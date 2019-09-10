select vc_bgkbh as vc_bgkbh,
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_BGKLX', vc_bgklx) as vc_bgklx_text,
       vc_mzh,
       vc_zyh,
       vc_hzicd,
       vc_hzxm,
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_XB', vc_hzxb) as vc_hzxb_text,
       to_char(dt_hzcsrq, 'yyyy-mm-dd') as dt_hzcsrq,
       vc_bksznl,
       vc_hzsfzh as vc_hzsfzh,
       vc_hzzy || '  ' || pkg_zjmb_tnb.fun_getcommdic('C_COMM_HY', vc_hzzy) as vc_hzzy,
       vc_jtgz || '  ' || pkg_zjmb_tnb.fun_getcommdic('C_COMM_ZY', vc_jtgz) as vc_jtgz,
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_WHCD', vc_hzwhcd) as vc_hzwhcd,
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_MZ', vc_hzmz) as vc_hzmz,
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_SHEDM', vc_czhks) as vc_czhks,
       vc_czhksi || '  ' ||
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_SJDM', vc_czhksi) as vc_czhksi,
       vc_czhkqx || '  ' ||
       (select px.mc from p_xzdm px where px.jb = '3' and px.dm = vc_czhkqx) as vc_czhkqx,
       vc_czhkjd || '  ' ||
       (select px.mc from p_xzdm px where px.jb = '4' and px.dm = vc_czhkjd) as vc_czhkjd,
       vc_czhkjw,
       vc_czhkxxdz,
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_SHEDM', vc_mqjzs) as vc_mqjzs,
       vc_mqjzsi || '  ' ||
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_SJDM', vc_mqjzsi) as vc_mqjzsi,
       vc_mqjzqx || '  ' ||
       (select px.mc from p_xzdm px where px.jb = '3' and px.dm = vc_mqjzqx) as vc_mqjzqx,
       vc_mqjzjd || '  ' ||
       (select px.mc from p_xzdm px where px.jb = '4' and px.dm = vc_mqjzjd) as vc_mqjzjd,
       vc_mqjzjw,
       vc_mqxxdz,
       vc_gzdw,
       vc_hzjtdh as vc_hzjtdh,
       pkg_zjmb_tnb.fun_getcommdic('C_XNXG_GXBZD', vc_gxbzd) as vc_gxbzd,
       pkg_zjmb_tnb.fun_getcommdic('C_XNXG_NCZZD', vc_nczzd) as vc_nczzd,
       pkg_zjmb_tnb.fun_getcommdic('C_XNXG_ZDYJ', vc_lczz) as vc_lczz,
       pkg_zjmb_tnb.fun_getcommdic('C_XNXG_ZDYJ', vc_xdt) as vc_xdt,
       pkg_zjmb_tnb.fun_getcommdic('C_XNXG_ZDYJ', vc_xqm) as vc_xqm,
       pkg_zjmb_tnb.fun_getcommdic('C_XNXG_ZDYJ', vc_njy) as vc_njy,
       pkg_zjmb_tnb.fun_getcommdic('C_XNXG_ZDYJ', vc_ndt) as vc_ndt,
       pkg_zjmb_tnb.fun_getcommdic('C_XNXG_ZDYJ', vc_xgzy) as vc_xgzy,
       pkg_zjmb_tnb.fun_getcommdic('C_XNXG_ZDYJ', vc_ct) as vc_ct,
       pkg_zjmb_tnb.fun_getcommdic('C_XNXG_ZDYJ', vc_ckz) as vc_ckz,
       pkg_zjmb_tnb.fun_getcommdic('C_XNXG_ZDYJ', vc_sj) as vc_sj,
       pkg_zjmb_tnb.fun_getcommdic('C_XNXG_ZDYJ', vc_sjkysjc) as vc_sjkysjc,
       vc_bs,
       vc_bkdwyy || '  ' ||
       (select d.mc from p_yljg d where d.dm = vc_bkdwyy) as vc_bkdwyy,
       vc_bkys,
       to_char(dt_bkrq, 'yyyy-mm-dd') as dt_bkrq,
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_SHZT', vc_shbz) as vc_shbz,
       to_char(dt_yyshsj, 'yyyy-mm-dd') as dt_yyshsj,
       to_char(dt_qxshsj, 'yyyy-mm-dd') as dt_qxshsj,
       to_char(dt_fbrq, 'yyyy-mm-dd') as dt_fbrq,
       to_char(dt_qzrq, 'yyyy-mm-dd') as dt_qzrq,
       vc_qzdw || '  ' ||
       pkg_zjmb_tnb.fun_getcommdic('C_XNXG_ZGZDDW', vc_qzdw) as vc_qzdw,
       vc_sfsf,
       vc_swysicd,
       vc_swysmc,
       to_char(dt_swrq, 'yyyy-mm-dd') as dt_swrq,
       vc_swys,
       to_char(dt_cjsj, 'yyyy-mm-dd') as dt_cjsj,
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_BGKZT', vc_kzt) as vc_kzt,
       to_char(dt_cfsj, 'yyyy-mm-dd') as dt_cfsj,
       to_char(dt_sfsj, 'yyyy-mm-dd') as dt_sfsj,
       vc_hzhy || '  ' ||
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_HYZK', vc_hzhy) as vc_hzhy,
       vc_cgzsjjg || '  ' ||
       pkg_zjmb_tnb.fun_getcommdic('C_XNXG_CGZSJJG', vc_cgzsjjg) as vc_cgzsjjg,
       vc_syzz || '  ' ||
       pkg_zjmb_tnb.fun_getcommdic('C_XNXG_SYZZ', vc_syzz) as vc_syzz,
       vc_bszy,
       vc_gldwdm as vc_gldwdm,
       vc_sfqc,
       vc_qcjddm,
       vc_qcxxdz,
       total,
       rn
  from (
       select vc_bgkid,
        vc_mzh,
        vc_zyh,
        vc_bgkbh,
        vc_bgklx,
        vc_hzxm,
        vc_hzxb,
        vc_hzhy,
        vc_hzicd,
        dt_hzcsrq,
        vc_sznl,
        vc_hzzy,
        vc_hzsfzh,
        vc_jtgz,
        vc_hzwhcd,
        vc_hzmz,
        vc_hzjtdh,
        vc_gzdw,
        vc_czhks,
        vc_czhksi,
        vc_czhkjd,
        vc_mqjzs,
        vc_mqjzsi,
        vc_mqjzjd,
        vc_mqjzjw,
        vc_gxbzd,
        vc_nczzd,
        vc_lczz,
        vc_xdt,
        vc_xqm,
        vc_njy,
        vc_ndt,
        vc_xgzy,
        vc_ct,
        vc_ckz,
        vc_sj,
        vc_sjkysjc,
        vc_bs,
        dt_fbrq,
        dt_qzrq,
        vc_sfsf,
        vc_qzdw,
        vc_bkdw,
        vc_bkys,
        dt_bkrq,
        dt_swrq,
        vc_swys,
        vc_bszy,
        vc_scbz,
        vc_gldwdm,
        vc_cjdwdm,
        vc_ckbz,
        vc_sfbb,
        vc_sdqrzt,
        dt_qrsj,
        vc_sdqrid,
        dt_cjsj,
        vc_cjyh,
        dt_xgsj,
        vc_xgyh,
        vc_shbz,
        vc_smtjid,
        vc_qcbz,
        vc_mqxxdz,
        vc_czhkjw,
        vc_czhkxxdz,
        vc_czhkqx,
        vc_mqjzqx,
        vc_swysicd,
        vc_swysmc,
        vc_bkdwqx,
        vc_bkdwyy,
        vc_sfcf,
        vc_kzt,
        vc_qcd,
        vc_qcsdm,
        vc_qcqxdm,
        vc_qcjddm,
        vc_qcjw,
        vc_sfqc,
        dt_qcsj,
        vc_qcxxdz,
        vc_shid,
        vc_khzt,
        vc_khid,
        vc_khjg,
        vc_ccid,
        vc_khbz,
        vc_shzt,
        vc_sfsw,
        vc_shwtgyy,
        vc_shwtgyy1,
        vc_wtzt,
        vc_ywtdw,
        vc_sqsl,
        vc_jjsl,
        vc_ywtjd,
        vc_ywtjw,
        vc_ywtxxdz,
        vc_ywtjgdm,
        vc_lszy,
        vc_cgzsjjg,
        vc_syzz,
        vc_shtd,
        vc_state,
        dt_yyshsj,
        dt_qxshsj,
        vc_bksznl,
        dt_cfsj,
        dt_sfsj,
        vc_bak_hy,
        vc_bak_zy,
        vc_zssj,
        vc_gxbz,
        vc_id,
        vc_kz,
        vc_yyrid,
        dt_qxshrq,
        vc_nzzzyzz,
        vc_bak_sfzh,
        upload_areaeport,
        total,
        rownum as rn
        from (
        select vc_bgkid,
        vc_mzh,
        vc_zyh,
        vc_bgkbh,
        vc_bgklx,
        vc_hzxm,
        vc_hzxb,
        vc_hzhy,
        vc_hzicd,
        dt_hzcsrq,
        vc_sznl,
        vc_hzzy,
        vc_hzsfzh,
        vc_jtgz,
        vc_hzwhcd,
        vc_hzmz,
        vc_hzjtdh,
        vc_gzdw,
        vc_czhks,
        vc_czhksi,
        vc_czhkjd,
        vc_mqjzs,
        vc_mqjzsi,
        vc_mqjzjd,
        vc_mqjzjw,
        vc_gxbzd,
        vc_nczzd,
        vc_lczz,
        vc_xdt,
        vc_xqm,
        vc_njy,
        vc_ndt,
        vc_xgzy,
        vc_ct,
        vc_ckz,
        vc_sj,
        vc_sjkysjc,
        vc_bs,
        dt_fbrq,
        dt_qzrq,
        vc_sfsf,
        vc_qzdw,
        vc_bkdw,
        vc_bkys,
        dt_bkrq,
        dt_swrq,
        vc_swys,
        vc_bszy,
        vc_scbz,
        vc_gldwdm,
        vc_cjdwdm,
        vc_ckbz,
        vc_sfbb,
        vc_sdqrzt,
        dt_qrsj,
        vc_sdqrid,
        dt_cjsj,
        vc_cjyh,
        dt_xgsj,
        vc_xgyh,
        vc_shbz,
        vc_smtjid,
        vc_qcbz,
        vc_mqxxdz,
        vc_czhkjw,
        vc_czhkxxdz,
        vc_czhkqx,
        vc_mqjzqx,
        vc_swysicd,
        vc_swysmc,
        vc_bkdwqx,
        vc_bkdwyy,
        vc_sfcf,
        vc_kzt,
        vc_qcd,
        vc_qcsdm,
        vc_qcqxdm,
        vc_qcjddm,
        vc_qcjw,
        vc_sfqc,
        dt_qcsj,
        vc_qcxxdz,
        vc_shid,
        vc_khzt,
        vc_khid,
        vc_khjg,
        vc_ccid,
        vc_khbz,
        vc_shzt,
        vc_sfsw,
        vc_shwtgyy,
        vc_shwtgyy1,
        vc_wtzt,
        vc_ywtdw,
        vc_sqsl,
        vc_jjsl,
        vc_ywtjd,
        vc_ywtjw,
        vc_ywtxxdz,
        vc_ywtjgdm,
        vc_lszy,
        vc_cgzsjjg,
        vc_syzz,
        vc_shtd,
        vc_state,
        dt_yyshsj,
        dt_qxshsj,
        vc_bksznl,
        dt_cfsj,
        dt_sfsj,
        vc_bak_hy,
        vc_bak_zy,
        vc_zssj,
        vc_gxbz,
        vc_id,
        vc_kz,
        vc_yyrid,
        dt_qxshrq,
        vc_nzzzyzz,
        vc_bak_sfzh,
        upload_areaeport,
        count(1) over() as total
        from zjjk_xnxg_bgk
                 where  vc_scbz = '2'
                   <if if(StringUtils.isNotBlank(#{jgszqh}))>
                     AND (vc_cjdwdm  like #{vc_gldw}|| '%' OR vc_gldwdm like #{vc_gldw}|| '%' or vc_czhkjd like #{jgszqh} || '%')
                   </if>
                   <if if(StringUtils.isBlank(#{jgszqh}))>
                     AND (vc_cjdwdm  like #{vc_gldw}|| '%' OR vc_gldwdm like #{vc_gldw}|| '%')
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_bghks}))>
                       and vc_bkdw = #{vc_bghks}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_bghkqx}))>
                       and vc_bkdwqx = #{vc_bghkqx}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_bgdw}))>
                       and vc_bkdwyy = #{vc_bgdw}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_bgkbh}))>
                       and vc_bgkbh = #{vc_bgkbh}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hzxb}))>
                       and Vc_Hzxb = #{vc_hzxb}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hzzy}))>
                       and vc_hzzy = #{vc_hzzy}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hzicd}))>
                       and VC_HZICD LIKE '%'||#{vc_hzicd}||'%'
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_sfzh}))>
                       and VC_HZSFZH = #{vc_sfzh}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_zyh}))>
                       and vc_zyh = #{vc_zyh}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_mzh}))>
                       and VC_MZH = #{vc_mzh}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_xm}))>
                       and vc_hzxm like '%' || #{vc_xm} || '%'
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_shbz}) && !#{vc_shbz}.contains(","))>
                     and vc_shbz = #{vc_shbz}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_shbz}) && #{vc_shbz}.contains(","))>
                     and instr(#{vc_shbz},vc_shbz) > 0
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_bgkzt}))>
                       and vc_kzt = #{vc_bgkzt}
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_bgrq_ks}))>
                       and dt_bkrq >= std(#{dt_bgrq_ks},1)
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_bgrq_js}))>
                       and dt_bkrq <= std(#{dt_bgrq_js},1)
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_swrq_ks}))>
                       and dt_swrq >= std(#{dt_swrq_ks},1)
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_swrq_js}))>
                       and dt_swrq <= std(#{dt_swrq_js},1)
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_cjsj_ks}))>
                       and dt_cjsj >= std(#{dt_cjsj_ks},1)
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_cjsj_js}))>
                       and dt_cjsj <= std(#{dt_cjsj_js},1)
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_sznl_ks}))>
                       and vc_bksznl >= to_number(#{vc_sznl_ks})
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_sznl_js}))>
                       and vc_bksznl <=to_number(#{vc_sznl_js})
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_fbrq_ks}))>
                       and getage(dt_fbrq) >= to_number(#{dt_fbrq_ks})
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_fbrq_js}))>
                       and getage(dt_fbrq) <=to_number(#{dt_fbrq_js})
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkshen}))>
                       and VC_CZHKS = #{vc_hkshen}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hks}))>
                       and (VC_CZHKSI = #{vc_hks})
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkqx}))>
                       and vc_czhkqx = #{vc_hkqx}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkjd}))>
                       and vc_czhkjd = #{vc_hkjd}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkjw}))>
                       and vc_czhkjw = #{vc_hkjw}
                   </if>
                   <if if("1".equals(#{vc_isrq}))>
                       and VC_GXBZD in ('1','2','3')
                   </if>
                   <if if("1".equals(#{vc_isrq}) && StringUtils.isNotBlank(#{vc_zdyj}))>
                       and Vc_Gxbzd = #{vc_zdyj}
                   </if>
                    <if if("2".equals(#{vc_isrq}))>
                       and VC_NCZZD in ('1','2','3','4','5','6')
                   </if>
                   <if if("2".equals(#{vc_isrq}) && StringUtils.isNotBlank(#{vc_zdyj}))>
                       and Vc_Nczzd = #{vc_zdyj}
                   </if>
                 order by vc_bgkid)
         where rownum <= #{rn_e})
 where rn >= #{rn_s}