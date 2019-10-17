SELECT sf.vc_sfkid,
       sf.vc_bgkid,
       sf.vc_hzid,
       sf.vc_bgkcode bgkbh,
       sf.vc_bgkzt,
       '3' vc_bllx,
       '糖尿病' bllx,
       #{vc_csflx} vc_csflx,
       decode(#{vc_csflx}, '1', '初访', '2', '随访') csflx,
       decode(#{vc_csflx}, '1', #{cfccsjd}, '2', #{sfccsjd}) vc_cctjid,
       hzxx.vc_hzxm xm,
       decode(hzxx.vc_hzxb, '1', '男', '2', '女') xb,
       hzxx.vc_sfzh sfzh,
       hzxx.vc_lxdh lxdh,
       decode(hzxx.vc_hkshen,
              '0',
              '浙江省' || pkg_zjmb_tnb.fun_getxzqhmc(hzxx.vc_hks) ||
              pkg_zjmb_tnb.fun_getxzqhmc(hzxx.vc_hkqx) ||
              pkg_zjmb_tnb.fun_getxzqhmc(hzxx.vc_hkjd) || hzxx.vc_hkjw ||
              hzxx.vc_hkxxdz,
              '1',
              '外省') hjdz,
       vc_gldw vc_bgdw,
       vc_zyh,
       (SELECT mc FROM p_yljg WHERE dm = sf.vc_gldw) bkdw,
       decode(hzxx.vc_hkshen, '0', hzxx.vc_hkqx || ' ' || pkg_zjmb_tnb.fun_getxzqhmc(hzxx.vc_hkqx), '1', '') hkqx_text,
       decode(hzxx.vc_hkshen, '0', hzxx.vc_hkjd || ' ' || pkg_zjmb_tnb.fun_getxzqhmc(hzxx.vc_hkjd), '1', '') hkjd_text,
       DECODE(sf.vc_bgkzt,'0','可用卡','2','死卡','3','误诊卡','4','重复卡','5','删除卡','6','失访卡','7','死亡卡') kpzt_text,
       hzxx.vc_hzxb || ' ' || decode(hzxx.vc_hzxb, '1', '男', '2', '女') xb_text,
       pkg_zjmb_tnb.fun_getcommdic('C_TNB_TNBLX', vc_tnblx) tnblx_text,
       decode(vc_sfsw, '0', '否', '1', '是') sfsw_text,
       vc_swicdmc swicdmc,
       dts(dt_swrq, 0) swrq,
       dts(dt_sczdrq, 0) sczdrq,
       rn
  FROM (SELECT vc_sfkid,
               vc_bgkid,
               vc_hzid,
               vc_bgkcode,
               vc_bgkzt,
               vc_gldw,
               vc_zyh,
               vc_tnblx,
               vc_sfsw,
               vc_swicdmc,
               dt_swrq,
               dt_sczdrq,
               rownum rn
          FROM (SELECT vc_sfkid,
                       vc_bgkid,
                       vc_hzid,
                       vc_bgkcode,
                       vc_bgkzt,
                       vc_gldw,
                       vc_zyh,
                       vc_tnblx,
                       vc_sfsw,
                       vc_swicdmc,
                       dt_swrq,
                       dt_sczdrq,
                       row_number() OVER(PARTITION BY vc_gldw ORDER BY nvl2(vc_zyh, 0, 1) asc, dbms_random.value) rowsnumber,
                       COUNT(1) over(PARTITION BY vc_gldw) countnumber
                  FROM (SELECT row_number() over(PARTITION BY sfk.vc_bgkid ORDER BY sfk.dt_cjsj) csfrn,
                               sfk.vc_sfkid,
                               sfk.vc_bgkid,
                               sfk.vc_hzid,
                               sfk.dt_cjsj,
                               bgk.vc_bgkcode,
                               bgk.vc_bgkzt,
                               bgk.vc_icd10,
                               bgk.vc_zyh,
                               bgk.vc_gldw,
                               bgk.vc_tnblx,
                               bgk.vc_sfsw,
                               bgk.vc_swicdmc,
                               bgk.dt_swrq,
                               bgk.dt_sczdrq
                          FROM zjjk_tnb_sfk sfk, zjjk_tnb_bgk bgk
                         WHERE sfk.vc_bgkid = bgk.vc_bgkid
                           AND bgk.vc_gldw LIKE #{vc_bgdw}||'%'
                           AND EXISTS (SELECT 1
                                 FROM p_yljgjb jg
                                WHERE bgk.vc_gldw = jg.jgdm
                                  AND jg.jbgjb IN ('乡级','村级')) 
                           AND bgk.vc_scbz = '0')
                 WHERE ((#{vc_csflx} = '1' AND csfrn = 1) OR
                       (#{vc_csflx} = '2' AND csfrn > 1))
                   AND ((#{vc_csflx} = '1' AND EXISTS
                        (SELECT 1
                            FROM zjjk_zlfhsj_cf cf
                           WHERE trunc(dt_cjsj) > trunc(cf.dt_ksrq)
                             AND trunc(dt_cjsj) <= trunc(cf.dt_jsrq)
                             AND cf.ccbz LIKE '%3%'
                             AND (cf.tnbicd10 is null or cf.tnbicd10||',' LIKE '%'||SUBSTR(vc_icd10,0,3)||',%')
                             AND (cf.bgkzt is null or vc_bgkzt in (select column_value from TABLE(split(cf.bgkzt, ','))))
                             AND cf.zt = '1')) OR
                       (#{vc_csflx} = '2' AND EXISTS
                        (SELECT 1
                            FROM zjjk_zlfhsj_sf sf
                           WHERE trunc(dt_cjsj) > trunc(sf.dt_ksrq)
                             AND trunc(dt_cjsj) <= trunc(sf.dt_jsrq)
                             AND sf.ccbz LIKE '%3%'
                             AND (sf.tnbicd10 is null or sf.tnbicd10||',' LIKE '%'||SUBSTR(vc_icd10,0,3)||',%')
                             AND (sf.bgkzt is null or vc_bgkzt in (select column_value from TABLE(split(sf.bgkzt, ','))))
                             AND sf.zt = '1')))
                   AND NOT EXISTS
                 (SELECT 1
                          FROM zjjk_csf_zlfh fh
                         WHERE fh.csflx = #{vc_csflx}
                           AND fh.bllx = '3'
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
       zjjk_tnb_hzxx hzxx
 WHERE sf.vc_hzid = hzxx.vc_personid
   AND rn >= 0                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                