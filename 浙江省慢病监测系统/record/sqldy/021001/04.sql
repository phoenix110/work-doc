SELECT vc_bgkid,
       vc_bgkid vc_bgkbh,
       vc_bgklx,
       vc_hzid,
       vc_bgkzt,
       vc_icd10,
       dts(dt_bgrq, 0) dt_bgrq,
       dts(dt_cjsj, 0) csrq,
       dts(dt_sczdrq, 0) qzrq,
       dts(dt_yyshsj, 0) dt_yyshsj,
       dts(dt_qxshsj, 0) dt_qxshsj,
       dts(dt_sfsj, 0) dt_sfsj,
       dts(dt_cfsj, 0) dt_cfsj,
       (SELECT wm_concat(mc)
          FROM p_tyzdml
         WHERE fldm = 'C_ZL_ZDYJ'
           AND vc_zdyh LIKE '%' || dm || '%') zdyj,
       vc_bgdw,
       (SELECT icd10_code||'-'||icd10_name FROM t_icd10 WHERE t_icd10.icd10_code = vc_icd10) zdmc,
       (SELECT mc FROM p_yljg WHERE dm = vc_bgdw) bkdw_text,
       vc_sfcf,
       vc_shbz,
       dt_hzcsrq,
       getage(dt_hzcsrq) nl,
       vc_hzxm vc_xm,
       vc_hzxb,
       vc_sfzh,
       vc_hksfdm,
       vc_hksdm,
       vc_hkqxdm,
       vc_hkjddm,
       vc_hkjwdm,
       vc_hkxxdz,
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_SHZT', vc_shbz) vc_shbz_text,
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_BGKZT', vc_bgkzt) vc_bgkzt_text,
       decode(vc_hzxb, '1', '男', '2', '女') vc_hzxb_text,
       decode(vc_hksfdm,
              '0',
              '浙江省' || pkg_zjmb_tnb.fun_getxzqhmc(vc_hksdm) ||
              pkg_zjmb_tnb.fun_getxzqhmc(vc_hkqxdm) ||
              pkg_zjmb_tnb.fun_getxzqhmc(vc_hkjddm) || vc_hkxxdz,
              '1',
              '外省') hkdz_text,
       vc_shwtgyy1,
       vc_mblx,
       vc_lx,
       COUNT(1) over() total,
       rn
  FROM (SELECT vc_bgkid,
               vc_bgklx,
               vc_hzid,
               vc_shbz,
               vc_bgkzt,
               vc_icd10,
               vc_zdyh,
               dt_bgrq,
               dt_cjsj,
               dt_hzcsrq,
               dt_yyshsj,
               dt_qxshsj,
               dt_sczdrq,
               dt_sfsj,
               dt_cfsj,
               vc_bgdw,
               vc_sfcf,
               vc_hzxm,
               vc_hzxb,
               vc_sfzh,
               vc_hksfdm,
               vc_hksdm,
               vc_hkqxdm,
               vc_hkjddm,
               vc_hkjwdm,
               vc_hkxxdz,
               vc_shwtgyy1,
               vc_mblx,
               vc_lx,
               rownum AS rn
          FROM (SELECT bgk.vc_bgkid,
                       bgk.vc_bgklx,
                       bgk.vc_hzid,
                       bgk.vc_shbz,
                       bgk.vc_bgkzt,
                       bgk.dt_bgrq,
                       bgk.vc_icd10,
                       bgk.vc_sfcf,
                       bgk.dt_cjsj,
                       bgk.dt_yyshsj,
                       bgk.dt_qxshsj,
                       bgk.dt_sfsj,
                       bgk.dt_cfsj,
                       bgk.vc_zdyh,
                       bgk.vc_bgdw,
                       bgk.dt_sczdrq,
                       hzxx.vc_hzxm,
                       hzxx.vc_hzxb,
                       hzxx.vc_sfzh,
                       hzxx.dt_hzcsrq,
                       hzxx.vc_hksfdm,
                       hzxx.vc_hksdm,
                       hzxx.vc_hkqxdm,
                       hzxx.vc_hkjddm,
                       hzxx.vc_hkjwdm,
                       hzxx.vc_hkxxdz,
                       bgk.vc_shwtgyy1,
                       '肿瘤' vc_mblx,
                       'zl' vc_lx,
                       row_number() OVER(PARTITION BY vc_bgdw ORDER BY dbms_random.value) rowsnumber,
                       COUNT(1) over(PARTITION BY vc_bgdw) countnumber
                  FROM zjjk_zl_bgk bgk, zjjk_zl_hzxx hzxx
                 WHERE bgk.vc_hzid = hzxx.vc_personid
                   AND bgk.vc_scbz = '0'
                   AND bgk.vc_bgdw like #{vc_bgdw}||'%'
                   AND EXISTS (SELECT 1
                                 FROM p_yljgjb b
                                WHERE bgk.vc_bgdw = b.jgdm
                                  AND jbgjb IN ('县级','地市级','省级'))
                   AND EXISTS (SELECT 1
	                               FROM zjjk_zlfh_ccjg ccjg
				                        WHERE ccjg.ywlx = '01'
				                          AND bgk.vc_bgdw = ccjg.jgdm)
                   AND EXISTS (SELECT 1
                         FROM zjjk_zlfhsj sj
                        WHERE trunc(bgk.dt_cjsj) > trunc(sj.dt_ksrq)
                          AND trunc(bgk.dt_cjsj) <= trunc(sj.dt_jsrq)
                          AND sj.ccbz LIKE '%4%'
                          AND (sj.zlicd10 IS NULL OR sj.zlicd10||',' LIKE '%'||SUBSTR(bgk.vc_icd10,0,3)||',%')
                          AND sj.zt = '1')
                   AND NOT EXISTS(SELECT 1
                                    FROM zjjk_mb_zlfh fh
                                   WHERE fh.bgkid = bgk.vc_bgkid
																	   AND fh.mblx = '4'
                                     AND fh.bccjgid = bgk.vc_bgdw
                                     AND fh.zt = '1'
                                     AND fh.fhbz = '1')
                   ) WHERE rowsnumber <= (SELECT tj.ccts FROM zjjk_zlfhsj tj WHERE tj.zt = '1')
                       AND countnumber >= (SELECT tj.ccts FROM zjjk_zlfhsj tj WHERE tj.zt = '1'))                                                                                                  