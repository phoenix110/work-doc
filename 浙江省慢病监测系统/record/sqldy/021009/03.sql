SELECT jg.mc yymc,
       '-' yydj,
       COUNT(tnb.id) fhbls,
       SUM(decode(tnb.sfczbdcxgbazl, '0', nvl2(tnb.id, 1, 0), 0)) dcbazldbls,
       SUM(nvl2(tnb.xmxg, 0, nvl2(tnb.id, 1, 0))) xmfhs,
       SUM(nvl2(tnb.xbxg, 0, nvl2(tnb.id, 1, 0))) xbfhs,
       SUM(nvl2(tnb.sfzhxg, 0, nvl2(tnb.id, 1, 0))) sfzhfhs,
       SUM(nvl2(tnb.csrqxg, 0, nvl2(tnb.id, 1, 0))) csrqfhs,
       SUM((CASE
             WHEN tnb.xmxg IS NULL AND tnb.xbxg IS NULL AND tnb.sfzhxg IS NULL AND
                  tnb.csrqxg IS NULL THEN
              nvl2(tnb.id, 1, 0)
             ELSE
              0
           END)) jbxxfhs,
       SUM(nvl2(tnb.zdrqxg, 0, nvl2(tnb.id, 1, 0))) qzfbrqfhs,
       SUM(nvl2(tnb.zdyjxg, 0, nvl2(tnb.id, 1, 0))) zdyjfhs,
       SUM(nvl2(tnb.icd10xg, 0, nvl2(tnb.id, 1, 0))) jbzdfhs,
       SUM((CASE
             WHEN tnb.zdrqxg IS NULL AND tnb.zdyjxg IS NULL AND
                  tnb.icd10xg IS NULL THEN
              nvl2(tnb.id, 1, 0)
             ELSE
              0
           END)) zdxxfhs,
       0 zlfhs,
       '0' zlfhl
  FROM p_yljg jg
  LEFT JOIN zjjk_mb_zlfh fh
    ON jg.dm = fh.bccjgid
   AND fh.zt = '1'
   AND fh.fhbz = '1'
   AND fh.fhzt >= 3
   AND fh.mblx = '3'
   AND fh.bccjgid LIKE #{bgdw} || '%'
   AND fh.fhsj <= to_date(#{tjnf} || '-12-31', 'yyyy-mm-dd')
   AND fh.fhsj >= to_date(#{tjnf} || '-01-01', 'yyyy-mm-dd')
  LEFT JOIN zjjk_mb_zlfh_tnb tnb
    ON fh.id = tnb.id
 WHERE jg.dm LIKE #{bgdw} || '%'
   AND EXISTS (SELECT 1
         FROM p_yljgjb b
        WHERE jg.dm = b.jgdm
          AND jbgjb IN ('县级','地市级','省级'))
 GROUP BY jg.mc       