CREATE OR REPLACE PROCEDURE      prc_err_log
(
 i_procedure_name Varchar2
,i_err_msg        Varchar2
)
--写日志的过程,Albert Song 2005-06-28
--注意本过程没有进行commit或rollback操作
--用法
--Exception
--   WHEN OTHERS
--   Then
--      rollbak;
--      prc_err_log('prc_err_log','写日志表错误');
--      commit;
As
v_sqlcode Varchar(10);
v_sqlerrm Varchar(1000);
Begin
  v_sqlcode:=Sqlcode;
  v_sqlerrm:=Sqlerrm;
  Insert Into wErrorLog Values(i_procedure_name,i_err_msg,v_sqlcode,v_sqlerrm,Sysdate);
  Exception
   WHEN OTHERS
   Then
      v_sqlcode:=Sqlcode;
      v_sqlerrm:=Sqlerrm;
      Insert Into wErrorLog Values('prc_err_log','写日志表错误',v_sqlcode,v_sqlerrm,Sysdate);
END;

