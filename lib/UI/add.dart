import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:ftawa_alswailem_manager/UI/CropImage.dart';
import 'package:ftawa_alswailem_manager/code/getFirebase.dart';
import 'package:image_picker/image_picker.dart';

class add extends StatefulWidget {
  List? data;

  add({Key? key, this.data}) : super(key: key);

  @override
  State<add> createState() => _AddState(data);
}

class _AddState extends State<add> {
  Uint8List? _qImage;
  Uint8List? _aImage;
  bool enter = true;

  // data [id, question, answer, qImage, aImage]
  final List? _data;

  _AddState(this._data);

  selectImage(bool ques) async {
    final i = await ImagePicker().pickImage(source: ImageSource.gallery);

    Uint8List? r;
    if (i != null) {
      r = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => CropImage(i.path)));
    }

    setState(() {
      ques ? _qImage = r : _aImage = r;
    });
  }

  TextEditingController question = TextEditingController(),
      answer = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    question.dispose();
    answer.dispose();
  }

  getImage() async {
    if (_data != null && enter) {
      Uint8List? q;
      Uint8List? a;

      question.text = _data![1];
      answer.text = _data![2];

      if (_data!.length >= 4) q = await getFirebase().getImage(_data![3]);
      if (_data!.length >= 5) a = await getFirebase().getImage(_data![4]);

      setState(() {
        _qImage = q;
        _aImage = a;
      });
      enter = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    toAdd() {
      getFirebase().add('main', question.text, answer.text,
          qImage: _qImage, aImage: _aImage);
      getFirebase().add('backup', question.text, answer.text,
          qImage: _qImage, aImage: _aImage);
    }

    getImage();

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          titleTextStyle:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          title: Text(_data == null ? 'إضافة فتوى' : 'تعديل الفتوى'),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.settings_outlined),
            ),
          ],
        ),
        backgroundColor: Colors.deepPurpleAccent,
        body: Padding(
          padding: const EdgeInsets.all(5),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  shape: const BeveledRectangleBorder(
                      borderRadius:
                          BorderRadius.all(Radius.elliptical(15, 15))),
                  child: Column(
                    children: [
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextField(
                          controller: question,
                          autofocus: true,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                              filled: true,
                              label: Text('السؤال:',
                                  textDirection: TextDirection.rtl),
                              alignLabelWithHint: true,
                              labelStyle: TextStyle(fontSize: 20)),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          selectImage(true);
                        },
                        iconSize: 100,
                        icon: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: _qImage != null
                                ? Image.memory(_qImage!).image
                                : const NetworkImage(
                                    'https://firebasestorage.googleapis.com/v0/b/ftawa-84eef.appspot.com/o/Add_Image_icon-icons.com_54218.png?alt=media&token=587788b1-1f50-4f7a-be02-867ed863bcbc'),
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  shape: const BeveledRectangleBorder(
                      borderRadius:
                          BorderRadius.all(Radius.elliptical(15, 15))),
                  child: Column(
                    children: [
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextField(
                          controller: answer,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                              filled: true,
                              label: Text('الجواب:',
                                  textDirection: TextDirection.rtl),
                              alignLabelWithHint: true,
                              labelStyle: TextStyle(fontSize: 20)),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          selectImage(false);
                        },
                        iconSize: 100,
                        icon: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: _aImage != null
                                ? Image.memory(_aImage!).image
                                : const NetworkImage(
                                    'https://firebasestorage.googleapis.com/v0/b/ftawa-84eef.appspot.com/o/Add_Image_icon-icons.com_54218.png?alt=media&token=587788b1-1f50-4f7a-be02-867ed863bcbc'),
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FloatingActionButton.extended(
                          extendedPadding: const EdgeInsets.all(15),
                          label: Text(
                            _data == null ? 'نشر' : 'تعديل',
                          ),
                          icon: Icon(_data == null
                              ? Icons.upload_outlined
                              : Icons.edit_outlined),
                          onPressed: () {
                            if (answer.text == '' || question.text == '') {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text(
                                  'لا يمكن ترك خانة السؤال أو الجواب فارغة',
                                  textDirection: TextDirection.rtl,
                                ),
                                behavior: SnackBarBehavior.floating,
                                shape: BeveledRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.elliptical(10, 10))),
                              ));
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text(
                                      'تأكيد',
                                      textDirection: TextDirection.rtl,
                                    ),
                                    content: Text(
                                      _data == null
                                          ? 'هل تريد نشر الفتوى؟'
                                          : 'هل تريد تعديل الفتوى؟',
                                      textDirection: TextDirection.rtl,
                                    ),
                                    actions: [
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            'لا',
                                            textDirection: TextDirection.rtl,
                                          )),
                                      ElevatedButton(
                                        child: const Text(
                                          'نعم',
                                          textDirection: TextDirection.rtl,
                                        ),
                                        onPressed: () {
                                          if (_data == null) {
                                            toAdd();
                                          } else {
                                            List _dataUpdate = [
                                              _data![0],
                                              question.text,
                                              answer.text,
                                              _qImage,
                                              _aImage
                                            ];
                                            getFirebase().update(_data!, _dataUpdate);
                                          }
                                          ScaffoldMessenger.of(this.context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                              _data == null
                                                  ? 'تم النشر'
                                                  : 'تم التعديل',
                                              textDirection: TextDirection.rtl,
                                            ),
                                            behavior: SnackBarBehavior.floating,
                                            shape: const BeveledRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.elliptical(10, 10))),
                                          ));
                                          Navigator.pop(context);
                                          Navigator.pop(this.context);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                        ),
                        if (_data != null)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                            child: FloatingActionButton.small(
                              onPressed: () {},
                              child: const Icon(Icons.delete_forever_outlined),
                            ),
                          ),
                      ]),
                ),
              ],
            ),
          ),
        ));
  }
}
