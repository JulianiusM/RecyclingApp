import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:recycling/data/district_data.dart';
import 'package:recycling/data/location_data.dart';
import 'package:recycling/data/location_data_types.dart';
import 'package:recycling/extensions/string_format_extension.dart';
import 'package:recycling/logic/data_integration.dart';

class LocationOverview extends StatefulWidget {
  const LocationOverview({Key? key, required this.selectedDistrict})
      : super(key: key);

  final String selectedDistrict;

  @override
  State<StatefulWidget> createState() => _LocationOverviewState();
}

class _LocationOverviewState extends State<LocationOverview> {
  DistrictData? districtData;
  Map<String, Marker> markers = {};

  void setDataState(DistrictData data) {
    districtData = data;
  }

  void _onMapCreated(
      GoogleMapController controller, List<LocationData> currentData) {
    setState(() {
      markers.clear();
      for (LocationData data in currentData) {
        String markerId = "${data.type}-${data.name}-${data.lat}-${data.long}";
        Marker marker = Marker(
          markerId: MarkerId(markerId),
          position: LatLng(data.lat, data.long),
          infoWindow: InfoWindow(title: data.name, snippet: data.description),
          icon: _selectDescriptor(data.type),
        );
        markers[markerId] = marker;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) {
    Widget currentChild;

    if (districtData == null) {
      currentChild = _buildFutureBody(context);
    } else {
      currentChild = _buildMapBody(context);
    }

    return Center(
      child: currentChild,
    );
  }

  Widget _buildFutureBody(BuildContext context) {
    return FutureBuilder(
      future: DataIntegration.generateDistrictData(
          AppLocalizations.of(context)!.districtDataPath,
          context: context),
      builder: (BuildContext context, AsyncSnapshot<List<DistrictData>> data) {
        switch (data.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const CircularProgressIndicator.adaptive();
          default:
            if (data.hasError) {
              return Text(AppLocalizations.of(context)!
                  .errorWhileReadingDataPlaceholder
                  .format([data.error.toString()]));
            } else if (data.hasData) {
              setDataState(data.data!.firstWhere(
                  (element) => element.name == widget.selectedDistrict));
              return _buildMapBody(context);
            }
            return Text(AppLocalizations.of(context)!.noDataInfo);
        }
      },
    );
  }

  Widget _buildMapBody(BuildContext context) {
    List<LocationData> currentData;
    if (districtData == null || districtData!.locationList.isEmpty) {
      return Text(AppLocalizations.of(context)!.noDataInfo);
    } else {
      currentData = districtData!.locationList;
    }

    return GoogleMap(
      onMapCreated: (GoogleMapController controller) =>
          _onMapCreated(controller, currentData),
      initialCameraPosition: CameraPosition(
        target: LatLng(districtData!.lat, districtData!.long),
        zoom: 13,
      ),
      markers: markers.values.toSet(),
    );
  }

  BitmapDescriptor _selectDescriptor(LocationDataType type) {
    switch (type) {
      case LocationDataType.recyclingCenter:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      case LocationDataType.bioContainer:
        return BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueViolet);
      case LocationDataType.glassContainer:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan);
      case LocationDataType.greenWaste:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      case LocationDataType.oldClothesContainer:
        return BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueYellow);
    }
  }
}
