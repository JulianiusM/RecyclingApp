import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recycling/data/data_config_values.dart';
import 'package:recycling/data/district_data.dart';
import 'package:recycling/data/district_data_entry.dart';

class DistrictDataDetailView extends StatelessWidget {
  const DistrictDataDetailView(
      {Key? key, this.districtDataEntry, this.districtData})
      : super(key: key);
  final DistrictDataEntry? districtDataEntry;
  final DistrictData? districtData;

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
        title: Text(districtData?.name ?? districtDataEntry!.goesTo),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    int imgFlexWeight = 3;
    int descFlexWeight = 6;
    Axis flexDirection = Axis.horizontal;
    MainAxisAlignment descAlignment = MainAxisAlignment.center;

    if (MediaQuery.of(context).size.width <
        ConfigValues.responsiveBreakpointWidth) {
      flexDirection = Axis.vertical;
      descAlignment = MainAxisAlignment.start;
    }

    return Center(
      child: SizedBox(
        child: Flex(
          direction: flexDirection,
          children: [
            Expanded(
              child: Image.asset(
                  districtData?.imageUrl ?? districtDataEntry!.imageUrl),
              flex: imgFlexWeight,
            ),
            Expanded(
              flex: descFlexWeight,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: descAlignment,
                  children: [
                    Text(
                      districtData?.name ?? districtDataEntry!.goesTo,
                      style: Theme.of(context)
                          .textTheme
                          .headline3!
                          .copyWith(color: Colors.black87),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                      child: Text(
                        districtData?.description ??
                            districtDataEntry!.generalInformation,
                        style: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(color: Colors.black87),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                      child: _buildDescriptiveBody(context),
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

  Widget _buildDescriptiveBody(BuildContext context) {
    if (districtData != null) {
      return _buildDistrictBody(context);
    } else {
      return _buildTableBody(context);
    }
  }

  Widget _buildDistrictBody(BuildContext context) {
    return Text(
      districtData!.additionalInformation.join("\n"),
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(color: Colors.black87),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildTableBody(BuildContext context) {
    List<TableRow> rows = [];
    DistrictDataEntry data = districtDataEntry!;
    rows.add(
      TableRow(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            child: Center(
              child: Text(
                AppLocalizations.of(context)!.allowedExampleHeader,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            child: Center(
              child: Text(
                AppLocalizations.of(context)!.disallowedExampleHeader,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );

    for (int i = 0;
        i < max(data.allowedExamples.length, data.disallowedExamples.length);
        i++) {
      rows.add(
        TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              child: Center(
                child: Text(
                  i < data.allowedExamples.length
                      ? data.allowedExamples[i]
                      : "",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              child: Center(
                child: Text(
                  i < data.disallowedExamples.length
                      ? data.disallowedExamples[i]
                      : "",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Table(
      border: const TableBorder(
        top: BorderSide(),
        bottom: BorderSide(),
        left: BorderSide(),
        right: BorderSide(),
        verticalInside: BorderSide(),
        horizontalInside: BorderSide(color: Colors.black26),
      ),
      children: rows,
    );
  }
}
