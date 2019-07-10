SELECT a.vc_bgkid   bgkid,
       a.vc_bgdw    bkdw,
       a.vc_zyh     zyh,
       a.vc_bgkzt kpzt,
       DECODE(a.vc_bgkzt,'0','可用卡','2','死卡','3','误诊卡','4','重复卡','5','删除卡','6','失访卡','7','死亡卡')   kpzt_text,
       a.vc_bgkcode bgkbm,
       b.vc_hzxm    xm,
       b.vc_hzxb    xb,
       dts(b.dt_hzcsrq, 0)  csrq,
       b.vc_sfzh    sfzh,
       dts(a.dt_sczdrq, 0)  zdrq,
       a.vc_icd10   icd10,
       a.vc_zdyh    zdyj,
			 a.vc_sfsw vc_sfsw
  FROM zjjk_tnb_bgk a, zjjk_tnb_hzxx b
 WHERE a.vc_hzid = b.vc_personid
   AND a.vc_bgkid = #{vc_bgkid}                                                            