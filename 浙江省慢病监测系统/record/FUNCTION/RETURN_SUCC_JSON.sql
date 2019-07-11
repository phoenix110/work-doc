CREATE OR REPLACE FUNCTION return_succ_json(json_in json,
                                            msg_in  IN VARCHAR2 := NULL)
  RETURN VARCHAR2 IS
  v_json json;
BEGIN
  v_json := json_in;
  v_json.put('code', '1');
  v_json.put('msg', msg_in);
  RETURN unistr_str(v_json.to_char);
END return_succ_json;
