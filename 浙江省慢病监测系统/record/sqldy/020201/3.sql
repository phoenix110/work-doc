select icd10_code code, icd10_code||'-'||icd10_name as name,icd10_code diccode
  from t_icd10
 where ccd_code = '40'
    or icd10_code = 'H28.0'
    or icd10_code = 'H28.0'
    or icd10_code = 'N08.3'
    or icd10_code like 'O24.%'
    or icd10_code = 'P70.2'
    order by icd10_code  