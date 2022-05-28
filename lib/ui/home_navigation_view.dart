import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recycling/ui/data_overview.dart';
import 'package:recycling/ui/district_data_overview.dart';
import 'package:recycling/ui/district_overview.dart';
import 'package:recycling/ui/location_overview.dart';

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
  late final List _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      DataOverview(selectedDistrict: widget.selectedDistrict),
      DistrictDataOverview(selectedDistrict: widget.selectedDistrict),
      LocationOverview(selectedDistrict: widget.selectedDistrict)
    ];
  }

  void _updateIndex(int value) {
    setState(() {
      _currentIdx = value;
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
        onTap: _updateIndex,
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
