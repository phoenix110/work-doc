select vc_bgkid,
       vc_bgkbh,
       vc_bgklx,
       vc_kzt,
       dts(dt_qzrq,0) dt_qzrq,
       dts(dt_cjsj,0) dt_cjsj,
       dts(DT_YYSHSJ,0) DT_YYSHSJ,
       dts(DT_QXSHSJ,0) DT_QXSHSJ,
       dts(dt_sfsj,0) dt_sfsj,
       vc_hzjtdh,
       dts(dt_cfsj,0) dt_cfsj,
       vc_sfcf,
       vc_shbz,
       dts(dt_hzcsrq,0) dt_hzcsrq,
       GetAge(dt_hzcsrq) nl,
       vc_hzxm,
       vc_hzxb,
       VC_HZSFZH,
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
       decode(vc_hzxb, '1', '男', '2', '女') vc_hzxb_text,
       decode(vc_czhks,
              '0',
              '浙江省' ||
              pkg_zjmb_tnb.fun_getxzqhmc(vc_czhksi) ||
              pkg_zjmb_tnb.fun_getxzqhmc(vc_czhkqx) ||
              pkg_zjmb_tnb.fun_getxzqhmc(vc_czhkjd) ||
              vc_czhkjw||vc_czhkxxdz,
              '1',
              '外省') hkdz_text,      
       total,
       rn
  from (select vc_bgkid,
               vc_bgkbh,
               vc_bgklx,
               vc_shbz,
               vc_kzt,
               dt_qzrq,
               dt_cjsj,
               DT_YYSHSJ,
               DT_QXSHSJ,
               dt_sfsj,
               vc_hzjtdh,
               dt_cfsj,
               vc_sfcf,
               vc_czhks,
               vc_czhksi,
               vc_czhkqx,
               vc_czhkjd,
               vc_czhkjw,
               vc_czhkxxdz,
               vc_hzxm,
               vc_hzxb,
               VC_HZSFZH,
               dt_hzcsrq,
               total,
               rownum as rn
          from (select bgk.vc_bgkid,
                       bgk.vc_bgkbh,
                       bgk.vc_bgklx,
                       bgk.vc_shbz,
                       bgk.vc_kzt,
                       bgk.dt_qzrq,
                       bgk.vc_sfcf,
                       bgk.dt_cjsj,
                       bgk.DT_YYSHSJ,
                       bgk.DT_QXSHSJ,
                       bgk.DT_SFSJ,
                       bgk.vc_hzjtdh,
                       bgk.dt_cfsj,
                       bgk.vc_czhks,
                       bgk.vc_czhksi,
                       bgk.vc_czhkqx,
                       bgk.vc_czhkjd,
                       bgk.vc_czhkjw,
                       bgk.vc_czhkxxdz,
                       bgk.vc_hzxm,
                       bgk.vc_hzxb,
                       bgk.VC_HZSFZH,
                       bgk.DT_HZCSRQ,
                       count(1) over() as total
                  from zjjk_xnxg_bgk bgk
 where bgk.VC_KZT = '0'
   and bgk.DT_SFSJ < add_months(sysdate, -11)
   and bgk.VC_SCBZ = '2'
   and bgk.VC_SDQRZT = '1'
   and bgk.VC_SHBZ in ('3', '5', '6', '7', '8')
   and bgk.VC_SFCF in ('1', '3')
   AND bgk.vc_gldwdm like #{vc_gldw}|| '%'
   <if if(StringUtils.isNotBlank(#{vc_hzxm}))>
     and bgk.vc_hzxm like '%'||#{vc_hzxm}||'%'
  </if>
  <if if(StringUtils.isNotBlank(#{dt_sfrq_ks}))>
     and bgk.dt_sfrq >= std(#{dt_sfrq_ks},1)
  </if>
  <if if(StringUtils.isNotBlank(#{dt_sfrq_js}))>
     and bgk.dt_sfrq <= std(#{dt_sfrq_js},1)
  </if>

                  <if if(StringUtils.isNotBlank(#{vc_hkshen}))>
                     and bgk.vc_czhks = #{vc_hkshen}
                  </if>
                  <if if(StringUtils.isNotBlank(#{vc_hksdm}))>
                     and bgk.vc_czhksi = #{vc_hks}
                  </if>
                  <if if(StringUtils.isNotBlank(#{vc_hkqxdm}))>
                     and bgk.vc_czhkqx = #{vc_hkqx}
                  </if>
                  <if if(StringUtils.isNotBlank(#{vc_hkjddm}))>
                     and bgk.vc_czhkjd = #{vc_hkjd}
                  </if>
                  <if if(StringUtils.isNotBlank(#{vc_hkjw}))>
                     and bgk.vc_czhkjw = #{vc_hkjw}
                  </if>
   order by bgk.vc_bgkid)
         where rownum <= #{rn_e})
 where rn >= #{rn_s}                                                                                                                                                                                                                                                                                                                                                                                                                   
