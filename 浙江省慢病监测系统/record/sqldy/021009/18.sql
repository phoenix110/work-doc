SELECT xz.mc yymc,
       COUNT(fh.id) fhbls,
       COUNT(mb.id) hsddbls,
       SUM(decode(mb.fhfs, '1', 1, 0)) dh,
       SUM(decode(mb.fhfs, '2', 1, 0)) rh,
       SUM(decode(mb.fhfs, '3', 1, 0)) qt,
       SUM(nvl2(mb.hzxmxg, 0, nvl2(mb.id, 1, 0))) xmfhs,
       SUM(nvl2(mb.xbxg, 0, nvl2(mb.id, 1, 0))) xbfhs,
       SUM(nvl2(mb.sfzhxg, 0, nvl2(mb.id, 1, 0))) sfzhfhs,
       SUM(nvl2(mb.hjdzxg, 0, nvl2(mb.id, 1, 0))) hjdzfhs,
       SUM((CASE
             WHEN mb.hzxmxg IS NULL AND mb.xbxg IS NULL AND mb.sfzhxg IS NULL AND
                  mb.hjdzxg IS NULL THEN
              nvl2(mb.id, 1, 0)
             ELSE
              0
           END)) jbxxfhs,			 
			 SUM(nvl2(mb.zdmcxg, 0, nvl2(mb.id, 1, 0))) zdjbfhs,
       SUM(nvl2(mb.fbrqxg, 0, nvl2(mb.id, 1, 0))) qzfbrqfhs,
       SUM(nvl2(mb.zdyyxg, 0, nvl2(mb.id, 1, 0))) qzfbrqfhs,
       SUM((CASE
             WHEN mb.zdmcxg IS NULL AND mb.fbrqxg IS NULL AND mb.zdyyxg IS NULL THEN
              nvl2(mb.id, 1, 0)
             ELSE
              0
           END)) zdxxfhs,
       SUM(nvl2(mb.swrqxg, 0, nvl2(mb.id, 1, 0))) swrqfhs,
       SUM(nvl2(mb.gbsyxg, 0, nvl2(mb.id, 1, 0))) gbsyfhs,
       SUM((CASE
             WHEN mb.swrqxg IS NULL AND mb.gbsyxg IS NULL THEN
              nvl2(mb.id, 1, 0)
             ELSE
              0
           END)) swqkfhs
  FROM p_xzdm xz
  LEFT JOIN zjjk_csf_zlfh fh
    ON xz.dm LIKE substr(fh.bccjgid, 0, 6) || '%'
   AND fh.zt = '1'
   AND fh.fhbz = '1'
   AND fh.bllx != '5'
   AND fh.csflx = '1'
   AND fh.bccjgid LIKE #{bgdw} || '%'
   AND fh.ccsj <= to_date(#{tjnf} || '-12-31', 'yyyy-mm-dd')
   AND fh.ccsj >= to_date(#{tjnf} || '-01-01', 'yyyy-mm-dd')
  LEFT JOIN zjjk_cf_zlfh_mxbjc mb
    ON fh.id = mb.id
 WHERE xz.jb = 2
   AND xz.sjid = '33000000'
 GROUP BY xz.mc