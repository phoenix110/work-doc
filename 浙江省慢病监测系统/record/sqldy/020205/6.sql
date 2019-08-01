select vc_bgkid,
       vc_bgkcode,
       vc_hzxm,
       decode(vc_hzxb, '1', '男', '2', '女') vc_hzxb,
       dts(dt_hzcsrq, 0) dt_hzcsrq,
       vc_sfzh,
       vc_lxdh,
       decode(vc_jzds,
              '0',
              '浙江省' ||
              pkg_zjmb_tnb.fun_getxzqhmc(vc_jzs) ||
              pkg_zjmb_tnb.fun_getxzqhmc(vc_jzqx) ||
              pkg_zjmb_tnb.fun_getxzqhmc(vc_jzjd) ||
              vc_jzjw||vc_jzxxdz,
              '1',
              '外省') jzdz_text,
       decode(vc_hkshen,
              '0',
              '浙江省' ||
              pkg_zjmb_tnb.fun_getxzqhmc(vc_hks) ||
              pkg_zjmb_tnb.fun_getxzqhmc(vc_hkqx) ||
              pkg_zjmb_tnb.fun_getxzqhmc(vc_hkjd) ||
              vc_hkjw||vc_hkxxdz,
              '1',
              '外省') hjdz_text,
       dt_sczdrq dt_sczdrq,
       dt_qxshsj dt_qxshsj,
       dt_sfsj dt_sfsj,
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
               vc_bgkcode,
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
                       to_char(bgk.dt_sczdrq, 'yyyy-mm-dd') dt_sczdrq,
                       to_char(bgk.dt_qxshsj, 'yyyy-mm-dd') dt_qxshsj,
                       to_char(bgk.dt_sfsj, 'yyyy-mm-dd') dt_sfsj,
                       bgk.vc_shbz,
                       count(1) over() as total
                  from zjjk_tnb_bgk bgk, zjjk_tnb_hzxx hz
                 where bgk.vc_hzid = hz.vc_personid
                   and bgk.vc_cfzt in ('1', '3')
                   and bgk.vc_bgkzt = '0'
                   and bgk.vc_tnblx in ('1', '2', '4')
                   and bgk.vc_scbz = '0'
                   and bgk.vc_shbz in ('3', '5', '6', '7', '8')
                   and bgk.vc_sdqrzt = '1'
                   and bgk.vc_gldw like #{vc_gldw} || '%'
                   <if if(StringUtils.isNotBlank(#{vc_hks}))>
                       and (hz.vc_hks like #{vc_hks})
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkqx}))>
                       and (hz.vc_hkqx like #{vc_hkqx})
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkjd}))>
                       and (hz.vc_hkjd like #{vc_hkjd})
                   </if>
                   <if if(StringUtils.isBlank(#{dt_sfsj_ks}) && StringUtils.isBlank(#{dt_sfsj_js}))>
                       and bgk.dt_sfsj <= add_months(sysdate,-11)
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_sfsj_ks}))>
                       and bgk.dt_sfsj >= std(#{dt_sfsj_ks},1)
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_sfsj_js}))>
                       and bgk.dt_sfsj <= std(#{dt_sfsj_js},1)
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hzxm}))>
                       and hz.vc_hzxm like '%'||#{vc_hzxm}||'%'
                   </if>
                    <if if(StringUtils.isNotBlank(#{jgszqh}))>  
                       and hz.vc_hkjd like #{jgszqh} || '%'  
                    </if>  
                 order by bgk.dt_sfsj)
         where rownum <= #{rn_e})
 where rn >= #{rn_s}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              