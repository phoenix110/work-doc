with dsum as (
select * from zjmb_rkglb 
where vc_nf = #{nf}    
<if if(StringUtils.isBlank(#{xb}))>
	 and vc_lx = '6'
</if>
 <if if("1".equals(#{xb}))>
		and vc_lx = '4'
 </if>
 <if if("2".equals(#{xb}))>
		and vc_lx = '5'
 </if>
 <if if(StringUtils.isNotBlank(#{vc_hkjd}))>
	 and vc_rkgljd = #{vc_hkjd}
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
),
 tsum as (
SELECT count(*) syhj from (
SELECT to_char(c.ccd_pcode) code
FROM zjmb_sw_bgk a, t_icd10_cc c
where a.vc_gbsy = c.icd10_code
 and a.vc_bgklb = '0'
 and a.vc_shbz in ('8', '7', '6', '5', '3')
 and a.vc_scbz = '2'
  <if if(StringUtils.isNotBlank(#{vc_hks}))>
                         and a.vc_hksdm = #{vc_hks}
                     </if>
                     <if if(StringUtils.isNotBlank(#{vc_hkqx}))>
                         and a.vc_hkqxdm = #{vc_hkqx}
                     </if>
                     <if if(StringUtils.isNotBlank(#{dt_jzsj_ks}))>
                         and a.dt_swrq >= std(#{dt_jzsj_ks},1)
                     </if>
                     <if if(StringUtils.isNotBlank(#{dt_jzsj_js}))>
                         and a.dt_swrq <= std(#{dt_jzsj_js},1)
                     </if>
                     <if if(StringUtils.isNotBlank(#{dt_lrsj_ks}))>
                         and a.dt_cjsj >= std(#{dt_lrsj_ks},1)
                     </if>
                     <if if(StringUtils.isNotBlank(#{dt_lrsj_js}))>
                         and a.dt_cjsj <= std(#{dt_lrsj_js},1)
                     </if>
                     <if if(StringUtils.isNotBlank(#{xb}))>
                         and a.vc_xb = #{xb}
                     </if>
                     <if if("2".equals(#{hjlx}))>
                         and exists(select 1 from p_xzdm xzdm where a.vc_hkjddm = xzdm.dm and xzdm.csbz = '城市')
                     </if>
                     <if if("3".equals(#{hjlx}))>
                         and exists(select 1 from p_xzdm xzdm where a.vc_hkjddm = xzdm.dm and xzdm.csbz = '农村')
                     </if>
) a )
, tab as (
select t.qt1,qt2,to_char(a.code) code,to_char(a.scode) scode,to_char(a.pcode) pcode,t.ordernum,3 clas,tsum.syhj,to_number(dsum.VC_ZHJ)  zhj from (
select  to_char(c.ccd_code) code ,to_char(c.ccd_scode) scode,to_char(c.ccd_pcode) pcode
from  t_icd10_cc c
GROUP BY to_char(c.ccd_code),to_char(c.ccd_scode),to_char(c.ccd_pcode)
) a inner join temp_zjjk_report_row t  on a.code = t.QT1,tsum,dsum
where t.reportname = 'jmbsswyyb'
             and t.rowname = '0'
             and t.QT1 > 1
				 <if if(StringUtils.isNotBlank(#{ids}))>
	
	AND t.qt1 in (select distinct column_value column_value from table(split(#{ids}, ',')))
</if>

union all
select t.qt1,qt2,to_char(a.pcode) code,'0' scode,to_char(a.pcode) pcode,t.ordernum,2 clas,tsum.syhj,to_number(dsum.VC_ZHJ)  zhj from (
select  0 code,to_char(c.ccd_scode) scode ,to_char(c.ccd_pcode) pcode
from  t_icd10_cc c
GROUP BY to_char(c.ccd_scode),to_char(c.ccd_pcode)
) a left join temp_zjjk_report_row t on a.scode = t.QT1,tsum,dsum
where t.reportname = 'jmbsswyyb'
             and t.rowname = '0'
             and t.QT1 > 1 <if if(StringUtils.isNotBlank(#{ids}))>
	
	AND t.qt1 in (select distinct column_value column_value from table(split(#{ids}, ',')))
	</if>
union all
select t.qt1,qt2,to_char(a.pcode) code,'0' scode,'0' pcode,t.ordernum,1 clas,tsum.syhj,to_number(dsum.VC_ZHJ)  zhj from (
select  to_char(c.ccd_pcode) pcode
from  t_icd10_cc c
GROUP BY to_char(c.ccd_pcode)
) a left join temp_zjjk_report_row t on a.pcode = t.QT1,tsum,dsum
where t.reportname = 'jmbsswyyb'
             and t.rowname = '0'
             and t.QT1 > 1 <if if(StringUtils.isNotBlank(#{ids}))>
	
	AND t.qt1 in (select distinct column_value column_value from table(split(#{ids}, ',')))
	</if>
) 

select ttt.*,round(ttt.hj/decode(zhj,0,null,zhj),2) swl, round(hj/ decode(syhj,0,null,syhj),2) sygc  from (
select tab.*,tb.HJ from tab LEFT JOIN (

SELECT code,count(*) hj from (
SELECT to_char(c.ccd_code) code
FROM zjmb_sw_bgk a, t_icd10_cc c
where a.vc_gbsy = c.icd10_code
 and a.vc_bgklb = '0'
 and a.vc_shbz in ('8', '7', '6', '5', '3')
 and a.vc_scbz = '2'
  <if if(StringUtils.isNotBlank(#{vc_hks}))>
                         and a.vc_hksdm = #{vc_hks}
                     </if>
                     <if if(StringUtils.isNotBlank(#{vc_hkqx}))>
                         and a.vc_hkqxdm = #{vc_hkqx}
                     </if>
                     <if if(StringUtils.isNotBlank(#{dt_jzsj_ks}))>
                         and a.dt_swrq >= std(#{dt_jzsj_ks},1)
                     </if>
                     <if if(StringUtils.isNotBlank(#{dt_jzsj_js}))>
                         and a.dt_swrq <= std(#{dt_jzsj_js},1)
                     </if>
                     <if if(StringUtils.isNotBlank(#{dt_lrsj_ks}))>
                         and a.dt_cjsj >= std(#{dt_lrsj_ks},1)
                     </if>
                     <if if(StringUtils.isNotBlank(#{dt_lrsj_js}))>
                         and a.dt_cjsj <= std(#{dt_lrsj_js},1)
                     </if>
                     <if if(StringUtils.isNotBlank(#{xb}))>
                         and a.vc_xb = #{xb}
                     </if>
                     <if if("2".equals(#{hjlx}))>
                         and exists(select 1 from p_xzdm xzdm where a.vc_hkjddm = xzdm.dm and xzdm.csbz = '城市')
                     </if>
                     <if if("3".equals(#{hjlx}))>
                         and exists(select 1 from p_xzdm xzdm where a.vc_hkjddm = xzdm.dm and xzdm.csbz = '农村')
                     </if>
) a GROUP BY code
 union all
 SELECT code,count(*) hj from (
SELECT to_char(c.ccd_scode) code
FROM zjmb_sw_bgk a, t_icd10_cc c
where a.vc_gbsy = c.icd10_code
 and a.vc_bgklb = '0'
 and a.vc_shbz in ('8', '7', '6', '5', '3')
 and a.vc_scbz = '2'
  <if if(StringUtils.isNotBlank(#{vc_hks}))>
                         and a.vc_hksdm = #{vc_hks}
                     </if>
                     <if if(StringUtils.isNotBlank(#{vc_hkqx}))>
                         and a.vc_hkqxdm = #{vc_hkqx}
                     </if>
                     <if if(StringUtils.isNotBlank(#{dt_jzsj_ks}))>
                         and a.dt_swrq >= std(#{dt_jzsj_ks},1)
                     </if>
                     <if if(StringUtils.isNotBlank(#{dt_jzsj_js}))>
                         and a.dt_swrq <= std(#{dt_jzsj_js},1)
                     </if>
                     <if if(StringUtils.isNotBlank(#{dt_lrsj_ks}))>
                         and a.dt_cjsj >= std(#{dt_lrsj_ks},1)
                     </if>
                     <if if(StringUtils.isNotBlank(#{dt_lrsj_js}))>
                         and a.dt_cjsj <= std(#{dt_lrsj_js},1)
                     </if>
                     <if if(StringUtils.isNotBlank(#{xb}))>
                         and a.vc_xb = #{xb}
                     </if>
                     <if if("2".equals(#{hjlx}))>
                         and exists(select 1 from p_xzdm xzdm where a.vc_hkjddm = xzdm.dm and xzdm.csbz = '城市')
                     </if>
                     <if if("3".equals(#{hjlx}))>
                         and exists(select 1 from p_xzdm xzdm where a.vc_hkjddm = xzdm.dm and xzdm.csbz = '农村')
                     </if>
) a GROUP BY code
 union all
SELECT code,count(*) hj from (
SELECT to_char(c.ccd_pcode) code
FROM zjmb_sw_bgk a, t_icd10_cc c
where a.vc_gbsy = c.icd10_code
 and a.vc_bgklb = '0'
 and a.vc_shbz in ('8', '7', '6', '5', '3')
 and a.vc_scbz = '2'
  <if if(StringUtils.isNotBlank(#{vc_hks}))>
                         and a.vc_hksdm = #{vc_hks}
                     </if>
                     <if if(StringUtils.isNotBlank(#{vc_hkqx}))>
                         and a.vc_hkqxdm = #{vc_hkqx}
                     </if>
                     <if if(StringUtils.isNotBlank(#{dt_jzsj_ks}))>
                         and a.dt_swrq >= std(#{dt_jzsj_ks},1)
                     </if>
                     <if if(StringUtils.isNotBlank(#{dt_jzsj_js}))>
                         and a.dt_swrq <= std(#{dt_jzsj_js},1)
                     </if>
                     <if if(StringUtils.isNotBlank(#{dt_lrsj_ks}))>
                         and a.dt_cjsj >= std(#{dt_lrsj_ks},1)
                     </if>
                     <if if(StringUtils.isNotBlank(#{dt_lrsj_js}))>
                         and a.dt_cjsj <= std(#{dt_lrsj_js},1)
                     </if>
                     <if if(StringUtils.isNotBlank(#{xb}))>
                         and a.vc_xb = #{xb}
                     </if>
                     <if if("2".equals(#{hjlx}))>
                         and exists(select 1 from p_xzdm xzdm where a.vc_hkjddm = xzdm.dm and xzdm.csbz = '城市')
                     </if>
                     <if if("3".equals(#{hjlx}))>
                         and exists(select 1 from p_xzdm xzdm where a.vc_hkjddm = xzdm.dm and xzdm.csbz = '农村')
                     </if>
) a GROUP BY code

) tb on tab.code = tb.code
union all 
select '1' qt1,'合计' qt2,'0' code,'0' scode,'0' pcode,'1' ordernum,0 clas,tsum.syhj,to_number(dsum.VC_ZHJ)zhj,a.hj from (
SELECT count(*) hj from (
SELECT to_char(c.ccd_pcode) code
FROM zjmb_sw_bgk a, t_icd10_cc c
where a.vc_gbsy = c.icd10_code
 and a.vc_bgklb = '0'
 and a.vc_shbz in ('8', '7', '6', '5', '3')
 and a.vc_scbz = '2'
 
 <if if(StringUtils.isNotBlank(#{ids}))>
	and instr(#{ids},to_char(c.ccd_pcode)) > 0
	AND to_char(c.ccd_pcode) in (select distinct column_value column_value from table(split(#{ids}, ',')))
</if>
 
  <if if(StringUtils.isNotBlank(#{vc_hks}))>
                         and a.vc_hksdm = #{vc_hks}
                     </if>
                     <if if(StringUtils.isNotBlank(#{vc_hkqx}))>
                         and a.vc_hkqxdm = #{vc_hkqx}
                     </if>
                     <if if(StringUtils.isNotBlank(#{dt_jzsj_ks}))>
                         and a.dt_swrq >= std(#{dt_jzsj_ks},1)
                     </if>
                     <if if(StringUtils.isNotBlank(#{dt_jzsj_js}))>
                         and a.dt_swrq <= std(#{dt_jzsj_js},1)
                     </if>
                     <if if(StringUtils.isNotBlank(#{dt_lrsj_ks}))>
                         and a.dt_cjsj >= std(#{dt_lrsj_ks},1)
                     </if>
                     <if if(StringUtils.isNotBlank(#{dt_lrsj_js}))>
                         and a.dt_cjsj <= std(#{dt_lrsj_js},1)
                     </if>
                     <if if(StringUtils.isNotBlank(#{xb}))>
                         and a.vc_xb = #{xb}
                     </if>
                     <if if("2".equals(#{hjlx}))>
                         and exists(select 1 from p_xzdm xzdm where a.vc_hkjddm = xzdm.dm and xzdm.csbz = '城市')
                     </if>
                     <if if("3".equals(#{hjlx}))>
                         and exists(select 1 from p_xzdm xzdm where a.vc_hkjddm = xzdm.dm and xzdm.csbz = '农村')
                     </if>
) a ) a,tsum,dsum
) ttt
where 1=1 

ORDER BY to_number(ttt.ordernum )





