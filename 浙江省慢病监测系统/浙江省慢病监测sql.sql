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

-- 查询用户信息
select a.*, b.* from xtyh a, p_ryxx b where a.ryid = b.id

-- 医疗机构 p_yljg.lb : A1 医院，B1 社区，J1疾控(省，市，区县)
select * from p_yljg；
-- 行政区划 p_xzdm.jb : 1省，2市，3区县，4街道(乡镇)，5社区
select * from p_xzdm；

/* 旧表 organ_node.code 对应 p_yljg.dm
 removed:0为有效，1为无效。
 description不为空的是社区，为空的是其它。此字段代表社区对应的街道，一个社区可能对应多个街道
*/
select * from organ_node;

-- 登录账号信息 
select a.bz, a.dm, a.jc, a.xzqh, b.mc, b.jb, a.lb, a.id
  from p_yljg a, p_xzdm b
 where a.xzqh = b.dm
--传到前台的user对象中：
user.jglx: p_yljg.lb
user.jgjb:
       p_yljg.lb='J1' && p_xzdm.jb = '1' => '1'  省疾控
       p_yljg.lb='J1' && p_xzdm.jb = '2' => '2'  市疾控
       p_yljg.lb='J1' && p_xzdm.jb = '3' => '3'  区县疾控
       p_yljg.lb='A1' || p_yljg.lb='B1'  => '4'  医院或者社区
 
 
-- 清除门户账号绑定
-- update xtyh set ptyhid = null where yhm ='xxxx'


-- 报告卡状态;0.可用卡；2.死卡；3.误诊卡；4.重复卡；5.删除卡；6.失访卡；7.死亡卡
-- zjjk_zl_bgk.vc_sfcf 1为初访，3为随访，2为未初访，0为异常数据
-- v_czyjgjb 机构级别： 1，省，2市，3区，4医院社区

-- 添加肿瘤随访提醒 VC_GLDW = '331002'为区县级别的
-- update zjjk_zl_bgk set NB_KSPF = 40, DT_SFSJ = add_months(sysdate, -2) where VC_BGKID in ('ex1800000003696','ex1800000003697','ex1800000003698')；
-- update zjjk_zl_bgk set VC_GLDW = '331002', vc_sdqrzt = '1', vc_sfcf = '3', dt_swrq = null, vc_swyy = null, vc_shbz = '3', vc_bgkzt = '0',NB_KSPF = 40, DT_SFSJ = add_months(sysdate, -2),dt_sfrq = add_months(sysdate, -2) where VC_BGKID in ('ex1800000003696','ex1800000003697','ex1800000003698');
 
-- 添加糖尿病初访提醒
-- update zjjk_tnb_bgk set vc_scbz = '0', vc_bgkzt = '0', vc_sdqrzt = '1', vc_cfzt = '0', vc_gldw = '331002009' where vc_bgkid = '6E69C432D3B050E6E05010AC296E5189'

-- 添加糖尿病随访提醒 VC_GLDW = '331002'为区县级别的
-- update zjjk_tnb_bgk set vc_gldw = '331002', vc_sdqrzt = '1', vc_shbz = '3', vc_scbz = '0', vc_tnblx = '1', vc_bgkzt = '0', vc_cfzt = '3', dt_sfsj = add_months(sysdate,-11) where vc_bgkid in ('2c90ee26699f5d6001699f64d2470003','6E69C432D3B050E6E05010AC296E5189');

-- 添加心脑初访提醒
   /*update zjjk_xnxg_bgk set VC_SFCF = '2', VC_KZT = '0', VC_SDQRZT = '1', VC_SHBZ = '3', vc_czhks = '0', vc_gldwdm = '331002009' where vc_bgkid in ('6CFE6F6F68489936E05010AC296E74BA','88EEC967258C0036E05010AC296E086F');
   delete from zjjk_xnxg_cfk where vc_bgkid in ('6CFE6F6F68489936E05010AC296E74BA','88EEC967258C0036E05010AC296E086F');*/
   
-- 添加肿瘤初访提醒
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

-- 操作卡死
select object_name, machine, s.sid, s.serial#
  from v$locked_object l, dba_objects o, v$session s
 where l.object_id　 = 　o.object_id
   and l.session_id = s.sid;
alter system kill session 'SID,serial#';
-- 如 alter system kill session '81,38364';
--------------------- 


-- 在所有存入过程或者包和函数等，中查找字符
select t.* from all_source t where 1=1
--  and  type = 'PACKAGE' 
and text like '%ZJJK_DATAEX_VALIDATE%'

-- 导入校验入库 --
procedures
		Tnb_ExValidate
		zl_ExValidate
packages
		ZJJK_DATAEX_VALIDATE_NEW
    
-- 业务操作日志
select * from zjjk_yw_log_bgjl where 1=1 and  bgkid = '8B80C1F22F9977DDE050007F010036F7' and bgzddm = 'vc_bgdwqx'
         

 
    
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

select * from sqldy where mkbh='020305' and ywdm= '01' for update -- 肿瘤 属地确认
select * from sqldy where mkbh='020202' and ywdm='1' for update   -- 糖尿病 属地确认
select * from sqldy where mkbh='020405' and ywdm='1' for update  -- 心脑 属地确认
select * from sqldy where mkbh='020502' and ywdm='1' for update  -- 出生 属地确认 查询和导出
select * from sqldy where mkbh='020602' and ywdm='1' for update    -- 死因 属地确认 查询
select * from sqldy where mkbh='020602' and ywdm='2' for update    -- 死因 属地确认 导出

-- 杭州，临安，青山湖街道 下有两个医院
select count(1), wm_concat(code) from organ_node where removed = '0' and description like '%33018503%'
select dm , mc from p_yljg where xzqh in ('33018503','33018568','33018569','33011450')
