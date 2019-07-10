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
       decode(vc_shbz,
              '0',
              '医院未审核',
              '1',
              '医院审核通过',
              '2',
              '医院审核未通过',
              '3',
              '区县审核通过',
              '4',
              '区县审核未通过',
              '5',
              '市审核通过',
              '6',
              '市审核不通过',
              '7',
              '省审核通过',
              '8',
              '省审核不通过',
              vc_shbz) vc_shbz_text,
       
       decode(vc_bgkzt,
              '0',
              '可用卡',
              '2',
              '死卡',
              '3',
              '误诊卡',
              '4',
              '重复卡',
              '6',
              '失访卡',
              '5',
              '删除卡',
              '7',
              '死亡卡',
              vc_bgkzt) vc_bgkzt_text,
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
               dt_hzcsrq,
               DT_YYSHSJ,
               DT_QXSHSJ,
               dt_sfsj,
               dt_cfsj,
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
               total,
               rownum as rn
          from (select bgk.vc_bgkid,
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
                 where BGK.VC_HZID = HZXX.VC_PERSONID
                   and BGK.vc_scbz = '0'
                   AND bgk.VC_GLDW like #{vc_gldw}|| '%'
                   and bgk.VC_SHBZ = '3'
                  
                   <if if(StringUtils.isNotBlank(#{vc_bgkid}))>
                       and BGK.VC_BGKID = #{vc_bgkid}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hzxb}))>
                       and hzxx.Vc_Hzxb = #{vc_hzxb}
                   </if>
                  
                   <if if(StringUtils.isNotBlank(#{dt_zdrq_ks}))>
                       and bgk.dt_zdrq >= std(#{dt_zdrq_ks},1)
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_zdrq_js}))>
                       and bgk.dt_zdrq <= std(#{dt_zdrq_js},1)
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_bgrq_ks}))>
                       and bgk.dt_bgrq >= std(#{dt_bgrq_ks},1)
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_bgrq_js}))>
                       and bgk.dt_bgrq <= std(#{dt_bgrq_js},1)
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_xm}))>
                       and hzxx.vc_hzxm like '%' ||#{vc_xm} || '%'
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
                 order by bgk.vc_bgkid)
         where rownum <= #{rn_e})
 where rn >= #{rn_s}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                