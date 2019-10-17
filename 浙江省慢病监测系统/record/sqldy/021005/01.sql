SELECT vc_sfkid,
       vc_bgkid,
       vc_bgkid vc_hzid,
       vc_bgkbh bgkbh,
       vc_kzt vc_bgkzt,
       #{vc_bllx} vc_bllx,
       decode(#{vc_bllx}, '1', '脑卒中', '2', '冠心病') bllx,
       #{vc_csflx} vc_csflx,
       decode(#{vc_csflx}, '1', '初访', '2', '随访') csflx,
       decode(#{vc_csflx}, '1', #{cfccsjd}, '2', #{sfccsjd}) vc_cctjid,
       vc_hzxm xm,
       decode(vc_hzxb, '1', '男', '2', '女') xb,
       vc_hzsfzh sfzh,
       vc_hzjtdh lxdh,
       decode(vc_czhks,
              '0',
              '浙江省' || pkg_zjmb_tnb.fun_getxzqhmc(vc_czhksi) ||
              pkg_zjmb_tnb.fun_getxzqhmc(vc_czhkqx) ||
              pkg_zjmb_tnb.fun_getxzqhmc(vc_czhkjd) || vc_czhkjw ||
              vc_czhkxxdz,
              '1',
              '外省') hjdz,
       vc_gldwdm vc_bgdw,
       vc_zyh,
       (SELECT mc FROM p_yljg WHERE dm = vc_gldwdm) bkdw,
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_BGKLX', vc_bgklx) as bgklx_text,
       vc_mzh mzh,
       vc_hzicd hzicd,
       vc_hzxb || ' ' || decode(vc_hzxb, '1', '男', '2', '女') xb_text,
       dts(dt_hzcsrq, 0) hzcsrq,
       vc_bksznl bksznl,
       vc_hzzy || ' ' || pkg_zjmb_tnb.fun_getcommdic('C_COMM_HY', vc_hzzy) as hzzy_text,
       vc_jtgz || ' ' || pkg_zjmb_tnb.fun_getcommdic('C_COMM_ZY', vc_jtgz) as jtgz_text,
       vc_hzwhcd || ' ' || pkg_zjmb_tnb.fun_getcommdic('C_COMM_WHCD', vc_hzwhcd) as hzwhcd_text,
       vc_hzmz || ' ' || pkg_zjmb_tnb.fun_getcommdic('C_COMM_MZ', vc_hzmz) as hzmz_text,
       vc_czhks || ' ' || decode(vc_czhks, '0', '浙江省', '1', '外省') as czhks_text,
       vc_czhksi || ' ' || pkg_zjmb_tnb.fun_getxzqhmc(vc_czhksi) as czhksi_text,
       vc_czhkqx || ' ' || pkg_zjmb_tnb.fun_getxzqhmc(vc_czhkqx) as czhkqx_text,
       vc_czhkjd || ' ' || pkg_zjmb_tnb.fun_getxzqhmc(vc_czhkjd) as czhkjd_text,
       vc_czhkjw czhkjw,
       vc_czhkxxdz czhkxxdz,
       vc_mqjzs || ' ' || decode(vc_mqjzs, '0', '浙江省', '1', '外省') as mqjzs_text,
       vc_mqjzsi || ' ' || pkg_zjmb_tnb.fun_getxzqhmc(vc_mqjzsi) as mqjzsi_text,
       vc_mqjzqx || ' ' || pkg_zjmb_tnb.fun_getxzqhmc(vc_mqjzqx) as mqjzqx_text,
       vc_mqjzjd || ' ' || pkg_zjmb_tnb.fun_getxzqhmc(vc_mqjzjd) as mqjzjd_text,
       vc_mqjzjw mqjzjw,
       vc_mqxxdz mqxxdz,
       vc_gzdw vc_gzdw,
       pkg_zjmb_tnb.fun_getcommdic('C_XNXG_GXBZD', vc_gxbzd) as vc_gxbzd_text,
       pkg_zjmb_tnb.fun_getcommdic('C_XNXG_NCZZD', vc_nczzd) as vc_nczzd_text,
       pkg_zjmb_tnb.fun_getcommdic('C_XNXG_ZDYJ', vc_lczz) as vc_lczz_text,
       pkg_zjmb_tnb.fun_getcommdic('C_XNXG_ZDYJ', vc_xdt) as vc_xdt_text,
       pkg_zjmb_tnb.fun_getcommdic('C_XNXG_ZDYJ', vc_xqm) as vc_xqm_text,
       pkg_zjmb_tnb.fun_getcommdic('C_XNXG_ZDYJ', vc_njy) as vc_njy_text,
       pkg_zjmb_tnb.fun_getcommdic('C_XNXG_ZDYJ', vc_ndt) as vc_ndt_text,
       pkg_zjmb_tnb.fun_getcommdic('C_XNXG_ZDYJ', vc_xgzy) as vc_xgzy_text,
       pkg_zjmb_tnb.fun_getcommdic('C_XNXG_ZDYJ', vc_ct) as vc_ct_text,
       pkg_zjmb_tnb.fun_getcommdic('C_XNXG_ZDYJ', vc_ckz) as vc_ckz_text,
       pkg_zjmb_tnb.fun_getcommdic('C_XNXG_ZDYJ', vc_sj) as vc_sj_text,
       pkg_zjmb_tnb.fun_getcommdic('C_XNXG_ZDYJ', vc_sjkysjc) as vc_sjkysjc_text,
       vc_bs vc_bs,
       vc_bkdwyy || ' ' || (select d.mc from p_yljg d where d.dm = vc_bkdwyy) as vc_bkdwyy_text,
       vc_bkys vc_bkys,
       dts(dt_bkrq, 0) dt_bkrq,
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_SHZT', vc_shbz) as vc_shbz_text,
       dts(dt_yyshsj, 0) dt_yyshsj,
       dts(dt_qxshsj, 0) dt_qxshsj,
       dts(dt_fbrq, 0) dt_fbrq,
       dts(dt_qzrq, 0) dt_qzrq,
       vc_qzdw || ' ' || pkg_zjmb_tnb.fun_getcommdic('C_XNXG_ZGZDDW', vc_qzdw) as vc_qzdw_text,
       vc_sfsf vc_sfsf,
       vc_swysicd vc_swysicd,
       vc_swysmc vc_swysmc,
       dts(dt_swrq, 0) dt_swrq,
       vc_swys vc_swys,
       dts(bgk_dt_cjsj, 0) bgk_dt_cjsj,
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_BGKZT', vc_kzt) as vc_kzt_text,
       dts(dt_cfsj, 0) dt_cfsj,
       dts(dt_sfsj, 0) dt_sfsj,
       vc_hzhy vc_hzhy,
       vc_cgzsjjg || ' ' || pkg_zjmb_tnb.fun_getcommdic('C_XNXG_CGZSJJG', vc_cgzsjjg) as vc_cgzsjjg_text,
       vc_syzz || '  ' || pkg_zjmb_tnb.fun_getcommdic('C_XNXG_SYZZ', vc_syzz) as vc_syzz_text,
       vc_bszy vc_bszy,
       vc_sfqc vc_sfqc,
       vc_qcjddm vc_qcjddm,
       vc_qcxxdz vc_qcxxdz,
       rn
  FROM (SELECT vc_sfkid,
               vc_bgkid,
               vc_bgkbh,
               vc_kzt,
               vc_gldwdm,
               vc_hzxm,
               vc_hzxb,
               vc_hzsfzh,
               vc_hzjtdh,
               vc_czhks,
               vc_czhksi,
               vc_czhkqx,
               vc_czhkjd,
               vc_czhkjw,
               vc_czhkxxdz,
               vc_zyh,
               vc_bgklx,
               vc_mzh,
               vc_hzicd,
               dt_hzcsrq,
               vc_bksznl,
               vc_hzzy,
               vc_jtgz,
               vc_hzwhcd,
               vc_hzmz,
               vc_mqjzs,
               vc_mqjzsi,
               vc_mqjzqx,
               vc_mqjzjd,
               vc_mqjzjw,
               vc_mqxxdz,
               vc_gzdw,
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
               vc_bkdwyy,
               vc_bkys,
               dt_bkrq,
               vc_shbz,
               dt_yyshsj,
               dt_qxshsj,
               dt_fbrq,
               dt_qzrq,
               vc_qzdw,
               vc_sfsf,
               vc_swysicd,
               vc_swysmc,
               dt_swrq,
               vc_swys,
               bgk_dt_cjsj,
               dt_cfsj,
               dt_sfsj,
               vc_hzhy,
               vc_cgzsjjg,
               vc_syzz,
               vc_bszy,
               vc_sfqc,
               vc_qcjddm,
               vc_qcxxdz,
               rownum rn
          FROM (SELECT vc_sfkid,
                       vc_bgkid,
                       vc_bgkbh,
                       vc_kzt,
                       vc_gldwdm,
                       vc_hzxm,
                       vc_hzxb,
                       vc_hzsfzh,
                       vc_hzjtdh,
                       vc_czhks,
                       vc_czhksi,
                       vc_czhkqx,
                       vc_czhkjd,
                       vc_czhkjw,
                       vc_czhkxxdz,
                       vc_zyh,
                       vc_bgklx,
                       vc_mzh,
                       vc_hzicd,
                       dt_hzcsrq,
                       vc_bksznl,
                       vc_hzzy,
                       vc_jtgz,
                       vc_hzwhcd,
                       vc_hzmz,
                       vc_mqjzs,
                       vc_mqjzsi,
                       vc_mqjzqx,
                       vc_mqjzjd,
                       vc_mqjzjw,
                       vc_mqxxdz,
                       vc_gzdw,
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
                       vc_bkdwyy,
                       vc_bkys,
                       dt_bkrq,
                       vc_shbz,
                       dt_yyshsj,
                       dt_qxshsj,
                       dt_fbrq,
                       dt_qzrq,
                       vc_qzdw,
                       vc_sfsf,
                       vc_swysicd,
                       vc_swysmc,
                       dt_swrq,
                       vc_swys,
                       bgk_dt_cjsj,
                       dt_cfsj,
                       dt_sfsj,
                       vc_hzhy,
                       vc_cgzsjjg,
                       vc_syzz,
                       vc_bszy,
                       vc_sfqc,
                       vc_qcjddm,
                       vc_qcxxdz,
                       row_number() OVER(PARTITION BY vc_gldwdm ORDER BY nvl2(vc_zyh, 0, 1) asc, dbms_random.value) rowsnumber,
                       COUNT(1) over(PARTITION BY vc_gldwdm) countnumber
                  FROM (SELECT row_number() over(PARTITION BY sfk.vc_bgkid ORDER BY sfk.dt_cjsj) csfrn,
                               sfk.vc_sfkid,
                               sfk.vc_bgkid,
                               sfk.dt_cjsj,
                               bgk.vc_bgkbh,
                               bgk.vc_kzt,
                               bgk.vc_gldwdm,
                               bgk.vc_hzxm,
                               bgk.vc_hzxb,
                               bgk.vc_hzsfzh,
                               bgk.vc_hzjtdh,
                               bgk.vc_czhks,
                               bgk.vc_czhksi,
                               bgk.vc_czhkqx,
                               bgk.vc_czhkjd,
                               bgk.vc_hzicd vc_icd10,
                               bgk.vc_czhkjw,
                               bgk.vc_czhkxxdz,
                               bgk.vc_zyh,
                               bgk.vc_bgklx,
                               bgk.vc_mzh,
                               bgk.vc_hzicd,
                               bgk.dt_hzcsrq,
                               bgk.vc_bksznl,
                               bgk.vc_hzzy,
                               bgk.vc_hzwhcd,
                               bgk.vc_jtgz,
                               bgk.vc_hzmz,
                               bgk.vc_mqjzs,
                               bgk.vc_mqjzsi,
                               bgk.vc_mqjzqx,
                               bgk.vc_mqjzjd,
                               bgk.vc_mqjzjw,
                               bgk.vc_mqxxdz,
                               bgk.vc_gzdw,
                               bgk.vc_gxbzd,
                               bgk.vc_nczzd,
                               bgk.vc_lczz,
                               bgk.vc_xdt,
                               bgk.vc_xqm,
                               bgk.vc_njy,
                               bgk.vc_ndt,
                               bgk.vc_xgzy,
                               bgk.vc_ct,
                               bgk.vc_ckz,
                               bgk.vc_sj,
                               bgk.vc_sjkysjc,
                               bgk.vc_bs,
                               bgk.vc_bkdwyy,
                               bgk.vc_bkys,
                               bgk.dt_bkrq,
                               bgk.vc_shbz,
                               bgk.dt_yyshsj,
                               bgk.dt_qxshsj,
                               bgk.dt_fbrq,
                               bgk.dt_qzrq,
                               bgk.vc_qzdw,
                               bgk.vc_sfsf,
                               bgk.vc_swysicd,
                               bgk.vc_swysmc,
                               bgk.dt_swrq,
                               bgk.vc_swys,
                               bgk.dt_cjsj bgk_dt_cjsj,
                               bgk.dt_cfsj,
                               bgk.dt_sfsj,
                               bgk.vc_hzhy,
                               bgk.vc_cgzsjjg,
                               bgk.vc_syzz,
                               bgk.vc_bszy,
                               bgk.vc_sfqc,
                               bgk.vc_qcjddm,
                               bgk.vc_qcxxdz
                          FROM zjjk_xnxg_sfk sfk, zjjk_xnxg_bgk bgk
                         WHERE sfk.vc_bgkid = bgk.vc_bgkid
                           AND bgk.vc_gldwdm LIKE #{vc_bgdw}||'%'
                           AND bgk.vc_scbz = '2'
                           AND EXISTS (SELECT 1
                                 FROM p_yljgjb jg
                                WHERE bgk.vc_gldwdm = jg.jgdm
                                  AND jg.jbgjb IN ('乡级','村级')) 
                           AND ((#{vc_bllx} = '1' AND bgk.vc_gxbzd IS NULL) OR
                               (#{vc_bllx} = '2' AND bgk.vc_gxbzd IS NOT NULL)))
                 WHERE ((#{vc_csflx} = '1' AND csfrn = 1) OR
                       (#{vc_csflx} = '2' AND csfrn > 1))
                   AND ((#{vc_csflx} = '1' AND EXISTS
                        (SELECT 1
                            FROM zjjk_zlfhsj_cf cf
                           WHERE trunc(dt_cjsj) > trunc(cf.dt_ksrq)
                             AND trunc(dt_cjsj) <= trunc(cf.dt_jsrq)
                             AND cf.ccbz LIKE '%1%'
                             AND (cf.nczicd10 is null or cf.nczicd10||',' LIKE '%'||SUBSTR(vc_icd10,0,3)||',%')
                             AND (cf.bgkzt is null or vc_kzt in (select column_value from TABLE(split(cf.bgkzt, ','))))
                             AND cf.zt = '1')) OR
                       (#{vc_csflx} = '2' AND EXISTS
                        (SELECT 1
                            FROM zjjk_zlfhsj_sf sf
                           WHERE trunc(dt_cjsj) > trunc(sf.dt_ksrq)
                             AND trunc(dt_cjsj) <= trunc(sf.dt_jsrq)
                             AND sf.ccbz LIKE '%1%'
                             AND (sf.nczicd10 is null or sf.nczicd10||',' LIKE '%'||SUBSTR(vc_icd10,0,3)||',%')
                             AND (sf.bgkzt is null or vc_kzt in (select column_value from TABLE(split(sf.bgkzt, ','))))
                             AND sf.zt = '1'))))
         WHERE rowsnumber <= 
         <if if(StringUtils.isNotBlank(#{vc_csflx}) && "1".equals(#{vc_csflx}))>
             (SELECT tj.ccts FROM zjjk_zlfhsj_cf tj WHERE tj.zt = '1')
         </if>
         <if if(StringUtils.isNotBlank(#{vc_csflx}) && "2".equals(#{vc_csflx}))>
             (SELECT tj.ccts FROM zjjk_zlfhsj_sf tj WHERE tj.zt = '1')
         </if>
         )                                                                                                                                                                                                                                                                                                                                                                                                                    