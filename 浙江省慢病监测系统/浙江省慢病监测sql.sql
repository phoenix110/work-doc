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

-- cdc���ݽ��� zjjkjk ��־��ѯ 
select * from area_upload_log;
select * from zjsjk_ws_config;

select log.* from area_upload_log log, zjsjk_ws_config confwhere 
log.aera = conf.areacode
and conf.areaname = '����'

select log.*, bgk.* from area_upload_log log, zjsjk_ws_config conf, ZJJK_ZL_BGK bgk, ZJJK_ZL_HZXX hzxx where 
log.aera = conf.areacode
and log.operation_id = bgk.VC_BGKID
and BGK.VC_HZID = HZXX.VC_PERSONID
and conf.areaname = '����'
and hzxx.vc_sfzh like '%33072519360804%'

-- ���ݽ��� ���˱�VC_SCBZ 1���ճɹ���δ�ش����˽����2��ʾ�ѻش����˽�������У� vc_dzjg 1��ʾ�ɹ���
select * from zjjk_dz;

-- ��ѯ�û���Ϣ
select a.*, b.* from xtyh a, p_ryxx b where a.ryid = b.id
select * from p_xzdm -- ��������

-- ���濨״̬;0.���ÿ���2.������3.���￨��4.�ظ�����5.ɾ������6.ʧ�ÿ���7.������
-- zjjk_zl_bgk.vc_sfcf 1Ϊ���ã�3Ϊ��ã�2Ϊδ���ã�0Ϊ�쳣����
-- v_czyjgjb �������� 1��ʡ��2�У�3����4ҽԺ����

-- �Լ��������������� VC_GLDW = '331002'Ϊ���ؼ����
-- update zjjk_zl_bgk set NB_KSPF = 40, DT_SFSJ = add_months(sysdate, -2) where VC_BGKID in ('ex1800000003696','ex1800000003697','ex1800000003698')��
-- update zjjk_zl_bgk set VC_GLDW = '331002', vc_sdqrzt = '1', vc_sfcf = '3', dt_swrq = null, vc_swyy = null, vc_shbz = '3', vc_bgkzt = '0',NB_KSPF = 40, DT_SFSJ = add_months(sysdate, -2),dt_sfrq = add_months(sysdate, -2) where VC_BGKID in ('ex1800000003696','ex1800000003697','ex1800000003698');
 
-- �Լ�������򲡳�������
-- update zjjk_tnb_bgk set vc_scbz = '0', vc_bgkzt = '0', vc_sdqrzt = '1', vc_cfzt = '0', vc_gldw = '331002009' where vc_bgkid = '702916FF01546408E05010AC296E1C6D'

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



