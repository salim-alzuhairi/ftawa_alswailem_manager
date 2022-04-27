import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ftawa_alswailem_manager/UI/MainUi1.dart';
import 'code/getFirebase.dart';

Future<void> main({search = ''}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  List<List> data = await getFirebase().getFiredoc(search: search);
  int listCount = data.length;

  await getFirebase().getLength().then((value) {
    listCount = value;
  });
  runApp(MainUi1(listCount, data));
}
