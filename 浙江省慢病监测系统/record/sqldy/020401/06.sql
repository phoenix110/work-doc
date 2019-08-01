select vc_bgkid,
       vc_bgkbh,
       vc_hzxm,
       decode(vc_hzxb,'1','男','2','女') vc_hzxb,
       dts(dt_hzcsrq,0) dt_hzcsrq,
       vc_hzsfzh,
       vc_hzjtdh,
       (case when vc_gxbzd is null then '1' else '2' end) bzfl,
       decode(vc_mqjzs,
              '0',
              '浙江省' ||
              pkg_zjmb_tnb.fun_getxzqhmc(vc_mqjzsi) ||
              pkg_zjmb_tnb.fun_getxzqhmc(vc_mqjzqx) ||
              pkg_zjmb_tnb.fun_getxzqhmc(vc_mqjzjd) ||
              vc_czhkjw||vc_czhkxxdz,
              '1',
              '外省') jzdz_text,
       decode(vc_czhks,
              '0',
              '浙江省' ||
              pkg_zjmb_tnb.fun_getxzqhmc(vc_czhksi) ||
              pkg_zjmb_tnb.fun_getxzqhmc(vc_czhkqx) ||
              pkg_zjmb_tnb.fun_getxzqhmc(vc_czhkjd) ||
              vc_czhkjw||vc_czhkxxdz,
              '1',
              '外省') hjdz_text,
       dts(dt_qxshsj,0) dt_qxshsj,
       dts(dt_sfsj,0) dt_sfsj,
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
              vc_kzt,
        decode(vc_kzt,
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
              vc_kzt) vc_bgkzt_text,
       total,
       rn
  from (select vc_bgkid,
               vc_bgkbh,
               vc_kzt,
               vc_hzxm,
               vc_hzxb,
               dt_hzcsrq,
               vc_hzsfzh,
               vc_hzjtdh,
               vc_czhks,
               vc_czhksi,
               vc_czhkqx,
               vc_czhkjd,
               vc_czhkjw,
               vc_czhkxxdz,
               vc_mqjzs,
               vc_mqjzsi,
               vc_mqjzqx,
               vc_mqjzjd,
               vc_mqjzjw,
               vc_mqxxdz,
               vc_gxbzd,
               dt_qxshsj,
               dt_sfsj,
               vc_shbz,
               total,
               rownum as rn
          from (select bgk.vc_bgkid,
                       bgk.vc_bgkbh,
                       bgk.vc_kzt,
                       bgk.vc_hzxm,
                       bgk.vc_hzxb,
                       bgk.dt_hzcsrq,
                       bgk.vc_hzsfzh,
                       bgk.vc_hzjtdh,
                       bgk.vc_czhks,
                       bgk.vc_czhksi,
                       bgk.vc_czhkqx,
                       bgk.vc_czhkjd,
                       bgk.vc_czhkjw,
                       bgk.vc_czhkxxdz,
                       bgk.vc_mqjzs,
                       bgk.vc_mqjzsi,
                       bgk.vc_mqjzqx,
                       bgk.vc_mqjzjd,
                       bgk.vc_mqjzjw,
                       bgk.vc_mqxxdz,
                       bgk.vc_gxbzd, 
                       bgk.dt_qxshsj,
                       bgk.dt_sfsj,
                       bgk.vc_shbz,
                       count(1) over() as total
                  from zjjk_xnxg_bgk bgk
									LEFT JOIN zjjk_xnxg_bgk_zfgx b on bgk.vc_bgkid=b.vc_fkid
                 where 1=1 AND decode(vc_zkid, vc_fkid, '主卡', '副卡') = '主卡'
                   and bgk.VC_SHBZ in ('3', '5', '6', '7', '8')
                   and bgk.VC_SDQRZT = '1'
                   and bgk.vc_scbz = '2'
                   and bgk.vc_kzt in ('0', '2', '3', '6', '7')
                  and (bgk.VC_CJDWDM like #{vc_gldw} || '%' or
                        bgk.VC_GLDWDM like #{vc_gldw} || '%')
                 <if if("1".equals(#{vc_sfcf}))>
                      and (bgk.vc_sfcf in ('1', '3'))
                 </if>
                 <if if("0".equals(#{vc_sfcf}))>
                      and nvl(bgk.vc_sfcf, '2') = '2' 
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_bgkzt}))>
                     and bgk.vc_kzt = #{vc_bgkzt}
                 </if>
                 <if if(StringUtils.isNotBlank(#{dt_cfrq_ks}) )>
                      and bgk.DT_CFSJ >= std(#{dt_cfrq_ks},'1')
                 </if>
                 <if if(StringUtils.isNotBlank(#{dt_cfrq_js}))>
                      and bgk.DT_CFSJ <= std(#{dt_cfrq_js},'1')
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_bgkcode}))>
                      and bgk.vc_bgkbh = #{vc_bgkcode}
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_hzxm}))>
                      and bgk.vc_hzxm like '%'||#{vc_hzxm}||'%'
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_hzxb}))>
                      and bgk.vc_hzxb = #{vc_hzxb}
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_sfzh}))>
                      and bgk.vc_hzsfzh = #{vc_sfzh}
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_hks}))>
                      and bgk.vc_czhksi = #{vc_hks}
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_hkqx}))>
                      and bgk.vc_czhkqx = #{vc_hkqx}
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_hkjd}))>
                      and bgk.vc_czhkjd = #{vc_hkjd}
                 </if>
                 <if if(StringUtils.isNotBlank(#{jgszqh}))>  
                     and bgk.vc_czhkjd like #{jgszqh} || '%'  
                 </if>  
                 order by bgk.DT_SFSJ)
         where rownum <= #{rn_e})
 where rn >= #{rn_s}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             