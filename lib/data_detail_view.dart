import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recycling/extensions/string_format_extension.dart';
import 'package:recycling/recycling_data.dart';

class DataDetailView extends StatelessWidget {
  const DataDetailView({Key? key, required this.recData}) : super(key: key);
  final RecyclingData recData;

  static const int _RESPONSIVE_BREAKPOINT_WIDTH = 700;

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
        title: Text(recData.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    int imgFlexWeight = 3;
    int descFlexWeight = 6;
    Axis flexDirection = Axis.horizontal;
    MainAxisAlignment descAlignment = MainAxisAlignment.center;

    if (MediaQuery.of(context).size.width < _RESPONSIVE_BREAKPOINT_WIDTH) {
      flexDirection = Axis.vertical;
      descAlignment = MainAxisAlignment.start;
    }

    return Center(
      child: SizedBox(
        child: Flex(
          direction: flexDirection,
          children: [
            Expanded(
              child: Image.asset(recData.imageUrl),
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
                      recData.title,
                      style: Theme.of(context)
                          .textTheme
                          .headline3!
                          .copyWith(color: Colors.black87),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                      child: Text(
                        AppLocalizations.of(context)!
                            .goesToBinDetailPlaceholder
                            .format([recData.goesTo]),
                        style: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(color: Colors.black87),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                      child: Text(
                        recData.generalInformation,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.black87),
                      ),
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
