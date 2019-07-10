SELECT xz.mc yymc,
       COUNT(fh.id) fhbls,
       COUNT(mb.id) hsddbls,
       SUM(decode(mb.fhfs, '1', 1, 0)) dh,
       SUM(decode(mb.fhfs, '2', 1, 0)) rh,
       SUM(decode(mb.fhfs, '3', 1, 0)) qt,
       SUM(nvl2(mb.hzxmxg, 0, nvl2(mb.id, 1, 0))) xmfhs,
       SUM(nvl2(mb.lxdhxg, 0, nvl2(mb.id, 1, 0))) lxdhfhs,
       SUM(nvl2(mb.hjdzxg, 0, nvl2(mb.id, 1, 0))) hjdzfhs,
       SUM((CASE
             WHEN mb.hzxmxg IS NULL AND mb.lxdhxg IS NULL AND mb.hjdzxg IS NULL THEN
              nvl2(mb.id, 1, 0)
             ELSE
              0
           END)) jbxxfhs,       
       SUM(nvl2(mb.scztxg, 0, nvl2(mb.id, 1, 0))) scztfhs,
       SUM(nvl2(mb.swrqxg, 0, nvl2(mb.id, 1, 0))) swrqfhs,
       SUM(nvl2(mb.gbsyxg, 0, nvl2(mb.id, 1, 0))) swyyfhs,
       SUM((CASE
             WHEN mb.scztxg IS NULL AND mb.swrqxg IS NULL AND mb.gbsyxg IS NULL THEN
              nvl2(mb.id, 1, 0)
             ELSE
              0
           END)) scztzfhs,      
       SUM((CASE
             WHEN  mb.hzxmxg IS NULL AND mb.lxdhxg IS NULL AND mb.hjdzxg IS NULL AND
                  mb.scztxg IS NULL AND mb.swrqxg IS NULL AND mb.gbsyxg IS NULL THEN
              nvl2(mb.id, 1, 0)
             ELSE
              0
           END)) zfhs
  FROM p_xzdm xz
  LEFT JOIN zjjk_csf_zlfh fh
    ON xz.dm LIKE substr(fh.bccjgid, 0, 6) || '%'
   AND fh.zt = '1'
   AND fh.fhbz = '1'
   AND fh.bllx = #{mblx}
   AND fh.csflx = '2'
   AND fh.bccjgid LIKE #{bgdw} || '%'
   AND fh.ccsj <= to_date(#{tjnf} || '-12-31', 'yyyy-mm-dd')
   AND fh.ccsj >= to_date(#{tjnf} || '-01-01', 'yyyy-mm-dd')
  LEFT JOIN zjjk_sf_zlfh_mxbjc mb
    ON fh.id = mb.id
 WHERE xz.jb = 3
   AND xz.sjid = #{vc_bks}
 GROUP BY xz.mc