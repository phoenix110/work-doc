SELECT a.vc_bgkid bgkid,
       a.vc_bgkid kpbm,
       a.vc_bgkzt kpzt,
       b.vc_hzxm hzxm,
       b.vc_hzxb xb,
       b.vc_sfzh sfzh,
       dts(b.dt_hzcsrq, 0) csrq,
       b.vc_jtdh lxdh,
       (SELECT mc FROM p_yljg WHERE dm = a.vc_bgdw) zdyy,
       a.vc_icd10 icd10,
       (SELECT icd10_code || '-' || icd10_name
          FROM t_icd10
         WHERE t_icd10.icd10_code = a.vc_icd10) zdmc,
       dts(a.dt_zdrq, 0) fbrq,
       decode(b.vc_hksfdm,
              '0',
              '浙江省' || pkg_zjmb_tnb.fun_getxzqhmc(b.vc_hksdm) ||
              pkg_zjmb_tnb.fun_getxzqhmc(b.vc_hkqxdm) ||
              pkg_zjmb_tnb.fun_getxzqhmc(b.vc_hkjddm) || b.vc_hkjwdm ||
              b.vc_hkxxdz,
              '1',
              '外省') hjdz,
       nvl2(a.dt_swrq, '0', '1') sfsw,
       nvl2(a.dt_swrq, '1', '2') sczt,
       dts(a.dt_swrq, 0) swrq,
       a.vc_swyy gbsy
  FROM zjjk_zl_bgk a, zjjk_zl_hzxx b
 WHERE a.vc_hzid = b.vc_personid
   AND a.vc_bgkid = #{vc_bgkid}          