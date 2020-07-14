import 'global.dart';

class Dictionary {
  static List healthRegisterType = [
    HealthTypeValues[HEALTH_TYPE.ILLNESS],
    HealthTypeValues[HEALTH_TYPE.INJURY]
  ];
  static List reportType = [
    CheckTypeValues[CHECK_TYPE.MORENING],
    CheckTypeValues[CHECK_TYPE.AFTERNOON]
  ];
  static List getByUniqueName(String uniqueName) {
    List _dics = Global.profile.dictionary;
    // print('_Dictionary__dics:$_dics');
    if (_dics == null) {
      return [];
    }
    List _filterdics =
        _dics.where((element) => element['uniqueName'] == uniqueName).toList();
    _filterdics.sort((a, b) => a['sort'].compareTo(b['sort']));
    // print('_filterdics:$_filterdics');
    return _filterdics;
  }

  static Map getItemById(String id) {
    List _dics = Global.profile.dictionary;
    if (_dics == null) {
      return {};
    }
    Map item = _dics.firstWhere((element) => element['id'] == id, orElse: () {
      return null;
    });
    return item;
  }

  static String getNameByUniqueNameAndCode({String uniqueName, String code}) {
    if (code == null) {
      return '';
    }
    List ulist = getByUniqueName(uniqueName);
    Map item =
        ulist.firstWhere((element) => element['code'] == code, orElse: () {
      print('eee');
      return code;
    });

    return item['name'] ?? '';
  }
  // static String getCodeByUniqueNameAndName
}

enum UNIQUE_NAME {
  SYMPTOMTYPE,
  REGISTERTYPE,
  MEASURE,
  CHECKTYPE,
  ILLTYPE,
  ILLCODE,
  HURTTYPE,
  INFECTIONTYPE,
  HURTSITE,
  CLASSSTATUS,
  PERSONTYPE,
  GENDER,
  LEAVETYPE,
  BOOLEAN,
  ORGTYPE,
  DEALCODE,
  JUDGESTATUS,
  TASKSTATUS,
  FLOWSTATUS,
  HEASTATUS,
  REPORTSTATUS,
  CHECKRESULT
}

enum HEALTH_TYPE { ILLNESS, INJURY }
enum CHECK_TYPE { MORENING, AFTERNOON }

enum YES_OR_NO { YES, NO }
// judgestatus taskStatus flowStatus heaStatus
const UniqueNameValues = {
  UNIQUE_NAME.MEASURE: 'measure',
  UNIQUE_NAME.REGISTERTYPE: 'registerType',
  UNIQUE_NAME.SYMPTOMTYPE: 'symptomType',
  UNIQUE_NAME.CHECKTYPE: 'checkType',
  UNIQUE_NAME.ILLTYPE: 'illType',
  UNIQUE_NAME.ILLCODE: 'illCode',
  UNIQUE_NAME.HURTTYPE: 'hurtType',
  UNIQUE_NAME.INFECTIONTYPE: 'infectionType',
  UNIQUE_NAME.HURTSITE: 'hurtSite',
  UNIQUE_NAME.CLASSSTATUS: 'class_status',
  UNIQUE_NAME.PERSONTYPE: 'yqfkPersonType',
  UNIQUE_NAME.GENDER: 'gender',
  UNIQUE_NAME.LEAVETYPE: 'leaveType',
  UNIQUE_NAME.BOOLEAN: 'boolean',
  UNIQUE_NAME.ORGTYPE: 'orgType',
  UNIQUE_NAME.DEALCODE: 'dealCode',
  UNIQUE_NAME.JUDGESTATUS: 'mobileLeaveType',
  UNIQUE_NAME.TASKSTATUS: 'taskStatus',
  UNIQUE_NAME.FLOWSTATUS: 'flowStatus',
  UNIQUE_NAME.HEASTATUS: 'heaStatus',
  UNIQUE_NAME.REPORTSTATUS: 'parentReportStatus',
  UNIQUE_NAME.CHECKRESULT: 'checkResult'
};

const HealthTypeValues = {
  HEALTH_TYPE.ILLNESS: '因病缺课',
  HEALTH_TYPE.INJURY: '伤害缺课'
};

const CheckTypeValues = {CHECK_TYPE.MORENING: '晨检', CHECK_TYPE.AFTERNOON: '午检'};

const YesOrNoValues = {YES_OR_NO.YES: '是', YES_OR_NO.NO: '否'};
