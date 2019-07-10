SELECT bkzt,
       bgkbh,
       decode(bllx, '1', '脑卒中', '2', '冠心病', '3', '糖尿病', '4', '肿瘤', '5', '死亡') bllx,
       decode(csflx, '1', '初访', '2', '随访') csflx,
       xm,
       decode(xb, '1', '男', '2', '女') xb,
       sfzh,
       hjdz,
       lxdh,
			 id fhid,
			 bgkid,
			 bllx bllx_code,
			 csflx csflx_code,
       fn_zjjk_zlfh_csf_getfhjg(csflx, bllx,id) sffh,
       decode(fhzt,
              '0',
              '未开始',
              '1',
              '进行中',
              '2',
              '待复核',
              '3',
              '复核通过',
              '4',
              '复核不通过',
              '5',
              '审核通过',
              '6',
              '审核不通过') fhzt,
       rn,
       total
  FROM (SELECT id,
               bgkid,
               bkzt,
               bgkbh,
               bllx,
               csflx,
               xm,
               xb,
               sfzh,
               hjdz,
               lxdh,
               fhzt,
               rn,
               total
          FROM (SELECT id,
                       bgkid,
                       bkzt,
                       bgkbh,
                       bllx,
                       csflx,
                       xm,
                       xb,
                       sfzh,
                       hjdz,
                       lxdh,
                       fhzt,
                       rownum rn,
                       COUNT(1) over() total
                  FROM (
                        
                        SELECT  fh.id id,
                                xnxgbk.vc_bgkid bgkid,
                                xnxgbk.vc_kzt bkzt,
                                xnxgbk.vc_bgkbh bgkbh,
                                nvl2(xnxgbk.vc_gxbzd, '1', '2') bllx,
                                fh.csflx csflx,
                                xnxgbk.vc_hzxm xm,
                                xnxgbk.vc_hzxb xb,
                                xnxgbk.vc_hzsfzh sfzh,
                                decode(xnxgbk.vc_czhks,
                                       '0',
                                       '浙江省' ||
                                       pkg_zjmb_tnb.fun_getxzqhmc(xnxgbk.vc_czhksi) ||
                                       pkg_zjmb_tnb.fun_getxzqhmc(xnxgbk.vc_czhkqx) ||
                                       pkg_zjmb_tnb.fun_getxzqhmc(xnxgbk.vc_czhkjd) ||
                                       xnxgbk.vc_czhkjw || xnxgbk.vc_czhkxxdz,
                                       '1',
                                       '外省') hjdz,
                                xnxgbk.vc_hzjtdh lxdh,
                                fh.fhzt fhzt
                          FROM zjjk_xnxg_bgk xnxgbk,
                                zjjk_csf_zlfh fh,
                                zjjk_xnxg_sfk xnxgsfk
                         WHERE xnxgbk.vc_bgkid = xnxgsfk.vc_bgkid
                           AND xnxgsfk.vc_sfkid = fh.sfkid
                           AND xnxgbk.vc_scbz = '2'
                           AND fh.bllx IN ('1', '2')
                              <if if(StringUtils.isNotBlank(#{bgdw}))>
                           AND xnxgbk.vc_bkdwyy LIKE #{bgdw} || '%'
                              </if>
                              <if if(StringUtils.isNotBlank(#{bgkbh}))>
                           AND xnxgbk.vc_bgkbh = #{bgkbh}
                              </if>
                              <if if(StringUtils.isNotBlank(#{xm}))>
                           AND xnxgbk.vc_hzxm LIKE '%' || #{xm} || '%'
                              </if>
                              <if if(StringUtils.isNotBlank(#{xb}))>
                           AND xnxgbk.vc_hzxb = #{xb}
                              </if>
                              <if if(StringUtils.isNotBlank(#{sfzh}))>
                           AND xnxgbk.vc_hzsfzh LIKE '%' || #{sfzh} || '%'
                              </if>
                              <if if(StringUtils.isNotBlank(#{csrq}))>
                           AND trunc(xnxgbk.dt_hzcsrq) =
                               to_date(#{csrq}, 'yyyy-mm-dd')
                              </if>
                              <if if(StringUtils.isNotBlank(#{vc_bllx}))>
                           AND fh.bllx = #{vc_bllx}
                              </if>
                              <if if(StringUtils.isNotBlank(#{vc_csflx}))>
                           AND fh.csflx = #{vc_csflx}
                              </if>
                              <if if(StringUtils.isNotBlank(#{vc_csflx}) && "1".equals(#{vc_csflx}) && StringUtils.isNotBlank(#{cfccsjd}))>
                           AND fh.cctjid = #{cfccsjd}
                              </if>
                              <if if(StringUtils.isNotBlank(#{vc_csflx}) && "2".equals(#{vc_csflx}) && StringUtils.isNotBlank(#{sfccsjd}))>
                           AND fh.cctjid = #{sfccsjd}
                              </if>
                        <if if(1 == 1)>
                        UNION ALL
                        SELECT  fh.id id,
                                tnbbk.vc_bgkid bgkid,
                                tnbbk.vc_bgkzt bkzt,
                                tnbbk.vc_bgkcode bgkbh,
                                '3' bllx,
                                fh.csflx csflx,
                                tnbhz.vc_hzxm xm,
                                tnbhz.vc_hzxb xb,
                                tnbhz.vc_sfzh sfzh,
                                decode(tnbhz.vc_hkshen,
                                       '0',
                                       '浙江省' ||
                                       pkg_zjmb_tnb.fun_getxzqhmc(tnbhz.vc_hks) ||
                                       pkg_zjmb_tnb.fun_getxzqhmc(tnbhz.vc_hkqx) ||
                                       pkg_zjmb_tnb.fun_getxzqhmc(tnbhz.vc_hkjd) ||
                                       tnbhz.vc_hkjw || tnbhz.vc_hkxxdz,
                                       '1',
                                       '外省') hjdz,
                                tnbhz.vc_lxdh lxdh,
                                fh.fhzt fhzt
                          FROM zjjk_tnb_bgk  tnbbk,
                                zjjk_tnb_hzxx tnbhz,
                                zjjk_csf_zlfh fh,
                                zjjk_tnb_sfk  tnbsf
                         WHERE tnbbk.vc_hzid = tnbhz.vc_personid
                           AND tnbsf.vc_sfkid = fh.sfkid
                           AND tnbbk.vc_bgkid = tnbsf.vc_sfkid
                           AND fh.bllx = '3'
                           AND tnbbk.vc_scbz = '0'
                              </if>
                              <if if(StringUtils.isNotBlank(#{bgdw}))>
                           AND tnbbk.vc_bgdw LIKE #{bgdw} || '%'
                              </if>
                              <if if(StringUtils.isNotBlank(#{bgkbh}))>
                           AND tnbbk.vc_bgkcode = #{bgkbh}
                              </if>
                              <if if(StringUtils.isNotBlank(#{xm}))>
                           AND tnbhz.vc_hzxm LIKE '%' || #{xm} || '%'
                              </if>
                              <if if(StringUtils.isNotBlank(#{xb}))>
                           AND tnbhz.vc_hzxb = #{xb}
                              </if>
                              <if if(StringUtils.isNotBlank(#{sfzh}))>
                           AND tnbhz.vc_sfzh LIKE '%' || #{sfzh} || '%'
                              </if>
                              <if if(StringUtils.isNotBlank(#{csrq}))>
                           AND trunc(tnbhz.dt_hzcsrq) =
                               to_date(#{csrq}, 'yyyy-mm-dd')
                              </if>
                              <if if(StringUtils.isNotBlank(#{vc_bllx}))>
                           AND '3' = #{vc_bllx}
                              </if>
                              <if if(StringUtils.isNotBlank(#{vc_csflx}))>
                           AND fh.csflx = #{vc_csflx}
                              </if>
                              <if if(StringUtils.isNotBlank(#{vc_csflx}) && "1".equals(#{vc_csflx}) && StringUtils.isNotBlank(#{cfccsjd}))>
                           AND fh.cctjid = #{cfccsjd}
                              </if>
                              <if if(StringUtils.isNotBlank(#{vc_csflx}) && "2".equals(#{vc_csflx}) && StringUtils.isNotBlank(#{sfccsjd}))>
                           AND fh.cctjid = #{sfccsjd}
                              </if>
                        <if if(1 == 1)>
                        
                        UNION ALL
                        SELECT  fh.id id,
                                zlbk.vc_bgkid bgkid,
                                zlbk.vc_bgkzt bkzt,
                                zlbk.vc_bgkid bgkbh,
                                '4' bllx,
                                fh.csflx csflx,
                                zlhz.vc_hzxm xm,
                                zlhz.vc_hzxb xb,
                                zlhz.vc_sfzh sfzh,
                                decode(zlhz.vc_hksfdm,
                                       '0',
                                       '浙江省' ||
                                       pkg_zjmb_tnb.fun_getxzqhmc(zlhz.vc_hksdm) ||
                                       pkg_zjmb_tnb.fun_getxzqhmc(zlhz.vc_hkqxdm) ||
                                       pkg_zjmb_tnb.fun_getxzqhmc(zlhz.vc_hkjddm) ||
                                       zlhz.vc_hkjwdm || zlhz.vc_hkxxdz,
                                       '1',
                                       '外省') hjdz,
                                zlhz.vc_jtdh lxdh,
                                fh.fhzt fhzt
                          FROM zjjk_zl_bgk   zlbk,
                                zjjk_zl_hzxx  zlhz,
                                zjjk_csf_zlfh fh,
                                zjjk_zl_sfk   zlsf
                         WHERE zlbk.vc_hzid = zlhz.vc_personid
                           AND zlsf.vc_sfkid = fh.sfkid
                           AND zlbk.vc_bgkid = zlsf.vc_bgkid
                           AND fh.bllx = '4'
                           AND zlbk.vc_scbz = '0'
                              </if>
                              <if if(StringUtils.isNotBlank(#{bgdw}))>
                           AND zlbk.vc_bgdw LIKE #{bgdw} || '%'
                              </if>
                              <if if(StringUtils.isNotBlank(#{bgkbh}))>
                           AND zlbk.vc_bgkid = #{bgkbh}
                              </if>
                              <if if(StringUtils.isNotBlank(#{xm}))>
                           AND zlhz.vc_hzxm LIKE '%' || #{xm} || '%'
                              </if>
                              <if if(StringUtils.isNotBlank(#{xb}))>
                           AND zlhz.vc_hzxb = #{xb}
                              </if>
                              <if if(StringUtils.isNotBlank(#{sfzh}))>
                           AND zlhz.vc_sfzh LIKE '%' || #{sfzh} || '%'
                              </if>
                              <if if(StringUtils.isNotBlank(#{csrq}))>
                           AND trunc(zlhz.dt_hzcsrq) =
                               to_date(#{csrq}, 'yyyy-mm-dd')
                              </if>
                              <if if(StringUtils.isNotBlank(#{vc_bllx}))>
                           AND '4' = #{vc_bllx}
                              </if>
                              <if if(StringUtils.isNotBlank(#{vc_csflx}))>
                           AND fh.csflx = #{vc_csflx}
                              </if>
                              <if if(StringUtils.isNotBlank(#{vc_csflx}) && "1".equals(#{vc_csflx}) && StringUtils.isNotBlank(#{cfccsjd}))>
                           AND fh.cctjid = #{cfccsjd}
                              </if>
                              <if if(StringUtils.isNotBlank(#{vc_csflx}) && "2".equals(#{vc_csflx}) && StringUtils.isNotBlank(#{sfccsjd}))>
                           AND fh.cctjid = #{sfccsjd}
                              </if>
                        <if if(1 == 1)>
                        
                        UNION ALL
                        SELECT  fh.id id,
                                swbk.vc_bgkid bgkid,
                                swbk.vc_bgklb bkzt,
                                swbk.vc_bgkid bgkbh,
                                '5' bllx,
                                fh.csflx csflx,
                                swbk.vc_xm xm,
                                swbk.vc_xb xb,
                                swbk.vc_sfzhm sfzh,
                                decode(swbk.vc_hkqcs,
                                       '0',
                                       '浙江省' ||
                                       pkg_zjmb_tnb.fun_getxzqhmc(swbk.vc_hksdm) ||
                                       pkg_zjmb_tnb.fun_getxzqhmc(swbk.vc_hkqxdm) ||
                                       pkg_zjmb_tnb.fun_getxzqhmc(swbk.vc_hkjddm) ||
                                       swbk.vc_hkjw || swbk.vc_hkxxdz,
                                       '1',
                                       '外省') hjdz,
                                swbk.vc_jslxdh lxdh,
                                fh.fhzt fhzt
                          FROM zjmb_sw_bgk swbk, zjjk_csf_zlfh fh
                         WHERE swbk.vc_bgkid = fh.sfkid
                           AND swbk.vc_scbz = '2'
                           AND fh.bllx = '5'
                              </if>
                              <if if(StringUtils.isNotBlank(#{bgdw}))>
                           AND swbk.vc_gldwdm LIKE #{bgdw} || '%'
                              </if>
                              <if if(StringUtils.isNotBlank(#{bgkbh}))>
                           AND swbk.vc_bgkid = #{bgkbh}
                              </if>
                              <if if(StringUtils.isNotBlank(#{xm}))>
                           AND swbk.vc_xm LIKE '%' || #{xm} || '%'
                              </if>
                              <if if(StringUtils.isNotBlank(#{xb}))>
                           AND swbk.vc_xb = #{xb}
                              </if>
                              <if if(StringUtils.isNotBlank(#{sfzh}))>
                           AND swbk.vc_sfzhm LIKE '%' || #{sfzh} || '%'
                              </if>
                              <if if(StringUtils.isNotBlank(#{csrq}))>
                           AND trunc(swbk.dt_csrq) =
                               to_date(#{csrq}, 'yyyy-mm-dd')
                              </if>
                              <if if(StringUtils.isNotBlank(#{vc_bllx}))>
                           AND '5' = #{vc_bllx}
                              </if>
                              <if if(StringUtils.isNotBlank(#{vc_csflx}))>
                           AND fh.csflx = #{vc_csflx}
                              </if>
                              <if if(StringUtils.isNotBlank(#{vc_csflx}) && "1".equals(#{vc_csflx}) && StringUtils.isNotBlank(#{cfccsjd}))>
                           AND fh.cctjid = #{cfccsjd}
                              </if>
                              <if if(StringUtils.isNotBlank(#{vc_csflx}) && "2".equals(#{vc_csflx}) && StringUtils.isNotBlank(#{sfccsjd}))>
                           AND fh.cctjid = #{sfccsjd}
                              </if>
                        <if if(1 == 1)>
                        ))
         WHERE rownum <= #{rn_e})
 WHERE rn >= #{rn_s}
</if>                                                                                                                                                                                                                                                                                                                                                                                                            