CREATE OR REPLACE TRIGGER "ZJJK".TRG_ZJJK_XNXG_BGK
  before delete on ZJJK_XNXG_BGK
  for each row
declare
 v_count number:=0;
begin
  --select YHM into v_yhm from middleof_ZJJK_XNXG_BGK  where VC_BGKID=:NEW.VC_BGKID;
  
             insert into middleof_ZJJK_XNXG_BGK (VC_BGKID,OPERATE)
             values('111','delete');
             v_count:=1;
    --异常处理
  
end;
