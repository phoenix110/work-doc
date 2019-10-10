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
       COUNT(1) OVER() total
  FROM zjjk_csf_zlfh fh, zjmb_sw_bgk bg
 WHERE fh.sfkid = bg.vc_bgkid
   AND bg.vc_bgkid = bg.vc_bgkid
   AND fh.bllx = '5'
   AND fh.zt = '1'
   AND bg.vc_gldwdm LIKE #{vc_bgdw}||'%'   
   AND (('1' = #{vc_csflx} AND cctjid=#{cfccsjd}) OR ('2' = #{vc_csflx} AND cctjid=#{sfccsjd}))    
   order by fh.ccxh asc                                                                                                                                                                                                                                                                                                                                                                             
