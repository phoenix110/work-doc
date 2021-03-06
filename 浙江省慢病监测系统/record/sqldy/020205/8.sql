select vc_bgkcode as vc_bgkcode,
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_BGKLX', vc_bgklx) as vc_bgklx_text,
       vc_hzxm,
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_XB', vc_hzxb) as vc_hzxb_text,
       to_char(dt_hzcsrq, 'yyyy-mm-dd') as dt_hzcsrq,
       vc_hydm || '  ' || pkg_zjmb_tnb.fun_getcommdic('C_COMM_HY', vc_hydm) as vc_hydm,
       vc_zydm || '  ' || pkg_zjmb_tnb.fun_getcommdic('C_COMM_ZY', vc_zydm) as vc_zydm,
       vc_hzmz || '  ' ||
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_MZ', vc_hzmz) as vc_hzmz,
       vc_whcd || '  ' ||
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_WHCD', vc_whcd) as vc_whcd,
       vc_sfzh as vc_sfzh,
       vc_gzdw,
       vc_lxdh as vc_lxdh,
       vc_hkshen || '  ' ||
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_SHEDM', vc_hkshen) as vc_hkshen,
       vc_hks || '  ' || pkg_zjmb_tnb.fun_getcommdic('C_COMM_SJDM', vc_hks) as vc_hks,
       vc_hkqx || '  ' ||
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_QXDM', vc_hkqx) as vc_hkqx,
       vc_hkjd || '  ' ||
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_JDDM', vc_hkjd) as vc_hkjd,
       vc_hkjw,
       vc_hkxxdz,
       vc_jzds || '  ' ||
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_SHEDM', vc_jzds) as vc_jzds,
       vc_jzs || '  ' || pkg_zjmb_tnb.fun_getcommdic('C_COMM_SJDM', vc_jzs) as vc_jzs,
       vc_jzqx || '  ' ||
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_QXDM', vc_hkqx) as vc_jzqx,
       vc_jzjd || '  ' ||
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_JDDM', vc_hkjd) as vc_jzjd,
       vc_jzjw,
       vc_jzxxdz,
       vc_icd10,
       pkg_zjmb_tnb.fun_getcommdic('C_TNB_TNBLX', vc_tnblx) as vc_tnblx,
       vc_ywbfz,
       vc_wxystz,
       vc_wxyssg,
       vc_bmi,
       vc_wxys,
       vc_tnbs,
       vc_jzsrs,
       vc_zddw || '  ' ||
       pkg_zjmb_tnb.fun_getcommdic('C_ZL_ZGZDDW', vc_zddw) as vc_zddw,
       
       vc_bgdw || '  ' || pkg_zjmb_tnb.fun_getyljgmc(vc_bgdw) as vc_bgdw,
       vc_bgys,
       to_char(dt_bgrq, 'yyyy-mm-dd') as dt_bgrq,
       to_char(dt_swrq, 'yyyy-mm-dd') as dt_swrq,
       vc_swyy,
       vc_swicd10,
       vc_swicdmc,
       vc_bszyqt,
       nb_kfxtz,
       nb_sjxtz,
       nb_xjptt,
       nb_zdgc,
       nb_e4hdlc,
       nb_e5ldlc,
       nb_gysz,
       nb_nwldb,
       nbthxhdb,
       vc_bszy,
       vc_shbz || '  ' ||
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_SHZT', vc_shbz) as vc_shbz,
       to_char(dt_cjsj, 'yyyy-mm-dd') as dt_cjsj,
       vc_bgkzt || '  ' ||
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_BGKZT', vc_bgkzt) as vc_bgkzt,
       vc_sznl,
       to_char(dt_yyshsj, 'yyyy-mm-dd') as dt_yyshsj,
       to_char(dt_qxshsj, 'yyyy-mm-dd') as dt_qxshsj,
       to_char(dt_cfsj, 'yyyy-mm-dd') as dt_cfsj,
       to_char(dt_sfsj, 'yyyy-mm-dd') as dt_sfsj,
       vc_mzh,
       vc_zyh,
       vc_gldw as vc_gldw,
       vc_qybz,
       vc_qcjddm,
       vc_qcxxdz,
       to_char(dt_sczdrq, 'yyyy-mm-dd') dt_sczdrq
  from (select vc_bgkcode,
               vc_bgklx,
               vc_hzxm,
               vc_hzxb,
               dt_hzcsrq,
               vc_hydm,
               vc_zydm,
               vc_hzmz,
               vc_whcd,
               vc_sfzh,
               vc_gzdw,
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
               vc_icd10,
               vc_tnblx,
               vc_ywbfz,
               vc_wxystz,
               vc_wxyssg,
               vc_bmi,
               vc_wxys,
               vc_tnbs,
               vc_jzsrs,
               dt_sczdrq,
               vc_zddw,
               vc_bgdw,
               vc_bgys,
               dt_bgrq,
               dt_swrq,
               vc_swyy,
               vc_swicd10,
               vc_swicdmc,
               vc_bszyqt,
               nb_kfxtz,
               NB_SJXTZ,
               NB_XJPTT,
               NB_ZDGC,
               NB_E4HDLC,
               NB_E5LDLC,
               NB_GYSZ,
               NB_NWLDB,
               NBTHXHDB,
               vc_bszy,
               vc_shbz,
               dt_cjsj,
               vc_bgkzt,
               vc_sznl,
               dt_yyshsj,
               dt_qxshsj,
               dt_cfsj,
               dt_sfsj,
               vc_mzh,
               vc_zyh,
               vc_gldw,
               vc_qybz,
               vc_qcjddm,
               vc_qcxxdz,
               rownum as rn
          from (select t.vc_bgkcode,
                       t.vc_bgklx,
                       h.vc_hzxm,
                       h.vc_hzxb,
                       h.dt_hzcsrq,
                       h.vc_hydm,
                       h.vc_zydm,
                       h.vc_hzmz,
                       h.vc_whcd,
                       h.vc_sfzh,
                       h.vc_gzdw,
                       h.vc_lxdh,
                       h.vc_hkshen,
                       h.vc_hks,
                       h.vc_hkqx,
                       h.vc_hkjd,
                       h.vc_hkjw,
                       h.vc_hkxxdz,
                       h.vc_jzds,
                       h.vc_jzs,
                       h.vc_jzqx,
                       h.vc_jzjd,
                       h.vc_jzjw,
                       h.vc_jzxxdz,
                       t.vc_icd10,
                       t.vc_tnblx,
                       t.vc_ywbfz,
                       t.vc_wxystz,
                       t.vc_wxyssg,
                       t.vc_bmi,
                       t.vc_wxys,
                       t.vc_tnbs,
                       t.vc_jzsrs,
                       t.dt_sczdrq,
                       t.vc_zddw,
                       t.vc_bgdw,
                       t.vc_bgys,
                       t.dt_bgrq,
                       t.dt_swrq,
                       t.vc_swyy,
                       t.vc_swicd10,
                       t.vc_swicdmc,
                       t.vc_bszyqt,
                       t.nb_kfxtz,
                       t.NB_SJXTZ,
                       t.NB_XJPTT,
                       t.NB_ZDGC,
                       t.NB_E4HDLC,
                       t.NB_E5LDLC,
                       t.NB_GYSZ,
                       t.NB_NWLDB,
                       t.NBTHXHDB,
                       t.vc_bszy,
                       t.vc_shbz,
                       t.dt_cjsj,
                       t.vc_bgkzt,
                       t.vc_sznl,
                       t.dt_yyshsj,
                       t.dt_qxshsj,
                       t.dt_cfsj,
                       t.dt_sfsj,
                       t.vc_mzh,
                       t.vc_zyh,
                       t.vc_gldw,
                       t.vc_qybz,
                       t.vc_qcjddm,
                       t.vc_qcxxdz
                from zjjk_tnb_bgk t, zjjk_tnb_hzxx h
                  where t.vc_hzid = h.vc_personid
                   and t.vc_cfzt in ('1', '3')
                   and t.vc_bgkzt = '0'
                   and t.vc_tnblx in ('1', '2', '4')
                   and t.vc_scbz = '0'
                   and t.vc_shbz in ('3', '5', '6', '7', '8')
                   and t.vc_sdqrzt = '1'
                   and t.vc_gldw like #{vc_gldw} || '%'
                   <if if(StringUtils.isNotBlank(#{vc_hks}))>
                       and (h.vc_hks like #{vc_hks})
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkqx}))>
                       and (h.vc_hkqx like #{vc_hkqx})
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkjd}))>
                       and (h.vc_hkjd like #{vc_hkjd})
                   </if>
                   <if if(StringUtils.isBlank(#{dt_sfsj_ks}) && StringUtils.isBlank(#{dt_sfsj_js}))>
                       and t.dt_sfsj <= add_months(sysdate,-11)
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_sfsj_ks}))>
                       and t.dt_sfsj >= std(#{dt_sfsj_ks},1)
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_sfsj_js}))>
                       and t.dt_sfsj <= std(#{dt_sfsj_js},1)
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hzxm}))>
                       and h.vc_hzxm like '%'||#{vc_hzxm}||'%'
                   </if>
                 order by t.dt_sfsj)
         where rownum <= #{rn_e})
 where rn >= #{rn_s}
 