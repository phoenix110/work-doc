SELECT a.id,
       a.bgkid,
       b.vc_bgkid,
       a.cctjid,
       b.vc_bgkcode vc_bgkbh,
       '糖尿病' vc_mblx,
       a.ccbz,
       DECODE(a.ccbz,'101','脑卒中','201','冠心病','301','糖尿病','401','肺癌','402','肝癌','403','胃癌'
                    ,'404','食管癌','405','结、直肠癌','406','女性乳腺癌','407','其他恶性肿瘤') ccbz_text,
       b.vc_bgkzt,
       c.vc_hzxm vc_xm,
       DECODE(c.vc_hzxb,'1','男','2','女') vc_hzxb_text,
			 dts(c.dt_hzcsrq, 0)  csrq,
			 dts(b.dt_sczdrq, 0)  qzrq,
			 b.vc_zdyh zdyj,
			 (SELECT icd10_code||'-'||icd10_name FROM t_icd10 WHERE t_icd10.icd10_code = b.vc_icd10) zdmc,
       c.vc_sfzh vc_sfzh,
       (select mc from P_YLJG where dm=b.vc_bgdw) bkdw_text,
       a.ccczrid,
       a.shyj,
       a.fhbz fhbz,
       fn_zjjk_zlfh_mb_getfhjg('3',b.vc_bgkid,a.cctjid) fhjgpd,
       a.fhzt fhzt,
       DECODE(a.fhzt,'0','未开始','1','进行中','2','待复核','3','复核通过','4','复核不通过','5','审核通过','6','审核不通过') fhzt_text,
       COUNT(1) OVER() total
  FROM zjjk_mb_zlfh a, zjjk_tnb_bgk b, zjjk_tnb_hzxx c
 WHERE a.bgkid = b.vc_bgkid
   AND b.vc_hzid = c.vc_personid
   AND a.mblx = '3'
   AND a.zt = '1'
   AND b.vc_bgdw LIKE #{vc_bgdw}||'%'
   AND a.mblx = #{vc_mblx}
   AND cctjid = #{ccsjd}
 ORDER BY b.vc_bgdw                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 