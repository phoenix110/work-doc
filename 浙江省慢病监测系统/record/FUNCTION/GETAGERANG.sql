create or replace function      GetAgeRang(dtCsrq Date,dtSwrq Date) return varchar2 is
  Result varchar2(30);
  tempcount integer;
  tempcount2 integer;
begin
    If dtCsrq Is Not Null Then
       Select (dtSwrq-dtCsrq)/365.25 Into tempcount From dual;
       if (tempcount>1) then
           tempcount2 := trunc((Sysdate-dtCsrq)/365.25);
           if (tempcount2<5) then
               Result := '' || '1～';
           elsif (tempcount2>=5) and (tempcount2<10) then
               Result := '' || '5～';
           elsif (tempcount2>=10) and (tempcount2<15) then
               Result := '' || '10～';
           elsif (tempcount2>=15) and (tempcount2<20) then
               Result := '' || '15～';
           elsif (tempcount2>=20) and (tempcount2<25) then
               Result := '' || '20～';
           elsif (tempcount2>=25) and (tempcount2<30) then
               Result := '' || '25～';
           elsif (tempcount2>=30) and (tempcount2<35) then
               Result := '' || '30～';
           elsif (tempcount2>=35) and (tempcount2<40) then
               Result := '' || '35～';
           elsif (tempcount2>=40) and (tempcount2<45) then
               Result := '' || '40～';
           elsif (tempcount2>=45) and (tempcount2<50) then
               Result := '' || '45～';
           elsif (tempcount2>=50) and (tempcount2<55) then
               Result := '' || '50～';
           elsif (tempcount2>=55) and (tempcount2<60) then
               Result := '' || '55～';
           elsif (tempcount2>=60) and (tempcount2<65) then
               Result := '' || '60～';
           elsif (tempcount2>=65) and (tempcount2<70) then
               Result := '' || '65～';
           elsif (tempcount2>=70) and (tempcount2<75) then
               Result := '' || '70～';
           elsif (tempcount2>=75) and (tempcount2<80) then
               Result := '' || '75～';
           elsif (tempcount2>=80) and (tempcount2<85) then
               Result := '' || '80～';
           elsif (tempcount2>=85) then
               Result := '' || '85～';
           else
               Result := '' || '不明';
           end if;
       elsif (tempcount>=0.075665) then
           Result := '' || '0岁';
       else
           Result := '' || '新生儿';
       end if;
    Else
       Result := '' || '空';
    End If;

  return(Result);
end GetAgeRang;

