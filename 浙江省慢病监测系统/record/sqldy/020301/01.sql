select vc_bgkid,
       vc_bgklx,
       vc_hzid,
       vc_bgkzt,
       vc_icd10,
       dts(dt_bgrq,0) dt_bgrq,
       dts(dt_cjsj,0) dt_cjsj,
       dts(DT_YYSHSJ,0) DT_YYSHSJ,
       dts(DT_QXSHSJ,0) DT_QXSHSJ,
       dts(dt_sfsj,0) dt_sfsj,
       dts(dt_cfsj,0) dt_cfsj,
       (select d.mc from p_yljg d where d.dm=vc_bgdw) vc_bgdw_mc,
       vc_sfcf,
       vc_shbz,
       dt_hzcsrq,
       GetAge(dt_hzcsrq) nl,
       vc_hzxm,
       vc_hzxb,
       vc_sfzh,
       VC_HKSFDM,
       VC_HKSDM,
       VC_HKQXDM,
       VC_HKJDDM,
       VC_HKJWDM,
       VC_HKXXDZ,
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_SHZT',vc_shbz) vc_shbz_text,
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_BGKZT',vc_bgkzt) vc_bgkzt_text,
       decode(vc_hzxb, '1', '男', '2', '女') vc_hzxb_text,
       decode(VC_HKSFDM,
              '0',
              '浙江省' ||
              pkg_zjmb_tnb.fun_getxzqhmc(VC_HKSDM) ||
              pkg_zjmb_tnb.fun_getxzqhmc(VC_HKQXDM) ||
              pkg_zjmb_tnb.fun_getxzqhmc(VC_HKJDDM) ||
              VC_HKXXDZ,
              '1',
              '外省') hkdz_text,   
       vc_gldw,  
       vc_shwtgyy, 
       vc_shwtgyy1, 
       total,
       rn
  from (select vc_bgkid,
               vc_bgklx,
               vc_hzid,
               vc_shbz,
               vc_bgkzt,
               vc_icd10,
               dt_bgrq,
               dt_cjsj,
               dt_hzcsrq,
               DT_YYSHSJ,
               DT_QXSHSJ,
               dt_sfsj,
               dt_cfsj,
               vc_bgdw,
               vc_sfcf,
               vc_hzxm,
               vc_hzxb,
               vc_sfzh,
               VC_HKSFDM,
               VC_HKSDM,
               VC_HKQXDM,
               VC_HKJDDM,
               VC_HKJWDM,
               VC_HKXXDZ,
               vc_gldw,
               vc_shwtgyy,
               vc_shwtgyy1,
               total,
               rownum as rn
          from (select /*+INDEX(bgk INDEX_ZL_GLDW)*/ bgk.vc_bgkid,
                       bgk.vc_bgklx,
                       bgk.vc_hzid,
                       bgk.vc_shbz,
                       bgk.vc_bgkzt,
                       bgk.dt_bgrq,
                       bgk.vc_icd10,
                       bgk.vc_sfcf,
                       bgk.dt_cjsj,
                       bgk.DT_YYSHSJ,
                       bgk.DT_QXSHSJ,
                       bgk.DT_SFSJ,
                       bgk.dt_cfsj,
                       bgk.vc_bgdw,
                       hzxx.vc_hzxm,
                       hzxx.vc_hzxb,
                       hzxx.vc_sfzh,
                       hzxx.dt_hzcsrq,
                       hzxx.VC_HKSFDM,
                       hzxx.VC_HKSDM,
                       hzxx.VC_HKQXDM,
                       hzxx.VC_HKJDDM,
                       hzxx.VC_HKJWDM,
                       hzxx.VC_HKXXDZ,
                       bgk.vc_gldw,
                       bgk.vc_shwtgyy,
                       bgk.vc_shwtgyy1,
                       count(1) over() as total
                  from ZJJK_ZL_BGK bgk, ZJJK_ZL_HZXX hzxx
                 where BGK.VC_HZID = HZXX.VC_PERSONID
                   and BGK.vc_scbz = '0'
                   AND (BGK.VC_CJDW like #{vc_gldw}|| '%' OR bgk.VC_GLDW like #{vc_gldw}|| '%')
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
                       AND instr(#{vc_shbz},BGK.VC_SHBZ)  > 0
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
                       and bgk.DT_ZDRQ >= std(#{dt_zdrq_ks},1)
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_zdrq_js}))>
                       and bgk.DT_ZDRQ <= std(#{dt_zdrq_js},1)
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_bgrq_ks}))>
                       and bgk.dt_bgrq >= std(#{dt_bgrq_ks},1)
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_bgrq_js}))>
                       and bgk.dt_bgrq <= std(#{dt_bgrq_js},1)
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_xm}))>
                       and hzxx.vc_hzxm like '%'|| #{vc_xm} || '%'
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_cjsj_ks}))>
                       and bgk.dt_cjsj >= std(#{dt_cjsj_ks},1)
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_cjsj_js}))>
                       and bgk.dt_cjsj <= std(#{dt_cjsj_js},1)
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_qxshsj_ks}))>
                       and bgk.dt_qxshsj >= std(#{dt_qxshsj_ks},1)
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_qxshsj_js}))>
                       and bgk.dt_qxshsj <= std(#{dt_qxshsj_js},1)
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
                 order by bgk.dt_cjsj, bgk.vc_bgkid)
         where rownum <= #{rn_e})
 where rn >= #{rn_s}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                