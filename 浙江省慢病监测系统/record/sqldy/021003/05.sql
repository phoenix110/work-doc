SELECT mblx, COUNT(1) COUNT
  FROM zjjk_mb_zlfh
 WHERE (fhzt = '5' OR fhzt = '6')
   AND zt = '1'
   AND cctjid = #{ccsjd}
   AND ccjgid LIKE #{vc_bkqx} || '%'
 GROUP BY mblx