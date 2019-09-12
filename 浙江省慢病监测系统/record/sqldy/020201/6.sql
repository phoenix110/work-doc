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
       (select px.mc from p_xzdm px where px.jb = '3' and px.dm = vc_hkqx) as vc_hkqx,
       vc_hkjd || '  ' ||
       (select px.mc from p_xzdm px where px.jb = '4' and px.dm = vc_hkjd) as vc_hkjd,
       vc_hkjw,
       vc_hkxxdz,
       vc_jzds || '  ' ||
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_SHEDM', vc_jzds) as vc_jzds,
       vc_jzs || '  ' || pkg_zjmb_tnb.fun_getcommdic('C_COMM_SJDM', vc_jzs) as vc_jzs,
       vc_jzqx || '  ' ||
       (select px.mc from p_xzdm px where px.jb = '3' and px.dm = vc_hkqx) as vc_jzqx,
       vc_jzjd || '  ' ||
       (select px.mc from p_xzdm px where px.jb = '4' and px.dm = vc_hkjd) as vc_jzjd,
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
       dts(dt_sczdrq,0) dt_sczdrq
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
                   <if if("A1".equals(#{jglx}))>
                       and t.vc_bgdw like #{vc_gldw} || '%'
                   </if>
                   <if if("B1".equals(#{jglx}))>
                       and ((t.vc_shbz = '1' and t.vc_bgdw like #{vc_gldw} || '%') or 
                       (t.vc_shbz != '1' and (t.vc_cjdw like #{vc_gldw} || '%' or t.vc_gldw like #{vc_gldw} || '%' or h.vc_hkjd like #{jgszqh} || '%')))
                   </if>
                   <if if(!"A1".equals(#{jglx}) && !"B1".equals(#{jglx}) && StringUtils.isNotBlank(#{jgszqh}))>
                     and (t.vc_cjdw like #{vc_gldw} || '%' or t.vc_gldw like #{vc_gldw} || '%' or h.vc_hkjd like #{jgszqh} || '%')
                   </if>
                   <if if(!"A1".equals(#{jglx}) && !"B1".equals(#{jglx}) && StringUtils.isBlank(#{jgszqh}))>
                     and (t.vc_cjdw like #{vc_gldw} || '%' or t.vc_gldw like #{vc_gldw} || '%') 
                   </if>
                   and t.vc_scbz = '0'
                <if if(StringUtils.isNotBlank(#{vc_zyh}))>
                  and t.vc_zyh = #{vc_zyh}
                </if>
                <if if(StringUtils.isNotBlank(#{vc_mzh}))>
                  and t.vc_mzh = #{vc_mzh}
                </if>
                <if if(StringUtils.isNotBlank(#{vc_bgkcode}))>
                  and t.vc_bgkcode like #{vc_bgkcode}||'%'
                </if>
                <if if(StringUtils.isNotBlank(#{vc_hzxm}))>
                  and h.vc_hzxm = #{vc_hzxm}
                </if>
                <if if(StringUtils.isNotBlank(#{vc_hzxb}))>
                  and h.vc_hzxb = #{vc_hzxb}
                </if>
                <if if(StringUtils.isNotBlank(#{vc_sfzh}))>
                  and h.vc_sfzh = #{vc_sfzh}
                </if>
                <if if(StringUtils.isNotBlank(#{vc_bgkzt}))>
                  and t.vc_bgkzt = #{vc_bgkzt}
                </if>
                <if if(StringUtils.isNotBlank(#{vc_shbz}) && !#{vc_shbz}.contains(","))>
                  and t.vc_shbz = #{vc_shbz}
                </if>
                <if if(StringUtils.isNotBlank(#{vc_shbz}) && #{vc_shbz}.contains(","))>
                  and instr(#{vc_shbz},t.vc_shbz) > 0
                </if>
                <if if(StringUtils.isNotBlank(#{fbnl_ks}))>
                  and t.vc_sznl >= #{fbnl_ks}
                </if>
                <if if(StringUtils.isNotBlank(#{fbnl_js}))>
                  and t.vc_sznl <= #{fbnl_js}
                </if>
                <if if(StringUtils.isNotBlank(#{dt_sczdrq_ks}))>
                  and t.dt_sczdrq <= to_date(#{dt_sczdrq_ks},'yyyy-MM-dd HH24:mi:ss')
                </if>
                <if if(StringUtils.isNotBlank(#{dt_sczdrq_js}))>
                  and t.dt_sczdrq <= to_date(#{dt_sczdrq_js},'yyyy-MM-dd HH24:mi:ss')
                </if>
                <if if(StringUtils.isNotBlank(#{VC_ICD10}))>
                  and t.VC_ICD10 LIKE '%'||#{VC_ICD10}||'%'
                </if>
                <if if(StringUtils.isNotBlank(#{dt_bgrq_ks}))>
                  and t.dt_bgrq >= to_date(#{dt_bgrq_ks},'yyyy-MM-dd HH24:mi:ss')
                </if>
                <if if(StringUtils.isNotBlank(#{dt_bgrq_js}))>
                  and t.dt_bgrq <= to_date(#{dt_bgrq_js},'yyyy-MM-dd HH24:mi:ss')
                </if>
                <if if(StringUtils.isNotBlank(#{dt_swrq_ks}))>
                  and t.dt_swrq >= to_date(#{dt_swrq_ks},'yyyy-MM-dd HH24:mi:ss')
                </if>
                <if if(StringUtils.isNotBlank(#{dt_swrq_js}))>
                  and t.dt_swrq <= to_date(#{dt_swrq_js},'yyyy-MM-dd HH24:mi:ss')
                </if>
                <if if(StringUtils.isNotBlank(#{dt_cjsj_ks}))>
                  and t.dt_cjsj >= to_date(#{dt_cjsj_ks},'yyyy-MM-dd HH24:mi:ss')
                </if>
                <if if(StringUtils.isNotBlank(#{dt_cjsj_js}))>
                  and t.dt_cjsj <= to_date(#{dt_cjsj_js},'yyyy-MM-dd HH24:mi:ss')
                </if>
                <if if(StringUtils.isNotBlank(#{dt_qxshsj_ks}))>
                  and t.dt_qxshsj >= to_date(#{dt_qxshsj_ks},'yyyy-MM-dd HH24:mi:ss')
                </if>
                <if if(StringUtils.isNotBlank(#{dt_qxshsj_js}))>
                  and t.dt_qxshsj <= to_date(#{dt_qxshsj_js},'yyyy-MM-dd HH24:mi:ss')
                </if>
                <if if(StringUtils.isNotBlank(#{vc_wxystz_ks}))>
                  and t.vc_wxystz >= #{vc_wxystz_ks}
                </if>
                <if if(StringUtils.isNotBlank(#{vc_wxystz_js}))>
                  and t.vc_wxystz <= #{vc_wxystz_js}
                </if>
                <if if(StringUtils.isNotBlank(#{vc_hkshen}))>
                  and h.vc_hkshen = #{vc_hkshen}
                </if>
                <if if(StringUtils.isNotBlank(#{vc_hks}))>
                  and h.vc_hks = #{vc_hks}
                </if>
                <if if(StringUtils.isNotBlank(#{vc_hkqx}))>
                  and h.vc_hkqx = #{vc_hkqx}
                </if>
                <if if(StringUtils.isNotBlank(#{vc_hkjd}))>
                  and h.vc_hkjd = #{vc_hkjd}
                </if>
                <if if(StringUtils.isNotBlank(#{vc_hkjw}))>
                  and h.vc_hkjw = #{vc_hkjw}
                </if>
                <if if(StringUtils.isNotBlank(#{vc_hkxxdz}))>
                  and h.vc_hkxxdz like '%'||#{vc_hkxxdz}||'%'
                </if>
                <if if(StringUtils.isNotBlank(#{vc_bks}))>
                  and t.vc_bks = #{vc_bks}
                </if>
                <if if(StringUtils.isNotBlank(#{vc_bkq}))>
                  and t.vc_bkq = #{vc_bkq}
                </if>
                <if if(StringUtils.isNotBlank(#{vc_bgdw}))>
                  and t.vc_bgdw = #{vc_bgdw}
                </if>
                 order by t.vc_bgkid)
         where rownum <= #{rn_e})
 where rn >= #{rn_s}