SELECT xnxg.vc_bgkid bgkid,
			 xnxg.vc_bkdw bkdw,
			 xnxg.vc_zyh zyh,
		 	 xnxg.vc_kzt kpzt,
			 DECODE(xnxg.vc_kzt,'0','可用卡','2','死卡','3','误诊卡','4','重复卡','5','删除卡','6','失访卡','7','死亡卡')   kpzt_text,
			 xnxg.vc_bgkbh bgkbm,
			 xnxg.vc_hzxm xm,
			 xnxg.vc_hzxb xb,
			 dts(xnxg.dt_hzcsrq, 0)  csrq,
			 xnxg.vc_hzsfzh sfzh,
			 dts(xnxg.dt_qzrq, 0)  zdrq,
			 xnxg.vc_hzicd icd10,
			 xnxg.vc_sfsw vc_sfsw
  FROM zjjk_xnxg_bgk xnxg
 WHERE xnxg.vc_bgkid = #{vc_bgkid}                    