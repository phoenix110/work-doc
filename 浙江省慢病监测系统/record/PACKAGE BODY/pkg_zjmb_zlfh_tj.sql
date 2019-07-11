CREATE OR REPLACE PACKAGE BODY pkg_zjmb_zlfh_tj AS
  --初始化包序号--
  /******************************************************************************/
  /*  程序包名 ：pkg_zjmb_zlfh                                                  */
  /*  业务环节 ：浙江慢病_初随访_质量复核                                       */
  /*  功能描述 ：初随访质量复核的存储过程及函数                                 */
  /*                                                                            */
  /*  作    者 ：yuanruiqing  作成日期 ：2018-11-15   版本编号 ：Ver 1.0.0      */
  /*----------------------------------------------------------------------------*/
  /*  修改记录 ：                                                               */
  /******************************************************************************/
  /*----------------------------------------------------------------------------*/
  /*----------------------------------------------------------------------------*/
  /*-----------------------------------------------------------------------------
  || 功能描述 ：慢性病监测住院事件核查汇总
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_zy_mb_tj(data_in    IN CLOB, --入参
                         result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err  VARCHAR2(2000);
    v_bgdw   zjjk_mb_zlfh.id%TYPE; --ID
  
    --公共变量
    v_sysdate DATE;
    v_czyjgjb VARCHAR2(3);
    v_czyjgdm VARCHAR2(50);
    v_czyyhid VARCHAR2(50);
    v_czyyhxm VARCHAR2(50);
    v_count   NUMBER;
  
  BEGIN
    json_data(data_in, '慢性病监测住院事件核查汇总', v_json_data);
    v_sysdate := SYSDATE;
    v_czyjgdm := json_str(v_json_data, 'czyjgdm');
    v_czyyhid := json_str(v_json_data, 'czyyhid');
    v_czyjgjb := json_str(v_json_data, 'czyjgjb');
    v_czyyhxm := json_str(v_json_data, 'czyyhxm');
		
    v_bgdw   := json_str(v_json_data, 'v_bgdw');

    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_zy_mb_tj;
	
	
  /*-----------------------------------------------------------------------------
  || 功能描述 ：死因监测初访信息汇总
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_cf_sw_tj(data_in    IN CLOB, --入参
                         result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err  VARCHAR2(2000);
    v_id   zjjk_mb_zlfh.id%TYPE; --ID
    v_shzt zjjk_mb_zlfh.fhzt%TYPE; --ID
    v_shyj zjjk_mb_zlfh.shyj%TYPE; --复核意见
  
    --公共变量
    v_sysdate DATE;
    v_czyjgjb VARCHAR2(3);
    v_czyjgdm VARCHAR2(50);
    v_czyyhid VARCHAR2(50);
    v_czyyhxm VARCHAR2(50);
    v_count   NUMBER;
  
  BEGIN
    json_data(data_in, '慢性病随访病例审核', v_json_data);
    v_sysdate := SYSDATE;
    v_czyjgdm := json_str(v_json_data, 'czyjgdm');
    v_czyyhid := json_str(v_json_data, 'czyyhid');
    v_czyjgjb := json_str(v_json_data, 'czyjgjb');
    v_czyyhxm := json_str(v_json_data, 'czyyhxm');
  
    v_id   := json_str(v_json_data, 'id');
    v_shzt := json_str(v_json_data, 'fhzt');
    v_shyj := json_str(v_json_data, 'shyj');
    IF v_id IS NULL THEN
      v_err := 'id不能为空!';
      RAISE err_custom;
    END IF;
    IF nvl(v_shzt, '-1') NOT IN ('5', '6') THEN
      v_err := '审核状态传入有误!';
      RAISE err_custom;
    END IF;
    --更新状态
    UPDATE zjjk_csf_zlfh a
       SET a.fhzt    = v_shzt,
           a.shczrid = v_czyyhid,
           a.shczrxm = v_czyyhxm,
           a.shjgid  = v_czyjgdm,
           a.shsj    = v_sysdate,
           a.shyj    = v_shyj
     WHERE a.fhzt = '3'
       AND a.id = v_id
       AND a.csflx = '2'
       AND a.zt = '1';
    IF SQL%ROWCOUNT <> 1 THEN
      v_err := '更新病例审核状态出错!';
      RAISE err_custom;
    END IF;
    UPDATE zjjk_sf_zlfh_mxbjc a SET a.fhzt = v_shzt WHERE a.id = v_id;
  
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_cf_sw_tj;
	
	
  /*-----------------------------------------------------------------------------
  || 功能描述 ：慢性病监测初访信息汇总
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_cf_mb_tj(data_in    IN CLOB, --入参
                         result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err  VARCHAR2(2000);
    v_id   zjjk_mb_zlfh.id%TYPE; --ID
    v_shzt zjjk_mb_zlfh.fhzt%TYPE; --ID
    v_shyj zjjk_mb_zlfh.shyj%TYPE; --复核意见
  
    --公共变量
    v_sysdate DATE;
    v_czyjgjb VARCHAR2(3);
    v_czyjgdm VARCHAR2(50);
    v_czyyhid VARCHAR2(50);
    v_czyyhxm VARCHAR2(50);
    v_count   NUMBER;
  
  BEGIN
    json_data(data_in, '慢性病随访病例审核', v_json_data);
    v_sysdate := SYSDATE;
    v_czyjgdm := json_str(v_json_data, 'czyjgdm');
    v_czyyhid := json_str(v_json_data, 'czyyhid');
    v_czyjgjb := json_str(v_json_data, 'czyjgjb');
    v_czyyhxm := json_str(v_json_data, 'czyyhxm');
  
    v_id   := json_str(v_json_data, 'id');
    v_shzt := json_str(v_json_data, 'fhzt');
    v_shyj := json_str(v_json_data, 'shyj');
    IF v_id IS NULL THEN
      v_err := 'id不能为空!';
      RAISE err_custom;
    END IF;
    IF nvl(v_shzt, '-1') NOT IN ('5', '6') THEN
      v_err := '审核状态传入有误!';
      RAISE err_custom;
    END IF;
    --更新状态
    UPDATE zjjk_csf_zlfh a
       SET a.fhzt    = v_shzt,
           a.shczrid = v_czyyhid,
           a.shczrxm = v_czyyhxm,
           a.shjgid  = v_czyjgdm,
           a.shsj    = v_sysdate,
           a.shyj    = v_shyj
     WHERE a.fhzt = '3'
       AND a.id = v_id
       AND a.csflx = '2'
       AND a.zt = '1';
    IF SQL%ROWCOUNT <> 1 THEN
      v_err := '更新病例审核状态出错!';
      RAISE err_custom;
    END IF;
    UPDATE zjjk_sf_zlfh_mxbjc a SET a.fhzt = v_shzt WHERE a.id = v_id;
  
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_cf_mb_tj;

  /*-----------------------------------------------------------------------------
  || 功能描述 ：慢性病监测随访信息汇总
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_sf_mb_tj(data_in    IN CLOB, --入参
                         result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err  VARCHAR2(2000);
    v_id   zjjk_mb_zlfh.id%TYPE; --ID
    v_shzt zjjk_mb_zlfh.fhzt%TYPE; --ID
    v_shyj zjjk_mb_zlfh.shyj%TYPE; --复核意见
  
    --公共变量
    v_sysdate DATE;
    v_czyjgjb VARCHAR2(3);
    v_czyjgdm VARCHAR2(50);
    v_czyyhid VARCHAR2(50);
    v_czyyhxm VARCHAR2(50);
    v_count   NUMBER;
  
  BEGIN
    json_data(data_in, '慢性病随访病例审核', v_json_data);
    v_sysdate := SYSDATE;
    v_czyjgdm := json_str(v_json_data, 'czyjgdm');
    v_czyyhid := json_str(v_json_data, 'czyyhid');
    v_czyjgjb := json_str(v_json_data, 'czyjgjb');
    v_czyyhxm := json_str(v_json_data, 'czyyhxm');
  
    v_id   := json_str(v_json_data, 'id');
    v_shzt := json_str(v_json_data, 'fhzt');
    v_shyj := json_str(v_json_data, 'shyj');
    IF v_id IS NULL THEN
      v_err := 'id不能为空!';
      RAISE err_custom;
    END IF;
    IF nvl(v_shzt, '-1') NOT IN ('5', '6') THEN
      v_err := '审核状态传入有误!';
      RAISE err_custom;
    END IF;
    --更新状态
    UPDATE zjjk_csf_zlfh a
       SET a.fhzt    = v_shzt,
           a.shczrid = v_czyyhid,
           a.shczrxm = v_czyyhxm,
           a.shjgid  = v_czyjgdm,
           a.shsj    = v_sysdate,
           a.shyj    = v_shyj
     WHERE a.fhzt = '3'
       AND a.id = v_id
       AND a.csflx = '2'
       AND a.zt = '1';
    IF SQL%ROWCOUNT <> 1 THEN
      v_err := '更新病例审核状态出错!';
      RAISE err_custom;
    END IF;
    UPDATE zjjk_sf_zlfh_mxbjc a SET a.fhzt = v_shzt WHERE a.id = v_id;
  
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_sf_mb_tj;
END pkg_zjmb_zlfh_tj;
