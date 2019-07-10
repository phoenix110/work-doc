SELECT xz.mc yymc,
       COUNT(fh.id) fhbls,
       COUNT(sw.id) hsddbls,
       SUM(decode(sw.fhfs, '1', 1, 0)) dh,
       SUM(decode(sw.fhfs, '2', 1, 0)) rh,
       SUM(decode(sw.fhfs, '3', 1, 0)) qt,
       SUM(nvl2(sw.szxmxg, 0, nvl2(sw.id, 1, 0))) xmfhs,
       SUM(nvl2(sw.xbxg, 0, nvl2(sw.id, 1, 0))) xbfhs,
       SUM(nvl2(sw.sfzhxg, 0, nvl2(sw.id, 1, 0))) sfzhfhs,
       SUM(nvl2(sw.hjdzxg, 0, nvl2(sw.id, 1, 0))) hjdzfhs,
       SUM((CASE
             WHEN sw.szxmxg IS NULL AND sw.xbxg IS NULL AND sw.sfzhxg IS NULL AND
                  sw.hjdzxg IS NULL THEN
              nvl2(sw.id, 1, 0)
             ELSE
              0
           END)) jbxxfhs,
       SUM(nvl2(sw.swrqxg, 0, nvl2(sw.id, 1, 0))) swrqfhs,
       SUM(nvl2(sw.gbsyxg, 0, nvl2(sw.id, 1, 0))) gbsyfhs,
       SUM((CASE
             WHEN sw.swrqxg IS NULL AND sw.gbsyxg IS NULL THEN
              nvl2(sw.id, 1, 0)
             ELSE
              0
           END)) swqkfhs
  FROM p_xzdm xz
  LEFT JOIN zjjk_csf_zlfh fh
    ON xz.dm LIKE substr(fh.bccjgid, 0, 6) || '%'
   AND fh.zt = '1'
   AND fh.fhbz = '1'
   AND fh.bllx = '5'
   AND fh.csflx = '1'
   AND fh.bccjgid LIKE #{bgdw} || '%'
   AND fh.ccsj <= to_date(#{tjnf} || '-12-31', 'yyyy-mm-dd')
   AND fh.ccsj >= to_date(#{tjnf} || '-01-01', 'yyyy-mm-dd')
  LEFT JOIN zjjk_cf_zlfh_swga sw
    ON fh.id = sw.id
 WHERE xz.jb = 3
   AND xz.sjid = #{vc_bks}
 GROUP BY xz.mc