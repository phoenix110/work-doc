SELECT fh.id,
       fh.sfkid,
       bg.vc_bgkid,
       fh.cctjid,
       '1' vc_csflx,
       '初访' csflx,
       bg.vc_bgkid bgkbh,
       '5' vc_bllx,
       '死亡' bllx,
       bg.vc_bgklb vc_bgkzt,
       bg.vc_xm xm,
       DECODE(bg.vc_xb,'1','男','2','女') xb,
       bg.vc_sfzhm sfzh,
       (select mc from P_YLJG where dm=bg.vc_gldwdm) bkdw,
       decode(bg.vc_hkqcs,
              '0',
              '浙江省' || pkg_zjmb_tnb.fun_getxzqhmc(bg.vc_hksdm) ||
              pkg_zjmb_tnb.fun_getxzqhmc(bg.vc_hkqxdm) ||
              pkg_zjmb_tnb.fun_getxzqhmc(bg.vc_hkjddm) || bg.vc_hkjw || bg.vc_hkxxdz,
              '1',
              '外省') hjdz,
       bg.vc_jslxdh lxdh,
       fn_zjjk_zlfh_csf_getfhjg(#{vc_csflx}, #{vc_bllx},fh.id) sffh,
       fh.fhbz fhbz,
       fh.fhzt vc_fhzt,
       fh.shyj,
       DECODE(fh.fhzt,'0','未开始','1','进行中','2','待复核','3','复核通过','4','复核不通过','5','审核通过','6','审核不通过') fhzt,
       bg.vc_zyh,
       lag(fh.fhzt, 1, null) over (order by fh.ccxh asc) last_fhzt,
       vc_gldwdm vc_bgdw,
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_BGKZT', bg.vc_bgklb) as vc_bgkzt_text,
       bg.vc_mz || '  ' || pkg_zjmb_tnb.fun_getcommdic('C_COMM_MZ', bg.vc_mz) vc_mz_text,
       bg.vc_zy || '  ' || pkg_zjmb_tnb.fun_getcommdic('C_SMTJSW_GRSF', bg.vc_zy) grsf,
       bg.vc_hkqcs || '  ' || decode(bg.vc_hkqcs, '0', '浙江省', '1', '外省') vc_hkqcs_text,
       bg.vc_hksdm || '  ' ||  pkg_zjmb_tnb.fun_getxzqhmc(bg.vc_hksdm) vc_hksdm_text,
       bg.vc_hkqxdm || '  ' || pkg_zjmb_tnb.fun_getxzqhmc(bg.vc_hkqxdm) vc_hkqxdm_text,
       bg.vc_hkjddm || '  ' || pkg_zjmb_tnb.fun_getxzqhmc(bg.vc_hkjddm) vc_hkjddm_text,
       bg.vc_hkjw vc_hkjw,
       bg.vc_hkxxdz vc_hkxxdz,
       bg.vc_hyzk || ' ' || pkg_zjmb_tnb.fun_getcommdic('C_COMM_HYZK', bg.vc_hyzk) vc_hyzk_text,
       bg.vc_whcd || ' ' || pkg_zjmb_tnb.fun_getcommdic('C_COMM_WHCD', bg.vc_whcd) as vc_whcd_text,
       bg.vc_lxdzhgzdw vc_lxdzhgzdw,
       dts(bg.dt_csrq, 0) dt_csrq,
       dts(bg.dt_swrq, 0) dt_swrq,
       bg.vc_sznl vc_sznl,
       bg.vc_jsxm vc_jsxm,
       bg.vc_swdd || ' ' || pkg_zjmb_tnb.fun_getcommdic('C_SMTJSW_SWDD', bg.vc_swdd) as vc_swdd_text,
       bg.vc_jsdz vc_jsdz,
       bg.vc_azjswjb1 vc_azjswjb1,
       bg.nb_azjswjbicd || '  ' || bg.vc_azjswjb azjdzswdjbhqk,
       bg.vc_afbdswsjjg vc_afbdswsjjg,
       bg.vc_bzjswjb1 vc_bzjswjb1,
       bg.nb_bzjswjbidc || '  ' || bg.vc_bzjswjb byqadjbhqk,
       bg.vc_bfbdswsjjg vc_bfbdswsjjg,
       bg.vc_czjswjb1 vc_czjswjb1,
       bg.nb_czjswjbicd || '  ' || bg.vc_czjswjb cyqbdjbhqk,
       bg.vc_cfbdswsjjg vc_cfbdswsjjg,
       bg.vc_dzjswjb1 vc_dzjswjb1,
       bg.nb_dajswjbicd || '  ' || bg.vc_dzjswjb dyqcdjbhqk,
       bg.vc_dfbdswsjjg vc_dfbdswsjjg,
       bg.vc_ezjswjb1 vc_ezjswjb1,
       bg.nb_eajswjbicd || '  ' || bg.vc_ezjswjb qtjb1,
       bg.vc_efbdswsjjg vc_efbdswsjjg,
       bg.vc_fzjswjb1 vc_fzjswjb1,
       bg.nb_fajswjbicd || '  ' || bg.vc_fzjswjb sglr2_,
       bg.vc_ffbdswsjjg vc_ffbdswsjjg,
       bg.vc_gzjswjb1 vc_gzjswjb1,
       bg.nb_gajswjbicd || '  ' || bg.vc_gzjswjb sglr3_,
       bg.vc_gfbdswsjjg vc_gfbdswsjjg,
       bg.vc_sqzgzddw || '  ' ||
       (SELECT t.name
          FROM code_info t
         WHERE t.code = bg.vc_sqzgzddw
           AND t.code_info_id =
               (SELECT f.id FROM code_info f WHERE f.code = 'C_SMTJSW_ZGZZDW')) szsqssjbdzgzdyy,
       bg.vc_zdyj || '  ' ||
       (SELECT t.name
          FROM code_info t
         WHERE t.code = bg.vc_zdyj
           AND t.code_info_id =
               (SELECT f.id FROM code_info f WHERE f.code = 'C_ZJMB_ZDYJDMWH')) szssjbdzgzdyj,
       bg.vc_ysqm vc_ysqm,
       bg.vc_gbsy || '  ' || bg.nb_gbsybm gbswyy,
       bg.fenleitj fenleitj,
       dts(bg.dt_dcrq, 0) dt_dcrq,
       bg.vc_jkdw || ' ' || (select d.mc from p_yljg d where d.dm = bg.vc_jkdw) as vc_jkdw_text,
       bg.vc_szsqbljzztz vc_szsqbljzztz,
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_SF', bg.vc_hkhs) as vc_hkhs_text,
       (SELECT t.name
          FROM code_info t
         WHERE t.code = bg.vc_whsyy
           AND t.code_info_id =
               (SELECT f.id FROM code_info f WHERE f.code = 'C_ZL_HKWHSYY')) vc_whsyy_text,
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_SHZT', bg.vc_shbz) as vc_shbz_text,
       dts(bg.dt_yyshsj, 0) dt_yyshsj,
       dts(bg.dt_shsj, 0) dt_shsj,
       dts(bg.dt_lrsj, 0) dt_lrsj,
       dts(bg.dt_sfsj, 0) dt_sfsj,
       bg.vc_gjhdq vc_gjhdq,
       bg.vc_zjlx vc_zjlx,
       bg.vc_rsqk vc_rsqk,
       bg.vc_wshkshendm || '  ' ||
       (SELECT t.name FROM area_qg t WHERE t.code = bg.vc_wshkshendm) vc_wshkshendm_text,
       vc_wshksdm || '  ' ||
       (SELECT t.name FROM area_qg t WHERE t.code = bg.vc_wshksdm) vc_wshksdm_text,
       vc_wshkqxdm || '  ' ||
       (SELECT t.name FROM area_qg t WHERE t.code = bg.vc_wshkqxdm) vc_wshkqxdm_text,
       vc_wshkjddm || '  ' ||
       (SELECT t.name FROM area_qg t WHERE t.code = bg.vc_wshkjddm) vc_wshkjddm_text,
       bg.vc_wshkjw vc_wshkjw,
       bg.vc_jzqcs || '  ' || decode(bg.vc_jzqcs, '0', '浙江省', '1', '外省') vc_jzqcs_text,
       bg.vc_jzsdm || '  ' ||  pkg_zjmb_tnb.fun_getxzqhmc(bg.vc_jzsdm) vc_jzsdm_text,
       bg.vc_jzqxdm || '  ' || pkg_zjmb_tnb.fun_getxzqhmc(bg.vc_jzqxdm) vc_jzqxdm_text,
       bg.vc_jzjddm || '  ' || pkg_zjmb_tnb.fun_getxzqhmc(bg.vc_jzjddm) vc_jzjddm_text,
       bg.vc_jzjw vc_jzjw,
       bg.vc_wsjzshendm || '  ' ||
       (SELECT t.name FROM area_qg t WHERE t.code = bg.vc_wsjzshendm) vc_wsjzshendm_text,
       bg.vc_wsjzsdm || '  ' ||
       (SELECT t.name FROM area_qg t WHERE t.code = bg.vc_wsjzsdm) vc_wsjzsdm_text,
       bg.vc_wsjzqxdm || '  ' ||
       (SELECT t.name FROM area_qg t WHERE t.code = bg.vc_wsjzqxdm) vc_wsjzqxdm_text,
       bg.vc_wsjzjddm || '  ' ||
       (SELECT t.name FROM area_qg t WHERE t.code = bg.vc_wsjzjddm) vc_wsjzjddm_text,
       bg.vc_wsjzjw vc_wsjzjw,
       COUNT(1) OVER() total
  FROM zjjk_csf_zlfh fh, zjmb_sw_bgk bg
 WHERE fh.sfkid = bg.vc_bgkid
   AND bg.vc_bgkid = bg.vc_bgkid
   AND fh.bllx = '5'
   AND fh.zt = '1'
   AND bg.vc_gldwdm LIKE #{vc_bgdw}||'%'   
   AND (('1' = #{vc_csflx} AND cctjid=#{cfccsjd}) OR ('2' = #{vc_csflx} AND cctjid=#{sfccsjd}))    
   order by fh.ccxh asc                                                                                                                                                                                                                                                                                                                                                                                                                             