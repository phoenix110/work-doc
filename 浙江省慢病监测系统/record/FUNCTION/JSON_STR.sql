CREATE OR REPLACE FUNCTION json_str(json_in  json,
                                    key_in   VARCHAR2,
                                    value_in VARCHAR2 DEFAULT NULL)
  RETURN VARCHAR2 IS
  /*-------------------------------
  函数名： json_str
  作者：    lv
  功能:    string获取
  创建日期： 2016-08-09
  修改日期:
  版本号:
  --------------------------------*/
  v_ret VARCHAR2(4000);
BEGIN
  v_ret := json_ext.get_string(json_in, key_in);
  v_ret := nvl(v_ret, value_in);
  RETURN v_ret;
END json_str;
