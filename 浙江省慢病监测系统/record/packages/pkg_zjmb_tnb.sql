CREATE OR REPLACE PACKAGE BODY pkg_zjmb_tnb AS
  /******************************************************************************/
  /*  程序包名 ：pkg_P_COMM                                                     */
  /*  业务环节 ：综合部分_公共类                                                */
  /*  功能描述 ：为综合部分提供调用的公共过程和函数。                           */
  /*                                                                            */
  /*  作    者 ：     作成日期 ：2011-05-11   版本编号 ：Ver 1.0.0  */
  /*----------------------------------------------------------------------------*/
  /*  修改记录 ：                                                               */
  /******************************************************************************/
  /*-------------------------------------------------------------------------*/
  /*-------------------------------------------------------------------------*/
  /*--------------------------------------------------------------------------
  || 业务环节 ：报卡管理
  || 过程名称 ：prc_tnbbgk_update
  || 错误编号 ：
  || 功能描述 ：糖尿病报告卡新增及修改
  || 参数描述 ：参数标识           说明
  ||            --------------------------------------------------------------
  ||
  ||
  || 作    者 ：          完成日期 ：2018-03-14
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_tnbbgk_update(Data_In    In Clob, --入参
                              result_out OUT VARCHAR2) --返回
   IS
    v_json_data   json;
    v_json_yw_log json;
    v_ywjl_czlx   varchar2(3);
    v_Json_Return Json := Json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
    --报卡信息
    v_vc_bgkid    zjjk_tnb_bgk.vc_bgkid%TYPE; --报告卡ID
    v_vc_bgklx    zjjk_tnb_bgk.vc_bgklx%TYPE; --报告卡类型
    v_vc_hzid     zjjk_tnb_bgk.vc_hzid%TYPE; --患者ID
    v_vc_icd10    zjjk_tnb_bgk.vc_icd10%TYPE; --ICD—10
    v_vc_tnblx    zjjk_tnb_bgk.vc_tnblx%TYPE; --糖尿病类型
    v_vc_wxys     zjjk_tnb_bgk.vc_wxys%TYPE; --危险因素
    v_vc_wxystz   zjjk_tnb_bgk.vc_wxystz%TYPE; --危险因素体重
    v_vc_wxyssg   zjjk_tnb_bgk.vc_wxyssg%TYPE; --危险因素身高
    v_vc_tnbs     zjjk_tnb_bgk.vc_tnbs%TYPE; --糖尿病史
    v_vc_jzsrs    zjjk_tnb_bgk.vc_jzsrs%TYPE; --家族史人数
    v_vc_ywbfz    zjjk_tnb_bgk.vc_ywbfz%TYPE; --有无并发症
    v_vc_zslcbx   zjjk_tnb_bgk.vc_zslcbx%TYPE; --临床表现
    v_vc_zslcbxqt zjjk_tnb_bgk.vc_zslcbxqt%TYPE; --临床表现其它
    v_nb_kfxtz    zjjk_tnb_bgk.nb_kfxtz%TYPE; --E
    v_nb_sjxtz    zjjk_tnb_bgk.nb_sjxtz%TYPE; --E
    v_nb_xjptt    zjjk_tnb_bgk.nb_xjptt%TYPE; --E
    v_nb_zdgc     zjjk_tnb_bgk.nb_zdgc%TYPE; --E
    v_nb_e4hdlc   zjjk_tnb_bgk.nb_e4hdlc%TYPE; --E
    v_nb_e5ldlc   zjjk_tnb_bgk.nb_e5ldlc%TYPE; --E
    v_nb_gysz     zjjk_tnb_bgk.nb_gysz%TYPE; --E
    v_nb_nwldb    zjjk_tnb_bgk.nb_nwldb%TYPE; --E
    v_nbthxhdb    zjjk_tnb_bgk.nbthxhdb%TYPE; --E
    v_dt_sczdrq   zjjk_tnb_bgk.dt_sczdrq%TYPE; --首次诊断日期
    v_vc_zddw     zjjk_tnb_bgk.Vc_Zddw%TYPE; --最高诊断单位
    v_vc_bgdw     zjjk_tnb_bgk.vc_bgdw%TYPE; --报告单位
    v_vc_bgys     zjjk_tnb_bgk.vc_bgys%TYPE; --报告医生
    v_dt_bgrq     zjjk_tnb_bgk.dt_bgrq%TYPE; --报告日期
    v_vc_sfsw     zjjk_tnb_bgk.vc_sfsw%TYPE; --是否死亡
    v_dt_swrq     zjjk_tnb_bgk.dt_swrq%TYPE; --死亡日期
    v_vc_swyy     zjjk_tnb_bgk.vc_swyy%TYPE; --死亡原因
    v_vc_swicd10  zjjk_tnb_bgk.vc_swicd10%TYPE; --死亡ICD—10
    v_vc_swicdmc  zjjk_tnb_bgk.vc_swicdmc%TYPE; --死亡ICD名称
    v_vc_bszy     zjjk_tnb_bgk.vc_bszy%TYPE; --病史摘要
    v_vc_scbz     zjjk_tnb_bgk.vc_scbz%TYPE; --删除标志
    v_vc_ccid     zjjk_tnb_bgk.vc_ccid%TYPE; --查重ID
    v_vc_ckbz     zjjk_tnb_bgk.vc_ckbz%TYPE; --重卡标志
    v_vc_sfbb     zjjk_tnb_bgk.vc_sfbb%TYPE; --是否补报
    v_vc_sdqrzt   zjjk_tnb_bgk.vc_sdqrzt%TYPE; --属地确认状态0代表未确认1代表已确认
    v_dt_qrsj     zjjk_tnb_bgk.dt_qrsj%TYPE; --确认时间
    v_vc_sdqrid   zjjk_tnb_bgk.vc_sdqrid%TYPE; --属地确认ID
    v_dt_cjsj     zjjk_tnb_bgk.dt_cjsj%TYPE; --创建时间
    v_vc_cjdw     zjjk_tnb_bgk.vc_cjdw%TYPE; --创建单位
    v_dt_xgsj     zjjk_tnb_bgk.dt_xgsj%TYPE; --修改时间
    v_vc_xgdw     zjjk_tnb_bgk.vc_xgdw%TYPE; --修改单位
    v_vc_gldw     zjjk_tnb_bgk.vc_gldw%TYPE; --管理单位
    v_vc_shbz     zjjk_tnb_bgk.vc_shbz%TYPE; --审核标志(0:医院未审核,1:医院通过,2:医院未通过,3:区县通过,4:区县未通过,5:市通过,6:市未通过,7:省通过,8:省未通过。)
    v_vc_shwtgyy1 zjjk_tnb_bgk.vc_shwtgyy1%TYPE; --区县审核未通过原因选项
    v_vc_shwtgyy2 zjjk_tnb_bgk.vc_shwtgyy2%TYPE; --区县审核未通过原因
    v_vc_khbz     zjjk_tnb_bgk.vc_khbz%TYPE; --考核标志
    v_vc_khjg     zjjk_tnb_bgk.vc_khjg%TYPE; --考核结果
    v_vc_smtjid   zjjk_tnb_bgk.vc_smtjid%TYPE; --生命统计ID
    v_vc_qybz     zjjk_tnb_bgk.vc_qybz%TYPE; --迁移标志
    v_vc_hkhs     zjjk_tnb_bgk.vc_hkhs%TYPE; --户口是否核实
    v_vc_hkwhsyy  zjjk_tnb_bgk.vc_hkwhsyy%TYPE; --户口未核实原因
    v_vc_jzhs     zjjk_tnb_bgk.vc_jzhs%TYPE; --居住地是否核实
    v_vc_jzwhsyy  zjjk_tnb_bgk.vc_jzwhsyy%TYPE; --居住地未核实原因
    v_vc_cxgl     zjjk_tnb_bgk.vc_cxgl%TYPE; --是否撤销管理
    v_vc_qcbz     zjjk_tnb_bgk.vc_qcbz%TYPE; --迁出标志
    v_vc_xgyh     zjjk_tnb_bgk.vc_xgyh%TYPE; --
    v_vc_cjyh     zjjk_tnb_bgk.vc_cjyh%TYPE; --
    v_vc_xxly     zjjk_tnb_bgk.vc_xxly%TYPE; --
    v_vc_bz       zjjk_tnb_bgk.vc_bz%TYPE; --备注
    v_dt_dcrq     zjjk_tnb_bgk.dt_dcrq%TYPE; --
    v_vc_dcr      zjjk_tnb_bgk.vc_dcr%TYPE; --
    v_vc_zdyh     zjjk_tnb_bgk.vc_zdyh%TYPE; --
    v_vc_swxx     zjjk_tnb_bgk.vc_swxx%TYPE; --
    v_vc_zgzddw   zjjk_tnb_bgk.vc_zgzddw%TYPE; --最高诊断单位
    v_vc_sznl     zjjk_tnb_bgk.vc_sznl%TYPE; --
    v_vc_icdo     zjjk_tnb_bgk.vc_icdo%TYPE; --
    v_vc_zyh      zjjk_tnb_bgk.vc_zyh%TYPE; --
    v_vc_mzh      zjjk_tnb_bgk.vc_mzh%TYPE; --
    v_vc_bqygzbr  zjjk_tnb_bgk.vc_bqygzbr%TYPE; --
    v_vc_xzqybm   zjjk_tnb_bgk.vc_xzqybm%TYPE; --
    v_vc_bgkzt    zjjk_tnb_bgk.vc_bgkzt%TYPE; --报告卡状态
    v_vc_bgkcode  zjjk_tnb_bgk.vc_bgkcode%TYPE; --报告卡编号
    v_vc_qcd      zjjk_tnb_bgk.vc_qcd%TYPE; --迁出省
    v_vc_qcsdm    zjjk_tnb_bgk.vc_qcsdm%TYPE; --迁出市
    v_vc_qcqxdm   zjjk_tnb_bgk.vc_qcqxdm%TYPE; --迁出区
    v_vc_qcjddm   zjjk_tnb_bgk.vc_qcjddm%TYPE; --迁出街道
    v_vc_qcjw     zjjk_tnb_bgk.vc_qcjw%TYPE; --迁出居委
    v_vc_sfqc     zjjk_tnb_bgk.vc_sfqc%TYPE; --是否迁出
    v_dt_qcsj     zjjk_tnb_bgk.dt_qcsj%TYPE; --迁出时间
    v_vc_qcxxdz   zjjk_tnb_bgk.vc_qcxxdz%TYPE; --迁出详细地址
    v_vc_shid     zjjk_tnb_bgk.vc_shid%TYPE; --审核ID
    v_vc_khid     zjjk_tnb_bgk.vc_khid%TYPE; --考核ID
    v_vc_khzt     zjjk_tnb_bgk.vc_khzt%TYPE; --考核状态
    v_vc_shzt     zjjk_tnb_bgk.vc_shzt%TYPE; --审核状态
    v_vc_cfzt     zjjk_tnb_bgk.vc_cfzt%TYPE; --初访状态0为未初访1为已初访
    v_vc_shwtgyy  zjjk_tnb_bgk.vc_shwtgyy%TYPE; --区县审核未通过原因
    v_vc_bks      zjjk_tnb_bgk.vc_bks%TYPE; --报卡市
    v_vc_bkq      zjjk_tnb_bgk.vc_bkq%TYPE; --报卡区
    v_vc_bmi      zjjk_tnb_bgk.vc_bmi%TYPE; --BMI指数
    v_vc_wtzt     zjjk_tnb_bgk.vc_wtzt%TYPE; --委托状态
    v_vc_ywtdw    zjjk_tnb_bgk.vc_ywtdw%TYPE; --原委托单位
    v_vc_sqsl     zjjk_tnb_bgk.vc_sqsl%TYPE; --街道对应社区数量
    v_vc_jjsl     zjjk_tnb_bgk.vc_jjsl%TYPE; --拒绝数量
    v_vc_ywtjd    zjjk_tnb_bgk.vc_ywtjd%TYPE; --原委托街道
    v_vc_ywtjw    zjjk_tnb_bgk.vc_ywtjw%TYPE; --原委托居委
    v_vc_ywtxxdz  zjjk_tnb_bgk.vc_ywtxxdz%TYPE; --原委托详细地址
    v_vc_ywtjgdm  zjjk_tnb_bgk.vc_ywtjgdm%TYPE; --原委托机构代码
    v_vc_lszy     zjjk_tnb_bgk.vc_lszy%TYPE; --历史数据导入的职业
    v_vc_state    zjjk_tnb_bgk.vc_state%TYPE; --随访结果
    v_dt_yyshsj   zjjk_tnb_bgk.dt_yyshsj%TYPE; --医院审核时间
    v_dt_qxshsj   zjjk_tnb_bgk.dt_qxshsj%TYPE; --区县审核时间
    v_vc_bksznl   zjjk_tnb_bgk.vc_bksznl%TYPE; --实足年龄
    v_dt_cfsj     zjjk_tnb_bgk.dt_cfsj%TYPE; --初访时间
    v_dt_sfsj     zjjk_tnb_bgk.dt_sfsj%TYPE; --随访时间
    v_dt_qxzssj   zjjk_tnb_bgk.dt_qxzssj%TYPE; --
  
    --患者信息
    v_vc_personid zjjk_tnb_hzxx.vc_personid%TYPE; --患者ID
    v_vc_hzxm     zjjk_tnb_hzxx.vc_hzxm%TYPE; --患者姓名
    v_vc_hzxb     zjjk_tnb_hzxx.vc_hzxb%TYPE; --患者性别
    v_vc_hzmz     zjjk_tnb_hzxx.vc_hzmz%TYPE; --患者民族
    v_vc_whcd     zjjk_tnb_hzxx.vc_whcd%TYPE; --文化程度
    v_dt_hzcsrq   zjjk_tnb_hzxx.dt_hzcsrq%TYPE; --患者出生日期
    v_vc_sfzh     zjjk_tnb_hzxx.vc_sfzh%TYPE; --身份证号
  
    v_vc_lxdh     zjjk_tnb_hzxx.vc_lxdh%TYPE; --联系电话
    v_vc_hydm     zjjk_tnb_hzxx.vc_hydm%TYPE; --行业代码
    v_vc_zydm     zjjk_tnb_hzxx.vc_zydm%TYPE; --职业代码-具体工种
    v_vc_gzdw     zjjk_tnb_hzxx.vc_gzdw%TYPE; --工作单位
    v_vc_hkshen   zjjk_tnb_hzxx.vc_hkshen%TYPE; --户口省份
    v_vc_hks      zjjk_tnb_hzxx.vc_hks%TYPE; --户口市
    v_vc_hkqx     zjjk_tnb_hzxx.vc_hkqx%TYPE; --户口区县
    v_vc_hkjd     zjjk_tnb_hzxx.vc_hkjd%TYPE; --户口街道
    v_vc_hkjw     zjjk_tnb_hzxx.vc_hkjw%TYPE; --户口居委
    v_vc_hkxxdz   zjjk_tnb_hzxx.vc_hkxxdz%TYPE; --户口详细地址
    v_vc_jzds     zjjk_tnb_hzxx.vc_jzds%TYPE; --居住地址省
    v_vc_jzs      zjjk_tnb_hzxx.vc_jzs%TYPE; --居住地址市
    v_vc_jzqx     zjjk_tnb_hzxx.vc_jzqx%TYPE; --居住地址区县
    v_vc_jzjd     zjjk_tnb_hzxx.vc_jzjd%TYPE; --居住街道
    v_vc_jzjw     zjjk_tnb_hzxx.vc_jzjw%TYPE; --居住居委
    v_vc_jzxxdz   zjjk_tnb_hzxx.vc_jzxxdz%TYPE; --居住详细地址
    v_vc_bak_hy   zjjk_tnb_hzxx.vc_bak_hy%TYPE; --备份职业
    v_vc_bak_zy   zjjk_tnb_hzxx.vc_bak_zy%TYPE; --备份行业
    v_vc_bak_sfzh zjjk_tnb_hzxx.vc_bak_sfzh%TYPE; --备份身份证号
    v_vc_hkjd_bgq zjjk_tnb_hzxx.vc_hkjd%TYPE; --户口街道
    v_vc_hkqx_bgq zjjk_tnb_hzxx.vc_hkqx%TYPE; --户口区县
        v_vc_hkjw_bgq zjjk_tnb_hzxx.vc_hkjw%TYPE; --户口居委
    v_vc_hkxx_bgq zjjk_tnb_hzxx.vc_hkxxdz%TYPE; --户口详细地址
    --公共变量
    v_sysdate      date;
    v_czyjgjb      varchar2(3);
    v_czyjgdm      varchar2(50);
    v_czyyhid      varchar2(50);
    v_count        number;
    v_ywrzid       zjjk_yw_log.id%TYPE; --业务日志id
    v_tab_bgk_old  zjjk_tnb_bgk%rowtype; --糖尿病报告卡变更前
    v_tab_hzxx_old zjjk_tnb_hzxx%rowtype; --糖尿病患者信息变更前
    v_tab_bgk_new  zjjk_tnb_bgk%rowtype; --糖尿病报告卡变更后
    v_tab_hzxx_new zjjk_tnb_hzxx%rowtype; --糖尿病患者信息变更后
  BEGIN
    json_data(data_in, 'zjjk_tnb_bgk更新', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid');
    --获取机构级别
    -- select fun_getczyjgjb(v_czyjgdm) into v_czyjgjb from dual;
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    --获取参数
    v_vc_personid := Json_Str(v_Json_Data, 'vc_personid');
    v_vc_hzxm     := Json_Str(v_Json_Data, 'vc_hzxm');
    v_vc_hzxb     := Json_Str(v_Json_Data, 'vc_hzxb');
    v_vc_hzmz     := Json_Str(v_Json_Data, 'vc_hzmz');
    v_vc_whcd     := Json_Str(v_Json_Data, 'vc_whcd');
    v_dt_hzcsrq   := std(Json_Str(v_Json_Data, 'dt_hzcsrq'));
    v_vc_sznl     := Json_Str(v_Json_Data, 'vc_sznl');
    v_vc_sfzh     := Json_Str(v_Json_Data, 'vc_sfzh');
    v_vc_sfzh     := UPPER(v_vc_sfzh); --大写身份证号
    v_vc_lxdh     := Json_Str(v_Json_Data, 'vc_lxdh');
    v_vc_hydm     := Json_Str(v_Json_Data, 'vc_hydm');
    v_vc_zydm     := Json_Str(v_Json_Data, 'vc_zydm');
    v_vc_gzdw     := Json_Str(v_Json_Data, 'vc_gzdw');
    v_vc_hkshen   := Json_Str(v_Json_Data, 'vc_hkshen');
    v_vc_hks      := Json_Str(v_Json_Data, 'vc_hks');
    v_vc_hkqx     := Json_Str(v_Json_Data, 'vc_hkqx');
    v_vc_hkjd     := Json_Str(v_Json_Data, 'vc_hkjd');
    v_vc_hkjw     := Json_Str(v_Json_Data, 'vc_hkjw');
    v_vc_hkxxdz   := Json_Str(v_Json_Data, 'vc_hkxxdz');
    v_vc_jzds     := Json_Str(v_Json_Data, 'vc_jzds');
    v_vc_jzs      := Json_Str(v_Json_Data, 'vc_jzs');
    v_vc_jzqx     := Json_Str(v_Json_Data, 'vc_jzqx');
    v_vc_jzjd     := Json_Str(v_Json_Data, 'vc_jzjd');
    v_vc_jzjw     := Json_Str(v_Json_Data, 'vc_jzjw');
    v_vc_jzxxdz   := Json_Str(v_Json_Data, 'vc_jzxxdz');
    v_vc_bak_hy   := Json_Str(v_Json_Data, 'vc_bak_hy');
    v_vc_bak_zy   := Json_Str(v_Json_Data, 'vc_bak_zy');
    v_vc_bak_sfzh := Json_Str(v_Json_Data, 'vc_bak_sfzh');
    v_vc_bgkid    := Json_Str(v_Json_Data, 'vc_bgkid');
    v_vc_bgklx    := Json_Str(v_Json_Data, 'vc_bgklx');
    v_vc_hzid     := Json_Str(v_Json_Data, 'vc_hzid');
    v_vc_icd10    := Json_Str(v_Json_Data, 'vc_icd10');
    v_vc_tnblx    := Json_Str(v_Json_Data, 'vc_tnblx');
    v_vc_wxys     := Json_Str(v_Json_Data, 'vc_wxys');
    v_vc_wxystz   := Json_Str(v_Json_Data, 'vc_wxystz');
    v_vc_wxyssg   := Json_Str(v_Json_Data, 'vc_wxyssg');
    v_vc_tnbs     := Json_Str(v_Json_Data, 'vc_tnbs');
    v_vc_jzsrs    := Json_Str(v_Json_Data, 'vc_jzsrs');
    v_vc_ywbfz    := Json_Str(v_Json_Data, 'vc_ywbfz');
    v_vc_zslcbx   := Json_Str(v_Json_Data, 'vc_zslcbx');
    v_vc_zslcbxqt := Json_Str(v_Json_Data, 'vc_zslcbxqt');
    v_nb_kfxtz    := Json_Str(v_Json_Data, 'nb_kfxtz');
    v_nb_sjxtz    := Json_Str(v_Json_Data, 'nb_sjxtz');
    v_nb_xjptt    := Json_Str(v_Json_Data, 'nb_xjptt');
    v_nb_zdgc     := Json_Str(v_Json_Data, 'nb_zdgc');
    v_nb_e4hdlc   := Json_Str(v_Json_Data, 'nb_e4hdlc');
    v_nb_e5ldlc   := Json_Str(v_Json_Data, 'nb_e5ldlc');
    v_nb_gysz     := Json_Str(v_Json_Data, 'nb_gysz');
    v_nb_nwldb    := Json_Str(v_Json_Data, 'nb_nwldb');
    v_nbthxhdb    := Json_Str(v_Json_Data, 'nbthxhdb');
    v_dt_sczdrq   := std(Json_Str(v_Json_Data, 'dt_sczdrq'));
    v_vc_bgdw     := Json_Str(v_Json_Data, 'vc_bgdw');
    v_vc_bgys     := Json_Str(v_Json_Data, 'vc_bgys');
    v_dt_bgrq     := std(Json_Str(v_Json_Data, 'dt_bgrq'));
    v_vc_sfsw     := Json_Str(v_Json_Data, 'vc_sfsw');
    v_dt_swrq     := std(Json_Str(v_Json_Data, 'dt_swrq'));
    v_vc_swyy     := Json_Str(v_Json_Data, 'vc_swyy');
    v_vc_swicd10  := Json_Str(v_Json_Data, 'vc_swicd10');
    v_vc_swicdmc  := Json_Str(v_Json_Data, 'vc_swicdmc');
    v_vc_bszy     := Json_Str(v_Json_Data, 'vc_bszy');
    v_vc_scbz     := Json_Str(v_Json_Data, 'vc_scbz');
    v_vc_ccid     := Json_Str(v_Json_Data, 'vc_ccid');
    v_vc_ckbz     := Json_Str(v_Json_Data, 'vc_ckbz');
    v_vc_sfbb     := Json_Str(v_Json_Data, 'vc_sfbb');
    v_vc_sdqrzt   := Json_Str(v_Json_Data, 'vc_sdqrzt');
    v_dt_qrsj     := std(Json_Str(v_Json_Data, 'dt_qrsj'));
    v_vc_sdqrid   := Json_Str(v_Json_Data, 'vc_sdqrid');
    v_dt_cjsj     := v_sysdate;
    v_dt_xgsj     := v_sysdate;
    v_vc_xgdw     := Json_Str(v_Json_Data, 'vc_xgdw');
    v_vc_gldw     := Json_Str(v_Json_Data, 'vc_gldw');
    v_vc_shbz     := Json_Str(v_Json_Data, 'vc_shbz');
    v_vc_shwtgyy1 := Json_Str(v_Json_Data, 'vc_shwtgyy1');
    v_vc_shwtgyy2 := Json_Str(v_Json_Data, 'vc_shwtgyy2');
    v_vc_khbz     := Json_Str(v_Json_Data, 'vc_khbz');
    v_vc_khjg     := Json_Str(v_Json_Data, 'vc_khjg');
    v_vc_smtjid   := Json_Str(v_Json_Data, 'vc_smtjid');
    v_vc_qybz     := Json_Str(v_Json_Data, 'vc_qybz');
    v_vc_hkhs     := Json_Str(v_Json_Data, 'vc_hkhs');
    v_vc_hkwhsyy  := Json_Str(v_Json_Data, 'vc_hkwhsyy');
    v_vc_jzhs     := Json_Str(v_Json_Data, 'vc_jzhs');
    v_vc_jzwhsyy  := Json_Str(v_Json_Data, 'vc_jzwhsyy');
    v_vc_cxgl     := Json_Str(v_Json_Data, 'vc_cxgl');
    v_vc_qcbz     := Json_Str(v_Json_Data, 'vc_qcbz');
    v_vc_xxly     := Json_Str(v_Json_Data, 'vc_xxly');
    v_vc_bz       := Json_Str(v_Json_Data, 'vc_bz');
    v_dt_dcrq     := std(Json_Str(v_Json_Data, 'dt_dcrq'));
    v_vc_dcr      := Json_Str(v_Json_Data, 'vc_dcr');
    v_vc_zdyh     := Json_Str(v_Json_Data, 'vc_zdyh');
    v_vc_swxx     := Json_Str(v_Json_Data, 'vc_swxx');
    v_vc_zgzddw   := Json_Str(v_Json_Data, 'vc_zgzddw');
    v_vc_sznl     := Json_Str(v_Json_Data, 'vc_sznl');
    v_vc_icdo     := Json_Str(v_Json_Data, 'vc_icdo');
    v_vc_zyh      := Json_Str(v_Json_Data, 'vc_zyh');
    v_vc_mzh      := Json_Str(v_Json_Data, 'vc_mzh');
    v_vc_bqygzbr  := Json_Str(v_Json_Data, 'vc_bqygzbr');
    v_vc_xzqybm   := Json_Str(v_Json_Data, 'vc_xzqybm');
    v_vc_bgkzt    := Json_Str(v_Json_Data, 'vc_bgkzt');
    v_vc_bgkcode  := Json_Str(v_Json_Data, 'vc_bgkcode');
    v_vc_qcd      := Json_Str(v_Json_Data, 'vc_qcd');
    v_vc_qcsdm    := Json_Str(v_Json_Data, 'vc_qcsdm');
    v_vc_qcqxdm   := Json_Str(v_Json_Data, 'vc_qcqxdm');
    v_vc_qcjddm   := Json_Str(v_Json_Data, 'vc_qcjddm');
    v_vc_qcjw     := Json_Str(v_Json_Data, 'vc_qcjw');
    v_vc_sfqc     := Json_Str(v_Json_Data, 'vc_sfqc');
    v_dt_qcsj     := std(Json_Str(v_Json_Data, 'dt_qcsj'));
    v_vc_qcxxdz   := Json_Str(v_Json_Data, 'vc_qcxxdz');
    v_vc_shid     := Json_Str(v_Json_Data, 'vc_shid');
    v_vc_khid     := Json_Str(v_Json_Data, 'vc_khid');
    v_vc_khzt     := Json_Str(v_Json_Data, 'vc_khzt');
    v_vc_shzt     := Json_Str(v_Json_Data, 'vc_shzt');
    v_vc_cfzt     := Json_Str(v_Json_Data, 'vc_cfzt');
    v_vc_shwtgyy  := Json_Str(v_Json_Data, 'vc_shwtgyy');
    v_vc_bks      := Json_Str(v_Json_Data, 'vc_bks');
    v_vc_bkq      := Json_Str(v_Json_Data, 'vc_bkq');
    v_vc_bmi      := Json_Str(v_Json_Data, 'vc_bmi');
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
    v_dt_qxshsj   := Json_Str(v_Json_Data, 'dt_qxshsj');
    v_vc_bksznl   := Json_Str(v_Json_Data, 'vc_bksznl');
    v_dt_cfsj     := Json_Str(v_Json_Data, 'dt_cfsj');
    v_dt_sfsj     := Json_Str(v_Json_Data, 'dt_sfsj');
    v_dt_qxzssj   := Json_Str(v_Json_Data, 'dt_qxzssj');
    v_vc_zddw     := Json_Str(v_Json_Data, 'vc_zddw');
    --检验字段必填
    --校验数据是否合法
    if v_vc_bgklx is null then
      v_err := '报告卡类别不能为空!';
      raise err_custom;
    end if;
    if v_vc_hzxm is null then
      v_err := '姓名不能为空!';
      raise err_custom;
    end if;
    if v_vc_hzxb is null then
      v_err := '性别不能为空!';
      raise err_custom;
    end if;
    if v_dt_hzcsrq is null then
      v_err := '出生日期不能为空!';
      raise err_custom;
    end if;
    if v_vc_hydm is null then
      v_err := '行业不能为空!';
      raise err_custom;
    end if;
    if v_vc_zydm is null then
      v_err := '具体工种不能为空!';
      raise err_custom;
    end if;
    if v_vc_whcd is null then
      v_err := '文化程度不能为空!';
      raise err_custom;
    end if;
    if v_vc_lxdh is null then
      v_err := '联系电话不能为空!';
      raise err_custom;
    end if;
    if v_vc_hkshen is null then
      v_err := '户口省份不能为空!';
      raise err_custom;
    end if;
    --户籍浙江省
    if v_vc_hkshen = '0' then
      if v_vc_hks is null then
        v_err := '户口市不能为空!';
        raise err_custom;
      end if;
      if v_vc_hkqx is null then
        v_err := '户口区县不能为空!';
        raise err_custom;
      end if;
      if v_vc_hkjd is null then
        v_err := '户口街道不能为空!';
        raise err_custom;
      end if;
      if substr(v_vc_hks, 1, 4) <> substr(v_vc_hkqx, 1, 4) or
         substr(v_vc_hks, 1, 4) <> substr(v_vc_hkjd, 1, 4) then
        v_err := '户口地址区划不匹配!';
        raise err_custom;
      end if;
    end if;
    if v_vc_jzds is null then
      v_err := '居住地址省不能为空!';
      raise err_custom;
    end if;
    --居住地址浙江
    if v_vc_jzds = '0' then
      if v_vc_jzs is null then
        v_err := '居住地市不能为空!';
        raise err_custom;
      end if;
      if v_vc_jzqx is null then
        v_err := '居住地区县不能为空!';
        raise err_custom;
      end if;
      if v_vc_jzjd is null then
        v_err := '居住地街道不能为空!';
        raise err_custom;
      end if;
      if v_vc_jzxxdz is null then
        v_err := '居住地详细地址不能为空!';
        raise err_custom;
      end if;
      if substr(v_vc_jzs, 1, 4) <> substr(v_vc_jzqx, 1, 4) or
         substr(v_vc_jzs, 1, 4) <> substr(v_vc_jzjd, 1, 4) then
        v_err := '户口地址区划不匹配!';
        raise err_custom;
      end if;
    end if;
    if v_vc_icd10 is null then
      v_err := 'ICD编码（IDC-10）不能为空!';
      raise err_custom;
    end if;
    if v_vc_tnblx is null then
      v_err := '糖尿病类型不能为空!';
      raise err_custom;
    end if;
    if v_vc_zddw is null then
      v_err := '最高诊断单位不能为空!';
      raise err_custom;
    end if;
    if v_dt_sczdrq is null then
      v_err := '首次诊断日期不能为空!';
      raise err_custom;
    end if;
    if v_dt_bgrq is null then
      v_err := '报卡日期不能为空!';
      raise err_custom;
    end if;
    if v_vc_bgys is null then
      v_err := '报告医师不能为空!';
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
  
    if v_vc_bgdw is null then
      v_err := '报告单位不能为空!';
      raise err_custom;
    end if;
    if v_vc_bgkid is null then
      --创建单位默认当前操作员所在机构
      v_vc_bgdw := v_czyjgdm;
      --新增
      v_ywjl_czlx := '01';
      --设置报卡状态
      if v_czyjgjb <> '4' then
        v_err := '当前机构无新增权限!';
        raise err_custom;
      end if;
      v_vc_bks    := substr(v_vc_bgdw, 1, 4) || '0000';
      v_vc_bkq    := substr(v_vc_bgdw, 1, 6) || '00';
      v_vc_cjdw   := v_vc_bgdw;
      v_vc_shbz   := '1';
      v_dt_yyshsj := v_sysdate;
      v_vc_scbz   := '0';
      v_vc_bgkzt  := '0';
      v_vc_cfzt   := '0';
      v_vc_qybz   := '0';
      v_vc_wtzt   := '0';
      v_dt_cjsj   := v_sysdate;
      v_vc_swyy   := Json_Str(v_Json_Data, 'vc_swyy');
      v_vc_icd10  := Json_Str(v_Json_Data, 'vc_icd10');
      --死亡标志
      if v_vc_swyy is null then
        --未死亡
        v_vc_sfsw := '0';
      elsif v_vc_swyy = '1' then
        --死亡原因为糖尿病
        v_vc_sfsw    := '1';
        v_vc_swicd10 := v_vc_icd10;
        v_vc_bgkzt   := '7';
      else
        v_vc_sfsw  := '1';
        v_vc_bgkzt := '7';
      end if;
    
      v_vc_personid := sys_guid();
      v_vc_hzid     := v_vc_personid;
      --属地确认
      select count(1), wm_concat(a.code)
        into v_count, v_vc_gldw
        from organ_node a
       where a.removed = 0
         and a.description like '%' || v_vc_hkjd || '%';
      if v_count = 1 then
        --确定属地
        v_vc_sdqrzt := '1';
      else
        v_vc_gldw   := v_vc_hkqx;
        v_vc_sdqrzt := '0';
      end if;
      --户口省
      v_vc_hkshen := Json_Str(v_Json_Data, 'vc_hkshen');
      --外省
      if v_vc_hkshen = '1' then
        v_vc_gldw   := '99999999';
        v_vc_hks    := '';
        v_vc_hkqx   := '';
        v_vc_hkjd   := '';
        v_vc_hks    := '';
        v_vc_hkjw   := '';
        v_vc_sdqrzt := '1';
      end if;
      --写入患者信息
      insert into zjjk_tnb_hzxx
        (vc_personid,
         vc_jzxxdz,
         vc_jzjw,
         vc_jzjd,
         vc_jzqx,
         vc_jzs,
         vc_jzds,
         vc_hkxxdz,
         vc_hkjw,
         vc_hkjd,
         vc_hkqx,
         vc_hks,
         vc_hkshen,
         vc_gzdw,
         vc_zydm,
         vc_hydm,
         vc_lxdh,
         vc_sfzh,
         vc_sznl,
         dt_hzcsrq,
         vc_whcd,
         vc_hzmz,
         vc_hzxb,
         vc_hzxm)
      values
        (v_vc_personid,
         v_vc_jzxxdz,
         v_vc_jzjw,
         v_vc_jzjd,
         v_vc_jzqx,
         v_vc_jzs,
         v_vc_jzds,
         v_vc_hkxxdz,
         v_vc_hkjw,
         v_vc_hkjd,
         v_vc_hkqx,
         v_vc_hks,
         v_vc_hkshen,
         v_vc_gzdw,
         v_vc_zydm,
         v_vc_hydm,
         v_vc_lxdh,
         v_vc_sfzh,
         v_vc_sznl,
         v_dt_hzcsrq,
         v_vc_whcd,
         v_vc_hzmz,
         v_vc_hzxb,
         v_vc_hzxm);
      v_vc_bgkid := sys_guid();
      --写入报告卡
      insert into zjjk_tnb_bgk
        (VC_ZDDW,
         vc_bksznl,
         dt_yyshsj,
         vc_sqsl,
         vc_bmi,
         vc_bkq,
         vc_bks,
         vc_bgkcode,
         vc_bgkzt,
         vc_mzh,
         vc_zyh,
         vc_sznl,
         vc_zgzddw,
         vc_cjyh,
         vc_xgyh,
         vc_shbz,
         vc_gldw,
         vc_xgdw,
         dt_xgsj,
         vc_cjdw,
         dt_cjsj,
         vc_sdqrzt,
         vc_scbz,
         vc_bszy,
         vc_swicdmc,
         vc_swicd10,
         vc_swyy,
         dt_swrq,
         vc_sfsw,
         dt_bgrq,
         vc_bgys,
         vc_bgdw,
         dt_sczdrq,
         nbthxhdb,
         nb_nwldb,
         nb_gysz,
         nb_e5ldlc,
         nb_e4hdlc,
         nb_zdgc,
         nb_xjptt,
         nb_sjxtz,
         nb_kfxtz,
         vc_zslcbxqt,
         vc_zslcbx,
         vc_ywbfz,
         vc_jzsrs,
         vc_tnbs,
         vc_wxyssg,
         vc_wxystz,
         vc_wxys,
         vc_tnblx,
         vc_icd10,
         vc_hzid,
         vc_bgklx,
         vc_bgkid,
         vc_wtzt)
      values
        (v_vc_zddw,
         v_vc_bksznl,
         v_sysdate,
         v_vc_sqsl,
         v_vc_bmi,
         v_vc_bkq,
         v_vc_bks,
         fun_getbgkcode(substr(v_vc_bgdw, 3)),
         v_vc_bgkzt,
         v_vc_mzh,
         v_vc_zyh,
         v_vc_sznl,
         v_vc_zgzddw,
         v_czyyhid,
         v_czyyhid,
         v_vc_shbz,
         v_vc_gldw,
         v_vc_xgdw,
         v_dt_xgsj,
         v_vc_cjdw,
         v_dt_cjsj,
         v_vc_sdqrzt,
         v_vc_scbz,
         v_vc_bszy,
         v_vc_swicdmc,
         v_vc_swicd10,
         v_vc_swyy,
         v_dt_swrq,
         v_vc_sfsw,
         v_dt_bgrq,
         v_vc_bgys,
         v_vc_bgdw,
         v_dt_sczdrq,
         v_nbthxhdb,
         v_nb_nwldb,
         v_nb_gysz,
         v_nb_e5ldlc,
         v_nb_e4hdlc,
         v_nb_zdgc,
         v_nb_xjptt,
         v_nb_sjxtz,
         v_nb_kfxtz,
         v_vc_zslcbxqt,
         v_vc_zslcbx,
         v_vc_ywbfz,
         v_vc_jzsrs,
         v_vc_tnbs,
         v_vc_wxyssg,
         v_vc_wxystz,
         v_vc_wxys,
         v_vc_tnblx,
         v_vc_icd10,
         v_vc_hzid,
         v_vc_bgklx,
         v_vc_bgkid,
         '0'); --委托状态全部为0，已取消委托
      --写入主副卡关系
      insert into zjjk_tnb_bgk_zfgx
        (vc_zkid, vc_fkid, vc_cjjg, vc_cjry, dt_cjsj)
      values
        (v_vc_bgkid, v_vc_bgkid, v_czyjgdm, v_czyyhid, v_sysdate);
    else
      --修改
      v_ywjl_czlx := '02';
      begin
        select vc_cfzt,
               vc_hzid,
               vc_shbz,
               b.vc_hkjd,
               b.vc_hkqx,
                             b.vc_hkjw,
                             b.vc_hkxxdz,
               a.vc_gldw,
               a.vc_sdqrzt,
               vc_bgkzt
          into v_vc_cfzt,
               v_vc_personid,
               v_vc_shbz,
               v_vc_hkjd_bgq,
               v_vc_hkqx_bgq,
                             v_vc_hkjw_bgq,
                             v_vc_hkxx_bgq,
               v_vc_gldw,
               v_vc_sdqrzt,
               v_vc_bgkzt
          from zjjk_tnb_bgk a, zjjk_tnb_hzxx b
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
        if (substr(v_vc_gldw, 1, 6) <> substr(v_czyjgdm, 1, 6)) and v_vc_gldw <> '99999999'  then
          v_err := '非管理单位无此操作权限!';
          raise err_custom;
        end if;
                if v_vc_cfzt in ('1', '3') then
                  if v_vc_hkjd_bgq <> v_vc_hkjd or v_vc_hkqx_bgq <> v_vc_hkqx 
                          /* OR v_vc_hkjw_bgq <> v_vc_hkjw OR v_vc_hkxx_bgq <> v_vc_hkxxdz */ THEN
                    v_err := '该报卡已初访，不能修改户籍地址!';
            raise err_custom;
          end if;
                END IF;
      end if;
      if v_czyjgjb = '4' then
        --医院社区
        /* 医院社区可以修改已初访的卡，前端限制只能修改 户籍地址和目前居住地址中的居委会和详细地址四个字段
        if v_vc_cfzt in ('1', '3') then
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
        if v_vc_hkjd_bgq <> v_vc_hkjd or v_vc_hkqx_bgq <> v_vc_hkqx then
          --审核状态改为医院通过
          v_vc_shbz := '1';
          --属地确认
          select count(1), wm_concat(a.code)
            into v_count, v_vc_gldw
            from organ_node a
           where a.removed = 0
             and a.description like '%' || v_vc_hkjd || '%';
          if v_count = 1 then
            --确定属地
            v_vc_sdqrzt := '1';
          else
            v_vc_gldw   := v_vc_hkqx;
            v_vc_sdqrzt := '0';
          end if;
          /*v_vc_gldw   := v_vc_hkqx;
          v_vc_sdqrzt := '0';*/
          --户口省
          v_vc_hkshen := Json_Str(v_Json_Data, 'vc_hkshen');
          --外省
          if v_vc_hkshen = '1' then
            v_vc_gldw   := '99999999';
            v_vc_hks    := '';
            v_vc_hkqx   := '';
            v_vc_hkjd   := '';
            v_vc_hks    := '';
            v_vc_hkjw   := '';
            v_vc_sdqrzt := '1';
          end if;
        end if;
      elsif v_czyjgjb = '3' then
        --区县修改
        v_vc_shbz := '3';
        --修改了户籍地址
        if v_vc_hkjd_bgq <> v_vc_hkjd or v_vc_hkqx_bgq <> v_vc_hkqx then
          --属地确认
          select count(1), wm_concat(a.code)
            into v_count, v_vc_gldw
            from organ_node a
           where a.removed = 0
             and a.description like '%' || v_vc_hkjd || '%';
          if v_count = 1 then
            --确定属地
            v_vc_sdqrzt := '1';
          else
            v_vc_gldw   := '';
            v_vc_sdqrzt := '0';
          end if;
          --户口省
          v_vc_hkshen := Json_Str(v_Json_Data, 'vc_hkshen');
          --外省
          if v_vc_hkshen = '1' then
            v_vc_gldw   := '99999999';
            v_vc_hks    := '';
            v_vc_hkqx   := '';
            v_vc_hkjd   := '';
            v_vc_hks    := '';
            v_vc_hkjw   := '';
            v_vc_sdqrzt := '1';
          end if;
        end if;
      else
        --非区县
        v_err := '当前机构无修改权限!';
        raise err_custom;
      end if;
      --死亡标志
      if v_vc_swyy is null then
        --未死亡
        v_vc_sfsw := '0';
        if v_vc_bgkzt = '7' then
          v_vc_bgkzt := '0';
        end if;
      elsif v_vc_swyy = '1' then
        --死亡原因为糖尿病
        v_vc_sfsw    := '1';
        v_vc_swicd10 := v_vc_icd10;
        v_vc_bgkzt   := '7';
      else
        v_vc_sfsw  := '1';
        v_vc_bgkzt := '7';
      end if;
      --获取变更前信息
      select *
        into v_tab_bgk_old
        from zjjk_tnb_bgk
       where vc_bgkid = v_vc_bgkid;
      select *
        into v_tab_hzxx_old
        from zjjk_tnb_hzxx
       where vc_personid = v_vc_personid;
      --修改报告卡
      update zjjk_tnb_bgk
         set vc_bgklx    = v_vc_bgklx,
             vc_icd10    = v_vc_icd10,
             vc_tnblx    = v_vc_tnblx,
             vc_wxys     = v_vc_wxys,
             vc_wxystz   = v_vc_wxystz,
             vc_wxyssg   = v_vc_wxyssg,
             vc_tnbs     = v_vc_tnbs,
             vc_jzsrs    = v_vc_jzsrs,
             vc_ywbfz    = v_vc_ywbfz,
             vc_zslcbx   = v_vc_zslcbx,
             vc_zslcbxqt = v_vc_zslcbxqt,
             nb_kfxtz    = v_nb_kfxtz,
             nb_sjxtz    = v_nb_sjxtz,
             nb_xjptt    = v_nb_xjptt,
             nb_zdgc     = v_nb_zdgc,
             nb_e4hdlc   = v_nb_e4hdlc,
             nb_e5ldlc   = v_nb_e5ldlc,
             nb_gysz     = v_nb_gysz,
             nb_nwldb    = v_nb_nwldb,
             nbthxhdb    = v_nbthxhdb,
             vc_bgys     = v_vc_bgys,
             dt_bgrq     = v_dt_bgrq,
             vc_sfsw     = v_vc_sfsw,
             dt_swrq     = v_dt_swrq,
             vc_swyy     = v_vc_swyy,
             vc_swicd10  = v_vc_swicd10,
             vc_swicdmc  = v_vc_swicdmc,
             vc_bszy     = v_vc_bszy,
             dt_xgsj     = v_sysdate,
             vc_xgdw     = v_czyjgdm,
             vc_xgyh     = v_czyyhid,
             vc_zgzddw   = v_vc_zgzddw,
             vc_sznl     = v_vc_sznl,
             vc_zyh      = v_vc_zyh,
             vc_mzh      = v_vc_mzh,
             vc_bmi      = v_vc_bmi,
             vc_bksznl   = v_vc_bksznl,
             vc_zddw     = v_vc_zddw,
             vc_gldw     = v_vc_gldw,
             dt_sczdrq   = v_dt_sczdrq,
             vc_sdqrzt   = v_vc_sdqrzt,
             vc_shbz     = v_vc_shbz,
             vc_bgkzt    = v_vc_bgkzt,
             dt_qxshsj = case
                           when v_vc_shbz = '3' and dt_qxshsj is null then
                            v_sysdate
                           else
                            dt_qxshsj
                         end
       where vc_bgkid = v_vc_bgkid
         and vc_scbz = '0';
      -- and nvl(vc_gldw, v_czyjgdm) like v_czyjgdm || '%';
      --修改患者信息
      update zjjk_tnb_hzxx
         set vc_hzxm   = v_vc_hzxm,
             vc_hzxb   = v_vc_hzxb,
             vc_hzmz   = v_vc_hzmz,
             vc_whcd   = v_vc_whcd,
             dt_hzcsrq = v_dt_hzcsrq,
             vc_sznl   = v_vc_sznl,
             vc_sfzh   = v_vc_sfzh,
             vc_lxdh   = v_vc_lxdh,
             vc_hydm   = v_vc_hydm,
             vc_zydm   = v_vc_zydm,
             vc_gzdw   = v_vc_gzdw,
             vc_hkshen = v_vc_hkshen,
             vc_hks    = v_vc_hks,
             vc_hkqx   = v_vc_hkqx,
             vc_hkjd   = v_vc_hkjd,
             vc_hkjw   = v_vc_hkjw,
             vc_hkxxdz = v_vc_hkxxdz,
             vc_jzds   = v_vc_jzds,
             vc_jzs    = v_vc_jzs,
             vc_jzqx   = v_vc_jzqx,
             vc_jzjd   = v_vc_jzjd,
             vc_jzjw   = v_vc_jzjw,
             vc_jzxxdz = v_vc_jzxxdz
       where vc_personid = v_vc_personid;
      --记录报卡变更日志
      v_ywrzid := sys_guid();
      --获取变更后信息
      select *
        into v_tab_bgk_new
        from zjjk_tnb_bgk
       where vc_bgkid = v_vc_bgkid;
      select *
        into v_tab_hzxx_new
        from zjjk_tnb_hzxx
       where vc_personid = v_vc_personid;
      --写入变更记录
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'vc_bgklx',
                                         '报告卡类别',
                                         v_tab_bgk_old.vc_bgklx,
                                         v_tab_bgk_new.vc_bgklx,
                                         'C_COMM_BGKLX',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'vc_icd10',
                                         '（ICD-10）',
                                         v_tab_bgk_old.vc_icd10,
                                         v_tab_bgk_new.vc_icd10,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'vc_tnblx',
                                         '糖尿病类型',
                                         v_tab_bgk_old.vc_tnblx,
                                         v_tab_bgk_new.vc_tnblx,
                                         'C_TNB_TNBLX',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'vc_wxys',
                                         '危险因素',
                                         v_tab_bgk_old.vc_wxys,
                                         v_tab_bgk_new.vc_wxys,
                                         'C_TNB_WXYS',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'vc_wxystz',
                                         '体重',
                                         v_tab_bgk_old.vc_wxystz,
                                         v_tab_bgk_new.vc_wxystz,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'vc_wxyssg',
                                         '身高',
                                         v_tab_bgk_old.vc_wxyssg,
                                         v_tab_bgk_new.vc_wxyssg,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'vc_tnbs',
                                         '糖尿病史',
                                         v_tab_bgk_old.vc_tnbs,
                                         v_tab_bgk_new.vc_tnbs,
                                         'C_TNB_TNBS',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'vc_jzsrs',
                                         '父母兄弟姐妹人数',
                                         v_tab_bgk_old.vc_jzsrs,
                                         v_tab_bgk_new.vc_jzsrs,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'vc_ywbfz',
                                         '并发症',
                                         v_tab_bgk_old.vc_ywbfz,
                                         v_tab_bgk_new.vc_ywbfz,
                                         'C_TNB_YWBFZ',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'vc_zslcbx',
                                         '主诉、临床表现',
                                         v_tab_bgk_old.vc_zslcbx,
                                         v_tab_bgk_new.vc_zslcbx,
                                         'C_TNB_LCBX',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'vc_zslcbxqt',
                                         '其他临床表现',
                                         v_tab_bgk_old.vc_zslcbxqt,
                                         v_tab_bgk_new.vc_zslcbxqt,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'nb_kfxtz',
                                         'E-1空腹血糖值(mmol/L)',
                                         v_tab_bgk_old.nb_kfxtz,
                                         v_tab_bgk_new.nb_kfxtz,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'nb_sjxtz',
                                         'E-2随机血糖值（mmol/L）',
                                         v_tab_bgk_old.nb_sjxtz,
                                         v_tab_bgk_new.nb_sjxtz,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'nb_xjptt',
                                         'E-3OGTT试验，2小时血浆葡糖糖水平（mmol/L）',
                                         v_tab_bgk_old.nb_xjptt,
                                         v_tab_bgk_new.nb_xjptt,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'nb_zdgc',
                                         'E-4总胆固醇（mmol/L）',
                                         v_tab_bgk_old.nb_zdgc,
                                         v_tab_bgk_new.nb_zdgc,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'nb_e4hdlc',
                                         'E-5HDL-C（mmol/L）',
                                         v_tab_bgk_old.nb_e4hdlc,
                                         v_tab_bgk_new.nb_e4hdlc,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'nb_e5ldlc',
                                         'E-6 LDL-C(mmol/L)',
                                         v_tab_bgk_old.nb_e5ldlc,
                                         v_tab_bgk_new.nb_e5ldlc,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'nb_gysz',
                                         'E-7 甘油三酯(mmol/L)',
                                         v_tab_bgk_old.nb_gysz,
                                         v_tab_bgk_new.nb_gysz,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'nb_nwldb',
                                         'E-8尿微量蛋白（mg/min）',
                                         v_tab_bgk_old.nb_nwldb,
                                         v_tab_bgk_new.nb_nwldb,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'nbthxhdb',
                                         'E-9糖化血红蛋白(%)',
                                         v_tab_bgk_old.nbthxhdb,
                                         v_tab_bgk_new.nbthxhdb,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'vc_bgys',
                                         '报告医师',
                                         v_tab_bgk_old.vc_bgys,
                                         v_tab_bgk_new.vc_bgys,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'dt_bgrq',
                                         '报告日期',
                                         dts(v_tab_bgk_old.dt_bgrq, 0),
                                         dts(v_tab_bgk_new.dt_bgrq, 0),
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'dt_swrq',
                                         '死亡日期',
                                         v_tab_bgk_old.dt_swrq,
                                         v_tab_bgk_new.dt_swrq,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'vc_swyy',
                                         'E-2随机血糖值（mmol/L）',
                                         v_tab_bgk_old.vc_swyy,
                                         v_tab_bgk_new.vc_swyy,
                                         'C_TNB_SWYY',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         '死亡icd10',
                                         'vc_swicd10',
                                         v_tab_bgk_old.vc_swicd10,
                                         v_tab_bgk_new.vc_swicd10,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'vc_swicdmc',
                                         '死亡icd名称',
                                         v_tab_bgk_old.vc_swicdmc,
                                         v_tab_bgk_new.vc_swicdmc,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'vc_bszy',
                                         '备注',
                                         v_tab_bgk_old.vc_bszy,
                                         v_tab_bgk_new.vc_bszy,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'vc_zgzddw',
                                         '最高诊断单位',
                                         v_tab_bgk_old.vc_zgzddw,
                                         v_tab_bgk_new.vc_zgzddw,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'vc_sznl',
                                         '发病年龄',
                                         v_tab_bgk_old.vc_sznl,
                                         v_tab_bgk_new.vc_sznl,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'vc_zyh',
                                         '住院号',
                                         v_tab_bgk_old.vc_zyh,
                                         v_tab_bgk_new.vc_zyh,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'vc_mzh',
                                         '门诊号',
                                         v_tab_bgk_old.vc_mzh,
                                         v_tab_bgk_new.vc_mzh,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'vc_bks',
                                         '报卡市',
                                         v_tab_bgk_old.vc_bks,
                                         v_tab_bgk_new.vc_bks,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'vc_bkq',
                                         '报卡区县',
                                         v_tab_bgk_old.vc_bkq,
                                         v_tab_bgk_new.vc_bkq,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'vc_bmi',
                                         'BMI',
                                         v_tab_bgk_old.vc_bmi,
                                         v_tab_bgk_new.vc_bmi,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'vc_bksznl',
                                         '实足年龄',
                                         v_tab_bgk_old.vc_bksznl,
                                         v_tab_bgk_new.vc_bksznl,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'vc_zddw',
                                         '最高诊断单位',
                                         v_tab_bgk_old.vc_zddw,
                                         v_tab_bgk_new.vc_zddw,
                                         'C_ZL_ZGZDDW',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'vc_gldw',
                                         '管理单位',
                                         v_tab_bgk_old.vc_gldw,
                                         v_tab_bgk_new.vc_gldw,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'dt_sczdrq',
                                         '首次诊断日期',
                                         dts(v_tab_bgk_old.dt_sczdrq, 0),
                                         dts(v_tab_bgk_new.dt_sczdrq, 0),
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'vc_sdqrzt',
                                         '属地确认状态',
                                         v_tab_bgk_old.vc_sdqrzt,
                                         v_tab_bgk_new.vc_sdqrzt,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'vc_shbz',
                                         '审核标志',
                                         v_tab_bgk_old.vc_shbz,
                                         v_tab_bgk_new.vc_shbz,
                                         'C_COMM_SHZT',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'vc_bgkzt',
                                         '报告卡状态',
                                         v_tab_bgk_old.vc_bgkzt,
                                         v_tab_bgk_new.vc_bgkzt,
                                         'C_COMM_BGKZT',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'vc_hzxm',
                                         '姓名',
                                         v_tab_hzxx_old.vc_hzxm,
                                         v_tab_hzxx_new.vc_hzxm,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'vc_hzxb',
                                         '性别',
                                         v_tab_hzxx_old.vc_hzxb,
                                         v_tab_hzxx_new.vc_hzxb,
                                         'C_COMM_XB',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'vc_hzmz',
                                         '民族',
                                         v_tab_hzxx_old.vc_hzmz,
                                         v_tab_hzxx_new.vc_hzmz,
                                         'C_COMM_MZ',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'vc_whcd',
                                         '文化程度',
                                         v_tab_hzxx_old.vc_whcd,
                                         v_tab_hzxx_new.vc_whcd,
                                         'C_COMM_WHCD',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'vc_hzxm',
                                         '姓名',
                                         v_tab_hzxx_old.vc_hzxm,
                                         v_tab_hzxx_new.vc_hzxm,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'dt_hzcsrq',
                                         '出生日期',
                                         dts(v_tab_hzxx_old.dt_hzcsrq, 0),
                                         dts(v_tab_hzxx_new.dt_hzcsrq, 0),
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'vc_sznl',
                                         '发病年龄',
                                         v_tab_hzxx_old.vc_sznl,
                                         v_tab_hzxx_new.vc_sznl,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'vc_sfzh',
                                         '身份证号',
                                         v_tab_hzxx_old.vc_sfzh,
                                         v_tab_hzxx_new.vc_sfzh,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'vc_lxdh',
                                         '联系电话',
                                         v_tab_hzxx_old.vc_lxdh,
                                         v_tab_hzxx_new.vc_lxdh,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'vc_hydm',
                                         '行业',
                                         v_tab_hzxx_old.vc_hydm,
                                         v_tab_hzxx_new.vc_hydm,
                                         'C_COMM_HY',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'vc_hzxm',
                                         '姓名',
                                         v_tab_hzxx_old.vc_hzxm,
                                         v_tab_hzxx_new.vc_hzxm,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'vc_zydm',
                                         '职业',
                                         v_tab_hzxx_old.vc_zydm,
                                         v_tab_hzxx_new.vc_zydm,
                                         'C_COMM_ZY',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'vc_gzdw',
                                         '工作单位',
                                         v_tab_hzxx_old.vc_gzdw,
                                         v_tab_hzxx_new.vc_gzdw,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'vc_hkshen',
                                         '户口省',
                                         v_tab_hzxx_old.vc_hkshen,
                                         v_tab_hzxx_new.vc_hkshen,
                                         'C_COMM_SHEDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'vc_hks',
                                         '户口市',
                                         v_tab_hzxx_old.vc_hks,
                                         v_tab_hzxx_new.vc_hks,
                                         'P_XZDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'vc_hkqx',
                                         '户口区县',
                                         v_tab_hzxx_old.vc_hkqx,
                                         v_tab_hzxx_new.vc_hkqx,
                                         'P_XZDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'vc_hkjd',
                                         '户口街道',
                                         v_tab_hzxx_old.vc_hkjd,
                                         v_tab_hzxx_new.vc_hkjd,
                                         'P_XZDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'vc_hkjw',
                                         '户口居委',
                                         v_tab_hzxx_old.vc_hkjw,
                                         v_tab_hzxx_new.vc_hkjw,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'vc_hkxxdz',
                                         '户口详细地址',
                                         v_tab_hzxx_old.vc_hkxxdz,
                                         v_tab_hzxx_new.vc_hkxxdz,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'vc_jzds',
                                         '居住地省',
                                         v_tab_hzxx_old.vc_jzds,
                                         v_tab_hzxx_new.vc_jzds,
                                         'C_COMM_SHEDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'vc_jzs',
                                         '居住市',
                                         v_tab_hzxx_old.vc_jzs,
                                         v_tab_hzxx_new.vc_jzs,
                                         'P_XZDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'vc_jzqx',
                                         '居住区县',
                                         v_tab_hzxx_old.vc_jzqx,
                                         v_tab_hzxx_new.vc_jzqx,
                                         'P_XZDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'vc_jzjd',
                                         '居住街道',
                                         v_tab_hzxx_old.vc_jzjd,
                                         v_tab_hzxx_new.vc_jzjd,
                                         'P_XZDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'vc_jzjw',
                                         '居住居委',
                                         v_tab_hzxx_old.vc_jzjw,
                                         v_tab_hzxx_new.vc_jzjw,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '01',
                                         'vc_jzxxdz',
                                         '居住详细地址',
                                         v_tab_hzxx_old.vc_jzxxdz,
                                         v_tab_hzxx_new.vc_jzxxdz,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      if v_err is not null then
        raise err_custom;
      end if;
    end if;
    --记录日志
    v_json_yw_log := Json_ext.get_json(v_json_data, 'ywjllog');
    if v_json_yw_log is not null then
      v_json_yw_log.put('ywrzid', v_ywrzid);
      v_json_yw_log.put('bgkid', v_vc_bgkid);
      v_json_yw_log.put('bgklx', '01');
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
  
    v_Json_Return.put('id', v_vc_bgkid);
    result_out := Return_Succ_Json(v_json_return);
  
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_tnbbgk_update;
  /*--------------------------------------------------------------------------
  || 功能描述 ：获取报告卡编码
  ||------------------------------------------------------------------------*/
  FUNCTION fun_getbgkcode(prm_sqyym VARCHAR2) --市区及医院码
   RETURN VARCHAR2 is
    v_code ZJJK_TNB_BGK.Vc_Bgkcode%type;
    v_dm   VARCHAR2(30);
  begin
    if prm_sqyym is null then
      return '';
    end if;
    v_dm := to_char(sysdate, 'yy') || prm_sqyym;
    select case
             when max(substr(VC_BGKCODE, 0, 14)) is null then
              v_dm || '00001'
             else
              to_char(max(substr(VC_BGKCODE, 0, 14)) + 1)
           end
      into v_code
      from ZJJK_TNB_BGK
     where VC_BGKCODE like v_dm || '%'
       and length(VC_BGKCODE) = 14
       and stn(VC_BGKCODE, 1) is not null;
  
    return v_code;
  END fun_getbgkcode;
  /*--------------------------------------------------------------------------
  || 功能描述 ：糖尿病报告卡删除
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_tnbbgk_sc(Data_In    In Clob, --入参
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
    v_cfzt    zjjk_tnb_bgk.vc_cfzt%type;
    v_bkid    zjjk_tnb_bgk.vc_bgkid%type;
    v_scbz    zjjk_tnb_bgk.vc_scbz%TYPE; --删除标志
    v_vc_gldw zjjk_tnb_bgk.vc_gldw%TYPE;
  BEGIN
    json_data(data_in, 'zjjk_tnb_bgk状态更新', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    --获取机构级别
    --select fun_getczyjgjb(v_czyjgdm) into v_czyjgjb from dual;
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    v_bkid    := Json_Str(v_Json_Data, 'vc_bgkid');
    --获取报卡状态
    begin
      select vc_cfzt, vc_scbz, vc_gldw
        into v_cfzt, v_scbz, v_vc_gldw
        from zjjk_tnb_bgk
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
    update zjjk_tnb_bgk
       set vc_scbz = '1', vc_bgkzt = '5', dt_xgsj = sysdate
     where vc_bgkid = v_bkid;
    v_Json_Return.put('id', v_bkid);
    result_out    := Return_Succ_Json(v_json_return);
    v_json_yw_log := Json_ext.get_json(v_json_data, 'ywjllog');
    if v_json_yw_log is not null then
      v_json_yw_log.put('bgkid', v_bkid);
      v_json_yw_log.put('bgklx', '01');
      v_json_yw_log.put('ywjlid', v_bkid);
      v_json_yw_log.put('gnmk', '01');
      v_json_yw_log.put('gnmc', '报告卡删除');
      v_json_yw_log.put('czlx', '04');
      v_json_yw_log.put('ywjlid', v_bkid);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_update(v_json_yw_log, v_err);
      if v_err is not null then
        raise err_custom;
      end if;
    end if;
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_tnbbgk_sc;
  /*--------------------------------------------------------------------------
  || 功能描述 ：糖尿病报告卡审核
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_tnbbgk_sh(Data_In    In Clob, --入参
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
    v_shbz       zjjk_tnb_bgk.vc_shbz%TYPE; --审核状态
    v_shbz_table zjjk_tnb_bgk.vc_shbz%TYPE; --审核状态
    v_bkid       zjjk_tnb_bgk.vc_bgkid%type;
    v_shwtgyy    zjjk_tnb_bgk.vc_shwtgyy%TYPE; --区县审核未通过原因选项
    v_shwtgyy1   zjjk_tnb_bgk.vc_shwtgyy1%TYPE; --区县审核未通过原因
    v_vc_gldw    zjjk_tnb_bgk.vc_gldw%TYPE; --区县审核未通过原因
  BEGIN
    json_data(data_in, 'zjjk_tnb_bgk审核', v_json_data);
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
        from zjjk_tnb_bgk
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
    update zjjk_tnb_bgk
       set vc_shbz     = v_shbz,
           vc_shwtgyy  = v_shwtgyy,
           vc_shwtgyy1 = v_shwtgyy1,
           dt_qxshsj   = v_sysdate,
           dt_xgsj     = sysdate
     where vc_bgkid = v_bkid;
    v_json_yw_log := Json_ext.get_json(v_json_data, 'ywjllog');
    if v_json_yw_log is not null then
      v_json_yw_log.put('bgkid', v_bkid);
      v_json_yw_log.put('bgklx', '01');
      v_json_yw_log.put('ywjlid', v_bkid);
      v_json_yw_log.put('gnmk', '01');
      v_json_yw_log.put('gnmc', '报告卡审核');
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
  END prc_tnbbgk_sh;
  /*--------------------------------------------------------------------------
  || 功能描述 ：糖尿病报告卡属地确认
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_tnbbgk_sdqr(Data_In    In Clob, --入参
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
    v_bkid    zjjk_tnb_bgk.vc_bgkid%type;
    v_gldw    zjjk_tnb_bgk.vc_gldw%type;
    v_count   number;
  BEGIN
    json_data(data_in, 'zjjk_tnb_bgk属地确认', v_json_data);
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
      from zjjk_tnb_bgk a, zjjk_tnb_hzxx b, organ_node c
     where a.vc_hzid = b.vc_personid
       and c.description like '%' || b.vc_hkjd || '%'
       and c.code = v_gldw
       and c.removed = 0
       and a.vc_bgkid = v_bkid;
    if v_count <> 1 then
      v_err := '管理单位与户籍街道不匹配!';
      raise err_custom;
    end if;
    --修改管理单位
    update zjjk_tnb_bgk a
       set a.vc_gldw = v_gldw, a.vc_sdqrzt = '1', dt_xgsj = sysdate
     where a.vc_scbz = '0'
       and a.vc_shbz = '3'
       and a.vc_bgkid = v_bkid
       and a.vc_sdqrzt = '0';
    if sql%rowcount <> 1 then
      v_err := 'id[' || v_bkid || ']未获取到有效的待属地确认的告卡信息!';
      raise err_custom;
    end if;
    v_json_yw_log := Json_ext.get_json(v_json_data, 'ywjllog');
    if v_json_yw_log is not null then
      v_json_yw_log.put('bgkid', v_bkid);
      v_json_yw_log.put('bgklx', '01');
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
  END prc_tnbbgk_sdqr;
  /*--------------------------------------------------------------------------
  || 功能描述 ：糖尿病报告卡新增及修改
  ||------------------------------------------------------------------------*/
  procedure prc_tnbbgk_cfsf_update(Data_In    In Clob, --入参
                                   result_out OUT VARCHAR2) --返回
   is
    sfk_vc_sfkid         zjjk_tnb_sfk.vc_sfkid%TYPE;
    sfk_vc_bgkid         zjjk_tnb_sfk.vc_bgkid%TYPE;
    sfk_vc_hzid          zjjk_tnb_sfk.vc_hzid%TYPE;
    sfk_dt_sfrq          zjjk_tnb_sfk.dt_sfrq%TYPE;
    sfk_vc_sfys          zjjk_tnb_sfk.vc_sfys%TYPE;
    sfk_vc_hksfqc        zjjk_tnb_sfk.vc_hksfqc%TYPE;
    sfk_vc_hkqcs         zjjk_tnb_sfk.vc_hkqcs%TYPE;
    sfk_vc_hkqcshi       zjjk_tnb_sfk.vc_hkqcshi%TYPE;
    sfk_vc_hkqcjw        zjjk_tnb_sfk.vc_hkqcjw%TYPE;
    sfk_vc_hkqcxx        zjjk_tnb_sfk.vc_hkqcxx%TYPE;
    sfk_dt_hkqcrq        zjjk_tnb_sfk.dt_hkqcrq%TYPE;
    sfk_dt_scjzrq        zjjk_tnb_sfk.dt_scjzrq%TYPE;
    sfk_vc_bfz           zjjk_tnb_sfk.vc_bfz%TYPE;
    sfk_dt_swrq          zjjk_tnb_sfk.dt_swrq%TYPE;
    sfk_vc_swyy          zjjk_tnb_sfk.vc_swyy%TYPE;
    sfk_vc_swicd         zjjk_tnb_sfk.vc_swicd%TYPE;
    sfk_vc_swmc          zjjk_tnb_sfk.vc_swmc%TYPE;
    sfk_vc_swdd          zjjk_tnb_sfk.vc_swdd%TYPE;
    sfk_nb_scqn          zjjk_tnb_sfk.nb_scqn%TYPE;
    sfk_nb_scqy          zjjk_tnb_sfk.nb_scqy%TYPE;
    sfk_vc_clxt          zjjk_tnb_sfk.vc_clxt%TYPE;
    sfk_vc_zjycxtlx      zjjk_tnb_sfk.vc_zjycxtlx%TYPE;
    sfk_nb_zjycxtz       zjjk_tnb_sfk.nb_zjycxtz%TYPE;
    sfk_dt_clsj          zjjk_tnb_sfk.dt_clsj%TYPE;
    sfk_vc_bfzlx         zjjk_tnb_sfk.vc_bfzlx%TYPE;
    sfk_dt_bfzqt         zjjk_tnb_sfk.dt_bfzqt%TYPE;
    sfk_dt_szbbkssj      zjjk_tnb_sfk.dt_szbbkssj%TYPE;
    sfk_dt_szbbqzsj      zjjk_tnb_sfk.dt_szbbqzsj%TYPE;
    sfk_dt_sjbbkssj      zjjk_tnb_sfk.dt_sjbbkssj%TYPE;
    sfk_dt_sjbbqzsj      zjjk_tnb_sfk.dt_sjbbqzsj%TYPE;
    sfk_dt_xgbbkssj      zjjk_tnb_sfk.dt_xgbbkssj%TYPE;
    sfk_dt_xgbbqzsj      zjjk_tnb_sfk.dt_xgbbqzsj%TYPE;
    sfk_dt_swmbbkssj     zjjk_tnb_sfk.dt_swmbbkssj%TYPE;
    sfk_dt_swmbbqzsj     zjjk_tnb_sfk.dt_swmbbqzsj%TYPE;
    sfk_dt_pfgrkssj      zjjk_tnb_sfk.dt_pfgrkssj%TYPE;
    sfk_dt_pfgrqzsj      zjjk_tnb_sfk.dt_pfgrqzsj%TYPE;
    sfk_dt_qtbbkssj      zjjk_tnb_sfk.dt_qtbbkssj%TYPE;
    sfk_dt_qtbbqzsj      zjjk_tnb_sfk.dt_qtbbqzsj%TYPE;
    sfk_dt_cxglrq        zjjk_tnb_sfk.dt_cxglrq%TYPE;
    sfk_vc_cxglyy        zjjk_tnb_sfk.vc_cxglyy%TYPE;
    sfk_vc_cxglyyqt      zjjk_tnb_sfk.vc_cxglyyqt%TYPE;
    sfk_vc_bf            zjjk_tnb_sfk.vc_bf%TYPE;
    sfk_vc_fyqk          zjjk_tnb_sfk.vc_fyqk%TYPE;
    sfk_vc_yds           zjjk_tnb_sfk.vc_yds%TYPE;
    sfk_vc_scbz          zjjk_tnb_sfk.vc_scbz%TYPE;
    sfk_vc_cjyh          zjjk_tnb_sfk.vc_cjyh%TYPE;
    sfk_vc_cjdw          zjjk_tnb_sfk.vc_cjdw%TYPE;
    sfk_dt_cjsj          zjjk_tnb_sfk.dt_cjsj%TYPE;
    sfk_dt_xgsj          zjjk_tnb_sfk.dt_xgsj%TYPE;
    sfk_vc_xgdw          zjjk_tnb_sfk.vc_xgdw%TYPE;
    sfk_vc_hkqcqx        zjjk_tnb_sfk.vc_hkqcqx%TYPE;
    sfk_vc_hkqcjd        zjjk_tnb_sfk.vc_hkqcjd%TYPE;
    sfk_vc_jxbfz         zjjk_tnb_sfk.vc_jxbfz%TYPE;
    sfk_dt_sczzrq        zjjk_tnb_sfk.dt_sczzrq%TYPE;
    sfk_vc_jxbfzlx       zjjk_tnb_sfk.vc_jxbfzlx%TYPE;
    sfk_vc_tnbtszdsj     zjjk_tnb_sfk.vc_tnbtszdsj%TYPE;
    sfk_vc_tnbrszdsj     zjjk_tnb_sfk.vc_tnbrszdsj%TYPE;
    sfk_vc_tnbftszdsj    zjjk_tnb_sfk.vc_tnbftszdsj%TYPE;
    sfk_vc_tnbdxtzsj     zjjk_tnb_sfk.vc_tnbdxtzsj%TYPE;
    sfk_vc_zlqk          zjjk_tnb_sfk.vc_zlqk%TYPE;
    sfk_dt_gxybkssj      zjjk_tnb_sfk.dt_gxybkssj%TYPE;
    sfk_dt_gxybqzsj      zjjk_tnb_sfk.dt_gxybqzsj%TYPE;
    sfk_dt_xjgsbkssj     zjjk_tnb_sfk.dt_xjgsbkssj%TYPE;
    sfk_dt_xjgsbqzsj     zjjk_tnb_sfk.dt_xjgsbqzsj%TYPE;
    sfk_nb_zjycxtzch     zjjk_tnb_sfk.nb_zjycxtzch%TYPE;
    sfk_nb_tz            zjjk_tnb_sfk.nb_tz%TYPE;
    sfk_vc_jcxm          zjjk_tnb_sfk.vc_jcxm%TYPE;
    sfk_vc_mqqk          zjjk_tnb_sfk.vc_mqqk%TYPE;
    sfk_vc_bz            zjjk_tnb_sfk.vc_bz%TYPE;
    sfk_vc_gxbz          zjjk_tnb_sfk.vc_gxbz%TYPE;
    sfk_vc_hjhs          zjjk_tnb_sfk.vc_hjhs%TYPE;
    sfk_vc_hjwhsyy       zjjk_tnb_sfk.vc_hjwhsyy%TYPE;
    sfk_vc_jzdhs         zjjk_tnb_sfk.vc_jzdhs%TYPE;
    sfk_vc_jzdwhsyy      zjjk_tnb_sfk.vc_jzdwhsyy%TYPE;
    sfk_vc_id            zjjk_tnb_sfk.vc_id%TYPE;
    sfk_vc_sflx          zjjk_tnb_sfk.vc_sflx%TYPE;
    sfk_vc_ispass        zjjk_tnb_sfk.vc_ispass%TYPE;
    sfk_upload_areaeport zjjk_tnb_sfk.upload_areaeport%TYPE;
    sfk_vc_brsftnb       zjjk_tnb_sfk.vc_brsftnb%TYPE;
    sfk_vc_sfzh          zjjk_tnb_sfk.vc_sfzh%TYPE;
  
    --公共变量
    sfk_fl          VARCHAR2(1); -- 随访卡分类 1为初访卡 2为随访卡
    sfk_json_data   json;
    v_json_yw_log   json;
    v_ywjl_czlx     varchar2(3);
    sfk_json_return json := json();
    err_custom EXCEPTION;
    sfk_err     VARCHAR2(2000);
    sfk_sysdate date;
    --定义个人基本信息
    hz_vc_sfzh   zjjk_tnb_hzxx.vc_sfzh%type;
    hz_vc_hkshen zjjk_tnb_hzxx.vc_hkshen%type;
    hz_vc_hks    zjjk_tnb_hzxx.vc_hks%type;
    hz_vc_hkqx   zjjk_tnb_hzxx.vc_hkqx%type;
    hz_vc_hkjd   zjjk_tnb_hzxx.vc_hkjd%type;
    hz_vc_hkjw   zjjk_tnb_hzxx.vc_hkjw%type;
    hz_vc_hkxxdz zjjk_tnb_hzxx.vc_hkxxdz%type;
    --定义相关的糖尿病报告卡字段
    bgk_vc_hzid    zjjk_tnb_bgk.vc_hzid%type;
    bgk_vc_hkhs    zjjk_tnb_bgk.vc_hkhs%type;
    bgk_vc_jzhs    zjjk_tnb_bgk.vc_jzhs%type;
    bgk_vc_qcqxdm  zjjk_tnb_bgk.vc_qcqxdm%type;
    bgk_vc_qcjw    zjjk_tnb_bgk.vc_qcjw%type;
    bgk_vc_qcjddm  zjjk_tnb_bgk.vc_qcjddm%type;
    bgk_vc_qcxxdz  zjjk_tnb_bgk.vc_qcxxdz%type;
    bgk_vc_qcsdm   zjjk_tnb_bgk.vc_qcsdm%type;
    bgk_dt_qcsj    zjjk_tnb_bgk.dt_qcsj%type;
    bgk_vc_hkwhsyy zjjk_tnb_bgk.vc_hkwhsyy%type;
    bgk_vc_jzwhsyy zjjk_tnb_bgk.vc_jzwhsyy%type;
    bgk_vc_cxgl    zjjk_tnb_bgk.vc_cxgl%type; -- 是否撤销管理 1 是 2 否
    bgk_dt_sczdrq  zjjk_tnb_bgk.dt_sczdrq%type; -- 首次确诊日期
    bgk_vc_qybz    zjjk_tnb_bgk.vc_qybz%type; --迁移标志
    bgk_vc_bgkzt   zjjk_tnb_bgk.vc_bgkzt%type; -- 是否报告卡状态
    bgk_vc_sfsw    zjjk_tnb_bgk.vc_sfsw%type; -- 是否死亡
    bgk_vc_cfzt    zjjk_tnb_bgk.vc_cfzt%type; -- 是否初访  默认 0 未初访
    bgk_dt_cfsj    zjjk_tnb_bgk.dt_cfsj%type; -- 初访时间
    bgk_dt_sfsj    zjjk_tnb_bgk.dt_sfsj%type; -- 随访时间
    bgk_vc_swyy    zjjk_tnb_bgk.vc_swyy%type; --死亡原因
    bgk_dt_swrq    zjjk_tnb_bgk.dt_swrq%type; --死亡日期
    
    v_count     number;
    v_vc_gldw   varchar2(100);
    v_vc_sdqrzt varchar2(10);
  BEGIN
    json_data(Data_In, 'zjjk_tnb_Sfk新增修改', sfk_json_data);
    sfk_sysdate := sysdate;
    sfk_fl      := json_str(sfk_Json_Data, 'sfk_fl');
  
    --初随访卡赋值
    sfk_vc_sfkid         := json_str(sfk_Json_Data, 'vc_sfkid');
    sfk_vc_bgkid         := json_str(sfk_Json_Data, 'vc_bgkid');
    sfk_vc_hzid          := json_str(sfk_Json_Data, 'vc_hzid');
    sfk_dt_sfrq          := std(json_str(sfk_Json_Data, 'dt_sfrq'));
    sfk_vc_sfys          := json_str(sfk_Json_Data, 'vc_sfys');
    sfk_vc_hksfqc        := json_str(sfk_Json_Data, 'vc_hksfqc');
    sfk_vc_hkqcs         := json_str(sfk_Json_Data, 'vc_hkqcs');
    sfk_vc_hkqcshi       := json_str(sfk_Json_Data, 'vc_hkqcshi');
    sfk_vc_hkqcjw        := json_str(sfk_Json_Data, 'vc_hkqcjw');
    sfk_vc_hkqcxx        := json_str(sfk_Json_Data, 'vc_hkqcxx');
    sfk_dt_hkqcrq        := std(json_str(sfk_Json_Data, 'dt_hkqcrq'));
    sfk_dt_scjzrq        := std(json_str(sfk_Json_Data, 'dt_scjzrq'));
    sfk_vc_bfz           := json_str(sfk_Json_Data, 'vc_bfz');
    sfk_dt_swrq          := std(json_str(sfk_Json_Data, 'dt_swrq'));
    sfk_vc_swyy          := json_str(sfk_Json_Data, 'vc_swyy');
    sfk_vc_swicd         := json_str(sfk_Json_Data, 'vc_swicd');
    sfk_vc_swmc          := json_str(sfk_Json_Data, 'vc_swmc');
    sfk_vc_swdd          := json_str(sfk_Json_Data, 'vc_swdd');
    sfk_nb_scqn          := json_str(sfk_Json_Data, 'nb_scqn');
    sfk_nb_scqy          := json_str(sfk_Json_Data, 'nb_scqy');
    sfk_vc_clxt          := json_str(sfk_Json_Data, 'vc_clxt');
    sfk_vc_zjycxtlx      := json_str(sfk_Json_Data, 'vc_zjycxtlx');
    sfk_nb_zjycxtz       := json_str(sfk_Json_Data, 'nb_zjycxtz');
    sfk_dt_clsj          := std(json_str(sfk_Json_Data, 'dt_clsj'));
    sfk_vc_bfzlx         := json_str(sfk_Json_Data, 'vc_bfzlx');
    sfk_dt_bfzqt         := json_str(sfk_Json_Data, 'dt_bfzqt');
    sfk_dt_szbbkssj      := std(json_str(sfk_Json_Data, 'dt_szbbkssj'));
    sfk_dt_szbbqzsj      := std(json_str(sfk_Json_Data, 'dt_szbbqzsj'));
    sfk_dt_sjbbkssj      := std(json_str(sfk_Json_Data, 'dt_sjbbkssj'));
    sfk_dt_sjbbqzsj      := std(json_str(sfk_Json_Data, 'dt_sjbbqzsj'));
    sfk_dt_xgbbkssj      := std(json_str(sfk_Json_Data, 'dt_xgbbkssj'));
    sfk_dt_xgbbqzsj      := std(json_str(sfk_Json_Data, 'dt_xgbbqzsj'));
    sfk_dt_swmbbkssj     := std(json_str(sfk_Json_Data, 'dt_swmbbkssj'));
    sfk_dt_swmbbqzsj     := std(json_str(sfk_Json_Data, 'dt_swmbbqzsj'));
    sfk_dt_pfgrkssj      := std(json_str(sfk_Json_Data, 'dt_pfgrkssj'));
    sfk_dt_pfgrqzsj      := std(json_str(sfk_Json_Data, 'dt_pfgrqzsj'));
    sfk_dt_qtbbkssj      := std(json_str(sfk_Json_Data, 'dt_qtbbkssj'));
    sfk_dt_qtbbqzsj      := std(json_str(sfk_Json_Data, 'dt_qtbbqzsj'));
    sfk_dt_cxglrq        := std(json_str(sfk_Json_Data, 'dt_cxglrq'));
    sfk_vc_cxglyy        := json_str(sfk_Json_Data, 'vc_cxglyy');
    sfk_vc_cxglyyqt      := json_str(sfk_Json_Data, 'vc_cxglyyqt');
    sfk_vc_bf            := json_str(sfk_Json_Data, 'vc_bf');
    sfk_vc_fyqk          := json_str(sfk_Json_Data, 'vc_fyqk');
    sfk_vc_yds           := json_str(sfk_Json_Data, 'vc_yds');
    sfk_vc_scbz          := json_str(sfk_Json_Data, 'vc_scbz');
    sfk_vc_cjyh          := json_str(sfk_Json_Data, 'vc_cjyh');
    sfk_vc_cjdw          := json_str(sfk_Json_Data, 'vc_cjdw');
    sfk_dt_cjsj          := sfk_sysdate;
    sfk_dt_xgsj          := sfk_sysdate;
    sfk_vc_xgdw          := json_str(sfk_Json_Data, 'vc_xgdw');
    sfk_vc_hkqcqx        := json_str(sfk_Json_Data, 'vc_hkqcqx');
    sfk_vc_hkqcjd        := json_str(sfk_Json_Data, 'vc_hkqcjd');
    sfk_vc_jxbfz         := json_str(sfk_Json_Data, 'vc_jxbfz');
    sfk_dt_sczzrq        := std(json_str(sfk_Json_Data, 'dt_sczzrq'));
    sfk_vc_jxbfzlx       := json_str(sfk_Json_Data, 'vc_jxbfzlx');
    sfk_vc_tnbtszdsj     := std(json_str(sfk_Json_Data, 'vc_tnbtszdsj'));
    sfk_vc_tnbrszdsj     := std(json_str(sfk_Json_Data, 'vc_tnbrszdsj'));
    sfk_vc_tnbftszdsj    := std(json_str(sfk_Json_Data, 'vc_tnbftszdsj'));
    sfk_vc_tnbdxtzsj     := std(json_str(sfk_Json_Data, 'vc_tnbdxtzsj'));
    sfk_vc_zlqk          := json_str(sfk_Json_Data, 'vc_zlqk');
    sfk_dt_gxybkssj      := std(json_str(sfk_Json_Data, 'dt_gxybkssj'));
    sfk_dt_gxybqzsj      := std(json_str(sfk_Json_Data, 'dt_gxybqzsj'));
    sfk_dt_xjgsbkssj     := std(json_str(sfk_Json_Data, 'dt_xjgsbkssj'));
    sfk_dt_xjgsbqzsj     := std(json_str(sfk_Json_Data, 'dt_xjgsbqzsj'));
    sfk_nb_zjycxtzch     := json_str(sfk_Json_Data, 'nb_zjycxtzch');
    sfk_nb_tz            := json_str(sfk_Json_Data, 'nb_tz');
    sfk_vc_jcxm          := json_str(sfk_Json_Data, 'vc_jcxm');
    sfk_vc_mqqk          := json_str(sfk_Json_Data, 'vc_mqqk');
    sfk_vc_bz            := json_str(sfk_Json_Data, 'vc_bz');
    sfk_vc_gxbz          := json_str(sfk_Json_Data, 'vc_gxbz');
    sfk_vc_hjhs          := json_str(sfk_Json_Data, 'vc_hjhs');
    sfk_vc_hjwhsyy       := json_str(sfk_Json_Data, 'vc_hjwhsyy');
    sfk_vc_jzdhs         := json_str(sfk_Json_Data, 'vc_jzdhs');
    sfk_vc_jzdwhsyy      := json_str(sfk_Json_Data, 'vc_jzdwhsyy');
    sfk_vc_id            := json_str(sfk_Json_Data, 'vc_id');
    sfk_vc_sflx          := json_str(sfk_Json_Data, 'vc_sflx');
    sfk_vc_ispass        := json_str(sfk_Json_Data, 'vc_ispass');
    sfk_upload_areaeport := json_str(sfk_Json_Data, 'upload_areaeport');
    sfk_vc_brsftnb       := json_str(sfk_Json_Data, 'vc_brsftnb');
    sfk_vc_sfzh          := json_str(sfk_Json_Data, 'vc_sfzh');
    --初随访卡赋值
    --初始化糖尿病报卡的数据项
    if (sfk_vc_bgkid is not null) then
      --初始化赋值相应的报卡项值
      select vc_hkhs,
             vc_jzhs,
             vc_hzid,
             vc_qcqxdm,
             vc_qcjw,
             vc_qcjddm,
             vc_qcxxdz,
             vc_qcsdm,
             dt_qcsj,
             vc_hkwhsyy,
             vc_jzwhsyy,
             vc_cxgl,
             dt_sczdrq,
             vc_qybz,
             vc_bgkzt,
             vc_sfsw,
             vc_cfzt,
             dt_cfsj,
             dt_sfsj,
             vc_swyy,
             dt_swrq
        into bgk_vc_hkhs,
             bgk_vc_jzhs,
             bgk_vc_hzid,
             bgk_vc_qcqxdm,
             bgk_vc_qcjw,
             bgk_vc_qcjddm,
             bgk_vc_qcxxdz,
             bgk_vc_qcsdm,
             bgk_dt_qcsj,
             bgk_vc_hkwhsyy,
             bgk_vc_jzwhsyy,
             bgk_vc_cxgl,
             bgk_dt_sczdrq,
             bgk_vc_qybz,
             bgk_vc_bgkzt,
             bgk_vc_sfsw,
             bgk_vc_cfzt,
             bgk_dt_cfsj,
             bgk_dt_sfsj,
             bgk_vc_swyy,
             bgk_dt_swrq
        from zjjk_tnb_bgk
       where vc_bgkid = sfk_vc_bgkid;
    else
      sfk_err := '糖尿病报告卡id不能为空！';
      raise err_custom;
    end if;
    if bgk_vc_hzid is not null then
      --户籍信息赋值
      select vc_sfzh,
             vc_hkshen,
             vc_hks,
             vc_hkqx,
             vc_hkjd,
             vc_hkjw,
             vc_hkxxdz
        into hz_vc_sfzh,
             hz_vc_hkshen,
             hz_vc_hks,
             hz_vc_hkqx,
             hz_vc_hkjd,
             hz_vc_hkjw,
             hz_vc_hkxxdz
        from zjjk_tnb_hzxx
       where vc_personid = bgk_vc_hzid;
    else
      sfk_err := '糖尿病报告卡未能关联相应的患者信息！';
      raise err_custom;
    end if;
    --区分开新增或者修改
    if sfk_vc_sfkid is null then
      --新增初访或者随访
      sfk_vc_sfkid := sys_guid();
      --对随访卡的患者id赋值
      sfk_vc_hzid := bgk_vc_hzid;
      --再次判断是初访还是随访 分别做数据项校验
      if (sfk_fl = '1') then
        --初访数据项校验
        if (sfk_vc_cxglyy is null or sfk_vc_cxglyy <> '2') and sfk_vc_brsftnb is null then
          sfk_err := '本人是否患有糖尿病必填！';
          raise err_custom;
        end if;
        if sfk_vc_brsftnb is not null and sfk_vc_brsftnb <> '2' and sfk_vc_hjhs is null then
          sfk_err := '户籍核实不能为空！';
          raise err_custom;
        end if;
        if sfk_vc_brsftnb is not null and sfk_vc_brsftnb <> '2' and sfk_vc_jzdhs is null then
          sfk_err := '居住地核实不能为空！';
          raise err_custom;
        end if;
        -- 初访日期必填
        if sfk_dt_sfrq is null then
          sfk_err := '初访日期必填！';
          raise err_custom;
        end if;
        -- 初访医生必填
        if sfk_vc_sfys is null then
          sfk_err := '初访医生必填！';
          raise err_custom;
        end if;
        -- 户籍未核实时，未核实原因不能为空
        if sfk_vc_hjhs = '2' and (sfk_vc_hjwhsyy is null) then
          sfk_err := '户籍未核实时，未核实原因不能为空！';
          raise err_custom;
        end if;
        -- 居住地未核实时，未核实原因不能为空
        if sfk_vc_jzdhs = '2' and (sfk_vc_jzdwhsyy is null) then
          sfk_err := '居住地未核实时，未核实原因不能为空！';
          raise err_custom;
        end if;
        -- 并发症选择为有时，并发症类型不能为空
        if sfk_vc_bfz = '1' and (sfk_vc_bfzlx is null) then
          sfk_err := '并发症选择为有时，并发症类型不能为空';
          raise err_custom;
        elsif (sfk_vc_bfz = '1') then
          if instr(sfk_vc_bfzlx, '1', 1, 1) > 0 and
             (sfk_dt_gxybkssj is null or sfk_dt_gxybqzsj is null) then
            sfk_err := '高血压出现时间和确诊时间皆不能为空！';
            raise err_custom;
          elsif instr(sfk_vc_bfzlx, '2', 1, 1) > 0 and
                (sfk_dt_xjgsbkssj is null or sfk_dt_xjgsbqzsj is null) then
            sfk_err := '心肌梗死或猝死出现时间和确诊时间皆不能为空！';
            raise err_custom;
          elsif instr(sfk_vc_bfzlx, '3', 1, 1) > 0 and
                (sfk_dt_xgbbkssj is null or sfk_dt_xgbbqzsj is null) then
            sfk_err := '脑卒中出现时间和确诊时间皆不能为空！';
            raise err_custom;
          elsif instr(sfk_vc_bfzlx, '4', 1, 1) > 0 and
                (sfk_dt_szbbkssj is null or sfk_dt_szbbqzsj is null) then
            sfk_err := '肾脏病变出现时间和确诊时间皆不能为空！';
            raise err_custom;
          elsif instr(sfk_vc_bfzlx, '5', 1, 1) > 0 and
                (sfk_dt_sjbbkssj is null or sfk_dt_sjbbqzsj is null) then
            sfk_err := '神经病变出现时间和确诊时间皆不能为空！';
            raise err_custom;
          elsif instr(sfk_vc_bfzlx, '6', 1, 1) > 0 and
                (sfk_dt_swmbbkssj is null or sfk_dt_swmbbqzsj is null) then
            sfk_err := '视网膜病变出现时间和确诊时间皆不能为空！';
            raise err_custom;
          elsif instr(sfk_vc_bfzlx, '7', 1, 1) > 0 and
                (sfk_dt_pfgrkssj is null or sfk_dt_pfgrqzsj is null) then
            sfk_err := '糖尿病足出现时间和确诊时间皆不能为空！';
            raise err_custom;
          end if;
        end if;
        -- 急性并发症选择为有时，急性并发症类型不能为空
        if sfk_vc_jxbfz = '1' and (sfk_vc_jxbfzlx is null) then
          sfk_err := '急性并发症选择为有时，急性并发症类型不能为空';
          raise err_custom;
        elsif (sfk_vc_jxbfz = '1') then
          if instr(sfk_vc_jxbfzlx, '1', 1, 1) > 0 and
             sfk_vc_tnbtszdsj is null then
            sfk_err := '糖尿病酮酸中毒时间不能为空！';
            raise err_custom;
          elsif instr(sfk_vc_jxbfzlx, '2', 1, 1) > 0 and
                sfk_vc_tnbrszdsj is null then
            sfk_err := '糖尿病乳酸中毒时间不能为空！';
            raise err_custom;
          elsif instr(sfk_vc_jxbfzlx, '3', 1, 1) > 0 and
                sfk_vc_tnbftszdsj is null then
            sfk_err := '糖尿病非酮症高渗综合症中毒时间不能为空！';
            raise err_custom;
          elsif instr(sfk_vc_jxbfzlx, '4', 1, 1) > 0 and
                sfk_vc_tnbdxtzsj is null then
            sfk_err := '糖尿病低血糖症中毒时间不能为空！';
            raise err_custom;
          end if;
        end if;
        --撤销管理
        if (sfk_dt_cxglrq is not null and sfk_vc_cxglyy is null) then
          sfk_err := '撤销管理日期非空时撤销原因必填！';
          raise err_custom;
        elsif (sfk_dt_cxglrq is not null and sfk_vc_cxglyy = '6' and
              sfk_vc_cxglyyqt is null) then
          sfk_err := '撤销原因选择其他时，其他原因必填！';
          raise err_custom;
        end if;
        --死亡
        if sfk_dt_swrq is not null and
           (sfk_vc_swyy is null or sfk_vc_swicd is null or
           sfk_vc_swmc is null or sfk_vc_swdd is null) then
          sfk_err := '死亡日期非空时,死亡原因，死亡icd，死亡icd名称，死亡地点不能为空！';
          raise err_custom;
        end if;
        --初访数据项校验
      else
        --随访卡数据项校验
        -- 初访日期必填
        if sfk_dt_sfrq is null then
          sfk_err := '随访日期必填！';
          raise err_custom;
        end if;
        -- 初访医生必填
        if sfk_vc_sfys is null then
          sfk_err := '随访医生必填！';
          raise err_custom;
        end if;
        if sfk_vc_hksfqc is null then
          sfk_err := '户口是否迁出必填！';
          raise err_custom;
        end if;
        if sfk_vc_hksfqc = '1' and sfk_dt_hkqcrq is null then
          sfk_err := '迁移时间必填！';
          raise err_custom;
        end if;
        --居住地址类型为0 户籍省市区县街道居委详细地址不为空
        --if hz_vc_hkshen = '0' and
        --   (hz_vc_hks is null or hz_vc_hkqx is null or hz_vc_hkjd is null or
        --   hz_vc_hkjw is null or hz_vc_hkxxdz is null) then
        --  sfk_err := '居住地址类型为浙江省时,居住市，居住区县，居住街道，居住居委，详细地址皆不能为空！';
        --  raise err_custom;
        --end if;
        -- 并发症选择为有时，并发症类型不能为空
        if sfk_vc_bfz = '1' and (sfk_vc_bfzlx is null) then
          sfk_err := '并发症选择为有时，并发症类型不能为空';
          raise err_custom;
        elsif (sfk_vc_bfz = '1') then
          if instr(sfk_vc_bfzlx, '1', 1, 1) > 0 and
             (sfk_dt_gxybqzsj is null) then
            sfk_err := '高血压确诊时间不能为空！';
            raise err_custom;
          elsif instr(sfk_vc_bfzlx, '2', 1, 1) > 0 and
                (sfk_dt_xjgsbqzsj is null) then
            sfk_err := '心肌梗死或猝死确诊时间不能为空！';
            raise err_custom;
          elsif instr(sfk_vc_bfzlx, '3', 1, 1) > 0 and
                (sfk_dt_xgbbqzsj is null) then
            sfk_err := '脑卒中确诊时间皆不能为空！';
            raise err_custom;
          elsif instr(sfk_vc_bfzlx, '4', 1, 1) > 0 and
                (sfk_dt_szbbqzsj is null) then
            sfk_err := '肾脏病变确诊时间皆不能为空！';
            raise err_custom;
          elsif instr(sfk_vc_bfzlx, '5', 1, 1) > 0 and
                (sfk_dt_sjbbqzsj is null) then
            sfk_err := '神经病变确诊时间不能为空！';
            raise err_custom;
          elsif instr(sfk_vc_bfzlx, '6', 1, 1) > 0 and
                (sfk_dt_swmbbqzsj is null) then
            sfk_err := '视网膜病变确诊时间皆不能为空！';
            raise err_custom;
          elsif instr(sfk_vc_bfzlx, '7', 1, 1) > 0 and
                (sfk_dt_pfgrqzsj is null) then
            sfk_err := '糖尿病足确诊时间皆不能为空！';
            raise err_custom;
          end if;
        end if;
        -- 急性并发症选择为有时，急性并发症类型不能为空
        if sfk_vc_jxbfz = '1' and (sfk_vc_jxbfzlx is null) then
          sfk_err := '急性并发症选择为有时，急性并发症类型不能为空';
          raise err_custom;
        elsif (sfk_vc_jxbfz = '1') then
          if instr(sfk_vc_jxbfzlx, '1', 1, 1) > 0 and
             sfk_vc_tnbtszdsj is null then
            sfk_err := '糖尿病酮酸中毒时间不能为空！';
            raise err_custom;
          elsif instr(sfk_vc_jxbfzlx, '2', 1, 1) > 0 and
                sfk_vc_tnbrszdsj is null then
            sfk_err := '糖尿病乳酸中毒时间不能为空！';
            raise err_custom;
          elsif instr(sfk_vc_jxbfzlx, '3', 1, 1) > 0 and
                sfk_vc_tnbftszdsj is null then
            sfk_err := '糖尿病非酮症高渗综合症中毒时间不能为空！';
            raise err_custom;
          elsif instr(sfk_vc_jxbfzlx, '4', 1, 1) > 0 and
                sfk_vc_tnbdxtzsj is null then
            sfk_err := '糖尿病低血糖症中毒时间不能为空！';
            raise err_custom;
          end if;
        end if;
        --撤销管理
        if (sfk_dt_cxglrq is not null and sfk_vc_cxglyy is null) then
          sfk_err := '撤销管理日期非空时撤销原因必填！';
          raise err_custom;
        elsif (sfk_dt_cxglrq is not null and sfk_vc_cxglyy = '6' and
              sfk_vc_cxglyyqt is null) then
          sfk_err := '撤销原因选择其他时，其他原因必填！';
          raise err_custom;
        end if;
        --死亡
        if sfk_dt_swrq is not null and
           (sfk_vc_swyy is null or sfk_vc_swicd is null or
           sfk_vc_swmc is null or sfk_vc_swdd is null) then
          sfk_err := '死亡日期非空时,死亡原因，死亡icd，死亡icd名称，死亡地点不能为空！';
          raise err_custom;
        end if;
      end if;
      --初访页面的户籍迁出地址字段不一致再次取值赋值
      if (sfk_vc_hkqcs is null) then
        sfk_vc_hkqcs   := json_str(sfk_Json_Data, 'vc_hkshen');
        sfk_vc_hkqcshi := json_str(sfk_Json_Data, 'vc_hks');
        sfk_vc_hkqcqx  := json_str(sfk_Json_Data, 'vc_hkqx');
        sfk_vc_hkqcjd  := json_str(sfk_Json_Data, 'vc_hkjd');
        sfk_vc_hkqcjw  := json_str(sfk_Json_Data, 'vc_hkjw');
        sfk_vc_hkqcxx  := json_str(sfk_Json_Data, 'vc_hkxxdz');
        -- if sfk_vc_hkqcs is NULL then
        --   sfk_err := '户籍地址省必填！';
        --   raise err_custom;
        -- end if;
        if sfk_vc_hkqcs = '0' then
          if sfk_vc_hkqcshi is null then
            sfk_err := '户籍地址市必填！';
            raise err_custom;
          end if;
          if sfk_vc_hkqcqx is null then
            sfk_err := '户籍地址区县必填！';
            raise err_custom;
          end if;
          if sfk_vc_hkqcjd is null then
            sfk_err := '户籍地址街道必填！';
            raise err_custom;
          end if;
          if substr(sfk_vc_hkqcshi, 1, 4) <> substr(sfk_vc_hkqcqx, 1, 4) or
             substr(sfk_vc_hkqcshi, 1, 4) <> substr(sfk_vc_hkqcjd, 1, 4) then
            sfk_err := '户口地址区划不匹配!';
            raise err_custom;
          end if;
        end if;
      end if;
      --判断是否核实户籍信息地址
      if (sfk_vc_brsftnb = '2') then
        --代表误诊
        sfk_dt_sfrq   := sfk_sysdate;
        sfk_vc_cxglyy := '2';
      
        bgk_vc_hkhs := '1';
        bgk_vc_jzhs := '1';
      else
        bgk_vc_hkhs := sfk_vc_hjhs;
        bgk_vc_jzhs := sfk_vc_jzdhs;
      end if;
    
      --插入入随访卡
      insert into zjjk_tnb_sfk
        (dt_xjgsbqzsj,
         dt_scjzrq,
         dt_hkqcrq,
         vc_hkqcxx,
         vc_hkqcjw,
         vc_hkqcshi,
         vc_hkqcs,
         vc_hksfqc,
         vc_sfys,
         dt_sfrq,
         vc_hzid,
         vc_bgkid,
         vc_sfkid,
         dt_xjgsbkssj,
         dt_gxybqzsj,
         dt_gxybkssj,
         vc_zlqk,
         vc_tnbdxtzsj,
         vc_tnbftszdsj,
         vc_tnbrszdsj,
         vc_tnbtszdsj,
         vc_jxbfzlx,
         dt_sczzrq,
         vc_jxbfz,
         vc_hkqcjd,
         vc_hkqcqx,
         vc_xgdw,
         dt_xgsj,
         dt_cjsj,
         vc_cjdw,
         vc_cjyh,
         vc_scbz,
         vc_yds,
         vc_fyqk,
         vc_bf,
         vc_cxglyyqt,
         vc_cxglyy,
         dt_cxglrq,
         dt_qtbbqzsj,
         dt_qtbbkssj,
         dt_pfgrqzsj,
         dt_pfgrkssj,
         dt_swmbbqzsj,
         dt_swmbbkssj,
         dt_xgbbqzsj,
         dt_xgbbkssj,
         dt_sjbbqzsj,
         dt_sjbbkssj,
         dt_szbbqzsj,
         dt_szbbkssj,
         dt_bfzqt,
         vc_bfzlx,
         dt_clsj,
         nb_zjycxtz,
         vc_zjycxtlx,
         vc_clxt,
         nb_scqy,
         nb_scqn,
         vc_swdd,
         vc_swmc,
         vc_swicd,
         vc_swyy,
         dt_swrq,
         vc_bfz,
         vc_sfzh,
         vc_brsftnb,
         upload_areaeport,
         vc_ispass,
         vc_sflx,
         vc_id,
         vc_jzdwhsyy,
         vc_jzdhs,
         vc_hjwhsyy,
         vc_hjhs,
         vc_gxbz,
         vc_bz,
         vc_mqqk,
         vc_jcxm,
         nb_tz,
         nb_zjycxtzch)
      values
        (sfk_dt_xjgsbqzsj,
         sfk_dt_scjzrq,
         sfk_dt_hkqcrq,
         sfk_vc_hkqcxx,
         sfk_vc_hkqcjw,
         sfk_vc_hkqcshi,
         sfk_vc_hkqcs,
         sfk_vc_hksfqc,
         sfk_vc_sfys,
         sfk_dt_sfrq,
         sfk_vc_hzid,
         sfk_vc_bgkid,
         sfk_vc_sfkid,
         sfk_dt_xjgsbkssj,
         sfk_dt_gxybqzsj,
         sfk_dt_gxybkssj,
         sfk_vc_zlqk,
         sfk_vc_tnbdxtzsj,
         sfk_vc_tnbftszdsj,
         sfk_vc_tnbrszdsj,
         sfk_vc_tnbtszdsj,
         sfk_vc_jxbfzlx,
         sfk_dt_sczzrq,
         sfk_vc_jxbfz,
         sfk_vc_hkqcjd,
         sfk_vc_hkqcqx,
         sfk_vc_xgdw,
         sfk_dt_xgsj,
         sfk_dt_cjsj,
         sfk_vc_cjdw,
         sfk_vc_cjyh,
         sfk_vc_scbz,
         sfk_vc_yds,
         sfk_vc_fyqk,
         sfk_vc_bf,
         sfk_vc_cxglyyqt,
         sfk_vc_cxglyy,
         sfk_dt_cxglrq,
         sfk_dt_qtbbqzsj,
         sfk_dt_qtbbkssj,
         sfk_dt_pfgrqzsj,
         sfk_dt_pfgrkssj,
         sfk_dt_swmbbqzsj,
         sfk_dt_swmbbkssj,
         sfk_dt_xgbbqzsj,
         sfk_dt_xgbbkssj,
         sfk_dt_sjbbqzsj,
         sfk_dt_sjbbkssj,
         sfk_dt_szbbqzsj,
         sfk_dt_szbbkssj,
         sfk_dt_bfzqt,
         sfk_vc_bfzlx,
         sfk_dt_clsj,
         sfk_nb_zjycxtz,
         sfk_vc_zjycxtlx,
         sfk_vc_clxt,
         sfk_nb_scqy,
         sfk_nb_scqn,
         sfk_vc_swdd,
         sfk_vc_swmc,
         sfk_vc_swicd,
         sfk_vc_swyy,
         sfk_dt_swrq,
         sfk_vc_bfz,
         sfk_vc_sfzh,
         sfk_vc_brsftnb,
         sfk_upload_areaeport,
         sfk_vc_ispass,
         sfk_vc_sflx,
         sfk_vc_id,
         sfk_vc_jzdwhsyy,
         sfk_vc_jzdhs,
         sfk_vc_hjwhsyy,
         sfk_vc_hjhs,
         sfk_vc_gxbz,
         sfk_vc_bz,
         sfk_vc_mqqk,
         sfk_vc_jcxm,
         sfk_nb_tz,
         sfk_nb_zjycxtzch);
      --依据填写的迁出信息更新糖尿病报告卡的值
      bgk_vc_qcqxdm  := sfk_vc_hkqcqx;
      bgk_vc_qcjw    := sfk_vc_hkqcjw;
      bgk_vc_qcjddm  := sfk_vc_hkqcjd;
      bgk_vc_qcxxdz  := sfk_vc_hkqcxx;
      bgk_vc_qcsdm   := sfk_vc_hkqcshi;
      bgk_dt_qcsj    := sfk_dt_hkqcrq;
      bgk_vc_hkwhsyy := sfk_vc_hjwhsyy;
      bgk_vc_jzwhsyy := sfk_vc_jzdwhsyy;
      /*      bgk_vc_cxgl   := sfk_vc_cxgl;*/
      --判断是否核实户籍信息地址
      --设置糖尿病报卡的首次时间
      if (sfk_vc_brsftnb = '1' and sfk_dt_scjzrq is not null) then
        bgk_dt_sczdrq := sfk_dt_scjzrq;
      end if;
      --操作是否更新患者的户口地址
      if (sfk_vc_hkqcs is not null and sfk_fl = '1'
        and (hz_vc_hkshen <> sfk_vc_hkqcs 
        or hz_vc_hks <> sfk_vc_hkqcshi
        or hz_vc_hkqx <> sfk_vc_hkqcqx
        or hz_vc_hkjd <> sfk_vc_hkqcjd)) then
        if sfk_vc_hkqcjd is not null and sfk_vc_hkqcqx is not null then
          --初访时做属地确认
          select count(1), wm_concat(a.code)
            into v_count, v_vc_gldw
            from organ_node a
           where a.removed = 0
             and a.description like '%' || sfk_vc_hkqcjd || '%';
          if v_count = 1 then
            --确定属地
            v_vc_sdqrzt := '1';
          else
            v_vc_gldw   := sfk_vc_hkqcqx;
            v_vc_sdqrzt := '0';
          end if;
          if sfk_vc_hkqcs = '1' then
            v_vc_gldw   := '99999999';
            v_vc_sdqrzt := '1';
          end if;
          --更新报告卡属地确认
          update zjjk_tnb_bgk a
             set a.vc_sdqrzt = v_vc_sdqrzt, a.vc_gldw = v_vc_gldw
           where a.vc_bgkid = sfk_vc_bgkid;
        end if;
        --更新患者的户籍信息
        update zjjk_tnb_hzxx
           set vc_sfzh   = sfk_vc_sfzh,
               vc_hkshen = sfk_vc_hkqcs,
               vc_hks    = sfk_vc_hkqcshi,
               vc_hkqx   = sfk_vc_hkqcqx,
               vc_hkjd   = sfk_vc_hkqcjd,
               vc_hkjw   = sfk_vc_hkqcjw,
               vc_hkxxdz = sfk_vc_hkqcxx
         where vc_personid = bgk_vc_hzid;
      end if;
      --设置糖尿病报卡的首次时间
      --设置糖尿病报卡的迁出标志
      if (sfk_vc_hksfqc = '1') then
        bgk_vc_qybz := '1';
      end if;
      --设置糖尿病报卡的迁出标志
      --判断报告卡状态  不为重复卡  和 户籍核实 为 未核实  设置为失放卡
      if bgk_vc_bgkzt <> '4' AND sfk_vc_hjhs = '2' THEN
        bgk_vc_bgkzt := '6';
      END IF;
      --判断患者是否死亡
      if sfk_dt_swrq IS NOT NULL THEN
        --设置糖尿病报告卡死亡
        bgk_vc_sfsw  := '1';
        bgk_vc_bgkzt := '7';
        bgk_vc_swyy  := sfk_vc_swyy;
        bgk_dt_swrq  := sfk_dt_swrq;
      ELSE
        bgk_vc_sfsw  := '0';
        bgk_vc_bgkzt := '0';
      END IF;
      --依据不用的撤销原因设置不用的tnb 报卡的状态
      if bgk_vc_bgkzt <> '4' and sfk_dt_cxglrq IS NOT NULL then
        if sfk_vc_cxglyy = '2' THEN
          bgk_vc_bgkzt := '3';
        ElSIF (sfk_vc_cxglyy = '5') THEN
          --设置个人基本信息
          hz_vc_hkshen := '1';
          hz_vc_hks    := '';
          hz_vc_hkqx   := '';
          hz_vc_hkjd   := '';
        ElSIF (sfk_vc_cxglyy = '4') THEN
          bgk_vc_bgkzt := '7';
          bgk_dt_swrq  := sfk_dt_swrq;
        ELSIF (sfk_vc_cxglyy = '1' AND bgk_vc_cfzt = '0') THEN
          bgk_vc_bgkzt := '2';
        ELSIF (sfk_vc_cxglyy = '1' AND bgk_vc_cfzt <> '0') THEN
          bgk_vc_bgkzt := '6';
        end if;
      END IF;
    
      --处理糖尿病报卡中的初访状态
      IF (bgk_vc_cfzt = '0') THEN
        bgk_vc_cfzt := '1';
        bgk_dt_cfsj := sfk_dt_sfrq;
        bgk_dt_sfsj := sfk_dt_sfrq;
      ELSIF (bgk_vc_cfzt = '1') THEN
        bgk_vc_cfzt := '3';
        bgk_dt_sfsj := sfk_dt_sfrq;
      END IF;
      --处理户口信息id
      if (sfk_vc_hzid is null) then
        sfk_vc_hzid := bgk_vc_hzid;
      end if;
      --赋值操作结束
      
      --新增初访卡，并且是否患有糖尿病选否
      if sfk_fl = '1' and sfk_vc_brsftnb = '2' then
          bgk_vc_bgkzt := '3';
          --更新糖尿病报卡, 只更新初访状态和时间等字段
          update zjjk_tnb_bgk
             set vc_bgkzt   = bgk_vc_bgkzt,
                 vc_cfzt    = bgk_vc_cfzt,
                 dt_cfsj    = bgk_dt_cfsj,
                 dt_sfsj    = bgk_dt_sfsj,
                 dt_xgsj    = sysdate
           where vc_bgkid = sfk_vc_bgkid;
             --更新副卡
            update zjjk_tnb_bgk a
               set vc_bgkzt  = bgk_vc_bgkzt,
                   a.dt_xgsj = sysdate
             where exists (select 1
                      from zjjk_tnb_bgk_zfgx b
                     where a.vc_bgkid = b.vc_fkid
                       and b.vc_zkid <> b.vc_fkid
                       and b.vc_zkid = sfk_vc_bgkid);             
      -- 新增初访卡，并且选了撤销管理原因
      elsif sfk_fl = '1' and sfk_vc_cxglyy is not null and sfk_vc_cxglyy = '2' then
          --更新糖尿病报卡, 只更新初访状态和时间等字段
          update zjjk_tnb_bgk
             set vc_bgkzt   = bgk_vc_bgkzt,
                 vc_cfzt    = bgk_vc_cfzt,
                 dt_cfsj    = bgk_dt_cfsj,
                 dt_sfsj    = bgk_dt_sfsj,
                 dt_xgsj    = sysdate
           where vc_bgkid = sfk_vc_bgkid;
          --更新副卡
          update zjjk_tnb_bgk a
             set vc_bgkzt  = bgk_vc_bgkzt,
                 a.dt_xgsj = sysdate
           where exists (select 1
                    from zjjk_tnb_bgk_zfgx b
                   where a.vc_bgkid = b.vc_fkid
                     and b.vc_zkid <> b.vc_fkid
                     and b.vc_zkid = sfk_vc_bgkid);           
      else
          --更新糖尿病报卡字段
          update zjjk_tnb_bgk
             set vc_hkhs    = bgk_vc_hkhs,
                 vc_jzhs    = bgk_vc_jzhs,
                 vc_qcqxdm  = bgk_vc_qcqxdm,
                 vc_qcjw    = bgk_vc_qcjw,
                 vc_qcjddm  = bgk_vc_qcjddm,
                 vc_qcxxdz  = bgk_vc_qcxxdz,
                 vc_qcsdm   = bgk_vc_qcsdm,
                 dt_qcsj    = bgk_dt_qcsj,
                 vc_hkwhsyy = bgk_vc_hkwhsyy,
                 vc_jzwhsyy = bgk_vc_jzwhsyy,
                 vc_cxgl    = bgk_vc_cxgl,
                 dt_sczdrq  = bgk_dt_sczdrq,
                 vc_qybz    = bgk_vc_qybz,
                 vc_bgkzt   = bgk_vc_bgkzt,
                 vc_sfsw    = bgk_vc_sfsw,
                 vc_cfzt    = bgk_vc_cfzt,
                 dt_cfsj    = bgk_dt_cfsj,
                 dt_sfsj    = bgk_dt_sfsj,
                 vc_swyy    = bgk_vc_swyy,
                 dt_swrq    = bgk_dt_swrq,
                 dt_xgsj    = sysdate
           where vc_bgkid = sfk_vc_bgkid;    
          --更新副卡vc_bgkzt,dt_swrq，vc_swyy
          update zjjk_tnb_bgk a
             set vc_bgkzt  = bgk_vc_bgkzt,
                 a.vc_swyy = bgk_vc_swyy,
                 a.dt_swrq = bgk_dt_swrq,
                 a.dt_xgsj = sysdate
           where exists (select 1
                    from zjjk_tnb_bgk_zfgx b
                   where a.vc_bgkid = b.vc_fkid
                     and b.vc_zkid <> b.vc_fkid
                     and b.vc_zkid = sfk_vc_bgkid);                
      end if;

      sfk_json_return.put('vc_sfkid', sfk_vc_sfkid);
      result_out := Return_Succ_Json(sfk_json_return);
    else
      --开始-----数据项校验
      -- --随访数据项校验
      if (sfk_fl = '2') then
        -- 初访日期必填
        if sfk_dt_sfrq is null then
          sfk_err := '随访日期必填！';
          raise err_custom;
        end if;
        -- 初访医生必填
        if sfk_vc_sfys is null then
          sfk_err := '随访医生必填！';
          raise err_custom;
        end if;
        if sfk_vc_hksfqc is null then
          sfk_err := '户口是否迁出必填！';
          raise err_custom;
        end if;
        --户口迁出为【是】时，迁出时间必填
        if (sfk_vc_hksfqc = '1' and sfk_dt_hkqcrq is null) then
          sfk_err := '户口迁出为【是】时，迁出时间必填！';
          raise err_custom;
        end if;
        -- 户籍未核实时，未核实原因不能为空
        if sfk_vc_hjhs = '2' and (sfk_vc_hjwhsyy is null) then
          sfk_err := '户籍未核实时，未核实原因不能为空！';
          raise err_custom;
        end if;
        -- 居住地未核实时，未核实原因不能为空
        if sfk_vc_jzdhs = '2' and (sfk_vc_jzdwhsyy is null) then
          sfk_err := '居住地未核实时，未核实原因不能为空！';
          raise err_custom;
        end if;
        -- 并发症选择为有时，并发症类型不能为空
        if sfk_vc_bfz = '1' and (sfk_vc_bfzlx is null) then
          sfk_err := '并发症选择为有时，并发症类型不能为空';
          raise err_custom;
        elsif (sfk_vc_bfz = '1') then
          if instr(sfk_vc_bfzlx, '1', 1, 1) > 0 and
             (sfk_dt_gxybqzsj is null) then
            sfk_err := '高血压确诊时间不能为空！';
            raise err_custom;
          elsif instr(sfk_vc_bfzlx, '2', 1, 1) > 0 and
                (sfk_dt_xjgsbqzsj is null) then
            sfk_err := '心肌梗死或猝死确诊时间不能为空！';
            raise err_custom;
          elsif instr(sfk_vc_bfzlx, '3', 1, 1) > 0 and
                (sfk_dt_xgbbqzsj is null) then
            sfk_err := '脑卒中确诊时间不能为空！';
            raise err_custom;
          elsif instr(sfk_vc_bfzlx, '4', 1, 1) > 0 and
                (sfk_dt_szbbqzsj is null) then
            sfk_err := '肾脏病变确诊时间不能为空！';
            raise err_custom;
          elsif instr(sfk_vc_bfzlx, '5', 1, 1) > 0 and
                (sfk_dt_sjbbqzsj is null) then
            sfk_err := '神经病变确诊时间不能为空！';
            raise err_custom;
          elsif instr(sfk_vc_bfzlx, '6', 1, 1) > 0 and
                (sfk_dt_swmbbqzsj is null) then
            sfk_err := '视网膜病变确诊时间不能为空！';
            raise err_custom;
          elsif instr(sfk_vc_bfzlx, '7', 1, 1) > 0 and
                (sfk_dt_pfgrqzsj is null) then
            sfk_err := '糖尿病足确诊时间不能为空！';
            raise err_custom;
          end if;
        end if;
        -- 急性并发症选择为有时，急性并发症类型不能为空
        if sfk_vc_jxbfz = '1' and (sfk_vc_jxbfzlx is null) then
          sfk_err := '急性并发症选择为有时，急性并发症类型不能为空';
          raise err_custom;
        elsif (sfk_vc_jxbfz = '1') then
          if instr(sfk_vc_jxbfzlx, '1', 1, 1) > 0 and
             sfk_vc_tnbtszdsj is null then
            sfk_err := '糖尿病酮酸中毒时间不能为空！';
            raise err_custom;
          elsif instr(sfk_vc_jxbfzlx, '2', 1, 1) > 0 and
                sfk_vc_tnbrszdsj is null then
            sfk_err := '糖尿病乳酸中毒时间不能为空！';
            raise err_custom;
          elsif instr(sfk_vc_jxbfzlx, '3', 1, 1) > 0 and
                sfk_vc_tnbftszdsj is null then
            sfk_err := '糖尿病非酮症高渗综合症中毒时间不能为空！';
            raise err_custom;
          elsif instr(sfk_vc_jxbfzlx, '4', 1, 1) > 0 and
                sfk_vc_tnbdxtzsj is null then
            sfk_err := '糖尿病低血糖症中毒时间不能为空！';
            raise err_custom;
          end if;
        end if;
        --撤销管理
        if (sfk_dt_cxglrq is not null and sfk_vc_cxglyy is null) then
          sfk_err := '撤销管理日期非空时撤销原因必填！';
          raise err_custom;
        elsif (sfk_dt_cxglrq is not null and sfk_vc_cxglyy = '6' and
              sfk_vc_cxglyyqt is null) then
          sfk_err := '撤销原因选择其他时，其他原因必填！';
          raise err_custom;
        end if;
        --死亡
        if sfk_dt_swrq is not null and
           (sfk_vc_swyy is null or sfk_vc_swicd is null or
           sfk_vc_swmc is null or sfk_vc_swdd is null) then
          sfk_err := '死亡日期非空时,死亡原因，死亡icd，死亡icd名称，死亡地点不能为空！';
          raise err_custom;
        end if;
        --if sfk_vc_hkqcs is NULL AND sfk_vc_hksfqc = '1' then
        --  sfk_err := '户籍地址省必填！';
        --  raise err_custom;
        --end if;
        if sfk_vc_hkqcs = '0' then
          if sfk_vc_hkqcshi is null then
            sfk_err := '户籍地址市必填！';
            raise err_custom;
          end if;
          if sfk_vc_hkqcqx is null then
            sfk_err := '户籍地址区县必填！';
            raise err_custom;
          end if;
          if sfk_vc_hkqcjd is null then
            sfk_err := '户籍地址街道必填！';
            raise err_custom;
          end if;
          if substr(sfk_vc_hkqcshi, 1, 4) <> substr(sfk_vc_hkqcqx, 1, 4) or
             substr(sfk_vc_hkqcshi, 1, 4) <> substr(sfk_vc_hkqcjd, 1, 4) then
            sfk_err := '户口地址区划不匹配!';
            raise err_custom;
          end if;
        end if;
      else
        --随访卡数据项校验,初访没修改
        null;
      end if;
      --结束-----数据项校验
      --判断是否核实户籍信息地址
      if (sfk_vc_brsftnb = '2') then
        --代表误诊
        sfk_dt_sfrq   := sfk_sysdate;
        sfk_vc_cxglyy := '2';
      
        bgk_vc_hkhs := '1';
        bgk_vc_jzhs := '1';
      else
        bgk_vc_hkhs := sfk_vc_hjhs;
        bgk_vc_jzhs := sfk_vc_jzdhs;
      end if;
      --更新随访操作
      update zjjk_tnb_sfk
         set dt_xjgsbqzsj = sfk_dt_xjgsbqzsj,
             dt_scjzrq    = sfk_dt_scjzrq,
             dt_hkqcrq    = sfk_dt_hkqcrq,
             vc_hkqcxx    = sfk_vc_hkqcxx,
             vc_hkqcjw    = sfk_vc_hkqcjw,
             vc_hkqcshi   = sfk_vc_hkqcshi,
             vc_hkqcs     = sfk_vc_hkqcs,
             vc_hksfqc    = sfk_vc_hksfqc,
             vc_sfys      = sfk_vc_sfys,
             dt_sfrq      = sfk_dt_sfrq,
             --vc_hzid          = sfk_vc_hzid,
             vc_bgkid         = sfk_vc_bgkid,
             dt_xjgsbkssj     = sfk_dt_xjgsbkssj,
             dt_gxybqzsj      = sfk_dt_gxybqzsj,
             dt_gxybkssj      = sfk_dt_gxybkssj,
             vc_zlqk          = sfk_vc_zlqk,
             vc_tnbdxtzsj     = sfk_vc_tnbdxtzsj,
             vc_tnbftszdsj    = sfk_vc_tnbftszdsj,
             vc_tnbrszdsj     = sfk_vc_tnbrszdsj,
             vc_tnbtszdsj     = sfk_vc_tnbtszdsj,
             vc_jxbfzlx       = sfk_vc_jxbfzlx,
             dt_sczzrq        = sfk_dt_sczzrq,
             vc_jxbfz         = sfk_vc_jxbfz,
             vc_hkqcjd        = sfk_vc_hkqcjd,
             vc_hkqcqx        = sfk_vc_hkqcqx,
             vc_xgdw          = sfk_vc_xgdw,
             dt_xgsj          = sfk_dt_xgsj,
             vc_scbz          = sfk_vc_scbz,
             vc_yds           = sfk_vc_yds,
             vc_fyqk          = sfk_vc_fyqk,
             vc_bf            = sfk_vc_bf,
             vc_cxglyyqt      = sfk_vc_cxglyyqt,
             vc_cxglyy        = sfk_vc_cxglyy,
             dt_cxglrq        = sfk_dt_cxglrq,
             dt_qtbbqzsj      = sfk_dt_qtbbqzsj,
             dt_qtbbkssj      = sfk_dt_qtbbkssj,
             dt_pfgrqzsj      = sfk_dt_pfgrqzsj,
             dt_pfgrkssj      = sfk_dt_pfgrkssj,
             dt_swmbbqzsj     = sfk_dt_swmbbqzsj,
             dt_swmbbkssj     = sfk_dt_swmbbkssj,
             dt_xgbbqzsj      = sfk_dt_xgbbqzsj,
             dt_xgbbkssj      = sfk_dt_xgbbkssj,
             dt_sjbbqzsj      = sfk_dt_sjbbqzsj,
             dt_sjbbkssj      = sfk_dt_sjbbkssj,
             dt_szbbqzsj      = sfk_dt_szbbqzsj,
             dt_szbbkssj      = sfk_dt_szbbkssj,
             dt_bfzqt         = sfk_dt_bfzqt,
             vc_bfzlx         = sfk_vc_bfzlx,
             dt_clsj          = sfk_dt_clsj,
             nb_zjycxtz       = sfk_nb_zjycxtz,
             vc_zjycxtlx      = sfk_vc_zjycxtlx,
             vc_clxt          = sfk_vc_clxt,
             nb_scqy          = sfk_nb_scqy,
             nb_scqn          = sfk_nb_scqn,
             vc_swdd          = sfk_vc_swdd,
             vc_swmc          = sfk_vc_swmc,
             vc_swicd         = sfk_vc_swicd,
             vc_swyy          = sfk_vc_swyy,
             dt_swrq          = sfk_dt_swrq,
             vc_bfz           = sfk_vc_bfz,
             vc_sfzh          = sfk_vc_sfzh,
             vc_brsftnb       = sfk_vc_brsftnb,
             upload_areaeport = sfk_upload_areaeport,
             vc_ispass        = sfk_vc_ispass,
             vc_sflx          = sfk_vc_sflx,
             vc_id            = sfk_vc_id,
             vc_jzdwhsyy      = sfk_vc_jzdwhsyy,
             vc_jzdhs         = sfk_vc_jzdhs,
             vc_hjwhsyy       = sfk_vc_hjwhsyy,
             vc_hjhs          = sfk_vc_hjhs,
             vc_gxbz          = sfk_vc_gxbz,
             vc_bz            = sfk_vc_bz,
             vc_mqqk          = sfk_vc_mqqk,
             vc_jcxm          = sfk_vc_jcxm,
             nb_tz            = sfk_nb_tz,
             nb_zjycxtzch     = sfk_nb_zjycxtzch
       where vc_sfkid = sfk_vc_sfkid;
      --依据填写的迁出信息更新糖尿病报告卡的值
      bgk_vc_qcqxdm  := sfk_vc_hkqcqx;
      bgk_vc_qcjw    := sfk_vc_hkqcjw;
      bgk_vc_qcjddm  := sfk_vc_hkqcjd;
      bgk_vc_qcxxdz  := sfk_vc_hkqcxx;
      bgk_vc_qcsdm   := sfk_vc_hkqcshi;
      bgk_dt_qcsj    := sfk_dt_hkqcrq;
      bgk_vc_hkwhsyy := sfk_vc_hjwhsyy;
      bgk_vc_jzwhsyy := sfk_vc_jzdwhsyy;
      /*      bgk_vc_cxgl   := sfk_vc_cxgl;*/
      --判断是否核实户籍信息地址
      --设置糖尿病报卡的首次时间
      if (sfk_vc_brsftnb = '1' and sfk_dt_scjzrq is not null) then
        bgk_dt_sczdrq := sfk_dt_scjzrq;
      end if;
      /*--操作是否更新患者的户口地址
      if (sfk_vc_hksfqc = '1' and sfk_vc_hkqcs is not null) then
        --更新患者的户籍信息
        update zjjk_tnb_hzxx
           set vc_sfzh   = sfk_vc_sfzh,
               vc_hkshen = sfk_vc_hkqcs,
               vc_hks    = sfk_vc_hkqcshi,
               vc_hkqx   = sfk_vc_hkqcqx,
               vc_hkjd   = sfk_vc_hkqcjd,
               vc_hkjw   = sfk_vc_hkqcjw,
               vc_hkxxdz = sfk_vc_hkqcxx
         where vc_personid = bgk_vc_hzid;
      end if;*/
      --设置糖尿病报卡的首次时间
      --设置糖尿病报卡的迁出标志
      if (sfk_vc_hksfqc = '1') then
        bgk_vc_qybz := '1';
      end if;
      --设置糖尿病报卡的迁出标志
      --判断报告卡状态  不为重复卡  和 户籍核实 为 未核实  设置为失放卡
      if bgk_vc_bgkzt <> '4' AND sfk_vc_hjhs = '2' THEN
        bgk_vc_bgkzt := '6';
      END IF;
      --判断患者是否死亡
      if sfk_dt_swrq IS NOT NULL THEN
        --设置糖尿病报告卡死亡
        bgk_vc_sfsw  := '1';
        bgk_vc_bgkzt := '7';
        bgk_vc_swyy  := sfk_vc_swyy;
        bgk_dt_swrq  := sfk_dt_swrq;
      ELSE
        bgk_vc_sfsw  := '0';
        bgk_vc_bgkzt := '0';
      END IF;
      --依据不用的撤销原因设置不用的tnb 报卡的状态
      if bgk_vc_bgkzt <> '4' and sfk_dt_cxglrq IS NOT NULL then
        if sfk_vc_cxglyy = '2' THEN
          bgk_vc_bgkzt := '3';
        ElSIF (sfk_vc_cxglyy = '5') THEN
          --设置个人基本信息
          hz_vc_hkshen := '1';
          hz_vc_hks    := '';
          hz_vc_hkqx   := '';
          hz_vc_hkjd   := '';
        ElSIF (sfk_vc_cxglyy = '4') THEN
          bgk_vc_bgkzt := '7';
          bgk_dt_swrq  := sfk_dt_swrq;
        ELSIF (sfk_vc_cxglyy = '1' AND bgk_vc_cfzt = '0') THEN
          bgk_vc_bgkzt := '2';
        ELSIF (sfk_vc_cxglyy = '1' AND bgk_vc_cfzt <> '0') THEN
          bgk_vc_bgkzt := '6';
        end if;
      END IF;
    
      --处理糖尿病报卡中的初访状态
      IF (bgk_vc_cfzt = '0') THEN
        bgk_vc_cfzt := '1';
        bgk_dt_cfsj := sfk_dt_sfrq;
        bgk_dt_sfsj := sfk_dt_sfrq;
      ELSIF (bgk_vc_cfzt = '1') THEN
        bgk_vc_cfzt := '3';
        bgk_dt_sfsj := sfk_dt_sfrq;
      END IF;
      --处理户口信息id
      if (sfk_vc_hzid is null) then
        sfk_vc_hzid := bgk_vc_hzid;
      end if;
      --赋值操作结束
      --更新糖尿病报卡字段
      update zjjk_tnb_bgk
         set vc_hkhs    = bgk_vc_hkhs,
             vc_jzhs    = bgk_vc_jzhs,
             vc_qcqxdm  = bgk_vc_qcqxdm,
             vc_qcjw    = bgk_vc_qcjw,
             vc_qcjddm  = bgk_vc_qcjddm,
             vc_qcxxdz  = bgk_vc_qcxxdz,
             vc_qcsdm   = bgk_vc_qcsdm,
             dt_qcsj    = bgk_dt_qcsj,
             vc_hkwhsyy = bgk_vc_hkwhsyy,
             vc_jzwhsyy = bgk_vc_jzwhsyy,
             vc_cxgl    = bgk_vc_cxgl,
             dt_sczdrq  = bgk_dt_sczdrq,
             vc_qybz    = bgk_vc_qybz,
             vc_bgkzt   = bgk_vc_bgkzt,
             vc_sfsw    = bgk_vc_sfsw,
             vc_cfzt    = bgk_vc_cfzt,
             dt_cfsj    = bgk_dt_cfsj,
             dt_sfsj    = bgk_dt_sfsj,
             vc_swyy    = bgk_vc_swyy,
             dt_swrq    = bgk_dt_swrq,
             dt_xgsj    = sysdate
       where vc_bgkid = sfk_vc_bgkid;
      --更新副卡vc_bgkzt,dt_swrq，vc_swyy
      update zjjk_tnb_bgk a
         set vc_bgkzt  = bgk_vc_bgkzt,
             a.vc_swyy = bgk_vc_swyy,
             a.dt_swrq = bgk_dt_swrq,
             a.dt_xgsj = sysdate
       where exists (select 1
                from zjjk_tnb_bgk_zfgx b
               where a.vc_bgkid = b.vc_fkid
                 and b.vc_zkid <> b.vc_fkid
                 and b.vc_zkid = sfk_vc_bgkid);
      sfk_json_return.put('vc_sfkid', sfk_vc_sfkid);
      result_out := Return_Succ_Json(sfk_json_return);
    END IF;
    --插入日志
    --记录日志
    v_json_yw_log := Json_ext.get_json(sfk_json_data, 'ywjllog');
    if v_json_yw_log is not null then
      v_json_yw_log.put('bgkid', sfk_vc_sfkid);
      v_json_yw_log.put('bgklx', '01');
      v_json_yw_log.put('ywjlid', sfk_vc_sfkid);
      v_json_yw_log.put('gnmk', '01');
      If (sfk_vc_bgkid is null) then
        v_ywjl_czlx := '01';
      else
        v_ywjl_czlx := '02';
      end if;
      if (sfk_fl = '2') then
        v_json_yw_log.put('gnmc', '报卡随访');
      else
        v_json_yw_log.put('gnmc', '报卡初访');
      end if;
      v_json_yw_log.put('czlx', v_ywjl_czlx);
      v_json_yw_log.put('ywjlid', sfk_vc_sfkid);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_update(v_json_yw_log, sfk_err);
      if sfk_err is not null then
        raise err_custom;
      end if;
    end if;
    --更新初随访标志
    pkg_zjmb_tnb.prc_bgkcsfzt_update(sfk_vc_bgkid, sfk_err);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(sfk_err, 2);
    WHEN OTHERS THEN
      sfk_err    := SQLERRM;
      result_out := return_fail(sfk_err, 0);
  END prc_tnbbgk_cfsf_update;
  /*--------------------------------------------------------------------------
  || 功能描述 ：糖尿病报告卡主副卡设置
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_tnbbgk_zfksz(Data_In    In Clob, --入参
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
    v_czyyhid zjjk_tnb_bgk_zfgx.vc_cjry%type;
    v_czyjgjb varchar2(3);
    v_zkid    zjjk_tnb_bgk_zfgx.vc_zkid%type;
    v_fkid    zjjk_tnb_bgk_zfgx.vc_fkid%type;
    v_count   number;
  BEGIN
    json_data(data_in, 'zjjk_tnb_bgk主副卡设置', v_json_data);
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
    update zjjk_tnb_bgk_zfgx a
       set a.vc_zkid = v_zkid,
           a.vc_cjjg = v_czyjgdm,
           a.vc_cjry = v_czyyhid,
           a.dt_cjsj = sysdate
     where a.vc_fkid = v_zkid;
    --当前卡不存在主副卡信息,默认当前卡为主卡
    if sql%rowcount = 0 then
      insert into zjjk_tnb_bgk_zfgx
        (vc_zkid, vc_fkid)
      values
        (v_zkid, v_zkid);
    end if;
    --处理副卡(副卡id可为空，将当前卡副卡属性改为主卡)
    if v_fkid is not null then
      --检查副卡是否初访
      select count(1)
        into v_count
        from zjjk_tnb_bgk a
       where a.vc_bgkid = v_fkid
         and a.vc_cfzt in ('1', '3');
      if v_count = 0 then
        v_err := '当前副卡还未初访!';
        raise err_custom;
      end if;
      --检查该副卡是否为其他副卡的主卡
      select count(1)
        into v_count
        from zjjk_tnb_bgk_zfgx a
       where a.vc_zkid = v_fkid
         and a.vc_fkid <> v_fkid;
      if v_count > 0 then
        v_err := '当前副卡为其他卡的主卡，不允许此操作!';
        raise err_custom;
      end if;
      --更新副卡
      update zjjk_tnb_bgk_zfgx a
         set a.vc_zkid = v_zkid,
             a.vc_cjjg = v_czyjgdm,
             a.vc_cjry = v_czyyhid,
             a.dt_cjsj = sysdate
       where a.vc_fkid = v_fkid;
      --副卡不存在主副关系则插入
      if sql%rowcount = 0 then
        insert into zjjk_tnb_bgk_zfgx
          (vc_zkid, vc_fkid)
        values
          (v_zkid, v_fkid);
      end if;
    end if;
    --操作日志
    v_json_yw_log := Json_ext.get_json(v_json_data, 'ywjllog');
    if v_json_yw_log is not null then
      v_json_yw_log.put('bgkid', v_zkid);
      v_json_yw_log.put('bgklx', '01');
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
  END prc_tnbbgk_zfksz;

  /*--------------------------------------------------------------------------
  || 功能描述 ：糖尿病报告卡初访随访删除
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_tnbbgk_cfsf_delete(Data_In    In Clob, --入参
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
    v_jgjb     varchar2(3);
    v_vc_sfkid zjjk_tnb_sfk.vc_sfkid%type;
    v_vc_bgkid varchar2(50);
  BEGIN
    json_data(data_in, 'zjjk_tnb_sfk随访卡删除', v_json_data);
    v_sysdate  := sysdate;
    v_vc_sfkid := Json_Str(v_Json_Data, 'vc_sfkid');
    v_jgjb     := Json_Str(v_Json_Data, 'jgjb');
    if v_jgjb = '3' then
      --获取报告卡id
      select max(vc_bgkid)
        into v_vc_bgkid
        from ZJJK_TNB_SFK
       where VC_SFKID = v_vc_sfkid;
      delete from ZJJK_TNB_SFK where VC_SFKID = v_vc_sfkid;
      if sql%rowcount <> 1 then
        v_err := 'id[' || v_vc_sfkid || ']未获取到有效报的随访信息!';
        raise err_custom;
      end if;
    else
      v_err := '当前机构无删除权限';
      raise err_custom;
    end if;
    v_json_yw_log := Json_ext.get_json(v_json_data, 'ywjllog');
    if v_json_yw_log is not null then
      v_json_yw_log.put('bgkid', v_vc_sfkid);
      v_json_yw_log.put('bgklx', '01');
      v_json_yw_log.put('ywjlid', v_vc_sfkid);
      v_json_yw_log.put('gnmk', '01');
      v_json_yw_log.put('gnmc', '随访卡删除');
      v_json_yw_log.put('czlx', '04');
      v_json_yw_log.put('ywjlid', v_vc_sfkid);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_update(v_json_yw_log, v_err);
      if v_err is not null then
        raise err_custom;
      end if;
    end if;
    --更新初随访标志
    pkg_zjmb_tnb.prc_bgkcsfzt_update(v_vc_bgkid, v_err);
    v_Json_Return.put('id', v_vc_sfkid);
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_tnbbgk_cfsf_delete;
  /*--------------------------------------------------------------------------
  || 功能描述 ：糖尿病报告卡迁出管理
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_tnbbgk_qc(Data_In    In Clob, --入参
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
  
    v_vc_jjqcyy zjjk_tnb_qrqcb.vc_jjqcyy%TYPE; --拒绝迁出原因
    v_vc_qrgldw zjjk_tnb_qrqcb.vc_qrgldw%TYPE; --迁入管理单位
    v_vc_id     zjjk_tnb_qrqcb.vc_id%TYPE; --系统唯一ID
    v_vc_xtlb   zjjk_tnb_qrqcb.vc_xtlb%TYPE; --系统类别 
    v_vc_bgkid  zjjk_tnb_qrqcb.vc_bgkid%TYPE; --报告卡ID
    v_vc_qccs   zjjk_tnb_qrqcb.vc_qccs%TYPE; --迁出市
    v_vc_qcqx   zjjk_tnb_qrqcb.vc_qcqx%TYPE; --迁出区县
    v_vc_qcjd   zjjk_tnb_qrqcb.vc_qcjd%TYPE; --迁出街道
    v_vc_qcdl   zjjk_tnb_qrqcb.vc_qcdl%TYPE; --迁出道路
    v_vc_qcjw   zjjk_tnb_qrqcb.vc_qcjw%TYPE; --迁出居委
    v_vc_qcxxdz zjjk_tnb_qrqcb.vc_qcxxdz%TYPE; --迁出详细地址
    v_vc_qrcs   zjjk_tnb_qrqcb.vc_qrcs%TYPE; --迁入市
    v_vc_qrqx   zjjk_tnb_qrqcb.vc_qrqx%TYPE; --迁入区县
    v_vc_qrjd   zjjk_tnb_qrqcb.vc_qrjd%TYPE; --迁入街道
    v_vc_qrdl   zjjk_tnb_qrqcb.vc_qrdl%TYPE; --迁入道路
    v_vc_qrjw   zjjk_tnb_qrqcb.vc_qrjw%TYPE; --迁入居委
    v_vc_qrxxdz zjjk_tnb_qrqcb.vc_qrxxdz%TYPE; --迁入详细地址
    v_dt_qcsj   zjjk_tnb_qrqcb.dt_qcsj%TYPE; --迁出时间
    v_dt_clsj   zjjk_tnb_qrqcb.dt_clsj%TYPE; --处理时间
    v_vc_clfs   zjjk_tnb_qrqcb.vc_clfs%TYPE; --处理方式
    v_vc_qcr    zjjk_tnb_qrqcb.vc_qcr%TYPE; --迁出人
    v_vc_clr    zjjk_tnb_qrqcb.vc_clr%TYPE; --处理人
    v_vc_zhxgr  zjjk_tnb_qrqcb.vc_zhxgr%TYPE; --最后修改人
    v_dt_zhxgsj zjjk_tnb_qrqcb.dt_zhxgsj%TYPE; --最后修改时间
    v_qyshbz    varchar2(1);
    v_hzid      zjjk_tnb_hzxx.vc_personid%TYPE; --患者ID
  
  BEGIN
    json_data(data_in, 'zjjk_tnb_bgk迁出', v_json_data);
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
      select b.vc_hks,
             b.vc_hkqx,
             b.vc_hkjd,
             b.vc_hkjw,
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
        from zjjk_tnb_bgk a, zjjk_tnb_hzxx b
       where a.vc_bgkid = v_vc_bgkid
         and a.vc_hzid = b.vc_personid
         and a.vc_qybz = '1';
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
        update zjjk_tnb_hzxx a
           set a.vc_hks    = v_vc_qrcs,
               a.vc_hkqx   = v_vc_qrqx,
               a.vc_hkjd   = v_vc_qrjd,
               a.vc_hkjw   = v_vc_qrjw,
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
    insert into zjjk_tnb_qrqcb
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
    update zjjk_tnb_bgk a
       set a.vc_qybz   = '0',
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
    
      v_json_yw_log.put('bgklx', '01');
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
  END prc_tnbbgk_qc;
  /*--------------------------------------------------------------------------
  || 功能描述 ：糖尿病报告卡迁入管理
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_tnbbgk_qr(Data_In    In Clob, --入参
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
  
    v_vc_jjqcyy zjjk_tnb_qrqcb.vc_jjqcyy%TYPE; --拒绝迁出原因
    v_vc_qrgldw zjjk_tnb_qrqcb.vc_qrgldw%TYPE; --迁入管理单位
    v_vc_id     zjjk_tnb_qrqcb.vc_id%TYPE; --系统唯一ID
    v_vc_xtlb   zjjk_tnb_qrqcb.vc_xtlb%TYPE; --系统类别 
    v_vc_bgkid  zjjk_tnb_qrqcb.vc_bgkid%TYPE; --报告卡ID
    v_vc_qccs   zjjk_tnb_qrqcb.vc_qccs%TYPE; --迁出市
    v_vc_qcqx   zjjk_tnb_qrqcb.vc_qcqx%TYPE; --迁出区县
    v_vc_qcjd   zjjk_tnb_qrqcb.vc_qcjd%TYPE; --迁出街道
    v_vc_qcdl   zjjk_tnb_qrqcb.vc_qcdl%TYPE; --迁出道路
    v_vc_qcjw   zjjk_tnb_qrqcb.vc_qcjw%TYPE; --迁出居委
    v_vc_qcxxdz zjjk_tnb_qrqcb.vc_qcxxdz%TYPE; --迁出详细地址
    v_vc_qrcs   zjjk_tnb_qrqcb.vc_qrcs%TYPE; --迁入市
    v_vc_qrqx   zjjk_tnb_qrqcb.vc_qrqx%TYPE; --迁入区县
    v_vc_qrjd   zjjk_tnb_qrqcb.vc_qrjd%TYPE; --迁入街道
    v_vc_qrdl   zjjk_tnb_qrqcb.vc_qrdl%TYPE; --迁入道路
    v_vc_qrjw   zjjk_tnb_qrqcb.vc_qrjw%TYPE; --迁入居委
    v_vc_qrxxdz zjjk_tnb_qrqcb.vc_qrxxdz%TYPE; --迁入详细地址
    v_dt_qcsj   zjjk_tnb_qrqcb.dt_qcsj%TYPE; --迁出时间
    v_dt_clsj   zjjk_tnb_qrqcb.dt_clsj%TYPE; --处理时间
    v_vc_clfs   zjjk_tnb_qrqcb.vc_clfs%TYPE; --处理方式
    v_vc_qcr    zjjk_tnb_qrqcb.vc_qcr%TYPE; --迁出人
    v_vc_clr    zjjk_tnb_qrqcb.vc_clr%TYPE; --处理人
    v_vc_zhxgr  zjjk_tnb_qrqcb.vc_zhxgr%TYPE; --最后修改人
    v_dt_zhxgsj zjjk_tnb_qrqcb.dt_zhxgsj%TYPE; --最后修改时间
    v_qyshbz    varchar2(1);
    v_hzid      zjjk_tnb_hzxx.vc_personid%TYPE; --患者ID
    v_bgkid_q   zjjk_tnb_bgk.vc_bgkid%type;
  BEGIN
    json_data(data_in, 'zjjk_tnb_bgk迁出', v_json_data);
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
        from zjjk_tnb_qrqcb a
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
      select b.vc_hks,
             b.vc_hkqx,
             b.vc_hkjd,
             b.vc_hkjw,
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
        from zjjk_tnb_bgk a, zjjk_tnb_hzxx b
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
      update zjjk_tnb_hzxx a
         set a.vc_hks    = v_vc_qrcs,
             a.vc_hkqx   = v_vc_qrqx,
             a.vc_hkjd   = v_vc_qrjd,
             a.vc_hkjw   = v_vc_qrjw,
             a.vc_hkxxdz = v_vc_qrxxdz
       where a.vc_personid = v_hzid;
    end if;
    --更新迁移记录
    update zjjk_tnb_qrqcb a
       set a.vc_clfs   = v_vc_clfs,
           a.vc_jjqcyy = v_vc_jjqcyy,
           a.vc_clr    = v_czyyhid,
           a.dt_clsj   = v_sysdate,
           a.dt_zhxgsj = v_sysdate
     where a.vc_id = v_vc_id;
    --更新报告卡
    update zjjk_tnb_bgk a
       set a.vc_qybz = '0', a.vc_gldw = v_vc_qrgldw, dt_xgsj = sysdate
     where a.vc_bgkid = v_vc_bgkid;
  
    --操作日志
    v_json_yw_log := Json_ext.get_json(v_json_data, 'ywjllog');
    if v_json_yw_log is not null then
      v_json_yw_log.put('bgkid', v_vc_bgkid);
    
      v_json_yw_log.put('bgklx', '01');
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
  END prc_tnbbgk_qr;
  /*--------------------------------------------------------------------------
  || 功能描述 ：糖尿病报告卡查重
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_tnbbgk_cc(Data_In    In Clob, --入参
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
    v_czyyhid       zjjk_tnb_qrqcb.vc_qcr%type;
    v_czyjgjb       varchar2(3);
    v_json_list_yx  json_List; --有效卡
    v_json_list_cf  json_List; --重复卡
    v_json_temp_bgk Json;
    v_vc_bgkid      zjjk_tnb_bgk.vc_bgkid%type;
  
  BEGIN
    json_data(data_in, 'zjjk_tnb_bgk查重', v_json_data);
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
        update zjjk_tnb_bgk a
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
        update zjjk_tnb_bgk a
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
      v_json_yw_log.put('bgklx', '01');
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
  END prc_tnbbgk_cc;
  /*--------------------------------------------------------------------------
  || 功能描述 ：糖尿病死亡补发
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_tnbbgk_swbf(Data_In    In Clob, --入参
                            result_out OUT VARCHAR2) --返回
   is
    v_json_data   json;
    v_json_yw_log json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
  
    --公共变量
    v_sysdate   date;
    v_czyjgdm   varchar2(50);
    v_czyjgjb   varchar2(3);
    v_czyyhid   varchar2(50);
    v_tnb_bgkid varchar2(4000);
    v_sw_bgkid  varchar2(4000);
    v_pplx      varchar2(1);
  
  BEGIN
    json_data(data_in, 'zjjk_tnb_bgk死亡补发', v_json_data);
    v_sysdate   := sysdate;
    v_czyjgdm   := Json_Str(v_Json_Data, 'czyjgdm'); --操作员机构代码
    v_czyjgjb   := Json_Str(v_Json_Data, 'czyjgjb'); --获取机构级别
    v_czyyhid   := Json_Str(v_Json_Data, 'czyyhid'); --操作员id
    v_tnb_bgkid := Json_Str(v_Json_Data, 'vc_tnb_bgkid'); --糖尿病报卡id
    v_sw_bgkid  := Json_Str(v_Json_Data, 'vc_sw_bgkid'); --死亡报卡id
    v_pplx      := Json_Str(v_Json_Data, 'pplx'); --匹配类型
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
      if v_tnb_bgkid is null then
        v_err := '未获取到糖尿病报卡id!';
        raise err_custom;
      end if;      
      update zjmb_sw_bgk a
         set a.vc_tnbbfzt = '1'
       where a.vc_bgkid = v_sw_bgkid;
      if sql%rowcount = 0 then
        v_err := '死亡报告id未找到对应的报卡!';
        raise err_custom;
      end if;
      update zjjk_tnb_bgk a
         set a.vc_bgkzt = '7',
             dt_xgsj = sysdate,
             (a.vc_swicd10, a.dt_swrq) =
             (select b.vc_gbsy, b.dt_swrq
                from zjmb_sw_bgk b
               where b.vc_bgkid = v_sw_bgkid)
       where a.vc_bgkid in
             (select distinct column_value column_value
                from table(split(v_tnb_bgkid, ',')))
         and nvl(a.vc_bgkzt, '0') <> '7';
      --未匹配上
    elsif v_pplx = '0' then
      update zjmb_sw_bgk a
         set a.vc_tnbbfzt = '2'
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
      v_json_yw_log.put('bgklx', '01');
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
  END prc_tnbbgk_swbf;
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
    v_id      zjjk_yw_log.id%TYPE; --ID
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
    if v_yhm is not null and v_gnmc is not null and v_czlx is not null then
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
        (sys_guid(),
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
  
  EXCEPTION
    WHEN err_custom THEN
      result_out := v_err;
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := v_err;
  END prc_zjjk_yw_log_update;
  /*--------------------------------------------------------------------------
  || 功能描述 ：获取行政区划名称
  ||------------------------------------------------------------------------*/
  FUNCTION fun_getxzqhmc(prm_xzdm VARCHAR2) --市区及医院码
   RETURN VARCHAR2 is
    v_mc VARCHAR2(300);
  begin
    if prm_xzdm is null then
      return '';
    end if;
    select max(mc) into v_mc from p_xzdm where dm = prm_xzdm;
    return v_mc;
  END fun_getxzqhmc;
  /*--------------------------------------------------------------------------
  || 功能描述 ：获取字典对应的code
  ||------------------------------------------------------------------------*/
  FUNCTION fun_getcommdic(v_fldm VARCHAR2, --分类代码
                          v_dm   varchar2) --代码
   RETURN VARCHAR2 is
    v_mc VARCHAR2(3000);
  begin
    if v_fldm is null or v_dm is null then
      return '';
    end if;
    select max(mc)
      into v_mc
      from p_tyzdml
     where fldm = v_fldm
       and dm = v_dm;
    return v_mc;
  END fun_getcommdic;
  /*--------------------------------------------------------------------------
  || 功能描述 ：获取字典代码
  ||------------------------------------------------------------------------*/
  FUNCTION fun_getcommdiccode(v_fldm  VARCHAR2, --分类代码
                              v_value varchar2) --代码
   RETURN VARCHAR2 is
    v_dm VARCHAR2(300);
  begin
    if v_fldm is null or v_value is null then
      return '';
    end if;
    select max(dm)
      into v_dm
      from p_tyzdml
     where fldm = v_fldm
       and mc = v_value;
    return v_dm;
  END fun_getcommdiccode;
  /*--------------------------------------------------------------------------
  || 功能描述 ：获取行政区划代码
  ||------------------------------------------------------------------------*/
  FUNCTION fun_getxxqhdm(v_xzjb VARCHAR2, --分类代码
                         v_xzmc varchar2, --名称
                         v_code varchar2) --代码
   RETURN VARCHAR2 is
    v_dm VARCHAR2(300);
  begin
    if v_xzjb is null or v_xzmc is null then
      return '';
    end if;
    if v_code is null then
      select max(dm)
        into v_dm
        from p_xzdm
       where jb = v_xzjb
         and mc like v_xzmc || '%';
    else
      select max(dm)
        into v_dm
        from p_xzdm
       where jb = v_xzjb
         and mc like v_xzmc || '%'
         and dm like v_code || '%';
    end if;
    return v_dm;
  END fun_getxxqhdm;
  /*--------------------------------------------------------------------------
  || 功能描述 ：获取机构名称
  ||------------------------------------------------------------------------*/
  FUNCTION fun_getyljgmc(prm_jgdm VARCHAR2) --医疗机构代码
   RETURN VARCHAR2 is
    v_mc VARCHAR2(300);
  begin
    if prm_jgdm is null then
      return '';
    end if;
    select nvl(max(mc), prm_jgdm)
      into v_mc
      from p_yljg
     where dm = prm_jgdm;
    return v_mc;
  END fun_getyljgmc;
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
    v_cfzt := '0';
    select min(dt_sfrq), max(dt_sfrq)
      into v_cfsj, v_sfsj
      from zjjk_tnb_sfk a
     where a.vc_bgkid = p_bgkid;
    --存在初访
    if v_cfsj is not null then
      v_cfzt := '1';
    end if;
    --初访时间和随访时间不等，存在随访
    if v_cfsj <> v_sfsj then
      v_cfzt := '3';
    end if;
    --更新报卡初随访状态
    update zjjk_tnb_bgk a
       set a.vc_cfzt = v_cfzt,
           a.dt_cfsj = v_cfsj,
           a.dt_sfsj = v_sfsj,
           dt_xgsj   = sysdate
     where a.vc_bgkid = p_bgkid;
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_bgkcsfzt_update;
  /*--------------------------------------------------------------------------
  || 功能描述 ：获取多选的字典名称
  ||------------------------------------------------------------------------*/
  FUNCTION fun_getdicnames(v_fldm   VARCHAR2, --分类代码
                           v_values varchar2) --代码
   RETURN VARCHAR2 is
    v_mcs VARCHAR2(4000);
  begin
    if v_fldm is null or v_values is null then
      return '';
    end if;
    SELECT CASE
             WHEN COUNT(1) >= 100 THEN
              wm_concat(mc) || '...'
             ELSE
              wm_concat(mc)
           END
      into v_mcs
      from p_tyzdml
     where fldm = v_fldm
       and ',' || v_values || ',' LIKE '%,' || dm || ',%'
       AND rownum <= 100;
    return v_mcs;
  END fun_getdicnames;
end pkg_zjmb_tnb;
