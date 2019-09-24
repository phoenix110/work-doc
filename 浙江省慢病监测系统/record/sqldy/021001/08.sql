SELECT a.id ,
       a.bgkid,
       b.vc_bgkid,
       b.vc_bgkbh,
       a.cctjid,
       '冠心病' vc_mblx,
       a.ccbz,
       DECODE(a.ccbz,'101','脑卒中','201','冠心病','301','糖尿病','401','肺癌','402','肝癌','403','胃癌'
                    ,'404','食管癌','405','结、直肠癌','406','女性乳腺癌','407','其他恶性肿瘤') ccbz_text,
       b.vc_kzt vc_bgkzt,
       b.vc_hzxm vc_xm,
       DECODE(b.vc_hzxb,'1','男','2','女') vc_hzxb_text,
			 dts(b.dt_hzcsrq, 0)  csrq,
       dts(b.dt_fbrq, 0)  qzrq,
			 DECODE(b.vc_lczz,'1','临床诊断:典型;','2','临床诊断:不典型;','3','临床诊断:无变化;') ||
			 DECODE(b.vc_xdt,'1','心电图:典型;','2','心电图:不典型;','3','心电图:无变化;') ||
			 DECODE(b.vc_xqm,'1','血清酶:典型;','2','血清酶:不典型;','3','血清酶:无变化;') ||
			 DECODE(b.vc_njy,'1','脑脊液:典型;','2','脑脊液:不典型;','3','脑脊液:无变化;') ||
       DECODE(b.vc_ndt,'1','脑电图:典型;','2','脑电图:不典型;','3','脑电图:无变化;') ||
       DECODE(b.vc_xgzy,'1','血管造影:典型;','2','血管造影:不典型;','3','血管造影:无变化;') ||
       DECODE(b.vc_ct,'1',':典型;','2',':不典型;','3',':无变化;') ||
       DECODE(b.vc_ckz,'1','磁共振:典型;','2','磁共振:不典型;','3','磁共振:无变化;') ||
       DECODE(b.vc_sj,'1','尸检:典型;','2','尸检:不典型;','3','尸检:无变化;') ||
       DECODE(b.vc_sjkysjc,'1','神经科医生检查:典型;','2','神经科医生检查:不典型;','3','神经科医生检查:无变化;') zdyj,
       (SELECT icd10_code||'-'||icd10_name FROM t_icd10 WHERE t_icd10.icd10_code = b.vc_hzicd) zdmc,
       b.vc_hzsfzh vc_sfzh,
       (select mc from P_YLJG where dm=b.vc_bkdwyy) bkdw_text,
       a.ccczrid,
       a.shyj,
       a.fhbz fhbz,
       fn_zjjk_zlfh_mb_getfhjg('2',b.vc_bgkid,a.cctjid) fhjgpd,
       a.fhzt fhzt,
       DECODE(a.fhzt,'0','未开始','1','进行中','2','待复核','3','复核通过','4','复核不通过','5','审核通过','6','审核不通过') fhzt_text,
       b.vc_zyh,
       lag(a.fhzt, 1, null) over (order by a.ccxh asc) last_fhzt,
       COUNT(1) OVER() total
  FROM zjjk_mb_zlfh a, zjjk_xnxg_bgk b
 WHERE a.bgkid = b.vc_bgkid
   AND a.mblx = '2'
   AND a.zt = '1'
   AND b.vc_bkdwyy LIKE #{vc_bgdw}||'%'
   AND a.cctjid = #{ccsjd} 
   order by a.ccxh asc                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          