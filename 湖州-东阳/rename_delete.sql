-- ���Ƹ���
update T_ICD10 set ICD10_NAME = '��ԭѧ����' where ICD10_CODE = 'A15.000';
update T_ICD10 set ICD10_NAME = '��ԭѧ����' where ICD10_CODE = 'A16.000';
update T_ICD10 set ICD10_NAME = '�޲�ԭѧ���' where ICD10_CODE = 'A16.100';
-- ����ɾ��
update T_ICD10 set TYPE_SFTK = '0' where ICD10_CODE in ('A15.100', 'A15.600');
