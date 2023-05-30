import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:animations/animations.dart';

class CreditCard extends StatelessWidget {
  var infoData;
  CreditCard({Key? key, required this.infoData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        padding: const EdgeInsets.only(left: 15, top: 5),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromRGBO(27, 79, 114, 22),
              Color.fromRGBO(169, 223, 191, 22),
              Color.fromRGBO(27, 79, 114, 22),
            ],
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              blurRadius: 6,
              spreadRadius: 4,
              color: Color.fromARGB(20, 0, 0, 0),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          verticalDirection: VerticalDirection.down,
          children: [
            Expanded(
                child: Container(
                    padding: EdgeInsets.all(2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          infoData.gfmc ?? 'gfmc',
                          // infoData['gfmc'],
                          // 'gfmc',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          softWrap: true,
                          overflow: TextOverflow.clip,
                        ),
                        Text(
                          infoData.kprq ?? 'kprq',
                          // infoData['kprq'],
                          // 'kprq',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(200, 255, 255, 255),
                          ),
                        ),
                        Text(
                          infoData.fphm ?? 'fphm',
                          // infoData['fphm'],
                          // 'fphm',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(200, 255, 255, 255),
                          ),
                        ),
                        Text(
                          infoData.je ?? 'je',
                          // infoData['je'],
                          // 'je',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(200, 255, 255, 255),
                          ),
                        ),
                      ],
                    ))),
            Container(
              padding: EdgeInsets.all(5),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                        child: Text(
                      infoData.id.toString(),
                      style: const TextStyle(color: Colors.white),
                    )),
                    Container(
                      child: OpenContainer(
                          closedColor: Colors.transparent,
                          closedElevation: 0.0,
                          closedBuilder: (context, action) => _cardButton(),
                          openBuilder: (context, action) =>
                              _PdfReader(infoData.filePath)),
                    ),
                    Container(
                        child: TextButton.icon(
                      onPressed: () {
                        Share.shareFiles([infoData.filePath],
                            mimeTypes: ['application/pdf']);
                      },
                      icon: const Icon(Icons.share),
                      label: const Text('分享'),
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                      ),
                      // color: Colors.blueAccent,
                    )),
                  ]),
            )
          ],
        ));
  }
}

Widget _PdfReader(filePath) {
  return Scaffold(
    appBar: AppBar(),
    body: Container(
      child: SfPdfViewer.file(File(filePath)),
    ),
  );
}

Widget _cardButton() {
  return const Flex(direction: Axis.horizontal, children: [
    Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 9, 0.0),
      child: Icon(
        Icons.picture_as_pdf,
        color: Colors.white,
      ),
    ),
    Text(
      '预览',
      style: TextStyle(
        color: Colors.white,
        // fontSize: 16,
        // fontFamily: 'SmileySans',
      ),
    ),
  ]);
}
