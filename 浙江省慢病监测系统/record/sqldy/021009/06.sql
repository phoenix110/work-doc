SELECT xz.mc yymc,
       COUNT(gxb.id) fhbls,
       SUM(decode(gxb.sfczbdcxgbazl, '0', nvl2(gxb.id, 1, 0), 0)) dcbazldbls,
       SUM(nvl2(gxb.xmxg, 0, nvl2(gxb.id, 1, 0))) xmfhs,
       SUM(nvl2(gxb.xbxg, 0, nvl2(gxb.id, 1, 0))) xbfhs,
       SUM(nvl2(gxb.sfzhxg, 0, nvl2(gxb.id, 1, 0))) sfzhfhs,
       SUM(nvl2(gxb.csrqxg, 0, nvl2(gxb.id, 1, 0))) csrqfhs,
       SUM((CASE
             WHEN gxb.xmxg IS NULL AND gxb.xbxg IS NULL AND gxb.sfzhxg IS NULL AND
                  gxb.csrqxg IS NULL THEN
              nvl2(gxb.id, 1, 0)
             ELSE
              0
           END)) jbxxfhs,
       SUM(nvl2(gxb.zdrqxg, 0, nvl2(gxb.id, 1, 0))) qzfbrqfhs,
       SUM(nvl2(gxb.zdyjxg, 0, nvl2(gxb.id, 1, 0))) zdyjfhs,
       SUM(nvl2(gxb.icd10xg, 0, nvl2(gxb.id, 1, 0))) jbzdfhs,
       SUM((CASE
             WHEN gxb.zdrqxg IS NULL AND gxb.zdyjxg IS NULL AND
                  gxb.icd10xg IS NULL THEN
              nvl2(gxb.id, 1, 0)
             ELSE
              0
           END)) zdxxfhs,
       0 zlfhs,
       '0' zlfhl
  FROM p_xzdm xz
  LEFT JOIN zjjk_mb_zlfh fh
    ON xz.dm LIKE substr(fh.bccjgid, 0, 6) || '%'
   AND fh.zt = '1'
   AND fh.fhbz = '1'
   AND fh.fhzt >= 3
   AND fh.mblx = '2'
   AND fh.bccjgid LIKE #{bgdw} || '%'
   AND fh.fhsj <= to_date(#{tjnf} || '-12-31', 'yyyy-mm-dd')
   AND fh.fhsj >= to_date(#{tjnf} || '-01-01', 'yyyy-mm-dd')
  LEFT JOIN zjjk_mb_zlfh_gxb gxb
    ON fh.id = gxb.id
 WHERE xz.jb = 3
   AND xz.sjid = #{vc_bks}
 GROUP BY xz.mc