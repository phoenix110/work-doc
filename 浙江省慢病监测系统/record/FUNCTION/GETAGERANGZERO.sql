create or replace function      GetAgeRangZero(dtCsrq Date,dtBgrq Date) return varchar2 is
  Result varchar2(30);
  tempcount integer;
begin
    If dtCsrq Is Not Null Then
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


       if (tempcount>=0) then
           if (tempcount<5) then
               Result := '' || '0～';
           elsif (tempcount>=5) and (tempcount<10) then
               Result := '' || '5～';
           elsif (tempcount>=10) and (tempcount<15) then
               Result := '' || '10～';
           elsif (tempcount>=15) and (tempcount<20) then
               Result := '' || '15～';
           elsif (tempcount>=20) and (tempcount<25) then
               Result := '' || '20～';
           elsif (tempcount>=25) and (tempcount<30) then
               Result := '' || '25～';
           elsif (tempcount>=30) and (tempcount<35) then
               Result := '' || '30～';
           elsif (tempcount>=35) and (tempcount<40) then
               Result := '' || '35～';
           elsif (tempcount>=40) and (tempcount<45) then
               Result := '' || '40～';
           elsif (tempcount>=45) and (tempcount<50) then
               Result := '' || '45～';
           elsif (tempcount>=50) and (tempcount<55) then
               Result := '' || '50～';
           elsif (tempcount>=55) and (tempcount<60) then
               Result := '' || '55～';
           elsif (tempcount>=60) and (tempcount<65) then
               Result := '' || '60～';
           elsif (tempcount>=65) and (tempcount<70) then
               Result := '' || '65～';
           elsif (tempcount>=70) and (tempcount<75) then
               Result := '' || '70～';
           elsif (tempcount>=75) and (tempcount<80) then
               Result := '' || '75～';
           elsif (tempcount>=80) and (tempcount<85) then
               Result := '' || '80～';
           elsif (tempcount>=85) then
               Result := '' || '85～';
           else
               Result := '' || '不明';
           end if;
       else
           Result := '' || '错误数据';
       end if;
    Else
       Result := '' || '空';
    End If;

  return(Result);
end GetAgeRangZero;

