-- 名称更改
update T_ICD10 set ICD10_NAME = '病原学阳性' where ICD10_CODE = 'A15.000';
update T_ICD10 set ICD10_NAME = '病原学阴性' where ICD10_CODE = 'A16.000';
update T_ICD10 set ICD10_NAME = '无病原学结果' where ICD10_CODE = 'A16.100';
-- 编码删除
update T_ICD10 set TYPE_SFTK = '0' where ICD10_CODE in ('A15.100', 'A15.600');
