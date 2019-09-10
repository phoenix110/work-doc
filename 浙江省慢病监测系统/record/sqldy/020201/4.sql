select  /*+INDEX(a INDEX_TNB_GLDW)*/ nvl(sum(decode(a.vc_shbz, '4', 1, 0)),0) qxshbtg,
       nvl(sum(case when a.vc_cfzt = '0' and a.vc_sdqrzt = '1' and a.vc_bgkzt = '0' and a.vc_shbz in ('3','5','6','7','8') then 1 else 0 end),0) dcf,
       nvl(sum(case when a.vc_cfzt = '1' and (dt_sfsj is null or dt_sfsj < sysdate - 335) then 1 else 0 end),0) dsf,
       nvl(sum(case when a.vc_sdqrzt = '0' and a.vc_shbz = '3' and b.vc_hkjd like #{vc_gldw} || '%' then 1 else 0 end),0) dsdqr
  from zjjk_tnb_bgk a, zjjk_tnb_hzxx b
 where a.vc_hzid = b.vc_personid
                   <if if(StringUtils.isNotBlank(#{jgszqh}))>
                     and (a.vc_cjdw like #{vc_gldw} || '%' or a.vc_gldw like #{vc_gldw} || '%' or b.vc_hkjd like #{jgszqh} || '%')
                   </if>
                   <if if(StringUtils.isBlank(#{jgszqh}))>
                     and (a.vc_cjdw like #{vc_gldw} || '%' or a.vc_gldw like #{vc_gldw} || '%')
                   </if>
                   and a.vc_scbz = '0'
                   <if if(StringUtils.isNotBlank(#{vc_zyh}))>
                     and a.vc_zyh = #{vc_zyh}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_mzh}))>
                     and a.vc_mzh = #{vc_mzh}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_bgkcode}))>
                     and a.vc_bgkcode like #{vc_bgkcode}||'%'
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hzxm}))>
                     and b.vc_hzxm like '%'||#{vc_hzxm}||'%'
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hzxb}))>
                     and b.vc_hzxb = #{vc_hzxb}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_sfzh}))>
                     and b.vc_sfzh = #{vc_sfzh}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_bgkzt}))>
                     and a.vc_bgkzt = #{vc_bgkzt}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_shbz}) && !#{vc_shbz}.contains(","))>
                     and a.vc_shbz = #{vc_shbz}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_shbz}) && #{vc_shbz}.contains(","))>
                     and instr(#{vc_shbz},a.vc_shbz) > 0
                   </if>
                   <if if(StringUtils.isNotBlank(#{fbnl_ks}))>
                     and a.vc_sznl >= #{fbnl_ks}
                   </if>
                   <if if(StringUtils.isNotBlank(#{fbnl_js}))>
                     and a.vc_sznl <= #{fbnl_js}
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_sczdrq_ks}))>
                     and a.dt_sczdrq >= to_date(#{dt_sczdrq_ks},'yyyy-MM-dd HH24:mi:ss')
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_sczdrq_js}))>
                     and a.dt_sczdrq <= to_date(#{dt_sczdrq_js},'yyyy-MM-dd HH24:mi:ss')
                   </if>
                   <if if(StringUtils.isNotBlank(#{VC_ICD10}))>
                     and a.VC_ICD10  LIKE '%'||#{VC_ICD10}||'%'
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_bgrq_ks}))>
                     and a.dt_bgrq >= to_date(#{dt_bgrq_ks},'yyyy-MM-dd HH24:mi:ss')
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_bgrq_js}))>
                     and a.dt_bgrq <= to_date(#{dt_bgrq_js},'yyyy-MM-dd HH24:mi:ss')
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_swrq_ks}))>
                     and a.dt_swrq >= to_date(#{dt_swrq_ks},'yyyy-MM-dd HH24:mi:ss')
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_swrq_js}))>
                     and a.dt_swrq <= to_date(#{dt_swrq_js},'yyyy-MM-dd HH24:mi:ss')
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_cjsj_ks}))>
                     and a.dt_cjsj >= to_date(#{dt_cjsj_ks},'yyyy-MM-dd HH24:mi:ss')
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_cjsj_js}))>
                     and a.dt_cjsj <= to_date(#{dt_cjsj_js},'yyyy-MM-dd HH24:mi:ss')
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_qxshsj_ks}))>
                     and a.dt_qxshsj >= to_date(#{dt_qxshsj_ks},'yyyy-MM-dd HH24:mi:ss')
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_qxshsj_js}))>
                     and a.dt_qxshsj <= to_date(#{dt_qxshsj_js},'yyyy-MM-dd HH24:mi:ss')
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_wxystz_ks}))>
                     and a.vc_wxystz >= #{vc_wxystz_ks}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_wxystz_js}))>
                     and a.vc_wxystz <= #{vc_wxystz_js}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkshen}))>
                     and b.vc_hkshen = #{vc_hkshen}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hks}))>
                     and b.vc_hks = #{vc_hks}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkqx}))>
                     and b.vc_hkqx = #{vc_hkqx}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkjd}))>
                     and b.vc_hkjd = #{vc_hkjd}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkjw}))>
                     and b.vc_hkjw = #{vc_hkjw}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkxxdz}))>
                     and b.vc_hkxxdz like '%'||#{vc_hkxxdz}||'%'
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_bks}))>
                     and a.vc_bks = #{vc_bks}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_bkq}))>
                     and a.vc_bkq = #{vc_bkq}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_bgdw}))>
                     and a.vc_bgdw = #{vc_bgdw}
                   </if>