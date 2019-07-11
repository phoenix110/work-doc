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
       vc_hzicd,
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
        vc_gldwdm,  
        vc_shwtgyy,   
        vc_shwtgyy1,   
        (select d.mc from p_yljg d where d.dm= vc_bkdwyy) vc_bgdw_mc,
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
               vc_gldwdm,
               vc_hzxm,
               vc_hzxb,
               VC_HZSFZH,
               vc_hzicd,
               dt_hzcsrq,
               vc_shwtgyy,
               vc_shwtgyy1,
               vc_bkdwyy,
               total,
               rownum as rn
          from (select /*+INDEX(BGK INDEX_XNXG_GLDW)*/ bgk.vc_bgkid,
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
                       bgk.vc_gldwdm,
                       bgk.vc_hzxm,
                       bgk.vc_hzxb,
                       bgk.VC_HZSFZH,
                       bgk.vc_hzicd,
                       bgk.DT_HZCSRQ,
                       bgk.vc_shwtgyy,
                       bgk.vc_shwtgyy1,
                       bgk.vc_bkdwyy,
                       count(1) over() as total
                  from zjjk_xnxg_bgk bgk
                 where  BGK.vc_scbz = '2'
                   <if if(StringUtils.isNotBlank(#{jgszqh}))>
                     AND (bgk.vc_cjdwdm  like #{vc_gldw}|| '%' OR bgk.vc_gldwdm like #{vc_gldw}|| '%' or bgk.vc_czhkjd like #{jgszqh} || '%')
                   </if>
                   <if if(StringUtils.isBlank(#{jgszqh}))>
                     AND (bgk.vc_cjdwdm  like #{vc_gldw}|| '%' OR bgk.vc_gldwdm like #{vc_gldw}|| '%')
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_bghks}))>
                       and BGK.vc_bkdw = #{vc_bghks}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_bghkqx}))>
                       and BGK.vc_bkdwqx = #{vc_bghkqx}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_bgdw}))>
                       and BGK.vc_bkdwyy = #{vc_bgdw}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_bgkbh}))>
                       and BGK.vc_bgkbh = #{vc_bgkbh}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hzxb}))>
                       and BGK.Vc_Hzxb = #{vc_hzxb}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hzzy}))>
                       and BGK.vc_hzzy = #{vc_hzzy}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hzicd}))>
                       and BGK.VC_HZICD LIKE '%'||#{vc_hzicd}||'%'
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_sfzh}))>
                       and BGK.VC_HZSFZH = #{vc_sfzh}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_zyh}))>
                       and BGK.vc_zyh = #{vc_zyh}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_mzh}))>
                       and BGK.VC_MZH = #{vc_mzh}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_xm}))>
                       and BGK.vc_hzxm like '%' || #{vc_xm} || '%'
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_shbz}))>
                       AND instr(#{vc_shbz},BGK.VC_SHBZ) > 0 
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_bgkzt}))>
                       and BGK.vc_kzt = #{vc_bgkzt}
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_bgrq_ks}))>
                       and bgk.dt_bkrq >= std(#{dt_bgrq_ks},1)
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_bgrq_js}))>
                       and bgk.dt_bkrq <= std(#{dt_bgrq_js},1)
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_swrq_ks}))>
                       and bgk.dt_swrq >= std(#{dt_swrq_ks},1)
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_swrq_js}))>
                       and bgk.dt_swrq <= std(#{dt_swrq_js},1)
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
                       and bgk.vc_bksznl >= to_number(#{vc_sznl_ks})
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_sznl_js}))>
                       and bgk.vc_bksznl <=to_number(#{vc_sznl_js})
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_fbrq_ks}))>
                       and getage(bgk.dt_fbrq) >= to_number(#{dt_fbrq_ks})
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_fbrq_js}))>
                       and getage(bgk.dt_fbrq) <=to_number(#{dt_fbrq_js})
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkshen}))>
                       and bgk.VC_CZHKS = #{vc_hkshen}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hks}))>
                       and (bgk.VC_CZHKSI = #{vc_hks})
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkqx}))>
                       and bgk.vc_czhkqx = #{vc_hkqx}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkjd}))>
                       and bgk.vc_czhkjd = #{vc_hkjd}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkjw}))>
                       and bgk.vc_czhkjw = #{vc_hkjw}
                   </if>
                   <if if("1".equals(#{vc_isrq}))>
                       and bgk.VC_GXBZD in ('1','2','3')
                   </if>
                   <if if("1".equals(#{vc_isrq}) && StringUtils.isNotBlank(#{vc_zdyj}))>
                       and bgk.Vc_Gxbzd = #{vc_zdyj}
                   </if>
                    <if if("2".equals(#{vc_isrq}))>
                       and bgk.VC_NCZZD in ('1','2','3','4','5','6')
                   </if>
                   <if if("2".equals(#{vc_isrq}) && StringUtils.isNotBlank(#{vc_zdyj}))>
                       and bgk.Vc_Nczzd = #{vc_zdyj}
                   </if>
                 order by bgk.dt_cfsj, bgk.vc_bgkid)
         where rownum <= #{rn_e})
 where rn >= #{rn_s}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   