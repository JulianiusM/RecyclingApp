import 'package:flutter/material.dart';
import 'package:recycling/recycling_data.dart';

class DataDetailView extends StatelessWidget {
  const DataDetailView({Key? key, required this.recData}) : super(key: key);
  final RecyclingData recData;

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
    return Card(
      child: Row(
        children: [Expanded( child: Image.asset(recData.imageUrl),flex:3),
          Expanded(child:Column(mainAxisAlignment:MainAxisAlignment.center,
          children: [Text(recData.title
          ,style:Theme.of(context).textTheme.headline3!.copyWith(color:Colors.black87)),
          Padding(
            padding: const EdgeInsets.all(15),
          child: Text("Goes into: ${recData.goesTo}",style:Theme.of(context).textTheme.headline6!.copyWith(color:Colors.black87))
          ),
          Padding(
          padding: const EdgeInsets.all(30),
          child: Text(recData.generalInformation,style:Theme.of(context).textTheme.bodyLarge!.copyWith(color:Colors.black87))
          )
      ]
        ),flex:6)
        ]

      )
        //image: Image(recData.imageUrl),
        //description: Text(recData.generalInformation),
        //bin: Bin(recData.goesTo),
        //examples: String(recData.examples),
        //TODO: Add declarative UI building here
        // see for further reference: https://docs.flutter.dev/development/ui/layout
        );
  }
}
