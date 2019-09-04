CREATE OR REPLACE PACKAGE BODY pkg_zjmb_zlfh_bgk AS
  --初始化包序号--
  /******************************************************************************/
  /*  程序包名 ：pkg_zjmb_zlfh                                                  */
  /*  业务环节 ：浙江慢病_质量复核                                              */
  /*  功能描述 ：质量复核的存储过程及函数                                       */
  /*                                                                            */
  /*  作    者 ：yuanruiqing  作成日期 ：2018-10-16   版本编号 ：Ver 1.0.0      */
  /*----------------------------------------------------------------------------*/
  /*  修改记录 ：                                                               */
  /******************************************************************************/
  /*----------------------------------------------------------------------------*/
  /*----------------------------------------------------------------------------*/
  /*----------------------------------------------------------------------------
  || 功能描述 ：糖尿病病例抽查
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_mbcc_tnb_update(data_in    IN CLOB, --入参
                                result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
     
    --公共变量
    v_sysdate date;
    v_czyjgjb varchar2(3);
    v_czyjgdm varchar2(50);
    v_czyyhid varchar2(50);
    v_czyyhxm varchar2(50);
    v_count   number;
    v_ccts    number;
     
    v_id      zjjk_mb_zlfh.id%TYPE; --ID
    v_bgkid   zjjk_mb_zlfh.bgkid%TYPE; --报告卡ID
    v_cctjid  zjjk_mb_zlfh.cctjid%TYPE; --抽查条件ID
    v_mblx    zjjk_mb_zlfh.mblx%TYPE; --慢病类型:1-脑卒中 2-冠心病 3-糖尿病 4-恶性肿瘤
    v_ccbz    zjjk_mb_zlfh.ccbz%TYPE; --抽查病种:101-脑卒中 201-冠心病 301-糖尿病 401-肺癌 402-肝癌 403-胃癌 404-食管癌 405-结、直肠癌 406-女性乳腺癌 407-其他恶性肿瘤
    v_ccczrid zjjk_mb_zlfh.ccczrid%TYPE; --抽查操作人id
    v_ccczrxm zjjk_mb_zlfh.ccczrxm%TYPE; --抽查操作人姓名
    v_ccjgid  zjjk_mb_zlfh.ccjgid%TYPE; --抽查机构id
    v_ccsj    zjjk_mb_zlfh.ccsj%TYPE; --抽查时间
    v_fhczrid zjjk_mb_zlfh.fhczrid%TYPE; --复核操作人id
    v_fhczrxm zjjk_mb_zlfh.fhczrxm%TYPE; --复核操作人姓名
    v_fhjgid  zjjk_mb_zlfh.fhjgid%TYPE; --复核机构id
    v_fhzt    zjjk_mb_zlfh.fhzt%TYPE; --复核状态
    v_fhsj    zjjk_mb_zlfh.fhsj%TYPE; --复核时间
    v_shczrid zjjk_mb_zlfh.shczrid%TYPE; --审核操作人id
    v_shczrxm zjjk_mb_zlfh.shczrxm%TYPE; --复核操作人姓名
    v_shjgid  zjjk_mb_zlfh.shjgid%TYPE; --审核机构id
    v_shsj    zjjk_mb_zlfh.shsj%TYPE; --审核时间
    v_zt      zjjk_mb_zlfh.zt%TYPE; --抽查状态（1:正常，0:作废）
    v_fhbz    zjjk_mb_zlfh.fhbz%TYPE; --复核标志：0-未复核 1-已复核
    v_bccjgid VARCHAR2(4000); --被抽查机构id
  
    --其他变量
    v_bgkid_s VARCHAR2(2000); --被抽查的报告卡IDs
  
  BEGIN
    json_data(data_in, '糖尿病病例抽查', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid');
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    v_czyyhxm := Json_Str(v_Json_Data, 'czyyhxm');
  
    v_id      := Json_Str(v_Json_Data, 'id');
    v_bgkid   := Json_Str(v_Json_Data, 'bgkid');
    v_cctjid  := Json_Str(v_Json_Data, 'cctjid');
    v_mblx    := Json_Str(v_Json_Data, 'mblx');
    v_ccbz    := Json_Str(v_Json_Data, 'ccbz');
    v_ccczrid := Json_Str(v_Json_Data, 'ccczrid');
    v_ccczrxm := Json_Str(v_Json_Data, 'ccczrxm');
    v_ccjgid  := Json_Str(v_Json_Data, 'ccjgid');
    v_ccsj    := Json_Str(v_Json_Data, 'ccsj');
    v_fhczrid := Json_Str(v_Json_Data, 'fhczrid');
    v_fhczrxm := Json_Str(v_Json_Data, 'fhczrxm');
    v_fhjgid  := Json_Str(v_Json_Data, 'fhjgid');
    v_fhzt    := Json_Str(v_Json_Data, 'fhzt');
    v_fhsj    := Json_Str(v_Json_Data, 'fhsj');
    v_shczrid := Json_Str(v_Json_Data, 'shczrid');
    v_shczrxm := Json_Str(v_Json_Data, 'shczrxm');
    v_shjgid  := Json_Str(v_Json_Data, 'shjgid');
    v_shsj    := Json_Str(v_Json_Data, 'shsj');
    v_zt      := Json_Str(v_Json_Data, 'zt');
    v_fhbz    := Json_Str(v_Json_Data, 'fhbz');
    v_bccjgid := Json_Str(v_Json_Data, 'bccjgid');
    v_bgkid_s := Json_Str(v_Json_Data, 'bgkid_s');
  
    --校验必填项目
    if v_bgkid_s is null then
      v_err := '报告卡ID不能为空!';
      raise err_custom;
    end if;
    if v_cctjid is null then
      v_err := '抽查条件ID不能为空!';
      raise err_custom;
    end if;
    --如果抽查区县
    if v_bccjgid is null THEN
      SELECT wm_concat(bgk.vc_bgdw)
        INTO v_bccjgid
        FROM zjjk_tnb_bgk bgk WHERE v_bgkid_s LIKE '%'||bgk.vc_bgkid||'%';
      --v_err := '被抽查机构不能为空!';
      --raise err_custom;
    end if;
    --校验权限
    if v_czyjgjb <> '3' then
      --非区县
      v_err := '当前机构无抽查权限!';
      raise err_custom;
    end if;
  
    --校验糖尿病是否已病例复核
    select count(1)
      into v_count
      from zjjk_mb_zlfh a
     where a.cctjid = v_cctjid
       and v_bccjgid LIKE '%'||bccjgid||'%'
       and zt = '1'
       and fhbz = '1'
       and a.mblx = '3';
    if v_count > 0 then
      v_err := '该次抽查已存在病例复核记录!';
      raise err_custom;
    end if;
    --删除未复核病例，重新生成
    update zjjk_mb_zlfh a
       set a.zt = '0'
     where a.cctjid = v_cctjid
       and v_bccjgid LIKE '%'||bccjgid||'%'
       and zt = '1'
       and fhbz = '0'
       and a.mblx = '3';
    --获取抽查条数的条件
    SELECT ccts
      INTO v_ccts
      FROM zjjk_zlfhsj a
     WHERE a.zt = 1;
    --校验bgkid合法性
/*    select min(count(vc_bgdw))
      into v_count
      from zjjk_tnb_bgk a
     where a.vc_bgkid in
           (SELECT DISTINCT column_value column_value
              FROM TABLE(split(v_bgkid_s, ',')))
     GROUP BY a.vc_bgdw;
    if v_count <> v_ccts then
      v_err := '本次抽查有医疗机构未找到'||v_ccts||'条糖尿病病例!';
      raise err_custom;
    end if;*/
    --写入糖尿病
    insert into zjjk_mb_zlfh
      (id,
       bgkid,
       cctjid,
       mblx,
       ccbz,
       ccczrid,
       ccczrxm,
       ccjgid,
       ccsj,
       zt,
       fhbz,
       fhzt,
       bccjgid,
       ccxh)
      select DISTINCT sys_guid(),
                      column_value,
                      v_cctjid,
                      '3',
                      '301',
                      v_czyyhid,
                      v_czyyhxm,
                      v_czyjgdm,
                      v_sysdate,
                      '1',
                      '0',
                      '0',
                      (SELECT bgk.vc_bgdw FROM zjjk_tnb_bgk bgk WHERE bgk.vc_bgkid = column_value),
                      rownum
        FROM TABLE(split(v_bgkid_s, ','));
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_mbcc_tnb_update;
  /*-----------------------------------------------------------------------------
  || 功能描述 ：脑卒中病例抽查
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_mbcc_ncz_update(data_in    IN CLOB, --入参
                                result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
  
    --公共变量
    v_sysdate date;
    v_czyjgjb varchar2(3);
    v_czyjgdm varchar2(50);
    v_czyyhid varchar2(50);
    v_czyyhxm varchar2(50);
    v_count   number;
    v_ccts    number;
      
    v_id      zjjk_mb_zlfh.id%TYPE; --ID
    v_bgkid   zjjk_mb_zlfh.bgkid%TYPE; --报告卡ID
    v_cctjid  zjjk_mb_zlfh.cctjid%TYPE; --抽查条件ID
    v_mblx    zjjk_mb_zlfh.mblx%TYPE; --慢病类型:1-脑卒中 2-冠心病 3-糖尿病 4-恶性肿瘤
    v_ccbz    zjjk_mb_zlfh.ccbz%TYPE; --抽查病种:101-脑卒中 201-冠心病 301-糖尿病 401-肺癌 402-肝癌 403-胃癌 404-食管癌 405-结、直肠癌 406-女性乳腺癌 407-其他恶性肿瘤
    v_ccczrid zjjk_mb_zlfh.ccczrid%TYPE; --抽查操作人id
    v_ccczrxm zjjk_mb_zlfh.ccczrxm%TYPE; --抽查操作人姓名
    v_ccjgid  zjjk_mb_zlfh.ccjgid%TYPE; --抽查机构id
    v_ccsj    zjjk_mb_zlfh.ccsj%TYPE; --抽查时间
    v_fhczrid zjjk_mb_zlfh.fhczrid%TYPE; --复核操作人id
    v_fhczrxm zjjk_mb_zlfh.fhczrxm%TYPE; --复核操作人姓名
    v_fhjgid  zjjk_mb_zlfh.fhjgid%TYPE; --复核机构id
    v_fhzt    zjjk_mb_zlfh.fhzt%TYPE; --复核状态
    v_fhsj    zjjk_mb_zlfh.fhsj%TYPE; --复核时间
    v_shczrid zjjk_mb_zlfh.shczrid%TYPE; --审核操作人id
    v_shczrxm zjjk_mb_zlfh.shczrxm%TYPE; --复核操作人姓名
    v_shjgid  zjjk_mb_zlfh.shjgid%TYPE; --审核机构id
    v_shsj    zjjk_mb_zlfh.shsj%TYPE; --审核时间
    v_zt      zjjk_mb_zlfh.zt%TYPE; --抽查状态（1:正常，0:作废）
    v_fhbz    zjjk_mb_zlfh.fhbz%TYPE; --复核标志：0-未复核 1-已复核
    v_bccjgid VARCHAR2(4000); --被抽查机构id
  
    --其他变量
    v_bgkid_s VARCHAR2(2000); --被抽查的报告卡IDs
  
  BEGIN
    json_data(data_in, '脑卒中病例抽查', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid');
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    v_czyyhxm := Json_Str(v_Json_Data, 'czyyhxm');
  
    v_id      := Json_Str(v_Json_Data, 'id');
    v_bgkid   := Json_Str(v_Json_Data, 'bgkid');
    v_cctjid  := Json_Str(v_Json_Data, 'cctjid');
    v_mblx    := Json_Str(v_Json_Data, 'mblx');
    v_ccbz    := Json_Str(v_Json_Data, 'ccbz');
    v_ccczrid := Json_Str(v_Json_Data, 'ccczrid');
    v_ccczrxm := Json_Str(v_Json_Data, 'ccczrxm');
    v_ccjgid  := Json_Str(v_Json_Data, 'ccjgid');
    v_ccsj    := Json_Str(v_Json_Data, 'ccsj');
    v_fhczrid := Json_Str(v_Json_Data, 'fhczrid');
    v_fhczrxm := Json_Str(v_Json_Data, 'fhczrxm');
    v_fhjgid  := Json_Str(v_Json_Data, 'fhjgid');
    v_fhzt    := Json_Str(v_Json_Data, 'fhzt');
    v_fhsj    := Json_Str(v_Json_Data, 'fhsj');
    v_shczrid := Json_Str(v_Json_Data, 'shczrid');
    v_shczrxm := Json_Str(v_Json_Data, 'shczrxm');
    v_shjgid  := Json_Str(v_Json_Data, 'shjgid');
    v_shsj    := Json_Str(v_Json_Data, 'shsj');
    v_zt      := Json_Str(v_Json_Data, 'zt');
    v_fhbz    := Json_Str(v_Json_Data, 'fhbz');
    v_bccjgid := Json_Str(v_Json_Data, 'bccjgid');
    v_bgkid_s := Json_Str(v_Json_Data, 'bgkid_s');
  
    --校验必填项目
    if v_bgkid_s is null then
      v_err := '报告卡ID不能为空!';
      raise err_custom;
    end if;
    if v_cctjid is null then
      v_err := '抽查条件ID不能为空!';
      raise err_custom;
    end if;
    --如果抽查区县
    if v_bccjgid is null THEN
      SELECT wm_concat(bgk.vc_bkdwyy)
        INTO v_bccjgid
        FROM zjjk_xnxg_bgk bgk WHERE v_bgkid_s LIKE '%'||bgk.vc_bgkid||'%';
      --v_err := '被抽查机构不能为空!';
      --raise err_custom;
    end if;
    --校验权限
    if v_czyjgjb <> '3' then
      --非区县
      v_err := '当前机构无抽查权限!';
      raise err_custom;
    end if;
  
    --校验是否已病例复核
    select count(1)
      into v_count
      from zjjk_mb_zlfh a
     where a.cctjid = v_cctjid
       and v_bccjgid LIKE '%'||bccjgid||'%'
       and zt = '1'
       and fhbz = '1'
       and a.mblx = '1';
    if v_count > 0 then
      v_err := '该次抽查已存在病例复核记录!';
      raise err_custom;
    end if;
    --删除未复核病例，重新生成
    update zjjk_mb_zlfh a
       set a.zt = '0'
     where a.cctjid = v_cctjid
       and v_bccjgid LIKE '%'||bccjgid||'%'
       and zt = '1'
       and fhbz = '0'
       and a.mblx = '1';
    --获取抽查条数的条件
    SELECT ccts
      INTO v_ccts
      FROM zjjk_zlfhsj a
     WHERE a.zt = 1;        
      --校验bgkid合法性
/*    SELECT MIN(COUNT(a.vc_bkdwyy))
      INTO v_count
      FROM zjjk_xnxg_bgk a
     WHERE a.vc_nczzd IN ('1', '2', '3', '4', '5', '6')
       AND a.vc_bgkid IN
           (SELECT DISTINCT column_value column_value
              FROM TABLE(split(v_bgkid_s, ',')))
     GROUP BY a.vc_bkdwyy;
    if v_count <> v_ccts then
      v_err := '本次抽查有医疗机构未找到'||v_ccts||'条脑卒中病例!';
      raise err_custom;
    end if;*/
    --写入脑卒中
    insert into zjjk_mb_zlfh
      (id,
       bgkid,
       cctjid,
       mblx,
       ccbz,
       ccczrid,
       ccczrxm,
       ccjgid,
       ccsj,
       zt,
       fhbz,
       fhzt,
       bccjgid,
       ccxh)
      select DISTINCT sys_guid(),
                      column_value,
                      v_cctjid,
                      '1',
                      '101',
                      v_czyyhid,
                      v_czyyhxm,
                      v_czyjgdm,
                      v_sysdate,
                      '1',
                      '0',
                      '0',
                      (SELECT bgk.vc_bkdwyy FROM zjjk_xnxg_bgk bgk WHERE bgk.vc_bgkid = column_value),
                      rownum
        FROM TABLE(split(v_bgkid_s, ','));
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_mbcc_ncz_update;
  /*-----------------------------------------------------------------------------
  || 功能描述 ：冠心病病例抽查
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_mbcc_gxb_update(data_in    IN CLOB, --入参
                                result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
  
    --公共变量
    v_sysdate date;
    v_czyjgjb varchar2(3);
    v_czyjgdm varchar2(50);
    v_czyyhid varchar2(50);
    v_czyyhxm varchar2(50);
    v_count   number;
    v_ccts    number;
  
    v_id      zjjk_mb_zlfh.id%TYPE; --ID
    v_bgkid   zjjk_mb_zlfh.bgkid%TYPE; --报告卡ID
    v_cctjid  zjjk_mb_zlfh.cctjid%TYPE; --抽查条件ID
    v_mblx    zjjk_mb_zlfh.mblx%TYPE; --慢病类型:1-脑卒中 2-冠心病 3-糖尿病 4-恶性肿瘤
    v_ccbz    zjjk_mb_zlfh.ccbz%TYPE; --抽查病种:101-脑卒中 201-冠心病 301-糖尿病 401-肺癌 402-肝癌 403-胃癌 404-食管癌 405-结、直肠癌 406-女性乳腺癌 407-其他恶性肿瘤
    v_ccczrid zjjk_mb_zlfh.ccczrid%TYPE; --抽查操作人id
    v_ccczrxm zjjk_mb_zlfh.ccczrxm%TYPE; --抽查操作人姓名
    v_ccjgid  zjjk_mb_zlfh.ccjgid%TYPE; --抽查机构id
    v_ccsj    zjjk_mb_zlfh.ccsj%TYPE; --抽查时间
    v_fhczrid zjjk_mb_zlfh.fhczrid%TYPE; --复核操作人id
    v_fhczrxm zjjk_mb_zlfh.fhczrxm%TYPE; --复核操作人姓名
    v_fhjgid  zjjk_mb_zlfh.fhjgid%TYPE; --复核机构id
    v_fhzt    zjjk_mb_zlfh.fhzt%TYPE; --复核状态
    v_fhsj    zjjk_mb_zlfh.fhsj%TYPE; --复核时间
    v_shczrid zjjk_mb_zlfh.shczrid%TYPE; --审核操作人id
    v_shczrxm zjjk_mb_zlfh.shczrxm%TYPE; --复核操作人姓名
    v_shjgid  zjjk_mb_zlfh.shjgid%TYPE; --审核机构id
    v_shsj    zjjk_mb_zlfh.shsj%TYPE; --审核时间
    v_zt      zjjk_mb_zlfh.zt%TYPE; --抽查状态（1:正常，0:作废）
    v_fhbz    zjjk_mb_zlfh.fhbz%TYPE; --复核标志：0-未复核 1-已复核
    v_bccjgid VARCHAR2(4000); --被抽查机构id
  
    --其他变量
    v_bgkid_s VARCHAR2(2000); --被抽查的报告卡IDs
  
  BEGIN
    json_data(data_in, '冠心病病例抽查', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid');
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    v_czyyhxm := Json_Str(v_Json_Data, 'czyyhxm');
  
    v_id      := Json_Str(v_Json_Data, 'id');
    v_bgkid   := Json_Str(v_Json_Data, 'bgkid');
    v_cctjid  := Json_Str(v_Json_Data, 'cctjid');
    v_mblx    := Json_Str(v_Json_Data, 'mblx');
    v_ccbz    := Json_Str(v_Json_Data, 'ccbz');
    v_ccczrid := Json_Str(v_Json_Data, 'ccczrid');
    v_ccczrxm := Json_Str(v_Json_Data, 'ccczrxm');
    v_ccjgid  := Json_Str(v_Json_Data, 'ccjgid');
    v_ccsj    := Json_Str(v_Json_Data, 'ccsj');
    v_fhczrid := Json_Str(v_Json_Data, 'fhczrid');
    v_fhczrxm := Json_Str(v_Json_Data, 'fhczrxm');
    v_fhjgid  := Json_Str(v_Json_Data, 'fhjgid');
    v_fhzt    := Json_Str(v_Json_Data, 'fhzt');
    v_fhsj    := Json_Str(v_Json_Data, 'fhsj');
    v_shczrid := Json_Str(v_Json_Data, 'shczrid');
    v_shczrxm := Json_Str(v_Json_Data, 'shczrxm');
    v_shjgid  := Json_Str(v_Json_Data, 'shjgid');
    v_shsj    := Json_Str(v_Json_Data, 'shsj');
    v_zt      := Json_Str(v_Json_Data, 'zt');
    v_fhbz    := Json_Str(v_Json_Data, 'fhbz');
    v_bccjgid := Json_Str(v_Json_Data, 'bccjgid');
    v_bgkid_s := Json_Str(v_Json_Data, 'bgkid_s');
  
    --校验必填项目
    if v_bgkid_s is null then
      v_err := '报告卡ID不能为空!';
      raise err_custom;
    end if;
    if v_cctjid is null then
      v_err := '抽查条件ID不能为空!';
      raise err_custom;
    end if;
    --如果抽查区县
    if v_bccjgid is null THEN
      SELECT wm_concat(bgk.vc_bkdwyy)
        INTO v_bccjgid
        FROM zjjk_xnxg_bgk bgk WHERE v_bgkid_s LIKE '%'||bgk.vc_bgkid||'%';
      --v_err := '被抽查机构不能为空!';
      --raise err_custom;
    end if;
    --校验权限
    if v_czyjgjb <> '3' then
      --非区县
      v_err := '当前机构无抽查权限!';
      raise err_custom;
    end if;
  
    --校验是否已病例复核
    select count(1)
      into v_count
      from zjjk_mb_zlfh a
     where a.cctjid = v_cctjid
       and v_bccjgid LIKE '%'||bccjgid||'%'
       and zt = '1'
       and fhbz = '1'
       and a.mblx = '2';
    if v_count > 0 then
      v_err := '该次抽查已存在病例复核记录!';
      raise err_custom;
    end if;
    --删除未复核病例，重新生成
    update zjjk_mb_zlfh a
       set a.zt = '0'
     where a.cctjid = v_cctjid
       and v_bccjgid LIKE '%'||bccjgid||'%'
       and zt = '1'
       and fhbz = '0'
       and a.mblx = '2';
    --获取抽查条数的条件
    SELECT ccts
      INTO v_ccts
      FROM zjjk_zlfhsj a
     WHERE a.zt = 1;
    --校验bgkid合法性
    --校验bgkid合法性
/*    SELECT MIN(COUNT(a.vc_bkdwyy))
      INTO v_count
      FROM zjjk_xnxg_bgk a
     WHERE a.vc_gxbzd in ('1', '2', '3')
       AND a.vc_bgkid IN
           (SELECT DISTINCT column_value column_value
              FROM TABLE(split(v_bgkid_s, ',')))
     GROUP BY a.vc_bkdwyy;
    if v_count <> v_ccts then
      v_err := '本次抽查有医疗机构未找到'||v_ccts||'条冠心病病例!';
      raise err_custom;
    end if;*/
    --写入冠心病
    insert into zjjk_mb_zlfh
      (id,
       bgkid,
       cctjid,
       mblx,
       ccbz,
       ccczrid,
       ccczrxm,
       ccjgid,
       ccsj,
       zt,
       fhbz,
       fhzt,
       bccjgid,
       ccxh)
      select DISTINCT sys_guid(),
                      column_value,
                      v_cctjid,
                      '2',
                      '201',
                      v_czyyhid,
                      v_czyyhxm,
                      v_czyjgdm,
                      v_sysdate,
                      '1',
                      '0',
                      '0',
                      (SELECT bgk.vc_bkdwyy FROM zjjk_xnxg_bgk bgk WHERE bgk.vc_bgkid = column_value),
                      rownum
        FROM TABLE(split(v_bgkid_s, ','));
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_mbcc_gxb_update;
  /*-----------------------------------------------------------------------------
  || 功能描述 ：肿瘤病例抽查
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_mbcc_zl_update(data_in    IN CLOB, --入参
                               result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
  
    --公共变量
    v_sysdate date;
    v_czyjgjb varchar2(3);
    v_czyjgdm varchar2(50);
    v_czyyhid varchar2(50);
    v_czyyhxm varchar2(50);
    v_count   number;
    v_ccts    number;
  
    v_id      zjjk_mb_zlfh.id%TYPE; --ID
    v_bgkid   zjjk_mb_zlfh.bgkid%TYPE; --报告卡ID
    v_cctjid  zjjk_mb_zlfh.cctjid%TYPE; --抽查条件ID
    v_mblx    zjjk_mb_zlfh.mblx%TYPE; --慢病类型:1-脑卒中 2-冠心病 3-糖尿病 4-恶性肿瘤
    v_ccbz    zjjk_mb_zlfh.ccbz%TYPE; --抽查病种:101-脑卒中 201-冠心病 301-糖尿病 401-肺癌 402-肝癌 403-胃癌 404-食管癌 405-结、直肠癌 406-女性乳腺癌 407-其他恶性肿瘤
    v_ccczrid zjjk_mb_zlfh.ccczrid%TYPE; --抽查操作人id
    v_ccczrxm zjjk_mb_zlfh.ccczrxm%TYPE; --抽查操作人姓名
    v_ccjgid  zjjk_mb_zlfh.ccjgid%TYPE; --抽查机构id
    v_ccsj    zjjk_mb_zlfh.ccsj%TYPE; --抽查时间
    v_fhczrid zjjk_mb_zlfh.fhczrid%TYPE; --复核操作人id
    v_fhczrxm zjjk_mb_zlfh.fhczrxm%TYPE; --复核操作人姓名
    v_fhjgid  zjjk_mb_zlfh.fhjgid%TYPE; --复核机构id
    v_fhzt    zjjk_mb_zlfh.fhzt%TYPE; --复核状态
    v_fhsj    zjjk_mb_zlfh.fhsj%TYPE; --复核时间
    v_shczrid zjjk_mb_zlfh.shczrid%TYPE; --审核操作人id
    v_shczrxm zjjk_mb_zlfh.shczrxm%TYPE; --复核操作人姓名
    v_shjgid  zjjk_mb_zlfh.shjgid%TYPE; --审核机构id
    v_shsj    zjjk_mb_zlfh.shsj%TYPE; --审核时间
    v_zt      zjjk_mb_zlfh.zt%TYPE; --抽查状态（1:正常，0:作废）
    v_fhbz    zjjk_mb_zlfh.fhbz%TYPE; --复核标志：0-未复核 1-已复核
    v_bccjgid VARCHAR2(4000); --被抽查机构id
  
    --其他变量
    v_bgkid_s VARCHAR2(2000); --被抽查的报告卡IDs
  
  BEGIN
    json_data(data_in, '肿瘤病例抽查', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid');
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    v_czyyhxm := Json_Str(v_Json_Data, 'czyyhxm');
  
    v_id      := Json_Str(v_Json_Data, 'id');
    v_bgkid   := Json_Str(v_Json_Data, 'bgkid');
    v_cctjid  := Json_Str(v_Json_Data, 'cctjid');
    v_mblx    := Json_Str(v_Json_Data, 'mblx');
    v_ccbz    := Json_Str(v_Json_Data, 'ccbz');
    v_ccczrid := Json_Str(v_Json_Data, 'ccczrid');
    v_ccczrxm := Json_Str(v_Json_Data, 'ccczrxm');
    v_ccjgid  := Json_Str(v_Json_Data, 'ccjgid');
    v_ccsj    := Json_Str(v_Json_Data, 'ccsj');
    v_fhczrid := Json_Str(v_Json_Data, 'fhczrid');
    v_fhczrxm := Json_Str(v_Json_Data, 'fhczrxm');
    v_fhjgid  := Json_Str(v_Json_Data, 'fhjgid');
    v_fhzt    := Json_Str(v_Json_Data, 'fhzt');
    v_fhsj    := Json_Str(v_Json_Data, 'fhsj');
    v_shczrid := Json_Str(v_Json_Data, 'shczrid');
    v_shczrxm := Json_Str(v_Json_Data, 'shczrxm');
    v_shjgid  := Json_Str(v_Json_Data, 'shjgid');
    v_shsj    := Json_Str(v_Json_Data, 'shsj');
    v_zt      := Json_Str(v_Json_Data, 'zt');
    v_fhbz    := Json_Str(v_Json_Data, 'fhbz');
    v_bccjgid := Json_Str(v_Json_Data, 'bccjgid');
    v_bgkid_s := Json_Str(v_Json_Data, 'bgkid_s');
  
    --校验必填项目
    if v_bgkid_s is null then
      v_err := '报告卡ID不能为空!';
      raise err_custom;
    end if;
    if v_cctjid is null then
      v_err := '抽查条件ID不能为空!';
      raise err_custom;
    end if;
    --如果抽查区县
    if v_bccjgid is null THEN
      SELECT wm_concat(bgk.vc_bgdw)
        INTO v_bccjgid
        FROM zjjk_zl_bgk bgk WHERE v_bgkid_s LIKE '%'||bgk.vc_bgkid||'%';
      --v_err := '被抽查机构不能为空!';
      --raise err_custom;
    end if;
    --校验权限
    if v_czyjgjb <> '3' then
      --非区县
      v_err := '当前机构无抽查权限!';
      raise err_custom;
    end if;
  
    --校验是否已病例复核
    select count(1)
      into v_count
      from zjjk_mb_zlfh a
     where a.cctjid = v_cctjid
       and v_bccjgid LIKE '%'||bccjgid||'%'
       and zt = '1'
       and fhbz = '1'
       and a.mblx = '4';
    if v_count > 0 then
      v_err := '该次抽查已存在病例复核记录!';
      raise err_custom;
    end if;
    --删除未复核病例，重新生成
    update zjjk_mb_zlfh a
       set a.zt = '0'
     where a.cctjid = v_cctjid
       and v_bccjgid LIKE '%'||bccjgid||'%'
       and zt = '1'
       and fhbz = '0'
       and a.mblx = '4';
    --获取抽查条数的条件
    SELECT ccts
      INTO v_ccts
      FROM zjjk_zlfhsj a
     WHERE a.zt = 1;
    --校验bgkid合法性
/*    select min(count(a.vc_bgdw))
      into v_count
      from zjjk_zl_bgk a
     where a.vc_bgkid in
           (SELECT DISTINCT column_value column_value
              FROM TABLE(split(v_bgkid_s, ',')))
     GROUP BY a.vc_bgdw;  
    if v_count <> v_ccts then
      v_err := '本次抽查有医疗机构未找到'||v_ccts||'条肿瘤病例!';
      raise err_custom;
    end if;*/
    --写入肿瘤
    for rec_zlbg in (select column_value bgkid
                       FROM TABLE(split(v_bgkid_s, ','))) loop
      null;
    end loop;
    insert into zjjk_mb_zlfh
      (id,
       bgkid,
       cctjid,
       mblx,
       ccbz,
       ccczrid,
       ccczrxm,
       ccjgid,
       ccsj,
       zt,
       fhbz,
       fhzt,
       bccjgid,
       ccxh)
      select DISTINCT sys_guid(),
                      column_value,
                      v_cctjid,
                      '4',
                      (SELECT CASE
                                WHEN zl.vc_icd10 LIKE 'C34%' THEN
                                 '401' --肺癌
                                WHEN zl.vc_icd10 LIKE 'C22%' THEN
                                 '402' --肝癌
                                WHEN zl.vc_icd10 LIKE 'C16%' THEN
                                 '403'  --胃癌
                                WHEN zl.vc_icd10 LIKE 'C15%' THEN
                                 '404' --食管癌
                                WHEN zl.vc_icd10 LIKE 'C18%' OR
                                     zl.vc_icd10 LIKE 'C20%' THEN
                                 '405' --结、直肠癌
                                WHEN zl.vc_icd10 LIKE 'C50%' AND hz.vc_hzxb = '2' THEN
                                 '406' --女性乳腺癌
                                ELSE
                                 '407' --其他恶性肿瘤
                              END
                         FROM zjjk_zl_bgk zl, zjjk_zl_hzxx hz
                        WHERE zl.vc_hzid = hz.vc_personid
                          AND zl.vc_bgkid = column_value) ccbz,
                      v_czyyhid,
                      v_czyyhxm,
                      v_czyjgdm,
                      v_sysdate,
                      '1',
                      '0',
                      '0',
                      (SELECT bgk.vc_bgdw FROM zjjk_zl_bgk bgk WHERE bgk.vc_bgkid = column_value),
                      rownum
        FROM TABLE(split(v_bgkid_s, ','));
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_mbcc_zl_update;
  /*-----------------------------------------------------------------------------
  || 功能描述 ：糖尿病病例填报
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_mb_blfh_tnb_update(data_in    IN CLOB, --入参
                                   result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
  
    --公共变量
    v_sysdate date;
    v_czyjgjb varchar2(3);
    v_czyjgdm varchar2(50);
    v_czyyhid varchar2(50);
    v_czyyhxm varchar2(50);
    v_count   number;
  
    v_id             zjjk_mb_zlfh_tnb.id%TYPE; --ID
    v_bkdw           zjjk_mb_zlfh_tnb.bkdw%TYPE; --报卡单位
    v_zyh            zjjk_mb_zlfh_tnb.zyh%TYPE; --住院号
    v_jbxxybgksfyz   zjjk_mb_zlfh_tnb.jbxxybgksfyz%TYPE; --基本信息与报告卡是否一致（0 是 1否）
    v_kpzt           zjjk_mb_zlfh_tnb.kpzt%TYPE; --卡片状态
    v_blh            zjjk_mb_zlfh_tnb.blh%TYPE; --病理号
    v_bgkbm          zjjk_mb_zlfh_tnb.bgkbm%TYPE; --报告卡编码
    v_xm             zjjk_mb_zlfh_tnb.xm%TYPE; --姓名
    v_xmxg           zjjk_mb_zlfh_tnb.xmxg%TYPE; --姓名修改
    v_xb             zjjk_mb_zlfh_tnb.xb%TYPE; --性别
    v_xbxg           zjjk_mb_zlfh_tnb.xbxg%TYPE; --性别修改
    v_csrq           zjjk_mb_zlfh_tnb.csrq%TYPE; --出生日期
    v_csrqxg         zjjk_mb_zlfh_tnb.csrqxg%TYPE; --出生日期修改
    v_sfzh           zjjk_mb_zlfh_tnb.sfzh%TYPE; --身份证号
    v_sfzhxg         zjjk_mb_zlfh_tnb.sfzhxg%TYPE; --身份证号修改
    v_zdrq           zjjk_mb_zlfh_tnb.zdrq%TYPE; --诊断日期（发病日期）
    v_zdrqxg         zjjk_mb_zlfh_tnb.zdrqxg%TYPE; --诊断日期修改
    v_icd10          zjjk_mb_zlfh_tnb.icd10%TYPE; --ICD-10
    v_icd10xg        zjjk_mb_zlfh_tnb.icd10xg%TYPE; --ICD-10修改
    v_bgyysfwzdyy    zjjk_mb_zlfh_tnb.bgyysfwzdyy%TYPE; --报告医院是否为诊断医院（0 是 1否）
    v_zdyymc         zjjk_mb_zlfh_tnb.zdyymc%TYPE; --诊断医院名称
    v_czbajldjttj    zjjk_mb_zlfh_tnb.czbajldjttj%TYPE; --查找病案记录的具体途径（0 电子住院记录系统 1 电子以及纸质住院记录名单 2 纸质住院名单 3 其他）
    v_qtczbajldtj    zjjk_mb_zlfh_tnb.qtczbajldtj%TYPE; --其他查找病案记录的途径
    v_sfczbdcxgbazl  zjjk_mb_zlfh_tnb.sfczbdcxgbazl%TYPE; --是否查找并调出该对象住院诊治的相关病案资料（0 是 1否）
    v_bajlsfdzh      zjjk_mb_zlfh_tnb.bajlsfdzh%TYPE; --病案记录是否电子化（0 是 1否）
    v_dzbasjnr       zjjk_mb_zlfh_tnb.dzbasjnr%TYPE; --电子病案涉及内容（0 所有病案信息 1 只有病案首页）
    v_wczbdcxgbazlyy zjjk_mb_zlfh_tnb.wczbdcxgbazlyy%TYPE; --未查找并调出该对象住院诊治的相关病案资料的可能原因（0 未在住院记录系统中找到相关资料 1 住院病案系统有记录但病案丢失 2 住院病案系统有记录但病案未保存 3 其他）
    v_qtknyy         zjjk_mb_zlfh_tnb.qtknyy%TYPE; --其他可能原因
    v_sfcjbasy       zjjk_mb_zlfh_tnb.sfcjbasy%TYPE; --是否采集（复印或拍照）医院病案首页（0 是 1否）
    v_sfcjcyxj       zjjk_mb_zlfh_tnb.sfcjcyxj%TYPE; --是否采集（复印或拍照）医院出院小结/死亡记录（0 是 1否）
    v_sfcjryjl       zjjk_mb_zlfh_tnb.sfcjryjl%TYPE; --是否采集（复印或拍照）医院入院记录（首次病程）（0 是 1否）
    v_sfcjyscf       zjjk_mb_zlfh_tnb.sfcjyscf%TYPE; --是否采集（复印或拍照）医生处方（降糖药物、胰岛素等）（0 是 1否）
    v_sfcjydxbzskt   zjjk_mb_zlfh_tnb.sfcjydxbzskt%TYPE; --是否采集（复印或拍照）胰岛β细胞自身抗体（1型）（0 是 1否）
    v_sfcjxtbg       zjjk_mb_zlfh_tnb.sfcjxtbg%TYPE; --是否采集（复印或拍照）空腹/随机血糖报告（0 是 1否）
    v_sfcjtnxsybg    zjjk_mb_zlfh_tnb.sfcjtnxsybg%TYPE; --是否采集（复印或拍照）糖耐量试验报告（0 是 1否）
    v_sfcjthxhdbjcbg zjjk_mb_zlfh_tnb.sfcjthxhdbjcbg%TYPE; --是否采集（复印或拍照）糖化血红蛋白检测报告（0 是 1否）
    v_sfcjncg        zjjk_mb_zlfh_tnb.sfcjncg%TYPE; --是否采集（复印或拍照）尿常规（酮体）（0 是 1否）
    v_zyzd           zjjk_mb_zlfh_tnb.zyzd%TYPE; --主要诊断
    v_cyhqtzd        zjjk_mb_zlfh_tnb.cyhqtzd%TYPE; --次要或其他诊断
    v_chzt           zjjk_mb_zlfh_tnb.chzt%TYPE; --存活状态（0存活 1死亡）
    v_wlcdqtjcbg     zjjk_mb_zlfh_tnb.wlcdqtjcbg%TYPE; --注明其他采集到上面未列出的检测报告
    v_blcjzqz        zjjk_mb_zlfh_tnb.blcjzqz%TYPE; --病例采集者签字
    v_bacjzdw        zjjk_mb_zlfh_tnb.bacjzdw%TYPE; --病案采集者单位
    v_fhbgrq         zjjk_mb_zlfh_tnb.fhbgrq%TYPE; --复核报告日期
    v_zdyj           zjjk_mb_zlfh_tnb.zdyj%TYPE; --诊断依据
    v_zdyjxg         zjjk_mb_zlfh_tnb.zdyjxg%TYPE; --诊断依据修改
    v_fhjgpd         zjjk_mb_zlfh_tnb.fhjgpd%TYPE; --复核结果判断（0 符合 1不符合）
    v_zlwzx          zjjk_mb_zlfh_tnb.zlwzx%TYPE; --资料完整性（0 符合 1不符合）
    v_fhzt           zjjk_mb_zlfh_tnb.fhzt%TYPE; --复核状态（0 符合 1不符合）
    v_basyzp         zjjk_mb_zlfh_tnb.basyzp%TYPE;    --（复印或拍照）医院病案首页照片
    v_cyxjzp         zjjk_mb_zlfh_tnb.cyxjzp%TYPE;    --（复印或拍照）医院出院小结/死亡记录照片
    v_ryjlzp         zjjk_mb_zlfh_tnb.ryjlzp%TYPE;    --（复印或拍照）医院入院记录（首次病程）照片
    v_yscfzp         zjjk_mb_zlfh_tnb.yscfzp%TYPE;    --（复印或拍照）医生处方（降糖药物、胰岛素等）照片
    v_ydxbzsktzp     zjjk_mb_zlfh_tnb.ydxbzsktzp%TYPE;    --（复印或拍照）胰岛β细胞自身抗体（1型）照片
    v_xtbgzp         zjjk_mb_zlfh_tnb.xtbgzp%TYPE;    --（复印或拍照）空腹/随机血糖报告照片
    v_zptnxsybgzp    zjjk_mb_zlfh_tnb.zptnxsybgzp%TYPE;    --（复印或拍照）糖耐量试验报告照片
    v_thxhdbjcbgzp   zjjk_mb_zlfh_tnb.thxhdbjcbgzp%TYPE;    --（复印或拍照）糖化血红蛋白检测报告照片
    v_ncgzp          zjjk_mb_zlfh_tnb.ncgzp%TYPE;    --（复印或拍照）尿常规（酮体）照片 
    
    --其他变量
    v_bgkid_s VARCHAR2(2000); --被抽查的报告卡IDs
  
  BEGIN
    json_data(data_in, '糖尿病报告卡病例填报', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid');
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    v_czyyhxm := Json_Str(v_Json_Data, 'czyyhxm');
  
    v_id             := Json_Str(v_Json_Data, 'id');
    v_bkdw           := Json_Str(v_Json_Data, 'bkdw');
    v_zyh            := Json_Str(v_Json_Data, 'zyh');
    v_jbxxybgksfyz   := Json_Str(v_Json_Data, 'jbxxybgksfyz');
    v_kpzt           := Json_Str(v_Json_Data, 'kpzt');
    v_blh            := Json_Str(v_Json_Data, 'blh');
    v_bgkbm          := Json_Str(v_Json_Data, 'bgkbm');
    v_xm             := Json_Str(v_Json_Data, 'xm');
    v_xmxg           := Json_Str(v_Json_Data, 'xmxg');
    v_xb             := Json_Str(v_Json_Data, 'xb');
    v_xbxg           := Json_Str(v_Json_Data, 'xbxg');
    v_csrq           := std(Json_Str(v_Json_Data, 'csrq'), 0);
    v_csrqxg         := Json_Str(v_Json_Data, 'csrqxg');
    v_sfzh           := Json_Str(v_Json_Data, 'sfzh');
    v_sfzhxg         := Json_Str(v_Json_Data, 'sfzhxg');
    v_zdrq           := std(Json_Str(v_Json_Data, 'zdrq'), 0);
    v_zdrqxg         := Json_Str(v_Json_Data, 'zdrqxg');
    v_icd10          := Json_Str(v_Json_Data, 'icd10');
    v_icd10xg        := Json_Str(v_Json_Data, 'icd10xg');
    v_bgyysfwzdyy    := Json_Str(v_Json_Data, 'bgyysfwzdyy');
    v_zdyymc         := Json_Str(v_Json_Data, 'zdyymc');
    v_czbajldjttj    := Json_Str(v_Json_Data, 'czbajldjttj');
    v_qtczbajldtj    := Json_Str(v_Json_Data, 'qtczbajldtj');
    v_sfczbdcxgbazl  := Json_Str(v_Json_Data, 'sfczbdcxgbazl');
    v_bajlsfdzh      := Json_Str(v_Json_Data, 'bajlsfdzh');
    v_dzbasjnr       := Json_Str(v_Json_Data, 'dzbasjnr');
    v_wczbdcxgbazlyy := Json_Str(v_Json_Data, 'wczbdcxgbazlyy');
    v_qtknyy         := Json_Str(v_Json_Data, 'qtknyy');
    v_sfcjbasy       := Json_Str(v_Json_Data, 'sfcjbasy');
    v_sfcjcyxj       := Json_Str(v_Json_Data, 'sfcjcyxj');
    v_sfcjryjl       := Json_Str(v_Json_Data, 'sfcjryjl');
    v_sfcjyscf       := Json_Str(v_Json_Data, 'sfcjyscf');
    v_sfcjydxbzskt   := Json_Str(v_Json_Data, 'sfcjydxbzskt');
    v_sfcjxtbg       := Json_Str(v_Json_Data, 'sfcjxtbg');
    v_sfcjtnxsybg    := Json_Str(v_Json_Data, 'sfcjtnxsybg');
    v_sfcjthxhdbjcbg := Json_Str(v_Json_Data, 'sfcjthxhdbjcbg');
    v_sfcjncg        := Json_Str(v_Json_Data, 'sfcjncg');
    v_zyzd           := Json_Str(v_Json_Data, 'zyzd');
    v_cyhqtzd        := Json_Str(v_Json_Data, 'cyhqtzd');
    v_chzt           := Json_Str(v_Json_Data, 'chzt');
    v_wlcdqtjcbg     := Json_Str(v_Json_Data, 'wlcdqtjcbg');
    v_blcjzqz        := Json_Str(v_Json_Data, 'blcjzqz');
    v_bacjzdw        := Json_Str(v_Json_Data, 'bacjzdw');
    v_fhbgrq         := std(Json_Str(v_Json_Data, 'fhbgrq'), 0);
    v_zdyj           := Json_Str(v_Json_Data, 'zdyj');
    v_zdyjxg         := Json_Str(v_Json_Data, 'zdyjxg');
    v_fhjgpd         := Json_Str(v_Json_Data, 'fhjgpd');
    v_zlwzx          := Json_Str(v_Json_Data, 'zlwzx');
    v_basyzp         := Json_Str(v_Json_Data, 'basyzp');
    v_cyxjzp         := Json_Str(v_Json_Data, 'cyxjzp');
    v_ryjlzp         := Json_Str(v_Json_Data, 'ryjlzp');
    v_yscfzp         := Json_Str(v_Json_Data, 'yscfzp');
    v_ydxbzsktzp     := Json_Str(v_Json_Data, 'ydxbzsktzp');
    v_xtbgzp         := Json_Str(v_Json_Data, 'xtbgzp');
    v_zptnxsybgzp    := Json_Str(v_Json_Data, 'zptnxsybgzp');
    v_thxhdbjcbgzp   := Json_Str(v_Json_Data, 'thxhdbjcbgzp');
    v_ncgzp          := Json_Str(v_Json_Data, 'ncgzp'); 
    
    --校验权限
    if v_czyjgjb <> '3' then
      --非区县
      v_err := '当前机构无病例填报权限!';
      raise err_custom;
    end if;
  
    --校验状态
    select count(1)
      into v_count
      from zjjk_mb_zlfh a, zjjk_zlfhsj b
     where a.cctjid = b.jlbh
       and b.zt = '1'
       and a.id = v_id
       and a.mblx = '3'
       and a.zt = '1'
       and nvl(a.fhzt, '0') in ('0', '1', '6');
    if v_count <> 1 then
      v_err := '未找到待填报的病例!';
      raise err_custom;
    end if;
  
    --校验必填项目
    if v_id is null then
      v_err := '报告卡ID不能为空!';
      raise err_custom;
    end if;
    if v_bkdw is null then
      v_err := '报卡单位不能为空!';
      raise err_custom;
    end if;
    if v_jbxxybgksfyz is null then
      v_err := '个人信息判断不能为空!';
      raise err_custom;
    end if;
    if v_kpzt is null then
      v_err := '卡片状态不能为空!';
      raise err_custom;
    end if;
    if v_bgkbm is null then
      v_err := '报告卡编码不能为空!';
      raise err_custom;
    end if;
    if v_xm is null then
      v_err := '姓名不能为空!';
      raise err_custom;
    end if;
    if v_xb is null then
      v_err := '性别不能为空!';
      raise err_custom;
    end if;
    if v_csrq is null then
      v_err := '出生日期不能为空!';
      raise err_custom;
    end if;
    if v_sfzh is null then
      --v_err := '身份证号不能为空!';
      --raise err_custom;
      --如果没有身份证号，则设为否
      v_sfzh:='无';
    end if;
    if v_zdrq is null then
      v_err := '诊断日期（发病日期）不能为空!';
      raise err_custom;
    end if;
    if v_icd10 is null then
      v_err := 'ICD-10不能为空!';
      raise err_custom;
    end if;
    if v_czbajldjttj is null then
      v_err := '查找病案记录的具体途径不能为空!';
      raise err_custom;
    end if;
    if v_qtczbajldtj is null and v_czbajldjttj = '3' then
      v_err := '其他查找病案记录的途径不能为空!';
      raise err_custom;
    end if;
    if v_sfczbdcxgbazl is null then
      v_err := '是否查找并调出该对象住院诊治的相关病案资料不能为空!';
      raise err_custom;
    end if;
    if v_bajlsfdzh is null and v_sfczbdcxgbazl = '0' then
      v_err := '病案记录是否电子化不能为空!';
      raise err_custom;
    end if;
    if v_dzbasjnr is null and v_bajlsfdzh = '0' then
      v_err := '电子病案涉及内容不能为空!';
      raise err_custom;
    end if;
    if v_wczbdcxgbazlyy is null and v_sfczbdcxgbazl = '1' then
      v_err := '未查找并调出该对象住院诊治的相关病案资料的可能原因不能为空!';
      raise err_custom;
    end if;
    if v_qtknyy is null and v_wczbdcxgbazlyy = '3' then
      v_err := '其他可能的原因不能为空!';
      raise err_custom;
    end if;
    if v_sfczbdcxgbazl = '0' then
      if v_sfcjbasy is null then
        v_err := '是否采集（复印或拍照）医院病案首页不能为空!';
        raise err_custom;
      end if;
      if v_sfcjcyxj is null then
        v_err := '是否采集（复印或拍照）医院出院小结/死亡记录不能为空!';
        raise err_custom;
      end if;
      if v_sfcjryjl is null then
        v_err := '是否采集（复印或拍照）医院入院记录（首次病程）不能为空!';
        raise err_custom;
      end if;
      if v_sfcjyscf is null then
        v_err := '是否采集（复印或拍照）医生处方（降糖药物、胰岛素等）不能为空!';
        raise err_custom;
      end if;
      if v_sfcjydxbzskt is null then
        v_err := '是否采集（复印或拍照）胰岛β细胞自身抗体（1型）不能为空!';
        raise err_custom;
      end if;
      if v_sfcjxtbg is null then
        v_err := '是否采集（复印或拍照）空腹/随机血糖报告不能为空!';
        raise err_custom;
      end if;
      if v_sfcjtnxsybg is null then
        v_err := '是否采集（复印或拍照）糖耐量试验报告不能为空!';
        raise err_custom;
      end if;
      if v_sfcjthxhdbjcbg is null then
        v_err := '是否采集（复印或拍照）糖化血红蛋白检测报告不能为空!';
        raise err_custom;
      end if;
      if v_sfcjncg is null then
        v_err := '是否采集（复印或拍照）尿常规（酮体）不能为空!';
        raise err_custom;
      end if;
      if v_zyzd is null then
        v_err := '主要诊断不能为空!';
        raise err_custom;
      end if;
      if v_chzt is null then
        v_err := '存活状态不能为空!';
        raise err_custom;
      end if;
      if v_blcjzqz is null then
        v_err := '病例采集者签字不能为空!';
        raise err_custom;
      end if;
      if v_bacjzdw is null then
        v_err := '病案采集者单位不能为空!';
        raise err_custom;
      end if;
      if v_fhbgrq is null then
        v_err := '复核报告日期不能为空!';
        raise err_custom;
      end if;
    end if;
    if v_zdyj is null then
      v_err := '诊断依据不能为空!';
      raise err_custom;
    end if;
    if v_zlwzx is null then
      v_err := '病案结果判断不能为空!';
      raise err_custom;
    end if;
    
    --更新资料完整性
    --基本信息判断验证
    if ((v_xmxg IS NULL AND v_xbxg IS NULL AND v_csrqxg IS NULL AND v_sfzhxg IS NULL 
         ) AND v_jbxxybgksfyz='1')
       OR
       ((v_xmxg IS NOT NULL OR v_xbxg IS NOT NULL OR v_csrqxg IS NOT NULL OR v_sfzhxg IS NOT NULL 
         ) AND v_jbxxybgksfyz='0') then
       v_err := '个人信息判断验证不通过!';
      raise err_custom;
    end if;
    
    --病案结果判断验证
    if ((nvl(v_sfcjbasy, '1') <> '0' or nvl(v_sfcjcyxj, '1') <> '0' or
       nvl(v_sfcjryjl, '1') <> '0' or nvl(v_sfcjyscf, '1') <> '0' or
       nvl(v_sfcjydxbzskt, '1') <> '0' or nvl(v_sfcjxtbg, '1') <> '0' or
       nvl(v_sfcjtnxsybg, '1') <> '0' or nvl(v_sfcjthxhdbjcbg, '1') <> '0' or
       nvl(v_sfcjncg, '1') <> '0') AND v_zlwzx='0')
       OR
       ((nvl(v_sfcjbasy, '1') = '0' AND nvl(v_sfcjcyxj, '1') = '0' AND
       nvl(v_sfcjryjl, '1') = '0' AND nvl(v_sfcjyscf, '1') = '0' AND
       nvl(v_sfcjydxbzskt, '1') = '0' AND nvl(v_sfcjxtbg, '1') = '0' AND
       nvl(v_sfcjtnxsybg, '1') = '0' AND nvl(v_sfcjthxhdbjcbg, '1') = '0' AND
       nvl(v_sfcjncg, '1') =  '0') AND v_zlwzx='1') then
       v_err := '病案结果判断验证不通过!';
      raise err_custom;
    end if;
    
    --综合结果判断验证
    if (v_jbxxybgksfyz = '0' AND v_zlwzx ='0' AND v_fhjgpd='1')
       OR
       ((v_jbxxybgksfyz = '1' OR v_zlwzx ='1') AND v_fhjgpd='0') then
       v_err := '结果判断验证不通过!';
      raise err_custom;
    end if;
    
    --判断新增还是修改
    select count(1) into v_count from zjjk_mb_zlfh_tnb a where a.id = v_id;
    if v_count > 0 then
      --修改
    UPDATE zjjk_mb_zlfh_tnb
       SET bkdw           = v_bkdw,
           zyh            = v_zyh,
           jbxxybgksfyz   = v_jbxxybgksfyz,
           kpzt           = v_kpzt,
           blh            = v_blh,
           bgkbm          = v_bgkbm,
           xm             = v_xm,
           xmxg           = v_xmxg,
           xb             = v_xb,
           xbxg           = v_xbxg,
           csrq           = v_csrq,
           csrqxg         = v_csrqxg,
           sfzh           = v_sfzh,
           sfzhxg         = v_sfzhxg,
           zdrq           = v_zdrq,
           zdrqxg         = v_zdrqxg,
           icd10          = v_icd10,
           icd10xg        = v_icd10xg,
           bgyysfwzdyy    = v_bgyysfwzdyy,
           zdyymc         = v_zdyymc,
           czbajldjttj    = v_czbajldjttj,
           qtczbajldtj    = v_qtczbajldtj,
           sfczbdcxgbazl  = v_sfczbdcxgbazl,
           bajlsfdzh      = v_bajlsfdzh,
           dzbasjnr       = v_dzbasjnr,
           wczbdcxgbazlyy = v_wczbdcxgbazlyy,
           qtknyy         = v_qtknyy,
           sfcjbasy       = v_sfcjbasy,
           sfcjcyxj       = v_sfcjcyxj,
           sfcjryjl       = v_sfcjryjl,
           sfcjyscf       = v_sfcjyscf,
           sfcjydxbzskt   = v_sfcjydxbzskt,
           sfcjxtbg       = v_sfcjxtbg,
           sfcjtnxsybg    = v_sfcjtnxsybg,
           sfcjthxhdbjcbg = v_sfcjthxhdbjcbg,
           sfcjncg        = v_sfcjncg,
           zyzd           = v_zyzd,
           cyhqtzd        = v_cyhqtzd,
           chzt           = v_chzt,
           wlcdqtjcbg     = v_wlcdqtjcbg,
           blcjzqz        = v_blcjzqz,
           bacjzdw        = v_bacjzdw,
           fhbgrq         = v_fhbgrq,
           zdyj           = v_zdyj,
           zdyjxg         = v_zdyjxg,
           fhjgpd         = v_fhjgpd,
           zlwzx          = v_zlwzx,
           xgrid          = v_czyyhid,
           xgrxm          = v_czyyhxm,
           xgsj           = v_sysdate,
           fhzt           = '1',
           basyzp         = v_basyzp,
           cyxjzp         = v_cyxjzp,
           ryjlzp         = v_ryjlzp,
           yscfzp         = v_yscfzp,
           ydxbzsktzp     = v_ydxbzsktzp,
           xtbgzp         = v_xtbgzp,
           zptnxsybgzp    = v_zptnxsybgzp,
           thxhdbjcbgzp   = v_thxhdbjcbgzp,
           ncgzp          = v_ncgzp
     WHERE id = v_id;
    else
      --新增
      INSERT INTO zjjk_mb_zlfh_tnb
        (id,
         bkdw,
         zyh,
         jbxxybgksfyz,
         kpzt,
         blh,
         bgkbm,
         xm,
         xmxg,
         xb,
         xbxg,
         csrq,
         csrqxg,
         sfzh,
         sfzhxg,
         zdrq,
         zdrqxg,
         icd10,
         icd10xg,
         bgyysfwzdyy,
         zdyymc,
         czbajldjttj,
         qtczbajldtj,
         sfczbdcxgbazl,
         bajlsfdzh,
         dzbasjnr,
         wczbdcxgbazlyy,
         qtknyy,
         sfcjbasy,
         sfcjcyxj,
         sfcjryjl,
         sfcjyscf,
         sfcjydxbzskt,
         sfcjxtbg,
         sfcjtnxsybg,
         sfcjthxhdbjcbg,
         sfcjncg,
         zyzd,
         cyhqtzd,
         chzt,
         wlcdqtjcbg,
         blcjzqz,
         bacjzdw,
         fhbgrq,
         zdyj,
         zdyjxg,
         fhjgpd,
         zlwzx,
         fhzt,
         cjrid,
         cjrxm,
         cjsj,
         xgrid,
         xgrxm,
         xgsj,
         basyzp,
         cyxjzp,
         ryjlzp,
         yscfzp,
         ydxbzsktzp,
         xtbgzp,
         zptnxsybgzp,
         thxhdbjcbgzp,
         ncgzp)
      VALUES
        (v_id,
         v_bkdw,
         v_zyh,
         v_jbxxybgksfyz,
         v_kpzt,
         v_blh,
         v_bgkbm,
         v_xm,
         v_xmxg,
         v_xb,
         v_xbxg,
         v_csrq,
         v_csrqxg,
         v_sfzh,
         v_sfzhxg,
         v_zdrq,
         v_zdrqxg,
         v_icd10,
         v_icd10xg,
         v_bgyysfwzdyy,
         v_zdyymc,
         v_czbajldjttj,
         v_qtczbajldtj,
         v_sfczbdcxgbazl,
         v_bajlsfdzh,
         v_dzbasjnr,
         v_wczbdcxgbazlyy,
         v_qtknyy,
         v_sfcjbasy,
         v_sfcjcyxj,
         v_sfcjryjl,
         v_sfcjyscf,
         v_sfcjydxbzskt,
         v_sfcjxtbg,
         v_sfcjtnxsybg,
         v_sfcjthxhdbjcbg,
         v_sfcjncg,
         v_zyzd,
         v_cyhqtzd,
         v_chzt,
         v_wlcdqtjcbg,
         v_blcjzqz,
         v_bacjzdw,
         v_fhbgrq,
         v_zdyj,
         v_zdyjxg,
         v_fhjgpd,
         v_zlwzx,
         '1',
         v_czyyhid,
         v_czyyhxm,
         v_sysdate,
         v_czyyhid,
         v_czyyhxm,
         v_sysdate,
         v_basyzp,
         v_cyxjzp,
         v_ryjlzp,
         v_yscfzp,
         v_ydxbzsktzp,
         v_xtbgzp,
         v_zptnxsybgzp,
         v_thxhdbjcbgzp,
         v_ncgzp);
    end if;
    --更新复核状态
    update zjjk_mb_zlfh a
       set a.fhzt = '1', a.fhbz = '1'
     where a.id = v_id
       and a.mblx = '3';
    --返回
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_mb_blfh_tnb_update;
  /*-----------------------------------------------------------------------------
  || 功能描述 ：糖尿病病例提交
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_mb_blfh_tnb_zt_tj(data_in    IN CLOB, --入参
                                  result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
  
    v_id zjjk_mb_zlfh.id%TYPE; --ID
    --公共变量
    v_sysdate date;
    v_czyjgjb varchar2(3);
    v_czyjgdm varchar2(50);
    v_czyyhid varchar2(50);
    v_czyyhxm varchar2(50);
    v_count   number;
  
  BEGIN
    json_data(data_in, '糖尿病病例提交', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid');
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    v_czyyhxm := Json_Str(v_Json_Data, 'czyyhxm');
  
    v_id := Json_Str(v_Json_Data, 'id');
    if v_id is null then
      v_err := 'id不能为空!';
      raise err_custom;
    end if;
    --更新状态
    update zjjk_mb_zlfh a
       set a.fhzt = '3',
           a.fhczrid = v_czyyhid,
           a.fhczrxm = v_czyyhxm,
           a.fhjgid  = v_czyjgdm,
           a.fhsj    = v_sysdate
     where a.fhzt = '1'
       and a.id = v_id
       and a.mblx = '3'
       and a.zt = '1';
    if sql%rowcount <> 1 then
      v_err := '更新病例状态出错!';
      raise err_custom;
    end if;
    update zjjk_mb_zlfh_tnb a set a.fhzt = '3' where a.id = v_id;
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_mb_blfh_tnb_zt_tj;
  /*-----------------------------------------------------------------------------
  || 功能描述 ：糖尿病病例复核
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_mb_blfh_tnb_zt_fh(data_in    IN CLOB, --入参
                                  result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err  VARCHAR2(2000);
    v_id   zjjk_mb_zlfh.id%TYPE; --ID
    v_fhzt zjjk_mb_zlfh.fhzt%TYPE; --ID
    v_fhyj zjjk_mb_zlfh.fhyj%TYPE; --复核意见
  
    --公共变量
    v_sysdate date;
    v_czyjgjb varchar2(3);
    v_czyjgdm varchar2(50);
    v_czyyhid varchar2(50);
    v_czyyhxm varchar2(50);
    v_count   number;
  
  BEGIN
    json_data(data_in, '糖尿病病例复核', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid');
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    v_czyyhxm := Json_Str(v_Json_Data, 'czyyhxm');
  
    v_id   := Json_Str(v_Json_Data, 'id');
    v_fhzt := Json_Str(v_Json_Data, 'fhzt');
    v_fhyj := Json_Str(v_Json_Data, 'fhyj');
    if v_id is null then
      v_err := 'id不能为空!';
      raise err_custom;
    end if;
    if nvl(v_fhzt, '-1') not in ('3', '4') then
      v_err := '复核状态传入有误!';
      raise err_custom;
    end if;
    --更新状态
    update zjjk_mb_zlfh a
       set a.fhzt    = v_fhzt,
           a.fhczrid = v_czyyhid,
           a.fhczrxm = v_czyyhxm,
           a.fhjgid  = v_czyjgdm,
           a.fhsj    = v_sysdate,
           a.fhyj    = v_fhyj
     where a.fhzt = '2'
       and a.id = v_id
       and a.mblx = '3'
       and a.zt = '1';
    if sql%rowcount <> 1 then
      v_err := '更新病例复核状态出错!';
      raise err_custom;
    end if;
    update zjjk_mb_zlfh_tnb a set a.fhzt = v_fhzt where a.id = v_id;
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_mb_blfh_tnb_zt_fh;
  /*-----------------------------------------------------------------------------
  || 功能描述 ：糖尿病病例审核
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_mb_blfh_tnb_zt_sh(data_in    IN CLOB, --入参
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
    v_sysdate date;
    v_czyjgjb varchar2(3);
    v_czyjgdm varchar2(50);
    v_czyyhid varchar2(50);
    v_czyyhxm varchar2(50);
    v_count   number;
  
  BEGIN
    json_data(data_in, '糖尿病病例审核', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid');
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    v_czyyhxm := Json_Str(v_Json_Data, 'czyyhxm');
  
    v_id   := Json_Str(v_Json_Data, 'id');
    v_shzt := Json_Str(v_Json_Data, 'fhzt');
    v_shyj := Json_Str(v_Json_Data, 'shyj');
    if v_id is null then
      v_err := 'id不能为空!';
      raise err_custom;
    end if;
    if nvl(v_shzt, '-1') not in ('5', '6') then
      v_err := '审核状态传入有误!';
      raise err_custom;
    end if;
    --更新状态
    update zjjk_mb_zlfh a
       set a.fhzt    = v_shzt,
           a.shczrid = v_czyyhid,
           a.shczrxm = v_czyyhxm,
           a.shjgid  = v_czyjgdm,
           a.shsj    = v_sysdate,
           a.shyj    = v_shyj
     where a.fhzt = '3'
       and a.id = v_id
       and a.mblx = '3'
       and a.zt = '1';
    if sql%rowcount <> 1 then
      v_err := '更新病例审核状态出错!';
      raise err_custom;
    end if;
    update zjjk_mb_zlfh_tnb a set a.fhzt = v_shzt where a.id = v_id;
  
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_mb_blfh_tnb_zt_sh;
  /*-----------------------------------------------------------------------------
  || 功能描述 ：脑卒中病例填报
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_mb_blfh_ncz_update(data_in    IN CLOB, --入参
                                   result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
  
    --公共变量
    v_sysdate date;
    v_czyjgjb varchar2(3);
    v_czyjgdm varchar2(50);
    v_czyyhid varchar2(50);
    v_czyyhxm varchar2(50);
    v_count   number;
  
    v_id             zjjk_mb_zlfh_ncz.id%TYPE; --id
    v_bkdw           zjjk_mb_zlfh_ncz.bkdw%TYPE; --报卡单位
    v_zyh            zjjk_mb_zlfh_ncz.zyh%TYPE; --住院号
    v_jbxxybgksfyz   zjjk_mb_zlfh_ncz.jbxxybgksfyz%TYPE; --基本信息与报告卡是否一致（0 是 1否）
    v_kpzt           zjjk_mb_zlfh_ncz.kpzt%TYPE; --卡片状态
    v_blh            zjjk_mb_zlfh_ncz.blh%TYPE; --病理号
    v_bgkbm          zjjk_mb_zlfh_ncz.bgkbm%TYPE; --报告卡编码
    v_xm             zjjk_mb_zlfh_ncz.xm%TYPE; --姓名
    v_xmxg           zjjk_mb_zlfh_ncz.xmxg%TYPE; --姓名修改
    v_xb             zjjk_mb_zlfh_ncz.xb%TYPE; --性别
    v_xbxg           zjjk_mb_zlfh_ncz.xbxg%TYPE; --性别修改
    v_csrq           zjjk_mb_zlfh_ncz.csrq%TYPE; --出生日期
    v_csrqxg         zjjk_mb_zlfh_ncz.csrqxg%TYPE; --出生日期修改
    v_sfzh           zjjk_mb_zlfh_ncz.sfzh%TYPE; --身份证号
    v_sfzhxg         zjjk_mb_zlfh_ncz.sfzhxg%TYPE; --身份证号修改
    v_zdrq           zjjk_mb_zlfh_ncz.zdrq%TYPE; --诊断日期（发病日期）
    v_zdrqxg         zjjk_mb_zlfh_ncz.zdrqxg%TYPE; --诊断日期修改
    v_icd10          zjjk_mb_zlfh_ncz.icd10%TYPE; --ICD-10
    v_icd10xg        zjjk_mb_zlfh_ncz.icd10xg%TYPE; --ICD-10修改
    v_bgyysfwzdyy    zjjk_mb_zlfh_ncz.bgyysfwzdyy%TYPE; --报告医院是否为诊断医院（0 是 1否）
    v_zdyymc         zjjk_mb_zlfh_ncz.zdyymc%TYPE; --诊断医院名称
    v_czbajldjttj    zjjk_mb_zlfh_ncz.czbajldjttj%TYPE; --查找病案记录的具体途径（0 电子住院记录系统 1 电子以及纸质住院记录名单 2 纸质住院名单 3 其他）
    v_qtczbajldtj    zjjk_mb_zlfh_ncz.qtczbajldtj%TYPE; --其他查找病案记录的途径
    v_sfczbdcxgbazl  zjjk_mb_zlfh_ncz.sfczbdcxgbazl%TYPE; --是否查找并调出该对象住院诊治的相关病案资料（0 是 1否）
    v_bajlsfdzh      zjjk_mb_zlfh_ncz.bajlsfdzh%TYPE; --病案记录是否电子化（0 是 1否）
    v_dzbasjnr       zjjk_mb_zlfh_ncz.dzbasjnr%TYPE; --电子病案涉及内容（0 所有病案信息 1 只有病案首页）
    v_wczbdcxgbazlyy zjjk_mb_zlfh_ncz.wczbdcxgbazlyy%TYPE; --未查找并调出该对象住院诊治的相关病案资料的可能原因（0 未在住院记录系统中找到相关资料 1 住院病案系统有记录但病案丢失 2 住院病案系统有记录但病案未保存 3 其他）
    v_qtknyy         zjjk_mb_zlfh_ncz.qtknyy%TYPE; --其他可能原因
    v_sfcjbasy       zjjk_mb_zlfh_ncz.sfcjbasy%TYPE; --是否采集（复印或拍照）医院病案首页（0 是 1否）
    v_sfcjcyxj       zjjk_mb_zlfh_ncz.sfcjcyxj%TYPE; --是否采集（复印或拍照）医院出院小结/死亡记录（0 是 1否）
    v_sfcjryjl       zjjk_mb_zlfh_ncz.sfcjryjl%TYPE; --是否采集（复印或拍照）医院入院记录（首次病程）（0 是 1否）
    v_sfcjtbjcbb     zjjk_mb_zlfh_ncz.sfcjtbjcbb%TYPE; --是否采集（复印或拍照）头部CT/MRI检查报告（0 是 1否）
    v_sfcjyzccjcbg   zjjk_mb_zlfh_ncz.sfcjyzccjcbg%TYPE; --是否采集（复印或拍照）腰椎穿刺检查报告（SHA）（0 是 1否）
    v_sfcjxgzybg     zjjk_mb_zlfh_ncz.sfcjxgzybg%TYPE; --是否采集（复印或拍照）血管造影报告（SHA）（0 是 1否）
    v_sfcjsjbg       zjjk_mb_zlfh_ncz.sfcjsjbg%TYPE; --是否采集（复印或拍照）尸检报告（0 是 1否）
    v_zyzd           zjjk_mb_zlfh_ncz.zyzd%TYPE; --主要诊断
    v_cyhqtzd        zjjk_mb_zlfh_ncz.cyhqtzd%TYPE; --次要或其他诊断
    v_chzt           zjjk_mb_zlfh_ncz.chzt%TYPE; --存活状态（0存活 1死亡）
    v_wlcdqtjcbg     zjjk_mb_zlfh_ncz.wlcdqtjcbg%TYPE; --注明其他采集到上面未列出的检测报告
    v_blcjzqz        zjjk_mb_zlfh_ncz.blcjzqz%TYPE; --病例采集者签字
    v_bacjzdw        zjjk_mb_zlfh_ncz.bacjzdw%TYPE; --病案采集者单位
    v_fhbgrq         zjjk_mb_zlfh_ncz.fhbgrq%TYPE; --复核报告日期
    v_zdyj           zjjk_mb_zlfh_ncz.zdyj%TYPE; --诊断依据
    v_zdyjxg         zjjk_mb_zlfh_ncz.zdyjxg%TYPE; --诊断依据修改
    v_fhjgpd         zjjk_mb_zlfh_ncz.fhjgpd%TYPE; --复核结果判断（0 符合 1不符合）
    v_zlwzx          zjjk_mb_zlfh_ncz.zlwzx%TYPE; --资料完整性（0 符合 1不符合）
    v_fhzt           zjjk_mb_zlfh_ncz.fhzt%TYPE; --复核状态（0 符合 1不符合）
    v_ryjlzp         zjjk_mb_zlfh_ncz.ryjlzp%TYPE;    --（复印或拍照）医院入院记录（首次病程）照片
    v_tbjcbbzp       zjjk_mb_zlfh_ncz.tbjcbbzp%TYPE;    --（复印或拍照）头部CT/MRI检查报告照片
    v_yzccjcbgzp     zjjk_mb_zlfh_ncz.yzccjcbgzp%TYPE;    --（复印或拍照）腰椎穿刺检查报告（SHA）照片
    v_xgzybgzp       zjjk_mb_zlfh_ncz.xgzybgzp%TYPE;    --（复印或拍照）血管造影报告（SHA）照片
    v_sjbgzp         zjjk_mb_zlfh_ncz.sjbgzp%TYPE;    --（复印或拍照）尸检报告照片
    v_cyxjzp         zjjk_mb_zlfh_ncz.cyxjzp%TYPE;    --（复印或拍照）医院出院小结/死亡记录照片
    v_basyzp         zjjk_mb_zlfh_ncz.basyzp%TYPE;    --（复印或拍照）医院病案首页照片
  
    --其他变量
    v_bgkid_s VARCHAR2(2000); --被抽查的报告卡IDs
  
  BEGIN
    json_data(data_in, '脑卒中报告卡病例填报', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid');
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    v_czyyhxm := Json_Str(v_Json_Data, 'czyyhxm');
  
    v_id             := Json_Str(v_Json_Data, 'id');
    v_bkdw           := Json_Str(v_Json_Data, 'bkdw');
    v_zyh            := Json_Str(v_Json_Data, 'zyh');
    v_jbxxybgksfyz   := Json_Str(v_Json_Data, 'jbxxybgksfyz');
    v_kpzt           := Json_Str(v_Json_Data, 'kpzt');
    v_blh            := Json_Str(v_Json_Data, 'blh');
    v_bgkbm          := Json_Str(v_Json_Data, 'bgkbm');
    v_xm             := Json_Str(v_Json_Data, 'xm');
    v_xmxg           := Json_Str(v_Json_Data, 'xmxg');
    v_xb             := Json_Str(v_Json_Data, 'xb');
    v_xbxg           := Json_Str(v_Json_Data, 'xbxg');
    v_csrq           := std(Json_Str(v_Json_Data, 'csrq'), 0);
    v_csrqxg         := Json_Str(v_Json_Data, 'csrqxg');
    v_sfzh           := Json_Str(v_Json_Data, 'sfzh');
    v_sfzhxg         := Json_Str(v_Json_Data, 'sfzhxg');
    v_zdrq           := std(Json_Str(v_Json_Data, 'zdrq'), 0);
    v_zdrqxg         := Json_Str(v_Json_Data, 'zdrqxg');
    v_icd10          := Json_Str(v_Json_Data, 'icd10');
    v_icd10xg        := Json_Str(v_Json_Data, 'icd10xg');
    v_bgyysfwzdyy    := Json_Str(v_Json_Data, 'bgyysfwzdyy');
    v_zdyymc         := Json_Str(v_Json_Data, 'zdyymc');
    v_czbajldjttj    := Json_Str(v_Json_Data, 'czbajldjttj');
    v_qtczbajldtj    := Json_Str(v_Json_Data, 'qtczbajldtj');
    v_sfczbdcxgbazl  := Json_Str(v_Json_Data, 'sfczbdcxgbazl');
    v_bajlsfdzh      := Json_Str(v_Json_Data, 'bajlsfdzh');
    v_dzbasjnr       := Json_Str(v_Json_Data, 'dzbasjnr');
    v_wczbdcxgbazlyy := Json_Str(v_Json_Data, 'wczbdcxgbazlyy');
    v_qtknyy         := Json_Str(v_Json_Data, 'qtknyy');
    v_sfcjbasy       := Json_Str(v_Json_Data, 'sfcjbasy');
    v_sfcjcyxj       := Json_Str(v_Json_Data, 'sfcjcyxj');
    v_sfcjryjl       := Json_Str(v_Json_Data, 'sfcjryjl');
    v_sfcjtbjcbb     := Json_Str(v_Json_Data, 'sfcjtbjcbb');
    v_sfcjyzccjcbg   := Json_Str(v_Json_Data, 'sfcjyzccjcbg');
    v_sfcjxgzybg     := Json_Str(v_Json_Data, 'sfcjxgzybg');
    v_sfcjsjbg       := Json_Str(v_Json_Data, 'sfcjsjbg');
    v_zyzd           := Json_Str(v_Json_Data, 'zyzd');
    v_cyhqtzd        := Json_Str(v_Json_Data, 'cyhqtzd');
    v_chzt           := Json_Str(v_Json_Data, 'chzt');
    v_wlcdqtjcbg     := Json_Str(v_Json_Data, 'wlcdqtjcbg');
    v_blcjzqz        := Json_Str(v_Json_Data, 'blcjzqz');
    v_bacjzdw        := Json_Str(v_Json_Data, 'bacjzdw');
    v_fhbgrq         := std(Json_Str(v_Json_Data, 'fhbgrq'), 0);
    v_zdyj           := Json_Str(v_Json_Data, 'zdyj');
    v_zdyjxg         := Json_Str(v_Json_Data, 'zdyjxg');
    v_fhjgpd         := Json_Str(v_Json_Data, 'fhjgpd');
    v_zlwzx          := Json_Str(v_Json_Data, 'zlwzx');
    v_basyzp         := Json_Str(v_Json_Data, 'basyzp');
    v_cyxjzp         := Json_Str(v_Json_Data, 'cyxjzp');
    v_ryjlzp         := Json_Str(v_Json_Data, 'ryjlzp');
    v_tbjcbbzp       := Json_Str(v_Json_Data, 'tbjcbbzp');
    v_yzccjcbgzp     := Json_Str(v_Json_Data, 'yzccjcbgzp');
    v_xgzybgzp       := Json_Str(v_Json_Data, 'xgzybgzp');
    v_sjbgzp         := Json_Str(v_Json_Data, 'sjbgzp');
    
    --校验权限
    if v_czyjgjb <> '3' then
      --非区县
      v_err := '当前机构无病例填报权限!';
      raise err_custom;
    end if;
  
    --校验状态
    select count(1)
      into v_count
      from zjjk_mb_zlfh a, zjjk_zlfhsj b
     where a.cctjid = b.jlbh
       and b.zt = '1'
       and a.id = v_id
       and a.mblx = '1'
       and a.zt = '1'
       and nvl(a.fhzt, '0') in ('0', '1', '6');
    if v_count <> 1 then
      v_err := '未找到待填报的病例!';
      raise err_custom;
    end if;
  
    --校验必填项目
    if v_id is null then
      v_err := '报告卡ID不能为空!';
      raise err_custom;
    end if;
    if v_bkdw is null then
      v_err := '报卡单位不能为空!';
      raise err_custom;
    end if;
    if v_jbxxybgksfyz is null then
      v_err := '个人信息判断不能为空!';
      raise err_custom;
    end if;
    if v_kpzt is null then
      v_err := '卡片状态不能为空!';
      raise err_custom;
    end if;
    if v_bgkbm is null then
      v_err := '报告卡编码不能为空!';
      raise err_custom;
    end if;
    if v_xm is null then
      v_err := '姓名不能为空!';
      raise err_custom;
    end if;
    if v_xb is null then
      v_err := '性别不能为空!';
      raise err_custom;
    end if;
    if v_csrq is null then
      v_err := '出生日期不能为空!';
      raise err_custom;
    end if;
    if v_sfzh is null then
      --v_err := '身份证号不能为空!';
      --raise err_custom;
      --如果没有身份证号，则设为否
      v_sfzh:='无';
    end if;
    if v_zdrq is null then
      v_err := '诊断日期（发病日期）不能为空!';
      raise err_custom;
    end if;
    if v_icd10 is null then
      v_err := 'ICD-10不能为空!';
      raise err_custom;
    end if;
    if v_czbajldjttj is null then
      v_err := '查找病案记录的具体途径不能为空!';
      raise err_custom;
    end if;
    if v_qtczbajldtj is null and v_czbajldjttj = '3' then
      v_err := '其他查找病案记录的途径不能为空!';
      raise err_custom;
    end if;
    if v_sfczbdcxgbazl is null then
      v_err := '是否查找并调出该对象住院诊治的相关病案资料不能为空!';
      raise err_custom;
    end if;
    if v_bajlsfdzh is null and v_sfczbdcxgbazl = '0' then
      v_err := '病案记录是否电子化不能为空!';
      raise err_custom;
    end if;
    if v_dzbasjnr is null and v_bajlsfdzh = '0' then
      v_err := '电子病案涉及内容不能为空!';
      raise err_custom;
    end if;
    if v_wczbdcxgbazlyy is null and v_sfczbdcxgbazl = '1' then
      v_err := '未查找并调出该对象住院诊治的相关病案资料的可能原因不能为空!';
      raise err_custom;
    end if;
    if v_qtknyy is null and v_wczbdcxgbazlyy = '3' then
      v_err := '其他可能的原因不能为空!';
      raise err_custom;
    end if;
    if v_sfczbdcxgbazl = '0' then
      if v_sfcjbasy is null then
        v_err := '是否采集（复印或拍照）医院病案首页不能为空!';
        raise err_custom;
      end if;
      if v_sfcjcyxj is null then
        v_err := '是否采集（复印或拍照）医院出院小结/死亡记录不能为空!';
        raise err_custom;
      end if;
      if v_sfcjryjl is null then
        v_err := '是否采集（复印或拍照）医院入院记录（首次病程）不能为空!';
        raise err_custom;
      end if;
      if v_sfcjtbjcbb is null then
        v_err := '是否采集（复印或拍照）头部CT/MRI检查报告不能为空!';
        raise err_custom;
      end if;
      if v_sfcjyzccjcbg is null then
        v_err := '是否采集（复印或拍照）腰椎穿刺检查报告（SHA）不能为空!';
        raise err_custom;
      end if;
      if v_sfcjxgzybg is null then
        v_err := '是否采集（复印或拍照）血管造影报告（SHA）不能为空!';
        raise err_custom;
      end if;
      if v_sfcjsjbg is null then
        v_err := '是否采集（复印或拍照）尸检报告不能为空!';
        raise err_custom;
      end if;
      if v_zyzd is null then
        v_err := '主要诊断不能为空!';
        raise err_custom;
      end if;
      if v_chzt is null then
        v_err := '存活状态不能为空!';
        raise err_custom;
      end if;
      if v_blcjzqz is null then
        v_err := '病例采集者签字不能为空!';
        raise err_custom;
      end if;
      if v_bacjzdw is null then
        v_err := '病案采集者单位不能为空!';
        raise err_custom;
      end if;
      if v_fhbgrq is null then
        v_err := '复核报告日期不能为空!';
        raise err_custom;
      end if;
    end if;
    if v_zdyj is null then
      v_err := '诊断依据不能为空!';
      raise err_custom;
    end if;
    if v_zlwzx is null then
      v_err := '病案结果判断不能为空!';
      raise err_custom;
    end if;
  
    --更新资料完整性
    --基本信息判断验证
    if ((v_xmxg IS NULL AND v_xbxg IS NULL AND v_csrqxg IS NULL AND v_sfzhxg IS NULL 
         ) AND v_jbxxybgksfyz='1')
       OR
       ((v_xmxg IS NOT NULL OR v_xbxg IS NOT NULL OR v_csrqxg IS NOT NULL OR v_sfzhxg IS NOT NULL 
         ) AND v_jbxxybgksfyz='0') then
       v_err := '个人信息判断验证不通过!';
      raise err_custom;
    end if;
    
    --病案结果判断验证
    if ((nvl(v_sfcjbasy, '1') <> '0' or nvl(v_sfcjcyxj, '1') <> '0' or
       nvl(v_sfcjryjl, '1') <> '0' or nvl(v_sfcjtbjcbb, '1') <> '0' or
       nvl(v_sfcjyzccjcbg, '1') <> '0' or nvl(v_sfcjxgzybg, '1') <> '0') AND v_zlwzx='0')
       OR
       ((nvl(v_sfcjbasy, '1') = '0' AND nvl(v_sfcjcyxj, '1') = '0' AND
       nvl(v_sfcjryjl, '1') = '0' AND nvl(v_sfcjtbjcbb, '1') = '0' AND
       nvl(v_sfcjyzccjcbg, '1') = '0' AND nvl(v_sfcjxgzybg, '1') = '0') AND v_zlwzx='1') then
       v_err := '病案结果判断验证不通过!';
      raise err_custom;
    end if;
    
    --综合结果判断验证
    if (v_jbxxybgksfyz = '0' AND v_zlwzx ='0' AND v_fhjgpd='1')
       OR
       ((v_jbxxybgksfyz = '1' OR v_zlwzx ='1') AND v_fhjgpd='0') then
       v_err := '结果判断验证不通过!';
      raise err_custom;
    end if;
    
    --判断新增还是修改
    select count(1) into v_count from zjjk_mb_zlfh_ncz a where a.id = v_id;
    if v_count > 0 then
      --修改
     UPDATE zjjk_mb_zlfh_ncz
        SET bkdw           = v_bkdw,
            zyh            = v_zyh,
            jbxxybgksfyz   = v_jbxxybgksfyz,
            kpzt           = v_kpzt,
            blh            = v_blh,
            bgkbm          = v_bgkbm,
            xm             = v_xm,
            xmxg           = v_xmxg,
            xb             = v_xb,
            xbxg           = v_xbxg,
            csrq           = v_csrq,
            csrqxg         = v_csrqxg,
            sfzh           = v_sfzh,
            sfzhxg         = v_sfzhxg,
            zdrq           = v_zdrq,
            zdrqxg         = v_zdrqxg,
            icd10          = v_icd10,
            icd10xg        = v_icd10xg,
            bgyysfwzdyy    = v_bgyysfwzdyy,
            zdyymc         = v_zdyymc,
            czbajldjttj    = v_czbajldjttj,
            qtczbajldtj    = v_qtczbajldtj,
            sfczbdcxgbazl  = v_sfczbdcxgbazl,
            bajlsfdzh      = v_bajlsfdzh,
            dzbasjnr       = v_dzbasjnr,
            wczbdcxgbazlyy = v_wczbdcxgbazlyy,
            qtknyy         = v_qtknyy,
            sfcjbasy       = v_sfcjbasy,
            sfcjcyxj       = v_sfcjcyxj,
            sfcjryjl       = v_sfcjryjl,
            sfcjtbjcbb     = v_sfcjtbjcbb,
            sfcjyzccjcbg   = v_sfcjyzccjcbg,
            sfcjxgzybg     = v_sfcjxgzybg,
            sfcjsjbg       = v_sfcjsjbg,
            zyzd           = v_zyzd,
            cyhqtzd        = v_cyhqtzd,
            chzt           = v_chzt,
            wlcdqtjcbg     = v_wlcdqtjcbg,
            blcjzqz        = v_blcjzqz,
            bacjzdw        = v_bacjzdw,
            fhbgrq         = v_fhbgrq,
            zdyj           = v_zdyj,
            zdyjxg         = v_zdyjxg,
            fhjgpd         = v_fhjgpd,
            zlwzx          = v_zlwzx,
            xgrid          = v_czyyhid,
            xgrxm          = v_czyyhxm,
            xgsj           = v_sysdate,
            fhzt           = '1',
            basyzp         = v_basyzp,
            cyxjzp         = v_cyxjzp,
            ryjlzp         = v_ryjlzp,
            tbjcbbzp       = v_tbjcbbzp,
            yzccjcbgzp     = v_yzccjcbgzp,
            xgzybgzp       = v_xgzybgzp,
            sjbgzp         = v_sjbgzp
      WHERE id = v_id;
    else
      --新增
      INSERT INTO zjjk_mb_zlfh_ncz
        (id,
         bkdw,
         zyh,
         jbxxybgksfyz,
         kpzt,
         blh,
         bgkbm,
         xm,
         xmxg,
         xb,
         xbxg,
         csrq,
         csrqxg,
         sfzh,
         sfzhxg,
         zdrq,
         zdrqxg,
         icd10,
         icd10xg,
         bgyysfwzdyy,
         zdyymc,
         czbajldjttj,
         qtczbajldtj,
         sfczbdcxgbazl,
         bajlsfdzh,
         dzbasjnr,
         wczbdcxgbazlyy,
         qtknyy,
         sfcjbasy,
         sfcjcyxj,
         sfcjryjl,
         sfcjtbjcbb,
         sfcjyzccjcbg,
         sfcjxgzybg,
         sfcjsjbg,
         zyzd,
         cyhqtzd,
         chzt,
         wlcdqtjcbg,
         blcjzqz,
         bacjzdw,
         fhbgrq,
         zdyj,
         zdyjxg,
         fhjgpd,
         zlwzx,
         fhzt,
         cjrid,
         cjrxm,
         cjsj,
         xgrid,
         xgrxm,
         xgsj,
         basyzp,
         cyxjzp,
         ryjlzp,
         tbjcbbzp,
         yzccjcbgzp,
         xgzybgzp,
         sjbgzp)
      VALUES
        (v_id,
         v_bkdw,
         v_zyh,
         v_jbxxybgksfyz,
         v_kpzt,
         v_blh,
         v_bgkbm,
         v_xm,
         v_xmxg,
         v_xb,
         v_xbxg,
         v_csrq,
         v_csrqxg,
         v_sfzh,
         v_sfzhxg,
         v_zdrq,
         v_zdrqxg,
         v_icd10,
         v_icd10xg,
         v_bgyysfwzdyy,
         v_zdyymc,
         v_czbajldjttj,
         v_qtczbajldtj,
         v_sfczbdcxgbazl,
         v_bajlsfdzh,
         v_dzbasjnr,
         v_wczbdcxgbazlyy,
         v_qtknyy,
         v_sfcjbasy,
         v_sfcjcyxj,
         v_sfcjryjl,
         v_sfcjtbjcbb,
         v_sfcjyzccjcbg,
         v_sfcjxgzybg,
         v_sfcjsjbg,
         v_zyzd,
         v_cyhqtzd,
         v_chzt,
         v_wlcdqtjcbg,
         v_blcjzqz,
         v_bacjzdw,
         v_fhbgrq,
         v_zdyj,
         v_zdyjxg,
         v_fhjgpd,
         v_zlwzx,
         '1',
         v_czyyhid,
         v_czyyhxm,
         v_sysdate,
         v_czyyhid,
         v_czyyhxm,
         v_sysdate,
         v_basyzp,
         v_cyxjzp,
         v_ryjlzp,
         v_tbjcbbzp,
         v_yzccjcbgzp,
         v_xgzybgzp,
         v_sjbgzp);
    end if;
    --更新复核状态
    update zjjk_mb_zlfh a
       set a.fhzt = '1', a.fhbz = '1'
     where a.id = v_id
       and a.mblx = '1';
    --返回
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_mb_blfh_ncz_update;
  /*-----------------------------------------------------------------------------
  || 功能描述 ：脑卒中病例提交
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_mb_blfh_ncz_zt_tj(data_in    IN CLOB, --入参
                                  result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
  
    v_id zjjk_mb_zlfh.id%TYPE; --ID
    --公共变量
    v_sysdate date;
    v_czyjgjb varchar2(3);
    v_czyjgdm varchar2(50);
    v_czyyhid varchar2(50);
    v_czyyhxm varchar2(50);
    v_count   number;
  
  BEGIN
    json_data(data_in, '脑卒中病例提交', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid');
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    v_czyyhxm := Json_Str(v_Json_Data, 'czyyhxm');
  
    v_id := Json_Str(v_Json_Data, 'id');
    if v_id is null then
      v_err := 'id不能为空!';
      raise err_custom;
    end if;
    --更新状态
    update zjjk_mb_zlfh a
       set a.fhzt = '3',
           a.fhczrid = v_czyyhid,
           a.fhczrxm = v_czyyhxm,
           a.fhjgid  = v_czyjgdm,
           a.fhsj    = v_sysdate
     where a.fhzt = '1'
       and a.id = v_id
       and a.mblx = '1'
       and a.zt = '1';
    if sql%rowcount <> 1 then
      v_err := '更新病例状态出错!';
      raise err_custom;
    end if;
    update zjjk_mb_zlfh_ncz a set a.fhzt = '3' where a.id = v_id;
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_mb_blfh_ncz_zt_tj;
  /*-----------------------------------------------------------------------------
  || 功能描述 ：脑卒中病例复核
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_mb_blfh_ncz_zt_fh(data_in    IN CLOB, --入参
                                  result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err  VARCHAR2(2000);
    v_id   zjjk_mb_zlfh.id%TYPE; --ID
    v_fhzt zjjk_mb_zlfh.fhzt%TYPE; --ID
    v_fhyj zjjk_mb_zlfh.fhyj%TYPE; --复核意见
  
    --公共变量
    v_sysdate date;
    v_czyjgjb varchar2(3);
    v_czyjgdm varchar2(50);
    v_czyyhid varchar2(50);
    v_czyyhxm varchar2(50);
    v_count   number;
  
  BEGIN
    json_data(data_in, '脑卒中病例复核', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid');
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    v_czyyhxm := Json_Str(v_Json_Data, 'czyyhxm');
  
    v_id   := Json_Str(v_Json_Data, 'id');
    v_fhzt := Json_Str(v_Json_Data, 'fhzt');
    v_fhyj := Json_Str(v_Json_Data, 'fhyj');
    if v_id is null then
      v_err := 'id不能为空!';
      raise err_custom;
    end if;
    if nvl(v_fhzt, '-1') not in ('3', '4') then
      v_err := '复核状态传入有误!';
      raise err_custom;
    end if;
    --更新状态
    update zjjk_mb_zlfh a
       set a.fhzt    = v_fhzt,
           a.fhczrid = v_czyyhid,
           a.fhczrxm = v_czyyhxm,
           a.fhjgid  = v_czyjgdm,
           a.fhsj    = v_sysdate,
           a.fhyj    = v_fhyj
     where a.fhzt = '2'
       and a.id = v_id
       and a.mblx = '1'
       and a.zt = '1';
    if sql%rowcount <> 1 then
      v_err := '更新病例复核状态出错!';
      raise err_custom;
    end if;
    update zjjk_mb_zlfh_ncz a set a.fhzt = v_fhzt where a.id = v_id;
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_mb_blfh_ncz_zt_fh;
  /*-----------------------------------------------------------------------------
  || 功能描述 ：脑卒中病例审核
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_mb_blfh_ncz_zt_sh(data_in    IN CLOB, --入参
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
    v_sysdate date;
    v_czyjgjb varchar2(3);
    v_czyjgdm varchar2(50);
    v_czyyhid varchar2(50);
    v_czyyhxm varchar2(50);
    v_count   number;
  
  BEGIN
    json_data(data_in, '脑卒中病例审核', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid');
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    v_czyyhxm := Json_Str(v_Json_Data, 'czyyhxm');
  
    v_id   := Json_Str(v_Json_Data, 'id');
    v_shzt := Json_Str(v_Json_Data, 'fhzt');
    v_shyj := Json_Str(v_Json_Data, 'shyj');
    if v_id is null then
      v_err := 'id不能为空!';
      raise err_custom;
    end if;
    if nvl(v_shzt, '-1') not in ('5', '6') then
      v_err := '审核状态传入有误!';
      raise err_custom;
    end if;
    --更新状态
    update zjjk_mb_zlfh a
       set a.fhzt    = v_shzt,
           a.shczrid = v_czyyhid,
           a.shczrxm = v_czyyhxm,
           a.shjgid  = v_czyjgdm,
           a.shsj    = v_sysdate,
           a.shyj    = v_shyj
     where a.fhzt = '3'
       and a.id = v_id
       and a.mblx = '1'
       and a.zt = '1';
    if sql%rowcount <> 1 then
      v_err := '更新病例审核状态出错!';
      raise err_custom;
    end if;
    update zjjk_mb_zlfh_ncz a set a.fhzt = v_shzt where a.id = v_id;
  
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_mb_blfh_ncz_zt_sh;
  /*-----------------------------------------------------------------------------
  || 功能描述 ：冠心病病例填报
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_mb_blfh_gxb_update(data_in    IN CLOB, --入参
                                   result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
  
    --公共变量
    v_sysdate date;
    v_czyjgjb varchar2(3);
    v_czyjgdm varchar2(50);
    v_czyyhid varchar2(50);
    v_czyyhxm varchar2(50);
    v_count   number;
  
    v_id              zjjk_mb_zlfh_gxb.id%TYPE; --ID
    v_bkdw            zjjk_mb_zlfh_gxb.bkdw%TYPE; --报卡单位
    v_zyh             zjjk_mb_zlfh_gxb.zyh%TYPE; --住院号
    v_jbxxybgksfyz    zjjk_mb_zlfh_gxb.jbxxybgksfyz%TYPE; --基本信息与报告卡是否一致（0 是 1否）
    v_kpzt            zjjk_mb_zlfh_gxb.kpzt%TYPE; --卡片状态
    v_blh             zjjk_mb_zlfh_gxb.blh%TYPE; --病理号
    v_bgkbm           zjjk_mb_zlfh_gxb.bgkbm%TYPE; --报告卡编码
    v_xm              zjjk_mb_zlfh_gxb.xm%TYPE; --姓名
    v_xmxg            zjjk_mb_zlfh_gxb.xmxg%TYPE; --姓名修改
    v_xb              zjjk_mb_zlfh_gxb.xb%TYPE; --性别
    v_xbxg            zjjk_mb_zlfh_gxb.xbxg%TYPE; --性别修改
    v_csrq            zjjk_mb_zlfh_gxb.csrq%TYPE; --出生日期
    v_csrqxg          zjjk_mb_zlfh_gxb.csrqxg%TYPE; --出生日期修改
    v_sfzh            zjjk_mb_zlfh_gxb.sfzh%TYPE; --身份证号
    v_sfzhxg          zjjk_mb_zlfh_gxb.sfzhxg%TYPE; --身份证号修改
    v_zdrq            zjjk_mb_zlfh_gxb.zdrq%TYPE; --诊断日期（发病日期）
    v_zdrqxg          zjjk_mb_zlfh_gxb.zdrqxg%TYPE; --诊断日期修改
    v_icd10           zjjk_mb_zlfh_gxb.icd10%TYPE; --ICD-10
    v_icd10xg         zjjk_mb_zlfh_gxb.icd10xg%TYPE; --ICD-10修改
    v_bgyysfwzdyy     zjjk_mb_zlfh_gxb.bgyysfwzdyy%TYPE; --报告医院是否为诊断医院（0 是 1否）
    v_zdyymc          zjjk_mb_zlfh_gxb.zdyymc%TYPE; --诊断医院名称
    v_czbajldjttj     zjjk_mb_zlfh_gxb.czbajldjttj%TYPE; --查找病案记录的具体途径（0 电子住院记录系统 1 电子以及纸质住院记录名单 2 纸质住院名单 3 其他）
    v_qtczbajldtj     zjjk_mb_zlfh_gxb.qtczbajldtj%TYPE; --其他查找病案记录的途径
    v_sfczbdcxgbazl   zjjk_mb_zlfh_gxb.sfczbdcxgbazl%TYPE; --是否查找并调出该对象住院诊治的相关病案资料（0 是 1否）
    v_bajlsfdzh       zjjk_mb_zlfh_gxb.bajlsfdzh%TYPE; --病案记录是否电子化（0 是 1否）
    v_dzbasjnr        zjjk_mb_zlfh_gxb.dzbasjnr%TYPE; --电子病案涉及内容（0 所有病案信息 1 只有病案首页）
    v_wczbdcxgbazlyy  zjjk_mb_zlfh_gxb.wczbdcxgbazlyy%TYPE; --未查找并调出该对象住院诊治的相关病案资料的可能原因（0 未在住院记录系统中找到相关资料 1 住院病案系统有记录但病案丢失 2 住院病案系统有记录但病案未保存 3 其他）
    v_qtknyy          zjjk_mb_zlfh_gxb.qtknyy%TYPE; --其他可能原因
    v_sfcjbasy        zjjk_mb_zlfh_gxb.sfcjbasy%TYPE; --是否采集（复印或拍照）医院病案首页（0 是 1否）
    v_sfcjcyxj        zjjk_mb_zlfh_gxb.sfcjcyxj%TYPE; --是否采集（复印或拍照）医院出院小结/死亡记录（0 是 1否）
    v_sfcjryjl        zjjk_mb_zlfh_gxb.sfcjryjl%TYPE; --是否采集（复印或拍照）医院入院记录（首次病程）（0 是 1否）
    v_sfcjxdtjcbg     zjjk_mb_zlfh_gxb.sfcjxdtjcbg%TYPE; --是否采集（复印或拍照）心电图检查报告（0 是 1否）
    v_sfcjxqmjc       zjjk_mb_zlfh_gxb.sfcjxqmjc%TYPE; --是否采集（复印或拍照）血清酶检查（肌酸激酶，肌钙蛋白等）（0 是 1否）
    v_sfcjxzxgzdmzybg zjjk_mb_zlfh_gxb.sfcjxzxgzdmzybg%TYPE; --是否采集（复印或拍照）选择性冠状动脉造影报告（0 是 1否）
    v_zyzd            zjjk_mb_zlfh_gxb.zyzd%TYPE; --主要诊断
    v_cyhqtzd         zjjk_mb_zlfh_gxb.cyhqtzd%TYPE; --次要或其他诊断
    v_chzt            zjjk_mb_zlfh_gxb.chzt%TYPE; --存活状态（0存活 1死亡）
    v_wlcdqtjcbg      zjjk_mb_zlfh_gxb.wlcdqtjcbg%TYPE; --注明其他采集到上面未列出的检测报告
    v_blcjzqz         zjjk_mb_zlfh_gxb.blcjzqz%TYPE; --病例采集者签字
    v_bacjzdw         zjjk_mb_zlfh_gxb.bacjzdw%TYPE; --病案采集者单位
    v_fhbgrq          zjjk_mb_zlfh_gxb.fhbgrq%TYPE; --复核报告日期
    v_zdyj            zjjk_mb_zlfh_gxb.zdyj%TYPE; --诊断依据
    v_zdyjxg          zjjk_mb_zlfh_gxb.zdyjxg%TYPE; --诊断依据修改
    v_fhjgpd          zjjk_mb_zlfh_gxb.fhjgpd%TYPE; --复核结果判断（0 符合 1不符合）
    v_zlwzx           zjjk_mb_zlfh_gxb.zlwzx%TYPE; --资料完整性（0 符合 1不符合）
    v_fhzt            zjjk_mb_zlfh_gxb.fhzt%TYPE; --复核状态（0 符合 1不符合）
    v_basyzp          zjjk_mb_zlfh_gxb.basyzp%TYPE;    --（复印或拍照）医院病案首页照片
    v_cyxjzp          zjjk_mb_zlfh_gxb.cyxjzp%TYPE;    --（复印或拍照）医院出院小结/死亡记录照片
    v_ryjlzp          zjjk_mb_zlfh_gxb.ryjlzp%TYPE;    --（复印或拍照）医院入院记录（首次病程）照片
    v_xdtjcbgzp       zjjk_mb_zlfh_gxb.xdtjcbgzp%TYPE;    --（复印或拍照）心电图检查报告照片
    v_xqmjczp         zjjk_mb_zlfh_gxb.xqmjczp%TYPE;    --（复印或拍照）血清酶检查（肌酸激酶，肌钙蛋白等）照片
    v_xzxgzdmzybgzp   zjjk_mb_zlfh_gxb.xzxgzdmzybgzp%TYPE;    --（复印或拍照）选择性冠状动脉造影报告照片
    
    --其他变量
    v_bgkid_s VARCHAR2(2000); --被抽查的报告卡IDs
  
  BEGIN
    json_data(data_in, '冠心病报告卡病例填报', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid');
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    v_czyyhxm := Json_Str(v_Json_Data, 'czyyhxm');
  
    v_id              := Json_Str(v_Json_Data, 'id');
    v_bkdw            := Json_Str(v_Json_Data, 'bkdw');
    v_zyh             := Json_Str(v_Json_Data, 'zyh');
    v_jbxxybgksfyz    := Json_Str(v_Json_Data, 'jbxxybgksfyz');
    v_kpzt            := Json_Str(v_Json_Data, 'kpzt');
    v_blh             := Json_Str(v_Json_Data, 'blh');
    v_bgkbm           := Json_Str(v_Json_Data, 'bgkbm');
    v_xm              := Json_Str(v_Json_Data, 'xm');
    v_xmxg            := Json_Str(v_Json_Data, 'xmxg');
    v_xb              := Json_Str(v_Json_Data, 'xb');
    v_xbxg            := Json_Str(v_Json_Data, 'xbxg');
    v_csrq            := std(Json_Str(v_Json_Data, 'csrq'), 0);
    v_csrqxg          := Json_Str(v_Json_Data, 'csrqxg');
    v_sfzh            := Json_Str(v_Json_Data, 'sfzh');
    v_sfzhxg          := Json_Str(v_Json_Data, 'sfzhxg');
    v_zdrq            := std(Json_Str(v_Json_Data, 'zdrq'), 0);
    v_zdrqxg          := Json_Str(v_Json_Data, 'zdrqxg');
    v_icd10           := Json_Str(v_Json_Data, 'icd10');
    v_icd10xg         := Json_Str(v_Json_Data, 'icd10xg');
    v_bgyysfwzdyy     := Json_Str(v_Json_Data, 'bgyysfwzdyy');
    v_zdyymc          := Json_Str(v_Json_Data, 'zdyymc');
    v_czbajldjttj     := Json_Str(v_Json_Data, 'czbajldjttj');
    v_qtczbajldtj     := Json_Str(v_Json_Data, 'qtczbajldtj');
    v_sfczbdcxgbazl   := Json_Str(v_Json_Data, 'sfczbdcxgbazl');
    v_bajlsfdzh       := Json_Str(v_Json_Data, 'bajlsfdzh');
    v_dzbasjnr        := Json_Str(v_Json_Data, 'dzbasjnr');
    v_wczbdcxgbazlyy  := Json_Str(v_Json_Data, 'wczbdcxgbazlyy');
    v_qtknyy          := Json_Str(v_Json_Data, 'qtknyy');
    v_sfcjbasy        := Json_Str(v_Json_Data, 'sfcjbasy');
    v_sfcjcyxj        := Json_Str(v_Json_Data, 'sfcjcyxj');
    v_sfcjryjl        := Json_Str(v_Json_Data, 'sfcjryjl');
    v_sfcjxdtjcbg     := Json_Str(v_Json_Data, 'sfcjxdtjcbg');
    v_sfcjxqmjc       := Json_Str(v_Json_Data, 'sfcjxqmjc');
    v_sfcjxzxgzdmzybg := Json_Str(v_Json_Data, 'sfcjxzxgzdmzybg');
    v_zyzd            := Json_Str(v_Json_Data, 'zyzd');
    v_cyhqtzd         := Json_Str(v_Json_Data, 'cyhqtzd');
    v_chzt            := Json_Str(v_Json_Data, 'chzt');
    v_wlcdqtjcbg      := Json_Str(v_Json_Data, 'wlcdqtjcbg');
    v_blcjzqz         := Json_Str(v_Json_Data, 'blcjzqz');
    v_bacjzdw         := Json_Str(v_Json_Data, 'bacjzdw');
    v_fhbgrq          := std(Json_Str(v_Json_Data, 'fhbgrq'), 0);
    v_zdyj            := Json_Str(v_Json_Data, 'zdyj');
    v_zdyjxg          := Json_Str(v_Json_Data, 'zdyjxg');
    v_fhjgpd          := Json_Str(v_Json_Data, 'fhjgpd');
    v_zlwzx           := Json_Str(v_Json_Data, 'zlwzx');
    v_basyzp          := Json_Str(v_Json_Data, 'basyzp');
    v_cyxjzp          := Json_Str(v_Json_Data, 'cyxjzp');
    v_ryjlzp          := Json_Str(v_Json_Data, 'ryjlzp');
    v_xdtjcbgzp       := Json_Str(v_Json_Data, 'xdtjcbgzp');
    v_xqmjczp         := Json_Str(v_Json_Data, 'xqmjczp');
    v_xzxgzdmzybgzp   := Json_Str(v_Json_Data, 'xzxgzdmzybgzp');
  
    --校验权限
    if v_czyjgjb <> '3' then
      --非区县
      v_err := '当前机构无病例填报权限!';
      raise err_custom;
    end if;
  
    --校验状态
    select count(1)
      into v_count
      from zjjk_mb_zlfh a, zjjk_zlfhsj b
     where a.cctjid = b.jlbh
       and b.zt = '1'
       and a.id = v_id
       and a.mblx = '2'
       and a.zt = '1'
       and nvl(a.fhzt, '0') in ('0', '1', '6');
    if v_count <> 1 then
      v_err := '未找到待填报的病例!';
      raise err_custom;
    end if;
  
    --校验必填项目
    if v_id is null then
      v_err := '报告卡ID不能为空!';
      raise err_custom;
    end if;
    if v_bkdw is null then
      v_err := '报卡单位不能为空!';
      raise err_custom;
    end if;
    if v_jbxxybgksfyz is null then
      v_err := '个人信息判断不能为空!';
      raise err_custom;
    end if;
    if v_kpzt is null then
      v_err := '卡片状态不能为空!';
      raise err_custom;
    end if;
    if v_bgkbm is null then
      v_err := '报告卡编码不能为空!';
      raise err_custom;
    end if;
    if v_xm is null then
      v_err := '姓名不能为空!';
      raise err_custom;
    end if;
    if v_xb is null then
      v_err := '性别不能为空!';
      raise err_custom;
    end if;
    if v_csrq is null then
      v_err := '出生日期不能为空!';
      raise err_custom;
    end if;
    if v_sfzh is null then
      --v_err := '身份证号不能为空!';
      --raise err_custom;
      --如果没有身份证号，则设为否
      v_sfzh:='无';
    end if;
    if v_zdrq is null then
      v_err := '诊断日期（发病日期）不能为空!';
      raise err_custom;
    end if;
    if v_icd10 is null then
      v_err := 'ICD-10不能为空!';
      raise err_custom;
    end if;
    if v_czbajldjttj is null then
      v_err := '查找病案记录的具体途径不能为空!';
      raise err_custom;
    end if;
    if v_qtczbajldtj is null and v_czbajldjttj = '3' then
      v_err := '其他查找病案记录的途径不能为空!';
      raise err_custom;
    end if;
    if v_sfczbdcxgbazl is null then
      v_err := '是否查找并调出该对象住院诊治的相关病案资料不能为空!';
      raise err_custom;
    end if;
    if v_bajlsfdzh is null and v_sfczbdcxgbazl = '0' then
      v_err := '病案记录是否电子化不能为空!';
      raise err_custom;
    end if;
    if v_dzbasjnr is null and v_bajlsfdzh = '0' then
      v_err := '电子病案涉及内容不能为空!';
      raise err_custom;
    end if;
    if v_wczbdcxgbazlyy is null and v_sfczbdcxgbazl = '1' then
      v_err := '未查找并调出该对象住院诊治的相关病案资料的可能原因不能为空!';
      raise err_custom;
    end if;
    if v_qtknyy is null and v_wczbdcxgbazlyy = '3' then
      v_err := '其他可能的原因不能为空!';
      raise err_custom;
    end if;
    if v_sfczbdcxgbazl = '0' then
      if v_sfcjbasy is null then
        v_err := '是否采集（复印或拍照）医院病案首页不能为空!';
        raise err_custom;
      end if;
      if v_sfcjcyxj is null then
        v_err := '是否采集（复印或拍照）医院出院小结/死亡记录不能为空!';
        raise err_custom;
      end if;
      if v_sfcjryjl is null then
        v_err := '是否采集（复印或拍照）医院入院记录（首次病程）不能为空!';
        raise err_custom;
      end if;
      if v_sfcjxdtjcbg is null then
        v_err := '是否采集（复印或拍照）心电图检查报告不能为空!';
        raise err_custom;
      end if;
      if v_sfcjxqmjc is null then
        v_err := '是否采集（复印或拍照）血清酶检查（肌酸激酶，肌钙蛋白等）不能为空!';
        raise err_custom;
      end if;
      if v_sfcjxzxgzdmzybg is null then
        v_err := '是否采集（复印或拍照）选择性冠状动脉造影报告不能为空!';
        raise err_custom;
      end if;
      if v_zyzd is null then
        v_err := '主要诊断不能为空!';
        raise err_custom;
      end if;
      if v_chzt is null then
        v_err := '存活状态不能为空!';
        raise err_custom;
      end if;
      if v_blcjzqz is null then
        v_err := '病例采集者签字不能为空!';
        raise err_custom;
      end if;
      if v_bacjzdw is null then
        v_err := '病案采集者单位不能为空!';
        raise err_custom;
      end if;
      if v_fhbgrq is null then
        v_err := '复核报告日期不能为空!';
        raise err_custom;
      end if;
    end if;
    if v_zdyj is null then
      v_err := '诊断依据不能为空!';
      raise err_custom;
    end if;
    if v_zlwzx is null then
      v_err := '病案结果判断不能为空!';
      raise err_custom;
    end if;
    
    --更新资料完整性
    --基本信息判断验证
    if ((v_xmxg IS NULL AND v_xbxg IS NULL AND v_csrqxg IS NULL AND v_sfzhxg IS NULL 
         ) AND v_jbxxybgksfyz='1')
       OR
       ((v_xmxg IS NOT NULL OR v_xbxg IS NOT NULL OR v_csrqxg IS NOT NULL OR v_sfzhxg IS NOT NULL 
         ) AND v_jbxxybgksfyz='0') then
       v_err := '个人信息判断验证不通过!';
      raise err_custom;
    end if;
    
    --病案结果判断验证
    if ((nvl(v_sfcjbasy, '1') <> '0' or nvl(v_sfcjcyxj, '1') <> '0' or
       nvl(v_sfcjryjl, '1') <> '0' or nvl(v_sfcjxdtjcbg, '1') <> '0' or
       nvl(v_sfcjxqmjc, '1') <> '0' or nvl(v_sfcjxzxgzdmzybg, '1') <> '0') AND v_zlwzx='0')
       OR
       ((nvl(v_sfcjbasy, '1') = '0' AND nvl(v_sfcjcyxj, '1') = '0' AND
       nvl(v_sfcjryjl, '1') = '0' AND nvl(v_sfcjxdtjcbg, '1') = '0' AND
       nvl(v_sfcjxqmjc, '1') = '0' AND nvl(v_sfcjxzxgzdmzybg, '1') = '0') AND v_zlwzx='1') then
       v_err := '病案结果判断验证不通过!';
      raise err_custom;
    end if;
    
    --综合结果判断验证
    if (v_jbxxybgksfyz = '0' AND v_zlwzx ='0' AND v_fhjgpd='1')
       OR
       ((v_jbxxybgksfyz = '1' OR v_zlwzx ='1') AND v_fhjgpd='0') then
       v_err := '结果判断验证不通过!';
      raise err_custom;
    end if;
    
    --判断新增还是修改
    select count(1) into v_count from zjjk_mb_zlfh_gxb a where a.id = v_id;
    if v_count > 0 then
      --修改
UPDATE zjjk_mb_zlfh_gxb
   SET bkdw            = v_bkdw,
       zyh             = v_zyh,
       jbxxybgksfyz    = v_jbxxybgksfyz,
       kpzt            = v_kpzt,
       blh             = v_blh,
       bgkbm           = v_bgkbm,
       xm              = v_xm,
       xmxg            = v_xmxg,
       xb              = v_xb,
       xbxg            = v_xbxg,
       csrq            = v_csrq,
       csrqxg          = v_csrqxg,
       sfzh            = v_sfzh,
       sfzhxg          = v_sfzhxg,
       zdrq            = v_zdrq,
       zdrqxg          = v_zdrqxg,
       icd10           = v_icd10,
       icd10xg         = v_icd10xg,
       bgyysfwzdyy     = v_bgyysfwzdyy,
       zdyymc          = v_zdyymc,
       czbajldjttj     = v_czbajldjttj,
       qtczbajldtj     = v_qtczbajldtj,
       sfczbdcxgbazl   = v_sfczbdcxgbazl,
       bajlsfdzh       = v_bajlsfdzh,
       dzbasjnr        = v_dzbasjnr,
       wczbdcxgbazlyy  = v_wczbdcxgbazlyy,
       qtknyy          = v_qtknyy,
       sfcjbasy        = v_sfcjbasy,
       sfcjcyxj        = v_sfcjcyxj,
       sfcjryjl        = v_sfcjryjl,
       sfcjxdtjcbg     = v_sfcjxdtjcbg,
       sfcjxqmjc       = v_sfcjxqmjc,
       sfcjxzxgzdmzybg = v_sfcjxzxgzdmzybg,
       zyzd            = v_zyzd,
       cyhqtzd         = v_cyhqtzd,
       chzt            = v_chzt,
       wlcdqtjcbg      = v_wlcdqtjcbg,
       blcjzqz         = v_blcjzqz,
       bacjzdw         = v_bacjzdw,
       fhbgrq          = v_fhbgrq,
       zlwzx           = v_zlwzx,
       zdyj            = v_zdyj,
       zdyjxg          = v_zdyjxg,
       fhjgpd          = v_fhjgpd,
       xgrid           = v_czyyhid,
       xgrxm           = v_czyyhxm,
       xgsj            = v_sysdate,
       fhzt            = '1',
       basyzp          = v_basyzp,
       cyxjzp          = v_cyxjzp,
       ryjlzp          = v_ryjlzp,
       xdtjcbgzp       = v_xdtjcbgzp,
       xqmjczp         = v_xqmjczp,
       xzxgzdmzybgzp   = v_xzxgzdmzybgzp
 WHERE id = v_id;
    else
      --新增
      INSERT INTO zjjk_mb_zlfh_gxb
        (id,
         bkdw,
         zyh,
         jbxxybgksfyz,
         kpzt,
         blh,
         bgkbm,
         xm,
         xmxg,
         xb,
         xbxg,
         csrq,
         csrqxg,
         sfzh,
         sfzhxg,
         zdrq,
         zdrqxg,
         icd10,
         icd10xg,
         bgyysfwzdyy,
         zdyymc,
         czbajldjttj,
         qtczbajldtj,
         sfczbdcxgbazl,
         bajlsfdzh,
         dzbasjnr,
         wczbdcxgbazlyy,
         qtknyy,
         sfcjbasy,
         sfcjcyxj,
         sfcjryjl,
         sfcjxdtjcbg,
         sfcjxqmjc,
         sfcjxzxgzdmzybg,
         zyzd,
         cyhqtzd,
         chzt,
         wlcdqtjcbg,
         blcjzqz,
         bacjzdw,
         fhbgrq,
         zdyj,
         zdyjxg,
         fhjgpd,
         zlwzx,
         fhzt,
         cjrid,
         cjrxm,
         cjsj,
         xgrid,
         xgrxm,
         xgsj, 
         basyzp,
         cyxjzp,
         ryjlzp,
         xdtjcbgzp,
         xqmjczp,
         xzxgzdmzybgzp)
      VALUES
        (v_id,
         v_bkdw,
         v_zyh,
         v_jbxxybgksfyz,
         v_kpzt,
         v_blh,
         v_bgkbm,
         v_xm,
         v_xmxg,
         v_xb,
         v_xbxg,
         v_csrq,
         v_csrqxg,
         v_sfzh,
         v_sfzhxg,
         v_zdrq,
         v_zdrqxg,
         v_icd10,
         v_icd10xg,
         v_bgyysfwzdyy,
         v_zdyymc,
         v_czbajldjttj,
         v_qtczbajldtj,
         v_sfczbdcxgbazl,
         v_bajlsfdzh,
         v_dzbasjnr,
         v_wczbdcxgbazlyy,
         v_qtknyy,
         v_sfcjbasy,
         v_sfcjcyxj,
         v_sfcjryjl,
         v_sfcjxdtjcbg,
         v_sfcjxqmjc,
         v_sfcjxzxgzdmzybg,
         v_zyzd,
         v_cyhqtzd,
         v_chzt,
         v_wlcdqtjcbg,
         v_blcjzqz,
         v_bacjzdw,
         v_fhbgrq,
         v_zdyj,
         v_zdyjxg,
         v_fhjgpd,
         v_zlwzx,
         '1',
         v_czyyhid,
         v_czyyhxm,
         v_sysdate,
         v_czyyhid,
         v_czyyhxm,
         v_sysdate,
         v_basyzp,
         v_cyxjzp,
         v_ryjlzp,
         v_xdtjcbgzp,
         v_xqmjczp,
         v_xzxgzdmzybgzp);
    end if;
    --更新复核状态
    update zjjk_mb_zlfh a
       set a.fhzt = '1', a.fhbz = '1'
     where a.id = v_id
       and a.mblx = '2';
    --返回
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_mb_blfh_gxb_update;
  /*-----------------------------------------------------------------------------
  || 功能描述 ：冠心病病例提交
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_mb_blfh_gxb_zt_tj(data_in    IN CLOB, --入参
                                  result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
  
    v_id zjjk_mb_zlfh.id%TYPE; --ID
    --公共变量
    v_sysdate date;
    v_czyjgjb varchar2(3);
    v_czyjgdm varchar2(50);
    v_czyyhid varchar2(50);
    v_czyyhxm varchar2(50);
    v_count   number;
  
  BEGIN
    json_data(data_in, '冠心病病例提交', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid');
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    v_czyyhxm := Json_Str(v_Json_Data, 'czyyhxm');
  
    v_id := Json_Str(v_Json_Data, 'id');
    if v_id is null then
      v_err := 'id不能为空!';
      raise err_custom;
    end if;
    --更新状态
    update zjjk_mb_zlfh a
       set a.fhzt = '3',
           a.fhczrid = v_czyyhid,
           a.fhczrxm = v_czyyhxm,
           a.fhjgid  = v_czyjgdm,
           a.fhsj    = v_sysdate
     where a.fhzt = '1'
       and a.id = v_id
       and a.mblx = '2'
       and a.zt = '1';
    if sql%rowcount <> 1 then
      v_err := '更新病例状态出错!';
      raise err_custom;
    end if;
    update zjjk_mb_zlfh_gxb a set a.fhzt = '3' where a.id = v_id;
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_mb_blfh_gxb_zt_tj;
  /*-----------------------------------------------------------------------------
  || 功能描述 ：冠心病病例复核
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_mb_blfh_gxb_zt_fh(data_in    IN CLOB, --入参
                                  result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err  VARCHAR2(2000);
    v_id   zjjk_mb_zlfh.id%TYPE; --ID
    v_fhzt zjjk_mb_zlfh.fhzt%TYPE; --ID
    v_fhyj zjjk_mb_zlfh.fhyj%TYPE; --复核意见
  
    --公共变量
    v_sysdate date;
    v_czyjgjb varchar2(3);
    v_czyjgdm varchar2(50);
    v_czyyhid varchar2(50);
    v_czyyhxm varchar2(50);
    v_count   number;
  
  BEGIN
    json_data(data_in, '冠心病病例复核', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid');
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    v_czyyhxm := Json_Str(v_Json_Data, 'czyyhxm');
  
    v_id   := Json_Str(v_Json_Data, 'id');
    v_fhzt := Json_Str(v_Json_Data, 'fhzt');
    v_fhyj := Json_Str(v_Json_Data, 'fhyj');
    if v_id is null then
      v_err := 'id不能为空!';
      raise err_custom;
    end if;
    if nvl(v_fhzt, '-1') not in ('3', '4') then
      v_err := '复核状态传入有误!';
      raise err_custom;
    end if;
    --更新状态
    update zjjk_mb_zlfh a
       set a.fhzt    = v_fhzt,
           a.fhczrid = v_czyyhid,
           a.fhczrxm = v_czyyhxm,
           a.fhjgid  = v_czyjgdm,
           a.fhsj    = v_sysdate,
           a.fhyj    = v_fhyj
     where a.fhzt = '2'
       and a.id = v_id
       and a.mblx = '2'
       and a.zt = '1';
    if sql%rowcount <> 1 then
      v_err := '更新病例复核状态出错!';
      raise err_custom;
    end if;
    update zjjk_mb_zlfh_gxb a set a.fhzt = v_fhzt where a.id = v_id;
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_mb_blfh_gxb_zt_fh;
  /*-----------------------------------------------------------------------------
  || 功能描述 ：冠心病病例审核
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_mb_blfh_gxb_zt_sh(data_in    IN CLOB, --入参
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
    v_sysdate date;
    v_czyjgjb varchar2(3);
    v_czyjgdm varchar2(50);
    v_czyyhid varchar2(50);
    v_czyyhxm varchar2(50);
    v_count   number;
  
  BEGIN
    json_data(data_in, '冠心病病例审核', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid');
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    v_czyyhxm := Json_Str(v_Json_Data, 'czyyhxm');
  
    v_id   := Json_Str(v_Json_Data, 'id');
    v_shzt := Json_Str(v_Json_Data, 'fhzt');
    v_shyj := Json_Str(v_Json_Data, 'shyj');
    if v_id is null then
      v_err := 'id不能为空!';
      raise err_custom;
    end if;
    if nvl(v_shzt, '-1') not in ('5', '6') then
      v_err := '审核状态传入有误!';
      raise err_custom;
    end if;
    --更新状态
    update zjjk_mb_zlfh a
       set a.fhzt    = v_shzt,
           a.shczrid = v_czyyhid,
           a.shczrxm = v_czyyhxm,
           a.shjgid  = v_czyjgdm,
           a.shsj    = v_sysdate,
           a.shyj    = v_shyj
     where a.fhzt = '3'
       and a.id = v_id
       and a.mblx = '2'
       and a.zt = '1';
    if sql%rowcount <> 1 then
      v_err := '更新病例审核状态出错!';
      raise err_custom;
    end if;
    update zjjk_mb_zlfh_gxb a set a.fhzt = v_shzt where a.id = v_id;
  
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_mb_blfh_gxb_zt_sh;
  /*-----------------------------------------------------------------------------
  || 功能描述 ：肺癌病例填报
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_mb_blfh_fa_update(data_in    IN CLOB, --入参
                                  result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
  
    --公共变量
    v_sysdate date;
    v_czyjgjb varchar2(3);
    v_czyjgdm varchar2(50);
    v_czyyhid varchar2(50);
    v_czyyhxm varchar2(50);
    v_count   number;
  
    v_id             zjjk_mb_zlfh_fa.id%TYPE; --id
    v_bkdw           zjjk_mb_zlfh_fa.bkdw%TYPE; --报卡单位
    v_zyh            zjjk_mb_zlfh_fa.zyh%TYPE; --住院号
    v_jbxxybgksfyz   zjjk_mb_zlfh_fa.jbxxybgksfyz%TYPE; --基本信息与报告卡是否一致（0 是 1否）
    v_kpzt           zjjk_mb_zlfh_fa.kpzt%TYPE; --卡片状态
    v_blh            zjjk_mb_zlfh_fa.blh%TYPE; --病理号
    v_bgkbm          zjjk_mb_zlfh_fa.bgkbm%TYPE; --报告卡编码
    v_xm             zjjk_mb_zlfh_fa.xm%TYPE; --姓名
    v_xmxg           zjjk_mb_zlfh_fa.xmxg%TYPE; --姓名修改
    v_xb             zjjk_mb_zlfh_fa.xb%TYPE; --性别
    v_xbxg           zjjk_mb_zlfh_fa.xbxg%TYPE; --性别修改
    v_csrq           zjjk_mb_zlfh_fa.csrq%TYPE; --出生日期
    v_csrqxg         zjjk_mb_zlfh_fa.csrqxg%TYPE; --出生日期修改
    v_sfzh           zjjk_mb_zlfh_fa.sfzh%TYPE; --身份证号
    v_sfzhxg         zjjk_mb_zlfh_fa.sfzhxg%TYPE; --身份证号修改
    v_zdrq           zjjk_mb_zlfh_fa.zdrq%TYPE; --诊断日期（发病日期）
    v_zdrqxg         zjjk_mb_zlfh_fa.zdrqxg%TYPE; --诊断日期修改
    v_icd10          zjjk_mb_zlfh_fa.icd10%TYPE; --ICD-10
    v_icd10xg        zjjk_mb_zlfh_fa.icd10xg%TYPE; --ICD-10修改
    v_bgyysfwzdyy    zjjk_mb_zlfh_fa.bgyysfwzdyy%TYPE; --报告医院是否为诊断医院（0 是 1否）
    v_zdyymc         zjjk_mb_zlfh_fa.zdyymc%TYPE; --诊断医院名称
    v_czbajldjttj    zjjk_mb_zlfh_fa.czbajldjttj%TYPE; --查找病案记录的具体途径（0 电子住院记录系统 1 电子以及纸质住院记录名单 2 纸质住院名单 3 其他）
    v_qtczbajldtj    zjjk_mb_zlfh_fa.qtczbajldtj%TYPE; --其他查找病案记录的途径
    v_sfczbdcxgbazl  zjjk_mb_zlfh_fa.sfczbdcxgbazl%TYPE; --是否查找并调出该对象住院诊治的相关病案资料（0 是 1否）
    v_bajlsfdzh      zjjk_mb_zlfh_fa.bajlsfdzh%TYPE; --病案记录是否电子化（0 是 1否）
    v_dzbasjnr       zjjk_mb_zlfh_fa.dzbasjnr%TYPE; --电子病案涉及内容（0 所有病案信息 1 只有病案首页）
    v_wczbdcxgbazlyy zjjk_mb_zlfh_fa.wczbdcxgbazlyy%TYPE; --未查找并调出该对象住院诊治的相关病案资料的可能原因（0 未在住院记录系统中找到相关资料 1 住院病案系统有记录但病案丢失 2 住院病案系统有记录但病案未保存 3 其他）
    v_qtknyy         zjjk_mb_zlfh_fa.qtknyy%TYPE; --其他可能原因
    v_sfcjbasy       zjjk_mb_zlfh_fa.sfcjbasy%TYPE; --是否采集（复印或拍照）医院病案首页（0 是 1否）
    v_sfcjcyxj       zjjk_mb_zlfh_fa.sfcjcyxj%TYPE; --是否采集（复印或拍照）医院出院小结/死亡记录（0 是 1否）
    v_sfcjryjl       zjjk_mb_zlfh_fa.sfcjryjl%TYPE; --是否采集（复印或拍照）医院入院记录（首次病程）（0 是 1否）
    v_sfcjhjblbg     zjjk_mb_zlfh_fa.sfcjhjblbg%TYPE; --是否采集（复印或拍照）是否采集（复印或拍照）经皮肺穿刺活检病理报告（0 是 1否）
    v_sfcjqzjjcbg    zjjk_mb_zlfh_fa.sfcjqzjjcbg%TYPE; --是否采集（复印或拍照）是否采集（复印或拍照）纤维支气管镜检查报告（0 是 1否）
    v_sfcjctjcbg     zjjk_mb_zlfh_fa.sfcjctjcbg%TYPE; --是否采集（复印或拍照）是否采集（复印或拍照）CT检查报告（0 是 1否）
    v_sfcjmrijcbg    zjjk_mb_zlfh_fa.sfcjmrijcbg%TYPE; --是否采集（复印或拍照）是否采集（复印或拍照）MRI检查报告（0 是 1否）
    v_sfcjxxjcbg     zjjk_mb_zlfh_fa.sfcjxxjcbg%TYPE; --是否采集（复印或拍照）是否采集（复印或拍照）X线检查报告（0 是 1否）
    v_sfcjttlxbjcbg  zjjk_mb_zlfh_fa.sfcjttlxbjcbg%TYPE; --是否采集（复印或拍照）痰脱落细胞检查报告（0 是 1否）
    v_zyzd           zjjk_mb_zlfh_fa.zyzd%TYPE; --主要诊断
    v_cyhqtzd        zjjk_mb_zlfh_fa.cyhqtzd%TYPE; --次要或其他诊断
    v_chzt           zjjk_mb_zlfh_fa.chzt%TYPE; --存活状态（0存活 1死亡）
    v_wlcdqtjcbg     zjjk_mb_zlfh_fa.wlcdqtjcbg%TYPE; --注明其他采集到上面未列出的检测报告
    v_blcjzqz        zjjk_mb_zlfh_fa.blcjzqz%TYPE; --病例采集者签字
    v_bacjzdw        zjjk_mb_zlfh_fa.bacjzdw%TYPE; --病案采集者单位
    v_fhbgrq         zjjk_mb_zlfh_fa.fhbgrq%TYPE; --复核报告日期
    v_zdyj           zjjk_mb_zlfh_fa.zdyj%TYPE; --诊断依据
    v_zdyjxg         zjjk_mb_zlfh_fa.zdyjxg%TYPE; --诊断依据修改
    v_fhjgpd         zjjk_mb_zlfh_fa.fhjgpd%TYPE; --复核结果判断（0 符合 1不符合）
    v_zlwzx          zjjk_mb_zlfh_fa.zlwzx%TYPE; --资料完整性（0 符合 1不符合）
    v_fhzt           zjjk_mb_zlfh_fa.fhzt%TYPE; --复核状态（0 符合 1不符合）
    v_blxlx          zjjk_mb_zlfh_fa.blxlx%TYPE; --病理学类型
    v_blxlxxg        zjjk_mb_zlfh_fa.blxlxxg%TYPE; --病理学类型修改
    v_basyzp         zjjk_mb_zlfh_fa.basyzp%TYPE;    --（复印或拍照）医院病案首页照片
    v_cyxjzp         zjjk_mb_zlfh_fa.cyxjzp%TYPE;    --（复印或拍照）医院出院小结/死亡记录照片
    v_ryjlzp         zjjk_mb_zlfh_fa.ryjlzp%TYPE;    --（复印或拍照）医院入院记录（首次病程）照片
    v_hjblbgzp       zjjk_mb_zlfh_fa.hjblbgzp%TYPE;    --（复印或拍照）是否采集（复印或拍照）经皮肺穿刺活检病理报告照片
    v_qzjjcbgzp      zjjk_mb_zlfh_fa.qzjjcbgzp%TYPE;    --（复印或拍照）是否采集（复印或拍照）纤维支气管镜检查报告照片
    v_ctjcbgzp       zjjk_mb_zlfh_fa.ctjcbgzp%TYPE;    --（复印或拍照）是否采集（复印或拍照）CT检查报告照片
    v_mrijcbgzp      zjjk_mb_zlfh_fa.mrijcbgzp%TYPE;    --（复印或拍照）是否采集（复印或拍照）MRI检查报告照片
    v_xxjcbgzp       zjjk_mb_zlfh_fa.xxjcbgzp%TYPE;    --（复印或拍照）是否采集（复印或拍照）X线检查报告照片
    v_ttlxbjcbgzp    zjjk_mb_zlfh_fa.ttlxbjcbgzp%TYPE;    --（复印或拍照）痰脱落细胞检查报告照片
    v_icdo3bm        zjjk_mb_zlfh_fa.icdo3bm%TYPE;    --ICD-O-3编码
    v_icdo3bmxg      zjjk_mb_zlfh_fa.icdo3bmxg%TYPE;    -- ICD-O-3编码修改
    
    --其他变量
    v_bgkid_s VARCHAR2(2000); --被抽查的报告卡IDs
  
  BEGIN
    json_data(data_in, '肺癌报告卡病例填报', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid');
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    v_czyyhxm := Json_Str(v_Json_Data, 'czyyhxm');
  
    v_id             := Json_Str(v_Json_Data, 'id');
    v_bkdw           := Json_Str(v_Json_Data, 'bkdw');
    v_zyh            := Json_Str(v_Json_Data, 'zyh');
    v_jbxxybgksfyz   := Json_Str(v_Json_Data, 'jbxxybgksfyz');
    v_kpzt           := Json_Str(v_Json_Data, 'kpzt');
    v_blh            := Json_Str(v_Json_Data, 'blh');
    v_bgkbm          := Json_Str(v_Json_Data, 'bgkbm');
    v_xm             := Json_Str(v_Json_Data, 'xm');
    v_xmxg           := Json_Str(v_Json_Data, 'xmxg');
    v_xb             := Json_Str(v_Json_Data, 'xb');
    v_xbxg           := Json_Str(v_Json_Data, 'xbxg');
    v_csrq           := std(Json_Str(v_Json_Data, 'csrq'), 0);
    v_csrqxg         := Json_Str(v_Json_Data, 'csrqxg');
    v_sfzh           := Json_Str(v_Json_Data, 'sfzh');
    v_sfzhxg         := Json_Str(v_Json_Data, 'sfzhxg');
    v_zdrq           := std(Json_Str(v_Json_Data, 'zdrq'), 0);
    v_zdrqxg         := Json_Str(v_Json_Data, 'zdrqxg');
    v_icd10          := Json_Str(v_Json_Data, 'icd10');
    v_icd10xg        := Json_Str(v_Json_Data, 'icd10xg');
    v_bgyysfwzdyy    := Json_Str(v_Json_Data, 'bgyysfwzdyy');
    v_zdyymc         := Json_Str(v_Json_Data, 'zdyymc');
    v_czbajldjttj    := Json_Str(v_Json_Data, 'czbajldjttj');
    v_qtczbajldtj    := Json_Str(v_Json_Data, 'qtczbajldtj');
    v_sfczbdcxgbazl  := Json_Str(v_Json_Data, 'sfczbdcxgbazl');
    v_bajlsfdzh      := Json_Str(v_Json_Data, 'bajlsfdzh');
    v_dzbasjnr       := Json_Str(v_Json_Data, 'dzbasjnr');
    v_wczbdcxgbazlyy := Json_Str(v_Json_Data, 'wczbdcxgbazlyy');
    v_qtknyy         := Json_Str(v_Json_Data, 'qtknyy');
    v_sfcjbasy       := Json_Str(v_Json_Data, 'sfcjbasy');
    v_sfcjcyxj       := Json_Str(v_Json_Data, 'sfcjcyxj');
    v_sfcjryjl       := Json_Str(v_Json_Data, 'sfcjryjl');
    v_sfcjhjblbg     := Json_Str(v_Json_Data, 'sfcjhjblbg');
    v_sfcjqzjjcbg    := Json_Str(v_Json_Data, 'sfcjqzjjcbg');
    v_sfcjctjcbg     := Json_Str(v_Json_Data, 'sfcjctjcbg');
    v_sfcjmrijcbg    := Json_Str(v_Json_Data, 'sfcjmrijcbg');
    v_sfcjxxjcbg     := Json_Str(v_Json_Data, 'sfcjxxjcbg');
    v_sfcjttlxbjcbg  := Json_Str(v_Json_Data, 'sfcjttlxbjcbg');
    v_zyzd           := Json_Str(v_Json_Data, 'zyzd');
    v_cyhqtzd        := Json_Str(v_Json_Data, 'cyhqtzd');
    v_chzt           := Json_Str(v_Json_Data, 'chzt');
    v_wlcdqtjcbg     := Json_Str(v_Json_Data, 'wlcdqtjcbg');
    v_blcjzqz        := Json_Str(v_Json_Data, 'blcjzqz');
    v_bacjzdw        := Json_Str(v_Json_Data, 'bacjzdw');
    v_fhbgrq         := std(Json_Str(v_Json_Data, 'fhbgrq'), 0);
    v_zdyj           := Json_Str(v_Json_Data, 'zdyj');
    v_zdyjxg         := Json_Str(v_Json_Data, 'zdyjxg');
    v_fhjgpd         := Json_Str(v_Json_Data, 'fhjgpd');
    v_blxlx          := Json_Str(v_Json_Data, 'blxlx');
    v_blxlxxg        := Json_Str(v_Json_Data, 'blxlxxg');
    v_zlwzx          := Json_Str(v_Json_Data, 'zlwzx');
    v_basyzp         := Json_Str(v_Json_Data, 'basyzp');
    v_cyxjzp         := Json_Str(v_Json_Data, 'cyxjzp');
    v_ryjlzp         := Json_Str(v_Json_Data, 'ryjlzp');
    v_hjblbgzp       := Json_Str(v_Json_Data, 'hjblbgzp');
    v_qzjjcbgzp      := Json_Str(v_Json_Data, 'qzjjcbgzp');
    v_ctjcbgzp       := Json_Str(v_Json_Data, 'ctjcbgzp');
    v_mrijcbgzp      := Json_Str(v_Json_Data, 'mrijcbgzp');
    v_xxjcbgzp       := Json_Str(v_Json_Data, 'xxjcbgzp');
    v_ttlxbjcbgzp    := Json_Str(v_Json_Data, 'ttlxbjcbgzp');
    v_icdo3bm        := Json_Str(v_Json_Data, 'icdo3bm');
    v_icdo3bmxg      := Json_Str(v_Json_Data, 'icdo3bmxg');
    
    --校验权限
    if v_czyjgjb <> '3' then
      --非区县
      v_err := '当前机构无病例填报权限!';
      raise err_custom;
    end if;
  
    --校验状态
    select count(1)
      into v_count
      from zjjk_mb_zlfh a, zjjk_zlfhsj b
     where a.cctjid = b.jlbh
       and b.zt = '1'
       and a.id = v_id
       and a.mblx = '4'
       and a.ccbz = '401'
       and a.zt = '1'
       and nvl(a.fhzt, '0') in ('0', '1', '6');
    if v_count <> 1 then
      v_err := '未找到待填报的病例!';
      raise err_custom;
    end if;
  
    --校验必填项目
    if v_id is null then
      v_err := '报告卡ID不能为空!';
      raise err_custom;
    end if;
    if v_bkdw is null then
      v_err := '报卡单位不能为空!';
      raise err_custom;
    end if;
    if v_jbxxybgksfyz is null then
      v_err := '个人信息判断不能为空!';
      raise err_custom;
    end if;
    if v_kpzt is null then
      v_err := '卡片状态不能为空!';
      raise err_custom;
    end if;
    if v_bgkbm is null then
      v_err := '报告卡编码不能为空!';
      raise err_custom;
    end if;
    if v_xm is null then
      v_err := '姓名不能为空!';
      raise err_custom;
    end if;
    if v_xb is null then
      v_err := '性别不能为空!';
      raise err_custom;
    end if;
    if v_csrq is null then
      v_err := '出生日期不能为空!';
      raise err_custom;
    end if;
    if v_sfzh is null then
      --v_err := '身份证号不能为空!';
      --raise err_custom;
      --如果没有身份证号，则设为否
      v_sfzh:='无';
    end if;
    if v_zdrq is null then
      v_err := '诊断日期（发病日期）不能为空!';
      raise err_custom;
    end if;
    if v_icd10 is null then
      v_err := 'ICD-10不能为空!';
      raise err_custom;
    end if;
    if v_czbajldjttj is null then
      v_err := '查找病案记录的具体途径不能为空!';
      raise err_custom;
    end if;
    if v_qtczbajldtj is null and v_czbajldjttj = '3' then
      v_err := '其他查找病案记录的途径不能为空!';
      raise err_custom;
    end if;
    if v_sfczbdcxgbazl is null then
      v_err := '是否查找并调出该对象住院诊治的相关病案资料不能为空!';
      raise err_custom;
    end if;
    if v_bajlsfdzh is null and v_sfczbdcxgbazl = '0' then
      v_err := '病案记录是否电子化不能为空!';
      raise err_custom;
    end if;
    if v_dzbasjnr is null and v_bajlsfdzh = '0' then
      v_err := '电子病案涉及内容不能为空!';
      raise err_custom;
    end if;
    if v_wczbdcxgbazlyy is null and v_sfczbdcxgbazl = '1' then
      v_err := '未查找并调出该对象住院诊治的相关病案资料的可能原因不能为空!';
      raise err_custom;
    end if;
    if v_qtknyy is null and v_wczbdcxgbazlyy = '3' then
      v_err := '其他可能的原因不能为空!';
      raise err_custom;
    end if;
    if v_sfczbdcxgbazl = '0' then
      if v_sfcjbasy is null then
        v_err := '是否采集（复印或拍照）医院病案首页不能为空!';
        raise err_custom;
      end if;
      if v_sfcjcyxj is null then
        v_err := '是否采集（复印或拍照）医院出院小结/死亡记录不能为空!';
        raise err_custom;
      end if;
      if v_sfcjryjl is null then
        v_err := '是否采集（复印或拍照）医院入院记录（首次病程）不能为空!';
        raise err_custom;
      end if;
      if v_sfcjhjblbg is null then
        v_err := '是否采集（复印或拍照）经皮肺穿刺活检病理报告不能为空!';
        raise err_custom;
      end if;
      if v_sfcjqzjjcbg is null then
        v_err := '是否采集（复印或拍照）纤维支气管镜检查报告不能为空!';
        raise err_custom;
      end if;
      if v_sfcjctjcbg is null then
        v_err := '是否采集（复印或拍照）CT检查报告不能为空!';
        raise err_custom;
      end if;
    
      if v_sfcjmrijcbg is null then
        v_err := '是否采集（复印或拍照）MRI检查报告不能为空!';
        raise err_custom;
      end if;
      if v_sfcjxxjcbg is null then
        v_err := '是否采集（复印或拍照）X线检查报告不能为空!';
        raise err_custom;
      end if;
      if v_sfcjttlxbjcbg is null then
        v_err := '是否采集（复印或拍照）痰脱落细胞检查报告不能为空!';
        raise err_custom;
      end if;
      --if v_blxlx is null then
      --  v_err := '病理学类型不能为空!';
      --  raise err_custom;
      --end if;
      if v_zyzd is null then
        v_err := '主要诊断不能为空!';
        raise err_custom;
      end if;
      if v_chzt is null then
        v_err := '存活状态不能为空!';
        raise err_custom;
      end if;
      if v_blcjzqz is null then
        v_err := '病例采集者签字不能为空!';
        raise err_custom;
      end if;
      if v_bacjzdw is null then
        v_err := '病案采集者单位不能为空!';
        raise err_custom;
      end if;
      if v_fhbgrq is null then
        v_err := '复核报告日期不能为空!';
        raise err_custom;
      end if;
    end if;
    if v_zdyj is null then
      v_err := '诊断依据不能为空!';
      raise err_custom;
    end if;
    if v_zlwzx is null then
      v_err := '病案结果判断不能为空!';
      raise err_custom;
    end if;
    
    --更新资料完整性
    --基本信息判断验证
    if ((v_xmxg IS NULL AND v_xbxg IS NULL AND v_csrqxg IS NULL AND v_sfzhxg IS NULL 
         ) AND v_jbxxybgksfyz='1')
       OR
       ((v_xmxg IS NOT NULL OR v_xbxg IS NOT NULL OR v_csrqxg IS NOT NULL OR v_sfzhxg IS NOT NULL 
         ) AND v_jbxxybgksfyz='0') then
       v_err := '个人信息判断验证不通过!';
      raise err_custom;
    end if;
    
    --病案结果判断验证
    if ((nvl(v_sfcjbasy, '1') <> '0' or nvl(v_sfcjcyxj, '1') <> '0' or
       nvl(v_sfcjryjl, '1') <> '0' or nvl(v_sfcjhjblbg, '1') <> '0' or
       nvl(v_sfcjxxjcbg, '1') <> '0' or nvl(v_sfcjctjcbg, '1') <> '0' or
       nvl(v_sfcjmrijcbg, '1') <> '0' or nvl(v_sfcjxxjcbg, '1') <> '0' or
       nvl(v_sfcjttlxbjcbg, '1') <> '0') AND v_zlwzx='0')
       OR
       ((nvl(v_sfcjbasy, '1') = '0' AND nvl(v_sfcjcyxj, '1') = '0' AND
       nvl(v_sfcjryjl, '1') = '0' AND nvl(v_sfcjhjblbg, '1') = '0' AND
       nvl(v_sfcjxxjcbg, '1') = '0' AND nvl(v_sfcjctjcbg, '1') = '0' AND
       nvl(v_sfcjmrijcbg, '1') = '0' AND nvl(v_sfcjxxjcbg, '1') = '0' AND
       nvl(v_sfcjttlxbjcbg, '1') = '0') AND v_zlwzx='1') then
       v_err := '病案结果判断验证不通过!';
      raise err_custom;
    end if;
    
    --综合结果判断验证
    if (v_jbxxybgksfyz = '0' AND v_zlwzx ='0' AND v_fhjgpd='1')
       OR
       ((v_jbxxybgksfyz = '1' OR v_zlwzx ='1') AND v_fhjgpd='0') then
       v_err := '结果判断验证不通过!';
      raise err_custom;
    end if;
    
    --判断新增还是修改
    select count(1) into v_count from zjjk_mb_zlfh_fa a where a.id = v_id;
    if v_count > 0 then
      --修改
      UPDATE zjjk_mb_zlfh_fa
         SET bkdw           = v_bkdw,
             zyh            = v_zyh,
             jbxxybgksfyz   = v_jbxxybgksfyz,
             kpzt           = v_kpzt,
             blh            = v_blh,
             bgkbm          = v_bgkbm,
             xm             = v_xm,
             xmxg           = v_xmxg,
             xb             = v_xb,
             xbxg           = v_xbxg,
             csrq           = v_csrq,
             csrqxg         = v_csrqxg,
             sfzh           = v_sfzh,
             sfzhxg         = v_sfzhxg,
             zdrq           = v_zdrq,
             zdrqxg         = v_zdrqxg,
             icd10          = v_icd10,
             icd10xg        = v_icd10xg,
             bgyysfwzdyy    = v_bgyysfwzdyy,
             zdyymc         = v_zdyymc,
             czbajldjttj    = v_czbajldjttj,
             qtczbajldtj    = v_qtczbajldtj,
             sfczbdcxgbazl  = v_sfczbdcxgbazl,
             bajlsfdzh      = v_bajlsfdzh,
             dzbasjnr       = v_dzbasjnr,
             wczbdcxgbazlyy = v_wczbdcxgbazlyy,
             qtknyy         = v_qtknyy,
             sfcjbasy       = v_sfcjbasy,
             sfcjcyxj       = v_sfcjcyxj,
             sfcjryjl       = v_sfcjryjl,
             sfcjhjblbg     = v_sfcjhjblbg,
             sfcjqzjjcbg    = v_sfcjqzjjcbg,
             sfcjctjcbg     = v_sfcjctjcbg,
             sfcjmrijcbg    = v_sfcjmrijcbg,
             sfcjxxjcbg     = v_sfcjxxjcbg,
             sfcjttlxbjcbg  = v_sfcjttlxbjcbg,
             zyzd           = v_zyzd,
             cyhqtzd        = v_cyhqtzd,
             chzt           = v_chzt,
             wlcdqtjcbg     = v_wlcdqtjcbg,
             blcjzqz        = v_blcjzqz,
             bacjzdw        = v_bacjzdw,
             fhbgrq         = v_fhbgrq,
             zdyj           = v_zdyj,
             zdyjxg         = v_zdyjxg,
             fhjgpd         = v_fhjgpd,
             zlwzx          = v_zlwzx,
             xgrid          = v_czyyhid,
             xgrxm          = v_czyyhxm,
             xgsj           = v_sysdate,
             blxlx          = v_blxlx,
             blxlxxg        = v_blxlxxg,
             fhzt           = '1',
             basyzp         = v_basyzp,
             cyxjzp         = v_cyxjzp,
             ryjlzp         = v_ryjlzp,
             hjblbgzp       = v_hjblbgzp,
             qzjjcbgzp      = v_qzjjcbgzp,
             ctjcbgzp       = v_ctjcbgzp,
             mrijcbgzp      = v_mrijcbgzp,
             xxjcbgzp       = v_xxjcbgzp,
             icdo3bm        = v_icdo3bm,
             icdo3bmxg     = v_icdo3bmxg,
             ttlxbjcbgzp    = v_ttlxbjcbgzp
       WHERE id = v_id;
    else
      --新增
      INSERT INTO zjjk_mb_zlfh_fa
        (id,
         bkdw,
         zyh,
         jbxxybgksfyz,
         kpzt,
         blh,
         bgkbm,
         xm,
         xmxg,
         xb,
         xbxg,
         csrq,
         csrqxg,
         sfzh,
         sfzhxg,
         zdrq,
         zdrqxg,
         icd10,
         icd10xg,
         bgyysfwzdyy,
         zdyymc,
         czbajldjttj,
         qtczbajldtj,
         sfczbdcxgbazl,
         bajlsfdzh,
         dzbasjnr,
         wczbdcxgbazlyy,
         qtknyy,
         sfcjbasy,
         sfcjcyxj,
         sfcjryjl,
         sfcjhjblbg,
         sfcjqzjjcbg,
         sfcjctjcbg,
         sfcjmrijcbg,
         sfcjxxjcbg,
         sfcjttlxbjcbg,
         zyzd,
         cyhqtzd,
         chzt,
         wlcdqtjcbg,
         blcjzqz,
         bacjzdw,
         fhbgrq,
         zdyj,
         zdyjxg,
         fhjgpd,
         zlwzx,
         fhzt,
         cjrid,
         cjrxm,
         cjsj,
         xgrid,
         xgrxm,
         xgsj,
         blxlx,
         blxlxxg,
         basyzp,
         cyxjzp,
         ryjlzp,
         hjblbgzp,
         qzjjcbgzp,
         ctjcbgzp,
         mrijcbgzp,
         xxjcbgzp,
         icdo3bm,
         icdo3bmxg,
         ttlxbjcbgzp)
      VALUES
        (v_id,
         v_bkdw,
         v_zyh,
         v_jbxxybgksfyz,
         v_kpzt,
         v_blh,
         v_bgkbm,
         v_xm,
         v_xmxg,
         v_xb,
         v_xbxg,
         v_csrq,
         v_csrqxg,
         v_sfzh,
         v_sfzhxg,
         v_zdrq,
         v_zdrqxg,
         v_icd10,
         v_icd10xg,
         v_bgyysfwzdyy,
         v_zdyymc,
         v_czbajldjttj,
         v_qtczbajldtj,
         v_sfczbdcxgbazl,
         v_bajlsfdzh,
         v_dzbasjnr,
         v_wczbdcxgbazlyy,
         v_qtknyy,
         v_sfcjbasy,
         v_sfcjcyxj,
         v_sfcjryjl,
         v_sfcjhjblbg,
         v_sfcjqzjjcbg,
         v_sfcjctjcbg,
         v_sfcjmrijcbg,
         v_sfcjxxjcbg,
         v_sfcjttlxbjcbg,
         v_zyzd,
         v_cyhqtzd,
         v_chzt,
         v_wlcdqtjcbg,
         v_blcjzqz,
         v_bacjzdw,
         v_fhbgrq,
         v_zdyj,
         v_zdyjxg,
         v_fhjgpd,
         v_zlwzx,
         '1',
         v_czyyhid,
         v_czyyhxm,
         v_sysdate,
         v_czyyhid,
         v_czyyhxm,
         v_sysdate,
         v_blxlx,
         v_blxlxxg,
         v_basyzp,
         v_cyxjzp,
         v_ryjlzp,
         v_hjblbgzp,
         v_qzjjcbgzp,
         v_ctjcbgzp,
         v_mrijcbgzp,
         v_xxjcbgzp,
         v_icdo3bm,
         v_icdo3bmxg,
         v_ttlxbjcbgzp);
    
    end if;
    --更新复核状态
    update zjjk_mb_zlfh a
       set a.fhzt = '1', a.fhbz = '1'
     where a.id = v_id
       and a.mblx = '4'
       and a.ccbz = '401';
    --返回
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_mb_blfh_fa_update;
  /*-----------------------------------------------------------------------------
  || 功能描述 ：肺癌病例提交
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_mb_blfh_fa_zt_tj(data_in    IN CLOB, --入参
                                 result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
  
    v_id zjjk_mb_zlfh.id%TYPE; --ID
    --公共变量
    v_sysdate date;
    v_czyjgjb varchar2(3);
    v_czyjgdm varchar2(50);
    v_czyyhid varchar2(50);
    v_czyyhxm varchar2(50);
    v_count   number;
  
  BEGIN
    json_data(data_in, '肺癌病例提交', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid');
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    v_czyyhxm := Json_Str(v_Json_Data, 'czyyhxm');
  
    v_id := Json_Str(v_Json_Data, 'id');
    if v_id is null then
      v_err := 'id不能为空!';
      raise err_custom;
    end if;
    --更新状态
    update zjjk_mb_zlfh a
       set a.fhzt = '3',
           a.fhczrid = v_czyyhid,
           a.fhczrxm = v_czyyhxm,
           a.fhjgid  = v_czyjgdm,
           a.fhsj    = v_sysdate
     where a.fhzt = '1'
       and a.id = v_id
       and a.mblx = '4'
       and a.ccbz = '401'
       and a.zt = '1';
    if sql%rowcount <> 1 then
      v_err := '更新病例状态出错!';
      raise err_custom;
    end if;
    update zjjk_mb_zlfh_fa a set a.fhzt = '3' where a.id = v_id;
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_mb_blfh_fa_zt_tj;
  /*-----------------------------------------------------------------------------
  || 功能描述 ：肺癌病例复核
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_mb_blfh_fa_zt_fh(data_in    IN CLOB, --入参
                                 result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err  VARCHAR2(2000);
    v_id   zjjk_mb_zlfh.id%TYPE; --ID
    v_fhzt zjjk_mb_zlfh.fhzt%TYPE; --ID
    v_fhyj zjjk_mb_zlfh.fhyj%TYPE; --复核意见
  
    --公共变量
    v_sysdate date;
    v_czyjgjb varchar2(3);
    v_czyjgdm varchar2(50);
    v_czyyhid varchar2(50);
    v_czyyhxm varchar2(50);
    v_count   number;
  
  BEGIN
    json_data(data_in, '肺癌病例复核', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid');
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    v_czyyhxm := Json_Str(v_Json_Data, 'czyyhxm');
  
    v_id   := Json_Str(v_Json_Data, 'id');
    v_fhzt := Json_Str(v_Json_Data, 'fhzt');
    v_fhyj := Json_Str(v_Json_Data, 'fhyj');
    if v_id is null then
      v_err := 'id不能为空!';
      raise err_custom;
    end if;
    if nvl(v_fhzt, '-1') not in ('3', '4') then
      v_err := '复核状态传入有误!';
      raise err_custom;
    end if;
    --更新状态
    update zjjk_mb_zlfh a
       set a.fhzt    = v_fhzt,
           a.fhczrid = v_czyyhid,
           a.fhczrxm = v_czyyhxm,
           a.fhjgid  = v_czyjgdm,
           a.fhsj    = v_sysdate,
           a.fhyj    = v_fhyj
     where a.fhzt = '2'
       and a.id = v_id
       and a.mblx = '4'
       and a.ccbz = '401'
       and a.zt = '1';
    if sql%rowcount <> 1 then
      v_err := '更新病例复核状态出错!';
      raise err_custom;
    end if;
    update zjjk_mb_zlfh_fa a set a.fhzt = v_fhzt where a.id = v_id;
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_mb_blfh_fa_zt_fh;
  /*-----------------------------------------------------------------------------
  || 功能描述 ：肺癌病例审核
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_mb_blfh_fa_zt_sh(data_in    IN CLOB, --入参
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
    v_sysdate date;
    v_czyjgjb varchar2(3);
    v_czyjgdm varchar2(50);
    v_czyyhid varchar2(50);
    v_czyyhxm varchar2(50);
    v_count   number;
  
  BEGIN
    json_data(data_in, '肺癌病例审核', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid');
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    v_czyyhxm := Json_Str(v_Json_Data, 'czyyhxm');
  
    v_id   := Json_Str(v_Json_Data, 'id');
    v_shzt := Json_Str(v_Json_Data, 'fhzt');
    v_shyj := Json_Str(v_Json_Data, 'shyj');
    if v_id is null then
      v_err := 'id不能为空!';
      raise err_custom;
    end if;
    if nvl(v_shzt, '-1') not in ('5', '6') then
      v_err := '审核状态传入有误!';
      raise err_custom;
    end if;
    --更新状态
    update zjjk_mb_zlfh a
       set a.fhzt    = v_shzt,
           a.shczrid = v_czyyhid,
           a.shczrxm = v_czyyhxm,
           a.shjgid  = v_czyjgdm,
           a.shsj    = v_sysdate,
           a.shyj    = v_shyj
     where a.fhzt = '3'
       and a.id = v_id
       and a.mblx = '4'
       and a.ccbz = '401'
       and a.zt = '1';
    if sql%rowcount <> 1 then
      v_err := '更新病例审核状态出错!';
      raise err_custom;
    end if;
    update zjjk_mb_zlfh_fa a set a.fhzt = v_shzt where a.id = v_id;
  
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_mb_blfh_fa_zt_sh;
  /*-----------------------------------------------------------------------------
  || 功能描述 ：肝癌病例填报
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_mb_blfh_ga_update(data_in    IN CLOB, --入参
                                  result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
  
    --公共变量
    v_sysdate date;
    v_czyjgjb varchar2(3);
    v_czyjgdm varchar2(50);
    v_czyyhid varchar2(50);
    v_czyyhxm varchar2(50);
    v_count   number;
  
    v_id             zjjk_mb_zlfh_ga.id%TYPE; --ID
    v_bkdw           zjjk_mb_zlfh_ga.bkdw%TYPE; --报卡单位
    v_zyh            zjjk_mb_zlfh_ga.zyh%TYPE; --住院号
    v_jbxxybgksfyz   zjjk_mb_zlfh_ga.jbxxybgksfyz%TYPE; --基本信息与报告卡是否一致（0 是 1否）
    v_kpzt           zjjk_mb_zlfh_ga.kpzt%TYPE; --卡片状态
    v_blh            zjjk_mb_zlfh_ga.blh%TYPE; --病理号
    v_bgkbm          zjjk_mb_zlfh_ga.bgkbm%TYPE; --报告卡编码
    v_xm             zjjk_mb_zlfh_ga.xm%TYPE; --姓名
    v_xmxg           zjjk_mb_zlfh_ga.xmxg%TYPE; --姓名修改
    v_xb             zjjk_mb_zlfh_ga.xb%TYPE; --性别
    v_xbxg           zjjk_mb_zlfh_ga.xbxg%TYPE; --性别修改
    v_csrq           zjjk_mb_zlfh_ga.csrq%TYPE; --出生日期
    v_csrqxg         zjjk_mb_zlfh_ga.csrqxg%TYPE; --出生日期修改
    v_sfzh           zjjk_mb_zlfh_ga.sfzh%TYPE; --身份证号
    v_sfzhxg         zjjk_mb_zlfh_ga.sfzhxg%TYPE; --身份证号修改
    v_zdrq           zjjk_mb_zlfh_ga.zdrq%TYPE; --诊断日期（发病日期）
    v_zdrqxg         zjjk_mb_zlfh_ga.zdrqxg%TYPE; --诊断日期修改
    v_icd10          zjjk_mb_zlfh_ga.icd10%TYPE; --ICD-10
    v_icd10xg        zjjk_mb_zlfh_ga.icd10xg%TYPE; --ICD-10修改
    v_bgyysfwzdyy    zjjk_mb_zlfh_ga.bgyysfwzdyy%TYPE; --报告医院是否为诊断医院（0 是 1否）
    v_zdyymc         zjjk_mb_zlfh_ga.zdyymc%TYPE; --诊断医院名称
    v_czbajldjttj    zjjk_mb_zlfh_ga.czbajldjttj%TYPE; --查找病案记录的具体途径（0 电子住院记录系统 1 电子以及纸质住院记录名单 2 纸质住院名单 3 其他）
    v_qtczbajldtj    zjjk_mb_zlfh_ga.qtczbajldtj%TYPE; --其他查找病案记录的途径
    v_sfczbdcxgbazl  zjjk_mb_zlfh_ga.sfczbdcxgbazl%TYPE; --是否查找并调出该对象住院诊治的相关病案资料（0 是 1否）
    v_bajlsfdzh      zjjk_mb_zlfh_ga.bajlsfdzh%TYPE; --病案记录是否电子化（0 是 1否）
    v_dzbasjnr       zjjk_mb_zlfh_ga.dzbasjnr%TYPE; --电子病案涉及内容（0 所有病案信息 1 只有病案首页）
    v_wczbdcxgbazlyy zjjk_mb_zlfh_ga.wczbdcxgbazlyy%TYPE; --未查找并调出该对象住院诊治的相关病案资料的可能原因（0 未在住院记录系统中找到相关资料 1 住院病案系统有记录但病案丢失 2 住院病案系统有记录但病案未保存 3 其他）
    v_qtknyy         zjjk_mb_zlfh_ga.qtknyy%TYPE; --其他可能原因
    v_sfcjbasy       zjjk_mb_zlfh_ga.sfcjbasy%TYPE; --是否采集（复印或拍照）医院病案首页（0 是 1否）
    v_sfcjcyxj       zjjk_mb_zlfh_ga.sfcjcyxj%TYPE; --是否采集（复印或拍照）医院出院小结/死亡记录（0 是 1否）
    v_sfcjryjl       zjjk_mb_zlfh_ga.sfcjryjl%TYPE; --是否采集（复印或拍照）医院入院记录（首次病程）（0 是 1否）
    v_sfcjgcchjblbg  zjjk_mb_zlfh_ga.sfcjgcchjblbg%TYPE; --是否采集（复印或拍照）肝穿刺活检病理报告（0 是 1否）
    v_sfcjjtdbdxzdbg zjjk_mb_zlfh_ga.sfcjjtdbdxzdbg%TYPE; --是否采集（复印或拍照）甲胎蛋白（AFP）定性诊断报告（1型）（0 是 1否）
    v_sfcjctjcbg     zjjk_mb_zlfh_ga.sfcjctjcbg%TYPE; --是否采集（复印或拍照）CT检查报告（0 是 1否）
    v_sfcjmrijcbg    zjjk_mb_zlfh_ga.sfcjmrijcbg%TYPE; --是否采集（复印或拍照）MRI检查报告（0 是 1否）
    v_sfcjbcjcbg     zjjk_mb_zlfh_ga.sfcjbcjcbg%TYPE; --是否采集（复印或拍照）B超检查报告（0 是 1否）
    v_zyzd           zjjk_mb_zlfh_ga.zyzd%TYPE; --主要诊断
    v_cyhqtzd        zjjk_mb_zlfh_ga.cyhqtzd%TYPE; --次要或其他诊断
    v_chzt           zjjk_mb_zlfh_ga.chzt%TYPE; --存活状态（0存活 1死亡）
    v_wlcdqtjcbg     zjjk_mb_zlfh_ga.wlcdqtjcbg%TYPE; --注明其他采集到上面未列出的检测报告
    v_blcjzqz        zjjk_mb_zlfh_ga.blcjzqz%TYPE; --病例采集者签字
    v_bacjzdw        zjjk_mb_zlfh_ga.bacjzdw%TYPE; --病案采集者单位
    v_fhbgrq         zjjk_mb_zlfh_ga.fhbgrq%TYPE; --复核报告日期
    v_zdyj           zjjk_mb_zlfh_ga.zdyj%TYPE; --诊断依据
    v_zdyjxg         zjjk_mb_zlfh_ga.zdyjxg%TYPE; --诊断依据修改
    v_fhjgpd         zjjk_mb_zlfh_ga.fhjgpd%TYPE; --复核结果判断（0 符合 1不符合）
    v_zlwzx          zjjk_mb_zlfh_ga.zlwzx%TYPE; --资料完整性（0 符合 1不符合）
    v_fhzt           zjjk_mb_zlfh_ga.fhzt%TYPE; --复核状态（0 符合 1不符合）
    v_blxlx          zjjk_mb_zlfh_ga.blxlx%TYPE; --病理学类型
    v_blxlxxg        zjjk_mb_zlfh_ga.blxlxxg%TYPE; --病理学类型修改
    v_basyzp         zjjk_mb_zlfh_ga.basyzp%TYPE;    --（复印或拍照）医院病案首页照片
    v_cyxjzp         zjjk_mb_zlfh_ga.cyxjzp%TYPE;    --（复印或拍照）医院出院小结/死亡记录照片
    v_ryjlzp         zjjk_mb_zlfh_ga.ryjlzp%TYPE;    --（复印或拍照）医院入院记录（首次病程）照片
    v_gcchjblbgzp    zjjk_mb_zlfh_ga.gcchjblbgzp%TYPE;    --（复印或拍照）肝穿刺活检病理报告照片
    v_jtdbdxzdbgzp   zjjk_mb_zlfh_ga.jtdbdxzdbgzp%TYPE;    --（复印或拍照）甲胎蛋白（AFP）定性诊断报告（1型）照片
    v_ctjcbgzp       zjjk_mb_zlfh_ga.ctjcbgzp%TYPE;    --（复印或拍照）CT检查报告照片
    v_mrijcbgzp      zjjk_mb_zlfh_ga.mrijcbgzp%TYPE;    --（复印或拍照）MRI检查报告照片
    v_bcjcbgzp       zjjk_mb_zlfh_ga.bcjcbgzp%TYPE;    --（复印或拍照）B超检查报告照片
    v_icdo3bm        zjjk_mb_zlfh_ga.icdo3bm%TYPE;    -- ICD-O-3编码
    v_icdo3bmxg      zjjk_mb_zlfh_ga.icdo3bmxg%TYPE;    -- ICD-O-3编码修改
  
    --其他变量
    v_bgkid_s VARCHAR2(2000); --被抽查的报告卡IDs
  
  BEGIN
    json_data(data_in, '肝癌报告卡病例填报', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid');
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    v_czyyhxm := Json_Str(v_Json_Data, 'czyyhxm');
  
    v_id             := Json_Str(v_Json_Data, 'id');
    v_bkdw           := Json_Str(v_Json_Data, 'bkdw');
    v_zyh            := Json_Str(v_Json_Data, 'zyh');
    v_jbxxybgksfyz   := Json_Str(v_Json_Data, 'jbxxybgksfyz');
    v_kpzt           := Json_Str(v_Json_Data, 'kpzt');
    v_blh            := Json_Str(v_Json_Data, 'blh');
    v_bgkbm          := Json_Str(v_Json_Data, 'bgkbm');
    v_xm             := Json_Str(v_Json_Data, 'xm');
    v_xmxg           := Json_Str(v_Json_Data, 'xmxg');
    v_xb             := Json_Str(v_Json_Data, 'xb');
    v_xbxg           := Json_Str(v_Json_Data, 'xbxg');
    v_csrq           := std(Json_Str(v_Json_Data, 'csrq'), 0);
    v_csrqxg         := Json_Str(v_Json_Data, 'csrqxg');
    v_sfzh           := Json_Str(v_Json_Data, 'sfzh');
    v_sfzhxg         := Json_Str(v_Json_Data, 'sfzhxg');
    v_zdrq           := std(Json_Str(v_Json_Data, 'zdrq'), 0);
    v_zdrqxg         := Json_Str(v_Json_Data, 'zdrqxg');
    v_icd10          := Json_Str(v_Json_Data, 'icd10');
    v_icd10xg        := Json_Str(v_Json_Data, 'icd10xg');
    v_bgyysfwzdyy    := Json_Str(v_Json_Data, 'bgyysfwzdyy');
    v_zdyymc         := Json_Str(v_Json_Data, 'zdyymc');
    v_czbajldjttj    := Json_Str(v_Json_Data, 'czbajldjttj');
    v_qtczbajldtj    := Json_Str(v_Json_Data, 'qtczbajldtj');
    v_sfczbdcxgbazl  := Json_Str(v_Json_Data, 'sfczbdcxgbazl');
    v_bajlsfdzh      := Json_Str(v_Json_Data, 'bajlsfdzh');
    v_dzbasjnr       := Json_Str(v_Json_Data, 'dzbasjnr');
    v_wczbdcxgbazlyy := Json_Str(v_Json_Data, 'wczbdcxgbazlyy');
    v_qtknyy         := Json_Str(v_Json_Data, 'qtknyy');
    v_sfcjbasy       := Json_Str(v_Json_Data, 'sfcjbasy');
    v_sfcjcyxj       := Json_Str(v_Json_Data, 'sfcjcyxj');
    v_sfcjryjl       := Json_Str(v_Json_Data, 'sfcjryjl');
    v_sfcjgcchjblbg  := Json_Str(v_Json_Data, 'sfcjgcchjblbg');
    v_sfcjjtdbdxzdbg := Json_Str(v_Json_Data, 'sfcjjtdbdxzdbg');
    v_sfcjctjcbg     := Json_Str(v_Json_Data, 'sfcjctjcbg');
    v_sfcjmrijcbg    := Json_Str(v_Json_Data, 'sfcjmrijcbg');
    v_sfcjbcjcbg     := Json_Str(v_Json_Data, 'sfcjbcjcbg');
    v_zyzd           := Json_Str(v_Json_Data, 'zyzd');
    v_cyhqtzd        := Json_Str(v_Json_Data, 'cyhqtzd');
    v_chzt           := Json_Str(v_Json_Data, 'chzt');
    v_wlcdqtjcbg     := Json_Str(v_Json_Data, 'wlcdqtjcbg');
    v_blcjzqz        := Json_Str(v_Json_Data, 'blcjzqz');
    v_bacjzdw        := Json_Str(v_Json_Data, 'bacjzdw');
    v_fhbgrq         := std(Json_Str(v_Json_Data, 'fhbgrq'), 0);
    v_zdyj           := Json_Str(v_Json_Data, 'zdyj');
    v_zdyjxg         := Json_Str(v_Json_Data, 'zdyjxg');
    v_fhjgpd         := Json_Str(v_Json_Data, 'fhjgpd');
    v_blxlx          := Json_Str(v_Json_Data, 'blxlx');
    v_blxlxxg        := Json_Str(v_Json_Data, 'blxlxxg');
    v_zlwzx          := Json_Str(v_Json_Data, 'zlwzx');
    v_basyzp         := Json_Str(v_Json_Data, 'basyzp');
    v_cyxjzp         := Json_Str(v_Json_Data, 'cyxjzp');
    v_ryjlzp         := Json_Str(v_Json_Data, 'ryjlzp');
    v_gcchjblbgzp    := Json_Str(v_Json_Data, 'gcchjblbgzp');
    v_jtdbdxzdbgzp   := Json_Str(v_Json_Data, 'jtdbdxzdbgzp');
    v_ctjcbgzp       := Json_Str(v_Json_Data, 'ctjcbgzp');
    v_mrijcbgzp      := Json_Str(v_Json_Data, 'mrijcbgzp');
    v_bcjcbgzp       := Json_Str(v_Json_Data, 'bcjcbgzp'); 
    v_icdo3bm        := Json_Str(v_Json_Data, 'icdo3bm');
    v_icdo3bmxg      := Json_Str(v_Json_Data, 'icdo3bmxg');    
    
    --校验权限
    if v_czyjgjb <> '3' then
      --非区县
      v_err := '当前机构无病例填报权限!';
      raise err_custom;
    end if;
  
    --校验状态
    select count(1)
      into v_count
      from zjjk_mb_zlfh a, zjjk_zlfhsj b
     where a.cctjid = b.jlbh
       and b.zt = '1'
       and a.id = v_id
       and a.mblx = '4'
       and a.ccbz = '402'
       and a.zt = '1'
       and nvl(a.fhzt, '0') in ('0', '1', '6');
    if v_count <> 1 then
      v_err := '未找到待填报的病例!';
      raise err_custom;
    end if;
  
    --校验必填项目
    if v_id is null then
      v_err := '报告卡ID不能为空!';
      raise err_custom;
    end if;
    if v_bkdw is null then
      v_err := '报卡单位不能为空!';
      raise err_custom;
    end if;
    if v_jbxxybgksfyz is null then
      v_err := '个人信息判断不能为空!';
      raise err_custom;
    end if;
    if v_kpzt is null then
      v_err := '卡片状态不能为空!';
      raise err_custom;
    end if;
    if v_bgkbm is null then
      v_err := '报告卡编码不能为空!';
      raise err_custom;
    end if;
    if v_xm is null then
      v_err := '姓名不能为空!';
      raise err_custom;
    end if;
    if v_xb is null then
      v_err := '性别不能为空!';
      raise err_custom;
    end if;
    if v_csrq is null then
      v_err := '出生日期不能为空!';
      raise err_custom;
    end if;
    if v_sfzh is null then
      --v_err := '身份证号不能为空!';
      --raise err_custom;
      --如果没有身份证号，则设为否
      v_sfzh:='无';
    end if;
    if v_zdrq is null then
      v_err := '诊断日期（发病日期）不能为空!';
      raise err_custom;
    end if;
    if v_icd10 is null then
      v_err := 'ICD-10不能为空!';
      raise err_custom;
    end if;
    if v_czbajldjttj is null then
      v_err := '查找病案记录的具体途径不能为空!';
      raise err_custom;
    end if;
    if v_qtczbajldtj is null and v_czbajldjttj = '3' then
      v_err := '其他查找病案记录的途径不能为空!';
      raise err_custom;
    end if;
    if v_sfczbdcxgbazl is null then
      v_err := '是否查找并调出该对象住院诊治的相关病案资料不能为空!';
      raise err_custom;
    end if;
    if v_bajlsfdzh is null and v_sfczbdcxgbazl = '0' then
      v_err := '病案记录是否电子化不能为空!';
      raise err_custom;
    end if;
    if v_dzbasjnr is null and v_bajlsfdzh = '0' then
      v_err := '电子病案涉及内容不能为空!';
      raise err_custom;
    end if;
    if v_wczbdcxgbazlyy is null and v_sfczbdcxgbazl = '1' then
      v_err := '未查找并调出该对象住院诊治的相关病案资料的可能原因不能为空!';
      raise err_custom;
    end if;
    if v_qtknyy is null and v_wczbdcxgbazlyy = '3' then
      v_err := '其他可能的原因不能为空!';
      raise err_custom;
    end if;
    if v_sfczbdcxgbazl = '0' then
      if v_sfcjbasy is null then
        v_err := '是否采集（复印或拍照）医院病案首页不能为空!';
        raise err_custom;
      end if;
      if v_sfcjcyxj is null then
        v_err := '是否采集（复印或拍照）医院出院小结/死亡记录不能为空!';
        raise err_custom;
      end if;
      if v_sfcjryjl is null then
        v_err := '是否采集（复印或拍照）医院入院记录（首次病程）不能为空!';
        raise err_custom;
      end if;
    
      if v_sfcjgcchjblbg is null then
        v_err := '是否采集（复印或拍照）肝穿刺活检病理报告不能为空!';
        raise err_custom;
      end if;
      if v_sfcjjtdbdxzdbg is null then
        v_err := '是否采集（复印或拍照）甲胎蛋白（AFP）定性诊断报告不能为空!';
        raise err_custom;
      end if;
      if v_sfcjctjcbg is null then
        v_err := '是否采集（复印或拍照）CT检查报告不能为空!';
        raise err_custom;
      end if;
    
      if v_sfcjmrijcbg is null then
        v_err := '是否采集（复印或拍照）MRI检查报告不能为空!';
        raise err_custom;
      end if;
      if v_sfcjbcjcbg is null then
        v_err := '是否采集（复印或拍照）B超检查报告不能为空!';
        raise err_custom;
      end if;
      --if v_blxlx is null then
      --  v_err := '病理学类型不能为空!';
      --  raise err_custom;
      --end if;
      if v_zyzd is null then
        v_err := '主要诊断不能为空!';
        raise err_custom;
      end if;
      if v_chzt is null then
        v_err := '存活状态不能为空!';
        raise err_custom;
      end if;
      if v_blcjzqz is null then
        v_err := '病例采集者签字不能为空!';
        raise err_custom;
      end if;
      if v_bacjzdw is null then
        v_err := '病案采集者单位不能为空!';
        raise err_custom;
      end if;
      if v_fhbgrq is null then
        v_err := '复核报告日期不能为空!';
        raise err_custom;
      end if;
    end if;
    if v_zdyj is null then
      v_err := '诊断依据不能为空!';
      raise err_custom;
    end if;
    if v_zlwzx is null then
      v_err := '病案结果判断不能为空!';
      raise err_custom;
    end if;
  
    --更新资料完整性
    --基本信息判断验证
    if ((v_xmxg IS NULL AND v_xbxg IS NULL AND v_csrqxg IS NULL AND v_sfzhxg IS NULL 
         ) AND v_jbxxybgksfyz='1')
       OR
       ((v_xmxg IS NOT NULL OR v_xbxg IS NOT NULL OR v_csrqxg IS NOT NULL OR v_sfzhxg IS NOT NULL 
         ) AND v_jbxxybgksfyz='0') then
       v_err := '个人信息判断验证不通过!';
      raise err_custom;
    end if;
    
    --病案结果判断验证
    if ((nvl(v_sfcjbasy, '1') <> '0' or nvl(v_sfcjcyxj, '1') <> '0' or
       nvl(v_sfcjryjl, '1') <> '0' or nvl(v_sfcjgcchjblbg, '1') <> '0' or
       nvl(v_sfcjjtdbdxzdbg, '1') <> '0' or nvl(v_sfcjctjcbg, '1') <> '0' or
       nvl(v_sfcjmrijcbg, '1') <> '0' or nvl(v_sfcjbcjcbg, '1') <> '0') AND v_zlwzx='0')
       OR
       ((nvl(v_sfcjbasy, '1') = '0' AND nvl(v_sfcjcyxj, '1') = '0' AND
       nvl(v_sfcjryjl, '1') = '0' AND nvl(v_sfcjgcchjblbg, '1') = '0' AND
       nvl(v_sfcjjtdbdxzdbg, '1') = '0' AND nvl(v_sfcjctjcbg, '1') = '0' AND
       nvl(v_sfcjmrijcbg, '1') = '0' AND nvl(v_sfcjbcjcbg, '1') = '0') AND v_zlwzx='1') then
       v_err := '病案结果判断验证不通过!';
      raise err_custom;
    end if;
    
    --综合结果判断验证
    if (v_jbxxybgksfyz = '0' AND v_zlwzx ='0' AND v_fhjgpd='1')
       OR
       ((v_jbxxybgksfyz = '1' OR v_zlwzx ='1') AND v_fhjgpd='0') then
       v_err := '结果判断验证不通过!';
      raise err_custom;
    end if;
    
    --判断新增还是修改
    select count(1) into v_count from zjjk_mb_zlfh_ga a where a.id = v_id;
    if v_count > 0 then
      --修改
      UPDATE zjjk_mb_zlfh_ga
         SET bkdw           = v_bkdw,
             zyh            = v_zyh,
             jbxxybgksfyz   = v_jbxxybgksfyz,
             kpzt           = v_kpzt,
             blh            = v_blh,
             bgkbm          = v_bgkbm,
             xm             = v_xm,
             xmxg           = v_xmxg,
             xb             = v_xb,
             xbxg           = v_xbxg,
             csrq           = v_csrq,
             csrqxg         = v_csrqxg,
             sfzh           = v_sfzh,
             sfzhxg         = v_sfzhxg,
             zdrq           = v_zdrq,
             zdrqxg         = v_zdrqxg,
             icd10          = v_icd10,
             icd10xg        = v_icd10xg,
             bgyysfwzdyy    = v_bgyysfwzdyy,
             zdyymc         = v_zdyymc,
             czbajldjttj    = v_czbajldjttj,
             qtczbajldtj    = v_qtczbajldtj,
             sfczbdcxgbazl  = v_sfczbdcxgbazl,
             bajlsfdzh      = v_bajlsfdzh,
             dzbasjnr       = v_dzbasjnr,
             wczbdcxgbazlyy = v_wczbdcxgbazlyy,
             qtknyy         = v_qtknyy,
             sfcjbasy       = v_sfcjbasy,
             sfcjcyxj       = v_sfcjcyxj,
             sfcjryjl       = v_sfcjryjl,
             sfcjgcchjblbg  = v_sfcjgcchjblbg,
             sfcjjtdbdxzdbg = v_sfcjjtdbdxzdbg,
             sfcjctjcbg     = v_sfcjctjcbg,
             sfcjmrijcbg    = v_sfcjmrijcbg,
             sfcjbcjcbg     = v_sfcjbcjcbg,
             zyzd           = v_zyzd,
             cyhqtzd        = v_cyhqtzd,
             chzt           = v_chzt,
             wlcdqtjcbg     = v_wlcdqtjcbg,
             blcjzqz        = v_blcjzqz,
             bacjzdw        = v_bacjzdw,
             fhbgrq         = v_fhbgrq,
             zdyj           = v_zdyj,
             zdyjxg         = v_zdyjxg,
             fhjgpd         = v_fhjgpd,
             zlwzx          = v_zlwzx,
             xgrid          = v_czyyhid,
             xgrxm          = v_czyyhxm,
             xgsj           = v_sysdate,
             blxlx          = v_blxlx,
             blxlxxg        = v_blxlxxg,
             fhzt           = '1',
             basyzp         = v_basyzp,
             cyxjzp         = v_cyxjzp,
             ryjlzp         = v_ryjlzp,
             gcchjblbgzp    = v_gcchjblbgzp,
             jtdbdxzdbgzp   = v_jtdbdxzdbgzp,
             ctjcbgzp       = v_ctjcbgzp,
             mrijcbgzp      = v_mrijcbgzp,
             icdo3bm        = v_icdo3bm,
             icdo3bmxg     = v_icdo3bmxg,             
             bcjcbgzp       = v_bcjcbgzp
       WHERE id = v_id;
    else
      --新增
      INSERT INTO zjjk_mb_zlfh_ga
        (id,
         bkdw,
         zyh,
         jbxxybgksfyz,
         kpzt,
         blh,
         bgkbm,
         xm,
         xmxg,
         xb,
         xbxg,
         csrq,
         csrqxg,
         sfzh,
         sfzhxg,
         zdrq,
         zdrqxg,
         icd10,
         icd10xg,
         bgyysfwzdyy,
         zdyymc,
         czbajldjttj,
         qtczbajldtj,
         sfczbdcxgbazl,
         bajlsfdzh,
         dzbasjnr,
         wczbdcxgbazlyy,
         qtknyy,
         sfcjbasy,
         sfcjcyxj,
         sfcjryjl,
         sfcjgcchjblbg,
         sfcjjtdbdxzdbg,
         sfcjctjcbg,
         sfcjmrijcbg,
         sfcjbcjcbg,
         zyzd,
         cyhqtzd,
         chzt,
         wlcdqtjcbg,
         blcjzqz,
         bacjzdw,
         fhbgrq,
         zdyj,
         zdyjxg,
         fhjgpd,
         zlwzx,
         fhzt,
         cjrid,
         cjrxm,
         cjsj,
         xgrid,
         xgrxm,
         xgsj,
         blxlx,
         blxlxxg,
         basyzp,
         cyxjzp,
         ryjlzp,
         gcchjblbgzp,
         jtdbdxzdbgzp,
         ctjcbgzp,
         mrijcbgzp,
         icdo3bm,
         icdo3bmxg,         
         bcjcbgzp)
      VALUES
        (v_id,
         v_bkdw,
         v_zyh,
         v_jbxxybgksfyz,
         v_kpzt,
         v_blh,
         v_bgkbm,
         v_xm,
         v_xmxg,
         v_xb,
         v_xbxg,
         v_csrq,
         v_csrqxg,
         v_sfzh,
         v_sfzhxg,
         v_zdrq,
         v_zdrqxg,
         v_icd10,
         v_icd10xg,
         v_bgyysfwzdyy,
         v_zdyymc,
         v_czbajldjttj,
         v_qtczbajldtj,
         v_sfczbdcxgbazl,
         v_bajlsfdzh,
         v_dzbasjnr,
         v_wczbdcxgbazlyy,
         v_qtknyy,
         v_sfcjbasy,
         v_sfcjcyxj,
         v_sfcjryjl,
         v_sfcjgcchjblbg,
         v_sfcjjtdbdxzdbg,
         v_sfcjctjcbg,
         v_sfcjmrijcbg,
         v_sfcjbcjcbg,
         v_zyzd,
         v_cyhqtzd,
         v_chzt,
         v_wlcdqtjcbg,
         v_blcjzqz,
         v_bacjzdw,
         v_fhbgrq,
         v_zdyj,
         v_zdyjxg,
         v_fhjgpd,
         v_zlwzx,
         '1',
         v_czyyhid,
         v_czyyhxm,
         v_sysdate,
         v_czyyhid,
         v_czyyhxm,
         v_sysdate,
         v_blxlx,
         v_blxlxxg,
         v_basyzp,
         v_cyxjzp,
         v_ryjlzp,
         v_gcchjblbgzp,
         v_jtdbdxzdbgzp,
         v_ctjcbgzp,
         v_mrijcbgzp,
         v_icdo3bm,
         v_icdo3bmxg,        
         v_bcjcbgzp);
    
    end if;
    --更新复核状态
    update zjjk_mb_zlfh a
       set a.fhzt = '1', a.fhbz = '1'
     where a.id = v_id
       and a.mblx = '4'
       and a.ccbz = '402';
    --返回
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_mb_blfh_ga_update;
  /*-----------------------------------------------------------------------------
  || 功能描述 ：肝癌病例提交
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_mb_blfh_ga_zt_tj(data_in    IN CLOB, --入参
                                 result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
  
    v_id zjjk_mb_zlfh.id%TYPE; --ID
    --公共变量
    v_sysdate date;
    v_czyjgjb varchar2(3);
    v_czyjgdm varchar2(50);
    v_czyyhid varchar2(50);
    v_czyyhxm varchar2(50);
    v_count   number;
  
  BEGIN
    json_data(data_in, '肝癌病例提交', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid');
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    v_czyyhxm := Json_Str(v_Json_Data, 'czyyhxm');
  
    v_id := Json_Str(v_Json_Data, 'id');
    if v_id is null then
      v_err := 'id不能为空!';
      raise err_custom;
    end if;
    --更新状态
    update zjjk_mb_zlfh a
       set a.fhzt = '3',
           a.fhczrid = v_czyyhid,
           a.fhczrxm = v_czyyhxm,
           a.fhjgid  = v_czyjgdm,
           a.fhsj    = v_sysdate
     where a.fhzt = '1'
       and a.id = v_id
       and a.mblx = '4'
       and a.ccbz = '402'
       and a.zt = '1';
    if sql%rowcount <> 1 then
      v_err := '更新病例状态出错!';
      raise err_custom;
    end if;
    update zjjk_mb_zlfh_ga a set a.fhzt = '3' where a.id = v_id;
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_mb_blfh_ga_zt_tj;
  /*-----------------------------------------------------------------------------
  || 功能描述 ：肝癌病例复核
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_mb_blfh_ga_zt_fh(data_in    IN CLOB, --入参
                                 result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err  VARCHAR2(2000);
    v_id   zjjk_mb_zlfh.id%TYPE; --ID
    v_fhzt zjjk_mb_zlfh.fhzt%TYPE; --ID
    v_fhyj zjjk_mb_zlfh.fhyj%TYPE; --复核意见
  
    --公共变量
    v_sysdate date;
    v_czyjgjb varchar2(3);
    v_czyjgdm varchar2(50);
    v_czyyhid varchar2(50);
    v_czyyhxm varchar2(50);
    v_count   number;
  
  BEGIN
    json_data(data_in, '肝癌病例复核', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid');
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    v_czyyhxm := Json_Str(v_Json_Data, 'czyyhxm');
  
    v_id   := Json_Str(v_Json_Data, 'id');
    v_fhzt := Json_Str(v_Json_Data, 'fhzt');
    v_fhyj := Json_Str(v_Json_Data, 'fhyj');
    if v_id is null then
      v_err := 'id不能为空!';
      raise err_custom;
    end if;
    if nvl(v_fhzt, '-1') not in ('3', '4') then
      v_err := '复核状态传入有误!';
      raise err_custom;
    end if;
    --更新状态
    update zjjk_mb_zlfh a
       set a.fhzt    = v_fhzt,
           a.fhczrid = v_czyyhid,
           a.fhczrxm = v_czyyhxm,
           a.fhjgid  = v_czyjgdm,
           a.fhsj    = v_sysdate,
           a.fhyj    = v_fhyj
     where a.fhzt = '2'
       and a.id = v_id
       and a.mblx = '4'
       and a.ccbz = '402'
       and a.zt = '1';
    if sql%rowcount <> 1 then
      v_err := '更新病例复核状态出错!';
      raise err_custom;
    end if;
    update zjjk_mb_zlfh_ga a set a.fhzt = v_fhzt where a.id = v_id;
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_mb_blfh_ga_zt_fh;
  /*-----------------------------------------------------------------------------
  || 功能描述 ：肝癌病例审核
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_mb_blfh_ga_zt_sh(data_in    IN CLOB, --入参
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
    v_sysdate date;
    v_czyjgjb varchar2(3);
    v_czyjgdm varchar2(50);
    v_czyyhid varchar2(50);
    v_czyyhxm varchar2(50);
    v_count   number;
  
  BEGIN
    json_data(data_in, '肝癌病例审核', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid');
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    v_czyyhxm := Json_Str(v_Json_Data, 'czyyhxm');
  
    v_id   := Json_Str(v_Json_Data, 'id');
    v_shzt := Json_Str(v_Json_Data, 'fhzt');
    v_shyj := Json_Str(v_Json_Data, 'shyj');
    if v_id is null then
      v_err := 'id不能为空!';
      raise err_custom;
    end if;
    if nvl(v_shzt, '-1') not in ('5', '6') then
      v_err := '审核状态传入有误!';
      raise err_custom;
    end if;
    --更新状态
    update zjjk_mb_zlfh a
       set a.fhzt    = v_shzt,
           a.shczrid = v_czyyhid,
           a.shczrxm = v_czyyhxm,
           a.shjgid  = v_czyjgdm,
           a.shsj    = v_sysdate,
           a.shyj    = v_shyj
     where a.fhzt = '3'
       and a.id = v_id
       and a.mblx = '4'
       and a.ccbz = '402'
       and a.zt = '1';
    if sql%rowcount <> 1 then
      v_err := '更新病例审核状态出错!';
      raise err_custom;
    end if;
    update zjjk_mb_zlfh_ga a set a.fhzt = v_shzt where a.id = v_id;
  
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_mb_blfh_ga_zt_sh;
  /*-----------------------------------------------------------------------------
  || 功能描述 ：胃癌例填报
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_mb_blfh_wa_update(data_in    IN CLOB, --入参
                                  result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
  
    --公共变量
    v_sysdate date;
    v_czyjgjb varchar2(3);
    v_czyjgdm varchar2(50);
    v_czyyhid varchar2(50);
    v_czyyhxm varchar2(50);
    v_count   number;
  
    v_id                zjjk_mb_zlfh_wa.id%TYPE; --id
    v_bkdw              zjjk_mb_zlfh_wa.bkdw%TYPE; --报卡单位
    v_zyh               zjjk_mb_zlfh_wa.zyh%TYPE; --住院号
    v_jbxxybgksfyz      zjjk_mb_zlfh_wa.jbxxybgksfyz%TYPE; --基本信息与报告卡是否一致（0 是 1否）
    v_kpzt              zjjk_mb_zlfh_wa.kpzt%TYPE; --卡片状态
    v_blh               zjjk_mb_zlfh_wa.blh%TYPE; --病理号
    v_bgkbm             zjjk_mb_zlfh_wa.bgkbm%TYPE; --报告卡编码
    v_xm                zjjk_mb_zlfh_wa.xm%TYPE; --姓名
    v_xmxg              zjjk_mb_zlfh_wa.xmxg%TYPE; --姓名修改
    v_xb                zjjk_mb_zlfh_wa.xb%TYPE; --性别
    v_xbxg              zjjk_mb_zlfh_wa.xbxg%TYPE; --性别修改
    v_csrq              zjjk_mb_zlfh_wa.csrq%TYPE; --出生日期
    v_csrqxg            zjjk_mb_zlfh_wa.csrqxg%TYPE; --出生日期修改
    v_sfzh              zjjk_mb_zlfh_wa.sfzh%TYPE; --身份证号
    v_sfzhxg            zjjk_mb_zlfh_wa.sfzhxg%TYPE; --身份证号修改
    v_zdrq              zjjk_mb_zlfh_wa.zdrq%TYPE; --诊断日期（发病日期）
    v_zdrqxg            zjjk_mb_zlfh_wa.zdrqxg%TYPE; --诊断日期修改
    v_icd10             zjjk_mb_zlfh_wa.icd10%TYPE; --ICD-10
    v_icd10xg           zjjk_mb_zlfh_wa.icd10xg%TYPE; --ICD-10修改
    v_bgyysfwzdyy       zjjk_mb_zlfh_wa.bgyysfwzdyy%TYPE; --报告医院是否为诊断医院（0 是 1否）
    v_zdyymc            zjjk_mb_zlfh_wa.zdyymc%TYPE; --诊断医院名称
    v_czbajldjttj       zjjk_mb_zlfh_wa.czbajldjttj%TYPE; --查找病案记录的具体途径（0 电子住院记录系统 1 电子以及纸质住院记录名单 2 纸质住院名单 3 其他）
    v_qtczbajldtj       zjjk_mb_zlfh_wa.qtczbajldtj%TYPE; --其他查找病案记录的途径
    v_sfczbdcxgbazl     zjjk_mb_zlfh_wa.sfczbdcxgbazl%TYPE; --是否查找并调出该对象住院诊治的相关病案资料（0 是 1否）
    v_bajlsfdzh         zjjk_mb_zlfh_wa.bajlsfdzh%TYPE; --病案记录是否电子化（0 是 1否）
    v_dzbasjnr          zjjk_mb_zlfh_wa.dzbasjnr%TYPE; --电子病案涉及内容（0 所有病案信息 1 只有病案首页）
    v_wczbdcxgbazlyy    zjjk_mb_zlfh_wa.wczbdcxgbazlyy%TYPE; --未查找并调出该对象住院诊治的相关病案资料的可能原因（0 未在住院记录系统中找到相关资料 1 住院病案系统有记录但病案丢失 2 住院病案系统有记录但病案未保存 3 其他）
    v_qtknyy            zjjk_mb_zlfh_wa.qtknyy%TYPE; --其他可能原因
    v_sfcjbasy          zjjk_mb_zlfh_wa.sfcjbasy%TYPE; --是否采集（复印或拍照）医院病案首页（0 是 1否）
    v_sfcjcyxj          zjjk_mb_zlfh_wa.sfcjcyxj%TYPE; --是否采集（复印或拍照）医院出院小结/死亡记录（0 是 1否）
    v_sfcjryjl          zjjk_mb_zlfh_wa.sfcjryjl%TYPE; --是否采集（复印或拍照）医院入院记录（首次病程）（0 是 1否）
    v_sfcjqwwjxnmhjblbg zjjk_mb_zlfh_wa.sfcjqwwjxnmhjblbg%TYPE; --是否采集（复印或拍照）纤维胃镜下粘膜活检病理报告（0 是 1否）
    v_sfcjwxxbcjcbg     zjjk_mb_zlfh_wa.sfcjwxxbcjcbg%TYPE; --是否采集（复印或拍照）胃X线钡餐检查报告（0 是 1否）
    v_sfcjwtlxbxjcbg    zjjk_mb_zlfh_wa.sfcjwtlxbxjcbg%TYPE; --是否采集（复印或拍照）胃脱落细胞学检查报告（0 是 1否）
    v_zyzd              zjjk_mb_zlfh_wa.zyzd%TYPE; --主要诊断
    v_cyhqtzd           zjjk_mb_zlfh_wa.cyhqtzd%TYPE; --次要或其他诊断
    v_chzt              zjjk_mb_zlfh_wa.chzt%TYPE; --存活状态（0存活 1死亡）
    v_wlcdqtjcbg        zjjk_mb_zlfh_wa.wlcdqtjcbg%TYPE; --注明其他采集到上面未列出的检测报告
    v_blcjzqz           zjjk_mb_zlfh_wa.blcjzqz%TYPE; --病例采集者签字
    v_bacjzdw           zjjk_mb_zlfh_wa.bacjzdw%TYPE; --病案采集者单位
    v_fhbgrq            zjjk_mb_zlfh_wa.fhbgrq%TYPE; --复核报告日期
    v_zdyj              zjjk_mb_zlfh_wa.zdyj%TYPE; --诊断依据
    v_zdyjxg            zjjk_mb_zlfh_wa.zdyjxg%TYPE; --诊断依据修改
    v_fhjgpd            zjjk_mb_zlfh_wa.fhjgpd%TYPE; --复核结果判断（0 符合 1不符合）
    v_zlwzx             zjjk_mb_zlfh_wa.zlwzx%TYPE; --资料完整性（0 符合 1不符合）
    v_fhzt              zjjk_mb_zlfh_wa.fhzt%TYPE; --复核状态（0 符合 1不符合）
    v_blxlx             zjjk_mb_zlfh_wa.blxlx%TYPE; --病理学类型
    v_blxlxxg           zjjk_mb_zlfh_wa.blxlxxg%TYPE; --病理学类型修改
    v_basyzp            zjjk_mb_zlfh_wa.basyzp%TYPE;    --（复印或拍照）医院病案首页照片
    v_cyxjzp            zjjk_mb_zlfh_wa.cyxjzp%TYPE;    --（复印或拍照）医院出院小结/死亡记录照片
    v_ryjlzp            zjjk_mb_zlfh_wa.ryjlzp%TYPE;    --（复印或拍照）医院入院记录（首次病程）照片
    v_qwwjxnmhjblbgzp   zjjk_mb_zlfh_wa.qwwjxnmhjblbgzp%TYPE;    --（复印或拍照）纤维胃镜下粘膜活检病理报告照片
    v_wxxbcjcbgzp       zjjk_mb_zlfh_wa.wxxbcjcbgzp%TYPE;    --（复印或拍照）胃X线钡餐检查报告照片
    v_wtlxbxjcbgzp      zjjk_mb_zlfh_wa.wtlxbxjcbgzp%TYPE;    --（复印或拍照）胃脱落细胞学检查报告照片
    v_icdo3bm           zjjk_mb_zlfh_wa.icdo3bm%TYPE;    -- ICD-O-3编码
    v_icdo3bmxg         zjjk_mb_zlfh_wa.icdo3bmxg%TYPE;    -- ICD-O-3编码修改    
      
    --其他变量
    v_bgkid_s VARCHAR2(2000); --被抽查的报告卡IDs
  
  BEGIN
    json_data(data_in, '胃癌报告卡病例填报', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid');
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    v_czyyhxm := Json_Str(v_Json_Data, 'czyyhxm');
  
    v_id                := Json_Str(v_Json_Data, 'id');
    v_bkdw              := Json_Str(v_Json_Data, 'bkdw');
    v_zyh               := Json_Str(v_Json_Data, 'zyh');
    v_jbxxybgksfyz      := Json_Str(v_Json_Data, 'jbxxybgksfyz');
    v_kpzt              := Json_Str(v_Json_Data, 'kpzt');
    v_blh               := Json_Str(v_Json_Data, 'blh');
    v_bgkbm             := Json_Str(v_Json_Data, 'bgkbm');
    v_xm                := Json_Str(v_Json_Data, 'xm');
    v_xmxg              := Json_Str(v_Json_Data, 'xmxg');
    v_xb                := Json_Str(v_Json_Data, 'xb');
    v_xbxg              := Json_Str(v_Json_Data, 'xbxg');
    v_csrq              := std(Json_Str(v_Json_Data, 'csrq'), 0);
    v_csrqxg            := Json_Str(v_Json_Data, 'csrqxg');
    v_sfzh              := Json_Str(v_Json_Data, 'sfzh');
    v_sfzhxg            := Json_Str(v_Json_Data, 'sfzhxg');
    v_zdrq              := std(Json_Str(v_Json_Data, 'zdrq'), 0);
    v_zdrqxg            := Json_Str(v_Json_Data, 'zdrqxg');
    v_icd10             := Json_Str(v_Json_Data, 'icd10');
    v_icd10xg           := Json_Str(v_Json_Data, 'icd10xg');
    v_bgyysfwzdyy       := Json_Str(v_Json_Data, 'bgyysfwzdyy');
    v_zdyymc            := Json_Str(v_Json_Data, 'zdyymc');
    v_czbajldjttj       := Json_Str(v_Json_Data, 'czbajldjttj');
    v_qtczbajldtj       := Json_Str(v_Json_Data, 'qtczbajldtj');
    v_sfczbdcxgbazl     := Json_Str(v_Json_Data, 'sfczbdcxgbazl');
    v_bajlsfdzh         := Json_Str(v_Json_Data, 'bajlsfdzh');
    v_dzbasjnr          := Json_Str(v_Json_Data, 'dzbasjnr');
    v_wczbdcxgbazlyy    := Json_Str(v_Json_Data, 'wczbdcxgbazlyy');
    v_qtknyy            := Json_Str(v_Json_Data, 'qtknyy');
    v_sfcjbasy          := Json_Str(v_Json_Data, 'sfcjbasy');
    v_sfcjcyxj          := Json_Str(v_Json_Data, 'sfcjcyxj');
    v_sfcjryjl          := Json_Str(v_Json_Data, 'sfcjryjl');
    v_sfcjqwwjxnmhjblbg := Json_Str(v_Json_Data, 'sfcjqwwjxnmhjblbg');
    v_sfcjwxxbcjcbg     := Json_Str(v_Json_Data, 'sfcjwxxbcjcbg');
    v_sfcjwtlxbxjcbg    := Json_Str(v_Json_Data, 'sfcjwtlxbxjcbg');
    v_zyzd              := Json_Str(v_Json_Data, 'zyzd');
    v_cyhqtzd           := Json_Str(v_Json_Data, 'cyhqtzd');
    v_chzt              := Json_Str(v_Json_Data, 'chzt');
    v_wlcdqtjcbg        := Json_Str(v_Json_Data, 'wlcdqtjcbg');
    v_blcjzqz           := Json_Str(v_Json_Data, 'blcjzqz');
    v_bacjzdw           := Json_Str(v_Json_Data, 'bacjzdw');
    v_fhbgrq            := std(Json_Str(v_Json_Data, 'fhbgrq'), 0);
    v_zdyj              := Json_Str(v_Json_Data, 'zdyj');
    v_zdyjxg            := Json_Str(v_Json_Data, 'zdyjxg');
    v_fhjgpd            := Json_Str(v_Json_Data, 'fhjgpd');
    v_blxlx             := Json_Str(v_Json_Data, 'blxlx');
    v_blxlxxg           := Json_Str(v_Json_Data, 'blxlxxg');
    v_zlwzx             := Json_Str(v_Json_Data, 'zlwzx');
    v_basyzp            := Json_Str(v_Json_Data, 'basyzp');
    v_cyxjzp            := Json_Str(v_Json_Data, 'cyxjzp');
    v_ryjlzp            := Json_Str(v_Json_Data, 'ryjlzp');
    v_qwwjxnmhjblbgzp   := Json_Str(v_Json_Data, 'qwwjxnmhjblbgzp');
    v_wxxbcjcbgzp       := Json_Str(v_Json_Data, 'wxxbcjcbgzp');
    v_wtlxbxjcbgzp      := Json_Str(v_Json_Data, 'wtlxbxjcbgzp');
    v_icdo3bm           := Json_Str(v_Json_Data, 'icdo3bm');
    v_icdo3bmxg         := Json_Str(v_Json_Data, 'icdo3bmxg');    
    
    --校验权限
    if v_czyjgjb <> '3' then
      --非区县
      v_err := '当前机构无病例填报权限!';
      raise err_custom;
    end if;
  
    --校验状态
    select count(1)
      into v_count
      from zjjk_mb_zlfh a, zjjk_zlfhsj b
     where a.cctjid = b.jlbh
       and b.zt = '1'
       and a.id = v_id
       and a.mblx = '4'
       and a.ccbz = '403'
       and a.zt = '1'
       and nvl(a.fhzt, '0') in ('0', '1', '6');
    if v_count <> 1 then
      v_err := '未找到待填报的病例!';
      raise err_custom;
    end if;
  
    --校验必填项目
    if v_id is null then
      v_err := '报告卡ID不能为空!';
      raise err_custom;
    end if;
    if v_bkdw is null then
      v_err := '报卡单位不能为空!';
      raise err_custom;
    end if;
    if v_jbxxybgksfyz is null then
      v_err := '个人信息判断不能为空!';
      raise err_custom;
    end if;
    if v_kpzt is null then
      v_err := '卡片状态不能为空!';
      raise err_custom;
    end if;
    if v_bgkbm is null then
      v_err := '报告卡编码不能为空!';
      raise err_custom;
    end if;
    if v_xm is null then
      v_err := '姓名不能为空!';
      raise err_custom;
    end if;
    if v_xb is null then
      v_err := '性别不能为空!';
      raise err_custom;
    end if;
    if v_csrq is null then
      v_err := '出生日期不能为空!';
      raise err_custom;
    end if;
    if v_sfzh is null then
      --v_err := '身份证号不能为空!';
      --raise err_custom;
      --如果没有身份证号，则设为否
      v_sfzh:='无';
    end if;
    if v_zdrq is null then
      v_err := '诊断日期（发病日期）不能为空!';
      raise err_custom;
    end if;
    if v_icd10 is null then
      v_err := 'ICD-10不能为空!';
      raise err_custom;
    end if;
    if v_czbajldjttj is null then
      v_err := '查找病案记录的具体途径不能为空!';
      raise err_custom;
    end if;
    if v_qtczbajldtj is null and v_czbajldjttj = '3' then
      v_err := '其他查找病案记录的途径不能为空!';
      raise err_custom;
    end if;
    if v_sfczbdcxgbazl is null then
      v_err := '是否查找并调出该对象住院诊治的相关病案资料不能为空!';
      raise err_custom;
    end if;
    if v_bajlsfdzh is null and v_sfczbdcxgbazl = '0' then
      v_err := '病案记录是否电子化不能为空!';
      raise err_custom;
    end if;
    if v_dzbasjnr is null and v_bajlsfdzh = '0' then
      v_err := '电子病案涉及内容不能为空!';
      raise err_custom;
    end if;
    if v_wczbdcxgbazlyy is null and v_sfczbdcxgbazl = '1' then
      v_err := '未查找并调出该对象住院诊治的相关病案资料的可能原因不能为空!';
      raise err_custom;
    end if;
    if v_qtknyy is null and v_wczbdcxgbazlyy = '3' then
      v_err := '其他可能的原因不能为空!';
      raise err_custom;
    end if;
    if v_sfczbdcxgbazl = '0' then 
      if v_sfcjbasy is null then
        v_err := '是否采集（复印或拍照）医院病案首页不能为空!';
        raise err_custom;
      end if;
      if v_sfcjcyxj is null then
        v_err := '是否采集（复印或拍照）医院出院小结/死亡记录不能为空!';
        raise err_custom;
      end if;
      if v_sfcjryjl is null then
        v_err := '是否采集（复印或拍照）医院入院记录（首次病程）不能为空!';
        raise err_custom;
      end if;
    
      if v_sfcjqwwjxnmhjblbg is null then
        v_err := '是否采集（复印或拍照）纤维胃镜下粘膜活检病理报告不能为空!';
        raise err_custom;
      end if;
      if v_sfcjwxxbcjcbg is null then
        v_err := '是否采集（复印或拍照）胃X线钡餐检查报告不能为空!';
        raise err_custom;
      end if;
      if v_sfcjwtlxbxjcbg is null then
        v_err := '是否采集（复印或拍照）胃脱落细胞学检查报告不能为空!';
        raise err_custom;
      end if;
    
      --if v_blxlx is null then
      --  v_err := '病理学类型不能为空!';
      --  raise err_custom;
      --end if;
      if v_zyzd is null then
        v_err := '主要诊断不能为空!';
        raise err_custom;
      end if;
      if v_chzt is null then
        v_err := '存活状态不能为空!';
        raise err_custom;
      end if;
      if v_blcjzqz is null then
        v_err := '病例采集者签字不能为空!';
        raise err_custom;
      end if;
      if v_bacjzdw is null then
        v_err := '病案采集者单位不能为空!';
        raise err_custom;
      end if;
      if v_fhbgrq is null then
        v_err := '复核报告日期不能为空!';
        raise err_custom;
      end if;
    end if;
    if v_zdyj is null then
      v_err := '诊断依据不能为空!';
      raise err_custom;
    end if;
    if v_zlwzx is null then
      v_err := '病案结果判断不能为空!';
      raise err_custom;
    end if;
  
    --更新资料完整性
    --基本信息判断验证
    if ((v_xmxg IS NULL AND v_xbxg IS NULL AND v_csrqxg IS NULL AND v_sfzhxg IS NULL 
         ) AND v_jbxxybgksfyz='1')
       OR
       ((v_xmxg IS NOT NULL OR v_xbxg IS NOT NULL OR v_csrqxg IS NOT NULL OR v_sfzhxg IS NOT NULL 
         ) AND v_jbxxybgksfyz='0') then
       v_err := '个人信息判断验证不通过!';
      raise err_custom;
    end if;
    
    --病案结果判断验证
    if ((nvl(v_sfcjbasy, '1') <> '0' or nvl(v_sfcjcyxj, '1') <> '0' or
       nvl(v_sfcjryjl, '1') <> '0' or nvl(v_sfcjqwwjxnmhjblbg, '1') <> '0' or
       nvl(v_sfcjwxxbcjcbg, '1') <> '0' or nvl(v_sfcjwtlxbxjcbg, '1') <> '0') AND v_zlwzx='0')
       OR
       ((nvl(v_sfcjbasy, '1') = '0' AND nvl(v_sfcjcyxj, '1') = '0' AND
       nvl(v_sfcjryjl, '1') = '0' AND nvl(v_sfcjqwwjxnmhjblbg, '1') = '0' AND
       nvl(v_sfcjwxxbcjcbg, '1') = '0' AND nvl(v_sfcjwtlxbxjcbg, '1') = '0') AND v_zlwzx='1') then
       v_err := '病案结果判断验证不通过!';
      raise err_custom;
    end if;
    
    --综合结果判断验证
    if (v_jbxxybgksfyz = '0' AND v_zlwzx ='0' AND v_fhjgpd='1')
       OR
       ((v_jbxxybgksfyz = '1' OR v_zlwzx ='1') AND v_fhjgpd='0') then
       v_err := '结果判断验证不通过!';
      raise err_custom;
    end if;
    
    --判断新增还是修改
    select count(1) into v_count from zjjk_mb_zlfh_wa a where a.id = v_id;
    if v_count > 0 then
      --修改
      UPDATE zjjk_mb_zlfh_wa
         SET bkdw              = v_bkdw,
             zyh               = v_zyh,
             jbxxybgksfyz      = v_jbxxybgksfyz,
             kpzt              = v_kpzt,
             blh               = v_blh,
             bgkbm             = v_bgkbm,
             xm                = v_xm,
             xmxg              = v_xmxg,
             xb                = v_xb,
             xbxg              = v_xbxg,
             csrq              = v_csrq,
             csrqxg            = v_csrqxg,
             sfzh              = v_sfzh,
             sfzhxg            = v_sfzhxg,
             zdrq              = v_zdrq,
             zdrqxg            = v_zdrqxg,
             icd10             = v_icd10,
             icd10xg           = v_icd10xg,
             bgyysfwzdyy       = v_bgyysfwzdyy,
             zdyymc            = v_zdyymc,
             czbajldjttj       = v_czbajldjttj,
             qtczbajldtj       = v_qtczbajldtj,
             sfczbdcxgbazl     = v_sfczbdcxgbazl,
             bajlsfdzh         = v_bajlsfdzh,
             dzbasjnr          = v_dzbasjnr,
             wczbdcxgbazlyy    = v_wczbdcxgbazlyy,
             qtknyy            = v_qtknyy,
             sfcjbasy          = v_sfcjbasy,
             sfcjcyxj          = v_sfcjcyxj,
             sfcjryjl          = v_sfcjryjl,
             sfcjqwwjxnmhjblbg = v_sfcjqwwjxnmhjblbg,
             sfcjwxxbcjcbg     = v_sfcjwxxbcjcbg,
             sfcjwtlxbxjcbg    = v_sfcjwtlxbxjcbg,
             zyzd              = v_zyzd,
             cyhqtzd           = v_cyhqtzd,
             chzt              = v_chzt,
             wlcdqtjcbg        = v_wlcdqtjcbg,
             blcjzqz           = v_blcjzqz,
             bacjzdw           = v_bacjzdw,
             fhbgrq            = v_fhbgrq,
             zdyj              = v_zdyj,
             zdyjxg            = v_zdyjxg,
             fhjgpd            = v_fhjgpd,
             zlwzx             = v_zlwzx,
             xgrid             = v_czyyhid,
             xgrxm             = v_czyyhxm,
             xgsj              = v_sysdate,
             blxlx             = v_blxlx,
             blxlxxg           = v_blxlxxg,
             fhzt              = '1',
             basyzp            = v_basyzp,
             cyxjzp            = v_cyxjzp,
             ryjlzp            = v_ryjlzp,
             qwwjxnmhjblbgzp   = v_qwwjxnmhjblbgzp,
             wxxbcjcbgzp       = v_wxxbcjcbgzp,
             icdo3bm        = v_icdo3bm,
             icdo3bmxg     = v_icdo3bmxg,             
             wtlxbxjcbgzp      = v_wtlxbxjcbgzp
       WHERE id = v_id;
    
    else
      --新增
      INSERT INTO zjjk_mb_zlfh_wa
        (id,
         bkdw,
         zyh,
         jbxxybgksfyz,
         kpzt,
         blh,
         bgkbm,
         xm,
         xmxg,
         xb,
         xbxg,
         csrq,
         csrqxg,
         sfzh,
         sfzhxg,
         zdrq,
         zdrqxg,
         icd10,
         icd10xg,
         bgyysfwzdyy,
         zdyymc,
         czbajldjttj,
         qtczbajldtj,
         sfczbdcxgbazl,
         bajlsfdzh,
         dzbasjnr,
         wczbdcxgbazlyy,
         qtknyy,
         sfcjbasy,
         sfcjcyxj,
         sfcjryjl,
         sfcjqwwjxnmhjblbg,
         sfcjwxxbcjcbg,
         sfcjwtlxbxjcbg,
         zyzd,
         cyhqtzd,
         chzt,
         wlcdqtjcbg,
         blcjzqz,
         bacjzdw,
         fhbgrq,
         zdyj,
         zdyjxg,
         fhjgpd,
         zlwzx,
         fhzt,
         cjrid,
         cjrxm,
         cjsj,
         xgrid,
         xgrxm,
         xgsj,
         blxlx,
         blxlxxg,
         basyzp,
         cyxjzp,
         ryjlzp,
         qwwjxnmhjblbgzp,
         wxxbcjcbgzp,
         icdo3bm,
         icdo3bmxg,         
         wtlxbxjcbgzp)
      VALUES
        (v_id,
         v_bkdw,
         v_zyh,
         v_jbxxybgksfyz,
         v_kpzt,
         v_blh,
         v_bgkbm,
         v_xm,
         v_xmxg,
         v_xb,
         v_xbxg,
         v_csrq,
         v_csrqxg,
         v_sfzh,
         v_sfzhxg,
         v_zdrq,
         v_zdrqxg,
         v_icd10,
         v_icd10xg,
         v_bgyysfwzdyy,
         v_zdyymc,
         v_czbajldjttj,
         v_qtczbajldtj,
         v_sfczbdcxgbazl,
         v_bajlsfdzh,
         v_dzbasjnr,
         v_wczbdcxgbazlyy,
         v_qtknyy,
         v_sfcjbasy,
         v_sfcjcyxj,
         v_sfcjryjl,
         v_sfcjqwwjxnmhjblbg,
         v_sfcjwxxbcjcbg,
         v_sfcjwtlxbxjcbg,
         v_zyzd,
         v_cyhqtzd,
         v_chzt,
         v_wlcdqtjcbg,
         v_blcjzqz,
         v_bacjzdw,
         v_fhbgrq,
         v_zdyj,
         v_zdyjxg,
         v_fhjgpd,
         v_zlwzx,
         '1',
         v_czyyhid,
         v_czyyhxm,
         v_sysdate,
         v_czyyhid,
         v_czyyhxm,
         v_sysdate,
         v_blxlx,
         v_blxlxxg,
         v_basyzp,
         v_cyxjzp,
         v_ryjlzp,
         v_qwwjxnmhjblbgzp,
         v_wxxbcjcbgzp,
         v_icdo3bm,
         v_icdo3bmxg,         
         v_wtlxbxjcbgzp);
    
    end if;
    --更新复核状态
    update zjjk_mb_zlfh a
       set a.fhzt = '1', a.fhbz = '1'
     where a.id = v_id
       and a.mblx = '4'
       and a.ccbz = '403';
    --返回
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_mb_blfh_wa_update;
  /*-----------------------------------------------------------------------------
  || 功能描述 ：胃癌病例提交
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_mb_blfh_wa_zt_tj(data_in    IN CLOB, --入参
                                 result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
  
    v_id zjjk_mb_zlfh.id%TYPE; --ID
    --公共变量
    v_sysdate date;
    v_czyjgjb varchar2(3);
    v_czyjgdm varchar2(50);
    v_czyyhid varchar2(50);
    v_czyyhxm varchar2(50);
    v_count   number;
  
  BEGIN
    json_data(data_in, '胃癌病例提交', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid');
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    v_czyyhxm := Json_Str(v_Json_Data, 'czyyhxm');
  
    v_id := Json_Str(v_Json_Data, 'id');
    if v_id is null then
      v_err := 'id不能为空!';
      raise err_custom;
    end if;
    --更新状态
    update zjjk_mb_zlfh a
       set a.fhzt = '3',
           a.fhczrid = v_czyyhid,
           a.fhczrxm = v_czyyhxm,
           a.fhjgid  = v_czyjgdm,
           a.fhsj    = v_sysdate
     where a.fhzt = '1'
       and a.id = v_id
       and a.mblx = '4'
       and a.ccbz = '403'
       and a.zt = '1';
    if sql%rowcount <> 1 then
      v_err := '更新病例状态出错!';
      raise err_custom;
    end if;
    update zjjk_mb_zlfh_wa a set a.fhzt = '3' where a.id = v_id;
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_mb_blfh_wa_zt_tj;
  /*-----------------------------------------------------------------------------
  || 功能描述 ：胃癌病例复核
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_mb_blfh_wa_zt_fh(data_in    IN CLOB, --入参
                                 result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err  VARCHAR2(2000);
    v_id   zjjk_mb_zlfh.id%TYPE; --ID
    v_fhzt zjjk_mb_zlfh.fhzt%TYPE; --ID
    v_fhyj zjjk_mb_zlfh.fhyj%TYPE; --复核意见
  
    --公共变量
    v_sysdate date;
    v_czyjgjb varchar2(3);
    v_czyjgdm varchar2(50);
    v_czyyhid varchar2(50);
    v_czyyhxm varchar2(50);
    v_count   number;
  
  BEGIN
    json_data(data_in, '胃癌病例复核', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid');
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    v_czyyhxm := Json_Str(v_Json_Data, 'czyyhxm');
  
    v_id   := Json_Str(v_Json_Data, 'id');
    v_fhzt := Json_Str(v_Json_Data, 'fhzt');
    v_fhyj := Json_Str(v_Json_Data, 'fhyj');
    if v_id is null then
      v_err := 'id不能为空!';
      raise err_custom;
    end if;
    if nvl(v_fhzt, '-1') not in ('3', '4') then
      v_err := '复核状态传入有误!';
      raise err_custom;
    end if;
    --更新状态
    update zjjk_mb_zlfh a
       set a.fhzt    = v_fhzt,
           a.fhczrid = v_czyyhid,
           a.fhczrxm = v_czyyhxm,
           a.fhjgid  = v_czyjgdm,
           a.fhsj    = v_sysdate,
           a.fhyj    = v_fhyj
     where a.fhzt = '2'
       and a.id = v_id
       and a.mblx = '4'
       and a.ccbz = '403'
       and a.zt = '1';
    if sql%rowcount <> 1 then
      v_err := '更新病例复核状态出错!';
      raise err_custom;
    end if;
    update zjjk_mb_zlfh_wa a set a.fhzt = v_fhzt where a.id = v_id;
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_mb_blfh_wa_zt_fh;
  /*-----------------------------------------------------------------------------
  || 功能描述 ：胃癌病例审核
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_mb_blfh_wa_zt_sh(data_in    IN CLOB, --入参
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
    v_sysdate date;
    v_czyjgjb varchar2(3);
    v_czyjgdm varchar2(50);
    v_czyyhid varchar2(50);
    v_czyyhxm varchar2(50);
    v_count   number;
  
  BEGIN
    json_data(data_in, '胃癌病例审核', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid');
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    v_czyyhxm := Json_Str(v_Json_Data, 'czyyhxm');
  
    v_id   := Json_Str(v_Json_Data, 'id');
    v_shzt := Json_Str(v_Json_Data, 'fhzt');
    v_shyj := Json_Str(v_Json_Data, 'shyj');
    if v_id is null then
      v_err := 'id不能为空!';
      raise err_custom;
    end if;
    if nvl(v_shzt, '-1') not in ('5', '6') then
      v_err := '审核状态传入有误!';
      raise err_custom;
    end if;
    --更新状态
    update zjjk_mb_zlfh a
       set a.fhzt    = v_shzt,
           a.shczrid = v_czyyhid,
           a.shczrxm = v_czyyhxm,
           a.shjgid  = v_czyjgdm,
           a.shsj    = v_sysdate,
           a.shyj    = v_shyj
     where a.fhzt = '3'
       and a.id = v_id
       and a.mblx = '4'
       and a.ccbz = '403'
       and a.zt = '1';
    if sql%rowcount <> 1 then
      v_err := '更新病例审核状态出错!';
      raise err_custom;
    end if;
    update zjjk_mb_zlfh_wa a set a.fhzt = v_shzt where a.id = v_id;
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_mb_blfh_wa_zt_sh;
  /*-----------------------------------------------------------------------------
  || 功能描述 ：食管癌例填报
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_mb_blfh_sga_update(data_in    IN CLOB, --入参
                                   result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
  
    --公共变量
    v_sysdate date;
    v_czyjgjb varchar2(3);
    v_czyjgdm varchar2(50);
    v_czyyhid varchar2(50);
    v_czyyhxm varchar2(50);
    v_count   number;
  
    v_id                zjjk_mb_zlfh_sga.id%TYPE; --id
    v_bkdw              zjjk_mb_zlfh_sga.bkdw%TYPE; --报卡单位
    v_zyh               zjjk_mb_zlfh_sga.zyh%TYPE; --住院号
    v_jbxxybgksfyz      zjjk_mb_zlfh_sga.jbxxybgksfyz%TYPE; --基本信息与报告卡是否一致（0 是 1否）
    v_kpzt              zjjk_mb_zlfh_sga.kpzt%TYPE; --卡片状态
    v_blh               zjjk_mb_zlfh_sga.blh%TYPE; --病理号
    v_bgkbm             zjjk_mb_zlfh_sga.bgkbm%TYPE; --报告卡编码
    v_xm                zjjk_mb_zlfh_sga.xm%TYPE; --姓名
    v_xmxg              zjjk_mb_zlfh_sga.xmxg%TYPE; --姓名修改
    v_xb                zjjk_mb_zlfh_sga.xb%TYPE; --性别
    v_xbxg              zjjk_mb_zlfh_sga.xbxg%TYPE; --性别修改
    v_csrq              zjjk_mb_zlfh_sga.csrq%TYPE; --出生日期
    v_csrqxg            zjjk_mb_zlfh_sga.csrqxg%TYPE; --出生日期修改
    v_sfzh              zjjk_mb_zlfh_sga.sfzh%TYPE; --身份证号
    v_sfzhxg            zjjk_mb_zlfh_sga.sfzhxg%TYPE; --身份证号修改
    v_zdrq              zjjk_mb_zlfh_sga.zdrq%TYPE; --诊断日期（发病日期）
    v_zdrqxg            zjjk_mb_zlfh_sga.zdrqxg%TYPE; --诊断日期修改
    v_icd10             zjjk_mb_zlfh_sga.icd10%TYPE; --ICD-10
    v_icd10xg           zjjk_mb_zlfh_sga.icd10xg%TYPE; --ICD-10修改
    v_bgyysfwzdyy       zjjk_mb_zlfh_sga.bgyysfwzdyy%TYPE; --报告医院是否为诊断医院（0 是 1否）
    v_zdyymc            zjjk_mb_zlfh_sga.zdyymc%TYPE; --诊断医院名称
    v_czbajldjttj       zjjk_mb_zlfh_sga.czbajldjttj%TYPE; --查找病案记录的具体途径（0 电子住院记录系统 1 电子以及纸质住院记录名单 2 纸质住院名单 3 其他）
    v_qtczbajldtj       zjjk_mb_zlfh_sga.qtczbajldtj%TYPE; --其他查找病案记录的途径
    v_sfczbdcxgbazl     zjjk_mb_zlfh_sga.sfczbdcxgbazl%TYPE; --是否查找并调出该对象住院诊治的相关病案资料（0 是 1否）
    v_bajlsfdzh         zjjk_mb_zlfh_sga.bajlsfdzh%TYPE; --病案记录是否电子化（0 是 1否）
    v_dzbasjnr          zjjk_mb_zlfh_sga.dzbasjnr%TYPE; --电子病案涉及内容（0 所有病案信息 1 只有病案首页）
    v_wczbdcxgbazlyy    zjjk_mb_zlfh_sga.wczbdcxgbazlyy%TYPE; --未查找并调出该对象住院诊治的相关病案资料的可能原因（0 未在住院记录系统中找到相关资料 1 住院病案系统有记录但病案丢失 2 住院病案系统有记录但病案未保存 3 其他）
    v_qtknyy            zjjk_mb_zlfh_sga.qtknyy%TYPE; --其他可能原因
    v_sfcjbasy          zjjk_mb_zlfh_sga.sfcjbasy%TYPE; --是否采集（复印或拍照）医院病案首页（0 是 1否）
    v_sfcjcyxj          zjjk_mb_zlfh_sga.sfcjcyxj%TYPE; --是否采集（复印或拍照）医院出院小结/死亡记录（0 是 1否）
    v_sfcjryjl          zjjk_mb_zlfh_sga.sfcjryjl%TYPE; --是否采集（复印或拍照）医院入院记录（首次病程）（0 是 1否）
    v_sfcjsgjxhjblbg    zjjk_mb_zlfh_sga.sfcjsgjxhjblbg%TYPE; --是否采集（复印或拍照）食管镜下活检病理报告（0 是 1否）
    v_sfcjsgnmtlxbxjcbg zjjk_mb_zlfh_sga.sfcjsgnmtlxbxjcbg%TYPE; --是否采集（复印或拍照）食管黏膜脱落细胞学检查报告（0 是 1否）
    v_sfcjxxtbjcbg      zjjk_mb_zlfh_sga.sfcjxxtbjcbg%TYPE; --是否采集（复印或拍照）X线吞钡检查报告（0 是 1否）
    v_zyzd              zjjk_mb_zlfh_sga.zyzd%TYPE; --主要诊断
    v_cyhqtzd           zjjk_mb_zlfh_sga.cyhqtzd%TYPE; --次要或其他诊断
    v_chzt              zjjk_mb_zlfh_sga.chzt%TYPE; --存活状态（0存活 1死亡）
    v_wlcdqtjcbg        zjjk_mb_zlfh_sga.wlcdqtjcbg%TYPE; --注明其他采集到上面未列出的检测报告
    v_blcjzqz           zjjk_mb_zlfh_sga.blcjzqz%TYPE; --病例采集者签字
    v_bacjzdw           zjjk_mb_zlfh_sga.bacjzdw%TYPE; --病案采集者单位
    v_fhbgrq            zjjk_mb_zlfh_sga.fhbgrq%TYPE; --复核报告日期
    v_zdyj              zjjk_mb_zlfh_sga.zdyj%TYPE; --诊断依据
    v_zdyjxg            zjjk_mb_zlfh_sga.zdyjxg%TYPE; --诊断依据修改
    v_fhjgpd            zjjk_mb_zlfh_sga.fhjgpd%TYPE; --复核结果判断（0 符合 1不符合）
    v_zlwzx             zjjk_mb_zlfh_sga.zlwzx%TYPE; --资料完整性（0 符合 1不符合）
    v_fhzt              zjjk_mb_zlfh_sga.fhzt%TYPE; --复核状态（0 符合 1不符合）
    v_blxlx             zjjk_mb_zlfh_sga.blxlx%TYPE; --病理学类型
    v_blxlxxg           zjjk_mb_zlfh_sga.blxlxxg%TYPE; --病理学类型修改
    v_basyzp            zjjk_mb_zlfh_sga.basyzp%TYPE;    --（复印或拍照）医院病案首页照片
    v_cyxjzp            zjjk_mb_zlfh_sga.cyxjzp%TYPE;    --（复印或拍照）医院出院小结/死亡记录照片
    v_ryjlzp            zjjk_mb_zlfh_sga.ryjlzp%TYPE;    --（复印或拍照）医院入院记录（首次病程）照片
    v_sgjxhjblbgzp      zjjk_mb_zlfh_sga.sgjxhjblbgzp%TYPE;    --（复印或拍照）食管镜下活检病理报告照片
    v_sgnmtlxbxjcbgzp   zjjk_mb_zlfh_sga.sgnmtlxbxjcbgzp%TYPE;    --（复印或拍照）食管黏膜脱落细胞学检查报告照片
    v_xxtbjcbgzp        zjjk_mb_zlfh_sga.xxtbjcbgzp%TYPE;    --（复印或拍照）X线吞钡检查报告照片
    v_icdo3bm           zjjk_mb_zlfh_sga.icdo3bm%TYPE;    -- ICD-O-3编码
    v_icdo3bmxg         zjjk_mb_zlfh_sga.icdo3bmxg%TYPE;    -- ICD-O-3编码修改   
  
    --其他变量
    v_bgkid_s VARCHAR2(2000); --被抽查的报告卡IDs
  
  BEGIN
    json_data(data_in, '食管癌报告卡病例填报', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid');
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    v_czyyhxm := Json_Str(v_Json_Data, 'czyyhxm');
  
    v_id                := Json_Str(v_Json_Data, 'id');
    v_bkdw              := Json_Str(v_Json_Data, 'bkdw');
    v_zyh               := Json_Str(v_Json_Data, 'zyh');
    v_jbxxybgksfyz      := Json_Str(v_Json_Data, 'jbxxybgksfyz');
    v_kpzt              := Json_Str(v_Json_Data, 'kpzt');
    v_blh               := Json_Str(v_Json_Data, 'blh');
    v_bgkbm             := Json_Str(v_Json_Data, 'bgkbm');
    v_xm                := Json_Str(v_Json_Data, 'xm');
    v_xmxg              := Json_Str(v_Json_Data, 'xmxg');
    v_xb                := Json_Str(v_Json_Data, 'xb');
    v_xbxg              := Json_Str(v_Json_Data, 'xbxg');
    v_csrq              := std(Json_Str(v_Json_Data, 'csrq'), 0);
    v_csrqxg            := Json_Str(v_Json_Data, 'csrqxg');
    v_sfzh              := Json_Str(v_Json_Data, 'sfzh');
    v_sfzhxg            := Json_Str(v_Json_Data, 'sfzhxg');
    v_zdrq              := std(Json_Str(v_Json_Data, 'zdrq'), 0);
    v_zdrqxg            := Json_Str(v_Json_Data, 'zdrqxg');
    v_icd10             := Json_Str(v_Json_Data, 'icd10');
    v_icd10xg           := Json_Str(v_Json_Data, 'icd10xg');
    v_bgyysfwzdyy       := Json_Str(v_Json_Data, 'bgyysfwzdyy');
    v_zdyymc            := Json_Str(v_Json_Data, 'zdyymc');
    v_czbajldjttj       := Json_Str(v_Json_Data, 'czbajldjttj');
    v_qtczbajldtj       := Json_Str(v_Json_Data, 'qtczbajldtj');
    v_sfczbdcxgbazl     := Json_Str(v_Json_Data, 'sfczbdcxgbazl');
    v_bajlsfdzh         := Json_Str(v_Json_Data, 'bajlsfdzh');
    v_dzbasjnr          := Json_Str(v_Json_Data, 'dzbasjnr');
    v_wczbdcxgbazlyy    := Json_Str(v_Json_Data, 'wczbdcxgbazlyy');
    v_qtknyy            := Json_Str(v_Json_Data, 'qtknyy');
    v_sfcjbasy          := Json_Str(v_Json_Data, 'sfcjbasy');
    v_sfcjcyxj          := Json_Str(v_Json_Data, 'sfcjcyxj');
    v_sfcjryjl          := Json_Str(v_Json_Data, 'sfcjryjl');
    v_sfcjsgjxhjblbg    := Json_Str(v_Json_Data, 'sfcjsgjxhjblbg');
    v_sfcjsgnmtlxbxjcbg := Json_Str(v_Json_Data, 'sfcjsgnmtlxbxjcbg');
    v_sfcjxxtbjcbg      := Json_Str(v_Json_Data, 'sfcjxxtbjcbg');
    v_zyzd              := Json_Str(v_Json_Data, 'zyzd');
    v_cyhqtzd           := Json_Str(v_Json_Data, 'cyhqtzd');
    v_chzt              := Json_Str(v_Json_Data, 'chzt');
    v_wlcdqtjcbg        := Json_Str(v_Json_Data, 'wlcdqtjcbg');
    v_blcjzqz           := Json_Str(v_Json_Data, 'blcjzqz');
    v_bacjzdw           := Json_Str(v_Json_Data, 'bacjzdw');
    v_fhbgrq            := std(Json_Str(v_Json_Data, 'fhbgrq'), 0);
    v_zdyj              := Json_Str(v_Json_Data, 'zdyj');
    v_zdyjxg            := Json_Str(v_Json_Data, 'zdyjxg');
    v_fhjgpd            := Json_Str(v_Json_Data, 'fhjgpd');
    v_blxlx             := Json_Str(v_Json_Data, 'blxlx');
    v_blxlxxg           := Json_Str(v_Json_Data, 'blxlxxg');
    v_zlwzx             := Json_Str(v_Json_Data, 'zlwzx');
    v_basyzp            := Json_Str(v_Json_Data, 'basyzp');
    v_cyxjzp            := Json_Str(v_Json_Data, 'cyxjzp');
    v_ryjlzp            := Json_Str(v_Json_Data, 'ryjlzp');
    v_sgjxhjblbgzp      := Json_Str(v_Json_Data, 'sgjxhjblbgzp');
    v_sgnmtlxbxjcbgzp   := Json_Str(v_Json_Data, 'sgnmtlxbxjcbgzp');
    v_xxtbjcbgzp        := Json_Str(v_Json_Data, 'xxtbjcbgzp');
    v_icdo3bm           := Json_Str(v_Json_Data, 'icdo3bm');
    v_icdo3bmxg         := Json_Str(v_Json_Data, 'icdo3bmxg');      
      
    --校验权限
    if v_czyjgjb <> '3' then
      --非区县
      v_err := '当前机构无病例填报权限!';
      raise err_custom;
    end if;
  
    --校验状态
    select count(1)
      into v_count
      from zjjk_mb_zlfh a, zjjk_zlfhsj b
     where a.cctjid = b.jlbh
       and b.zt = '1'
       and a.id = v_id
       and a.mblx = '4'
       and a.ccbz = '404'
       and a.zt = '1'
       and nvl(a.fhzt, '0') in ('0', '1', '6');
    if v_count <> 1 then
      v_err := '未找到待填报的病例!';
      raise err_custom;
    end if;
  
    --校验必填项目
    if v_id is null then
      v_err := '报告卡ID不能为空!';
      raise err_custom;
    end if;
    if v_bkdw is null then
      v_err := '报卡单位不能为空!';
      raise err_custom;
    end if;
    if v_jbxxybgksfyz is null then
      v_err := '个人信息判断不能为空!';
      raise err_custom;
    end if;
    if v_kpzt is null then
      v_err := '卡片状态不能为空!';
      raise err_custom;
    end if;
    if v_bgkbm is null then
      v_err := '报告卡编码不能为空!';
      raise err_custom;
    end if;
    if v_xm is null then
      v_err := '姓名不能为空!';
      raise err_custom;
    end if;
    if v_xb is null then
      v_err := '性别不能为空!';
      raise err_custom;
    end if;
    if v_csrq is null then
      v_err := '出生日期不能为空!';
      raise err_custom;
    end if;
    if v_sfzh is null then
      --v_err := '身份证号不能为空!';
      --raise err_custom;
      --如果没有身份证号，则设为否
      v_sfzh:='无';
    end if;
    if v_zdrq is null then
      v_err := '诊断日期（发病日期）不能为空!';
      raise err_custom;
    end if;
    if v_icd10 is null then
      v_err := 'ICD-10不能为空!';
      raise err_custom;
    end if;
    if v_czbajldjttj is null then
      v_err := '查找病案记录的具体途径不能为空!';
      raise err_custom;
    end if;
    if v_qtczbajldtj is null and v_czbajldjttj = '3' then
      v_err := '其他查找病案记录的途径不能为空!';
      raise err_custom;
    end if;
    if v_sfczbdcxgbazl is null then
      v_err := '是否查找并调出该对象住院诊治的相关病案资料不能为空!';
      raise err_custom;
    end if;
    if v_bajlsfdzh is null and v_sfczbdcxgbazl = '0' then
      v_err := '病案记录是否电子化不能为空!';
      raise err_custom;
    end if;
    if v_dzbasjnr is null and v_bajlsfdzh = '0' then
      v_err := '电子病案涉及内容不能为空!';
      raise err_custom;
    end if;
    if v_wczbdcxgbazlyy is null and v_sfczbdcxgbazl = '1' then
      v_err := '未查找并调出该对象住院诊治的相关病案资料的可能原因不能为空!';
      raise err_custom;
    end if;
    if v_qtknyy is null and v_wczbdcxgbazlyy = '3' then
      v_err := '其他可能的原因不能为空!';
      raise err_custom;
    end if;
    if v_sfczbdcxgbazl = '0' then
      if v_sfcjbasy is null then
        v_err := '是否采集（复印或拍照）医院病案首页不能为空!';
        raise err_custom;
      end if;
      if v_sfcjcyxj is null then
        v_err := '是否采集（复印或拍照）医院出院小结/死亡记录不能为空!';
        raise err_custom;
      end if;
      if v_sfcjryjl is null then
        v_err := '是否采集（复印或拍照）医院入院记录（首次病程）不能为空!';
        raise err_custom;
      end if;
    
      if v_sfcjsgjxhjblbg is null then
        v_err := '是否采集（复印或拍照）食管镜下活检病理报告不能为空!';
        raise err_custom;
      end if;
      if v_sfcjsgnmtlxbxjcbg is null then
        v_err := '是否采集（复印或拍照）食管黏膜脱落细胞学检查报告不能为空!';
        raise err_custom;
      end if;
      if v_sfcjxxtbjcbg is null then
        v_err := '是否采集（复印或拍照）X线吞钡检查报告不能为空!';
        raise err_custom;
      end if;
    
      --if v_blxlx is null then
      --  v_err := '病理学类型不能为空!';
      --  raise err_custom;
      --end if;
      if v_zyzd is null then
        v_err := '主要诊断不能为空!';
        raise err_custom;
      end if;
      if v_chzt is null then
        v_err := '存活状态不能为空!';
        raise err_custom;
      end if;
      if v_blcjzqz is null then
        v_err := '病例采集者签字不能为空!';
        raise err_custom;
      end if;
      if v_bacjzdw is null then
        v_err := '病案采集者单位不能为空!';
        raise err_custom;
      end if;
      if v_fhbgrq is null then
        v_err := '复核报告日期不能为空!';
        raise err_custom;
      end if;
    end if;
    if v_zdyj is null then
      v_err := '诊断依据不能为空!';
      raise err_custom;
    end if;
    if v_zlwzx is null then
      v_err := '病案结果判断不能为空!';
      raise err_custom;
    end if;
    
    --更新资料完整性
    --基本信息判断验证
    if ((v_xmxg IS NULL AND v_xbxg IS NULL AND v_csrqxg IS NULL AND v_sfzhxg IS NULL 
         ) AND v_jbxxybgksfyz='1')
       OR
       ((v_xmxg IS NOT NULL OR v_xbxg IS NOT NULL OR v_csrqxg IS NOT NULL OR v_sfzhxg IS NOT NULL 
         ) AND v_jbxxybgksfyz='0') then
       v_err := '个人信息判断验证不通过!';
      raise err_custom;
    end if;
    
    --病案结果判断验证
    if ((nvl(v_sfcjbasy, '1') <> '0' or nvl(v_sfcjcyxj, '1') <> '0' or
       nvl(v_sfcjryjl, '1') <> '0' or nvl(v_sfcjsgjxhjblbg, '1') <> '0' or
       nvl(v_sfcjsgnmtlxbxjcbg, '1') <> '0' or nvl(v_sfcjxxtbjcbg, '1') <> '0') AND v_zlwzx='0')
       OR
       ((nvl(v_sfcjbasy, '1') = '0' AND nvl(v_sfcjcyxj, '1') = '0' AND
       nvl(v_sfcjryjl, '1') = '0' AND nvl(v_sfcjsgjxhjblbg, '1') = '0' AND
       nvl(v_sfcjsgnmtlxbxjcbg, '1') = '0' AND nvl(v_sfcjxxtbjcbg, '1') = '0') AND v_zlwzx='1') then
       v_err := '病案结果判断验证不通过!';
      raise err_custom;
    end if;
    
    --综合结果判断验证
    if (v_jbxxybgksfyz = '0' AND v_zlwzx ='0' AND v_fhjgpd='1')
       OR
       ((v_jbxxybgksfyz = '1' OR v_zlwzx ='1') AND v_fhjgpd='0') then
       v_err := '结果判断验证不通过!';
      raise err_custom;
    end if;
    
    --判断新增还是修改
    select count(1) into v_count from zjjk_mb_zlfh_sga a where a.id = v_id;
    if v_count > 0 then
      --修改
        UPDATE zjjk_mb_zlfh_sga
           SET id                = v_id,
               bkdw              = v_bkdw,
               zyh               = v_zyh,
               jbxxybgksfyz      = v_jbxxybgksfyz,
               kpzt              = v_kpzt,
               blh               = v_blh,
               bgkbm             = v_bgkbm,
               xm                = v_xm,
               xmxg              = v_xmxg,
               xb                = v_xb,
               xbxg              = v_xbxg,
               csrq              = v_csrq,
               csrqxg            = v_csrqxg,
               sfzh              = v_sfzh,
               sfzhxg            = v_sfzhxg,
               zdrq              = v_zdrq,
               zdrqxg            = v_zdrqxg,
               icd10             = v_icd10,
               icd10xg           = v_icd10xg,
               bgyysfwzdyy       = v_bgyysfwzdyy,
               zdyymc            = v_zdyymc,
               czbajldjttj       = v_czbajldjttj,
               qtczbajldtj       = v_qtczbajldtj,
               sfczbdcxgbazl     = v_sfczbdcxgbazl,
               bajlsfdzh         = v_bajlsfdzh,
               dzbasjnr          = v_dzbasjnr,
               wczbdcxgbazlyy    = v_wczbdcxgbazlyy,
               qtknyy            = v_qtknyy,
               sfcjbasy          = v_sfcjbasy,
               sfcjcyxj          = v_sfcjcyxj,
               sfcjryjl          = v_sfcjryjl,
               sfcjsgjxhjblbg    = v_sfcjsgjxhjblbg,
               sfcjsgnmtlxbxjcbg = v_sfcjsgnmtlxbxjcbg,
               sfcjxxtbjcbg      = v_sfcjxxtbjcbg,
               zyzd              = v_zyzd,
               cyhqtzd           = v_cyhqtzd,
               chzt              = v_chzt,
               wlcdqtjcbg        = v_wlcdqtjcbg,
               blcjzqz           = v_blcjzqz,
               bacjzdw           = v_bacjzdw,
               fhbgrq            = v_fhbgrq,
               zdyj              = v_zdyj,
               zdyjxg            = v_zdyjxg,
               fhjgpd            = v_fhjgpd,
               zlwzx             = v_zlwzx,
               xgrid             = v_czyyhid,
               xgrxm             = v_czyyhxm,
               xgsj              = v_sysdate,
               blxlx             = v_blxlx,
               blxlxxg           = v_blxlxxg,
               fhzt              = '1',
               basyzp            = v_basyzp,
               cyxjzp            = v_cyxjzp,
               ryjlzp            = v_ryjlzp,
               sgjxhjblbgzp      = v_sgjxhjblbgzp,
               sgnmtlxbxjcbgzp   = v_sgnmtlxbxjcbgzp,
               icdo3bm           = v_icdo3bm,
               icdo3bmxg         = v_icdo3bmxg,               
               xxtbjcbgzp        = v_xxtbjcbgzp
         WHERE id = v_id;
    else
      --新增
      INSERT INTO zjjk_mb_zlfh_sga
        (id,
         bkdw,
         zyh,
         jbxxybgksfyz,
         kpzt,
         blh,
         bgkbm,
         xm,
         xmxg,
         xb,
         xbxg,
         csrq,
         csrqxg,
         sfzh,
         sfzhxg,
         zdrq,
         zdrqxg,
         icd10,
         icd10xg,
         bgyysfwzdyy,
         zdyymc,
         czbajldjttj,
         qtczbajldtj,
         sfczbdcxgbazl,
         bajlsfdzh,
         dzbasjnr,
         wczbdcxgbazlyy,
         qtknyy,
         sfcjbasy,
         sfcjcyxj,
         sfcjryjl,
         sfcjsgjxhjblbg,
         sfcjsgnmtlxbxjcbg,
         sfcjxxtbjcbg,
         zyzd,
         cyhqtzd,
         chzt,
         wlcdqtjcbg,
         blcjzqz,
         bacjzdw,
         fhbgrq,
         zdyj,
         zdyjxg,
         fhjgpd,
         zlwzx,
         fhzt,
         cjrid,
         cjrxm,
         cjsj,
         xgrid,
         xgrxm,
         xgsj,
         blxlx,
         blxlxxg,
         basyzp,
         cyxjzp,
         ryjlzp,
         sgjxhjblbgzp,
         sgnmtlxbxjcbgzp,
         icdo3bm,
         icdo3bmxg,         
         xxtbjcbgzp)
      VALUES
        (v_id,
         v_bkdw,
         v_zyh,
         v_jbxxybgksfyz,
         v_kpzt,
         v_blh,
         v_bgkbm,
         v_xm,
         v_xmxg,
         v_xb,
         v_xbxg,
         v_csrq,
         v_csrqxg,
         v_sfzh,
         v_sfzhxg,
         v_zdrq,
         v_zdrqxg,
         v_icd10,
         v_icd10xg,
         v_bgyysfwzdyy,
         v_zdyymc,
         v_czbajldjttj,
         v_qtczbajldtj,
         v_sfczbdcxgbazl,
         v_bajlsfdzh,
         v_dzbasjnr,
         v_wczbdcxgbazlyy,
         v_qtknyy,
         v_sfcjbasy,
         v_sfcjcyxj,
         v_sfcjryjl,
         v_sfcjsgjxhjblbg,
         v_sfcjsgnmtlxbxjcbg,
         v_sfcjxxtbjcbg,
         v_zyzd,
         v_cyhqtzd,
         v_chzt,
         v_wlcdqtjcbg,
         v_blcjzqz,
         v_bacjzdw,
         v_fhbgrq,
         v_zdyj,
         v_zdyjxg,
         v_fhjgpd,
         v_zlwzx,
         '1',
         v_czyyhid,
         v_czyyhxm,
         v_sysdate,
         v_czyyhid,
         v_czyyhxm,
         v_sysdate,
         v_blxlx,
         v_blxlxxg,
         v_basyzp,
         v_cyxjzp,
         v_ryjlzp,
         v_sgjxhjblbgzp,
         v_sgnmtlxbxjcbgzp,
         v_icdo3bm,
         v_icdo3bmxg,         
         v_xxtbjcbgzp);
    
    end if;
    --更新复核状态
    update zjjk_mb_zlfh a
       set a.fhzt = '1', a.fhbz = '1'
     where a.id = v_id
       and a.mblx = '4'
       and a.ccbz = '404';
    --返回
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_mb_blfh_sga_update;
  /*-----------------------------------------------------------------------------
  || 功能描述 ：食管癌病例提交
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_mb_blfh_sga_zt_tj(data_in    IN CLOB, --入参
                                  result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
  
    v_id zjjk_mb_zlfh.id%TYPE; --ID
    --公共变量
    v_sysdate date;
    v_czyjgjb varchar2(3);
    v_czyjgdm varchar2(50);
    v_czyyhid varchar2(50);
    v_czyyhxm varchar2(50);
    v_count   number;
  
  BEGIN
    json_data(data_in, '食管癌病例提交', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid');
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    v_czyyhxm := Json_Str(v_Json_Data, 'czyyhxm');
  
    v_id := Json_Str(v_Json_Data, 'id');
    if v_id is null then
      v_err := 'id不能为空!';
      raise err_custom;
    end if;
    --更新状态
    update zjjk_mb_zlfh a
       set a.fhzt = '3',
           a.fhczrid = v_czyyhid,
           a.fhczrxm = v_czyyhxm,
           a.fhjgid  = v_czyjgdm,
           a.fhsj    = v_sysdate
     where a.fhzt = '1'
       and a.id = v_id
       and a.mblx = '4'
       and a.ccbz = '404'
       and a.zt = '1';
    if sql%rowcount <> 1 then
      v_err := '更新病例状态出错!';
      raise err_custom;
    end if;
    update zjjk_mb_zlfh_sga a set a.fhzt = '3' where a.id = v_id;
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_mb_blfh_sga_zt_tj;
  /*-----------------------------------------------------------------------------
  || 功能描述 ：食管癌病例复核
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_mb_blfh_sga_zt_fh(data_in    IN CLOB, --入参
                                  result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err  VARCHAR2(2000);
    v_id   zjjk_mb_zlfh.id%TYPE; --ID
    v_fhzt zjjk_mb_zlfh.fhzt%TYPE; --ID
    v_fhyj zjjk_mb_zlfh.fhyj%TYPE; --复核意见
  
    --公共变量
    v_sysdate date;
    v_czyjgjb varchar2(3);
    v_czyjgdm varchar2(50);
    v_czyyhid varchar2(50);
    v_czyyhxm varchar2(50);
    v_count   number;
  
  BEGIN
    json_data(data_in, '食管癌病例复核', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid');
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    v_czyyhxm := Json_Str(v_Json_Data, 'czyyhxm');
  
    v_id   := Json_Str(v_Json_Data, 'id');
    v_fhzt := Json_Str(v_Json_Data, 'fhzt');
    v_fhyj := Json_Str(v_Json_Data, 'fhyj');
    if v_id is null then
      v_err := 'id不能为空!';
      raise err_custom;
    end if;
    if nvl(v_fhzt, '-1') not in ('3', '4') then
      v_err := '复核状态传入有误!';
      raise err_custom;
    end if;
    --更新状态
    update zjjk_mb_zlfh a
       set a.fhzt    = v_fhzt,
           a.fhczrid = v_czyyhid,
           a.fhczrxm = v_czyyhxm,
           a.fhjgid  = v_czyjgdm,
           a.fhsj    = v_sysdate,
           a.fhyj    = v_fhyj
     where a.fhzt = '2'
       and a.id = v_id
       and a.mblx = '4'
       and a.ccbz = '404'
       and a.zt = '1';
    if sql%rowcount <> 1 then
      v_err := '更新病例复核状态出错!';
      raise err_custom;
    end if;
    update zjjk_mb_zlfh_sga a set a.fhzt = v_fhzt where a.id = v_id;
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_mb_blfh_sga_zt_fh;
  /*-----------------------------------------------------------------------------
  || 功能描述 ：食管癌病例审核
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_mb_blfh_sga_zt_sh(data_in    IN CLOB, --入参
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
    v_sysdate date;
    v_czyjgjb varchar2(3);
    v_czyjgdm varchar2(50);
    v_czyyhid varchar2(50);
    v_czyyhxm varchar2(50);
    v_count   number;
  
  BEGIN
    json_data(data_in, '食管癌病例审核', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid');
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    v_czyyhxm := Json_Str(v_Json_Data, 'czyyhxm');
  
    v_id   := Json_Str(v_Json_Data, 'id');
    v_shzt := Json_Str(v_Json_Data, 'fhzt');
    v_shyj := Json_Str(v_Json_Data, 'shyj');
    if v_id is null then
      v_err := 'id不能为空!';
      raise err_custom;
    end if;
    if nvl(v_shzt, '-1') not in ('5', '6') then
      v_err := '审核状态传入有误!';
      raise err_custom;
    end if;
    --更新状态
    update zjjk_mb_zlfh a
       set a.fhzt    = v_shzt,
           a.shczrid = v_czyyhid,
           a.shczrxm = v_czyyhxm,
           a.shjgid  = v_czyjgdm,
           a.shsj    = v_sysdate,
           a.shyj    = v_shyj
     where a.fhzt = '3'
       and a.id = v_id
       and a.mblx = '4'
       and a.ccbz = '404'
       and a.zt = '1';
    if sql%rowcount <> 1 then
      v_err := '更新病例审核状态出错!';
      raise err_custom;
    end if;
    update zjjk_mb_zlfh_sga a set a.fhzt = v_shzt where a.id = v_id;
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_mb_blfh_sga_zt_sh;
  /*-----------------------------------------------------------------------------
  || 功能描述 ：结、直肠癌例填报
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_mb_blfh_jzca_update(data_in    IN CLOB, --入参
                                    result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
  
    --公共变量
    v_sysdate date;
    v_czyjgjb varchar2(3);
    v_czyjgdm varchar2(50);
    v_czyyhid varchar2(50);
    v_czyyhxm varchar2(50);
    v_count   number;
  
    v_id             zjjk_mb_zlfh_jzca.id%TYPE; --id
    v_bkdw           zjjk_mb_zlfh_jzca.bkdw%TYPE; --报卡单位
    v_zyh            zjjk_mb_zlfh_jzca.zyh%TYPE; --住院号
    v_jbxxybgksfyz   zjjk_mb_zlfh_jzca.jbxxybgksfyz%TYPE; --基本信息与报告卡是否一致（0 是 1否）
    v_kpzt           zjjk_mb_zlfh_jzca.kpzt%TYPE; --卡片状态
    v_blh            zjjk_mb_zlfh_jzca.blh%TYPE; --病理号
    v_bgkbm          zjjk_mb_zlfh_jzca.bgkbm%TYPE; --报告卡编码
    v_xm             zjjk_mb_zlfh_jzca.xm%TYPE; --姓名
    v_xmxg           zjjk_mb_zlfh_jzca.xmxg%TYPE; --姓名修改
    v_xb             zjjk_mb_zlfh_jzca.xb%TYPE; --性别
    v_xbxg           zjjk_mb_zlfh_jzca.xbxg%TYPE; --性别修改
    v_csrq           zjjk_mb_zlfh_jzca.csrq%TYPE; --出生日期
    v_csrqxg         zjjk_mb_zlfh_jzca.csrqxg%TYPE; --出生日期修改
    v_sfzh           zjjk_mb_zlfh_jzca.sfzh%TYPE; --身份证号
    v_sfzhxg         zjjk_mb_zlfh_jzca.sfzhxg%TYPE; --身份证号修改
    v_zdrq           zjjk_mb_zlfh_jzca.zdrq%TYPE; --诊断日期（发病日期）
    v_zdrqxg         zjjk_mb_zlfh_jzca.zdrqxg%TYPE; --诊断日期修改
    v_icd10          zjjk_mb_zlfh_jzca.icd10%TYPE; --ICD-10
    v_icd10xg        zjjk_mb_zlfh_jzca.icd10xg%TYPE; --ICD-10修改
    v_bgyysfwzdyy    zjjk_mb_zlfh_jzca.bgyysfwzdyy%TYPE; --报告医院是否为诊断医院（0 是 1否）
    v_zdyymc         zjjk_mb_zlfh_jzca.zdyymc%TYPE; --诊断医院名称
    v_czbajldjttj    zjjk_mb_zlfh_jzca.czbajldjttj%TYPE; --查找病案记录的具体途径（0 电子住院记录系统 1 电子以及纸质住院记录名单 2 纸质住院名单 3 其他）
    v_qtczbajldtj    zjjk_mb_zlfh_jzca.qtczbajldtj%TYPE; --其他查找病案记录的途径
    v_sfczbdcxgbazl  zjjk_mb_zlfh_jzca.sfczbdcxgbazl%TYPE; --是否查找并调出该对象住院诊治的相关病案资料（0 是 1否）
    v_bajlsfdzh      zjjk_mb_zlfh_jzca.bajlsfdzh%TYPE; --病案记录是否电子化（0 是 1否）
    v_dzbasjnr       zjjk_mb_zlfh_jzca.dzbasjnr%TYPE; --电子病案涉及内容（0 所有病案信息 1 只有病案首页）
    v_wczbdcxgbazlyy zjjk_mb_zlfh_jzca.wczbdcxgbazlyy%TYPE; --未查找并调出该对象住院诊治的相关病案资料的可能原因（0 未在住院记录系统中找到相关资料 1 住院病案系统有记录但病案丢失 2 住院病案系统有记录但病案未保存 3 其他）
    v_qtknyy         zjjk_mb_zlfh_jzca.qtknyy%TYPE; --其他可能原因
    v_sfcjbasy       zjjk_mb_zlfh_jzca.sfcjbasy%TYPE; --是否采集（复印或拍照）医院病案首页（0 是 1否）
    v_sfcjcyxj       zjjk_mb_zlfh_jzca.sfcjcyxj%TYPE; --是否采集（复印或拍照）医院出院小结/死亡记录（0 是 1否）
    v_sfcjryjl       zjjk_mb_zlfh_jzca.sfcjryjl%TYPE; --是否采集（复印或拍照）医院入院记录（首次病程）（0 是 1否）
    v_sfcjjcjxhjblbg zjjk_mb_zlfh_jzca.sfcjjcjxhjblbg%TYPE; --是否采集（复印或拍照）结肠镜下活检病理报告（0 是 1否）
    v_sfcjzccssmjcbg zjjk_mb_zlfh_jzca.sfcjzccssmjcbg%TYPE; --是否采集（复印或拍照）直肠超声扫描检查报告（0 是 1否）
    v_sfcjxqapkycdbg zjjk_mb_zlfh_jzca.sfcjxqapkycdbg%TYPE; --是否采集（复印或拍照）血清癌胚抗原（CEA）测定报告（0 是 1否）
    v_sfcjtbgcxxjcbg zjjk_mb_zlfh_jzca.sfcjtbgcxxjcbg%TYPE; --是否采集（复印或拍照）钡灌肠X线检查报告（0 是 1否）
    v_zyzd           zjjk_mb_zlfh_jzca.zyzd%TYPE; --主要诊断
    v_cyhqtzd        zjjk_mb_zlfh_jzca.cyhqtzd%TYPE; --次要或其他诊断
    v_chzt           zjjk_mb_zlfh_jzca.chzt%TYPE; --存活状态（0存活 1死亡）
    v_wlcdqtjcbg     zjjk_mb_zlfh_jzca.wlcdqtjcbg%TYPE; --注明其他采集到上面未列出的检测报告
    v_blcjzqz        zjjk_mb_zlfh_jzca.blcjzqz%TYPE; --病例采集者签字
    v_bacjzdw        zjjk_mb_zlfh_jzca.bacjzdw%TYPE; --病案采集者单位
    v_fhbgrq         zjjk_mb_zlfh_jzca.fhbgrq%TYPE; --复核报告日期
    v_zdyj           zjjk_mb_zlfh_jzca.zdyj%TYPE; --诊断依据
    v_zdyjxg         zjjk_mb_zlfh_jzca.zdyjxg%TYPE; --诊断依据修改
    v_fhjgpd         zjjk_mb_zlfh_jzca.fhjgpd%TYPE; --复核结果判断（0 符合 1不符合）
    v_zlwzx          zjjk_mb_zlfh_jzca.zlwzx%TYPE; --资料完整性（0 符合 1不符合）
    v_fhzt           zjjk_mb_zlfh_jzca.fhzt%TYPE; --复核状态（0 符合 1不符合）
    v_xgsj           zjjk_mb_zlfh_jzca.xgsj%TYPE; --修改时间
    v_blxlx          zjjk_mb_zlfh_jzca.blxlx%TYPE; --病理学类型
    v_blxlxxg        zjjk_mb_zlfh_jzca.blxlxxg%TYPE; --病理学类型修改
    v_basyzp         zjjk_mb_zlfh_jzca.basyzp%TYPE;    --（复印或拍照）医院病案首页照片
    v_cyxjzp         zjjk_mb_zlfh_jzca.cyxjzp%TYPE;    --（复印或拍照）医院出院小结/死亡记录照片
    v_ryjlzp         zjjk_mb_zlfh_jzca.ryjlzp%TYPE;    --（复印或拍照）医院入院记录（首次病程）照片
    v_jcjxhjblbgzp   zjjk_mb_zlfh_jzca.jcjxhjblbgzp%TYPE;    --（复印或拍照）结肠镜下活检病理报告照片
    v_zccssmjcbgzp   zjjk_mb_zlfh_jzca.zccssmjcbgzp%TYPE;    --（复印或拍照）直肠超声扫描检查报告照片
    v_xqapkycdbgzp   zjjk_mb_zlfh_jzca.xqapkycdbgzp%TYPE;    --（复印或拍照）血清癌胚抗原（CEA）测定报告照片
    v_tbgcxxjcbgzp   zjjk_mb_zlfh_jzca.tbgcxxjcbgzp%TYPE;    --（复印或拍照）钡灌肠X线检查报告照片
    v_icdo3bm        zjjk_mb_zlfh_jzca.icdo3bm%TYPE;    -- ICD-O-3编码
    v_icdo3bmxg      zjjk_mb_zlfh_jzca.icdo3bmxg%TYPE;    -- ICD-O-3编码修改    
  
    --其他变量
    v_bgkid_s VARCHAR2(2000); --被抽查的报告卡IDs
  
  BEGIN
    json_data(data_in, '结、直肠癌报告卡病例填报', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid');
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    v_czyyhxm := Json_Str(v_Json_Data, 'czyyhxm');
  
    v_id             := Json_Str(v_Json_Data, 'id');
    v_bkdw           := Json_Str(v_Json_Data, 'bkdw');
    v_zyh            := Json_Str(v_Json_Data, 'zyh');
    v_jbxxybgksfyz   := Json_Str(v_Json_Data, 'jbxxybgksfyz');
    v_kpzt           := Json_Str(v_Json_Data, 'kpzt');
    v_blh            := Json_Str(v_Json_Data, 'blh');
    v_bgkbm          := Json_Str(v_Json_Data, 'bgkbm');
    v_xm             := Json_Str(v_Json_Data, 'xm');
    v_xmxg           := Json_Str(v_Json_Data, 'xmxg');
    v_xb             := Json_Str(v_Json_Data, 'xb');
    v_xbxg           := Json_Str(v_Json_Data, 'xbxg');
    v_csrq           := std(Json_Str(v_Json_Data, 'csrq'), 0);
    v_csrqxg         := Json_Str(v_Json_Data, 'csrqxg');
    v_sfzh           := Json_Str(v_Json_Data, 'sfzh');
    v_sfzhxg         := Json_Str(v_Json_Data, 'sfzhxg');
    v_zdrq           := std(Json_Str(v_Json_Data, 'zdrq'), 0);
    v_zdrqxg         := Json_Str(v_Json_Data, 'zdrqxg');
    v_icd10          := Json_Str(v_Json_Data, 'icd10');
    v_icd10xg        := Json_Str(v_Json_Data, 'icd10xg');
    v_bgyysfwzdyy    := Json_Str(v_Json_Data, 'bgyysfwzdyy');
    v_zdyymc         := Json_Str(v_Json_Data, 'zdyymc');
    v_czbajldjttj    := Json_Str(v_Json_Data, 'czbajldjttj');
    v_qtczbajldtj    := Json_Str(v_Json_Data, 'qtczbajldtj');
    v_sfczbdcxgbazl  := Json_Str(v_Json_Data, 'sfczbdcxgbazl');
    v_bajlsfdzh      := Json_Str(v_Json_Data, 'bajlsfdzh');
    v_dzbasjnr       := Json_Str(v_Json_Data, 'dzbasjnr');
    v_wczbdcxgbazlyy := Json_Str(v_Json_Data, 'wczbdcxgbazlyy');
    v_qtknyy         := Json_Str(v_Json_Data, 'qtknyy');
    v_sfcjbasy       := Json_Str(v_Json_Data, 'sfcjbasy');
    v_sfcjcyxj       := Json_Str(v_Json_Data, 'sfcjcyxj');
    v_sfcjryjl       := Json_Str(v_Json_Data, 'sfcjryjl');
    v_sfcjjcjxhjblbg := Json_Str(v_Json_Data, 'sfcjjcjxhjblbg');
    v_sfcjzccssmjcbg := Json_Str(v_Json_Data, 'sfcjzccssmjcbg');
    v_sfcjxqapkycdbg := Json_Str(v_Json_Data, 'sfcjxqapkycdbg');
    v_sfcjtbgcxxjcbg := Json_Str(v_Json_Data, 'sfcjtbgcxxjcbg');
    v_zyzd           := Json_Str(v_Json_Data, 'zyzd');
    v_cyhqtzd        := Json_Str(v_Json_Data, 'cyhqtzd');
    v_chzt           := Json_Str(v_Json_Data, 'chzt');
    v_wlcdqtjcbg     := Json_Str(v_Json_Data, 'wlcdqtjcbg');
    v_blcjzqz        := Json_Str(v_Json_Data, 'blcjzqz');
    v_bacjzdw        := Json_Str(v_Json_Data, 'bacjzdw');
    v_fhbgrq         := std(Json_Str(v_Json_Data, 'fhbgrq'), 0);
    v_zdyj           := Json_Str(v_Json_Data, 'zdyj');
    v_zdyjxg         := Json_Str(v_Json_Data, 'zdyjxg');
    v_fhjgpd         := Json_Str(v_Json_Data, 'fhjgpd');
    v_blxlx          := Json_Str(v_Json_Data, 'blxlx');
    v_blxlxxg        := Json_Str(v_Json_Data, 'blxlxxg');
    v_zlwzx          := Json_Str(v_Json_Data, 'zlwzx');
    v_basyzp         := Json_Str(v_Json_Data, 'basyzp');
    v_cyxjzp         := Json_Str(v_Json_Data, 'cyxjzp');
    v_ryjlzp         := Json_Str(v_Json_Data, 'ryjlzp');
    v_jcjxhjblbgzp   := Json_Str(v_Json_Data, 'jcjxhjblbgzp');
    v_zccssmjcbgzp   := Json_Str(v_Json_Data, 'zccssmjcbgzp');
    v_xqapkycdbgzp   := Json_Str(v_Json_Data, 'xqapkycdbgzp');
    v_tbgcxxjcbgzp   := Json_Str(v_Json_Data, 'tbgcxxjcbgzp');
    v_icdo3bm        := Json_Str(v_Json_Data, 'icdo3bm');
    v_icdo3bmxg      := Json_Str(v_Json_Data, 'icdo3bmxg');    
  
    --校验权限
    if v_czyjgjb <> '3' then
      --非区县
      v_err := '当前机构无病例填报权限!';
      raise err_custom;
    end if;
  
    --校验状态
    select count(1)
      into v_count
      from zjjk_mb_zlfh a, zjjk_zlfhsj b
     where a.cctjid = b.jlbh
       and b.zt = '1'
       and a.id = v_id
       and a.mblx = '4'
       and a.ccbz = '405'
       and a.zt = '1'
       and nvl(a.fhzt, '0') in ('0', '1', '6');
    if v_count <> 1 then
      v_err := '未找到待填报的病例!';
      raise err_custom;
    end if;
  
    --校验必填项目
    if v_id is null then
      v_err := '报告卡ID不能为空!';
      raise err_custom;
    end if;
    if v_bkdw is null then
      v_err := '报卡单位不能为空!';
      raise err_custom;
    end if;
    if v_jbxxybgksfyz is null then
      v_err := '个人信息判断不能为空!';
      raise err_custom;
    end if;
    if v_kpzt is null then
      v_err := '卡片状态不能为空!';
      raise err_custom;
    end if;
    if v_bgkbm is null then
      v_err := '报告卡编码不能为空!';
      raise err_custom;
    end if;
    if v_xm is null then
      v_err := '姓名不能为空!';
      raise err_custom;
    end if;
    if v_xb is null then
      v_err := '性别不能为空!';
      raise err_custom;
    end if;
    if v_csrq is null then
      v_err := '出生日期不能为空!';
      raise err_custom;
    end if;
    if v_sfzh is null then
      --v_err := '身份证号不能为空!';
      --raise err_custom;
      --如果没有身份证号，则设为否
      v_sfzh:='无';
    end if;
    if v_zdrq is null then
      v_err := '诊断日期（发病日期）不能为空!';
      raise err_custom;
    end if;
    if v_icd10 is null then
      v_err := 'ICD-10不能为空!';
      raise err_custom;
    end if;
    if v_czbajldjttj is null then
      v_err := '查找病案记录的具体途径不能为空!';
      raise err_custom;
    end if;
    if v_qtczbajldtj is null and v_czbajldjttj = '3' then
      v_err := '其他查找病案记录的途径不能为空!';
      raise err_custom;
    end if;
    if v_sfczbdcxgbazl is null then
      v_err := '是否查找并调出该对象住院诊治的相关病案资料不能为空!';
      raise err_custom;
    end if;
    if v_bajlsfdzh is null and v_sfczbdcxgbazl = '0' then
      v_err := '病案记录是否电子化不能为空!';
      raise err_custom;
    end if;
    if v_dzbasjnr is null and v_bajlsfdzh = '0' then
      v_err := '电子病案涉及内容不能为空!';
      raise err_custom;
    end if;
    if v_wczbdcxgbazlyy is null and v_sfczbdcxgbazl = '1' then
      v_err := '未查找并调出该对象住院诊治的相关病案资料的可能原因不能为空!';
      raise err_custom;
    end if;
    if v_qtknyy is null and v_wczbdcxgbazlyy = '3' then
      v_err := '其他可能的原因不能为空!';
      raise err_custom;
    end if;
    if v_sfczbdcxgbazl = '0' then
      if v_sfcjbasy is null then
        v_err := '是否采集（复印或拍照）医院病案首页不能为空!';
        raise err_custom;
      end if;
      if v_sfcjcyxj is null then
        v_err := '是否采集（复印或拍照）医院出院小结/死亡记录不能为空!';
        raise err_custom;
      end if;
      if v_sfcjryjl is null then
        v_err := '是否采集（复印或拍照）医院入院记录（首次病程）不能为空!';
        raise err_custom;
      end if;
    
      if v_sfcjjcjxhjblbg is null then
        v_err := '是否采集（复印或拍照）结肠镜下活检病理报告不能为空!';
        raise err_custom;
      end if;
      if v_sfcjzccssmjcbg is null then
        v_err := '是否采集（复印或拍照）直肠超声扫描检查报告不能为空!';
        raise err_custom;
      end if;
      if v_sfcjxqapkycdbg is null then
        v_err := '是否采集（复印或拍照）血清癌胚抗原（CEA）测定报告不能为空!';
        raise err_custom;
      end if;
      if v_sfcjtbgcxxjcbg is null then
        v_err := '是否采集（复印或拍照）钡灌肠X线检查报告不能为空!';
        raise err_custom;
      end if;
    
      --if v_blxlx is null then
      --  v_err := '病理学类型不能为空!';
      --  raise err_custom;
      --end if;
      if v_zyzd is null then
        v_err := '主要诊断不能为空!';
        raise err_custom;
      end if;
      if v_chzt is null then
        v_err := '存活状态不能为空!';
        raise err_custom;
      end if;
      if v_blcjzqz is null then
        v_err := '病例采集者签字不能为空!';
        raise err_custom;
      end if;
      if v_bacjzdw is null then
        v_err := '病案采集者单位不能为空!';
        raise err_custom;
      end if;
      if v_fhbgrq is null then
        v_err := '复核报告日期不能为空!';
        raise err_custom;
      end if;
    end if;
    if v_zdyj is null then
      v_err := '诊断依据不能为空!';
      raise err_custom;
    end if;
    if v_zlwzx is null then
      v_err := '病案结果判断不能为空!';
      raise err_custom;
    end if;
  
    --更新资料完整性
    --基本信息判断验证
    if ((v_xmxg IS NULL AND v_xbxg IS NULL AND v_csrqxg IS NULL AND v_sfzhxg IS NULL 
         ) AND v_jbxxybgksfyz='1')
       OR
       ((v_xmxg IS NOT NULL OR v_xbxg IS NOT NULL OR v_csrqxg IS NOT NULL OR v_sfzhxg IS NOT NULL 
         ) AND v_jbxxybgksfyz='0') then
       v_err := '个人信息判断验证不通过!';
      raise err_custom;
    end if;
    
    --病案结果判断验证
    if ((nvl(v_sfcjbasy, '1') <> '0' or nvl(v_sfcjcyxj, '1') <> '0' or
       nvl(v_sfcjryjl, '1') <> '0' or nvl(v_sfcjjcjxhjblbg, '1') <> '0' or
       nvl(v_sfcjzccssmjcbg, '1') <> '0' or nvl(v_sfcjxqapkycdbg, '1') <> '0' or
       nvl(v_sfcjtbgcxxjcbg, '1') <> '0') AND v_zlwzx='0')
       OR
       ((nvl(v_sfcjbasy, '1') = '0' AND nvl(v_sfcjcyxj, '1') = '0' AND
       nvl(v_sfcjryjl, '1') = '0' AND nvl(v_sfcjjcjxhjblbg, '1') = '0' AND
       nvl(v_sfcjzccssmjcbg, '1') = '0' AND nvl(v_sfcjxqapkycdbg, '1') = '0' AND
       nvl(v_sfcjtbgcxxjcbg, '1') = '0') AND v_zlwzx='1') then
       v_err := '病案结果判断验证不通过!';
      raise err_custom;
    end if;
    
    --综合结果判断验证
    if (v_jbxxybgksfyz = '0' AND v_zlwzx ='0' AND v_fhjgpd='1')
       OR
       ((v_jbxxybgksfyz = '1' OR v_zlwzx ='1') AND v_fhjgpd='0') then
       v_err := '结果判断验证不通过!';
      raise err_custom;
    end if;
    
    --判断新增还是修改
    select count(1)
      into v_count
      from zjjk_mb_zlfh_jzca a
     where a.id = v_id;
    if v_count > 0 then
      --修改
      UPDATE zjjk_mb_zlfh_jzca
         SET bkdw           = v_bkdw,
             zyh            = v_zyh,
             jbxxybgksfyz   = v_jbxxybgksfyz,
             kpzt           = v_kpzt,
             blh            = v_blh,
             bgkbm          = v_bgkbm,
             xm             = v_xm,
             xmxg           = v_xmxg,
             xb             = v_xb,
             xbxg           = v_xbxg,
             csrq           = v_csrq,
             csrqxg         = v_csrqxg,
             sfzh           = v_sfzh,
             sfzhxg         = v_sfzhxg,
             zdrq           = v_zdrq,
             zdrqxg         = v_zdrqxg,
             icd10          = v_icd10,
             icd10xg        = v_icd10xg,
             bgyysfwzdyy    = v_bgyysfwzdyy,
             zdyymc         = v_zdyymc,
             czbajldjttj    = v_czbajldjttj,
             qtczbajldtj    = v_qtczbajldtj,
             sfczbdcxgbazl  = v_sfczbdcxgbazl,
             bajlsfdzh      = v_bajlsfdzh,
             dzbasjnr       = v_dzbasjnr,
             wczbdcxgbazlyy = v_wczbdcxgbazlyy,
             qtknyy         = v_qtknyy,
             sfcjbasy       = v_sfcjbasy,
             sfcjcyxj       = v_sfcjcyxj,
             sfcjryjl       = v_sfcjryjl,
             sfcjjcjxhjblbg = v_sfcjjcjxhjblbg,
             sfcjzccssmjcbg = v_sfcjzccssmjcbg,
             sfcjxqapkycdbg = v_sfcjxqapkycdbg,
             sfcjtbgcxxjcbg = v_sfcjtbgcxxjcbg,
             zyzd           = v_zyzd,
             cyhqtzd        = v_cyhqtzd,
             chzt           = v_chzt,
             wlcdqtjcbg     = v_wlcdqtjcbg,
             blcjzqz        = v_blcjzqz,
             bacjzdw        = v_bacjzdw,
             fhbgrq         = v_fhbgrq,
             zdyj           = v_zdyj,
             zdyjxg         = v_zdyjxg,
             fhjgpd         = v_fhjgpd,
             zlwzx          = v_zlwzx,
             xgrid          = v_czyyhid,
             xgrxm          = v_czyyhxm,
             xgsj           = v_sysdate,
             blxlx          = v_blxlx,
             blxlxxg        = v_blxlxxg,
             fhzt           = '1',
             basyzp         = v_basyzp,
             cyxjzp         = v_cyxjzp,
             ryjlzp         = v_ryjlzp,
             jcjxhjblbgzp   = v_jcjxhjblbgzp,
             zccssmjcbgzp   = v_zccssmjcbgzp,
             xqapkycdbgzp   = v_xqapkycdbgzp,
             icdo3bm        = v_icdo3bm,
             icdo3bmxg      = v_icdo3bmxg,            
             tbgcxxjcbgzp   = v_tbgcxxjcbgzp
       WHERE id = v_id;
    
    else
      --新增
      INSERT INTO zjjk_mb_zlfh_jzca
        (id,
         bkdw,
         zyh,
         jbxxybgksfyz,
         kpzt,
         blh,
         bgkbm,
         xm,
         xmxg,
         xb,
         xbxg,
         csrq,
         csrqxg,
         sfzh,
         sfzhxg,
         zdrq,
         zdrqxg,
         icd10,
         icd10xg,
         bgyysfwzdyy,
         zdyymc,
         czbajldjttj,
         qtczbajldtj,
         sfczbdcxgbazl,
         bajlsfdzh,
         dzbasjnr,
         wczbdcxgbazlyy,
         qtknyy,
         sfcjbasy,
         sfcjcyxj,
         sfcjryjl,
         sfcjjcjxhjblbg,
         sfcjzccssmjcbg,
         sfcjxqapkycdbg,
         sfcjtbgcxxjcbg,
         zyzd,
         cyhqtzd,
         chzt,
         wlcdqtjcbg,
         blcjzqz,
         bacjzdw,
         fhbgrq,
         zdyj,
         zdyjxg,
         fhjgpd,
         zlwzx,
         fhzt,
         cjrid,
         cjrxm,
         cjsj,
         xgrid,
         xgrxm,
         xgsj,
         blxlx,
         blxlxxg,
         basyzp,
         cyxjzp,
         ryjlzp,
         jcjxhjblbgzp,
         zccssmjcbgzp,
         xqapkycdbgzp,
         icdo3bm,
         icdo3bmxg,         
         tbgcxxjcbgzp)
      VALUES
        (v_id,
         v_bkdw,
         v_zyh,
         v_jbxxybgksfyz,
         v_kpzt,
         v_blh,
         v_bgkbm,
         v_xm,
         v_xmxg,
         v_xb,
         v_xbxg,
         v_csrq,
         v_csrqxg,
         v_sfzh,
         v_sfzhxg,
         v_zdrq,
         v_zdrqxg,
         v_icd10,
         v_icd10xg,
         v_bgyysfwzdyy,
         v_zdyymc,
         v_czbajldjttj,
         v_qtczbajldtj,
         v_sfczbdcxgbazl,
         v_bajlsfdzh,
         v_dzbasjnr,
         v_wczbdcxgbazlyy,
         v_qtknyy,
         v_sfcjbasy,
         v_sfcjcyxj,
         v_sfcjryjl,
         v_sfcjjcjxhjblbg,
         v_sfcjzccssmjcbg,
         v_sfcjxqapkycdbg,
         v_sfcjtbgcxxjcbg,
         v_zyzd,
         v_cyhqtzd,
         v_chzt,
         v_wlcdqtjcbg,
         v_blcjzqz,
         v_bacjzdw,
         v_fhbgrq,
         v_zdyj,
         v_zdyjxg,
         v_fhjgpd,
         v_zlwzx,
         '1',
         v_czyyhid,
         v_czyyhxm,
         v_sysdate,
         v_czyyhid,
         v_czyyhxm,
         v_sysdate,
         v_blxlx,
         v_blxlxxg,
         v_basyzp,
         v_cyxjzp,
         v_ryjlzp,
         v_jcjxhjblbgzp,
         v_zccssmjcbgzp,
         v_xqapkycdbgzp,
         v_icdo3bm,
         v_icdo3bmxg,         
         v_tbgcxxjcbgzp);
    
    end if;
    --更新复核状态
    update zjjk_mb_zlfh a
       set a.fhzt = '1', a.fhbz = '1'
     where a.id = v_id
       and a.mblx = '4'
       and a.ccbz = '405';
    --返回
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_mb_blfh_jzca_update;
  /*-----------------------------------------------------------------------------
  || 功能描述 ：结、直肠癌病例提交
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_mb_blfh_jzca_zt_tj(data_in    IN CLOB, --入参
                                   result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
  
    v_id zjjk_mb_zlfh.id%TYPE; --ID
    --公共变量
    v_sysdate date;
    v_czyjgjb varchar2(3);
    v_czyjgdm varchar2(50);
    v_czyyhid varchar2(50);
    v_czyyhxm varchar2(50);
    v_count   number;
  
  BEGIN
    json_data(data_in, '结、直肠癌病例提交', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid');
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    v_czyyhxm := Json_Str(v_Json_Data, 'czyyhxm');
  
    v_id := Json_Str(v_Json_Data, 'id');
    if v_id is null then
      v_err := 'id不能为空!';
      raise err_custom;
    end if;
    --更新状态
    update zjjk_mb_zlfh a
       set a.fhzt = '3',
           a.fhczrid = v_czyyhid,
           a.fhczrxm = v_czyyhxm,
           a.fhjgid  = v_czyjgdm,
           a.fhsj    = v_sysdate
     where a.fhzt = '1'
       and a.id = v_id
       and a.mblx = '4'
       and a.ccbz = '405'
       and a.zt = '1';
    if sql%rowcount <> 1 then
      v_err := '更新病例状态出错!';
      raise err_custom;
    end if;
    update zjjk_mb_zlfh_jzca a set a.fhzt = '3' where a.id = v_id;
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_mb_blfh_jzca_zt_tj;
  /*-----------------------------------------------------------------------------
  || 功能描述 ：结、直肠癌病例复核
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_mb_blfh_jzca_zt_fh(data_in    IN CLOB, --入参
                                   result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err  VARCHAR2(2000);
    v_id   zjjk_mb_zlfh.id%TYPE; --ID
    v_fhzt zjjk_mb_zlfh.fhzt%TYPE; --ID
    v_fhyj zjjk_mb_zlfh.fhyj%TYPE; --复核意见
  
    --公共变量
    v_sysdate date;
    v_czyjgjb varchar2(3);
    v_czyjgdm varchar2(50);
    v_czyyhid varchar2(50);
    v_czyyhxm varchar2(50);
    v_count   number;
  
  BEGIN
    json_data(data_in, '结、直肠癌病例复核', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid');
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    v_czyyhxm := Json_Str(v_Json_Data, 'czyyhxm');
  
    v_id   := Json_Str(v_Json_Data, 'id');
    v_fhzt := Json_Str(v_Json_Data, 'fhzt');
    v_fhyj := Json_Str(v_Json_Data, 'fhyj');
    if v_id is null then
      v_err := 'id不能为空!';
      raise err_custom;
    end if;
    if nvl(v_fhzt, '-1') not in ('3', '4') then
      v_err := '复核状态传入有误!';
      raise err_custom;
    end if;
    --更新状态
    update zjjk_mb_zlfh a
       set a.fhzt    = v_fhzt,
           a.fhczrid = v_czyyhid,
           a.fhczrxm = v_czyyhxm,
           a.fhjgid  = v_czyjgdm,
           a.fhsj    = v_sysdate,
           a.fhyj    = v_fhyj
     where a.fhzt = '2'
       and a.id = v_id
       and a.mblx = '4'
       and a.ccbz = '405'
       and a.zt = '1';
    if sql%rowcount <> 1 then
      v_err := '更新病例复核状态出错!';
      raise err_custom;
    end if;
    update zjjk_mb_zlfh_jzca a set a.fhzt = v_fhzt where a.id = v_id;
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_mb_blfh_jzca_zt_fh;
  /*-----------------------------------------------------------------------------
  || 功能描述 ：结、直肠癌病例审核
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_mb_blfh_jzca_zt_sh(data_in    IN CLOB, --入参
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
    v_sysdate date;
    v_czyjgjb varchar2(3);
    v_czyjgdm varchar2(50);
    v_czyyhid varchar2(50);
    v_czyyhxm varchar2(50);
    v_count   number;
  
  BEGIN
    json_data(data_in, '结、直肠癌病例审核', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid');
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    v_czyyhxm := Json_Str(v_Json_Data, 'czyyhxm');
  
    v_id   := Json_Str(v_Json_Data, 'id');
    v_shzt := Json_Str(v_Json_Data, 'fhzt');
    v_shyj := Json_Str(v_Json_Data, 'shyj');
    if v_id is null then
      v_err := 'id不能为空!';
      raise err_custom;
    end if;
    if nvl(v_shzt, '-1') not in ('5', '6') then
      v_err := '审核状态传入有误!';
      raise err_custom;
    end if;
    --更新状态
    update zjjk_mb_zlfh a
       set a.fhzt    = v_shzt,
           a.shczrid = v_czyyhid,
           a.shczrxm = v_czyyhxm,
           a.shjgid  = v_czyjgdm,
           a.shsj    = v_sysdate,
           a.shyj    = v_shyj
     where a.fhzt = '3'
       and a.id = v_id
       and a.mblx = '4'
       and a.ccbz = '405'
       and a.zt = '1';
    if sql%rowcount <> 1 then
      v_err := '更新病例审核状态出错!';
      raise err_custom;
    end if;
    update zjjk_mb_zlfh_jzca a set a.fhzt = v_shzt where a.id = v_id;
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_mb_blfh_jzca_zt_sh;
  /*-----------------------------------------------------------------------------
  || 功能描述 ：女性乳腺癌例填报
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_mb_blfh_nxrxa_update(data_in    IN CLOB, --入参
                                     result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
  
    --公共变量
    v_sysdate date;
    v_czyjgjb varchar2(3);
    v_czyjgdm varchar2(50);
    v_czyyhid varchar2(50);
    v_czyyhxm varchar2(50);
    v_count   number;
  
    v_id               zjjk_mb_zlfh_nxrxa.id%TYPE; --ID
    v_bkdw             zjjk_mb_zlfh_nxrxa.bkdw%TYPE; --报卡单位
    v_zyh              zjjk_mb_zlfh_nxrxa.zyh%TYPE; --住院号
    v_jbxxybgksfyz     zjjk_mb_zlfh_nxrxa.jbxxybgksfyz%TYPE; --基本信息与报告卡是否一致（0 是 1否）
    v_kpzt             zjjk_mb_zlfh_nxrxa.kpzt%TYPE; --卡片状态
    v_blh              zjjk_mb_zlfh_nxrxa.blh%TYPE; --病理号
    v_bgkbm            zjjk_mb_zlfh_nxrxa.bgkbm%TYPE; --报告卡编码
    v_xm               zjjk_mb_zlfh_nxrxa.xm%TYPE; --姓名
    v_xmxg             zjjk_mb_zlfh_nxrxa.xmxg%TYPE; --姓名修改
    v_xb               zjjk_mb_zlfh_nxrxa.xb%TYPE; --性别
    v_xbxg             zjjk_mb_zlfh_nxrxa.xbxg%TYPE; --性别修改
    v_csrq             zjjk_mb_zlfh_nxrxa.csrq%TYPE; --出生日期
    v_csrqxg           zjjk_mb_zlfh_nxrxa.csrqxg%TYPE; --出生日期修改
    v_sfzh             zjjk_mb_zlfh_nxrxa.sfzh%TYPE; --身份证号
    v_sfzhxg           zjjk_mb_zlfh_nxrxa.sfzhxg%TYPE; --身份证号修改
    v_zdrq             zjjk_mb_zlfh_nxrxa.zdrq%TYPE; --诊断日期（发病日期）
    v_zdrqxg           zjjk_mb_zlfh_nxrxa.zdrqxg%TYPE; --诊断日期修改
    v_icd10            zjjk_mb_zlfh_nxrxa.icd10%TYPE; --ICD-10
    v_icd10xg          zjjk_mb_zlfh_nxrxa.icd10xg%TYPE; --ICD-10修改
    v_bgyysfwzdyy      zjjk_mb_zlfh_nxrxa.bgyysfwzdyy%TYPE; --报告医院是否为诊断医院（0 是 1否）
    v_zdyymc           zjjk_mb_zlfh_nxrxa.zdyymc%TYPE; --诊断医院名称
    v_czbajldjttj      zjjk_mb_zlfh_nxrxa.czbajldjttj%TYPE; --查找病案记录的具体途径（0 电子住院记录系统 1 电子以及纸质住院记录名单 2 纸质住院名单 3 其他）
    v_qtczbajldtj      zjjk_mb_zlfh_nxrxa.qtczbajldtj%TYPE; --其他查找病案记录的途径
    v_sfczbdcxgbazl    zjjk_mb_zlfh_nxrxa.sfczbdcxgbazl%TYPE; --是否查找并调出该对象住院诊治的相关病案资料（0 是 1否）
    v_bajlsfdzh        zjjk_mb_zlfh_nxrxa.bajlsfdzh%TYPE; --病案记录是否电子化（0 是 1否）
    v_dzbasjnr         zjjk_mb_zlfh_nxrxa.dzbasjnr%TYPE; --电子病案涉及内容（0 所有病案信息 1 只有病案首页）
    v_wczbdcxgbazlyy   zjjk_mb_zlfh_nxrxa.wczbdcxgbazlyy%TYPE; --未查找并调出该对象住院诊治的相关病案资料的可能原因（0 未在住院记录系统中找到相关资料 1 住院病案系统有记录但病案丢失 2 住院病案系统有记录但病案未保存 3 其他）
    v_qtknyy           zjjk_mb_zlfh_nxrxa.qtknyy%TYPE; --其他可能原因
    v_sfcjbasy         zjjk_mb_zlfh_nxrxa.sfcjbasy%TYPE; --是否采集（复印或拍照）医院病案首页（0 是 1否）
    v_sfcjcyxj         zjjk_mb_zlfh_nxrxa.sfcjcyxj%TYPE; --是否采集（复印或拍照）医院出院小结/死亡记录（0 是 1否）
    v_sfcjryjl         zjjk_mb_zlfh_nxrxa.sfcjryjl%TYPE; --是否采集（复印或拍照）医院入院记录（首次病程）（0 是 1否）
    v_sfcjrxzzxblbg    zjjk_mb_zlfh_nxrxa.sfcjrxzzxblbg%TYPE; --是否采集（复印或拍照）乳腺组织学病理报告（0 是 1否）
    v_sfcjrxcsjcbg     zjjk_mb_zlfh_nxrxa.sfcjrxcsjcbg%TYPE; --是否采集（复印或拍照）乳腺超声检查报告（0 是 1否）
    v_sfcjrxzxjcbg     zjjk_mb_zlfh_nxrxa.sfcjrxzxjcbg%TYPE; --是否采集（复印或拍照）乳腺照相检查报告（0 是 1否）
    v_sfcjrxadjsstztbg zjjk_mb_zlfh_nxrxa.sfcjrxadjsstztbg%TYPE; --是否采集（复印或拍照）乳腺癌的激素受体（ER/PR）状态报告（0 是 1否）
    v_zyzd             zjjk_mb_zlfh_nxrxa.zyzd%TYPE; --主要诊断
    v_cyhqtzd          zjjk_mb_zlfh_nxrxa.cyhqtzd%TYPE; --次要或其他诊断
    v_chzt             zjjk_mb_zlfh_nxrxa.chzt%TYPE; --存活状态（0存活 1死亡）
    v_wlcdqtjcbg       zjjk_mb_zlfh_nxrxa.wlcdqtjcbg%TYPE; --注明其他采集到上面未列出的检测报告
    v_blcjzqz          zjjk_mb_zlfh_nxrxa.blcjzqz%TYPE; --病例采集者签字
    v_bacjzdw          zjjk_mb_zlfh_nxrxa.bacjzdw%TYPE; --病案采集者单位
    v_fhbgrq           zjjk_mb_zlfh_nxrxa.fhbgrq%TYPE; --复核报告日期
    v_zdyj             zjjk_mb_zlfh_nxrxa.zdyj%TYPE; --诊断依据
    v_zdyjxg           zjjk_mb_zlfh_nxrxa.zdyjxg%TYPE; --诊断依据修改
    v_fhjgpd           zjjk_mb_zlfh_nxrxa.fhjgpd%TYPE; --复核结果判断（0 符合 1不符合）
    v_zlwzx            zjjk_mb_zlfh_nxrxa.zlwzx%TYPE; --资料完整性（0 符合 1不符合）
    v_fhzt             zjjk_mb_zlfh_nxrxa.fhzt%TYPE; --复核状态（0 符合 1不符合）
    v_blxlx            zjjk_mb_zlfh_nxrxa.blxlx%TYPE; --病理学类型
    v_blxlxxg          zjjk_mb_zlfh_nxrxa.blxlxxg%TYPE; --病理学类型修改
    v_basyzp           zjjk_mb_zlfh_nxrxa.basyzp%TYPE;    --（复印或拍照）医院病案首页照片
    v_cyxjzp           zjjk_mb_zlfh_nxrxa.cyxjzp%TYPE;    --（复印或拍照）医院出院小结/死亡记录照片
    v_ryjlzp           zjjk_mb_zlfh_nxrxa.ryjlzp%TYPE;    --（复印或拍照）医院入院记录（首次病程）照片
    v_rxzzxblbgzp      zjjk_mb_zlfh_nxrxa.rxzzxblbgzp%TYPE;    --（复印或拍照）乳腺组织学病理报告照片
    v_rxcsjcbgzp       zjjk_mb_zlfh_nxrxa.rxcsjcbgzp%TYPE;    --（复印或拍照）乳腺超声检查报告照片
    v_rxzxjcbgzp       zjjk_mb_zlfh_nxrxa.rxzxjcbgzp%TYPE;    --（复印或拍照）乳腺照相检查报告照片
    v_rxadjsstztbgzp   zjjk_mb_zlfh_nxrxa.rxadjsstztbgzp%TYPE;    --（复印或拍照）乳腺癌的激素受体（ER/PR）状态报告照片
    v_icdo3bm          zjjk_mb_zlfh_nxrxa.icdo3bm%TYPE;    -- ICD-O-3编码
    v_icdo3bmxg        zjjk_mb_zlfh_nxrxa.icdo3bmxg%TYPE;    -- ICD-O-3编码修改 
  
    --其他变量
    v_bgkid_s VARCHAR2(2000); --被抽查的报告卡IDs
  
  BEGIN
    json_data(data_in, '女性乳腺癌报告卡病例填报', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid');
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    v_czyyhxm := Json_Str(v_Json_Data, 'czyyhxm');
  
    v_id               := Json_Str(v_Json_Data, 'id');
    v_bkdw             := Json_Str(v_Json_Data, 'bkdw');
    v_zyh              := Json_Str(v_Json_Data, 'zyh');
    v_jbxxybgksfyz     := Json_Str(v_Json_Data, 'jbxxybgksfyz');
    v_kpzt             := Json_Str(v_Json_Data, 'kpzt');
    v_blh              := Json_Str(v_Json_Data, 'blh');
    v_bgkbm            := Json_Str(v_Json_Data, 'bgkbm');
    v_xm               := Json_Str(v_Json_Data, 'xm');
    v_xmxg             := Json_Str(v_Json_Data, 'xmxg');
    v_xb               := Json_Str(v_Json_Data, 'xb');
    v_xbxg             := Json_Str(v_Json_Data, 'xbxg');
    v_csrq             := std(Json_Str(v_Json_Data, 'csrq'), 0);
    v_csrqxg           := Json_Str(v_Json_Data, 'csrqxg');
    v_sfzh             := Json_Str(v_Json_Data, 'sfzh');
    v_sfzhxg           := Json_Str(v_Json_Data, 'sfzhxg');
    v_zdrq             := std(Json_Str(v_Json_Data, 'zdrq'), 0);
    v_zdrqxg           := Json_Str(v_Json_Data, 'zdrqxg');
    v_icd10            := Json_Str(v_Json_Data, 'icd10');
    v_icd10xg          := Json_Str(v_Json_Data, 'icd10xg');
    v_bgyysfwzdyy      := Json_Str(v_Json_Data, 'bgyysfwzdyy');
    v_zdyymc           := Json_Str(v_Json_Data, 'zdyymc');
    v_czbajldjttj      := Json_Str(v_Json_Data, 'czbajldjttj');
    v_qtczbajldtj      := Json_Str(v_Json_Data, 'qtczbajldtj');
    v_sfczbdcxgbazl    := Json_Str(v_Json_Data, 'sfczbdcxgbazl');
    v_bajlsfdzh        := Json_Str(v_Json_Data, 'bajlsfdzh');
    v_dzbasjnr         := Json_Str(v_Json_Data, 'dzbasjnr');
    v_wczbdcxgbazlyy   := Json_Str(v_Json_Data, 'wczbdcxgbazlyy');
    v_qtknyy           := Json_Str(v_Json_Data, 'qtknyy');
    v_sfcjbasy         := Json_Str(v_Json_Data, 'sfcjbasy');
    v_sfcjcyxj         := Json_Str(v_Json_Data, 'sfcjcyxj');
    v_sfcjryjl         := Json_Str(v_Json_Data, 'sfcjryjl');
    v_sfcjrxzzxblbg    := Json_Str(v_Json_Data, 'sfcjrxzzxblbg');
    v_sfcjrxcsjcbg     := Json_Str(v_Json_Data, 'sfcjrxcsjcbg');
    v_sfcjrxzxjcbg     := Json_Str(v_Json_Data, 'sfcjrxzxjcbg');
    v_sfcjrxadjsstztbg := Json_Str(v_Json_Data, 'sfcjrxadjsstztbg');
    v_zyzd             := Json_Str(v_Json_Data, 'zyzd');
    v_cyhqtzd          := Json_Str(v_Json_Data, 'cyhqtzd');
    v_chzt             := Json_Str(v_Json_Data, 'chzt');
    v_wlcdqtjcbg       := Json_Str(v_Json_Data, 'wlcdqtjcbg');
    v_blcjzqz          := Json_Str(v_Json_Data, 'blcjzqz');
    v_bacjzdw          := Json_Str(v_Json_Data, 'bacjzdw');
    v_fhbgrq           := std(Json_Str(v_Json_Data, 'fhbgrq'), 0);
    v_zdyj             := Json_Str(v_Json_Data, 'zdyj');
    v_zdyjxg           := Json_Str(v_Json_Data, 'zdyjxg');
    v_fhjgpd           := Json_Str(v_Json_Data, 'fhjgpd');
    v_blxlx            := Json_Str(v_Json_Data, 'blxlx');
    v_blxlxxg          := Json_Str(v_Json_Data, 'blxlxxg');
    v_zlwzx            := Json_Str(v_Json_Data, 'zlwzx');
    v_basyzp           := Json_Str(v_Json_Data, 'basyzp');
    v_cyxjzp           := Json_Str(v_Json_Data, 'cyxjzp');
    v_ryjlzp           := Json_Str(v_Json_Data, 'ryjlzp');
    v_rxzzxblbgzp      := Json_Str(v_Json_Data, 'rxzzxblbgzp');
    v_rxcsjcbgzp       := Json_Str(v_Json_Data, 'rxcsjcbgzp');
    v_rxzxjcbgzp       := Json_Str(v_Json_Data, 'rxzxjcbgzp');
    v_rxadjsstztbgzp   := Json_Str(v_Json_Data, 'rxadjsstztbgzp');
    v_icdo3bm          := Json_Str(v_Json_Data, 'icdo3bm');
    v_icdo3bmxg        := Json_Str(v_Json_Data, 'icdo3bmxg');    

    
    --校验权限
    if v_czyjgjb <> '3' then
      --非区县
      v_err := '当前机构无病例填报权限!';
      raise err_custom;
    end if;
  
    --校验状态
    select count(1)
      into v_count
      from zjjk_mb_zlfh a, zjjk_zlfhsj b
     where a.cctjid = b.jlbh
       and b.zt = '1'
       and a.id = v_id
       and a.mblx = '4'
       and a.ccbz = '406'
       and a.zt = '1'
       and nvl(a.fhzt, '0') in ('0', '1', '6');
    if v_count <> 1 then
      v_err := '未找到待填报的病例!';
      raise err_custom;
    end if;
  
    --校验必填项目
    if v_id is null then
      v_err := '报告卡ID不能为空!';
      raise err_custom;
    end if;
    if v_bkdw is null then
      v_err := '报卡单位不能为空!';
      raise err_custom;
    end if;
    if v_jbxxybgksfyz is null then
      v_err := '个人信息判断不能为空!';
      raise err_custom;
    end if;
    if v_kpzt is null then
      v_err := '卡片状态不能为空!';
      raise err_custom;
    end if;
    if v_bgkbm is null then
      v_err := '报告卡编码不能为空!';
      raise err_custom;
    end if;
    if v_xm is null then
      v_err := '姓名不能为空!';
      raise err_custom;
    end if;
    if v_xb is null then
      v_err := '性别不能为空!';
      raise err_custom;
    end if;
    if v_csrq is null then
      v_err := '出生日期不能为空!';
      raise err_custom;
    end if;
    if v_sfzh is null then
      --v_err := '身份证号不能为空!';
      --raise err_custom;
      --如果没有身份证号，则设为否
      v_sfzh:='无';
    end if;
    if v_zdrq is null then
      v_err := '诊断日期（发病日期）不能为空!';
      raise err_custom;
    end if;
    if v_icd10 is null then
      v_err := 'ICD-10不能为空!';
      raise err_custom;
    end if;
    if v_czbajldjttj is null then
      v_err := '查找病案记录的具体途径不能为空!';
      raise err_custom;
    end if;
    if v_qtczbajldtj is null and v_czbajldjttj = '3' then
      v_err := '其他查找病案记录的途径不能为空!';
      raise err_custom;
    end if;
    if v_sfczbdcxgbazl is null then
      v_err := '是否查找并调出该对象住院诊治的相关病案资料不能为空!';
      raise err_custom;
    end if;
    if v_bajlsfdzh is null and v_sfczbdcxgbazl = '0' then
      v_err := '病案记录是否电子化不能为空!';
      raise err_custom;
    end if;
    if v_dzbasjnr is null and v_bajlsfdzh = '0' then
      v_err := '电子病案涉及内容不能为空!';
      raise err_custom;
    end if;
    if v_wczbdcxgbazlyy is null and v_sfczbdcxgbazl = '1' then
      v_err := '未查找并调出该对象住院诊治的相关病案资料的可能原因不能为空!';
      raise err_custom;
    end if;
    if v_qtknyy is null and v_wczbdcxgbazlyy = '3' then
      v_err := '其他可能的原因不能为空!';
      raise err_custom;
    end if;
    if v_sfczbdcxgbazl = '0' then
      if v_sfcjbasy is null then
        v_err := '是否采集（复印或拍照）医院病案首页不能为空!';
        raise err_custom;
      end if;
      if v_sfcjcyxj is null then
        v_err := '是否采集（复印或拍照）医院出院小结/死亡记录不能为空!';
        raise err_custom;
      end if;
      if v_sfcjryjl is null then
        v_err := '是否采集（复印或拍照）医院入院记录（首次病程）不能为空!';
        raise err_custom;
      end if;
    
      if v_sfcjrxzzxblbg is null then
        v_err := '是否采集（复印或拍照）乳腺组织学病理报告不能为空!';
        raise err_custom;
      end if;
      if v_sfcjrxcsjcbg is null then
        v_err := '是否采集（复印或拍照）乳腺超声检查报告不能为空!';
        raise err_custom;
      end if;
      if v_sfcjrxzxjcbg is null then
        v_err := '是否采集（复印或拍照）乳腺照相检查报告不能为空!';
        raise err_custom;
      end if;
      if v_sfcjrxadjsstztbg is null then
        v_err := '是否采集（复印或拍照）乳腺癌的激素受体（ER/PR）状态报告不能为空!';
        raise err_custom;
      end if;
    
      --if v_blxlx is null then
      --  v_err := '病理学类型不能为空!';
      --  raise err_custom;
      --end if;
      if v_zyzd is null then
        v_err := '主要诊断不能为空!';
        raise err_custom;
      end if;
      if v_chzt is null then
        v_err := '存活状态不能为空!';
        raise err_custom;
      end if;
      if v_blcjzqz is null then
        v_err := '病例采集者签字不能为空!';
        raise err_custom;
      end if;
      if v_bacjzdw is null then
        v_err := '病案采集者单位不能为空!';
        raise err_custom;
      end if;
      if v_fhbgrq is null then
        v_err := '复核报告日期不能为空!';
        raise err_custom;
      end if;
    end if;
    if v_zdyj is null then
      v_err := '诊断依据不能为空!';
      raise err_custom;
    end if;
    if v_zlwzx is null then
      v_err := '病案结果判断不能为空!';
      raise err_custom;
    end if;
  
    --更新资料完整性
    --基本信息判断验证
    if ((v_xmxg IS NULL AND v_xbxg IS NULL AND v_csrqxg IS NULL AND v_sfzhxg IS NULL 
         ) AND v_jbxxybgksfyz='1')
       OR
       ((v_xmxg IS NOT NULL OR v_xbxg IS NOT NULL OR v_csrqxg IS NOT NULL OR v_sfzhxg IS NOT NULL 
         ) AND v_jbxxybgksfyz='0') then
       v_err := '个人信息判断验证不通过!';
      raise err_custom;
    end if;
    
    --病案结果判断验证
    if ((nvl(v_sfcjbasy, '1') <> '0' or nvl(v_sfcjcyxj, '1') <> '0' or
       nvl(v_sfcjryjl, '1') <> '0' or nvl(v_sfcjrxzzxblbg, '1') <> '0' or
       nvl(v_sfcjrxcsjcbg, '1') <> '0' or nvl(v_sfcjrxzxjcbg, '1') <> '0' or
       nvl(v_sfcjrxadjsstztbg, '1') <> '0') AND v_zlwzx='0')
       OR
       ((nvl(v_sfcjbasy, '1') = '0' AND nvl(v_sfcjcyxj, '1') = '0' AND
       nvl(v_sfcjryjl, '1') = '0' AND nvl(v_sfcjrxzzxblbg, '1') = '0' AND
       nvl(v_sfcjrxcsjcbg, '1') = '0' AND nvl(v_sfcjrxzxjcbg, '1') = '0' AND
       nvl(v_sfcjrxadjsstztbg, '1') = '0') AND v_zlwzx='1') then
       v_err := '病案结果判断验证不通过!';
      raise err_custom;
    end if;
    
    --综合结果判断验证
    if (v_jbxxybgksfyz = '0' AND v_zlwzx ='0' AND v_fhjgpd='1')
       OR
       ((v_jbxxybgksfyz = '1' OR v_zlwzx ='1') AND v_fhjgpd='0') then
       v_err := '结果判断验证不通过!';
      raise err_custom;
    end if;
    
    --判断新增还是修改
    select count(1)
      into v_count
      from zjjk_mb_zlfh_nxrxa a
     where a.id = v_id;
    if v_count > 0 then
      --修改
      UPDATE zjjk_mb_zlfh_nxrxa
         SET id               = v_id,
             bkdw             = v_bkdw,
             zyh              = v_zyh,
             jbxxybgksfyz     = v_jbxxybgksfyz,
             kpzt             = v_kpzt,
             blh              = v_blh,
             bgkbm            = v_bgkbm,
             xm               = v_xm,
             xmxg             = v_xmxg,
             xb               = v_xb,
             xbxg             = v_xbxg,
             csrq             = v_csrq,
             csrqxg           = v_csrqxg,
             sfzh             = v_sfzh,
             sfzhxg           = v_sfzhxg,
             zdrq             = v_zdrq,
             zdrqxg           = v_zdrqxg,
             icd10            = v_icd10,
             icd10xg          = v_icd10xg,
             bgyysfwzdyy      = v_bgyysfwzdyy,
             zdyymc           = v_zdyymc,
             czbajldjttj      = v_czbajldjttj,
             qtczbajldtj      = v_qtczbajldtj,
             sfczbdcxgbazl    = v_sfczbdcxgbazl,
             bajlsfdzh        = v_bajlsfdzh,
             dzbasjnr         = v_dzbasjnr,
             wczbdcxgbazlyy   = v_wczbdcxgbazlyy,
             qtknyy           = v_qtknyy,
             sfcjbasy         = v_sfcjbasy,
             sfcjcyxj         = v_sfcjcyxj,
             sfcjryjl         = v_sfcjryjl,
             sfcjrxzzxblbg    = v_sfcjrxzzxblbg,
             sfcjrxcsjcbg     = v_sfcjrxcsjcbg,
             sfcjrxzxjcbg     = v_sfcjrxzxjcbg,
             sfcjrxadjsstztbg = v_sfcjrxadjsstztbg,
             zyzd             = v_zyzd,
             cyhqtzd          = v_cyhqtzd,
             chzt             = v_chzt,
             wlcdqtjcbg       = v_wlcdqtjcbg,
             blcjzqz          = v_blcjzqz,
             bacjzdw          = v_bacjzdw,
             fhbgrq           = v_fhbgrq,
             zdyj             = v_zdyj,
             zdyjxg           = v_zdyjxg,
             fhjgpd           = v_fhjgpd,
             zlwzx            = v_zlwzx,
             xgrid            = v_czyyhid,
             xgrxm            = v_czyyhxm,
             xgsj             = v_sysdate,
             blxlx            = v_blxlx,
             blxlxxg          = v_blxlxxg,
             fhzt             = '1',
             basyzp           = v_basyzp,
             cyxjzp           = v_cyxjzp,
             ryjlzp           = v_ryjlzp,
             rxzzxblbgzp      = v_rxzzxblbgzp,
             rxcsjcbgzp       = v_rxcsjcbgzp,
             rxzxjcbgzp       = v_rxzxjcbgzp,
             icdo3bm        = v_icdo3bm,
             icdo3bmxg     = v_icdo3bmxg,             
             rxadjsstztbgzp   = v_rxadjsstztbgzp
       WHERE id = v_id;
    else
      --新增
        INSERT INTO zjjk_mb_zlfh_nxrxa
          (id,
           bkdw,
           zyh,
           jbxxybgksfyz,
           kpzt,
           blh,
           bgkbm,
           xm,
           xmxg,
           xb,
           xbxg,
           csrq,
           csrqxg,
           sfzh,
           sfzhxg,
           zdrq,
           zdrqxg,
           icd10,
           icd10xg,
           bgyysfwzdyy,
           zdyymc,
           czbajldjttj,
           qtczbajldtj,
           sfczbdcxgbazl,
           bajlsfdzh,
           dzbasjnr,
           wczbdcxgbazlyy,
           qtknyy,
           sfcjbasy,
           sfcjcyxj,
           sfcjryjl,
           sfcjrxzzxblbg,
           sfcjrxcsjcbg,
           sfcjrxzxjcbg,
           sfcjrxadjsstztbg,
           zyzd,
           cyhqtzd,
           chzt,
           wlcdqtjcbg,
           blcjzqz,
           bacjzdw,
           fhbgrq,
           zdyj,
           zdyjxg,
           fhjgpd,
           zlwzx,
           fhzt,
           cjrid,
           cjrxm,
           cjsj,
           xgrid,
           xgrxm,
           xgsj,
           blxlx,
           blxlxxg,
           basyzp,
           cyxjzp,
           ryjlzp,
           rxzzxblbgzp,
           rxcsjcbgzp,
           rxzxjcbgzp,
           icdo3bm,
           icdo3bmxg,           
           rxadjsstztbgzp)
        VALUES
          (v_id,
           v_bkdw,
           v_zyh,
           v_jbxxybgksfyz,
           v_kpzt,
           v_blh,
           v_bgkbm,
           v_xm,
           v_xmxg,
           v_xb,
           v_xbxg,
           v_csrq,
           v_csrqxg,
           v_sfzh,
           v_sfzhxg,
           v_zdrq,
           v_zdrqxg,
           v_icd10,
           v_icd10xg,
           v_bgyysfwzdyy,
           v_zdyymc,
           v_czbajldjttj,
           v_qtczbajldtj,
           v_sfczbdcxgbazl,
           v_bajlsfdzh,
           v_dzbasjnr,
           v_wczbdcxgbazlyy,
           v_qtknyy,
           v_sfcjbasy,
           v_sfcjcyxj,
           v_sfcjryjl,
           v_sfcjrxzzxblbg,
           v_sfcjrxcsjcbg,
           v_sfcjrxzxjcbg,
           v_sfcjrxadjsstztbg,
           v_zyzd,
           v_cyhqtzd,
           v_chzt,
           v_wlcdqtjcbg,
           v_blcjzqz,
           v_bacjzdw,
           v_fhbgrq,
           v_zdyj,
           v_zdyjxg,
           v_fhjgpd,
           v_zlwzx,
           '1',
           v_czyyhid,
           v_czyyhxm,
           v_sysdate,
           v_czyyhid,
           v_czyyhxm,
           v_sysdate,
           v_blxlx,
           v_blxlxxg,
           v_basyzp,
           v_cyxjzp,
           v_ryjlzp,
           v_rxzzxblbgzp,
           v_rxcsjcbgzp,
           v_rxzxjcbgzp,
           v_icdo3bm,
           v_icdo3bmxg,           
           v_rxadjsstztbgzp);
    
    end if;
    --更新复核状态
    update zjjk_mb_zlfh a
       set a.fhzt = '1', a.fhbz = '1'
     where a.id = v_id
       and a.mblx = '4'
       and a.ccbz = '406';
    --返回
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_mb_blfh_nxrxa_update;
  /*-----------------------------------------------------------------------------
  || 功能描述 ：女性乳腺癌病例提交
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_mb_blfh_nxrxa_zt_tj(data_in    IN CLOB, --入参
                                    result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
  
    v_id zjjk_mb_zlfh.id%TYPE; --ID
    --公共变量
    v_sysdate date;
    v_czyjgjb varchar2(3);
    v_czyjgdm varchar2(50);
    v_czyyhid varchar2(50);
    v_czyyhxm varchar2(50);
    v_count   number;
  
  BEGIN
    json_data(data_in, '女性乳腺癌病例提交', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid');
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    v_czyyhxm := Json_Str(v_Json_Data, 'czyyhxm');
  
    v_id := Json_Str(v_Json_Data, 'id');
    if v_id is null then
      v_err := 'id不能为空!';
      raise err_custom;
    end if;
    --更新状态
    update zjjk_mb_zlfh a
       set a.fhzt = '3',
           a.fhczrid = v_czyyhid,
           a.fhczrxm = v_czyyhxm,
           a.fhjgid  = v_czyjgdm,
           a.fhsj    = v_sysdate
     where a.fhzt = '1'
       and a.id = v_id
       and a.mblx = '4'
       and a.ccbz = '406'
       and a.zt = '1';
    if sql%rowcount <> 1 then
      v_err := '更新病例状态出错!';
      raise err_custom;
    end if;
    update zjjk_mb_zlfh_nxrxa a set a.fhzt = '3' where a.id = v_id;
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_mb_blfh_nxrxa_zt_tj;
  /*-----------------------------------------------------------------------------
  || 功能描述 ：女性乳腺癌病例复核
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_mb_blfh_nxrxa_zt_fh(data_in    IN CLOB, --入参
                                    result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err  VARCHAR2(2000);
    v_id   zjjk_mb_zlfh.id%TYPE; --ID
    v_fhzt zjjk_mb_zlfh.fhzt%TYPE; --ID
    v_fhyj zjjk_mb_zlfh.fhyj%TYPE; --复核意见
  
    --公共变量
    v_sysdate date;
    v_czyjgjb varchar2(3);
    v_czyjgdm varchar2(50);
    v_czyyhid varchar2(50);
    v_czyyhxm varchar2(50);
    v_count   number;
  
  BEGIN
    json_data(data_in, '女性乳腺癌病例复核', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid');
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    v_czyyhxm := Json_Str(v_Json_Data, 'czyyhxm');
  
    v_id   := Json_Str(v_Json_Data, 'id');
    v_fhzt := Json_Str(v_Json_Data, 'fhzt');
    v_fhyj := Json_Str(v_Json_Data, 'fhyj');
    if v_id is null then
      v_err := 'id不能为空!';
      raise err_custom;
    end if;
    if nvl(v_fhzt, '-1') not in ('3', '4') then
      v_err := '复核状态传入有误!';
      raise err_custom;
    end if;
    --更新状态
    update zjjk_mb_zlfh a
       set a.fhzt    = v_fhzt,
           a.fhczrid = v_czyyhid,
           a.fhczrxm = v_czyyhxm,
           a.fhjgid  = v_czyjgdm,
           a.fhsj    = v_sysdate,
           a.fhyj    = v_fhyj
     where a.fhzt = '2'
       and a.id = v_id
       and a.mblx = '4'
       and a.ccbz = '406'
       and a.zt = '1';
    if sql%rowcount <> 1 then
      v_err := '更新病例复核状态出错!';
      raise err_custom;
    end if;
    update zjjk_mb_zlfh_nxrxa a set a.fhzt = v_fhzt where a.id = v_id;
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_mb_blfh_nxrxa_zt_fh;
  /*-----------------------------------------------------------------------------
  || 功能描述 ：女性乳腺癌病例审核
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_mb_blfh_nxrxa_zt_sh(data_in    IN CLOB, --入参
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
    v_sysdate date;
    v_czyjgjb varchar2(3);
    v_czyjgdm varchar2(50);
    v_czyyhid varchar2(50);
    v_czyyhxm varchar2(50);
    v_count   number;
  
  BEGIN
    json_data(data_in, '女性乳腺癌病例审核', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid');
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    v_czyyhxm := Json_Str(v_Json_Data, 'czyyhxm');
  
    v_id   := Json_Str(v_Json_Data, 'id');
    v_shzt := Json_Str(v_Json_Data, 'fhzt');
    v_shyj := Json_Str(v_Json_Data, 'shyj');
    if v_id is null then
      v_err := 'id不能为空!';
      raise err_custom;
    end if;
    if nvl(v_shzt, '-1') not in ('5', '6') then
      v_err := '审核状态传入有误!';
      raise err_custom;
    end if;
    --更新状态
    update zjjk_mb_zlfh a
       set a.fhzt    = v_shzt,
           a.shczrid = v_czyyhid,
           a.shczrxm = v_czyyhxm,
           a.shjgid  = v_czyjgdm,
           a.shsj    = v_sysdate,
           a.shyj    = v_shyj
     where a.fhzt = '3'
       and a.id = v_id
       and a.mblx = '4'
       and a.ccbz = '406'
       and a.zt = '1';
    if sql%rowcount <> 1 then
      v_err := '更新病例审核状态出错!';
      raise err_custom;
    end if;
    update zjjk_mb_zlfh_nxrxa a set a.fhzt = v_shzt where a.id = v_id;
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_mb_blfh_nxrxa_zt_sh;
  /*-----------------------------------------------------------------------------
  || 功能描述 ：其他恶性肿瘤病例填报
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_mb_blfh_qtexzl_update(data_in    IN CLOB, --入参
                                      result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
  
    --公共变量
    v_sysdate date;
    v_czyjgjb varchar2(3);
    v_czyjgdm varchar2(50);
    v_czyyhid varchar2(50);
    v_czyyhxm varchar2(50);
    v_count   number;
  
    v_id             zjjk_mb_zlfh_qtexzl.id%TYPE; --id
    v_bkdw           zjjk_mb_zlfh_qtexzl.bkdw%TYPE; --报卡单位
    v_zyh            zjjk_mb_zlfh_qtexzl.zyh%TYPE; --住院号
    v_jbxxybgksfyz   zjjk_mb_zlfh_qtexzl.jbxxybgksfyz%TYPE; --基本信息与报告卡是否一致（0 是 1否）
    v_kpzt           zjjk_mb_zlfh_qtexzl.kpzt%TYPE; --卡片状态
    v_blh            zjjk_mb_zlfh_qtexzl.blh%TYPE; --病理号
    v_bgkbm          zjjk_mb_zlfh_qtexzl.bgkbm%TYPE; --报告卡编码
    v_xm             zjjk_mb_zlfh_qtexzl.xm%TYPE; --姓名
    v_xmxg           zjjk_mb_zlfh_qtexzl.xmxg%TYPE; --姓名修改
    v_xb             zjjk_mb_zlfh_qtexzl.xb%TYPE; --性别
    v_xbxg           zjjk_mb_zlfh_qtexzl.xbxg%TYPE; --性别修改
    v_csrq           zjjk_mb_zlfh_qtexzl.csrq%TYPE; --出生日期
    v_csrqxg         zjjk_mb_zlfh_qtexzl.csrqxg%TYPE; --出生日期修改
    v_sfzh           zjjk_mb_zlfh_qtexzl.sfzh%TYPE; --身份证号
    v_sfzhxg         zjjk_mb_zlfh_qtexzl.sfzhxg%TYPE; --身份证号修改
    v_zdrq           zjjk_mb_zlfh_qtexzl.zdrq%TYPE; --诊断日期（发病日期）
    v_zdrqxg         zjjk_mb_zlfh_qtexzl.zdrqxg%TYPE; --诊断日期修改
    v_icd10          zjjk_mb_zlfh_qtexzl.icd10%TYPE; --ICD-10
    v_icd10xg        zjjk_mb_zlfh_qtexzl.icd10xg%TYPE; --ICD-10修改
    v_bgyysfwzdyy    zjjk_mb_zlfh_qtexzl.bgyysfwzdyy%TYPE; --报告医院是否为诊断医院（0 是 1否）
    v_zdyymc         zjjk_mb_zlfh_qtexzl.zdyymc%TYPE; --诊断医院名称
    v_czbajldjttj    zjjk_mb_zlfh_qtexzl.czbajldjttj%TYPE; --查找病案记录的具体途径（0 电子住院记录系统 1 电子以及纸质住院记录名单 2 纸质住院名单 3 其他）
    v_qtczbajldtj    zjjk_mb_zlfh_qtexzl.qtczbajldtj%TYPE; --其他查找病案记录的途径
    v_sfczbdcxgbazl  zjjk_mb_zlfh_qtexzl.sfczbdcxgbazl%TYPE; --是否查找并调出该对象住院诊治的相关病案资料（0 是 1否）
    v_bajlsfdzh      zjjk_mb_zlfh_qtexzl.bajlsfdzh%TYPE; --病案记录是否电子化（0 是 1否）
    v_dzbasjnr       zjjk_mb_zlfh_qtexzl.dzbasjnr%TYPE; --电子病案涉及内容（0 所有病案信息 1 只有病案首页）
    v_wczbdcxgbazlyy zjjk_mb_zlfh_qtexzl.wczbdcxgbazlyy%TYPE; --未查找并调出该对象住院诊治的相关病案资料的可能原因（0 未在住院记录系统中找到相关资料 1 住院病案系统有记录但病案丢失 2 住院病案系统有记录但病案未保存 3 其他）
    v_qtknyy         zjjk_mb_zlfh_qtexzl.qtknyy%TYPE; --其他可能原因
    v_sfcjbasy       zjjk_mb_zlfh_qtexzl.sfcjbasy%TYPE; --是否采集（复印或拍照）医院病案首页（0 是 1否）
    v_sfcjcyxj       zjjk_mb_zlfh_qtexzl.sfcjcyxj%TYPE; --是否采集（复印或拍照）医院出院小结/死亡记录（0 是 1否）
    v_sfcjryjl       zjjk_mb_zlfh_qtexzl.sfcjryjl%TYPE; --是否采集（复印或拍照）医院入院记录（首次病程）（0 是 1否）
    v_sfcjzzxblbg    zjjk_mb_zlfh_qtexzl.sfcjzzxblbg%TYPE; --是否采集（复印或拍照）组织学病理报告（0 是 1否）
    v_sfcjctmrijcbg  zjjk_mb_zlfh_qtexzl.sfcjctmrijcbg%TYPE; --是否采集（复印或拍照）CT/MRI检查报告（0 是 1否）
    v_zyzd           zjjk_mb_zlfh_qtexzl.zyzd%TYPE; --主要诊断
    v_cyhqtzd        zjjk_mb_zlfh_qtexzl.cyhqtzd%TYPE; --次要或其他诊断
    v_chzt           zjjk_mb_zlfh_qtexzl.chzt%TYPE; --存活状态（0存活 1死亡）
    v_wlcdqtjcbg     zjjk_mb_zlfh_qtexzl.wlcdqtjcbg%TYPE; --注明其他采集到上面未列出的检测报告
    v_blcjzqz        zjjk_mb_zlfh_qtexzl.blcjzqz%TYPE; --病例采集者签字
    v_bacjzdw        zjjk_mb_zlfh_qtexzl.bacjzdw%TYPE; --病案采集者单位
    v_fhbgrq         zjjk_mb_zlfh_qtexzl.fhbgrq%TYPE; --复核报告日期
    v_zdyj           zjjk_mb_zlfh_qtexzl.zdyj%TYPE; --诊断依据
    v_zdyjxg         zjjk_mb_zlfh_qtexzl.zdyjxg%TYPE; --诊断依据修改
    v_fhjgpd         zjjk_mb_zlfh_qtexzl.fhjgpd%TYPE; --复核结果判断（0 符合 1不符合）
    v_zlwzx          zjjk_mb_zlfh_qtexzl.zlwzx%TYPE; --资料完整性（0 符合 1不符合）
    v_fhzt           zjjk_mb_zlfh_qtexzl.fhzt%TYPE; --复核状态（0 符合 1不符合）
    v_blxlx          zjjk_mb_zlfh_qtexzl.blxlx%TYPE; --病理学类型
    v_blxlxxg        zjjk_mb_zlfh_qtexzl.blxlxxg%TYPE; --病理学类型修改
    v_basyzp         zjjk_mb_zlfh_qtexzl.basyzp%TYPE;    --（复印或拍照）医院病案首页照片
    v_cyxjzp         zjjk_mb_zlfh_qtexzl.cyxjzp%TYPE;    --（复印或拍照）医院出院小结/死亡记录照片
    v_ryjlzp         zjjk_mb_zlfh_qtexzl.ryjlzp%TYPE;    --（复印或拍照）医院入院记录（首次病程）照片
    v_zzxblbgzp      zjjk_mb_zlfh_qtexzl.zzxblbgzp%TYPE;    --（复印或拍照）组织学病理报告照片
    v_ctmrijcbgzp    zjjk_mb_zlfh_qtexzl.ctmrijcbgzp%TYPE;    --（复印或拍照）CT/MRI检查报告照片
    v_icdo3bm        zjjk_mb_zlfh_qtexzl.icdo3bm%TYPE;    -- ICD-O-3编码
    v_icdo3bmxg      zjjk_mb_zlfh_qtexzl.icdo3bmxg%TYPE;    -- ICD-O-3编码修改
  
    --其他变量
    v_bgkid_s VARCHAR2(2000); --被抽查的报告卡IDs
  
  BEGIN
    json_data(data_in, '女性乳腺癌报告卡病例填报', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid');
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    v_czyyhxm := Json_Str(v_Json_Data, 'czyyhxm');
  
    v_id             := Json_Str(v_Json_Data, 'id');
    v_bkdw           := Json_Str(v_Json_Data, 'bkdw');
    v_zyh            := Json_Str(v_Json_Data, 'zyh');
    v_jbxxybgksfyz   := Json_Str(v_Json_Data, 'jbxxybgksfyz');
    v_kpzt           := Json_Str(v_Json_Data, 'kpzt');
    v_blh            := Json_Str(v_Json_Data, 'blh');
    v_bgkbm          := Json_Str(v_Json_Data, 'bgkbm');
    v_xm             := Json_Str(v_Json_Data, 'xm');
    v_xmxg           := Json_Str(v_Json_Data, 'xmxg');
    v_xb             := Json_Str(v_Json_Data, 'xb');
    v_xbxg           := Json_Str(v_Json_Data, 'xbxg');
    v_csrq           := std(Json_Str(v_Json_Data, 'csrq'), 0);
    v_csrqxg         := Json_Str(v_Json_Data, 'csrqxg');
    v_sfzh           := Json_Str(v_Json_Data, 'sfzh');
    v_sfzhxg         := Json_Str(v_Json_Data, 'sfzhxg');
    v_zdrq           := std(Json_Str(v_Json_Data, 'zdrq'), 0);
    v_zdrqxg         := Json_Str(v_Json_Data, 'zdrqxg');
    v_icd10          := Json_Str(v_Json_Data, 'icd10');
    v_icd10xg        := Json_Str(v_Json_Data, 'icd10xg');
    v_bgyysfwzdyy    := Json_Str(v_Json_Data, 'bgyysfwzdyy');
    v_zdyymc         := Json_Str(v_Json_Data, 'zdyymc');
    v_czbajldjttj    := Json_Str(v_Json_Data, 'czbajldjttj');
    v_qtczbajldtj    := Json_Str(v_Json_Data, 'qtczbajldtj');
    v_sfczbdcxgbazl  := Json_Str(v_Json_Data, 'sfczbdcxgbazl');
    v_bajlsfdzh      := Json_Str(v_Json_Data, 'bajlsfdzh');
    v_dzbasjnr       := Json_Str(v_Json_Data, 'dzbasjnr');
    v_wczbdcxgbazlyy := Json_Str(v_Json_Data, 'wczbdcxgbazlyy');
    v_qtknyy         := Json_Str(v_Json_Data, 'qtknyy');
    v_sfcjbasy       := Json_Str(v_Json_Data, 'sfcjbasy');
    v_sfcjcyxj       := Json_Str(v_Json_Data, 'sfcjcyxj');
    v_sfcjryjl       := Json_Str(v_Json_Data, 'sfcjryjl');
    v_sfcjzzxblbg    := Json_Str(v_Json_Data, 'sfcjzzxblbg');
    v_sfcjctmrijcbg  := Json_Str(v_Json_Data, 'sfcjctmrijcbg');
    v_zyzd           := Json_Str(v_Json_Data, 'zyzd');
    v_cyhqtzd        := Json_Str(v_Json_Data, 'cyhqtzd');
    v_chzt           := Json_Str(v_Json_Data, 'chzt');
    v_wlcdqtjcbg     := Json_Str(v_Json_Data, 'wlcdqtjcbg');
    v_blcjzqz        := Json_Str(v_Json_Data, 'blcjzqz');
    v_bacjzdw        := Json_Str(v_Json_Data, 'bacjzdw');
    v_fhbgrq         := std(Json_Str(v_Json_Data, 'fhbgrq'), 0);
    v_zdyj           := Json_Str(v_Json_Data, 'zdyj');
    v_zdyjxg         := Json_Str(v_Json_Data, 'zdyjxg');
    v_fhjgpd         := Json_Str(v_Json_Data, 'fhjgpd');
    v_blxlx          := Json_Str(v_Json_Data, 'blxlx');
    v_blxlxxg        := Json_Str(v_Json_Data, 'blxlxxg');
    v_zlwzx          := Json_Str(v_Json_Data, 'zlwzx');
    v_basyzp         := Json_Str(v_Json_Data, 'basyzp');
    v_cyxjzp         := Json_Str(v_Json_Data, 'cyxjzp');
    v_ryjlzp         := Json_Str(v_Json_Data, 'ryjlzp');
    v_zzxblbgzp      := Json_Str(v_Json_Data, 'zzxblbgzp');
    v_ctmrijcbgzp    := Json_Str(v_Json_Data, 'ctmrijcbgzp');
    v_icdo3bm        := Json_Str(v_Json_Data, 'icdo3bm');
    v_icdo3bmxg      := Json_Str(v_Json_Data, 'icdo3bmxg');   
  
    --校验权限
    if v_czyjgjb <> '3' then
      --非区县
      v_err := '当前机构无病例填报权限!';
      raise err_custom;
    end if;
  
    --校验状态
    select count(1)
      into v_count
      from zjjk_mb_zlfh a, zjjk_zlfhsj b
     where a.cctjid = b.jlbh
       and b.zt = '1'
       and a.id = v_id
       and a.mblx = '4'
       and a.ccbz = '407'
       and a.zt = '1'
       and nvl(a.fhzt, '0') in ('0', '1', '6');
    if v_count <> 1 then
      v_err := '未找到待填报的病例!';
      raise err_custom;
    end if;
  
    --校验必填项目
    if v_id is null then
      v_err := '报告卡ID不能为空!';
      raise err_custom;
    end if;
    if v_bkdw is null then
      v_err := '报卡单位不能为空!';
      raise err_custom;
    end if;
    if v_jbxxybgksfyz is null then
      v_err := '个人信息判断不能为空!';
      raise err_custom;
    end if;
    if v_kpzt is null then
      v_err := '卡片状态不能为空!';
      raise err_custom;
    end if;
    if v_bgkbm is null then
      v_err := '报告卡编码不能为空!';
      raise err_custom;
    end if;
    if v_xm is null then
      v_err := '姓名不能为空!';
      raise err_custom;
    end if;
    if v_xb is null then
      v_err := '性别不能为空!';
      raise err_custom;
    end if;
    if v_csrq is null then
      v_err := '出生日期不能为空!';
      raise err_custom;
    end if;
    if v_sfzh is null then
      --v_err := '身份证号不能为空!';
      --raise err_custom;
      --如果没有身份证号，则设为否
      v_sfzh:='无';
    end if;
    if v_zdrq is null then
      v_err := '诊断日期（发病日期）不能为空!';
      raise err_custom;
    end if;
    if v_icd10 is null then
      v_err := 'ICD-10不能为空!';
      raise err_custom;
    end if;
    if v_czbajldjttj is null then
      v_err := '查找病案记录的具体途径不能为空!';
      raise err_custom;
    end if;
    if v_qtczbajldtj is null and v_czbajldjttj = '3' then
      v_err := '其他查找病案记录的途径不能为空!';
      raise err_custom;
    end if;
    if v_sfczbdcxgbazl is null then
      v_err := '是否查找并调出该对象住院诊治的相关病案资料不能为空!';
      raise err_custom;
    end if;
    if v_bajlsfdzh is null and v_sfczbdcxgbazl = '0' then
      v_err := '病案记录是否电子化不能为空!';
      raise err_custom;
    end if;
    if v_dzbasjnr is null and v_bajlsfdzh = '0' then
      v_err := '电子病案涉及内容不能为空!';
      raise err_custom;
    end if;
    if v_wczbdcxgbazlyy is null and v_sfczbdcxgbazl = '1' then
      v_err := '未查找并调出该对象住院诊治的相关病案资料的可能原因不能为空!';
      raise err_custom;
    end if;
    if v_qtknyy is null and v_wczbdcxgbazlyy = '3' then
      v_err := '其他可能的原因不能为空!';
      raise err_custom;
    end if;
    if v_sfczbdcxgbazl = '0' then
      if v_sfcjbasy is null then
        v_err := '是否采集（复印或拍照）医院病案首页不能为空!';
        raise err_custom;
      end if;
      if v_sfcjcyxj is null then
        v_err := '是否采集（复印或拍照）医院出院小结/死亡记录不能为空!';
        raise err_custom;
      end if;
      if v_sfcjryjl is null then
        v_err := '是否采集（复印或拍照）医院入院记录（首次病程）不能为空!';
        raise err_custom;
      end if;
    
      if v_sfcjzzxblbg is null then
        v_err := '是否采集（复印或拍照）组织学病理报告不能为空!';
        raise err_custom;
      end if;
      if v_sfcjctmrijcbg is null then
        v_err := '是否采集（复印或拍照）CT/MRI检查报告不能为空!';
        raise err_custom;
      end if;
    
      --if v_blxlx is null then
      --  v_err := '病理学类型不能为空!';
      --  raise err_custom;
      --end if;
      if v_zyzd is null then
        v_err := '主要诊断不能为空!';
        raise err_custom;
      end if;
      if v_chzt is null then
        v_err := '存活状态不能为空!';
        raise err_custom;
      end if;
      if v_blcjzqz is null then
        v_err := '病例采集者签字不能为空!';
        raise err_custom;
      end if;
      if v_bacjzdw is null then
        v_err := '病案采集者单位不能为空!';
        raise err_custom;
      end if;
      if v_fhbgrq is null then
        v_err := '复核报告日期不能为空!';
        raise err_custom;
      end if;
    end if;
    if v_zdyj is null then
      v_err := '诊断依据不能为空!';
      raise err_custom;
    end if;
    if v_zlwzx is null then
      v_err := '病案结果判断不能为空!';
      raise err_custom;
    end if;
  
    --更新资料完整性
    --基本信息判断验证
    if ((v_xmxg IS NULL AND v_xbxg IS NULL AND v_csrqxg IS NULL AND v_sfzhxg IS NULL 
         ) AND v_jbxxybgksfyz='1')
       OR
       ((v_xmxg IS NOT NULL OR v_xbxg IS NOT NULL OR v_csrqxg IS NOT NULL OR v_sfzhxg IS NOT NULL 
         ) AND v_jbxxybgksfyz='0') then
       v_err := '个人信息判断验证不通过!';
      raise err_custom;
    end if;
    
    --病案结果判断验证
    if ((nvl(v_sfcjbasy, '1') <> '0' or nvl(v_sfcjcyxj, '1') <> '0' or
       nvl(v_sfcjryjl, '1') <> '0' or nvl(v_sfcjzzxblbg, '1') <> '0' or
       nvl(v_sfcjctmrijcbg, '1') <> '0') AND v_zlwzx='0')
       OR
       ((nvl(v_sfcjbasy, '1') = '0' AND nvl(v_sfcjcyxj, '1') = '0' AND
       nvl(v_sfcjryjl, '1') = '0' AND nvl(v_sfcjzzxblbg, '1') = '0' AND
       nvl(v_sfcjctmrijcbg, '1') = '0') AND v_zlwzx='1') then
       v_err := '病案结果判断验证不通过!';
      raise err_custom;
    end if;
    
    --综合结果判断验证
    if (v_jbxxybgksfyz = '0' AND v_zlwzx ='0' AND v_fhjgpd='1')
       OR
       ((v_jbxxybgksfyz = '1' OR v_zlwzx ='1') AND v_fhjgpd='0') then
       v_err := '结果判断验证不通过!';
      raise err_custom;
    end if;
    
    --判断新增还是修改
    select count(1)
      into v_count
      from zjjk_mb_zlfh_qtexzl a
     where a.id = v_id;
    if v_count > 0 then
      --修改
      UPDATE zjjk_mb_zlfh_qtexzl
         SET id             = v_id,
             bkdw           = v_bkdw,
             zyh            = v_zyh,
             jbxxybgksfyz   = v_jbxxybgksfyz,
             kpzt           = v_kpzt,
             blh            = v_blh,
             bgkbm          = v_bgkbm,
             xm             = v_xm,
             xmxg           = v_xmxg,
             xb             = v_xb,
             xbxg           = v_xbxg,
             csrq           = v_csrq,
             csrqxg         = v_csrqxg,
             sfzh           = v_sfzh,
             sfzhxg         = v_sfzhxg,
             zdrq           = v_zdrq,
             zdrqxg         = v_zdrqxg,
             icd10          = v_icd10,
             icd10xg        = v_icd10xg,
             bgyysfwzdyy    = v_bgyysfwzdyy,
             zdyymc         = v_zdyymc,
             czbajldjttj    = v_czbajldjttj,
             qtczbajldtj    = v_qtczbajldtj,
             sfczbdcxgbazl  = v_sfczbdcxgbazl,
             bajlsfdzh      = v_bajlsfdzh,
             dzbasjnr       = v_dzbasjnr,
             wczbdcxgbazlyy = v_wczbdcxgbazlyy,
             qtknyy         = v_qtknyy,
             sfcjbasy       = v_sfcjbasy,
             sfcjcyxj       = v_sfcjcyxj,
             sfcjryjl       = v_sfcjryjl,
             sfcjzzxblbg    = v_sfcjzzxblbg,
             sfcjctmrijcbg  = v_sfcjctmrijcbg,
             zyzd           = v_zyzd,
             cyhqtzd        = v_cyhqtzd,
             chzt           = v_chzt,
             wlcdqtjcbg     = v_wlcdqtjcbg,
             blcjzqz        = v_blcjzqz,
             bacjzdw        = v_bacjzdw,
             fhbgrq         = v_fhbgrq,
             zdyj           = v_zdyj,
             zdyjxg         = v_zdyjxg,
             fhjgpd         = v_fhjgpd,
             zlwzx          = v_zlwzx,
             xgrid          = v_czyyhid,
             xgrxm          = v_czyyhxm,
             xgsj           = v_sysdate,
             blxlx          = v_blxlx,
             blxlxxg        = v_blxlxxg,
             fhzt           = '1',
             basyzp         = v_basyzp,
             cyxjzp         = v_cyxjzp,
             ryjlzp         = v_ryjlzp,
             zzxblbgzp      = v_zzxblbgzp,
             icdo3bm        = v_icdo3bm,
             icdo3bmxg     = v_icdo3bmxg,             
             ctmrijcbgzp    = v_ctmrijcbgzp
       WHERE id = v_id;
    
    else
      --新增
      INSERT INTO zjjk_mb_zlfh_qtexzl
        (id,
         bkdw,
         zyh,
         jbxxybgksfyz,
         kpzt,
         blh,
         bgkbm,
         xm,
         xmxg,
         xb,
         xbxg,
         csrq,
         csrqxg,
         sfzh,
         sfzhxg,
         zdrq,
         zdrqxg,
         icd10,
         icd10xg,
         bgyysfwzdyy,
         zdyymc,
         czbajldjttj,
         qtczbajldtj,
         sfczbdcxgbazl,
         bajlsfdzh,
         dzbasjnr,
         wczbdcxgbazlyy,
         qtknyy,
         sfcjbasy,
         sfcjcyxj,
         sfcjryjl,
         sfcjzzxblbg,
         sfcjctmrijcbg,
         zyzd,
         cyhqtzd,
         chzt,
         wlcdqtjcbg,
         blcjzqz,
         bacjzdw,
         fhbgrq,
         zdyj,
         zdyjxg,
         fhjgpd,
         zlwzx,
         fhzt,
         cjrid,
         cjrxm,
         cjsj,
         xgrid,
         xgrxm,
         xgsj,
         blxlx,
         blxlxxg,
         basyzp,
         cyxjzp,
         ryjlzp,
         zzxblbgzp,
         icdo3bm,
         icdo3bmxg,         
         ctmrijcbgzp)
      VALUES
        (v_id,
         v_bkdw,
         v_zyh,
         v_jbxxybgksfyz,
         v_kpzt,
         v_blh,
         v_bgkbm,
         v_xm,
         v_xmxg,
         v_xb,
         v_xbxg,
         v_csrq,
         v_csrqxg,
         v_sfzh,
         v_sfzhxg,
         v_zdrq,
         v_zdrqxg,
         v_icd10,
         v_icd10xg,
         v_bgyysfwzdyy,
         v_zdyymc,
         v_czbajldjttj,
         v_qtczbajldtj,
         v_sfczbdcxgbazl,
         v_bajlsfdzh,
         v_dzbasjnr,
         v_wczbdcxgbazlyy,
         v_qtknyy,
         v_sfcjbasy,
         v_sfcjcyxj,
         v_sfcjryjl,
         v_sfcjzzxblbg,
         v_sfcjctmrijcbg,
         v_zyzd,
         v_cyhqtzd,
         v_chzt,
         v_wlcdqtjcbg,
         v_blcjzqz,
         v_bacjzdw,
         v_fhbgrq,
         v_zdyj,
         v_zdyjxg,
         v_fhjgpd,
         v_zlwzx,
         '1',
         v_czyyhid,
         v_czyyhxm,
         v_sysdate,
         v_czyyhid,
         v_czyyhxm,
         v_sysdate,
         v_blxlx,
         v_blxlxxg,
         v_basyzp,
         v_cyxjzp,
         v_ryjlzp,
         v_zzxblbgzp,
         v_icdo3bm,
         v_icdo3bmxg,         
         v_ctmrijcbgzp);
    
    end if;
    --更新复核状态
    update zjjk_mb_zlfh a
       set a.fhzt = '1', a.fhbz = '1'
     where a.id = v_id
       and a.mblx = '4'
       and a.ccbz = '407';
    --返回
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_mb_blfh_qtexzl_update;
  /*-----------------------------------------------------------------------------
  || 功能描述 ：其他恶性肿瘤病例提交
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_mb_blfh_qtexzl_zt_tj(data_in    IN CLOB, --入参
                                     result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
  
    v_id zjjk_mb_zlfh.id%TYPE; --ID
    --公共变量
    v_sysdate date;
    v_czyjgjb varchar2(3);
    v_czyjgdm varchar2(50);
    v_czyyhid varchar2(50);
    v_czyyhxm varchar2(50);
    v_count   number;
  
  BEGIN
    json_data(data_in, '其他恶性肿瘤病例提交', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid');
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    v_czyyhxm := Json_Str(v_Json_Data, 'czyyhxm');
  
    v_id := Json_Str(v_Json_Data, 'id');
    if v_id is null then
      v_err := 'id不能为空!';
      raise err_custom;
    end if;
    --更新状态
    update zjjk_mb_zlfh a
       set a.fhzt = '3',
           a.fhczrid = v_czyyhid,
           a.fhczrxm = v_czyyhxm,
           a.fhjgid  = v_czyjgdm,
           a.fhsj    = v_sysdate
     where a.fhzt = '1'
       and a.id = v_id
       and a.mblx = '4'
       and a.ccbz = '407'
       and a.zt = '1';
    if sql%rowcount <> 1 then
      v_err := '更新病例状态出错!';
      raise err_custom;
    end if;
    update zjjk_mb_zlfh_qtexzl a set a.fhzt = '3' where a.id = v_id;
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_mb_blfh_qtexzl_zt_tj;
  /*-----------------------------------------------------------------------------
  || 功能描述 ：其他恶性肿瘤病例复核
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_mb_blfh_qtexzl_zt_fh(data_in    IN CLOB, --入参
                                     result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err  VARCHAR2(2000);
    v_id   zjjk_mb_zlfh.id%TYPE; --ID
    v_fhzt zjjk_mb_zlfh.fhzt%TYPE; --ID
    v_fhyj zjjk_mb_zlfh.fhyj%TYPE; --复核意见
  
    --公共变量
    v_sysdate date;
    v_czyjgjb varchar2(3);
    v_czyjgdm varchar2(50);
    v_czyyhid varchar2(50);
    v_czyyhxm varchar2(50);
    v_count   number;
  
  BEGIN
    json_data(data_in, '其他恶性肿瘤病例复核', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid');
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    v_czyyhxm := Json_Str(v_Json_Data, 'czyyhxm');
  
    v_id   := Json_Str(v_Json_Data, 'id');
    v_fhzt := Json_Str(v_Json_Data, 'fhzt');
    v_fhyj := Json_Str(v_Json_Data, 'fhyj');
    if v_id is null then
      v_err := 'id不能为空!';
      raise err_custom;
    end if;
    if nvl(v_fhzt, '-1') not in ('3', '4') then
      v_err := '复核状态传入有误!';
      raise err_custom;
    end if;
    --更新状态
    update zjjk_mb_zlfh a
       set a.fhzt    = v_fhzt,
           a.fhczrid = v_czyyhid,
           a.fhczrxm = v_czyyhxm,
           a.fhjgid  = v_czyjgdm,
           a.fhsj    = v_sysdate,
           a.fhyj    = v_fhyj
     where a.fhzt = '2'
       and a.id = v_id
       and a.mblx = '4'
       and a.ccbz = '407'
       and a.zt = '1';
    if sql%rowcount <> 1 then
      v_err := '更新病例复核状态出错!';
      raise err_custom;
    end if;
    update zjjk_mb_zlfh_qtexzl a set a.fhzt = v_fhzt where a.id = v_id;
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_mb_blfh_qtexzl_zt_fh;
  /*-----------------------------------------------------------------------------
  || 功能描述 ：其他恶性肿瘤病例审核
  ||----------------------------------------------------------------------------*/
  PROCEDURE prc_mb_blfh_qtexzl_zt_sh(data_in    IN CLOB, --入参
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
    v_sysdate date;
    v_czyjgjb varchar2(3);
    v_czyjgdm varchar2(50);
    v_czyyhid varchar2(50);
    v_czyyhxm varchar2(50);
    v_count   number;
  
  BEGIN
    json_data(data_in, '其他恶性肿瘤病例审核', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid');
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    v_czyyhxm := Json_Str(v_Json_Data, 'czyyhxm');
  
    v_id   := Json_Str(v_Json_Data, 'id');
    v_shzt := Json_Str(v_Json_Data, 'fhzt');
    v_shyj := Json_Str(v_Json_Data, 'shyj');
    if v_id is null then
      v_err := 'id不能为空!';
      raise err_custom;
    end if;
    if nvl(v_shzt, '-1') not in ('5', '6') then
      v_err := '审核状态传入有误!';
      raise err_custom;
    end if;
    --更新状态
    update zjjk_mb_zlfh a
       set a.fhzt    = v_shzt,
           a.shczrid = v_czyyhid,
           a.shczrxm = v_czyyhxm,
           a.shjgid  = v_czyjgdm,
           a.shsj    = v_sysdate,
           a.shyj    = v_shyj
     where a.fhzt = '3'
       and a.id = v_id
       and a.mblx = '4'
       and a.ccbz = '407'
       and a.zt = '1';
    if sql%rowcount <> 1 then
      v_err := '更新病例审核状态出错!';
      raise err_custom;
    end if;
    update zjjk_mb_zlfh_qtexzl a set a.fhzt = v_shzt where a.id = v_id;
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_mb_blfh_qtexzl_zt_sh;
END pkg_zjmb_zlfh_bgk;
