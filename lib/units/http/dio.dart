import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import '../units.dart';
import '../../db/model.dart';

class RequestProxyServer {
  Dio dio = Dio();

  Future requestInfo(String? receiptcode) async {
    Response info;
    var errorInfo;
    dio.interceptors.add(LogInterceptor());
    try {
      info = await dio.get(InfoUrl + receiptcode!);
    } on DioError catch (e) {
      if (e.response != null) {
        errorInfo = {
          'data': e.response!.data,
          'headers': e.response!.headers,
          'requestOptions': e.response!.requestOptions,
        };
      } else {
        errorInfo = {
          'requestOptions': e.requestOptions,
          'message': e.message,
        };
      }
      return errorInfo;
    }
    if (info.data['ErrorCode'] != 0) {
      errorInfo = info.data;
      return errorInfo;
    } else {
      Map receiptInfo = Receipt.fromJson(info.data).toJson();
      return receiptInfo;
    }
  }

  Future downloadFileInfo(String? receiptcode, String? fileName) async {
    Map<String, dynamic> errorInfo;
    String? localDirt = (await getExternalStorageDirectory())!.path;
    dio.interceptors.add(LogInterceptor());
    try {
      await dio.download(DownloadUrl + receiptcode!, '$localDirt/$fileName');
    } on DioError catch (e) {
      if (e.response != null) {
        errorInfo = {
          "data": e.response!.data,
          "headers": e.response!.headers,
          "requestOptions": e.response!.requestOptions
        };
      } else {
        errorInfo = {"requestOptions": e.requestOptions, "message": e.message};
      }
      return errorInfo;
    }
    return '$localDirt/$fileName';
  }

  Future appUpdateInfo() async {
    Response response = await dio.get(appUpdateUrl);
    print(response.data);
    return response.data;
  }
}
