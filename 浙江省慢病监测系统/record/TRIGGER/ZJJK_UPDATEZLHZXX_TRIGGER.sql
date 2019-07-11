CREATE OR REPLACE TRIGGER "ZJJK".zjjk_updatezlhzxx_trigger
AFTER update
    ON zjjk_zl_hzxx  FOR EACH ROW
BEGIN
  update zjjk_zl_bgk set dt_xgsj=sysdate where vc_hzid=:New.Vc_Personid;
END zjjk_updatezlhzxx_trigger;
