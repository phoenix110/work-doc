CREATE OR REPLACE FUNCTION return_succ_clob(json_in json) RETURN CLOB IS
  v_json json;
BEGIN
  v_json := json_in;
  v_json.put('code', '1');
  v_json.put('msg', '成功');
  RETURN json_clob(v_json);
END;
