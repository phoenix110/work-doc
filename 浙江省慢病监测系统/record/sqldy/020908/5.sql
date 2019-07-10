
with tab as (
	SELECT nld,jb,COUNT(*) count FROM(
	SELECT 
	case when fun_get_agebycsrqandywrq(a.DT_CSRQ, a.DT_SWRQ) between 30 and 34 then  '30'
			 when fun_get_agebycsrqandywrq(a.DT_CSRQ, a.DT_SWRQ) between 35 and 39 then  '35'
			 when fun_get_agebycsrqandywrq(a.DT_CSRQ, a.DT_SWRQ) between 40 and 44 then  '40'
			 when fun_get_agebycsrqandywrq(a.DT_CSRQ, a.DT_SWRQ) between 45 and 49 then  '45'
			 when fun_get_agebycsrqandywrq(a.DT_CSRQ, a.DT_SWRQ) between 50 and 54 then  '50'
			 when fun_get_agebycsrqandywrq(a.DT_CSRQ, a.DT_SWRQ) between 55 and 59 then  '55'
			 when fun_get_agebycsrqandywrq(a.DT_CSRQ, a.DT_SWRQ) between 60 and 64 then  '60'
			 when fun_get_agebycsrqandywrq(a.DT_CSRQ, a.DT_SWRQ) between 65 and 69 then  '65'
			 end nld,
		case  
			 WHEN substr(a.VC_GBSY,0,1) IN ('E','H','N','O') THEN 'E'
			 ELSE substr(a.VC_GBSY,0,1) END jb
			 from ZJMB_SW_BGK a 
			 WHERE (substr(a.VC_GBSY,0,1) in('J','C')  
			 OR substr(a.VC_GBSY,0,3) in ('E10','E11','E12','E13','E14','H28','N08','O24')
			 OR (substr(a.VC_GBSY,0,3) in ('I20','I21','I22','I24','I25','I46','I60','I61','I63','I64')) )
  AND fun_get_agebycsrqandywrq(a.DT_CSRQ, a.DT_SWRQ) between 30 and 69
	AND vc_scbz = '2'
 and vc_shbz in ('3', '5', '6', '7', '8')
 and vc_bgklb = '0'
  <if if(StringUtils.isNotBlank(#{vc_hks}))>
	 and vc_hksdm = #{vc_hks}
 </if>
 <if if(StringUtils.isNotBlank(#{vc_hkqx}))>
	 and vc_hkqxdm = #{vc_hkqx}
 </if>
 
 <if if("1".equals(#{xb}))>
		and vc_xb = '1'
 </if>
 <if if("2".equals(#{xb}))>
		and vc_xb = '2'
 </if>
 <if if("1".equals(#{sjlx}) && StringUtils.isNotBlank(#{year}))>
		and to_char(dt_swrq,'yyyy')	= #{year}
 </if>
 <if if("2".equals(#{sjlx}) && StringUtils.isNotBlank(#{year}))>
		and to_char(dt_lrsj,'yyyy')	= #{year}
 </if><if if(1 == 1)>
	AND fun_get_agebycsrqandywrq(a.DT_CSRQ, a.DT_SWRQ) between 30 and 69
	) a GROUP BY jb,nld ORDER BY jb 
) ,
tt As 
(
SELECT
	   decode(max(vc_zhj), 0, null, max(vc_zhj)) vc_zhj,
		 decode(max(vc_30nld), 0, null, max(vc_30nld)) vc_30nld,
		 decode(max(vc_35nld), 0, null, max(vc_35nld)) vc_35nld,
		 decode(max(vc_40nld), 0, null, max(vc_40nld)) vc_40nld,
		 decode(max(vc_45nld), 0, null, max(vc_45nld)) vc_45nld,
		 decode(max(vc_50nld), 0, null, max(vc_50nld)) vc_50nld,
		 decode(max(vc_55nld), 0, null, max(vc_55nld)) vc_55nld,
		 decode(max(vc_60nld), 0, null, max(vc_60nld)) vc_60nld,
		 decode(max(vc_65nld), 0, null, max(vc_65nld)) vc_65nld
				FROM ZJMB_RKGLB 
			 where 1=1
			 </if>
			  <if if(StringUtils.isNotBlank(#{year}))>
				 and vc_nf = #{year}
			 </if>
			  <if if(StringUtils.isBlank(#{xb}))>
				 and vc_lx = '6'
			 </if>
			 <if if("1".equals(#{xb}))>
					and vc_lx = '4'
			 </if>
			 <if if("2".equals(#{xb}))>
					and vc_lx = '5'
			 </if>
			 <if if(StringUtils.isNotBlank(#{vc_hkqx}) && StringUtils.isBlank(#{vc_hkjd}))>
				 and vc_rkgljd = '99999999'
				 and vc_rkglq = #{vc_hkqx}
			 </if>
			 <if if(StringUtils.isBlank(#{vc_hkqx}) && StringUtils.isNotBlank(#{vc_hks}))>
				 and vc_rkglq = '99999999'
				 and vc_rkgls = #{vc_hks}
			 </if>
			 <if if(StringUtils.isBlank(#{vc_hks}))>
					 and vc_rkgls = '99999999'
			 </if>
)
SELECT tb.nld,tb.ages,tb.total,
nvl(c.num,0) zlnum,nvl(c.swl,0) zlswl,
nvl(j.num,0) hxnum,nvl(j.swl,0) hxswl,
nvl(e.num,0) tnbnum,nvl(e.swl,0) tnbswl,
nvl(i.num,0) xnxgnum,nvl(i.swl,0) xnxgswl FROM (
SELECT '30' nld,'30-' ages,tt.vc_30nld total FROM dual,tt
union all
SELECT '35' nld,'35-' ages,tt.vc_35nld total FROM dual,tt
union all
SELECT '40' nld,'40-' ages,tt.vc_40nld total FROM dual,tt
union all
SELECT '45' nld,'45-' ages,tt.vc_45nld total FROM dual,tt
union all
SELECT '50' nld,'50-' ages,tt.vc_50nld total FROM dual,tt
union all
SELECT '55' nld,'55-' ages,tt.vc_55nld total FROM dual,tt
union all
SELECT '60' nld,'60-' ages,tt.vc_60nld total FROM dual,tt
union all
SELECT '65' nld,'65-69' ages,tt.vc_65nld total FROM dual,tt
) tb
FULL JOIN (
select tab.nld,tab.jb,count num,
CASE nld 
	WHEN '30' THEN count/decode(VC_30NLD, 0, null, VC_30NLD)
	WHEN '35' THEN count/decode(VC_35NLD, 0, null, VC_35NLD)
	WHEN '40' THEN count/decode(VC_40NLD, 0, null, VC_40NLD)
	WHEN '45' THEN count/decode(VC_45NLD, 0, null, VC_45NLD)
	WHEN '50' THEN count/decode(VC_50NLD, 0, null, VC_50NLD)
	WHEN '55' THEN count/decode(VC_55NLD, 0, null, VC_55NLD)
	WHEN '60' THEN count/decode(VC_60NLD, 0, null, VC_60NLD)
	WHEN '65' THEN count/decode(VC_65NLD, 0, null, VC_65NLD)
END swl

from tab,tt where tab.jb = 'C'
) c on tb.nld = c.nld
FULL JOIN (
select tab.nld,tab.jb,count num,
CASE nld 
	WHEN '30' THEN count/decode(VC_30NLD, 0, null, VC_30NLD)
	WHEN '35' THEN count/decode(VC_35NLD, 0, null, VC_35NLD)
	WHEN '40' THEN count/decode(VC_40NLD, 0, null, VC_40NLD)
	WHEN '45' THEN count/decode(VC_45NLD, 0, null, VC_45NLD)
	WHEN '50' THEN count/decode(VC_50NLD, 0, null, VC_50NLD)
	WHEN '55' THEN count/decode(VC_55NLD, 0, null, VC_55NLD)
	WHEN '60' THEN count/decode(VC_60NLD, 0, null, VC_60NLD)
	WHEN '65' THEN count/decode(VC_65NLD, 0, null, VC_65NLD)
END swl
from tab,tt where tab.jb = 'J'
) j on tb.nld = j.nld
FULL JOIN (
select tab.nld,tab.jb,count num,
CASE nld 
	WHEN '30' THEN count/decode(VC_30NLD, 0, null, VC_30NLD)
	WHEN '35' THEN count/decode(VC_35NLD, 0, null, VC_35NLD)
	WHEN '40' THEN count/decode(VC_40NLD, 0, null, VC_40NLD)
	WHEN '45' THEN count/decode(VC_45NLD, 0, null, VC_45NLD)
	WHEN '50' THEN count/decode(VC_50NLD, 0, null, VC_50NLD)
	WHEN '55' THEN count/decode(VC_55NLD, 0, null, VC_55NLD)
	WHEN '60' THEN count/decode(VC_60NLD, 0, null, VC_60NLD)
	WHEN '65' THEN count/decode(VC_65NLD, 0, null, VC_65NLD)
END swl
from tab,tt where tab.jb = 'E'
) e on tb.nld = e.nld
FULL JOIN (
select tab.nld,tab.jb,count num,
CASE nld 
	WHEN '30' THEN count/decode(VC_30NLD, 0, null, VC_30NLD)
	WHEN '35' THEN count/decode(VC_35NLD, 0, null, VC_35NLD)
	WHEN '40' THEN count/decode(VC_40NLD, 0, null, VC_40NLD)
	WHEN '45' THEN count/decode(VC_45NLD, 0, null, VC_45NLD)
	WHEN '50' THEN count/decode(VC_50NLD, 0, null, VC_50NLD)
	WHEN '55' THEN count/decode(VC_55NLD, 0, null, VC_55NLD)
	WHEN '60' THEN count/decode(VC_60NLD, 0, null, VC_60NLD)
	WHEN '65' THEN count/decode(VC_65NLD, 0, null, VC_65NLD) 
END swl
from tab,tt where tab.jb = 'I'
) i on tb.nld = i.nld

ORDER BY tb.nld
