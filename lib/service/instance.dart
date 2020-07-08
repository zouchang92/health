import 'dart:convert';

import 'package:dio/dio.dart';
// import 'package:flui/flui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:health/model/global.dart';
/**/
/*基础类*/
import './base.dart';
import 'config.dart';

/*提示*/

class DioManager {
  static final baseApi = Config.baseApi;
  static final DioManager _shared = DioManager._internal();
  factory DioManager() => _shared;
  // BuildContext context;
  Dio dio;
  var dismiss;
  bool start = false;
  DioManager._internal() {
    if (dio == null) {
      BaseOptions opt = BaseOptions(
        baseUrl: baseApi,
        // contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        receiveDataWhenStatusError: true,
        connectTimeout: 5000,
        receiveTimeout: 3000,
      );
      dio = Dio(opt);
    }
  }

  Future post<T>(String path,
      {dynamic data, Map<String, dynamic> params, bool loading = true}) async {
    try {
      // print('loading$loading');
      if (loading) {
        EasyLoading.show();
        start = true;
      }
      Response response = await dio.post(path,
          data: data,
          queryParameters: params,
          options: Options(headers: {"token": Global.profile.token}));
      print('response:${response.data}');
      if (response != null) {
        if (loading && start) {
          EasyLoading.dismiss();
        }
        BaseEntity entity = BaseEntity<T>.fromJson(response.data);
        // print(response.toString());
        if (entity.code == 0) {
          // text: entity.message
          if (loading) {
            // FLToast.showSuccess();
            EasyLoading.showSuccess(entity.message);
          }
          if (entity.data != null) {
            return entity.data;
          } else {
            return response.data;
          }
        } else {
          //消息提示
          print('response:${entity.message}');
          if (loading && start) {
            // FLToast.error(text: entity.message);
            EasyLoading.showError(entity.message);
          }
          // return ErrorEntity(code: entity.code, message: entity.message);
        }
      }
    } on DioError catch (e) {
      print('e:$e');
      if (loading && start) {
        // print('消失');
        EasyLoading.dismiss();
      }
      //消息提示
      ErrorEntity er = createErrorEntity(e);

      /*token失效*/
      if (er.code == -15) {
        showDialog(
            context: Global.appContext,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('提示'),
                content: Text('${er.message},是否重新登录?'),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('取消')),
                  FlatButton(
                      onPressed: () {
                        Global.quit();
                        Navigator.of(context).pushNamed('/login');
                      },
                      child: Text('确认')),
                ],
              );
            });
      } else {
        // print(er);
        // FLToast.error(text: er.message);
        EasyLoading.showError(er.message);
      }
      // dio.close();
      // print(er.code);
      // return er;
    }
  }

  Future get<T>(String path,
      {Map<String, dynamic> params, bool loading = true}) async {
    try {
      if (loading) {
        EasyLoading.show();
        start = true;
      }
      Response response = await dio.get(path,
          queryParameters: params,
          options: Options(headers: {"token": Global.profile.token}));
      if (response != null) {
        if (loading && start) {
          EasyLoading.dismiss();
        }
        BaseEntity entity = BaseEntity<T>.fromJson(response.data);
        if (entity.code == 0) {
          return entity.data;
        } else {
          //消息提示
          if (loading && start) {
            EasyLoading.showSuccess(entity.message);
          }
          // return ErrorEntity(code: entity.code, message: entity.message);
        }
      }
    } on DioError catch (e) {
      ErrorEntity er = createErrorEntity(e);
      if (loading && start) {
        EasyLoading.dismiss();
      }
      // print('post${er.toJson()}');

      /*token失效*/
      if (er.code == -15) {
        showDialog(
            context: Global.appContext,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('提示'),
                content: Text('${er.message},是否重新登录?'),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('取消')),
                  FlatButton(
                      onPressed: () {
                        Global.quit();
                        Navigator.of(context).pushNamed('/login');
                      },
                      child: Text('确认')),
                ],
              );
            });
      } else {
        // print('e:$e');
        // FLToast.error(text: '网络异常!');
        EasyLoading.showError(er.message);
      }
      // dio.close();
    }
  }

  ErrorEntity createErrorEntity(DioError error) {
    switch (error.type) {
      case DioErrorType.CANCEL:
        {
          return ErrorEntity(code: -1, message: "请求取消");
        }
        break;
      case DioErrorType.CONNECT_TIMEOUT:
        {
          return ErrorEntity(code: -1, message: "连接超时");
        }
        break;
      case DioErrorType.SEND_TIMEOUT:
        {
          return ErrorEntity(code: -1, message: "请求超时");
        }
        break;
      case DioErrorType.RECEIVE_TIMEOUT:
        {
          return ErrorEntity(code: -1, message: "响应超时");
        }
        break;
      case DioErrorType.RESPONSE:
        {
          try {
            // int errCode = error.response.statusCode;
            // String errMsg = error.response.statusMessage;

            var eresponse = json.decode(error.response.toString());
            // print('error.response${eresponse['message']}');
            String errMsg = eresponse['message'];
            int errCode = eresponse['status'];
            return ErrorEntity(code: errCode, message: errMsg);
          } on Exception catch (_) {
            print('responseNull${error.response}');
            return ErrorEntity(code: -1, message: "未知错误");
          }
        }
        break;
      default:
        {
          print('error.default:$error');
          return ErrorEntity(code: -1, message: '网络异常');
        }
    }
  }
}
