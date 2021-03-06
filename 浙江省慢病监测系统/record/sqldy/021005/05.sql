SELECT vc_bgkid vc_sfkid,
       vc_bgkid,
       vc_bgkid vc_hzid,
       vc_bgkid bgkbh,
       vc_bgklb vc_bgkzt,
       '5' vc_bllx,
       '死亡' bllx,
       '1' vc_csflx,
       '初访' csflx,
       #{cfccsjd} vc_cctjid,
       vc_xm xm,
       decode(vc_xb, '1', '男', '2', '女') xb,
       vc_sfzhm sfzh,
       vc_jslxdh lxdh,
       decode(vc_hkqcs,
              '0',
              '浙江省' || pkg_zjmb_tnb.fun_getxzqhmc(vc_hksdm) ||
              pkg_zjmb_tnb.fun_getxzqhmc(vc_hkqxdm) ||
              pkg_zjmb_tnb.fun_getxzqhmc(vc_hkjddm) || vc_hkjw || vc_hkxxdz,
              '1',
              '外省') hjdz,
       vc_zyh,
       vc_gldwdm vc_bgdw,
       (SELECT mc FROM p_yljg WHERE dm = vc_gldwdm) bkdw,
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_BGKZT', vc_bgklb) as vc_bgkzt_text,
       vc_mz || '  ' || pkg_zjmb_tnb.fun_getcommdic('C_COMM_MZ', vc_mz) vc_mz_text,
       vc_zy || '  ' || pkg_zjmb_tnb.fun_getcommdic('C_SMTJSW_GRSF', vc_zy) grsf,
       vc_hkqcs || '  ' || decode(vc_hkqcs, '0', '浙江省', '1', '外省') vc_hkqcs_text,
       vc_hksdm || '  ' ||  pkg_zjmb_tnb.fun_getxzqhmc(vc_hksdm) vc_hksdm_text,
       vc_hkqxdm || '  ' || pkg_zjmb_tnb.fun_getxzqhmc(vc_hkqxdm) vc_hkqxdm_text,
       vc_hkjddm || '  ' || pkg_zjmb_tnb.fun_getxzqhmc(vc_hkjddm) vc_hkjddm_text,
       vc_hkjw vc_hkjw,
       vc_hkxxdz vc_hkxxdz,
       vc_hyzk || ' ' || pkg_zjmb_tnb.fun_getcommdic('C_COMM_HYZK', vc_hyzk) vc_hyzk_text,
       vc_whcd || ' ' || pkg_zjmb_tnb.fun_getcommdic('C_COMM_WHCD', vc_whcd) as vc_whcd_text,
       vc_lxdzhgzdw vc_lxdzhgzdw,
       dts(dt_csrq, 0) dt_csrq,
       dts(dt_swrq, 0) dt_swrq,
       vc_sznl vc_sznl,
       vc_jsxm vc_jsxm,
       vc_swdd || ' ' || pkg_zjmb_tnb.fun_getcommdic('C_SMTJSW_SWDD', vc_swdd) as vc_swdd_text,
       vc_jsdz vc_jsdz,
       vc_azjswjb1 vc_azjswjb1,
       nb_azjswjbicd || '  ' || vc_azjswjb azjdzswdjbhqk,
       vc_afbdswsjjg vc_afbdswsjjg,
       vc_bzjswjb1 vc_bzjswjb1,
       nb_bzjswjbidc || '  ' || vc_bzjswjb byqadjbhqk,
       vc_bfbdswsjjg vc_bfbdswsjjg,
       vc_czjswjb1 vc_czjswjb1,
       nb_czjswjbicd || '  ' || vc_czjswjb cyqbdjbhqk,
       vc_cfbdswsjjg vc_cfbdswsjjg,
       vc_dzjswjb1 vc_dzjswjb1,
       nb_dajswjbicd || '  ' || vc_dzjswjb dyqcdjbhqk,
       vc_dfbdswsjjg vc_dfbdswsjjg,
       vc_ezjswjb1 vc_ezjswjb1,
       nb_eajswjbicd || '  ' || vc_ezjswjb qtjb1,
       vc_efbdswsjjg vc_efbdswsjjg,
       vc_fzjswjb1 vc_fzjswjb1,
       nb_fajswjbicd || '  ' || vc_fzjswjb sglr2_,
       vc_ffbdswsjjg vc_ffbdswsjjg,
       vc_gzjswjb1 vc_gzjswjb1,
       nb_gajswjbicd || '  ' || vc_gzjswjb sglr3_,
       vc_gfbdswsjjg vc_gfbdswsjjg,
       vc_sqzgzddw || '  ' ||
       (SELECT t.name
          FROM code_info t
         WHERE t.code = vc_sqzgzddw
           AND t.code_info_id =
               (SELECT f.id FROM code_info f WHERE f.code = 'C_SMTJSW_ZGZZDW')) szsqssjbdzgzdyy,
       vc_zdyj || '  ' ||
       (SELECT t.name
          FROM code_info t
         WHERE t.code = vc_zdyj
           AND t.code_info_id =
               (SELECT f.id FROM code_info f WHERE f.code = 'C_ZJMB_ZDYJDMWH')) szssjbdzgzdyj,
       vc_ysqm vc_ysqm,
       vc_gbsy || '  ' || nb_gbsybm gbswyy,
       fenleitj fenleitj,
       dts(dt_dcrq, 0) dt_dcrq,
       vc_jkdw || ' ' || (select d.mc from p_yljg d where d.dm = vc_jkdw) as vc_jkdw_text,
       vc_szsqbljzztz vc_szsqbljzztz,
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_SF', vc_hkhs) as vc_hkhs_text,
       (SELECT t.name
          FROM code_info t
         WHERE t.code = vc_whsyy
           AND t.code_info_id =
               (SELECT f.id FROM code_info f WHERE f.code = 'C_ZL_HKWHSYY')) vc_whsyy_text,
        pkg_zjmb_tnb.fun_getcommdic('C_COMM_SHZT', vc_shbz) as vc_shbz_text,
       dts(dt_yyshsj, 0) dt_yyshsj,
       dts(dt_shsj, 0) dt_shsj,
       dts(dt_lrsj, 0) dt_lrsj,
       dts(dt_sfsj, 0) dt_sfsj,
       vc_gjhdq vc_gjhdq,
       vc_zjlx vc_zjlx,
       vc_rsqk vc_rsqk,
       vc_wshkshendm || '  ' ||
       (SELECT t.name FROM area_qg t WHERE t.code = vc_wshkshendm) vc_wshkshendm_text,
       vc_wshksdm || '  ' ||
       (SELECT t.name FROM area_qg t WHERE t.code = vc_wshksdm) vc_wshksdm_text,
       vc_wshkqxdm || '  ' ||
       (SELECT t.name FROM area_qg t WHERE t.code = vc_wshkqxdm) vc_wshkqxdm_text,
       vc_wshkjddm || '  ' ||
       (SELECT t.name FROM area_qg t WHERE t.code = vc_wshkjddm) vc_wshkjddm_text,
       vc_wshkjw vc_wshkjw,
       vc_jzqcs || '  ' || decode(vc_jzqcs, '0', '浙江省', '1', '外省') vc_jzqcs_text,
       vc_jzsdm || '  ' ||  pkg_zjmb_tnb.fun_getxzqhmc(vc_jzsdm) vc_jzsdm_text,
       vc_jzqxdm || '  ' || pkg_zjmb_tnb.fun_getxzqhmc(vc_jzqxdm) vc_jzqxdm_text,
       vc_jzjddm || '  ' || pkg_zjmb_tnb.fun_getxzqhmc(vc_jzjddm) vc_jzjddm_text,
       vc_jzjw vc_jzjw,
       vc_wsjzshendm || '  ' ||
       (SELECT t.name FROM area_qg t WHERE t.code = vc_wsjzshendm) vc_wsjzshendm_text,
       vc_wsjzsdm || '  ' ||
       (SELECT t.name FROM area_qg t WHERE t.code = vc_wsjzsdm) vc_wsjzsdm_text,
       vc_wsjzqxdm || '  ' ||
       (SELECT t.name FROM area_qg t WHERE t.code = vc_wsjzqxdm) vc_wsjzqxdm_text,
       vc_wsjzjddm || '  ' ||
       (SELECT t.name FROM area_qg t WHERE t.code = vc_wsjzjddm) vc_wsjzjddm_text,
       vc_wsjzjw vc_wsjzjw,
       rn,
       COUNT(1) over() total
  FROM (SELECT vc_bgkid,
               vc_bgklb,
               vc_gldwdm,
               vc_xm,
               vc_xb,
               vc_sfzhm,
               vc_jslxdh,
               vc_hkqcs,
               vc_hksdm,
               vc_hkqxdm,
               vc_hkjddm,
               vc_hkjw,
               vc_hkxxdz,
               vc_zyh,
               vc_mz,
               vc_zy,
               vc_hyzk,
               vc_whcd,
               vc_lxdzhgzdw,
               dt_csrq,
               dt_swrq,
               vc_sznl,
               vc_jsxm,
               vc_swdd,
               vc_jsdz,
               vc_azjswjb1,
               nb_azjswjbicd,
               vc_azjswjb,
               vc_afbdswsjjg,
               vc_bzjswjb1,
               nb_bzjswjbidc,
               vc_bzjswjb,
               vc_bfbdswsjjg,
               vc_czjswjb1,
               nb_czjswjbicd,
               vc_czjswjb,
               vc_cfbdswsjjg,
               vc_dzjswjb1,
               nb_dajswjbicd,
               vc_dzjswjb,
               vc_dfbdswsjjg,
               vc_ezjswjb1,
               nb_eajswjbicd,
               vc_ezjswjb,
               vc_efbdswsjjg,
               vc_fzjswjb1,
               nb_fajswjbicd,
               vc_fzjswjb,
               vc_ffbdswsjjg,
               vc_gzjswjb1,
               nb_gajswjbicd,
               vc_gzjswjb,
               vc_gfbdswsjjg,
               vc_sqzgzddw,
               vc_zdyj,
               vc_ysqm,
               vc_gbsy,
               nb_gbsybm,
               fenleitj,
               dt_dcrq,
               vc_jkdw,
               vc_szsqbljzztz,
               vc_hkhs,
               vc_whsyy,
               vc_shbz,
               dt_yyshsj,
               dt_shsj,
               dt_lrsj,
               dt_sfsj,
               vc_gjhdq,
               vc_zjlx,
               vc_rsqk,
               vc_wshkshendm,
               vc_wshksdm,
               vc_wshkqxdm,
               vc_wshkjddm,
               vc_wshkjw,
               vc_jzqcs,
               vc_jzsdm,
               vc_jzqxdm,
               vc_jzjddm,
               vc_jzjw,
               vc_wsjzshendm,
               vc_wsjzsdm,
               vc_wsjzqxdm,
               vc_wsjzjddm,
               vc_wsjzjw,
               rownum rn
          FROM (SELECT bgk.vc_bgkid,
                       bgk.vc_bgkid vc_bgkbh,
                       bgk.vc_bgklb,
                       bgk.vc_gldwdm,
                       bgk.vc_xm,
                       bgk.vc_xb,
                       bgk.vc_sfzhm,
                       bgk.vc_jslxdh,
                       bgk.vc_hkqcs,
                       bgk.vc_hksdm,
                       bgk.vc_hkqxdm,
                       bgk.vc_hkjddm,
                       bgk.vc_hkjw,
                       bgk.vc_hkxxdz,
                       bgk.vc_zyh,
                       bgk.vc_mz,
                       bgk.vc_zy,
                       bgk.vc_hyzk,
                       bgk.vc_whcd,
                       bgk.vc_lxdzhgzdw,
                       bgk.dt_csrq,
                       bgk.dt_swrq,
                       bgk.vc_sznl,
                       bgk.vc_jsxm,
                       bgk.vc_swdd,
                       bgk.vc_jsdz,
                       bgk.vc_azjswjb1,
                       bgk.nb_azjswjbicd,
                       bgk.vc_azjswjb,
                       bgk.vc_afbdswsjjg,
                       bgk.vc_bzjswjb1,
                       bgk.nb_bzjswjbidc,
                       bgk.vc_bzjswjb,
                       bgk.vc_bfbdswsjjg,
                       bgk.vc_czjswjb1,
                       bgk.nb_czjswjbicd,
                       bgk.vc_czjswjb,
                       bgk.vc_cfbdswsjjg,
                       bgk.vc_dzjswjb1,
                       bgk.nb_dajswjbicd,
                       bgk.vc_dzjswjb,
                       bgk.vc_dfbdswsjjg,
                       bgk.vc_ezjswjb1,
                       bgk.nb_eajswjbicd,
                       bgk.vc_ezjswjb,
                       bgk.vc_efbdswsjjg,
                       bgk.vc_fzjswjb1,
                       bgk.nb_fajswjbicd,
                       bgk.vc_fzjswjb,
                       bgk.vc_ffbdswsjjg,
                       bgk.vc_gzjswjb1,
                       bgk.nb_gajswjbicd,
                       bgk.vc_gzjswjb,
                       bgk.vc_gfbdswsjjg,
                       bgk.vc_sqzgzddw,
                       bgk.vc_zdyj,
                       bgk.vc_ysqm,
                       bgk.vc_gbsy,
                       bgk.nb_gbsybm,
                       bgk.fenleitj,
                       bgk.dt_dcrq,
                       bgk.vc_jkdw,
                       bgk.vc_szsqbljzztz,
                       bgk.vc_hkhs,
                       bgk.vc_whsyy,
                       bgk.vc_shbz,
                       bgk.dt_yyshsj,
                       bgk.dt_shsj,
                       bgk.dt_lrsj,
                       bgk.dt_sfsj,
                       bgk.vc_gjhdq,
                       bgk.vc_zjlx,
                       bgk.vc_rsqk,
                       bgk.vc_wshkshendm,
                       bgk.vc_wshksdm,
                       bgk.vc_wshkqxdm,
                       bgk.vc_wshkjddm,
                       bgk.vc_wshkjw,
                       bgk.vc_jzqcs,
                       bgk.vc_jzsdm,
                       bgk.vc_jzqxdm,
                       bgk.vc_jzjddm,
                       bgk.vc_jzjw,
                       bgk.vc_wsjzshendm,
                       bgk.vc_wsjzsdm,
                       bgk.vc_wsjzqxdm,
                       bgk.vc_wsjzjddm,
                       bgk.vc_wsjzjw,
                       row_number() OVER(PARTITION BY vc_gldwdm ORDER BY nvl2(bgk.vc_zyh, 0, 1) asc, dbms_random.value) rowsnumber,
                       COUNT(1) over(PARTITION BY vc_gldwdm) countnumber
                  FROM zjmb_sw_bgk bgk
                 WHERE bgk.vc_sdqr = '1'
                   AND bgk.vc_bgklb = '0'
                   AND bgk.vc_scbz = '2'
                   AND bgk.vc_shbz IN ('3', '5', '6', '7', '8')
                   AND bgk.vc_hkhs IS not NULL
                   AND bgk.vc_gldwdm LIKE #{vc_bgdw}||'%'
                   AND EXISTS (SELECT 1
                                 FROM p_yljgjb jg
                                WHERE bgk.vc_gldwdm = jg.jgdm
                                  AND jg.jbgjb IN ('乡级','村级')) 
                   AND EXISTS
                 (SELECT 1
                          FROM zjjk_zlfhsj_cf cf
                         WHERE trunc(bgk.dt_cjsj) > trunc(cf.dt_ksrq)
                           AND trunc(bgk.dt_cjsj) <= trunc(cf.dt_jsrq)
                           AND cf.ccbz LIKE '%5%'
                           AND cf.zt = '1')
                   AND NOT EXISTS
                 (SELECT 1
                          FROM zjjk_csf_zlfh fh
                         WHERE fh.csflx = '1'
                           AND fh.bllx = '5'
                           AND fh.zt = '1'
                           AND fh.sfkid = bgk.vc_bgkid))
         WHERE rowsnumber <= 
         <if if(StringUtils.isNotBlank(#{vc_csflx}) && "1".equals(#{vc_csflx}))>
             (SELECT tj.ccts FROM zjjk_zlfhsj_cf tj WHERE tj.zt = '1')
         </if>
         <if if(StringUtils.isNotBlank(#{vc_csflx}) && "2".equals(#{vc_csflx}))>
             (SELECT tj.ccts FROM zjjk_zlfhsj_sf tj WHERE tj.zt = '1')
         </if>
         )
 WHERE rn >= 0                                                                                                                                                                                                                                                 