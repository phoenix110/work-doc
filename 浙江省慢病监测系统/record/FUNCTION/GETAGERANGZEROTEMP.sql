create or replace function      GetAgeRangZeroTemp(dtCsrq Date,dtBgrq Date) return varchar2 is
  Result varchar2(30);
  tempcount integer;
begin
       --Select trunc((dtBgrq-dtCsrq)/365.25) Into tempcount From dual;
       /*if (to_char(dtCsrq,'mm')=to_char(dtBgrq,'mm') and to_char(dtCsrq,'dd')=to_char(dtBgrq,'dd')) then
           tempcount := tempcount+1;
       end if;
       */
       if to_number(to_char(dtBgrq,'mm'))>to_number(to_char(dtCsrq,'mm')) then
           tempcount := to_number(to_char(dtBgrq,'yyyy')) - to_number(to_char(dtCsrq,'yyyy'));
       elsif to_number(to_char(dtBgrq,'mm'))<to_number(to_char(dtCsrq,'mm')) then
           tempcount := to_number(to_char(dtBgrq,'yyyy')) - to_number(to_char(dtCsrq,'yyyy')) - 1;
       else
          if to_number(to_char(dtBgrq,'dd'))>=to_number(to_char(dtCsrq,'dd')) then
              tempcount := to_number(to_char(dtBgrq,'yyyy')) - to_number(to_char(dtCsrq,'yyyy'));
          else
              tempcount := to_number(to_char(dtBgrq,'yyyy')) - to_number(to_char(dtCsrq,'yyyy')) - 1;
          end if;
       end if;
  return(tempcount);
end GetAgeRangZeroTemp;

