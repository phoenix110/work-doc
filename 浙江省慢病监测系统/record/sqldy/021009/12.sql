WITH zjjk_mb_zlfh_zl AS
 (SELECT id,
         sfczbdcxgbazl,
         xmxg,
         xbxg,
         sfzhxg,
         csrqxg,
         zdrqxg,
         zdyjxg,
         icd10xg
    FROM zjjk_mb_zlfh_fa
  UNION ALL
  SELECT id,
         sfczbdcxgbazl,
         xmxg,
         xbxg,
         sfzhxg,
         csrqxg,
         zdrqxg,
         zdyjxg,
         icd10xg
    FROM zjjk_mb_zlfh_ga
  UNION ALL
  SELECT id,
         sfczbdcxgbazl,
         xmxg,
         xbxg,
         sfzhxg,
         csrqxg,
         zdrqxg,
         zdyjxg,
         icd10xg
    FROM zjjk_mb_zlfh_wa
  UNION ALL
  SELECT id,
         sfczbdcxgbazl,
         xmxg,
         xbxg,
         sfzhxg,
         csrqxg,
         zdrqxg,
         zdyjxg,
         icd10xg
    FROM zjjk_mb_zlfh_sga
  UNION ALL
  SELECT id,
         sfczbdcxgbazl,
         xmxg,
         xbxg,
         sfzhxg,
         csrqxg,
         zdrqxg,
         zdyjxg,
         icd10xg
    FROM zjjk_mb_zlfh_jzca
  UNION ALL
  SELECT id,
         sfczbdcxgbazl,
         xmxg,
         xbxg,
         sfzhxg,
         csrqxg,
         zdrqxg,
         zdyjxg,
         icd10xg
    FROM zjjk_mb_zlfh_nxrxa
  UNION ALL
  SELECT id,
         sfczbdcxgbazl,
         xmxg,
         xbxg,
         sfzhxg,
         csrqxg,
         zdrqxg,
         zdyjxg,
         icd10xg
    FROM zjjk_mb_zlfh_qtexzl)
SELECT xz.mc yymc,
       COUNT(zl.id) fhbls,
       SUM(decode(zl.sfczbdcxgbazl, '0', nvl2(zl.id, 1, 0), 0)) dcbazldbls,
       SUM(nvl2(zl.xmxg, 0, nvl2(zl.id, 1, 0))) xmfhs,
       SUM(nvl2(zl.xbxg, 0, nvl2(zl.id, 1, 0))) xbfhs,
       SUM(nvl2(zl.sfzhxg, 0, nvl2(zl.id, 1, 0))) sfzhfhs,
       SUM(nvl2(zl.csrqxg, 0, nvl2(zl.id, 1, 0))) csrqfhs,
       SUM((CASE
             WHEN zl.xmxg IS NULL AND zl.xbxg IS NULL AND zl.sfzhxg IS NULL AND
                  zl.csrqxg IS NULL THEN
              nvl2(zl.id, 1, 0)
             ELSE
              0
           END)) jbxxfhs,
       SUM(nvl2(zl.zdrqxg, 0, nvl2(zl.id, 1, 0))) qzfbrqfhs,
       SUM(nvl2(zl.zdyjxg, 0, nvl2(zl.id, 1, 0))) zdyjfhs,
       SUM(nvl2(zl.icd10xg, 0, nvl2(zl.id, 1, 0))) jbzdfhs,
       SUM((CASE
             WHEN zl.zdrqxg IS NULL AND zl.zdyjxg IS NULL AND
                  zl.icd10xg IS NULL THEN
              nvl2(zl.id, 1, 0)
             ELSE
              0
           END)) zdxxfhs,
       SUM(nvl2(zl.icd10xg, 0, nvl2(zl.id, 1, 0))) zlfhs,
       SUM(nvl2(zl.icd10xg, 0, nvl2(zl.id, 1, 0))) zlfhl
  FROM p_xzdm xz
  LEFT JOIN zjjk_mb_zlfh fh
    ON xz.dm LIKE substr(fh.bccjgid, 0, 4) || '%'
   AND fh.zt = '1'
   AND fh.fhbz = '1'
   AND fh.fhzt >= 3
   AND fh.mblx = '4'
   AND fh.bccjgid LIKE #{bgdw} || '%'
   AND fh.fhsj <= to_date(#{tjnf} || '-12-31', 'yyyy-mm-dd')
   AND fh.fhsj >= to_date(#{tjnf} || '-01-01', 'yyyy-mm-dd')
  LEFT JOIN zjjk_mb_zlfh_zl zl
    ON fh.id = zl.id
 WHERE xz.jb = 2
   AND xz.sjid = '33000000'
 GROUP BY xz.mc