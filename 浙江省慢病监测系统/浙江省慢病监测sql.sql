-- ���е�sql��䣬Ҫ���������޸ģ��ֶ������ݿ�
select * from sqldy where rownum < 2;

-- �洢���̣����� GCMC ����.������
select * from prody where rownum < 2;

-- ϵͳ��־���洢����ִ�еļ�¼
SELECT * FROM TB_LOG where rownum < 2;

-- ҵ����־
SELECT * FROM ZJJK_YW_LOG where rownum < 2;

select * from sqldy where mkbh = '020205';-- ���򲡳����
select * from sqldy where mkbh = '020302';-- ��������
select * from sqldy where mkbh = '020303'; -- �������
select * from sqldy where mkbh = '020601'; -- ����ͳ����������
select * from sqldy where mkbh = '020401'; -- ����Ѫ��
select * from sqldy where mkbh = '020301';-- �������濨
select * from sqldy where mkbh = '020201';    -- ���򲡱��濨


-- �Լ��������������� VC_GLDW = '331002'Ϊ���ؼ����
-- update zjjk_zl_bgk set NB_KSPF = 40, DT_SFSJ = add_months(sysdate, -2) where VC_BGKID in ('ex1800000003696','ex1800000003697','ex1800000003698')��
-- update zjjk_zl_bgk set VC_GLDW = '331002', vc_sdqrzt = '1', vc_sfcf = '3', dt_swrq = null, vc_swyy = null, vc_shbz = '3', vc_bgkzt = '0',NB_KSPF = 40, DT_SFSJ = add_months(sysdate, -2),dt_sfrq = add_months(sysdate, -2) where VC_BGKID in ('ex1800000003696','ex1800000003697','ex1800000003698');
 
-- �Լ��������������� VC_GLDW = '331002'Ϊ���ؼ����
-- update zjjk_tnb_bgk set vc_gldw = '331002', vc_sdqrzt = '1', vc_shbz = '3', vc_scbz = '0', vc_tnblx = '1', vc_bgkzt = '0', vc_cfzt = '3', dt_sfsj = add_months(sysdate,-11) where vc_bgkid in ('2c90ee26699f5d6001699f64d2470003','6E69C432D3B050E6E05010AC296E5189');

