CREATE OR REPLACE PACKAGE BODY pkg_zjmb_xnxg AS
  --初始化包序号--
  /******************************************************************************/
  /*  程序包名 ：pkg_zjmb_tnb                                                  */
  /*  业务环节 ：浙江慢病_心脑血管管理                                             */
  /*  功能描述 ：为慢病糖尿病管理相关的存储过程及函数                           */
  /*                                                                            */
  /*  作    者 ：          作成日期 ：2018-05-31   版本编号 ：Ver 1.0.0  */
  /*----------------------------------------------------------------------------*/
  /*  修改记录 ：                                                               */
  /******************************************************************************/
  /*-------------------------------------------------------------------------*/
  /*-------------------------------------------------------------------------*/
  /*--------------------------------------------------------------------------
  || 业务环节 ：报卡管理
  || 过程名称 ：prc_tnbbgk_update
  || 错误编号 ：
  || 功能描述 ：心脑血管报告卡新增及修改
  || 参数描述 ：参数标识           说明
  ||            --------------------------------------------------------------
  ||
  ||
  || 作    者 ：          完成日期 ：2018-03-14
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_xnxg_bgk_update(Data_In    In Clob, --入参
                                result_out OUT VARCHAR2) --返回
   IS
    v_vc_lczz          zjjk_xnxg_bgk.vc_lczz%TYPE; --临床症状诊断依据
    v_vc_xdt           zjjk_xnxg_bgk.vc_xdt%TYPE; --心电图诊断依据
    v_vc_xqm           zjjk_xnxg_bgk.vc_xqm%TYPE; --血清酶诊断依据
    v_vc_njy           zjjk_xnxg_bgk.vc_njy%TYPE; --脑脊液诊断依据
    v_vc_ndt           zjjk_xnxg_bgk.vc_ndt%TYPE; --脑电图诊断依据
    v_vc_xgzy          zjjk_xnxg_bgk.vc_xgzy%TYPE; --血管造影诊断依据
    v_vc_ct            zjjk_xnxg_bgk.vc_ct%TYPE; --CT诊断依据
    v_vc_ckz           zjjk_xnxg_bgk.vc_ckz%TYPE; --磁共振诊断依据
    v_vc_sj            zjjk_xnxg_bgk.vc_sj%TYPE; --尸检诊断依据
    v_vc_sjkysjc       zjjk_xnxg_bgk.vc_sjkysjc%TYPE; --神经科医生检查诊断依据
    v_vc_bs            zjjk_xnxg_bgk.vc_bs%TYPE; --病史
    v_dt_fbrq          zjjk_xnxg_bgk.dt_fbrq%TYPE; --发病日期
    v_dt_qzrq          zjjk_xnxg_bgk.dt_qzrq%TYPE; --确诊日期
    v_vc_sfsf          zjjk_xnxg_bgk.vc_sfsf%TYPE; --是否首次发病
    v_vc_qzdw          zjjk_xnxg_bgk.vc_qzdw%TYPE; --确诊单位
    v_vc_bkdw          zjjk_xnxg_bgk.vc_bkdw%TYPE; --报卡单位市
    v_vc_bkys          zjjk_xnxg_bgk.vc_bkys%TYPE; --报卡医师
    v_dt_bkrq          zjjk_xnxg_bgk.dt_bkrq%TYPE; --报卡日期
    v_dt_swrq          zjjk_xnxg_bgk.dt_swrq%TYPE; --死亡日期
    v_vc_swys          zjjk_xnxg_bgk.vc_swys%TYPE; --死亡原因
    v_vc_bszy          zjjk_xnxg_bgk.vc_bszy%TYPE; --病史摘要
    v_vc_scbz          zjjk_xnxg_bgk.vc_scbz%TYPE; --删除标志
    v_vc_gldwdm        zjjk_xnxg_bgk.vc_gldwdm%TYPE; --管理单位代码;本区域户籍数据管理单位必须满足代码对应关系；外地户籍数据与户籍区县代码一致
    v_vc_cjdwdm        zjjk_xnxg_bgk.vc_cjdwdm%TYPE; --创建单位代码
    v_vc_ckbz          zjjk_xnxg_bgk.vc_ckbz%TYPE; --重卡标志
    v_vc_sfbb          zjjk_xnxg_bgk.vc_sfbb%TYPE; --是否补报
    v_vc_sdqrzt        zjjk_xnxg_bgk.vc_sdqrzt%TYPE; --属地确认状态
    v_dt_qrsj          zjjk_xnxg_bgk.dt_qrsj%TYPE; --确认时间
    v_vc_sdqrid        zjjk_xnxg_bgk.vc_sdqrid%TYPE; --属地确认ID
    v_dt_cjsj          zjjk_xnxg_bgk.dt_cjsj%TYPE; --创建时间
    v_vc_cjyh          zjjk_xnxg_bgk.vc_cjyh%TYPE; --创建用户
    v_dt_xgsj          zjjk_xnxg_bgk.dt_xgsj%TYPE; --修改时间
    v_vc_xgyh          zjjk_xnxg_bgk.vc_xgyh%TYPE; --修改用户
    v_vc_shbz          zjjk_xnxg_bgk.vc_shbz%TYPE; --审核标志
    v_vc_smtjid        zjjk_xnxg_bgk.vc_smtjid%TYPE; --生命统计ID
    v_vc_qcbz          zjjk_xnxg_bgk.vc_qcbz%TYPE; --迁出标志
    v_vc_mqxxdz        zjjk_xnxg_bgk.vc_mqxxdz%TYPE; --目前居住详细地址
    v_vc_czhkjw        zjjk_xnxg_bgk.vc_czhkjw%TYPE; --常住户口居委
    v_vc_czhkxxdz      zjjk_xnxg_bgk.vc_czhkxxdz%TYPE; --常住户口详细地址
    v_vc_czhkqx        zjjk_xnxg_bgk.vc_czhkqx%TYPE; --常住户口地址区县
    v_vc_mqjzqx        zjjk_xnxg_bgk.vc_mqjzqx%TYPE; --目前居住地址区县
    v_vc_swysicd       zjjk_xnxg_bgk.vc_swysicd%TYPE; --死亡原因ICD
    v_vc_swysmc        zjjk_xnxg_bgk.vc_swysmc%TYPE; --死亡原因名称
    v_vc_bkdwqx        zjjk_xnxg_bgk.vc_bkdwqx%TYPE; --报卡单位区县
    v_vc_bkdwyy        zjjk_xnxg_bgk.vc_bkdwyy%TYPE; --报卡单位医院
    v_vc_sfcf          zjjk_xnxg_bgk.vc_sfcf%TYPE; --是否初访
    v_vc_kzt           zjjk_xnxg_bgk.vc_kzt%TYPE; --报告卡状态;0.可用卡；2.死卡；3.误诊卡；4.重复卡；5.删除卡；6.失访卡；7.死亡卡
    v_vc_qcd           zjjk_xnxg_bgk.vc_qcd%TYPE; --迁出省
    v_vc_qcsdm         zjjk_xnxg_bgk.vc_qcsdm%TYPE; --迁出市
    v_vc_qcqxdm        zjjk_xnxg_bgk.vc_qcqxdm%TYPE; --迁出区
    v_vc_qcjddm        zjjk_xnxg_bgk.vc_qcjddm%TYPE; --迁出街道
    v_vc_qcjw          zjjk_xnxg_bgk.vc_qcjw%TYPE; --迁出居委
    v_vc_sfqc          zjjk_xnxg_bgk.vc_sfqc%TYPE; --是否迁出
    v_dt_qcsj          zjjk_xnxg_bgk.dt_qcsj%TYPE; --迁出时间
    v_vc_qcxxdz        zjjk_xnxg_bgk.vc_qcxxdz%TYPE; --迁出详细地址
    v_vc_shid          zjjk_xnxg_bgk.vc_shid%TYPE; --审核ID
    v_vc_khzt          zjjk_xnxg_bgk.vc_khzt%TYPE; --考核状态
    v_vc_khid          zjjk_xnxg_bgk.vc_khid%TYPE; --考核ID
    v_vc_khjg          zjjk_xnxg_bgk.vc_khjg%TYPE; --考核结果
    v_vc_ccid          zjjk_xnxg_bgk.vc_ccid%TYPE; --查重ID
    v_vc_khbz          zjjk_xnxg_bgk.vc_khbz%TYPE; --考核标志
    v_vc_shzt          zjjk_xnxg_bgk.vc_shzt%TYPE; --审核状态
    v_vc_sfsw          zjjk_xnxg_bgk.vc_sfsw%TYPE; --是否死亡
    v_vc_shwtgyy       zjjk_xnxg_bgk.vc_shwtgyy%TYPE; --区县审核未通过原因
    v_vc_shwtgyy1      zjjk_xnxg_bgk.vc_shwtgyy1%TYPE; --区县审核未通过原因选项
    v_vc_wtzt          zjjk_xnxg_bgk.vc_wtzt%TYPE; --委托状态
    v_vc_ywtdw         zjjk_xnxg_bgk.vc_ywtdw%TYPE; --原委托单位
    v_vc_sqsl          zjjk_xnxg_bgk.vc_sqsl%TYPE; --街道对应社区数量
    v_vc_jjsl          zjjk_xnxg_bgk.vc_jjsl%TYPE; --拒绝数量
    v_vc_ywtjd         zjjk_xnxg_bgk.vc_ywtjd%TYPE; --原委托街道
    v_vc_ywtjw         zjjk_xnxg_bgk.vc_ywtjw%TYPE; --原委托居委
    v_vc_ywtxxdz       zjjk_xnxg_bgk.vc_ywtxxdz%TYPE; --原委托详细地址
    v_vc_ywtjgdm       zjjk_xnxg_bgk.vc_ywtjgdm%TYPE; --原委托机构代码
    v_vc_lszy          zjjk_xnxg_bgk.vc_lszy%TYPE; --历史数据导入的职业
    v_vc_cgzsjjg       zjjk_xnxg_bgk.vc_cgzsjjg%TYPE; --时间间隔
    v_vc_syzz          zjjk_xnxg_bgk.vc_syzz%TYPE; --首要症状
    v_vc_shtd          zjjk_xnxg_bgk.vc_shtd%TYPE; --死后推断
    v_vc_state         zjjk_xnxg_bgk.vc_state%TYPE; --随访结果
    v_dt_yyshsj        zjjk_xnxg_bgk.dt_yyshsj%TYPE; --医院审核时间
    v_dt_qxshsj        zjjk_xnxg_bgk.dt_qxshsj%TYPE; --区县审核时间
    v_vc_bksznl        zjjk_xnxg_bgk.vc_bksznl%TYPE; --实足年龄
    v_dt_cfsj          zjjk_xnxg_bgk.dt_cfsj%TYPE; --初访时间
    v_dt_sfsj          zjjk_xnxg_bgk.dt_sfsj%TYPE; --随访时间
    v_vc_bak_hy        zjjk_xnxg_bgk.vc_bak_hy%TYPE; --备份职业
    v_vc_bak_zy        zjjk_xnxg_bgk.vc_bak_zy%TYPE; --备份行业
    v_vc_zssj          zjjk_xnxg_bgk.vc_zssj%TYPE; --
    v_vc_gxbz          zjjk_xnxg_bgk.vc_gxbz%TYPE; --更新标志
    v_vc_kz            zjjk_xnxg_bgk.vc_kz%TYPE; --
    v_vc_yyrid         zjjk_xnxg_bgk.vc_yyrid%TYPE; --
    v_dt_qxshrq        zjjk_xnxg_bgk.dt_qxshrq%TYPE; --
    v_vc_nzzzyzz       zjjk_xnxg_bgk.vc_nzzzyzz%TYPE; --
    v_vc_bak_sfzh      zjjk_xnxg_bgk.vc_bak_sfzh%TYPE; --备份身份证号
    v_upload_areaeport zjjk_xnxg_bgk.upload_areaeport%TYPE; --
    v_vc_bgkid         zjjk_xnxg_bgk.vc_bgkid%TYPE; --报告卡ID
    v_vc_mzh           zjjk_xnxg_bgk.vc_mzh%TYPE; --门诊号
    v_vc_zyh           zjjk_xnxg_bgk.vc_zyh%TYPE; --住院号
    v_vc_bgkbh         zjjk_xnxg_bgk.vc_bgkbh%TYPE; --报告卡(卡片)编号
    v_vc_bgklx         zjjk_xnxg_bgk.vc_bgklx%TYPE; --报告卡类型;1.常规卡；2.死亡补发卡
    v_vc_hzxm          zjjk_xnxg_bgk.vc_hzxm%TYPE; --患者姓名
    v_vc_hzxb          zjjk_xnxg_bgk.vc_hzxb%TYPE; --患者性别
    v_vc_hzhy          zjjk_xnxg_bgk.vc_hzhy%TYPE; --患者婚姻
    v_vc_hzicd         zjjk_xnxg_bgk.vc_hzicd%TYPE; --患者ICD编码（ICD-10）
    v_dt_hzcsrq        zjjk_xnxg_bgk.dt_hzcsrq%TYPE; --患者出生日期
    v_vc_sznl          zjjk_xnxg_bgk.vc_sznl%TYPE; --实足年龄
    v_vc_hzzy          zjjk_xnxg_bgk.vc_hzzy%TYPE; --职业
    v_vc_hzsfzh        zjjk_xnxg_bgk.vc_hzsfzh%TYPE; --患者身份证号
    v_vc_jtgz          zjjk_xnxg_bgk.vc_jtgz%TYPE; --具体工种
    v_vc_hzwhcd        zjjk_xnxg_bgk.vc_hzwhcd%TYPE; --患者文化程度
    v_vc_hzmz          zjjk_xnxg_bgk.vc_hzmz%TYPE; --患者民族
    v_vc_hzjtdh        zjjk_xnxg_bgk.vc_hzjtdh%TYPE; --患者家庭电话
    v_vc_gzdw          zjjk_xnxg_bgk.vc_gzdw%TYPE; --工作单位
    v_vc_czhks         zjjk_xnxg_bgk.vc_czhks%TYPE; --常住户口地址省
    v_vc_czhksi        zjjk_xnxg_bgk.vc_czhksi%TYPE; --常住户口地址市
    v_vc_czhkjd        zjjk_xnxg_bgk.vc_czhkjd%TYPE; --常住户口地址街道
    v_vc_mqjzs         zjjk_xnxg_bgk.vc_mqjzs%TYPE; --目前居住地址省
    v_vc_mqjzsi        zjjk_xnxg_bgk.vc_mqjzsi%TYPE; --目前居住地址市
    v_vc_mqjzjd        zjjk_xnxg_bgk.vc_mqjzjd%TYPE; --目前居住地址街道
    v_vc_mqjzjw        zjjk_xnxg_bgk.vc_mqjzjw%TYPE; --目前居住地址居委
    v_vc_gxbzd         zjjk_xnxg_bgk.vc_gxbzd%TYPE; --冠心病诊断
    v_vc_nczzd         zjjk_xnxg_bgk.vc_nczzd%TYPE; --脑卒中诊断
    v_vc_hkjd_bgq      zjjk_xnxg_bgk.vc_czhkjd%type; --原本户口街道
    v_vc_hkqx_bgq      zjjk_xnxg_bgk.vc_czhkqx%type; --原本户口区县
		v_vc_hkjw_bgq      zjjk_xnxg_bgk.vc_czhkjw%TYPE; --户口居委
    v_vc_hkxx_bgq      zjjk_xnxg_bgk.vc_czhkxxdz%TYPE; --户口详细地址
  
    --公共变量
    v_czyhjgjb    varchar2(20);
    v_czyjgdm     varchar2(50);
    v_czyyhid     varchar2(50);
    v_json_data   json;
    v_json_yw_log json;
    v_json_return json := json();
    v_ywjl_czlx   varchar2(3);
    err_custom EXCEPTION;
    v_err         VARCHAR2(2000);
    v_sysdate     date;
    v_count       number(2);
    v_ywrzid      zjjk_yw_log.id%TYPE; --业务日志id
    v_tab_bgk_old zjjk_xnxg_bgk%rowtype; --心脑血管报告卡变更前
    v_tab_bgk_new zjjk_xnxg_bgk%rowtype; --心脑血管报告卡变更后
  
  BEGIN
    json_data(Data_In, 'zjjk_xnxg_bgk新增或修改', v_json_data);
  
    --初随访卡赋值
    v_sysdate          := sysdate;
    v_czyhjgjb         := json_str(v_json_data, 'czyjgjb');
    v_czyjgdm          := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyyhid          := Json_Str(v_Json_Data, 'czyyhid');
    v_vc_lczz          := Json_Str(v_Json_Data, 'vc_lczz');
    v_vc_xdt           := Json_Str(v_Json_Data, 'vc_xdt');
    v_vc_xqm           := Json_Str(v_Json_Data, 'vc_xqm');
    v_vc_njy           := Json_Str(v_Json_Data, 'vc_njy');
    v_vc_ndt           := Json_Str(v_Json_Data, 'vc_ndt');
    v_vc_xgzy          := Json_Str(v_Json_Data, 'vc_xgzy');
    v_vc_ct            := Json_Str(v_Json_Data, 'vc_ct');
    v_vc_ckz           := Json_Str(v_Json_Data, 'vc_ckz');
    v_vc_sj            := Json_Str(v_Json_Data, 'vc_sj');
    v_vc_sjkysjc       := Json_Str(v_Json_Data, 'vc_sjkysjc');
    v_vc_bs            := Json_Str(v_Json_Data, 'vc_bs');
    v_dt_fbrq          := std(Json_Str(v_Json_Data, 'dt_fbrq'), 1);
    v_dt_qzrq          := std(Json_Str(v_Json_Data, 'dt_qzrq'), 1);
    v_vc_sfsf          := Json_Str(v_Json_Data, 'vc_sfsf');
    v_vc_qzdw          := Json_Str(v_Json_Data, 'vc_qzdw');
    v_vc_bkdw          := Json_Str(v_Json_Data, 'vc_bkdw');
    v_vc_bkys          := Json_Str(v_Json_Data, 'vc_bkys');
    v_dt_bkrq          := std(Json_Str(v_Json_Data, 'dt_bkrq'), 1);
    v_dt_swrq          := std(Json_Str(v_Json_Data, 'dt_swrq'), 1);
    v_vc_swys          := Json_Str(v_Json_Data, 'vc_swys');
    v_vc_bszy          := Json_Str(v_Json_Data, 'vc_bszy');
    v_vc_scbz          := Json_Str(v_Json_Data, 'vc_scbz');
    v_vc_gldwdm        := Json_Str(v_Json_Data, 'czyjgdm');
    v_vc_cjdwdm        := Json_Str(v_Json_Data, 'czyjgdm');
    v_vc_ckbz          := Json_Str(v_Json_Data, 'vc_ckbz');
    v_vc_sfbb          := Json_Str(v_Json_Data, 'vc_sfbb');
    v_vc_sdqrzt        := Json_Str(v_Json_Data, 'vc_sdqrzt');
    v_dt_qrsj          := std(Json_Str(v_Json_Data, 'dt_qrsj'), 1);
    v_vc_sdqrid        := Json_Str(v_Json_Data, 'vc_sdqrid');
    v_dt_cjsj          := v_sysdate;
    v_vc_cjyh          := Json_Str(v_Json_Data, 'v_czyyhid');
    v_dt_xgsj          := v_sysdate;
    v_vc_xgyh          := Json_Str(v_Json_Data, 'v_czyyhid');
    v_vc_shbz          := Json_Str(v_Json_Data, 'vc_shbz');
    v_vc_smtjid        := Json_Str(v_Json_Data, 'vc_smtjid');
    v_vc_qcbz          := Json_Str(v_Json_Data, 'vc_qcbz');
    v_vc_mqxxdz        := Json_Str(v_Json_Data, 'vc_mqxxdz');
    v_vc_czhkjw        := Json_Str(v_Json_Data, 'vc_czhkjw');
    v_vc_czhkxxdz      := Json_Str(v_Json_Data, 'vc_czhkxxdz');
    v_vc_czhkqx        := Json_Str(v_Json_Data, 'vc_czhkqx');
    v_vc_mqjzqx        := Json_Str(v_Json_Data, 'vc_mqjzqx');
    v_vc_swysicd       := Json_Str(v_Json_Data, 'vc_swysicd');
    v_vc_swysmc        := Json_Str(v_Json_Data, 'vc_swysmc');
    v_vc_bkdwqx        := Json_Str(v_Json_Data, 'vc_bkdwqx');
    v_vc_sfcf          := Json_Str(v_Json_Data, 'vc_sfcf');
    v_vc_kzt           := Json_Str(v_Json_Data, 'vc_kzt');
    v_vc_qcd           := Json_Str(v_Json_Data, 'vc_qcd');
    v_vc_qcsdm         := Json_Str(v_Json_Data, 'vc_qcsdm');
    v_vc_qcqxdm        := Json_Str(v_Json_Data, 'vc_qcqxdm');
    v_vc_qcjddm        := Json_Str(v_Json_Data, 'vc_qcjddm');
    v_vc_qcjw          := Json_Str(v_Json_Data, 'vc_qcjw');
    v_vc_sfqc          := Json_Str(v_Json_Data, 'vc_sfqc');
    v_dt_qcsj          := std(Json_Str(v_Json_Data, 'dt_qcsj'), 1);
    v_vc_qcxxdz        := Json_Str(v_Json_Data, 'vc_qcxxdz');
    v_vc_shid          := Json_Str(v_Json_Data, 'vc_shid');
    v_vc_khzt          := Json_Str(v_Json_Data, 'vc_khzt');
    v_vc_khid          := Json_Str(v_Json_Data, 'vc_khid');
    v_vc_khjg          := Json_Str(v_Json_Data, 'vc_khjg');
    v_vc_ccid          := Json_Str(v_Json_Data, 'vc_ccid');
    v_vc_khbz          := Json_Str(v_Json_Data, 'vc_khbz');
    v_vc_shzt          := Json_Str(v_Json_Data, 'vc_shzt');
    v_vc_sfsw          := Json_Str(v_Json_Data, 'vc_sfsw');
    v_vc_shwtgyy       := Json_Str(v_Json_Data, 'vc_shwtgyy');
    v_vc_shwtgyy1      := Json_Str(v_Json_Data, 'vc_shwtgyy1');
    v_vc_wtzt          := Json_Str(v_Json_Data, 'vc_wtzt');
    v_vc_ywtdw         := Json_Str(v_Json_Data, 'vc_ywtdw');
    v_vc_sqsl          := Json_Str(v_Json_Data, 'vc_sqsl');
    v_vc_jjsl          := Json_Str(v_Json_Data, 'vc_jjsl');
    v_vc_ywtjd         := Json_Str(v_Json_Data, 'vc_ywtjd');
    v_vc_ywtjw         := Json_Str(v_Json_Data, 'vc_ywtjw');
    v_vc_ywtxxdz       := Json_Str(v_Json_Data, 'vc_ywtxxdz');
    v_vc_ywtjgdm       := Json_Str(v_Json_Data, 'vc_ywtjgdm');
    v_vc_lszy          := Json_Str(v_Json_Data, 'vc_lszy');
    v_vc_cgzsjjg       := Json_Str(v_Json_Data, 'vc_cgzsjjg');
    v_vc_syzz          := Json_Str(v_Json_Data, 'vc_syzz');
    v_vc_shtd          := Json_Str(v_Json_Data, 'vc_shtd');
    v_vc_state         := Json_Str(v_Json_Data, 'vc_state');
    v_dt_yyshsj        := std(Json_Str(v_Json_Data, 'dt_yyshsj'), 1);
    v_dt_qxshsj        := std(Json_Str(v_Json_Data, 'dt_qxshsj'), 1);
    v_vc_bksznl        := Json_Str(v_Json_Data, 'vc_bksznl');
    v_dt_cfsj          := std(Json_Str(v_Json_Data, 'dt_cfsj'), 1);
    v_dt_sfsj          := std(Json_Str(v_Json_Data, 'dt_sfsj'), 1);
    v_vc_bak_hy        := Json_Str(v_Json_Data, 'vc_bak_hy');
    v_vc_bak_zy        := Json_Str(v_Json_Data, 'vc_bak_zy');
    v_vc_zssj          := std(Json_Str(v_Json_Data, 'vc_zssj'), 1);
    v_vc_gxbz          := Json_Str(v_Json_Data, 'vc_gxbz');
    v_vc_kz            := Json_Str(v_Json_Data, 'vc_kz');
    v_vc_yyrid         := Json_Str(v_Json_Data, 'vc_yyrid');
    v_dt_qxshrq        := std(Json_Str(v_Json_Data, 'dt_qxshrq'), 1);
    v_vc_nzzzyzz       := Json_Str(v_Json_Data, 'vc_nzzzyzz');
    v_vc_bak_sfzh      := Json_Str(v_Json_Data, 'vc_bak_sfzh');
    v_upload_areaeport := Json_Str(v_Json_Data, 'upload_areaeport');
    v_vc_bgkid         := Json_Str(v_Json_Data, 'vc_bgkid');
    v_vc_mzh           := Json_Str(v_Json_Data, 'vc_mzh');
    v_vc_zyh           := Json_Str(v_Json_Data, 'vc_zyh');
    v_vc_bgkbh         := Json_Str(v_Json_Data, 'vc_bgkbh');
    v_vc_bgklx         := Json_Str(v_Json_Data, 'vc_bgklx');
    v_vc_hzxm          := Json_Str(v_Json_Data, 'vc_hzxm');
    v_vc_hzxb          := Json_Str(v_Json_Data, 'vc_hzxb');
    v_vc_hzhy          := Json_Str(v_Json_Data, 'vc_hzhy');
    v_vc_hzicd         := Json_Str(v_Json_Data, 'vc_hzicd');
    v_dt_hzcsrq        := std(Json_Str(v_Json_Data, 'dt_hzcsrq'), 1);
    v_vc_sznl          := Json_Str(v_Json_Data, 'vc_sznl');
    v_vc_hzzy          := Json_Str(v_Json_Data, 'vc_hzzy');
    v_vc_hzsfzh        := Json_Str(v_Json_Data, 'vc_hzsfzh');
    v_vc_jtgz          := Json_Str(v_Json_Data, 'vc_jtgz');
    v_vc_hzwhcd        := Json_Str(v_Json_Data, 'vc_hzwhcd');
    v_vc_hzmz          := Json_Str(v_Json_Data, 'vc_hzmz');
    v_vc_hzjtdh        := Json_Str(v_Json_Data, 'vc_hzjtdh');
    v_vc_gzdw          := Json_Str(v_Json_Data, 'vc_gzdw');
    v_vc_czhks         := Json_Str(v_Json_Data, 'vc_czhks');
    v_vc_czhksi        := Json_Str(v_Json_Data, 'vc_czhksi');
    v_vc_czhkjd        := Json_Str(v_Json_Data, 'vc_czhkjd');
    v_vc_mqjzs         := Json_Str(v_Json_Data, 'vc_mqjzs');
    v_vc_mqjzsi        := Json_Str(v_Json_Data, 'vc_mqjzsi');
    v_vc_mqjzjd        := Json_Str(v_Json_Data, 'vc_mqjzjd');
    v_vc_mqjzjw        := Json_Str(v_Json_Data, 'vc_mqjzjw');
    v_vc_gxbzd         := Json_Str(v_Json_Data, 'vc_gxbzd');
    v_vc_nczzd         := Json_Str(v_Json_Data, 'vc_nczzd');
  
    --检验字段必填
    --校验数据是否合法
    if v_vc_hzicd is null then
      v_err := 'ICD编码不能为空!';
      raise err_custom;
    end if;
    if v_vc_hzxm is null then
      v_err := '患者姓名不能为空!';
      raise err_custom;
    end if;
    if v_vc_hzxb is null then
      v_err := '患者性别不能为空!';
      raise err_custom;
    end if;
    if v_vc_hzhy is null then
      v_err := '患者婚姻不能为空!';
      raise err_custom;
    end if;
    if v_dt_hzcsrq is null then
      v_err := '患者出生日期不能为空!';
      raise err_custom;
    end if;
    if v_vc_hzzy is null then
      v_err := '职业不能为空!';
      raise err_custom;
    end if;
    if v_vc_hzicd is null then
      v_err := 'ICD编码姓名不能为空!';
      raise err_custom;
    end if;
    if v_vc_jtgz is null then
      v_err := '具体工种不能为空!';
      raise err_custom;
    end if;
    if v_vc_hzwhcd is null then
      v_err := '患者文化程度不能为空!';
      raise err_custom;
    end if;
    if v_vc_hzmz is null then
      v_err := '患者民族不能为空!';
      raise err_custom;
    end if;
    if v_vc_hzjtdh is null then
      v_err := '联系电话不能为空!';
      raise err_custom;
    end if;
    if v_vc_czhks is null then
      v_err := '常住户口地址省不能为空!';
      raise err_custom;
    end if;
    --户籍地址浙江
    if v_vc_czhks = '0' then
      if v_vc_czhksi is null then
        v_err := '常住户口地址市不能为空!';
        raise err_custom;
      end if;
      if v_vc_czhkqx is null then
        v_err := '常住户口地址区县不能为空!';
        raise err_custom;
      end if;
      if v_vc_czhkjd is null then
        v_err := '常住户口地址街道不能为空!';
        raise err_custom;
      end if;
      if substr(v_vc_czhksi, 1, 4) <> substr(v_vc_czhkqx, 1, 4) or
         substr(v_vc_czhksi, 1, 4) <> substr(v_vc_czhkjd, 1, 4) then
        v_err := '户籍地址区划不匹配!';
        raise err_custom;
      end if;
    end if;
    if v_vc_czhkxxdz is null then
      v_err := '常住户口详细地址不能为空!';
      raise err_custom;
    end if;
    if v_vc_mqjzs is null then
      v_err := '目前居住地址省不能为空!';
      raise err_custom;
    end if;
    --居住地址浙江
    if v_vc_mqjzs = '0' then
      if v_vc_mqjzsi is null then
        v_err := '目前居住地址市不能为空!';
        raise err_custom;
      end if;
      if v_vc_mqjzqx is null then
        v_err := '目前居住地址区县不能为空!';
        raise err_custom;
      end if;
      if v_vc_mqjzjd is null then
        v_err := '目前居住地址街道不能为空!';
        raise err_custom;
      end if;
      if substr(v_vc_mqjzsi, 1, 4) <> substr(v_vc_mqjzqx, 1, 4) or
         substr(v_vc_mqjzsi, 1, 4) <> substr(v_vc_mqjzjd, 1, 4) then
        v_err := '目前居住地址区划不匹配!';
        raise err_custom;
      end if;
    end if;
    if v_vc_mqxxdz is null then
      v_err := '目前居住详细地址不能为空!';
      raise err_custom;
    end if;
    if v_vc_gxbzd is null and v_vc_nczzd is null then
      v_err := '冠心病诊断与脑卒中诊断不能为空!';
      raise err_custom;
    end if;
    if v_vc_lczz is null then
      v_err := '临床症状诊断依据不能为空!';
      raise err_custom;
    end if;
    if v_vc_xdt is null then
      v_err := '心电图诊断依据不能为空!';
      raise err_custom;
    end if;
    if v_vc_xqm is null then
      v_err := '血清酶诊断依据不能为空!';
      raise err_custom;
    end if;
    if v_vc_njy is null then
      v_err := '脑脊液诊断依据不能为空!';
      raise err_custom;
    end if;
    if v_vc_ndt is null then
      v_err := '脑电图诊断依据能为空!';
      raise err_custom;
    end if;
    if v_vc_xgzy is null then
      v_err := '血管造影诊断依据不能为空!';
      raise err_custom;
    end if;
    if v_vc_ct is null then
      v_err := 'CT诊断依据不能为空!';
      raise err_custom;
    end if;
    if v_vc_ckz is null then
      v_err := '磁共振诊断依据不能为空!';
      raise err_custom;
    end if;
    if v_vc_sj is null then
      v_err := '尸检诊断依据不能为空!';
      raise err_custom;
    end if;
    if v_vc_sjkysjc is null then
      v_err := '神经科医生检查诊断依不能为空!';
      raise err_custom;
    end if;
    if v_vc_bs is null then
      v_err := '病史不能为空!';
      raise err_custom;
    end if;
    if v_vc_nczzd is not null and v_vc_syzz is null then
      v_err := '当脑卒中诊断非空时，首要症状(脑卒中)不能为空!';
      raise err_custom;
    end if;
    if v_dt_fbrq is null then
      v_err := '发病日期不能为空!';
      raise err_custom;
    end if;
    if v_dt_qzrq is null then
      v_err := '确诊日期不能为空!';
      raise err_custom;
    end if;
    if v_vc_bkys is null then
      v_err := '报卡医师不能为空!';
      raise err_custom;
    end if;
    if v_dt_bkrq is null then
      v_err := '报卡日期不能为空!';
      raise err_custom;
    end if;
    if v_vc_sfsf is null then
      v_err := '是否首次发病不能为空!';
      raise err_custom;
    end if;
    if v_dt_swrq is not null then
      if v_dt_swrq < v_dt_fbrq then
        v_err := '死亡日期不能早于发病日期!';
        raise err_custom;
      end if;
      if v_vc_swys is null then
        v_err := '死亡原因不能为空!';
        raise err_custom;
      end if;
      if v_vc_swysicd is null then
        v_err := '死亡原因ICD不能为空!';
        raise err_custom;
      end if;
      if v_vc_swysmc is null then
        v_err := '死亡具体原因不能为空!';
        raise err_custom;
      end if;
    end if;
  
    if v_vc_bgkid is null then
      if v_czyhjgjb <> '4' then
        v_err := '当前机构无新增权限!';
        raise err_custom;
      end if;
      v_vc_bkdwyy := v_czyjgdm;
      v_ywjl_czlx := '01';
      v_vc_wtzt   := '0';
      v_vc_bkdw   := substr(v_vc_bkdwyy, 1, 4) || '0000';
      v_vc_bkdwqx := substr(v_vc_bkdwyy, 1, 6) || '00';
      v_vc_shbz   := '1';
      v_dt_yyshsj := v_sysdate;
      v_vc_scbz   := '2';
      v_vc_kzt    := '0';
      v_vc_sfcf   := '2';
      v_vc_qcbz   := '0';
      v_dt_cjsj   := v_sysdate;
      --死亡标志
      if v_vc_swys is null then
        --未死亡
        v_vc_sfsw := '0';
      elsif v_vc_swys = '1' then
        --死亡原因为糖尿病
        v_vc_sfsw    := '1';
        v_vc_swysicd := v_vc_hzicd;
        v_vc_kzt     := '7';
      else
        v_vc_sfsw := '1';
        v_vc_kzt  := '7';
      end if;
      --生成报告卡编号
      v_vc_bgkbh := pkg_zjmb_xnxg.fun_getbgkcode(v_vc_bkdwyy, null);
      --报告卡id
      v_vc_bgkid := sys_guid();
      --属地确认
      select count(1), wm_concat(a.dm)
        into v_count, v_vc_gldwdm
        from p_yljg a
       where a.bz = 1
         and a.lb = 'B1'
         and a.xzqh = v_vc_czhkjd;
      if v_count = 1 then
        --确定属地
        v_vc_sdqrzt := '1';
      else
        v_vc_gldwdm := v_vc_czhkqx;
        v_vc_sdqrzt := '0';
      end if;
      if v_vc_czhks = '1' then
        v_vc_gldwdm := '99999999';
        v_vc_czhksi := '';
        v_vc_czhkqx := '';
        v_vc_czhkjd := '';
        v_vc_czhks  := '';
        v_vc_czhkjw := '';
        v_vc_sdqrzt := '1';
      end if;
      --插入报告卡
      insert into zjjk_xnxg_bgk
        (vc_lczz,
         vc_nczzd,
         vc_gxbzd,
         vc_mqjzjw,
         vc_mqjzjd,
         vc_mqjzsi,
         vc_mqjzs,
         vc_czhkjd,
         vc_czhksi,
         vc_czhks,
         vc_gzdw,
         vc_hzjtdh,
         vc_hzmz,
         vc_hzwhcd,
         vc_jtgz,
         vc_hzsfzh,
         vc_hzzy,
         vc_sznl,
         dt_hzcsrq,
         vc_hzicd,
         vc_hzhy,
         vc_hzxb,
         vc_hzxm,
         vc_bgklx,
         vc_bgkbh,
         vc_zyh,
         vc_mzh,
         vc_bgkid,
         vc_bak_sfzh,
         vc_nzzzyzz,
         dt_qxshrq,
         vc_yyrid,
         vc_kz,
         vc_gxbz,
         vc_zssj,
         vc_bak_zy,
         vc_bak_hy,
         dt_sfsj,
         dt_cfsj,
         vc_bksznl,
         dt_qxshsj,
         dt_yyshsj,
         vc_state,
         vc_shtd,
         vc_syzz,
         vc_cgzsjjg,
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
         vc_sfsw,
         vc_shzt,
         vc_khbz,
         vc_ccid,
         vc_khjg,
         vc_khid,
         vc_khzt,
         vc_shid,
         vc_qcxxdz,
         dt_qcsj,
         vc_sfqc,
         vc_qcjw,
         vc_qcjddm,
         vc_qcqxdm,
         vc_qcsdm,
         vc_qcd,
         vc_kzt,
         vc_sfcf,
         vc_bkdwyy,
         vc_bkdwqx,
         vc_swysmc,
         vc_swysicd,
         vc_mqjzqx,
         vc_czhkqx,
         vc_czhkxxdz,
         vc_czhkjw,
         vc_mqxxdz,
         vc_qcbz,
         vc_smtjid,
         vc_shbz,
         vc_xgyh,
         dt_xgsj,
         vc_cjyh,
         dt_cjsj,
         vc_sdqrid,
         dt_qrsj,
         vc_sdqrzt,
         vc_sfbb,
         vc_ckbz,
         vc_cjdwdm,
         vc_gldwdm,
         vc_scbz,
         vc_bszy,
         vc_swys,
         dt_swrq,
         dt_bkrq,
         vc_bkys,
         vc_bkdw,
         vc_qzdw,
         vc_sfsf,
         dt_qzrq,
         dt_fbrq,
         vc_bs,
         vc_sjkysjc,
         vc_sj,
         vc_ckz,
         vc_ct,
         vc_xgzy,
         vc_ndt,
         vc_njy,
         vc_xqm,
         vc_xdt)
      values
        (v_vc_lczz,
         v_vc_nczzd,
         v_vc_gxbzd,
         v_vc_mqjzjw,
         v_vc_mqjzjd,
         v_vc_mqjzsi,
         v_vc_mqjzs,
         v_vc_czhkjd,
         v_vc_czhksi,
         v_vc_czhks,
         v_vc_gzdw,
         v_vc_hzjtdh,
         v_vc_hzmz,
         v_vc_hzwhcd,
         v_vc_jtgz,
         v_vc_hzsfzh,
         v_vc_hzzy,
         v_vc_sznl,
         v_dt_hzcsrq,
         v_vc_hzicd,
         v_vc_hzhy,
         v_vc_hzxb,
         v_vc_hzxm,
         v_vc_bgklx,
         v_vc_bgkbh,
         v_vc_zyh,
         v_vc_mzh,
         v_vc_bgkid,
         v_vc_bak_sfzh,
         v_vc_nzzzyzz,
         v_dt_qxshrq,
         v_vc_yyrid,
         v_vc_kz,
         v_vc_gxbz,
         v_vc_zssj,
         v_vc_bak_zy,
         v_vc_bak_hy,
         v_dt_sfsj,
         v_dt_cfsj,
         v_vc_bksznl,
         v_dt_qxshsj,
         v_dt_yyshsj,
         v_vc_state,
         v_vc_shtd,
         v_vc_syzz,
         v_vc_cgzsjjg,
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
         v_vc_sfsw,
         v_vc_shzt,
         v_vc_khbz,
         v_vc_ccid,
         v_vc_khjg,
         v_vc_khid,
         v_vc_khzt,
         v_vc_shid,
         v_vc_qcxxdz,
         v_dt_qcsj,
         v_vc_sfqc,
         v_vc_qcjw,
         v_vc_qcjddm,
         v_vc_qcqxdm,
         v_vc_qcsdm,
         v_vc_qcd,
         v_vc_kzt,
         v_vc_sfcf,
         v_vc_bkdwyy,
         v_vc_bkdwqx,
         v_vc_swysmc,
         v_vc_swysicd,
         v_vc_mqjzqx,
         v_vc_czhkqx,
         v_vc_czhkxxdz,
         v_vc_czhkjw,
         v_vc_mqxxdz,
         v_vc_qcbz,
         v_vc_smtjid,
         v_vc_shbz,
         v_vc_xgyh,
         v_dt_xgsj,
         v_vc_cjyh,
         v_dt_cjsj,
         v_vc_sdqrid,
         v_dt_qrsj,
         v_vc_sdqrzt,
         v_vc_sfbb,
         v_vc_ckbz,
         v_vc_cjdwdm,
         v_vc_gldwdm,
         v_vc_scbz,
         v_vc_bszy,
         v_vc_swys,
         v_dt_swrq,
         v_dt_bkrq,
         v_vc_bkys,
         v_vc_bkdw,
         v_vc_qzdw,
         v_vc_sfsf,
         v_dt_qzrq,
         v_dt_fbrq,
         v_vc_bs,
         v_vc_sjkysjc,
         v_vc_sj,
         v_vc_ckz,
         v_vc_ct,
         v_vc_xgzy,
         v_vc_ndt,
         v_vc_njy,
         v_vc_xqm,
         v_vc_xdt);
      --插入主副卡关系
      --写入主副卡关系
      insert into zjjk_xnxg_bgk_zfgx
        (vc_zkid, vc_fkid, vc_cjjg, vc_cjry, dt_cjsj)
      values
        (v_vc_bgkid, v_vc_bgkid, v_czyjgdm, v_czyyhid, v_sysdate);
    ELSE
      begin
        select vc_czhkjd,
               vc_czhkqx,
               vc_shbz,
               vc_sdqrzt,
               vc_gldwdm,
               vc_kzt,
               vc_sfsw,
               vc_swysicd,
							 vc_czhkjw,
							 vc_czhkxxdz,
							 vc_sfcf
          into v_vc_hkjd_bgq,
               v_vc_hkqx_bgq,
               v_vc_shbz,
               v_vc_sdqrzt,
               v_vc_gldwdm,
               v_vc_kzt,
               v_vc_sfsw,
               v_vc_swysicd,
							 v_vc_hkjw_bgq,
							 v_vc_hkxx_bgq,
							 v_vc_sfcf
          from zjjk_xnxg_bgk
         where vc_bgkid = v_vc_bgkid;
      exception
        when no_data_found then
          v_err := 'id[' || v_vc_bgkid || ']未获取到有效报告卡信息!';
          raise err_custom;
      end;
      --校验管理单位审核权限
      if v_czyhjgjb = '3' then
        if substr(v_vc_gldwdm, 1, 6) <> substr(v_czyjgdm, 1, 6) and v_vc_gldwdm <> '99999999' then
          v_err := '非管理单位无此操作权限!';
          raise err_custom;
        end if;
        if v_vc_sfcf in ('1', '3') THEN
          if v_vc_hkjd_bgq <> v_vc_czhkjd or v_vc_hkqx_bgq <> v_vc_czhkqx
              OR v_vc_hkjw_bgq <> v_vc_czhkjw OR v_vc_hkxx_bgq <> v_vc_czhkxxdz THEN
            v_err := '该报卡已初访，不能修改户籍地址!';
            raise err_custom;
          END IF;
        END IF;
      end if;
      v_ywjl_czlx := '02';
      if v_czyhjgjb = '4' then
        --医院社区
        if v_vc_sfcf in ('1', '3') then
          v_err := '该报卡已初访，当前机构无权修改!';
          raise err_custom;
        end if;
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
        if v_vc_hkjd_bgq <> v_vc_czhkjd or v_vc_hkqx_bgq <> v_vc_czhkqx then
          --审核状态改为医院通过
          v_vc_shbz := '1';
          --属地确认
          select count(1), wm_concat(a.dm)
            into v_count, v_vc_gldwdm
            from p_yljg a
           where a.bz = 1
             and a.lb = 'B1'
             and a.xzqh = v_vc_czhkjd;
          if v_count = 1 then
            --确定属地
            v_vc_sdqrzt := '1';
          else
            v_vc_gldwdm := v_vc_czhkqx;
            v_vc_sdqrzt := '0';
          end if;
          --外省
          if v_vc_czhks = '1' then
            v_vc_gldwdm := '99999999';
            v_vc_czhksi := '';
            v_vc_czhkqx := '';
            v_vc_czhkjd := '';
            v_vc_czhks  := '';
            v_vc_czhkjw := '';
            v_vc_sdqrzt := '1';
          end if;
        end if;
      elsif v_czyhjgjb = '3' then
        --区县修改
        v_vc_shbz := '3';
        --修改了户籍地址
        if v_vc_hkjd_bgq <> v_vc_czhkjd or v_vc_hkqx_bgq <> v_vc_czhkqx then
          --属地确认
          select count(1), wm_concat(a.dm)
            into v_count, v_vc_gldwdm
            from p_yljg a
           where a.bz = 1
             and a.lb = 'B1'
             and a.xzqh = v_vc_czhkjd;
          if v_count = 1 then
            --确定属地
            v_vc_sdqrzt := '1';
          else
            v_vc_gldwdm := '';
            v_vc_sdqrzt := '0';
          end if;
          --外省
          if v_vc_czhks = '1' then
            v_vc_gldwdm := '99999999';
            v_vc_czhksi := '';
            v_vc_czhkqx := '';
            v_vc_czhkjd := '';
            v_vc_czhks  := '';
            v_vc_czhkjw := '';
            v_vc_sdqrzt := '1';
          end if;
        end if;
      else
        --非区县
        v_err := '当前机构无修改权限!';
        raise err_custom;
      end if;
      --死亡标志
      if v_vc_swys is null then
        --未死亡
        v_vc_sfsw := '0';
        if v_vc_kzt = '7' then
          v_vc_kzt := '0';
        end if;
      elsif v_vc_swys = '1' then
        --死亡原因为心脑
        v_vc_sfsw    := '1';
        v_vc_swysicd := v_vc_hzicd;
        v_vc_kzt     := '7';
      else
        v_vc_sfsw := '1';
        v_vc_kzt  := '7';
      end if;
      --获取变更前信息
      select *
        into v_tab_bgk_old
        from zjjk_xnxg_bgk
       where vc_bgkid = v_vc_bgkid;
    
      UPDATE zjjk_xnxg_bgk
         SET vc_shbz     = v_vc_shbz,
             vc_sdqrzt   = v_vc_sdqrzt,
             vc_gldwdm   = v_vc_gldwdm,
             vc_kzt      = v_vc_kzt,
             vc_sfsw     = v_vc_sfsw,
             vc_bgklx    = v_vc_bgklx,
             vc_hzicd    = v_vc_hzicd,
             vc_mzh      = v_vc_mzh,
             VC_ZYH      = v_vc_zyh,
             vc_hzxm     = v_vc_hzxm,
             vc_hzsfzh   = v_vc_hzsfzh,
             vc_hzxb     = v_vc_hzxb,
             dt_hzcsrq   = v_dt_hzcsrq,
             vc_hzmz     = v_vc_hzmz,
             vc_hzhy     = v_vc_hzhy,
             vc_hzzy     = v_vc_hzzy,
             vc_jtgz     = v_vc_jtgz,
             vc_hzwhcd   = v_vc_hzwhcd,
             vc_gzdw     = v_vc_gzdw,
             vc_hzjtdh   = v_vc_hzjtdh,
             vc_bksznl   = v_vc_bksznl,
             vc_czhks    = v_vc_czhks,
             vc_czhksi   = v_vc_czhksi,
             vc_czhkqx   = v_vc_czhkqx,
             vc_czhkjd   = v_vc_czhkjd,
             vc_czhkjw   = v_vc_czhkjw,
             vc_czhkxxdz = v_vc_czhkxxdz,
             vc_mqjzs    = v_vc_mqjzs,
             vc_mqjzsi   = v_vc_mqjzsi,
             vc_mqjzqx   = v_vc_mqjzqx,
             vc_mqjzjd   = v_vc_mqjzjd,
             vc_mqjzjw   = v_vc_mqjzjw,
             vc_mqxxdz   = v_vc_mqxxdz,
             vc_gxbzd    = v_vc_gxbzd,
             vc_nczzd    = v_vc_nczzd,
             vc_lczz     = v_vc_lczz,
             vc_xgzy     = v_vc_xgzy,
             vc_xdt      = v_vc_xdt,
             vc_ct       = v_vc_ct,
             vc_xqm      = v_vc_xqm,
             vc_ckz      = v_vc_ckz,
             vc_njy      = v_vc_njy,
             vc_sj       = v_vc_sj,
             vc_ndt      = v_vc_ndt,
             vc_sjkysjc  = v_vc_sjkysjc,
             vc_shtd     = v_vc_shtd,
             vc_cgzsjjg  = v_vc_cgzsjjg,
             vc_syzz     = v_vc_syzz,
             vc_bs       = v_vc_bs,
             dt_fbrq     = v_dt_fbrq,
             dt_qzrq     = v_dt_qzrq,
             vc_qzdw     = v_vc_qzdw,
             vc_sfsf     = v_vc_sfsf,
             dt_swrq     = v_dt_swrq,
             vc_swys     = v_vc_swys,
             vc_swysicd  = v_vc_swysicd,
             vc_swysmc   = v_vc_swysmc,
             vc_bkys     = v_vc_bkys,
             dt_bkrq     = v_dt_bkrq,
             vc_bszy     = v_vc_bszy,
             dt_xgsj     = sysdate,
             dt_qxshsj = case
                           when v_vc_shbz = '3' and dt_qxshsj is null then
                            v_sysdate
                           else
                            dt_qxshsj
                         end
       WHERE vc_bgkid = v_vc_bgkid;
      --记录报卡变更日志
      v_ywrzid := sys_guid();
      --获取变更后信息
      select *
        into v_tab_bgk_new
        from zjjk_xnxg_bgk
       where vc_bgkid = v_vc_bgkid;
      --写入变更记录
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '03',
                                         'vc_shbz',
                                         '审核状态',
                                         v_tab_bgk_old.vc_shbz,
                                         v_tab_bgk_new.vc_shbz,
                                         'C_COMM_SHZT',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '03',
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
                                         '03',
                                         'vc_gldwdm',
                                         '管理单位',
                                         v_tab_bgk_old.vc_gldwdm,
                                         v_tab_bgk_new.vc_gldwdm,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '03',
                                         'vc_kzt',
                                         '报告卡状态',
                                         v_tab_bgk_old.vc_kzt,
                                         v_tab_bgk_new.vc_kzt,
                                         'C_COMM_BGKZT',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '03',
                                         'vc_sfsw',
                                         '是否死亡',
                                         v_tab_bgk_old.vc_sfsw,
                                         v_tab_bgk_new.vc_sfsw,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '03',
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
                                         '03',
                                         'vc_hzicd',
                                         'ICD编码（ICD-10）',
                                         v_tab_bgk_old.vc_hzicd,
                                         v_tab_bgk_new.vc_hzicd,
                                         'C_XNXG_ICD10',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '03',
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
                                         '03',
                                         'VC_ZYH',
                                         '住院号',
                                         v_tab_bgk_old.VC_ZYH,
                                         v_tab_bgk_new.VC_ZYH,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '03',
                                         'vc_hzxm',
                                         '患者姓名',
                                         v_tab_bgk_old.vc_hzxm,
                                         v_tab_bgk_new.vc_hzxm,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '03',
                                         'vc_hzsfzh',
                                         '身份证号',
                                         v_tab_bgk_old.vc_hzsfzh,
                                         v_tab_bgk_new.vc_hzsfzh,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '03',
                                         'vc_hzxb',
                                         '性别',
                                         v_tab_bgk_old.vc_hzxb,
                                         v_tab_bgk_new.vc_hzxb,
                                         'C_COMM_XB',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '03',
                                         'dt_hzcsrq',
                                         '出生日期',
                                         dts(v_tab_bgk_old.dt_hzcsrq, 0),
                                         dts(v_tab_bgk_new.dt_hzcsrq, 0),
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '03',
                                         'vc_hzmz',
                                         '民族',
                                         v_tab_bgk_old.vc_hzmz,
                                         v_tab_bgk_new.vc_hzmz,
                                         'C_COMM_MZ',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '03',
                                         'vc_hzhy',
                                         '婚姻状况',
                                         v_tab_bgk_old.vc_hzhy,
                                         v_tab_bgk_new.vc_hzhy,
                                         'C_COMM_HYZK',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '03',
                                         'vc_hzzy',
                                         '职业',
                                         v_tab_bgk_old.vc_hzzy,
                                         v_tab_bgk_new.vc_hzzy,
                                         'C_COMM_HY',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '03',
                                         'vc_jtgz',
                                         '具体工种',
                                         v_tab_bgk_old.vc_jtgz,
                                         v_tab_bgk_new.vc_jtgz,
                                         'C_COMM_ZY',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '03',
                                         'vc_hzwhcd',
                                         '文化程度',
                                         v_tab_bgk_old.vc_hzwhcd,
                                         v_tab_bgk_new.vc_hzwhcd,
                                         'C_COMM_WHCD',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '03',
                                         'vc_gzdw',
                                         '工作单位',
                                         v_tab_bgk_old.vc_gzdw,
                                         v_tab_bgk_new.vc_gzdw,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '03',
                                         'vc_hzjtdh',
                                         '联系电话',
                                         v_tab_bgk_old.vc_hzjtdh,
                                         v_tab_bgk_new.vc_hzjtdh,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '03',
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
                                         '03',
                                         'vc_czhks',
                                         '常住户口省',
                                         v_tab_bgk_old.vc_czhks,
                                         v_tab_bgk_new.vc_czhks,
                                         'C_COMM_SHEDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '03',
                                         'vc_czhksi',
                                         '户口市',
                                         v_tab_bgk_old.vc_czhksi,
                                         v_tab_bgk_new.vc_czhksi,
                                         'P_XZDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '03',
                                         'vc_czhkqx',
                                         '户口区县',
                                         v_tab_bgk_old.vc_czhkqx,
                                         v_tab_bgk_new.vc_czhkqx,
                                         'P_XZDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '03',
                                         'vc_czhkjd',
                                         '户口街道',
                                         v_tab_bgk_old.vc_czhkjd,
                                         v_tab_bgk_new.vc_czhkjd,
                                         'P_XZDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '03',
                                         'vc_czhkjw',
                                         '户口居委',
                                         v_tab_bgk_old.vc_czhkjw,
                                         v_tab_bgk_new.vc_czhkjw,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '03',
                                         'vc_czhkxxdz',
                                         '户口详细地址',
                                         v_tab_bgk_old.vc_czhkxxdz,
                                         v_tab_bgk_new.vc_czhkxxdz,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '03',
                                         'vc_mqjzs',
                                         '居住地省',
                                         v_tab_bgk_old.vc_mqjzs,
                                         v_tab_bgk_new.vc_mqjzs,
                                         'C_COMM_SHEDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '03',
                                         'vc_mqjzsi',
                                         '居住地市',
                                         v_tab_bgk_old.vc_mqjzsi,
                                         v_tab_bgk_new.vc_mqjzsi,
                                         'P_XZDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '03',
                                         'vc_mqjzqx',
                                         '居住地区县',
                                         v_tab_bgk_old.vc_mqjzqx,
                                         v_tab_bgk_new.vc_mqjzqx,
                                         'P_XZDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '03',
                                         'vc_mqjzjd',
                                         '居住地街道',
                                         v_tab_bgk_old.vc_mqjzjd,
                                         v_tab_bgk_new.vc_mqjzjd,
                                         'P_XZDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '03',
                                         'vc_mqjzjw',
                                         '居住地居委',
                                         v_tab_bgk_old.vc_mqjzjw,
                                         v_tab_bgk_new.vc_mqjzjw,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '03',
                                         'vc_mqxxdz',
                                         '居住地详细地址',
                                         v_tab_bgk_old.vc_mqxxdz,
                                         v_tab_bgk_new.vc_mqxxdz,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '03',
                                         'vc_gxbzd',
                                         '冠心病诊断',
                                         v_tab_bgk_old.vc_gxbzd,
                                         v_tab_bgk_new.vc_gxbzd,
                                         'C_XNXG_GXBZD',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '03',
                                         'vc_nczzd',
                                         '脑卒中诊断',
                                         v_tab_bgk_old.vc_nczzd,
                                         v_tab_bgk_new.vc_nczzd,
                                         'C_XNXG_NCZZD',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '03',
                                         'vc_lczz',
                                         '临床症状',
                                         v_tab_bgk_old.vc_lczz,
                                         v_tab_bgk_new.vc_lczz,
                                         'C_XNXG_ZDYJ',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '03',
                                         'vc_xgzy',
                                         '血管造影',
                                         v_tab_bgk_old.vc_xgzy,
                                         v_tab_bgk_new.vc_xgzy,
                                         'C_XNXG_ZDYJ',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '03',
                                         'vc_xdt',
                                         '心电图',
                                         v_tab_bgk_old.vc_xdt,
                                         v_tab_bgk_new.vc_xdt,
                                         'C_XNXG_ZDYJ',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '03',
                                         'vc_ct',
                                         'CT',
                                         v_tab_bgk_old.vc_ct,
                                         v_tab_bgk_new.vc_ct,
                                         'C_XNXG_ZDYJ',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '03',
                                         'vc_xqm',
                                         '血清酶',
                                         v_tab_bgk_old.vc_xqm,
                                         v_tab_bgk_new.vc_xqm,
                                         'C_XNXG_ZDYJ',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '03',
                                         'vc_ckz',
                                         '磁共振',
                                         v_tab_bgk_old.vc_ckz,
                                         v_tab_bgk_new.vc_ckz,
                                         'C_XNXG_ZDYJ',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '03',
                                         'vc_njy',
                                         '脑脊液',
                                         v_tab_bgk_old.vc_njy,
                                         v_tab_bgk_new.vc_njy,
                                         'C_XNXG_ZDYJ',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '03',
                                         'vc_sj',
                                         '尸检',
                                         v_tab_bgk_old.vc_sj,
                                         v_tab_bgk_new.vc_sj,
                                         'C_XNXG_ZDYJ',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '03',
                                         'vc_ndt',
                                         '脑电图',
                                         v_tab_bgk_old.vc_ndt,
                                         v_tab_bgk_new.vc_ndt,
                                         'C_XNXG_ZDYJ',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '03',
                                         'vc_sjkysjc',
                                         '神经科医生检查',
                                         v_tab_bgk_old.vc_sjkysjc,
                                         v_tab_bgk_new.vc_sjkysjc,
                                         'C_XNXG_ZDYJ',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '03',
                                         'vc_shtd',
                                         '是否死后推断',
                                         v_tab_bgk_old.vc_shtd,
                                         v_tab_bgk_new.vc_shtd,
                                         'C_COMM_SF',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '03',
                                         'vc_cgzsjjg',
                                         '本次卒中发病时间与CT/磁共振检查时间间隔',
                                         v_tab_bgk_old.vc_cgzsjjg,
                                         v_tab_bgk_new.vc_cgzsjjg,
                                         'C_XNXG_CGZSJJG',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '03',
                                         'vc_syzz',
                                         '首要症状(脑卒中)',
                                         v_tab_bgk_old.vc_syzz,
                                         v_tab_bgk_new.vc_syzz,
                                         'C_XNXG_SYZZ',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '03',
                                         'vc_bs',
                                         '病史',
                                         v_tab_bgk_old.vc_bs,
                                         v_tab_bgk_new.vc_bs,
                                         'C_XNXG_BS',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '03',
                                         'dt_fbrq',
                                         '发病日期',
                                         dts(v_tab_bgk_old.dt_fbrq, 0),
                                         dts(v_tab_bgk_new.dt_fbrq, 0),
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '03',
                                         'dt_qzrq',
                                         '确诊日期',
                                         dts(v_tab_bgk_old.dt_qzrq, 0),
                                         dts(v_tab_bgk_new.dt_qzrq, 0),
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '03',
                                         'vc_qzdw',
                                         '确诊单位',
                                         v_tab_bgk_old.vc_qzdw,
                                         v_tab_bgk_new.vc_qzdw,
                                         'C_XNXG_ZGZDDW',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '03',
                                         'vc_sfsf',
                                         '是否首次发病',
                                         v_tab_bgk_old.vc_sfsf,
                                         v_tab_bgk_new.vc_sfsf,
                                         'C_COMM_SF',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '03',
                                         'dt_swrq',
                                         '死亡日期',
                                         dts(v_tab_bgk_old.dt_swrq, 0),
                                         dts(v_tab_bgk_new.dt_swrq, 0),
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '03',
                                         'vc_swys',
                                         '死亡原因',
                                         v_tab_bgk_old.vc_swys,
                                         v_tab_bgk_new.vc_swys,
                                         'C_XNXG_SWYX',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '03',
                                         'vc_swysicd',
                                         '死亡ICD-10',
                                         v_tab_bgk_old.vc_swysicd,
                                         v_tab_bgk_new.vc_swysicd,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '03',
                                         'vc_swysmc',
                                         '死亡具体原因',
                                         v_tab_bgk_old.vc_swysmc,
                                         v_tab_bgk_new.vc_swysmc,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '03',
                                         'vc_bkys',
                                         '报告医师',
                                         v_tab_bgk_old.vc_bkys,
                                         v_tab_bgk_new.vc_bkys,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '03',
                                         'dt_bkrq',
                                         '报告日期',
                                         dts(v_tab_bgk_old.dt_bkrq, 0),
                                         dts(v_tab_bgk_new.dt_bkrq, 0),
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '03',
                                         'vc_bszy',
                                         '病史摘要',
                                         v_tab_bgk_old.vc_bszy,
                                         v_tab_bgk_new.vc_bszy,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '03',
                                         'dt_qxshsj',
                                         '区县审核时间',
                                         dts(v_tab_bgk_old.dt_qxshsj, 0),
                                         dts(v_tab_bgk_new.dt_qxshsj, 0),
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
    
    END IF;
    --记录日志
    v_json_yw_log := Json_ext.get_json(v_json_data, 'ywjllog');
    if v_json_yw_log is not null then
      v_json_yw_log.put('ywrzid', v_ywrzid);
      v_json_yw_log.put('bgkid', v_vc_bgkid);
      v_json_yw_log.put('bgklx', '03');
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
    v_json_return.put('vc_bgkid', v_vc_bgkid);
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      if (SQL%NOTFOUND) then
        v_err      := '未找到相应的患者信息或心脑报卡信息';
        result_out := return_fail(v_err, 0);
      ELSE
        v_err      := SQLERRM;
        result_out := return_fail(v_err, 0);
      end if;
  END prc_xnxg_bgk_update;
  /*--------------------------------------------------------------------------
  || 功能描述 ：获取报告卡编码
  ||------------------------------------------------------------------------*/
  FUNCTION fun_getbgkcode(yycode VARCHAR2, qxcode varchar2) --报卡医院code,报卡区县
   RETURN VARCHAR2 is
    v_code   ZJJK_XNXG_BGK.vc_bgkbh%type;
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
             when max(substr(vc_bgkbh, 0, 14)) is null then
              v_dm || '00001'
             else
              to_char(max(substr(vc_bgkbh, 0, 14)) + 1)
           end
      into v_code
      from ZJJK_XNXG_BGK
     where vc_bgkbh like v_dm || '%'
       and length(vc_bgkbh) = 14
       and stn(vc_bgkbh, 1) is not null;
    return v_code;
  END fun_getbgkcode;
  /*--------------------------------------------------------------------------
  || 功能描述 ：心脑报告卡主副卡设置
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_xnxgbgk_zfksz(Data_In    In Clob, --入参
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
    v_czyyhid zjjk_xnxg_bgk_zfgx.vc_cjry%type;
    v_czyjgjb varchar2(3);
    v_zkid    zjjk_xnxg_bgk_zfgx.vc_zkid%type;
    v_fkid    zjjk_xnxg_bgk_zfgx.vc_fkid%type;
    v_count   number;
  BEGIN
    json_data(data_in, 'zjjk_xnxg_bgk主副卡设置', v_json_data);
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
    update zjjk_xnxg_bgk_zfgx a
       set a.vc_zkid = v_zkid,
           a.vc_cjjg = v_czyjgdm,
           a.vc_cjry = v_czyyhid,
           a.dt_cjsj = sysdate
     where a.vc_fkid = v_zkid;
    --当前卡不存在主副卡信息,默认当前卡为主卡
    if sql%rowcount = 0 then
      insert into zjjk_xnxg_bgk_zfgx
        (vc_zkid, vc_fkid)
      values
        (v_zkid, v_zkid);
    end if;
    --处理副卡(副卡id可为空，将当前卡副卡属性改为主卡)
    if v_fkid is not null then
      --检查副卡是否初访
      select count(1)
        into v_count
        from zjjk_xnxg_bgk a
       where a.vc_bgkid = v_fkid
         and a.vc_sfcf in ('1', '3');
      if v_count = 0 then
        v_err := '当前副卡还未初访!';
        raise err_custom;
      end if;
      --检查该副卡是否为其他副卡的主卡
      select count(1)
        into v_count
        from zjjk_xnxg_bgk_zfgx a
       where a.vc_zkid = v_fkid
         and a.vc_fkid <> v_fkid;
      if v_count > 0 then
        v_err := '当前副卡为其他卡的主卡，不允许此操作!';
        raise err_custom;
      end if;
      --更新副卡
      update zjjk_xnxg_bgk_zfgx a
         set a.vc_zkid = v_zkid,
             a.vc_cjjg = v_czyjgdm,
             a.vc_cjry = v_czyyhid,
             a.dt_cjsj = sysdate
       where a.vc_fkid = v_fkid;
      --副卡不存在主副关系则插入
      if sql%rowcount = 0 then
        insert into zjjk_xnxg_bgk_zfgx
          (vc_zkid, vc_fkid)
        values
          (v_zkid, v_fkid);
      end if;
    end if;
    --操作日志
    v_json_yw_log := Json_ext.get_json(v_json_data, 'ywjllog');
    if v_json_yw_log is not null then
      v_json_yw_log.put('bgkid', v_zkid);
      v_json_yw_log.put('bgklx', '03');
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
  END prc_xnxgbgk_zfksz;
  /*--------------------------------------------------------------------------
  || 功能描述 ：心脑报告卡属地确认
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_xnxgbgk_sdqr(Data_In    In Clob, --入参
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
    v_bkid    zjjk_xnxg_bgk.vc_bgkid%type;
    v_gldw    zjjk_xnxg_bgk.vc_gldwdm%type;
    v_count   number;
  BEGIN
    json_data(data_in, 'zjjk_xnxg_bgk属地确认', v_json_data);
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
      from zjjk_xnxg_bgk a, p_yljg c
     where a.vc_czhkjd = c.xzqh
       and c.dm = v_gldw
       and c.lb = 'B1'
       and a.vc_bgkid = v_bkid;
    if v_count <> 1 then
      v_err := '管理单位与户籍街道不匹配!';
      raise err_custom;
    end if;
    --修改管理单位
    update zjjk_xnxg_bgk a
       set a.vc_gldwdm = v_gldw, a.vc_sdqrzt = '1', dt_xgsj = sysdate
     where a.vc_scbz = '2'
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
      v_json_yw_log.put('bgklx', '03');
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
  END prc_xnxgbgk_sdqr;
  /*--------------------------------------------------------------------------
  || 功能描述 ：心脑病报告卡删除
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_xnxgbgk_sc(Data_In    In Clob, --入参
                           result_out OUT VARCHAR2) --返回
   is
    v_json_data   json;
    v_json_yw_log json;
    v_ywjl_czlx   varchar2(3);
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
    --公共变量
    v_sysdate   date;
    v_czyjgdm   varchar2(50);
    v_czyjgjb   varchar2(3);
    v_cfzt      zjjk_xnxg_bgk.vc_sfcf%type;
    v_bkid      zjjk_xnxg_bgk.vc_bgkid%type;
    v_scbz      zjjk_xnxg_bgk.vc_scbz%TYPE; --删除标志
    v_vc_gldwdm zjjk_xnxg_bgk.vc_gldwdm%TYPE; --删除标志
  BEGIN
    json_data(data_in, 'zjjk_xnxg_bgk删除', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    --获取机构级别
    --select fun_getczyjgjb(v_czyjgdm) into v_czyjgjb from dual;
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    v_bkid    := Json_Str(v_Json_Data, 'vc_bgkid');
    --获取报卡状态
    begin
      select vc_sfcf, vc_scbz, vc_gldwdm
        into v_cfzt, v_scbz, v_vc_gldwdm
        from zjjk_xnxg_bgk
       where vc_bgkid = v_bkid
         and vc_scbz = '2';
    exception
      when no_data_found then
        v_err := 'id[' || v_bkid || ']未获取到有效报告卡信息!';
        raise err_custom;
    end;
    --校验管理单位审核权限
    if v_czyjgjb = '3' then
      if substr(v_vc_gldwdm, 1, 6) <> substr(v_czyjgdm, 1, 6) then
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
    update zjjk_xnxg_bgk
       set vc_scbz = '1', vc_kzt = '5', dt_xgsj = sysdate
     where vc_bgkid = v_bkid;
    --记录日志
    v_json_yw_log := Json_ext.get_json(v_json_data, 'ywjllog');
    if v_json_yw_log is not null then
      v_json_yw_log.put('bgkid', v_bkid);
      v_json_yw_log.put('bgklx', '03');
      v_json_yw_log.put('ywjlid', v_bkid);
      v_json_yw_log.put('gnmk', '01');
      v_json_yw_log.put('gnmc', '报卡管理');
      v_json_yw_log.put('czlx', '04');
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
  END prc_xnxgbgk_sc;
  /*--------------------------------------------------------------------------
  || 功能描述 ：心脑报告卡审核
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_xnxgbgk_sh(Data_In    In Clob, --入参
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
    v_shbz       zjjk_xnxg_bgk.vc_shbz%TYPE; --审核状态
    v_shbz_table zjjk_xnxg_bgk.vc_shbz%TYPE; --审核状态
    v_bkid       zjjk_xnxg_bgk.vc_bgkid%type;
    v_shwtgyy    zjjk_xnxg_bgk.vc_shwtgyy%TYPE; --区县审核未通过原因
    v_shwtgyy1   zjjk_xnxg_bgk.vc_shwtgyy1%TYPE; --区县审核未通过原因选项
    v_vc_gldwdm  zjjk_xnxg_bgk.vc_gldwdm%TYPE;
  BEGIN
    json_data(data_in, 'zjjk_xnxg_bgk审核', v_json_data);
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
      select vc_shbz,vc_gldwdm
        into v_shbz_table,v_vc_gldwdm
        from zjjk_xnxg_bgk
       where vc_bgkid = v_bkid
         and vc_scbz = '2'
         and vc_shbz = '1';
    exception
      when no_data_found then
        v_err := 'id[' || v_bkid || ']未获取到有效报告卡信息!';
        raise err_custom;
    end;
    --校验管理单位审核权限
    if v_czyjgjb = '3' then
      if substr(v_vc_gldwdm, 1, 6) <> substr(v_czyjgdm, 1, 6) then
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
    update zjjk_xnxg_bgk
       set vc_shbz     = v_shbz,
           vc_shwtgyy  = v_shwtgyy,
           vc_shwtgyy1 = v_shwtgyy1,
           dt_qxshsj   = v_sysdate,
           dt_xgsj     = sysdate
     where vc_bgkid = v_bkid;
    --记录日志
    v_json_yw_log := Json_ext.get_json(v_json_data, 'ywjllog');
    if v_json_yw_log is not null then
      v_json_yw_log.put('bgkid', v_bkid);
      v_json_yw_log.put('bgklx', '03');
      v_json_yw_log.put('ywjlid', v_bkid);
      v_json_yw_log.put('gnmk', '01');
      v_json_yw_log.put('gnmc', '报卡管理');
      v_json_yw_log.put('czlx', '03');
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
  END prc_xnxgbgk_sh;
  /*--------------------------------------------------------------------------
  || 功能描述 ：心脑报告卡迁出管理
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_xnxgbgk_qc(Data_In    In Clob, --入参
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
  BEGIN
    json_data(data_in, 'zjjk_xnxg_bgk迁出', v_json_data);
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
      select a.vc_czhksi   vc_hksdm,
             a.vc_czhkqx   vc_hkqxdm,
             a.vc_czhkjd   vc_hkjddm,
             a.vc_czhkjw   vc_hkjwdm,
             a.vc_czhkxxdz vc_hkxxdz,
             a.vc_gldwdm   vc_gldw
        into v_vc_qccs,
             v_vc_qcqx,
             v_vc_qcjd,
             v_vc_qcjw,
             v_vc_qrxxdz,
             v_vc_gldw
        from zjjk_xnxg_bgk a
       where a.vc_bgkid = v_vc_bgkid
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
        update zjjk_xnxg_bgk a
           set a.vc_czhksi   = v_vc_qrcs,
               a.vc_czhkqx   = v_vc_qrqx,
               a.vc_czhkjd   = v_vc_qrjd,
               a.vc_czhkjw   = v_vc_qrjw,
               a.vc_czhkxxdz = v_vc_qrxxdz,
               dt_xgsj       = sysdate
         where a.vc_bgkid = v_vc_bgkid;
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
    update zjjk_xnxg_bgk a
       set a.vc_qcbz   = '0',
           a.vc_qcsdm  = v_vc_qrcs,
           a.vc_qcqxdm = v_vc_qrqx,
           a.vc_qcjddm = v_vc_qrjd,
           a.vc_qcjw   = v_vc_qrjw,
           a.vc_qcxxdz = v_vc_qrxxdz,
           a.vc_gldwdm = v_vc_qrgldw,
           dt_xgsj     = sysdate
     where a.vc_bgkid = v_vc_bgkid;
  
    --操作日志
    v_json_yw_log := Json_ext.get_json(v_json_data, 'ywjllog');
    if v_json_yw_log is not null then
      v_json_yw_log.put('bgkid', v_vc_bgkid);
    
      v_json_yw_log.put('bgklx', '03');
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
  END prc_xnxgbgk_qc;
  /*--------------------------------------------------------------------------
  || 功能描述 ：心脑报告卡迁入管理
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_xnxgbgk_qr(Data_In    In Clob, --入参
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
    v_vc_gldw zjjk_xnxg_bgk.vc_gldwdm%type;
  
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
    v_bgkid_q   zjjk_zl_qrqcb.vc_bgkid%type;
  BEGIN
    json_data(data_in, 'zjjk_xnxg_bgk迁出', v_json_data);
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
      select a.vc_czhksi,
             a.vc_czhkqx,
             a.vc_czhkjd,
             a.vc_czhkjw,
             a.vc_czhkxxdz,
             a.vc_gldwdm
        into v_vc_qccs,
             v_vc_qcqx,
             v_vc_qcjd,
             v_vc_qcjw,
             v_vc_qrxxdz,
             v_vc_gldw
        from zjjk_xnxg_bgk a
       where a.vc_bgkid = v_vc_bgkid;
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
      update zjjk_xnxg_bgk a
         set a.vc_czhksi   = v_vc_qrcs,
             a.vc_czhkqx   = v_vc_qrqx,
             a.vc_czhkjd   = v_vc_qrjd,
             a.vc_czhkjw   = v_vc_qrjw,
             a.vc_czhkxxdz = v_vc_qrxxdz,
             dt_xgsj       = sysdate
       where a.vc_bgkid = v_vc_bgkid;
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
    update zjjk_xnxg_bgk a
       set a.vc_qcbz = '0', a.vc_gldwdm = v_vc_qrgldw, dt_xgsj = sysdate
     where a.vc_bgkid = v_vc_bgkid;
    --操作日志
    v_json_yw_log := Json_ext.get_json(v_json_data, 'ywjllog');
    if v_json_yw_log is not null then
      v_json_yw_log.put('bgkid', v_vc_bgkid);
    
      v_json_yw_log.put('bgklx', '03');
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
  END prc_xnxgbgk_qr;
  /*--------------------------------------------------------------------------
  || 功能描述 ：心脑报告卡死亡补发
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_xnxgbgk_swbf(Data_In    In Clob, --入参
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
    v_czyyhid    varchar2(50);
    v_xnxg_bgkid varchar2(4000);
    v_sw_bgkid   varchar2(4000);
    v_pplx       varchar2(1);
  
  BEGIN
    json_data(data_in, 'zjjk_xnxg_bgk死亡补发', v_json_data);
    v_sysdate    := sysdate;
    v_czyjgdm    := Json_Str(v_Json_Data, 'czyjgdm'); --操作员机构代码
    v_czyjgjb    := Json_Str(v_Json_Data, 'czyjgjb'); --获取机构级别
    v_czyyhid    := Json_Str(v_Json_Data, 'czyyhid'); --操作员id
    v_xnxg_bgkid := Json_Str(v_Json_Data, 'vc_xnxg_bgkid'); --心脑报卡id
    v_sw_bgkid   := Json_Str(v_Json_Data, 'vc_sw_bgkid'); --死亡报卡id
    v_pplx       := Json_Str(v_Json_Data, 'pplx'); --匹配类型
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
      if v_xnxg_bgkid is null then
        v_err := '未获取到心脑报卡id!';
        raise err_custom;
      end if;
      update zjmb_sw_bgk a
         set a.vc_xnxgbfzt = '1'
       where a.vc_bgkid = v_sw_bgkid;
      if sql%rowcount = 0 then
        v_err := '死亡报告id未找到对应的报卡!';
        raise err_custom;
      end if;
      update zjjk_xnxg_bgk a
         set a.vc_kzt = '7',
             dt_xgsj = sysdate,
             (a.vc_swysicd, a.dt_swrq) =
             (select b.vc_gbsy, b.dt_swrq
                from zjmb_sw_bgk b
               where b.vc_bgkid = v_sw_bgkid)
       where a.vc_bgkid in
             (select distinct column_value column_value
                from table(split(v_xnxg_bgkid, ',')))
         and nvl(a.vc_kzt, '0') <> '7';
      --未匹配上
    elsif v_pplx = '0' then
      update zjmb_sw_bgk a
         set a.vc_xnxgbfzt = '2'
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
      v_json_yw_log.put('bgklx', '03');
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
  END prc_xnxgbgk_swbf;
  /*--------------------------------------------------------------------------
  || 功能描述 ：心脑报告卡查重
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_xnxgbgk_cc(Data_In    In Clob, --入参
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
    v_vc_bgkid      zjjk_xnxg_bgk.vc_bgkid%type;
  
  BEGIN
    json_data(data_in, 'zjjk_xnxg_bgk查重', v_json_data);
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
        update zjjk_xnxg_bgk a
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
        update zjjk_xnxg_bgk a
           set a.vc_ccid = v_czyjgdm, a.vc_kzt = '4', dt_xgsj = sysdate
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
      v_json_yw_log.put('bgklx', '03');
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
  END prc_xnxgbgk_cc;
  /*--------------------------------------------------------------------------
  || 功能描述 ：心脑初访卡新增
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_xnxg_cfk_update(Data_In    In Clob, --入参
                                result_out OUT VARCHAR2) --返回 
   is
    --定义初访卡变量
    v_vc_jzdhsyy zjjk_xnxg_cfk.vc_jzdhsyy%TYPE; --居住地未核实原因
    v_vc_hjqc    zjjk_xnxg_cfk.vc_hjqc%TYPE; --户籍迁出
    v_vc_qydz    zjjk_xnxg_cfk.vc_qydz%TYPE; --迁移地址
    v_dt_qyrq    zjjk_xnxg_cfk.dt_qyrq%TYPE; --迁移日期
    v_dt_zzrq    zjjk_xnxg_cfk.dt_zzrq%TYPE; --本次症状出现日期
    v_dt_jzrq    zjjk_xnxg_cfk.dt_jzrq%TYPE; --本次就诊日期
    v_dt_fbrq    zjjk_xnxg_cfk.dt_fbrq%TYPE; --首次发病时间
    v_vc_sfhyz   zjjk_xnxg_cfk.vc_sfhyz%TYPE; --是否后遗症
    v_dt_cxglrq  zjjk_xnxg_cfk.dt_cxglrq%TYPE; --撤销管理日期
    v_vc_cxyy    zjjk_xnxg_cfk.vc_cxyy%TYPE; --撤销原因
    v_vc_cxyyzm  zjjk_xnxg_cfk.vc_cxyyzm%TYPE; --撤销原因注明
    v_vc_sffbsw  zjjk_xnxg_cfk.vc_sffbsw%TYPE; --是否发病28天死亡
    v_dt_swrq    zjjk_xnxg_cfk.dt_swrq%TYPE; --死亡日期
    v_vc_swyy    zjjk_xnxg_cfk.vc_swyy%TYPE; --死亡原因
    v_vc_swdd    zjjk_xnxg_cfk.vc_swdd%TYPE; --死亡地点
    v_nb_scqn    zjjk_xnxg_cfk.nb_scqn%TYPE; --生存期年
    v_nb_scqy    zjjk_xnxg_cfk.nb_scqy%TYPE; --生存期月
    v_vc_scbz    zjjk_xnxg_cfk.vc_scbz%TYPE; --删除标志
    v_vc_cjyh    zjjk_xnxg_cfk.vc_cjyh%TYPE; --创建用户
    v_dt_cjsj    zjjk_xnxg_cfk.dt_cjsj%TYPE; --创建时间
    v_dt_xgsj    zjjk_xnxg_cfk.dt_xgsj%TYPE; --修改时间
    v_vc_xgyh    zjjk_xnxg_cfk.vc_xgyh%TYPE; --修改用户
    v_vc_qcd     zjjk_xnxg_cfk.vc_qcd%TYPE; --迁出省
    v_vc_qcsdm   zjjk_xnxg_cfk.vc_qcsdm%TYPE; --迁出市
    v_vc_qcqxdm  zjjk_xnxg_cfk.vc_qcqxdm%TYPE; --迁出区
    v_vc_qcjddm  zjjk_xnxg_cfk.vc_qcjddm%TYPE; --迁出街
    v_vc_qcjw    zjjk_xnxg_cfk.vc_qcjw%TYPE; --迁出居委
    v_vc_qcxxdz  zjjk_xnxg_cfk.vc_qcxxdz%TYPE; --迁出详细地址
    v_vc_swicd   zjjk_xnxg_cfk.vc_swicd%TYPE; --死亡ICD
    v_vc_swicdmc zjjk_xnxg_cfk.vc_swicdmc%TYPE; --死亡ICD名称
    v_vc_zlqk    zjjk_xnxg_cfk.vc_zlqk%TYPE; --治疗情况
    v_vc_jzs     zjjk_xnxg_cfk.vc_jzs%TYPE; --家族史
    v_vc_gx      zjjk_xnxg_cfk.vc_gx%TYPE; --关系
    v_vc_sfdyyjz zjjk_xnxg_cfk.vc_sfdyyjz%TYPE; --是否到医院就诊
    v_dt_qzrq    zjjk_xnxg_cfk.dt_qzrq%TYPE; --确诊日期
    v_vc_xys     zjjk_xnxg_cfk.vc_xys%TYPE; --吸烟史
    v_vc_jyyf    zjjk_xnxg_cfk.vc_jyyf%TYPE; --戒烟月份
    v_vc_fzqrkpf zjjk_xnxg_cfk.vc_fzqrkpf%TYPE; --脑卒中发作前Rank评分
    v_vc_cfrkpf  zjjk_xnxg_cfk.vc_cfrkpf%TYPE; --初访Rank评分
    v_vc_ywzl    zjjk_xnxg_cfk.vc_ywzl%TYPE; --药物治疗
    v_vc_ywzlqt  zjjk_xnxg_cfk.vc_ywzlqt%TYPE; --药物治疗其他
    v_vc_gxbz    zjjk_xnxg_cfk.vc_gxbz%TYPE; --更新标志
    v_vc_sfscfb  zjjk_xnxg_cfk.vc_sfscfb%TYPE; --是否首次发病
    v_vc_hzsfzh  zjjk_xnxg_cfk.vc_hzsfzh%TYPE; --患者身份证号
    v_vc_cfkid   zjjk_xnxg_cfk.vc_cfkid%TYPE; --初访卡ID
    v_vc_bgkid   zjjk_xnxg_cfk.vc_bgkid%TYPE; --报告卡ID
    v_dt_cfrq    zjjk_xnxg_cfk.dt_cfrq%TYPE; --初访日期
    v_vc_cfys    zjjk_xnxg_cfk.vc_cfys%TYPE; --初访医生
    v_vc_hjhs    zjjk_xnxg_cfk.vc_hjhs%TYPE; --户籍核实
    v_vc_hjwhsyy zjjk_xnxg_cfk.vc_hjwhsyy%TYPE; --户籍未核实原因
    v_vc_jzdhs   zjjk_xnxg_cfk.vc_jzdhs%TYPE; --居住地核实
  
    --公共变量
    v_czyhjgjb    varchar2(20);
    v_json_data   json;
    v_json_yw_log json;
    v_json_return json := json();
    v_ywjl_czlx   varchar2(3);
    err_custom EXCEPTION;
    v_err     VARCHAR2(2000);
    v_sysdate date;
    v_count   number(2);
    -- 定义报告卡变量
    b_vc_sfsw     zjjk_xnxg_bgk.vc_sfsw%type; --是否死亡
    b_vc_kzt      zjjk_xnxg_bgk.vc_kzt%type; --报卡状态
    b_dt_swrq     zjjk_xnxg_bgk.dt_swrq%type; --死亡日期
    b_vc_swys     zjjk_xnxg_bgk.vc_swys%type; --死亡原因
    b_vc_qcbz     zjjk_xnxg_bgk.vc_qcbz%type; --迁出标志
    b_vc_czhks    zjjk_xnxg_bgk.vc_czhks%type; --户口省
    b_vc_czhksi   zjjk_xnxg_bgk.vc_czhksi%type; --户口市
    b_vc_czhkqx   zjjk_xnxg_bgk.vc_czhkqx%type; --户口区县
    b_vc_czhkjd   zjjk_xnxg_bgk.vc_czhkjd%type; --户口街道
    b_vc_czhkjw   zjjk_xnxg_bgk.vc_czhkjw%type; --户口居委
    b_vc_czhkxxdz zjjk_xnxg_bgk.vc_czhkxxdz%type; --户口详细地址
    b_vc_sfcf     zjjk_xnxg_bgk.vc_sfcf%type; --是否初访
    b_dt_cfsj     zjjk_xnxg_bgk.dt_cfsj%type; --初访时间
    b_dt_sfsj     zjjk_xnxg_bgk.dt_sfsj%type; --随访时间
    b_vc_sfqc     zjjk_xnxg_bgk.vc_sfqc%type; --随访迁出
    b_vc_hzsfzh   zjjk_xnxg_bgk.vc_hzsfzh%type; --身份证号
    b_dt_qcsj     zjjk_xnxg_bgk.dt_qcsj%type; --迁出时间
    b_dt_qrsj     zjjk_xnxg_bgk.dt_qrsj%type; -- 迁入时间
    v_vc_sdqrzt   varchar2(10);
    v_vc_gldwdm   varchar2(100);
  BEGIN
    json_data(Data_In, 'zjjk_xnxg_cfk新增', v_json_data);
    v_sysdate := sysdate;
    --初随访卡赋值
    v_czyhjgjb   := json_str(v_json_data, 'czyjgjb');
    v_vc_jzdhsyy := Json_Str(v_Json_Data, 'vc_jzdhsyy');
    v_vc_hjqc    := Json_Str(v_Json_Data, 'vc_hjqc');
    v_vc_qydz    := Json_Str(v_Json_Data, 'vc_qydz');
    v_dt_qyrq    := std(Json_Str(v_Json_Data, 'dt_qyrq'), 1);
    v_dt_zzrq    := std(Json_Str(v_Json_Data, 'dt_zzrq'), 1);
    v_dt_jzrq    := std(Json_Str(v_Json_Data, 'dt_jzrq'), 1);
    v_dt_fbrq    := std(Json_Str(v_Json_Data, 'dt_fbrq'), 1);
    v_vc_sfhyz   := Json_Str(v_Json_Data, 'vc_sfhyz');
    v_dt_cxglrq  := std(Json_Str(v_Json_Data, 'dt_cxglrq'), 1);
    v_vc_cxyy    := Json_Str(v_Json_Data, 'vc_cxyy');
    v_vc_cxyyzm  := Json_Str(v_Json_Data, 'vc_cxyyzm');
    v_vc_sffbsw  := Json_Str(v_Json_Data, 'vc_sffbsw');
    v_dt_swrq    := std(Json_Str(v_Json_Data, 'dt_swrq'), 1);
    v_vc_swyy    := Json_Str(v_Json_Data, 'vc_swyy');
    v_vc_swdd    := Json_Str(v_Json_Data, 'vc_swdd');
    v_nb_scqn    := Json_Str(v_Json_Data, 'nb_scqn');
    v_nb_scqy    := Json_Str(v_Json_Data, 'nb_scqy');
    v_vc_scbz    := Json_Str(v_Json_Data, 'vc_scbz');
    v_vc_cjyh    := Json_Str(v_Json_Data, 'czyyhid');
    v_dt_cjsj    := std(Json_Str(v_Json_Data, 'dt_cjsj'), 1);
    v_dt_xgsj    := std(Json_Str(v_Json_Data, 'dt_xgsj'), 1);
    v_vc_xgyh    := Json_Str(v_Json_Data, 'czyyhid');
    v_vc_qcd     := Json_Str(v_Json_Data, 'vc_qcd');
    v_vc_qcsdm   := Json_Str(v_Json_Data, 'vc_qcsdm');
    v_vc_qcqxdm  := Json_Str(v_Json_Data, 'vc_qcqxdm');
    v_vc_qcjddm  := Json_Str(v_Json_Data, 'vc_qcjddm');
    v_vc_qcjw    := Json_Str(v_Json_Data, 'vc_qcjw');
    v_vc_qcxxdz  := Json_Str(v_Json_Data, 'vc_qcxxdz');
    v_vc_swicd   := Json_Str(v_Json_Data, 'vc_swicd');
    v_vc_swicdmc := Json_Str(v_Json_Data, 'vc_swicdmc');
    v_vc_zlqk    := Json_Str(v_Json_Data, 'vc_zlqk');
    v_vc_jzs     := Json_Str(v_Json_Data, 'vc_jzs');
    v_vc_gx      := Json_Str(v_Json_Data, 'vc_gx');
    v_vc_sfdyyjz := Json_Str(v_Json_Data, 'vc_sfdyyjz');
    v_dt_qzrq    := std(Json_Str(v_Json_Data, 'dt_qzrq'), 1);
    v_vc_xys     := Json_Str(v_Json_Data, 'vc_xys');
    v_vc_jyyf    := Json_Str(v_Json_Data, 'vc_jyyf');
    v_vc_fzqrkpf := Json_Str(v_Json_Data, 'vc_fzqrkpf');
    v_vc_cfrkpf  := Json_Str(v_Json_Data, 'vc_cfrkpf');
    v_vc_ywzl    := Json_Str(v_Json_Data, 'vc_ywzl');
    v_vc_ywzlqt  := Json_Str(v_Json_Data, 'vc_ywzlqt');
    v_vc_gxbz    := Json_Str(v_Json_Data, 'vc_gxbz');
    v_vc_sfscfb  := Json_Str(v_Json_Data, 'vc_sfscfb');
    v_vc_hzsfzh  := Json_Str(v_Json_Data, 'vc_hzsfzh');
    v_vc_cfkid   := Json_Str(v_Json_Data, 'vc_cfkid');
    v_vc_bgkid   := Json_Str(v_Json_Data, 'vc_bgkid');
    v_dt_cfrq    := std(Json_Str(v_Json_Data, 'dt_cfrq'), 1);
    v_vc_cfys    := Json_Str(v_Json_Data, 'vc_cfys');
    v_vc_hjhs    := Json_Str(v_Json_Data, 'vc_hjhs');
    v_vc_hjwhsyy := Json_Str(v_Json_Data, 'vc_hjwhsyy');
    v_vc_jzdhs   := Json_Str(v_Json_Data, 'vc_jzdhs');
    v_dt_cjsj    := sysdate;
    v_dt_xgsj    := sysdate;
    if (v_vc_bgkid is not null) then
      select vc_sfsw,
             vc_kzt,
             dt_swrq,
             vc_swys,
             vc_qcbz,
             vc_czhks,
             vc_czhksi,
             vc_czhkqx,
             vc_czhkjd,
             vc_czhkjw,
             vc_czhkxxdz,
             vc_sfcf,
             dt_cfsj,
             dt_sfsj,
             vc_sfqc,
             vc_hzsfzh,
             dt_qcsj,
             dt_qrsj
        into b_vc_sfsw,
             b_vc_kzt,
             b_dt_swrq,
             b_vc_swys,
             b_vc_qcbz,
             b_vc_czhks,
             b_vc_czhksi,
             b_vc_czhkqx,
             b_vc_czhkjd,
             b_vc_czhkjw,
             b_vc_czhkxxdz,
             b_vc_sfcf,
             b_dt_cfsj,
             b_dt_sfsj,
             b_vc_sfqc,
             b_vc_hzsfzh,
             b_dt_qcsj,
             b_dt_qrsj
        from zjjk_xnxg_bgk
       where vc_bgkid = v_vc_bgkid;
    else
      v_err := '糖尿病报告卡id不能为空！';
      raise err_custom;
    end if;
    --操作相应的报告卡信息
    if (v_vc_swyy is not null) then
      b_vc_sfsw := '1';
      b_vc_kzt  := '7';
      b_dt_swrq := v_dt_swrq;
      b_vc_swys := v_vc_swyy;
    else
      b_vc_sfsw := '0';
      b_vc_kzt  := '0';
    end if;
    if (v_vc_hjqc = '1') then
      b_vc_qcbz := '1';
    end if;
    /* if(b_vc_kzt <> '4' and v_vc_hjhs = '2') then
        b_vc_kzt := '6';
    end if;*/
    /*  if(b_vc_kzt != '4' and v_vc_hjhs = '2')then
      b_vc_kzt := '6';
    end if;*/
    if (b_vc_kzt != '4') then
      if (v_dt_cxglrq is not null and v_vc_cxyy = '2') then
        b_vc_kzt := '3';
      elsif (v_dt_cxglrq is not null and v_vc_cxyy = '5') then
        b_vc_czhks  := '1';
        b_vc_czhksi := null;
        b_vc_czhkqx := null;
        b_vc_czhkjd := null;
      elsif (v_dt_cxglrq is not null and v_vc_cxyy = '4') then
        b_vc_kzt  := '7';
        b_dt_swrq := v_dt_swrq;
        b_vc_swys := v_vc_swyy;
      elsif (v_dt_cxglrq is not null and v_vc_cxyy = '1') then
        b_vc_kzt := '2';
      elsif (v_dt_cxglrq is not null and v_vc_cxyy = '3') then
        b_vc_kzt := '6';
      end if;
    end if;
    b_vc_sfcf     := '1';
    b_dt_cfsj     := v_dt_cfrq;
    b_dt_sfsj     := v_dt_cfrq;
    b_vc_sfqc     := v_vc_hjqc;
    b_vc_czhks    := v_vc_qcd;
    b_vc_czhksi   := v_vc_qcsdm;
    b_vc_czhkqx   := v_vc_qcqxdm;
    b_vc_czhkjd   := v_vc_qcjddm;
    b_vc_czhkjw   := v_vc_qcjw;
    b_vc_czhkxxdz := v_vc_qcxxdz;
    b_vc_hzsfzh   := v_vc_hzsfzh;
    b_dt_qcsj     := v_dt_qyrq;
    b_dt_qrsj     := v_dt_cfrq;
  
    --检验字段必填
    --校验数据是否合法
    if v_dt_cfrq is null then
      v_err := '初访日期不能为空!';
      raise err_custom;
    end if;
    if v_vc_cfys is null then
      v_err := '初访医生不能为空!';
      raise err_custom;
    end if;
    if v_vc_hjhs is null then
      v_err := '户籍核实不能为空!';
      raise err_custom;
    end if;
    if v_vc_hjhs = '2' and v_vc_hjwhsyy is null then
      v_err := '户籍未核实原因不能为空!';
      raise err_custom;
    end if;
    if v_vc_qcd is null then
      v_err := '户籍核实省不能为空!';
      raise err_custom;
    end if;
    --浙江
    if v_vc_qcd = '0' then
      if v_vc_qcsdm is null then
        v_err := '户籍核实市不能为空!';
        raise err_custom;
      end if;
      if v_vc_qcqxdm is null then
        v_err := '户籍核实区县不能为空!';
        raise err_custom;
      end if;
      if v_vc_qcjddm is null then
        v_err := '户籍核实街道不能为空!';
        raise err_custom;
      end if;
      if substr(v_vc_qcsdm, 1, 4) <> substr(v_vc_qcqxdm, 1, 4) or
         substr(v_vc_qcsdm, 1, 4) <> substr(v_vc_qcjddm, 1, 4) then
        v_err := '户籍地址区划不匹配!';
        raise err_custom;
      end if;
      if v_vc_qcxxdz is null then
        v_err := '户籍详细地址不能为空!';
        raise err_custom;
      end if;
    end if;
    if v_vc_hjqc = '1' and v_dt_qyrq is null then
      v_err := '迁出时间不能为空!';
      raise err_custom;
    end if;
    if v_vc_sfdyyjz = '1' and v_dt_jzrq is null then
      v_err := '就诊日期不能为空!';
      raise err_custom;
    end if;
    if v_vc_sfdyyjz = '1' and v_vc_zlqk is null then
      v_err := '本次治疗情况不能为空!';
      raise err_custom;
    end if;
    if v_vc_xys = '1' and v_vc_jyyf is null then
      v_err := '戒烟月数不能为空!';
      raise err_custom;
    end if;
    if v_vc_jzs = '1' and v_vc_gx is null then
      v_err := '与患者关系不能为空!';
      raise err_custom;
    end if;
    if v_vc_swyy is not null and v_dt_swrq is null then
      v_err := '死亡日期不能为空!';
      raise err_custom;
    end if;
    if v_vc_swyy is not null and v_vc_swicd is null then
      v_err := '死亡ICD不能为空!';
      raise err_custom;
    end if;
    if v_vc_swyy is not null and v_vc_swdd is null then
      v_err := '死亡地点不能为空!';
      raise err_custom;
    end if;
    if v_nb_scqn is null or v_nb_scqy is null then
      v_err := '生存期不能为空!';
      raise err_custom;
    end if;
  
    --第一步：新增初访卡
    v_vc_cfkid := sys_guid();
    insert into zjjk_xnxg_cfk
      (vc_jzdhsyy,
       vc_jzdhs,
       vc_hjwhsyy,
       vc_hjhs,
       vc_cfys,
       dt_cfrq,
       vc_bgkid,
       vc_cfkid,
       vc_hzsfzh,
       vc_sfscfb,
       vc_gxbz,
       vc_ywzlqt,
       vc_ywzl,
       vc_cfrkpf,
       vc_fzqrkpf,
       vc_jyyf,
       vc_xys,
       dt_qzrq,
       vc_sfdyyjz,
       vc_gx,
       vc_jzs,
       vc_zlqk,
       vc_swicdmc,
       vc_swicd,
       vc_qcxxdz,
       vc_qcjw,
       vc_qcjddm,
       vc_qcqxdm,
       vc_qcsdm,
       vc_qcd,
       vc_xgyh,
       dt_xgsj,
       dt_cjsj,
       vc_cjyh,
       vc_scbz,
       nb_scqy,
       nb_scqn,
       vc_swdd,
       vc_swyy,
       dt_swrq,
       vc_sffbsw,
       vc_cxyyzm,
       vc_cxyy,
       dt_cxglrq,
       vc_sfhyz,
       dt_fbrq,
       dt_jzrq,
       dt_zzrq,
       dt_qyrq,
       vc_qydz,
       vc_hjqc)
    values
      (v_vc_jzdhsyy,
       v_vc_jzdhs,
       v_vc_hjwhsyy,
       v_vc_hjhs,
       v_vc_cfys,
       v_dt_cfrq,
       v_vc_bgkid,
       v_vc_cfkid,
       v_vc_hzsfzh,
       v_vc_sfscfb,
       v_vc_gxbz,
       v_vc_ywzlqt,
       v_vc_ywzl,
       v_vc_cfrkpf,
       v_vc_fzqrkpf,
       v_vc_jyyf,
       v_vc_xys,
       v_dt_qzrq,
       v_vc_sfdyyjz,
       v_vc_gx,
       v_vc_jzs,
       v_vc_zlqk,
       v_vc_swicdmc,
       v_vc_swicd,
       v_vc_qcxxdz,
       v_vc_qcjw,
       v_vc_qcjddm,
       v_vc_qcqxdm,
       v_vc_qcsdm,
       v_vc_qcd,
       v_vc_xgyh,
       v_dt_xgsj,
       v_dt_cjsj,
       v_vc_cjyh,
       v_vc_scbz,
       v_nb_scqy,
       v_nb_scqn,
       v_vc_swdd,
       v_vc_swyy,
       v_dt_swrq,
       v_vc_sffbsw,
       v_vc_cxyyzm,
       v_vc_cxyy,
       v_dt_cxglrq,
       v_vc_sfhyz,
       v_dt_fbrq,
       v_dt_jzrq,
       v_dt_zzrq,
       v_dt_qyrq,
       v_vc_qydz,
       v_vc_hjqc);
  
    --属地确认
    select count(1), wm_concat(a.dm)
      into v_count, v_vc_gldwdm
      from p_yljg a
     where a.bz = 1
       and a.lb = 'B1'
       and a.xzqh = b_vc_czhkjd;
    if v_count = 1 then
      --确定属地
      v_vc_sdqrzt := '1';
    else
      v_vc_gldwdm := b_vc_czhkqx;
      v_vc_sdqrzt := '0';
    end if;
    if b_vc_czhks = '1' then
      v_vc_gldwdm := '99999999';
      v_vc_sdqrzt := '1';
    end if;
    --第二步：更新报告卡信息
    update zjjk_xnxg_bgk
       set vc_sfsw     = b_vc_sfsw,
           vc_kzt      = b_vc_kzt,
           dt_swrq     = b_dt_swrq,
           vc_swys     = b_vc_swys,
           vc_qcbz     = b_vc_qcbz,
           vc_czhks    = b_vc_czhks,
           vc_czhksi   = b_vc_czhksi,
           vc_czhkqx   = b_vc_czhkqx,
           vc_czhkjd   = b_vc_czhkjd,
           vc_czhkjw   = b_vc_czhkjw,
           vc_czhkxxdz = b_vc_czhkxxdz,
           vc_sfcf     = b_vc_sfcf,
           dt_cfsj     = b_dt_cfsj,
           dt_sfsj     = b_dt_sfsj,
           vc_sfqc     = b_vc_sfqc,
           vc_hzsfzh   = b_vc_hzsfzh,
           dt_qcsj     = b_dt_qcsj,
           dt_qrsj     = b_dt_qrsj,
           dt_xgsj     = sysdate,
           vc_sdqrzt   = v_vc_sdqrzt,
           vc_gldwdm   = v_vc_gldwdm
     where vc_bgkid = v_vc_bgkid;
    --更新副卡vc_bgkzt,dt_swrq，vc_swyy
    update zjjk_xnxg_bgk a
       set a.vc_kzt  = b_vc_kzt,
           a.dt_swrq = b_dt_swrq,
           a.vc_swys = b_vc_swys,
           a.dt_xgsj = sysdate
     where exists (select 1
              from zjjk_xnxg_bgk_zfgx b
             where a.vc_bgkid = b.vc_fkid
               and b.vc_zkid <> b.vc_fkid
               and b.vc_zkid = v_vc_bgkid);
    --记录日志
    v_json_yw_log := Json_ext.get_json(v_json_data, 'ywjllog');
    if v_json_yw_log is not null then
      v_json_yw_log.put('bgkid', v_vc_bgkid);
      v_json_yw_log.put('bgklx', '03');
      v_json_yw_log.put('ywjlid', v_vc_cfkid);
      v_json_yw_log.put('gnmk', '04');
      v_json_yw_log.put('gnmc', '新增心脑血管初访');
      v_json_yw_log.put('czlx', '01');
      pkg_zjmb_xtfz.prc_zjjk_yw_log_update(v_json_yw_log, v_err);
      if v_err is not null then
        raise err_custom;
      end if;
    end if;
    --更新初随访状态
    pkg_zjmb_xnxg.prc_bgkcsfzt_update(v_vc_bgkid, v_err);
    v_json_return.put('vc_bgkid', v_vc_bgkid);
    v_json_return.put('vc_cfkid', v_vc_cfkid);
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      if (SQL%NOTFOUND) then
        v_err      := '未找到相应的心脑血管报卡信息';
        result_out := return_fail(v_err, 0);
      ELSE
        v_err      := SQLERRM;
        result_out := return_fail(v_err, 0);
      end if;
  END prc_xnxg_cfk_update;
  /*--------------------------------------------------------------------------
  || 功能描述 ：心脑随访卡新增或者修改
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_xnxg_sfk_update(Data_In    In Clob, --入参
                                result_out OUT VARCHAR2) --返回 
   is
    --定义随访卡变量
    v_vc_ywzlqt3       zjjk_xnxg_sfk.vc_ywzlqt3%TYPE; --药物治疗其他3
    v_vc_ywzlqt2       zjjk_xnxg_sfk.vc_ywzlqt2%TYPE; --药物治疗其他2
    v_vc_sfkid         zjjk_xnxg_sfk.vc_sfkid%TYPE; --随访卡ID
    v_vc_bgkid         zjjk_xnxg_sfk.vc_bgkid%TYPE; --报告卡ID
    v_dt_sfrq          zjjk_xnxg_sfk.dt_sfrq%TYPE; --随访日期
    v_vc_sfys          zjjk_xnxg_sfk.vc_sfys%TYPE; --随访医生
    v_vc_hjqc          zjjk_xnxg_sfk.vc_hjqc%TYPE; --户籍迁出
    v_vc_qydz          zjjk_xnxg_sfk.vc_qydz%TYPE; --迁移地址
    v_dt_qyrq          zjjk_xnxg_sfk.dt_qyrq%TYPE; --迁移日期
    v_vc_sfzlqk        zjjk_xnxg_sfk.vc_sfzlqk%TYPE; --随访期治疗情况
    v_vc_sfqfzqk       zjjk_xnxg_sfk.vc_sfqfzqk%TYPE; --随访期发作情况
    v_nb_sfqfzcs       zjjk_xnxg_sfk.nb_sfqfzcs%TYPE; --随访期发作次数
    v_dt_dycfbsj       zjjk_xnxg_sfk.dt_dycfbsj%TYPE; --第一次发病时间
    v_dt_dycqzsj       zjjk_xnxg_sfk.dt_dycqzsj%TYPE; --第一次确诊时间
    v_dt_decfbsj       zjjk_xnxg_sfk.dt_decfbsj%TYPE; --第二次发病时间
    v_dt_decqzsj       zjjk_xnxg_sfk.dt_decqzsj%TYPE; --第二次确诊时间
    v_dt_dscfbsj       zjjk_xnxg_sfk.dt_dscfbsj%TYPE; --第三次发病时间
    v_dt_dscqzsj       zjjk_xnxg_sfk.dt_dscqzsj%TYPE; --第三次确诊时间
    v_vc_mqqk          zjjk_xnxg_sfk.vc_mqqk%TYPE; --目前情况
    v_vc_sfhyz         zjjk_xnxg_sfk.vc_sfhyz%TYPE; --是否后遗症
    v_dt_cxglrq        zjjk_xnxg_sfk.dt_cxglrq%TYPE; --撤销管理日期
    v_vc_cxyy          zjjk_xnxg_sfk.vc_cxyy%TYPE; --撤销原因
    v_vc_cxyyzm        zjjk_xnxg_sfk.vc_cxyyzm%TYPE; --撤销原因注明
    v_nb_qzsjn         zjjk_xnxg_sfk.nb_qzsjn%TYPE; --与首次确诊时间年
    v_nb_qzsjy         zjjk_xnxg_sfk.nb_qzsjy%TYPE; --与首次确诊时间月
    v_dt_swrq          zjjk_xnxg_sfk.dt_swrq%TYPE; --死亡日期
    v_vc_swyy          zjjk_xnxg_sfk.vc_swyy%TYPE; --死亡原因
    v_vc_swdd          zjjk_xnxg_sfk.vc_swdd%TYPE; --死亡地点
    v_nb_scqn          zjjk_xnxg_sfk.nb_scqn%TYPE; --生存期年
    v_nb_scqy          zjjk_xnxg_sfk.nb_scqy%TYPE; --生存期月
    v_vc_scbz          zjjk_xnxg_sfk.vc_scbz%TYPE; --删除标志
    v_vc_cjyh          zjjk_xnxg_sfk.vc_cjyh%TYPE; --创建用户
    v_dt_cjsj          zjjk_xnxg_sfk.dt_cjsj%TYPE; --创建时间
    v_dt_xgsj          zjjk_xnxg_sfk.dt_xgsj%TYPE; --修改时间
    v_vc_xgyh          zjjk_xnxg_sfk.vc_xgyh%TYPE; --修改用户
    v_vc_qcd           zjjk_xnxg_sfk.vc_qcd%TYPE; --迁出省
    v_vc_qcsdm         zjjk_xnxg_sfk.vc_qcsdm%TYPE; --迁出市
    v_vc_qcqxdm        zjjk_xnxg_sfk.vc_qcqxdm%TYPE; --迁出区
    v_vc_qcjddm        zjjk_xnxg_sfk.vc_qcjddm%TYPE; --迁出街
    v_vc_qcjw          zjjk_xnxg_sfk.vc_qcjw%TYPE; --迁出居委
    v_vc_qcxxdz        zjjk_xnxg_sfk.vc_qcxxdz%TYPE; --迁出详细地址
    v_vc_swicd         zjjk_xnxg_sfk.vc_swicd%TYPE; --死亡ICD
    v_vc_swicdmc       zjjk_xnxg_sfk.vc_swicdmc%TYPE; --死亡ICD名称
    v_vc_zlqk          zjjk_xnxg_sfk.vc_zlqk%TYPE; --治疗情况
    v_vc_jzs           zjjk_xnxg_sfk.vc_jzs%TYPE; --家族史
    v_vc_gx            zjjk_xnxg_sfk.vc_gx%TYPE; --关系
    v_vc_sfdyyjz       zjjk_xnxg_sfk.vc_sfdyyjz%TYPE; --是否到医院就诊
    v_dt_qzrq          zjjk_xnxg_sfk.dt_qzrq%TYPE; --确诊日期
    v_vc_xys           zjjk_xnxg_sfk.vc_xys%TYPE; --吸烟史
    v_vc_jyyf          zjjk_xnxg_sfk.vc_jyyf%TYPE; --戒烟月份
    v_vc_fzqrkpf       zjjk_xnxg_sfk.vc_fzqrkpf%TYPE; --脑卒中发作前Rank评分
    v_vc_cfrkpf        zjjk_xnxg_sfk.vc_cfrkpf%TYPE; --初访Rank评分
    v_vc_ywzl          zjjk_xnxg_sfk.vc_ywzl%TYPE; --药物治疗
    v_vc_ywzlqt        zjjk_xnxg_sfk.vc_ywzlqt%TYPE; --药物治疗其他
    v_vc_zlqk2         zjjk_xnxg_sfk.vc_zlqk2%TYPE; --第二次治疗情况
    v_vc_zlqk3         zjjk_xnxg_sfk.vc_zlqk3%TYPE; --第三次治疗情况
    v_vc_sffbsw1       zjjk_xnxg_sfk.vc_sffbsw1%TYPE; --是否发病28天死亡1
    v_vc_sffbsw2       zjjk_xnxg_sfk.vc_sffbsw2%TYPE; --是否发病28天死亡2
    v_vc_sffbsw3       zjjk_xnxg_sfk.vc_sffbsw3%TYPE; --是否发病28天死亡3
    v_vc_cfrkpf2       zjjk_xnxg_sfk.vc_cfrkpf2%TYPE; --Rank评分2
    v_vc_cfrkpf3       zjjk_xnxg_sfk.vc_cfrkpf3%TYPE; --Rank评分3
    v_vc_ywzl2         zjjk_xnxg_sfk.vc_ywzl2%TYPE; --药物治疗2
    v_vc_ywzl3         zjjk_xnxg_sfk.vc_ywzl3%TYPE; --药物治疗3
    v_vc_bfz1          zjjk_xnxg_sfk.vc_bfz1%TYPE; --并发症1
    v_vc_bfz2          zjjk_xnxg_sfk.vc_bfz2%TYPE; --并发症2
    v_vc_bfz3          zjjk_xnxg_sfk.vc_bfz3%TYPE; --并发症3
    v_vc_gxbz          zjjk_xnxg_sfk.vc_gxbz%TYPE; --更新标志
    v_upload_areaeport zjjk_xnxg_sfk.upload_areaeport%TYPE; --
  
    --公共变量
    v_czyhjgjb    varchar2(20);
    v_json_data   json;
    v_json_yw_log json;
    v_json_return json := json();
    v_ywjl_czlx   varchar2(3);
    err_custom EXCEPTION;
    v_err     VARCHAR2(2000);
    v_sysdate date;
    v_count   number(2);
    -- 定义报告卡变量
    b_vc_sfsw   zjjk_xnxg_bgk.vc_sfsw%type; --是否死亡
    b_vc_kzt    zjjk_xnxg_bgk.vc_kzt%type; --报卡状态
    b_dt_swrq   zjjk_xnxg_bgk.dt_swrq%type; --死亡日期
    b_vc_swys   zjjk_xnxg_bgk.vc_swys%type; --死亡原因
    b_vc_czhkjd zjjk_xnxg_bgk.vc_czhkjd%type; --常住户口街道代码
    b_vc_qcbz   zjjk_xnxg_bgk.vc_qcbz%type; --迁出标志
    b_vc_qcd    zjjk_xnxg_bgk.vc_qcd%type; --户口省
    b_vc_qcsdm  zjjk_xnxg_bgk.vc_qcsdm%type; --户口市
    b_vc_qcqxdm zjjk_xnxg_bgk.vc_qcqxdm%type; --户口区县
    b_vc_qcjddm zjjk_xnxg_bgk.vc_qcjddm%type; --户口街道
    b_vc_qcjw   zjjk_xnxg_bgk.vc_qcjw%type; --户口居委
    b_vc_qcxxdz zjjk_xnxg_bgk.vc_qcxxdz%type; --户口详细地址
    b_vc_sfcf   zjjk_xnxg_bgk.vc_sfcf%type; --是否初访
    b_dt_cfsj   zjjk_xnxg_bgk.dt_cfsj%type; --初访时间
    b_dt_sfsj   zjjk_xnxg_bgk.dt_sfsj%type; --随访时间
    b_vc_sfqc   zjjk_xnxg_bgk.vc_sfqc%type; --随访迁出
    b_dt_qcsj   zjjk_xnxg_bgk.dt_qcsj%type; --迁出时间
    b_dt_qrsj   zjjk_xnxg_bgk.dt_qrsj%type; -- 迁入时间
  
  BEGIN
    json_data(Data_In, 'zjjk_xnxg_cfk新增', v_json_data);
    v_sysdate := sysdate;
    --初随访卡赋值
    v_czyhjgjb         := json_str(v_json_data, 'czyjgjb');
    v_vc_ywzlqt3       := Json_Str(v_Json_Data, 'vc_ywzlqt3');
    v_vc_ywzlqt2       := Json_Str(v_Json_Data, 'vc_ywzlqt2');
    v_vc_sfkid         := Json_Str(v_Json_Data, 'vc_sfkid');
    v_vc_bgkid         := Json_Str(v_Json_Data, 'vc_bgkid');
    v_dt_sfrq          := std(Json_Str(v_Json_Data, 'dt_sfrq'), 1);
    v_vc_sfys          := Json_Str(v_Json_Data, 'vc_sfys');
    v_vc_hjqc          := Json_Str(v_Json_Data, 'vc_hjqc');
    v_vc_qydz          := Json_Str(v_Json_Data, 'vc_qydz');
    v_dt_qyrq          := std(Json_Str(v_Json_Data, 'dt_qyrq'), 1);
    v_vc_sfzlqk        := Json_Str(v_Json_Data, 'vc_sfzlqk');
    v_vc_sfqfzqk       := Json_Str(v_Json_Data, 'vc_sfqfzqk');
    v_nb_sfqfzcs       := Json_Str(v_Json_Data, 'nb_sfqfzcs');
    v_dt_dycfbsj       := std(Json_Str(v_Json_Data, 'dt_dycfbsj'), 1);
    v_dt_dycqzsj       := std(Json_Str(v_Json_Data, 'dt_dycqzsj'), 1);
    v_dt_decfbsj       := std(Json_Str(v_Json_Data, 'dt_decfbsj'), 1);
    v_dt_decqzsj       := std(Json_Str(v_Json_Data, 'dt_decqzsj'), 1);
    v_dt_dscfbsj       := std(Json_Str(v_Json_Data, 'dt_dscfbsj'), 1);
    v_dt_dscqzsj       := std(Json_Str(v_Json_Data, 'dt_dscqzsj'), 1);
    v_vc_mqqk          := Json_Str(v_Json_Data, 'vc_mqqk');
    v_vc_sfhyz         := Json_Str(v_Json_Data, 'vc_sfhyz');
    v_dt_cxglrq        := std(Json_Str(v_Json_Data, 'dt_cxglrq'), 1);
    v_vc_cxyy          := Json_Str(v_Json_Data, 'vc_cxyy');
    v_vc_cxyyzm        := Json_Str(v_Json_Data, 'vc_cxyyzm');
    v_nb_qzsjn         := Json_Str(v_Json_Data, 'nb_qzsjn');
    v_nb_qzsjy         := Json_Str(v_Json_Data, 'nb_qzsjy');
    v_dt_swrq          := std(Json_Str(v_Json_Data, 'dt_swrq'), 1);
    v_vc_swyy          := Json_Str(v_Json_Data, 'vc_swyy');
    v_vc_swdd          := Json_Str(v_Json_Data, 'vc_swdd');
    v_nb_scqn          := Json_Str(v_Json_Data, 'nb_scqn');
    v_nb_scqy          := Json_Str(v_Json_Data, 'nb_scqy');
    v_vc_scbz          := Json_Str(v_Json_Data, 'vc_scbz');
    v_vc_cjyh          := Json_Str(v_Json_Data, 'czyyhid');
    v_dt_cjsj          := v_sysdate;
    v_dt_xgsj          := v_sysdate;
    v_vc_xgyh          := Json_Str(v_Json_Data, 'czyyhid');
    v_vc_qcd           := Json_Str(v_Json_Data, 'vc_qcd');
    v_vc_qcsdm         := Json_Str(v_Json_Data, 'vc_qcsdm');
    v_vc_qcqxdm        := Json_Str(v_Json_Data, 'vc_qcqxdm');
    v_vc_qcjddm        := Json_Str(v_Json_Data, 'vc_qcjddm');
    v_vc_qcjw          := Json_Str(v_Json_Data, 'vc_qcjw');
    v_vc_qcxxdz        := Json_Str(v_Json_Data, 'vc_qcxxdz');
    v_vc_swicd         := Json_Str(v_Json_Data, 'vc_swicd');
    v_vc_swicdmc       := Json_Str(v_Json_Data, 'vc_swicdmc');
    v_vc_zlqk          := Json_Str(v_Json_Data, 'vc_zlqk');
    v_vc_jzs           := Json_Str(v_Json_Data, 'vc_jzs');
    v_vc_gx            := Json_Str(v_Json_Data, 'vc_gx');
    v_vc_sfdyyjz       := Json_Str(v_Json_Data, 'vc_sfdyyjz');
    v_dt_qzrq          := std(Json_Str(v_Json_Data, 'dt_qzrq'), 1);
    v_vc_xys           := Json_Str(v_Json_Data, 'vc_xys');
    v_vc_jyyf          := Json_Str(v_Json_Data, 'vc_jyyf');
    v_vc_fzqrkpf       := Json_Str(v_Json_Data, 'vc_fzqrkpf');
    v_vc_cfrkpf        := Json_Str(v_Json_Data, 'vc_cfrkpf');
    v_vc_ywzl          := Json_Str(v_Json_Data, 'vc_ywzl');
    v_vc_ywzlqt        := Json_Str(v_Json_Data, 'vc_ywzlqt');
    v_vc_zlqk2         := Json_Str(v_Json_Data, 'vc_zlqk2');
    v_vc_zlqk3         := Json_Str(v_Json_Data, 'vc_zlqk3');
    v_vc_sffbsw1       := Json_Str(v_Json_Data, 'vc_sffbsw1');
    v_vc_sffbsw2       := Json_Str(v_Json_Data, 'vc_sffbsw2');
    v_vc_sffbsw3       := Json_Str(v_Json_Data, 'vc_sffbsw3');
    v_vc_cfrkpf2       := Json_Str(v_Json_Data, 'vc_cfrkpf2');
    v_vc_cfrkpf3       := Json_Str(v_Json_Data, 'vc_cfrkpf3');
    v_vc_ywzl2         := Json_Str(v_Json_Data, 'vc_ywzl2');
    v_vc_ywzl3         := Json_Str(v_Json_Data, 'vc_ywzl3');
    v_vc_bfz1          := Json_Str(v_Json_Data, 'vc_bfz1');
    v_vc_bfz2          := Json_Str(v_Json_Data, 'vc_bfz2');
    v_vc_bfz3          := Json_Str(v_Json_Data, 'vc_bfz3');
    v_vc_gxbz          := Json_Str(v_Json_Data, 'vc_gxbz');
    v_upload_areaeport := Json_Str(v_Json_Data, 'upload_areaeport');
  
    if (v_vc_bgkid is not null) then
      select vc_sfsw,
             vc_kzt,
             dt_swrq,
             vc_swys,
             vc_qcbz,
             vc_czhkjd,
             vc_qcd,
             vc_qcsdm,
             vc_qcqxdm,
             vc_qcjddm,
             vc_qcjw,
             vc_qcxxdz,
             vc_sfcf,
             dt_cfsj,
             dt_sfsj,
             vc_sfqc,
             dt_qcsj,
             dt_qrsj
        into b_vc_sfsw,
             b_vc_kzt,
             b_dt_swrq,
             b_vc_swys,
             b_vc_qcbz,
             b_vc_czhkjd,
             b_vc_qcd,
             b_vc_qcsdm,
             b_vc_qcqxdm,
             b_vc_qcjddm,
             b_vc_qcjw,
             b_vc_qcxxdz,
             b_vc_sfcf,
             b_dt_cfsj,
             b_dt_sfsj,
             b_vc_sfqc,
             b_dt_qcsj,
             b_dt_qrsj
        from zjjk_xnxg_bgk
       where vc_bgkid = v_vc_bgkid;
    else
      v_err := '糖尿病报告卡id不能为空！';
      raise err_custom;
    end if;
    --操作相应的报告卡信息
    if (v_vc_sfkid is null) then
      v_ywjl_czlx := '01';
      --是否死亡 设置死亡原因，报卡状态
      if (v_vc_swyy is not null) then
        b_vc_sfsw := '1';
        b_vc_kzt  := '7';
        b_vc_swys := v_vc_swyy;
        b_dt_swrq := v_dt_swrq;
      else
        b_vc_sfsw := '0';
        b_vc_kzt  := '0';
      end if;
      --设置报告卡状态
      if (b_vc_kzt <> '4') then
        if (v_dt_cxglrq is not null and v_vc_cxyy = '2') then
          b_vc_kzt := '3';
        elsif (v_dt_cxglrq is not null and v_vc_cxyy = '4') then
          b_vc_kzt  := '7';
          b_dt_swrq := v_dt_swrq;
        elsif (v_dt_cxglrq is not null and v_vc_cxyy = '1') then
          b_vc_kzt := '6';
        end if;
      end if;
      --判断是否户籍迁出
      if (v_vc_hjqc = '1') then
        b_vc_qcbz := '1';
      end if;
      if (b_vc_czhkjd = v_vc_qcjddm and v_vc_hjqc = '1') then
        v_err := '迁出地址不可为原地址！';
        raise err_custom;
      end if;
      b_vc_sfcf   := '3';
      b_dt_sfsj   := v_dt_sfrq;
      b_vc_sfqc   := v_vc_hjqc;
      b_vc_qcd    := v_vc_qcd;
      b_vc_qcsdm  := v_vc_qcsdm;
      b_vc_qcqxdm := v_vc_qcqxdm;
      b_vc_qcjddm := v_vc_qcjddm;
      b_vc_qcjw   := v_vc_qcjw;
      b_vc_qcxxdz := v_vc_qcxxdz;
      b_dt_qcsj   := v_dt_qyrq;
      b_dt_qrsj   := v_dt_sfrq;
      --操作更新报卡信息
      update zjjk_xnxg_bgk
         set vc_sfsw   = b_vc_sfsw,
             vc_kzt    = b_vc_kzt,
             dt_swrq   = b_dt_swrq,
             vc_swys   = b_vc_swys,
             vc_qcbz   = b_vc_qcbz,
             vc_qcd    = b_vc_qcd,
             vc_qcsdm  = b_vc_qcsdm,
             vc_qcqxdm = b_vc_qcqxdm,
             vc_qcjddm = b_vc_qcjddm,
             vc_qcjw   = b_vc_qcjw,
             vc_qcxxdz = b_vc_qcxxdz,
             vc_sfcf   = b_vc_sfcf,
             dt_cfsj   = b_dt_cfsj,
             dt_sfsj   = b_dt_sfsj,
             vc_sfqc   = b_vc_sfqc,
             dt_qcsj   = b_dt_qcsj,
             dt_qrsj   = b_dt_qrsj,
             dt_xgsj   = sysdate
       where vc_bgkid = v_vc_bgkid;
      --更新副卡vc_bgkzt,dt_swrq，vc_swyy
      update zjjk_xnxg_bgk a
         set a.vc_kzt  = b_vc_kzt,
             a.dt_swrq = b_dt_swrq,
             a.vc_swys = b_vc_swys,
             a.dt_xgsj = sysdate
       where exists (select 1
                from zjjk_xnxg_bgk_zfgx b
               where a.vc_bgkid = b.vc_fkid
                 and b.vc_zkid <> b.vc_fkid
                 and b.vc_zkid = v_vc_bgkid);
      --检验字段必填
      --校验数据是否合法
      if v_dt_sfrq is null then
        v_err := '随访日期不能为空!';
        raise err_custom;
      end if;
      if v_vc_sfys is null then
        v_err := '随访医生不能为空!';
        raise err_custom;
      end if;
      if v_vc_hjqc = '1' then
        if v_vc_qcd is null then
          v_err := '迁出省不能为空!';
          raise err_custom;
        end if;
        --浙江省
        if v_vc_hjqc = '1' then
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
          if substr(v_vc_qcsdm, 1, 4) <> substr(v_vc_qcqxdm, 1, 4) or
             substr(v_vc_qcsdm, 1, 4) <> substr(v_vc_qcjddm, 1, 4) then
            v_err := '迁出地址区划不匹配!';
            raise err_custom;
          end if;
          if v_vc_qcjw is null then
            v_err := '迁出居委不能为空!';
            raise err_custom;
          end if;
          if v_vc_qcxxdz is null then
            v_err := '详细地址不能为空!';
            raise err_custom;
          end if;
          if v_dt_qyrq is null then
            v_err := '迁移日期不能为空!';
            raise err_custom;
          end if;
        end if;
      end if;
      if v_vc_jzs = '1' and v_vc_gx is null then
        v_err := '与患者关系不能为空!';
        raise err_custom;
      end if;
      if v_vc_swyy is not null and v_dt_swrq is null then
        v_err := '死亡日期不能为空!';
        raise err_custom;
      end if;
      if v_vc_swyy is not null and v_vc_swicd is null then
        v_err := '死亡ICD不能为空!';
        raise err_custom;
      end if;
      if v_vc_swyy is not null and v_vc_swdd is null then
        v_err := '死亡地点不能为空!';
        raise err_custom;
      end if;
      if instr(v_vc_ywzl, '5') > 0 and v_vc_ywzlqt is null then
        v_err := '其他药物1不能为空!';
        raise err_custom;
      end if;
      if instr(v_vc_ywzl2, '5') > 0 and v_vc_ywzlqt2 is null then
        v_err := '其他药物2不能为空!';
        raise err_custom;
      end if;
      if instr(v_vc_ywzl3, '5') > 0 and v_vc_ywzlqt3 is null then
        v_err := '其他药物3不能为空!';
        raise err_custom;
      end if;
      --新增插入随访卡信息
      v_vc_sfkid := sys_guid();
      insert into zjjk_xnxg_sfk
        (vc_ywzlqt3,
         vc_gxbz,
         vc_bfz3,
         vc_bfz2,
         vc_bfz1,
         vc_ywzl3,
         vc_ywzl2,
         vc_cfrkpf3,
         vc_cfrkpf2,
         vc_sffbsw3,
         vc_sffbsw2,
         vc_sffbsw1,
         vc_zlqk3,
         vc_zlqk2,
         vc_ywzlqt,
         vc_ywzl,
         vc_cfrkpf,
         vc_fzqrkpf,
         vc_jyyf,
         vc_xys,
         dt_qzrq,
         vc_sfdyyjz,
         vc_gx,
         vc_jzs,
         vc_zlqk,
         vc_swicdmc,
         vc_swicd,
         vc_qcxxdz,
         vc_qcjw,
         vc_qcjddm,
         vc_qcqxdm,
         vc_qcsdm,
         vc_qcd,
         vc_xgyh,
         dt_xgsj,
         dt_cjsj,
         vc_cjyh,
         vc_scbz,
         nb_scqy,
         nb_scqn,
         vc_swdd,
         vc_swyy,
         dt_swrq,
         nb_qzsjy,
         nb_qzsjn,
         vc_cxyyzm,
         vc_cxyy,
         dt_cxglrq,
         vc_sfhyz,
         vc_mqqk,
         dt_dscqzsj,
         dt_dscfbsj,
         dt_decqzsj,
         dt_decfbsj,
         dt_dycqzsj,
         dt_dycfbsj,
         nb_sfqfzcs,
         vc_sfqfzqk,
         vc_sfzlqk,
         dt_qyrq,
         vc_qydz,
         vc_hjqc,
         vc_sfys,
         dt_sfrq,
         vc_bgkid,
         vc_sfkid,
         vc_ywzlqt2)
      values
        (v_vc_ywzlqt3,
         v_vc_gxbz,
         v_vc_bfz3,
         v_vc_bfz2,
         v_vc_bfz1,
         v_vc_ywzl3,
         v_vc_ywzl2,
         v_vc_cfrkpf3,
         v_vc_cfrkpf2,
         v_vc_sffbsw3,
         v_vc_sffbsw2,
         v_vc_sffbsw1,
         v_vc_zlqk3,
         v_vc_zlqk2,
         v_vc_ywzlqt,
         v_vc_ywzl,
         v_vc_cfrkpf,
         v_vc_fzqrkpf,
         v_vc_jyyf,
         v_vc_xys,
         v_dt_qzrq,
         v_vc_sfdyyjz,
         v_vc_gx,
         v_vc_jzs,
         v_vc_zlqk,
         v_vc_swicdmc,
         v_vc_swicd,
         v_vc_qcxxdz,
         v_vc_qcjw,
         v_vc_qcjddm,
         v_vc_qcqxdm,
         v_vc_qcsdm,
         v_vc_qcd,
         v_vc_xgyh,
         v_dt_xgsj,
         v_dt_cjsj,
         v_vc_cjyh,
         v_vc_scbz,
         v_nb_scqy,
         v_nb_scqn,
         v_vc_swdd,
         v_vc_swyy,
         v_dt_swrq,
         v_nb_qzsjy,
         v_nb_qzsjn,
         v_vc_cxyyzm,
         v_vc_cxyy,
         v_dt_cxglrq,
         v_vc_sfhyz,
         v_vc_mqqk,
         v_dt_dscqzsj,
         v_dt_dscfbsj,
         v_dt_decqzsj,
         v_dt_decfbsj,
         v_dt_dycqzsj,
         v_dt_dycfbsj,
         v_nb_sfqfzcs,
         v_vc_sfqfzqk,
         v_vc_sfzlqk,
         v_dt_qyrq,
         v_vc_qydz,
         v_vc_hjqc,
         v_vc_sfys,
         v_dt_sfrq,
         v_vc_bgkid,
         v_vc_sfkid,
         v_vc_ywzlqt2);
    ELSE
      v_ywjl_czlx := '02';
      --是否死亡 设置死亡原因，报卡状态
      if (v_vc_swyy is not null) then
        b_vc_sfsw := '1';
        b_vc_kzt  := '7';
        b_dt_swrq := v_dt_swrq;
      else
        b_vc_sfsw := '0';
        b_vc_kzt  := '0';
      end if;
      --设置报告卡状态
      if (b_vc_kzt <> '4') then
        if (v_dt_cxglrq is not null and v_vc_cxyy = '2') then
          b_vc_kzt := '3';
        elsif (v_dt_cxglrq is not null and v_vc_cxyy = '4') then
          b_vc_kzt  := '7';
          b_dt_swrq := v_dt_swrq;
        elsif (v_dt_cxglrq is not null and v_vc_cxyy = '1') then
          b_vc_kzt := '6';
        end if;
      end if;
      --判断是否户籍迁出
      if (v_vc_hjqc = '1') then
        b_vc_qcbz := '1';
      end if;
      b_dt_sfsj   := v_dt_sfrq;
      b_vc_sfqc   := v_vc_hjqc;
      b_vc_qcd    := v_vc_qcd;
      b_vc_qcsdm  := v_vc_qcsdm;
      b_vc_qcqxdm := v_vc_qcqxdm;
      b_vc_qcjddm := v_vc_qcjddm;
      b_vc_qcjw   := v_vc_qcjw;
      b_vc_qcxxdz := v_vc_qcxxdz;
      b_dt_qcsj   := v_dt_qyrq;
      b_dt_qrsj   := v_dt_sfrq;
      --操作更新报卡信息
      update zjjk_xnxg_bgk
         set vc_sfsw   = b_vc_sfsw,
             vc_kzt    = b_vc_kzt,
             dt_swrq   = b_dt_swrq,
             vc_swys   = b_vc_swys,
             vc_qcbz   = b_vc_qcbz,
             vc_qcd    = b_vc_qcd,
             vc_qcsdm  = b_vc_qcsdm,
             vc_qcqxdm = b_vc_qcqxdm,
             vc_qcjddm = b_vc_qcjddm,
             vc_qcjw   = b_vc_qcjw,
             vc_qcxxdz = b_vc_qcxxdz,
             vc_sfcf   = b_vc_sfcf,
             dt_cfsj   = b_dt_cfsj,
             dt_sfsj   = b_dt_sfsj,
             vc_sfqc   = b_vc_sfqc,
             dt_qcsj   = b_dt_qcsj,
             dt_qrsj   = b_dt_qrsj,
             dt_xgsj   = sysdate
       where vc_bgkid = v_vc_bgkid;
      --更新副卡vc_bgkzt,dt_swrq，vc_swyy
      update zjjk_xnxg_bgk a
         set a.vc_kzt  = b_vc_kzt,
             a.dt_swrq = b_dt_swrq,
             a.vc_swys = b_vc_swys,
             a.dt_xgsj = sysdate
       where exists (select 1
                from zjjk_xnxg_bgk_zfgx b
               where a.vc_bgkid = b.vc_fkid
                 and b.vc_zkid <> b.vc_fkid
                 and b.vc_zkid = v_vc_bgkid);
      --更新报告卡信息
      update zjjk_xnxg_sfk
         set dt_sfrq    = v_dt_sfrq,
             vc_sfys    = v_vc_sfys,
             vc_hjqc    = v_vc_hjqc,
             dt_qyrq    = v_dt_qyrq,
             vc_qcd     = v_vc_qcd,
             vc_qcsdm   = v_vc_qcsdm,
             vc_qcqxdm  = v_vc_qcqxdm,
             vc_qcjddm  = v_vc_qcjddm,
             vc_qcjw    = v_vc_qcjw,
             vc_qcxxdz  = v_vc_qcxxdz,
             vc_xys     = v_vc_xys,
             nb_sfqfzcs = v_nb_sfqfzcs,
             dt_dycfbsj = v_dt_dycfbsj,
             dt_dycqzsj = v_dt_dycqzsj,
             vc_sffbsw1 = v_vc_sffbsw1,
             vc_cfrkpf  = v_vc_cfrkpf,
             vc_zlqk    = v_vc_zlqk,
             vc_ywzlqt  = v_vc_ywzlqt,
             dt_decfbsj = v_dt_decfbsj,
             dt_decqzsj = v_dt_decqzsj,
             vc_sffbsw2 = v_vc_sffbsw2,
             vc_cfrkpf2 = v_vc_cfrkpf2,
             vc_zlqk2   = v_vc_zlqk2,
             vc_ywzl2   = v_vc_ywzl2,
             vc_ywzlqt2 = v_vc_ywzlqt2,
             dt_dscfbsj = v_dt_dscfbsj,
             dt_dscqzsj = v_dt_dscqzsj,
             vc_sffbsw3 = v_vc_sffbsw3,
             vc_cfrkpf3 = v_vc_cfrkpf3,
             vc_zlqk3   = v_vc_zlqk3,
             vc_ywzl3   = v_vc_ywzl3,
             vc_ywzlqt3 = v_vc_ywzlqt3,
             vc_mqqk    = v_vc_mqqk,
             vc_sfhyz   = v_vc_sfhyz,
             vc_bfz1    = v_vc_bfz1,
             vc_jzs     = v_vc_jzs,
             vc_gx      = v_vc_gx,
             dt_cxglrq  = v_dt_cxglrq,
             vc_cxyy    = v_vc_cxyy,
             vc_cxyyzm  = v_vc_cxyyzm,
             dt_swrq    = v_dt_swrq,
             vc_swdd    = v_vc_swdd,
             vc_swyy    = v_vc_swyy,
             vc_swicd   = v_vc_swicd,
             vc_swicdmc = v_vc_swicdmc,
             nb_qzsjn   = v_nb_qzsjn,
             nb_qzsjy   = v_nb_qzsjy,
             nb_scqy    = v_nb_scqy,
             nb_scqn    = v_nb_scqn
       where vc_sfkid = v_vc_sfkid;
    end if;
    --记录日志
    v_json_yw_log := Json_ext.get_json(v_json_data, 'ywjllog');
    if v_json_yw_log is not null then
      v_json_yw_log.put('bgkid', v_vc_bgkid);
      v_json_yw_log.put('bgklx', '03');
      v_json_yw_log.put('ywjlid', v_vc_sfkid);
      v_json_yw_log.put('gnmk', '05');
      v_json_yw_log.put('gnmc', '心脑血管随访');
      v_json_yw_log.put('czlx', v_ywjl_czlx);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_update(v_json_yw_log, v_err);
      --pkg_zjmb_tnb.prc_zjjk_yw_log_update(v_json_yw_log, v_err);
      if v_err is not null then
        raise err_custom;
      end if;
    end if;
    --更新初随访状态
    pkg_zjmb_xnxg.prc_bgkcsfzt_update(v_vc_bgkid, v_err);
    v_json_return.put('vc_sfkid', v_vc_sfkid);
    v_json_return.put('vc_bgkid', v_vc_bgkid);
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      if (SQL%NOTFOUND) then
        v_err      := '未找到相应的心脑血管报卡信息';
        result_out := return_fail(v_err, 0);
      ELSE
        v_err      := SQLERRM;
        result_out := return_fail(v_err, 0);
      end if;
  END prc_xnxg_sfk_update;
  /*---------------------------------------------------
  //  心脑血管初随访删除
  //----------------------------------------------------*/
  procedure prc_xnxg_sfk_delete(Data_In    In Clob, --入参
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
    json_data(Data_In, 'ZJJK_XNXG_SFK_DELETE删除', v_json_data);
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
          from zjjk_XNXG_sfk
         where vc_bgkid = v_vc_bgkid;
        if (v_count > 0) then
          v_err := '该患者已有随访记录，不能删除初访记录';
          raise err_custom;
        end if;
      end if;
    end if;
    if (v_vc_sffl = '1') then
      DELETE FROM ZJJK_XNXG_CFK
       WHERE vc_cfkid = v_vc_sfkid
         and vc_bgkid = v_vc_bgkid;
    else
      DELETE FROM ZJJK_XNXG_SFK
       WHERE vc_sfkid = v_vc_sfkid
         and vc_bgkid = v_vc_bgkid;
    END IF;
    --记录日志
    v_json_yw_log := Json_ext.get_json(v_json_data, 'ywjllog');
    if v_json_yw_log is not null then
      v_json_yw_log.put('bgkid', v_vc_bgkid);
      v_json_yw_log.put('bgklx', '03');
      v_json_yw_log.put('ywjlid', v_vc_sfkid);
      v_json_yw_log.put('gnmk', '05');
      v_json_yw_log.put('gnmc', '心脑血管随访卡删除');
      v_json_yw_log.put('czlx', '04');
      pkg_zjmb_xtfz.prc_zjjk_yw_log_update(v_json_yw_log, v_err);
    end if;
    --更新初随访状态
    pkg_zjmb_xnxg.prc_bgkcsfzt_update(v_vc_bgkid, v_err);
    v_json_return.put('vc_sfkid', v_vc_sfkid);
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_xnxg_sfk_delete;
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
    select min(dt_cfrq)
      into v_cfsj
      from ZJJK_XNXG_CFK a
     where a.vc_bgkid = p_bgkid;
    --存在初访
    if v_cfsj is not null then
      v_cfzt := '1';
    end if;
    --随访
    select max(dt_sfrq)
      into v_sfsj
      from zjjk_XNXG_sfk a
     where a.vc_bgkid = p_bgkid;
    --存在初访
    if v_sfsj is not null then
      v_cfzt := '3';
    else
      v_sfsj := v_cfsj;
    end if;
    --更新报卡初随访状态
    update zjjk_xnxg_bgk a
       set a.vc_sfcf = v_cfzt,
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
END pkg_zjmb_xnxg;
