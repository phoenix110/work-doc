CREATE OR REPLACE PACKAGE BODY pkg_zjmb_xtfz AS
  --初始化包序号--
  /******************************************************************************/
  /*  程序包名 ：pkg_zjmb_xtfz                                                  */
  /*  业务环节 ：浙江慢病_系统辅助                                           */
  /*  功能描述 ：为慢病生命统计相关的存储过程及函数                           */
  /*                                                                            */
  /*  作    者 ：          作成日期 ：2018-06-04   版本编号 ：Ver 1.0.0  */
  /*----------------------------------------------------------------------------*/
  /*  修改记录 ：                                                               */
  /******************************************************************************/
  /*-------------------------------------------------------------------------*/
  /*-------------------------------------------------------------------------*/
  /*--------------------------------------------------------------------------
  || 功能描述 ：告卡导入
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_bgk_excel_imp(Data_In    In Clob, --入参
                              result_out OUT VARCHAR2) --返回
   is
    v_json_data   json;
    v_json_return json := json();
    v_json_yw_log json;
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
  
    --公共变量
    v_sysdate       date;
    v_czyjgdm       varchar2(50);
    v_czyjgjb       varchar2(3);
    v_czyyhid       varchar2(50);
    v_json_list_xls json_List; --报告卡汇总信息
    v_json_list_bgk json_List; --各分类报卡
    v_json_temp_bgk Json;
    v_vc_bgkid      zjjk_csbgk_temp.vc_bgkid%type;
    v_vc_drbz       zjjk_csbgk_temp.vc_drbz%type;
    v_vc_dryhmc     zjjk_csbgk_temp.vc_dryhmc%type;
    v_bgk_index     varchar(100);
    v_count         number;
    v_id            varchar2(100);
    v_orders        VARCHAR2(2); --是否能导入系统标志（1-是 0-否）
    v_zxrq          date;
  
  BEGIN
    json_data(data_in, '报告卡EXCEL导入', v_json_data);
    v_sysdate       := sysdate;
    v_czyjgdm       := Json_Str(v_Json_Data, 'czyjgdm'); --操作员机构代码
    v_czyyhid       := Json_Str(v_Json_Data, 'czyyhid');
    v_czyjgjb       := Json_Str(v_Json_Data, 'czyjgjb'); --获取机构级别
    v_json_list_xls := Json_Ext.Get_Json_List(v_Json_Data, 'bgk_arr'); --出生信息
  
    if v_czyjgdm is null then
      v_err := '未获取到操作员信息!';
      raise err_custom;
    end if;
    if v_czyjgjb not in ('1', '2', '3', '4') then
      v_err := '当前机构无导入权限!';
      raise err_custom;
    end if;
    --organ_node
    --SELECT FROM 
  
    v_sysdate := sysdate;
    v_zxrq    := to_date('1900-01-01', 'yyyy-MM-dd');
    --写入数据
    if v_json_list_xls.count > 0 then
      for i in 1 .. v_json_list_xls.count loop
        --获取各分类报卡：1-肿瘤报卡，2-肿瘤患者信息，3-糖尿病报告卡，4-糖尿病患者信息，5-心脑血管报告卡，6-伤害报告卡，7-死因报告卡
        v_json_list_bgk := Json_List(v_json_list_xls.Get(i));
        if v_json_list_bgk.count > 0 then
          for j in 1 .. v_json_list_bgk.count loop
            if i = 1 then
              v_bgk_index     := '肿瘤报卡：第' || j || '行,';
              v_json_temp_bgk := Json(v_json_list_bgk.Get(j));
              --校验数据合法性
              if (Json_Str(v_json_temp_bgk, 'dt_yzdrq') is not null and
                 std(Json_Str(v_json_temp_bgk, 'dt_yzdrq'), 0) is null) or
                 std(Json_Str(v_json_temp_bgk, 'dt_yzdrq'), 0) < v_zxrq then
                v_err := v_bgk_index || '原诊断日期格式有误';
                raise err_custom;
              end if;
              if (Json_Str(v_json_temp_bgk, 'dt_zdrq') is not null and
                 std(Json_Str(v_json_temp_bgk, 'dt_zdrq'), 0) is null) or
                 nvl(std(Json_Str(v_json_temp_bgk, 'dt_zdrq'), 0), sysdate) < v_zxrq then
                v_err := v_bgk_index || '首次诊断日期格式有误';
                raise err_custom;
              end if;
              if (Json_Str(v_json_temp_bgk, 'dt_bgrq') is not null and
                 std(Json_Str(v_json_temp_bgk, 'dt_bgrq'), 0) is null) or
                 nvl(std(Json_Str(v_json_temp_bgk, 'dt_bgrq'), 0),sysdate) < v_zxrq then
                v_err := v_bgk_index || '报告日期格式有误';
                raise err_custom;
              end if;
              if (Json_Str(v_json_temp_bgk, 'dt_swrq') is not null and
                 std(Json_Str(v_json_temp_bgk, 'dt_swrq'), 0) is null) or
                 nvl(std(Json_Str(v_json_temp_bgk, 'dt_swrq'), 0),sysdate) < v_zxrq then
                v_err := v_bgk_index || '死亡日期格式有误';
                raise err_custom;
              end if;
              --检查是否已导入
              v_id := Json_Str(v_json_temp_bgk, 'vc_yyrid');
              select count(1)
                into v_count
                from zjjk_zl_bgk_ex a
               where a.vc_yyrid = v_id;
              if v_count = 0 then
                --写入excel临时表
                insert into zjjk_zl_bgk_ex
                  (vc_yyrid,
                   vc_bqygzbr,
                   vc_mzh,
                   vc_zyh,
                   vc_hzid,
                   vc_icd9,
                   vc_icdm,
                   vc_icdo,
                   vc_dlw,
                   vc_zdbw,
                   vc_zdbmms,
                   vc_blxlx,
                   vc_blh,
                   vc_zdsqb,
                   vc_zdqbt,
                   vc_zdqbn,
                   vc_zdqbm,
                   dt_yzdrq,
                   dt_zdrq,
                   vc_zgzddw,
                   vc_yzd,
                   vc_bgdw,
                   vc_bgys,
                   dt_bgrq,
                   dt_swrq,
                   vc_swyy,
                   vc_swicd10,
                   vc_zdyh,
                   vc_bszy,
                   vc_swicdmc,
                   vc_shbz,
                   validate_date)
                values
                  (v_id,
                   Json_Str(v_json_temp_bgk, 'vc_bqygzbr'),
                   Json_Str(v_json_temp_bgk, 'vc_mzh'),
                   Json_Str(v_json_temp_bgk, 'vc_zyh'),
                   Json_Str(v_json_temp_bgk, 'vc_hzid'),
                   Json_Str(v_json_temp_bgk, 'vc_icd9'),
                   Json_Str(v_json_temp_bgk, 'vc_icdm'),
                   Json_Str(v_json_temp_bgk, 'vc_icdo'),
                   Json_Str(v_json_temp_bgk, 'vc_dlw'),
                   Json_Str(v_json_temp_bgk, 'vc_zdbw'),
                   Json_Str(v_json_temp_bgk, 'vc_zdbmms'),
                   Json_Str(v_json_temp_bgk, 'vc_blxlx'),
                   Json_Str(v_json_temp_bgk, 'vc_blh'),
                   Json_Str(v_json_temp_bgk, 'vc_zdsqb'),
                   Json_Str(v_json_temp_bgk, 'vc_zdqbt'),
                   Json_Str(v_json_temp_bgk, 'vc_zdqbn'),
                   Json_Str(v_json_temp_bgk, 'vc_zdqbm'),
                   std(Json_Str(v_json_temp_bgk, 'dt_yzdrq'), 0),
                   std(Json_Str(v_json_temp_bgk, 'dt_zdrq'), 0),
                   Json_Str(v_json_temp_bgk, 'vc_zgzddw'),
                   Json_Str(v_json_temp_bgk, 'vc_yzd'),
                   Json_Str(v_json_temp_bgk, 'vc_bgdw'),
                   Json_Str(v_json_temp_bgk, 'vc_bgys'),
                   std(Json_Str(v_json_temp_bgk, 'dt_bgrq'), 0),
                   std(Json_Str(v_json_temp_bgk, 'dt_swrq'), 0),
                   Json_Str(v_json_temp_bgk, 'vc_swyy'),
                   Json_Str(v_json_temp_bgk, 'vc_swicd10'),
                   Json_Str(v_json_temp_bgk, 'vc_zdyh'),
                   Json_Str(v_json_temp_bgk, 'vc_bszy'),
                   Json_Str(v_json_temp_bgk, 'vc_swicdmc'),
                   Json_Str(v_json_temp_bgk, 'vc_shbz'),
                   v_sysdate);
              else
                --更新
                update zjjk_zl_bgk_ex
                   set vc_bqygzbr    = Json_Str(v_json_temp_bgk,
                                                'vc_bqygzbr'),
                       vc_mzh        = Json_Str(v_json_temp_bgk, 'vc_mzh'),
                       vc_zyh        = Json_Str(v_json_temp_bgk, 'vc_zyh'),
                       vc_hzid       = Json_Str(v_json_temp_bgk, 'vc_hzid'),
                       vc_icd9       = Json_Str(v_json_temp_bgk, 'vc_icd9'),
                       vc_icdm       = Json_Str(v_json_temp_bgk, 'vc_icdm'),
                       vc_icdo       = Json_Str(v_json_temp_bgk, 'vc_icdo'),
                       vc_dlw        = Json_Str(v_json_temp_bgk, 'vc_dlw'),
                       vc_zdbw       = Json_Str(v_json_temp_bgk, 'vc_zdbw'),
                       vc_zdbmms     = Json_Str(v_json_temp_bgk, 'vc_zdbmms'),
                       vc_blxlx      = Json_Str(v_json_temp_bgk, 'vc_blxlx'),
                       vc_blh        = Json_Str(v_json_temp_bgk, 'vc_blh'),
                       vc_zdsqb      = Json_Str(v_json_temp_bgk, 'vc_zdsqb'),
                       vc_zdqbt      = Json_Str(v_json_temp_bgk, 'vc_zdqbt'),
                       vc_zdqbn      = Json_Str(v_json_temp_bgk, 'vc_zdqbn'),
                       vc_zdqbm      = Json_Str(v_json_temp_bgk, 'vc_zdqbm'),
                       dt_yzdrq      = std(Json_Str(v_json_temp_bgk,
                                                    'dt_yzdrq'),
                                           0),
                       dt_zdrq       = std(Json_Str(v_json_temp_bgk,
                                                    'dt_zdrq'),
                                           0),
                       vc_zgzddw     = Json_Str(v_json_temp_bgk, 'vc_zgzddw'),
                       vc_yzd        = Json_Str(v_json_temp_bgk, 'vc_yzd'),
                       vc_bgdw       = Json_Str(v_json_temp_bgk, 'vc_bgdw'),
                       vc_bgys       = Json_Str(v_json_temp_bgk, 'vc_bgys'),
                       dt_bgrq       = std(Json_Str(v_json_temp_bgk,
                                                    'dt_bgrq'),
                                           0),
                       dt_swrq       = std(Json_Str(v_json_temp_bgk,
                                                    'dt_swrq'),
                                           0),
                       vc_swyy       = Json_Str(v_json_temp_bgk, 'vc_swyy'),
                       vc_swicd10    = Json_Str(v_json_temp_bgk,
                                                'vc_swicd10'),
                       vc_zdyh       = Json_Str(v_json_temp_bgk, 'vc_zdyh'),
                       vc_bszy       = Json_Str(v_json_temp_bgk, 'vc_bszy'),
                       vc_swicdmc    = Json_Str(v_json_temp_bgk,
                                                'vc_swicdmc'),
                       vc_shbz       = Json_Str(v_json_temp_bgk, 'vc_shbz'),
                       validate_date = v_sysdate
                 where vc_yyrid = v_id;
              end if;
            elsif i = 2 then
              v_bgk_index     := '肿瘤患者信息：第' || j || '行,';
              v_json_temp_bgk := Json(v_json_list_bgk.Get(j));
              --校验数据合法性
              if (Json_Str(v_json_temp_bgk, 'dt_hzcsrq') is not null and
                 std(Json_Str(v_json_temp_bgk, 'dt_hzcsrq'), 0) is null) or
                 nvl(std(Json_Str(v_json_temp_bgk, 'dt_hzcsrq'), 0),sysdate) < v_zxrq then
                v_err := v_bgk_index || '患者出生日期格式有误';
                raise err_custom;
              end if;
              --检查是否已导入
              v_id := Json_Str(v_json_temp_bgk, 'vc_personid');
              select count(1)
                into v_count
                from ZJJK_ZL_HZXX_EX a
               where a.vc_personid = v_id;
              if v_count = 0 then
                --写入excel临时表
                insert into ZJJK_ZL_HZXX_EX
                  (vc_personid,
                   vc_hzxm,
                   vc_hzxb,
                   vc_hzmz,
                   dt_hzcsrq,
                   vc_sfzh,
                   vc_jtdh,
                   vc_zydm,
                   vc_gzdw,
                   vc_jtgz,
                   vc_hksfdm,
                   vc_hksdm,
                   vc_hkqxdm,
                   vc_hkjddm,
                   vc_hkjwdm,
                   vc_hkxxdz,
                   vc_sjsfdm,
                   vc_sjsdm,
                   vc_sjqxdm,
                   vc_sjjddm,
                   vc_sjjwdm,
                   vc_sjxxdz,
                   validate_date)
                values
                  (v_id,
                   Json_Str(v_json_temp_bgk, 'vc_hzxm'),
                   Json_Str(v_json_temp_bgk, 'vc_hzxb'),
                   Json_Str(v_json_temp_bgk, 'vc_hzmz'),
                   std(Json_Str(v_json_temp_bgk, 'dt_hzcsrq'), 0),
                   Json_Str(v_json_temp_bgk, 'vc_sfzh'),
                   Json_Str(v_json_temp_bgk, 'vc_jtdh'),
                   Json_Str(v_json_temp_bgk, 'vc_zydm'),
                   Json_Str(v_json_temp_bgk, 'vc_gzdw'),
                   Json_Str(v_json_temp_bgk, 'vc_jtgz'),
                   Json_Str(v_json_temp_bgk, 'vc_hksfdm'),
                   Json_Str(v_json_temp_bgk, 'vc_hksdm'),
                   Json_Str(v_json_temp_bgk, 'vc_hkqxdm'),
                   Json_Str(v_json_temp_bgk, 'vc_hkjddm'),
                   Json_Str(v_json_temp_bgk, 'vc_hkjwdm'),
                   Json_Str(v_json_temp_bgk, 'vc_hkxxdz'),
                   Json_Str(v_json_temp_bgk, 'vc_sjsfdm'),
                   Json_Str(v_json_temp_bgk, 'vc_sjsdm'),
                   Json_Str(v_json_temp_bgk, 'vc_sjqxdm'),
                   Json_Str(v_json_temp_bgk, 'vc_sjjddm'),
                   Json_Str(v_json_temp_bgk, 'vc_sjjwdm'),
                   Json_Str(v_json_temp_bgk, 'vc_sjxxdz'),
                   v_sysdate);
              else
                update ZJJK_ZL_HZXX_EX
                   set vc_hzxm       = Json_Str(v_json_temp_bgk, 'vc_hzxm'),
                       vc_hzxb       = Json_Str(v_json_temp_bgk, 'vc_hzxb'),
                       vc_hzmz       = Json_Str(v_json_temp_bgk, 'vc_hzmz'),
                       dt_hzcsrq     = std(Json_Str(v_json_temp_bgk,
                                                    'dt_hzcsrq'),
                                           0),
                       vc_sfzh       = Json_Str(v_json_temp_bgk, 'vc_sfzh'),
                       vc_jtdh       = Json_Str(v_json_temp_bgk, 'vc_jtdh'),
                       vc_zydm       = Json_Str(v_json_temp_bgk, 'vc_zydm'),
                       vc_gzdw       = Json_Str(v_json_temp_bgk, 'vc_gzdw'),
                       vc_jtgz       = Json_Str(v_json_temp_bgk, 'vc_jtgz'),
                       vc_hksfdm     = Json_Str(v_json_temp_bgk, 'vc_hksfdm'),
                       vc_hksdm      = Json_Str(v_json_temp_bgk, 'vc_hksdm'),
                       vc_hkqxdm     = Json_Str(v_json_temp_bgk, 'vc_hkqxdm'),
                       vc_hkjddm     = Json_Str(v_json_temp_bgk, 'vc_hkjddm'),
                       vc_hkjwdm     = Json_Str(v_json_temp_bgk, 'vc_hkjwdm'),
                       vc_hkxxdz     = Json_Str(v_json_temp_bgk, 'vc_hkxxdz'),
                       vc_sjsfdm     = Json_Str(v_json_temp_bgk, 'vc_sjsfdm'),
                       vc_sjsdm      = Json_Str(v_json_temp_bgk, 'vc_sjsdm'),
                       vc_sjqxdm     = Json_Str(v_json_temp_bgk, 'vc_sjqxdm'),
                       vc_sjjddm     = Json_Str(v_json_temp_bgk, 'vc_sjjddm'),
                       vc_sjjwdm     = Json_Str(v_json_temp_bgk, 'vc_sjjwdm'),
                       vc_sjxxdz     = Json_Str(v_json_temp_bgk, 'vc_sjxxdz'),
                       validate_date = v_sysdate
                 where vc_personid = v_id;
              end if;
            elsif i = 3 then
              v_bgk_index     := '糖尿病报告卡：第' || j || '行,';
              v_json_temp_bgk := Json(v_json_list_bgk.Get(j));
              --校验数据合法性
              if (Json_Str(v_json_temp_bgk, 'dt_sczdrq') is not null and
                 std(Json_Str(v_json_temp_bgk, 'dt_sczdrq'), 0) is null) or
                 nvl(std(Json_Str(v_json_temp_bgk, 'dt_sczdrq'), 0),sysdate) < v_zxrq then
                v_err := v_bgk_index || '首次诊断日期格式有误';
                raise err_custom;
              end if;
              if (Json_Str(v_json_temp_bgk, 'dt_bgrq') is not null and
                 std(Json_Str(v_json_temp_bgk, 'dt_bgrq'), 0) is null) or
                 nvl(std(Json_Str(v_json_temp_bgk, 'dt_bgrq'), 0),sysdate) < v_zxrq then
                v_err := v_bgk_index || '报告日期格式有误';
                raise err_custom;
              end if;
              if (Json_Str(v_json_temp_bgk, 'dt_swrq') is not null and
                 std(Json_Str(v_json_temp_bgk, 'dt_swrq'), 0) is null) or
                 nvl(std(Json_Str(v_json_temp_bgk, 'dt_swrq'), 0),sysdate) < v_zxrq then
                v_err := v_bgk_index || '死亡日期格式有误';
                raise err_custom;
              end if;
              --检查是否已导入
              v_id := Json_Str(v_json_temp_bgk, 'vc_yyrid');
              select count(1)
                into v_count
                from ZJJK_TNB_BGK_EX a
               where a.vc_yyrid = v_id;
              if v_count = 0 then
                insert into ZJJK_TNB_BGK_EX
                  (vc_yyrid,
                   vc_icd10,
                   vc_tnblx,
                   vc_wxys,
                   vc_wxystz,
                   vc_wxyssg,
                   vc_tnbs,
                   vc_jzsrs,
                   vc_ywbfz,
                   vc_zslcbx,
                   vc_zslcbxqt,
                   nb_kfxtz,
                   nb_sjxtz,
                   nb_xjptt,
                   nb_zdgc,
                   nb_e4hdlc,
                   nb_e5ldlc,
                   nb_gysz,
                   nb_nwldb,
                   nbthxhdb,
                   vc_bszyqt,
                   dt_sczdrq,
                   vc_zddw,
                   vc_bgdw,
                   vc_bgys,
                   dt_bgrq,
                   dt_swrq,
                   vc_swyy,
                   vc_swicd10,
                   vc_swicdmc,
                   vc_hzid,
                   vc_zyh,
                   vc_mzh,
                   vc_shbz,
                   validate_date)
                values
                  (Json_Str(v_json_temp_bgk, 'vc_yyrid'),
                   Json_Str(v_json_temp_bgk, 'vc_icd10'),
                   Json_Str(v_json_temp_bgk, 'vc_tnblx'),
                   Json_Str(v_json_temp_bgk, 'vc_wxys'),
                   Json_Str(v_json_temp_bgk, 'vc_wxystz'),
                   Json_Str(v_json_temp_bgk, 'vc_wxyssg'),
                   Json_Str(v_json_temp_bgk, 'vc_tnbs'),
                   Json_Str(v_json_temp_bgk, 'vc_jzsrs'),
                   Json_Str(v_json_temp_bgk, 'vc_ywbfz'),
                   Json_Str(v_json_temp_bgk, 'vc_zslcbx'),
                   Json_Str(v_json_temp_bgk, 'vc_zslcbxqt'),
                   Json_Str(v_json_temp_bgk, 'nb_kfxtz'),
                   Json_Str(v_json_temp_bgk, 'nb_sjxtz'),
                   Json_Str(v_json_temp_bgk, 'nb_xjptt'),
                   Json_Str(v_json_temp_bgk, 'nb_zdgc'),
                   Json_Str(v_json_temp_bgk, 'nb_e4hdlc'),
                   Json_Str(v_json_temp_bgk, 'nb_e5ldlc'),
                   Json_Str(v_json_temp_bgk, 'nb_gysz'),
                   Json_Str(v_json_temp_bgk, 'nb_nwldb'),
                   Json_Str(v_json_temp_bgk, 'nbthxhdb'),
                   Json_Str(v_json_temp_bgk, 'vc_bszyqt'),
                   std(Json_Str(v_json_temp_bgk, 'dt_sczdrq'), 0),
                   Json_Str(v_json_temp_bgk, 'vc_zddw'),
                   Json_Str(v_json_temp_bgk, 'vc_bgdw'),
                   Json_Str(v_json_temp_bgk, 'vc_bgys'),
                   std(Json_Str(v_json_temp_bgk, 'dt_bgrq'), 0),
                   std(Json_Str(v_json_temp_bgk, 'dt_swrq'), 0),
                   Json_Str(v_json_temp_bgk, 'vc_swyy'),
                   Json_Str(v_json_temp_bgk, 'vc_swicd10'),
                   Json_Str(v_json_temp_bgk, 'vc_swicdmc'),
                   Json_Str(v_json_temp_bgk, 'vc_hzid'),
                   Json_Str(v_json_temp_bgk, 'vc_zyh'),
                   Json_Str(v_json_temp_bgk, 'vc_mzh'),
                   Json_Str(v_json_temp_bgk, 'vc_shbz'),
                   v_sysdate);
              else
                update ZJJK_TNB_BGK_EX
                   set vc_icd10      = Json_Str(v_json_temp_bgk, 'vc_icd10'),
                       vc_tnblx      = Json_Str(v_json_temp_bgk, 'vc_tnblx'),
                       vc_wxys       = Json_Str(v_json_temp_bgk, 'vc_wxys'),
                       vc_wxystz     = Json_Str(v_json_temp_bgk, 'vc_wxystz'),
                       vc_wxyssg     = Json_Str(v_json_temp_bgk, 'vc_wxyssg'),
                       vc_tnbs       = Json_Str(v_json_temp_bgk, 'vc_tnbs'),
                       vc_jzsrs      = Json_Str(v_json_temp_bgk, 'vc_jzsrs'),
                       vc_ywbfz      = Json_Str(v_json_temp_bgk, 'vc_ywbfz'),
                       vc_zslcbx     = Json_Str(v_json_temp_bgk, 'vc_zslcbx'),
                       vc_zslcbxqt   = Json_Str(v_json_temp_bgk,
                                                'vc_zslcbxqt'),
                       nb_kfxtz      = Json_Str(v_json_temp_bgk, 'nb_kfxtz'),
                       nb_sjxtz      = Json_Str(v_json_temp_bgk, 'nb_sjxtz'),
                       nb_xjptt      = Json_Str(v_json_temp_bgk, 'nb_xjptt'),
                       nb_zdgc       = Json_Str(v_json_temp_bgk, 'nb_zdgc'),
                       nb_e4hdlc     = Json_Str(v_json_temp_bgk, 'nb_e4hdlc'),
                       nb_e5ldlc     = Json_Str(v_json_temp_bgk, 'nb_e5ldlc'),
                       nb_gysz       = Json_Str(v_json_temp_bgk, 'nb_gysz'),
                       nb_nwldb      = Json_Str(v_json_temp_bgk, 'nb_nwldb'),
                       nbthxhdb      = Json_Str(v_json_temp_bgk, 'nbthxhdb'),
                       vc_bszyqt     = Json_Str(v_json_temp_bgk, 'vc_bszyqt'),
                       dt_sczdrq     = std(Json_Str(v_json_temp_bgk,
                                                    'dt_sczdrq'),
                                           0),
                       vc_zddw       = Json_Str(v_json_temp_bgk, 'vc_zddw'),
                       vc_bgdw       = Json_Str(v_json_temp_bgk, 'vc_bgdw'),
                       vc_bgys       = Json_Str(v_json_temp_bgk, 'vc_bgys'),
                       dt_bgrq       = std(Json_Str(v_json_temp_bgk,
                                                    'dt_bgrq'),
                                           0),
                       dt_swrq       = std(Json_Str(v_json_temp_bgk,
                                                    'dt_swrq'),
                                           0),
                       vc_swyy       = Json_Str(v_json_temp_bgk, 'vc_swyy'),
                       vc_swicd10    = Json_Str(v_json_temp_bgk,
                                                'vc_swicd10'),
                       vc_swicdmc    = Json_Str(v_json_temp_bgk,
                                                'vc_swicdmc'),
                       vc_hzid       = Json_Str(v_json_temp_bgk, 'vc_hzid'),
                       vc_zyh        = Json_Str(v_json_temp_bgk, 'vc_zyh'),
                       vc_mzh        = Json_Str(v_json_temp_bgk, 'vc_mzh'),
                       vc_shbz       = Json_Str(v_json_temp_bgk, 'vc_shbz'),
                       validate_date = v_sysdate
                 where vc_yyrid = v_id;
              end if;
            elsif i = 4 then
              v_bgk_index     := '糖尿病患者信息：第' || j || '行,';
              v_json_temp_bgk := Json(v_json_list_bgk.Get(j));
              --校验数据合法性
              if (Json_Str(v_json_temp_bgk, 'dt_hzcsrq') is not null and
                 std(Json_Str(v_json_temp_bgk, 'dt_hzcsrq'), 0) is null) or
                 nvl(std(Json_Str(v_json_temp_bgk, 'dt_hzcsrq'), 0),sysdate) < v_zxrq then
                v_err := v_bgk_index || '患者出生日期格式有误';
                raise err_custom;
              end if;
              --检查是否已导入
              v_id := Json_Str(v_json_temp_bgk, 'vc_personid');
              select count(1)
                into v_count
                from ZJJK_TNB_HZXX_EX a
               where a.vc_personid = v_id;
              if v_count = 0 then
                insert into ZJJK_TNB_HZXX_EX
                  (vc_personid,
                   vc_hzxm,
                   vc_hzxb,
                   vc_hzmz,
                   vc_whcd,
                   dt_hzcsrq,
                   vc_sfzh,
                   vc_lxdh,
                   vc_hydm,
                   vc_zydm,
                   vc_gzdw,
                   vc_hkshen,
                   vc_hks,
                   vc_hkqx,
                   vc_hkjd,
                   vc_hkjw,
                   vc_hkxxdz,
                   vc_jzds,
                   vc_jzs,
                   vc_jzqx,
                   vc_jzjd,
                   vc_jzjw,
                   vc_jzxxdz)
                values
                  (Json_Str(v_json_temp_bgk, 'vc_personid'),
                   Json_Str(v_json_temp_bgk, 'vc_hzxm'),
                   Json_Str(v_json_temp_bgk, 'vc_hzxb'),
                   Json_Str(v_json_temp_bgk, 'vc_hzmz'),
                   Json_Str(v_json_temp_bgk, 'vc_whcd'),
                   std(Json_Str(v_json_temp_bgk, 'dt_hzcsrq'), 0),
                   Json_Str(v_json_temp_bgk, 'vc_sfzh'),
                   Json_Str(v_json_temp_bgk, 'vc_lxdh'),
                   Json_Str(v_json_temp_bgk, 'vc_hydm'),
                   Json_Str(v_json_temp_bgk, 'vc_zydm'),
                   Json_Str(v_json_temp_bgk, 'vc_gzdw'),
                   Json_Str(v_json_temp_bgk, 'vc_hkshen'),
                   Json_Str(v_json_temp_bgk, 'vc_hks'),
                   Json_Str(v_json_temp_bgk, 'vc_hkqx'),
                   Json_Str(v_json_temp_bgk, 'vc_hkjd'),
                   Json_Str(v_json_temp_bgk, 'vc_hkjw'),
                   Json_Str(v_json_temp_bgk, 'vc_hkxxdz'),
                   Json_Str(v_json_temp_bgk, 'vc_jzds'),
                   Json_Str(v_json_temp_bgk, 'vc_jzs'),
                   Json_Str(v_json_temp_bgk, 'vc_jzqx'),
                   Json_Str(v_json_temp_bgk, 'vc_jzjd'),
                   Json_Str(v_json_temp_bgk, 'vc_jzjw'),
                   Json_Str(v_json_temp_bgk, 'vc_jzxxdz'));
              else
                update ZJJK_TNB_HZXX_EX
                   set vc_hzxm   = Json_Str(v_json_temp_bgk, 'vc_hzxm'),
                       vc_hzxb   = Json_Str(v_json_temp_bgk, 'vc_hzxb'),
                       vc_hzmz   = Json_Str(v_json_temp_bgk, 'vc_hzmz'),
                       vc_whcd   = Json_Str(v_json_temp_bgk, 'vc_whcd'),
                       dt_hzcsrq = std(Json_Str(v_json_temp_bgk, 'dt_hzcsrq'),
                                       0),
                       vc_sfzh   = Json_Str(v_json_temp_bgk, 'vc_sfzh'),
                       vc_lxdh   = Json_Str(v_json_temp_bgk, 'vc_lxdh'),
                       vc_hydm   = Json_Str(v_json_temp_bgk, 'vc_hydm'),
                       vc_zydm   = Json_Str(v_json_temp_bgk, 'vc_zydm'),
                       vc_gzdw   = Json_Str(v_json_temp_bgk, 'vc_gzdw'),
                       vc_hkshen = Json_Str(v_json_temp_bgk, 'vc_hkshen'),
                       vc_hks    = Json_Str(v_json_temp_bgk, 'vc_hks'),
                       vc_hkqx   = Json_Str(v_json_temp_bgk, 'vc_hkqx'),
                       vc_hkjd   = Json_Str(v_json_temp_bgk, 'vc_hkjd'),
                       vc_hkjw   = Json_Str(v_json_temp_bgk, 'vc_hkjw'),
                       vc_hkxxdz = Json_Str(v_json_temp_bgk, 'vc_hkxxdz'),
                       vc_jzds   = Json_Str(v_json_temp_bgk, 'vc_jzds'),
                       vc_jzs    = Json_Str(v_json_temp_bgk, 'vc_jzs'),
                       vc_jzqx   = Json_Str(v_json_temp_bgk, 'vc_jzqx'),
                       vc_jzjd   = Json_Str(v_json_temp_bgk, 'vc_jzjd'),
                       vc_jzjw   = Json_Str(v_json_temp_bgk, 'vc_jzjw'),
                       vc_jzxxdz = Json_Str(v_json_temp_bgk, 'vc_jzxxdz')
                 where vc_personid = v_id;
              end if;
            elsif i = 5 then
              v_bgk_index     := '心脑血管报告卡：第' || j || '行,';
              v_json_temp_bgk := Json(v_json_list_bgk.Get(j));
              --校验数据合法性
              if (Json_Str(v_json_temp_bgk, 'dt_hzcsrq') is not null and
                 std(Json_Str(v_json_temp_bgk, 'dt_hzcsrq'), 0) is null)or
                 nvl(std(Json_Str(v_json_temp_bgk, 'dt_hzcsrq'), 0),sysdate) < v_zxrq then
                v_err := v_bgk_index || '患者出生日期格式有误';
                raise err_custom;
              end if;
              if (Json_Str(v_json_temp_bgk, 'dt_fbrq') is not null and
                 std(Json_Str(v_json_temp_bgk, 'dt_fbrq'), 0) is null)or
                 nvl(std(Json_Str(v_json_temp_bgk, 'dt_fbrq'), 0),sysdate) < v_zxrq then
                v_err := v_bgk_index || '发病日期格式有误';
                raise err_custom;
              end if;
              if (Json_Str(v_json_temp_bgk, 'dt_qzrq') is not null and
                 std(Json_Str(v_json_temp_bgk, 'dt_qzrq'), 0) is null) or
                 nvl(std(Json_Str(v_json_temp_bgk, 'dt_qzrq'), 0),sysdate) < v_zxrq then
                v_err := v_bgk_index || '确诊日期格式有误';
                raise err_custom;
              end if;
              if (Json_Str(v_json_temp_bgk, 'dt_bkrq') is not null and
                 std(Json_Str(v_json_temp_bgk, 'dt_bkrq'), 0) is null) or
                 nvl(std(Json_Str(v_json_temp_bgk, 'dt_bkrq'), 0),sysdate) < v_zxrq  then
                v_err := v_bgk_index || '报卡日期格式有误';
                raise err_custom;
              end if;
              if (Json_Str(v_json_temp_bgk, 'dt_swrq') is not null and
                 std(Json_Str(v_json_temp_bgk, 'dt_swrq'), 0) is null)  or
                 nvl(std(Json_Str(v_json_temp_bgk, 'dt_swrq'), 0),sysdate) < v_zxrq then
                v_err := v_bgk_index || '死亡日期格式有误';
                raise err_custom;
              end if;
              --检查是否已导入
              v_id := Json_Str(v_json_temp_bgk, 'vc_yyrid');
              select count(1)
                into v_count
                from ZJJK_XNXG_BGK_EX a
               where a.vc_yyrid = v_id;
              if v_count = 0 then
                insert into ZJJK_XNXG_BGK_EX
                  (vc_yyrid,
                   vc_mzh,
                   vc_zyh,
                   vc_hzxm,
                   vc_hzxb,
                   vc_hzhy,
                   vc_hzicd,
                   dt_hzcsrq,
                   vc_hzzy,
                   vc_jtgz,
                   vc_hzsfzh,
                   vc_hzwhcd,
                   vc_hzmz,
                   vc_hzjtdh,
                   vc_gzdw,
                   vc_czhks,
                   vc_czhksi,
                   vc_czhkqx,
                   vc_czhkjd,
                   vc_czhkjw,
                   vc_czhkxxdz,
                   vc_mqjzs,
                   vc_mqjzsi,
                   vc_mqjzqx,
                   vc_mqjzjd,
                   vc_mqjzjw,
                   vc_mqxxdz,
                   vc_gxbzd,
                   vc_nczzd,
                   vc_lczz,
                   vc_xdt,
                   vc_xqm,
                   vc_njy,
                   vc_ndt,
                   vc_xgzy,
                   vc_ct,
                   vc_ckz,
                   vc_sj,
                   vc_sjkysjc,
                   vc_bs,
                   vc_shtd,
                   vc_cgzsjjg,
                   vc_nzzzyzz,
                   dt_fbrq,
                   dt_qzrq,
                   vc_sfsf,
                   vc_qzdw,
                   vc_bkdwyy,
                   vc_bkys,
                   dt_bkrq,
                   dt_swrq,
                   vc_swys,
                   vc_swysicd,
                   vc_swysmc,
                   vc_bszy,
                   vc_shbz,
                   validate_date)
                values
                  (Json_Str(v_json_temp_bgk, 'vc_yyrid'),
                   Json_Str(v_json_temp_bgk, 'vc_mzh'),
                   Json_Str(v_json_temp_bgk, 'vc_zyh'),
                   Json_Str(v_json_temp_bgk, 'vc_hzxm'),
                   Json_Str(v_json_temp_bgk, 'vc_hzxb'),
                   Json_Str(v_json_temp_bgk, 'vc_hzhy'),
                   Json_Str(v_json_temp_bgk, 'vc_hzicd'),
                   std(Json_Str(v_json_temp_bgk, 'dt_hzcsrq'), 0),
                   Json_Str(v_json_temp_bgk, 'vc_hzzy'),
                   Json_Str(v_json_temp_bgk, 'vc_jtgz'),
                   Json_Str(v_json_temp_bgk, 'vc_hzsfzh'),
                   Json_Str(v_json_temp_bgk, 'vc_hzwhcd'),
                   Json_Str(v_json_temp_bgk, 'vc_hzmz'),
                   Json_Str(v_json_temp_bgk, 'vc_hzjtdh'),
                   Json_Str(v_json_temp_bgk, 'vc_gzdw'),
                   Json_Str(v_json_temp_bgk, 'vc_czhks'),
                   Json_Str(v_json_temp_bgk, 'vc_czhksi'),
                   Json_Str(v_json_temp_bgk, 'vc_czhkqx'),
                   Json_Str(v_json_temp_bgk, 'vc_czhkjd'),
                   Json_Str(v_json_temp_bgk, 'vc_czhkjw'),
                   Json_Str(v_json_temp_bgk, 'vc_czhkxxdz'),
                   Json_Str(v_json_temp_bgk, 'vc_mqjzs'),
                   Json_Str(v_json_temp_bgk, 'vc_mqjzsi'),
                   Json_Str(v_json_temp_bgk, 'vc_mqjzqx'),
                   Json_Str(v_json_temp_bgk, 'vc_mqjzjd'),
                   Json_Str(v_json_temp_bgk, 'vc_mqjzjw'),
                   Json_Str(v_json_temp_bgk, 'vc_mqxxdz'),
                   Json_Str(v_json_temp_bgk, 'vc_gxbzd'),
                   Json_Str(v_json_temp_bgk, 'vc_nczzd'),
                   Json_Str(v_json_temp_bgk, 'vc_lczz'),
                   Json_Str(v_json_temp_bgk, 'vc_xdt'),
                   Json_Str(v_json_temp_bgk, 'vc_xqm'),
                   Json_Str(v_json_temp_bgk, 'vc_njy'),
                   Json_Str(v_json_temp_bgk, 'vc_ndt'),
                   Json_Str(v_json_temp_bgk, 'vc_xgzy'),
                   Json_Str(v_json_temp_bgk, 'vc_ct'),
                   Json_Str(v_json_temp_bgk, 'vc_ckz'),
                   Json_Str(v_json_temp_bgk, 'vc_sj'),
                   Json_Str(v_json_temp_bgk, 'vc_sjkysjc'),
                   Json_Str(v_json_temp_bgk, 'vc_bs'),
                   Json_Str(v_json_temp_bgk, 'vc_shtd'),
                   Json_Str(v_json_temp_bgk, 'vc_cgzsjjg'),
                   Json_Str(v_json_temp_bgk, 'vc_nzzzyzz'),
                   std(Json_Str(v_json_temp_bgk, 'dt_fbrq'), 0),
                   std(Json_Str(v_json_temp_bgk, 'dt_qzrq'), 0),
                   Json_Str(v_json_temp_bgk, 'vc_sfsf'),
                   Json_Str(v_json_temp_bgk, 'vc_qzdw'),
                   Json_Str(v_json_temp_bgk, 'vc_bkdwyy'),
                   Json_Str(v_json_temp_bgk, 'vc_bkys'),
                   std(Json_Str(v_json_temp_bgk, 'dt_bkrq'), 0),
                   std(Json_Str(v_json_temp_bgk, 'dt_swrq'), 0),
                   Json_Str(v_json_temp_bgk, 'vc_swys'),
                   Json_Str(v_json_temp_bgk, 'vc_swysicd'),
                   Json_Str(v_json_temp_bgk, 'vc_swysmc'),
                   Json_Str(v_json_temp_bgk, 'vc_bszy'),
                   Json_Str(v_json_temp_bgk, 'vc_shbz'),
                   v_sysdate);
              else
                update ZJJK_XNXG_BGK_EX
                   set vc_mzh        = Json_Str(v_json_temp_bgk, 'vc_mzh'),
                       vc_zyh        = Json_Str(v_json_temp_bgk, 'vc_zyh'),
                       vc_hzxm       = Json_Str(v_json_temp_bgk, 'vc_hzxm'),
                       vc_hzxb       = Json_Str(v_json_temp_bgk, 'vc_hzxb'),
                       vc_hzhy       = Json_Str(v_json_temp_bgk, 'vc_hzhy'),
                       vc_hzicd      = Json_Str(v_json_temp_bgk, 'vc_hzicd'),
                       dt_hzcsrq     = std(Json_Str(v_json_temp_bgk,
                                                    'dt_hzcsrq'),
                                           0),
                       vc_hzzy       = Json_Str(v_json_temp_bgk, 'vc_hzzy'),
                       vc_jtgz       = Json_Str(v_json_temp_bgk, 'vc_jtgz'),
                       vc_hzsfzh     = Json_Str(v_json_temp_bgk, 'vc_hzsfzh'),
                       vc_hzwhcd     = Json_Str(v_json_temp_bgk, 'vc_hzwhcd'),
                       vc_hzmz       = Json_Str(v_json_temp_bgk, 'vc_hzmz'),
                       vc_hzjtdh     = Json_Str(v_json_temp_bgk, 'vc_hzjtdh'),
                       vc_gzdw       = Json_Str(v_json_temp_bgk, 'vc_gzdw'),
                       vc_czhks      = Json_Str(v_json_temp_bgk, 'vc_czhks'),
                       vc_czhksi     = Json_Str(v_json_temp_bgk, 'vc_czhksi'),
                       vc_czhkqx     = Json_Str(v_json_temp_bgk, 'vc_czhkqx'),
                       vc_czhkjd     = Json_Str(v_json_temp_bgk, 'vc_czhkjd'),
                       vc_czhkjw     = Json_Str(v_json_temp_bgk, 'vc_czhkjw'),
                       vc_czhkxxdz   = Json_Str(v_json_temp_bgk,
                                                'vc_czhkxxdz'),
                       vc_mqjzs      = Json_Str(v_json_temp_bgk, 'vc_mqjzs'),
                       vc_mqjzsi     = Json_Str(v_json_temp_bgk, 'vc_mqjzsi'),
                       vc_mqjzqx     = Json_Str(v_json_temp_bgk, 'vc_mqjzqx'),
                       vc_mqjzjd     = Json_Str(v_json_temp_bgk, 'vc_mqjzjd'),
                       vc_mqjzjw     = Json_Str(v_json_temp_bgk, 'vc_mqjzjw'),
                       vc_mqxxdz     = Json_Str(v_json_temp_bgk, 'vc_mqxxdz'),
                       vc_gxbzd      = Json_Str(v_json_temp_bgk, 'vc_gxbzd'),
                       vc_nczzd      = Json_Str(v_json_temp_bgk, 'vc_nczzd'),
                       vc_lczz       = Json_Str(v_json_temp_bgk, 'vc_lczz'),
                       vc_xdt        = Json_Str(v_json_temp_bgk, 'vc_xdt'),
                       vc_xqm        = Json_Str(v_json_temp_bgk, 'vc_xqm'),
                       vc_njy        = Json_Str(v_json_temp_bgk, 'vc_njy'),
                       vc_ndt        = Json_Str(v_json_temp_bgk, 'vc_ndt'),
                       vc_xgzy       = Json_Str(v_json_temp_bgk, 'vc_xgzy'),
                       vc_ct         = Json_Str(v_json_temp_bgk, 'vc_ct'),
                       vc_ckz        = Json_Str(v_json_temp_bgk, 'vc_ckz'),
                       vc_sj         = Json_Str(v_json_temp_bgk, 'vc_sj'),
                       vc_sjkysjc    = Json_Str(v_json_temp_bgk,
                                                'vc_sjkysjc'),
                       vc_bs         = Json_Str(v_json_temp_bgk, 'vc_bs'),
                       vc_shtd       = Json_Str(v_json_temp_bgk, 'vc_shtd'),
                       vc_cgzsjjg    = Json_Str(v_json_temp_bgk,
                                                'vc_cgzsjjg'),
                       vc_nzzzyzz    = Json_Str(v_json_temp_bgk,
                                                'vc_nzzzyzz'),
                       dt_fbrq       = std(Json_Str(v_json_temp_bgk,
                                                    'dt_fbrq'),
                                           0),
                       dt_qzrq       = std(Json_Str(v_json_temp_bgk,
                                                    'dt_qzrq'),
                                           0),
                       vc_sfsf       = Json_Str(v_json_temp_bgk, 'vc_sfsf'),
                       vc_qzdw       = Json_Str(v_json_temp_bgk, 'vc_qzdw'),
                       vc_bkdwyy     = Json_Str(v_json_temp_bgk, 'vc_bkdwyy'),
                       vc_bkys       = Json_Str(v_json_temp_bgk, 'vc_bkys'),
                       dt_bkrq       = std(Json_Str(v_json_temp_bgk,
                                                    'dt_bkrq'),
                                           0),
                       dt_swrq       = std(Json_Str(v_json_temp_bgk,
                                                    'dt_swrq'),
                                           0),
                       vc_swys       = Json_Str(v_json_temp_bgk, 'vc_swys'),
                       vc_swysicd    = Json_Str(v_json_temp_bgk,
                                                'vc_swysicd'),
                       vc_swysmc     = Json_Str(v_json_temp_bgk, 'vc_swysmc'),
                       vc_bszy       = Json_Str(v_json_temp_bgk, 'vc_bszy'),
                       vc_shbz       = Json_Str(v_json_temp_bgk, 'vc_shbz'),
                       validate_date = v_sysdate
                 where vc_yyrid = v_id;
              end if;
            elsif i = 6 then
              v_bgk_index     := '伤害报告卡：第' || j || '行,';
              v_json_temp_bgk := Json(v_json_list_bgk.Get(j));
              --校验数据合法性
              if (Json_Str(v_json_temp_bgk, 'dt_hzcsrq') is not null and
                 std(Json_Str(v_json_temp_bgk, 'dt_hzcsrq'), 0) is null) or
                 nvl(std(Json_Str(v_json_temp_bgk, 'dt_hzcsrq'), 0),sysdate) < v_zxrq  then
                v_err := v_bgk_index || '患者出生日期格式有误';
                raise err_custom;
              end if;
              if (Json_Str(v_json_temp_bgk, 'dt_shrq') is not null and
                 std(Json_Str(v_json_temp_bgk, 'dt_shrq'), 0) is null)or
                 nvl(std(Json_Str(v_json_temp_bgk, 'dt_shrq'), 0),sysdate) < v_zxrq  then
                v_err := v_bgk_index || '受伤日期格式有误';
                raise err_custom;
              end if;
              if (Json_Str(v_json_temp_bgk, 'dt_jzrq') is not null and
                 std(Json_Str(v_json_temp_bgk, 'dt_jzrq'), 0) is null) or
                 nvl(std(Json_Str(v_json_temp_bgk, 'dt_jzrq'), 0),sysdate) < v_zxrq then
                v_err := v_bgk_index || '就诊日期格式有误';
                raise err_custom;
              end if;
              --检查是否已导入
              v_id := Json_Str(v_json_temp_bgk, 'vc_yyrid');
              select count(1)
                into v_count
                from ZJJK_SHJC_BGK_EX a
               where a.vc_yyrid = v_id;
              if v_count = 0 then
                insert into ZJJK_SHJC_BGK_EX
                  (vc_yyrid,
                   dt_yytjrq,
                   vc_jkdw,
                   vc_xm,
                   vc_xb,
                   vc_nl,
                   vc_dh,
                   dt_shrq,
                   dt_jzrq,
                   vc_zz,
                   vc_hj,
                   vc_zy,
                   vc_zyqt,
                   vc_fsdd,
                   vc_fsddqt,
                   vc_shyy,
                   vc_shyyqt,
                   vc_shszsm,
                   vc_shszsmqt,
                   vc_yzcd,
                   vc_fsqsfyj,
                   vc_brddqk,
                   vc_brddqkqt,
                   vc_sfgy,
                   vc_jj,
                   vc_sfjdc,
                   vc_sszjtgj,
                   vc_sszjtgjqt,
                   vc_sszqk,
                   vc_sszqkqt,
                   vc_sszhsmfspz,
                   vc_sszhsmfspzqt,
                   vc_czjdcsszdwz,
                   vc_zwywanqd,
                   vc_anqdsy,
                   vc_ywbhzz,
                   vc_bhzzsy,
                   vc_zyxgys,
                   vc_zyxgysqt,
                   vc_yqzsfsdcs,
                   vc_shqy,
                   vc_shqyqt,
                   vc_sszysrg,
                   vc_sszysrgxqt,
                   vc_sygj,
                   vc_sygjqt,
                   vc_shxz1,
                   vc_shxz2,
                   vc_shxz3,
                   vc_ssbw1,
                   vc_ssbw2,
                   vc_ssbw3,
                   vc_sjzy,
                   vc_shwbyy,
                   vc_hzjzkb,
                   vc_hzjzkbqt,
                   vc_txyshs,
                   vc_shbz,
                   validate_date)
                values
                  (Json_Str(v_json_temp_bgk, 'vc_yyrid'),
                   std(Json_Str(v_json_temp_bgk, 'dt_yytjrq'), 0),
                   Json_Str(v_json_temp_bgk, 'vc_jkdw'),
                   Json_Str(v_json_temp_bgk, 'vc_xm'),
                   Json_Str(v_json_temp_bgk, 'vc_xb'),
                   Json_Str(v_json_temp_bgk, 'vc_nl'),
                   Json_Str(v_json_temp_bgk, 'vc_dh'),
                   std(Json_Str(v_json_temp_bgk, 'dt_shrq'), 0),
                   std(Json_Str(v_json_temp_bgk, 'dt_jzrq'), 0),
                   Json_Str(v_json_temp_bgk, 'vc_zz'),
                   Json_Str(v_json_temp_bgk, 'vc_hj'),
                   Json_Str(v_json_temp_bgk, 'vc_zy'),
                   Json_Str(v_json_temp_bgk, 'vc_zyqt'),
                   Json_Str(v_json_temp_bgk, 'vc_fsdd'),
                   Json_Str(v_json_temp_bgk, 'vc_fsddqt'),
                   Json_Str(v_json_temp_bgk, 'vc_shyy'),
                   Json_Str(v_json_temp_bgk, 'vc_shyyqt'),
                   Json_Str(v_json_temp_bgk, 'vc_shszsm'),
                   Json_Str(v_json_temp_bgk, 'vc_shszsmqt'),
                   Json_Str(v_json_temp_bgk, 'vc_yzcd'),
                   Json_Str(v_json_temp_bgk, 'vc_fsqsfyj'),
                   Json_Str(v_json_temp_bgk, 'vc_brddqk'),
                   Json_Str(v_json_temp_bgk, 'vc_brddqkqt'),
                   Json_Str(v_json_temp_bgk, 'vc_sfgy'),
                   Json_Str(v_json_temp_bgk, 'vc_jj'),
                   Json_Str(v_json_temp_bgk, 'vc_sfjdc'),
                   Json_Str(v_json_temp_bgk, 'vc_sszjtgj'),
                   Json_Str(v_json_temp_bgk, 'vc_sszjtgjqt'),
                   Json_Str(v_json_temp_bgk, 'vc_sszqk'),
                   Json_Str(v_json_temp_bgk, 'vc_sszqkqt'),
                   Json_Str(v_json_temp_bgk, 'vc_sszhsmfspz'),
                   Json_Str(v_json_temp_bgk, 'vc_sszhsmfspzqt'),
                   Json_Str(v_json_temp_bgk, 'vc_czjdcsszdwz'),
                   Json_Str(v_json_temp_bgk, 'vc_zwywanqd'),
                   Json_Str(v_json_temp_bgk, 'vc_anqdsy'),
                   Json_Str(v_json_temp_bgk, 'vc_ywbhzz'),
                   Json_Str(v_json_temp_bgk, 'vc_bhzzsy'),
                   Json_Str(v_json_temp_bgk, 'vc_zyxgys'),
                   Json_Str(v_json_temp_bgk, 'vc_zyxgysqt'),
                   Json_Str(v_json_temp_bgk, 'vc_yqzsfsdcs'),
                   Json_Str(v_json_temp_bgk, 'vc_shqy'),
                   Json_Str(v_json_temp_bgk, 'vc_shqyqt'),
                   Json_Str(v_json_temp_bgk, 'vc_sszysrg'),
                   Json_Str(v_json_temp_bgk, 'vc_sszysrgxqt'),
                   Json_Str(v_json_temp_bgk, 'vc_sygj'),
                   Json_Str(v_json_temp_bgk, 'vc_sygjqt'),
                   Json_Str(v_json_temp_bgk, 'vc_shxz1'),
                   Json_Str(v_json_temp_bgk, 'vc_shxz2'),
                   Json_Str(v_json_temp_bgk, 'vc_shxz3'),
                   Json_Str(v_json_temp_bgk, 'vc_ssbw1'),
                   Json_Str(v_json_temp_bgk, 'vc_ssbw2'),
                   Json_Str(v_json_temp_bgk, 'vc_ssbw3'),
                   Json_Str(v_json_temp_bgk, 'vc_sjzy'),
                   Json_Str(v_json_temp_bgk, 'vc_shwbyy'),
                   Json_Str(v_json_temp_bgk, 'vc_hzjzkb'),
                   Json_Str(v_json_temp_bgk, 'vc_hzjzkbqt'),
                   Json_Str(v_json_temp_bgk, 'vc_txyshs'),
                   Json_Str(v_json_temp_bgk, 'vc_shbz'),
                   v_sysdate);
              else
                update ZJJK_SHJC_BGK_EX
                   set dt_yytjrq       = std(Json_Str(v_json_temp_bgk,
                                                      'dt_yytjrq'),
                                             0),
                       vc_jkdw         = Json_Str(v_json_temp_bgk, 'vc_jkdw'),
                       vc_xm           = Json_Str(v_json_temp_bgk, 'vc_xm'),
                       vc_xb           = Json_Str(v_json_temp_bgk, 'vc_xb'),
                       vc_nl           = Json_Str(v_json_temp_bgk, 'vc_nl'),
                       vc_dh           = Json_Str(v_json_temp_bgk, 'vc_dh'),
                       dt_shrq         = std(Json_Str(v_json_temp_bgk,
                                                      'dt_shrq'),
                                             0),
                       dt_jzrq         = std(Json_Str(v_json_temp_bgk,
                                                      'dt_jzrq'),
                                             0),
                       vc_zz           = Json_Str(v_json_temp_bgk, 'vc_zz'),
                       vc_hj           = Json_Str(v_json_temp_bgk, 'vc_hj'),
                       vc_zy           = Json_Str(v_json_temp_bgk, 'vc_zy'),
                       vc_zyqt         = Json_Str(v_json_temp_bgk, 'vc_zyqt'),
                       vc_fsdd         = Json_Str(v_json_temp_bgk, 'vc_fsdd'),
                       vc_fsddqt       = Json_Str(v_json_temp_bgk,
                                                  'vc_fsddqt'),
                       vc_shyy         = Json_Str(v_json_temp_bgk, 'vc_shyy'),
                       vc_shyyqt       = Json_Str(v_json_temp_bgk,
                                                  'vc_shyyqt'),
                       vc_shszsm       = Json_Str(v_json_temp_bgk,
                                                  'vc_shszsm'),
                       vc_shszsmqt     = Json_Str(v_json_temp_bgk,
                                                  'vc_shszsmqt'),
                       vc_yzcd         = Json_Str(v_json_temp_bgk, 'vc_yzcd'),
                       vc_fsqsfyj      = Json_Str(v_json_temp_bgk,
                                                  'vc_fsqsfyj'),
                       vc_brddqk       = Json_Str(v_json_temp_bgk,
                                                  'vc_brddqk'),
                       vc_brddqkqt     = Json_Str(v_json_temp_bgk,
                                                  'vc_brddqkqt'),
                       vc_sfgy         = Json_Str(v_json_temp_bgk, 'vc_sfgy'),
                       vc_jj           = Json_Str(v_json_temp_bgk, 'vc_jj'),
                       vc_sfjdc        = Json_Str(v_json_temp_bgk,
                                                  'vc_sfjdc'),
                       vc_sszjtgj      = Json_Str(v_json_temp_bgk,
                                                  'vc_sszjtgj'),
                       vc_sszjtgjqt    = Json_Str(v_json_temp_bgk,
                                                  'vc_sszjtgjqt'),
                       vc_sszqk        = Json_Str(v_json_temp_bgk,
                                                  'vc_sszqk'),
                       vc_sszqkqt      = Json_Str(v_json_temp_bgk,
                                                  'vc_sszqkqt'),
                       vc_sszhsmfspz   = Json_Str(v_json_temp_bgk,
                                                  'vc_sszhsmfspz'),
                       vc_sszhsmfspzqt = Json_Str(v_json_temp_bgk,
                                                  'vc_sszhsmfspzqt'),
                       vc_czjdcsszdwz  = Json_Str(v_json_temp_bgk,
                                                  'vc_czjdcsszdwz'),
                       vc_zwywanqd     = Json_Str(v_json_temp_bgk,
                                                  'vc_zwywanqd'),
                       vc_anqdsy       = Json_Str(v_json_temp_bgk,
                                                  'vc_anqdsy'),
                       vc_ywbhzz       = Json_Str(v_json_temp_bgk,
                                                  'vc_ywbhzz'),
                       vc_bhzzsy       = Json_Str(v_json_temp_bgk,
                                                  'vc_bhzzsy'),
                       vc_zyxgys       = Json_Str(v_json_temp_bgk,
                                                  'vc_zyxgys'),
                       vc_zyxgysqt     = Json_Str(v_json_temp_bgk,
                                                  'vc_zyxgysqt'),
                       vc_yqzsfsdcs    = Json_Str(v_json_temp_bgk,
                                                  'vc_yqzsfsdcs'),
                       vc_shqy         = Json_Str(v_json_temp_bgk, 'vc_shqy'),
                       vc_shqyqt       = Json_Str(v_json_temp_bgk,
                                                  'vc_shqyqt'),
                       vc_sszysrg      = Json_Str(v_json_temp_bgk,
                                                  'vc_sszysrg'),
                       vc_sszysrgxqt   = Json_Str(v_json_temp_bgk,
                                                  'vc_sszysrgxqt'),
                       vc_sygj         = Json_Str(v_json_temp_bgk, 'vc_sygj'),
                       vc_sygjqt       = Json_Str(v_json_temp_bgk,
                                                  'vc_sygjqt'),
                       vc_shxz1        = Json_Str(v_json_temp_bgk,
                                                  'vc_shxz1'),
                       vc_shxz2        = Json_Str(v_json_temp_bgk,
                                                  'vc_shxz2'),
                       vc_shxz3        = Json_Str(v_json_temp_bgk,
                                                  'vc_shxz3'),
                       vc_ssbw1        = Json_Str(v_json_temp_bgk,
                                                  'vc_ssbw1'),
                       vc_ssbw2        = Json_Str(v_json_temp_bgk,
                                                  'vc_ssbw2'),
                       vc_ssbw3        = Json_Str(v_json_temp_bgk,
                                                  'vc_ssbw3'),
                       vc_sjzy         = Json_Str(v_json_temp_bgk, 'vc_sjzy'),
                       vc_shwbyy       = Json_Str(v_json_temp_bgk,
                                                  'vc_shwbyy'),
                       vc_hzjzkb       = Json_Str(v_json_temp_bgk,
                                                  'vc_hzjzkb'),
                       vc_hzjzkbqt     = Json_Str(v_json_temp_bgk,
                                                  'vc_hzjzkbqt'),
                       vc_txyshs       = Json_Str(v_json_temp_bgk,
                                                  'vc_txyshs'),
                       vc_shbz         = Json_Str(v_json_temp_bgk, 'vc_shbz'),
                       validate_date   = v_sysdate
                 where vc_yyrid = v_id;
              end if;
            elsif i = 7 then
              v_bgk_index     := '死因报告卡：第' || j || '行,';
              v_json_temp_bgk := Json(v_json_list_bgk.Get(j));
              if (Json_Str(v_json_temp_bgk, 'dt_csrq') is not null and
                 std(Json_Str(v_json_temp_bgk, 'dt_csrq'), 0) is null)  or
                 nvl(std(Json_Str(v_json_temp_bgk, 'dt_csrq'), 0),sysdate) < v_zxrq then
                v_err := v_bgk_index || '出生日期格式有误';
                raise err_custom;
              end if;
              if (Json_Str(v_json_temp_bgk, 'dt_swrq') is not null and
                 std(Json_Str(v_json_temp_bgk, 'dt_swrq'), 0) is null) or
                 nvl(std(Json_Str(v_json_temp_bgk, 'dt_swrq'), 0),sysdate) < v_zxrq then
                v_err := v_bgk_index || '死亡日期格式有误';
                raise err_custom;
              end if;
              if (Json_Str(v_json_temp_bgk, 'dt_bkrq') is not null and
                 std(Json_Str(v_json_temp_bgk, 'dt_bkrq'), 0) is null)  or
                 nvl(std(Json_Str(v_json_temp_bgk, 'dt_bkrq'), 0),sysdate) < v_zxrq  then
                v_err := v_bgk_index || '报卡日期格式有误';
                raise err_custom;
              end if;
              --检查是否已导入
              v_id := Json_Str(v_json_temp_bgk, 'vc_yyrid');
              select count(1)
                into v_count
                from ZJJK_SW_BGK_EX a
               where a.vc_yyrid = v_id;
              if v_count = 0 then
                insert into ZJJK_SW_BGK_EX
                  (vc_yyrid,
                   vc_szxm,
                   vc_xb,
                   vc_mz,
                   vc_grsf,
                   vc_hyzk,
                   vc_whcd,
                   dt_csrq,
                   dt_swrq,
                   vc_zjlx,
                   vc_zjhm,
                   vc_swdd,
                   vc_zgzddw,
                   vc_zdyj,
                   vc_gbswbm,
                   vc_tjflh,
                   vc_lxjsxm,
                   vc_jsdh,
                   vc_jsdz,
                   vc_szsqgzdw,
                   vc_zyh,
                   vc_bkdw,
                   dt_bkrq,
                   vc_bkys,
                   vc_aicd10bm,
                   vc_afbdswsjjg,
                   vc_bicd10bm,
                   vc_bfbdswsjjg,
                   vc_cicd11bm,
                   vc_cfbdswsjjg,
                   vc_dicd12bm,
                   vc_dfbdswsjjg,
                   vc_qtjbzd1icd10dm,
                   vc_qtfb1dswsjjg,
                   vc_qtjbzd2icd10dm,
                   vc_qtfb2dswsjjg,
                   vc_qtjbzd3icd10dm,
                   vc_qtfb3dswsjjg,
                   vc_azjdzswdjb,
                   vc_bzjdzswdjb,
                   vc_czjdzswdjb,
                   vc_dzjdzswdjb,
                   vc_qtjbzd1,
                   vc_qtjbzd2,
                   vc_qtjbzd3,
                   vc_rsqk,
                   vc_hjdzlx,
                   vc_hksdmzjs,
                   vc_hkqxdmzjs,
                   vc_hkjddmzjs,
                   vc_hkxxdzzjs,
                   vc_hkshedmws,
                   vc_hkshidmws,
                   vc_hkqxdmws,
                   vc_hkjddmws,
                   vc_hkxxdzws,
                   vc_gjhdq,
                   vc_jzdzlx,
                   vc_jzsdmzjs,
                   vc_jzqxdmzjs,
                   vc_jzjddmzjs,
                   vc_jzxxdzzjs,
                   vc_jzshedmws,
                   vc_jzshidmws,
                   vc_jzqxdmws,
                   vc_jzjddmws,
                   vc_jzxxdzws,
                   vc_szsqbsjzztz,
                   vc_shbz,
                   validate_date)
                values
                  (Json_Str(v_json_temp_bgk, 'vc_yyrid'),
                   Json_Str(v_json_temp_bgk, 'vc_szxm'),
                   Json_Str(v_json_temp_bgk, 'vc_xb'),
                   Json_Str(v_json_temp_bgk, 'vc_mz'),
                   Json_Str(v_json_temp_bgk, 'vc_grsf'),
                   Json_Str(v_json_temp_bgk, 'vc_hyzk'),
                   Json_Str(v_json_temp_bgk, 'vc_whcd'),
                   std(Json_Str(v_json_temp_bgk, 'dt_csrq'), 0),
                   std(Json_Str(v_json_temp_bgk, 'dt_swrq'), 0),
                   Json_Str(v_json_temp_bgk, 'vc_zjlx'),
                   Json_Str(v_json_temp_bgk, 'vc_zjhm'),
                   Json_Str(v_json_temp_bgk, 'vc_swdd'),
                   Json_Str(v_json_temp_bgk, 'vc_zgzddw'),
                   Json_Str(v_json_temp_bgk, 'vc_zdyj'),
                   Json_Str(v_json_temp_bgk, 'vc_gbswbm'),
                   Json_Str(v_json_temp_bgk, 'vc_tjflh'),
                   Json_Str(v_json_temp_bgk, 'vc_lxjsxm'),
                   Json_Str(v_json_temp_bgk, 'vc_jsdh'),
                   Json_Str(v_json_temp_bgk, 'vc_jsdz'),
                   Json_Str(v_json_temp_bgk, 'vc_szsqgzdw'),
                   Json_Str(v_json_temp_bgk, 'vc_zyh'),
                   Json_Str(v_json_temp_bgk, 'vc_bkdw'),
                   std(Json_Str(v_json_temp_bgk, 'dt_bkrq'), 0),
                   Json_Str(v_json_temp_bgk, 'vc_bkys'),
                   Json_Str(v_json_temp_bgk, 'vc_aicd10bm'),
                   Json_Str(v_json_temp_bgk, 'vc_afbdswsjjg'),
                   Json_Str(v_json_temp_bgk, 'vc_bicd10bm'),
                   Json_Str(v_json_temp_bgk, 'vc_bfbdswsjjg'),
                   Json_Str(v_json_temp_bgk, 'vc_cicd11bm'),
                   Json_Str(v_json_temp_bgk, 'vc_cfbdswsjjg'),
                   Json_Str(v_json_temp_bgk, 'vc_dicd12bm'),
                   Json_Str(v_json_temp_bgk, 'vc_dfbdswsjjg'),
                   Json_Str(v_json_temp_bgk, 'vc_qtjbzd1icd10dm'),
                   Json_Str(v_json_temp_bgk, 'vc_qtfb1dswsjjg'),
                   Json_Str(v_json_temp_bgk, 'vc_qtjbzd2icd10dm'),
                   Json_Str(v_json_temp_bgk, 'vc_qtfb2dswsjjg'),
                   Json_Str(v_json_temp_bgk, 'vc_qtjbzd3icd10dm'),
                   Json_Str(v_json_temp_bgk, 'vc_qtfb3dswsjjg'),
                   Json_Str(v_json_temp_bgk, 'vc_azjdzswdjb'),
                   Json_Str(v_json_temp_bgk, 'vc_bzjdzswdjb'),
                   Json_Str(v_json_temp_bgk, 'vc_czjdzswdjb'),
                   Json_Str(v_json_temp_bgk, 'vc_dzjdzswdjb'),
                   Json_Str(v_json_temp_bgk, 'vc_qtjbzd1'),
                   Json_Str(v_json_temp_bgk, 'vc_qtjbzd2'),
                   Json_Str(v_json_temp_bgk, 'vc_qtjbzd3'),
                   Json_Str(v_json_temp_bgk, 'vc_rsqk'),
                   Json_Str(v_json_temp_bgk, 'vc_hjdzlx'),
                   Json_Str(v_json_temp_bgk, 'vc_hksdmzjs'),
                   Json_Str(v_json_temp_bgk, 'vc_hkqxdmzjs'),
                   Json_Str(v_json_temp_bgk, 'vc_hkjddmzjs'),
                   Json_Str(v_json_temp_bgk, 'vc_hkxxdzzjs'),
                   Json_Str(v_json_temp_bgk, 'vc_hkshedmws'),
                   Json_Str(v_json_temp_bgk, 'vc_hkshidmws'),
                   Json_Str(v_json_temp_bgk, 'vc_hkqxdmws'),
                   Json_Str(v_json_temp_bgk, 'vc_hkjddmws'),
                   Json_Str(v_json_temp_bgk, 'vc_hkxxdzws'),
                   Json_Str(v_json_temp_bgk, 'vc_gjhdq'),
                   Json_Str(v_json_temp_bgk, 'vc_jzdzlx'),
                   Json_Str(v_json_temp_bgk, 'vc_jzsdmzjs'),
                   Json_Str(v_json_temp_bgk, 'vc_jzqxdmzjs'),
                   Json_Str(v_json_temp_bgk, 'vc_jzjddmzjs'),
                   Json_Str(v_json_temp_bgk, 'vc_jzxxdzzjs'),
                   Json_Str(v_json_temp_bgk, 'vc_jzshedmws'),
                   Json_Str(v_json_temp_bgk, 'vc_jzshidmws'),
                   Json_Str(v_json_temp_bgk, 'vc_jzqxdmws'),
                   Json_Str(v_json_temp_bgk, 'vc_jzjddmws'),
                   Json_Str(v_json_temp_bgk, 'vc_jzxxdzws'),
                   Json_Str(v_json_temp_bgk, 'vc_szsqbsjzztz'),
                   Json_Str(v_json_temp_bgk, 'vc_shbz'),
                   v_sysdate);
              else
                update ZJJK_SW_BGK_EX
                   set vc_szxm           = Json_Str(v_json_temp_bgk,
                                                    'vc_szxm'),
                       vc_xb             = Json_Str(v_json_temp_bgk, 'vc_xb'),
                       vc_mz             = Json_Str(v_json_temp_bgk, 'vc_mz'),
                       vc_grsf           = Json_Str(v_json_temp_bgk,
                                                    'vc_grsf'),
                       vc_hyzk           = Json_Str(v_json_temp_bgk,
                                                    'vc_hyzk'),
                       vc_whcd           = Json_Str(v_json_temp_bgk,
                                                    'vc_whcd'),
                       dt_csrq           = std(Json_Str(v_json_temp_bgk,
                                                        'dt_csrq'),
                                               0),
                       dt_swrq           = std(Json_Str(v_json_temp_bgk,
                                                        'dt_swrq'),
                                               0),
                       vc_zjlx           = Json_Str(v_json_temp_bgk,
                                                    'vc_zjlx'),
                       vc_zjhm           = Json_Str(v_json_temp_bgk,
                                                    'vc_zjhm'),
                       vc_swdd           = Json_Str(v_json_temp_bgk,
                                                    'vc_swdd'),
                       vc_zgzddw         = Json_Str(v_json_temp_bgk,
                                                    'vc_zgzddw'),
                       vc_zdyj           = Json_Str(v_json_temp_bgk,
                                                    'vc_zdyj'),
                       vc_gbswbm         = Json_Str(v_json_temp_bgk,
                                                    'vc_gbswbm'),
                       vc_tjflh          = Json_Str(v_json_temp_bgk,
                                                    'vc_tjflh'),
                       vc_lxjsxm         = Json_Str(v_json_temp_bgk,
                                                    'vc_lxjsxm'),
                       vc_jsdh           = Json_Str(v_json_temp_bgk,
                                                    'vc_jsdh'),
                       vc_jsdz           = Json_Str(v_json_temp_bgk,
                                                    'vc_jsdz'),
                       vc_szsqgzdw       = Json_Str(v_json_temp_bgk,
                                                    'vc_szsqgzdw'),
                       vc_zyh            = Json_Str(v_json_temp_bgk,
                                                    'vc_zyh'),
                       vc_bkdw           = Json_Str(v_json_temp_bgk,
                                                    'vc_bkdw'),
                       dt_bkrq           = std(Json_Str(v_json_temp_bgk,
                                                        'dt_bkrq'),
                                               0),
                       vc_bkys           = Json_Str(v_json_temp_bgk,
                                                    'vc_bkys'),
                       vc_aicd10bm       = Json_Str(v_json_temp_bgk,
                                                    'vc_aicd10bm'),
                       vc_afbdswsjjg     = Json_Str(v_json_temp_bgk,
                                                    'vc_afbdswsjjg'),
                       vc_bicd10bm       = Json_Str(v_json_temp_bgk,
                                                    'vc_bicd10bm'),
                       vc_bfbdswsjjg     = Json_Str(v_json_temp_bgk,
                                                    'vc_bfbdswsjjg'),
                       vc_cicd11bm       = Json_Str(v_json_temp_bgk,
                                                    'vc_cicd11bm'),
                       vc_cfbdswsjjg     = Json_Str(v_json_temp_bgk,
                                                    'vc_cfbdswsjjg'),
                       vc_dicd12bm       = Json_Str(v_json_temp_bgk,
                                                    'vc_dicd12bm'),
                       vc_dfbdswsjjg     = Json_Str(v_json_temp_bgk,
                                                    'vc_dfbdswsjjg'),
                       vc_qtjbzd1icd10dm = Json_Str(v_json_temp_bgk,
                                                    'vc_qtjbzd1icd10dm'),
                       vc_qtfb1dswsjjg   = Json_Str(v_json_temp_bgk,
                                                    'vc_qtfb1dswsjjg'),
                       vc_qtjbzd2icd10dm = Json_Str(v_json_temp_bgk,
                                                    'vc_qtjbzd2icd10dm'),
                       vc_qtfb2dswsjjg   = Json_Str(v_json_temp_bgk,
                                                    'vc_qtfb2dswsjjg'),
                       vc_qtjbzd3icd10dm = Json_Str(v_json_temp_bgk,
                                                    'vc_qtjbzd3icd10dm'),
                       vc_qtfb3dswsjjg   = Json_Str(v_json_temp_bgk,
                                                    'vc_qtfb3dswsjjg'),
                       vc_azjdzswdjb     = Json_Str(v_json_temp_bgk,
                                                    'vc_azjdzswdjb'),
                       vc_bzjdzswdjb     = Json_Str(v_json_temp_bgk,
                                                    'vc_bzjdzswdjb'),
                       vc_czjdzswdjb     = Json_Str(v_json_temp_bgk,
                                                    'vc_czjdzswdjb'),
                       vc_dzjdzswdjb     = Json_Str(v_json_temp_bgk,
                                                    'vc_dzjdzswdjb'),
                       vc_qtjbzd1        = Json_Str(v_json_temp_bgk,
                                                    'vc_qtjbzd1'),
                       vc_qtjbzd2        = Json_Str(v_json_temp_bgk,
                                                    'vc_qtjbzd2'),
                       vc_qtjbzd3        = Json_Str(v_json_temp_bgk,
                                                    'vc_qtjbzd3'),
                       vc_rsqk           = Json_Str(v_json_temp_bgk,
                                                    'vc_rsqk'),
                       vc_hjdzlx         = Json_Str(v_json_temp_bgk,
                                                    'vc_hjdzlx'),
                       vc_hksdmzjs       = Json_Str(v_json_temp_bgk,
                                                    'vc_hksdmzjs'),
                       vc_hkqxdmzjs      = Json_Str(v_json_temp_bgk,
                                                    'vc_hkqxdmzjs'),
                       vc_hkjddmzjs      = Json_Str(v_json_temp_bgk,
                                                    'vc_hkjddmzjs'),
                       vc_hkxxdzzjs      = Json_Str(v_json_temp_bgk,
                                                    'vc_hkxxdzzjs'),
                       vc_hkshedmws      = Json_Str(v_json_temp_bgk,
                                                    'vc_hkshedmws'),
                       vc_hkshidmws      = Json_Str(v_json_temp_bgk,
                                                    'vc_hkshidmws'),
                       vc_hkqxdmws       = Json_Str(v_json_temp_bgk,
                                                    'vc_hkqxdmws'),
                       vc_hkjddmws       = Json_Str(v_json_temp_bgk,
                                                    'vc_hkjddmws'),
                       vc_hkxxdzws       = Json_Str(v_json_temp_bgk,
                                                    'vc_hkxxdzws'),
                       vc_gjhdq          = Json_Str(v_json_temp_bgk,
                                                    'vc_gjhdq'),
                       vc_jzdzlx         = Json_Str(v_json_temp_bgk,
                                                    'vc_jzdzlx'),
                       vc_jzsdmzjs       = Json_Str(v_json_temp_bgk,
                                                    'vc_jzsdmzjs'),
                       vc_jzqxdmzjs      = Json_Str(v_json_temp_bgk,
                                                    'vc_jzqxdmzjs'),
                       vc_jzjddmzjs      = Json_Str(v_json_temp_bgk,
                                                    'vc_jzjddmzjs'),
                       vc_jzxxdzzjs      = Json_Str(v_json_temp_bgk,
                                                    'vc_jzxxdzzjs'),
                       vc_jzshedmws      = Json_Str(v_json_temp_bgk,
                                                    'vc_jzshedmws'),
                       vc_jzshidmws      = Json_Str(v_json_temp_bgk,
                                                    'vc_jzshidmws'),
                       vc_jzqxdmws       = Json_Str(v_json_temp_bgk,
                                                    'vc_jzqxdmws'),
                       vc_jzjddmws       = Json_Str(v_json_temp_bgk,
                                                    'vc_jzjddmws'),
                       vc_jzxxdzws       = Json_Str(v_json_temp_bgk,
                                                    'vc_jzxxdzws'),
                       vc_szsqbsjzztz    = Json_Str(v_json_temp_bgk,
                                                    'vc_szsqbsjzztz'),
                       vc_shbz           = Json_Str(v_json_temp_bgk,
                                                    'vc_shbz'),
                       validate_date     = v_sysdate
                
                 where vc_yyrid = v_id;
              
              end if;
            end if;
          end loop;
        end if;
      end loop;
    else
      v_err := '未获取到需要导入的数据!';
      raise err_custom;
    end if;
    --记录日志
    v_json_yw_log := Json_ext.get_json(v_json_data, 'ywjllog');
    if v_json_yw_log is not null then
      v_json_yw_log.put('bgkid', '');
      v_json_yw_log.put('bgklx', '00');
      v_json_yw_log.put('ywjlid', '');
      v_json_yw_log.put('gnmk', '01');
      v_json_yw_log.put('gnmc', '慢病导入');
      v_json_yw_log.put('czlx', '05');
      pkg_zjmb_xtfz.prc_zjjk_yw_log_update(v_json_yw_log, v_err);
      if v_err is not null then
        raise err_custom;
      end if;
    end if;
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_bgk_index || v_err, 0);
  END prc_bgk_excel_imp;
  /*--------------------------------------------------------------------------
  || 功能描述 ：业务记录
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_zjjk_yw_log_update(json_in    In json, --入参
                                   result_out OUT VARCHAR2) --返回
   is
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
  
    --公共变量
    v_sysdate date;
    v_ywrzid  zjjk_yw_log.id%TYPE; --ID
    v_ywjlid  zjjk_yw_log.ywjlid%TYPE; --ID
    v_yhm     zjjk_yw_log.yhm%TYPE; --用户名
    v_czsj    zjjk_yw_log.czsj%TYPE; --操作时间
    v_ip      zjjk_yw_log.ip%TYPE; --IP
    v_gjdq    zjjk_yw_log.gjdq%TYPE; --创建地区
    v_cs      zjjk_yw_log.cs%TYPE; --城市
    v_bgkid   zjjk_yw_log.bgkid%TYPE; --患者ID
    v_bgklx   zjjk_yw_log.bgklx%TYPE; --患者类型
    v_gnmk    zjjk_yw_log.gnmk%TYPE; --功能模块
    v_gnmc    zjjk_yw_log.gnmc%TYPE; --功能名称
    v_czlx    zjjk_yw_log.czlx%TYPE; --CZ类型
    v_jgdm    zjjk_yw_log.jgdm%TYPE; --机构代码
  
  BEGIN
    result_out := '';
    if json_in is null then
      return;
    end if;
    v_sysdate := sysdate;
    v_yhm     := Json_Str(json_in, 'yhm');
    v_ip      := Json_Str(json_in, 'ip');
    v_gjdq    := Json_Str(json_in, 'gjdq');
    v_cs      := Json_Str(json_in, 'cs');
    v_bgkid   := Json_Str(json_in, 'bgkid');
    v_bgklx   := Json_Str(json_in, 'bgklx');
    v_gnmk    := Json_Str(json_in, 'gnmk');
    v_gnmc    := Json_Str(json_in, 'gnmc');
    v_czlx    := Json_Str(json_in, 'czlx');
    v_ywjlid  := Json_Str(json_in, 'ywjlid');
    v_jgdm    := Json_Str(json_in, 'jgdm');
    v_ywrzid  := Json_Str(json_in, 'ywrzid');
    if v_yhm is not null and v_gnmc is not null and v_czlx is not null then
      if v_ywrzid is null then
        v_ywrzid := sys_guid();
      end if;
      insert into zjjk_yw_log
        (id,
         yhm,
         czsj,
         ip,
         gjdq,
         cs,
         bgkid,
         bgklx,
         gnmk,
         gnmc,
         czlx,
         ywjlid,
         jgdm)
      values
        (v_ywrzid,
         v_yhm,
         sysdate,
         v_ip,
         v_gjdq,
         v_cs,
         v_bgkid,
         v_bgklx,
         v_gnmk,
         v_gnmc,
         v_czlx,
         v_ywjlid,
         v_jgdm);
    else
      result_out := '业务日志记录信息不完整';
    end if;
    -- result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_zjjk_yw_log_update;
  /*--------------------------------------------------------------------------
  || 功能描述 ：业务记录
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_zjjk_yw_log(Data_In    In Clob, --入参
                            result_out OUT VARCHAR2) --返回
   is
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
  
    --公共变量
    v_sysdate date;
    v_czyjgdm varchar2(50);
    v_czyjgjb varchar2(3);
    v_czyyhid varchar2(50);
    v_czyyhxm varchar2(50);
  BEGIN
    json_data(data_in, '记录业务日志', v_json_data);
    pkg_zjmb_xtfz.prc_zjjk_yw_log_update(v_json_data, v_err);
    if v_err is not null then
      raise err_custom;
    end if;
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_zjjk_yw_log;
  /*--------------------------------------------------------------------------
  || 功能描述 ：下载管理文件上传
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_xzgl_file_imp(Data_In    In Clob, --入参
                              result_out OUT VARCHAR2) --返回
   is
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
  
    --公共变量
    v_sysdate date;
    v_czyjgdm varchar2(50);
    v_czyjgjb varchar2(3);
    v_czyyhid varchar2(50);
    v_czyyhxm varchar2(50);
  
    v_fileid zjjk_file_xzgl.fileid%TYPE; --文件ID
    v_xzqx   zjjk_file_xzgl.xzqx%TYPE; --下载权限
  
  BEGIN
    json_data(data_in, 'zjjk_file_xzgl文件上传', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm'); --操作员机构代码
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb'); --获取机构级别
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid'); --操作员id
    v_czyyhxm := Json_Str(v_Json_Data, 'czyyhxm'); --操作员姓名
    v_fileid  := Json_Str(v_Json_Data, 'fileid'); --文件id
    v_xzqx    := Json_Str(v_Json_Data, 'xzqx'); --下载权限
    if v_czyjgjb <> '1' then
      v_err := '当前用户无权上传!';
      raise err_custom;
    end if;
    if v_fileid is null then
      v_err := '文件ID不能为空!';
      raise err_custom;
    end if;
    --修改下载权限
    update zjjk_file_xzgl set xzqx = v_xzqx where fileid = v_fileid;
    if sql%rowcount = 0 then
      --新增
      insert into zjjk_file_xzgl
        (fileid, cjjgdm, cjryhm, cjrxm, cjsj, xzqx)
      values
        (v_fileid, v_czyjgdm, v_czyyhid, v_czyyhxm, v_sysdate, v_xzqx);
    end if;
    v_Json_Return.put('id', v_fileid);
    result_out := Return_Succ_Json(v_Json_Return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_xzgl_file_imp;
  /*--------------------------------------------------------------------------
  || 功能描述 ：下载管理文件目录删除
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_xzgl_file_del(Data_In    In Clob, --入参
                              result_out OUT VARCHAR2) --返回
   is
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
  
    --公共变量
    v_sysdate date;
    v_czyjgdm varchar2(50);
    v_czyjgjb varchar2(3);
    v_czyyhid varchar2(50);
    v_czyyhxm varchar2(50);
  
    v_fileid zjjk_file_xzgl.fileid%TYPE; --文件ID
  
  BEGIN
    json_data(data_in, 'zjjk_file_xzgl文件上传', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm'); --操作员机构代码
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb'); --获取机构级别
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid'); --操作员id
    v_czyyhxm := Json_Str(v_Json_Data, 'czyyhxm'); --操作员姓名
    v_fileid  := Json_Str(v_Json_Data, 'fileid'); --文件id
    if v_czyjgjb <> '1' then
      v_err := '当前用户无权删除!';
      raise err_custom;
    end if;
    if v_fileid is null then
      v_err := '文件ID不能为空!';
      raise err_custom;
    end if;
    --修改下载权限
    delete from zjjk_file_xzgl where fileid = v_fileid;
    if sql%rowcount = 0 then
      v_err := '未找到有效文件目录!';
      raise err_custom;
    end if;
    result_out := Return_Succ_Json(v_Json_Return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_xzgl_file_del;
  /*--------------------------------------------------------------------------
  || 功能描述 ：消息管理，发送邮件
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_xxgl_email_send(data_in    IN CLOB, --入参
                                result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
  
    --公共变量
    v_sysdate           DATE;
    v_cemailid          zjjk_email_mx.vc_emailid%TYPE; --邮件id 
    v_cxxbt             zjjk_email_mx.vc_xxbt%TYPE; --消息标题  
    v_cxxlb             zjjk_email_mx.vc_xxlb%TYPE; --消息类别  
    v_ccjyh             zjjk_email_mx.vc_cjyh%TYPE; --操作员用户id
    v_ccjyhjgid         zjjk_email_mx.vc_cjyhjgid%TYPE; --操作员机构代码
    v_cxxview           zjjk_email_mx.vc_xxview%TYPE; --消息预览
    v_cxxnr             CLOB; --消息内容 
    v_json_list_sjrids  json_list; --收件人id数组
    v_json_list_filesid json_list; --附件id数组
    --v_json_temp Json;
    v_csjrid  zjjk_email_sjr.sjrid%TYPE; --收件人id
    v_cfileid zjjk_email_files.fileid%TYPE; --附件id
  
  BEGIN
    json_data(data_in, 'ZJJK_EMAIL_MX发送消息', v_json_data);
    v_sysdate           := SYSDATE;
    v_cemailid          := json_str(v_json_data, 'emailid'); --邮件id 
    v_cxxbt             := json_str(v_json_data, 'vc_xxbt'); --消息标题  
    v_cxxlb             := json_str(v_json_data, 'vc_xxlb'); --消息类别  
    v_ccjyh             := json_str(v_json_data, 'czyyhid'); --操作员用户id
    v_ccjyhjgid         := json_str(v_json_data, 'czyjgdm'); --操作员机构代码
    v_cxxview           := json_str(v_json_data, 'vc_xxview'); --消息预览
    v_cxxnr             := json_get_clob(json_clob(v_json_data), 'vc_xxnr'); --消息内容 
    v_json_list_sjrids  := json_ext.get_json_list(v_json_data, 'sjrids'); --收件人id数组
    v_json_list_filesid := json_ext.get_json_list(v_json_data, 'filesid'); --附件id数组
  
    --插入邮件明细
    INSERT INTO zjjk_email_mx
      (vc_emailid,
       vc_xxbt,
       vc_xxlb,
       vc_cjyh,
       vc_cjyhjgid,
       vc_cjrq,
       vc_xxview,
       vc_xxnr)
    VALUES
      (v_cemailid,
       v_cxxbt,
       v_cxxlb,
       v_ccjyh,
       v_ccjyhjgid,
       v_sysdate,
       v_cxxview,
       v_cxxnr);
    --记录邮件接收人
    IF v_json_list_sjrids.count > 0 THEN
      FOR i IN 1 .. v_json_list_sjrids.count LOOP
        v_csjrid := v_json_list_sjrids.get(i).to_char;
        INSERT INTO zjjk_email_sjr
          (emailid, sjrid, vc_sfyd, vc_scbz)
        VALUES
          (v_cemailid, REPLACE(v_csjrid, '"', ''), '2', '2');
      END LOOP;
    END IF;
    --记录邮件附件列表
    IF v_json_list_filesid.count > 0 THEN
      FOR i IN 1 .. v_json_list_filesid.count LOOP
        v_cfileid := v_json_list_filesid.get(i).to_char;
        INSERT INTO zjjk_email_files
          (fileid, emailid, scsj)
        VALUES
          (REPLACE(v_cfileid, '"', ''), v_cemailid, v_sysdate);
      END LOOP;
    END IF;
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_xxgl_email_send;
  /*--------------------------------------------------------------------------
  || 功能描述 ：消息管理，设置已读
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_xxgl_email_read(data_in    IN CLOB, --入参
                                result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
  
    --公共变量
    v_sysdate  DATE;
    v_cemailid zjjk_email_mx.vc_emailid%TYPE; --邮件id 
    v_csjrid   zjjk_email_sjr.sjrid%TYPE; --收件人ID
  
  BEGIN
    json_data(data_in, 'ZJJK_EMAIL_MX阅读消息', v_json_data);
    v_sysdate  := SYSDATE;
    v_cemailid := json_str(v_json_data, 'vc_emailid'); --邮件id
    v_csjrid   := json_str(v_json_data, 'sjrid'); --操作员机构代码
  
    UPDATE zjjk_email_sjr
       SET vc_sfyd = 1, ydsj = v_sysdate
     WHERE emailid = v_cemailid
       AND sjrid = v_csjrid;
  
    result_out := return_succ_json(v_json_return);
  
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_xxgl_email_read;
  /*--------------------------------------------------------------------------
  || 功能描述 ：消息管理，设置删除
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_xxgl_email_del(data_in    IN CLOB, --入参
                               result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
  
    --公共变量
    v_cemailid zjjk_email_mx.vc_emailid%TYPE; --邮件id 
    v_csjrid   zjjk_email_sjr.sjrid%TYPE; --收件人ID
  
  BEGIN
    json_data(data_in, 'ZJJK_EMAIL_MX阅读消息', v_json_data);
    v_cemailid := json_str(v_json_data, 'vc_emailid'); --邮件id 
    v_csjrid   := json_str(v_json_data, 'sjrid'); --操作员机构代码
  
    UPDATE zjjk_email_sjr
       SET vc_scbz = 1
     WHERE emailid = v_cemailid
       AND sjrid = v_csjrid;
  
    result_out := return_succ_json(v_json_return);
  
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_xxgl_email_del;
  /*--------------------------------------------------------------------------
  || 功能描述 ：质量复核时间设置-慢性病
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_zlfl_sjsz(data_in    IN CLOB, --入参
                          result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
  
    --公共变量
    v_sysdate DATE;
    v_czyjgdm VARCHAR2(50);
    v_czyjgjb VARCHAR2(3);
    v_czyyhid VARCHAR2(50);
    v_czyyhxm VARCHAR2(50);
  
    v_jlbh     zjjk_zlfhsj.jlbh%TYPE; --记录编号
    v_dt_ksrq  zjjk_zlfhsj.dt_ksrq%TYPE; --开始日期
    v_dt_jsrq  zjjk_zlfhsj.dt_jsrq%TYPE; --结束日期
    v_ccbz     zjjk_zlfhsj.ccbz%TYPE; --抽查病种
    v_ccts     zjjk_zlfhsj.ccts%TYPE; --抽查条数
    v_nczicd10 zjjk_zlfhsj.nczicd10%TYPE; --脑卒中icd10
    v_gxbicd10 zjjk_zlfhsj.gxbicd10%TYPE; --冠心病icd10
    v_tnbicd10 zjjk_zlfhsj.tnbicd10%TYPE; --糖尿病icd10
    v_zlicd10  zjjk_zlfhsj.zlicd10%TYPE; --肿瘤icd10
  
  BEGIN
    json_data(data_in, '质量复核时间设置-慢性病', v_json_data);
    v_sysdate  := SYSDATE;
    v_dt_ksrq  := std(substr(json_str(v_json_data, 'dt_ksrq'), 1, 10) ||
                      '00:00:00',
                      1); --开始日期
    v_dt_jsrq  := std(substr(json_str(v_json_data, 'dt_jsrq'), 1, 10) ||
                      '23:59:59',
                      1); --结束日期
    v_ccbz     := json_str(v_json_data, 'ccbz'); --抽查病种
    v_ccts     := json_str(v_json_data, 'ccts'); --抽查条数
    v_nczicd10 := json_str(v_json_data, 'nczicd10'); --脑卒中icd10
    v_gxbicd10 := json_str(v_json_data, 'gxbicd10'); --冠心病icd10
    v_tnbicd10 := json_str(v_json_data, 'tnbicd10'); --糖尿病icd10
    v_zlicd10  := json_str(v_json_data, 'zlicd10'); --肿瘤icd10
    v_jlbh     := json_str(v_json_data, 'jlbh'); --记录编号
    v_czyjgdm  := json_str(v_json_data, 'czyjgdm'); --操作员机构代码
    v_czyjgjb  := json_str(v_json_data, 'czyjgjb'); --获取机构级别
    v_czyyhid  := json_str(v_json_data, 'czyyhid'); --操作员id
    v_czyyhxm  := json_str(v_json_data, 'czyyhxm'); --操作员姓名
  
    if v_czyjgjb <> 1 then
      v_err := '没有设置权限!';
      raise err_custom;
    end if;
  
    UPDATE zjjk_zlfhsj SET zt = 0 WHERE zt = 1;
    IF v_jlbh IS NULL THEN
      INSERT INTO zjjk_zlfhsj
        (jlbh,
         dt_ksrq,
         dt_jsrq,
         szrid,
         szrxm,
         szjgid,
         szsj,
         zt,
         ccbz,
         ccts,
         nczicd10,
         gxbicd10,
         tnbicd10,
         zlicd10)
      VALUES
        (sys_guid(),
         v_dt_ksrq,
         v_dt_jsrq,
         v_czyyhid,
         v_czyyhxm,
         v_czyjgdm,
         v_sysdate,
         1,
         v_ccbz,
         v_ccts,
         v_nczicd10,
         v_gxbicd10,
         v_tnbicd10,
         v_zlicd10);
    ELSE
      UPDATE zjjk_zlfhsj
         SET szrid  = v_czyyhid,
             szrxm  = v_czyyhxm,
             szjgid = v_czyjgdm,
             szsj   = v_sysdate,
             zt     = 1
       WHERE jlbh = v_jlbh;
    END IF;
  
    result_out := return_succ_json(v_json_return);
  
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_zlfl_sjsz;

  /*--------------------------------------------------------------------------
  || 功能描述 ：质量复核时间设置-初访
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_zlfl_sjsz_cf(data_in    IN CLOB, --入参
                             result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
  
    --公共变量
    v_sysdate DATE;
    v_czyjgdm VARCHAR2(50);
    v_czyjgjb VARCHAR2(3);
    v_czyyhid VARCHAR2(50);
    v_czyyhxm VARCHAR2(50);
  
    v_jlbh     zjjk_zlfhsj.jlbh%TYPE; --记录编号
    v_dt_ksrq  zjjk_zlfhsj.dt_ksrq%TYPE; --开始日期
    v_dt_jsrq  zjjk_zlfhsj.dt_jsrq%TYPE; --结束日期
    v_ccbz     zjjk_zlfhsj.ccbz%TYPE; --抽查病种
    v_ccts     zjjk_zlfhsj.ccts%TYPE; --抽查条数
    v_nczicd10 zjjk_zlfhsj.nczicd10%TYPE; --脑卒中icd10
    v_gxbicd10 zjjk_zlfhsj.gxbicd10%TYPE; --冠心病icd10
    v_tnbicd10 zjjk_zlfhsj.tnbicd10%TYPE; --糖尿病icd10
    v_zlicd10  zjjk_zlfhsj.zlicd10%TYPE; --肿瘤icd10
  
  BEGIN
    json_data(data_in, '质量复核时间设置-初访', v_json_data);
    v_sysdate  := SYSDATE;
    v_dt_ksrq  := std(substr(json_str(v_json_data, 'dt_ksrq'), 1, 10) ||
                      '00:00:00',
                      1); --开始日期
    v_dt_jsrq  := std(substr(json_str(v_json_data, 'dt_jsrq'), 1, 10) ||
                      '23:59:59',
                      1); --结束日期
    v_ccbz     := json_str(v_json_data, 'ccbz'); --抽查病种
    v_ccts     := json_str(v_json_data, 'ccts'); --抽查条数
    v_nczicd10 := json_str(v_json_data, 'nczicd10'); --脑卒中icd10
    v_gxbicd10 := json_str(v_json_data, 'gxbicd10'); --冠心病icd10
    v_tnbicd10 := json_str(v_json_data, 'tnbicd10'); --糖尿病icd10
    v_zlicd10  := json_str(v_json_data, 'zlicd10'); --肿瘤icd10
    v_jlbh     := json_str(v_json_data, 'jlbh'); --记录编号
    v_czyjgdm  := json_str(v_json_data, 'czyjgdm'); --操作员机构代码
    v_czyjgjb  := json_str(v_json_data, 'czyjgjb'); --获取机构级别
    v_czyyhid  := json_str(v_json_data, 'czyyhid'); --操作员id
    v_czyyhxm  := json_str(v_json_data, 'czyyhxm'); --操作员姓名
  
    if v_czyjgjb <> 1 then
      v_err := '没有设置权限!';
      raise err_custom;
    end if;
  
    UPDATE zjjk_zlfhsj_cf SET zt = 0 WHERE zt = 1;
    IF v_jlbh IS NULL THEN
      INSERT INTO zjjk_zlfhsj_cf
        (jlbh,
         dt_ksrq,
         dt_jsrq,
         szrid,
         szrxm,
         szjgid,
         szsj,
         zt,
         ccbz,
         ccts,
         nczicd10,
         gxbicd10,
         tnbicd10,
         zlicd10)
      VALUES
        (sys_guid(),
         v_dt_ksrq,
         v_dt_jsrq,
         v_czyyhid,
         v_czyyhxm,
         v_czyjgdm,
         v_sysdate,
         1,
         v_ccbz,
         v_ccts,
         v_nczicd10,
         v_gxbicd10,
         v_tnbicd10,
         v_zlicd10);
    ELSE
      UPDATE zjjk_zlfhsj_cf
         SET szrid  = v_czyyhid,
             szrxm  = v_czyyhxm,
             szjgid = v_czyjgdm,
             szsj   = v_sysdate,
             zt     = 1
       WHERE jlbh = v_jlbh;
    END IF;
  
    result_out := return_succ_json(v_json_return);
  
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_zlfl_sjsz_cf;

  /*--------------------------------------------------------------------------
  || 功能描述 ：质量复核时间设置-随访
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_zlfl_sjsz_sf(data_in    IN CLOB, --入参
                             result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
  
    --公共变量
    v_sysdate DATE;
    v_czyjgdm VARCHAR2(50);
    v_czyjgjb VARCHAR2(3);
    v_czyyhid VARCHAR2(50);
    v_czyyhxm VARCHAR2(50);
  
    v_jlbh     zjjk_zlfhsj.jlbh%TYPE; --记录编号
    v_dt_ksrq  zjjk_zlfhsj.dt_ksrq%TYPE; --开始日期
    v_dt_jsrq  zjjk_zlfhsj.dt_jsrq%TYPE; --结束日期
    v_ccbz     zjjk_zlfhsj.ccbz%TYPE; --抽查病种
    v_ccts     zjjk_zlfhsj.ccts%TYPE; --抽查条数
    v_nczicd10 zjjk_zlfhsj.nczicd10%TYPE; --脑卒中icd10
    v_gxbicd10 zjjk_zlfhsj.gxbicd10%TYPE; --冠心病icd10
    v_tnbicd10 zjjk_zlfhsj.tnbicd10%TYPE; --糖尿病icd10
    v_zlicd10  zjjk_zlfhsj.zlicd10%TYPE; --肿瘤icd10
  
  BEGIN
    json_data(data_in, '质量复核时间设置-随访', v_json_data);
    v_sysdate  := SYSDATE;
    v_dt_ksrq  := std(substr(json_str(v_json_data, 'dt_ksrq'), 1, 10) ||
                      '00:00:00',
                      1); --开始日期
    v_dt_jsrq  := std(substr(json_str(v_json_data, 'dt_jsrq'), 1, 10) ||
                      '23:59:59',
                      1); --结束日期
    v_ccbz     := json_str(v_json_data, 'ccbz'); --抽查病种
    v_ccts     := json_str(v_json_data, 'ccts'); --抽查条数
    v_nczicd10 := json_str(v_json_data, 'nczicd10'); --脑卒中icd10
    v_gxbicd10 := json_str(v_json_data, 'gxbicd10'); --冠心病icd10
    v_tnbicd10 := json_str(v_json_data, 'tnbicd10'); --糖尿病icd10
    v_zlicd10  := json_str(v_json_data, 'zlicd10'); --肿瘤icd10
    v_jlbh     := json_str(v_json_data, 'jlbh'); --记录编号
    v_czyjgdm  := json_str(v_json_data, 'czyjgdm'); --操作员机构代码
    v_czyjgjb  := json_str(v_json_data, 'czyjgjb'); --获取机构级别
    v_czyyhid  := json_str(v_json_data, 'czyyhid'); --操作员id
    v_czyyhxm  := json_str(v_json_data, 'czyyhxm'); --操作员姓名
  
    if v_czyjgjb <> 1 then
      v_err := '没有设置权限!';
      raise err_custom;
    end if;
  
    UPDATE zjjk_zlfhsj_sf SET zt = 0 WHERE zt = 1;
    IF v_jlbh IS NULL THEN
      INSERT INTO zjjk_zlfhsj_sf
        (jlbh,
         dt_ksrq,
         dt_jsrq,
         szrid,
         szrxm,
         szjgid,
         szsj,
         zt,
         ccbz,
         ccts,
         nczicd10,
         gxbicd10,
         tnbicd10,
         zlicd10)
      VALUES
        (sys_guid(),
         v_dt_ksrq,
         v_dt_jsrq,
         v_czyyhid,
         v_czyyhxm,
         v_czyjgdm,
         v_sysdate,
         1,
         v_ccbz,
         v_ccts,
         v_nczicd10,
         v_gxbicd10,
         v_tnbicd10,
         v_zlicd10);
    ELSE
      UPDATE zjjk_zlfhsj_sf
         SET szrid  = v_czyyhid,
             szrxm  = v_czyyhxm,
             szjgid = v_czyjgdm,
             szsj   = v_sysdate,
             zt     = 1
       WHERE jlbh = v_jlbh;
    END IF;
  
    result_out := return_succ_json(v_json_return);
  
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_zlfl_sjsz_sf;
  /*--------------------------------------------------------------------------
  || 功能描述 ：报告卡变更记录
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_zjjk_yw_log_bgjl(prm_ywrzid  in varchar2,
                                 prm_bgkid   in varchar2,
                                 prm_bgklx   in varchar2,
                                 prm_bgzddm  in varchar2,
                                 prm_bgzdmc  in varchar2,
                                 prm_bgqz    in varchar2,
                                 prm_bghz    in varchar2,
                                 prm_diccode in varchar2,
                                 prm_cjr     in varchar2,
                                 prm_cjjg    in varchar2,
                                 result_out  OUT VARCHAR2) --返回
   is
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
  BEGIN
    result_out := '';
    --发生变更
    if prm_bgqz <> prm_bghz or (prm_bgqz is null and prm_bghz is not null) or
       (prm_bgqz is not null and prm_bghz is null) then
      insert into zjjk_yw_log_bgjl
        (ywrzid,
         bgkid,
         bgklx,
         bgzddm,
         bgzdmc,
         diccode,
         bgqz,
         bghz,
         cjsj,
         cjr,
         cjjg)
      values
        (prm_ywrzid,
         prm_bgkid,
         prm_bgklx,
         prm_bgzddm,
         prm_bgzdmc,
         upper(prm_diccode),
         prm_bgqz,
         prm_bghz,
         sysdate,
         prm_cjr,
         prm_cjjg);
    end if;
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_zjjk_yw_log_bgjl;
  /*--------------------------------------------------------------------------
  || 功能描述 ：上传临时文件转正
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_t_file_source_temp_zz(data_in    IN CLOB, --入参
                                      result_out OUT VARCHAR2) --返回
   is
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
    --公共变量
    v_sysdate   date;
    v_czyjgdm   varchar2(50);
    v_czyjgid   varchar2(50);
    v_czyjgjb   varchar2(3);
    v_fileid_s  varchar2(4000);
    v_fileid    t_file_source.id%TYPE; --id
    v_json_list json_List; --文件id
  BEGIN
    json_data(data_in, '上传临时文件正式启用', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyjgid := Json_Str(v_Json_Data, 'czyjgid');
  
    v_json_list := Json_Ext.Get_Json_List(v_Json_Data, 'fileid_arr'); --文件id
    if v_json_list.count > 0 then
      v_fileid_s := '';
      for i in 1 .. v_json_list.count loop
        v_fileid   := v_json_list.Get(i).get_string;
        v_fileid_s := v_fileid_s || ',' || v_fileid;
        if mod(i, 100) = 0 or i = v_json_list.count then
          v_fileid_s := substr(v_fileid_s, 2);
          --插入正式文件记录表，一次插入100条
          insert into t_file_source
            (id, oname, name, server, path, ywid, cjsj)
            select id, oname, name, server, path, ywid, cjsj
              from t_file_source_temp
             where id in (select distinct column_value column_value
                            from table(split(v_fileid_s, ',')));
          --删除临时文件记录
          delete from t_file_source_temp
           where id in (select distinct column_value column_value
                          from table(split(v_fileid_s, ',')));
          v_fileid_s := '';
        end if;
      end loop;
    end if;
    --返回
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_t_file_source_temp_zz;

  /*--------------------------------------------------------------------------
  || 功能描述 ：质量复核-更新表中存的图片id
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_t_file_source_update(data_in    IN CLOB, --入参
                                     result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
    --公共变量
    v_sysdate   DATE;
    v_czyjgdm   VARCHAR2(50);
    v_czyjgid   VARCHAR2(50);
    v_czyjgjb   VARCHAR2(3);
    v_id        VARCHAR2(50); --表
    v_tps       json; --上传的图片
    v_tablename VARCHAR2(50); --表
  
  BEGIN
    json_data(data_in, '质量复核-更新表中存的图片id', v_json_data);
    v_sysdate   := SYSDATE;
    v_id        := json_str(v_json_data, 'id');
    v_tps       := json_ext.get_json(v_json_data, 'tps');
    v_tablename := json_str(v_json_data, 'tablename');
  
    IF v_id IS NULL OR v_id = '' THEN
      v_err := 'id不能为空!';
      RAISE err_custom;
    END IF;
    IF v_tablename IS NULL OR v_tablename = '' THEN
      v_err := 'tablename不能为空!';
      RAISE err_custom;
    END IF;
    IF v_tps IS NULL THEN
      v_err := 'tps不能为空!';
      RAISE err_custom;
    END IF;
    --脑卒中图片更新
    IF v_tablename = 'zlfh_ncz' THEN
      UPDATE zjjk_mb_zlfh_ncz a
         SET a.basyzp     = json_str(v_tps, 'basyzp'),
             a.cyxjzp     = json_str(v_tps, 'cyxjzp'),
             a.ryjlzp     = json_str(v_tps, 'ryjlzp'),
             a.tbjcbbzp   = json_str(v_tps, 'tbjcbbzp'),
             a.yzccjcbgzp = json_str(v_tps, 'yzccjcbgzp'),
             a.xgzybgzp   = json_str(v_tps, 'xgzybgzp'),
             a.sjbgzp     = json_str(v_tps, 'sjbgzp')
       WHERE a.id = v_id;
    END IF;
    --冠心病图片更新
    IF v_tablename = 'zlfh_gxb' THEN
      UPDATE zjjk_mb_zlfh_gxb a
         SET a.basyzp        = json_str(v_tps, 'basyzp'),
             a.cyxjzp        = json_str(v_tps, 'cyxjzp'),
             a.ryjlzp        = json_str(v_tps, 'ryjlzp'),
             a.xdtjcbgzp     = json_str(v_tps, 'xdtjcbgzp'),
             a.xqmjczp       = json_str(v_tps, 'xqmjczp'),
             a.xzxgzdmzybgzp = json_str(v_tps, 'xzxgzdmzybgzp')
       WHERE a.id = v_id;
    END IF;
    --糖尿病图片更新
    IF v_tablename = 'zlfh_tnb' THEN
      UPDATE zjjk_mb_zlfh_tnb a
         SET a.basyzp       = json_str(v_tps, 'basyzp'),
             a.cyxjzp       = json_str(v_tps, 'cyxjzp'),
             a.ryjlzp       = json_str(v_tps, 'ryjlzp'),
             a.yscfzp       = json_str(v_tps, 'yscfzp'),
             a.ydxbzsktzp   = json_str(v_tps, 'ydxbzsktzp'),
             a.xtbgzp       = json_str(v_tps, 'xtbgzp'),
             a.zptnxsybgzp  = json_str(v_tps, 'zptnxsybgzp'),
             a.thxhdbjcbgzp = json_str(v_tps, 'thxhdbjcbgzp'),
             a.ncgzp        = json_str(v_tps, 'ncgzp')
       WHERE a.id = v_id;
    END IF;
    --肺癌图片更新
    IF v_tablename = 'zlfh_fa' THEN
      UPDATE zjjk_mb_zlfh_fa a
         SET a.basyzp      = json_str(v_tps, 'basyzp'),
             a.cyxjzp      = json_str(v_tps, 'cyxjzp'),
             a.ryjlzp      = json_str(v_tps, 'ryjlzp'),
             a.hjblbgzp    = json_str(v_tps, 'hjblbgzp'),
             a.qzjjcbgzp   = json_str(v_tps, 'qzjjcbgzp'),
             a.ctjcbgzp    = json_str(v_tps, 'ctjcbgzp'),
             a.mrijcbgzp   = json_str(v_tps, 'mrijcbgzp'),
             a.xxjcbgzp    = json_str(v_tps, 'xxjcbgzp'),
             a.ttlxbjcbgzp = json_str(v_tps, 'ttlxbjcbgzp')
       WHERE a.id = v_id;
    END IF;
    --肝癌图片更新
    IF v_tablename = 'zlfh_ga' THEN
      UPDATE zjjk_mb_zlfh_ga a
         SET a.basyzp       = json_str(v_tps, 'basyzp'),
             a.cyxjzp       = json_str(v_tps, 'cyxjzp'),
             a.ryjlzp       = json_str(v_tps, 'ryjlzp'),
             a.gcchjblbgzp  = json_str(v_tps, 'gcchjblbgzp'),
             a.jtdbdxzdbgzp = json_str(v_tps, 'jtdbdxzdbgzp'),
             a.ctjcbgzp     = json_str(v_tps, 'ctjcbgzp'),
             a.mrijcbgzp    = json_str(v_tps, 'mrijcbgzp'),
             a.bcjcbgzp     = json_str(v_tps, 'bcjcbgzp')
       WHERE a.id = v_id;
    END IF;
    --胃癌图片更新
    IF v_tablename = 'zlfh_wa' THEN
      UPDATE zjjk_mb_zlfh_wa a
         SET a.basyzp          = json_str(v_tps, 'basyzp'),
             a.cyxjzp          = json_str(v_tps, 'cyxjzp'),
             a.ryjlzp          = json_str(v_tps, 'ryjlzp'),
             a.qwwjxnmhjblbgzp = json_str(v_tps, 'qwwjxnmhjblbgzp'),
             a.wxxbcjcbgzp     = json_str(v_tps, 'wxxbcjcbgzp'),
             a.wtlxbxjcbgzp    = json_str(v_tps, 'wtlxbxjcbgzp')
       WHERE a.id = v_id;
    END IF;
    --食管癌图片更新
    IF v_tablename = 'zlfh_sga' THEN
      UPDATE zjjk_mb_zlfh_sga a
         SET a.basyzp          = json_str(v_tps, 'basyzp'),
             a.cyxjzp          = json_str(v_tps, 'cyxjzp'),
             a.ryjlzp          = json_str(v_tps, 'ryjlzp'),
             a.sgjxhjblbgzp    = json_str(v_tps, 'sgjxhjblbgzp'),
             a.sgnmtlxbxjcbgzp = json_str(v_tps, 'sgnmtlxbxjcbgzp'),
             a.xxtbjcbgzp      = json_str(v_tps, 'xxtbjcbgzp')
       WHERE a.id = v_id;
    END IF;
    --结直肠癌图片更新
    IF v_tablename = 'zlfh_jzca' THEN
      UPDATE zjjk_mb_zlfh_jzca a
         SET a.basyzp       = json_str(v_tps, 'basyzp'),
             a.cyxjzp       = json_str(v_tps, 'cyxjzp'),
             a.ryjlzp       = json_str(v_tps, 'ryjlzp'),
             a.jcjxhjblbgzp = json_str(v_tps, 'jcjxhjblbgzp'),
             a.zccssmjcbgzp = json_str(v_tps, 'zccssmjcbgzp'),
             a.xqapkycdbgzp = json_str(v_tps, 'xqapkycdbgzp'),
             a.tbgcxxjcbgzp = json_str(v_tps, 'tbgcxxjcbgzp')
       WHERE a.id = v_id;
    END IF;
    --女性乳腺癌图片更新
    IF v_tablename = 'zlfh_nxrxa' THEN
      UPDATE zjjk_mb_zlfh_nxrxa a
         SET a.basyzp         = json_str(v_tps, 'basyzp'),
             a.cyxjzp         = json_str(v_tps, 'cyxjzp'),
             a.ryjlzp         = json_str(v_tps, 'ryjlzp'),
             a.rxzzxblbgzp    = json_str(v_tps, 'rxzzxblbgzp'),
             a.rxcsjcbgzp     = json_str(v_tps, 'rxcsjcbgzp'),
             a.rxzxjcbgzp     = json_str(v_tps, 'rxzxjcbgzp'),
             a.rxadjsstztbgzp = json_str(v_tps, 'rxadjsstztbgzp')
       WHERE a.id = v_id;
    END IF;
    --其他恶性肿瘤图片更新
    IF v_tablename = 'zlfh_qtexzl' THEN
      UPDATE zjjk_mb_zlfh_qtexzl a
         SET a.basyzp      = json_str(v_tps, 'basyzp'),
             a.cyxjzp      = json_str(v_tps, 'cyxjzp'),
             a.ryjlzp      = json_str(v_tps, 'ryjlzp'),
             a.zzxblbgzp   = json_str(v_tps, 'zzxblbgzp'),
             a.ctmrijcbgzp = json_str(v_tps, 'ctmrijcbgzp')
       WHERE a.id = v_id;
    END IF;
    --返回
    result_out := return_succ_json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_t_file_source_update;

END pkg_zjmb_xtfz;
