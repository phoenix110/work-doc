WITH bgk AS
 (SELECT vc_hksdm,
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
         SUM(nvl2(hzxx.VC_SFZH, 1, 0)) sfztbs
    FROM zjjk_zl_bgk bgk,zjjk_zl_hzxx hzxx
   WHERE bgk.vc_hzid = hzxx.vc_personid AND  bgk.vc_scbz = '2'
     AND bgk.vc_bgkzt IN ('0', '5', '7')
    
		  <if if("Y".equals(#{bblx}))>
		     and to_char(bgk.DT_CJSJ,'YYYY') = #{bbqh}
		  </if>
			<if if("Q".equals(#{bblx}))>
		     and to_char(bgk.DT_CJSJ,'YYYYQ') = #{bbqh}
		  </if>
			<if if("M".equals(#{bblx}))>
		     and to_char(bgk.DT_CJSJ,'YYYYMM') = #{bbqh}
		  </if>
			<if if(1 == 1)>
   GROUP BY hzxx.vc_hksdm),
cf AS
 (SELECT vc_hksdm cfsi,
         SUM(nvl2(dt_qxshsj, '1', '0')) cfywcs,
         SUM(nvl2(dt_sfrq, '1', '0')) cfwcs,
         SUM(CASE
               WHEN to_number(dt_sfrq - dt_qxshsj) < 31 THEN
                1
               ELSE
                0
             END) cfjss
    FROM (SELECT hzxx.vc_hksdm,
                
                 sfk.dt_sfrq,
                 bgk.dt_qxshsj,
                 row_number() over(PARTITION BY sfk.vc_bgkid ORDER BY sfk.dt_cjsj) rn
            FROM zjjk_xnxg_sfk sfk, zjjk_zl_bgk bgk,zjjk_zl_hzxx hzxx
           WHERE sfk.vc_bgkid = bgk.vc_bgkid
						 AND bgk.vc_hzid = hzxx.vc_personid
             AND bgk.vc_scbz = '2'
             AND bgk.vc_bgkzt IN ('0', '5', '7')
            
						 </if>
						  <if if("Y".equals(#{bblx}))>
								 and to_char(bgk.DT_CJSJ,'YYYY') = #{bbqh}
							</if>
							<if if("Q".equals(#{bblx}))>
								 and to_char(bgk.DT_CJSJ,'YYYYQ') = #{bbqh}
							</if>
							<if if("M".equals(#{bblx}))>
								 and to_char(bgk.DT_CJSJ,'YYYYMM') = #{bbqh}
							</if><if if(1 == 1)>
						 )
   WHERE rn = 1
   GROUP BY vc_hksdm),
sf AS
 (SELECT vc_hksdm sfsi,
         SUM(nvl2(dt_qxshsj, '1', '0')) sfywcs,
         SUM(nvl2(dt_sfrq, '1', '0')) sfwcs,
         SUM(CASE
               WHEN to_number(dt_sfrq - dt_qxshsj) < 31 THEN
                1
               ELSE
                0
             END) sfjss
    FROM (SELECT hzxx.vc_hksdm,
                 
                 sfk.dt_sfrq,
                 bgk.dt_qxshsj,
                 row_number() over(PARTITION BY sfk.vc_bgkid ORDER BY sfk.dt_cjsj) rn
            FROM zjjk_xnxg_sfk sfk, zjjk_zl_bgk bgk,zjjk_zl_hzxx hzxx
           WHERE sfk.vc_bgkid = bgk.vc_bgkid
					  AND bgk.vc_hzid = hzxx.vc_personid
             AND bgk.vc_scbz = '2'
             AND bgk.vc_bgkzt IN ('0', '5', '7')
            
						 </if>
						  <if if("Y".equals(#{bblx}))>
							 and to_char(bgk.DT_CJSJ,'YYYY') = #{bbqh}
						</if>
						<if if("Q".equals(#{bblx}))>
							 and to_char(bgk.DT_CJSJ,'YYYYQ') = #{bbqh}
						</if>
						<if if("M".equals(#{bblx}))>
							 and to_char(bgk.DT_CJSJ,'YYYYMM') = #{bbqh}
						</if><if if(1 == 1)>
						 )
   WHERE rn != 1
   GROUP BY vc_hksdm),
rk AS
 (
	 SELECT VC_GAZHJ zrks,VC_RKGLS,p_xzdm.mc FROM zjmb_rkglb LEFT JOIN p_xzdm ON p_xzdm.dm = VC_RKGLS
where vc_lx = 6 
and VC_RKGLSF = '33000000' AND sjid = '33000000'
AND VC_NF = substr(#{bbqh},2,2)
AND VC_RKGLQ =  '99999999' AND VC_RKGLS != '99999999'
	 ),
ck AS 
(SELECT vc_hksdm, SUM(counts) cks
  FROM (SELECT vc_hksdm, COUNT(1) counts
          FROM zjjk_zl_bgk bgk,zjjk_zl_hzxx hzxx
         WHERE bgk.vc_hzid = hzxx.vc_personid AND  bgk.vc_scbz = '2'
           AND bgk.vc_bgkzt IN ('0', '5', '7')
          
					 </if>
					 <if if("Y".equals(#{bblx}))>
							 and to_char(bgk.DT_CJSJ,'YYYY') = #{bbqh}
						</if>
						<if if("Q".equals(#{bblx}))>
							 and to_char(bgk.DT_CJSJ,'YYYYQ') = #{bbqh}
						</if>
						<if if("M".equals(#{bblx}))>
							 and to_char(bgk.DT_CJSJ,'YYYYMM') = #{bbqh}
						</if><if if(1 == 1)>
         GROUP BY hzxx.vc_hksdm,
                  hzxx.vc_hzxm,
                 hzxx.vc_hzxb,
                  hzxx.vc_sfzh,
                  hzxx.dt_hzcsrq
        HAVING COUNT(1) > 1)
 GROUP BY vc_hksdm)
SELECT xz.dm,
       xz.mc dq,
       NVL(bgk.bgs,0) bgs,
			  to_char(NVL(round(bgk.kps * 100 / bgk.bgs, 4),0),'fm990.0000') || '%' blzdbfb,
				to_char(NVL(round(bgk.gfkps * 100 / bgk.kps, 4),0),'fm990.0000') || '%' blzdtxl,
				to_char(NVL(round(bgk.bmkps * 100 / bgk.bgs, 4),0),'fm990.0000') || '%' zdbwtxbmbl,
       to_char(NVL(round(bgk.bgs * 100 / rk.zrks, 4),0),'fm990.0000') || '%' gjfbl,
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
  FROM p_xzdm xz
  LEFT JOIN bgk
    ON xz.dm = bgk.vc_hksdm
  LEFT JOIN cf
    ON xz.dm = cf.cfsi
  LEFT JOIN sf
    ON xz.dm = sf.sfsi
  LEFT JOIN rk
    ON xz.dm = rk.vc_rkgls
  LEFT JOIN ck
    ON xz.dm = ck.vc_hksdm
 WHERE xz.sjid = '33000000'
UNION ALL
SELECT '999999999' dm,
       '合计：' dq,
       NVL(sum(bgk.bgs),0) bgs,
			 
			 to_char(NVL(round(SUM(bgk.kps) * 100 / SUM(bgk.bgs), 4),0),'fm990.0000') || '%' blzdbfb,
			 to_char(NVL(round(SUM(bgk.gfkps) * 100 / SUM(bgk.kps), 4),0),'fm990.0000') || '%' blzdtxl,
			 to_char(NVL(round(SUM(bgk.bmkps) * 100 / SUM(bgk.bgs), 4),0),'fm990.0000') || '%' zdbwtxbmbl,
       to_char(NVL(round(sum(bgk.bgs) * 100 / sum(rk.zrks), 4),0),'fm990.0000') || '%' gjfbl,
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
  FROM p_xzdm xz
  LEFT JOIN bgk
    ON xz.dm = bgk.vc_hksdm
  LEFT JOIN cf
    ON xz.dm = cf.cfsi
  LEFT JOIN sf
    ON xz.dm = sf.sfsi
  LEFT JOIN rk
    ON xz.dm = rk.vc_rkgls
  LEFT JOIN ck
    ON xz.dm = ck.vc_hksdm
 WHERE xz.sjid = '33000000'
 </if>
 
 ORDER BY dm   
 
 
 
 