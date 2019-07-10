SELECT a.vc_bgkid   bgkid,
       a.vc_bgkcode kpbm,
       a.vc_bgkzt   kpzt,
       b.vc_hzxm    hzxm,
       b.vc_hzxb    xb,
       b.vc_sfzh    sfzh,
       dts(b.dt_hzcsrq, 0) csrq,
       b.vc_lxdh lxdh,
       (SELECT mc FROM p_yljg WHERE dm = a.vc_bgdw) zdyy,
       a.vc_icd10 icd10,
       (SELECT icd10_code || '-' || icd10_name
          FROM t_icd10
         WHERE t_icd10.icd10_code = a.vc_icd10) zdmc,
       dts(a.dt_sczdrq, 0) fbrq,
       decode(b.vc_hkshen,
              '0',
              '浙江省' || pkg_zjmb_tnb.fun_getxzqhmc(b.vc_hks) ||
              pkg_zjmb_tnb.fun_getxzqhmc(b.vc_hkqx) ||
              pkg_zjmb_tnb.fun_getxzqhmc(b.vc_hkjd) || b.vc_hkjw ||
              b.vc_hkxxdz,
              '1',
              '外省') hjdz,
       decode(a.vc_sfsw, '0', '1', '1', '0') sfsw,
       decode(a.vc_sfsw, '0', '2', '1', '1') sczt,
       dts(a.dt_swrq, 0) swrq,
       a.vc_swyy gbsy
  FROM zjjk_tnb_bgk a, zjjk_tnb_hzxx b
 WHERE a.vc_hzid = b.vc_personid
   AND a.vc_bgkid = #{vc_bgkid}          