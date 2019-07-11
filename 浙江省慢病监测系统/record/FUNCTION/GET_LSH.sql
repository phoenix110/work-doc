create or replace function      Get_Lsh(Preix in varchar2,Table_name in varchar2,Query_key in varchar2,suffix in int default 11) return varchar2 is
  Result long;
  Tmp_Lsh long;
  CurrMaxLsh number;
  Tmp_number number:=power(10,suffix);
  Query_Sql long;
  t long:=Preix;
begin
  Query_Sql:='select max('||Query_key||') from '||Table_name||' where '||Query_key||' like :t';

  --dbms_output.put_line(Query_Sql);

  execute immediate Query_Sql
  into Tmp_Lsh using t||'%';

  --dbms_output.put_line(Tmp_Lsh);

  if Tmp_Lsh is null then
  CurrMaxLsh:=0;
  else
  CurrMaxLsh:=to_number(replace(Tmp_Lsh,Preix,''));

  end if;

  Tmp_number:= Tmp_number+CurrMaxLsh+1;

  Result:= Preix||substr(Tmp_number,2,length(Tmp_number)) ;


  return Result;
end ;

