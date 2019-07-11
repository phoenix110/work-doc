CREATE OR REPLACE FUNCTION unistr_str(p_str IN VARCHAR2) RETURN VARCHAR2 IS
  /*-------------------------------
  函数名： json_unistr
  作者：    lv
  功能:    unistr获取
  创建日期： 2016-08-09
  修改日期:
  版本号:
  --------------------------------*/
  v_re VARCHAR2(4000);
BEGIN
  v_re := unistr(REPLACE(p_str, '\u', '\'));
  RETURN v_re;
END unistr_str;
