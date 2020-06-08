

class EntityFactory{
  static T generateObj<T>(json){
    if(json == null){
      return null;
    }else{
      return json as T;
    }
  }
}

class BaseEntity<T>{
  int code;
  String message;
  T data;
  BaseEntity({this.code,this.message,this.data});
  factory BaseEntity.fromJson(json){
    // print('json$json');
    return BaseEntity(code: json['code'],message: json['msg'],data:EntityFactory.generateObj(json['data']));
  }
  Map<String,dynamic> toJson(){
    return{
      "code":code,
      "message":message,
      "data":data
    };
  }
}

class BaseListEntity<T>{
  int code;
  String message;
  List<T> data;
  BaseListEntity({this.code,this.message,this.data});
  factory BaseListEntity.fromJson(json){
    
    return BaseListEntity(code:json['code'],message: json['msg'],data:json['data']);
  }
  Map<String,dynamic> toJson(){
    return{
      "code":code,
      "message":message,
      "data":data
    };
  }
}

class ErrorEntity{
  int code;
  String message;
  ErrorEntity({this.code,this.message});
  factory ErrorEntity.fromJson(json){
    print('json$json');
    return ErrorEntity(code: json['code'],message: json['msg']);
  }
  Map<String,dynamic>toJson(){
    return{
      "code":code,
      "message":message
    };
  }
}

enum NWMethod{
  GET,POST,DELETE,PUT
}

const NWMethodValues = {
  NWMethod.GET:'get',
  NWMethod.POST:'post',
  NWMethod.DELETE:'delete',
  NWMethod.PUT:'put'
};
