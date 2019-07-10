SELECT bkzt,
       bgkbh,
			 bgkid,
			 fhid,
       ccbz,
       DECODE(mblx,'1','脑卒中','2','冠心病','3','糖尿病','4','肿瘤') mblx,
       xm,
       decode(xb, '1', '男', '2', '女') xb,
       sfzh,
       (SELECT mc FROM p_yljg WHERE dm = bgdw) bgdw,
       fn_zjjk_zlsh_getzlwzx(mblx, bgkid, cctjid) zlwzx,
       fn_zjjk_zlfh_mb_getfhjg(mblx, bgkid, cctjid) fhjgpd,
       DECODE(fhzt, '0', '未开始', '1', '进行中', '2', '待复核', '3', '复核通过',
                               '4', '复核不通过', '5', '审核通过', '6', '审核不通过') fhzt,
       rn,
       total
  FROM (SELECT bgkid,bkzt,fhid,ccbz, bgkbh, mblx, xm, xb, sfzh, bgdw, cctjid, fhzt, rn, total
          FROM (SELECT bgkid,bkzt,fhid,ccbz, bgkbh, mblx, xm, xb, sfzh, bgdw, cctjid, fhzt, rownum rn, COUNT(1) over() total
                  FROM (SELECT xnxgbk.vc_bgkid bgkid,
                               xnxgbk.vc_kzt bkzt,
                               xnxgbk.vc_bgkbh bgkbh,
                               nvl2(vc_gxbzd, '2', '1') mblx,
                               xnxgbk.vc_hzxm xm,
                               xnxgbk.vc_hzxb xb,
                               xnxgbk.vc_hzsfzh sfzh,
                               xnxgbk.vc_bkdwyy bgdw,
                               fh.cctjid cctjid,
                               fh.id fhid,
                               fh.ccbz,
                               fh.fhzt fhzt
                          FROM zjjk_xnxg_bgk xnxgbk, zjjk_mb_zlfh fh
                         WHERE xnxgbk.vc_bgkid = fh.bgkid
                           AND xnxgbk.vc_scbz = '2'
                           AND fh.mblx IN ('1','2')
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
                         <if if(StringUtils.isNotBlank(#{bgdw}))>
                           AND xnxgbk.vc_bkdwyy LIKE #{bgdw} || '%'
                         </if>
                         <if if(StringUtils.isNotBlank(#{zyh}))>
                           AND xnxgbk.vc_zyh LIKE '%' || #{zyh} || '%'
                         </if>
                         <if if(StringUtils.isNotBlank(#{mblx}))>
                           AND (('1' = #{mblx} AND vc_gxbzd IS NULL) OR ('2' = #{mblx} AND vc_gxbzd IS NOT NULL))
                         </if>
                         <if if(StringUtils.isNotBlank(#{ccsjd}))>
                           AND fh.cctjid = #{ccsjd}
                         </if>
                         <if if(1 == 1)>
                        UNION ALL
                        SELECT tnbbk.vc_bgkid bgkid,
                               tnbbk.vc_bgkzt bkzt,
                               tnbbk.vc_bgkcode bgkbh,
                               '3' mblx,
                               tnbhz.vc_hzxm xm,
                               tnbhz.vc_hzxb xb,
                               tnbhz.vc_sfzh sfzh,
                               tnbbk.vc_bgdw bgdw,
                               fh.cctjid cctjid,
                               fh.id fhid,
                               fh.ccbz,
                               fh.fhzt fhzt
                          FROM zjjk_tnb_bgk tnbbk, zjjk_tnb_hzxx tnbhz, zjjk_mb_zlfh fh
                         WHERE tnbbk.vc_hzid = tnbhz.vc_personid
                           AND tnbbk.vc_bgkid = fh.bgkid
                           AND fh.mblx = '3'
                           AND tnbbk.vc_scbz = '0'
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
                         <if if(StringUtils.isNotBlank(#{bgdw}))>
                           AND tnbbk.vc_bgdw LIKE #{bgdw} || '%'
                         </if>
                         <if if(StringUtils.isNotBlank(#{zyh}))>
                           AND tnbbk.vc_zyh LIKE '%' || #{zyh} || '%'
                         </if>
                         <if if(StringUtils.isNotBlank(#{mblx}))>
                           AND '3' = #{mblx}
                         </if>
                         <if if(StringUtils.isNotBlank(#{ccsjd}))>
                           AND fh.cctjid = #{ccsjd}
                         </if>
                         <if if(1 == 1)>
                        UNION ALL
                        SELECT zlbk.vc_bgkid bgkid,
                               zlbk.vc_bgkzt bkzt,
                               zlbk.vc_bgkid bgkbh,
                               '4' mblx,
                               zlhz.vc_hzxm xm,
                               zlhz.vc_hzxb xb,
                               zlhz.vc_sfzh sfzh,
                               zlbk.vc_bgdw bgdw,
                               fh.cctjid cctjid,
                               fh.id fhid,
                               fh.ccbz,
                               fh.fhzt fhzt
                          FROM zjjk_zl_bgk zlbk, zjjk_zl_hzxx zlhz, zjjk_mb_zlfh fh
                         WHERE zlbk.vc_hzid = zlhz.vc_personid
                           AND zlbk.vc_bgkid = fh.bgkid
                           AND fh.mblx = '4'
                           AND zlbk.vc_scbz = '0'
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
                         <if if(StringUtils.isNotBlank(#{bgdw}))>
                           AND zlbk.vc_bgdw LIKE #{bgdw} || '%'
                         </if>
                         <if if(StringUtils.isNotBlank(#{zyh}))>
                           AND zlbk.vc_zyh LIKE '%' || #{zyh} || '%'
                         </if>
                         <if if(StringUtils.isNotBlank(#{mblx}))>
                           AND '4' = #{mblx}
                         </if>
                         <if if(StringUtils.isNotBlank(#{ccsjd}))>
                           AND fh.cctjid = #{ccsjd}
                         </if>
                         <if if(1 == 1)>))
         WHERE rownum <= #{rn_e})
 WHERE rn >= #{rn_s}    
                         </if>                                                                                                                                                                                                                                                                                                                                                                                                                                               