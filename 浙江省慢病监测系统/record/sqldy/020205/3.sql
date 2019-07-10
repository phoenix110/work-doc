select vc_bgkid,
       vc_bgkcode,
       vc_bgkzt,
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_BGKZT',vc_bgkzt) vc_bgkzt_text,
       vc_hzxm,
       decode(vc_hzxb, '1', '男', '2', '女') vc_hzxb,
       dts(dt_hzcsrq, 0) dt_hzcsrq,
       vc_sfzh,
       vc_lxdh,
       decode(vc_jzds,
              '0',
              '浙江省' || pkg_zjmb_tnb.fun_getxzqhmc(vc_jzs) ||
              pkg_zjmb_tnb.fun_getxzqhmc(vc_jzqx) ||
              pkg_zjmb_tnb.fun_getxzqhmc(vc_jzjd) || vc_jzjw || vc_jzxxdz,
              '1',
              '外省') jzdz_text,
       decode(vc_hkshen,
              '0',
              '浙江省' || pkg_zjmb_tnb.fun_getxzqhmc(vc_hks) ||
              pkg_zjmb_tnb.fun_getxzqhmc(vc_hkqx) ||
              pkg_zjmb_tnb.fun_getxzqhmc(vc_hkjd) || vc_hkjw || vc_hkxxdz,
              '1',
              '外省') hjdz_text,
       dts(dt_sczdrq, 0) dt_sczdrq,
       dts(dt_qxshsj, 0) dt_qxshsj,
       dts(dt_sfsj, 0) dt_sfsj,
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_SHZT', vc_shbz) vc_shbz_text,
       total,
       rn
  from (select vc_bgkid,
               vc_bgkcode,
               vc_bgkzt,
               vc_hzxm,
               vc_hzxb,
               dt_hzcsrq,
               vc_sfzh,
               vc_lxdh,
               vc_hkshen,
               vc_hks,
               vc_hkqx,
               vc_hkjd,
               vc_hkjw,
               vc_hkxxdz,
               vc_jzds,
               vc_jzs,
               vc_jzqx,
               vc_jzjd,
               vc_jzjw,
               vc_jzxxdz,
               dt_sczdrq,
               dt_qxshsj,
               dt_sfsj,
               vc_shbz,
               total,
               rownum as rn
          from (select bgk.vc_bgkid,
                       bgk.vc_bgkcode,
                       bgk.vc_bgkzt,
                       hz.vc_hzxm,
                       hz.vc_hzxb,
                       hz.dt_hzcsrq,
                       hz.vc_sfzh,
                       hz.vc_lxdh,
                       hz.vc_hkshen,
                       hz.vc_hks,
                       hz.vc_hkqx,
                       hz.vc_hkjd,
                       hz.vc_hkjw,
                       hz.vc_hkxxdz,
                       hz.vc_jzds,
                       hz.vc_jzs,
                       hz.vc_jzqx,
                       hz.vc_jzjd,
                       hz.vc_jzjw,
                       hz.vc_jzxxdz,
                       bgk.dt_sczdrq,
                       bgk.dt_qxshsj,
                       bgk.dt_sfsj,
                       bgk.vc_shbz,
                       count(1) over() as total
                  from zjjk_tnb_bgk bgk
									LEFT JOIN zjjk_tnb_bgk_zfgx b ON bgk.vc_bgkid = b.vc_fkid
									, zjjk_tnb_hzxx hz
                 where bgk.vc_hzid = hz.vc_personid
										AND decode(b.vc_zkid, b.vc_fkid, '主卡', '副卡') = '主卡'
                   and bgk.VC_SCBZ = '0'
                   and bgk.VC_BGKZT in ('0', '2', '3', '6', '7')
                   and (bgk.VC_SHBZ in ('3', '5', '6', '7', '8'))
                   and (bgk.VC_SDQRZT = '1')
                   and (bgk.vc_gldw like #{vc_gldw} || '%')
                 <if if(StringUtils.isNotBlank(#{vc_bgkzt}))>
                    and bgk.VC_BGKZT = #{vc_bgkzt}
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_sfcf}) && "1".equals(#{vc_sfcf}))>
                      and bgk.vc_cfzt in ('1', '3')
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_sfcf}) && "0".equals(#{vc_sfcf}))>
                      and nvl(bgk.vc_cfzt, '0') = '0' 
                 </if>
                 <if if(StringUtils.isNotBlank(#{dt_cfrq_ks}))>
                      and bgk.DT_CFSJ >= std(#{dt_cfrq_ks},'1')
                 </if>
                 <if if(StringUtils.isNotBlank(#{dt_cfrq_js}))>
                      and bgk.DT_CFSJ <= std(#{dt_cfrq_js},'1')
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_bgkcode}))>
                      and bgk.vc_bgkcode = #{vc_bgkcode}
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
                      and hz.vc_hks = #{vc_hks}
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_hkqx}))>
                      and hz.vc_hkqx = #{vc_hkqx}
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_hkjd}))>
                      and hz.vc_hkjd = #{vc_hkjd}
                 </if>
                 order by bgk.DT_SFSJ)
         where rownum <= #{rn_e})
 where rn >= #{rn_s}                                                                                          