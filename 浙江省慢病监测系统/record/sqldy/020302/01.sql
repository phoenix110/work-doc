select vc_bgkid,
       vc_bgklx,
       vc_hzid,
       vc_bgkzt,
       vc_icd10,
       dts(dt_bgrq,0) dt_bgrq,
       dts(dt_cjsj,0) dt_cjsj,
       vc_mzh,
       vc_zyh,
       vc_icd9,
       vc_bqygzbr,
       vc_bksznl,
       dts(DT_YYSHSJ,0) DT_YYSHSJ,
       dts(DT_QXSHSJ,0) DT_QXSHSJ,
       dts(dt_sfsj,0) dt_sfsj,
       dts(dt_cfsj,0) dt_cfsj,
       VC_JTDH,
       dts(dt_sczdrq,0) dt_sczdrq,
       dts(dt_hzcsrq,0) dt_hzcsrq,
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
               vc_mzh,
               vc_zyh,
               vc_icd9,
               vc_bqygzbr,
               vc_bksznl,
               dt_hzcsrq,
               DT_YYSHSJ,
               DT_QXSHSJ,
               dt_sfsj,
               dt_cfsj,
               dt_sczdrq,
               VC_JTDH,
               vc_hzxm,
               vc_hzxb,
               vc_sfzh,
               VC_HKSFDM,
               VC_HKSDM,
               VC_HKQXDM,
               VC_HKJDDM,
               VC_HKJWDM,
               VC_HKXXDZ,
               total,
               rownum as rn
          from (select bgk.vc_bgkid,
                       bgk.vc_bgklx,
                       bgk.vc_hzid,
                       bgk.vc_shbz,
                       bgk.vc_bgkzt,
                       bgk.dt_bgrq,
                       bgk.vc_icd10,
                       bgk.dt_cjsj,
                       bgk.DT_YYSHSJ,
                       bgk.DT_QXSHSJ,
                       bgk.DT_SFSJ,
                       bgk.dt_cfsj,
                       bgk.vc_mzh,
                       bgk.vc_zyh,
                       bgk.vc_icd9,
                       bgk.vc_bqygzbr,
                       vc_bksznl,
                       bgk.dt_sczdrq,
                       hzxx.VC_JTDH,
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
                       count(1) over() as total
                  from ZJJK_ZL_BGK bgk, ZJJK_ZL_HZXX hzxx
                 where bgk.VC_HZID = HZXX.VC_PERSONID
                   and bgk.VC_GLDW like #{vc_gldw}|| '%'
                   and bgk.VC_SHBZ in ('3', '5', '6', '7', '8')
                   and bgk.VC_BGKZT = '0'
                   and bgk.VC_SFCF = '2'
                   and bgk.VC_SDQRZT ='1'
                   and bgk.VC_SCBZ = '0'
                   and hzxx.vc_hksfdm = '0'
                   and to_number(to_char(bgk.dt_cjsj,'yyyy')) >= (to_number(to_char(SYSDate, 'YYYY')) - 1)
                   <if if(StringUtils.isNotBlank(#{vc_hzxm}))>
                       and hzxx.vc_hzxm like '%'||#{vc_hzxm}||'%'
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_qxshsj_ks}))>
                       and bgk.DT_QXSHSJ >= std(#{dt_qxshsj_ks},1)
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_qxshsj_js}))>
                       and bgk.DT_QXSHSJ <= std(#{dt_qxshsj_js},1)
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkshen}))>
                       and hzxx.VC_HKSFDM = #{vc_hkshen}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hksdm}))>
                       and (hzxx.VC_HKSDM = #{vc_hksdm})
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkqxdm}))>
                       and hzxx.VC_HKQXDM = #{vc_hkqxdm}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkjddm}))>
                       and hzxx.VC_HKJDDM = #{vc_hkjddm}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkjw}))>
                       and hzxx.VC_HKJWDM = #{vc_hkjw}
                   </if>
                 order by bgk.DT_CJSJ)
         where rownum <= #{rn_e})
 where rn >= #{rn_s}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        