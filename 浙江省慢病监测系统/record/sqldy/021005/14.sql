SELECT fh.id,
       fh.sfkid,
       bg.vc_bgkid,
       fh.cctjid,
       #{vc_csflx} vc_csflx,
			 decode(#{vc_csflx},'1','初访','2','随访') csflx,
			 bg.vc_bgkid bgkbh,
       '4' vc_bllx,
       '肿瘤' bllx,
       bg.vc_bgkzt,
       hz.vc_hzxm xm,
       DECODE(hz.vc_hzxb,'1','男','2','女') xb,
       hz.vc_sfzh sfzh,
       (select mc from P_YLJG where dm=bg.vc_gldw) bkdw,
       decode(hz.vc_hksfdm ,
              '0',
              '浙江省' || pkg_zjmb_tnb.fun_getxzqhmc(hz.vc_hksdm ) ||
              pkg_zjmb_tnb.fun_getxzqhmc(hz.vc_hkqxdm ) ||
              pkg_zjmb_tnb.fun_getxzqhmc(hz.vc_hkjddm ) || hz.vc_hkjwdm  ||
              hz.vc_hkxxdz ,
              '1',
              '外省') hjdz,
       hz.vc_sjhm lxdh,
       fn_zjjk_zlfh_csf_getfhjg(#{vc_csflx}, #{vc_bllx},fh.id) sffh,
       fh.fhbz fhbz,
       fh.fhzt vc_fhzt,
       fh.shyj,
       DECODE(fh.fhzt,'0','未开始','1','进行中','2','待复核','3','复核通过','4','复核不通过','5','审核通过','6','审核不通过') fhzt,
       bg.vc_zyh,
       lag(fh.fhzt, 1, null) over (order by fh.ccxh asc) last_fhzt,
       COUNT(1) OVER() total
  FROM zjjk_csf_zlfh fh, zjjk_zl_sfk sf, zjjk_zl_bgk bg, zjjk_zl_hzxx hz
 WHERE fh.sfkid = sf.vc_sfkid
   AND sf.vc_bgkid = bg.vc_bgkid
   AND bg.vc_hzid = hz.vc_personid
   AND fh.bllx = '4'
   AND fh.zt = '1'
   AND fh.csflx = #{vc_csflx}
   AND bg.vc_gldw LIKE #{vc_bgdw}||'%'
   AND (('1' = #{vc_csflx} AND cctjid=#{cfccsjd}) OR ('2' = #{vc_csflx} AND cctjid=#{sfccsjd}))   
   order by fh.ccxh asc                                                                                                                                                                                                                                                                                                                             