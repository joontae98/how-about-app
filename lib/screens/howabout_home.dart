import 'package:dart_random_choice/dart_random_choice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:how_about_app/models/db.dart';
import 'package:how_about_app/models/model.dart';
import 'package:how_about_app/widgets/scaleroute.dart';
import '../constants.dart';
import 'howabout_option.dart';
import 'howabout_result.dart';
import 'howabout_write.dart';

class HowAboutHome extends StatefulWidget {
  @override
  _HowAboutHomeState createState() => _HowAboutHomeState();
}

class _HowAboutHomeState extends State<HowAboutHome> {
  List<String> selectList = [];
  String selectString = "\'";
  String catalog;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: size.height * .38,
            decoration: BoxDecoration(
              color: kTealLightColor,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        '이건어때?',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                      Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => HowAboutWrite()));
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: size.height * .05,
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        child: chipView(),
                        height: size.height * .05,
                        width: size.width * .9,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * .05,
                  ),
                  Expanded(
                    child: gridView(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
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
                              '결과보기',
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
                        onPressed: () async {
                          this.selectString += selectList.reduce(
                              (value, element) => value + '\',\'' + element);
                          this.selectString += "\'";
                          print(selectString);
                          var rand = randomChoice(
                              await DB().randomOption(selectString));
                          print(rand.catalog + ' ' + rand.option);
                          this.selectString = "\'";
                          Navigator.push(
                              context,
                              ScaleRoute(
                                  page: HowAboutResult(
                                catalog: rand.catalog,
                                option: rand.option,
                              )));
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget gridView() {
    return FutureBuilder(
      future: DB().getAllCatalog(),
      builder: (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
        if (snapshot.hasData) {
          return GridView.builder(
              padding: const EdgeInsets.only(right: 10, left: 10, bottom: 10),
              itemCount: snapshot.data.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 5 / 2,
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemBuilder: (BuildContext context, int index) {
                Category item = snapshot.data[index];
                return Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(13),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 17),
                          blurRadius: 23,
                          spreadRadius: -13,
                          color: kShadowColor,
                        ),
                      ]),
                  child: InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          height: 42,
                          width: 43,
                          decoration: BoxDecoration(
                            color: kTealColor,
                            shape: BoxShape.circle,
                          ),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                if (this.selectList.isEmpty) {
                                  this.selectList.add(item.catalog);
                                }
                                for (int i = 0; i < this.selectList.length; i++) {
                                  if (this.selectList[i] == item.catalog) {
                                    break;
                                  } else if (i == selectList.length-1) {
                                    this.selectList.add(item.catalog);
                                  }
                                }
                                print(this.selectList);
                              });
                            },
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          child: Text(
                            item.catalog,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                          child: PopupMenuButton<String>(
                            padding: const EdgeInsets.all(0),
                            icon: Icon(Icons.more_vert),
                            onSelected: choiceAction,
                            itemBuilder: (BuildContext context) {
                              this.catalog = item.catalog;
                              return IconOption.choices.map((String choice) {
                                return PopupMenuItem<String>(
                                  value: choice,
                                  child: Text(choice),
                                );
                              }).toList();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget chipView() {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: this.selectList.length,
        itemBuilder: (BuildContext context, int index) {
          String item = this.selectList[index];
          return Container(
            padding: const EdgeInsets.all(3),
            child: Chip(
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                color: Colors.black,
              ),
              deleteIcon: Icon(Icons.close),
              label: Text(item),
              onDeleted: () {
                setState(() {
                  this.selectList.removeAt(index);
                  print("delete");
                });
              },
            ),
          );
        });
  }

  void choiceAction(String choice) {
    if (choice == IconOption.Edit) {
      Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => HowAboutOption(
                    catalog: this.catalog,
                  )));
    } else if (choice == IconOption.Delete) {
      _showDeleteDialog();
    }
  }

  Future<void> _showDeleteDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('카테고리를 삭제 하시겠습니까?',
              style: TextStyle(fontWeight: FontWeight.w600)),
          content: SingleChildScrollView(
            child: Text('해당 카테고리와 모든 옵션들이 삭제 됩니다.',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w100)),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('취소', style: TextStyle(color: kTealColor)),
              onPressed: () {
                setState(() {
                  Navigator.pop(context);
                });
              },
            ),
            FlatButton(
              child: Text(
                '삭제',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                await DB().deleteCatalog(this.catalog);
                for (int i = 0; i < this.selectList.length; i++) {
                  if (this.selectList[i] == this.catalog) {
                    this.selectList.removeAt(i);
                  }
                }
                setState(() {
                  Navigator.pop(context);
                });
              },
            ),
          ],
        );
      },
    );
  }
}
