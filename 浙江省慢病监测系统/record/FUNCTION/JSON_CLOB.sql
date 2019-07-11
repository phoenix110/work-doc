CREATE OR REPLACE FUNCTION json_clob(json_in json) RETURN CLOB IS
  temp_clob CLOB;
BEGIN
  temp_clob := empty_clob();
  dbms_lob.createtemporary(temp_clob, TRUE);
  json_in.to_clob(temp_clob, FALSE);
  RETURN unistr_clob(temp_clob);
END json_clob;
