-- ���е�sql��䣬Ҫ���������޸ģ��ֶ������ݿ�
select * from sqldy where rownum < 2;
-- �洢���̣����� GCMC ����.������
select * from prody where rownum < 2;
-- ϵͳ��־���洢����ִ�еļ�¼
SELECT * FROM TB_LOG where rownum < 2;
-- ҵ����־
SELECT * FROM ZJJK_YW_LOG where rownum < 2;

-- �ֵ��
-- pkg_zjmb_tnb.fun_getcommdic('C_COMM_SHEDM', vc_csdd) ,
select mc from p_tyzdml where fldm = 'C_COMM_SHEDM' and dm = ''; -- ʡ
select mc from p_tyzdml where fldm = 'C_COMM_SJDM' and dm = '33020000'; -- ��
select * from p_xzdm where jb = '3' and dm = '33028300';  -- ����
select * from p_xzdm where jb = '4' and dm = '33100202';  -- �ֵ�
select pt.mc from p_tyzdml pt where pt.fldm = 'C_ZJMB_JKZK'; --����״̬
select pt.mc from p_tyzdml pt where pt.fldm = 'C_COMM_MZ'; --����
select pt.mc from p_tyzdml pt where pt.fldm = 'C_COMM_SF'; --������ʵ
select pt.mc from p_tyzdml pt where pt.fldm = 'C_SMTJSW_WHSYY'; --δ��ʵԭ��
select pt.mc from p_tyzdml pt where pt.fldm = 'C_COMM_SHZT'; --���״̬
select pt.mc from p_tyzdml pt where pt.fldm = 'DICT_SHJC_HJ'; --����
select pt.mc from p_tyzdml pt where pt.fldm = 'DICT_SHJC_ZY'; --ְҵ
select pt.mc from p_tyzdml pt where pt.fldm = 'C_SHJC_FSDD'; --�����ص�
select pt.mc from p_tyzdml pt where pt.fldm = 'DICT_SHJC_SSYY'; --����ԭ��
select pt.mc from p_tyzdml pt where pt.fldm = 'DICT_SHJC_SSSZZSM'; --����ʱ��ʲô
select pt.mc from p_tyzdml pt where pt.fldm = 'DICT_SHJC_YZCD'; --���س̶�
select pt.mc from p_tyzdml pt where pt.fldm = 'DICT_SHJC_FSQSFYJ'; --����ǰ�Ƿ�����
select pt.mc from p_tyzdml pt where pt.fldm = 'DICT_SHJC_BRDDQK'; --���˵ִ����
select pt.mc from p_tyzdml pt where pt.fldm = 'DICT_SHJC_SFGY'; --�Ƿ����
select pt.mc from p_tyzdml pt where pt.fldm = 'DICT_SHJC_JJ'; --���
select pt.mc from p_tyzdml pt where pt.fldm = 'DICT_SHJC_SSZDJTGJ'; --�����ߵĽ�ͨ����
select pt.mc from p_tyzdml pt where pt.fldm = 'DICT_SHJC_SSZDQK'; --���������
select pt.mc from p_tyzdml pt where pt.fldm = 'DICT_SHJC_SSZFSPZ'; --�����ߺ�ʲô������ײ
select pt.mc from p_tyzdml pt where pt.fldm = 'DICT_SHJC_SSZWZ'; --�������������������λ��
select pt.mc from p_tyzdml pt where pt.fldm = 'DICT_SHJC_HZJZKB'; --���߾���Ʊ�

-- ҽԺ
select DM , MC  from P_YLJG a where a.lb in ('B1', 'A1') and dm = '';

/*begin zjjkjk (zjjkjk2019) ���ݻش���¼��ѯ begin*/
-- ÿ���賿3��ᶨʱ�ش�
-- area_upload_log ��� upresult 1Ϊ�ɹ��ģ�2Ϊʧ�ܵ�
/* area_upload_log ��� DATATYPE 
  DISEASE_TUMOR_ZX("1", "��������", "ZjjkZlHzxxBgks"),
  DISEASE_DIABETES_ZX("2", "���򲡱���", "ZjjkTnbHzxxBgks"),
  DISEASE_HEART_ZX("3", "���Ա���", "ZjjkXnxgBgks"),
  DISEASE_HARM("4", "�˺�����", "ZjmbShjcBgks"),
  DISEASE_DIE("5", "��������", "ZjmbSwBgks"),
  DISEASE_DIABETES_CF("6", "���򲡳��ÿ�", "ZjjkTnbSfks"),
  DISEASE_DIABETES_SF("7", "������ÿ�", "ZjjkTnbSfks"),
  DISEASE_HEART_CF("8", "���Գ��ÿ�", "ZjjkXnxgCfks"),
  DISEASE_HEART_SF("9", "������ÿ�", "ZjjkXnxgSfks"),
  DISEASE_TUMOR_CF("10", "�������ÿ�", "ZjjkZlCcsfks"),
	DISEASE_TUMOR_SF("11", "������ÿ�", "ZjjkZlSfks"),
	BACK_DISEASE("12", "У����", "ZjjkDzCxs");*/
  
-- ���в���ʧ�ܵļ�¼ 
select log.* from area_upload_log log, zjsjk_ws_config conf
where log.aera = conf.areacode
and conf.areaname = '����'
and upresult = '2'
and insert_time >= to_date('2019-05-01 00:00:00','yyyy-mm-dd hh24:mi:ss') 

-- ����ʧ�ܵļ�¼ 
select count(*) from area_upload_log log, zjsjk_ws_config conf, ZJJK_ZL_BGK bgk, ZJJK_ZL_HZXX hzxx
where log.aera = conf.areacode
and log.operation_id = bgk.VC_BGKID
and BGK.VC_HZID = HZXX.VC_PERSONID
and log.datatype = '1'
and conf.areaname = '����'
and log.upresult = '2'
and log.insert_time >= to_date('2019-05-01 00:00:00','yyyy-mm-dd hh24:mi:ss') 

-- ����ʧ�ܵļ�¼ 
select count(*) from area_upload_log log, zjsjk_ws_config conf, ZJJK_TNB_BGK bgk, ZJJK_TNB_HZXX hzxx
where log.aera = conf.areacode
and log.operation_id = bgk.VC_BGKID
and BGK.VC_HZID = HZXX.VC_PERSONID
and log.datatype = '2'
and conf.areaname = '����'
and upresult = '2'
and insert_time >= to_date('2019-05-01 00:00:00','yyyy-mm-dd hh24:mi:ss') 

-- ����Ѫ��ʧ�ܵļ�¼ 
select count(*) from area_upload_log log, zjsjk_ws_config conf, ZJJK_XNXG_BGK bgk
where log.aera = conf.areacode
and log.operation_id = bgk.VC_BGKID
and log.datatype = '3'
and conf.areaname = '����'
and log.upresult = '2'
and log.insert_time >= to_date('2019-05-01 00:00:00','yyyy-mm-dd hh24:mi:ss') 

-- ����ʧ�ܵļ�¼ 
select count(*) from area_upload_log log, zjsjk_ws_config conf, ZJMB_SW_BGK bgk
where log.aera = conf.areacode
and log.operation_id = bgk.VC_BGKID
and conf.areaname = '����'
and log.datatype = '5'
and upresult = '2'
and insert_time >= to_date('2019-05-01 00:00:00','yyyy-mm-dd hh24:mi:ss') 
/*end zjjkjk (zjjkjk2019) ���ݻش���¼��ѯ end*/



/*begin zjjkjk (zjjkjk2019) ���ݻش��ش� begin*/
-- ����Ӧ���濨�� dt_xgsj�ĳ� sysdate��ÿ���賿3��ᶨʱ�ش�
-- �����ش�
update ZJJK_ZL_BGK t set t.dt_xgsj = sysdate where t.vc_bgkid in (
    select distinct bgk.vc_bgkid from area_upload_log log, zjsjk_ws_config conf, ZJJK_ZL_BGK bgk, ZJJK_ZL_HZXX hzxx
    where log.aera = conf.areacode
    and log.operation_id = bgk.VC_BGKID
    and BGK.VC_HZID = HZXX.VC_PERSONID
    and log.datatype = '1'
    and conf.areaname = '����'
    and log.upresult = '2'
    and log.insert_time >= to_date('2019-05-01 00:00:00','yyyy-mm-dd hh24:mi:ss') 
 )
 
 -- �����ش�
update ZJJK_TNB_BGK t set t.dt_xgsj = sysdate where t.vc_bgkid in (
    select distinct bgk.vc_bgkid from area_upload_log log, zjsjk_ws_config conf, ZJJK_TNB_BGK bgk, ZJJK_TNB_HZXX hzxx
    where log.aera = conf.areacode
    and log.operation_id = bgk.VC_BGKID
    and BGK.VC_HZID = HZXX.VC_PERSONID
    and log.datatype = '2'
    and conf.areaname = '����'
    and upresult = '2'
    and insert_time >= to_date('2019-05-01 00:00:00','yyyy-mm-dd hh24:mi:ss') 
 )
 
  -- ����Ѫ���ش�
update ZJJK_XNXG_BGK t set t.dt_xgsj = sysdate  where t.vc_bgkid in (
    select distinct bgk.vc_bgkid from area_upload_log log, zjsjk_ws_config conf, ZJJK_XNXG_BGK bgk
    where log.aera = conf.areacode
    and log.operation_id = bgk.VC_BGKID
    and log.datatype = '3'
    and conf.areaname = '����'
    and log.upresult = '2'
    and log.insert_time >= to_date('2019-05-01 00:00:00','yyyy-mm-dd hh24:mi:ss') 
 )

  -- �����ش�
update ZJMB_SW_BGK t set t.dt_xgsj = sysdate where t.vc_bgkid in (
    select distinct bgk.vc_bgkid from area_upload_log log, zjsjk_ws_config conf, ZJMB_SW_BGK bgk
    where log.aera = conf.areacode
    and log.operation_id = bgk.VC_BGKID
    and conf.areaname = '����'
    and log.datatype = '5'
    and upresult = '2'
    and insert_time >= to_date('2019-05-01 00:00:00','yyyy-mm-dd hh24:mi:ss') 
 )
/*end zjjkjk (zjjkjk2019) ���ݻش��ش� end*/


-- ���ݽ��� ���˱�VC_SCBZ 1���ճɹ���δ�ش����˽����2��ʾ�ѻش����˽�������У� vc_dzjg 1��ʾ�ɹ���
-- ÿһСʱ��ʱ����
select * from zjjk_dz;
-- �������ͽ������ zjjk_dz ���Ҫ���Ƶ����ݵ� VC_SCBZ �ĳ� 1
-- update zjjk_dz set vc_scbz = '1' where vc_bgkid = 'xxxx'

-- ��ѯ�û���Ϣ
select a.*, b.* from xtyh a, p_ryxx b where a.ryid = b.id
-- ����Ż��˺Ű�
-- update xtyh set ptyhid = null where yhm ='xxxx'

select * from p_xzdm -- ��������/��������
select * from p_yljg -- ҽ�ƻ���

-- ���濨״̬;0.���ÿ���2.������3.���￨��4.�ظ�����5.ɾ������6.ʧ�ÿ���7.������
-- zjjk_zl_bgk.vc_sfcf 1Ϊ���ã�3Ϊ��ã�2Ϊδ���ã�0Ϊ�쳣����
-- v_czyjgjb �������� 1��ʡ��2�У�3����4ҽԺ����

-- �Լ��������������� VC_GLDW = '331002'Ϊ���ؼ����
-- update zjjk_zl_bgk set NB_KSPF = 40, DT_SFSJ = add_months(sysdate, -2) where VC_BGKID in ('ex1800000003696','ex1800000003697','ex1800000003698')��
-- update zjjk_zl_bgk set VC_GLDW = '331002', vc_sdqrzt = '1', vc_sfcf = '3', dt_swrq = null, vc_swyy = null, vc_shbz = '3', vc_bgkzt = '0',NB_KSPF = 40, DT_SFSJ = add_months(sysdate, -2),dt_sfrq = add_months(sysdate, -2) where VC_BGKID in ('ex1800000003696','ex1800000003697','ex1800000003698');
 
-- �Լ�������򲡳�������
-- update zjjk_tnb_bgk set vc_scbz = '0', vc_bgkzt = '0', vc_sdqrzt = '1', vc_cfzt = '0', vc_gldw = '331002009' where vc_bgkid = '6E69C432D3B050E6E05010AC296E5189'

-- �Լ��������������� VC_GLDW = '331002'Ϊ���ؼ����
-- update zjjk_tnb_bgk set vc_gldw = '331002', vc_sdqrzt = '1', vc_shbz = '3', vc_scbz = '0', vc_tnblx = '1', vc_bgkzt = '0', vc_cfzt = '3', dt_sfsj = add_months(sysdate,-11) where vc_bgkid in ('2c90ee26699f5d6001699f64d2470003','6E69C432D3B050E6E05010AC296E5189');

-- �Լ�������Գ�������
-- update zjjk_xnxg_bgk set VC_SFCF = '2', VC_KZT = '0', VC_SDQRZT = '1', VC_SHBZ = '3', vc_czhks = '0', vc_gldwdm = '331002009' where vc_bgkid = '87A877762F779B64E05010AC296E6482'

-- �Լ����������������
-- update zjjk_zl_bgk set VC_SFCF = '2', VC_BGKZT = '0', VC_SDQRZT = '1', VC_SHBZ = '3', VC_SCBZ = '0',VC_GLDW = '331002009' where vc_bgkid = '19100200900009'

select * from sqldy where mkbh = '020205';-- ���򲡳����
select * from sqldy where mkbh = '020302';-- ��������
select * from sqldy where mkbh = '020303'; -- �������
select * from sqldy where mkbh = '020601'; -- ����ͳ����������
select * from sqldy where mkbh = '020401'; -- ����Ѫ��
select * from sqldy where mkbh = '020301';-- �������濨
select * from sqldy where mkbh = '020201';    -- ���򲡱��濨
select * from sqldy where mkbh = '020203';-- ������������
select * from sqldy where mkbh = '020307';-- ������������
select * from sqldy where mkbh = '020403';-- ����Ѫ����������
select * from sqldy where mkbh = '020308';  -- ������������

-- �洢���̱��뿨��
SELECT * FROM V$DB_OBJECT_CACHE WHERE name='PKG_ZJMB_SMTJ' AND LOCKS!='0';
select /*+ rule*/  SID from V$ACCESS WHERE object='PKG_ZJMB_SMTJ';
SELECT 'alter system kill session '''||SID || ',' || SERIAL# || ''' immediate;' FROM V$SESSION WHERE SID in (
select /*+ rule*/  SID from V$ACCESS WHERE object='PKG_ZJMB_SMTJ'
)
alter system kill session '643,11' immediate;

-- �����д�����̻��߰��ͺ����ȣ��в����ַ�
select t.* from all_source t where 1=1
--  and  type = 'PACKAGE' 
and text like '%ZJJK_DATAEX_VALIDATE%'

-- �������ͳ������ɾ����ť --
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

select '���򲡱��濨' sbxt,
       count(1) hjsbs,
       nvl(sum(decode(is_pass, 1, 1)),0) zqsbs,
       nvl(sum(decode(is_pass, 2, 1)),0) cwsbs,
       '2' type
  from zjjk_tnb_bgk_ex_bak b1
  where b1.vc_bgdw = '330102026'
 -- group by vc_bgdw
 
 update zjjk_tnb_bgk_ex_bak set vc_bgdw = '330102026' where vc_bgdw = '330303003'
-- �������ͳ������ɾ����ť --

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
