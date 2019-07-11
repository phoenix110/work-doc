create or replace function      comp_group_repeat(count_str varchar2, count_num integer) return integer is
  return_type integer;--0表示不需要参与查重，1需要查重
  split_num integer;
  comp_temp_str varchar2(60);
begin
  return_type := 0;
  split_num := length(regexp_replace(replace(count_str,',','@'),'[^@]+',''));
  if count_num=split_num + 1 then
    for i in 1..count_num loop
      if i=1 then
        comp_temp_str := substr(count_str,1,instr(count_str,',',1,1)-1);
      elsif i<count_num then
        if comp_temp_str=substr(count_str,instr(count_str,',',1,i-1)+1,instr(count_str,',',1,i)-instr(count_str,',',1,i-1)-1) then
          return_type := 0;
        else
          return_type := 1;
          exit;
        end if;
      else
        if comp_temp_str=substr(count_str,instr(count_str,',',1,i-1)+1) then
          return_type := 0;
        else
          return_type := 1;
          exit;
        end if;
      end if;
    end loop;
    --return_type := 0;
  else
    return_type := 1;
  end if;
  return return_type;
end comp_group_repeat;

