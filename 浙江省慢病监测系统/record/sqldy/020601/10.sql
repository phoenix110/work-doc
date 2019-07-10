SELECT decode(vc_bgklb,
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
              vc_bgklb) bgkzt,
       vc_bgkid bgkbh,
       vc_xm xm,
       decode(vc_xb, '1', '男', '2', '女') xb,
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_MZ', vc_mz) mz,
       pkg_zjmb_tnb.fun_getcommdic('C_SMTJSW_GRSF', vc_zy) grsf,
       vc_sfzhm zjhm,
       decode(vc_hkqcs, '0', '浙江省', '1', '外省') hjdzs,
       (SELECT NAME
          FROM code_info
         WHERE code = vc_hksdm
           AND code_info_id =
               (SELECT id FROM code_info WHERE code = 'C_COMM_SJDM')) hkdzsi,
       (SELECT NAME
          FROM code_info
         WHERE code = vc_hkqxdm
           AND code_info_id =
               (SELECT id FROM code_info WHERE code = 'C_COMM_QXDM')) hkdzqx,
       (SELECT NAME
          FROM code_info
         WHERE code = vc_hkjddm
           AND code_info_id =
               (SELECT id FROM code_info WHERE code = 'C_COMM_JDDM')) hkdzjd,
       vc_hkjw hkxxdz,
       vc_hkxxdz mqjzdz,
       vc_hyzk || '  ' ||
       (SELECT t.name
          FROM code_info t
         WHERE t.code = vc_hyzk
           AND t.code_info_id =
               (SELECT f.id FROM code_info f WHERE f.code = 'C_COMM_HYZK')) hyzk,
       vc_whcd || '  ' ||
       (SELECT t.name
          FROM code_info t
         WHERE t.code = vc_whcd
           AND t.code_info_id =
               (SELECT f.id FROM code_info f WHERE f.code = 'C_SMTJSW_WHCD')) whcd,
       vc_lxdzhgzdw gzdw,
       to_char(dt_csrq, 'yyyy-mm-dd') csrq,
       to_char(dt_swrq, 'yyyy-mm-dd') swrq,
       vc_sznl sznl,
       vc_jsxm kylxdjsxm,
       vc_swdd || '  ' ||
       (SELECT t.name
          FROM code_info t
         WHERE t.code = vc_swdd
           AND t.code_info_id =
               (SELECT f.id FROM code_info f WHERE f.code = 'C_SMTJSW_SWDD')) swdd,
       vc_jsdz jszzhgzdw,
       vc_azjswjb1 asglr,
       nb_azjswjbicd || '  ' || vc_azjswjb azjdzswdjbhqk,
       vc_afbdswsjjg fbdswddgsjjg,
       vc_bzjswjb1 bsglr,
       nb_bzjswjbidc || '  ' || vc_bzjswjb byqadjbhqk,
       vc_bfbdswsjjg bfbdswddgsjjg,
       vc_czjswjb1 csglr,
       nb_czjswjbicd || '  ' || vc_czjswjb cyqbdjbhqk,
       vc_cfbdswsjjg cfbdswddgsjjg,
       vc_dzjswjb1 dsglr,
       nb_dajswjbicd || '  ' || vc_dzjswjb dyqcdjbhqk,
       vc_dfbdswsjjg dfbdswddgsjjg,
       vc_ezjswjb1 qtjb1sglr,
       nb_eajswjbicd || '  ' || vc_ezjswjb qtjb1,
       vc_efbdswsjjg qtjbfbdswddgsjjg,
       vc_fzjswjb1 sglr2,
       nb_fajswjbicd || '  ' || vc_fzjswjb sglr2_,
       vc_ffbdswsjjg sglr2fbdswddgsjjg,
       vc_gzjswjb1 sglr3,
       nb_gajswjbicd || '  ' || vc_gzjswjb sglr3_,
       vc_gfbdswsjjg sglr3fbdswddgsjjg,
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
       vc_zyh yyh,
       vc_ysqm ysxm,
       vc_gbsy || '  ' || nb_gbsybm gbswyy,
       fenleitj fltjh,
       to_char(dt_dcrq, 'yyyy-mm-dd') tbrq,
       vc_jkdw || '  ' ||
       (SELECT t.name
          FROM code_info t
         WHERE t.code = vc_jkdw
           AND removed = '0'
           AND t.code_info_id =
               (SELECT f.id FROM code_info f WHERE f.code = 'C_COMM_YYDM')) bkdw,
       vc_szsqbljzztz szsqbsjzztz,
       (SELECT t.name
          FROM code_info t
         WHERE t.code = vc_hkhs
           AND t.code_info_id =
               (SELECT f.id FROM code_info f WHERE f.code = 'C_COMM_SF')) hkhs,
       (SELECT t.name
          FROM code_info t
         WHERE t.code = vc_whsyy
           AND t.code_info_id =
               (SELECT f.id FROM code_info f WHERE f.code = 'C_ZL_HKWHSYY')) whsyy,
       (SELECT t.name
          FROM code_info t
         WHERE t.code = vc_shbz
           AND t.code_info_id =
               (SELECT f.id FROM code_info f WHERE f.code = 'C_COMM_SHZT')) shzt,
       to_char(dt_yyshsj, 'yyyy-mm-dd') yyshrq,
       to_char(dt_shsj, 'yyyy-mm-dd') qxshrq,
       to_char(dt_lrsj, 'yyyy-mm-dd') lrrq,
       to_char(dt_sfsj, 'yyyy-mm-dd') cfrq,
       vc_jslxdh jslxdh,
       vc_gjhdq gjhdq,
       vc_zjlx || '  ' ||
       (SELECT t.name
          FROM code_info t
         WHERE t.code = vc_zjlx
           AND t.code_info_id =
               (SELECT f.id FROM code_info f WHERE f.code = 'C_SMTJSW_ZJLX')) zjlx,
       vc_rsqk rsqk,
       vc_wshkshendm || '  ' ||
       (SELECT t.name FROM area_qg t WHERE t.code = vc_wshkshendm) wshksdm,
       vc_wshksdm || '  ' ||
       (SELECT t.name FROM area_qg t WHERE t.code = vc_wshksdm) wshksidm,
       vc_wshkqxdm || '  ' ||
       (SELECT t.name FROM area_qg t WHERE t.code = vc_wshkqxdm) wshkqdm,
       vc_wshkjddm || '  ' ||
       (SELECT t.name FROM area_qg t WHERE t.code = vc_wshkjddm) wshkjddm,
       vc_wshkjw wshkxxdz,
       vc_jzqcs || '  ' ||
       (SELECT t.name
          FROM code_info t
         WHERE t.code = vc_jzqcs
           AND t.code_info_id =
               (SELECT f.id FROM code_info f WHERE f.code = 'C_COMM_SHEDM')) jzsdm,
       vc_jzsdm || '  ' ||
       (SELECT t.name
          FROM code_info t
         WHERE t.code = vc_jzsdm
           AND t.code_info_id =
               (SELECT f.id FROM code_info f WHERE f.code = 'C_COMM_SJDM')) jzsidm,
       vc_jzqxdm || '  ' ||
       (SELECT t.name
          FROM code_info t
         WHERE t.code = vc_jzqxdm
           AND t.code_info_id =
               (SELECT f.id FROM code_info f WHERE f.code = 'C_COMM_QXDM')) jzqdm,
       vc_jzjddm || '  ' ||
       (SELECT t.name
          FROM code_info t
         WHERE t.code = vc_jzjddm
           AND removed = '0'
           AND t.code_info_id =
               (SELECT f.id FROM code_info f WHERE f.code = 'C_COMM_JDDM')) jzjddm,
       vc_jzjw jzxxdz,
       vc_wsjzshendm || '  ' ||
       (SELECT t.name FROM area_qg t WHERE t.code = vc_wsjzshendm) wsjzdm,
       vc_wsjzsdm || '  ' ||
       (SELECT t.name FROM area_qg t WHERE t.code = vc_wsjzsdm) wsjzsidm,
       vc_wsjzqxdm || '  ' ||
       (SELECT t.name FROM area_qg t WHERE t.code = vc_wsjzqxdm) wsjzqdm,
       vc_wsjzjddm || '  ' ||
       (SELECT t.name FROM area_qg t WHERE t.code = vc_wsjzjddm) wsjzjddm,
       vc_wsjzjw wsjzxxdz,
       vc_gldwdm gldwdm,
       total,
       rn
  FROM (SELECT vc_bgkid,
               vc_ccid,
               vc_ckbz,
               vc_qyid,
               vc_xm,
               vc_jkdw,
               nb_jkyybm,
               vc_sdqr,
               vc_jkys,
               dt_jksj,
               vc_xb,
               vc_mz,
               vc_zy,
               vc_hjdzlx,
               vc_hjdz,
               vc_hjdzbm,
               vc_hkqcs,
               vc_hksdm,
               vc_hkqxdm,
               vc_hkjddm,
               vc_hkxxdz,
               vc_hyzk,
               vc_whcd,
               dt_swrq,
               vc_sznl,
               vc_sfzhm,
               vc_rqfl,
               vc_swdd,
               vc_sqczdzlx,
               vc_sqxxdz,
               vc_sqzgzddw,
               vc_icdbm,
               vc_zdyj,
               vc_gbsy,
               nb_gbsybm,
               vc_qtjbzd,
               nb_qtjbzdicd,
               vc_jsxm,
               vc_jslxdh,
               vc_jsdz,
               vc_bgklb,
               vc_zyh,
               vc_scbz,
               vc_gldwdm,
               vc_cjdwdm,
               dt_cjsj,
               vc_cjyh,
               dt_xgsj,
               vc_xgyh,
               vc_xxly,
               vc_shzt,
               vc_azjswjb,
               nb_azjswjbicd,
               vc_afbdswsjjg,
               vc_afbdswsjdw,
               vc_bzjswjb,
               nb_bzjswjbidc,
               vc_bfbdswsjjg,
               vc_bfbdswsjdw,
               vc_czjswjb,
               nb_czjswjbicd,
               vc_cfbdswsjjg,
               vc_cfbdswsjdw,
               vc_dzjswjb,
               nb_dajswjbicd,
               vc_dfbdswsjjg,
               vc_dfbdswsjdw,
               vc_ezjswjb,
               nb_eajswjbicd,
               vc_efbdswsjjg,
               vc_efbdswsjdw,
               vc_fzjswjb,
               nb_fajswjbicd,
               vc_ffbdswsjjg,
               vc_ffbdswsjdw,
               vc_gzjswjb,
               nb_gajswjbicd,
               vc_gfbdswsjjg,
               vc_gfbdswsjdw,
               vc_szsqbljzztz,
               vc_bdczxm,
               vc_yszgx,
               vc_lxdzhgzdw,
               vc_bdczdh,
               vc_sytd,
               vc_bdczqm,
               dt_dcrq,
               dt_scsj,
               dt_sfsj,
               dt_lrsj,
               vc_lrrid,
               vc_shbz,
               dt_shsj,
               dt_yyshsj,
               vc_kpzt,
               vc_kply,
               vc_shid,
               vc_khid,
               vc_khzt,
               vc_khjg,
               vc_hkjw,
               vc_qcjw,
               vc_cssdm,
               vc_csqxdm,
               vc_csjddm,
               vc_qcsdm,
               vc_qcqxdm,
               vc_qcjddm,
               vc_hkqc,
               dt_qcsj,
               dt_csrq,
               dt_qxzssj,
               vc_wbswyy,
               vc_ebm,
               vc_ysqm,
               vc_hkhs,
               vc_whsyy,
               vc_bz,
               vc_qcxxdz,
               fenleitj,
               fenleitjmc,
               vc_xnxgbfzt,
               vc_tnbbfzt,
               vc_qcsfdm,
               vc_zlbfzt,
               vc_azjswjb1,
               vc_bzjswjb1,
               vc_czjswjb1,
               vc_dzjswjb1,
               vc_ezjswjb1,
               vc_fzjswjb1,
               vc_gzjswjb1,
               vc_shwtgyy,
               vc_shwtgyy1,
               vc_dyqbh,
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
               vc_gjhdq,
               total,              
               rownum rn
          FROM (SELECT
                 bgk.vc_bgkid,
                 bgk.vc_ccid,
                 bgk.vc_ckbz,
                 bgk.vc_qyid,
                 bgk.vc_xm,
                 bgk.vc_jkdw,
                 bgk.nb_jkyybm,
                 bgk.vc_sdqr,
                 bgk.vc_jkys,
                 bgk.dt_jksj,
                 bgk.vc_xb,
                 bgk.vc_mz,
                 bgk.vc_zy,
                 bgk.vc_hjdzlx,
                 bgk.vc_hjdz,
                 bgk.vc_hjdzbm,
                 bgk.vc_hkqcs,
                 bgk.vc_hksdm,
                 bgk.vc_hkqxdm,
                 bgk.vc_hkjddm,
                 bgk.vc_hkxxdz,
                 bgk.vc_hyzk,
                 bgk.vc_whcd,
                 bgk.dt_swrq,
                 bgk.vc_sznl,
                 bgk.vc_sfzhm,
                 bgk.vc_rqfl,
                 bgk.vc_swdd,
                 bgk.vc_sqczdzlx,
                 bgk.vc_sqxxdz,
                 bgk.vc_sqzgzddw,
                 bgk.vc_icdbm,
                 bgk.vc_zdyj,
                 bgk.vc_gbsy,
                 bgk.nb_gbsybm,
                 bgk.vc_qtjbzd,
                 bgk.nb_qtjbzdicd,
                 bgk.vc_jsxm,
                 bgk.vc_jslxdh,
                 bgk.vc_jsdz,
                 bgk.vc_bgklb,
                 bgk.vc_zyh,
                 bgk.vc_scbz,
                 bgk.vc_gldwdm,
                 bgk.vc_cjdwdm,
                 bgk.dt_cjsj,
                 bgk.vc_cjyh,
                 bgk.dt_xgsj,
                 bgk.vc_xgyh,
                 bgk.vc_xxly,
                 bgk.vc_shzt,
                 bgk.vc_azjswjb,
                 bgk.nb_azjswjbicd,
                 bgk.vc_afbdswsjjg,
                 bgk.vc_afbdswsjdw,
                 bgk.vc_bzjswjb,
                 bgk.nb_bzjswjbidc,
                 bgk.vc_bfbdswsjjg,
                 bgk.vc_bfbdswsjdw,
                 bgk.vc_czjswjb,
                 bgk.nb_czjswjbicd,
                 bgk.vc_cfbdswsjjg,
                 bgk.vc_cfbdswsjdw,
                 bgk.vc_dzjswjb,
                 bgk.nb_dajswjbicd,
                 bgk.vc_dfbdswsjjg,
                 bgk.vc_dfbdswsjdw,
                 bgk.vc_ezjswjb,
                 bgk.nb_eajswjbicd,
                 bgk.vc_efbdswsjjg,
                 bgk.vc_efbdswsjdw,
                 bgk.vc_fzjswjb,
                 bgk.nb_fajswjbicd,
                 bgk.vc_ffbdswsjjg,
                 bgk.vc_ffbdswsjdw,
                 bgk.vc_gzjswjb,
                 bgk.nb_gajswjbicd,
                 bgk.vc_gfbdswsjjg,
                 bgk.vc_gfbdswsjdw,
                 bgk.vc_szsqbljzztz,
                 bgk.vc_bdczxm,
                 bgk.vc_yszgx,
                 bgk.vc_lxdzhgzdw,
                 bgk.vc_bdczdh,
                 bgk.vc_sytd,
                 bgk.vc_bdczqm,
                 bgk.dt_dcrq,
                 bgk.dt_scsj,
                 bgk.dt_sfsj,
                 bgk.dt_lrsj,
                 bgk.vc_lrrid,
                 bgk.vc_shbz,
                 bgk.dt_shsj,
                 bgk.dt_yyshsj,
                 bgk.vc_kpzt,
                 bgk.vc_kply,
                 bgk.vc_shid,
                 bgk.vc_khid,
                 bgk.vc_khzt,
                 bgk.vc_khjg,
                 bgk.vc_hkjw,
                 bgk.vc_qcjw,
                 bgk.vc_cssdm,
                 bgk.vc_csqxdm,
                 bgk.vc_csjddm,
                 bgk.vc_qcsdm,
                 bgk.vc_qcqxdm,
                 bgk.vc_qcjddm,
                 bgk.vc_hkqc,
                 bgk.dt_qcsj,
                 bgk.dt_csrq,
                 bgk.dt_qxzssj,
                 bgk.vc_wbswyy,
                 bgk.vc_ebm,
                 bgk.vc_ysqm,
                 bgk.vc_hkhs,
                 bgk.vc_whsyy,
                 bgk.vc_bz,
                 bgk.vc_qcxxdz,
                 bgk.fenleitj,
                 bgk.fenleitjmc,
                 bgk.vc_xnxgbfzt,
                 bgk.vc_tnbbfzt,
                 bgk.vc_qcsfdm,
                 bgk.vc_zlbfzt,
                 bgk.vc_azjswjb1,
                 bgk.vc_bzjswjb1,
                 bgk.vc_czjswjb1,
                 bgk.vc_dzjswjb1,
                 bgk.vc_ezjswjb1,
                 bgk.vc_fzjswjb1,
                 bgk.vc_gzjswjb1,
                 bgk.vc_shwtgyy,
                 bgk.vc_shwtgyy1,
                 bgk.vc_dyqbh,
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
                 bgk.vc_gjhdq,
                 COUNT(1) over() AS total
                  FROM ZJMB_SW_BGK_WM bgk
                 WHERE (BGK.VC_SCBZ LIKE '2')
                  AND (BGK.VC_CJDWDM like #{vc_gldw}|| '%' OR
                       BGK.VC_GLDWDM like #{vc_gldw}|| '%')
                  and NOT exists(select 1 from zjmb_sw_bgk_wm_zzjl b where b.vc_bgkid_wm = bgk.vc_bgkid)
                  <if if(StringUtils.isNotBlank(#{vc_bgklb}))>
                      AND BGK.vc_bgklb = #{vc_bgklb}
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_shbz}))>
                      AND (instr(#{vc_shbz},BGK.VC_SHBZ) > 0) 
                 </if>
                 <if if(StringUtils.isNotBlank(#{jgjb}) && "1".equals(#{jgjb}))>
                      AND (BGK.VC_SHBZ IN ('1', '3', '5', '6', '7', '8'))
                 </if>
                 <if if(StringUtils.isNotBlank(#{jgjb}) && "2".equals(#{jgjb}))>
                      AND (BGK.VC_SHBZ IN ('3', '5', '6', '7', '8'))
                 </if>
                 <if if(StringUtils.isNotBlank(#{jgjb}) && !"2".equals(#{jgjb}) && !"1".equals(#{jgjb}))>
                      AND (BGK.VC_SHBZ IN ('1', '3', '4', '5', '6', '7', '8'))
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_qx}))>
                      AND (BGK.VC_JKDW like #{vc_qx}||'%')
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_shi}))>
                      AND (BGK.VC_JKDW like #{vc_shi}||'%')
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_jkdw}))>
                      AND (BGK.VC_JKDW = #{vc_jkdw})
                 </if>
                 <if if(StringUtils.isNotBlank(#{lrsj_ks}))>
                      AND (BGK.DT_LRSJ >= std(#{lrsj_ks},1))
                 </if>
                 <if if(StringUtils.isNotBlank(#{lrsj_js}))>
                      AND (BGK.DT_LRSJ <= std(#{lrsj_js},1))
                 </if>
                 <if if(StringUtils.isNotBlank(#{cxsjlx}) && "1".equals(#{cxsjlx}) && StringUtils.isNotBlank(#{dt_sjd_ks}))>
                      AND (BGK.DT_LRSJ >= std(#{dt_sjd_ks},1))
                 </if>
                 <if if(StringUtils.isNotBlank(#{cxsjlx}) && "1".equals(#{cxsjlx}) && StringUtils.isNotBlank(#{dt_sjd_js}))>
                      AND (BGK.DT_LRSJ <= std(#{dt_sjd_js},1))
                 </if>
                 <if if(StringUtils.isNotBlank(#{cxsjlx}) && "2".equals(#{cxsjlx}) && StringUtils.isNotBlank(#{dt_sjd_ks}))>
                      AND (BGK.DT_SHSJ >= std(#{dt_sjd_ks},1))
                 </if>
                 <if if(StringUtils.isNotBlank(#{cxsjlx}) && "2".equals(#{cxsjlx}) && StringUtils.isNotBlank(#{dt_sjd_js}))>
                      AND (BGK.DT_SHSJ <= std(#{dt_sjd_js},1))
                 </if>
                 <if if(StringUtils.isNotBlank(#{cxsjlx}) && "3".equals(#{cxsjlx}) && StringUtils.isNotBlank(#{dt_sjd_ks}))>
                      AND (BGK.DT_SWRQ >= std(#{dt_sjd_ks},1))
                 </if>
                 <if if(StringUtils.isNotBlank(#{cxsjlx}) && "3".equals(#{cxsjlx}) && StringUtils.isNotBlank(#{dt_sjd_js}))>
                      AND (BGK.DT_SWRQ <= std(#{dt_sjd_js},1))
                 </if>
                 <if if(StringUtils.isNotBlank(#{cxsjlx}) && "4".equals(#{cxsjlx}) && StringUtils.isNotBlank(#{dt_sjd_ks}))>
                      AND (BGK.DT_DCRQ >= std(#{dt_sjd_ks},1))
                 </if>
                 <if if(StringUtils.isNotBlank(#{cxsjlx}) && "4".equals(#{cxsjlx}) && StringUtils.isNotBlank(#{dt_sjd_js}))>
                      AND (BGK.DT_DCRQ <= std(#{dt_sjd_js},1))
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_bgkid}))>
                      AND (BGK.VC_BGKID = #{vc_bgkid})
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_xm}))>
                      AND (BGK.VC_XM like '%'||#{vc_xm}||'%')
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_xb}))>
                      AND (BGK.VC_XB = #{vc_xb})
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_gbsy}))>
                      AND ((BGK.VC_GBSY LIKE '%'||#{vc_gbsy}||'%') OR (BGK.vc_azjswjb LIKE  '%'||#{vc_gbsy}||'%'))
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_swdd}))>
                      AND (BGK.VC_SWDD = #{vc_swdd})
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_sznl_ks}))>
                      AND (BGK.VC_SZNL >= #{vc_sznl_ks})
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_sznl_js}))>
                      AND (BGK.VC_SZNL <= #{vc_sznl_js})
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_hkshen}))>
                      AND (BGK.VC_HKQCS = #{vc_hkshen})
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_hks}))>
                      AND (BGK.VC_HKSDM = #{vc_hks})
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_hkqx}))>
                      AND (BGK.VC_HKQXDM = #{vc_hkqx})
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_hkjd}))>
                      AND (BGK.VC_HKJDDM = #{vc_hkjd})
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_hkjw}))>
                      AND (BGK.VC_HKJW = #{vc_hkjw})
                 </if>
                 <if if(StringUtils.isNotBlank(#{fenleitjks}))>
                      AND (to_number(BGK.FENLEITJ) >= to_number(#{fenleitjks}))
                 </if>
                 <if if(StringUtils.isNotBlank(#{fenleitjjs}))>
                      AND (to_number(BGK.FENLEITJ) <= to_number(#{fenleitjjs}))
                 </if>
                 ORDER BY BGK.DT_CJSJ DESC)
                <if if(1==1)>
         WHERE rownum <= #{rn_e})
 WHERE rn >= #{rn_s}  
 </if>                                                                                                            