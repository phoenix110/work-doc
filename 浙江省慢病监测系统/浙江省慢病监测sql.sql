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

-- ��ѯ�û���Ϣ
select a.*, b.* from xtyh a, p_ryxx b where a.ryid = b.id

-- ҽ�ƻ��� p_yljg.lb : A1 ҽԺ��B1 ������J1����(ʡ���У�����)
select * from p_yljg��
-- �������� p_xzdm.jb : 1ʡ��2�У�3���أ�4�ֵ�(����)��5����
select * from p_xzdm��

/* �ɱ� organ_node.code ��Ӧ p_yljg.dm
 removed:0Ϊ��Ч��1Ϊ��Ч��
 description��Ϊ�յ���������Ϊ�յ������������ֶδ���������Ӧ�Ľֵ���һ���������ܶ�Ӧ����ֵ�
*/
select * from organ_node;

-- ��¼�˺���Ϣ 
select a.bz, a.dm, a.jc, a.xzqh, b.mc, b.jb, a.lb, a.id
  from p_yljg a, p_xzdm b
 where a.xzqh = b.dm
--����ǰ̨��user�����У�
user.jglx: p_yljg.lb
user.jgjb:
       p_yljg.lb='J1' && p_xzdm.jb = '1' => '1'  ʡ����
       p_yljg.lb='J1' && p_xzdm.jb = '2' => '2'  �м���
       p_yljg.lb='J1' && p_xzdm.jb = '3' => '3'  ���ؼ���
       p_yljg.lb='A1' || p_yljg.lb='B1'  => '4'  ҽԺ��������
 
 
-- ����Ż��˺Ű�
-- update xtyh set ptyhid = null where yhm ='xxxx'


-- ���濨״̬;0.���ÿ���2.������3.���￨��4.�ظ�����5.ɾ������6.ʧ�ÿ���7.������
-- zjjk_zl_bgk.vc_sfcf 1Ϊ���ã�3Ϊ��ã�2Ϊδ���ã�0Ϊ�쳣����
-- v_czyjgjb �������� 1��ʡ��2�У�3����4ҽԺ����

-- �������������� VC_GLDW = '331002'Ϊ���ؼ����
-- update zjjk_zl_bgk set NB_KSPF = 40, DT_SFSJ = add_months(sysdate, -2) where VC_BGKID in ('ex1800000003696','ex1800000003697','ex1800000003698')��
-- update zjjk_zl_bgk set VC_GLDW = '331002', vc_sdqrzt = '1', vc_sfcf = '3', dt_swrq = null, vc_swyy = null, vc_shbz = '3', vc_bgkzt = '0',NB_KSPF = 40, DT_SFSJ = add_months(sysdate, -2),dt_sfrq = add_months(sysdate, -2) where VC_BGKID in ('ex1800000003696','ex1800000003697','ex1800000003698');
 
-- ������򲡳�������
-- update zjjk_tnb_bgk set vc_scbz = '0', vc_bgkzt = '0', vc_sdqrzt = '1', vc_cfzt = '0', vc_gldw = '331002009' where vc_bgkid = '6E69C432D3B050E6E05010AC296E5189'

-- �������������� VC_GLDW = '331002'Ϊ���ؼ����
-- update zjjk_tnb_bgk set vc_gldw = '331002', vc_sdqrzt = '1', vc_shbz = '3', vc_scbz = '0', vc_tnblx = '1', vc_bgkzt = '0', vc_cfzt = '3', dt_sfsj = add_months(sysdate,-11) where vc_bgkid in ('2c90ee26699f5d6001699f64d2470003','6E69C432D3B050E6E05010AC296E5189');

-- ������Գ�������
   /*update zjjk_xnxg_bgk set VC_SFCF = '2', VC_KZT = '0', VC_SDQRZT = '1', VC_SHBZ = '3', vc_czhks = '0', vc_gldwdm = '331002009' where vc_bgkid in ('6CFE6F6F68489936E05010AC296E74BA','88EEC967258C0036E05010AC296E086F');
   delete from zjjk_xnxg_cfk where vc_bgkid in ('6CFE6F6F68489936E05010AC296E74BA','88EEC967258C0036E05010AC296E086F');*/
   
-- ���������������
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

-- ��������
select object_name, machine, s.sid, s.serial#
  from v$locked_object l, dba_objects o, v$session s
 where l.object_id�� = ��o.object_id
   and l.session_id = s.sid;
alter system kill session 'SID,serial#';
-- �� alter system kill session '81,38364';
--------------------- 


-- �����д�����̻��߰��ͺ����ȣ��в����ַ�
select t.* from all_source t where 1=1
--  and  type = 'PACKAGE' 
and text like '%ZJJK_DATAEX_VALIDATE%'

-- ����У����� --
procedures
		Tnb_ExValidate
		zl_ExValidate
packages
		ZJJK_DATAEX_VALIDATE_NEW
    
-- ҵ�������־
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

select * from sqldy where mkbh='020305' and ywdm= '01' for update -- ���� ����ȷ��
select * from sqldy where mkbh='020202' and ywdm='1' for update   -- ���� ����ȷ��
select * from sqldy where mkbh='020405' and ywdm='1' for update  -- ���� ����ȷ��
select * from sqldy where mkbh='020502' and ywdm='1' for update  -- ���� ����ȷ�� ��ѯ�͵���
select * from sqldy where mkbh='020602' and ywdm='1' for update    -- ���� ����ȷ�� ��ѯ
select * from sqldy where mkbh='020602' and ywdm='2' for update    -- ���� ����ȷ�� ����

-- ���ݣ��ٰ�����ɽ���ֵ� ��������ҽԺ
select count(1), wm_concat(code) from organ_node where removed = '0' and description like '%33018503%'
select dm , mc from p_yljg where xzqh in ('33018503','33018568','33018569','33011450')
