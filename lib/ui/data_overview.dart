import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recycling/data/district_data.dart';
import 'package:recycling/data/district_data_entry.dart';
import 'package:recycling/data/recycling_data.dart';
import 'package:recycling/extensions/string_format_extension.dart';
import 'package:recycling/logic/data_integration.dart';
import 'package:recycling/ui/data_detail_view.dart';
import 'package:recycling/ui/district_data_detail_view.dart';

import '../data/data_access_interface.dart';

class DataOverview extends StatefulWidget {
  DataOverview({Key? key, required this.selectedDistrict}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final String selectedDistrict;
  final List<_DataOverviewState?> _currentState = [null];

  @override
  State<DataOverview> createState() => _DataOverviewState();

  void searchCallback(String input) {
    _currentState[0]?.performSearch(input);
  }
}

class _DataOverviewState extends State<DataOverview> {
  DistrictData? districtData;
  List<RecyclingData>? dataList;
  Map<String, List<RecyclingData>>? dataIndex;
  Map<String, List<DistrictDataEntry>>? extendedSearchIndex;

  List<DataAccessInterface>? searchData;
  bool isSearching = false;
  bool useExtended = false;
  String lastSearchInput = "";

  @override
  void initState() {
    widget._currentState[0] = this;
    super.initState();
  }

  void setDataState(List<RecyclingData> data) {
    dataList = districtData == null
        ? data
        : DataIntegration.mergeRecyclingDistrictData(
            data, districtData!.entryList);
    dataIndex = DataIntegration.generateRuntimeIndex(data);
  }

  void setDistrictDataState(DistrictData data) {
    dataList = DataIntegration.mergeRecyclingDistrictData(
        dataList ?? [], data.entryList);
    districtData = data;
    dataIndex = DataIntegration.generateRuntimeIndex(dataList!);
    extendedSearchIndex = DataIntegration.generateRuntimeIndex(data.entryList);
  }

  void performSearch(String input) {
    setState(() {
      lastSearchInput = input;
      isSearching = input.isNotEmpty;

      if (!isSearching) {
        useExtended = false;
        return;
      }

      Map<String, List<DataAccessInterface>> index;
      if (useExtended) {
        if (districtData == null || districtData!.entryList.isEmpty) return;

        extendedSearchIndex ??=
            DataIntegration.generateRuntimeIndex(districtData!.entryList);
        index = extendedSearchIndex!;
      } else {
        if (dataList == null || dataList!.isEmpty) return;

        dataIndex ??= DataIntegration.generateRuntimeIndex(dataList!);
        index = dataIndex!;
      }

      searchData = DataIntegration.performSearchOnIndex(index, input);
    });
  }

  void switchSearch() {
    useExtended = !useExtended;
    performSearch(lastSearchInput);
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) {
    Widget currentChild;

    if (dataList == null) {
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
      future: DataIntegration.generateRecyclingData(
          AppLocalizations.of(context)!.dataPath,
          context: context),
      builder: (BuildContext context, AsyncSnapshot<List<RecyclingData>> data) {
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
              setDataState(data.data!);
              return _buildFutureDistrictBody(context);
            }
            return Text(AppLocalizations.of(context)!.noDataInfo);
        }
      },
    );
  }

  Widget _buildFutureDistrictBody(BuildContext context) {
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
                DistrictData currentData = data.data!.firstWhere(
                    (element) => element.name == widget.selectedDistrict);
                setDistrictDataState(currentData);
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
    List<DataAccessInterface> currentData;
    if (isSearching) {
      currentData = searchData ?? [];
    } else {
      if (dataList == null || dataList!.isEmpty) {
        return Text(AppLocalizations.of(context)!.noDataInfo);
      } else {
        currentData = dataList!;
      }
    }

    double height = MediaQuery.of(context).size.height * 0.1;

    if (height < 50) {
      height = 50;
    } else if (height > 100) {
      height = 100;
    }

    return Align(
      alignment: Alignment.topCenter,
      child: ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.all(8),
        itemBuilder: (BuildContext context, int index) {
          if (index == currentData.length) {
            return _buildListEntry(context: context, height: height);
          } else {
            return _buildListEntry(
                context: context, height: height, data: currentData[index]);
          }
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemCount: currentData.length + (isSearching ? 1 : 0),
      ),
    );
  }

  Widget _buildListEntry(
      {required BuildContext context,
      required double height,
      DataAccessInterface? data}) {
    bool switchRow = data == null;

    return SizedBox(
      height: height,
      child: InkWell(
        onTap: () {
          if (switchRow) {
            switchSearch();
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  if (data is RecyclingData) {
                    return DataDetailView(
                      recData: data,
                      districtDataEntry: districtData!.entryList.firstWhere(
                          (element) =>
                              element.dataTitles.contains(data.getId())),
                    );
                  } else if (data is DistrictDataEntry) {
                    return DistrictDataDetailView(
                      districtDataEntry: data,
                    );
                  }
                  throw UnsupportedError("Data entry $data is not supported");
                },
              ),
            );
          }
        },
        child: switchRow
            ? _buildSwitchListEntry(context)
            : _buildDataListEntry(data),
      ),
    );
  }

  Widget _buildDataListEntry(DataAccessInterface data) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Image.asset(
            data.getImagePath(),
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
                  data.getId(),
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(
                  data.getDescription(),
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.fade,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchListEntry(BuildContext context) {
    return Center(
      child: Text(
        useExtended
            ? AppLocalizations.of(context)!.switchToWasteSearch
            : AppLocalizations.of(context)!.switchToDistrictSearch,
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      ),
    );
  }
}
