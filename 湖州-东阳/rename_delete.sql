-- 名称更改 T_ICD10
update T_ICD10 set type_name = '病原学阳性', CRB_CODEINFO = '376' where (card_type != '99' or card_type is null) and CRB_CODEINFO = '130';
update T_ICD10 set type_name = '病原学阴性', CRB_CODEINFO = '377' where (card_type != '99' or card_type is null) and CRB_CODEINFO = '131';
update T_ICD10 set type_name = '无病原学结果', CRB_CODEINFO = '378' where (card_type != '99' or card_type is null) and CRB_CODEINFO = '132';

-- 名称更改 T_ICD10_JCJB
update T_ICD10_JCJB set type_name = '病原学阳性', province_code = '376' where province_code = '130';
update T_ICD10_JCJB set type_name = '病原学阴性', province_code = '377' where province_code = '131';
update T_ICD10_JCJB set type_name = '无病原学结果', province_code = '378' where province_code = '132';

-- 名称更改 TB_DIC_JBBZ
update TB_DIC_JBBZ set DMXMC = '病原学阳性', BZID = '376' where BZID = '130';
update TB_DIC_JBBZ set DMXMC = '病原学阴性', BZID = '377' where BZID = '131';
update TB_DIC_JBBZ set DMXMC = '无病原学结果', BZID = '378' where BZID = '132';

-- 名称更改 CK_RULE
update CK_RULE set JBMC = '病原学阳性', JBBM = '376' where JBBM = '130';
update CK_RULE set JBMC = '病原学阴性', JBBM = '377' where JBBM = '131';
update CK_RULE set JBMC = '无病原学结果', JBBM = '378' where JBBM = '132';

-- 编码删除
update T_ICD10 set TYPE_SFTK = '0' where (card_type != '99' or card_type is null) and CRB_CODEINFO = '134';
update T_ICD10 set TYPE_SFTK = '0' where (card_type != '99' or card_type is null) and CRB_CODEINFO = '197';
