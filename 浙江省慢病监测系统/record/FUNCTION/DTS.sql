CREATE OR REPLACE FUNCTION dts(v_datetime IN DATE,
                               f_datetime IN NUMBER := 1) RETURN VARCHAR2 IS
  /*-------------------------------
  函数名： 日期转yyyy-mm-dd hh24:mi:ss字符串
  作者：    sxp
  功能:    select std(sysdate) as datestr from dual
         f_datetime:1 日期时间格式，0 日期格式 2 时间
  创建日期： 2016-08-09
  修改日期:
  版本号:
  --------------------------------*/
BEGIN
  IF f_datetime = 1 THEN
    --日期时间
    RETURN to_char(v_datetime, 'yyyy-mm-dd hh24:mi:ss');
  ELSIF f_datetime = 0 THEN
    --日期
    RETURN to_char(v_datetime, 'yyyy-mm-dd');
  ELSIF f_datetime = 2 THEN
    RETURN to_char(v_datetime, 'hh24:mi:ss');
  ELSE
    --时间
    RETURN to_char(v_datetime, 'yyyy-mm-dd hh24:mi:ss');
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    RETURN NULL;
END dts;
