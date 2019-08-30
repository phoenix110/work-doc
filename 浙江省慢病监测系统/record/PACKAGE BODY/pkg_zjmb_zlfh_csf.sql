CREATE OR REPLACE PACKAGE BODY pkg_zjmb_zlfh_csf AS
  --初始化包序号--
  /******************************************************************************/
  /*  程序包名 ：pkg_zjmb_zlfh_csf                                              */
  /*  业务环节 ：浙江慢病_初随访_质量复核                                       */
  /*  功能描述 ：初随访质量复核的存储过程及函数                                 */
  /*                                                                            */
  /*  作    者 ：yuanruiqing  作成日期 ：2018-11-27   版本编号 ：Ver 1.0.0      */
  /*----------------------------------------------------------------------------*/
  /*  修改记录 ：                                                               */
  /******************************************************************************/
  /*----------------------------------------------------------------------------*/
  /*----------------------------------------------------------------------------*/
  /*----------------------------------------------------------------------------
  || 功能描述 ：脑卒中初随访病例抽查
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_csfcc_ncz_update(data_in    IN CLOB, --入参
                                 result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
  
    --公共变量
    v_sysdate DATE;
    v_czyjgjb VARCHAR2(3);
    v_czyjgdm VARCHAR2(50);
    v_czyyhid VARCHAR2(50);
    v_czyyhxm VARCHAR2(50);
    v_count   NUMBER;
    v_ccts    NUMBER;
  
    v_id      zjjk_csf_zlfh.id%TYPE; --ID
    v_sfkid   zjjk_csf_zlfh.sfkid%TYPE; --报告卡ID
    v_cctjid  zjjk_csf_zlfh.cctjid%TYPE; --抽查条件ID
    v_csflx   zjjk_csf_zlfh.csflx%TYPE; --初随访类型:1-初访 2-随访
    v_bllx    zjjk_csf_zlfh.bllx%TYPE; --病例类型:1-脑卒中 2-冠心病 3-糖尿病 4-恶性 5-死亡
    v_ccczrid zjjk_csf_zlfh.ccczrid%TYPE; --抽查操作人id
    v_ccczrxm zjjk_csf_zlfh.ccczrxm%TYPE; --抽查操作人姓名
    v_ccjgid  zjjk_csf_zlfh.ccjgid%TYPE; --抽查机构id
    v_ccsj    zjjk_csf_zlfh.ccsj%TYPE; --抽查时间
    v_fhczrid zjjk_csf_zlfh.fhczrid%TYPE; --复核操作人id
    v_fhczrxm zjjk_csf_zlfh.fhczrxm%TYPE; --复核操作人姓名
    v_fhjgid  zjjk_csf_zlfh.fhjgid%TYPE; --复核机构id
    v_fhzt    zjjk_csf_zlfh.fhzt%TYPE; --复核状态:0-未开始 1-进行中 2-待复核 3-复核通过 4-复核不通过 5-审核通过 6-审核不通过
    v_fhsj    zjjk_csf_zlfh.fhsj%TYPE; --复核时间
    v_shczrid zjjk_csf_zlfh.shczrid%TYPE; --审核操作人id
    v_shczrxm zjjk_csf_zlfh.shczrxm%TYPE; --审核操作人姓名
    v_shjgid  zjjk_csf_zlfh.shjgid%TYPE; --审核机构id
    v_shsj    zjjk_csf_zlfh.shsj%TYPE; --审核时间
    v_zt      zjjk_csf_zlfh.zt%TYPE; --抽查状态（1:正常，0:作废）
    v_fhbz    zjjk_csf_zlfh.fhbz%TYPE; --复核标志：0-未填写数据 1-已填写数据
    v_bccjgid VARCHAR2(4000); --被抽查机构id
    v_fhyj    zjjk_csf_zlfh.fhyj%TYPE; --复核意见
    v_shyj    zjjk_csf_zlfh.shyj%TYPE; --审核意见
  
    --其他变量
    v_sfkid_s VARCHAR2(2000); --被抽查的报告卡IDs
  
  BEGIN
    json_data(data_in, '脑卒中随访病例抽查', v_json_data);
    v_sysdate := SYSDATE;
    v_czyjgdm := json_str(v_json_data, 'czyjgdm');
    v_czyyhid := json_str(v_json_data, 'czyyhid');
    v_czyjgjb := json_str(v_json_data, 'czyjgjb');
    v_czyyhxm := json_str(v_json_data, 'czyyhxm');
  
    v_id      := json_str(v_json_data, 'id');
    v_sfkid   := json_str(v_json_data, 'sfkid');
    v_cctjid  := json_str(v_json_data, 'cctjid');
    v_csflx   := json_str(v_json_data, 'csflx');
    v_bllx    := json_str(v_json_data, 'bllx');
    v_ccczrid := json_str(v_json_data, 'ccczrid');
    v_ccczrxm := json_str(v_json_data, 'ccczrxm');
    v_ccjgid  := json_str(v_json_data, 'ccjgid');
    v_ccsj    := json_str(v_json_data, 'ccsj');
    v_fhczrid := json_str(v_json_data, 'fhczrid');
    v_fhczrxm := json_str(v_json_data, 'fhczrxm');
    v_fhjgid  := json_str(v_json_data, 'fhjgid');
    v_fhzt    := json_str(v_json_data, 'fhzt');
    v_fhsj    := json_str(v_json_data, 'fhsj');
    v_shczrid := json_str(v_json_data, 'shczrid');
    v_shczrxm := json_str(v_json_data, 'shczrxm');
    v_shjgid  := json_str(v_json_data, 'shjgid');
    v_shsj    := json_str(v_json_data, 'shsj');
    v_zt      := json_str(v_json_data, 'zt');
    v_fhbz    := json_str(v_json_data, 'fhbz');
    v_bccjgid := json_str(v_json_data, 'bccjgid');
    v_fhyj    := json_str(v_json_data, 'fhyj');
    v_shyj    := json_str(v_json_data, 'shyj');
    v_sfkid_s := json_str(v_json_data, 'sfkid_s');
  
    --校验必填项目
    IF v_sfkid_s IS NULL THEN
      v_err := '报告卡ID不能为空!';
      RAISE err_custom;
    END IF;
    IF v_cctjid IS NULL THEN
      v_err := '抽查条件ID不能为空!';
      RAISE err_custom;
    END IF;
    --如果抽查区县
    IF v_bccjgid IS NULL THEN
      SELECT wm_concat((SELECT bgk.vc_bkdwyy
                         FROM zjjk_xnxg_bgk bgk
                        WHERE bgk.vc_bgkid = sfk.vc_bgkid))
        INTO v_bccjgid
        FROM zjjk_xnxg_sfk sfk
       WHERE v_sfkid_s LIKE '%' || sfk.vc_sfkid || '%';
      --v_err := '被抽查机构不能为空!';
      --raise err_custom;
    END IF;
    IF v_csflx IS NULL THEN
      v_err := '初随访类型不能为空!';
      RAISE err_custom;
    END IF;
    --校验权限
    IF v_czyjgjb <> '3' THEN
      --非区县
      v_err := '当前机构无抽查权限!';
      RAISE err_custom;
    END IF;
  
    --校验是否已病例复核
    SELECT COUNT(1)
      INTO v_count
      FROM zjjk_csf_zlfh a
     WHERE a.cctjid = v_cctjid
       AND v_bccjgid LIKE '%' || bccjgid || '%'
       AND zt = '1'
       AND fhbz = '1'
       AND a.bllx = '1'
       AND a.csflx = v_csflx;
    IF v_count > 0 THEN
      v_err := '该次抽查已存在病例复核记录!';
      RAISE err_custom;
    END IF;
    --删除未复核病例，重新生成
    UPDATE zjjk_csf_zlfh a
       SET a.zt = '0'
     WHERE a.cctjid = v_cctjid
       AND v_bccjgid LIKE '%' || bccjgid || '%'
       AND zt = '1'
       AND fhbz = '0'
       AND a.bllx = '2'
       AND a.csflx = v_csflx;
    --获取抽查条数的条件
    IF v_csflx = '1' THEN
      SELECT ccts INTO v_ccts FROM zjjk_zlfhsj_cf a WHERE a.zt = 1;
    ELSIF v_csflx = '2' THEN
      SELECT ccts INTO v_ccts FROM zjjk_zlfhsj_sf a WHERE a.zt = 1;
    END IF;
    --校验sfkid合法性
/*    SELECT MIN(COUNT(b.vc_bkdwyy))
      INTO v_count
      FROM zjjk_xnxg_sfk a, zjjk_xnxg_bgk b
     WHERE a.vc_bgkid = b.vc_bgkid
       AND a.vc_sfkid IN
           (SELECT DISTINCT column_value column_value
              FROM TABLE(split(v_sfkid_s, ',')))
     GROUP BY b.vc_bkdwyy;
    IF v_count <> v_ccts THEN
      v_err := '本次抽查有医疗机构未找到' || v_ccts || '条脑卒中病例!';
      RAISE err_custom;
    END IF;*/
    --写入质量复核初随访表
    INSERT INTO zjjk_csf_zlfh
      (id,
       sfkid,
       cctjid,
       csflx,
       bllx,
       ccczrid,
       ccczrxm,
       ccjgid,
       ccsj,
       zt,
       fhbz,
       fhzt,
       bccjgid,
       ccxh)
      SELECT DISTINCT sys_guid(),
                      column_value,
                      v_cctjid,
                      v_csflx,
                      '1',
                      v_czyyhid,
                      v_czyyhxm,
                      v_czyjgdm,
                      v_sysdate,
                      '1',
                      '0',
                      '0',
                      v_bccjgid,
                      rownum
        FROM TABLE(split(v_sfkid_s, ','));
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_csfcc_ncz_update;
  /*----------------------------------------------------------------------------
  || 功能描述 ：冠心病初随访病例抽查
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_csfcc_gxb_update(data_in    IN CLOB, --入参
                                 result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
  
    --公共变量
    v_sysdate DATE;
    v_czyjgjb VARCHAR2(3);
    v_czyjgdm VARCHAR2(50);
    v_czyyhid VARCHAR2(50);
    v_czyyhxm VARCHAR2(50);
    v_count   NUMBER;
    v_ccts    NUMBER;
  
    v_id      zjjk_csf_zlfh.id%TYPE; --ID
    v_sfkid   zjjk_csf_zlfh.sfkid%TYPE; --报告卡ID
    v_cctjid  zjjk_csf_zlfh.cctjid%TYPE; --抽查条件ID
    v_csflx   zjjk_csf_zlfh.csflx%TYPE; --初随访类型:1-初访 2-随访
    v_bllx    zjjk_csf_zlfh.bllx%TYPE; --病例类型:1-脑卒中 2-冠心病 3-糖尿病 4-恶性 5-死亡
    v_ccczrid zjjk_csf_zlfh.ccczrid%TYPE; --抽查操作人id
    v_ccczrxm zjjk_csf_zlfh.ccczrxm%TYPE; --抽查操作人姓名
    v_ccjgid  zjjk_csf_zlfh.ccjgid%TYPE; --抽查机构id
    v_ccsj    zjjk_csf_zlfh.ccsj%TYPE; --抽查时间
    v_fhczrid zjjk_csf_zlfh.fhczrid%TYPE; --复核操作人id
    v_fhczrxm zjjk_csf_zlfh.fhczrxm%TYPE; --复核操作人姓名
    v_fhjgid  zjjk_csf_zlfh.fhjgid%TYPE; --复核机构id
    v_fhzt    zjjk_csf_zlfh.fhzt%TYPE; --复核状态:0-未开始 1-进行中 2-待复核 3-复核通过 4-复核不通过 5-审核通过 6-审核不通过
    v_fhsj    zjjk_csf_zlfh.fhsj%TYPE; --复核时间
    v_shczrid zjjk_csf_zlfh.shczrid%TYPE; --审核操作人id
    v_shczrxm zjjk_csf_zlfh.shczrxm%TYPE; --审核操作人姓名
    v_shjgid  zjjk_csf_zlfh.shjgid%TYPE; --审核机构id
    v_shsj    zjjk_csf_zlfh.shsj%TYPE; --审核时间
    v_zt      zjjk_csf_zlfh.zt%TYPE; --抽查状态（1:正常，0:作废）
    v_fhbz    zjjk_csf_zlfh.fhbz%TYPE; --复核标志：0-未填写数据 1-已填写数据
    v_bccjgid VARCHAR2(4000); --被抽查机构id
    v_fhyj    zjjk_csf_zlfh.fhyj%TYPE; --复核意见
    v_shyj    zjjk_csf_zlfh.shyj%TYPE; --审核意见
  
    --其他变量
    v_sfkid_s VARCHAR2(2000); --被抽查的报告卡IDs
  
  BEGIN
    json_data(data_in, '冠心病初随访病例抽查', v_json_data);
    v_sysdate := SYSDATE;
    v_czyjgdm := json_str(v_json_data, 'czyjgdm');
    v_czyyhid := json_str(v_json_data, 'czyyhid');
    v_czyjgjb := json_str(v_json_data, 'czyjgjb');
    v_czyyhxm := json_str(v_json_data, 'czyyhxm');
  
    v_id      := json_str(v_json_data, 'id');
    v_sfkid   := json_str(v_json_data, 'sfkid');
    v_cctjid  := json_str(v_json_data, 'cctjid');
    v_csflx   := json_str(v_json_data, 'csflx');
    v_bllx    := json_str(v_json_data, 'bllx');
    v_ccczrid := json_str(v_json_data, 'ccczrid');
    v_ccczrxm := json_str(v_json_data, 'ccczrxm');
    v_ccjgid  := json_str(v_json_data, 'ccjgid');
    v_ccsj    := json_str(v_json_data, 'ccsj');
    v_fhczrid := json_str(v_json_data, 'fhczrid');
    v_fhczrxm := json_str(v_json_data, 'fhczrxm');
    v_fhjgid  := json_str(v_json_data, 'fhjgid');
    v_fhzt    := json_str(v_json_data, 'fhzt');
    v_fhsj    := json_str(v_json_data, 'fhsj');
    v_shczrid := json_str(v_json_data, 'shczrid');
    v_shczrxm := json_str(v_json_data, 'shczrxm');
    v_shjgid  := json_str(v_json_data, 'shjgid');
    v_shsj    := json_str(v_json_data, 'shsj');
    v_zt      := json_str(v_json_data, 'zt');
    v_fhbz    := json_str(v_json_data, 'fhbz');
    v_bccjgid := json_str(v_json_data, 'bccjgid');
    v_fhyj    := json_str(v_json_data, 'fhyj');
    v_shyj    := json_str(v_json_data, 'shyj');
    v_sfkid_s := json_str(v_json_data, 'sfkid_s');
  
    --校验必填项目
    IF v_sfkid_s IS NULL THEN
      v_err := '报告卡ID不能为空!';
      RAISE err_custom;
    END IF;
    IF v_cctjid IS NULL THEN
      v_err := '抽查条件ID不能为空!';
      RAISE err_custom;
    END IF;
    --如果抽查区县
    IF v_bccjgid IS NULL THEN
      SELECT wm_concat((SELECT bgk.vc_bkdwyy
                         FROM zjjk_xnxg_bgk bgk
                        WHERE bgk.vc_bgkid = sfk.vc_bgkid))
        INTO v_bccjgid
        FROM zjjk_xnxg_sfk sfk
       WHERE v_sfkid_s LIKE '%' || sfk.vc_sfkid || '%';
      --v_err := '被抽查机构不能为空!';
      --raise err_custom;
    END IF;
    IF v_csflx IS NULL THEN
      v_err := '初随访类型不能为空!';
      RAISE err_custom;
    END IF;
    --校验权限
    IF v_czyjgjb <> '3' THEN
      --非区县
      v_err := '当前机构无抽查权限!';
      RAISE err_custom;
    END IF;
  
    --校验是否已病例复核
    SELECT COUNT(1)
      INTO v_count
      FROM zjjk_csf_zlfh a
     WHERE a.cctjid = v_cctjid
       AND v_bccjgid LIKE '%' || bccjgid || '%'
       AND zt = '1'
       AND fhbz = '1'
       AND a.bllx = '2'
       AND a.csflx = v_csflx;
    IF v_count > 0 THEN
      v_err := '该次抽查已存在病例复核记录!';
      RAISE err_custom;
    END IF;
    --删除未复核病例，重新生成
    UPDATE zjjk_csf_zlfh a
       SET a.zt = '0'
     WHERE a.cctjid = v_cctjid
       AND v_bccjgid LIKE '%' || bccjgid || '%'
       AND zt = '1'
       AND fhbz = '0'
       AND a.bllx = '2'
       AND a.csflx = v_csflx;
    --获取抽查条数的条件
    IF v_csflx = '1' THEN
      SELECT ccts INTO v_ccts FROM zjjk_zlfhsj_cf a WHERE a.zt = 1;
    ELSIF v_csflx = '2' THEN
      SELECT ccts INTO v_ccts FROM zjjk_zlfhsj_sf a WHERE a.zt = 1;
    END IF;
    --校验sfkid合法性
/*    SELECT MIN(COUNT(b.vc_bkdwyy))
      INTO v_count
      FROM zjjk_xnxg_sfk a, zjjk_xnxg_bgk b
     WHERE a.vc_bgkid = b.vc_bgkid
       AND a.vc_sfkid IN
           (SELECT DISTINCT column_value column_value
              FROM TABLE(split(v_sfkid_s, ',')))
     GROUP BY b.vc_bkdwyy;
    IF v_count <> v_ccts THEN
      v_err := '本次抽查有医疗机构未找到' || v_ccts || '条冠心病病例!';
      RAISE err_custom;
    END IF;*/
    --写入质量复核初随访表
    INSERT INTO zjjk_csf_zlfh
      (id,
       sfkid,
       cctjid,
       csflx,
       bllx,
       ccczrid,
       ccczrxm,
       ccjgid,
       ccsj,
       zt,
       fhbz,
       fhzt,
       bccjgid,
       ccxh)
      SELECT DISTINCT sys_guid(),
                      column_value,
                      v_cctjid,
                      v_csflx,
                      '2',
                      v_czyyhid,
                      v_czyyhxm,
                      v_czyjgdm,
                      v_sysdate,
                      '1',
                      '0',
                      '0',
                      v_bccjgid,
                      rownum
        FROM TABLE(split(v_sfkid_s, ','));
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_csfcc_gxb_update;
  /*----------------------------------------------------------------------------
  || 功能描述 ：糖尿病初随访病例抽查
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_csfcc_tnb_update(data_in    IN CLOB, --入参
                                 result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
  
    --公共变量
    v_sysdate DATE;
    v_czyjgjb VARCHAR2(3);
    v_czyjgdm VARCHAR2(50);
    v_czyyhid VARCHAR2(50);
    v_czyyhxm VARCHAR2(50);
    v_count   NUMBER;
    v_ccts    NUMBER;
  
    v_id      zjjk_csf_zlfh.id%TYPE; --ID
    v_sfkid   zjjk_csf_zlfh.sfkid%TYPE; --报告卡ID
    v_cctjid  zjjk_csf_zlfh.cctjid%TYPE; --抽查条件ID
    v_csflx   zjjk_csf_zlfh.csflx%TYPE; --初随访类型:1-初访 2-随访
    v_bllx    zjjk_csf_zlfh.bllx%TYPE; --病例类型:1-脑卒中 2-冠心病 3-糖尿病 4-恶性 5-死亡
    v_ccczrid zjjk_csf_zlfh.ccczrid%TYPE; --抽查操作人id
    v_ccczrxm zjjk_csf_zlfh.ccczrxm%TYPE; --抽查操作人姓名
    v_ccjgid  zjjk_csf_zlfh.ccjgid%TYPE; --抽查机构id
    v_ccsj    zjjk_csf_zlfh.ccsj%TYPE; --抽查时间
    v_fhczrid zjjk_csf_zlfh.fhczrid%TYPE; --复核操作人id
    v_fhczrxm zjjk_csf_zlfh.fhczrxm%TYPE; --复核操作人姓名
    v_fhjgid  zjjk_csf_zlfh.fhjgid%TYPE; --复核机构id
    v_fhzt    zjjk_csf_zlfh.fhzt%TYPE; --复核状态:0-未开始 1-进行中 2-待复核 3-复核通过 4-复核不通过 5-审核通过 6-审核不通过
    v_fhsj    zjjk_csf_zlfh.fhsj%TYPE; --复核时间
    v_shczrid zjjk_csf_zlfh.shczrid%TYPE; --审核操作人id
    v_shczrxm zjjk_csf_zlfh.shczrxm%TYPE; --审核操作人姓名
    v_shjgid  zjjk_csf_zlfh.shjgid%TYPE; --审核机构id
    v_shsj    zjjk_csf_zlfh.shsj%TYPE; --审核时间
    v_zt      zjjk_csf_zlfh.zt%TYPE; --抽查状态（1:正常，0:作废）
    v_fhbz    zjjk_csf_zlfh.fhbz%TYPE; --复核标志：0-未填写数据 1-已填写数据
    v_bccjgid VARCHAR2(4000); --被抽查机构id
    v_fhyj    zjjk_csf_zlfh.fhyj%TYPE; --复核意见
    v_shyj    zjjk_csf_zlfh.shyj%TYPE; --审核意见
  
    --其他变量
    v_sfkid_s VARCHAR2(2000); --被抽查的报告卡IDs
  
  BEGIN
    json_data(data_in, '糖尿病初随访病例抽查', v_json_data);
    v_sysdate := SYSDATE;
    v_czyjgdm := json_str(v_json_data, 'czyjgdm');
    v_czyyhid := json_str(v_json_data, 'czyyhid');
    v_czyjgjb := json_str(v_json_data, 'czyjgjb');
    v_czyyhxm := json_str(v_json_data, 'czyyhxm');
  
    v_id      := json_str(v_json_data, 'id');
    v_sfkid   := json_str(v_json_data, 'sfkid');
    v_cctjid  := json_str(v_json_data, 'cctjid');
    v_csflx   := json_str(v_json_data, 'csflx');
    v_bllx    := json_str(v_json_data, 'bllx');
    v_ccczrid := json_str(v_json_data, 'ccczrid');
    v_ccczrxm := json_str(v_json_data, 'ccczrxm');
    v_ccjgid  := json_str(v_json_data, 'ccjgid');
    v_ccsj    := json_str(v_json_data, 'ccsj');
    v_fhczrid := json_str(v_json_data, 'fhczrid');
    v_fhczrxm := json_str(v_json_data, 'fhczrxm');
    v_fhjgid  := json_str(v_json_data, 'fhjgid');
    v_fhzt    := json_str(v_json_data, 'fhzt');
    v_fhsj    := json_str(v_json_data, 'fhsj');
    v_shczrid := json_str(v_json_data, 'shczrid');
    v_shczrxm := json_str(v_json_data, 'shczrxm');
    v_shjgid  := json_str(v_json_data, 'shjgid');
    v_shsj    := json_str(v_json_data, 'shsj');
    v_zt      := json_str(v_json_data, 'zt');
    v_fhbz    := json_str(v_json_data, 'fhbz');
    v_bccjgid := json_str(v_json_data, 'bccjgid');
    v_fhyj    := json_str(v_json_data, 'fhyj');
    v_shyj    := json_str(v_json_data, 'shyj');
    v_sfkid_s := json_str(v_json_data, 'sfkid_s');
  
    --校验必填项目
    IF v_sfkid_s IS NULL THEN
      v_err := '报告卡ID不能为空!';
      RAISE err_custom;
    END IF;
    IF v_cctjid IS NULL THEN
      v_err := '抽查条件ID不能为空!';
      RAISE err_custom;
    END IF;
    --如果抽查区县
    IF v_bccjgid IS NULL THEN
      SELECT wm_concat((SELECT bgk.vc_bgdw
                         FROM zjjk_tnb_bgk bgk
                        WHERE bgk.vc_bgkid = sfk.vc_bgkid))
        INTO v_bccjgid
        FROM zjjk_tnb_sfk sfk
       WHERE v_sfkid_s LIKE '%' || sfk.vc_sfkid || '%';
      --v_err := '被抽查机构不能为空!';
      --raise err_custom;
    END IF;
    IF v_csflx IS NULL THEN
      v_err := '初随访类型不能为空!';
      RAISE err_custom;
    END IF;
    --校验权限
    IF v_czyjgjb <> '3' THEN
      --非区县
      v_err := '当前机构无抽查权限!';
      RAISE err_custom;
    END IF;
  
    --校验是否已病例复核
    SELECT COUNT(1)
      INTO v_count
      FROM zjjk_csf_zlfh a
     WHERE a.cctjid = v_cctjid
       AND v_bccjgid LIKE '%' || bccjgid || '%'
       AND zt = '1'
       AND fhbz = '1'
       AND a.bllx = '3'
       AND a.csflx = v_csflx;
    IF v_count > 0 THEN
      v_err := '该次抽查已存在病例复核记录!';
      RAISE err_custom;
    END IF;
    --删除未复核病例，重新生成
    UPDATE zjjk_csf_zlfh a
       SET a.zt = '0'
     WHERE a.cctjid = v_cctjid
       AND v_bccjgid LIKE '%' || bccjgid || '%'
       AND zt = '1'
       AND fhbz = '0'
       AND a.bllx = '3'
       AND a.csflx = v_csflx;
    --获取抽查条数的条件
    IF v_csflx = '1' THEN
      SELECT ccts INTO v_ccts FROM zjjk_zlfhsj_cf a WHERE a.zt = 1;
    ELSIF v_csflx = '2' THEN
      SELECT ccts INTO v_ccts FROM zjjk_zlfhsj_sf a WHERE a.zt = 1;
    END IF;
    --校验sfkid合法性
/*    SELECT MIN(COUNT(b.vc_bgdw))
      INTO v_count
      FROM zjjk_tnb_sfk a, zjjk_tnb_bgk b
     WHERE a.vc_bgkid = b.vc_bgkid
       AND a.vc_sfkid IN
           (SELECT DISTINCT column_value column_value
              FROM TABLE(split(v_sfkid_s, ',')))
     GROUP BY b.vc_bgdw;
    IF v_count <> v_ccts THEN
      v_err := '本次抽查有医疗机构未找到' || v_ccts || '条糖尿病病例!';
      RAISE err_custom;
    END IF;*/
    --写入质量复核初随访表
    INSERT INTO zjjk_csf_zlfh
      (id,
       sfkid,
       cctjid,
       csflx,
       bllx,
       ccczrid,
       ccczrxm,
       ccjgid,
       ccsj,
       zt,
       fhbz,
       fhzt,
       bccjgid,
       ccxh)
      SELECT DISTINCT sys_guid(),
                      column_value,
                      v_cctjid,
                      v_csflx,
                      '3',
                      v_czyyhid,
                      v_czyyhxm,
                      v_czyjgdm,
                      v_sysdate,
                      '1',
                      '0',
                      '0',
                      v_bccjgid,
                      rownum
        FROM TABLE(split(v_sfkid_s, ','));
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_csfcc_tnb_update;
  /*----------------------------------------------------------------------------
  || 功能描述 ：糖尿病初随访病例抽查
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_csfcc_zl_update(data_in    IN CLOB, --入参
                                result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
  
    --公共变量
    v_sysdate DATE;
    v_czyjgjb VARCHAR2(3);
    v_czyjgdm VARCHAR2(50);
    v_czyyhid VARCHAR2(50);
    v_czyyhxm VARCHAR2(50);
    v_count   NUMBER;
    v_ccts    NUMBER;
  
    v_id      zjjk_csf_zlfh.id%TYPE; --ID
    v_sfkid   zjjk_csf_zlfh.sfkid%TYPE; --报告卡ID
    v_cctjid  zjjk_csf_zlfh.cctjid%TYPE; --抽查条件ID
    v_csflx   zjjk_csf_zlfh.csflx%TYPE; --初随访类型:1-初访 2-随访
    v_bllx    zjjk_csf_zlfh.bllx%TYPE; --病例类型:1-脑卒中 2-冠心病 3-糖尿病 4-恶性 5-死亡
    v_ccczrid zjjk_csf_zlfh.ccczrid%TYPE; --抽查操作人id
    v_ccczrxm zjjk_csf_zlfh.ccczrxm%TYPE; --抽查操作人姓名
    v_ccjgid  zjjk_csf_zlfh.ccjgid%TYPE; --抽查机构id
    v_ccsj    zjjk_csf_zlfh.ccsj%TYPE; --抽查时间
    v_fhczrid zjjk_csf_zlfh.fhczrid%TYPE; --复核操作人id
    v_fhczrxm zjjk_csf_zlfh.fhczrxm%TYPE; --复核操作人姓名
    v_fhjgid  zjjk_csf_zlfh.fhjgid%TYPE; --复核机构id
    v_fhzt    zjjk_csf_zlfh.fhzt%TYPE; --复核状态:0-未开始 1-进行中 2-待复核 3-复核通过 4-复核不通过 5-审核通过 6-审核不通过
    v_fhsj    zjjk_csf_zlfh.fhsj%TYPE; --复核时间
    v_shczrid zjjk_csf_zlfh.shczrid%TYPE; --审核操作人id
    v_shczrxm zjjk_csf_zlfh.shczrxm%TYPE; --审核操作人姓名
    v_shjgid  zjjk_csf_zlfh.shjgid%TYPE; --审核机构id
    v_shsj    zjjk_csf_zlfh.shsj%TYPE; --审核时间
    v_zt      zjjk_csf_zlfh.zt%TYPE; --抽查状态（1:正常，0:作废）
    v_fhbz    zjjk_csf_zlfh.fhbz%TYPE; --复核标志：0-未填写数据 1-已填写数据
    v_bccjgid VARCHAR2(4000); --被抽查机构id
    v_fhyj    zjjk_csf_zlfh.fhyj%TYPE; --复核意见
    v_shyj    zjjk_csf_zlfh.shyj%TYPE; --审核意见
  
    --其他变量
    v_sfkid_s VARCHAR2(2000); --被抽查的报告卡IDs
  
  BEGIN
    json_data(data_in, '肿瘤初随访病例抽查', v_json_data);
    v_sysdate := SYSDATE;
    v_czyjgdm := json_str(v_json_data, 'czyjgdm');
    v_czyyhid := json_str(v_json_data, 'czyyhid');
    v_czyjgjb := json_str(v_json_data, 'czyjgjb');
    v_czyyhxm := json_str(v_json_data, 'czyyhxm');
  
    v_id      := json_str(v_json_data, 'id');
    v_sfkid   := json_str(v_json_data, 'sfkid');
    v_cctjid  := json_str(v_json_data, 'cctjid');
    v_csflx   := json_str(v_json_data, 'csflx');
    v_bllx    := json_str(v_json_data, 'bllx');
    v_ccczrid := json_str(v_json_data, 'ccczrid');
    v_ccczrxm := json_str(v_json_data, 'ccczrxm');
    v_ccjgid  := json_str(v_json_data, 'ccjgid');
    v_ccsj    := json_str(v_json_data, 'ccsj');
    v_fhczrid := json_str(v_json_data, 'fhczrid');
    v_fhczrxm := json_str(v_json_data, 'fhczrxm');
    v_fhjgid  := json_str(v_json_data, 'fhjgid');
    v_fhzt    := json_str(v_json_data, 'fhzt');
    v_fhsj    := json_str(v_json_data, 'fhsj');
    v_shczrid := json_str(v_json_data, 'shczrid');
    v_shczrxm := json_str(v_json_data, 'shczrxm');
    v_shjgid  := json_str(v_json_data, 'shjgid');
    v_shsj    := json_str(v_json_data, 'shsj');
    v_zt      := json_str(v_json_data, 'zt');
    v_fhbz    := json_str(v_json_data, 'fhbz');
    v_bccjgid := json_str(v_json_data, 'bccjgid');
    v_fhyj    := json_str(v_json_data, 'fhyj');
    v_shyj    := json_str(v_json_data, 'shyj');
    v_sfkid_s := json_str(v_json_data, 'sfkid_s');
  
    --校验必填项目
    IF v_sfkid_s IS NULL THEN
      v_err := '报告卡ID不能为空!';
      RAISE err_custom;
    END IF;
    IF v_cctjid IS NULL THEN
      v_err := '抽查条件ID不能为空!';
      RAISE err_custom;
    END IF;
    --如果抽查区县
    IF v_bccjgid IS NULL THEN
      SELECT wm_concat((SELECT bgk.vc_bgdw
                         FROM zjjk_zl_bgk bgk
                        WHERE bgk.vc_bgkid = sfk.vc_bgkid))
        INTO v_bccjgid
        FROM zjjk_zl_sfk sfk
       WHERE v_sfkid_s LIKE '%' || sfk.vc_sfkid || '%';
      --v_err := '被抽查机构不能为空!';
      --raise err_custom;
    END IF;
    IF v_csflx IS NULL THEN
      v_err := '初随访类型不能为空!';
      RAISE err_custom;
    END IF;
    --校验权限
    IF v_czyjgjb <> '3' THEN
      --非区县
      v_err := '当前机构无抽查权限!';
      RAISE err_custom;
    END IF;
  
    --校验是否已病例复核
    SELECT COUNT(1)
      INTO v_count
      FROM zjjk_csf_zlfh a
     WHERE a.cctjid = v_cctjid
       AND v_bccjgid LIKE '%' || bccjgid || '%'
       AND zt = '1'
       AND fhbz = '1'
       AND a.bllx = '4'
       AND a.csflx = v_csflx;
    IF v_count > 0 THEN
      v_err := '该次抽查已存在病例复核记录!';
      RAISE err_custom;
    END IF;
    --删除未复核病例，重新生成
    UPDATE zjjk_csf_zlfh a
       SET a.zt = '0'
     WHERE a.cctjid = v_cctjid
       AND v_bccjgid LIKE '%' || bccjgid || '%'
       AND zt = '1'
       AND fhbz = '0'
       AND a.bllx = '4'
       AND a.csflx = v_csflx;
    --获取抽查条数的条件
    IF v_csflx = '1' THEN
      SELECT ccts INTO v_ccts FROM zjjk_zlfhsj_cf a WHERE a.zt = 1;
    ELSIF v_csflx = '2' THEN
      SELECT ccts INTO v_ccts FROM zjjk_zlfhsj_sf a WHERE a.zt = 1;
    END IF;
    --校验sfkid合法性
/*    SELECT MIN(COUNT(b.vc_bgdw))
      INTO v_count
      FROM zjjk_zl_sfk a, zjjk_zl_bgk b
     WHERE a.vc_bgkid = b.vc_bgkid
       AND a.vc_sfkid IN
           (SELECT DISTINCT column_value column_value
              FROM TABLE(split(v_sfkid_s, ',')))
     GROUP BY b.vc_bgdw;
    IF v_count <> v_ccts THEN
      v_err := '本次抽查有医疗机构未找到' || v_ccts || '条肿瘤病例!';
      RAISE err_custom;
    END IF;*/
    --写入质量复核初随访表
    INSERT INTO zjjk_csf_zlfh
      (id,
       sfkid,
       cctjid,
       csflx,
       bllx,
       ccczrid,
       ccczrxm,
       ccjgid,
       ccsj,
       zt,
       fhbz,
       fhzt,
       bccjgid,
       ccxh)
      SELECT DISTINCT sys_guid(),
                      column_value,
                      v_cctjid,
                      v_csflx,
                      '4',
                      v_czyyhid,
                      v_czyyhxm,
                      v_czyjgdm,
                      v_sysdate,
                      '1',
                      '0',
                      '0',
                      v_bccjgid,
                      rownum
        FROM TABLE(split(v_sfkid_s, ','));
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_csfcc_zl_update;
  /*----------------------------------------------------------------------------
  || 功能描述 ：死亡初访病例抽查
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_cfcc_sw_update(data_in    IN CLOB, --入参
                               result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
  
    --公共变量
    v_sysdate DATE;
    v_czyjgjb VARCHAR2(3);
    v_czyjgdm VARCHAR2(50);
    v_czyyhid VARCHAR2(50);
    v_czyyhxm VARCHAR2(50);
    v_count   NUMBER;
    v_ccts    NUMBER;
  
    v_id      zjjk_csf_zlfh.id%TYPE; --ID
    v_sfkid   zjjk_csf_zlfh.sfkid%TYPE; --报告卡ID
    v_cctjid  zjjk_csf_zlfh.cctjid%TYPE; --抽查条件ID
    v_csflx   zjjk_csf_zlfh.csflx%TYPE; --初随访类型:1-初访 2-随访
    v_bllx    zjjk_csf_zlfh.bllx%TYPE; --病例类型:1-脑卒中 2-冠心病 3-糖尿病 4-恶性 5-死亡
    v_ccczrid zjjk_csf_zlfh.ccczrid%TYPE; --抽查操作人id
    v_ccczrxm zjjk_csf_zlfh.ccczrxm%TYPE; --抽查操作人姓名
    v_ccjgid  zjjk_csf_zlfh.ccjgid%TYPE; --抽查机构id
    v_ccsj    zjjk_csf_zlfh.ccsj%TYPE; --抽查时间
    v_fhczrid zjjk_csf_zlfh.fhczrid%TYPE; --复核操作人id
    v_fhczrxm zjjk_csf_zlfh.fhczrxm%TYPE; --复核操作人姓名
    v_fhjgid  zjjk_csf_zlfh.fhjgid%TYPE; --复核机构id
    v_fhzt    zjjk_csf_zlfh.fhzt%TYPE; --复核状态:0-未开始 1-进行中 2-待复核 3-复核通过 4-复核不通过 5-审核通过 6-审核不通过
    v_fhsj    zjjk_csf_zlfh.fhsj%TYPE; --复核时间
    v_shczrid zjjk_csf_zlfh.shczrid%TYPE; --审核操作人id
    v_shczrxm zjjk_csf_zlfh.shczrxm%TYPE; --审核操作人姓名
    v_shjgid  zjjk_csf_zlfh.shjgid%TYPE; --审核机构id
    v_shsj    zjjk_csf_zlfh.shsj%TYPE; --审核时间
    v_zt      zjjk_csf_zlfh.zt%TYPE; --抽查状态（1:正常，0:作废）
    v_fhbz    zjjk_csf_zlfh.fhbz%TYPE; --复核标志：0-未填写数据 1-已填写数据
    v_bccjgid VARCHAR2(4000); --被抽查机构id
    v_fhyj    zjjk_csf_zlfh.fhyj%TYPE; --复核意见
    v_shyj    zjjk_csf_zlfh.shyj%TYPE; --审核意见
  
    --其他变量
    v_sfkid_s VARCHAR2(2000); --被抽查的报告卡IDs
  
  BEGIN
    json_data(data_in, '死亡初访病例抽查', v_json_data);
    v_sysdate := SYSDATE;
    v_czyjgdm := json_str(v_json_data, 'czyjgdm');
    v_czyyhid := json_str(v_json_data, 'czyyhid');
    v_czyjgjb := json_str(v_json_data, 'czyjgjb');
    v_czyyhxm := json_str(v_json_data, 'czyyhxm');
  
    v_id      := json_str(v_json_data, 'id');
    v_sfkid   := json_str(v_json_data, 'sfkid');
    v_cctjid  := json_str(v_json_data, 'cctjid');
    v_csflx   := json_str(v_json_data, 'csflx');
    v_bllx    := json_str(v_json_data, 'bllx');
    v_ccczrid := json_str(v_json_data, 'ccczrid');
    v_ccczrxm := json_str(v_json_data, 'ccczrxm');
    v_ccjgid  := json_str(v_json_data, 'ccjgid');
    v_ccsj    := json_str(v_json_data, 'ccsj');
    v_fhczrid := json_str(v_json_data, 'fhczrid');
    v_fhczrxm := json_str(v_json_data, 'fhczrxm');
    v_fhjgid  := json_str(v_json_data, 'fhjgid');
    v_fhzt    := json_str(v_json_data, 'fhzt');
    v_fhsj    := json_str(v_json_data, 'fhsj');
    v_shczrid := json_str(v_json_data, 'shczrid');
    v_shczrxm := json_str(v_json_data, 'shczrxm');
    v_shjgid  := json_str(v_json_data, 'shjgid');
    v_shsj    := json_str(v_json_data, 'shsj');
    v_zt      := json_str(v_json_data, 'zt');
    v_fhbz    := json_str(v_json_data, 'fhbz');
    v_bccjgid := json_str(v_json_data, 'bccjgid');
    v_fhyj    := json_str(v_json_data, 'fhyj');
    v_shyj    := json_str(v_json_data, 'shyj');
    v_sfkid_s := json_str(v_json_data, 'sfkid_s');
  
    --校验必填项目
    IF v_sfkid_s IS NULL THEN
      v_err := '报告卡ID不能为空!';
      RAISE err_custom;
    END IF;
    IF v_cctjid IS NULL THEN
      v_err := '抽查条件ID不能为空!';
      RAISE err_custom;
    END IF;
    --如果抽查区县
    IF v_bccjgid IS NULL THEN
      SELECT wm_concat(bgk.vc_gldwdm)
        INTO v_bccjgid
        FROM zjmb_sw_bgk bgk
       WHERE v_sfkid_s LIKE '%' || bgk.vc_bgkid || '%';
      --v_err := '被抽查机构不能为空!';
      --raise err_custom;
    END IF;
    IF v_csflx IS NULL THEN
      v_err := '初随访类型不能为空!';
      RAISE err_custom;
    END IF;
    --校验权限
    IF v_czyjgjb <> '3' THEN
      --非区县
      v_err := '当前机构无抽查权限!';
      RAISE err_custom;
    END IF;
  
    --校验是否已病例复核
    SELECT COUNT(1)
      INTO v_count
      FROM zjjk_csf_zlfh a
     WHERE a.cctjid = v_cctjid
       AND v_bccjgid LIKE '%' || bccjgid || '%'
       AND zt = '1'
       AND fhbz = '1'
       AND a.bllx = '5'
       AND a.csflx = v_csflx;
    IF v_count > 0 THEN
      v_err := '该次抽查已存在病例复核记录!';
      RAISE err_custom;
    END IF;
    --删除未复核病例，重新生成
    UPDATE zjjk_csf_zlfh a
       SET a.zt = '0'
     WHERE a.cctjid = v_cctjid
       AND v_bccjgid LIKE '%' || bccjgid || '%'
       AND zt = '1'
       AND fhbz = '0'
       AND a.bllx = '5'
       AND a.csflx = v_csflx;
    --获取抽查条数的条件
    IF v_csflx = '1' THEN
      SELECT ccts INTO v_ccts FROM zjjk_zlfhsj_cf a WHERE a.zt = 1;
    ELSIF v_csflx = '2' THEN
      SELECT ccts INTO v_ccts FROM zjjk_zlfhsj_sf a WHERE a.zt = 1;
    END IF;
 
    --校验bgkid合法性
/*    SELECT MIN(COUNT(a.vc_gldwdm))
      INTO v_count
      FROM zjmb_sw_bgk a
     WHERE a.vc_bgkid IN
           (SELECT DISTINCT column_value column_value
              FROM TABLE(split(v_sfkid_s, ',')))
     GROUP BY a.vc_gldwdm;
    IF v_count <> v_ccts THEN
      v_err := '本次抽查有医疗机构未找到' || v_ccts || '条死亡病例!';
      RAISE err_custom;
    END IF;*/
    --写入质量复核初随访表
    INSERT INTO zjjk_csf_zlfh
      (id,
       sfkid,
       cctjid,
       csflx,
       bllx,
       ccczrid,
       ccczrxm,
       ccjgid,
       ccsj,
       zt,
       fhbz,
       fhzt,
       bccjgid,
       ccxh)
      SELECT DISTINCT sys_guid(),
                      column_value,
                      v_cctjid,
                      v_csflx,
                      '5',
                      v_czyyhid,
                      v_czyyhxm,
                      v_czyjgdm,
                      v_sysdate,
                      '1',
                      '0',
                      '0',
                      v_bccjgid,
                      rownum
        FROM TABLE(split(v_sfkid_s, ','));
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_cfcc_sw_update;
  /*-----------------------------------------------------------------------------
  || 功能描述 ：慢病初访填报
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_cf_blfh_mb_update(data_in    IN CLOB, --入参
                                  result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
  
    --公共变量
    v_sysdate DATE;
    v_czyjgjb VARCHAR2(3);
    v_czyjgdm VARCHAR2(50);
    v_czyyhid VARCHAR2(50);
    v_czyyhxm VARCHAR2(50);
    v_count   NUMBER;
  
    v_id           zjjk_cf_zlfh_mxbjc.id%TYPE; --id
    v_jbxxybgksfyz zjjk_cf_zlfh_mxbjc.jbxxybgksfyz%TYPE; --基本信息与报告卡是否一致（0 是 1 否）
    v_kpbm         zjjk_cf_zlfh_mxbjc.kpbm%TYPE; --卡片编码
    v_kpbmxg       zjjk_cf_zlfh_mxbjc.kpbmxg%TYPE; --卡片编码修改
    v_kpzt         zjjk_cf_zlfh_mxbjc.kpzt%TYPE; --卡片状态
    v_kpztxg       zjjk_cf_zlfh_mxbjc.kpztxg%TYPE; --卡片状态修改
    v_hzxm         zjjk_cf_zlfh_mxbjc.hzxm%TYPE; --患者姓名
    v_hzxmxg       zjjk_cf_zlfh_mxbjc.hzxmxg%TYPE; --患者姓名修改
    v_xb           zjjk_cf_zlfh_mxbjc.xb%TYPE; --性别
    v_xbxg         zjjk_cf_zlfh_mxbjc.xbxg%TYPE; --性别修改
    v_sfzh         zjjk_cf_zlfh_mxbjc.sfzh%TYPE; --身份证号
    v_sfzhxg       zjjk_cf_zlfh_mxbjc.sfzhxg%TYPE; --身份证号修改
    v_csrq         zjjk_cf_zlfh_mxbjc.csrq%TYPE; --出生日期
    v_csrqxg       zjjk_cf_zlfh_mxbjc.csrqxg%TYPE; --出生日期修改
    v_lxdh         zjjk_cf_zlfh_mxbjc.lxdh%TYPE; --联系电话
    v_lxdhxg       zjjk_cf_zlfh_mxbjc.lxdhxg%TYPE; --联系电话修改
    v_zdyy         zjjk_cf_zlfh_mxbjc.zdyy%TYPE; --诊断医院
    v_zdyyxg       zjjk_cf_zlfh_mxbjc.zdyyxg%TYPE; --诊断医院修改
    v_zdmc         zjjk_cf_zlfh_mxbjc.zdmc%TYPE; --诊断名称
    v_zdmcxg       zjjk_cf_zlfh_mxbjc.zdmcxg%TYPE; --诊断名称修改
    v_fbrq         zjjk_cf_zlfh_mxbjc.fbrq%TYPE; --发病日期
    v_fbrqxg       zjjk_cf_zlfh_mxbjc.fbrqxg%TYPE; --发病日期修改
    v_hjdz         zjjk_cf_zlfh_mxbjc.hjdz%TYPE; --户籍地址
    v_hjdzxg       zjjk_cf_zlfh_mxbjc.hjdzxg%TYPE; --户籍地址修改
    v_sfsw         zjjk_cf_zlfh_mxbjc.sfsw%TYPE; --是否死亡（0 是 1 否）
    v_sfswxg       zjjk_cf_zlfh_mxbjc.sfswxg%TYPE; --是否死亡修改（0 是 1 否）
    v_swrq         zjjk_cf_zlfh_mxbjc.swrq%TYPE; --死亡日期
    v_swrqxg       zjjk_cf_zlfh_mxbjc.swrqxg%TYPE; --死亡日期修改
    v_gbsy         zjjk_cf_zlfh_mxbjc.gbsy%TYPE; --根本死因
    v_gbsyxg       zjjk_cf_zlfh_mxbjc.gbsyxg%TYPE; --根本死因修改
    v_fhfs         zjjk_cf_zlfh_mxbjc.fhfs%TYPE; --复核方式（1 电话 2 入户）
    v_fhry         zjjk_cf_zlfh_mxbjc.fhry%TYPE; --复核人员
    v_jcsj         zjjk_cf_zlfh_mxbjc.jcsj%TYPE; --检查时间
    v_sffh         zjjk_cf_zlfh_mxbjc.sffh%TYPE; --是否符合（1 符合 2 不符合）
    v_fhzt         zjjk_cf_zlfh_mxbjc.fhzt%TYPE; --复核状态（0 未开始 1 进行中 2 完成 3 审核不通过）
    v_cjrid        zjjk_cf_zlfh_mxbjc.cjrid%TYPE; --创建人ID
    v_cjrxm        zjjk_cf_zlfh_mxbjc.cjrxm%TYPE; --创建人姓名
    v_cjsj         zjjk_cf_zlfh_mxbjc.cjsj%TYPE; --创建时间
    v_xgrid        zjjk_cf_zlfh_mxbjc.xgrid%TYPE; --修改人id
    v_xgrxm        zjjk_cf_zlfh_mxbjc.xgrxm%TYPE; --修改人姓名
    v_xgsj         zjjk_cf_zlfh_mxbjc.xgsj%TYPE; --修改时间
  
  BEGIN
    json_data(data_in, '慢性病初访病例填报', v_json_data);
    v_sysdate := SYSDATE;
    v_czyjgdm := json_str(v_json_data, 'czyjgdm');
    v_czyyhid := json_str(v_json_data, 'czyyhid');
    v_czyjgjb := json_str(v_json_data, 'czyjgjb');
    v_czyyhxm := json_str(v_json_data, 'czyyhxm');
  
    v_id           := json_str(v_json_data, 'id');
    v_jbxxybgksfyz := json_str(v_json_data, 'jbxxybgksfyz');
    v_kpbm         := json_str(v_json_data, 'kpbm');
    v_kpbmxg       := json_str(v_json_data, 'kpbmxg');
    v_kpzt         := json_str(v_json_data, 'kpzt');
    v_kpztxg       := json_str(v_json_data, 'kpztxg');
    v_hzxm         := json_str(v_json_data, 'hzxm');
    v_hzxmxg       := json_str(v_json_data, 'hzxmxg');
    v_xb           := json_str(v_json_data, 'xb');
    v_xbxg         := json_str(v_json_data, 'xbxg');
    v_sfzh         := json_str(v_json_data, 'sfzh');
    v_sfzhxg       := json_str(v_json_data, 'sfzhxg');
    v_csrq         := std(json_str(v_json_data, 'csrq'));
    v_csrqxg       := json_str(v_json_data, 'csrqxg');
    v_lxdh         := json_str(v_json_data, 'lxdh');
    v_lxdhxg       := json_str(v_json_data, 'lxdhxg');
    v_zdyy         := json_str(v_json_data, 'zdyy');
    v_zdyyxg       := json_str(v_json_data, 'zdyyxg');
    v_zdmc         := json_str(v_json_data, 'zdmc');
    v_zdmcxg       := json_str(v_json_data, 'zdmcxg');
    v_fbrq         := std(json_str(v_json_data, 'fbrq'));
    v_fbrqxg       := json_str(v_json_data, 'fbrqxg');
    v_hjdz         := json_str(v_json_data, 'hjdz');
    v_hjdzxg       := json_str(v_json_data, 'hjdzxg');
    v_sfsw         := json_str(v_json_data, 'sfsw');
    v_sfswxg       := json_str(v_json_data, 'sfswxg');
    v_swrq         := std(json_str(v_json_data, 'swrq'));
    v_swrqxg       := json_str(v_json_data, 'swrqxg');
    v_gbsy         := json_str(v_json_data, 'gbsy');
    v_gbsyxg       := json_str(v_json_data, 'gbsyxg');
    v_fhfs         := json_str(v_json_data, 'fhfs');
    v_fhry         := json_str(v_json_data, 'fhry');
    v_jcsj         := std(json_str(v_json_data, 'jcsj'));
    v_sffh         := json_str(v_json_data, 'sffh');
    v_fhzt         := json_str(v_json_data, 'fhzt');
    v_cjrid        := json_str(v_json_data, 'cjrid');
    v_cjrxm        := json_str(v_json_data, 'cjrxm');
    v_cjsj         := std(json_str(v_json_data, 'cjsj'));
    v_xgrid        := json_str(v_json_data, 'xgrid');
    v_xgrxm        := json_str(v_json_data, 'xgrxm');
    v_xgsj         := std(json_str(v_json_data, 'xgsj'));
  
    --校验权限
    IF v_czyjgjb <> '3' THEN
      --非区县
      v_err := '当前机构无病例填报权限!';
      RAISE err_custom;
    END IF;
  
    --校验状态
    SELECT COUNT(1)
      INTO v_count
      FROM zjjk_csf_zlfh a, zjjk_zlfhsj_cf b
     WHERE a.cctjid = b.jlbh
       AND b.zt = '1'
       AND a.id = v_id
       AND a.csflx = '1'
       AND a.zt = '1'
       AND nvl(a.fhzt, '0') IN ('0', '1', '6');
    IF v_count <> 1 THEN
      v_err := '未找到待填报的病例!';
      RAISE err_custom;
    END IF;
  
    --校验必填项目
    IF v_id IS NULL THEN
      v_err := '复核ID不能为空!';
      RAISE err_custom;
    END IF;
    IF v_jbxxybgksfyz IS NULL THEN
      v_err := '基本信息与报告卡是否一致不能为空!';
      RAISE err_custom;
    END IF;
    IF v_kpzt IS NULL THEN
      v_err := '卡片状态不能为空!';
      RAISE err_custom;
    END IF;
    IF v_hzxm IS NULL THEN
      v_err := '患者姓名不能为空!';
      RAISE err_custom;
    END IF;
    IF v_xb IS NULL THEN
      v_err := '性别不能为空!';
      RAISE err_custom;
    END IF;
    IF v_sfzh IS NULL THEN
      v_err := '身份证号不能为空!';
      RAISE err_custom;
    END IF;
    IF v_csrq IS NULL THEN
      v_err := '出生日期不能为空!';
      RAISE err_custom;
    END IF;
    IF v_lxdh IS NULL THEN
      v_err := '联系电话不能为空!';
      RAISE err_custom;
    END IF;
    IF v_zdyy IS NULL THEN
      v_err := '诊断医院不能为空!';
      RAISE err_custom;
    END IF;
    IF v_zdmc IS NULL THEN
      v_err := '诊断名称不能为空!';
      RAISE err_custom;
    END IF;
    IF v_fbrq IS NULL THEN
      v_err := '发病日期不能为空!';
      RAISE err_custom;
    END IF;
    IF v_hjdz IS NULL THEN
      v_err := '户籍地址不能为空!';
      RAISE err_custom;
    END IF;
    IF v_sfsw IS NULL THEN
      v_err := '是否死亡不能为空!';
      RAISE err_custom;
    END IF;
    IF v_fhfs IS NULL THEN
      v_err := '复核方式不能为空!';
      RAISE err_custom;
    END IF;
    IF v_fhry IS NULL THEN
      v_err := '复核人员不能为空!';
      RAISE err_custom;
    END IF;
    IF v_jcsj IS NULL THEN
      v_err := '检查时间不能为空!';
      RAISE err_custom;
    END IF;
    IF v_sffh IS NULL THEN
      v_err := '是否符合不能为空!';
      RAISE err_custom;
    END IF;
  
    --判断新增还是修改
    SELECT COUNT(1)
      INTO v_count
      FROM zjjk_cf_zlfh_mxbjc a
     WHERE a.id = v_id;
    IF v_count > 0 THEN
      --修改
      UPDATE zjjk_cf_zlfh_mxbjc
         SET jbxxybgksfyz = v_jbxxybgksfyz,
             kpbm         = v_kpbm,
             kpbmxg       = v_kpbmxg,
             kpzt         = v_kpzt,
             kpztxg       = v_kpztxg,
             hzxm         = v_hzxm,
             hzxmxg       = v_hzxmxg,
             xb           = v_xb,
             xbxg         = v_xbxg,
             sfzh         = v_sfzh,
             sfzhxg       = v_sfzhxg,
             csrq         = v_csrq,
             csrqxg       = v_csrqxg,
             lxdh         = v_lxdh,
             lxdhxg       = v_lxdhxg,
             zdyy         = v_zdyy,
             zdyyxg       = v_zdyyxg,
             zdmc         = v_zdmc,
             zdmcxg       = v_zdmcxg,
             fbrq         = v_fbrq,
             fbrqxg       = v_fbrqxg,
             hjdz         = v_hjdz,
             hjdzxg       = v_hjdzxg,
             sfsw         = v_sfsw,
             sfswxg       = v_sfswxg,
             swrq         = v_swrq,
             swrqxg       = v_swrqxg,
             gbsy         = v_gbsy,
             gbsyxg       = v_gbsyxg,
             fhfs         = v_fhfs,
             fhry         = v_fhry,
             jcsj         = v_jcsj,
             sffh         = v_sffh,
             xgrid        = v_czyyhid,
             xgrxm        = v_czyyhxm,
             xgsj         = v_sysdate,
             fhzt         = '1'
       WHERE id = v_id;
    ELSE
      --新增
      INSERT INTO zjjk_cf_zlfh_mxbjc
        (id, --id
         jbxxybgksfyz, --基本信息与报告卡是否一致（0 是 1 否）
         kpbm, --卡片编码
         kpbmxg, --卡片编码修改
         kpzt, --卡片状态
         kpztxg, --卡片状态修改
         hzxm, --患者姓名
         hzxmxg, --患者姓名修改
         xb, --性别
         xbxg, --性别修改
         sfzh, --身份证号
         sfzhxg, --身份证号修改
         csrq, --出生日期
         csrqxg, --出生日期修改
         lxdh, --联系电话
         lxdhxg, --联系电话修改
         zdyy, --诊断医院
         zdyyxg, --诊断医院修改
         zdmc, --诊断名称
         zdmcxg, --诊断名称修改
         fbrq, --发病日期
         fbrqxg, --发病日期修改
         hjdz, --户籍地址
         hjdzxg, --户籍地址修改
         sfsw, --是否死亡（0 是 1 否）
         sfswxg, --是否死亡修改（0 是 1 否）
         swrq, --死亡日期
         swrqxg, --死亡日期修改
         gbsy, --根本死因
         gbsyxg, --根本死因修改
         fhfs, --复核方式（1 电话 2 入户）
         fhry, --复核人员
         jcsj, --检查时间
         sffh, --是否符合（1 符合 2 不符合）
         fhzt, --复核状态（0 未开始 1 进行中 2 完成 3 审核不通过）
         cjrid, --创建人id
         cjrxm, --创建人姓名
         cjsj) --创建时间
      VALUES
        (v_id, --id
         v_jbxxybgksfyz, --基本信息与报告卡是否一致（0 是 1 否）
         v_kpbm, --卡片编码
         v_kpbmxg, --卡片编码修改
         v_kpzt, --卡片状态
         v_kpztxg, --卡片状态修改
         v_hzxm, --患者姓名
         v_hzxmxg, --患者姓名修改
         v_xb, --性别
         v_xbxg, --性别修改
         v_sfzh, --身份证号
         v_sfzhxg, --身份证号修改
         v_csrq, --出生日期
         v_csrqxg, --出生日期修改
         v_lxdh, --联系电话
         v_lxdhxg, --联系电话修改
         v_zdyy, --诊断医院
         v_zdyyxg, --诊断医院修改
         v_zdmc, --诊断名称
         v_zdmcxg, --诊断名称修改
         v_fbrq, --发病日期
         v_fbrqxg, --发病日期修改
         v_hjdz, --户籍地址
         v_hjdzxg, --户籍地址修改
         v_sfsw, --是否死亡（0 是 1 否）
         v_sfswxg, --是否死亡修改（0 是 1 否）
         v_swrq, --死亡日期
         v_swrqxg, --死亡日期修改
         v_gbsy, --根本死因
         v_gbsyxg, --根本死因修改
         v_fhfs, --复核方式（1 电话 2 入户）
         v_fhry, --复核人员
         v_jcsj, --检查时间
         v_sffh, --是否符合（1 符合 2 不符合）
         '1', --复核状态（0 未开始 1 进行中 2 完成 3 审核不通过）
         v_czyyhid, --创建人id
         v_czyyhxm, --创建人姓名
         v_sysdate); --创建时间
    END IF;
    --更新复核状态
    UPDATE zjjk_csf_zlfh a
       SET a.fhzt = '1', a.fhbz = '1'
     WHERE a.id = v_id
       AND a.csflx = '1';
    --返回
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_cf_blfh_mb_update;
  /*-----------------------------------------------------------------------------
  || 功能描述 ：慢病初访病例提交
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_cf_blfh_mb_tj(data_in    IN CLOB, --入参
                              result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
  
    v_id zjjk_mb_zlfh.id%TYPE; --ID
    --公共变量
    v_sysdate DATE;
    v_czyjgjb VARCHAR2(3);
    v_czyjgdm VARCHAR2(50);
    v_czyyhid VARCHAR2(50);
    v_czyyhxm VARCHAR2(50);
    v_count   NUMBER;
  
  BEGIN
    json_data(data_in, '慢性病初访病例提交', v_json_data);
    v_sysdate := SYSDATE;
    v_czyjgdm := json_str(v_json_data, 'czyjgdm');
    v_czyyhid := json_str(v_json_data, 'czyyhid');
    v_czyjgjb := json_str(v_json_data, 'czyjgjb');
    v_czyyhxm := json_str(v_json_data, 'czyyhxm');
  
    v_id := json_str(v_json_data, 'id');
    IF v_id IS NULL THEN
      v_err := 'id不能为空!';
      RAISE err_custom;
    END IF;
    --更新状态
    UPDATE zjjk_csf_zlfh a
       SET a.fhzt    = '3',
           a.fhczrid = v_czyyhid,
           a.fhczrxm = v_czyyhxm,
           a.fhjgid  = v_czyjgdm,
           a.fhsj    = v_sysdate
     WHERE a.fhzt = '1'
       AND a.id = v_id
       AND a.csflx = '1'
       AND a.zt = '1';
    IF SQL%ROWCOUNT <> 1 THEN
      v_err := '更新病例状态出错!';
      RAISE err_custom;
    END IF;
    UPDATE zjjk_cf_zlfh_mxbjc a SET a.fhzt = '3' WHERE a.id = v_id;
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_cf_blfh_mb_tj;
  /*-----------------------------------------------------------------------------
  || 功能描述 ：慢性病初访病例审核
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_cf_blfh_mb_zt_sh(data_in    IN CLOB, --入参
                                 result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err    VARCHAR2(2000);
    v_id     zjjk_csf_zlfh.id%TYPE; --ID
    v_shzt   zjjk_csf_zlfh.fhzt%TYPE; --ID
    v_shyj   zjjk_csf_zlfh.shyj%TYPE; --复核意见
    v_kpbmsh zjjk_cf_zlfh_mxbjc.kpbmsh%TYPE; --卡片编码审核
    v_kpztsh zjjk_cf_zlfh_mxbjc.kpztsh%TYPE; --卡片状态审核
    v_hzxmsh zjjk_cf_zlfh_mxbjc.hzxmsh%TYPE; --患者姓名审核
    v_xbsh   zjjk_cf_zlfh_mxbjc.xbsh%TYPE; --性别审核
    v_sfzhsh zjjk_cf_zlfh_mxbjc.sfzhsh%TYPE; --身份证号审核
    v_csrqsh zjjk_cf_zlfh_mxbjc.csrqsh%TYPE; --出生日期审核
    v_lxdhsh zjjk_cf_zlfh_mxbjc.lxdhsh%TYPE; --联系电话审核
    v_zdyysh zjjk_cf_zlfh_mxbjc.zdyysh%TYPE; --诊断医院审核
    v_zdmcsh zjjk_cf_zlfh_mxbjc.zdmcsh%TYPE; --诊断名称审核
    v_fbrqsh zjjk_cf_zlfh_mxbjc.fbrqsh%TYPE; --发病日期审核
    v_hjdzsh zjjk_cf_zlfh_mxbjc.hjdzsh%TYPE; --户籍地址审核
    v_sfswsh zjjk_cf_zlfh_mxbjc.sfswsh%TYPE; --是否死亡审核
    v_swrqsh zjjk_cf_zlfh_mxbjc.swrqsh%TYPE; --死亡日期审核
    v_gbsysh zjjk_cf_zlfh_mxbjc.gbsysh%TYPE; --根本死因审核

    --公共变量
    v_sysdate DATE;
    v_czyjgjb VARCHAR2(3);
    v_czyjgdm VARCHAR2(50);
    v_czyyhid VARCHAR2(50);
    v_czyyhxm VARCHAR2(50);
    v_count   NUMBER;

  BEGIN
    json_data(data_in, '慢性病初访病例审核', v_json_data);
    v_sysdate := SYSDATE;
    v_czyjgdm := json_str(v_json_data, 'czyjgdm');
    v_czyyhid := json_str(v_json_data, 'czyyhid');
    v_czyjgjb := json_str(v_json_data, 'czyjgjb');
    v_czyyhxm := json_str(v_json_data, 'czyyhxm');

    v_id     := json_str(v_json_data, 'id');
    v_shzt   := json_str(v_json_data, 'fhzt');
    v_shyj   := json_str(v_json_data, 'shyj');
    v_kpbmsh := json_str(v_json_data, 'kpbmsh');
    v_kpztsh := json_str(v_json_data, 'kpztsh');
    v_hzxmsh := json_str(v_json_data, 'hzxmsh');
    v_xbsh   := json_str(v_json_data, 'xbsh');
    v_sfzhsh := json_str(v_json_data, 'sfzhsh');
    v_csrqsh := json_str(v_json_data, 'csrqsh');
    v_lxdhsh := json_str(v_json_data, 'lxdhsh');
    v_zdyysh := json_str(v_json_data, 'zdyysh');
    v_zdmcsh := json_str(v_json_data, 'zdmcsh');
    v_fbrqsh := json_str(v_json_data, 'fbrqsh');
    v_hjdzsh := json_str(v_json_data, 'hjdzsh');
    v_sfswsh := json_str(v_json_data, 'sfswsh');
    v_swrqsh := json_str(v_json_data, 'swrqsh');
    v_gbsysh := json_str(v_json_data, 'gbsysh');

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
       AND a.csflx = '1'
       AND a.zt = '1';
    IF SQL%ROWCOUNT <> 1 THEN
      v_err := '更新病例审核状态出错!';
      RAISE err_custom;
    END IF;
    UPDATE zjjk_cf_zlfh_mxbjc a
       SET a.kpbmsh = v_kpbmsh,
           a.kpztsh = v_kpztsh,
           a.hzxmsh = v_hzxmsh,
           a.xbsh   = v_xbsh,
           a.sfzhsh = v_sfzhsh,
           a.csrqsh = v_csrqsh,
           a.lxdhsh = v_lxdhsh,
           a.zdyysh = v_zdyysh,
           a.zdmcsh = v_zdmcsh,
           a.fbrqsh = v_fbrqsh,
           a.hjdzsh = v_hjdzsh,
           a.sfswsh = v_sfswsh,
           a.swrqsh = v_swrqsh,
           a.gbsysh = v_gbsysh,
           a.fhzt   = v_shzt
     WHERE a.id = v_id;

    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_cf_blfh_mb_zt_sh;
  /*-----------------------------------------------------------------------------
  || 功能描述 ：死亡初访填报
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_cf_blfh_sw_update(data_in    IN CLOB, --入参
                                  result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
  
    --公共变量
    v_sysdate DATE;
    v_czyjgjb VARCHAR2(3);
    v_czyjgdm VARCHAR2(50);
    v_czyyhid VARCHAR2(50);
    v_czyyhxm VARCHAR2(50);
    v_count   NUMBER;
  
    v_id           zjjk_cf_zlfh_swga.id%TYPE; --id
    v_jbxxybgksfyz zjjk_cf_zlfh_swga.jbxxybgksfyz%TYPE; --基本信息与报告卡是否一致（0:是，1:否）
    v_kpbm         zjjk_cf_zlfh_swga.kpbm%TYPE; --卡片编码
    v_kpbmxg       zjjk_cf_zlfh_swga.kpbmxg%TYPE; --卡片编码修改
    v_szxm         zjjk_cf_zlfh_swga.szxm%TYPE; --死者姓名
    v_szxmxg       zjjk_cf_zlfh_swga.szxmxg%TYPE; --死者姓名修改
    v_xb           zjjk_cf_zlfh_swga.xb%TYPE; --性别
    v_xbxg         zjjk_cf_zlfh_swga.xbxg%TYPE; --性别修改
    v_sfzh         zjjk_cf_zlfh_swga.sfzh%TYPE; --身份证号
    v_sfzhxg       zjjk_cf_zlfh_swga.sfzhxg%TYPE; --身份证号修改
    v_lxjs         zjjk_cf_zlfh_swga.lxjs%TYPE; --联系家属
    v_lxjsxg       zjjk_cf_zlfh_swga.lxjsxg%TYPE; --联系家属修改
    v_lxdh         zjjk_cf_zlfh_swga.lxdh%TYPE; --联系电话
    v_lxdhxg       zjjk_cf_zlfh_swga.lxdhxg%TYPE; --联系电话修改
    v_hjdz         zjjk_cf_zlfh_swga.hjdz%TYPE; --户籍地址
    v_hjdzxg       zjjk_cf_zlfh_swga.hjdzxg%TYPE; --户籍地址修改
    v_swrq         zjjk_cf_zlfh_swga.swrq%TYPE; --死亡日期
    v_swrqxg       zjjk_cf_zlfh_swga.swrqxg%TYPE; --死亡日期修改
    v_gbsy         zjjk_cf_zlfh_swga.gbsy%TYPE; --根本死因
    v_gbsyxg       zjjk_cf_zlfh_swga.gbsyxg%TYPE; --根本死因修改
    v_fhfs         zjjk_cf_zlfh_swga.fhfs%TYPE; --复核方式(1 电话 2 入户)
    v_fhry         zjjk_cf_zlfh_swga.fhry%TYPE; --复核人员
    v_jcsj         zjjk_cf_zlfh_swga.jcsj%TYPE; --检查时间
    v_sffh         zjjk_cf_zlfh_swga.sffh%TYPE; --是否符合(1 符合 2 不符合)
    v_fhzt         zjjk_cf_zlfh_swga.fhzt%TYPE; --复核状态(0 未开始 1 进行中 2 完成 3 审核不通过)
    v_cjrid        zjjk_cf_zlfh_swga.cjrid%TYPE; --创建人ID
    v_cjrxm        zjjk_cf_zlfh_swga.cjrxm%TYPE; --创建人姓名
    v_cjsj         zjjk_cf_zlfh_swga.cjsj%TYPE; --创建时间
    v_xgrid        zjjk_cf_zlfh_swga.xgrid%TYPE; --修改人id
    v_xgrxm        zjjk_cf_zlfh_swga.xgrxm%TYPE; --修改人姓名
    v_xgsj         zjjk_cf_zlfh_swga.xgsj%TYPE; --修改时间
  
  BEGIN
    json_data(data_in, '死亡初访病例填报', v_json_data);
    v_sysdate := SYSDATE;
    v_czyjgdm := json_str(v_json_data, 'czyjgdm');
    v_czyyhid := json_str(v_json_data, 'czyyhid');
    v_czyjgjb := json_str(v_json_data, 'czyjgjb');
    v_czyyhxm := json_str(v_json_data, 'czyyhxm');
  
    v_id           := json_str(v_json_data, 'id');
    v_jbxxybgksfyz := json_str(v_json_data, 'jbxxybgksfyz');
    v_kpbm         := json_str(v_json_data, 'kpbm');
    v_kpbmxg       := json_str(v_json_data, 'kpbmxg');
    v_szxm         := json_str(v_json_data, 'szxm');
    v_szxmxg       := json_str(v_json_data, 'szxmxg');
    v_xb           := json_str(v_json_data, 'xb');
    v_xbxg         := json_str(v_json_data, 'xbxg');
    v_sfzh         := json_str(v_json_data, 'sfzh');
    v_sfzhxg       := json_str(v_json_data, 'sfzhxg');
    v_lxjs         := json_str(v_json_data, 'lxjs');
    v_lxjsxg       := json_str(v_json_data, 'lxjsxg');
    v_lxdh         := json_str(v_json_data, 'lxdh');
    v_lxdhxg       := json_str(v_json_data, 'lxdhxg');
    v_hjdz         := json_str(v_json_data, 'hjdz');
    v_hjdzxg       := json_str(v_json_data, 'hjdzxg');
    v_swrq         := std(json_str(v_json_data, 'swrq'));
    v_swrqxg       := json_str(v_json_data, 'swrqxg');
    v_gbsy         := json_str(v_json_data, 'gbsy');
    v_gbsyxg       := json_str(v_json_data, 'gbsyxg');
    v_fhfs         := json_str(v_json_data, 'fhfs');
    v_fhry         := json_str(v_json_data, 'fhry');
    v_jcsj         := std(json_str(v_json_data, 'jcsj'));
    v_sffh         := json_str(v_json_data, 'sffh');
    v_fhzt         := json_str(v_json_data, 'fhzt');
    v_cjrid        := json_str(v_json_data, 'cjrid');
    v_cjrxm        := json_str(v_json_data, 'cjrxm');
    v_cjsj         := std(json_str(v_json_data, 'cjsj'));
    v_xgrid        := json_str(v_json_data, 'xgrid');
    v_xgrxm        := json_str(v_json_data, 'xgrxm');
    v_xgsj         := std(json_str(v_json_data, 'xgsj'));
  
    --校验权限
    IF v_czyjgjb <> '3' THEN
      --非区县
      v_err := '当前机构无病例填报权限!';
      RAISE err_custom;
    END IF;
  
    --校验状态
    SELECT COUNT(1)
      INTO v_count
      FROM zjjk_csf_zlfh a, zjjk_zlfhsj_cf b
     WHERE a.cctjid = b.jlbh
       AND b.zt = '1'
       AND a.id = v_id
       AND a.csflx = '1'
       AND a.bllx = '5'
       AND a.zt = '1'
       AND nvl(a.fhzt, '0') IN ('0', '1', '6');
    IF v_count <> 1 THEN
      v_err := '未找到待填报的病例!';
      RAISE err_custom;
    END IF;
  
    --校验必填项目
    IF v_id IS NULL THEN
      v_err := 'id不能为空!';
      RAISE err_custom;
    END IF;
    IF v_jbxxybgksfyz IS NULL THEN
      v_err := '基本信息与报告卡是否一致（0:是，1:否）不能为空!';
      RAISE err_custom;
    END IF;
    IF v_kpbm IS NULL THEN
      v_err := '卡片编码不能为空!';
      RAISE err_custom;
    END IF;
    IF v_szxm IS NULL THEN
      v_err := '死者姓名不能为空!';
      RAISE err_custom;
    END IF;
    IF v_xb IS NULL THEN
      v_err := '性别不能为空!';
      RAISE err_custom;
    END IF;
    IF v_sfzh IS NULL THEN
      v_err := '身份证号不能为空!';
      RAISE err_custom;
    END IF;
    IF v_lxjs IS NULL THEN
      v_err := '联系家属不能为空!';
      RAISE err_custom;
    END IF;
    IF v_lxdh IS NULL THEN
      v_err := '联系电话不能为空!';
      RAISE err_custom;
    END IF;
    IF v_hjdz IS NULL THEN
      v_err := '户籍地址不能为空!';
      RAISE err_custom;
    END IF;
    IF v_swrq IS NULL THEN
      v_err := '死亡日期不能为空!';
      RAISE err_custom;
    END IF;
    IF v_gbsy IS NULL THEN
      v_err := '根本死因不能为空!';
      RAISE err_custom;
    END IF;
    IF v_fhfs IS NULL THEN
      v_err := '复核方式不能为空!';
      RAISE err_custom;
    END IF;
    IF v_fhry IS NULL THEN
      v_err := '复核人员不能为空!';
      RAISE err_custom;
    END IF;
    IF v_jcsj IS NULL THEN
      v_err := '检查时间不能为空!';
      RAISE err_custom;
    END IF;
    IF v_sffh IS NULL THEN
      v_err := '是否符合不能为空!';
      RAISE err_custom;
    END IF;
  
    --判断新增还是修改
    SELECT COUNT(1)
      INTO v_count
      FROM zjjk_cf_zlfh_swga a
     WHERE a.id = v_id;
    IF v_count > 0 THEN
      --修改
      UPDATE zjjk_cf_zlfh_swga
         SET id           = v_id,
             jbxxybgksfyz = v_jbxxybgksfyz,
             kpbm         = v_kpbm,
             kpbmxg       = v_kpbmxg,
             szxm         = v_szxm,
             szxmxg       = v_szxmxg,
             xb           = v_xb,
             xbxg         = v_xbxg,
             sfzh         = v_sfzh,
             sfzhxg       = v_sfzhxg,
             lxjs         = v_lxjs,
             lxjsxg       = v_lxjsxg,
             lxdh         = v_lxdh,
             lxdhxg       = v_lxdhxg,
             hjdz         = v_hjdz,
             hjdzxg       = v_hjdzxg,
             swrq         = v_swrq,
             swrqxg       = v_swrqxg,
             gbsy         = v_gbsy,
             gbsyxg       = v_gbsyxg,
             fhfs         = v_fhfs,
             fhry         = v_fhry,
             jcsj         = v_jcsj,
             sffh         = v_sffh,
             fhzt         = '1',
             xgrid        = v_czyyhid,
             xgrxm        = v_czyyhxm,
             xgsj         = v_sysdate
       WHERE id = v_id;
    ELSE
      --新增
      INSERT INTO zjjk_cf_zlfh_swga
        (id, --id
         jbxxybgksfyz, --基本信息与报告卡是否一致（0:是，1:否）
         kpbm, --卡片编码
         kpbmxg, --卡片编码修改
         szxm, --死者姓名
         szxmxg, --死者姓名修改
         xb, --性别
         xbxg, --性别修改
         sfzh, --身份证号
         sfzhxg, --身份证号修改
         lxjs, --联系家属
         lxjsxg, --联系家属修改
         lxdh, --联系电话
         lxdhxg, --联系电话修改
         hjdz, --户籍地址
         hjdzxg, --户籍地址修改
         swrq, --死亡日期
         swrqxg, --死亡日期修改
         gbsy, --根本死因
         gbsyxg, --根本死因修改
         fhfs, --复核方式(1 电话 2 入户)
         fhry, --复核人员
         jcsj, --检查时间
         sffh, --是否符合(1 符合 2 不符合)
         fhzt, --复核状态(0 未开始 1 进行中 2 完成 3 审核不通过)
         cjrid, --创建人id
         cjrxm, --创建人姓名
         cjsj) --创建时间
      VALUES
        (v_id, --id
         v_jbxxybgksfyz, --基本信息与报告卡是否一致（0:是，1:否）
         v_kpbm, --卡片编码
         v_kpbmxg, --卡片编码修改
         v_szxm, --死者姓名
         v_szxmxg, --死者姓名修改
         v_xb, --性别
         v_xbxg, --性别修改
         v_sfzh, --身份证号
         v_sfzhxg, --身份证号修改
         v_lxjs, --联系家属
         v_lxjsxg, --联系家属修改
         v_lxdh, --联系电话
         v_lxdhxg, --联系电话修改
         v_hjdz, --户籍地址
         v_hjdzxg, --户籍地址修改
         v_swrq, --死亡日期
         v_swrqxg, --死亡日期修改
         v_gbsy, --根本死因
         v_gbsyxg, --根本死因修改
         v_fhfs, --复核方式(1 电话 2 入户)
         v_fhry, --复核人员
         v_jcsj, --检查时间
         v_sffh, --是否符合(1 符合 2 不符合)
         '1', --复核状态（0 未开始 1 进行中 2 完成 3 审核不通过）
         v_czyyhid, --创建人id
         v_czyyhxm, --创建人姓名
         v_sysdate); --创建时间
    END IF;
    --更新复核状态
    UPDATE zjjk_csf_zlfh a
       SET a.fhzt = '1', a.fhbz = '1'
     WHERE a.id = v_id
       AND a.csflx = '1'
       AND a.bllx = '5';
    --返回
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_cf_blfh_sw_update;
  /*-----------------------------------------------------------------------------
  || 功能描述 ：死亡初访病例提交
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_cf_blfh_sw_tj(data_in    IN CLOB, --入参
                              result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
  
    v_id zjjk_mb_zlfh.id%TYPE; --ID
    --公共变量
    v_sysdate DATE;
    v_czyjgjb VARCHAR2(3);
    v_czyjgdm VARCHAR2(50);
    v_czyyhid VARCHAR2(50);
    v_czyyhxm VARCHAR2(50);
    v_count   NUMBER;
  
  BEGIN
    json_data(data_in, '慢性病初访病例提交', v_json_data);
    v_sysdate := SYSDATE;
    v_czyjgdm := json_str(v_json_data, 'czyjgdm');
    v_czyyhid := json_str(v_json_data, 'czyyhid');
    v_czyjgjb := json_str(v_json_data, 'czyjgjb');
    v_czyyhxm := json_str(v_json_data, 'czyyhxm');
  
    v_id := json_str(v_json_data, 'id');
    IF v_id IS NULL THEN
      v_err := 'id不能为空!';
      RAISE err_custom;
    END IF;
    --更新状态
    UPDATE zjjk_csf_zlfh a
       SET a.fhzt    = '3',
           a.fhczrid = v_czyyhid,
           a.fhczrxm = v_czyyhxm,
           a.fhjgid  = v_czyjgdm,
           a.fhsj    = v_sysdate
     WHERE a.fhzt = '1'
       AND a.id = v_id
       AND a.csflx = '1'
       AND a.bllx = '5'
       AND a.zt = '1';
    IF SQL%ROWCOUNT <> 1 THEN
      v_err := '更新病例状态出错!';
      RAISE err_custom;
    END IF;
    UPDATE zjjk_cf_zlfh_swga a SET a.fhzt = '3' WHERE a.id = v_id;
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_cf_blfh_sw_tj;
  /*-----------------------------------------------------------------------------
  || 功能描述 ：死亡初访病例审核
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_cf_blfh_sw_zt_sh(data_in    IN CLOB, --入参
                                 result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err    VARCHAR2(2000);
    v_id     zjjk_csf_zlfh.id%TYPE; --ID
    v_shzt   zjjk_csf_zlfh.fhzt%TYPE; --ID
    v_shyj   zjjk_csf_zlfh.shyj%TYPE; --复核意见
    v_kpbmsh zjjk_cf_zlfh_swga.kpbmsh%TYPE; --卡片编码审核
    v_szxmsh zjjk_cf_zlfh_swga.szxmsh%TYPE; --死者姓名审核
    v_xbsh   zjjk_cf_zlfh_swga.xbsh%TYPE; --性别审核
    v_sfzhsh zjjk_cf_zlfh_swga.sfzhsh%TYPE; --身份证号审核
    v_lxjssh zjjk_cf_zlfh_swga.lxjssh%TYPE; --联系家属审核
    v_lxdhsh zjjk_cf_zlfh_swga.lxdhsh%TYPE; --联系电话审核
    v_hjdzsh zjjk_cf_zlfh_swga.hjdzsh%TYPE; --户籍地址审核
    v_swrqsh zjjk_cf_zlfh_swga.swrqsh%TYPE; --死亡日期审核
    v_gbsysh zjjk_cf_zlfh_swga.gbsysh%TYPE; --根本死因审核

    --公共变量
    v_sysdate DATE;
    v_czyjgjb VARCHAR2(3);
    v_czyjgdm VARCHAR2(50);
    v_czyyhid VARCHAR2(50);
    v_czyyhxm VARCHAR2(50);
    v_count   NUMBER;

  BEGIN
    json_data(data_in, '慢性病初访病例审核', v_json_data);
    v_sysdate := SYSDATE;
    v_czyjgdm := json_str(v_json_data, 'czyjgdm');
    v_czyyhid := json_str(v_json_data, 'czyyhid');
    v_czyjgjb := json_str(v_json_data, 'czyjgjb');
    v_czyyhxm := json_str(v_json_data, 'czyyhxm');

    v_id     := json_str(v_json_data, 'id');
    v_shzt   := json_str(v_json_data, 'fhzt');
    v_shyj   := json_str(v_json_data, 'shyj');
    v_kpbmsh := json_str(v_json_data, 'kpbmsh');
    v_szxmsh := json_str(v_json_data, 'szxmsh');
    v_xbsh   := json_str(v_json_data, 'xbsh');
    v_sfzhsh := json_str(v_json_data, 'sfzhsh');
    v_lxjssh := json_str(v_json_data, 'lxjssh');
    v_lxdhsh := json_str(v_json_data, 'lxdhsh');
    v_hjdzsh := json_str(v_json_data, 'hjdzsh');
    v_swrqsh := json_str(v_json_data, 'swrqsh');
    v_gbsysh := json_str(v_json_data, 'gbsysh');
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
       AND a.csflx = '1'
       AND a.bllx = '5'
       AND a.zt = '1';
    IF SQL%ROWCOUNT <> 1 THEN
      v_err := '更新病例审核状态出错!';
      RAISE err_custom;
    END IF;
    UPDATE zjjk_cf_zlfh_swga a
       SET a.kpbmsh = v_kpbmsh,
           a.szxmsh = v_szxmsh,
           a.xbsh   = v_xbsh,
           a.sfzhsh = v_sfzhsh,
           a.lxjssh = v_lxjssh,
           a.lxdhsh = v_lxdhsh,
           a.hjdzsh = v_hjdzsh,
           a.swrqsh = v_swrqsh,
           a.gbsysh = v_gbsysh,
           a.fhzt   = v_shzt
     WHERE a.id = v_id;

    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_cf_blfh_sw_zt_sh;
  /*-----------------------------------------------------------------------------
  || 功能描述 ：慢病随访填报
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_sf_blfh_mb_update(data_in    IN CLOB, --入参
                                  result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
  
    --公共变量
    v_sysdate DATE;
    v_czyjgjb VARCHAR2(3);
    v_czyjgdm VARCHAR2(50);
    v_czyyhid VARCHAR2(50);
    v_czyyhxm VARCHAR2(50);
    v_count   NUMBER;
  
    v_id           zjjk_sf_zlfh_mxbjc.id%TYPE; --id
    v_jbxxybgksfyz zjjk_sf_zlfh_mxbjc.jbxxybgksfyz%TYPE; --基本信息与报告卡是否一致
    v_kpbm         zjjk_sf_zlfh_mxbjc.kpbm%TYPE; --卡片编码
    v_kpbmxg       zjjk_sf_zlfh_mxbjc.kpbmxg%TYPE; --卡片编码修改
    v_hzxm         zjjk_sf_zlfh_mxbjc.hzxm%TYPE; --患者姓名
    v_hzxmxg       zjjk_sf_zlfh_mxbjc.hzxmxg%TYPE; --患者姓名修改
    v_lxdh         zjjk_sf_zlfh_mxbjc.lxdh%TYPE; --联系电话
    v_lxdhxg       zjjk_sf_zlfh_mxbjc.lxdhxg%TYPE; --联系电话修改
    v_hjdz         zjjk_sf_zlfh_mxbjc.hjdz%TYPE; --户籍地址
    v_hjdzxg       zjjk_sf_zlfh_mxbjc.hjdzxg%TYPE; --户籍地址修改
    v_sczt         zjjk_sf_zlfh_mxbjc.sczt%TYPE; --生存状态（1:死亡，2:生存，3:失访）  
    v_scztxg       zjjk_sf_zlfh_mxbjc.scztxg%TYPE; --生存状态修改（1:死亡，2:生存，3:失访）  
    v_swrq         zjjk_sf_zlfh_mxbjc.swrq%TYPE; --死亡日期
    v_swrqxg       zjjk_sf_zlfh_mxbjc.swrqxg%TYPE; --死亡日期修改
    v_gbsy         zjjk_sf_zlfh_mxbjc.gbsy%TYPE; --根本死因
    v_gbsyxg       zjjk_sf_zlfh_mxbjc.gbsyxg%TYPE; --根本死因修改
    v_jynhjsfbh    zjjk_sf_zlfh_mxbjc.jynhjsfbh%TYPE; --近1年户籍是否变化（县区）（0:是，1:否）  
    v_fhfs         zjjk_sf_zlfh_mxbjc.fhfs%TYPE; --复核方式
    v_fhry         zjjk_sf_zlfh_mxbjc.fhry%TYPE; --复核人员
    v_jcsj         zjjk_sf_zlfh_mxbjc.jcsj%TYPE; --检查时间
    v_sffh         zjjk_sf_zlfh_mxbjc.sffh%TYPE; --是否符合（1:符合，2:不符合）  
    v_fhzt         zjjk_sf_zlfh_mxbjc.fhzt%TYPE; --复核状态
    v_cjrid        zjjk_sf_zlfh_mxbjc.cjrid%TYPE; --创建人ID
    v_cjrxm        zjjk_sf_zlfh_mxbjc.cjrxm%TYPE; --创建人姓名
    v_cjsj         zjjk_sf_zlfh_mxbjc.cjsj%TYPE; --创建时间
    v_xgrid        zjjk_sf_zlfh_mxbjc.xgrid%TYPE; --修改人id
    v_xgrxm        zjjk_sf_zlfh_mxbjc.xgrxm%TYPE; --修改人姓名
    v_xgsj         zjjk_sf_zlfh_mxbjc.xgsj%TYPE; --修改时间
  
  BEGIN
    json_data(data_in, '糖尿病随访病例填报', v_json_data);
    v_sysdate := SYSDATE;
    v_czyjgdm := json_str(v_json_data, 'czyjgdm');
    v_czyyhid := json_str(v_json_data, 'czyyhid');
    v_czyjgjb := json_str(v_json_data, 'czyjgjb');
    v_czyyhxm := json_str(v_json_data, 'czyyhxm');
  
    v_id           := json_str(v_json_data, 'id');
    v_jbxxybgksfyz := json_str(v_json_data, 'jbxxybgksfyz');
    v_kpbm         := json_str(v_json_data, 'kpbm');
    v_kpbmxg       := json_str(v_json_data, 'kpbmxg');
    v_hzxm         := json_str(v_json_data, 'hzxm');
    v_hzxmxg       := json_str(v_json_data, 'hzxmxg');
    v_lxdh         := json_str(v_json_data, 'lxdh');
    v_lxdhxg       := json_str(v_json_data, 'lxdhxg');
    v_hjdz         := json_str(v_json_data, 'hjdz');
    v_hjdzxg       := json_str(v_json_data, 'hjdzxg');
    v_sczt         := json_str(v_json_data, 'sczt');
    v_scztxg       := json_str(v_json_data, 'scztxg');
    v_swrq         := std(json_str(v_json_data, 'swrq'));
    v_swrqxg       := json_str(v_json_data, 'swrqxg');
    v_gbsy         := json_str(v_json_data, 'gbsy');
    v_gbsyxg       := json_str(v_json_data, 'gbsyxg');
    v_jynhjsfbh    := json_str(v_json_data, 'jynhjsfbh');
    v_fhfs         := json_str(v_json_data, 'fhfs');
    v_fhry         := json_str(v_json_data, 'fhry');
    v_jcsj         := std(json_str(v_json_data, 'jcsj'));
    v_sffh         := json_str(v_json_data, 'sffh');
    v_fhzt         := json_str(v_json_data, 'fhzt');
    v_cjrid        := json_str(v_json_data, 'cjrid');
    v_cjrxm        := json_str(v_json_data, 'cjrxm');
    v_cjsj         := std(json_str(v_json_data, 'cjsj'));
    v_xgrid        := json_str(v_json_data, 'xgrid');
    v_xgrxm        := json_str(v_json_data, 'xgrxm');
    v_xgsj         := std(json_str(v_json_data, 'xgsj'));
  
    --校验权限
    IF v_czyjgjb <> '3' THEN
      --非区县
      v_err := '当前机构无病例填报权限!';
      RAISE err_custom;
    END IF;
  
    --校验状态
    SELECT COUNT(1)
      INTO v_count
      FROM zjjk_csf_zlfh a, zjjk_zlfhsj_sf b
     WHERE a.cctjid = b.jlbh
       AND b.zt = '1'
       AND a.id = v_id
       AND a.csflx = '2'
       AND a.zt = '1'
       AND nvl(a.fhzt, '0') IN ('0', '1', '6');
    IF v_count <> 1 THEN
      v_err := '未找到待填报的病例!';
      RAISE err_custom;
    END IF;
  
    --校验必填项目
    IF v_id IS NULL THEN
      v_err := '复核ID不能为空!';
      RAISE err_custom;
    END IF;
    IF v_jbxxybgksfyz IS NULL THEN
      v_err := '基本信息与报告卡是否一致不能为空!';
      RAISE err_custom;
    END IF;
    IF v_hzxm IS NULL THEN
      v_err := '患者姓名不能为空!';
      RAISE err_custom;
    END IF;
    IF v_lxdh IS NULL THEN
      v_err := '联系电话不能为空!';
      RAISE err_custom;
    END IF;
    IF v_hjdz IS NULL THEN
      v_err := '户籍地址不能为空!';
      RAISE err_custom;
    END IF;
    IF v_sczt IS NULL THEN
      v_err := '生存状态不能为空!';
      RAISE err_custom;
    END IF;
    IF v_jynhjsfbh IS NULL THEN
      v_err := '近1年户籍是否变化不能为空!';
      RAISE err_custom;
    END IF;
    IF v_fhfs IS NULL THEN
      v_err := '复核方式不能为空!';
      RAISE err_custom;
    END IF;
    IF v_fhry IS NULL THEN
      v_err := '复核人员不能为空!';
      RAISE err_custom;
    END IF;
    IF v_jcsj IS NULL THEN
      v_err := '检查时间不能为空!';
      RAISE err_custom;
    END IF;
    IF v_sffh IS NULL THEN
      v_err := '是否符合不能为空!';
      RAISE err_custom;
    END IF;
  
    --判断新增还是修改
    SELECT COUNT(1)
      INTO v_count
      FROM zjjk_sf_zlfh_mxbjc a
     WHERE a.id = v_id;
    IF v_count > 0 THEN
      --修改
      UPDATE zjjk_sf_zlfh_mxbjc
         SET id           = v_id,
             jbxxybgksfyz = v_jbxxybgksfyz,
             kpbm         = v_kpbm,
             kpbmxg       = v_kpbmxg,
             hzxm         = v_hzxm,
             hzxmxg       = v_hzxmxg,
             lxdh         = v_lxdh,
             lxdhxg       = v_lxdhxg,
             hjdz         = v_hjdz,
             hjdzxg       = v_hjdzxg,
             sczt         = v_sczt,
             scztxg       = v_scztxg,
             swrq         = v_swrq,
             swrqxg       = v_swrqxg,
             gbsy         = v_gbsy,
             gbsyxg       = v_gbsyxg,
             jynhjsfbh    = v_jynhjsfbh,
             fhfs         = v_fhfs,
             fhry         = v_fhry,
             jcsj         = v_jcsj,
             sffh         = v_sffh,
             fhzt         = '1',
             xgrid        = v_xgrid,
             xgrxm        = v_xgrxm,
             xgsj         = v_xgsj
       WHERE id = v_id;
    ELSE
      --新增
      INSERT INTO zjjk_sf_zlfh_mxbjc
        (id, --id
         jbxxybgksfyz, --基本信息与报告卡是否一致
         kpbm, --卡片编码
         kpbmxg, --卡片编码修改
         hzxm, --患者姓名
         hzxmxg, --患者姓名修改
         lxdh, --联系电话
         lxdhxg, --联系电话修改
         hjdz, --户籍地址
         hjdzxg, --户籍地址修改
         sczt, --生存状态（1:死亡，2:生存，3:失访）  
         scztxg, --生存状态修改（1:死亡，2:生存，3:失访）  
         swrq, --死亡日期
         swrqxg, --死亡日期修改
         gbsy, --根本死因
         gbsyxg, --根本死因修改
         jynhjsfbh, --近1年户籍是否变化（县区）（0:是，1:否）  
         fhfs, --复核方式
         fhry, --复核人员
         jcsj, --检查时间
         sffh, --是否符合（1:符合，2:不符合）  
         fhzt, --复核状态
         cjrid, --创建人id
         cjrxm, --创建人姓名
         cjsj) --创建时间
      VALUES
        (v_id, --id
         v_jbxxybgksfyz, --基本信息与报告卡是否一致
         v_kpbm, --卡片编码
         v_kpbmxg, --卡片编码修改
         v_hzxm, --患者姓名
         v_hzxmxg, --患者姓名修改
         v_lxdh, --联系电话
         v_lxdhxg, --联系电话修改
         v_hjdz, --户籍地址
         v_hjdzxg, --户籍地址修改
         v_sczt, --生存状态（1:死亡，2:生存，3:失访）  
         v_scztxg, --生存状态修改（1:死亡，2:生存，3:失访）  
         v_swrq, --死亡日期
         v_swrqxg, --死亡日期修改
         v_gbsy, --根本死因
         v_gbsyxg, --根本死因修改
         v_jynhjsfbh, --近1年户籍是否变化（县区）（0:是，1:否）  
         v_fhfs, --复核方式
         v_fhry, --复核人员
         v_jcsj, --检查时间
         v_sffh, --是否符合（1:符合，2:不符合）  
         '1', --复核状态（0 未开始 1 进行中 2 完成 3 审核不通过）
         v_czyyhid, --创建人id
         v_czyyhxm, --创建人姓名
         v_sysdate); --创建时间
    END IF;
    --更新复核状态
    UPDATE zjjk_csf_zlfh a
       SET a.fhzt = '1', a.fhbz = '1'
     WHERE a.id = v_id
       AND a.csflx = '2';
    --返回
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_sf_blfh_mb_update;
  /*-----------------------------------------------------------------------------
  || 功能描述 ：慢病随访病例提交
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_sf_blfh_mb_tj(data_in    IN CLOB, --入参
                              result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
  
    v_id zjjk_mb_zlfh.id%TYPE; --ID
    --公共变量
    v_sysdate DATE;
    v_czyjgjb VARCHAR2(3);
    v_czyjgdm VARCHAR2(50);
    v_czyyhid VARCHAR2(50);
    v_czyyhxm VARCHAR2(50);
    v_count   NUMBER;
  
  BEGIN
    json_data(data_in, '慢性病随访病例提交', v_json_data);
    v_sysdate := SYSDATE;
    v_czyjgdm := json_str(v_json_data, 'czyjgdm');
    v_czyyhid := json_str(v_json_data, 'czyyhid');
    v_czyjgjb := json_str(v_json_data, 'czyjgjb');
    v_czyyhxm := json_str(v_json_data, 'czyyhxm');
  
    v_id := json_str(v_json_data, 'id');
    IF v_id IS NULL THEN
      v_err := 'id不能为空!';
      RAISE err_custom;
    END IF;
    --更新状态
    UPDATE zjjk_csf_zlfh a
       SET a.fhzt    = '3',
           a.fhczrid = v_czyyhid,
           a.fhczrxm = v_czyyhxm,
           a.fhjgid  = v_czyjgdm,
           a.fhsj    = v_sysdate
     WHERE a.fhzt = '1'
       AND a.id = v_id
       AND a.csflx = '2'
       AND a.zt = '1';
    IF SQL%ROWCOUNT <> 1 THEN
      v_err := '更新病例状态出错!';
      RAISE err_custom;
    END IF;
    UPDATE zjjk_sf_zlfh_mxbjc a SET a.fhzt = '3' WHERE a.id = v_id;
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_sf_blfh_mb_tj;
  /*-----------------------------------------------------------------------------
  || 功能描述 ：慢性病随访病例审核
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_sf_blfh_mb_zt_sh(data_in    IN CLOB, --入参
                                 result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err    VARCHAR2(2000);
    v_id     zjjk_mb_zlfh.id%TYPE; --ID
    v_shzt   zjjk_mb_zlfh.fhzt%TYPE; --ID
    v_shyj   zjjk_mb_zlfh.shyj%TYPE; --复核意见
    v_kpbmsh zjjk_sf_zlfh_mxbjc.kpbmsh%TYPE; --卡片编码审核
    v_hzxmsh zjjk_sf_zlfh_mxbjc.hzxmsh%TYPE; --患者姓名审核
    v_lxdhsh zjjk_sf_zlfh_mxbjc.lxdhsh%TYPE; --联系电话审核
    v_hjdzsh zjjk_sf_zlfh_mxbjc.hjdzsh%TYPE; --户籍地址审核
    v_scztsh zjjk_sf_zlfh_mxbjc.scztsh%TYPE; --生存状态审核
    v_swrqsh zjjk_sf_zlfh_mxbjc.swrqsh%TYPE; --死亡日期审核
    v_gbsysh zjjk_sf_zlfh_mxbjc.gbsysh%TYPE; --根本死因审核

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

    v_id     := json_str(v_json_data, 'id');
    v_shzt   := json_str(v_json_data, 'fhzt');
    v_shyj   := json_str(v_json_data, 'shyj');
    v_kpbmsh := json_str(v_json_data, 'kpbmsh');
    v_hzxmsh := json_str(v_json_data, 'hzxmsh');
    v_lxdhsh := json_str(v_json_data, 'lxdhsh');
    v_hjdzsh := json_str(v_json_data, 'hjdzsh');
    v_scztsh := json_str(v_json_data, 'scztsh');
    v_swrqsh := json_str(v_json_data, 'swrqsh');
    v_gbsysh := json_str(v_json_data, 'gbsysh');
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
    UPDATE zjjk_sf_zlfh_mxbjc a
       SET a.kpbmsh = v_kpbmsh,
           a.hzxmsh = v_hzxmsh,
           a.lxdhsh = v_lxdhsh,
           a.hjdzsh = v_hjdzsh,
           a.scztsh = v_scztsh,
           a.swrqsh = v_swrqsh,
           a.gbsysh = v_gbsysh,
           a.fhzt   = v_shzt
     WHERE a.id = v_id;

    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_sf_blfh_mb_zt_sh;
END pkg_zjmb_zlfh_csf;
