SELECT fh.id,
       fh.sfkid,
       bg.vc_bgkid,
       fh.cctjid,
       #{vc_csflx} vc_csflx,
       decode(#{vc_csflx},'1','初访','2','随访') csflx,
       bg.vc_bgkbh bgkbh,
       #{vc_bllx} vc_bllx,
       decode(#{vc_bllx},'1','脑卒中','2','冠心病') bllx,
       bg.vc_kzt vc_bgkzt,
       bg.vc_hzxm xm,
       DECODE(bg.vc_hzxb,'1','男','2','女') xb,
       bg.vc_hzsfzh sfzh,
       (select mc from P_YLJG where dm=bg.vc_bkdwyy) bkdw,
			 decode(bg.vc_czhks,
              '0',
              '浙江省' || pkg_zjmb_tnb.fun_getxzqhmc(bg.vc_czhksi) ||
              pkg_zjmb_tnb.fun_getxzqhmc(bg.vc_czhkqx) ||
              pkg_zjmb_tnb.fun_getxzqhmc(bg.vc_czhkjd) || bg.vc_czhkjw ||
              bg.vc_czhkxxdz,
              '1',
              '外省') hjdz,
       bg.vc_hzjtdh lxdh,
       fh.fhbz fhbz,
       fn_zjjk_zlfh_csf_getfhjg(#{vc_csflx}, #{vc_bllx},fh.id) sffh,
       fh.fhzt vc_fhzt,
       fh.shyj,
       DECODE(fh.fhzt,'0','未开始','1','进行中','2','待复核','3','复核通过','4','复核不通过','5','审核通过','6','审核不通过') fhzt,
       bg.vc_zyh,
       lag(fh.fhzt, 1, null) over (order by fh.ccxh asc) last_fhzt,
       COUNT(1) OVER() total
  FROM zjjk_csf_zlfh fh, zjjk_xnxg_bgk bg, zjjk_xnxg_sfk sf
 WHERE fh.sfkid = sf.vc_sfkid
   AND bg.vc_bgkid = sf.vc_bgkid
   AND fh.bllx = #{vc_bllx}
   AND fh.zt = '1'
   AND fh.bccjgid LIKE #{vc_bgdw}||'%'
   AND (('1' = #{vc_csflx} AND cctjid=#{cfccsjd}) OR ('2' = #{vc_csflx} AND cctjid=#{sfccsjd}))  
   order by fh.ccxh asc                                                                                                                                                                                                                                                                                                                                                                                                            