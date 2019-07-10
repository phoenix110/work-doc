SELECT bgk.vc_bgkid  bgkid,
       bgk.vc_bgkid  kpbm,
       bgk.vc_xm     szxm,
       bgk.vc_xb     xb,
       bgk.vc_sfzhm  sfzh,
       bgk.vc_jsxm   lxjs,
       bgk.vc_jslxdh lxdh,
       decode(bgk.vc_hkqcs,
              '0',
              '浙江省' || pkg_zjmb_tnb.fun_getxzqhmc(bgk.vc_hksdm) ||
              pkg_zjmb_tnb.fun_getxzqhmc(bgk.vc_hkqxdm) ||
              pkg_zjmb_tnb.fun_getxzqhmc(bgk.vc_hkjddm) || bgk.vc_hkjw ||
              bgk.vc_hkxxdz,
              '1',
              '外省') hjdz,
       dts(bgk.dt_swrq, 0) swrq,
       bgk.nb_gbsybm gbsy
  FROM zjmb_sw_bgk bgk
 WHERE bgk.vc_bgkid = #{vc_bgkid}     