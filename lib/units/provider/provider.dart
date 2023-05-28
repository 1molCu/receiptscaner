import 'package:flutter/foundation.dart';
import '/db/model.dart';
import '/db/database.dart';
import '../units.dart';
// import 'package:package_info_plus/package_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ResponseData extends ChangeNotifier {
  var httpResponseData;
  Map sacnResult = {};
  List receiptlist = [];

  ResponseData() {
    list();
  }

  list() async {
    receiptlist = await DatabaseProvider().receipts();
    print(receiptlist);
    notifyListeners();
  }

  Map<String, dynamic>? response(String? scanerResult) {
    bool urlIsReceipt = RegExp(regExUrl).hasMatch(scanerResult!);
    if (urlIsReceipt) {
      final String regResult = RegExp(urlPattern, multiLine: true)
          .allMatches(scanerResult)
          .map((m) => m.group(0))
          .join(' ');
      List receiptSplitResult = regResult.split('_');
      sacnResult = {
        'code': urlIsReceipt,
        'result': regResult,
        'splitresult': receiptSplitResult
      };
    } else {
      sacnResult = {'code': urlIsReceipt};
    }
    notifyListeners();
  }

  Future httpData() async {
    Map receiptInfo =
        await RequestProxyServer().requestInfo(sacnResult['result']);
    var filePath = await RequestProxyServer().downloadFileInfo(
        sacnResult['result'],
        sacnResult['splitresult'][0] +
            '_' +
            sacnResult['splitresult'][1] +
            '.pdf');

    if (receiptInfo['requestOptions'] == null ||
        filePath['requestOptions'] == null) {
      Receipt info = Receipt(
        errorCode: receiptInfo['errorCode'],
        fpdm: receiptInfo['fpdm'],
        fphm: receiptInfo['fphm'],
        gfmc: receiptInfo['gfmc'],
        je: receiptInfo['je'],
        kprq: receiptInfo['kprq'],
        filePath: filePath,
      );
      httpResponseData = info;
      print(httpResponseData.fpdm);
    } else {
      Map errorInfo = {"receiptInfo": receiptInfo, "downloadinfo": filePath};
      httpResponseData = errorInfo;
    }
    notifyListeners();
  }

  insertData() async {
    await httpData();
    await DatabaseProvider().insertReceipt(httpResponseData);
    receiptlist = await readReceipts();
    notifyListeners();
  }

  readReceipts() async {
    return await DatabaseProvider().receipts();
  }
}

class AppUpdate extends ChangeNotifier {
  Map<String, dynamic>? updataAppinfo;
  String apkNamePath = '';
  double? progressValue;
  List requestLog = [];

  AppUpdate() {
    updateInfoNetwork();
  }

  // void initVersionInfo() async {
  //   PackageInfo packageInfo = await PackageInfo.fromPlatform();
  //   version = packageInfo.version;
  //   buildNumber = packageInfo.buildNumber;
  //   print(buildNumber);
  //   notifyListeners();
  // }

  updateInfoNetwork() async {
    Map data = await RequestProxyServer().appUpdateInfo();
    updataAppinfo = {
      "apksize": data['ApkSize'].toString(),
      "version": data['VersionCode'].toString(),
      "versionName": data['VersionName'],
      "content": data['ModifyContent'],
      "downloadurl": data['DownloadUrl'],
      'updatestatus': data['UpdateStatus'],
    };
    print(updataAppinfo);
    notifyListeners();
  }

  downloadProgress(String url) async {
    Directory? storageDir = await getExternalStorageDirectory();
    String storagePath = storageDir!.path;
    print(storagePath);
    Map errorInfo;
    apkNamePath = '$storagePath/receipt.apk';
    Dio dio = Dio();
    dio.interceptors.add(LogInterceptor());
    try {
      await dio.download(url, apkNamePath,
          onReceiveProgress: (received, total) {
        if (total != -1) {
          progressValue = received / total;
        }
      }, cancelToken: CancelToken());
    } on DioError catch (e) {
      if (e.response != null) {
        errorInfo = {
          "data": e.response!.data,
          "headers": e.response!.headers,
          "requestOptions": e.response!.requestOptions
        };
      }
      if (CancelToken.isCancel(e)) {
        print('Progress has been cancel');
      } else {
        errorInfo = {"requestOptions": e.requestOptions, "message": e.message};
      }
    }
    notifyListeners();
  }

  networkLog() {
    Dio dio = Dio();
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options, handler) {
      requestLog.add("===========Request===========");
      requestLog.add("method = ${options.method.toString()}");
      requestLog.add("url = ${options.uri.toString()}");
      requestLog.add("headers = ${options.headers}");
      requestLog.add("params = ${options.queryParameters}");
    }, onResponse: (Response response, handler) {
      requestLog.add("===========Response===========");
      requestLog.add("code = ${response.statusCode}");
      requestLog.add("data = ${response.data}");
    }, onError: (DioError error, handler) {
      requestLog.add("===========Error===========");
      requestLog.add("type = ${error.type}");
      requestLog.add("message = ${error.message}");
      requestLog.add("stackTrace = ${error.stackTrace}");
    }));
    notifyListeners();
  }
}
