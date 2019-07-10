SELECT csflx, bllx, COUNT(1) COUNT
  FROM zjjk_csf_zlfh
 WHERE (fhzt = '5' OR fhzt = '6')
   AND zt = '1'
   AND ((csflx='1' AND cctjid = #{cfccsjd}) OR (csflx='2' AND cctjid = #{sfccsjd}))
   AND ccjgid LIKE #{vc_bkqx} || '%'
 GROUP BY csflx, bllx