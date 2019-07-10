SELECT a.dm code,
       a.dm || '  ' || a.mc NAME,
       a.fldm diccode,
       (SELECT b.icd9
          FROM t_jcxxgl_icdo109 b
         WHERE a.dm = b.icd10
           AND b.icd9 != 'NC'
           AND rownum = 1) icd9
  FROM p_tyzdml a
 WHERE a.fldm = 'C_ZL_JCZDBW'
 ORDER BY a.dm