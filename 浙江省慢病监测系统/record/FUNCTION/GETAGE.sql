create or replace function GetAge(dtCsrq Date) return integer is
  Result integer;
begin
    If dtCsrq Is Not Null Then
       Select trunc((Sysdate-dtCsrq)/365.25) Into Result From dual;

    Else Result:=0;
       End If;

  return(Result);
end GetAge;
