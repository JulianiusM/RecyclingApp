import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recycling/data/data_config_values.dart';
import 'package:recycling/data/district_data.dart';
import 'package:recycling/extensions/string_format_extension.dart';
import 'package:recycling/logic/data_integration.dart';
import 'package:recycling/ui/home_navigation_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DistrictOverview extends StatefulWidget {
  const DistrictOverview({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DistrictOverviewState();
}

class _DistrictOverviewState extends State<DistrictOverview> {
  List<DistrictData>? dataList;

  void setDataState(List<DistrictData> data) {
    dataList = data;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _addData method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(
            AppLocalizations.of(context)?.selectDistrict ?? 'Recycling App'),
      ),
      body: _buildBody(context),
    );
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
              setDataState(data.data!);
              return _buildListBody(context);
            }
            return Text(AppLocalizations.of(context)!.noDataInfo);
        }
      },
    );
  }

  Widget _buildListBody(BuildContext context) {
    List<DistrictData> currentData;
    if (dataList == null || dataList!.isEmpty) {
      return Text(AppLocalizations.of(context)!.noDataInfo);
    } else {
      currentData = dataList!;
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
        padding: const EdgeInsets.all(8),
        itemBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: height,
            child: InkWell(
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString(
                    SharedPreferenceKeys.selectedDistrict.name,
                    currentData[index].name);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeNavigationView(
                      title: AppLocalizations.of(context)!.appTitle,
                      selectedDistrict: currentData[index].name,
                    ),
                  ),
                );
              },
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
                            currentData[index].name,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            currentData[index].description,
                            style: const TextStyle(fontSize: 12),
                            overflow: TextOverflow.fade,
                          ),
                          // Text(
                          //   currentData[index].opens,
                          //   style: const TextStyle(fontSize: 12),
                          //   overflow: TextOverflow.fade,
                          // ),
                          // Text(
                          //   currentData[index].closes,
                          //   style: const TextStyle(fontSize: 12),
                          //   overflow: TextOverflow.fade,
                          // ),
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
