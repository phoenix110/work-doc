CREATE OR REPLACE PACKAGE BODY pkg_zjmb_zl AS
  /******************************************************************************/
  /*  程序包名 ：pkg_zjmb_zl                                                  */
  /*  业务环节 ：浙江慢病_肿瘤管理                                              */
  /*  功能描述 ：为慢病肿瘤管理相关的存储过程及函数                           */
  /*                                                                            */
  /*  作    者 ：          作成日期 ：2018-03-14   版本编号 ：Ver 1.0.0  */
  /*----------------------------------------------------------------------------*/
  /*  修改记录 ：                                                               */
  /******************************************************************************/
  /*  修改记录 ：                                                               */
  /******************************************************************************/
  /*-------------------------------------------------------------------------*/
  /*-------------------------------------------------------------------------*/
  /*--------------------------------------------------------------------------
  || 功能描述 ：肿瘤报告卡新增或者修改
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_zlbgk_update(Data_In    In Clob, --入参
                             result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_yw_log json;
    v_ywjl_czlx   varchar2(3);
    v_sysdate     date;
    v_czyjgjb     VARCHAR2(10);
    v_czyjgdm     VARCHAR2(50);
    v_count       number(1);
    v_Json_Return Json := Json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
    --定义患者信息表量
    h_vc_personid zjjk_zl_hzxx.vc_personid%TYPE; --患者ID
    h_vc_hzxm     zjjk_zl_hzxx.vc_hzxm%TYPE; --患者姓名
    h_vc_hzxb     zjjk_zl_hzxx.vc_hzxb%TYPE; --患者性别
    h_vc_hzmz     zjjk_zl_hzxx.vc_hzmz%TYPE; --患者民族
    h_dt_hzcsrq   zjjk_zl_hzxx.dt_hzcsrq%TYPE; --患者出生日期
    h_vc_sfzh     zjjk_zl_hzxx.vc_sfzh%TYPE; --身份证号
    h_vc_jtdh     zjjk_zl_hzxx.vc_jtdh%TYPE; --家庭电话
    h_vc_gzdw     zjjk_zl_hzxx.vc_gzdw%TYPE; --工作单位
    h_vc_zydm     zjjk_zl_hzxx.vc_zydm%TYPE; --职业代码
    h_vc_jtgz     zjjk_zl_hzxx.vc_jtgz%TYPE; --具体工种
    h_vc_hksfdm   zjjk_zl_hzxx.vc_hksfdm%TYPE; --户口省份代码
    h_vc_hksdm    zjjk_zl_hzxx.vc_hksdm%TYPE; --户口市级代码
    h_vc_hkjddm   zjjk_zl_hzxx.vc_hkjddm%TYPE; --户口街道代码
    h_vc_hkqxdm   zjjk_zl_hzxx.vc_hkqxdm%TYPE; --户口区县代码
    h_vc_hkjwdm   zjjk_zl_hzxx.vc_hkjwdm%TYPE; --户口居委代码
    h_vc_hkxxdz   zjjk_zl_hzxx.vc_hkxxdz%TYPE; --户口详细地址
    h_vc_sjsfdm   zjjk_zl_hzxx.vc_sjsfdm%TYPE; --实际居住省份代码
    h_vc_sjsdm    zjjk_zl_hzxx.vc_sjsdm%TYPE; --实际市级代码
    h_vc_sjqxdm   zjjk_zl_hzxx.vc_sjqxdm%TYPE; --实际区县代码
    h_vc_sjjddm   zjjk_zl_hzxx.vc_sjjddm%TYPE; --实际居住街道代码
    h_vc_sjjwdm   zjjk_zl_hzxx.vc_sjjwdm%TYPE; --实际居住居委代码
    h_vc_sjxxdz   zjjk_zl_hzxx.vc_sjxxdz%TYPE; --实际居住详细地址
    h_vc_gldwdm   zjjk_zl_hzxx.vc_gldwdm%TYPE; --管理单位代码(目前作废字段)
    h_vc_sfsw     zjjk_zl_hzxx.vc_sfsw%TYPE; --是否死亡
    h_vc_sfhs     zjjk_zl_hzxx.vc_sfhs%TYPE; --是否户口核实(目前作废字段)
    h_vc_sjhm     zjjk_zl_hzxx.vc_sjhm%TYPE; --手机号码
    h_vc_dydz     zjjk_zl_hzxx.vc_dydz%TYPE; --电邮地址
    h_vc_jzyb     zjjk_zl_hzxx.vc_jzyb%TYPE; --居住邮编
    h_vc_hkyb     zjjk_zl_hzxx.vc_hkyb%TYPE; --户口邮编
    h_vc_bak_hy   zjjk_zl_hzxx.vc_bak_hy%TYPE; --备份职业
    h_vc_bak_zy   zjjk_zl_hzxx.vc_bak_zy%TYPE; --备份行业
    h_vc_bak_sfzh zjjk_zl_hzxx.vc_bak_sfzh%TYPE; --备份身份证
  
    --定义肿瘤报告卡变量
    v_vc_bgkid     zjjk_zl_bgk.vc_bgkid%TYPE; --报告卡ID
    v_vc_bgklx     zjjk_zl_bgk.vc_bgklx%TYPE; --报告卡类型;1.常规卡；2.死亡补发卡
    v_vc_xzqybm    zjjk_zl_bgk.vc_xzqybm%TYPE; --行政区划编码(目前无效)
    v_vc_bqygzbr   zjjk_zl_bgk.vc_bqygzbr%TYPE; --病情已告知病人
    v_vc_mzh       zjjk_zl_bgk.vc_mzh%TYPE; --门诊号
    v_vc_zyh       zjjk_zl_bgk.vc_zyh%TYPE; --住院号
    v_vc_hzid      zjjk_zl_bgk.vc_hzid%TYPE; --患者ID
    v_vc_icd10     zjjk_zl_bgk.vc_icd10%TYPE; --ICD—10
    v_vc_icdo      zjjk_zl_bgk.vc_icdo%TYPE; --ICD—O
    v_vc_sznl      zjjk_zl_bgk.vc_sznl%TYPE; --实足年龄
    v_vc_zdbw      zjjk_zl_bgk.vc_zdbw%TYPE; --诊断部位
    v_vc_blxlx     zjjk_zl_bgk.vc_blxlx%TYPE; --病理学类型
    v_vc_blh       zjjk_zl_bgk.vc_blh%TYPE; --病理号
    v_vc_zdsqb     zjjk_zl_bgk.vc_zdsqb%TYPE; --诊断时期别
    v_dt_zdrq      zjjk_zl_bgk.dt_zdrq%TYPE; --诊断日期
    v_vc_zgzddw    zjjk_zl_bgk.vc_zgzddw%TYPE; --最高诊断单位
    v_vc_bgdwqx    zjjk_zl_bgk.vc_bgdwqx%TYPE; --报告单位区县
    v_vc_bgys      zjjk_zl_bgk.vc_bgys%TYPE; --报告医生
    v_dt_bgrq      zjjk_zl_bgk.dt_bgrq%TYPE; --报告日期
    v_vc_swxx      zjjk_zl_bgk.vc_swxx%TYPE; --死亡信息
    v_dt_swrq      zjjk_zl_bgk.dt_swrq%TYPE; --死亡日期
    v_vc_swyy      zjjk_zl_bgk.vc_swyy%TYPE; --死亡原因
    v_vc_swicd10   zjjk_zl_bgk.vc_swicd10%TYPE; --死亡ICD—10
    v_vc_zdyh      zjjk_zl_bgk.vc_zdyh%TYPE; --诊断依据
    v_vc_bszy      zjjk_zl_bgk.vc_bszy%TYPE; --病史摘要
    v_vc_dcr       zjjk_zl_bgk.vc_dcr%TYPE; --调查人
    v_dt_dcrq      zjjk_zl_bgk.dt_dcrq%TYPE; --调查日期
    v_vc_bz        zjjk_zl_bgk.vc_bz%TYPE; --备注
    v_vc_scbz      zjjk_zl_bgk.vc_scbz%TYPE; --删除标志
    v_vc_ccid      zjjk_zl_bgk.vc_ccid%TYPE; --查重ID
    v_vc_ckbz      zjjk_zl_bgk.vc_ckbz%TYPE; --重卡标志
    v_vc_xxly      zjjk_zl_bgk.vc_xxly%TYPE; --信息来源
    v_vc_sfbb      zjjk_zl_bgk.vc_sfbb%TYPE; --是否补报
    v_vc_sdqrzt    zjjk_zl_bgk.vc_sdqrzt%TYPE; --属地确认状态
    v_dt_qrsj      zjjk_zl_bgk.dt_qrsj%TYPE; --确认时间
    v_vc_sdqrid    zjjk_zl_bgk.vc_sdqrid%TYPE; --属地确认ID
    v_dt_cjsj      zjjk_zl_bgk.dt_cjsj%TYPE; --创建时间
    v_vc_cjyh      zjjk_zl_bgk.vc_cjyh%TYPE; --创建用户
    v_dt_xgsj      zjjk_zl_bgk.dt_xgsj%TYPE; --修改时间
    v_vc_xgyh      zjjk_zl_bgk.vc_xgyh%TYPE; --修改用户
    v_vc_qcbz      zjjk_zl_bgk.vc_qcbz%TYPE; --迁出标志
    v_vc_sfbz      zjjk_zl_bgk.vc_sfbz%TYPE; --失访标志
    v_vc_cjdw      zjjk_zl_bgk.vc_cjdw%TYPE; --创建单位
    v_vc_gldw      zjjk_zl_bgk.vc_gldw%TYPE; --管理单位代码;本区域户籍数据管理单位必须满足代码对应关系；外地户籍数据与户籍区县代码一致
    v_vc_smtjid    zjjk_zl_bgk.vc_smtjid%TYPE; --生命统计ID
    v_vc_shbz      zjjk_zl_bgk.vc_shbz%TYPE; --审核标志;本区域户籍数据默认值为3;外地户籍数据默认为1
    v_vc_bgdws     zjjk_zl_bgk.vc_bgdws%TYPE; --报告单位市
    v_vc_ylfffs    zjjk_zl_bgk.vc_ylfffs%TYPE; --医疗付费方式
    v_vc_zdqbt     zjjk_zl_bgk.vc_zdqbt%TYPE; --诊断期别T
    v_vc_zdqbn     zjjk_zl_bgk.vc_zdqbn%TYPE; --诊断期别N
    v_vc_zdqbm     zjjk_zl_bgk.vc_zdqbm%TYPE; --诊断期别M
    v_vc_bgdw      zjjk_zl_bgk.vc_bgdw%TYPE; --报卡单位
    v_vc_bgkzt     zjjk_zl_bgk.vc_bgkzt%TYPE; --报告卡状态;0.可用卡；2.死卡；3.误诊卡；4.重复卡；5.删除卡；6.失访卡；7.死亡卡
    v_vc_yzd       zjjk_zl_bgk.vc_yzd%TYPE; --原诊断
    v_dt_yzdrq     zjjk_zl_bgk.dt_yzdrq%TYPE; --原诊断日期
    v_dt_sczdrq    zjjk_zl_bgk.dt_sczdrq%TYPE; --首次诊断日期
    v_vc_dbwyfid   zjjk_zl_bgk.vc_dbwyfid%TYPE; --多部位原发病人关联
    v_dt_sfrq      zjjk_zl_bgk.dt_sfrq%TYPE; --随访日期
    v_nb_kspf      zjjk_zl_bgk.nb_kspf%TYPE; --卡氏评分
    v_vc_zdjg      zjjk_zl_bgk.vc_zdjg%TYPE; --诊断结果
    v_vc_khjg      zjjk_zl_bgk.vc_khjg%TYPE; --考核结果
    v_dt_cxglrq    zjjk_zl_bgk.dt_cxglrq%TYPE; --撤消管理日期
    v_vc_cxglyy    zjjk_zl_bgk.vc_cxglyy%TYPE; --撤消管理原因
    v_vc_sfcx      zjjk_zl_bgk.vc_sfcx%TYPE; --是否撤消
    v_vc_cxglqtyy  zjjk_zl_bgk.vc_cxglqtyy%TYPE; --撤消管理其它原因
    v_vc_icdm      zjjk_zl_bgk.vc_icdm%TYPE; --ICDM
    v_vc_dlw       zjjk_zl_bgk.vc_dlw%TYPE; --第六位
    v_vc_khzt      zjjk_zl_bgk.vc_khzt%TYPE; --考核状态
    v_vc_icd9      zjjk_zl_bgk.vc_icd9%TYPE; --ICD9
    v_vc_khid      zjjk_zl_bgk.vc_khid%TYPE; --考核ID
    v_vc_sfcf      zjjk_zl_bgk.vc_sfcf%TYPE; --是否初访
    v_dt_zhycsfrq  zjjk_zl_bgk.dt_zhycsfrq%TYPE; --最后一次随访日期
    v_vc_shid      zjjk_zl_bgk.vc_shid%TYPE; --审核ID
    v_vc_swicdmc   zjjk_zl_bgk.vc_swicdmc%TYPE; --死亡ICD名称
    v_vc_qcd       zjjk_zl_bgk.vc_qcd%TYPE; --迁出省
    v_vc_qcsdm     zjjk_zl_bgk.vc_qcsdm%TYPE; --迁出市
    v_vc_qcqxdm    zjjk_zl_bgk.vc_qcqxdm%TYPE; --迁出区
    v_vc_qcjddm    zjjk_zl_bgk.vc_qcjddm%TYPE; --迁出街道
    v_vc_qcjw      zjjk_zl_bgk.vc_qcjw%TYPE; --迁出居委
    v_vc_sfqc      zjjk_zl_bgk.vc_sfqc%TYPE; --是否迁出
    v_dt_qcsj      zjjk_zl_bgk.dt_qcsj%TYPE; --迁出时间
    v_vc_qcxxdz    zjjk_zl_bgk.vc_qcxxdz%TYPE; --迁出详细地址
    v_vc_hjhs      zjjk_zl_bgk.vc_hjhs%TYPE; --户口核实
    v_vc_khbz      zjjk_zl_bgk.vc_khbz%TYPE; --考核标志
    v_vc_shzt      zjjk_zl_bgk.vc_shzt%TYPE; --审核状态
    v_vc_shwtgyy   zjjk_zl_bgk.vc_shwtgyy%TYPE; --区县审核未通过原因
    v_vc_shwtgyy1  zjjk_zl_bgk.vc_shwtgyy1%TYPE; --区县审核未通过原因选项
    v_vc_wtzt      zjjk_zl_bgk.vc_wtzt%TYPE; --委托状态
    v_vc_ywtdw     zjjk_zl_bgk.vc_ywtdw%TYPE; --原委托单位
    v_vc_sqsl      zjjk_zl_bgk.vc_sqsl%TYPE; --街道对应社区数量
    v_vc_jjsl      zjjk_zl_bgk.vc_jjsl%TYPE; --拒绝数量
    v_vc_ywtjd     zjjk_zl_bgk.vc_ywtjd%TYPE; --原委托街道
    v_vc_ywtjw     zjjk_zl_bgk.vc_ywtjw%TYPE; --原委托居委
    v_vc_ywtxxdz   zjjk_zl_bgk.vc_ywtxxdz%TYPE; --原委托详细地址
    v_vc_ywtjgdm   zjjk_zl_bgk.vc_ywtjgdm%TYPE; --原委托机构代码
    v_vc_lszy      zjjk_zl_bgk.vc_lszy%TYPE; --历史数据导入的职业
    v_vc_state     zjjk_zl_bgk.vc_state%TYPE; --随访结果
    v_dt_yyshsj    zjjk_zl_bgk.dt_yyshsj%TYPE; --医院审核时间
    v_dt_qxshsj    zjjk_zl_bgk.dt_qxshsj%TYPE; --区县审核时间
    v_vc_bksznl    zjjk_zl_bgk.vc_bksznl%TYPE; --实足年龄
    v_dt_cfsj      zjjk_zl_bgk.dt_cfsj%TYPE; --初访时间
    v_dt_sfsj      zjjk_zl_bgk.dt_sfsj%TYPE; --随访时间
    v_vc_zdbwmc    zjjk_zl_bgk.vc_zdbwmc%TYPE; --
    v_dt_qxzssj    zjjk_zl_bgk.dt_qxzssj%TYPE; --
    v_vc_gxbz      zjjk_zl_bgk.vc_gxbz%TYPE; --更新标志
    v_vc_yyrid     zjjk_zl_bgk.vc_yyrid%TYPE; --
    v_vc_zdbmms    zjjk_zl_bgk.vc_zdbmms%TYPE; --
    v_vc_sfbyzd    zjjk_zl_bgk.vc_sfbyzd%TYPE; --是否本院诊断
    v_vc_zdyy      zjjk_zl_bgk.vc_zdyy%TYPE; --诊断医院
    v_vc_icdo3bm   zjjk_zl_bgk.vc_icdo3bm%TYPE; --ICD-O-3编码（废弃，重复VC_ICDO）
    v_vc_icdo3ms   zjjk_zl_bgk.vc_icdo3ms%TYPE; --ICD-O-3文字描述
    v_vc_hkqxdm_bg zjjk_zl_hzxx.vc_hkqxdm%TYPE; --户口区县代码
    v_vc_hkjddm_bg zjjk_zl_hzxx.vc_hkjddm%TYPE;
        v_vc_hkjw_bgq  zjjk_zl_hzxx.vc_hkjwdm%TYPE; --户口居委
    v_vc_hkxx_bgq  zjjk_zl_hzxx.vc_hkxxdz%TYPE; --户口详细地址
  
    v_ywrzid       zjjk_yw_log.id%TYPE; --业务日志id
    v_tab_bgk_old  zjjk_zl_bgk%rowtype; --肿瘤报告卡变更前
    v_tab_hzxx_old zjjk_zl_hzxx%rowtype; --肿瘤患者信息变更前
    v_tab_bgk_new  zjjk_zl_bgk%rowtype; --肿瘤报告卡变更后
    v_tab_hzxx_new zjjk_zl_hzxx%rowtype; --肿瘤患者信息变更后
  begin
    json_data(data_in, 'zjjk_zl_bgk新增或更新', v_json_data);
    v_sysdate := sysdate;
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    --患者变量赋值
    h_vc_personid := Json_Str(v_Json_Data, 'vc_personid');
    h_vc_hzxm     := Json_Str(v_Json_Data, 'vc_hzxm');
    h_vc_hzxb     := Json_Str(v_Json_Data, 'vc_hzxb');
    h_vc_hzmz     := Json_Str(v_Json_Data, 'vc_hzmz');
    h_dt_hzcsrq   := std(Json_Str(v_Json_Data, 'dt_hzcsrq'));
    h_vc_sfzh     := Json_Str(v_Json_Data, 'vc_sfzh');
    h_vc_jtdh     := Json_Str(v_Json_Data, 'vc_jtdh');
    h_vc_gzdw     := Json_Str(v_Json_Data, 'vc_gzdw');
    h_vc_zydm     := Json_Str(v_Json_Data, 'vc_zydm');
    h_vc_jtgz     := Json_Str(v_Json_Data, 'vc_jtgz');
    h_vc_hksfdm   := Json_Str(v_Json_Data, 'vc_hksfdm');
    h_vc_hksdm    := Json_Str(v_Json_Data, 'vc_hksdm');
    h_vc_hkjddm   := Json_Str(v_Json_Data, 'vc_hkjddm');
    h_vc_hkqxdm   := Json_Str(v_Json_Data, 'vc_hkqxdm');
    h_vc_hkjwdm   := Json_Str(v_Json_Data, 'vc_hkjwdm');
    h_vc_hkxxdz   := Json_Str(v_Json_Data, 'vc_hkxxdz');
    h_vc_sjsfdm   := Json_Str(v_Json_Data, 'vc_sjsfdm');
    h_vc_sjsdm    := Json_Str(v_Json_Data, 'vc_sjsdm');
    h_vc_sjqxdm   := Json_Str(v_Json_Data, 'vc_sjqxdm');
    h_vc_sjjddm   := Json_Str(v_Json_Data, 'vc_sjjddm');
    h_vc_sjjwdm   := Json_Str(v_Json_Data, 'vc_sjjwdm');
    h_vc_sjxxdz   := Json_Str(v_Json_Data, 'vc_sjxxdz');
    h_vc_gldwdm   := Json_Str(v_Json_Data, 'vc_gldwdm');
    h_vc_sfsw     := Json_Str(v_Json_Data, 'vc_sfsw');
    h_vc_sfhs     := Json_Str(v_Json_Data, 'vc_sfhs');
    h_vc_sjhm     := Json_Str(v_Json_Data, 'vc_sjhm');
    h_vc_dydz     := Json_Str(v_Json_Data, 'vc_dydz');
    h_vc_jzyb     := Json_Str(v_Json_Data, 'vc_jzyb');
    h_vc_hkyb     := Json_Str(v_Json_Data, 'vc_hkyb');
    h_vc_bak_hy   := Json_Str(v_Json_Data, 'vc_bak_hy');
    h_vc_bak_zy   := Json_Str(v_Json_Data, 'vc_bak_zy');
    h_vc_bak_sfzh := Json_Str(v_Json_Data, 'vc_bak_sfzh');
    --报告变量赋值 
    v_vc_bgkid    := Json_Str(v_Json_Data, 'vc_bgkid');
    v_vc_bgklx    := Json_Str(v_Json_Data, 'vc_bgklx');
    v_vc_xzqybm   := Json_Str(v_Json_Data, 'vc_xzqybm');
    v_vc_bqygzbr  := Json_Str(v_Json_Data, 'vc_bqygzbr');
    v_vc_mzh      := Json_Str(v_Json_Data, 'vc_mzh');
    v_vc_zyh      := Json_Str(v_Json_Data, 'vc_zyh');
    v_vc_hzid     := Json_Str(v_Json_Data, 'vc_hzid');
    v_vc_icd10    := Json_Str(v_Json_Data, 'vc_icd10');
    v_vc_icdo     := Json_Str(v_Json_Data, 'vc_icdo');
    v_vc_sznl     := TO_NUMBER(Json_Str(v_Json_Data, 'vc_sznl'));
    v_vc_zdbw     := Json_Str(v_Json_Data, 'vc_zdbw');
    v_vc_blxlx    := Json_Str(v_Json_Data, 'vc_blxlx');
    v_vc_blh      := Json_Str(v_Json_Data, 'vc_blh');
    v_vc_zdsqb    := Json_Str(v_Json_Data, 'vc_zdsqb');
    v_dt_zdrq     := std(Json_Str(v_Json_Data, 'dt_zdrq'), 1);
    v_vc_zgzddw   := Json_Str(v_Json_Data, 'vc_zgzddw');
    v_vc_bgdwqx   := Json_Str(v_Json_Data, 'vc_bgdwqx');
    v_vc_bgys     := Json_Str(v_Json_Data, 'vc_bgys');
    v_dt_bgrq     := std(Json_Str(v_Json_Data, 'dt_bgrq'), 1);
    v_vc_swxx     := Json_Str(v_Json_Data, 'vc_swxx');
    v_dt_swrq     := std(Json_Str(v_Json_Data, 'dt_swrq'), 1);
    v_vc_swyy     := Json_Str(v_Json_Data, 'vc_swyy');
    v_vc_swicd10  := Json_Str(v_Json_Data, 'vc_swicd10');
    v_vc_zdyh     := Json_Str(v_Json_Data, 'vc_zdyh');
    v_vc_bszy     := Json_Str(v_Json_Data, 'vc_bszy');
    v_vc_dcr      := Json_Str(v_Json_Data, 'vc_dcr');
    v_dt_dcrq     := std(Json_Str(v_Json_Data, 'dt_dcrq'), 1);
    v_vc_bz       := Json_Str(v_Json_Data, 'vc_bz');
    v_vc_scbz     := Json_Str(v_Json_Data, 'vc_scbz');
    v_vc_ccid     := Json_Str(v_Json_Data, 'vc_ccid');
    v_vc_ckbz     := Json_Str(v_Json_Data, 'vc_ckbz');
    v_vc_xxly     := Json_Str(v_Json_Data, 'vc_xxly');
    v_vc_sfbb     := Json_Str(v_Json_Data, 'vc_sfbb');
    v_vc_sdqrzt   := Json_Str(v_Json_Data, 'vc_sdqrzt');
    v_dt_qrsj     := std(Json_Str(v_Json_Data, 'dt_qrsj'), 1);
    v_vc_sdqrid   := Json_Str(v_Json_Data, 'vc_sdqrid');
    v_dt_cjsj     := v_sysdate;
    v_vc_cjyh     := Json_Str(v_Json_Data, 'czyyhid');
    v_dt_xgsj     := v_sysdate;
    v_vc_xgyh     := Json_Str(v_Json_Data, 'czyyhid');
    v_vc_qcbz     := Json_Str(v_Json_Data, 'vc_qcbz');
    v_vc_sfbz     := Json_Str(v_Json_Data, 'vc_sfbz');
    v_vc_cjdw     := v_czyjgdm;
    v_vc_gldw     := Json_Str(v_Json_Data, 'vc_gldw');
    v_vc_smtjid   := Json_Str(v_Json_Data, 'vc_smtjid');
    v_vc_shbz     := Json_Str(v_Json_Data, 'vc_shbz');
    v_vc_bgdws    := Json_Str(v_Json_Data, 'vc_bgdws');
    v_vc_ylfffs   := Json_Str(v_Json_Data, 'vc_ylfffs');
    v_vc_zdqbt    := Json_Str(v_Json_Data, 'vc_zdqbt');
    v_vc_zdqbn    := Json_Str(v_Json_Data, 'vc_zdqbn');
    v_vc_zdqbm    := Json_Str(v_Json_Data, 'vc_zdqbm');
    v_vc_bgdw     := Json_Str(v_Json_Data, 'vc_bgdw');
    v_vc_bgkzt    := Json_Str(v_Json_Data, 'vc_bgkzt');
    v_vc_yzd      := Json_Str(v_Json_Data, 'vc_yzd');
    v_dt_yzdrq    := std(Json_Str(v_Json_Data, 'dt_yzdrq'));
    v_dt_sczdrq   := std(Json_Str(v_Json_Data, 'dt_sczdrq'));
    v_vc_dbwyfid  := Json_Str(v_Json_Data, 'vc_dbwyfid');
    v_dt_sfrq     := std(Json_Str(v_Json_Data, 'dt_sfrq'));
    v_nb_kspf     := TO_NUMBER(Json_Str(v_Json_Data, 'nb_kspf'));
    v_vc_zdjg     := Json_Str(v_Json_Data, 'vc_zdjg');
    v_vc_khjg     := Json_Str(v_Json_Data, 'vc_khjg');
    v_dt_cxglrq   := std(Json_Str(v_Json_Data, 'dt_cxglrq'));
    v_vc_cxglyy   := Json_Str(v_Json_Data, 'vc_cxglyy');
    v_vc_sfcx     := Json_Str(v_Json_Data, 'vc_sfcx');
    v_vc_cxglqtyy := Json_Str(v_Json_Data, 'vc_cxglqtyy');
    v_vc_icdm     := Json_Str(v_Json_Data, 'vc_icdm');
    v_vc_dlw      := Json_Str(v_Json_Data, 'vc_dlw');
    v_vc_khzt     := Json_Str(v_Json_Data, 'vc_khzt');
    v_vc_icd9     := Json_Str(v_Json_Data, 'vc_icd9');
    v_vc_khid     := Json_Str(v_Json_Data, 'vc_khid');
    v_vc_sfcf     := Json_Str(v_Json_Data, 'vc_sfcf');
    v_dt_zhycsfrq := std(Json_Str(v_Json_Data, 'dt_zhycsfrq'));
    v_vc_shid     := Json_Str(v_Json_Data, 'vc_shid');
    v_vc_swicdmc  := Json_Str(v_Json_Data, 'vc_swicdmc');
    v_vc_qcd      := Json_Str(v_Json_Data, 'vc_qcd');
    v_vc_qcsdm    := Json_Str(v_Json_Data, 'vc_qcsdm');
    v_vc_qcqxdm   := Json_Str(v_Json_Data, 'vc_qcqxdm');
    v_vc_qcjddm   := Json_Str(v_Json_Data, 'vc_qcjddm');
    v_vc_qcjw     := Json_Str(v_Json_Data, 'vc_qcjw');
    v_vc_sfqc     := Json_Str(v_Json_Data, 'vc_sfqc');
    v_dt_qcsj     := std(Json_Str(v_Json_Data, 'dt_qcsj'));
    v_vc_qcxxdz   := Json_Str(v_Json_Data, 'vc_qcxxdz');
    v_vc_hjhs     := Json_Str(v_Json_Data, 'vc_hjhs');
    v_vc_khbz     := Json_Str(v_Json_Data, 'vc_khbz');
    v_vc_shzt     := Json_Str(v_Json_Data, 'vc_shzt');
    v_vc_shwtgyy  := Json_Str(v_Json_Data, 'vc_shwtgyy');
    v_vc_shwtgyy1 := Json_Str(v_Json_Data, 'vc_shwtgyy1');
    v_vc_wtzt     := Json_Str(v_Json_Data, 'vc_wtzt');
    v_vc_ywtdw    := Json_Str(v_Json_Data, 'vc_ywtdw');
    v_vc_sqsl     := Json_Str(v_Json_Data, 'vc_sqsl');
    v_vc_jjsl     := Json_Str(v_Json_Data, 'vc_jjsl');
    v_vc_ywtjd    := Json_Str(v_Json_Data, 'vc_ywtjd');
    v_vc_ywtjw    := Json_Str(v_Json_Data, 'vc_ywtjw');
    v_vc_ywtxxdz  := Json_Str(v_Json_Data, 'vc_ywtxxdz');
    v_vc_ywtjgdm  := Json_Str(v_Json_Data, 'vc_ywtjgdm');
    v_vc_lszy     := Json_Str(v_Json_Data, 'vc_lszy');
    v_vc_state    := Json_Str(v_Json_Data, 'vc_state');
    v_dt_yyshsj   := std(Json_Str(v_Json_Data, 'dt_yyshsj'));
    v_dt_qxshsj   := std(Json_Str(v_Json_Data, 'dt_qxshsj'));
    v_vc_bksznl   := Json_Str(v_Json_Data, 'vc_bksznl');
    v_dt_cfsj     := std(Json_Str(v_Json_Data, 'dt_cfsj'));
    v_dt_sfsj     := std(Json_Str(v_Json_Data, 'dt_sfsj'));
    v_vc_zdbwmc   := Json_Str(v_Json_Data, 'vc_zdbwmc');
    v_dt_qxzssj   := std(Json_Str(v_Json_Data, 'dt_qxzssj'));
    v_vc_gxbz     := Json_Str(v_Json_Data, 'vc_gxbz');
    v_vc_yyrid    := Json_Str(v_Json_Data, 'vc_yyrid');
    v_vc_zdbmms   := Json_Str(v_Json_Data, 'vc_zdbmms');
    v_vc_sfbyzd   := Json_Str(v_Json_Data, 'vc_sfbyzd');
    v_vc_zdyy     := Json_Str(v_Json_Data, 'vc_zdyy');
    v_vc_icdo3bm  := Json_Str(v_Json_Data, 'vc_icdo3bm');
    v_vc_icdo3ms  := Json_Str(v_Json_Data, 'vc_icdo3ms');
  
    --检验字段必填
    --校验数据是否合法
    if v_vc_sfbyzd is null then
      v_err := '是否本院诊断不能为空!';
      raise err_custom;
    end if;
    if v_vc_sfbyzd = '2' and v_vc_zdyy is null then
      v_err := '诊断医院不能为空!';
      raise err_custom;
    end if;
    if v_vc_bgklx is null then
      v_err := '报告卡类别不能为空!';
      raise err_custom;
    end if;
    if v_vc_bqygzbr is null then
      v_err := '病情是否告知病人不能为空!';
      raise err_custom;
    end if;
    if h_vc_hzxm is null then
      v_err := '姓名不能为空!';
      raise err_custom;
    end if;
    if h_vc_hzxb is null then
      v_err := '性别不能为空!';
      raise err_custom;
    end if;
    if h_dt_hzcsrq is null then
      v_err := '出生日期不能为空!';
      raise err_custom;
    end if;
    if h_vc_zydm is null then
      v_err := '职业不能为空!';
      raise err_custom;
    end if;
    if h_vc_jtgz is null then
      v_err := '具体工种不能为空!';
      raise err_custom;
    end if;
    /* if h_vc_sfzh is null then
      v_err := '身份证号不能为空!';
      raise err_custom;
    end if;*/
    if v_vc_bksznl is null then
      v_err := '实足年龄不能为空!';
      raise err_custom;
    end if;
    --if h_vc_gzdw is null then
    --  v_err := '工作单位不能为空!';
    --  raise err_custom;
    --end if;
    if h_vc_jtdh is null then
      v_err := '联系电话不能为空!';
      raise err_custom;
    end if;
    if h_vc_hksfdm is null then
      v_err := '户口省份不能为空!';
      raise err_custom;
    end if;
    --浙江
    if h_vc_hksfdm = '0' then
      if h_vc_hksdm is null then
        v_err := '户口市不能为空!';
        raise err_custom;
      end if;
      if h_vc_hkqxdm is null then
        v_err := '户口区县不能为空!';
        raise err_custom;
      end if;
      if h_vc_hkjddm is null then
        v_err := '户口街道不能为空!';
        raise err_custom;
      end if;
      if substr(h_vc_hksdm, 1, 4) <> substr(h_vc_hkqxdm, 1, 4) or
         substr(h_vc_hksdm, 1, 4) <> substr(h_vc_hkjddm, 1, 4) then
        v_err := '户口地址区划不匹配!';
        raise err_custom;
      end if;
    end if;
  
    if h_vc_hkxxdz is null then
      v_err := '户口详细地址不能为空!';
      raise err_custom;
    end if;
    if h_vc_sjsfdm is null then
      v_err := '目前居住地址省不能为空!';
      raise err_custom;
    end if;
    --浙江
    if h_vc_sjsfdm = '0' then
      if h_vc_sjsdm is null then
        v_err := '目前居住地市不能为空!';
        raise err_custom;
      end if;
      if h_vc_sjqxdm is null then
        v_err := '目前居住地区县不能为空!';
        raise err_custom;
      end if;
      if h_vc_sjjddm is null then
        v_err := '目前居住地街道不能为空!';
        raise err_custom;
      end if;
    end if;
    if h_vc_sjxxdz is null then
      v_err := '居住详细地址不能为空!';
      raise err_custom;
    end if;
    if v_vc_zdbw is null then
      v_err := '诊断（部位）不能为空!';
      raise err_custom;
    end if;
    if v_vc_zgzddw is null then
      v_err := '最高诊断单位不能为空!';
      raise err_custom;
    end if;
    if v_dt_zdrq is null then
      v_err := '首次诊断日期不能为空!';
      raise err_custom;
    end if;
    if v_vc_bgys is null then
      v_err := '报卡医师不能为空!';
      raise err_custom;
    end if;
    if v_dt_bgrq is null then
      v_err := '报卡日期不能为空!';
      raise err_custom;
    end if;
    if v_vc_zdyh is null then
      v_err := '诊断依据不能为空!';
      raise err_custom;
    end if;
    if v_dt_swrq is not null and v_vc_swyy is null then
      v_err := '死亡原因不能为空!';
      raise err_custom;
    end if;
    if v_dt_swrq is not null and v_vc_swicd10 is null then
      v_err := '死亡ICD-10不能为空!';
      raise err_custom;
    end if;
    if v_dt_swrq is not null and v_vc_swicdmc is null then
      v_err := '死亡ICD-10名称不能为空!';
      raise err_custom;
    end if;
  
    if v_vc_bgkid is null then
      v_vc_bgkid  := pkg_zjmb_zl.fun_getbgkcode(v_vc_cjdw, null);
      v_vc_hzid   := sys_guid();
      v_vc_scbz   := '0';
      v_vc_bgkzt  := '0';
      v_vc_sfcf   := '2';
      v_vc_shbz   := '1';
      v_dt_yyshsj := v_sysdate;
      v_vc_sdqrzt := '1';
      v_vc_wtzt   := '0';
      v_ywjl_czlx := '01';
      --设置报卡状态
      if v_czyjgjb <> '4' then
        v_err := '当前机构无新增权限!';
        raise err_custom;
      end if;
      --判断是否填写死亡日期  或者 死亡原因
      if (v_dt_swrq is not null or v_vc_swyy is not null) then
        v_vc_bgkzt := '7';
        h_vc_sfsw  := '1';
      ElSE
        h_vc_sfsw := '0';
      end if;
      --属地确认
      select count(1), wm_concat(a.dm)
        into v_count, v_vc_gldw
        from p_yljg a
       where a.bz = 1
         and a.lb = 'B1'
         and a.xzqh = h_vc_hkjddm;
      if v_count = 1 then
        --确定属地
        v_vc_sdqrzt := '1';
      else
        v_vc_gldw   := h_vc_hkqxdm;
        v_vc_sdqrzt := '0';
      end if;
      --户口省
      --外省
      if h_vc_hksfdm = '1' then
        v_vc_gldw   := '99999999';
        h_vc_hksdm  := '';
        h_vc_hkqxdm := '';
        h_vc_hkjddm := '';
        h_vc_hkjwdm := '';
        v_vc_sdqrzt := '1';
      end if;
      --新增患者信息
      insert into zjjk_zl_hzxx
        (vc_personid,
         vc_bak_sfzh,
         vc_bak_zy,
         vc_bak_hy,
         vc_hkyb,
         vc_jzyb,
         vc_dydz,
         vc_sjhm,
         vc_sfhs,
         vc_sfsw,
         vc_gldwdm,
         vc_sjxxdz,
         vc_sjjwdm,
         vc_sjjddm,
         vc_sjqxdm,
         vc_sjsdm,
         vc_sjsfdm,
         vc_hkxxdz,
         vc_hkjwdm,
         vc_hkqxdm,
         vc_hkjddm,
         vc_hksdm,
         vc_hksfdm,
         vc_jtgz,
         vc_zydm,
         vc_gzdw,
         vc_jtdh,
         vc_sfzh,
         dt_hzcsrq,
         vc_hzmz,
         vc_hzxb,
         vc_hzxm)
      values
        (v_vc_hzid,
         h_vc_bak_sfzh,
         h_vc_bak_zy,
         h_vc_bak_hy,
         h_vc_hkyb,
         h_vc_jzyb,
         h_vc_dydz,
         h_vc_sjhm,
         h_vc_sfhs,
         h_vc_sfsw,
         h_vc_gldwdm,
         h_vc_sjxxdz,
         h_vc_sjjwdm,
         h_vc_sjjddm,
         h_vc_sjqxdm,
         h_vc_sjsdm,
         h_vc_sjsfdm,
         h_vc_hkxxdz,
         h_vc_hkjwdm,
         h_vc_hkqxdm,
         h_vc_hkjddm,
         h_vc_hksdm,
         h_vc_hksfdm,
         h_vc_jtgz,
         h_vc_zydm,
         h_vc_gzdw,
         h_vc_jtdh,
         h_vc_sfzh,
         h_dt_hzcsrq,
         h_vc_hzmz,
         h_vc_hzxb,
         h_vc_hzxm); --报告卡为空 报告卡新增
      --新增肿瘤报告卡信息
      insert into zjjk_zl_bgk
        (vc_bgkid,
         vc_icdo3ms,
         vc_icdo3bm,
         vc_zdyy,
         vc_sfbyzd,
         vc_zdbmms,
         vc_yyrid,
         vc_gxbz,
         dt_qxzssj,
         vc_zdbwmc,
         dt_sfsj,
         dt_cfsj,
         vc_bksznl,
         dt_qxshsj,
         dt_yyshsj,
         vc_state,
         vc_lszy,
         vc_ywtjgdm,
         vc_ywtxxdz,
         vc_ywtjw,
         vc_ywtjd,
         vc_jjsl,
         vc_sqsl,
         vc_ywtdw,
         vc_wtzt,
         vc_shwtgyy1,
         vc_shwtgyy,
         vc_shzt,
         vc_khbz,
         vc_hjhs,
         vc_qcxxdz,
         dt_qcsj,
         vc_sfqc,
         vc_qcjw,
         vc_qcjddm,
         vc_qcqxdm,
         vc_qcsdm,
         vc_qcd,
         vc_swicdmc,
         vc_shid,
         dt_zhycsfrq,
         vc_sfcf,
         vc_khid,
         vc_icd9,
         vc_khzt,
         vc_dlw,
         vc_icdm,
         vc_cxglqtyy,
         vc_sfcx,
         vc_cxglyy,
         dt_cxglrq,
         vc_khjg,
         vc_zdjg,
         nb_kspf,
         dt_sfrq,
         vc_dbwyfid,
         dt_sczdrq,
         dt_yzdrq,
         vc_yzd,
         vc_bgkzt,
         vc_bgdw,
         vc_zdqbm,
         vc_zdqbn,
         vc_zdqbt,
         vc_ylfffs,
         vc_bgdws,
         vc_shbz,
         vc_smtjid,
         vc_gldw,
         vc_cjdw,
         vc_sfbz,
         vc_qcbz,
         vc_xgyh,
         dt_xgsj,
         vc_cjyh,
         dt_cjsj,
         vc_sdqrid,
         dt_qrsj,
         vc_sdqrzt,
         vc_sfbb,
         vc_xxly,
         vc_ckbz,
         vc_ccid,
         vc_scbz,
         vc_bz,
         dt_dcrq,
         vc_dcr,
         vc_bszy,
         vc_zdyh,
         vc_swicd10,
         vc_swyy,
         dt_swrq,
         vc_swxx,
         dt_bgrq,
         vc_bgys,
         vc_bgdwqx,
         vc_zgzddw,
         dt_zdrq,
         vc_zdsqb,
         vc_blh,
         vc_blxlx,
         vc_zdbw,
         vc_sznl,
         vc_icdo,
         vc_icd10,
         vc_hzid,
         vc_zyh,
         vc_mzh,
         vc_bqygzbr,
         vc_xzqybm,
         vc_bgklx)
      values
        (v_vc_bgkid,
         v_vc_icdo3ms,
         v_vc_icdo3bm,
         v_vc_zdyy,
         v_vc_sfbyzd,
         v_vc_zdbmms,
         v_vc_yyrid,
         v_vc_gxbz,
         v_dt_qxzssj,
         v_vc_zdbwmc,
         v_dt_sfsj,
         v_dt_cfsj,
         v_vc_bksznl,
         v_dt_qxshsj,
         v_dt_yyshsj,
         v_vc_state,
         v_vc_lszy,
         v_vc_ywtjgdm,
         v_vc_ywtxxdz,
         v_vc_ywtjw,
         v_vc_ywtjd,
         v_vc_jjsl,
         v_vc_sqsl,
         v_vc_ywtdw,
         v_vc_wtzt,
         v_vc_shwtgyy1,
         v_vc_shwtgyy,
         v_vc_shzt,
         v_vc_khbz,
         v_vc_hjhs,
         v_vc_qcxxdz,
         v_dt_qcsj,
         v_vc_sfqc,
         v_vc_qcjw,
         v_vc_qcjddm,
         v_vc_qcqxdm,
         v_vc_qcsdm,
         v_vc_qcd,
         v_vc_swicdmc,
         v_vc_shid,
         v_dt_zhycsfrq,
         v_vc_sfcf,
         v_vc_khid,
         v_vc_icd9,
         v_vc_khzt,
         v_vc_dlw,
         v_vc_icdm,
         v_vc_cxglqtyy,
         v_vc_sfcx,
         v_vc_cxglyy,
         v_dt_cxglrq,
         v_vc_khjg,
         v_vc_zdjg,
         v_nb_kspf,
         v_dt_sfrq,
         v_vc_dbwyfid,
         v_dt_sczdrq,
         v_dt_yzdrq,
         v_vc_yzd,
         v_vc_bgkzt,
         v_czyjgdm,
         v_vc_zdqbm,
         v_vc_zdqbn,
         v_vc_zdqbt,
         v_vc_ylfffs,
         substr(v_czyjgdm, 1, 4) || '0000',
         v_vc_shbz,
         v_vc_smtjid,
         v_vc_gldw,
         v_vc_cjdw,
         v_vc_sfbz,
         v_vc_qcbz,
         v_vc_xgyh,
         v_dt_xgsj,
         v_vc_cjyh,
         v_dt_cjsj,
         v_vc_sdqrid,
         v_dt_qrsj,
         v_vc_sdqrzt,
         v_vc_sfbb,
         v_vc_xxly,
         v_vc_ckbz,
         v_vc_ccid,
         v_vc_scbz,
         v_vc_bz,
         v_dt_dcrq,
         v_vc_dcr,
         v_vc_bszy,
         v_vc_zdyh,
         v_vc_swicd10,
         v_vc_swyy,
         v_dt_swrq,
         v_vc_swxx,
         v_dt_bgrq,
         v_vc_bgys,
         substr(v_czyjgdm, 1, 6) || '00',
         v_vc_zgzddw,
         v_dt_zdrq,
         v_vc_zdsqb,
         v_vc_blh,
         v_vc_blxlx,
         v_vc_zdbw,
         v_vc_sznl,
         v_vc_icdo,
         v_vc_icd10,
         v_vc_hzid,
         v_vc_zyh,
         v_vc_mzh,
         v_vc_bqygzbr,
         v_vc_xzqybm,
         v_vc_bgklx);
      ----写入主副卡关系
      insert into zjjk_zl_bgk_zfgx
        (vc_zkid, vc_fkid, vc_cjjg, vc_cjry, dt_cjsj)
      values
        (v_vc_bgkid, v_vc_bgkid, v_vc_cjdw, v_vc_cjyh, v_sysdate);
    ELSE
      v_ywjl_czlx := '02';
      begin
        select a.VC_SFCF,
               a.vc_hzid,
               a.vc_shbz,
               b.vc_hkjddm,
               b.vc_hkqxdm,
                             b.vc_hkjwdm,
                             b.vc_hkxxdz,
               a.vc_gldw,
               a.vc_sdqrzt,
               a.vc_bgkzt
          into v_vc_sfcf,
               v_vc_hzid,
               v_vc_shbz,
               v_vc_hkjddm_bg,
               v_vc_hkqxdm_bg,
               v_vc_hkjw_bgq,
               v_vc_hkxx_bgq,
               v_vc_gldw,
               v_vc_sdqrzt,
               v_vc_bgkzt
          from zjjk_zl_bgk a, zjjk_zl_hzxx b
         where a.vc_hzid = b.vc_personid
           and a.vc_bgkid = v_vc_bgkid
           and a.vc_scbz = '0';
      exception
        when no_data_found then
          v_err := 'id[' || v_vc_bgkid || ']未获取到有效报告卡信息!';
          raise err_custom;
      end;
      --校验管理单位审核权限
      if v_czyjgjb = '3' then
        if substr(v_vc_gldw, 1, 6) <> substr(v_czyjgdm, 1, 6) and v_vc_gldw <> '99999999' then
          v_err := '非管理单位无此操作权限!';
          raise err_custom;
        end if;
                if v_vc_sfcf in ('1', '3') THEN
                    if v_vc_hkjddm_bg <> h_vc_hkjddm or v_vc_hkqxdm_bg <> h_vc_hkqxdm
                          /* OR v_vc_hkjw_bgq <> h_vc_hkjwdm OR v_vc_hkxx_bgq <> h_vc_hkxxdz */ THEN
                        v_err := '该报卡已初访，不能修改户籍地址!';
            raise err_custom;
                    END IF;
                END IF;
      end if;
      if v_czyjgjb = '4' then
        --医院社区
        /* 医院社区可以修改已初访的卡，前端限制只能修改 户籍地址和目前居住地址中的居委会和详细地址四个字段
        if v_vc_sfcf in ('1', '3') then
          v_err := '该报卡已初访，当前机构无权修改!';
          raise err_custom;
        end if;
        */
        /*if v_vc_shbz = '3' then
          v_err := '该报卡已区县审核通过，当前机构无权修改!';
          raise err_custom;
        end if;*/
        --审核不通过
        if v_vc_shbz in ('0', '2', '4') then
          --修改为审核通过
          v_vc_shbz := '1';
        end if;
        --修改了户籍地址
        if v_vc_hkjddm_bg <> h_vc_hkjddm or v_vc_hkqxdm_bg <> h_vc_hkqxdm then
          --审核状态改为医院通过
          v_vc_shbz := '1';
          --属地确认
          select count(1), wm_concat(a.dm)
            into v_count, v_vc_gldw
            from p_yljg a
           where a.bz = 1
             and a.xzqh = h_vc_hkjddm;
          if v_count = 1 then
            --确定属地
            v_vc_sdqrzt := '1';
          else
            v_vc_gldw   := h_vc_hkqxdm;
            v_vc_sdqrzt := '0';
          end if;
          --外省
          if h_vc_hksfdm = '1' then
            v_vc_gldw   := '99999999';
            h_vc_hksdm  := '';
            h_vc_hkqxdm := '';
            h_vc_hkjddm := '';
            h_vc_hkjwdm := '';
            v_vc_sdqrzt := '1';
          end if;
        end if;
      elsif v_czyjgjb = '3' then
        --区县修改
        v_vc_shbz := '3';
      
        --修改了户籍地址
        if v_vc_hkjddm_bg <> h_vc_hkjddm or v_vc_hkqxdm_bg <> h_vc_hkqxdm then
          --属地确认
          select count(1), wm_concat(a.dm)
            into v_count, v_vc_gldw
            from p_yljg a
           where a.bz = 1
             and a.xzqh = h_vc_hkjddm;
          if v_count = 1 then
            --确定属地
            v_vc_sdqrzt := '1';
          else
            v_vc_gldw   := '';
            v_vc_sdqrzt := '0';
          end if;
          --外省
          if h_vc_hksfdm = '1' then
            v_vc_gldw   := '99999999';
            h_vc_hksdm  := '';
            h_vc_hkqxdm := '';
            h_vc_hkjddm := '';
            h_vc_hkjwdm := '';
            v_vc_sdqrzt := '1';
          end if;
        end if;
      else
        --非区县
        v_err := '当前机构无修改权限!';
        raise err_custom;
      end if;
      --死亡标志
      if (v_vc_swyy is not null or v_dt_swrq is not null) and
         v_vc_sfcf = '2' then
        --未死亡
        v_vc_bgkzt := '7';
        h_vc_sfsw  := '1';
      elsif (v_vc_swyy is null or v_dt_swrq is null) and v_vc_sfcf <> '3' and
            v_vc_sfcf <> '1' and v_vc_sfcf <> '2' then
        --死亡原因为糖尿病
        v_vc_bgkzt := '0';
        h_vc_sfsw  := '0';
      end if;
      --获取变更前信息
      select *
        into v_tab_bgk_old
        from zjjk_zl_bgk
       where vc_bgkid = v_vc_bgkid;
      select *
        into v_tab_hzxx_old
        from zjjk_zl_hzxx
       where vc_personid = v_vc_hzid;
      --更新患者信息
      update zjjk_zl_hzxx
         set vc_hzxm   = h_vc_hzxm,
             vc_hzxb   = h_vc_hzxb,
             dt_hzcsrq = h_dt_hzcsrq,
             vc_zydm   = h_vc_zydm,
             vc_jtgz   = h_vc_jtgz,
             vc_hzmz   = h_vc_hzmz,
             vc_sfzh   = h_vc_sfzh,
             vc_gzdw   = h_vc_gzdw,
             vc_jtdh   = h_vc_jtdh,
             vc_hksfdm = h_vc_hksfdm,
             vc_hksdm  = h_vc_hksdm,
             vc_hkqxdm = h_vc_hkqxdm,
             vc_hkjddm = h_vc_hkjddm,
             vc_hkjwdm = h_vc_hkjwdm,
             vc_hkxxdz = h_vc_hkxxdz,
             vc_sjsfdm = h_vc_sjsfdm,
             vc_sjsdm  = h_vc_sjsdm,
             vc_sjqxdm = h_vc_sjqxdm,
             vc_sjjddm = h_vc_sjjddm,
             vc_sjjwdm = h_vc_sjjwdm,
             vc_sjxxdz = h_vc_sjxxdz,
             vc_sfsw   = h_vc_sfsw
       where VC_PERSONID = v_vc_hzid;
      --更新肿瘤报告卡信息
      UPDATE zjjk_zl_bgk
         set vc_bgklx   = v_vc_bgklx,
             vc_sfcf    = v_vc_sfcf,
             vc_shbz    = v_vc_shbz,
             vc_gldw    = v_vc_gldw,
             vc_sdqrzt  = v_vc_sdqrzt,
             vc_bgkzt   = v_vc_bgkzt,
             vc_bqygzbr = v_vc_bqygzbr,
             vc_zdyy    = v_vc_zdyy,
             vc_sfbyzd  = v_vc_sfbyzd,
             vc_icd10   = v_vc_icd10,
             vc_icdo    = v_vc_icdo,
             vc_icd9    = v_vc_icd9,
             vc_icdo3ms = v_vc_icdo3ms,
             vc_mzh     = v_vc_mzh,
             vc_zyh     = v_vc_zyh,
             vc_zdbw    = v_vc_zdbw,
             vc_zdbwmc  = v_vc_zdbwmc,
             vc_icdm    = v_vc_icdm,
             vc_dlw     = v_vc_dlw,
             vc_blh     = v_vc_blh,
             vc_blxlx   = v_vc_blxlx,
             vc_zdqbt   = v_vc_zdqbt,
             vc_zdqbn   = v_vc_zdqbn,
             vc_zdqbm   = v_vc_zdqbm,
             vc_zdsqb   = v_vc_zdsqb,
             vc_zgzddw  = v_vc_zgzddw,
             dt_zdrq    = v_dt_zdrq,
             vc_yzd     = v_vc_yzd,
             dt_yzdrq   = v_dt_yzdrq,
             vc_bgys    = v_vc_bgys,
             dt_bgrq    = v_dt_bgrq,
             vc_swicd10 = v_vc_swicd10,
             dt_sczdrq  = v_dt_sczdrq,
             dt_swrq    = v_dt_swrq,
             vc_swyy    = v_vc_swyy,
             vc_swicdmc = v_vc_swicdmc,
             vc_zdyh    = v_vc_zdyh,
             vc_bszy    = v_vc_bszy,
             DT_XGSJ    = v_dt_xgsj,
             VC_XGYH    = v_vc_xgyh,
             dt_qxshsj = case
                           when v_vc_shbz = '3' and dt_qxshsj is null then
                            v_sysdate
                           else
                            dt_qxshsj
                         end
       where vc_bgkid = v_vc_bgkid;
      --记录报卡变更日志
      v_ywrzid := sys_guid();
      --获取变更后信息
      select *
        into v_tab_bgk_new
        from zjjk_zl_bgk
       where vc_bgkid = v_vc_bgkid;
      select *
        into v_tab_hzxx_new
        from zjjk_zl_hzxx
       where vc_personid = v_vc_hzid;
      --写入变更记录
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'vc_bgklx',
                                         '报告卡类别',
                                         v_tab_bgk_old.vc_bgklx,
                                         v_tab_bgk_new.vc_bgklx,
                                         'C_COMM_BGKLX',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'vc_sfcf',
                                         '是否初访',
                                         v_tab_bgk_old.vc_sfcf,
                                         v_tab_bgk_new.vc_sfcf,
                                         '',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'vc_shbz',
                                         '审核标志',
                                         v_tab_bgk_old.vc_shbz,
                                         v_tab_bgk_new.vc_shbz,
                                         'C_COMM_SHZT',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'vc_gldw',
                                         '管理单位',
                                         v_tab_bgk_old.vc_gldw,
                                         v_tab_bgk_new.vc_gldw,
                                         '',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'vc_sdqrzt',
                                         '属地确认状态',
                                         v_tab_bgk_old.vc_sdqrzt,
                                         v_tab_bgk_new.vc_sdqrzt,
                                         '',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'vc_bgkzt',
                                         '报告卡状态',
                                         v_tab_bgk_old.vc_bgkzt,
                                         v_tab_bgk_new.vc_bgkzt,
                                         'C_COMM_BGKZT',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'vc_bqygzbr',
                                         '病情已告知病人',
                                         v_tab_bgk_old.vc_bqygzbr,
                                         v_tab_bgk_new.vc_bqygzbr,
                                         'C_ZL_BRZQ',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'vc_zdyy',
                                         '诊断医院',
                                         v_tab_bgk_old.vc_zdyy,
                                         v_tab_bgk_new.vc_zdyy,
                                         '',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'vc_sfbyzd',
                                         '是否本院诊断',
                                         v_tab_bgk_old.vc_sfbyzd,
                                         v_tab_bgk_new.vc_sfbyzd,
                                         'C_COMM_SF',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'vc_icd10',
                                         'ICD-10',
                                         v_tab_bgk_old.vc_icd10,
                                         v_tab_bgk_new.vc_icd10,
                                         '',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'vc_icdo',
                                         'ICD-O-3',
                                         v_tab_bgk_old.vc_icdo,
                                         v_tab_bgk_new.vc_icdo,
                                         '',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'vc_icd9',
                                         'ICD-9',
                                         v_tab_bgk_old.vc_icd9,
                                         v_tab_bgk_new.vc_icd9,
                                         '',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'vc_icdo3ms',
                                         'ICD-O-3描述',
                                         v_tab_bgk_old.vc_icdo3ms,
                                         v_tab_bgk_new.vc_icdo3ms,
                                         '',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'vc_mzh',
                                         '门诊号',
                                         v_tab_bgk_old.vc_mzh,
                                         v_tab_bgk_new.vc_mzh,
                                         '',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'vc_zyh',
                                         '住院号',
                                         v_tab_bgk_old.vc_zyh,
                                         v_tab_bgk_new.vc_zyh,
                                         '',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'vc_zdbw',
                                         '诊断（部位）',
                                         v_tab_bgk_old.vc_zdbw,
                                         v_tab_bgk_new.vc_zdbw,
                                         '',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'vc_zdbwmc',
                                         '诊断（部位）描述',
                                         v_tab_bgk_old.vc_zdbwmc,
                                         v_tab_bgk_new.vc_zdbwmc,
                                         '',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'vc_icdm',
                                         'M',
                                         v_tab_bgk_old.vc_icdm,
                                         v_tab_bgk_new.vc_icdm,
                                         '',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'vc_dlw',
                                         '第六位',
                                         v_tab_bgk_old.vc_dlw,
                                         v_tab_bgk_new.vc_dlw,
                                         'C_COMM_DLW',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'vc_blh',
                                         '病理号',
                                         v_tab_bgk_old.vc_blh,
                                         v_tab_bgk_new.vc_blh,
                                         '',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'vc_blxlx',
                                         '病理学类型',
                                         v_tab_bgk_old.vc_blxlx,
                                         v_tab_bgk_new.vc_blxlx,
                                         '',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'vc_zdqbt',
                                         '确诊时期别T',
                                         v_tab_bgk_old.vc_zdqbt,
                                         v_tab_bgk_new.vc_zdqbt,
                                         'C_ZL_ZDQBT',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'vc_zdqbn',
                                         '确诊时期别N',
                                         v_tab_bgk_old.vc_zdqbn,
                                         v_tab_bgk_new.vc_zdqbn,
                                         'C_ZL_ZDQBN',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'vc_zdqbm',
                                         '确诊时期别M',
                                         v_tab_bgk_old.vc_zdqbm,
                                         v_tab_bgk_new.vc_zdqbm,
                                         'C_ZL_ZDQBM',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'vc_zdsqb',
                                         '确诊时期别',
                                         v_tab_bgk_old.vc_zdsqb,
                                         v_tab_bgk_new.vc_zdsqb,
                                         'C_ZL_ZDQS',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'vc_zgzddw',
                                         '最高诊断单位',
                                         v_tab_bgk_old.vc_zgzddw,
                                         v_tab_bgk_new.vc_zgzddw,
                                         'C_ZL_ZGZDDW',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'dt_zdrq',
                                         '诊断日期',
                                         dts(v_tab_bgk_old.dt_zdrq, 0),
                                         dts(v_tab_bgk_new.dt_zdrq, 0),
                                         '',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'dt_yzdrq',
                                         '原诊断日期',
                                         dts(v_tab_bgk_old.dt_yzdrq, 0),
                                         dts(v_tab_bgk_new.dt_yzdrq, 0),
                                         '',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'dt_bgrq',
                                         '报卡日期',
                                         dts(v_tab_bgk_old.dt_bgrq, 0),
                                         dts(v_tab_bgk_new.dt_bgrq, 0),
                                         '',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'dt_sczdrq',
                                         '首次诊断日期',
                                         dts(v_tab_bgk_old.dt_sczdrq, 0),
                                         dts(v_tab_bgk_new.dt_sczdrq, 0),
                                         '',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'dt_swrq',
                                         '死亡日期',
                                         dts(v_tab_bgk_old.dt_swrq, 0),
                                         dts(v_tab_bgk_new.dt_swrq, 0),
                                         '',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'dt_qxshsj',
                                         '区县审核时间',
                                         dts(v_tab_bgk_old.dt_qxshsj, 1),
                                         dts(v_tab_bgk_new.dt_qxshsj, 1),
                                         '',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'vc_yzd',
                                         '原诊断',
                                         v_tab_bgk_old.vc_yzd,
                                         v_tab_bgk_new.vc_yzd,
                                         '',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'vc_bgys',
                                         '报告医师',
                                         v_tab_bgk_old.vc_bgys,
                                         v_tab_bgk_new.vc_bgys,
                                         '',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'vc_swicd10',
                                         '死亡ICD-10',
                                         v_tab_bgk_old.vc_swicd10,
                                         v_tab_bgk_new.vc_swicd10,
                                         '',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'vc_swyy',
                                         '死亡原因',
                                         v_tab_bgk_old.vc_swyy,
                                         v_tab_bgk_new.vc_swyy,
                                         'C_ZL_SWYYDM',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'vc_swicdmc',
                                         '死亡ICD名称',
                                         v_tab_bgk_old.vc_swicdmc,
                                         v_tab_bgk_new.vc_swicdmc,
                                         '',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'vc_zdyh',
                                         '诊断依据',
                                         v_tab_bgk_old.vc_zdyh,
                                         v_tab_bgk_new.vc_zdyh,
                                         '',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'vc_bszy',
                                         '病史摘要',
                                         v_tab_bgk_old.vc_bszy,
                                         v_tab_bgk_new.vc_bszy,
                                         '',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'vc_hzxm',
                                         '患者姓名',
                                         v_tab_hzxx_old.vc_hzxm,
                                         v_tab_hzxx_new.vc_hzxm,
                                         '',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'C_COMM_XB',
                                         '性别',
                                         v_tab_hzxx_old.vc_hzxb,
                                         v_tab_hzxx_new.vc_hzxb,
                                         '',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'dt_hzcsrq',
                                         '出生日期',
                                         dts(v_tab_hzxx_old.dt_hzcsrq, 0),
                                         dts(v_tab_hzxx_new.dt_hzcsrq, 0),
                                         '',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'vc_zydm',
                                         '职业',
                                         v_tab_hzxx_old.vc_zydm,
                                         v_tab_hzxx_new.vc_zydm,
                                         'C_COMM_HY',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'vc_jtgz',
                                         '具体工种',
                                         v_tab_hzxx_old.vc_jtgz,
                                         v_tab_hzxx_new.vc_jtgz,
                                         'C_COMM_ZY',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'vc_hzmz',
                                         '民族',
                                         v_tab_hzxx_old.vc_hzmz,
                                         v_tab_hzxx_new.vc_hzmz,
                                         'C_COMM_MZ',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'vc_sfzh',
                                         '身份证号',
                                         v_tab_hzxx_old.vc_sfzh,
                                         v_tab_hzxx_new.vc_sfzh,
                                         '',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'vc_gzdw',
                                         '工作单位',
                                         v_tab_hzxx_old.vc_gzdw,
                                         v_tab_hzxx_new.vc_gzdw,
                                         '',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'vc_jtdh',
                                         '联系电话',
                                         v_tab_hzxx_old.vc_jtdh,
                                         v_tab_hzxx_new.vc_jtdh,
                                         '',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'vc_hksfdm',
                                         '户口省',
                                         v_tab_hzxx_old.vc_hksfdm,
                                         v_tab_hzxx_new.vc_hksfdm,
                                         'C_COMM_SHEDM',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'vc_hksdm',
                                         '户口市',
                                         v_tab_hzxx_old.vc_hksdm,
                                         v_tab_hzxx_new.vc_hksdm,
                                         'P_XZDM',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'vc_hkqxdm',
                                         '户口区县',
                                         v_tab_hzxx_old.vc_hkqxdm,
                                         v_tab_hzxx_new.vc_hkqxdm,
                                         'P_XZDM',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'vc_hkjddm',
                                         '户口街道',
                                         v_tab_hzxx_old.vc_hkjddm,
                                         v_tab_hzxx_new.vc_hkjddm,
                                         'P_XZDM',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'vc_hkjwdm',
                                         '户口居委',
                                         v_tab_hzxx_old.vc_hkjwdm,
                                         v_tab_hzxx_new.vc_hkjwdm,
                                         '',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'vc_hkxxdz',
                                         '户口详细地址',
                                         v_tab_hzxx_old.vc_hkxxdz,
                                         v_tab_hzxx_new.vc_hkxxdz,
                                         '',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'vc_sjsfdm',
                                         '居住地省',
                                         v_tab_hzxx_old.vc_sjsfdm,
                                         v_tab_hzxx_new.vc_sjsfdm,
                                         'C_COMM_SHEDM',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'vc_sjsdm',
                                         '居住地市',
                                         v_tab_hzxx_old.vc_sjsdm,
                                         v_tab_hzxx_new.vc_sjsdm,
                                         'P_XZDM',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'vc_sjqxdm',
                                         '居住地区县',
                                         v_tab_hzxx_old.vc_sjqxdm,
                                         v_tab_hzxx_new.vc_sjqxdm,
                                         'P_XZDM',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'vc_sjjddm',
                                         '居住地街道',
                                         v_tab_hzxx_old.vc_sjjddm,
                                         v_tab_hzxx_new.vc_sjjddm,
                                         'P_XZDM',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'vc_sjjwdm',
                                         '居住地居委',
                                         v_tab_hzxx_old.vc_sjjwdm,
                                         v_tab_hzxx_new.vc_sjjwdm,
                                         '',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'vc_sjxxdz',
                                         '居住详细地址',
                                         v_tab_hzxx_old.vc_sjxxdz,
                                         v_tab_hzxx_new.vc_sjxxdz,
                                         '',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '02',
                                         'vc_sfsw',
                                         '是否死亡',
                                         v_tab_hzxx_old.vc_sfsw,
                                         v_tab_hzxx_new.vc_sfsw,
                                         '',
                                         v_vc_xgyh,
                                         v_czyjgdm,
                                         v_err);
    end if;
    --记录日志
    v_json_yw_log := Json_ext.get_json(v_json_data, 'ywjllog');
    if v_json_yw_log is not null then
      v_json_yw_log.put('ywrzid', v_ywrzid);
      v_json_yw_log.put('bgkid', v_vc_bgkid);
      v_json_yw_log.put('bgklx', '02');
      v_json_yw_log.put('ywjlid', v_vc_bgkid);
      v_json_yw_log.put('gnmk', '01');
      v_json_yw_log.put('gnmc', '报卡管理');
      v_json_yw_log.put('czlx', v_ywjl_czlx);
      v_json_yw_log.put('ywjlid', v_vc_bgkid);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_update(v_json_yw_log, v_err);
      if v_err is not null then
        raise err_custom;
      end if;
    end if;
    v_Json_Return.put('vc_bgkid', v_vc_bgkid);
    v_Json_Return.put('vc_hzid', v_vc_hzid);
    result_out := Return_Succ_Json(v_Json_Return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_zlbgk_update;
  /*--------------------------------------------------------------------------
  || 功能描述 ：获取报告卡编码
  ||------------------------------------------------------------------------*/
  FUNCTION fun_getbgkcode(yycode VARCHAR2, qxcode varchar2) --报卡医院code,报卡区县
   RETURN VARCHAR2 is
    v_code   zjjk_zl_bgk.vc_bgkid%type;
    v_f_code varchar(30);
    v_dm     VARCHAR2(30);
  begin
    IF (yycode is not null) THEN
      v_f_code := substr(yycode, 3);
    elsif (qxcode is not null) then
      v_f_code := substr(qxcode, 3);
    else
      v_f_code := '000000';
    end if;
    v_dm := to_char(sysdate, 'yy') || v_f_code;
    select case
             when max(substr(vc_bgkid, 0, 14)) is null then
              v_dm || '00001'
             else
              to_char(max(substr(vc_bgkid, 0, 14)) + 1)
           end
      into v_code
      from zjjk_zl_bgk
     where vc_bgkid like v_dm || '%'
       and length(vc_bgkid) = 14
       and stn(vc_bgkid, 1) is not null;
    return v_code;
  END fun_getbgkcode;
  /*--------------------------------------------------------------------------
  || 功能描述 ：肿瘤报告卡主副卡设置
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_zlbgk_zfksz(Data_In    In Clob, --入参
                            result_out OUT VARCHAR2) --返回
   is
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err         VARCHAR2(2000);
    v_json_yw_log json;
    --公共变量
    v_sysdate date;
    v_czyjgdm varchar2(50);
    v_czyyhid zjjk_zl_bgk_zfgx.vc_cjry%type;
    v_czyjgjb varchar2(3);
    v_zkid    zjjk_zl_bgk_zfgx.vc_zkid%type;
    v_fkid    zjjk_zl_bgk_zfgx.vc_fkid%type;
    v_count   number;
  BEGIN
    json_data(data_in, 'zjjk_zl_bgk主副卡设置', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm'); --操作员机构代码
    v_zkid    := Json_Str(v_Json_Data, 'vc_zkid'); --主卡id
    v_fkid    := Json_Str(v_Json_Data, 'vc_fkid'); --副卡id
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb'); --获取机构级别
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid');
    if v_zkid is null then
      v_err := '主卡id不能为空!';
      raise err_custom;
    end if;
    --处理主卡(将历史对应的主卡id改为当前卡)
    update zjjk_zl_bgk_zfgx a
       set a.vc_zkid = v_zkid,
           a.vc_cjjg = v_czyjgdm,
           a.vc_cjry = v_czyyhid,
           a.dt_cjsj = sysdate
     where a.vc_fkid = v_zkid;
    --当前卡不存在主副卡信息,默认当前卡为主卡
    if sql%rowcount = 0 then
      insert into zjjk_zl_bgk_zfgx
        (vc_zkid, vc_fkid)
      values
        (v_zkid, v_zkid);
    end if;
    --处理副卡(副卡id可为空，将当前卡副卡属性改为主卡)
    if v_fkid is not null then
      --检查副卡是否初访
      select count(1)
        into v_count
        from zjjk_zl_bgk a
       where a.vc_bgkid = v_fkid
         and a.vc_sfcf in ('1', '3');
      if v_count = 0 then
        v_err := '当前副卡还未初访!';
        raise err_custom;
      end if;
      --检查该副卡是否为其他副卡的主卡
      select count(1)
        into v_count
        from zjjk_zl_bgk_zfgx a
       where a.vc_zkid = v_fkid
         and a.vc_fkid <> v_fkid;
      if v_count > 0 then
        v_err := '当前副卡为其他卡的主卡，不允许此操作!';
        raise err_custom;
      end if;
      --更新副卡
      update zjjk_zl_bgk_zfgx a
         set a.vc_zkid = v_zkid,
             a.vc_cjjg = v_czyjgdm,
             a.vc_cjry = v_czyyhid,
             a.dt_cjsj = sysdate
       where a.vc_fkid = v_fkid;
      --副卡不存在主副关系则插入
      if sql%rowcount = 0 then
        insert into zjjk_zl_bgk_zfgx
          (vc_zkid, vc_fkid)
        values
          (v_zkid, v_fkid);
      end if;
    end if;
    --操作日志
    v_json_yw_log := Json_ext.get_json(v_json_data, 'ywjllog');
    if v_json_yw_log is not null then
      v_json_yw_log.put('bgkid', v_zkid);
      v_json_yw_log.put('bgklx', '02');
      v_json_yw_log.put('ywjlid', v_zkid);
      v_json_yw_log.put('gnmk', '09');
      v_json_yw_log.put('gnmc', '主副卡设置');
      v_json_yw_log.put('czlx', '01');
      pkg_zjmb_xtfz.prc_zjjk_yw_log_update(v_json_yw_log, v_err);
      if v_err is not null then
        raise err_custom;
      end if;
    end if;
  
    v_Json_Return.put('vc_zkid', v_zkid);
    v_Json_Return.put('vc_fkid', v_fkid);
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_zlbgk_zfksz;
  /*--------------------------------------------------------------------------
  || 功能描述 ：肿瘤报告卡属地确认
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_zlbgk_sdqr(Data_In    In Clob, --入参
                           result_out OUT VARCHAR2) --返回
   is
    v_json_data   json;
    v_json_yw_log json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
    --公共变量
    v_sysdate date;
    v_czyjgdm varchar2(50);
    v_czyjgjb varchar2(3);
    v_bkid    zjjk_zl_bgk.vc_bgkid%type;
    v_gldw    zjjk_zl_bgk.vc_gldw%type;
    v_count   number;
  BEGIN
    json_data(data_in, 'zjjk_zl_bgk属地确认', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_bkid    := Json_Str(v_Json_Data, 'vc_bgkid');
    v_gldw    := Json_Str(v_Json_Data, 'vc_gldw');
    --获取机构级别
    --select fun_getczyjgjb(v_czyjgdm) into v_czyjgjb from dual;
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    if v_czyjgjb not in ('3', '4') then
      v_err := '当前机构无属地确认权限!';
      raise err_custom;
    end if;
    if v_gldw is null then
      v_err := '管理单位不能为空!';
      raise err_custom;
    end if;
    --判断管理单位与户籍街道是否匹配
    select count(1)
      into v_count
      from zjjk_zl_bgk a, zjjk_zl_hzxx b, p_yljg c
     where a.vc_hzid = b.vc_personid
       and b.vc_hkjddm = c.xzqh
       and c.dm = v_gldw
       and c.lb = 'B1'
       and a.vc_bgkid = v_bkid;
    if v_count <> 1 then
      v_err := '管理单位与户籍街道不匹配!';
      raise err_custom;
    end if;
    --修改管理单位
    update zjjk_zl_bgk a
       set a.vc_gldw = v_gldw, a.vc_sdqrzt = '1', dt_xgsj = sysdate
     where a.vc_scbz = '0'
       and a.vc_shbz = '3'
       and a.vc_bgkid = v_bkid
       and a.vc_sdqrzt = '0';
    if sql%rowcount <> 1 then
      v_err := 'id[' || v_bkid || ']未获取到有效报的待属地确认的告卡信息!';
      raise err_custom;
    end if;
    --操作日志
    v_json_yw_log := Json_ext.get_json(v_json_data, 'ywjllog');
    if v_json_yw_log is not null then
      v_json_yw_log.put('bgkid', v_bkid);
      v_json_yw_log.put('bgklx', '02');
      v_json_yw_log.put('ywjlid', v_bkid);
      v_json_yw_log.put('gnmk', '02');
      v_json_yw_log.put('gnmc', '属地确认');
      v_json_yw_log.put('czlx', '01');
      v_json_yw_log.put('ywjlid', v_bkid);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_update(v_json_yw_log, v_err);
      if v_err is not null then
        raise err_custom;
      end if;
    end if;
    v_Json_Return.put('id', v_bkid);
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_zlbgk_sdqr;
  /*--------------------------------------------------------------------------
  || 功能描述 ：肿瘤病报告卡删除
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_zlbgk_sc(Data_In    In Clob, --入参
                         result_out OUT VARCHAR2) --返回
   is
    v_json_data   json;
    v_json_yw_log json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
    --公共变量
    v_sysdate date;
    v_czyjgdm varchar2(50);
    v_czyjgjb varchar2(3);
    v_cfzt    zjjk_zl_bgk.vc_sfcf%type;
    v_bkid    zjjk_zl_bgk.vc_bgkid%type;
    v_scbz    zjjk_zl_bgk.vc_scbz%TYPE; --删除标志
    v_vc_gldw zjjk_zl_bgk.vc_gldw%TYPE;
  BEGIN
    json_data(data_in, 'zjjk_zl_bgk删除', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    --获取机构级别
    --select fun_getczyjgjb(v_czyjgdm) into v_czyjgjb from dual;
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    v_bkid    := Json_Str(v_Json_Data, 'vc_bgkid');
    --获取报卡状态
    begin
      select vc_sfcf, vc_scbz, vc_gldw
        into v_cfzt, v_scbz, v_vc_gldw
        from zjjk_zl_bgk
       where vc_bgkid = v_bkid
         and vc_scbz = '0';
    exception
      when no_data_found then
        v_err := 'id[' || v_bkid || ']未获取到有效报告卡信息!';
        raise err_custom;
    end;
    --校验管理单位审核权限
    if v_czyjgjb = '3' then
      if substr(v_vc_gldw, 1, 6) <> substr(v_czyjgdm, 1, 6) then
        v_err := '非管理单位无此操作权限!';
        raise err_custom;
      end if;
    end if;
    if v_czyjgjb = '4' then
      --医院社区
      if v_cfzt in ('1', '3') then
        v_err := '该报卡已初访，当前机构无权删除!';
        raise err_custom;
      end if;
    elsif v_czyjgjb <> '3' then
      --非区县
      v_err := '当前机构无删除权限!';
      raise err_custom;
    end if;
    --更新删除标志
    update zjjk_zl_bgk
       set vc_scbz = '1', vc_bgkzt = '5', dt_xgsj = sysdate
     where vc_bgkid = v_bkid;
    --记录日志
    v_json_yw_log := Json_ext.get_json(v_json_data, 'ywjllog');
    if v_json_yw_log is not null then
      v_json_yw_log.put('bgkid', v_bkid);
      v_json_yw_log.put('bgklx', '02');
      v_json_yw_log.put('ywjlid', v_bkid);
      v_json_yw_log.put('gnmk', '01');
      v_json_yw_log.put('gnmc', '报卡管理');
      v_json_yw_log.put('czlx', '04');
      v_json_yw_log.put('ywjlid', v_bkid);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_update(v_json_yw_log, v_err);
      if v_err is not null then
        raise err_custom;
      end if;
    end if;
  
    v_Json_Return.put('id', v_bkid);
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_zlbgk_sc;
  /*--------------------------------------------------------------------------
  || 功能描述 ：肿瘤报告卡审核
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_zlbgk_sh(Data_In    In Clob, --入参
                         result_out OUT VARCHAR2) --返回
   is
    v_json_data   json;
    v_json_yw_log json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
    --公共变量
    v_sysdate    date;
    v_czyjgdm    varchar2(50);
    v_czyjgjb    varchar2(3);
    v_shbz       zjjk_zl_bgk.vc_shbz%TYPE; --审核状态
    v_shbz_table zjjk_zl_bgk.vc_shbz%TYPE; --审核状态
    v_bkid       zjjk_zl_bgk.vc_bgkid%type;
    v_shwtgyy    zjjk_zl_bgk.vc_shwtgyy%TYPE; --区县审核未通过原因
    v_shwtgyy1   zjjk_zl_bgk.vc_shwtgyy1%TYPE; --区县审核未通过原因选项
    v_vc_gldw    zjjk_zl_bgk.vc_gldw%TYPE;
  BEGIN
    json_data(data_in, 'zjjk_zl_bgk审核', v_json_data);
    v_sysdate  := sysdate;
    v_czyjgdm  := Json_Str(v_Json_Data, 'czyjgdm');
    v_bkid     := Json_Str(v_Json_Data, 'vc_bgkid');
    v_shbz     := Json_Str(v_Json_Data, 'vc_shbz');
    v_shwtgyy  := Json_Str(v_Json_Data, 'vc_shwtgyy');
    v_shwtgyy1 := Json_Str(v_Json_Data, 'vc_shwtgyy1');
    --获取机构级别
    --select fun_getczyjgjb(v_czyjgdm) into v_czyjgjb from dual;
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    --获取报卡状态
    begin
      select vc_shbz, vc_gldw
        into v_shbz_table, v_vc_gldw
        from zjjk_zl_bgk
       where vc_bgkid = v_bkid
         and vc_scbz = '0'
         and vc_shbz = '1';
    exception
      when no_data_found then
        v_err := 'id[' || v_bkid || ']未获取到有效报告卡信息!';
        raise err_custom;
    end;
    --校验管理单位审核权限
    if v_czyjgjb = '3' then
      if substr(v_vc_gldw, 1, 6) <> substr(v_czyjgdm, 1, 6) then
        v_err := '非管理单位无此操作权限!';
        raise err_custom;
      end if;
    end if;
    if v_czyjgjb <> '3' then
      --非区县
      v_err := '当前机构无审核权限!';
      raise err_custom;
    end if;
    --v_shbz_table := '1';
    if v_shbz_table <> '1' then
      v_err := '报卡当前状态不为区县待审核!';
      raise err_custom;
    end if;
    --判断审核状态
    if v_shbz = '3' then
      v_shwtgyy  := '';
      v_shwtgyy1 := '';
    elsif v_shbz = '4' then
      IF v_shwtgyy1 is NULL then
        v_err := '审核不通过原因不能为空';
        raise err_custom;
      end if;
    else
      v_err := '传入审核状态[' || v_shbz || ']不正确!';
      raise err_custom;
    end if;
    --更新审核标志
    update zjjk_zl_bgk
       set vc_shbz     = v_shbz,
           vc_shwtgyy  = v_shwtgyy,
           vc_shwtgyy1 = v_shwtgyy1,
           dt_qxshsj   = v_sysdate,
           dt_xgsj     = sysdate
     where vc_bgkid = v_bkid;
    v_json_yw_log := Json_ext.get_json(v_json_data, 'ywjllog');
    if v_json_yw_log is not null then
      v_json_yw_log.put('bgkid', v_bkid);
      v_json_yw_log.put('bgklx', '02');
      v_json_yw_log.put('ywjlid', v_bkid);
      v_json_yw_log.put('gnmk', '01');
      v_json_yw_log.put('gnmc', '报卡审核');
      v_json_yw_log.put('czlx', '03');
      v_json_yw_log.put('ywjlid', v_bkid);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_update(v_json_yw_log, v_err);
      if v_err is not null then
        raise err_custom;
      end if;
    end if;
    v_Json_Return.put('id', v_bkid);
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_zlbgk_sh;
  /*--------------------------------------------------------------------------
  || 功能描述 ：肿瘤报告卡迁出管理
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_zlbgk_qc(Data_In    In Clob, --入参
                         result_out OUT VARCHAR2) --返回
   is
    v_json_data   json;
    v_json_yw_log json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
  
    --公共变量
    v_sysdate date;
    v_czyjgdm varchar2(50);
    v_czyyhid zjjk_tnb_qrqcb.vc_qcr%type;
    v_czyjgjb varchar2(3);
    v_count   number;
    v_vc_gldw zjjk_tnb_bgk.vc_gldw%type;
  
    v_vc_jjqcyy zjjk_zl_qrqcb.vc_jjqcyy%TYPE; --拒绝迁出原因
    v_vc_qrgldw zjjk_zl_qrqcb.vc_qrgldw%TYPE; --迁入管理单位
    v_vc_id     zjjk_zl_qrqcb.vc_id%TYPE; --系统唯一ID
    v_vc_xtlb   zjjk_zl_qrqcb.vc_xtlb%TYPE; --系统类别 
    v_vc_bgkid  zjjk_zl_qrqcb.vc_bgkid%TYPE; --报告卡ID
    v_vc_qccs   zjjk_zl_qrqcb.vc_qccs%TYPE; --迁出市
    v_vc_qcqx   zjjk_zl_qrqcb.vc_qcqx%TYPE; --迁出区县
    v_vc_qcjd   zjjk_zl_qrqcb.vc_qcjd%TYPE; --迁出街道
    v_vc_qcdl   zjjk_zl_qrqcb.vc_qcdl%TYPE; --迁出道路
    v_vc_qcjw   zjjk_zl_qrqcb.vc_qcjw%TYPE; --迁出居委
    v_vc_qcxxdz zjjk_zl_qrqcb.vc_qcxxdz%TYPE; --迁出详细地址
    v_vc_qrcs   zjjk_zl_qrqcb.vc_qrcs%TYPE; --迁入市
    v_vc_qrqx   zjjk_zl_qrqcb.vc_qrqx%TYPE; --迁入区县
    v_vc_qrjd   zjjk_zl_qrqcb.vc_qrjd%TYPE; --迁入街道
    v_vc_qrdl   zjjk_zl_qrqcb.vc_qrdl%TYPE; --迁入道路
    v_vc_qrjw   zjjk_zl_qrqcb.vc_qrjw%TYPE; --迁入居委
    v_vc_qrxxdz zjjk_zl_qrqcb.vc_qrxxdz%TYPE; --迁入详细地址
    v_dt_qcsj   zjjk_zl_qrqcb.dt_qcsj%TYPE; --迁出时间
    v_dt_clsj   zjjk_zl_qrqcb.dt_clsj%TYPE; --处理时间
    v_vc_clfs   zjjk_zl_qrqcb.vc_clfs%TYPE; --处理方式
    v_vc_qcr    zjjk_zl_qrqcb.vc_qcr%TYPE; --迁出人
    v_vc_clr    zjjk_zl_qrqcb.vc_clr%TYPE; --处理人
    v_vc_zhxgr  zjjk_zl_qrqcb.vc_zhxgr%TYPE; --最后修改人
    v_dt_zhxgsj zjjk_zl_qrqcb.dt_zhxgsj%TYPE; --最后修改时间
    v_qyshbz    varchar2(1);
    v_hzid      zjjk_zl_hzxx.vc_personid%TYPE; --患者ID
  
  BEGIN
    json_data(data_in, 'zjjk_zl_bgk迁出', v_json_data);
    v_sysdate  := sysdate;
    v_czyjgdm  := Json_Str(v_Json_Data, 'czyjgdm'); --操作员机构代码
    v_vc_bgkid := Json_Str(v_Json_Data, 'vc_bgkid'); --报告卡id
    v_czyjgjb  := Json_Str(v_Json_Data, 'czyjgjb'); --获取机构级别
    v_czyyhid  := Json_Str(v_Json_Data, 'czyyhid'); --操作员id
    v_qyshbz   := Json_Str(v_Json_Data, 'qyshbz'); --迁移审核标志
    v_vc_clfs  := '2'; --0接收 1待迁出 2、待接收 3、拒绝
    v_vc_id    := sys_guid();
    --获取迁入地址信息
    v_vc_qrcs   := Json_Str(v_Json_Data, 'vc_qrcs'); --迁入市
    v_vc_qrqx   := Json_Str(v_Json_Data, 'vc_qrqx'); --迁入区县
    v_vc_qrjd   := Json_Str(v_Json_Data, 'vc_qrjd'); --迁入街道
    v_vc_qrdl   := Json_Str(v_Json_Data, 'vc_qrdl'); --迁入道路
    v_vc_qrjw   := Json_Str(v_Json_Data, 'vc_qrjw'); --迁入居委
    v_vc_qrxxdz := Json_Str(v_Json_Data, 'vc_qrxxdz'); --迁入详细地址
    v_vc_qrgldw := Json_Str(v_Json_Data, 'vc_qrgldw'); --管理单位
    v_vc_jjqcyy := Json_Str(v_Json_Data, 'vc_jjqcyy'); --决绝原因
    --获取迁出地址信息
    if v_czyjgjb <> '3' then
      --非区县
      v_err := '当前机构无迁出审核权限!';
      raise err_custom;
    end if;
    if v_vc_bgkid is null then
      v_err := '报告卡id不能为空!';
      raise err_custom;
    end if;
    --获取转移的报告卡信息(转出地暂时取患者信息的户籍信息)
    begin
      select b.vc_hksdm,
             b.vc_hkqxdm,
             b.vc_hkjddm,
             b.vc_hkjwdm,
             b.vc_hkxxdz,
             a.vc_gldw,
             b.vc_personid
        into v_vc_qccs,
             v_vc_qcqx,
             v_vc_qcjd,
             v_vc_qcjw,
             v_vc_qrxxdz,
             v_vc_gldw,
             v_hzid
        from zjjk_zl_bgk a, zjjk_zl_hzxx b
       where a.vc_bgkid = v_vc_bgkid
         and a.vc_hzid = b.vc_personid
         and a.vc_qcbz = '1';
    exception
      when no_data_found then
        v_err := '未获取到待转移的报卡信息!';
        raise err_custom;
    end;
    if v_qyshbz is null then
      v_err := '请选择审核状态!';
      raise err_custom;
    end if;
    --拒绝迁出
    if v_qyshbz = '0' then
      v_vc_clfs := '3';
      if v_vc_jjqcyy is null then
        v_err := '请填写拒绝原因!';
        raise err_custom;
      end if;
      --默认原来的管理单位
      v_vc_qrgldw := v_vc_gldw;
    else
      --同意迁出,判断是否同一区域
      if v_vc_qcqx = v_vc_qrqx then
        --同一个区县,审核通过
        v_vc_clfs := '0'; --直接接收
        --判断是否传入管理单位
        if v_vc_qrgldw is null then
          v_err := '请选择管理单位!';
          raise err_custom;
        end if;
        --更新患者户籍信息
        update zjjk_zl_hzxx a
           set a.vc_hksdm  = v_vc_qrcs,
               a.vc_hkqxdm = v_vc_qrqx,
               a.vc_hkjddm = v_vc_qrjd,
               a.vc_hkjwdm = v_vc_qrjw,
               a.vc_hkxxdz = v_vc_qrxxdz
         where a.vc_personid = v_hzid;
      else
        --不同区县
        v_vc_clfs := '2'; --待接收
        --未接收前不改变管理单位
        v_vc_qrgldw := v_vc_gldw;
      end if;
    end if;
    --写入迁移记录
    insert into zjjk_zl_qrqcb
      (vc_jjqcyy,
       dt_zhxgsj,
       vc_zhxgr,
       vc_qcr,
       vc_clfs,
       dt_qcsj,
       vc_qrxxdz,
       vc_qrjw,
       vc_qrdl,
       vc_qrjd,
       vc_qrqx,
       vc_qrcs,
       vc_qcxxdz,
       vc_qcjw,
       vc_qcdl,
       vc_qcjd,
       vc_qcqx,
       vc_qccs,
       vc_bgkid,
       vc_id,
       vc_qcgldw)
    values
      (v_vc_jjqcyy,
       v_sysdate,
       v_czyyhid,
       v_czyyhid,
       v_vc_clfs,
       v_sysdate,
       v_vc_qrxxdz,
       v_vc_qrjw,
       v_vc_qrdl,
       v_vc_qrjd,
       v_vc_qrqx,
       v_vc_qrcs,
       v_vc_qcxxdz,
       v_vc_qcjw,
       v_vc_qcdl,
       v_vc_qcjd,
       v_vc_qcqx,
       v_vc_qccs,
       v_vc_bgkid,
       v_vc_id,
       v_vc_gldw);
    --更新报告卡
    update zjjk_zl_bgk a
       set a.vc_qcbz   = '0',
           a.vc_qcsdm  = v_vc_qrcs,
           a.vc_qcqxdm = v_vc_qrqx,
           a.vc_qcjddm = v_vc_qrjd,
           a.vc_qcjw   = v_vc_qrjw,
           a.vc_qcxxdz = v_vc_qrxxdz,
           a.vc_gldw   = v_vc_qrgldw,
           dt_xgsj     = sysdate
     where a.vc_bgkid = v_vc_bgkid;
  
    --操作日志
    v_json_yw_log := Json_ext.get_json(v_json_data, 'ywjllog');
    if v_json_yw_log is not null then
      v_json_yw_log.put('bgkid', v_vc_bgkid);
    
      v_json_yw_log.put('bgklx', '02');
      v_json_yw_log.put('ywjlid', v_vc_bgkid);
      v_json_yw_log.put('gnmk', '07');
      v_json_yw_log.put('gnmc', '迁出');
      v_json_yw_log.put('czlx', '01');
      v_json_yw_log.put('ywjlid', v_vc_bgkid);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_update(v_json_yw_log, v_err);
      if v_err is not null then
        raise err_custom;
      end if;
    end if;
    v_Json_Return.put('id', v_vc_id);
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_zlbgk_qc;
  /*--------------------------------------------------------------------------
  || 功能描述 ：肿瘤报告卡迁入管理
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_zlbgk_qr(Data_In    In Clob, --入参
                         result_out OUT VARCHAR2) --返回
   is
    v_json_data   json;
    v_json_yw_log json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
  
    --公共变量
    v_sysdate date;
    v_czyjgdm varchar2(50);
    v_czyyhid zjjk_zl_qrqcb.vc_qcr%type;
    v_czyjgjb varchar2(3);
    v_count   number;
    v_vc_gldw zjjk_zl_bgk.vc_gldw%type;
  
    v_vc_jjqcyy zjjk_zl_qrqcb.vc_jjqcyy%TYPE; --拒绝迁出原因
    v_vc_qrgldw zjjk_zl_qrqcb.vc_qrgldw%TYPE; --迁入管理单位
    v_vc_id     zjjk_zl_qrqcb.vc_id%TYPE; --系统唯一ID
    v_vc_xtlb   zjjk_zl_qrqcb.vc_xtlb%TYPE; --系统类别 
    v_vc_bgkid  zjjk_zl_qrqcb.vc_bgkid%TYPE; --报告卡ID
    v_vc_qccs   zjjk_zl_qrqcb.vc_qccs%TYPE; --迁出市
    v_vc_qcqx   zjjk_zl_qrqcb.vc_qcqx%TYPE; --迁出区县
    v_vc_qcjd   zjjk_zl_qrqcb.vc_qcjd%TYPE; --迁出街道
    v_vc_qcdl   zjjk_zl_qrqcb.vc_qcdl%TYPE; --迁出道路
    v_vc_qcjw   zjjk_zl_qrqcb.vc_qcjw%TYPE; --迁出居委
    v_vc_qcxxdz zjjk_zl_qrqcb.vc_qcxxdz%TYPE; --迁出详细地址
    v_vc_qrcs   zjjk_zl_qrqcb.vc_qrcs%TYPE; --迁入市
    v_vc_qrqx   zjjk_zl_qrqcb.vc_qrqx%TYPE; --迁入区县
    v_vc_qrjd   zjjk_zl_qrqcb.vc_qrjd%TYPE; --迁入街道
    v_vc_qrdl   zjjk_zl_qrqcb.vc_qrdl%TYPE; --迁入道路
    v_vc_qrjw   zjjk_zl_qrqcb.vc_qrjw%TYPE; --迁入居委
    v_vc_qrxxdz zjjk_zl_qrqcb.vc_qrxxdz%TYPE; --迁入详细地址
    v_dt_qcsj   zjjk_zl_qrqcb.dt_qcsj%TYPE; --迁出时间
    v_dt_clsj   zjjk_zl_qrqcb.dt_clsj%TYPE; --处理时间
    v_vc_clfs   zjjk_zl_qrqcb.vc_clfs%TYPE; --处理方式
    v_vc_qcr    zjjk_zl_qrqcb.vc_qcr%TYPE; --迁出人
    v_vc_clr    zjjk_zl_qrqcb.vc_clr%TYPE; --处理人
    v_vc_zhxgr  zjjk_zl_qrqcb.vc_zhxgr%TYPE; --最后修改人
    v_dt_zhxgsj zjjk_zl_qrqcb.dt_zhxgsj%TYPE; --最后修改时间
    v_qyshbz    varchar2(1);
    v_hzid      zjjk_zl_hzxx.vc_personid%TYPE; --患者ID
    v_bgkid_q   zjjk_zl_qrqcb.vc_bgkid%type;
  BEGIN
    json_data(data_in, 'zjjk_zl_bgk迁出', v_json_data);
    v_sysdate  := sysdate;
    v_czyjgdm  := Json_Str(v_Json_Data, 'czyjgdm'); --操作员机构代码
    v_vc_bgkid := Json_Str(v_Json_Data, 'vc_bgkid'); --报告卡id
    v_czyjgjb  := Json_Str(v_Json_Data, 'czyjgjb'); --获取机构级别
    v_czyyhid  := Json_Str(v_Json_Data, 'czyyhid'); --操作员id
    v_qyshbz   := Json_Str(v_Json_Data, 'qyshbz'); --迁移审核标志
    v_vc_clfs  := '0'; --0接收 1待迁出 2、待接收 3、拒绝
    v_vc_id    := Json_Str(v_Json_Data, 'vc_qyid'); --迁移ID
    --获取迁入地址信息
    v_vc_qrcs   := Json_Str(v_Json_Data, 'vc_qrcs'); --迁入市
    v_vc_qrqx   := Json_Str(v_Json_Data, 'vc_qrqx'); --迁入区县
    v_vc_qrjd   := Json_Str(v_Json_Data, 'vc_qrjd'); --迁入街道
    v_vc_qrdl   := Json_Str(v_Json_Data, 'vc_qrdl'); --迁入道路
    v_vc_qrjw   := Json_Str(v_Json_Data, 'vc_qrjw'); --迁入居委
    v_vc_qrxxdz := Json_Str(v_Json_Data, 'vc_qrxxdz'); --迁入详细地址
    v_vc_qrgldw := Json_Str(v_Json_Data, 'vc_qrgldw'); --管理单位
    v_vc_jjqcyy := Json_Str(v_Json_Data, 'vc_jjqcyy'); --决绝原因
    --获取迁出地址信息
    if v_czyjgjb <> '3' then
      --非区县
      v_err := '当前机构无迁出审核权限!';
      raise err_custom;
    end if;
    if v_vc_bgkid is null then
      v_err := '报告卡id不能为空!';
      raise err_custom;
    end if;
    if v_vc_id is null then
      v_err := '迁移id不能为空!';
      raise err_custom;
    end if;
    --获取转移信息
    begin
      select a.vc_qrcs,
             a.vc_qrqx,
             a.vc_qrjd,
             a.vc_qrjw,
             a.vc_qrxxdz,
             a.vc_bgkid
        into v_vc_qrcs,
             v_vc_qrqx,
             v_vc_qrjd,
             v_vc_qrjw,
             v_vc_qrxxdz,
             v_bgkid_q
        from zjjk_zl_qrqcb a
       where a.vc_id = v_vc_id
         and a.vc_clfs = '2';
    exception
      when no_data_found then
        v_err := '未获取到待转入的转移信息!';
        raise err_custom;
    end;
    if v_bgkid_q <> v_vc_bgkid then
      v_err := '传入迁移id与报告卡不符!';
      raise err_custom;
    end if;
    --获取转移报卡信息
    begin
      select b.vc_hksdm,
             b.vc_hkqxdm,
             b.vc_hkjddm,
             b.vc_hkjwdm,
             b.vc_hkxxdz,
             a.vc_gldw,
             b.vc_personid
        into v_vc_qccs,
             v_vc_qcqx,
             v_vc_qcjd,
             v_vc_qcjw,
             v_vc_qrxxdz,
             v_vc_gldw,
             v_hzid
        from zjjk_zl_bgk a, zjjk_zl_hzxx b
       where a.vc_bgkid = v_vc_bgkid
         and a.vc_hzid = b.vc_personid;
    exception
      when no_data_found then
        v_err := '未获取到待转移的报卡信息!';
        raise err_custom;
    end;
    --拒绝迁出
    if v_qyshbz = '0' then
      v_vc_clfs := '3';
      if v_vc_jjqcyy is null then
        v_err := '请填写拒绝原因!';
        raise err_custom;
      end if;
      --默认原来的管理单位
      v_vc_qrgldw := v_vc_gldw;
    else
      --同意迁出
      v_vc_clfs := '0'; --直接接收
      --判断是否传入管理单位
      if v_vc_qrgldw is null then
        v_err := '请选择管理单位!';
        raise err_custom;
      end if;
      --更新患者户籍信息
      update zjjk_zl_hzxx a
         set a.vc_hksdm  = v_vc_qrcs,
             a.vc_hkqxdm = v_vc_qrqx,
             a.vc_hkjddm = v_vc_qrjd,
             a.vc_hkjwdm = v_vc_qrjw,
             a.vc_hkxxdz = v_vc_qrxxdz
       where a.vc_personid = v_hzid;
    end if;
    --更新迁移记录
    update zjjk_zl_qrqcb a
       set a.vc_clfs   = v_vc_clfs,
           a.vc_jjqcyy = v_vc_jjqcyy,
           a.vc_clr    = v_czyyhid,
           a.dt_clsj   = v_sysdate,
           a.dt_zhxgsj = v_sysdate
     where a.vc_id = v_vc_id;
    --更新报告卡
    update zjjk_zl_bgk a
       set a.vc_qcbz = '0', a.vc_gldw = v_vc_qrgldw, dt_xgsj = sysdate
     where a.vc_bgkid = v_vc_bgkid;
    --操作日志
    v_json_yw_log := Json_ext.get_json(v_json_data, 'ywjllog');
    if v_json_yw_log is not null then
      v_json_yw_log.put('bgkid', v_vc_bgkid);
    
      v_json_yw_log.put('bgklx', '02');
      v_json_yw_log.put('ywjlid', v_vc_bgkid);
      v_json_yw_log.put('gnmk', '06');
      v_json_yw_log.put('gnmc', '迁入');
      v_json_yw_log.put('czlx', '01');
      v_json_yw_log.put('ywjlid', v_vc_bgkid);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_update(v_json_yw_log, v_err);
      if v_err is not null then
        raise err_custom;
      end if;
    end if;
    v_Json_Return.put('id', v_vc_id);
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_zlbgk_qr;
  /*--------------------------------------------------------------------------
  || 功能描述 ：肿瘤报告卡死亡补发
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_zlbgk_swbf(Data_In    In Clob, --入参
                           result_out OUT VARCHAR2) --返回
   is
    v_json_data   json;
    v_json_yw_log json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
  
    --公共变量
    v_sysdate  date;
    v_czyjgdm  varchar2(50);
    v_czyjgjb  varchar2(3);
    v_czyyhid  varchar2(50);
    v_zl_bgkid varchar2(4000);
    v_sw_bgkid varchar2(4000);
    v_pplx     varchar2(1);
  
  BEGIN
    json_data(data_in, 'zjjk_zl_bgk死亡补发', v_json_data);
    v_sysdate  := sysdate;
    v_czyjgdm  := Json_Str(v_Json_Data, 'czyjgdm'); --操作员机构代码
    v_czyjgjb  := Json_Str(v_Json_Data, 'czyjgjb'); --获取机构级别
    v_czyyhid  := Json_Str(v_Json_Data, 'czyyhid'); --操作员id
    v_zl_bgkid := Json_Str(v_Json_Data, 'vc_zl_bgkid'); --肿瘤报卡id
    v_sw_bgkid := Json_Str(v_Json_Data, 'vc_sw_bgkid'); --死亡报卡id
    v_pplx     := Json_Str(v_Json_Data, 'pplx'); --匹配类型
    if v_czyjgdm is null then
      v_err := '未获取到操作员信息!';
      raise err_custom;
    end if;
    --判断权限机构或区县
    if v_czyjgjb not in ('3', '4') then
      v_err := '当前机构无操作权限!';
      raise err_custom;
    end if;
    if v_sw_bgkid is null then
      v_err := '未获取到死亡报卡id!';
      raise err_custom;
    end if;
    --更新报告，匹配
    if v_pplx = '1' then
      if v_zl_bgkid is null then
        v_err := '未获取到肿瘤报卡id!';
        raise err_custom;
      end if;
      update zjmb_sw_bgk a
         set a.vc_zlbfzt = '1'
       where a.vc_bgkid = v_sw_bgkid;
      if sql%rowcount = 0 then
        v_err := '死亡报告id未找到对应的报卡!';
        raise err_custom;
      end if;
      update zjjk_zl_bgk a
         set a.vc_bgkzt = '7',
             dt_xgsj = sysdate,
             (a.vc_swicd10, a.dt_swrq) =
             (select b.vc_gbsy, b.dt_swrq
                from zjmb_sw_bgk b
               where b.vc_bgkid = v_sw_bgkid)
       where a.vc_bgkid in
             (select distinct column_value column_value
                from table(split(v_zl_bgkid, ',')))
         and nvl(a.vc_bgkzt, '0') <> '7';
      --未匹配上
    elsif v_pplx = '0' then
      update zjmb_sw_bgk a
         set a.vc_zlbfzt = '2'
       where a.vc_bgkid in
             (select distinct column_value column_value
                from table(split(v_sw_bgkid, ',')));
      if sql%rowcount = 0 then
        v_err := '死亡报告id未找到对应的报卡!';
        raise err_custom;
      end if;
    else
      v_err := '匹配类型有误!';
      raise err_custom;
    end if;
    --操作日志
    v_json_yw_log := Json_ext.get_json(v_json_data, 'ywjllog');
    if v_json_yw_log is not null then
      v_json_yw_log.put('bgkid', '');
      v_json_yw_log.put('bgklx', '02');
      v_json_yw_log.put('ywjlid', '');
      v_json_yw_log.put('gnmk', '03');
      v_json_yw_log.put('gnmc', '死亡补发');
      v_json_yw_log.put('czlx', '01');
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
      result_out := return_fail(v_err, 0);
  END prc_zlbgk_swbf;
  /*--------------------------------------------------------------------------
  || 功能描述 ：肿瘤报告卡查重
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_zlbgk_cc(Data_In    In Clob, --入参
                         result_out OUT VARCHAR2) --返回
   is
    v_json_data   json;
    v_json_yw_log json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
  
    --公共变量
    v_sysdate       date;
    v_czyjgdm       varchar2(50);
    v_czyyhid       zjjk_zl_qrqcb.vc_qcr%type;
    v_czyjgjb       varchar2(3);
    v_json_list_yx  json_List; --有效卡
    v_json_list_cf  json_List; --重复卡
    v_json_temp_bgk Json;
    v_vc_bgkid      zjjk_zl_bgk.vc_bgkid%type;
  
  BEGIN
    json_data(data_in, 'zjjk_zl_bgk查重', v_json_data);
    v_sysdate      := sysdate;
    v_czyjgdm      := Json_Str(v_Json_Data, 'czyjgdm'); --操作员机构代码
    v_czyjgjb      := Json_Str(v_Json_Data, 'czyjgjb'); --获取机构级别
    v_czyyhid      := Json_Str(v_Json_Data, 'czyyhid'); --操作员id
    v_Json_List_yx := Json_Ext.Get_Json_List(v_Json_Data, 'yx_arr'); --有效卡
    v_Json_List_cf := Json_Ext.Get_Json_List(v_Json_Data, 'cf_arr'); --重复卡
    if v_czyjgdm is null then
      v_err := '未获取到操作员信息!';
      raise err_custom;
    end if;
  
    --处理有效卡
    if v_json_list_yx.count > 0 then
      for i in 1 .. v_json_list_yx.count loop
        v_json_temp_bgk := Json(v_json_list_yx.Get(i));
        v_vc_bgkid      := Json_Str(v_json_temp_bgk, 'vc_bgkid');
        update zjjk_zl_bgk a
           set a.vc_ccid = v_czyjgdm, dt_xgsj = sysdate
         where a.vc_bgkid = v_vc_bgkid;
      end loop;
    else
      v_err := '未获取到有效卡!';
      raise err_custom;
    end if;
    --处理重复卡
    if v_json_list_cf.count > 0 then
      for i in 1 .. v_json_list_cf.count loop
        v_json_temp_bgk := Json(v_json_list_cf.Get(i));
        v_vc_bgkid      := Json_Str(v_json_temp_bgk, 'vc_bgkid');
        update zjjk_zl_bgk a
           set a.vc_ccid = v_czyjgdm, a.vc_bgkzt = '4', dt_xgsj = sysdate
         where a.vc_bgkid = v_vc_bgkid;
      end loop;
    else
      --v_err := '未获取到重复卡!';
      --raise err_custom;
      --允许全部为有效卡
      null;
    end if;
    --操作日志
    v_json_yw_log := Json_ext.get_json(v_json_data, 'ywjllog');
    if v_json_yw_log is not null then
      v_json_yw_log.put('bgkid', '');
      v_json_yw_log.put('bgklx', '02');
      v_json_yw_log.put('ywjlid', '');
      v_json_yw_log.put('gnmk', '08');
      v_json_yw_log.put('gnmc', '查重');
      v_json_yw_log.put('czlx', '01');
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
      result_out := return_fail(v_err, 0);
  END prc_zlbgk_cc;
  /*--------------------------------------------------------------------------
  || 功能描述 ：肿瘤报初访更新
  ||------------------------------------------------------------------------*/
  procedure prc_zlcfk_update(Data_In    In Clob, --入参
                             result_out OUT VARCHAR2) --返回
   is
    v_nb_kspf      zjjk_zl_ccsfk.nb_kspf%TYPE; --卡氏评分
    v_vc_ysqm      zjjk_zl_ccsfk.vc_ysqm%TYPE; --医生签名
    v_vc_hzqm      zjjk_zl_ccsfk.vc_hzqm%TYPE; --患者签名
    v_vc_scbz      zjjk_zl_ccsfk.vc_scbz%TYPE; --删除标志
    v_vc_cjyh      zjjk_zl_ccsfk.vc_cjyh%TYPE; --创建用户
    v_dt_cjsj      zjjk_zl_ccsfk.dt_cjsj%TYPE; --创建时间
    v_dt_xgsj      zjjk_zl_ccsfk.dt_xgsj%TYPE; --修改时间
    v_vc_xgyh      zjjk_zl_ccsfk.vc_xgyh%TYPE; --修改用户
    v_vc_sfcf      zjjk_zl_ccsfk.vc_sfcf%TYPE; --是否初访
    v_vc_sczzrq    zjjk_zl_ccsfk.vc_sczzrq%TYPE; --首次症状出现日期
    v_vc_scjzsj    zjjk_zl_ccsfk.vc_scjzsj%TYPE; --首次就诊时间
    v_vc_scssyy    zjjk_zl_ccsfk.vc_scssyy%TYPE; --首次手术医院
    v_vc_scssrq    zjjk_zl_ccsfk.vc_scssrq%TYPE; --首次手术日期
    v_vc_scssxz    zjjk_zl_ccsfk.vc_scssxz%TYPE; --首次手术性质
    v_vc_zyh       zjjk_zl_ccsfk.vc_zyh%TYPE; --住院号
    v_vc_blh       zjjk_zl_ccsfk.vc_blh%TYPE; --病理号
    v_vc_qcd       zjjk_zl_ccsfk.vc_qcd%TYPE; --迁出省
    v_vc_qcsdm     zjjk_zl_ccsfk.vc_qcsdm%TYPE; --迁出市
    v_vc_qcqxdm    zjjk_zl_ccsfk.vc_qcqxdm%TYPE; --迁出区
    v_vc_qcjddm    zjjk_zl_ccsfk.vc_qcjddm%TYPE; --迁出街道
    v_vc_qcjw      zjjk_zl_ccsfk.vc_qcjw%TYPE; --迁出居委
    v_vc_sfqc      zjjk_zl_ccsfk.vc_sfqc%TYPE; --是否迁出
    v_dt_qcsj      zjjk_zl_ccsfk.dt_qcsj%TYPE; --迁出时间
    v_vc_qcxxdz    zjjk_zl_ccsfk.vc_qcxxdz%TYPE; --迁出详细地址
    v_vc_hjhs      zjjk_zl_ccsfk.vc_hjhs%TYPE; --户口核实
    v_vc_zybw      zjjk_zl_ccsfk.vc_zybw%TYPE; --转移部位
    v_vc_zljzs     zjjk_zl_ccsfk.vc_zljzs%TYPE; --肿瘤家族史
    v_vc_gx        zjjk_zl_ccsfk.vc_gx%TYPE; --关系
    v_vc_lb        zjjk_zl_ccsfk.vc_lb%TYPE; --瘤别
    v_vc_cxglrq    zjjk_zl_ccsfk.vc_cxglrq%TYPE; --撤消管理日期
    v_vc_cxglyy    zjjk_zl_ccsfk.vc_cxglyy%TYPE; --撤消管理原因
    v_vc_jzdhs     zjjk_zl_ccsfk.vc_jzdhs%TYPE; --居住地核实
    v_vc_whsyy     zjjk_zl_ccsfk.vc_whsyy%TYPE; --未核实原因
    v_vc_ssyy1     zjjk_zl_ccsfk.vc_ssyy1%TYPE; --手术医院1
    v_vc_ssyy2     zjjk_zl_ccsfk.vc_ssyy2%TYPE; --手术医院2
    v_vc_hlyy1     zjjk_zl_ccsfk.vc_hlyy1%TYPE; --化疗医院1
    v_vc_hlyy2     zjjk_zl_ccsfk.vc_hlyy2%TYPE; --化疗医院2
    v_vc_flyy1     zjjk_zl_ccsfk.vc_flyy1%TYPE; --放疗医院1
    v_vc_flyy2     zjjk_zl_ccsfk.vc_flyy2%TYPE; --放疗医院2
    v_vc_hjwhsyy   zjjk_zl_ccsfk.vc_hjwhsyy%TYPE; --户口未核实原因
    v_vc_swicd     zjjk_zl_ccsfk.vc_swicd%TYPE; --死亡ICD
    v_vc_swicdmc   zjjk_zl_ccsfk.vc_swicdmc%TYPE; --死亡ICD名称
    v_vc_xys       zjjk_zl_ccsfk.vc_xys%TYPE; --吸烟史
    v_vc_rjxyzs    zjjk_zl_ccsfk.vc_rjxyzs%TYPE; --日均吸烟支数
    v_vc_scxyrqn   zjjk_zl_ccsfk.vc_scxyrqn%TYPE; --首次吸烟日期年
    v_vc_scxyrqy   zjjk_zl_ccsfk.vc_scxyrqy%TYPE; --首次吸烟日期月
    v_vc_mcxyrqn   zjjk_zl_ccsfk.vc_mcxyrqn%TYPE; --末次吸烟日期年
    v_vc_mcxyrqy   zjjk_zl_ccsfk.vc_mcxyrqy%TYPE; --末次吸烟日期月
    v_vc_hjxysjn   zjjk_zl_ccsfk.vc_hjxysjn%TYPE; --合计吸烟时间年
    v_vc_hjxysjy   zjjk_zl_ccsfk.vc_hjxysjy%TYPE; --合计吸烟时间月
    v_nb_tz        zjjk_zl_ccsfk.nb_tz%TYPE; --体重
    v_nb_sg        zjjk_zl_ccsfk.nb_sg%TYPE; --身高
    v_vc_gxbz      zjjk_zl_ccsfk.vc_gxbz%TYPE; --更新标志
    v_vc_jzdhsyy   zjjk_zl_ccsfk.vc_jzdhsyy%TYPE; --
    v_vc_sfhzl     zjjk_zl_ccsfk.vc_sfhzl%TYPE; --是否患肿瘤，1是2否
    v_vc_sfzh      zjjk_zl_ccsfk.vc_sfzh%TYPE; --身份证号
    v_vc_sfkid     zjjk_zl_ccsfk.vc_sfkid%TYPE; --随访卡ID
    v_vc_bgkid     zjjk_zl_ccsfk.vc_bgkid%TYPE; --报告卡ID
    v_vc_hzid      zjjk_zl_ccsfk.vc_hzid%TYPE; --患者ID
    v_dt_sfrq      zjjk_zl_ccsfk.dt_sfrq%TYPE; --随访日期
    v_nb_zgjg      zjjk_zl_ccsfk.nb_zgjg%TYPE; --转归结果
    v_nb_zgjg_qcdz zjjk_zl_ccsfk.nb_zgjg_qcdz%TYPE; --转归结果_迁出地址代码
    v_nb_zgjg_sfyy zjjk_zl_ccsfk.nb_zgjg_sfyy%TYPE; --初访结果_失访原因
    v_dt_swrq      zjjk_zl_ccsfk.dt_swrq%TYPE; --死亡日期
    v_vc_swyy      zjjk_zl_ccsfk.vc_swyy%TYPE; --死亡原因
    v_vc_swdd      zjjk_zl_ccsfk.vc_swdd%TYPE; --死亡地点
    v_vc_scq       zjjk_zl_ccsfk.vc_scq%TYPE; --生存期
    v_vc_zlxm      zjjk_zl_ccsfk.vc_zlxm%TYPE; --治疗项目
    v_vc_ssyy      zjjk_zl_ccsfk.vc_ssyy%TYPE; --手术医院1
    v_vc_hlyy      zjjk_zl_ccsfk.vc_hlyy%TYPE; --化疗医院1
    v_vc_flyy      zjjk_zl_ccsfk.vc_flyy%TYPE; --放疗医院1
    v_vc_sfzy      zjjk_zl_ccsfk.vc_sfzy%TYPE; --是否转移
    v_dt_zysj      zjjk_zl_ccsfk.dt_zysj%TYPE; --转移时间
    v_vc_czlqk     zjjk_zl_ccsfk.vc_czlqk%TYPE; --曾治疗情况
    v_vc_mqqk      zjjk_zl_ccsfk.vc_mqqk%TYPE; --目前情况
  
    --公共变量
    v_czyhjgjb    varchar2(20);
    v_json_data   json;
    v_json_yw_log json;
    v_ywjl_czlx   varchar2(3);
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err     VARCHAR2(2000);
    v_sysdate date;
    v_count   number(2);
    --定义患者信息字段
    h_vc_sfsw   zjjk_zl_hzxx.vc_sfsw%type;
    h_vc_hksfdm zjjk_zl_hzxx.vc_hksfdm%type;
    h_vc_hksdm  zjjk_zl_hzxx.vc_hksdm%type;
    h_vc_hkqxdm zjjk_zl_hzxx.vc_hkqxdm%type;
    h_vc_hkjddm zjjk_zl_hzxx.vc_hkjddm%type;
    h_vc_hkjwdm zjjk_zl_hzxx.vc_hkjwdm%type;
    h_vc_sfzh   zjjk_zl_hzxx.vc_sfzh%type;
    h_vc_hkxxdz zjjk_zl_hzxx.vc_hkxxdz%type;
    --定义肿瘤报卡信息字段
    b_vc_bgkzt  zjjk_zl_bgk.vc_bgkzt%type;
    b_vc_swyy   zjjk_zl_bgk.vc_swyy%type;
    b_dt_swrq   zjjk_zl_bgk.dt_swrq%type;
    b_vc_qcbz   zjjk_zl_bgk.vc_qcbz%type;
    b_vc_sfcf   zjjk_zl_bgk.vc_sfcf%type;
    b_vc_sfqc   zjjk_zl_bgk.vc_sfqc%type;
    b_vc_hjhs   zjjk_zl_bgk.vc_hjhs%type;
    b_nb_kspf   zjjk_zl_bgk.nb_kspf%type;
    b_dt_cfsj   zjjk_zl_bgk.dt_cfsj%type;
    b_dt_sfrq   zjjk_zl_bgk.dt_sfrq%type;
    b_vc_qcd    zjjk_zl_bgk.vc_qcd%type;
    b_vc_gldw   zjjk_zl_bgk.vc_gldw%type;
    b_vc_qcsdm  zjjk_zl_bgk.vc_qcsdm%type;
    b_vc_qcqxdm zjjk_zl_bgk.vc_qcqxdm%type;
    b_vc_qcjddm zjjk_zl_bgk.vc_qcjddm%type;
    b_vc_qcjw   zjjk_zl_bgk.vc_qcjw%type;
    b_vc_qcxxdz zjjk_zl_bgk.vc_qcxxdz%type;
    b_dt_qcsj   zjjk_zl_bgk.dt_qcsj%type;
    b_dt_sczdrq zjjk_zl_bgk.dt_sczdrq%type;
    b_vc_hzid   zjjk_zl_bgk.vc_hzid%type;
    v_vc_sdqrzt varchar2(10);
  BEGIN
    json_data(Data_In, 'ZJJK_ZL_CCSFK新增', v_json_data);
    v_sysdate := sysdate;
    --初随访卡赋值
    v_czyhjgjb   := json_str(v_json_data, 'czyjgjb');
    v_nb_kspf    := to_number(Json_Str(v_Json_Data, 'nb_kspf'));
    v_vc_ysqm    := Json_Str(v_Json_Data, 'vc_ysqm');
    v_vc_hzqm    := Json_Str(v_Json_Data, 'vc_hzqm');
    v_vc_scbz    := Json_Str(v_Json_Data, 'vc_scbz');
    v_vc_cjyh    := Json_Str(v_Json_Data, 'czyyhid');
    v_dt_cjsj    := v_sysdate;
    v_dt_xgsj    := v_sysdate;
    v_vc_xgyh    := Json_Str(v_Json_Data, 'czyyhid');
    v_vc_sfcf    := Json_Str(v_Json_Data, 'vc_sfcf');
    v_vc_sczzrq  := std(Json_Str(v_Json_Data, 'vc_sczzrq'), 1);
    v_vc_scjzsj  := std(Json_Str(v_Json_Data, 'vc_scjzsj'), 1);
    v_vc_scssyy  := Json_Str(v_Json_Data, 'vc_scssyy');
    v_vc_scssrq  := std(Json_Str(v_Json_Data, 'vc_scssrq'),0);
    v_vc_scssxz  := Json_Str(v_Json_Data, 'vc_scssxz');
    v_vc_zyh     := Json_Str(v_Json_Data, 'vc_zyh');
    v_vc_blh     := Json_Str(v_Json_Data, 'vc_blh');
    v_vc_qcd     := Json_Str(v_Json_Data, 'vc_qcd');
    v_vc_qcsdm   := Json_Str(v_Json_Data, 'vc_qcsdm');
    v_vc_qcqxdm  := Json_Str(v_Json_Data, 'vc_qcqxdm');
    v_vc_qcjddm  := Json_Str(v_Json_Data, 'vc_qcjddm');
    v_vc_qcjw    := Json_Str(v_Json_Data, 'vc_qcjw');
    v_vc_sfqc    := Json_Str(v_Json_Data, 'vc_sfqc');
    v_dt_qcsj    := std(Json_Str(v_Json_Data, 'dt_qcsj'), 1);
    v_vc_qcxxdz  := Json_Str(v_Json_Data, 'vc_qcxxdz');
    v_vc_hjhs    := Json_Str(v_Json_Data, 'vc_hjhs');
    v_vc_zybw    := Json_Str(v_Json_Data, 'vc_zybw');
    v_vc_zljzs   := Json_Str(v_Json_Data, 'vc_zljzs');
    v_vc_gx      := Json_Str(v_Json_Data, 'vc_gx');
    v_vc_lb      := Json_Str(v_Json_Data, 'vc_lb');
    v_vc_cxglrq  := std(Json_Str(v_Json_Data, 'vc_cxglrq'), 1);
    v_vc_cxglyy  := Json_Str(v_Json_Data, 'vc_cxglyy');
    v_vc_jzdhs   := Json_Str(v_Json_Data, 'vc_jzdhs');
    v_vc_whsyy   := Json_Str(v_Json_Data, 'vc_whsyy');
    v_vc_ssyy1   := Json_Str(v_Json_Data, 'vc_ssyy1');
    v_vc_ssyy2   := Json_Str(v_Json_Data, 'vc_ssyy2');
    v_vc_hlyy1   := Json_Str(v_Json_Data, 'vc_hlyy1');
    v_vc_hlyy2   := Json_Str(v_Json_Data, 'vc_hlyy2');
    v_vc_flyy1   := Json_Str(v_Json_Data, 'vc_flyy1');
    v_vc_flyy2   := Json_Str(v_Json_Data, 'vc_flyy2');
    v_vc_hjwhsyy := Json_Str(v_Json_Data, 'vc_hjwhsyy');
    v_vc_swicd   := Json_Str(v_Json_Data, 'vc_swicd');
    v_vc_swicdmc := Json_Str(v_Json_Data, 'vc_swicdmc');
    v_vc_xys     := Json_Str(v_Json_Data, 'vc_xys');
    v_vc_rjxyzs  := Json_Str(v_Json_Data, 'vc_rjxyzs');
    v_vc_scxyrqn := Json_Str(v_Json_Data, 'vc_scxyrqn');
    v_vc_scxyrqy := Json_Str(v_Json_Data, 'vc_scxyrqy');
    v_vc_mcxyrqn := Json_Str(v_Json_Data, 'vc_mcxyrqn');
    v_vc_mcxyrqy := Json_Str(v_Json_Data, 'vc_mcxyrqy');
    v_vc_hjxysjn := Json_Str(v_Json_Data, 'vc_hjxysjn');
    v_vc_hjxysjy := Json_Str(v_Json_Data, 'vc_hjxysjy');
    v_nb_tz      := to_number(Json_Str(v_Json_Data, 'nb_tz'));
    v_nb_sg      := to_number(Json_Str(v_Json_Data, 'nb_sg'));
    v_vc_gxbz    := Json_Str(v_Json_Data, 'vc_gxbz');
    v_vc_jzdhsyy := Json_Str(v_Json_Data, 'vc_jzdhsyy');
  
    v_vc_sfhzl     := Json_Str(v_Json_Data, 'vc_sfhzl');
    v_vc_sfzh      := Json_Str(v_Json_Data, 'vc_sfzh');
    v_vc_sfkid     := Json_Str(v_Json_Data, 'vc_sfkid');
    v_vc_bgkid     := Json_Str(v_Json_Data, 'vc_bgkid');
    v_vc_hzid      := Json_Str(v_Json_Data, 'vc_hzid');
    v_dt_sfrq      := std(Json_Str(v_Json_Data, 'dt_sfrq'), 1);
    v_nb_zgjg      := to_number(Json_Str(v_Json_Data, 'nb_zgjg'));
    v_nb_zgjg_qcdz := to_number(Json_Str(v_Json_Data, 'nb_zgjg_qcdz'));
    v_nb_zgjg_sfyy := to_number(Json_Str(v_Json_Data, 'nb_zgjg_sfyy'));
    v_dt_swrq      := std(Json_Str(v_Json_Data, 'dt_swrq'), 1);
    v_vc_swyy      := Json_Str(v_Json_Data, 'vc_swyy');
    v_vc_swdd      := Json_Str(v_Json_Data, 'vc_swdd');
    v_vc_scq       := Json_Str(v_Json_Data, 'vc_scq');
    v_vc_zlxm      := Json_Str(v_Json_Data, 'vc_zlxm');
    v_vc_ssyy      := Json_Str(v_Json_Data, 'vc_ssyy');
    v_vc_hlyy      := Json_Str(v_Json_Data, 'vc_hlyy');
    v_vc_flyy      := Json_Str(v_Json_Data, 'vc_flyy');
    v_vc_sfzy      := Json_Str(v_Json_Data, 'vc_sfzy');
    v_dt_zysj      := std(Json_Str(v_Json_Data, 'dt_zysj'), 1);
    v_vc_czlqk     := Json_Str(v_Json_Data, 'vc_czlqk');
    v_vc_mqqk      := Json_Str(v_Json_Data, 'vc_mqqk');
  
    --检验字段必填
    --校验数据是否合法
    if v_vc_sfhzl is null then
      v_err := '本人是否患有肿瘤不能为空!';
      raise err_custom;
    end if;
    if v_vc_qcd is null then
      v_err := '确认户籍地址省不能为空!';
      raise err_custom;
    end if;
    --确认户籍地址为浙江
    if v_vc_qcd = '0' then
      if v_vc_qcsdm is null then
        v_err := '确认户籍地址市不能为空!';
        raise err_custom;
      end if;
      if v_vc_qcqxdm is null then
        v_err := '确认户籍地址区县不能为空!';
        raise err_custom;
      end if;
      if v_vc_qcjddm is null then
        v_err := '确认户籍地址街道不能为空!';
        raise err_custom;
      end if;
      if v_vc_qcxxdz is null then
        v_err := '确认详细地址不能为空!';
        raise err_custom;
      end if;
      if substr(v_vc_qcsdm, 1, 4) <> substr(v_vc_qcqxdm, 1, 4) or
         substr(v_vc_qcsdm, 1, 4) <> substr(v_vc_qcjddm, 1, 4) then
        v_err := '户口地址区划不匹配!';
        raise err_custom;
      end if;
    end if;
  
    if v_vc_hjhs is null then
      v_err := '户籍核实不能为空!';
      raise err_custom;
    end if;
    if v_vc_hjhs = '2' and v_vc_hjwhsyy is null then
      v_err := '户籍未核实原因不能为空!';
      raise err_custom;
    end if;
    if v_vc_jzdhs is null then
      v_err := '居住地核实不能为空!';
      raise err_custom;
    end if;
    if v_vc_jzdhs = '2' and v_vc_whsyy is null then
      v_err := '居住地未核实原因不能为空!';
      raise err_custom;
    end if;
  
    if v_vc_sfzy = '1' and v_vc_zybw is null then
      v_err := '转移部位不能为空!';
      raise err_custom;
    end if;
    if v_vc_sfzy = '1' and v_dt_zysj is null then
      v_err := '转移时间不能为空!';
      raise err_custom;
    end if;
    if v_vc_cxglyy is not null and v_vc_cxglrq is null then
      v_err := '撤销管理日期不能为空!';
      raise err_custom;
    end if;
    if v_vc_swyy is not null and v_dt_swrq is null then
      v_err := '死亡日期不能为空!';
      raise err_custom;
    end if;
    if v_vc_swyy is not null and v_vc_swicd is null then
      v_err := '死亡icd不能为空!';
      raise err_custom;
    end if;
    if v_vc_swyy is not null and v_vc_swicdmc is null then
      v_err := '死亡icd名称不能为空!';
      raise err_custom;
    end if;
    if v_vc_swyy is not null and v_vc_swdd is null then
      v_err := '死亡地点不能为空!';
      raise err_custom;
    end if;
    if v_dt_sfrq is null then
      v_err := '初访日期不能为空!';
      raise err_custom;
    end if;
    if v_vc_ysqm is null then
      v_err := '初访医生不能为空!';
      raise err_custom;
    end if;
  
    if v_vc_sfkid is null then
      if (v_czyhjgjb <> '4') then
        v_err := '该机构无权新增初访卡';
      end if;
    
      v_vc_sfkid := sys_guid();
      --查询相应的报卡信息
      select vc_bgkzt,
             vc_swyy,
             vc_qcbz,
             dt_swrq,
             vc_sfcf,
             vc_sfqc,
             vc_hjhs,
             nb_kspf,
             dt_cfsj,
             dt_sfrq,
             vc_qcd,
             vc_qcsdm,
             vc_qcqxdm,
             vc_qcjddm,
             vc_qcjw,
             vc_qcxxdz,
             dt_qcsj,
             dt_sczdrq,
             vc_hzid,
             vc_gldw
        into b_vc_bgkzt,
             b_vc_swyy,
             b_vc_qcbz,
             b_dt_swrq,
             b_vc_sfcf,
             b_vc_sfqc,
             b_vc_hjhs,
             b_nb_kspf,
             b_dt_cfsj,
             b_dt_sfrq,
             b_vc_qcd,
             b_vc_qcsdm,
             b_vc_qcqxdm,
             b_vc_qcjddm,
             b_vc_qcjw,
             b_vc_qcxxdz,
             b_dt_qcsj,
             b_dt_sczdrq,
             b_vc_hzid,
             b_vc_gldw
        from zjjk_zl_bgk
       where vc_bgkid = v_vc_bgkid;
      --操作相应的患者信息
      select vc_sfsw,
             vc_hksfdm,
             vc_hksdm,
             vc_hkqxdm,
             vc_hkjddm,
             vc_hkjwdm,
             vc_sfzh,
             vc_hkxxdz
        into h_vc_sfsw,
             h_vc_hksfdm,
             h_vc_hksdm,
             h_vc_hkqxdm,
             h_vc_hkjddm,
             h_vc_hkjwdm,
             h_vc_sfzh,
             h_vc_hkxxdz
        from zjjk_zl_hzxx
       where VC_PERSONID = b_vc_hzid;
    
      if (v_vc_sfhzl = '2') then
        v_vc_cxglrq := v_sysdate;
        v_vc_cxglyy := '2';
        v_vc_hjhs   := '1';
        v_vc_jzdhs  := '1';
      end if;
      v_vc_sfcf := '1';
      if (v_dt_swrq is not null) or (v_vc_swyy is not null) then
        h_vc_sfsw  := '1';
        b_vc_bgkzt := '7';
        b_vc_swyy  := v_vc_swyy;
        b_dt_swrq  := v_dt_swrq;
      ELSE
        h_vc_sfsw  := '0';
        b_vc_bgkzt := '0';
      end if;
      if (v_vc_sfqc is not null and v_vc_sfqc = '1') then
        b_vc_qcbz := '1';
      end if;
      if (b_vc_bgkzt <> 4) then
        if (v_vc_hjhs is not null and v_vc_hjhs = '2') then
          b_vc_bgkzt := '2';
        end if;
        if (v_vc_cxglrq is not null and v_vc_cxglyy = '2') then
          b_vc_bgkzt := '3';
        elsif (v_vc_cxglrq is not null and v_vc_cxglyy = '5') then
          h_vc_hksfdm := '1';
          h_vc_hksdm  := '';
          h_vc_hkqxdm := '';
          h_vc_hkjddm := '';
        elsif (v_vc_cxglrq is not null and v_vc_cxglyy = '4') then
          b_vc_bgkzt := '7';
          b_dt_swrq  := v_dt_swrq;
        elsif (v_vc_cxglrq is not null and v_vc_cxglyy = '1') then
          b_vc_bgkzt := '2';
        end if;
      end if;
      b_vc_sfcf := '1';
      b_vc_sfqc := v_vc_sfqc;
      b_vc_hjhs := v_vc_hjhs;
      b_nb_kspf := v_nb_kspf;
      b_dt_cfsj := v_dt_sfrq;
      b_dt_sfrq := v_dt_sfrq;
      -- b_vc_qcd  := v_vc_qcd;
      -- b_vc_qcsdm := v_vc_qcsdm;
      -- b_vc_qcqxdm := v_vc_qcqxdm;
      -- b_vc_qcjddm := v_vc_qcjddm;
      -- b_vc_qcjw := v_vc_qcjw;
      -- b_vc_qcxxdz := v_vc_qcxxdz;
      b_dt_qcsj   := v_dt_qcsj;
      b_dt_sczdrq := v_vc_scjzsj;
      if (v_vc_qcd is not null and (h_vc_hksfdm <> v_vc_qcd 
        or h_vc_hksdm<> v_vc_qcsdm or h_vc_hkqxdm <> v_vc_qcqxdm
        or h_vc_hkjddm <> v_vc_qcjddm)) then
        h_vc_sfzh   := v_vc_sfzh;
        h_vc_hksfdm := v_vc_qcd;
        h_vc_hksdm  := v_vc_qcsdm;
        h_vc_hkqxdm := v_vc_qcqxdm;
        h_vc_hkjddm := v_vc_qcjddm;
        h_vc_hkjwdm := v_vc_qcjw;
        h_vc_hkxxdz := v_vc_qcxxdz;
        --属地确认
        select count(1), wm_concat(a.dm)
          into v_count, b_vc_gldw
          from p_yljg a
         where a.bz = 1
           and a.lb = 'B1'
           and a.xzqh = h_vc_hkjddm;
        if v_count = 1 then
          --确定属地
          v_vc_sdqrzt := '1';
        else
          b_vc_gldw   := h_vc_hkqxdm;
          v_vc_sdqrzt := '0';
        end if;
      end if;
      if h_vc_hksfdm = '1' then
        b_vc_gldw   := '99999999';
        v_vc_sdqrzt := '1';
      end if;
      --更新报告卡信息
      UPDATE zjjk_zl_bgk
         SET vc_bgkzt  = b_vc_bgkzt,
             vc_swyy   = b_vc_swyy,
             vc_qcbz   = b_vc_qcbz,
             dt_swrq   = b_dt_swrq,
             vc_sfcf   = b_vc_sfcf,
             vc_sfqc   = b_vc_sfqc,
             vc_hjhs   = b_vc_hjhs,
             nb_kspf   = b_nb_kspf,
             dt_cfsj   = b_dt_cfsj,
             dt_sfrq   = b_dt_sfrq,
             vc_qcd    = b_vc_qcd,
             vc_qcsdm  = b_vc_qcsdm,
             vc_qcqxdm = b_vc_qcqxdm,
             vc_qcjddm = b_vc_qcjddm,
             vc_qcjw   = b_vc_qcjw,
             vc_qcxxdz = b_vc_qcxxdz,
             dt_qcsj   = b_dt_qcsj,
             dt_sczdrq = b_dt_sczdrq,
             vc_gldw   = b_vc_gldw,
             vc_sdqrzt = v_vc_sdqrzt,
             dt_xgsj   = sysdate
       where vc_bgkid = v_vc_bgkid;
      --更新患者信息
      update zjjk_zl_hzxx
         set vc_sfsw   = h_vc_sfsw,
             vc_hksfdm = h_vc_hksfdm,
             vc_hksdm  = h_vc_hksdm,
             vc_hkqxdm = h_vc_hkqxdm,
             vc_hkjddm = h_vc_hkjddm,
             vc_hkjwdm = h_vc_hkjwdm,
             vc_sfzh   = h_vc_sfzh,
             vc_hkxxdz = h_vc_hkxxdz
       where VC_PERSONID = b_vc_hzid;
      --更新副卡vc_bgkzt,dt_swrq，vc_swyy
      update zjjk_zl_bgk a
         set a.vc_bgkzt = b_vc_bgkzt,
             a.dt_swrq  = b_dt_swrq,
             a.vc_swyy  = b_vc_swyy,
             a.dt_xgsj  = sysdate
       where exists (select 1
                from zjjk_zl_bgk_zfgx b
               where a.vc_bgkid = b.vc_fkid
                 and b.vc_zkid <> b.vc_fkid
                 and b.vc_zkid = v_vc_bgkid);
      --插入初访卡信息
      insert into zjjk_zl_ccsfk
        (nb_kspf,
         vc_mqqk,
         vc_czlqk,
         dt_zysj,
         vc_sfzy,
         vc_flyy,
         vc_hlyy,
         vc_ssyy,
         vc_zlxm,
         vc_scq,
         vc_swdd,
         vc_swyy,
         dt_swrq,
         nb_zgjg_sfyy,
         nb_zgjg_qcdz,
         nb_zgjg,
         dt_sfrq,
         vc_hzid,
         vc_bgkid,
         vc_sfkid,
         vc_sfzh,
         vc_sfhzl,
         vc_jzdhsyy,
         vc_gxbz,
         nb_sg,
         nb_tz,
         vc_hjxysjy,
         vc_hjxysjn,
         vc_mcxyrqy,
         vc_mcxyrqn,
         vc_scxyrqy,
         vc_scxyrqn,
         vc_rjxyzs,
         vc_xys,
         vc_swicdmc,
         vc_swicd,
         vc_hjwhsyy,
         vc_flyy2,
         vc_flyy1,
         vc_hlyy2,
         vc_hlyy1,
         vc_ssyy2,
         vc_ssyy1,
         vc_whsyy,
         vc_jzdhs,
         vc_cxglyy,
         vc_cxglrq,
         vc_lb,
         vc_gx,
         vc_zljzs,
         vc_zybw,
         vc_hjhs,
         vc_qcxxdz,
         dt_qcsj,
         vc_sfqc,
         vc_qcjw,
         vc_qcjddm,
         vc_qcqxdm,
         vc_qcsdm,
         vc_qcd,
         vc_blh,
         vc_zyh,
         vc_scssxz,
         vc_scssrq,
         vc_scssyy,
         vc_scjzsj,
         vc_sczzrq,
         vc_sfcf,
         vc_xgyh,
         dt_xgsj,
         dt_cjsj,
         vc_cjyh,
         vc_scbz,
         vc_hzqm,
         vc_ysqm)
      values
        (v_nb_kspf,
         v_vc_mqqk,
         v_vc_czlqk,
         v_dt_zysj,
         v_vc_sfzy,
         v_vc_flyy,
         v_vc_hlyy,
         v_vc_ssyy,
         v_vc_zlxm,
         v_vc_scq,
         v_vc_swdd,
         v_vc_swyy,
         v_dt_swrq,
         v_nb_zgjg_sfyy,
         v_nb_zgjg_qcdz,
         v_nb_zgjg,
         v_dt_sfrq,
         v_vc_hzid,
         v_vc_bgkid,
         v_vc_sfkid,
         v_vc_sfzh,
         v_vc_sfhzl,
         v_vc_jzdhsyy,
         v_vc_gxbz,
         v_nb_sg,
         v_nb_tz,
         v_vc_hjxysjy,
         v_vc_hjxysjn,
         v_vc_mcxyrqy,
         v_vc_mcxyrqn,
         v_vc_scxyrqy,
         v_vc_scxyrqn,
         v_vc_rjxyzs,
         v_vc_xys,
         v_vc_swicdmc,
         v_vc_swicd,
         v_vc_hjwhsyy,
         v_vc_flyy2,
         v_vc_flyy1,
         v_vc_hlyy2,
         v_vc_hlyy1,
         v_vc_ssyy2,
         v_vc_ssyy1,
         v_vc_whsyy,
         v_vc_jzdhs,
         v_vc_cxglyy,
         v_vc_cxglrq,
         v_vc_lb,
         v_vc_gx,
         v_vc_zljzs,
         v_vc_zybw,
         v_vc_hjhs,
         v_vc_qcxxdz,
         v_dt_qcsj,
         v_vc_sfqc,
         v_vc_qcjw,
         v_vc_qcjddm,
         v_vc_qcqxdm,
         v_vc_qcsdm,
         v_vc_qcd,
         v_vc_blh,
         v_vc_zyh,
         v_vc_scssxz,
         v_vc_scssrq,
         v_vc_scssyy,
         v_vc_scjzsj,
         v_vc_sczzrq,
         v_vc_sfcf,
         v_vc_xgyh,
         v_dt_xgsj,
         v_dt_cjsj,
         v_vc_cjyh,
         v_vc_scbz,
         v_vc_hzqm,
         v_vc_ysqm);
    END IF;
    --记录日志
    v_json_yw_log := Json_ext.get_json(v_json_data, 'ywjllog');
    if v_json_yw_log is not null then
      v_json_yw_log.put('bgkid', v_vc_bgkid);
      v_json_yw_log.put('bgklx', '02');
      v_json_yw_log.put('ywjlid', v_vc_sfkid);
      v_json_yw_log.put('gnmk', '04');
      v_json_yw_log.put('gnmc', '报卡管理');
      v_json_yw_log.put('czlx', '01');
      pkg_zjmb_xtfz.prc_zjjk_yw_log_update(v_json_yw_log, v_err);
      if v_err is not null then
        raise err_custom;
      end if;
    end if;
    --更新初随访状态
    pkg_zjmb_zl.prc_bgkcsfzt_update(v_vc_bgkid, v_err);
    v_json_return.put('vc_sfkid', v_vc_sfkid);
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    --when SQL%notfound then
    --v_err := '未找到相应的患者信息或肿瘤报卡信息';
    --result_out := return_fail(v_err, 0);
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      if (SQL%NOTFOUND) then
        v_err      := '未找到相应的患者信息或肿瘤报卡信息';
        result_out := return_fail(v_err, 0);
      ELSE
        v_err      := SQLERRM;
        result_out := return_fail(v_err, 0);
      end if;
  END prc_zlcfk_update;
  /*--------------------------------------------------------------------------
  || 功能描述 ：肿瘤随访更新
  ||------------------------------------------------------------------------*/
  procedure prc_zlsfk_update(Data_In    In Clob, --入参
                             result_out OUT VARCHAR2) --返回
   is
    v_nb_zgjg_qcdz zjjk_zl_sfk.nb_zgjg_qcdz%TYPE; --转归结果_迁出地址代码
    v_nb_zgjg_sfyy zjjk_zl_sfk.nb_zgjg_sfyy%TYPE; --初访结果_失访原因
    v_dt_swrq      zjjk_zl_sfk.dt_swrq%TYPE; --死亡日期
    v_vc_swyy      zjjk_zl_sfk.vc_swyy%TYPE; --死亡原因
    v_vc_swdd      zjjk_zl_sfk.vc_swdd%TYPE; --死亡地点
    v_vc_scq       zjjk_zl_sfk.vc_scq%TYPE; --生存期
    v_vc_zlxm      zjjk_zl_sfk.vc_zlxm%TYPE; --治疗项目
    v_vc_ssyy      zjjk_zl_sfk.vc_ssyy%TYPE; --手术医院
    v_vc_hlyy      zjjk_zl_sfk.vc_hlyy%TYPE; --化疗医院
    v_vc_flyy      zjjk_zl_sfk.vc_flyy%TYPE; --放疗医院
    v_vc_sfzy      zjjk_zl_sfk.vc_sfzy%TYPE; --是否转移
    v_dt_zysj      zjjk_zl_sfk.dt_zysj%TYPE; --转移时间
    v_vc_czlqk     zjjk_zl_sfk.vc_czlqk%TYPE; --曾治疗情况
    v_vc_mqqk      zjjk_zl_sfk.vc_mqqk%TYPE; --目前情况
    v_nb_kspf      zjjk_zl_sfk.nb_kspf%TYPE; --卡氏评分
    v_vc_ysqm      zjjk_zl_sfk.vc_ysqm%TYPE; --随访医师
    v_vc_hzqm      zjjk_zl_sfk.vc_hzqm%TYPE; --患者签名
    v_vc_scbz      zjjk_zl_sfk.vc_scbz%TYPE; --删除标志
    v_vc_cjyh      zjjk_zl_sfk.vc_cjyh%TYPE; --创建用户
    v_dt_cjsj      zjjk_zl_sfk.dt_cjsj%TYPE; --创建时间
    v_dt_xgsj      zjjk_zl_sfk.dt_xgsj%TYPE; --修改时间
    v_vc_xgyh      zjjk_zl_sfk.vc_xgyh%TYPE; --修改用户
    v_dt_sczdrq    zjjk_zl_sfk.dt_sczdrq%TYPE; --
    v_dt_cxglrq    zjjk_zl_sfk.dt_cxglrq%TYPE; --撤消管理日期
    v_vc_cxglyy    zjjk_zl_sfk.vc_cxglyy%TYPE; --撤消管理原因
    v_vc_sfcx      zjjk_zl_sfk.vc_sfcx%TYPE; --是否撤消
    v_vc_cxglqtyy  zjjk_zl_sfk.vc_cxglqtyy%TYPE; --撤消管理其它原因
    v_vc_qcd       zjjk_zl_sfk.vc_qcd%TYPE; --迁出省
    v_vc_qcsdm     zjjk_zl_sfk.vc_qcsdm%TYPE; --迁出市
    v_vc_qcqxdm    zjjk_zl_sfk.vc_qcqxdm%TYPE; --迁出区
    v_vc_qcjddm    zjjk_zl_sfk.vc_qcjddm%TYPE; --迁出街道
    v_vc_qcjw      zjjk_zl_sfk.vc_qcjw%TYPE; --迁出居委
    v_vc_sfqc      zjjk_zl_sfk.vc_sfqc%TYPE; --户口是否迁出
    v_dt_qcsj      zjjk_zl_sfk.dt_qcsj%TYPE; --迁出时间
    v_vc_qcxxdz    zjjk_zl_sfk.vc_qcxxdz%TYPE; --迁出详细地址
    v_vc_zybw      zjjk_zl_sfk.vc_zybw%TYPE; --转移部位
    v_vc_ssyy1     zjjk_zl_sfk.vc_ssyy1%TYPE; --手术医院2
    v_vc_ssyy2     zjjk_zl_sfk.vc_ssyy2%TYPE; --手术医院3
    v_vc_hlyy1     zjjk_zl_sfk.vc_hlyy1%TYPE; --化疗医院2
    v_vc_hlyy2     zjjk_zl_sfk.vc_hlyy2%TYPE; --化疗医院3
    v_vc_flyy1     zjjk_zl_sfk.vc_flyy1%TYPE; --放疗医院2
    v_vc_flyy2     zjjk_zl_sfk.vc_flyy2%TYPE; --放疗医院3
    v_vc_sfff      zjjk_zl_sfk.vc_sfff%TYPE; --是否复发
    v_vc_ffcs      zjjk_zl_sfk.vc_ffcs%TYPE; --复发次数
    v_vc_ffsj      zjjk_zl_sfk.vc_ffsj%TYPE; --复发时间1
    v_vc_ffsj1     zjjk_zl_sfk.vc_ffsj1%TYPE; --复发时间2
    v_vc_ffsj2     zjjk_zl_sfk.vc_ffsj2%TYPE; --复发时间3
    v_vc_swicd     zjjk_zl_sfk.vc_swicd%TYPE; --死亡ICD
    v_vc_swicdmc   zjjk_zl_sfk.vc_swicdmc%TYPE; --死亡ICD名称
    v_nb_tz        zjjk_zl_sfk.nb_tz%TYPE; --体重
    v_nb_sg        zjjk_zl_sfk.nb_sg%TYPE; --身高
    v_vc_bz        zjjk_zl_sfk.vc_bz%TYPE; --备注
    v_vc_sfxy      zjjk_zl_sfk.vc_sfxy%TYPE; --是否吸烟
    v_vc_gxbz      zjjk_zl_sfk.vc_gxbz%TYPE; --更新标志
    v_vc_sfkid     zjjk_zl_sfk.vc_sfkid%TYPE; --随访卡ID
    v_vc_bgkid     zjjk_zl_sfk.vc_bgkid%TYPE; --报告卡ID
    v_vc_hzid      zjjk_zl_sfk.vc_hzid%TYPE; --患者ID
    v_dt_sfrq      zjjk_zl_sfk.dt_sfrq%TYPE; --随访日期
    v_nb_zgjg      zjjk_zl_sfk.nb_zgjg%TYPE; --转归结果
  
    --公共变量
    v_czyhjgjb    varchar2(20);
    v_json_data   json;
    v_json_yw_log json;
    v_ywjl_czlx   varchar2(3);
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err     VARCHAR2(2000);
    v_sysdate date;
    --定义患者信息字段
    h_vc_sfsw   zjjk_zl_hzxx.vc_sfsw%type;
    h_vc_hksfdm zjjk_zl_hzxx.vc_hksfdm%type;
    h_vc_hksdm  zjjk_zl_hzxx.vc_hksdm%type;
    h_vc_hkqxdm zjjk_zl_hzxx.vc_hkqxdm%type;
    h_vc_hkjddm zjjk_zl_hzxx.vc_hkjddm%type;
    h_vc_hkjwdm zjjk_zl_hzxx.vc_hkjwdm%type;
    h_vc_sfzh   zjjk_zl_hzxx.vc_sfzh%type;
    h_vc_hkxxdz zjjk_zl_hzxx.vc_hkxxdz%type;
    --定义肿瘤报卡信息字段
    b_vc_bgkzt  zjjk_zl_bgk.vc_bgkzt%type;
    b_vc_swyy   zjjk_zl_bgk.vc_swyy%type;
    b_dt_swrq   zjjk_zl_bgk.dt_swrq%type;
    b_vc_qcbz   zjjk_zl_bgk.vc_qcbz%type;
    b_vc_sfcf   zjjk_zl_bgk.vc_sfcf%type;
    b_vc_sfqc   zjjk_zl_bgk.vc_sfqc%type;
    b_nb_kspf   zjjk_zl_bgk.nb_kspf%type;
    b_dt_sfrq   zjjk_zl_bgk.dt_sfrq%type;
    b_dt_sfsj   zjjk_zl_bgk.dt_sfsj%type;
    b_vc_qcd    zjjk_zl_bgk.vc_qcd%type;
    b_vc_qcsdm  zjjk_zl_bgk.vc_qcsdm%type;
    b_vc_qcqxdm zjjk_zl_bgk.vc_qcqxdm%type;
    b_vc_qcjddm zjjk_zl_bgk.vc_qcjddm%type;
    b_vc_qcjw   zjjk_zl_bgk.vc_qcjw%type;
    b_vc_qcxxdz zjjk_zl_bgk.vc_qcxxdz%type;
    b_dt_qcsj   zjjk_zl_bgk.dt_qcsj%type;
    b_vc_hzid   zjjk_zl_bgk.vc_hzid%type;
  
  BEGIN
    json_data(Data_In, 'ZJJK_ZL_SFK新增或修改', v_json_data);
    v_sysdate := sysdate;
    --初随访卡赋值
    v_czyhjgjb     := json_str(v_json_data, 'czyjgjb');
    v_nb_zgjg_qcdz := Json_Str(v_Json_Data, 'nb_zgjg_qcdz');
    v_nb_zgjg_sfyy := Json_Str(v_Json_Data, 'nb_zgjg_sfyy');
    v_dt_swrq      := std(Json_Str(v_Json_Data, 'dt_swrq'), 0);
    v_vc_swyy      := Json_Str(v_Json_Data, 'vc_swyy');
    v_vc_swdd      := Json_Str(v_Json_Data, 'vc_swdd');
    v_vc_scq       := Json_Str(v_Json_Data, 'vc_scq');
    v_vc_zlxm      := Json_Str(v_Json_Data, 'vc_zlxm');
    v_vc_ssyy      := Json_Str(v_Json_Data, 'vc_ssyy');
    v_vc_hlyy      := Json_Str(v_Json_Data, 'vc_hlyy');
    v_vc_flyy      := Json_Str(v_Json_Data, 'vc_flyy');
    v_vc_sfzy      := Json_Str(v_Json_Data, 'vc_sfzy');
    v_dt_zysj      := std(Json_Str(v_Json_Data, 'dt_zysj'), 0);
    v_vc_czlqk     := Json_Str(v_Json_Data, 'vc_czlqk');
    v_vc_mqqk      := Json_Str(v_Json_Data, 'vc_mqqk');
    v_nb_kspf      := to_number(Json_Str(v_Json_Data, 'nb_kspf'));
    v_vc_ysqm      := Json_Str(v_Json_Data, 'vc_ysqm');
    v_vc_hzqm      := Json_Str(v_Json_Data, 'vc_hzqm');
    v_vc_scbz      := Json_Str(v_Json_Data, 'vc_scbz');
    v_vc_cjyh      := Json_Str(v_Json_Data, 'vc_cjyh');
    v_dt_cjsj      := v_sysdate;
    v_dt_xgsj      := v_sysdate;
    v_vc_xgyh      := Json_Str(v_Json_Data, 'vc_xgyh');
    v_dt_sczdrq    := std(Json_Str(v_Json_Data, 'dt_sczdrq'), 0);
    v_dt_cxglrq    := std(Json_Str(v_Json_Data, 'dt_cxglrq'), 0);
    v_vc_cxglyy    := Json_Str(v_Json_Data, 'vc_cxglyy');
    v_vc_sfcx      := Json_Str(v_Json_Data, 'vc_sfcx');
    v_vc_cxglqtyy  := Json_Str(v_Json_Data, 'vc_cxglqtyy');
    v_vc_qcd       := Json_Str(v_Json_Data, 'vc_qcd');
    v_vc_qcsdm     := Json_Str(v_Json_Data, 'vc_qcsdm');
    v_vc_qcqxdm    := Json_Str(v_Json_Data, 'vc_qcqxdm');
    v_vc_qcjddm    := Json_Str(v_Json_Data, 'vc_qcjddm');
    v_vc_qcjw      := Json_Str(v_Json_Data, 'vc_qcjw');
    v_vc_sfqc      := Json_Str(v_Json_Data, 'vc_sfqc');
    v_dt_qcsj      := std(Json_Str(v_Json_Data, 'dt_qcsj'), 0);
    v_vc_qcxxdz    := Json_Str(v_Json_Data, 'vc_qcxxdz');
    v_vc_zybw      := Json_Str(v_Json_Data, 'vc_zybw');
    v_vc_ssyy1     := Json_Str(v_Json_Data, 'vc_ssyy1');
    v_vc_ssyy2     := Json_Str(v_Json_Data, 'vc_ssyy2');
    v_vc_hlyy1     := Json_Str(v_Json_Data, 'vc_hlyy1');
    v_vc_hlyy2     := Json_Str(v_Json_Data, 'vc_hlyy2');
    v_vc_flyy1     := Json_Str(v_Json_Data, 'vc_flyy1');
    v_vc_flyy2     := Json_Str(v_Json_Data, 'vc_flyy2');
    v_vc_sfff      := Json_Str(v_Json_Data, 'vc_sfff');
    v_vc_ffcs      := Json_Str(v_Json_Data, 'vc_ffcs');
    v_vc_ffsj      := std(Json_Str(v_Json_Data, 'vc_ffsj'), 0);
    v_vc_ffsj1     := std(Json_Str(v_Json_Data, 'vc_ffsj1'), 0);
    v_vc_ffsj2     := std(Json_Str(v_Json_Data, 'vc_ffsj2'), 0);
    v_vc_swicd     := Json_Str(v_Json_Data, 'vc_swicd');
    v_vc_swicdmc   := Json_Str(v_Json_Data, 'vc_swicdmc');
    v_nb_tz        := to_number(Json_Str(v_Json_Data, 'nb_tz'));
    v_nb_sg        := to_number(Json_Str(v_Json_Data, 'nb_sg'));
    v_vc_bz        := Json_Str(v_Json_Data, 'vc_bz');
    v_vc_sfxy      := Json_Str(v_Json_Data, 'vc_sfxy');
    v_vc_gxbz      := Json_Str(v_Json_Data, 'vc_gxbz');
    v_vc_sfkid     := Json_Str(v_Json_Data, 'vc_sfkid');
    v_vc_bgkid     := Json_Str(v_Json_Data, 'vc_bgkid');
    v_vc_hzid      := Json_Str(v_Json_Data, 'vc_hzid');
    v_dt_sfrq      := std(Json_Str(v_Json_Data, 'dt_sfrq'), 0);
    v_nb_zgjg      := Json_Str(v_Json_Data, 'nb_zgjg');
  
    --检验字段必填
    --校验数据是否合法
    if v_dt_sfrq is null then
      v_err := '随访日期不能为空!';
      raise err_custom;
    end if;
    if v_vc_ysqm is null then
      v_err := '随访医师不能为空!';
      raise err_custom;
    end if;
    if v_vc_sfqc is null then
      v_err := '户口是否迁出不能为空!';
      raise err_custom;
    end if;
    if v_vc_sfqc = '1' and v_vc_qcd is null then
      v_err := '迁出省不能为空!';
      raise err_custom;
    end if;
    --迁出地，浙江省
    if v_vc_qcd = '0' then
      if v_vc_qcsdm is null then
        v_err := '迁出市不能为空!';
        raise err_custom;
      end if;
      if v_vc_qcqxdm is null then
        v_err := '迁出区县不能为空!';
        raise err_custom;
      end if;
      if v_vc_qcjddm is null then
        v_err := '迁出街道不能为空!';
        raise err_custom;
      end if;
      if v_vc_qcxxdz is null then
        v_err := '迁出详细地址不能为空!';
        raise err_custom;
      end if;
      if v_dt_qcsj is null then
        v_err := '迁出时间不能为空!';
        raise err_custom;
      end if;
      if substr(v_vc_qcsdm, 1, 4) <> substr(v_vc_qcqxdm, 1, 4) or
         substr(v_vc_qcsdm, 1, 4) <> substr(v_vc_qcjddm, 1, 4) then
        v_err := '迁出地址区划不匹配!';
        raise err_custom;
      end if;
    end if;
  
    if v_vc_sfff = '1' and v_vc_ffcs is null then
      v_err := '复发次数不能为空!';
      raise err_custom;
    end if;
    if v_vc_sfff = '1' and v_vc_ffsj is null then
      v_err := '复发时间不能为空!';
      raise err_custom;
    end if;
    if v_vc_sfcx = '1' and v_vc_cxglyy is null then
      v_err := '撤消管理原因不能为空!';
      raise err_custom;
    end if;
    if v_vc_sfcx = '1' and v_dt_cxglrq is null then
      v_err := '撤消管理日期不能为空!';
      raise err_custom;
    end if;
    if v_vc_swyy is not null and v_dt_swrq is null then
      v_err := '死亡日期不能为空!';
      raise err_custom;
    end if;
    if v_vc_swyy is not null and v_vc_swicd is null then
      v_err := '死亡icd不能为空!';
      raise err_custom;
    end if;
    if v_vc_swyy is not null and v_vc_swicdmc is null then
      v_err := '死亡icd名称不能为空!';
      raise err_custom;
    end if;
    if v_vc_swyy is not null and v_vc_swdd is null then
      v_err := '死亡地点不能为空!';
      raise err_custom;
    end if;
  
    --查询相应的报卡信息
    select vc_bgkzt,
           vc_swyy,
           vc_qcbz,
           dt_swrq,
           vc_sfcf,
           vc_sfqc,
           nb_kspf,
           dt_sfsj,
           dt_sfrq,
           vc_qcd,
           vc_qcsdm,
           vc_qcqxdm,
           vc_qcjddm,
           vc_qcjw,
           vc_qcxxdz,
           dt_qcsj,
           vc_hzid
      into b_vc_bgkzt,
           b_vc_swyy,
           b_vc_qcbz,
           b_dt_swrq,
           b_vc_sfcf,
           b_vc_sfqc,
           b_nb_kspf,
           b_dt_sfsj,
           b_dt_sfrq,
           b_vc_qcd,
           b_vc_qcsdm,
           b_vc_qcqxdm,
           b_vc_qcjddm,
           b_vc_qcjw,
           b_vc_qcxxdz,
           b_dt_qcsj,
           b_vc_hzid
      from zjjk_zl_bgk
     where vc_bgkid = v_vc_bgkid;
    --操作相应的患者信息
    --操作相应的患者信息
    select vc_sfsw,
           vc_hksfdm,
           vc_hksdm,
           vc_hkqxdm,
           vc_hkjddm,
           vc_hkjwdm,
           vc_sfzh,
           vc_hkxxdz
      into h_vc_sfsw,
           h_vc_hksfdm,
           h_vc_hksdm,
           h_vc_hkqxdm,
           h_vc_hkjddm,
           h_vc_hkjwdm,
           h_vc_sfzh,
           h_vc_hkxxdz
      from zjjk_zl_hzxx
     where VC_PERSONID = b_vc_hzid;
  
    if v_vc_sfkid is null then
      v_ywjl_czlx := '01';
      if (v_czyhjgjb <> '4') then
        v_err := '该机构无权新增初访卡';
      end if;
      v_vc_sfkid := sys_guid();
    
      if (v_dt_swrq is not null) or (v_vc_swyy is not null) then
        h_vc_sfsw  := '1';
        b_vc_bgkzt := '7';
        b_vc_swyy  := v_vc_swyy;
        b_dt_swrq  := v_dt_swrq;
      ELSE
        h_vc_sfsw  := '0';
        b_vc_bgkzt := '0';
      end if;
      if (v_vc_sfqc is not null and v_vc_sfqc = '1') then
        b_vc_qcbz := '1';
      end if;
      if (b_vc_bgkzt <> 4) then
        if (v_dt_cxglrq is not null and v_vc_cxglyy = '2') then
          b_vc_bgkzt := '3';
        end if;
        if (v_dt_cxglrq is not null and v_vc_cxglyy = '2') then
          b_vc_bgkzt := '3';
        elsif (v_dt_cxglrq is not null and v_vc_cxglyy = '4') then
          b_vc_bgkzt := '7';
          b_dt_swrq  := v_dt_swrq;
        elsif (v_dt_cxglrq is not null and v_vc_cxglyy = '1') then
          b_vc_bgkzt := '6';
        end if;
      end if;
      if (h_vc_hkjddm = v_vc_qcjddm and v_vc_sfqc = '1') then
        v_err := '迁出地址不可为原地址！';
        raise err_custom;
      end if;
      b_vc_sfcf := '3';
      b_vc_sfqc := v_vc_sfqc;
      b_nb_kspf := v_nb_kspf;
      b_dt_sfrq := v_dt_sfrq;
      b_dt_sfsj := v_dt_sfrq;
      --操作迁出地 
    
      b_vc_qcd    := v_vc_qcd;
      b_vc_qcsdm  := v_vc_qcsdm;
      b_vc_qcqxdm := v_vc_qcqxdm;
      b_vc_qcjddm := v_vc_qcjddm;
      b_vc_qcjw   := v_vc_qcjw;
      b_vc_qcxxdz := v_vc_qcxxdz;
      b_dt_qcsj   := v_dt_qcsj;
      --更新报告卡信息
      UPDATE zjjk_zl_bgk
         SET vc_bgkzt  = b_vc_bgkzt,
             vc_swyy   = b_vc_swyy,
             vc_qcbz   = b_vc_qcbz,
             dt_swrq   = b_dt_swrq,
             vc_sfcf   = b_vc_sfcf,
             vc_sfqc   = b_vc_sfqc,
             nb_kspf   = b_nb_kspf,
             dt_sfsj   = b_dt_sfsj,
             dt_sfrq   = b_dt_sfrq,
             vc_qcd    = b_vc_qcd,
             vc_qcsdm  = b_vc_qcsdm,
             vc_qcqxdm = b_vc_qcqxdm,
             vc_qcjddm = b_vc_qcjddm,
             vc_qcjw   = b_vc_qcjw,
             vc_qcxxdz = b_vc_qcxxdz,
             dt_qcsj   = b_dt_qcsj,
             dt_xgsj   = sysdate
       where vc_bgkid = v_vc_bgkid;
      --更新副卡vc_bgkzt,dt_swrq，vc_swyy
      update zjjk_zl_bgk a
         set a.vc_bgkzt = b_vc_bgkzt,
             a.dt_swrq  = b_dt_swrq,
             a.vc_swyy  = b_vc_swyy,
             a.dt_xgsj  = sysdate
       where exists (select 1
                from zjjk_zl_bgk_zfgx b
               where a.vc_bgkid = b.vc_fkid
                 and b.vc_zkid <> b.vc_fkid
                 and b.vc_zkid = v_vc_bgkid);
      --更新患者信息
      update zjjk_zl_hzxx
         set vc_sfsw = h_vc_sfsw
       where VC_PERSONID = b_vc_hzid;
      --插入随访卡信息
      insert into zjjk_zl_sfk
        (nb_zgjg_qcdz,
         nb_zgjg,
         dt_sfrq,
         vc_hzid,
         vc_bgkid,
         vc_sfkid,
         vc_gxbz,
         vc_sfxy,
         vc_bz,
         nb_sg,
         nb_tz,
         vc_swicdmc,
         vc_swicd,
         vc_ffsj2,
         vc_ffsj1,
         vc_ffsj,
         vc_ffcs,
         vc_sfff,
         vc_flyy2,
         vc_flyy1,
         vc_hlyy2,
         vc_hlyy1,
         vc_ssyy2,
         vc_ssyy1,
         vc_zybw,
         vc_qcxxdz,
         dt_qcsj,
         vc_sfqc,
         vc_qcjw,
         vc_qcjddm,
         vc_qcqxdm,
         vc_qcsdm,
         vc_qcd,
         vc_cxglqtyy,
         vc_sfcx,
         vc_cxglyy,
         dt_cxglrq,
         dt_sczdrq,
         vc_xgyh,
         dt_xgsj,
         dt_cjsj,
         vc_cjyh,
         vc_scbz,
         vc_hzqm,
         vc_ysqm,
         nb_kspf,
         vc_mqqk,
         vc_czlqk,
         dt_zysj,
         vc_sfzy,
         vc_flyy,
         vc_hlyy,
         vc_ssyy,
         vc_zlxm,
         vc_scq,
         vc_swdd,
         vc_swyy,
         dt_swrq,
         nb_zgjg_sfyy)
      values
        (v_nb_zgjg_qcdz,
         v_nb_zgjg,
         v_dt_sfrq,
         v_vc_hzid,
         v_vc_bgkid,
         v_vc_sfkid,
         v_vc_gxbz,
         v_vc_sfxy,
         v_vc_bz,
         v_nb_sg,
         v_nb_tz,
         v_vc_swicdmc,
         v_vc_swicd,
         v_vc_ffsj2,
         v_vc_ffsj1,
         v_vc_ffsj,
         v_vc_ffcs,
         v_vc_sfff,
         v_vc_flyy2,
         v_vc_flyy1,
         v_vc_hlyy2,
         v_vc_hlyy1,
         v_vc_ssyy2,
         v_vc_ssyy1,
         v_vc_zybw,
         v_vc_qcxxdz,
         v_dt_qcsj,
         v_vc_sfqc,
         v_vc_qcjw,
         v_vc_qcjddm,
         v_vc_qcqxdm,
         v_vc_qcsdm,
         v_vc_qcd,
         v_vc_cxglqtyy,
         v_vc_sfcx,
         v_vc_cxglyy,
         v_dt_cxglrq,
         v_dt_sczdrq,
         v_vc_xgyh,
         v_dt_xgsj,
         v_dt_cjsj,
         v_vc_cjyh,
         v_vc_scbz,
         v_vc_hzqm,
         v_vc_ysqm,
         v_nb_kspf,
         v_vc_mqqk,
         v_vc_czlqk,
         v_dt_zysj,
         v_vc_sfzy,
         v_vc_flyy,
         v_vc_hlyy,
         v_vc_ssyy,
         v_vc_zlxm,
         v_vc_scq,
         v_vc_swdd,
         v_vc_swyy,
         v_dt_swrq,
         v_nb_zgjg_sfyy);
    ELSE
      v_ywjl_czlx := '02';
      if (v_dt_swrq is not null) or (v_vc_swyy is not null) then
        h_vc_sfsw  := '1';
        b_vc_bgkzt := '7';
      ELSE
        h_vc_sfsw  := '0';
        b_vc_bgkzt := '0';
      end if;
      if (v_vc_sfqc = '1') then
        b_vc_qcbz := '1';
      end if;
      if (b_vc_bgkzt = '0') then
        if (v_dt_cxglrq is not null and v_dt_cxglrq = '2') then
          b_vc_bgkzt := '3';
        elsif (v_dt_cxglrq is not null and v_dt_cxglrq = '4') then
          b_vc_bgkzt := '7';
        elsif (v_dt_cxglrq is not null and v_dt_cxglrq = '1') then
          b_vc_bgkzt := '6';
        end if;
      end if;
      if (h_vc_hkjddm = v_vc_qcjddm and v_vc_sfqc = '1') then
        v_err := '迁出地址不可为原地址！';
        raise err_custom;
      end if;
      b_dt_sfrq   := v_dt_sfrq;
      b_dt_sfsj   := v_dt_sfrq;
      b_vc_qcd    := v_vc_qcd;
      b_vc_qcsdm  := v_vc_qcsdm;
      b_vc_qcqxdm := v_vc_qcqxdm;
      b_vc_qcjddm := v_vc_qcjddm;
      b_vc_qcjw   := v_vc_qcjw;
      b_vc_qcxxdz := v_vc_qcxxdz;
      b_dt_qcsj   := v_dt_qcsj;
      --更新报告卡信息
      UPDATE zjjk_zl_bgk
         SET vc_bgkzt  = b_vc_bgkzt,
             vc_swyy   = b_vc_swyy,
             vc_qcbz   = b_vc_qcbz,
             dt_swrq   = b_dt_swrq,
             vc_sfcf   = b_vc_sfcf,
             vc_sfqc   = b_vc_sfqc,
             nb_kspf   = b_nb_kspf,
             dt_sfsj   = b_dt_sfsj,
             dt_sfrq   = b_dt_sfrq,
             vc_qcd    = b_vc_qcd,
             vc_qcsdm  = b_vc_qcsdm,
             vc_qcqxdm = b_vc_qcqxdm,
             vc_qcjddm = b_vc_qcjddm,
             vc_qcjw   = b_vc_qcjw,
             vc_qcxxdz = b_vc_qcxxdz,
             dt_qcsj   = b_dt_qcsj,
             vc_hzid   = b_vc_hzid,
             dt_xgsj   = sysdate
       where vc_bgkid = v_vc_bgkid;
      --更新患者信息
      update zjjk_zl_hzxx
         set vc_sfsw = h_vc_sfsw
       where VC_PERSONID = b_vc_hzid;
      --更新随访卡信息
      UPDATE zjjk_zl_sfk
         SET vc_sfqc     = v_vc_sfqc,
             dt_qcsj     = v_dt_qcsj,
             dt_sfrq     = v_dt_sfrq,
             vc_ysqm     = v_vc_ysqm,
             vc_qcd      = v_vc_qcd,
             vc_qcsdm    = v_vc_qcsdm,
             vc_qcqxdm   = v_vc_qcqxdm,
             vc_qcjddm   = v_vc_qcjddm,
             vc_qcjw     = v_vc_qcjw,
             vc_qcxxdz   = v_vc_qcxxdz,
             vc_zlxm     = v_vc_zlxm,
             vc_sfxy     = v_vc_sfxy,
             vc_sfff     = v_vc_sfff,
             vc_ffcs     = v_vc_ffcs,
             nb_tz       = v_nb_tz,
             vc_ffsj     = v_vc_ffsj,
             vc_ffsj1    = v_vc_ffsj1,
             vc_ffsj2    = v_vc_ffsj2,
             vc_sfzy     = v_vc_sfzy,
             vc_zybw     = v_vc_zybw,
             dt_zysj     = v_dt_zysj,
             vc_mqqk     = v_vc_mqqk,
             nb_kspf     = v_nb_kspf,
             vc_sfcx     = v_vc_sfcx,
             dt_cxglrq   = v_dt_cxglrq,
             vc_cxglyy   = v_vc_cxglyy,
             vc_cxglqtyy = v_vc_cxglqtyy,
             dt_swrq     = v_dt_swrq,
             vc_swdd     = v_vc_swdd,
             vc_swicd    = v_vc_swicd,
             vc_swicdmc  = v_vc_swicdmc,
             vc_swyy     = v_vc_swyy,
             vc_scq      = v_vc_scq,
             vc_bz       = v_vc_bz
       where vc_sfkid = v_vc_sfkid;
    
    END IF;
    --记录日志
    v_json_yw_log := Json_ext.get_json(v_json_data, 'ywjllog');
    if v_json_yw_log is not null then
      v_json_yw_log.put('bgkid', v_vc_bgkid);
      v_json_yw_log.put('bgklx', '02');
      v_json_yw_log.put('ywjlid', v_vc_sfkid);
      v_json_yw_log.put('gnmk', '05');
      v_json_yw_log.put('gnmc', '报卡管理');
      v_json_yw_log.put('czlx', v_ywjl_czlx);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_update(v_json_yw_log, v_err);
      if v_err is not null then
        raise err_custom;
      end if;
    end if;
    --更新初随访状态
    pkg_zjmb_zl.prc_bgkcsfzt_update(v_vc_bgkid, v_err);
    v_json_return.put('vc_sfkid', v_vc_sfkid);
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      if (SQL%NOTFOUND) then
        v_err      := '未找到相应的患者信息或肿瘤报卡信息';
        result_out := return_fail(v_err, 0);
      ELSE
        v_err      := SQLERRM;
        result_out := return_fail(v_err, 0);
      end if;
    
  END prc_zlsfk_update;
  /*---------------------------------------------------
  //  初访或者随访删除
  //----------------------------------------------------*/
  procedure prc_zlsfk_delete(Data_In    In Clob, --入参
                             result_out OUT VARCHAR2) --返回
   is
  
    v_vc_sfkid varchar2(32);
    v_vc_bgkid varchar2(32);
    v_vc_sffl  varchar2(2);
    v_count    number(4);
    --公共变量
    v_czyhjgjb    varchar2(20);
    v_json_data   json;
    v_json_yw_log json;
    v_ywjl_czlx   varchar2(3);
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err     VARCHAR2(2000);
    v_sysdate date;
  
  BEGIN
    json_data(Data_In, 'ZJJK_ZL_SFK删除', v_json_data);
    v_sysdate  := sysdate;
    v_vc_sfkid := json_str(v_json_data, 'vc_sfkid');
    v_vc_bgkid := json_str(v_json_data, 'vc_bgkid');
    v_vc_sffl  := json_str(v_json_data, 'vc_sffl');
    v_czyhjgjb := json_str(v_json_data, 'jgjb');
    if (v_czyhjgjb <> 3) then
      v_err := '该机构无权删除随访卡';
      raise err_custom;
    else
      if (v_vc_sffl = '1') then
        select count(*)
          into v_count
          from zjjk_zl_sfk
         where vc_sfkid = v_vc_sfkid
           and vc_bgkid = v_vc_bgkid;
        if (v_count > 0) then
          v_err := '该患者已有随访记录，不能删除初访记录';
          raise err_custom;
        end if;
      end if;
    end if;
    --初随访卡赋值
    if (v_vc_sffl = '1') then
      DELETE FROM ZJJK_ZL_CCSFK
       WHERE vc_sfkid = v_vc_sfkid
         and vc_bgkid = v_vc_bgkid;
    else
      DELETE FROM ZJJK_ZL_SFK
       WHERE vc_sfkid = v_vc_sfkid
         and vc_bgkid = v_vc_bgkid;
    END IF;
    --记录日志
    v_json_yw_log := Json_ext.get_json(v_json_data, 'ywjllog');
    if v_json_yw_log is not null then
      v_json_yw_log.put('bgkid', v_vc_bgkid);
      v_json_yw_log.put('bgklx', '02');
      v_json_yw_log.put('ywjlid', v_vc_sfkid);
      v_json_yw_log.put('gnmk', '05');
      v_json_yw_log.put('gnmc', '报卡管理');
      v_json_yw_log.put('czlx', '04');
      pkg_zjmb_xtfz.prc_zjjk_yw_log_update(v_json_yw_log, v_err);
      if v_err is not null then
        raise err_custom;
      end if;
    end if;
    --更新初随访状态
    pkg_zjmb_zl.prc_bgkcsfzt_update(v_vc_bgkid, v_err);
    v_json_return.put('vc_sfkid', v_vc_sfkid);
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
    
  END prc_zlsfk_delete;
  /*--------------------------------------------------------------------------
  || 功能描述 ：更新初随访状态
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_bgkcsfzt_update(p_bgkid    In VARCHAR2,
                                result_out OUT VARCHAR2) --返回  
   is
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
    --公共变量
    v_sysdate date;
    v_czyjgdm varchar2(50);
    v_czyjgjb varchar2(3);
    v_count   number;
    v_cfzt    varchar2(3);
    v_cfsj    date;
    v_sfsj    date;
  BEGIN
    --初始化
    v_cfzt := '2';
    select min(dt_sfrq)
      into v_cfsj
      from ZJJK_ZL_CCSFK a
     where a.vc_bgkid = p_bgkid;
    --存在初访
    if v_cfsj is not null then
      v_cfzt := '1';
    end if;
    --随访
    select max(dt_sfrq)
      into v_sfsj
      from zjjk_zl_sfk a
     where a.vc_bgkid = p_bgkid;
    --存在初访
    if v_sfsj is not null then
      v_cfzt := '3';
    else
      v_sfsj := v_cfsj;
    end if;
    --更新报卡初随访状态
    update zjjk_zl_bgk a
       set a.vc_sfcf = v_cfzt,
           a.dt_cfsj = v_cfsj,
           a.dt_sfsj = v_sfsj,
           a.dt_sfrq = v_sfsj,
           dt_xgsj   = sysdate
     where a.vc_bgkid = p_bgkid;
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_bgkcsfzt_update;
end pkg_zjmb_zl;
