import 'package:dio/dio.dart';

import 'package:health/model/global.dart';
/**/ 
/*基础类*/ 
import './base.dart';
/*提示*/ 


class DioManager {
  static final baseApi = "http://115.223.19.233:8998/cloud";
  static final DioManager _shared = DioManager._internal();
  factory DioManager() => _shared;
  Dio dio;
  DioManager._internal() {
    if (dio == null) {
      BaseOptions opt = BaseOptions(
        baseUrl: '',
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        receiveDataWhenStatusError: false,
        connectTimeout: 5000,
        receiveTimeout: 3000,
        
      );
      dio = Dio(opt);
    }
  }

  Future post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic> params,
  }) async {
    try {
      Response response =
          await dio.post(path, data: data, queryParameters: params,options:Options(headers:{
            "token":Global.profile.token
          }));
      // print('response${response.data}');
      if (response != null) {
        BaseEntity entity = BaseEntity<T>.fromJson(response.data);

        if (entity.code == 0) {
          return entity.data;
        } else {
          //消息提示
         
          // return ErrorEntity(code: entity.code, message: entity.message);
        }
      }
    } on DioError catch (e) {
      //消息提示
      ErrorEntity er = createErrorEntity(e);
      
      // print(er.message);
      // print(er.code);
      return er;
    }
  }

  Future get<T>(String path, {Map<String, dynamic> params}) async {
    try {
      Response response = await dio.get(path, queryParameters: params,options: Options(
        headers:{
          "token":Global.profile.token
        }
      ));
      if (response != null) {
        BaseEntity entity = BaseEntity<T>.fromJson(response.data);
        if (entity.code == 0) {
          return entity.data;
        } else {
          //消息提示
          return ErrorEntity(code: entity.code, message: entity.message);
        }
      }
    } on DioError catch (e) {
      //消息提示
      return createErrorEntity(e);
    }
  }

  // data 类型 {}
  Future request<T>(NWMethod method, String path,
      {dynamic data,
      Map<String, dynamic> params,
      Function(T) success,
      Function(ErrorEntity) error}) async {
    try {
      Response response = await dio.request(path,
          data: data,
          queryParameters: params,
          options: Options(method: NWMethodValues[method]));
      if (response != null) {
        BaseEntity entity = BaseEntity<T>.fromJson(response.data);
        if (entity.code == 0) {
          // success(entity.data);
          return entity.data;
        } else {
          // error(ErrorEntity(code: entity.code, message: entity.message));
          return ErrorEntity(code: entity.code, message: entity.message);
        }
      } else {
        // error(ErrorEntity(code: -1, message: "未知错误"));
        return ErrorEntity(code: -1, message: "未知错误");
      }
    } on DioError catch (e) {
      return createErrorEntity(e);
      // error(createErrorEntity(e));
    }
  }

  // 回调data 数组结构
  Future requestList<T>(NWMethod method, String path,
      {dynamic data,
      Map<String, dynamic> params,
      Function(List<T>) success,
      Function(ErrorEntity) error}) async {
    try {
      Response response = await dio.request(path,
          data: data,
          queryParameters: params,
          options: Options(method: NWMethodValues[method]));
      if (response != null) {
        BaseListEntity entity = BaseListEntity<T>.fromJson(response.data);
        if (entity.code == 0) {
          success(entity.data);
        } else {
          error(ErrorEntity(code: entity.code, message: entity.message));
        }
      } else {
        error(ErrorEntity(code: -1, message: "未知错误"));
      }
    } on DioError catch (e) {
      error(createErrorEntity(e));
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
            int errCode = error.response.statusCode;
            String errMsg = error.response.statusMessage;
            // print(errMsg);
            return ErrorEntity(code: errCode, message: errMsg);
          } on Exception catch (_) {
            return ErrorEntity(code: -1, message: "未知错误");
          }
        }
        break;
      default:
        {
          return ErrorEntity(code: -1, message: error.message);
        }
    }
  }
}
