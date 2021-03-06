select vc_bgkid,
       vc_bgklx,
       vc_bgkzt,
       vc_bgkbh,
       vc_icd10,
       dts(dt_bgrq,0) dt_bgrq,
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
             vc_jtdh,   
       total,
       rn
  from (select vc_bgkid,
               vc_bgklx,
               vc_shbz,
               vc_bgkbh,
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
               vc_jtdh,
               total,
               rownum as rn
          from (select bgk.vc_bgkid,
                       bgk.vc_bgklx,
                       bgk.vc_shbz,
                       bgk.vc_bgkbh,
                       bgk.vc_kzt vc_bgkzt,
                       bgk.dt_bkrq dt_bgrq,
                       bgk.VC_HZICD vc_icd10,
                       bgk.vc_sfcf,
                       bgk.dt_cjsj,
                       bgk.DT_YYSHSJ,
                       bgk.DT_QXSHSJ,
                       bgk.DT_SFSJ,
                       bgk.dt_cfsj,
                       bgk.vc_hzxm,
                       bgk.vc_hzxb,
                       bgk.VC_HZSFZH vc_sfzh,
                       bgk.dt_hzcsrq,
                       bgk.VC_CZHKS VC_HKSFDM,
                       bgk.VC_CZHKSI VC_HKSDM,
                       bgk.VC_CZHKQX VC_HKQXDM,
                       bgk.VC_CZHKJD VC_HKJDDM,
                       bgk.VC_CZHKJW VC_HKJWDM,
                       bgk.VC_CZHKXXDZ VC_HKXXDZ,
                       bgk.VC_HZJTDH vc_jtdh,
                       count(1) over() as total
                  from ZJJK_XNXG_BGK bgk
                 where bgk.vc_gldwdm like #{vc_gldw} || '%'
                   and bgk.VC_CZHKQX like #{jgqxdm}||'%'
                   and bgk.vc_scbz = '2'
                   and bgk.vc_qcbz = '1'
                   and bgk.vc_shbz in ('3','5','6','7','8')
                   <if if(StringUtils.isNotBlank(#{vc_bgkcode}))>
                     and bgk.vc_bgkid like #{vc_bgkcode}||'%'
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hzxm}))>
                     and bgk.vc_hzxm like '%'||#{vc_hzxm}||'%'
                   </if>
                   order by bgk.vc_bgkid)
         where rownum <= #{rn_e})
 where rn >= #{rn_s}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                