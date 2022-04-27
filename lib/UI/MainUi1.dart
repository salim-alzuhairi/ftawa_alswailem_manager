import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ftawa_alswailem_manager/UI/add.dart';
import 'package:ftawa_alswailem_manager/main.dart';
import 'ListItem.dart';

class MainUi1 extends StatefulWidget {
  List<List> data;
  int listCount = 0;

  // data [id, question, answer, qImage, aImage]
  MainUi1(this.listCount, this.data, {Key? key}) : super(key: key);

  @override
  _MainUi1State createState() => _MainUi1State();
}

class _MainUi1State extends State<MainUi1> {
  bool isSearch = false;
  String search = '';

  final ScrollController _scrollController = ScrollController();
  bool _show = true;

  @override
  void initState() {
    super.initState();
    handleScroll();
  }

  @override
  void dispose() {
    _scrollController.removeListener(() {});
    super.dispose();
  }

  void showFloationButton() {
    setState(() {
      _show = true;
    });
  }

  void hideFloationButton() {
    setState(() {
      _show = false;
    });
  }

  void handleScroll() async {
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        hideFloationButton();
      }
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        showFloationButton();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<List> data = widget.data;
    return MaterialApp(
      title: 'فتاوى الشيخ عبد الرحمن السويلم',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: MaterialApp(
        locale: const Locale('ar', 'SA'),
        home: Scaffold(
            backgroundColor: Colors.teal.shade400,
            floatingActionButton: Visibility(
                visible: _show,
                child: Builder(builder: (context) {
                  return FloatingActionButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => add()));
                    },
                    child: const Icon(Icons.add),
                    elevation: 5,
                    backgroundColor: Colors.deepOrangeAccent,
                    shape: const BeveledRectangleBorder(
                        borderRadius:
                            BorderRadius.all(Radius.elliptical(10, 10))),
                  );
                })),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            appBar: AppBar(
              title: !isSearch
                  ? const Text('فتاوى الشيخ عبد الرحمن السويلم')
                  : Column(children: [
                      TextField(
                        textDirection: TextDirection.rtl,
                        cursorColor: Colors.amber,
                        decoration: const InputDecoration(
                            filled: true,
                            hintText: ' بحث',
                            hintTextDirection: TextDirection.rtl),
                        autofocus: true,
                        onChanged: (search) {
                          this.search = search;
                          main(search: search);
                        },
                      ),
                      const LinearProgressIndicator(),
                    ]),
              actions: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        isSearch = !isSearch;
                      });
                      if (!isSearch) main();
                    },
                    icon:
                        Icon(!isSearch ? Icons.search : Icons.cancel_outlined)),
                if (!isSearch)
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.settings_outlined),
                  ),
              ],
            ),
            body: RefreshIndicator(
              onRefresh: () => main(search: search),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: data.length,
                itemBuilder: (context, int index) {
                  return GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => add(data: data[index]))),
                    child: Card(
                      key: Key(data[index][0].toString()),
                      elevation: 10,
                      color: Colors.blue,
                      shape: const BeveledRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.elliptical(15, 15))),
                      child: ListItem(
                        data[index][1],
                        data[index][2],
                        qImage: data[index].length >= 4 ? data[index][3] : null,
                      ),
                      margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    ),
                  );
                },
              ),
            )),
      ),
    );
  }
}
