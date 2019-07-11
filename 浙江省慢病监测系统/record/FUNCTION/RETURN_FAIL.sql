CREATE OR REPLACE FUNCTION return_fail(err_in  VARCHAR2,
                                       code_in NUMBER,
                                       log_in  VARCHAR2 := NULL)
   RETURN VARCHAR2 IS
   PRAGMA AUTONOMOUS_TRANSACTION;
   /*-------------------------------
   函数名： return_fail
   作者：    lv
   功能:    失败信息返回 code_in 0系统失败  2业务逻辑失败
   创建日期： 2016-08-15
   修改日期:
   版本号: v1.0.1
   ---------------------------------*/
   v_return VARCHAR2(4000);
   v_logid  VARCHAR2(36);
BEGIN
   v_return := err_in;
   v_logid := log_in;
   IF v_logid IS NOT NULL THEN
      UPDATE tb_log SET err = v_return||' '||dbms_utility.format_error_backtrace WHERE id = v_logid;
      COMMIT;
   END IF;
   v_return := REPLACE(v_return, '"', '');
   v_return := REPLACE(v_return, 'ORA-20101: ', '');
   v_return := '{"code":"' || code_in || '","msg":"' || v_return || '"}';
   RETURN v_return;
END;

