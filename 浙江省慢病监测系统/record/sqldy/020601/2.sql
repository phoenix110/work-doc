select icd10_code,
       icd10_name,
       ccd_code,
       ccd_name,
       ccd_parent,
       total,
       rn
  from (select icd10_code,
               icd10_name,
               ccd_code,
               ccd_name,
               ccd_parent,
               total,
               rownum as rn
          from (select icd.icd10_code,
                       icd.icd10_name,
                       icd.ccd_code,
                       icd.ccd_name,
                       icd.ccd_parent,
                       count(1) over() as total
                  from T_ICD10 icd
                 where icd.icd10_code like upper('%' || #{keyword} || '%')
                 order by icd.icd10_code)
         where rownum <= #{rn_e})
 where rn >= #{rn_s}