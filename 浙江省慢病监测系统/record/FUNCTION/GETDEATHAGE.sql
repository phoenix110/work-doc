create or replace function      GetDeathAge(dtCsrq Date,dtSwrq Date) return varchar is
  Result varchar(10);
  c_year number(4);
  c_month number(2);
  c_date number(2);
  s_year number(4);
  s_month number(2);
  s_date number(2);
  tempdata number(30);
begin
    tempdata := dtSwrq - dtCsrq;
    If dtCsrq Is Not Null and dtSwrq is not null Then
       c_month := to_number(to_char(dtCsrq,'mm'));
       c_date := to_number(to_char(dtCsrq,'dd'));
       s_month := to_number(to_char(dtSwrq,'mm'));
       s_date := to_number(to_char(dtSwrq,'dd'));
       c_year := to_number(to_char(dtCsrq,'yyyy'));
       s_year := to_number(to_char(dtSwrq,'yyyy'));
       if (tempdata>364) then
           Result := '大于1年';
       elsif (tempdata < 28) then
           if (tempdata=0) then
               Result := '0-天';
           elsif (tempdata=1) then
               Result := '1-天';
           elsif (tempdata=2) then
               Result := '2-天';
           elsif (tempdata=3) then
               Result := '3-天';
           elsif (tempdata=4) then
               Result := '4-天';
           elsif (tempdata=5) then
               Result := '5-天';
           elsif (tempdata=6) then
               Result := '6-天';
           elsif (tempdata>=7 and tempdata<14) then
               Result := '7-天';
           elsif (tempdata>=14 and tempdata<21) then
               Result := '14-天';
           elsif (tempdata>=21 and tempdata<28) then
               Result := '21-天';
           elsif (tempdata>=28 and tempdata<30) then
               Result := '28-天';
           end if;
       else
           if (s_year = c_year) then
               if (s_date - c_date <0 ) then
                   Result := (s_month - c_month ) -1 || '-月';
               else
                   Result := (s_month - c_month )  || '-月';
               end if;
           else
               if (s_date - c_date <0) then
                   Result := (s_month + 12 - c_month ) -1 || '-月';
               else
                   Result := (s_month + 12 - c_month )  || '-月';
               end if;
           end if;
       end if;
    End If;

    if (Result='0-月' or Result='1-月') then
        Result := '28-天';
    end if;

  return(Result);
end GetDeathAge;

