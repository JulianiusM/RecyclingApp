import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recycling/data/data_config_values.dart';
import 'package:recycling/extensions/string_format_extension.dart';
import 'package:recycling/ui/district_overview.dart';
import 'package:recycling/ui/home_navigation_view.dart';
import 'package:recycling/ui/privacy_popup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatefulWidget {
  const App({Key? key, this.home}) : super(key: key);

  final DefaultAssetBundle? home;

  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  bool hasShownPrivacyPopup = false;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recycling App',
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primaryColor: const Color(0xFF43b17c),
          colorScheme: const ColorScheme.light()
              .copyWith(primary: const Color(0xFF43b17c))),
      home: widget.home ?? _buildRoot(context),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      localeListResolutionCallback: (deviceLocales, supportedLocales) {
        if (deviceLocales != null) {
          for (final locale in deviceLocales) {
            if (supportedLocales.contains(locale)) {
              return locale;
            }
          }
        }
        return const Locale("en");
      },
    );
  }

  Widget _buildRoot(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (BuildContext context, AsyncSnapshot<SharedPreferences> data) {
        switch (data.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const CircularProgressIndicator.adaptive();
          default:
            if (data.hasError) {
              return Text(AppLocalizations.of(context)!
                  .errorWhileReadingDataPlaceholder
                  .format([data.error.toString()]));
            } else {
              if (data.data?.getBool(SharedPreferenceKeys.privacyAgree.name) ==
                      null &&
                  !hasShownPrivacyPopup) {
                hasShownPrivacyPopup = true;
                Future.delayed(
                  Duration.zero,
                  () => PrivacyPopup.show(
                    context: context,
                  ),
                );
              }

              String? prefData = data.data
                  ?.getString(SharedPreferenceKeys.selectedDistrict.name);
              if (prefData != null && prefData.isNotEmpty) {
                return HomeNavigationView(
                  title:
                      AppLocalizations.of(context)?.appTitle ?? 'Recycling App',
                  selectedDistrict: data.data!
                      .getString(SharedPreferenceKeys.selectedDistrict.name)!,
                );
              } else {
                return const DistrictOverview();
              }
            }
        }
      },
    );
  }
}
