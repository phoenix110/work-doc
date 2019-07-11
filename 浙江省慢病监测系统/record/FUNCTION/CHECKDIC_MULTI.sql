create or replace function      checkDic_multi(dicKey varchar2,dicCode varchar2) return number is

  str varchar(120);
	rel varchar(120);
	pi varchar(120);
	temp varchar(120);
begin
	str :=dicCode;
  str:=trim(str);
  if instr(str,',')=1 then str:=substr(str,2,length(str)); end if;
	rel :='';
  if str is null then return 0;end if;
  while(str is not null)
	loop
	     pi :=instr(str,',');
	     temp :=str;
	     if(pi!=0) then temp :=substr(str,1,pi-1);end if;
	     rel :=checkDic(dicKey,temp);
	     if(rel='0') then return 0; end if;
	     if(pi=0) then return 1; end if;
	     str :=substr(str,pi+1,length(str));
	end loop;
  return 1 ;
end checkDic_multi;

