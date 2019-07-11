CREATE OR REPLACE FUNCTION split(p_list VARCHAR2,
                                 p_sep  VARCHAR2 := '-') RETURN t_type
  --函数名： split 作者：    lvsy 功能:    select * from table(split('1-2-3'))
  PIPELINED IS
  v_num  INTEGER;
  v_list VARCHAR2(4000) := p_list;
BEGIN
  LOOP
    v_num := instr(v_list, p_sep);
    IF v_num > 0 THEN
      PIPE ROW(substr(v_list, 1, v_num - 1));
      v_list := substr(v_list, v_num + length(p_sep));
    ELSE
      PIPE ROW(v_list);
      EXIT;
    END IF;
  END LOOP;
END split;
