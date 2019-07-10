select vc_id,
       vc_dzjg,
       vc_sbyy,
       dts(dt_rksj,1) dt_rksj,
       vc_bgkid,
       vc_gxbz,
       vc_bz,
       vc_bgdw,
       vc_scbz,
       id,
       total,
       rn
  from (select vc_id,
               vc_dzjg,
               vc_sbyy,
               dt_rksj,
               vc_bgkid,
               vc_gxbz,
               vc_bz,
               vc_bgdw,
               vc_scbz,
               id,
               total,
               rownum rn
          from (select vc_id,
                       vc_dzjg,
                       vc_sbyy,
                       dt_rksj,
                       vc_bgkid,
                       vc_gxbz,
                       vc_bz,
                       vc_bgdw,
                       vc_scbz,
                       id,
                       count(1) over() total
                  from zjjk_dz
                  where VC_BZ = #{vc_bz}
                    and vc_dzjg = '2'
                    and vc_bgdw like #{vc_gldw}||'%'
                  <if if(StringUtils.isNotBlank(#{sbdw}))>
                      and vc_bgdw = #{sbdw}
                  </if>
                  <if if(StringUtils.isNotBlank(#{dt_drsj_ks}))>
                      and DT_RKSJ >= std(#{dt_drsj_ks}, 1)
                  </if>
                  <if if(StringUtils.isNotBlank(#{dt_drsj_js}))>
                       and DT_RKSJ <= std(#{dt_drsj_js}, 1)
                  </if>)
         where rownum <= #{rn_e})
 where rn >= #{rn_s}