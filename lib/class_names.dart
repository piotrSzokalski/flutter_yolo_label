import 'package:flutter/material.dart';

import 'global_state.dart';

class ClassNamesPage extends StatefulWidget {
  VoidCallback cancel;
  ClassNamesPage(this.cancel);
  @override
  State<StatefulWidget> createState() => _ClassNamesPage(cancel);
}

class _ClassNamesPage extends State {
  //inal List<String> categoties = ['A'];

  final TextEditingController newCategoryController = TextEditingController();

  VoidCallback cancel;

  _ClassNamesPage(this.cancel);

  Future openAddCategoryDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text('dodaj nowa kategori'),
            content: TextField(
              controller: newCategoryController,
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      GlobalState.addClassName(newCategoryController.text);
                    });
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.add))
            ],
          ));

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('wybierz kategorie'),
        ),
        body: ListView.separated(
            itemCount: GlobalState.getClassNames().length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(GlobalState.getClassNames()[index]),
                onTap: () {
                  print('tap $index');
                  GlobalState.addRecord(index);
                  Navigator.pop(context);
                },
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(color: Colors.black)),
        floatingActionButton: Row(
          children: [
            FloatingActionButton(
                onPressed: () {
                  openAddCategoryDialog();
                },
                child: Icon(Icons.add)),
            FloatingActionButton(
                onPressed: () => {cancel(), Navigator.pop(context)},
                child: Icon(Icons.cancel)),
          ],
        ),
      );
}
