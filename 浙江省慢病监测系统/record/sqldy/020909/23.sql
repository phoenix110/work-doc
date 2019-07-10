WITH bgk AS
 (SELECT VC_BGDW,
         COUNT(1) bgs,
         SUM(CASE
               WHEN to_number(bgk.dt_qxshsj - bgk.dt_yyshsj) <= 7 THEN
                1
               ELSE
                0
             END) shjss,
						  SUM(CASE WHEN instr( bgk.vc_zdyh, '5')+instr( bgk.vc_zdyh, '6')+instr( bgk.vc_zdyh, '7')+instr( bgk.vc_zdyh, '8')  > 0 then 1 else 0 end ) kps,
				  SUM(nvl2(bgk.VC_BLH, 1, 0)) gfkps,
				sum(case when UPPER(SUBSTR(bgk.VC_ICD10, 0, 1)) = 'C' AND SUBSTR(bgk.VC_ICD10, 2, 2) IN ('26','39','48','76','77','78','79','80') then 1 else 0 end )  bmkps,
         SUM(nvl2(hzxx.vc_sfzh, 1, 0)) sfztbs
    FROM zjjk_zl_bgk bgk,zjjk_tnb_hzxx hzxx
   WHERE bgk.vc_hzid = hzxx.vc_personid AND bgk.vc_scbz = '2'
     AND bgk.VC_BGKZT IN ('0', '5', '7')
    
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
						 and bgk.VC_BGDW = #{vc_jkdw}
					 </if>
			<if if(1 == 1)>
   GROUP BY bgk.VC_BGDW),
cf AS
 (SELECT VC_BGDW cfsi,
         SUM(nvl2(dt_qxshsj, '1', '0')) cfywcs,
         SUM(nvl2(dt_sfrq, '1', '0')) cfwcs,
         SUM(CASE
               WHEN to_number(dt_sfrq - dt_qxshsj) < 31 THEN
                1
               ELSE
                0
             END) cfjss
    FROM (SELECT bgk.VC_BGDW,
                
                 sfk.dt_sfrq,
                 bgk.dt_qxshsj,
                 row_number() over(PARTITION BY sfk.vc_bgkid ORDER BY sfk.dt_cjsj) rn
            FROM zjjk_xnxg_sfk sfk, zjjk_zl_bgk bgk,zjjk_tnb_hzxx hzxx
           WHERE sfk.vc_bgkid = bgk.vc_bgkid
             AND bgk.vc_scbz = '2' AND bgk.vc_hzid = hzxx.vc_personid 
             AND bgk.VC_BGKZT IN ('0', '5', '7')
            
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
						 and bgk.VC_BGDW = #{vc_jkdw}
					 </if>
							<if if(1 == 1)>
						 )
   WHERE rn = 1
   GROUP BY VC_BGDW),
sf AS
 (SELECT VC_BGDW sfsi,
         SUM(nvl2(dt_qxshsj, '1', '0')) sfywcs,
         SUM(nvl2(dt_sfrq, '1', '0')) sfwcs,
         SUM(CASE
               WHEN to_number(dt_sfrq - dt_qxshsj) < 31 THEN
                1
               ELSE
                0
             END) sfjss
    FROM (SELECT bgk.VC_BGDW,
                
                 sfk.dt_sfrq,
                 bgk.dt_qxshsj,
                 row_number() over(PARTITION BY sfk.vc_bgkid ORDER BY sfk.dt_cjsj) rn
            FROM zjjk_xnxg_sfk sfk, zjjk_zl_bgk bgk,zjjk_tnb_hzxx hzxx
           WHERE sfk.vc_bgkid = bgk.vc_bgkid
             AND bgk.vc_scbz = '2' AND bgk.vc_hzid = hzxx.vc_personid 
             AND bgk.VC_BGKZT IN ('0', '5', '7')
            
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
						 and bgk.VC_BGDW = #{vc_jkdw}
					 </if>
						<if if(1 == 1)>
						 )
   WHERE rn != 1
   GROUP BY VC_BGDW),

ck AS 
(SELECT VC_BGDW, SUM(counts) cks
  FROM (SELECT VC_BGDW, COUNT(1) counts
          FROM zjjk_zl_bgk bgk,zjjk_tnb_hzxx hzxx
         WHERE bgk.vc_scbz = '2' AND bgk.vc_hzid = hzxx.vc_personid
           AND bgk.VC_BGKZT IN ('0', '5', '7')
          
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
						 and bgk.VC_BGDW = #{vc_jkdw}
					 </if>
						<if if(1 == 1)>
         GROUP BY bgk.VC_BGDW,
                  hzxx.VC_HZXM,
                  hzxx.vc_hzxb,
                  hzxx.vc_sfzh,
                  hzxx.dt_hzcsrq
        HAVING COUNT(1) > 1)
 GROUP BY VC_BGDW)
SELECT xz.dm,
       xz.mc dq,
       NVL(bgk.bgs,0) bgs,
      to_char(NVL(round(bgk.kps * 100 / bgk.bgs, 4),0),'fm990.0000') || '%' blzdbfb,
				to_char(NVL(round(bgk.gfkps * 100 / bgk.kps, 4),0),'fm990.0000') || '%' blzdtxl,
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
    ON xz.dm = bgk.VC_BGDW
  LEFT JOIN cf
    ON xz.dm = cf.cfsi
  LEFT JOIN sf
    ON xz.dm = sf.sfsi
  
  LEFT JOIN ck
    ON xz.dm = ck.VC_BGDW
 WHERE xz.xzqh = #{vc_qx}
 </if>
 <if if(StringUtils.isNotBlank(#{vc_jkdw}))>
	 and xz.dm = #{vc_jkdw}
 </if><if if(1 == 1)>
UNION ALL
SELECT '999999999' dm,
       '合计：' dq,
       NVL(sum(bgk.bgs),0) bgs,
			  to_char(NVL(round(SUM(bgk.kps) * 100 / SUM(bgk.bgs), 4),0),'fm990.0000') || '%' blzdbfb,
			 to_char(NVL(round(SUM(bgk.gfkps) * 100 / SUM(bgk.kps), 4),0),'fm990.0000') || '%' blzdtxl,
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
    ON xz.dm = bgk.VC_BGDW
  LEFT JOIN cf
    ON xz.dm = cf.cfsi
  LEFT JOIN sf
    ON xz.dm = sf.sfsi
 
  LEFT JOIN ck
    ON xz.dm = ck.VC_BGDW
 WHERE xz.xzqh = #{vc_qx}
 </if>
 <if if(StringUtils.isNotBlank(#{vc_jkdw}))>
	 and xz.dm = #{vc_jkdw}
 </if>
 ORDER BY dm   
 
 
 
 