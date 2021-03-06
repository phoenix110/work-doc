SELECT fh.id,
       fh.sfkid,
       bg.vc_bgkid,
       fh.cctjid,
       #{vc_csflx} vc_csflx,
			 decode(#{vc_csflx},'1','初访','2','随访') csflx,
			 bg.vc_bgkcode bgkbh,
       '3' vc_bllx,
       '糖尿病' bllx,
       bg.vc_bgkzt,
       hz.vc_hzxm xm,
       DECODE(hz.vc_hzxb,'1','男','2','女') xb,
       hz.vc_sfzh sfzh,
       (select mc from P_YLJG where dm=bg.vc_gldw) bkdw,
       decode(hz.vc_hkshen,
              '0',
              '浙江省' || pkg_zjmb_tnb.fun_getxzqhmc(hz.vc_hks) ||
              pkg_zjmb_tnb.fun_getxzqhmc(hz.vc_hkqx) ||
              pkg_zjmb_tnb.fun_getxzqhmc(hz.vc_hkjd) || hz.vc_hkjw ||
              hz.vc_hkxxdz,
              '1',
              '外省') hjdz,
       hz.vc_lxdh lxdh,
       fn_zjjk_zlfh_csf_getfhjg(#{vc_csflx}, #{vc_bllx},fh.id) sffh,
       fh.fhbz fhbz,
       fh.fhzt vc_fhzt,
       fh.shyj,
       DECODE(fh.fhzt,'0','未开始','1','进行中','2','待复核','3','复核通过','4','复核不通过','5','审核通过','6','审核不通过') fhzt,
       bg.vc_zyh,
       lag(fh.fhzt, 1, null) over (order by fh.ccxh asc) last_fhzt,
       decode(hz.vc_hkshen, '0', hz.vc_hkqx || ' ' || pkg_zjmb_tnb.fun_getxzqhmc(hz.vc_hkqx), '1', '') hkqx_text,
       decode(hz.vc_hkshen, '0', hz.vc_hkjd || ' ' || pkg_zjmb_tnb.fun_getxzqhmc(hz.vc_hkjd), '1', '') hkjd_text,
       DECODE(bg.vc_bgkzt,'0','可用卡','2','死卡','3','误诊卡','4','重复卡','5','删除卡','6','失访卡','7','死亡卡') kpzt_text,
       hz.vc_hzxb || ' ' || decode(hz.vc_hzxb, '1', '男', '2', '女') xb_text,
       pkg_zjmb_tnb.fun_getcommdic('C_TNB_TNBLX', bg.vc_tnblx) tnblx_text,
       decode(bg.vc_sfsw, '0', '否', '1', '是') sfsw_text,
       bg.vc_swicdmc swicdmc,
       dts(bg.dt_swrq, 0) swrq,
       dts(bg.dt_sczdrq, 0) sczdrq,
       COUNT(1) OVER() total
  FROM zjjk_csf_zlfh fh, zjjk_tnb_sfk sf, zjjk_tnb_bgk bg, zjjk_tnb_hzxx hz
 WHERE fh.sfkid = sf.vc_sfkid
   AND sf.vc_bgkid = bg.vc_bgkid
   AND sf.vc_hzid = hz.vc_personid
   AND fh.bllx = '3'
   AND fh.zt = '1'
   AND fh.csflx = #{vc_csflx}
   AND bg.vc_gldw LIKE #{vc_bgdw}||'%'
   AND (('1' = #{vc_csflx} AND cctjid=#{cfccsjd}) OR ('2' = #{vc_csflx} AND cctjid=#{sfccsjd}))   
   order by fh.ccxh asc                                                                                                                                                                                                                                                                                                                                                                                                                                               