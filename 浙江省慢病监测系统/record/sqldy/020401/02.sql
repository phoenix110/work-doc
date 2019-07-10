select  /*+INDEX(BGK INDEX_XNXG_GLDW)*/ nvl(sum(decode(BGK.vc_shbz, '4', 1, 0)),0) qxshbtg,
       nvl(sum(case when BGK.VC_SFCF = '2' AND BGK.VC_KZT = '0' AND BGK.VC_SDQRZT = '1' AND BGK.VC_SHBZ IN ('3','5','6','7','8') then 1 else 0 end), 0) dcf, 
       nvl(sum(case when BGK.VC_SFCF = '1' and (BGK.dt_sfsj is null or BGK.dt_sfsj < sysdate - 335) then 1 else 0 end),0) dsf,
       nvl(sum(case when BGK.vc_sdqrzt = '0'and BGK.vc_scbz = '2'and BGK.vc_shbz = '3' and BGK.vc_czhkjd like #{jgszqh} || '%'  then 1 else 0 end),0) dsdqr
  from zjjk_xnxg_bgk BGK
 where  BGK.vc_scbz = '2'
                   AND (bgk.vc_cjdwdm  like #{vc_gldw}|| '%' OR bgk.vc_gldwdm like #{vc_gldw}|| '%')
                   <if if(StringUtils.isNotBlank(#{vc_bghks}))>
                       and BGK.vc_bkdw = #{vc_bghks}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_bghkqx}))>
                       and BGK.vc_bkdwqx = #{vc_bghkqx}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_bgdw}))>
                       and BGK.vc_bkdwyy = #{vc_bgdw}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_bgkbh}))>
                       and BGK.vc_bgkbh = #{vc_bgkbh}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hzxb}))>
                       and BGK.Vc_Hzxb = #{vc_hzxb}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hzzy}))>
                       and BGK.vc_hzzy = #{vc_hzzy}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hzicd}))>
                       and BGK.VC_HZICD LIKE '%'||#{vc_hzicd}||'%'
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_sfzh}))>
                       and BGK.VC_HZSFZH = #{vc_sfzh}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_zyh}))>
                       and BGK.vc_zyh = #{vc_zyh}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_mzh}))>
                       and BGK.VC_MZH = #{vc_mzh}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_xm}))>
                       and BGK.vc_hzxm like '%' || #{vc_xm} || '%'
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_shbz}))>
                       AND instr(#{vc_shbz},BGK.VC_SHBZ) > 0  
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_bgkzt}))>
                       and BGK.vc_kzt = #{vc_bgkzt}
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_bgrq_ks}))>
                       and bgk.dt_bkrq >= std(#{dt_bgrq_ks},1)
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_bgrq_js}))>
                       and bgk.dt_bkrq <= std(#{dt_bgrq_js},1)
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_swrq_ks}))>
                       and bgk.dt_swrq >= std(#{dt_swrq_ks},1)
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_swrq_js}))>
                       and bgk.dt_swrq <= std(#{dt_swrq_js},1)
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_cjsj_ks}))>
                       and bgk.dt_cjsj >= std(#{dt_cjsj_ks},1)
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_cjsj_js}))>
                       and bgk.dt_cjsj <= std(#{dt_cjsj_js},1)
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_sznl_ks}))>
                       and bgk.vc_bksznl >= to_number(#{vc_sznl_ks})
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_sznl_js}))>
                       and bgk.vc_bksznl <=to_number(#{vc_sznl_js})
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_fbrq_ks}))>
                       and getage(bgk.dt_fbrq) >= to_number(#{dt_fbrq_ks})
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_fbrq_js}))>
                       and getage(bgk.dt_fbrq) <=to_number(#{dt_fbrq_js})
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkshen}))>
                       and bgk.VC_CZHKS = #{vc_hkshen}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hks}))>
                       and (bgk.VC_CZHKSI = #{vc_hks})
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkqx}))>
                       and bgk.vc_czhkqx = #{vc_hkqx}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkjd}))>
                       and bgk.vc_czhkjd = #{vc_hkjd}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkjw}))>
                       and bgk.vc_czhkjw = #{vc_hkjw}
                   </if>
                   <if if("1".equals(#{vc_isrq}))>
                       and bgk.VC_GXBZD in ('1','2','3')
                   </if>
                   <if if("1".equals(#{vc_isrq}) && StringUtils.isNotBlank(#{vc_zdyj}))>
                       and bgk.Vc_Gxbzd = #{vc_zdyj}
                   </if>
                    <if if("2".equals(#{vc_isrq}))>
                       and bgk.VC_NCZZD in ('1','2','3','4','5','6')
                   </if>
                   <if if("2".equals(#{vc_isrq}) && StringUtils.isNotBlank(#{vc_zdyj}))>
                       and bgk.Vc_Nczzd = #{vc_zdyj}
                   </if>