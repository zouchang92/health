import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flui/flui.dart';
import 'package:flutter/material.dart';

import 'package:health/model/global.dart';
/**/
/*基础类*/
import './base.dart';
import 'config.dart';

/*提示*/
var dismiss;

class DioManager {
  static final baseApi = Config.baseApi_1;
  static final DioManager _shared = DioManager._internal();
  factory DioManager() => _shared;
  // BuildContext context;
  Dio dio;

  DioManager._internal() {
    if (dio == null) {
      BaseOptions opt = BaseOptions(
        baseUrl: baseApi,
        contentType: Headers.jsonContentType,
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
      // print('token${Global.profile.token}');
      if (loading) {
        dismiss = FLToast.showLoading();
      }
      Response response = await dio.post(path,
          data: data,
          queryParameters: params,
          options: Options(headers: {"token": Global.profile.token}));
      print('response:$response');
      if (response != null) {
        if (loading) {
          dismiss();
        }
        BaseEntity entity = BaseEntity<T>.fromJson(response.data);
        // print(response.toString());
        if (entity.code == 0) {
          // text: entity.message
          if (loading) {
            FLToast.showSuccess();
          }
          return entity.data;
        } else {
          //消息提示
          // print('response:$response');
          if (loading) {
            FLToast.error(text: entity.message);
          }
          // return ErrorEntity(code: entity.code, message: entity.message);
        }
      }
    } on DioError catch (e) {
      if (loading) {
        dismiss();
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
        FLToast.error(text: er.message);
      }

      // print(er.code);
      // return er;
    }
  }

  Future get<T>(String path,
      {Map<String, dynamic> params, bool loading = true}) async {
    try {
      if (loading) {
        dismiss = FLToast.showLoading();
      }
      Response response = await dio.get(path,
          queryParameters: params,
          options: Options(headers: {"token": Global.profile.token}));
      if (response != null) {
        if (loading) {
          dismiss();
        }
        BaseEntity entity = BaseEntity<T>.fromJson(response.data);
        if (entity.code == 0) {
          return entity.data;
        } else {
          //消息提示
          if (loading) {
            FLToast.showSuccess();
          }
          // return ErrorEntity(code: entity.code, message: entity.message);
        }
      }
    } on DioError catch (e) {
      ErrorEntity er = createErrorEntity(e);
      if (loading) {
        dismiss();
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
        FLToast.error(text: er.message);
      }
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
          print('error.default');
          return ErrorEntity(code: -1, message: error.message);
        }
    }
  }
}
