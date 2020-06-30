import 'package:flutter/material.dart';
import 'package:how_about_app/model/db.dart';
import 'package:how_about_app/model/model.dart';
import '../constants.dart';

class HowAboutOption extends StatefulWidget {
  final String catalog;

  HowAboutOption({this.catalog,});

  @override
  _HowAboutOptionState createState() => _HowAboutOptionState();
}

class _HowAboutOptionState extends State<HowAboutOption> {
  bool fade = true;
  String option = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: kTealLightColor,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 200),
                    crossFadeState: fade
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    firstChild: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    secondChild: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        _showAddDialog();
                      },
                    ),
                  ),
                  Text(widget.catalog,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        //fontStyle: FontStyle.italic,
                        fontSize: 20.0,
                      )),
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 200),
                    crossFadeState: fade
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    firstChild: FlatButton(
                      child: Text('편집'),
                      shape: CircleBorder(
                          side: BorderSide(color: Colors.transparent)),
                      onPressed: () {
                        setState(() {
                          fade = false;
                        });
                      },
                    ),
                    secondChild: FlatButton(
                      child: Text('완료'),
                      shape: CircleBorder(
                          side: BorderSide(color: Colors.transparent)),
                      onPressed: () {
                        setState(() {
                          fade = true;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Expanded(
                child: FutureBuilder(
                  future: DB().getOption(widget.catalog),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Category>> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            Category item = snapshot.data[index];
                            return Center(
                                child: Padding(
                                  padding:
                                  const EdgeInsets.only(right: 10, left: 10),
                                  child: AnimatedCrossFade(
                                    duration: const Duration(milliseconds: 200),
                                    crossFadeState: fade
                                        ? CrossFadeState.showFirst
                                        : CrossFadeState.showSecond,
                                    firstChild: Card(
                                      margin: const EdgeInsets.only(
                                          right: 30, left: 30, top: 5, bottom: 5),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          ListTile(
                                            title: Text(item.option,
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 20.0,
                                                    color: Colors.black)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    secondChild: Card(
                                      margin: const EdgeInsets.only(
                                          right: 30, left: 30, top: 5, bottom: 5),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          ListTile(
                                            title: Text(item.option,
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 20.0,
                                                    color: Colors.black)),
                                            leading: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  DB().deleteOption(item.id);
                                                });
                                              },
                                              child: Icon(
                                                Icons.remove_circle,
                                                color: Colors.red,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ));
                          });
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showAddDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('옵션 추가'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  onChanged: (String text) {
                    this.option = text;
                  },
                  obscureText: false,
                  decoration: InputDecoration(
                    //border: OutlineInputBorder(),
                    hintText: '옵션',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('취소'),
              textColor: kTealColor,
              onPressed: () {
                setState(() {
                  Navigator.pop(context);
                });
              },
            ),
            FlatButton(
              child: Text('추가'),
              textColor: kTealColor,
              onPressed: () {
                setState(() {
                  if (this.option != "") {
                    saveDB();
                    Navigator.pop(context);
                  }
                });
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> saveDB() async {
    DB sd = DB();
    var cate = Category(
      option: this.option,
      catalog: widget.catalog,
    );
    await sd.createCategory(cate);
    await sd.category();
  }

}
