select vc_bgkid,
       vc_bgkzt,
       vc_hzxm,
       decode(vc_hzxb,'1','男','2','女') vc_hzxb,
       dts(dt_hzcsrq,0) dt_hzcsrq,
       vc_sfzh,
       VC_JTDH,
       decode(VC_SJSFDM,
              '0',
              '浙江省' ||
              pkg_zjmb_tnb.fun_getxzqhmc(VC_SJSDM) ||
              pkg_zjmb_tnb.fun_getxzqhmc(VC_SJQXDM) ||
              pkg_zjmb_tnb.fun_getxzqhmc(VC_SJJDDM) ||
              VC_SJJWDM||VC_SJXXDZ,
              '1',
              '外省') jzdz_text,
       decode(VC_HKSFDM,
              '0',
              '浙江省' ||
              pkg_zjmb_tnb.fun_getxzqhmc(VC_HKSDM) ||
              pkg_zjmb_tnb.fun_getxzqhmc(VC_HKQXDM) ||
              pkg_zjmb_tnb.fun_getxzqhmc(VC_HKJDDM) ||
              VC_HKJWDM||VC_HKXXDZ,
              '1',
              '外省') hjdz_text,
       dts(dt_sczdrq,0) dt_sczdrq,
       dts(dt_qxshsj,0) dt_qxshsj,
       dts(dt_sfsj,0) dt_sfsj,
       dts(dt_sfrq,0) dt_sfrq,
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
       total,
       rn
  from (select vc_bgkid,
               vc_bgkzt,
               vc_hzxm,
               vc_hzxb,
               dt_hzcsrq,
               vc_sfzh,
               VC_JTDH,
               vc_hksfdm,
               vc_hksdm,
               vc_hkqxdm,
               vc_hkjddm,
               vc_hkjwdm,
               vc_hkxxdz,
               VC_SJSFDM,
               VC_SJSDM,
               VC_SJQXDM,
               VC_SJJDDM,
               VC_SJJWDM,
               VC_SJXXDZ,
               dt_sczdrq,
               dt_qxshsj,
               dt_sfsj,
               dt_sfrq,
               vc_shbz,
               total,
               rownum as rn
          from (select bgk.vc_bgkid,
                       bgk.vc_bgkzt,
                       hz.vc_hzxm,
                       hz.vc_hzxb,
                       hz.dt_hzcsrq,
                       hz.vc_sfzh,
                       hz.VC_JTDH,
                       hz.vc_hksfdm,
                       hz.vc_hksdm,
                       hz.vc_hkqxdm,
                       hz.vc_hkjddm,
                       hz.VC_HKJWDM,
                       hz.VC_HKXXDZ,
                       hz.VC_SJSFDM,
                       hz.VC_SJSDM,
                       hz.VC_SJQXDM,
                       hz.VC_SJJDDM,
                       hz.VC_SJJWDM,
                       hz.VC_SJXXDZ,
                       bgk.dt_sczdrq,
                       bgk.dt_qxshsj,
                       bgk.dt_sfsj,
                       bgk.dt_sfrq,
                       bgk.vc_shbz,
                       count(1) over() as total
                  from zjjk_zl_bgk bgk
									LEFT JOIN zjjk_zl_bgk_zfgx b on bgk.vc_bgkid = b.vc_fkid
									, zjjk_zl_hzxx hz
                 where bgk.vc_hzid = hz.vc_personid
									AND decode(b.vc_zkid, b.vc_fkid, '主卡', '副卡') = '主卡'
                   and bgk.VC_SHBZ in ('3' , '5' , '6' , '7' , '8')
                   and bgk.VC_SDQRZT = '1'
                   and bgk.vc_bgkzt in ( '0' , '2' , '3' , '6' , '7' )
                  and (bgk.VC_CJDW like #{vc_gldw} || '%' or
                        bgk.VC_GLDW like #{vc_gldw} || '%')
                 <if if(StringUtils.isNotBlank(#{vc_sfcf}) && "1".equals(#{vc_sfcf}))>
                      and (bgk.vc_sfcf in ('1', '3'))
                 </if>
                 <if if("2".equals(#{vc_sfcf}))>
                      and nvl(bgk.vc_sfcf, '2') = #{vc_sfcf}
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_bgkzt}))>
                     and bgk.VC_BGKZT = #{vc_bgkzt}
                 </if>
                 
                 <if if(StringUtils.isNotBlank(#{dt_cfrq_ks}))>
                      and bgk.DT_CFSJ >= std(#{dt_cfrq_ks},'1')
                 </if>
                 <if if(StringUtils.isNotBlank(#{dt_cfrq_js}))>
                      and bgk.DT_CFSJ <= std(#{dt_cfrq_js},'1')
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_bgkcode}))>
                      and bgk.vc_bgkid = #{vc_bgkcode}
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_hzxm}))>
                      and hz.vc_hzxm like '%'||#{vc_hzxm}||'%'
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_hzxb}))>
                      and hz.vc_hzxb = #{vc_hzxb}
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_sfzh}))>
                      and hz.vc_sfzh = #{vc_sfzh}
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_hks}))>
                      and hz.VC_HKSDM = #{vc_hks}
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_hkqx}))>
                      and hz.VC_HKQXDM = #{vc_hkqx}
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_hkjd}))>
                      and hz.VC_HKJDDM = #{vc_hkjd}
                 </if>
                 <if if(StringUtils.isNotBlank(#{jgszqh}))>  
                     and hz.VC_HKJDDM like #{jgszqh} || '%'  
                 </if>  
                 order by bgk.DT_SFSJ)
         where rownum <= #{rn_e})
 where rn >= #{rn_s}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  