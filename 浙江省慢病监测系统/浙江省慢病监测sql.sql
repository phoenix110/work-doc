-- 所有的sql语句，要新增或者修改，手动改数据库
select * from sqldy where rownum < 2;

-- 存储过程，包名 GCMC 包名.过程名
select * from prody where rownum < 2;

-- 系统日志，存储过程执行的记录
SELECT * FROM TB_LOG where rownum < 2;

-- 业务日志
SELECT * FROM ZJJK_YW_LOG where rownum < 2;

-- 字典表
-- pkg_zjmb_tnb.fun_getcommdic('C_COMM_SHEDM', vc_csdd) ,
select mc from p_tyzdml where fldm = 'C_COMM_SHEDM' and dm = ''; -- 省
select mc from p_tyzdml where fldm = 'C_COMM_SJDM' and dm = '33020000'; -- 市
select * from p_xzdm where jb = '3' and dm = '33028300';  -- 区县
select * from p_xzdm where jb = '4' and dm = '33100202';  -- 街道
select pt.mc from p_tyzdml pt where pt.fldm = 'C_ZJMB_JKZK'; --健康状态
select pt.mc from p_tyzdml pt where pt.fldm = 'C_COMM_MZ'; --民族
select pt.mc from p_tyzdml pt where pt.fldm = 'C_COMM_SF'; --户籍核实
select pt.mc from p_tyzdml pt where pt.fldm = 'C_SMTJSW_WHSYY'; --未核实原因
select pt.mc from p_tyzdml pt where pt.fldm = 'C_COMM_SHZT'; --审核状态
select pt.mc from p_tyzdml pt where pt.fldm = 'DICT_SHJC_HJ'; --户籍
select pt.mc from p_tyzdml pt where pt.fldm = 'DICT_SHJC_ZY'; --职业
select pt.mc from p_tyzdml pt where pt.fldm = 'C_SHJC_FSDD'; --发生地点
select pt.mc from p_tyzdml pt where pt.fldm = 'DICT_SHJC_SSYY'; --受伤原因
select pt.mc from p_tyzdml pt where pt.fldm = 'DICT_SHJC_SSSZZSM'; --受伤时做什么
select pt.mc from p_tyzdml pt where pt.fldm = 'DICT_SHJC_YZCD'; --严重程度
select pt.mc from p_tyzdml pt where pt.fldm = 'DICT_SHJC_FSQSFYJ'; --发生前是否饮酒
select pt.mc from p_tyzdml pt where pt.fldm = 'DICT_SHJC_BRDDQK'; --病人抵达情况
select pt.mc from p_tyzdml pt where pt.fldm = 'DICT_SHJC_SFGY'; --是否故意
select pt.mc from p_tyzdml pt where pt.fldm = 'DICT_SHJC_JJ'; --结局
select pt.mc from p_tyzdml pt where pt.fldm = 'DICT_SHJC_SSZDJTGJ'; --受伤者的交通工具
select pt.mc from p_tyzdml pt where pt.fldm = 'DICT_SHJC_SSZDQK'; --受伤者情况
select pt.mc from p_tyzdml pt where pt.fldm = 'DICT_SHJC_SSZFSPZ'; --受伤者和什么发生碰撞
select pt.mc from p_tyzdml pt where pt.fldm = 'DICT_SHJC_SSZWZ'; --如乘坐机动车，受伤者位置
select pt.mc from p_tyzdml pt where pt.fldm = 'DICT_SHJC_HZJZKB'; --患者就诊科别

-- 医院
select DM , MC  from P_YLJG a where a.lb in ('B1', 'A1') and dm = '';

-- cdc数据交换 zjjkjk 日志查询 
select * from area_upload_log;
select * from zjsjk_ws_config;

select log.* from area_upload_log log, zjsjk_ws_config confwhere 
log.aera = conf.areacode
and conf.areaname = '义乌'

select log.*, bgk.* from area_upload_log log, zjsjk_ws_config conf, ZJJK_ZL_BGK bgk, ZJJK_ZL_HZXX hzxx where 
log.aera = conf.areacode
and log.operation_id = bgk.VC_BGKID
and BGK.VC_HZID = HZXX.VC_PERSONID
and conf.areaname = '义乌'
and hzxx.vc_sfzh like '%33072519360804%'

-- 数据交换 对账表，VC_SCBZ 1接收成功，未回传对账结果；2表示已回传对账结果到地市， vc_dzjg 1表示成功了
select * from zjjk_dz;

-- 查询用户信息
select a.*, b.* from xtyh a, p_ryxx b where a.ryid = b.id
select * from p_xzdm -- 行政区划

-- 报告卡状态;0.可用卡；2.死卡；3.误诊卡；4.重复卡；5.删除卡；6.失访卡；7.死亡卡
-- zjjk_zl_bgk.vc_sfcf 1为初访，3为随访，2为未初访，0为异常数据
-- v_czyjgjb 机构级别： 1，省，2市，3区，4医院社区

-- 自己添加肿瘤随访提醒 VC_GLDW = '331002'为区县级别的
-- update zjjk_zl_bgk set NB_KSPF = 40, DT_SFSJ = add_months(sysdate, -2) where VC_BGKID in ('ex1800000003696','ex1800000003697','ex1800000003698')；
-- update zjjk_zl_bgk set VC_GLDW = '331002', vc_sdqrzt = '1', vc_sfcf = '3', dt_swrq = null, vc_swyy = null, vc_shbz = '3', vc_bgkzt = '0',NB_KSPF = 40, DT_SFSJ = add_months(sysdate, -2),dt_sfrq = add_months(sysdate, -2) where VC_BGKID in ('ex1800000003696','ex1800000003697','ex1800000003698');
 
-- 自己添加糖尿病初访提醒
-- update zjjk_tnb_bgk set vc_scbz = '0', vc_bgkzt = '0', vc_sdqrzt = '1', vc_cfzt = '0', vc_gldw = '331002009' where vc_bgkid = '702916FF01546408E05010AC296E1C6D'

-- 自己添加糖尿病随访提醒 VC_GLDW = '331002'为区县级别的
-- update zjjk_tnb_bgk set vc_gldw = '331002', vc_sdqrzt = '1', vc_shbz = '3', vc_scbz = '0', vc_tnblx = '1', vc_bgkzt = '0', vc_cfzt = '3', dt_sfsj = add_months(sysdate,-11) where vc_bgkid in ('2c90ee26699f5d6001699f64d2470003','6E69C432D3B050E6E05010AC296E5189');

-- 自己添加心脑初访提醒
-- update zjjk_xnxg_bgk set VC_SFCF = '2', VC_KZT = '0', VC_SDQRZT = '1', VC_SHBZ = '3', vc_czhks = '0', vc_gldwdm = '331002009' where vc_bgkid = '87A877762F779B64E05010AC296E6482'

-- 自己添加肿瘤初访提醒
-- update zjjk_zl_bgk set VC_SFCF = '2', VC_BGKZT = '0', VC_SDQRZT = '1', VC_SHBZ = '3', VC_SCBZ = '0',VC_GLDW = '331002009' where vc_bgkid = '19100200900009'

select * from sqldy where mkbh = '020205';-- 糖尿病初随访
select * from sqldy where mkbh = '020302';-- 肿瘤初访
select * from sqldy where mkbh = '020303'; -- 肿瘤随访
select * from sqldy where mkbh = '020601'; -- 生命统计死亡管理
select * from sqldy where mkbh = '020401'; -- 心脑血管
select * from sqldy where mkbh = '020301';-- 肿瘤报告卡
select * from sqldy where mkbh = '020201';    -- 糖尿病报告卡
select * from sqldy where mkbh = '020203';-- 糖尿病死亡补发
select * from sqldy where mkbh = '020307';-- 肿瘤死亡补发
select * from sqldy where mkbh = '020403';-- 心脑血管死亡补发
select * from sqldy where mkbh = '020308';  -- 肿瘤报卡查重

-- 存储过程编译卡死
SELECT * FROM V$DB_OBJECT_CACHE WHERE name='PKG_ZJMB_SMTJ' AND LOCKS!='0';
select /*+ rule*/  SID from V$ACCESS WHERE object='PKG_ZJMB_SMTJ';
SELECT 'alter system kill session '''||SID || ',' || SERIAL# || ''' immediate;' FROM V$SESSION WHERE SID in (
select /*+ rule*/  SID from V$ACCESS WHERE object='PKG_ZJMB_SMTJ'
)
alter system kill session '643,11' immediate;



