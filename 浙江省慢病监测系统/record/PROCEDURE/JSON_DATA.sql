CREATE OR REPLACE PROCEDURE json_data(clob_in CLOB,
                                      gnms_in VARCHAR2,
                                      json_in OUT json
                                      ) IS
   /*-------------------------------
   过程名： json_data
   作者：    lvsy
   功能:     通用过程 ，json格式校验
   创建日期： 2016-09-27
   修改日期:
   版本号:
      {"jgid":"","czryid":""","czryxm":"","czryksid":"","czryksmc":""}
   --------------------------------*/
   v_id varchar2(36);
   v_json json:=json();
BEGIN
   v_id:=sys_guid();
   pro_log(gnms_in, clob_in,v_id);
   v_json := json(clob_in);
   v_json.put('logid',v_id);
   json_in:=v_json;
EXCEPTION
   WHEN OTHERS THEN
      IF clob_in IS NULL THEN
         raise_application_error(-20101, '传入数据为空,是否存在特殊字符');
      ELSE
         raise_application_error(-20101, 'JSON格式错误');
      END IF;
END;
