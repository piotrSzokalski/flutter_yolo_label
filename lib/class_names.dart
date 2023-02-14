import 'package:flutter/material.dart';

class ClassNamesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ClassNamesPage();
}

class _ClassNamesPage extends State {
  final List<String> categoties = ['A'];

  final TextEditingController newCategoryController = TextEditingController();

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
                      categoties.add(newCategoryController.text);
                    });
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.add))
            ],
          ));

  @override
  Widget build(BuildContext context) => Scaffold(
        body: ListView.separated(
            itemCount: categoties.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(categoties[index]),
                onTap: () {},
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
                onPressed: () {}, child: Icon(Icons.arrow_back)),
          ],
        ),
      );
}
