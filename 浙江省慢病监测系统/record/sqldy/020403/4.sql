select a.vc_xm           vc_hzxm,
       a.vc_xb           vc_hzxb,
       a.vc_hyzk         vc_hzhy,
   dts(a.dt_csrq,0)      dt_hzcsrq,
       a.vc_mz           vc_hzmz,
       a.vc_sznl         vc_sznl,
       a.vc_zy           vc_hzzy,
       a.vc_sfzhm        vc_hzsfzh,
       a.vc_whcd         vc_hzwhcd,
       a.vc_bgklb        vc_bgklx,
       a.vc_hkqcs        vc_czhks,
       a.vc_hksdm        vc_czhksi,
       a.vc_hkqxdm       vc_czhkqx,
       a.vc_hkjddm       vc_czhkjd,
       a.vc_hkjw         vc_czhkjw,
       a.vc_hkxxdz       vc_czhkxxdz,
       a.vc_hkqcs        vc_mqjzs,
       a.vc_hksdm        vc_mqjzsi,
       a.vc_hkqxdm       vc_mqjzqx,
       a.vc_hkjddm       vc_mqjzjd,
       a.vc_hkjw         vc_mqjzjw,
       a.vc_qcsdm        vc_qcd,
       a.vc_qcsdm        vc_qcsdm,
       a.vc_qcqxdm       vc_qcqxdm,
       a.vc_qcjw         vc_qcjw,
       a.vc_qcjddm       vc_qcjddm,
       a.vc_qcxxdz       vc_qcxxdz,
       a.dt_qcsj         vc_qcsj,
       a.vc_ckbz         vc_ckbz,
   dts(a.dt_swrq,0)      dt_swrq,
       a.nb_gbsybm       vc_swys,
       a.vc_gldwdm       vc_gldwdm,
       a.vc_cjdwdm       vc_cjdwdm,
       a.vc_gbsy         vc_hzicd,
   dts(a.dt_cjsj,0)      dt_cjsj,
       a.vc_cjyh         vc_cjyh,
       a.vc_xgyh         vc_xgyh,
   dts(a.dt_xgsj,0)      dt_xgsj,
       a.vc_gbsy         vc_swysicd,
       a.nb_gbsybm       vc_swysmc,
       a.vc_shid         vc_shid,
       a.vc_khid         vc_khid,
       a.vc_khjg         vc_khjg,
       a.vc_bz           vc_khbz,
       a.vc_ccid         vc_ccid,
       a.vc_shzt         vc_shzt,
       a.vc_shwtgyy      vc_shwtgyy,
       a.vc_shwtgyy1     vc_shwtgyy1,
   dts(a.dt_yyshsj,0)    dt_yyshsj,
   dts(a.dt_sfsj,0)      dt_sfsj
      
  
  from zjmb_sw_bgk a
 where a.vc_bgkid = #{vc_bgkid}    