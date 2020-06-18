// 接口注册
class Api {
  static String login = '/account/login';

  static String loginOut = '/account/logout';
  /*字典*/ 
  static String getDics = '/dict/listAllDictItem';
  
  /*学生列表*/
  static String getStuList = '/student/list';

  /*平安上报-删除*/ 
  static String deleteHeaDaily = '/heaClassDaily/delete';
  /*平安上报-添加*/
  static String insertHeaDaily = '/heaClassDaily/insert';
  /*平安上报-查询*/
  static String listHeaDaily = '/heaClassDaily/list';  
  /*平安上报-更新*/
  static String updateHeaDaily = '/heaClassDaily/update'; 
  /*晨午检-新增*/ 
  static String heaInfoDailyInsert = '/heaInfoDaily/insert';
  /*晨午检-删除*/
  static String heaInfoDailyDelete = '/heaInfoDaily/delete'; 
  /*晨午检-导出*/ 
  static String heaInfoDailyExport = '/heaInfoDaily/delete';
  /*晨午检-查询*/
  static String heaInfoDailyList = '/heaInfoDaily/list';
  /*晨午检-查询-daily*/
  static String heaInfoDailyListDaily = '/heaInfoDaily/listDaily';
  /*晨午检-更新*/
  static String heaInfoDailyUpdate = '/heaInfoDaily/update'; 
  /*健康卡-老师-审核*/
  static String heaInfoCardConfirm = '/heaInfo/confirm'; 
  /*健康卡-删除*/ 
  static String heaInfoCardDelete = '/heaInfo/delete';
  /*健康卡-？*/ 
  static String heaInfoCardFaceSave = '/heaInfo/faceSave';
  /*健康卡-导出*/
  static String heaInfoCardExportData = '/heaInfo/export';
  /*健康卡-新增*/ 
  static String heaInfoCardInsert = '/heaInfo/insert';
  /*健康卡-查询*/
  static String heaInfoCardList = '/heaInfo/listMobile'; 
  /*健康卡-更新*/ 
  static String heaInfoCardUpdate = '/heaInfo/update';
  
  /*申请请假*/
  static String applicationLeave = '/qj/request';
  /*请假审批*/
  static String leaveApproval = '/qj/update'; 
  /*请假列表*/ 
  static String leaveList = '/qj/listMy';
  
  /*通知列表*/
  static String newsList = '/schNews/getList';

  /*文件上传-通用*/ 
  static String uploadFile = '/upload/publicUpload';
}