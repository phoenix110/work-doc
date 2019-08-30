SELECT sf.vc_sfkid,
       sf.vc_bgkid,
       sf.vc_hzid,
       sf.vc_bgkcode bgkbh,
       sf.vc_bgkzt,
       '4' vc_bllx,
       '肿瘤' bllx,
       #{vc_csflx} vc_csflx,
       decode(#{vc_csflx}, '1', '初访', '2', '随访') csflx,
       decode(#{vc_csflx}, '1', #{cfccsjd}, '2', #{sfccsjd}) vc_cctjid,
       hzxx.vc_hzxm xm,
       decode(hzxx.vc_hzxb, '1', '男', '2', '女') xb,
       hzxx.vc_sfzh sfzh,
       hzxx.vc_sjhm lxdh,
       decode(hzxx.vc_hksfdm,
              '0',
              '浙江省' || pkg_zjmb_tnb.fun_getxzqhmc(hzxx.vc_hksdm) ||
              pkg_zjmb_tnb.fun_getxzqhmc(hzxx.vc_hkqxdm) ||
              pkg_zjmb_tnb.fun_getxzqhmc(hzxx.vc_hkjddm) || hzxx.vc_hkjwdm ||
              hzxx.vc_hkxxdz,
              '1',
              '外省') hjdz,
       vc_bgdw,
       vc_zyh,
       (SELECT mc FROM p_yljg WHERE dm = sf.vc_bgdw) bkdw,
       rn
  FROM (SELECT vc_sfkid,
               vc_bgkid,
               vc_hzid,
               vc_bgkcode,
               vc_bgkzt,
               vc_bgdw,
               vc_zyh,
               rownum rn
          FROM (SELECT vc_sfkid,
                       vc_bgkid,
                       vc_hzid,
                       vc_bgkcode,
                       vc_bgkzt,
                       vc_bgdw,
                       vc_zyh,
                       row_number() OVER(PARTITION BY vc_bgdw ORDER BY nvl2(vc_zyh, 0, 1) asc, dbms_random.value) rowsnumber,
                       COUNT(1) over(PARTITION BY vc_bgdw) countnumber
                  FROM (SELECT row_number() over(PARTITION BY sfk.vc_bgkid ORDER BY sfk.dt_cjsj) csfrn,
                               sfk.vc_sfkid,
                               sfk.vc_bgkid,
                               sfk.dt_cjsj,
                               bgk.vc_hzid,
                               bgk.vc_bgkid vc_bgkcode,
                               bgk.vc_bgkzt,
                               bgk.vc_bgdw,
                               bgk.vc_zyh,
                               bgk.vc_icd10
                          FROM zjjk_zl_sfk sfk, zjjk_zl_bgk bgk
                         WHERE sfk.vc_bgkid = bgk.vc_bgkid
                           AND bgk.vc_bgdw LIKE #{vc_bgdw}||'%'
                           AND EXISTS (SELECT 1
                                 FROM p_yljgjb jg
                                WHERE bgk.vc_bgdw = jg.jgdm
                                  AND jg.jbgjb IN ('乡级','村级')) 
                           AND bgk.vc_scbz = '0')
                 WHERE ((#{vc_csflx} = '1' AND csfrn = 1) OR
                       (#{vc_csflx} = '2' AND csfrn > 1))
                   AND ((#{vc_csflx} = '1' AND EXISTS
                        (SELECT 1
                            FROM zjjk_zlfhsj_cf cf
                           WHERE trunc(dt_cjsj) > trunc(cf.dt_ksrq)
                             AND trunc(dt_cjsj) <= trunc(cf.dt_jsrq)
                             AND cf.ccbz LIKE '%4%'
                             AND (cf.zlicd10 is null or cf.zlicd10||',' LIKE '%'||SUBSTR(vc_icd10,0,3)||',%')
                             AND cf.zt = '1')) OR
                       (#{vc_csflx} = '2' AND EXISTS
                        (SELECT 1
                            FROM zjjk_zlfhsj_sf sf
                           WHERE trunc(dt_cjsj) > trunc(sf.dt_ksrq)
                             AND trunc(dt_cjsj) <= trunc(sf.dt_jsrq)
                             AND sf.ccbz LIKE '%4%'
                             AND (sf.zlicd10 is null or sf.zlicd10||',' LIKE '%'||SUBSTR(vc_icd10,0,3)||',%')
                             AND sf.zt = '1')))
                   AND NOT EXISTS
                 (SELECT 1
                          FROM zjjk_csf_zlfh fh
                         WHERE fh.csflx = #{vc_csflx}
                           AND fh.bllx = '4'
                           AND fh.zt = '1'
                           AND fh.sfkid = vc_sfkid))
         WHERE rowsnumber <=
         <if if(StringUtils.isNotBlank(#{vc_csflx}) && "1".equals(#{vc_csflx}))>
             (SELECT tj.ccts FROM zjjk_zlfhsj_cf tj WHERE tj.zt = '1')
         </if>
         <if if(StringUtils.isNotBlank(#{vc_csflx}) && "2".equals(#{vc_csflx}))>
             (SELECT tj.ccts FROM zjjk_zlfhsj_sf tj WHERE tj.zt = '1')
         </if>
         ) sf,
       zjjk_zl_hzxx hzxx
 WHERE sf.vc_hzid = hzxx.vc_personid
   AND rn >= 0                                                                                                                                                                                       