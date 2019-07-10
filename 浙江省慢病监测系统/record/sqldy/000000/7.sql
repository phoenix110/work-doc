select icd10_code as code,icd10_code || ' = ' ||icd10_name as name,icd10_name 
from t_icd10 
where icd10_code like '%'||#{icd10}||'%'
     and (icd10_code like 'Y%' or icd10_code like 'V%' or icd10_code like 'W%' or icd10_code like 'X%')