SELECT VC_BGKID,
       VC_SFKID,
       SFFL,
       dts(DT_SFRQ, 0) dt_sfrq,
       dts(DT_CJSJ, 0) dt_cjsj,
       NB_KSPF,
       VC_YSQM,
       TOTAL,
       RN
  FROM (SELECT VC_BGKID,
               VC_SFKID,
               SFFL,
               DT_SFRQ,
               DT_CJSJ,
               NB_KSPF,
               VC_YSQM,
               TOTAL,
               ROWNUM AS RN
          FROM (SELECT VC_BGKID,
                       VC_SFKID,
                       SFFL,
                       DT_SFRQ,
                       DT_CJSJ,
                       NB_KSPF,
                       VC_YSQM,
                       COUNT(1) OVER() AS TOTAL
                  FROM (SELECT '1' AS SFFL,
                               VC_SFKID,
                               VC_BGKID,
                               DT_SFRQ,
                               DT_CJSJ,
                               NB_KSPF,
                               VC_YSQM
                          FROM ZJJK_ZL_CCSFK
                         WHERE VC_BGKID = #{vc_bgkid}
                        UNION
                        SELECT '2' AS SFFL,
                               VC_SFKID,
                               VC_BGKID,
                               DT_SFRQ,
                               DT_CJSJ,
                               NB_KSPF,
                               VC_YSQM
                          FROM ZJJK_ZL_SFK
                         WHERE VC_BGKID = #{vc_bgkid}))
         WHERE ROWNUM <= #{rn_e})
 WHERE RN >= #{rn_s}