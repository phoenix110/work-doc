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
                       vc_zyh,
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