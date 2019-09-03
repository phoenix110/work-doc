SELECT jlbh,
       dts(dt_ksrq, 0) dt_ksrq,
       dts(dt_jsrq, 0) dt_jsrq,
       szrid,
       szrxm,
       szjgid,
       (SELECT b.mc FROM p_yljg b WHERE szjgid = b.dm) szjgmc,
       dts(szsj, 0) szsj,
       zt,
       pkg_zjmb_tnb.fun_getdicnames('C_ZLFH_BLLX',ccbz) ccbz,
       ccts,
       pkg_zjmb_tnb.fun_getdicnames('C_XNXG_ICD10', nczicd10) nczicd10,
       pkg_zjmb_tnb.fun_getdicnames('C_XNXG_ICD10', gxbicd10) gxbicd10,
       (SELECT CASE
                 WHEN COUNT(1) >= 100 THEN
                  wm_concat(icd10_code || '-' || icd10_name) || '...'
                 ELSE
                  wm_concat(icd10_code || '-' || icd10_name)
               END
          FROM t_icd10
         WHERE ',' || tnbicd10 || ',' LIKE '%,' || icd10_code || ',%'
           AND rownum <= 100) tnbicd10,
       pkg_zjmb_tnb.fun_getdicnames('C_ZL_JCZDBW',zlicd10) zlicd10,
       decode(zt, 0, '停用', '1', '启用') ztmc,
       pkg_zjmb_tnb.fun_getdicnames('C_COMM_BGKZT', bgkzt) bgkzt_text,
       bgkzt,
       total,
       rn
  FROM (SELECT jlbh,
               dt_ksrq,
               dt_jsrq,
               szrid,
               szrxm,
               szjgid,
               szsj,
               zt,
               ccbz,
               ccts,
               nczicd10,
               gxbicd10,
               tnbicd10,
               zlicd10,
               bgkzt,
               total,
               rownum rn
          FROM (SELECT jlbh,
                       dt_ksrq,
                       dt_jsrq,
                       szrid,
                       szrxm,
                       szjgid,
                       szsj,
                       zt,
                       ccbz,
                       ccts,
                       nczicd10,
                       gxbicd10,
                       tnbicd10,
                       zlicd10,
                       bgkzt,
                       COUNT(1) over() total
                  FROM zjjk_zlfhsj_sf
                 ORDER BY zt DESC, szsj DESC, dt_jsrq DESC, dt_ksrq)
         WHERE rownum <= #{rn_e})
 WHERE rn >= #{rn_s}                                