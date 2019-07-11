CREATE OR REPLACE FUNCTION unistr_clob(clob_in IN CLOB) RETURN CLOB IS
  n      NUMBER;
  len    NUMBER;
  p_with VARCHAR2(10);
  p_what VARCHAR2(10);
  v_clob CLOB;
BEGIN
  v_clob := clob_in;
  p_what := '\u';
  n      := dbms_lob.instr(v_clob, p_what);

  WHILE (nvl(n, 0) > 0) LOOP
    len    := dbms_lob.getlength(v_clob);
    p_with := unistr(REPLACE(dbms_lob.substr(v_clob, 6, n), '\u', '\'));

    IF (n + length(p_with) - 1 > len) THEN
      dbms_lob.writeappend(v_clob, n + length(p_with) - 1 - len, p_with);
    END IF;

    IF (len - n - length(p_what) + 1 > 0) THEN
      dbms_lob.copy(v_clob, --目标
                    v_clob, --源
                    len - 6, ---源长度
                    n + 1, ---目标开始位置
                    n + 6 ---源开始位置
                    );
    END IF;

    dbms_lob.write(v_clob,
                   length(p_with), ---写入长度
                   n, ---写入起始位置
                   p_with ---写入数据
                   );

    dbms_lob.trim(v_clob, dbms_lob.getlength(v_clob) - 5);

    n := dbms_lob.instr(v_clob, p_what);
  END LOOP;
  RETURN v_clob;
END;
