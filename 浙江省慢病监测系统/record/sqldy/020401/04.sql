select vc_bgkid,
       vc_bgkbh,
       vc_bgklx,
       vc_kzt,
       dts(dt_qzrq,0) dt_qzrq,
       dts(dt_cjsj,0) dt_cjsj,
       dts(DT_YYSHSJ,0) DT_YYSHSJ,
       dts(DT_QXSHSJ,0) DT_QXSHSJ,
       dts(dt_sfsj,0) dt_sfsj,
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
              VC_HZJTDH,
              (case when vc_gxbzd is null then '脑卒中' else '冠心病' end) jbmc,   
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
               VC_HZJTDH,
               vc_gxbzd,
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
                       bgk.VC_HZJTDH,
                       bgk.vc_gxbzd,
                       count(1) over() as total
                  from zjjk_xnxg_bgk bgk
                  where  BGK.vc_scbz = '2'
                   AND bgk.vc_gldwdm like #{vc_gldw}|| '%'
                   AND BGK.VC_SFCF = '2'
                   AND BGK.VC_KZT = '0'
                   AND BGK.VC_SDQRZT = '1'
                   AND BGK.VC_SHBZ IN ('3','5','6','7','8')
                   and bgk.vc_czhks = '0'
                   and to_number(to_char(bgk.dt_cjsj,'yyyy')) >= (to_number(to_char(SYSDate, 'YYYY')) - 1)
                   <if if(StringUtils.isNotBlank(#{vc_hzxm}))>
                       and BGK.vc_hzxm like '%'||#{vc_hzxm}||'%'
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_qxshsj_ks}))>
                       and bgk.DT_QXSHSJ >= std(#{dt_qxshsj_ks},1)
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_qxshsj_js}))>
                       and bgk.DT_QXSHSJ <= std(#{dt_qxshsj_js},1)
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hksdm}))>
                       and bgk.VC_CZHKSI = #{vc_hksdm}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkqxdm}))>
                       and bgk.VC_CZHKQX = #{vc_hkqxdm}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkjddm}))>
                       and bgk.VC_CZHKJD = #{vc_hkjddm}
                   </if>
                   <if if(StringUtils.isNotBlank(#{jgszqh}))>  
                       and bgk.VC_CZHKJD like #{jgszqh} || '%'  
                   </if>  
                   
                   <if if("vc_hzxm".equals(#{orderField}) && "asc".equals(#{orderType}))>
                     order by nlssort(bgk.vc_hzxm, 'NLS_SORT=SCHINESE_PINYIN_M') asc
                   </if>
                   <if if("vc_hzxm".equals(#{orderField}) && "desc".equals(#{orderType}))>
                     order by nlssort(bgk.vc_hzxm, 'NLS_SORT=SCHINESE_PINYIN_M') desc
                   </if>
                   <if if("vc_hzxb_text".equals(#{orderField}) && "asc".equals(#{orderType}))>
                     order by bgk.vc_hzxb asc
                   </if>
                   <if if("vc_hzxb_text".equals(#{orderField}) && "desc".equals(#{orderType}))>
                     order by bgk.vc_hzxb desc
                   </if>
                   <if if("dt_qxshsj".equals(#{orderField}) && "asc".equals(#{orderType}))>
                     order by bgk.dt_qxshsj asc
                   </if>
                   <if if("dt_qxshsj".equals(#{orderField}) && "desc".equals(#{orderType}))>
                     order by bgk.dt_qxshsj desc
                   </if>
                   <if if(StringUtils.isBlank(#{orderField}))>
                     order by bgk.DT_CJSJ
                   </if>
                   
                 )
         where rownum <= #{rn_e})
 where rn >= #{rn_s}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  