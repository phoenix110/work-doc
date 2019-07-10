WITH bgk AS
 (SELECT VC_BKDWYY,
         COUNT(1) bgs,
         SUM(CASE
               WHEN to_number(bgk.dt_qxshsj - bgk.dt_yyshsj) <= 7 THEN
                1
               ELSE
                0
             END) shjss,
						  
         SUM(nvl2(bgk.vc_hzsfzh, 1, 0)) sfztbs
    FROM zjjk_xnxg_bgk bgk
   WHERE bgk.vc_scbz = '2'
     AND bgk.vc_kzt IN ('0', '5', '7')
     AND bgk.vc_gxbzd IS NULL
		  <if if("Y".equals(#{bblx}))>
		     and to_char(bgk.DT_CJSJ,'YYYY') = #{bbqh}
		  </if>
			<if if("Q".equals(#{bblx}))>
		     and to_char(bgk.DT_CJSJ,'YYYYQ') = #{bbqh}
		  </if>
			<if if("M".equals(#{bblx}))>
		     and to_char(bgk.DT_CJSJ,'YYYYMM') = #{bbqh}
		  </if>
			<if if(StringUtils.isNotBlank(#{vc_jkdw}))>
						 and bgk.VC_BKDWYY = #{vc_jkdw}
					 </if>
			<if if(1 == 1)>
   GROUP BY bgk.VC_BKDWYY),
cf AS
 (SELECT VC_BKDWYY cfsi,
         SUM(nvl2(dt_qxshsj, '1', '0')) cfywcs,
         SUM(nvl2(dt_sfrq, '1', '0')) cfwcs,
         SUM(CASE
               WHEN to_number(dt_sfrq - dt_qxshsj) < 31 THEN
                1
               ELSE
                0
             END) cfjss
    FROM (SELECT bgk.VC_BKDWYY,
                 bgk.vc_gldwdm,
                 sfk.dt_sfrq,
                 bgk.dt_qxshsj,
                 row_number() over(PARTITION BY sfk.vc_bgkid ORDER BY sfk.dt_cjsj) rn
            FROM zjjk_xnxg_sfk sfk, zjjk_xnxg_bgk bgk
           WHERE sfk.vc_bgkid = bgk.vc_bgkid
             AND bgk.vc_scbz = '2'
             AND bgk.vc_kzt IN ('0', '5', '7')
             AND bgk.vc_gxbzd IS NULL
						 </if>
						  <if if("Y".equals(#{bblx}))>
								 and to_char(bgk.DT_CJSJ,'YYYY') = #{bbqh}
							</if>
							<if if("Q".equals(#{bblx}))>
								 and to_char(bgk.DT_CJSJ,'YYYYQ') = #{bbqh}
							</if>
							<if if("M".equals(#{bblx}))>
								 and to_char(bgk.DT_CJSJ,'YYYYMM') = #{bbqh}
							</if>
							<if if(StringUtils.isNotBlank(#{vc_jkdw}))>
						 and bgk.VC_BKDWYY = #{vc_jkdw}
					 </if>
							<if if(1 == 1)>
						 )
   WHERE rn = 1
   GROUP BY VC_BKDWYY),
sf AS
 (SELECT VC_BKDWYY sfsi,
         SUM(nvl2(dt_qxshsj, '1', '0')) sfywcs,
         SUM(nvl2(dt_sfrq, '1', '0')) sfwcs,
         SUM(CASE
               WHEN to_number(dt_sfrq - dt_qxshsj) < 31 THEN
                1
               ELSE
                0
             END) sfjss
    FROM (SELECT bgk.VC_BKDWYY,
                 bgk.vc_gldwdm,
                 sfk.dt_sfrq,
                 bgk.dt_qxshsj,
                 row_number() over(PARTITION BY sfk.vc_bgkid ORDER BY sfk.dt_cjsj) rn
            FROM zjjk_xnxg_sfk sfk, zjjk_xnxg_bgk bgk
           WHERE sfk.vc_bgkid = bgk.vc_bgkid
             AND bgk.vc_scbz = '2'
             AND bgk.vc_kzt IN ('0', '5', '7')
             AND bgk.vc_gxbzd IS NULL
						 </if>
						  <if if("Y".equals(#{bblx}))>
							 and to_char(bgk.DT_CJSJ,'YYYY') = #{bbqh}
						</if>
						<if if("Q".equals(#{bblx}))>
							 and to_char(bgk.DT_CJSJ,'YYYYQ') = #{bbqh}
						</if>
						<if if("M".equals(#{bblx}))>
							 and to_char(bgk.DT_CJSJ,'YYYYMM') = #{bbqh}
						</if>
						<if if(StringUtils.isNotBlank(#{vc_jkdw}))>
						 and bgk.VC_BKDWYY = #{vc_jkdw}
					 </if>
						<if if(1 == 1)>
						 )
   WHERE rn != 1
   GROUP BY VC_BKDWYY),

ck AS 
(SELECT VC_BKDWYY, SUM(counts) cks
  FROM (SELECT VC_BKDWYY, COUNT(1) counts
          FROM zjjk_xnxg_bgk bgk
         WHERE bgk.vc_scbz = '2'
           AND bgk.vc_kzt IN ('0', '5', '7')
           AND bgk.vc_gxbzd IS NULL
					 </if>
					 <if if("Y".equals(#{bblx}))>
							 and to_char(bgk.DT_CJSJ,'YYYY') = #{bbqh}
						</if>
						<if if("Q".equals(#{bblx}))>
							 and to_char(bgk.DT_CJSJ,'YYYYQ') = #{bbqh}
						</if>
						<if if("M".equals(#{bblx}))>
							 and to_char(bgk.DT_CJSJ,'YYYYMM') = #{bbqh}
						</if>
						<if if(StringUtils.isNotBlank(#{vc_jkdw}))>
						 and bgk.VC_BKDWYY = #{vc_jkdw}
					 </if>
						<if if(1 == 1)>
         GROUP BY bgk.VC_BKDWYY,
                  bgk.vc_hzxm,
                  bgk.vc_hzxb,
                  bgk.vc_hzsfzh,
                  bgk.dt_hzcsrq
        HAVING COUNT(1) > 1)
 GROUP BY VC_BKDWYY)
SELECT xz.dm,
       xz.mc dq,
       NVL(bgk.bgs,0) bgs,
     
       to_char(NVL(round(bgk.shjss * 100 / bgk.bgs, 4),0),'fm990.0000') || '%' shjsl,
       to_char(NVL(round(bgk.sfztbs * 100 / bgk.bgs, 4),0),'fm990.0000') || '%' sfztbb,
       to_char(NVL(round(ck.cks * 100 / bgk.bgs, 4),0),'fm990.0000') || '%' ckb,
       NVL(cf.cfywcs,0) cfywcs,
       NVL(cf.cfwcs,0) cfwcs,
       to_char(NVL(round(cf.cfywcs * 100 / cf.cfwcs, 24),0),'fm990.0000') || '%' cfwcl,
       NVL(cf.cfjss,0) cfjss,
       to_char(NVL(round(cf.cfjss * 100 / cf.cfwcs, 4),0),'fm990.0000') || '%' cfjsl,
       NVL(sf.sfywcs,0) sfywcs,
       NVL(sf.sfwcs,0) sfwcs,
       to_char(NVL(round(sf.sfywcs * 100 / sf.sfwcs, 4),0),'fm990.0000') || '%' sfwcl,
       NVL(sf.sfjss,0) sfjss,
       to_char(NVL(round(sf.sfjss * 100 / sf.sfwcs, 4),0),'fm990.0000') || '%' sfjsl
  FROM P_YLJG xz
  LEFT JOIN bgk
    ON xz.dm = bgk.VC_BKDWYY
  LEFT JOIN cf
    ON xz.dm = cf.cfsi
  LEFT JOIN sf
    ON xz.dm = sf.sfsi
  
  LEFT JOIN ck
    ON xz.dm = ck.VC_BKDWYY
 WHERE xz.xzqh = #{vc_qx}
 </if>
 <if if(StringUtils.isNotBlank(#{vc_jkdw}))>
	 and xz.dm = #{vc_jkdw}
 </if><if if(1 == 1)>
UNION ALL
SELECT '999999999' dm,
       '合计：' dq,
       NVL(sum(bgk.bgs),0) bgs,
       to_char(NVL(round(sum(bgk.shjss) * 100 / sum(bgk.bgs), 4),0),'fm990.0000') || '%' shjsl,
       to_char(NVL(round(sum(bgk.sfztbs) * 100 / sum(bgk.bgs), 4),0),'fm990.0000') || '%' sfztbb,
       to_char(NVL(round(sum(ck.cks) * 100 / sum(bgk.bgs), 4),0),'fm990.0000') || '%' ckb,
       NVL(sum(cf.cfywcs),0) cfywcs,
       NVL(sum(cf.cfwcs),0) cfwcs,
       to_char(NVL(round(sum(cf.cfywcs) * 100 / sum(cf.cfwcs), 24),0),'fm990.0000') || '%' cfwcl,
       NVL(sum(cf.cfjss),0) cfjss,
       to_char(NVL(round(sum(cf.cfjss) * 100 / sum(cf.cfwcs), 4),0),'fm990.0000') || '%' cfjsl,
       NVL(sum(sf.sfywcs),0) sfywcs,
       NVL(sum(sf.sfwcs),0) sfwcs,
       to_char(NVL(round(sum(sf.sfywcs) * 100 / sum(sf.sfwcs), 4),0),'fm990.0000') || '%' sfwcl,
       NVL(sum(sf.sfjss),0) sfjss,
       to_char(NVL(round(sum(sf.sfjss) * 100 / sum(sf.sfwcs), 4),0),'fm990.0000') || '%' sfjsl
  FROM P_YLJG xz
  LEFT JOIN bgk
    ON xz.dm = bgk.VC_BKDWYY
  LEFT JOIN cf
    ON xz.dm = cf.cfsi
  LEFT JOIN sf
    ON xz.dm = sf.sfsi
 
  LEFT JOIN ck
    ON xz.dm = ck.VC_BKDWYY
 WHERE xz.xzqh = #{vc_qx}
 </if>
 <if if(StringUtils.isNotBlank(#{vc_jkdw}))>
	 and xz.dm = #{vc_jkdw}
 </if>
 ORDER BY dm   
 
 
 
 