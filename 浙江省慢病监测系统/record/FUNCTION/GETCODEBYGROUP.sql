create or replace function      GetCodeByGroup(groupId varchar2,tlabel varchar2) return varchar2 is
  Result varchar2(30);
begin
    If groupId Is Not Null Then
       Result := tlabel || '.ccd_code';
    elsif (groupId='1') then
               Result :=  tlabel || '.ccd_code';
    elsif (groupId='2') then
               Result :=  tlabel || '.ccd_scode';
    elsif (groupId='3') then
               Result :=  tlabel || '.ccd_pcode';
    Else
       Result :=  tlabel || '.ccd_code';
    End If;

  return(Result);
end GetCodeByGroup;

