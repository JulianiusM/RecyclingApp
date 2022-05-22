import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recycling/data/district_data.dart';
import 'package:recycling/data/recycling_data.dart';
import 'package:recycling/extensions/string_format_extension.dart';
import 'package:recycling/logic/data_integration.dart';
import 'package:recycling/ui/data_detail_view.dart';

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

  List<RecyclingData>? searchData;
  bool isSearching = false;

  @override
  void initState() {
    widget._currentState[0] = this;
    super.initState();
  }

  void setDataState(List<RecyclingData> data) {
    dataList = data;
    dataIndex = DataIntegration.generateRuntimeIndex(data);
  }

  void setDistrictDataState(DistrictData data) {
    dataList = DataIntegration.mergeRecyclingDistrictData(
        dataList ?? [], data.entryList);
    districtData = data;
  }

  void performSearch(String input) {
    setState(() {
      isSearching = input.isNotEmpty;

      if (!isSearching || dataList == null || dataList!.isEmpty) return;

      dataIndex ??= DataIntegration.generateRuntimeIndex(dataList!);
      searchData = DataIntegration.performSearchOnIndex(dataIndex!, input);
    });
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
    List<RecyclingData> currentData;
    if (isSearching) {
      if (searchData != null && searchData!.isNotEmpty) {
        currentData = searchData!;
      } else {
        return Text(AppLocalizations.of(context)!.noResultsInfo);
      }
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
          return SizedBox(
            height: height,
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DataDetailView(
                    recData: currentData[index],
                    districtDataEntry: districtData!.entryList.firstWhere(
                        (element) => element.dataTitles
                            .contains(currentData[index].title)),
                  ),
                ),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Image.asset(
                      currentData[index].imageUrl,
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
                            currentData[index].title,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            currentData[index].goesTo,
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
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemCount: currentData.length,
      ),
    );
  }
}
