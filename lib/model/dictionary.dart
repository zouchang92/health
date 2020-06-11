class Dictionary {
  static List healthRegisterType = [HealthTypeValues[HEALTH_TYPE.ILLNESS],HealthTypeValues[HEALTH_TYPE.INJURY]];
  static List reportType = [CheckTypeValues[CHECK_TYPE.MORENING],CheckTypeValues[CHECK_TYPE.AFTERNOON]];
}


enum HEALTH_TYPE { ILLNESS, INJURY }
enum CHECK_TYPE { MORENING, AFTERNOON }

enum YES_OR_NO { YES, NO }


const HealthTypeValues = {
 HEALTH_TYPE.ILLNESS:'因病缺课',
 HEALTH_TYPE.INJURY:'伤害缺课'
};

const CheckTypeValues = {
  CHECK_TYPE.MORENING:'晨检',
  CHECK_TYPE.AFTERNOON:'午检'
};

const YesOrNoValues = {
  YES_OR_NO.YES:'是',
  YES_OR_NO.NO:'否'
};
