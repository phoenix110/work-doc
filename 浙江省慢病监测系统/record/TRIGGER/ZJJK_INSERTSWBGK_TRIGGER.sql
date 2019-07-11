CREATE OR REPLACE TRIGGER "ZJJK".zjjk_insertswbgk_trigger
AFTER INSERT
    ON zjmb_sw_bgk  FOR EACH ROW
BEGIN
         insert into middlexmldate(vc_bgkid,vc_id,table_name,dt_cjsj,dt_xgsj,createtime,vc_scbz,action) values(:New.vc_bgkid,:New.vc_id,'zjmb_sw_bgk',:New.dt_cjsj,:New.dt_xgsj,sysdate,:New.vc_scbz,'insert') ;
END zjjk_insertswbgk_trigger;
