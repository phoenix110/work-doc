SELECT xnxg.vc_bgkid   bgkid,
       xnxg.vc_bgkid kpbm,
       xnxg.vc_kzt   kpzt,
       xnxg.vc_hzxm    hzxm,
       xnxg.vc_hzxb    xb,
       xnxg.vc_hzsfzh    sfzh,
       dts(xnxg.dt_hzcsrq, 0) csrq,
       xnxg.vc_hzjtdh lxdh,
       (SELECT mc FROM p_yljg WHERE dm = xnxg.vc_bkdwyy) zdyy,
       xnxg.vc_hzicd icd10,
       (SELECT icd10_code || '-' || icd10_name
          FROM t_icd10
         WHERE t_icd10.icd10_code = xnxg.vc_hzicd) zdmc,
       dts(xnxg.dt_fbrq, 0) fbrq,
       decode(xnxg.vc_czhks ,
              '0',
              '浙江省' || pkg_zjmb_tnb.fun_getxzqhmc(xnxg.vc_czhksi ) ||
              pkg_zjmb_tnb.fun_getxzqhmc(xnxg.vc_czhkqx ) ||
              pkg_zjmb_tnb.fun_getxzqhmc(xnxg.vc_czhkjd ) || xnxg.vc_czhkjw  ||
              xnxg.vc_czhkxxdz ,
              '1',
              '外省') hjdz,
       decode(xnxg.vc_sfsw, '0', '1', '1', '0') sfsw,
       decode(xnxg.vc_sfsw, '0', '2', '1', '1') sczt,
       dts(xnxg.dt_swrq, 0) swrq,
       xnxg.vc_swys gbsy
  FROM zjjk_xnxg_bgk xnxg
 WHERE xnxg.vc_bgkid = #{vc_bgkid}     