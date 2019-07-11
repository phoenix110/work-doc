select  /*+INDEX(bgk INDEX_ZL_GLDW)*/ nvl(sum(decode(BGK.vc_shbz, '4', 1, 0)), 0) qxshbtg,
       nvl(sum(case
                 when BGK.VC_SFCF = '2' and bgk.VC_BGKZT = '0' and
                      BGK.vc_sdqrzt = '1'  and bgk.VC_SHBZ in ('3', '5', '6', '7', '8') then
                  1
                 else
                  0
               end),
           0) dcf,
       nvl(sum(case
                 when bgk.vc_sdqrzt = '1' and bgk.vc_shbz = '3' and
                      bgk.vc_sfcf in ('1', '3') and bgk.vc_bgkzt = '0' and
                      bgk.dt_swrq is null and bgk.vc_swyy is null and
                      bgk.vc_bgkzt = '0' and
                      ((bgk.nb_kspf > 0 and bgk.nb_kspf <= 49 and
                      bgk.dt_sfrq <= add_months(sysdate, -2)) or
                      (bgk.nb_kspf > 50 and bgk.nb_kspf <= 79 and
                      bgk.dt_sfrq <= add_months(sysdate, -5)) or
                      (bgk.nb_kspf >= 80 and
                      bgk.dt_sfrq <= add_months(sysdate, -11))) then
                  1
                 else
                  0
               end),
           0) dsf,
       nvl(sum(case
                 when BGK.vc_sdqrzt = '0' and BGK.VC_SHBZ = '3' and HZXX.vc_hkjddm like #{jgszqh} || '%' then
                  1
                 else
                  0
               end),
           0) dsdqr
  from zjjk_zl_bgk BGK, zjjk_zl_hzxx HZXX
                where BGK.VC_HZID = HZXX.VC_PERSONID
                   and BGK.vc_scbz = '0'
                   <if if(StringUtils.isNotBlank(#{jgszqh}))>
                     AND (BGK.VC_CJDW like #{vc_gldw}|| '%' OR bgk.VC_GLDW like #{vc_gldw}|| '%' or hzxx.VC_HKJDDM like #{jgszqh} || '%')
                   </if>
                   <if if(StringUtils.isBlank(#{jgszqh}))>
                     AND (BGK.VC_CJDW like #{vc_gldw}|| '%' OR bgk.VC_GLDW like #{vc_gldw}|| '%')
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_bghks}))>
                       and BGK.VC_BGDWS = #{vc_bghks}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_bghkqx}))>
                       and BGK.VC_BGDWQX = #{vc_bghkqx}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_bgdw}))>
                       and BGK.VC_BGDW = #{vc_bgdw}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_icd10}))>
                       and BGK.vc_icd10 LIKE '%'||#{vc_icd10}||'%'
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_bgkid}))>
                       and BGK.VC_BGKID = #{vc_bgkid}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hzxb}))>
                       and hzxx.Vc_Hzxb = #{vc_hzxb}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_sfzh}))>
                       and hzxx.Vc_Sfzh = #{vc_sfzh}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_shbz}))>
                       AND instr(#{vc_shbz},BGK.VC_SHBZ) > 0  
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_sfhs}))>
                       and hzxx.Vc_Sfhs = #{vc_sfhs}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_bgkzt}))>
                       and BGK.VC_BGKZT = #{vc_bgkzt}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_sfsw}))>
                       and hzxx.vc_sfsw = #{vc_sfsw}
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_zdrq_ks}))>
                       and bgk.DT_SCZDRQ >= std(#{dt_zdrq_ks},1)
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_zdrq_js}))>
                       and bgk.DT_SCZDRQ <= std(#{dt_zdrq_js},1)
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_bgrq_ks}))>
                       and bgk.dt_bgrq >= std(#{dt_bgrq_ks},1)
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_bgrq_js}))>
                       and bgk.dt_bgrq <= std(#{dt_bgrq_js},1)
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_xm}))>
                       and hzxx.vc_hzxm like  '%'|| #{vc_xm} || '%'
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_cjsj_ks}))>
                       and bgk.dt_cjsj >= std(#{dt_cjsj_ks},1)
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_cjsj_js}))>
                       and bgk.dt_cjsj <= std(#{dt_cjsj_js},1)
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_sznl_ks}))>
                       and bgk.vc_sznl >= to_number(#{vc_sznl_ks})
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_sznl_js}))>
                       and bgk.vc_sznl <=to_number(#{vc_sznl_js})
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkshen}))>
                       and hzxx.VC_HKSFDM = #{vc_hkshen}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hks}))>
                       and (hzxx.VC_HKSDM = #{vc_hks})
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkqx}))>
                       and hzxx.VC_HKQXDM = #{vc_hkqx}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkjd}))>
                       and hzxx.VC_HKJDDM = #{vc_hkjd}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkjw}))>
                       and hzxx.VC_HKJWDM = #{vc_hkjw}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_mzh}))>
                       and bgk.VC_MZH = #{vc_mzh}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_zyh}))>
                       and bgk.VC_ZYH = #{vc_zyh}
                   </if>