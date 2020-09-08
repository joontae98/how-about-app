import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:how_about_app/models/db.dart';
import 'package:how_about_app/models/model.dart';
import '../constants.dart';

class HowAboutWrite extends StatefulWidget {
  @override
  _HowAboutWriteState createState() => _HowAboutWriteState();
}

class _HowAboutWriteState extends State<HowAboutWrite> {
  String catalog = '';
  String option = '';
  List<String> items = List<String>.generate(0, (index) {
    return "Item - $index";
  });

  final teController = TextEditingController(
    text: "",
  );

  @override
  void dispose() {
    teController.dispose();
    super.dispose();
  }

  ScrollController controller = new ScrollController();//ScrollController instance add

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        color: kTealLightColor,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("취소"),
                    shape: CircleBorder(
                        side: BorderSide(color: Colors.transparent)),
                  ),
                  Text(
                    '카테고리 추가',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      print(catalog);
                      setState(() {
                        for (int i = 0; i < items.length; i++) {
                          this.option = items[i];
                          saveDB();
                        }
                      });
                      Navigator.pop(context);
                    },
                    child: Text("저장"),
                    shape: CircleBorder(
                        side: BorderSide(color: Colors.transparent)),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  onChanged: (String catalog) {
                    this.catalog = catalog;
                  },
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(hintText: '카테고리 이름'),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: controller,// add controller
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Card(
                        child: ListTile(
                          title: Text(item),
                          trailing: IconButton(
                            icon: Icon(Icons.remove_circle),
                            color: Colors.red,
                            onPressed: () {
                              setState(() {
                                items.removeAt(index);
                              });
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Divider(
                color: Colors.grey,
                height: 5,
                indent: 10,
                endIndent: 10,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
                child: Row(
                  children: <Widget>[
                    Text("옵션 추가:"),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          controller: teController,
                          onSubmitted: (text) {
                            setState(() {
                              if (teController.text != "") {
                                items.add(teController.text);
                              }
                            });
                            teController.clear();
                          },
                        ),
                      ),
                    ),
                    RaisedButton(
                      child: Ink(
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(80.0)),
                            color: kTealColor),
                        child: Container(
                          constraints: const BoxConstraints(
                              minWidth: 88.0, minHeight: 36.0),
                          // min sizes for Material buttons
                          alignment: Alignment.center,
                          child: const Text(
                            '추가',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      padding: const EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80)),
                      onPressed: () {
                        setState(() {
                          if (teController.text != "") {
                            items.add(teController.text);
                          }
                          controller.jumpTo(controller.position.maxScrollExtent);// move to focus for last list
                        });
                        teController.clear();
                        print(items);
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveDB() async {
    DB sd = DB();
    var cate = Category(
      option: this.option,
      catalog: this.catalog,
    );
    await sd.createCategory(cate);
    await sd.category();
  }
}
