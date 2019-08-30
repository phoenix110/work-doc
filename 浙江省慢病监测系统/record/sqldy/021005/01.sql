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
       vc_bkdwyy vc_bgdw,
       vc_zyh,
       (SELECT mc FROM p_yljg WHERE dm = vc_bkdwyy) bkdw,
       rn
  FROM (SELECT vc_sfkid,
               vc_bgkid,
               vc_bgkbh,
               vc_kzt,
               vc_bkdwyy,
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
               rownum rn
          FROM (SELECT vc_sfkid,
                       vc_bgkid,
                       vc_bgkbh,
                       vc_kzt,
                       vc_bkdwyy,
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
                       row_number() OVER(PARTITION BY vc_bkdwyy ORDER BY nvl2(vc_zyh, 0, 1) asc, dbms_random.value) rowsnumber,
                       COUNT(1) over(PARTITION BY vc_bkdwyy) countnumber
                  FROM (SELECT row_number() over(PARTITION BY sfk.vc_bgkid ORDER BY sfk.dt_cjsj) csfrn,
                               sfk.vc_sfkid,
                               sfk.vc_bgkid,
                               sfk.dt_cjsj,
                               bgk.vc_bgkbh,
                               bgk.vc_kzt,
                               bgk.vc_bkdwyy,
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
                               bgk.vc_zyh
                          FROM zjjk_xnxg_sfk sfk, zjjk_xnxg_bgk bgk
                         WHERE sfk.vc_bgkid = bgk.vc_bgkid
                           AND bgk.vc_bkdwyy LIKE #{vc_bgdw}||'%'
                           AND bgk.vc_scbz = '2'
                           AND EXISTS (SELECT 1
                                 FROM p_yljgjb jg
                                WHERE bgk.vc_bkdwyy = jg.jgdm
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
                             AND cf.zt = '1')) OR
                       (#{vc_csflx} = '2' AND EXISTS
                        (SELECT 1
                            FROM zjjk_zlfhsj_sf sf
                           WHERE trunc(dt_cjsj) > trunc(sf.dt_ksrq)
                             AND trunc(dt_cjsj) <= trunc(sf.dt_jsrq)
                             AND sf.ccbz LIKE '%1%'
                             AND (sf.nczicd10 is null or sf.nczicd10||',' LIKE '%'||SUBSTR(vc_icd10,0,3)||',%')
                             AND sf.zt = '1'))))
         WHERE rowsnumber <= 
         <if if(StringUtils.isNotBlank(#{vc_csflx}) && "1".equals(#{vc_csflx}))>
             (SELECT tj.ccts FROM zjjk_zlfhsj_cf tj WHERE tj.zt = '1')
         </if>
         <if if(StringUtils.isNotBlank(#{vc_csflx}) && "2".equals(#{vc_csflx}))>
             (SELECT tj.ccts FROM zjjk_zlfhsj_sf tj WHERE tj.zt = '1')
         </if>
         )                                                                                                                                                                                                                                                  