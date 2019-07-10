
with tab as (
	SELECT * FROM (
	SELECT G.*, ROW_NUMBER() OVER(PARTITION BY vc_bgkid  ORDER BY DT_SFRQ DESC) ROWN from zjjk_zl_sfk g
	) a where a.ROWN = 1
)
select 
 COUNT(
 CASE 
 WHEN b.VC_CXGLYY  is null THEN b.vc_bgkid 
 ELSE null END 
 ) AS sc,
 COUNT(
 CASE b.VC_CXGLYY 
 WHEN '4' THEN b.vc_bgkid 
 ELSE null END 
 ) AS sw,
  COUNT(
 CASE 
 WHEN b.VC_SFQC = '1' THEN b.vc_bgkid 
 ELSE null END 
 ) AS hkqc,
   COUNT(
 CASE 
 WHEN b.VC_CXGLYY = '1' THEN b.vc_bgkid 
 ELSE null END 
 ) AS sf,
   COUNT(
 CASE 
 WHEN b.VC_CXGLYY = '6' THEN b.vc_bgkid 
 ELSE null END 
 ) AS qt,
 a.VC_ZDBW,a.VC_ZDBWMC
from ZJJK_ZL_bgk a 
INNER JOIN tab b on a.vc_bgkid = b.vc_bgkid
LEFT JOIN zjjk_zl_hzxx c on a.vc_hzid = c.vc_personid
where  a.VC_GLDW like #{vc_gldw}||'%' 
     and a.vc_scbz = '0'
     and a.vc_shbz in ('3', '5', '6', '7', '8')
     and a.vc_bgkzt in ('0', '2', '6', '7')
 <if if(StringUtils.isNotBlank(#{vc_hkjd}))>
	 and c.VC_HKJDDM = #{vc_hkjd}
 </if>
 <if if(StringUtils.isNotBlank(#{vc_hks}))>
	 and c.vc_hksdm = #{vc_hks}
 </if>
 <if if(StringUtils.isNotBlank(#{vc_hkqx}))>
	 and c.vc_hkqxdm = #{vc_hkqx}
 </if>
 
 <if if(StringUtils.isNotBlank(#{sfrq}))>
		and to_char(a.DT_SCZDRQ,'yyyy')	= #{sfrq}
 </if>
GROUP BY a.VC_ZDBW,a.VC_ZDBWMC


