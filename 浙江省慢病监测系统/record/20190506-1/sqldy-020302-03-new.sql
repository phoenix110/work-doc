select vc_bgkid as vc_bgkid,
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_BGKLX', vc_bgklx) as vc_bgklx,
       vc_mzh,
       vc_zyh,
       vc_icd10,
       vc_icd9,
       vc_bqygzbr,
       vc_hzxm,
       vc_hzxb || '  ' ||
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_XB', vc_bgklx) as vc_hzxb,
       to_char(dt_hzcsrq, 'yyyy-mm-dd') as dt_hzcsrq,
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_BGKZT', vc_bgkzt) as vc_bgkzt,
       vc_zydm || '  ' || pkg_zjmb_tnb.fun_getcommdic('C_COMM_HY', vc_zydm) as vc_zydm,
       vc_jtgz || '  ' || pkg_zjmb_tnb.fun_getcommdic('C_COMM_ZY', vc_jtgz) as vc_jtgz,
       vc_bksznl,
       vc_hzmz || '  ' || pkg_zjmb_tnb.fun_getcommdic('C_COMM_MZ', vc_hzmz) as vc_hzmz,
       vc_sfzh as vc_sfzh,
       vc_gzdw,
       vc_jtdh as vc_jtdh,
       vc_hksfdm || '  ' ||
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_SHEDM', vc_hksfdm) as vc_hksfdm,
       vc_hksdm || '  ' ||
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_SJDM', vc_hksdm) as vc_hksdm,
       vc_hkqxdm || '  ' ||
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_QXDM', vc_hkqxdm) as vc_hkqxdm,
       vc_hkjddm || '  ' ||
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_JDDM', vc_hkjddm) as vc_hkjddm,
       vc_hkjwdm,
       vc_hkxxdz,
       vc_sjsfdm || '  ' ||
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_SHEDM', vc_sjsfdm) as vc_sjsfdm,
       vc_sjsdm || '  ' ||
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_SJDM', vc_sjsdm) as vc_sjsdm,
       vc_sjqxdm || '  ' ||
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_QXDM', vc_sjqxdm) as vc_sjqxdm,
       vc_sjjddm || '  ' ||
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_JDDM', vc_sjjddm) as vc_sjjddm,
       vc_sjjwdm,
       vc_sjxxdz,
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_ICDO',
                                   substr(vc_icdo,
                                          1,
                                          instr(vc_icdo, ',', -1) - 1)) as vc_icdO,
       vc_icdM as vc_icdm,
       vc_dlw,
       vc_blh,
       vc_zdqbt,
       vc_zdqbN,
       vc_zdqbM,
       vc_zdsqb,
       vc_zgzddw || '  ' ||
       pkg_zjmb_tnb.fun_getcommdic('C_XNXG_ZGZDDW', vc_zgzddw) as vc_zgzddw,
       to_char(dt_zdrq, 'yyyy-mm-dd') as dt_zdrq,
       vc_yzd,
       to_char(dt_yzdrq, 'yyyy-mm-dd') as dt_yzdrq,
       vc_bgdw || '  ' ||
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_YYDM', vc_bgdw) as vc_bgdw,
       vc_bgys,
       to_char(dt_bgrq, 'yyyy-mm-dd') as dt_bgrq,
       to_char(dt_swrq, 'yyyy-mm-dd') as dt_swrq,
       vc_swyy,
       vc_swicd10,
       vc_swicdmc,
       vc_zdyh,
       vc_bszy,
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_SHZT', vc_shbz) as vc_shbz,
       to_char(dt_cjsj, 'yyyy-mm-dd') as dt_cjsj,
       to_char(dt_yyshsj, 'yyyy-mm-dd') as dt_yyshsj,
       to_char(dt_qxshsj, 'yyyy-mm-dd') as dt_qxshsj,
       to_char(dt_cfsj, 'yyyy-mm-dd') as dt_cfsj,
       to_char(dt_sfrq, 'yyyy-mm-dd') as dt_sfrq,
       vc_blxlx,
       vc_gldw as vc_gldw,
       vc_sfqc,
       vc_qcjddm,
       vc_qcxxdz,
       total,
       rn
  from (select vc_bgkid,
               vc_bgklx,
               vc_mzh,
               vc_zyh,
               vc_icd10,
               vc_icd9,
               vc_bqygzbr,
               vc_hzxm,
               vc_hzxb,
               dt_hzcsrq,
               vc_bgkzt,
               vc_zydm,
               vc_jtgz,
               vc_bksznl,
               vc_hzmz,
               vc_sfzh,
               vc_gzdw,
               vc_jtdh,
               vc_hksfdm,
               vc_hksdm,
               vc_hkqxdm,
               vc_hkjddm,
               vc_hkjwdm,
               vc_hkxxdz,
               vc_sjsfdm,
               vc_sjsdm,
               vc_sjqxdm,
               vc_sjjddm,
               vc_sjjwdm,
               vc_sjxxdz,
               vc_icdO,
               vc_icdM,
               vc_dlw,
               vc_blh,
               vc_zdqbt,
               vc_zdqbN,
               vc_zdqbM,
               vc_zdsqb,
               vc_zgzddw,
               dt_zdrq,
               vc_yzd,
               dt_yzdrq,
               vc_bgdw,
               vc_bgys,
               dt_bgrq,
               dt_swrq,
               vc_swyy,
               vc_swicd10,
               vc_swicdmc,
               vc_zdyh,
               vc_bszy,
               vc_shbz,
               dt_cjsj,
               dt_yyshsj,
               dt_qxshsj,
               dt_cfsj,
               dt_sfrq,
               vc_blxlx,
               vc_gldw,
               vc_sfqc,
               vc_qcjddm,
               vc_qcxxdz,
               total,
               rownum as rn
          from (select a.vc_bgkid,
                       a.vc_bgklx,
                       a.vc_mzh,
                       a.vc_zyh,
                       a.vc_icd10,
                       a.vc_icd9,
                       a.vc_bqygzbr,
                       b.vc_hzxm,
                       b.vc_hzxb,
                       b.dt_hzcsrq,
                       a.vc_bgkzt,
                       b.vc_zydm,
                       b.vc_jtgz,
                       a.vc_bksznl,
                       b.vc_hzmz,
                       b.vc_sfzh,
                       b.vc_gzdw,
                       b.vc_jtdh,
                       b.vc_hksfdm,
                       b.vc_hksdm,
                       b.vc_hkqxdm,
                       b.vc_hkjddm,
                       b.vc_hkjwdm,
                       b.vc_hkxxdz,
                       b.vc_sjsfdm,
                       b.vc_sjsdm,
                       b.vc_sjqxdm,
                       b.vc_sjjddm,
                       b.vc_sjjwdm,
                       b.vc_sjxxdz,
                       a.vc_icdO,
                       a.vc_icdM,
                       a.vc_dlw,
                       a.vc_blh,
                       a.vc_zdqbt,
                       a.vc_zdqbN,
                       a.vc_zdqbM,
                       a.vc_zdsqb,
                       a.vc_zgzddw,
                       a.dt_zdrq,
                       a.vc_yzd,
                       a.dt_yzdrq,
                       a.vc_bgdw,
                       a.vc_bgys,
                       a.dt_bgrq,
                       a.dt_swrq,
                       a.vc_swyy,
                       a.vc_swicd10,
                       a.vc_swicdmc,
                       a.vc_zdyh,
                       a.vc_bszy,
                       a.vc_shbz,
                       a.dt_cjsj,
                       a.dt_yyshsj,
                       a.dt_qxshsj,
                       a.dt_cfsj,
                       a.dt_sfrq,
                       a.vc_blxlx,
                       a.vc_gldw,
                       a.vc_sfqc,
                       a.vc_qcjddm,
                       a.vc_qcxxdz,
                       count(1) over() as total
                  from ZJJK_ZL_BGK a, ZJJK_ZL_HZXX b
                 where a.VC_HZID = b.VC_PERSONID
                   and a.VC_GLDW like #{vc_gldw}|| '%'
                   and a.VC_SHBZ in ('3', '5', '6', '7', '8')
                   and a.VC_BGKZT = '0'
                   and a.VC_SFCF = '2'
                   and a.VC_SDQRZT ='1'
                   and a.VC_SCBZ = '0'
                   <if if(StringUtils.isNotBlank(#{vc_hzxm}))>
                       and b.vc_hzxm = #{vc_hzxm}
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_qxshsj_ks}))>
                       and a.DT_QXSHSJ >= std(#{dt_qxshsj_ks},1)
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_qxshsj_js}))>
                       and a.DT_QXSHSJ <= std(#{dt_qxshsj_js},1)
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkshen}))>
                       and b.VC_HKSFDM = #{vc_hkshen}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hksdm}))>
                       and (b.VC_HKSDM = #{vc_hks})
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkqxdm}))>
                       and b.VC_HKQXDM = #{vc_hkqx}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkjddm}))>
                       and b.VC_HKJDDM = #{vc_hkjd}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkjw}))>
                       and b.VC_HKJWDM = #{vc_hkjw}
                   </if>
                 order by a.DT_CJSJ)
         where rownum <= #{rn_e})
 where rn >= #{rn_s}