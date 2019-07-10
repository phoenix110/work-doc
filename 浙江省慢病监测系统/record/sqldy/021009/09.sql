SELECT xz.mc yymc,
       COUNT(ncz.id) fhbls,
       SUM(decode(ncz.sfczbdcxgbazl, '0', nvl2(ncz.id, 1, 0), 0)) dcbazldbls,
       SUM(nvl2(ncz.xmxg, 0, nvl2(ncz.id, 1, 0))) xmfhs,
       SUM(nvl2(ncz.xbxg, 0, nvl2(ncz.id, 1, 0))) xbfhs,
       SUM(nvl2(ncz.sfzhxg, 0, nvl2(ncz.id, 1, 0))) sfzhfhs,
       SUM(nvl2(ncz.csrqxg, 0, nvl2(ncz.id, 1, 0))) csrqfhs,
       SUM((CASE
             WHEN ncz.xmxg IS NULL AND ncz.xbxg IS NULL AND ncz.sfzhxg IS NULL AND
                  ncz.csrqxg IS NULL THEN
              nvl2(ncz.id, 1, 0)
             ELSE
              0
           END)) jbxxfhs,
       SUM(nvl2(ncz.zdrqxg, 0, nvl2(ncz.id, 1, 0))) qzfbrqfhs,
       SUM(nvl2(ncz.zdyjxg, 0, nvl2(ncz.id, 1, 0))) zdyjfhs,
       SUM(nvl2(ncz.icd10xg, 0, nvl2(ncz.id, 1, 0))) jbzdfhs,
       SUM((CASE
             WHEN ncz.zdrqxg IS NULL AND ncz.zdyjxg IS NULL AND
                  ncz.icd10xg IS NULL THEN
              nvl2(ncz.id, 1, 0)
             ELSE
              0
           END)) zdxxfhs,
       0 zlfhs,
       '0' zlfhl
  FROM p_xzdm xz
  LEFT JOIN zjjk_mb_zlfh fh
    ON xz.dm LIKE substr(fh.bccjgid, 0, 4) || '%'
   AND fh.zt = '1'
   AND fh.fhbz = '1'
   AND fh.fhzt >= 3
   AND fh.mblx = '1'
   AND fh.bccjgid LIKE #{bgdw} || '%'
   AND fh.fhsj <= to_date(#{tjnf} || '-12-31', 'yyyy-mm-dd')
   AND fh.fhsj >= to_date(#{tjnf} || '-01-01', 'yyyy-mm-dd')
  LEFT JOIN zjjk_mb_zlfh_ncz ncz
    ON fh.id = ncz.id
 WHERE xz.jb = 2
   AND xz.sjid = '33000000'
 GROUP BY xz.mc