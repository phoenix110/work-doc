CREATE OR REPLACE PROCEDURE pro_log(gnms_in IN VARCHAR2,
                                    data_in CLOB,
                                    id_in  in varchar2:=null) IS
   PRAGMA AUTONOMOUS_TRANSACTION;
   v_json json;
   v_jgid VARCHAR2(36);
   v_id   VARCHAR2(36);
BEGIN
   v_json := json(data_in);
   v_jgid := json_ext.get_string(v_json, 'czyjgdm');
   v_id:=id_in;
   if v_id is null then
     v_id := sys_guid();
   end if;
   IF gnms_in <> '用户登录' and gnms_in is not null THEN

      INSERT INTO tb_log
         (id, jgid, gnms, data, cjsj, cjryxm)
      VALUES
         (v_id, v_jgid, gnms_in, data_in, SYSDATE,
          json_ext.get_string(v_json, 'czyyhxm'));
      COMMIT;
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      INSERT INTO tb_log
         (id, jgid, gnms, data, cjsj, cjryxm)
      VALUES
         (sys_guid(), NULL, gnms_in, data_in, SYSDATE, NULL);
      COMMIT;
      raise_application_error(-20101, 'json格式错误');
END;

