import 'package:flutter/material.dart';
import 'package:recycling/data_detail_view.dart';
import 'package:recycling/data_integration.dart';
import 'package:recycling/recycling_data.dart';

class DataOverview extends StatefulWidget {
  const DataOverview({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<DataOverview> createState() => _DataOverviewState();
}

class _DataOverviewState extends State<DataOverview> {
  Map<String, RecyclingData>? dataMap;

  void setDataState(Map<String, RecyclingData> data) {
    dataMap = data;
  }

  void _performSearch(String input) {
    //TODO: implement search
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
        title: Text(widget.title),
        bottom: AppBar(
          title: Container(
            width: double.infinity,
            height: 40,
            color: Colors.white,
            child: Center(
              child: TextField(
                decoration: const InputDecoration(
                    hintText: 'Search waste', prefixIcon: Icon(Icons.search)),
                onChanged: (input) => _performSearch(input),
              ),
            ),
          ),
        ),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    Widget currentChild;

    if (dataMap == null) {
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
      future: DataIntegration.generateRecyclingData("res/json/data.json",
          context: context),
      builder: (BuildContext context,
          AsyncSnapshot<Map<String, RecyclingData>> data) {
        if (data.hasError) {
          return Text(
              "An error occurred while reading the data: ${data.error}");
        } else if (data.hasData) {
          setDataState(data.data!);
          return _buildListBody(context);
        }
        return const Text("No Data!");
      },
    );
  }

  Widget _buildListBody(BuildContext context) {
    List<RecyclingData> dataList = dataMap!.values.toList();

    double height = MediaQuery.of(context).size.height * 0.1;
    if (height < 50) {
      height = 50;
    } else if (height > 100) {
      height = 100;
    }

    return ListView.separated(
        padding: const EdgeInsets.all(8),
        itemBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: height,
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      DataDetailView(recData: dataList[index]),
                ),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Image.asset(
                      dataList[index].imageUrl,
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
                            dataList[index].title,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            dataList[index].goesTo,
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
        itemCount: dataMap!.length);
  }
}
