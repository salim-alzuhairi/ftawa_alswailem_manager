import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:ftawa_alswailem_manager/code/getFirebase.dart';

class ListItem extends StatefulWidget {
  final String q;
  final String a;
  final String? qImage;

  const ListItem(this.q, this.a, {Key? key, this.qImage}) : super(key: key);

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              FutureBuilder<Uint8List?>(
                  future: widget.qImage != null
                      ? getFirebase().getImage(widget.qImage!)
                      : null,
                  builder: (context, snapshot) {
                    return Center(
                      child: AspectRatio(
                        aspectRatio: 2.5,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: widget.qImage == null
                                ? const NetworkImage(
                                    'https://firebasestorage.googleapis.com/v0/b/ftawa-84eef.appspot.com/o/1x1%20pexle%20%D8%B4%D9%81%D8%A7%D9%81.png?alt=media&token=3359c3da-1ac8-405b-bbea-9d304651b6a3')
                                : snapshot.hasData
                                    ? Image.memory(snapshot.data!).image
                                    : Image.asset('assets/loading.gif').image,
                          )),
                        ),
                      ),
                    );
                  }),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Stack(children: [
                  Text(
                    widget.q, //السؤال
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                        foreground: Paint()
                          ..color = Colors.white
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 2.5,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        decorationThickness: 2),
                  ),
                  Text(
                    // السؤال
                    widget.q,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                        color: Colors.amber,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        decorationThickness: 2),
                  )
                ]),
              ),
            ],
          ),
          const Divider(
            thickness: 3,
          ),
          Text(
            // الجواب
            widget.a,
            maxLines: 2,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          )
        ],
      ),
    );
  }
}
