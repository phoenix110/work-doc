-- ���е�sql��䣬Ҫ���������޸ģ��ֶ������ݿ�
select * from sqldy where rownum < 2;
-- �洢���̣����� GCMC ����.������
select * from prody where rownum < 2;
-- ϵͳ��־���洢����ִ�еļ�¼
SELECT * FROM TB_LOG where rownum < 2;
-- ҵ����־
SELECT * FROM ZJJK_YW_LOG where rownum < 2;
SELECT * FROM zjjk_yw_log_bgjl where bgkid = '33118100220190075' 

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


-- ������򲡳�������
-- update zjjk_tnb_bgk set vc_scbz = '0', vc_bgkzt = '0', vc_sdqrzt = '1', vc_cfzt = '0', vc_gldw = '331002009' where vc_bgkid = '6E69C432D3B050E6E05010AC296E5189'

-- �������������� VC_GLDW = '331002'Ϊ���ؼ����
-- update zjjk_tnb_bgk set vc_gldw = '331002', vc_sdqrzt = '1', vc_shbz = '3', vc_scbz = '0', vc_tnblx = '1', vc_bgkzt = '0', vc_cfzt = '3', dt_sfsj = add_months(sysdate,-11) where vc_bgkid in ('2c90ee26699f5d6001699f64d2470003','6E69C432D3B050E6E05010AC296E5189');

-- ���������������
-- update zjjk_zl_bgk set VC_SFCF = '2', VC_BGKZT = '0', VC_SDQRZT = '1', VC_SHBZ = '3', VC_SCBZ = '0',VC_GLDW = '331002009' where vc_bgkid = '19100200900009'

-- �������������� VC_GLDW = '331002'Ϊ���ؼ����
-- update zjjk_zl_bgk set NB_KSPF = 40, DT_SFSJ = add_months(sysdate, -2) where VC_BGKID in ('ex1800000003696','ex1800000003697','ex1800000003698')��
-- update zjjk_zl_bgk set VC_GLDW = '331002', vc_sdqrzt = '1', vc_sfcf = '3', dt_swrq = null, vc_swyy = null, vc_shbz = '3', vc_bgkzt = '0',NB_KSPF = 40, DT_SFSJ = add_months(sysdate, -2),dt_sfrq = add_months(sysdate, -2) where VC_BGKID in ('ex1800000003696','ex1800000003697','ex1800000003698');
 
-- ������Գ�������
   /*update zjjk_xnxg_bgk set VC_SFCF = '2', VC_KZT = '0', VC_SDQRZT = '1', VC_SHBZ = '3', vc_czhks = '0', vc_gldwdm = '331002009' where vc_bgkid in ('6CFE6F6F68489936E05010AC296E74BA','88EEC967258C0036E05010AC296E086F');
   delete from zjjk_xnxg_cfk where vc_bgkid in ('6CFE6F6F68489936E05010AC296E74BA','88EEC967258C0036E05010AC296E086F');*/
   
-- ��������������
/* update zjjk_xnxg_bgk set VC_SFCF = '1', VC_KZT = '0', VC_SDQRZT = '1', VC_SHBZ = '3', vc_czhks = '0', vc_gldwdm = '331002009', dt_sfsj = add_months(sysdate,-11)  where vc_bgkid in ('6CFE6F6F68529936E05010AC296E74BA','6CFE6F6F68529936E05010AC296E74BA');
delete from zjjk_xnxg_cfk where vc_bgkid in ('6CFE6F6F68529936E05010AC296E74BA','6CFE6F6F68529936E05010AC296E74BA'); */


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

-- excel����У����� --
--��������ݴ浽��Ӧ��_ex����job�еĶ�ʱ�����_ex���е����ݣ��浽��Ӧ��ʵ�ʱ��_bak���У��ٰ�_ex��������ɾ����
--ֻ����ʽ������job���ܣ����Ժͱ�����û�С�
procedures
		Tnb_ExValidate  -- job 22
		zl_ExValidate   -- job21
packages
		ZJJK_DATAEX_VALIDATE_NEW -- job 23
    


-- ���ݣ��ٰ�����ɽ���ֵ� ��������ҽԺ
select count(1), wm_concat(code) from organ_node where removed = '0' and description like '%33018503%'
select dm , mc from p_yljg where xzqh in ('33018503','33018568','33018569','33011450')
