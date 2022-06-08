import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recycling/data/data_config_values.dart';
import 'package:recycling/ui/data_overview.dart';
import 'package:recycling/ui/district_data_overview.dart';
import 'package:recycling/ui/district_overview.dart';
import 'package:recycling/ui/location_overview.dart';
import 'package:recycling/ui/privacy_popup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeNavigationView extends StatefulWidget {
  const HomeNavigationView(
      {Key? key, required this.title, required this.selectedDistrict})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final String selectedDistrict;

  @override
  State<HomeNavigationView> createState() => _HomeNavigationViewState();
}

class _HomeNavigationViewState extends State<HomeNavigationView> {
  int _currentIdx = 0;
  bool _privacyAgreed = false;

  late final List _screens;
  final List<int> _privacyRequiredScreens = [2];

  @override
  void initState() {
    super.initState();
    _screens = [
      DataOverview(selectedDistrict: widget.selectedDistrict),
      DistrictDataOverview(selectedDistrict: widget.selectedDistrict),
      LocationOverview(selectedDistrict: widget.selectedDistrict)
    ];

    SharedPreferences.getInstance().then(
      (SharedPreferences prefs) {
        if (prefs.containsKey(SharedPreferenceKeys.privacyAgree.name)) {
          _privacyAgreed =
              prefs.getBool(SharedPreferenceKeys.privacyAgree.name) ?? false;
        } else {
          showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              return PrivacyPopup(
                onAgree: () async {
                  await PrivacyPopup.defaultOnAgree();
                  _privacyAgreed = true;
                },
              );
            },
          );
        }
      },
    );
  }

  void _updateIndex(BuildContext context, int value) {
    setState(() {
      if (!_privacyAgreed && _privacyRequiredScreens.contains(value)) {
        showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return PrivacyPopup(
              onAgree: () async {
                await PrivacyPopup.defaultOnAgree();
                _privacyAgreed = true;
                _updateIndex(dialogContext, value);
              },
            );
          },
        );
      } else {
        _currentIdx = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        automaticallyImplyLeading: false,
        bottom: _buildAppbarBottom(context),
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry>[
                PopupMenuItem(
                  value: 0,
                  child: Row(
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: Icon(Icons.location_city, color: Colors.black54),
                      ),
                      Text(AppLocalizations.of(context)!.selectDistrict),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 1,
                  child: Row(
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: Icon(Icons.admin_panel_settings_outlined,
                            color: Colors.black54),
                      ),
                      Text(AppLocalizations.of(context)!.privacySettings),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Row(
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: Icon(Icons.privacy_tip_outlined,
                            color: Colors.black54),
                      ),
                      Text(AppLocalizations.of(context)!.privacyPolicy),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 3,
                  child: Row(
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: Icon(Icons.info_outline, color: Colors.black54),
                      ),
                      Text(AppLocalizations.of(context)!.imprint),
                    ],
                  ),
                ),
              ];
            },
            onSelected: (selected) {
              switch (selected) {
                case 0:
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const DistrictOverview(),
                    ),
                  );
                  break;
                case 1:
                  PrivacyPopup.show(
                    context: context,
                    onAgree: () async {
                      await PrivacyPopup.defaultOnAgree();
                      _privacyAgreed = true;
                    },
                    onDisagree: () async {
                      await PrivacyPopup.defaultOnDisagree();
                      _privacyAgreed = false;
                    },
                  );
                  break;
                case 2:
                  launchUrl(Uri.parse(
                      AppLocalizations.of(context)!.privacyPolicyUrl));
                  break;
                case 3:
                  launchUrl(
                      Uri.parse(AppLocalizations.of(context)!.imprintUrl));
                  break;
                default:
                  break;
              }
            },
          ),
        ],
      ),
      body: _screens[_currentIdx],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIdx,
        onTap: (int value) {
          _updateIndex(context, value);
        },
        items: [
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.searchNavName,
            icon: const Icon(Icons.search),
          ),
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.districtNavName,
            icon: const Icon(Icons.location_city),
          ),
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.locationNavName,
            icon: const Icon(Icons.map),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget? _buildAppbarBottom(BuildContext context) {
    switch (_currentIdx) {
      case 0:
        return AppBar(
          automaticallyImplyLeading: false,
          title: Container(
            width: double.infinity,
            height: 40,
            color: Colors.white,
            child: Center(
              child: TextField(
                decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.searchWasteBarHint,
                    prefixIcon: const Icon(Icons.search)),
                onChanged: (input) =>
                    (_screens[0] as DataOverview).searchCallback(input),
              ),
            ),
          ),
        );
      default:
        return null;
    }
  }
}
