select /*+INDEX(BGK INDEX_SW_GLDW)*/ nvl(sum(decode(bgk.vc_shbz, '4', 1, 0)),0) qxshbtg,
       nvl(sum(case when bgk.VC_BGKLB = '0' and bgk.vc_sdqr = '1' and bgk.vc_shbz in ('3','5','6','7','8') then 1 else 0 end),0) dcf,
       nvl(sum(case when bgk.vc_sdqr = '0' and bgk.vc_shbz = '3' and bgk.vc_hkjddm like #{vc_gldw} || '%' then 1 else 0 end),0) dsdqr
 FROM ZJMB_SW_BGK BGK
 WHERE (BGK.VC_SCBZ LIKE '2')
                  AND (BGK.VC_CJDWDM like #{vc_gldw}|| '%' OR
                       BGK.VC_GLDWDM like #{vc_gldw}|| '%')
                 <if if(StringUtils.isNotBlank(#{vc_bgklb}))>
                      AND BGK.vc_bgklb = #{vc_bgklb}
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_shbz}))>
                      AND (instr(#{vc_shbz},BGK.VC_SHBZ) > 0) 
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_qx}))>
                      AND (BGK.VC_JKDW like #{vc_qx}||'%')
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_shi}))>
                      AND (BGK.VC_JKDW like #{vc_shi}||'%')
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_jkdw}))>
                      AND (BGK.VC_JKDW = #{vc_jkdw})
                 </if>
                 <if if(StringUtils.isNotBlank(#{lrsj_ks}))>
                      AND (BGK.DT_LRSJ >= std(#{lrsj_ks},1))
                 </if>
                 <if if(StringUtils.isNotBlank(#{lrsj_js}))>
                      AND (BGK.DT_LRSJ <= std(#{lrsj_js},1))
                 </if>
                 <if if(StringUtils.isNotBlank(#{cxsjlx}) && "2".equals(#{cxsjlx}) && StringUtils.isNotBlank(#{dt_sjd_ks}))>
                      AND (BGK.DT_SHSJ >= std(#{dt_sjd_ks},1))
                 </if>
                 <if if(StringUtils.isNotBlank(#{cxsjlx}) && "2".equals(#{cxsjlx}) && StringUtils.isNotBlank(#{dt_sjd_js}))>
                      AND (BGK.DT_SHSJ <= std(#{dt_sjd_js},1))
                 </if>
                 <if if(StringUtils.isNotBlank(#{cxsjlx}) && "3".equals(#{cxsjlx}) && StringUtils.isNotBlank(#{dt_sjd_ks}))>
                      AND (BGK.DT_SWRQ >= std(#{dt_sjd_ks},1))
                 </if>
                 <if if(StringUtils.isNotBlank(#{cxsjlx}) && "3".equals(#{cxsjlx}) && StringUtils.isNotBlank(#{dt_sjd_js}))>
                      AND (BGK.DT_SWRQ <= std(#{dt_sjd_js},1))
                 </if>
                 <if if(StringUtils.isNotBlank(#{cxsjlx}) && "4".equals(#{cxsjlx}) && StringUtils.isNotBlank(#{dt_sjd_ks}))>
                      AND (BGK.DT_DCRQ >= std(#{dt_sjd_ks},1))
                 </if>
                 <if if(StringUtils.isNotBlank(#{cxsjlx}) && "4".equals(#{cxsjlx}) && StringUtils.isNotBlank(#{dt_sjd_js}))>
                      AND (BGK.DT_DCRQ <= std(#{dt_sjd_js},1))
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_bgkid}))>
                      AND (BGK.VC_BGKID = #{vc_bgkid})
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_xm}))>
                      AND (BGK.VC_XM = #{vc_xm})
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_xb}))>
                      AND (BGK.VC_XB = #{vc_xb})
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_gbsy}))>
                      AND ((BGK.VC_GBSY LIKE '%'||#{vc_gbsy}||'%') OR (BGK.NB_GBSYBM LIKE  '%'||#{vc_gbsy}||'%'))
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_swdd}))>
                      AND (BGK.VC_SWDD = #{vc_swdd})
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_sznl_ks}))>
                      AND (BGK.VC_SZNL >= #{vc_sznl_ks})
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_sznl_js}))>
                      AND (BGK.VC_SZNL <= #{vc_sznl_js})
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_hkshen}))>
                      AND (BGK.VC_HKQCS = #{vc_hkshen})
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_hks}))>
                      AND (BGK.VC_HKSDM = #{vc_hks})
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_hkqx}))>
                      AND (BGK.VC_HKQXDM = #{vc_hkqx})
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_hkjd}))>
                      AND (BGK.VC_HKJDDM = #{vc_hkjd})
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_hkjw}))>
                      AND (BGK.VC_HKJW = #{vc_hkjw})
                 </if>
                 <if if(StringUtils.isNotBlank(#{fenleitjks}))>
                      AND (to_number(BGK.FENLEITJ) >= to_number(#{fenleitjks}))
                 </if>
                 <if if(StringUtils.isNotBlank(#{fenleitjjs}))>
                      AND (to_number(BGK.FENLEITJ) <= to_number(#{fenleitjjs}))
                 </if>