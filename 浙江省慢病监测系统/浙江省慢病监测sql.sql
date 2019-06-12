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

/*begin zjjkjk (zjjkjk2019) 数据回传记录查询 begin*/
-- 每天凌晨3点会定时回传
-- area_upload_log 表的 upresult 1为成功的，2为失败的
/* area_upload_log 表的 DATATYPE 
  DISEASE_TUMOR_ZX("1", "肿瘤报卡", "ZjjkZlHzxxBgks"),
  DISEASE_DIABETES_ZX("2", "糖尿病报卡", "ZjjkTnbHzxxBgks"),
  DISEASE_HEART_ZX("3", "心脑报卡", "ZjjkXnxgBgks"),
  DISEASE_HARM("4", "伤害报卡", "ZjmbShjcBgks"),
  DISEASE_DIE("5", "死亡报卡", "ZjmbSwBgks"),
  DISEASE_DIABETES_CF("6", "糖尿病初访卡", "ZjjkTnbSfks"),
  DISEASE_DIABETES_SF("7", "糖尿病随访卡", "ZjjkTnbSfks"),
  DISEASE_HEART_CF("8", "心脑初访卡", "ZjjkXnxgCfks"),
  DISEASE_HEART_SF("9", "心脑随访卡", "ZjjkXnxgSfks"),
  DISEASE_TUMOR_CF("10", "肿瘤初访卡", "ZjjkZlCcsfks"),
	DISEASE_TUMOR_SF("11", "肿瘤随访卡", "ZjjkZlSfks"),
	BACK_DISEASE("12", "校验结果", "ZjjkDzCxs");*/
  
-- 所有病种失败的记录 
select log.* from area_upload_log log, zjsjk_ws_config conf
where log.aera = conf.areacode
and conf.areaname = '嘉兴'
and upresult = '2'
and insert_time >= to_date('2019-05-01 00:00:00','yyyy-mm-dd hh24:mi:ss') 

-- 肿瘤失败的记录 
select count(*) from area_upload_log log, zjsjk_ws_config conf, ZJJK_ZL_BGK bgk, ZJJK_ZL_HZXX hzxx
where log.aera = conf.areacode
and log.operation_id = bgk.VC_BGKID
and BGK.VC_HZID = HZXX.VC_PERSONID
and log.datatype = '1'
and conf.areaname = '嘉兴'
and log.upresult = '2'
and log.insert_time >= to_date('2019-05-01 00:00:00','yyyy-mm-dd hh24:mi:ss') 

-- 糖尿病失败的记录 
select count(*) from area_upload_log log, zjsjk_ws_config conf, ZJJK_TNB_BGK bgk, ZJJK_TNB_HZXX hzxx
where log.aera = conf.areacode
and log.operation_id = bgk.VC_BGKID
and BGK.VC_HZID = HZXX.VC_PERSONID
and log.datatype = '2'
and conf.areaname = '嘉兴'
and upresult = '2'
and insert_time >= to_date('2019-05-01 00:00:00','yyyy-mm-dd hh24:mi:ss') 

-- 心脑血管失败的记录 
select count(*) from area_upload_log log, zjsjk_ws_config conf, ZJJK_XNXG_BGK bgk
where log.aera = conf.areacode
and log.operation_id = bgk.VC_BGKID
and log.datatype = '3'
and conf.areaname = '嘉兴'
and log.upresult = '2'
and log.insert_time >= to_date('2019-05-01 00:00:00','yyyy-mm-dd hh24:mi:ss') 

-- 死亡失败的记录 
select count(*) from area_upload_log log, zjsjk_ws_config conf, ZJMB_SW_BGK bgk
where log.aera = conf.areacode
and log.operation_id = bgk.VC_BGKID
and conf.areaname = '嘉兴'
and log.datatype = '5'
and upresult = '2'
and insert_time >= to_date('2019-05-01 00:00:00','yyyy-mm-dd hh24:mi:ss') 
/*end zjjkjk (zjjkjk2019) 数据回传记录查询 end*/



/*begin zjjkjk (zjjkjk2019) 数据回传重传 begin*/
-- 把相应报告卡的 dt_xgsj改成 sysdate，每天凌晨3点会定时回传
-- 肿瘤重传
update ZJJK_ZL_BGK t set t.dt_xgsj = sysdate where t.vc_bgkid in (
    select distinct bgk.vc_bgkid from area_upload_log log, zjsjk_ws_config conf, ZJJK_ZL_BGK bgk, ZJJK_ZL_HZXX hzxx
    where log.aera = conf.areacode
    and log.operation_id = bgk.VC_BGKID
    and BGK.VC_HZID = HZXX.VC_PERSONID
    and log.datatype = '1'
    and conf.areaname = '嘉兴'
    and log.upresult = '2'
    and log.insert_time >= to_date('2019-05-01 00:00:00','yyyy-mm-dd hh24:mi:ss') 
 )
 
 -- 糖尿病重传
update ZJJK_TNB_BGK t set t.dt_xgsj = sysdate where t.vc_bgkid in (
    select distinct bgk.vc_bgkid from area_upload_log log, zjsjk_ws_config conf, ZJJK_TNB_BGK bgk, ZJJK_TNB_HZXX hzxx
    where log.aera = conf.areacode
    and log.operation_id = bgk.VC_BGKID
    and BGK.VC_HZID = HZXX.VC_PERSONID
    and log.datatype = '2'
    and conf.areaname = '嘉兴'
    and upresult = '2'
    and insert_time >= to_date('2019-05-01 00:00:00','yyyy-mm-dd hh24:mi:ss') 
 )
 
  -- 心脑血管重传
update ZJJK_XNXG_BGK t set t.dt_xgsj = sysdate  where t.vc_bgkid in (
    select distinct bgk.vc_bgkid from area_upload_log log, zjsjk_ws_config conf, ZJJK_XNXG_BGK bgk
    where log.aera = conf.areacode
    and log.operation_id = bgk.VC_BGKID
    and log.datatype = '3'
    and conf.areaname = '嘉兴'
    and log.upresult = '2'
    and log.insert_time >= to_date('2019-05-01 00:00:00','yyyy-mm-dd hh24:mi:ss') 
 )

  -- 死亡重传
update ZJMB_SW_BGK t set t.dt_xgsj = sysdate where t.vc_bgkid in (
    select distinct bgk.vc_bgkid from area_upload_log log, zjsjk_ws_config conf, ZJMB_SW_BGK bgk
    where log.aera = conf.areacode
    and log.operation_id = bgk.VC_BGKID
    and conf.areaname = '嘉兴'
    and log.datatype = '5'
    and upresult = '2'
    and insert_time >= to_date('2019-05-01 00:00:00','yyyy-mm-dd hh24:mi:ss') 
 )
/*end zjjkjk (zjjkjk2019) 数据回传重传 end*/


-- 数据交换 对账表，VC_SCBZ 1接收成功，未回传对账结果；2表示已回传对账结果到地市， vc_dzjg 1表示成功了
-- 每一小时定时推送
select * from zjjk_dz;
-- 重新推送结果，把 zjjk_dz 表的要重推的数据的 VC_SCBZ 改成 1
-- update zjjk_dz set vc_scbz = '1' where vc_bgkid = 'xxxx'

-- 查询用户信息
select a.*, b.* from xtyh a, p_ryxx b where a.ryid = b.id
-- 清除门户账号绑定
-- update xtyh set ptyhid = null where yhm ='xxxx'

select * from p_xzdm -- 行政区划/行政代码
select * from p_yljg -- 医疗机构

-- 报告卡状态;0.可用卡；2.死卡；3.误诊卡；4.重复卡；5.删除卡；6.失访卡；7.死亡卡
-- zjjk_zl_bgk.vc_sfcf 1为初访，3为随访，2为未初访，0为异常数据
-- v_czyjgjb 机构级别： 1，省，2市，3区，4医院社区

-- 自己添加肿瘤随访提醒 VC_GLDW = '331002'为区县级别的
-- update zjjk_zl_bgk set NB_KSPF = 40, DT_SFSJ = add_months(sysdate, -2) where VC_BGKID in ('ex1800000003696','ex1800000003697','ex1800000003698')；
-- update zjjk_zl_bgk set VC_GLDW = '331002', vc_sdqrzt = '1', vc_sfcf = '3', dt_swrq = null, vc_swyy = null, vc_shbz = '3', vc_bgkzt = '0',NB_KSPF = 40, DT_SFSJ = add_months(sysdate, -2),dt_sfrq = add_months(sysdate, -2) where VC_BGKID in ('ex1800000003696','ex1800000003697','ex1800000003698');
 
-- 自己添加糖尿病初访提醒
-- update zjjk_tnb_bgk set vc_scbz = '0', vc_bgkzt = '0', vc_sdqrzt = '1', vc_cfzt = '0', vc_gldw = '331002009' where vc_bgkid = '6E69C432D3B050E6E05010AC296E5189'

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

-- 在所有存入过程或者包和函数等，中查找字符
select t.* from all_source t where 1=1
--  and  type = 'PACKAGE' 
and text like '%ZJJK_DATAEX_VALIDATE%'

-- 导入情况统计增加删除按钮 --
select * from sqldy where mkbh = '020801' and ywdm = '1' 
select * from sqldy where mkbh = '020801' and ywdm = '2' 


select vc_personid, count(vc_personid) n from zjjk_tnb_hzxx_ex_bak group by vc_personid order by n desc
select vc_yyrid, count(vc_yyrid) n from zjjk_tnb_bgk_ex_bak group by vc_yyrid order by n desc
select vc_yyrid, count(vc_yyrid) n from zjjk_xnxg_bgk_ex_bak group by vc_yyrid order by n desc
select vc_personid, count(vc_personid) n from zjjk_zl_hzxx_ex_bak group by vc_personid order by n desc 
select vc_yyrid, count(vc_yyrid) n from zjjk_zl_bgk_ex_bak group by vc_yyrid order by n desc
select vc_yyrid, count(vc_yyrid) n from zjjk_shjc_bgk_ex_bak group by vc_yyrid order by n desc
select vc_yyrid, count(vc_yyrid) n from zjjk_sw_bgk_ex_bak_new group by vc_yyrid order by n desc

select * from zjjk_tnb_hzxx_ex_bak group by vc_personid order by n desc
select *  from zjjk_tnb_bgk_ex_bak group by vc_yyrid order by n desc
select *  from zjjk_xnxg_bgk_ex_bak group by vc_yyrid order by n desc
select *  from zjjk_zl_hzxx_ex_bak group by vc_personid order by n desc 
select *  from zjjk_zl_bgk_ex_bak group by vc_yyrid order by n desc
select *  from zjjk_shjc_bgk_ex_bak group by vc_yyrid order by n desc
select *  from zjjk_sw_bgk_ex_bak_new group by vc_yyrid order by n desc

select '糖尿病报告卡' sbxt,
       count(1) hjsbs,
       nvl(sum(decode(is_pass, 1, 1)),0) zqsbs,
       nvl(sum(decode(is_pass, 2, 1)),0) cwsbs,
       '2' type
  from zjjk_tnb_bgk_ex_bak b1
  where b1.vc_bgdw = '330102026'
 -- group by vc_bgdw
 
 update zjjk_tnb_bgk_ex_bak set vc_bgdw = '330102026' where vc_bgdw = '330303003'
-- 导入情况统计增加删除按钮 --

select distinct is_pass from zjjk_tnb_bgk_ex_bak
update zjjk_tnb_bgk_ex_bak set is_pass = '2' where vc_bgdw = '330102026'

Tnb_ExValidate
zl_ExValidate
ZJJK_DATAEX_VALIDATE_NEW

/*
alter table zjjk_tnb_hzxx_ex_bak add uuid varchar2(60);
update zjjk_tnb_hzxx_ex_bak set uuid = sys_guid();
commit;
alter table zjjk_tnb_hzxx_ex_bak add constraint pk_zjjk_tnb_hzxx_ex_bak primary key(uuid);

alter table zjjk_tnb_bgk_ex_bak add uuid varchar2(60);
update zjjk_tnb_bgk_ex_bak set uuid = sys_guid();
commit;
alter table zjjk_tnb_bgk_ex_bak add constraint pk_zjjk_tnb_bgk_ex_bak primary key(uuid);

alter table zjjk_zl_hzxx_ex_bak add uuid varchar2(60);
update zjjk_zl_hzxx_ex_bak set uuid = sys_guid();
commit;
alter table zjjk_zl_hzxx_ex_bak add constraint pk_zjjk_zl_hzxx_ex_bak primary key(uuid);

alter table zjjk_zl_bgk_ex_bak add uuid varchar2(60);
update zjjk_zl_bgk_ex_bak set uuid = sys_guid();
commit;
alter table zjjk_zl_bgk_ex_bak add constraint pk_zjjk_zl_bgk_ex_bak primary key(uuid);

alter table zjjk_xnxg_bgk_ex_bak add uuid varchar2(60);
update zjjk_xnxg_bgk_ex_bak set uuid = sys_guid();
commit;
alter table zjjk_xnxg_bgk_ex_bak add constraint pk_zjjk_xnxg_bgk_ex_bak primary key(uuid);

alter table zjjk_shjc_bgk_ex_bak add uuid varchar2(60);
update zjjk_shjc_bgk_ex_bak set uuid = sys_guid();
commit;
alter table zjjk_shjc_bgk_ex_bak add constraint pk_zjjk_shjc_bgk_ex_bak primary key(uuid);

alter table zjjk_sw_bgk_ex_bak_new add uuid varchar2(60);
update zjjk_sw_bgk_ex_bak_new set uuid = sys_guid();
commit;
alter table zjjk_sw_bgk_ex_bak_new add constraint pk_zjjk_sw_bgk_ex_bak_new primary key(uuid);

*/
-- ===============
