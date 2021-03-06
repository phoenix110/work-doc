select a.vc_bgkid,
       a.vc_bgklx,
       a.vc_xzqybm,
       a.vc_bqygzbr,
       pkg_zjmb_tnb.fun_getcommdic('C_ZL_JCZDBW',a.vc_zdbw) zdbw_text,
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_ICDO',substr(a.vc_icdo,1,instr(a.vc_icdo,',',-1)-1)) icdo_text,
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_ICDM',a.vc_icdm) icdm_text,
       a.vc_mzh,
       a.vc_zyh,
       a.vc_hzid,
       a.vc_icd10,
       a.vc_icdo,
       a.vc_sznl,
       a.vc_zdbw,
       a.vc_blxlx,
       a.vc_blh,
       a.vc_zdsqb,
       dts(a.dt_zdrq,0) de_zdrq,
       a.vc_zgzddw,
       a.vc_bgdwqx,
       a.vc_bgys,
       dts(a.dt_bgrq,0) dt_bgrq,
       a.vc_swxx,
       dts(a.dt_swrq,0) dt_swrq,
       a.vc_swyy,
       a.vc_swicd10,
       a.vc_zdyh,
       a.vc_bszy,
       a.vc_dcr,
       a.dt_dcrq,
       a.vc_bz,
       a.vc_scbz,
       a.vc_ccid,
       a.vc_ckbz,
       a.vc_xxly,
       a.vc_sfbb,
       a.vc_sdqrzt,
       a.dt_qrsj,
       a.vc_sdqrid,
       dts(a.dt_cjsj,0) dt_cjsj,
       a.vc_cjyh,
       a.dt_xgsj,
       a.vc_xgyh,
       a.vc_qcbz,
       a.vc_sfbz,
       a.vc_cjdw,
       a.vc_gldw,
       a.vc_smtjid,
       a.vc_shbz,
       a.vc_bgdws,
       a.vc_ylfffs,
       a.vc_zdqbt,
       a.vc_zdqbn,
       a.vc_zdqbm,
       a.vc_bgdw,
       a.vc_bgkzt,
       a.vc_yzd,
       dts(a.dt_yzdrq,0) dt_yzdrq,
       dts(a.dt_sczdrq, 0) dt_sczdrq,
       a.vc_dbwyfid,
       a.dt_sfrq,
       a.nb_kspf,
       a.vc_zdjg,
       a.vc_khjg,
       a.dt_cxglrq,
       a.vc_cxglyy,
       a.vc_sfcx,
       a.vc_cxglqtyy,
       a.vc_icdm,
       a.vc_dlw,
       a.vc_khzt,
       a.vc_icd9,
       a.vc_khid,
       a.vc_sfcf,
       a.dt_zhycsfrq,
       a.vc_shid,
       a.vc_swicdmc,
       a.vc_qcd,
       a.vc_qcsdm,
       a.vc_qcqxdm,
       a.vc_qcjddm,
       a.vc_qcjw,
       a.vc_sfqc,
       a.dt_qcsj,
       a.vc_qcxxdz,
       a.vc_hjhs,
       a.vc_khbz,
       a.vc_shzt,
       a.vc_shwtgyy,
       a.vc_shwtgyy1,
       a.vc_wtzt,
       a.vc_ywtdw,
       a.vc_sqsl,
       a.vc_jjsl,
       a.vc_ywtjd,
       a.vc_ywtjw,
       a.vc_ywtxxdz,
       a.vc_ywtjgdm,
       a.vc_lszy,
       a.vc_state,
       a.dt_yyshsj,
       a.dt_qxshsj,
       a.vc_bksznl,
       a.dt_cfsj,
       a.dt_sfsj,
       a.vc_zdbwmc,
       a.dt_qxzssj,
       a.vc_gxbz,
       a.vc_id,
       a.vc_yyrid,
       a.vc_zdbmms,
       a.upload_areaeport,
       a.vc_sfbyzd,
       a.vc_zdyy,
       a.vc_icdo3bm,
       a.vc_icdo3ms,
       b.vc_personid,
       b.vc_hzxm,
       b.vc_hzxb,
       decode(b.vc_hzxb, '1', '男', '2', '女') vc_hzxb_text,
       b.vc_hzmz,
       dts(b.dt_hzcsrq,0) dt_hzcsrq,
       b.vc_sfzh,
       b.vc_jtdh,
       b.vc_gzdw,
       b.vc_zydm,
       b.vc_jtgz,
       b.vc_hksfdm,
       b.vc_hksdm,
       b.vc_hkjddm,
       b.vc_hkqxdm,
       b.vc_hkjwdm,
       b.vc_hkxxdz,
       pkg_zjmb_tnb.fun_getxzqhmc(b.vc_hksdm) vc_hksmc,
       pkg_zjmb_tnb.fun_getxzqhmc(b.vc_hkqxdm) vc_hkqxmc,
       pkg_zjmb_tnb.fun_getxzqhmc(b.vc_hkjddm) vc_hkjdmc,
       b.vc_sjsfdm,
       b.vc_sjsdm,
       b.vc_sjqxdm,
       b.vc_sjjddm,
       b.vc_sjjwdm,
       b.vc_sjxxdz,
       b.vc_gldwdm,
       b.vc_sfsw,
       b.vc_sfhs,
       b.vc_sjhm,
       b.vc_dydz,
       b.vc_jzyb,
       b.vc_hkyb,
       b.vc_bak_hy,
       b.vc_bak_zy,
       b.vc_bak_sfzh,
       b.vc_id,
       c.vc_zkid,
       c.vc_fkid
  from zjjk_zl_bgk a, zjjk_zl_hzxx b, zjjk_zl_bgk_zfgx c
 where a.vc_hzid = b.vc_personid
   and a.vc_bgkid = c.vc_fkid(+)
   and a.vc_gldw like #{vc_gldw} || '%'
   and a.vc_scbz = '0'
   and a.vc_bgkid = #{vc_bgkid}      