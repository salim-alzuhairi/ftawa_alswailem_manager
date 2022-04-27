import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class getFirebase {
  static final _fireStore = FirebaseFirestore.instance.collection('main');
  final List<List> _data = [];

  Future<List<List>> getFiredoc(
      {search =
          'https://firebasestorage.googleapis.com/v0/b/ftawa-84eef.appspot.com/o/1x1%20pexle%20%D8%B4%D9%81%D8%A7%D9%81.png?alt=media&token=3359c3da-1ac8-405b-bbea-9d304651b6a3'}) async {
    var _col = await _fireStore.get();

    for (var q in _col.docs) {
      List _subdata = [];

      if (q.get('question').toString().contains(search) ||
          q.get('answer').toString().contains(search)) {
        _subdata.addAll([
          q.get('id'),
          q.get('question'),
          q.get('answer'),
          if (q.get('qImage') != '') q.get('qImage'),
          if (q.get('aImage') != '') q.get('aImage'),
        ]);
      }
      if (_subdata.isNotEmpty) _data.add(_subdata);
    }

    if (_data.isNotEmpty) {
      _data.sort((b, a) {
        return int.parse(a[0].toString()).compareTo(int.parse(b[0].toString()));
      });
    }
    return _data;
  }

  Future<int> getLength() async {
    var s = await _fireStore.get();
    return s.size;
  }

  add(String mainORbackup, String question, String answer,
      {Uint8List? qImage, Uint8List? aImage}) async {
    final _query = FirebaseFirestore.instance.collection(mainORbackup);

    var d = DateTime.now();
    var q = await FirebaseFirestore.instance.collection('backup').get();
    int id = 0;

    for (var element in q.docs) {
      var r = element.get('id');
      if (r > id) id = r;
    }
    id++;

    String name =
        '${d.year}-${d.month}-${d.day}-${d.hour}:${d.month}:${d.second}';

    Reference qRef =
        FirebaseStorage.instance.ref('$mainORbackup/q-$id-' + name);
    Reference aRef =
        FirebaseStorage.instance.ref('$mainORbackup/a-$id-' + name);

    String qLink = '';
    String aLink = '';

    if (qImage != null) {
      await qRef.putData(qImage);
      qLink = qRef.name;
    }
    if (aImage != null) {
      await aRef.putData(aImage);
      aLink = aRef.name;
    }

    _query.doc(name).set({
      'id': id,
      'question': question,
      'answer': answer,
      'qImage': qLink,
      'aImage': aLink
    });
  }

  Future<Uint8List?> getImage(String name) async {
    return await FirebaseStorage.instance.ref('main/$name').getData();
  }

  update(List oldData, List newData) async {
    final r = await _fireStore.where('id', isEqualTo: oldData[0]).get();

    String qLink = '';
    String aLink = '';

    for (var i = 0; i >= 1; i++) {
      for (var j = 0; j >= 1; j++) {
        var mainORbackup;
        var qORaImage;
        var img;

        i == 0 ? mainORbackup = 'main' : 'backup';
        j == 0 ? qORaImage = 'qImage' : 'aImage';
        r.docs.forEach((element) {
          img = element.get(qORaImage);
        });

        final qf = FirebaseStorage.instance.ref('$mainORbackup/$img');

        var c = qORaImage == 'qImage' ? 4 : 5;
        if (oldData.length >= c) {
          await qf.delete();
        }
        if (newData.length >= c) {
          await qf.putData(newData[c - 1]);
          qLink = qf.name;
        }
      }
    }

    r.docs.forEach((element) {
      element.data().updateAll((key, value) => {
            'question': newData[1],
            'answer': newData[2],
            'qImage': qLink,
            'aImage': aLink
          });
    });
  }

  delete() {}
}
