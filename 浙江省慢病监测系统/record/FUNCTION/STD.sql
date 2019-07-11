CREATE OR REPLACE FUNCTION std(p_str      IN VARCHAR2,
                               f_datetime IN NUMBER := 1) RETURN DATE IS
  /*-------------------------------
  函数名： yyyy-mm-dd hh24:mi:ss字符串转日期
  作者：    sxp
  功能:    select std('2016-08-10 12:34:00') as datetime from dual
         f_datetime:1 日期时间格式，0 日期格式
  创建日期： 2016-08-09
  修改日期:
  版本号:
  --------------------------------*/
BEGIN
  IF f_datetime = 1 THEN
    RETURN to_date(p_str, 'yyyy-mm-dd hh24:mi:ss');
  ELSE
    RETURN trunc(to_date(p_str, 'yyyy-mm-dd hh24:mi:ss'));
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    RETURN null;
END std;
