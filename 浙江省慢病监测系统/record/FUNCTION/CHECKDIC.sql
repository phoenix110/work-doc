create or replace function checkDic(dicType varchar2,dicCode varchar2) return number is
cz number:=0;

begin

select count(1) into cz
  from zjjk.code_info c1, zjjk.code_info c2
 where c1.id = c2.code_info_id
   and c1.code = dicType and c2.code=dicCode;


return cz;

end checkDic;
