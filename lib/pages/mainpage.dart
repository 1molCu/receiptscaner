import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/pages/pages.dart';
import '/units/provider/provider.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
              leading: const Image(
                image: AssetImage('assets/logo.png'),
                width: 5,
              ),
              forceElevated: true,
              title: const Text(
                '扫发票码，分享到微信',
                style: TextStyle(fontFamily: 'SmileySans'),
              ),
              actions: [
                PopupMenuButton(
                  color: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  itemBuilder: ((context) => [
                        const PopupMenuItem(
                          value: 'qr_code_scanner',
                          child: Flex(
                            direction: Axis.horizontal,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                                child: Icon(Icons.qr_code_scanner),
                              ),
                              Text(
                                '扫码',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: 'SmileySans',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'setting',
                          child: Flex(
                            direction: Axis.horizontal,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                                child: Icon(Icons.settings),
                              ),
                              Text(
                                '设置',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: 'SmileySans',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                  onSelected: (value) {
                    switch (value) {
                      case 'qr_code_scanner':
                        Navigator.pushNamed(context, 'scaner');
                        break;
                      case 'setting':
                        Navigator.pushNamed(context, 'setting');
                        break;
                    }
                  },
                ),
              ]),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return Consumer<ResponseData>(
                builder: (context, value, child) =>
                    CreditCard(infoData: value.receiptlist[index]),
              );
            }, childCount: context.watch<ResponseData>().receiptlist.length),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, 'scaner');
        },
        child: const Icon(Icons.qr_code_scanner),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
