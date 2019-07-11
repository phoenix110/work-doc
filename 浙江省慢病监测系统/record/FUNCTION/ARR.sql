CREATE OR REPLACE FUNCTION arr(p_str IN VARCHAR2,
                               p_i   IN NUMBER := 0,
                               p_sep IN VARCHAR2 := '-') RETURN VARCHAR2 IS

  --函数名： arr 作者：    lvsy 功能:    select splitstr('3333-tttt',1) from dual 创建日期： 2016-08-09


  v_count NUMBER;
  v_str   VARCHAR2(4000);
BEGIN
  IF p_i = 0 THEN
    v_str := p_str;
  ELSIF instr(p_str, p_sep) = 0 THEN
    v_str := p_str;
  ELSE
    SELECT COUNT(*) INTO v_count FROM TABLE(split(p_str, p_sep));
    IF p_i <= v_count THEN
      SELECT str
        INTO v_str
        FROM (SELECT rownum AS item, column_value AS str
                 FROM TABLE(split(p_str, p_sep)))
       WHERE item = p_i;
    END IF;
  END IF;
  RETURN v_str;
END arr;

