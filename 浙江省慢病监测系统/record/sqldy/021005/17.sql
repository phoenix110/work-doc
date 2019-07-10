SELECT a.dm code,
       a.mc name,
       a.fldm diccode
  FROM p_tyzdml a
 WHERE a.bz = 1
   AND a.fldm = 'C_ZLFH_BLLX'
   AND EXISTS
 (SELECT 1
          FROM zjjk_zlfhsj_sf fh
         WHERE fh.zt = '1'
           AND ',' || fh.ccbz || ',' LIKE '%,' || a.dm || ',%')