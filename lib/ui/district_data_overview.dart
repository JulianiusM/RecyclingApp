import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recycling/data/district_data.dart';
import 'package:recycling/data/district_data_entry.dart';
import 'package:recycling/extensions/string_format_extension.dart';
import 'package:recycling/logic/data_integration.dart';
import 'package:recycling/ui/district_data_detail_view.dart';

class DistrictDataOverview extends StatefulWidget {
  const DistrictDataOverview({Key? key, required this.selectedDistrict})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final String selectedDistrict;

  @override
  State<DistrictDataOverview> createState() => _DistrictDataOverviewState();
}

class _DistrictDataOverviewState extends State<DistrictDataOverview> {
  DistrictData? districtData;

  void setDataState(DistrictData data) {
    districtData = data;
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
      currentChild = _buildListBody(context);
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
              try {
                setDataState(data.data!.firstWhere(
                    (element) => element.name == widget.selectedDistrict));
                return _buildListBody(context);
              } on StateError {
                // Trapdoor --> No data text
              }
            }
            return Text(AppLocalizations.of(context)!.noDataInfo);
        }
      },
    );
  }

  Widget _buildListBody(BuildContext context) {
    List<DistrictDataEntry> currentData;
    if (districtData == null || districtData!.entryList.isEmpty) {
      return Text(AppLocalizations.of(context)!.noDataInfo);
    } else {
      currentData = districtData!.entryList;
    }

    double height = MediaQuery.of(context).size.height * 0.1;

    if (height < 50) {
      height = 50;
    } else if (height > 100) {
      height = 100;
    }

    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemBuilder: (BuildContext context, int index) {
        if (districtData!.hasAdditionalInformation) {
          if (index == 0) {
            return _buildListEntry(context, height: height);
          }
          index--;
        }
        return _buildListEntry(context,
            height: height, districtDataEntry: currentData[index]);
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemCount:
          currentData.length + (districtData!.hasAdditionalInformation ? 1 : 0),
    );
  }

  Widget _buildListEntry(BuildContext context,
      {required double height, DistrictDataEntry? districtDataEntry}) {
    bool useDistData = false;
    if (districtDataEntry == null) {
      useDistData = true;
    }
    return SizedBox(
      height: height,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              if (useDistData) {
                return DistrictDataDetailView(districtData: districtData!);
              }
              return DistrictDataDetailView(
                  districtDataEntry: districtDataEntry!);
            },
          ),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Image.asset(
                useDistData
                    ? districtData!.imageUrl
                    : districtDataEntry!.imageUrl,
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      useDistData
                          ? districtData!.name
                          : districtDataEntry!.goesTo,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      useDistData
                          ? districtData!.description
                          : districtDataEntry!.generalInformation,
                      style: const TextStyle(fontSize: 12),
                      overflow: TextOverflow.fade,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
