select bgk.vc_bgklx,
       bgk.vc_bgkbh,
       bgk.vc_mzh,
       bgk.vc_zyh,
       bgk.vc_sfsf,
       bgk.vc_hzsfzh,
       bgk.vc_czhks,
       bgk.vc_czhksi,
       bgk.vc_czhkqx,
       bgk.vc_czhkjd,
       bgk.vc_czhkjw,
       bgk.vc_czhkxxdz,
       cfk.vc_cfkid,
       cfk.dt_cfrq,
       cfk.vc_cfys,
       cfk.vc_hjhs,
       cfk.vc_hjwhsyy,
       cfk.vc_jzdhs,
       cfk.vc_jzdhsyy,
       cfk.vc_hjqc,
       cfk.dt_qyrq,
       cfk.vc_qcd,
       cfk.vc_qcsdm,
       cfk.vc_qcqxdm,
       cfk.vc_qcjddm,
       cfk.vc_qcjw,
       cfk.vc_qcxxdz,
       cfk.vc_sfscfb,
       cfk.vc_hzsfzh,
       cfk.vc_sfdyyjz,
       dts(cfk.dt_zzrq, 0) dt_zzrq,
       dts(cfk.dt_jzrq, 0) dt_jzrq,
       cfk.vc_zlqk,
       cfk.vc_ywzl,
       cfk.vc_ywzlqt,
       cfk.vc_fzqrkpf,
       cfk.vc_cfrkpf,
       cfk.vc_xys,
       cfk.vc_jzs,
       cfk.vc_gx,
       cfk.dt_cxglrq,
       cfk.vc_cxyy,
       cfk.vc_cxyyzm,
       cfk.vc_sffbsw,
       cfk.dt_swrq,
       cfk.vc_swyy,
       cfk.vc_swdd,
       cfk.vc_swicd,
       cfk.vc_swicdmc,
       (CASE
         WHEN (bgk.dt_swrq is not null) and (bgk.dt_qzrq is not null) THEN
          trunc(months_between(bgk.dt_swrq, bgk.dt_qzrq) / 12) ||'年'||
          mod(months_between(trunc(bgk.dt_swrq,'mm'),trunc(bgk.dt_qzrq,'mm')),12) ||'月'
         ELSE
          trunc(months_between(SYSDATE, bgk.dt_qzrq) / 12) ||'年'||
          mod(months_between(trunc(SYSDATE,'mm'),trunc(bgk.dt_qzrq,'mm')),12)||'月'
       END) vc_scq,
       CASE
         WHEN (bgk.dt_swrq is not null) and (bgk.dt_qzrq is not null) THEN
          trunc(months_between(bgk.dt_swrq, bgk.dt_qzrq) / 12) 
         ELSE
          trunc(months_between(SYSDATE, bgk.dt_qzrq) / 12)  END NB_SCQN,
       (CASE  WHEN (bgk.dt_swrq is not null) and (bgk.dt_qzrq is not null) THEN
                   mod(months_between(trunc(bgk.dt_swrq,'mm'),trunc(bgk.dt_qzrq,'mm')),12)
         ELSE
                    mod(months_between(trunc(SYSDATE,'mm'),trunc(bgk.dt_qzrq,'mm')),12)
       END) NB_SCQY
  from zjjk_xnxg_bgk bgk, zjjk_xnxg_cfk cfk
 where bgk.vc_bgkid = cfk.vc_bgkid(+)
   and bgk.vc_bgkid = #{vc_bgkid}            