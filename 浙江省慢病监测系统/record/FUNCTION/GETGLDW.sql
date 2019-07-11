create or replace function      GetGldw(hkjdmd in varchar2,hksdm in varchar2) return varchar2 is
  res varchar2(120);
  count_sxqz integer;
begin
  if hksdm = '0' then
    select count(1) into count_sxqz from organ_node t where t.description like '%'||hkjdmd||'%';
    --DBMS_OUTPUT.put_line('---count_sxqz----'||count_sxqz);
    if count_sxqz = 1 then
      select t.code into res from organ_node t where t.description like '%'||hkjdmd||'%';
      --DBMS_OUTPUT.put_line('---1----'||res);
    else
      SELECT wmsys.wm_concat(code) into res  FROM organ_node t where t.description like '%'||hkjdmd||'%';
      --DBMS_OUTPUT.put_line('---2----'||res);
    end if;
  else
    res := '99999999';
  end if;
  return res;
end GetGldw;

