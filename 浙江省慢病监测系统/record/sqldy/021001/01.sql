select vc_bgkid,
       vc_bgkbh,
       vc_bgklx,
       vc_kzt vc_bgkzt,
       dts(dt_qzrq,0) dt_qzrq,
       dts(dt_cjsj,0) dt_cjsj,
       dts(DT_YYSHSJ,0) DT_YYSHSJ,
       dts(DT_QXSHSJ,0) DT_QXSHSJ,
       dts(dt_sfsj,0) dt_sfsj,
       vc_hzjtdh,
       dts(dt_cfsj,0) dt_cfsj,
       vc_sfcf,
       vc_shbz,
       dts(dt_hzcsrq,0) dt_hzcsrq,
       GetAge(dt_hzcsrq) nl,
       vc_hzxm vc_xm,
       vc_hzxb,
       VC_HZSFZH vc_sfzh,
       vc_hzicd,
       decode(vc_shbz,
              '0',
              '医院未审核',
              '1',
              '医院审核通过',
              '2',
              '医院审核未通过',
              '3',
              '区县审核通过',
              '4',
              '区县审核未通过',
              '5',
              '市审核通过',
              '6',
              '市审核不通过',
              '7',
              '省审核通过',
              '8',
              '省审核不通过',
              vc_shbz) vc_shbz_text,
       
       decode(vc_kzt,
              '0',
              '可用卡',
              '2',
              '死卡',
              '3',
              '误诊卡',
              '4',
              '重复卡',
              '6',
              '失访卡',
              '5',
              '删除卡',
              '7',
              '死亡卡',
              vc_kzt) vc_bgkzt_text,
       decode(vc_hzxb, '1', '男', '2', '女') vc_hzxb_text,
       decode(vc_czhks,
              '0',
              '浙江省' ||
              pkg_zjmb_tnb.fun_getxzqhmc(vc_czhksi) ||
              pkg_zjmb_tnb.fun_getxzqhmc(vc_czhkqx) ||
              pkg_zjmb_tnb.fun_getxzqhmc(vc_czhkjd) ||
              vc_czhkjw||vc_czhkxxdz,
              '1',
              '外省') hkdz_text,   
        vc_shwtgyy1, 
        vc_mblx, 
        vc_lx,
        vc_zyh,
        vc_bkdwyy,
        (select mc from P_YLJG where dm=vc_bkdwyy) bkdw_text,
       dts(dt_hzcsrq, 0)  csrq,
       dts(dt_fbrq, 0)  qzrq,
       DECODE(vc_lczz,'1','临床诊断:典型;','2','临床诊断:不典型;','3','临床诊断:无变化;') ||
       DECODE(vc_xdt,'1','心电图:典型;','2','心电图:不典型;','3','心电图:无变化;') ||
       DECODE(vc_xqm,'1','血清酶:典型;','2','血清酶:不典型;','3','血清酶:无变化;') ||
       DECODE(vc_njy,'1','脑脊液:典型;','2','脑脊液:不典型;','3','脑脊液:无变化;') ||
       DECODE(vc_ndt,'1','脑电图:典型;','2','脑电图:不典型;','3','脑电图:无变化;') ||
       DECODE(vc_xgzy,'1','血管造影:典型;','2','血管造影:不典型;','3','血管造影:无变化;') ||
       DECODE(vc_ct,'1',':典型;','2',':不典型;','3',':无变化;') ||
       DECODE(vc_ckz,'1','磁共振:典型;','2','磁共振:不典型;','3','磁共振:无变化;') ||
       DECODE(vc_sj,'1','尸检:典型;','2','尸检:不典型;','3','尸检:无变化;') ||
       DECODE(vc_sjkysjc,'1','神经科医生检查:典型;','2','神经科医生检查:不典型;','3','神经科医生检查:无变化;') zdyj,
       (SELECT icd10_code||'-'||icd10_name FROM t_icd10 WHERE t_icd10.icd10_code = vc_hzicd) zdmc,
       count(1) over() total,
       rn
  from (select vc_bgkid,
               vc_bgkbh,
               vc_bgklx,
               vc_shbz,
               vc_kzt,
               dt_qzrq,
               dt_cjsj,
               DT_YYSHSJ,
               DT_QXSHSJ,
               dt_sfsj,
               vc_hzjtdh,
               dt_cfsj,
               vc_sfcf,
               vc_czhks,
               vc_czhksi,
               vc_czhkqx,
               vc_czhkjd,
               vc_czhkjw,
               vc_czhkxxdz,
               vc_hzxm,
               vc_hzxb,
               VC_HZSFZH,
               vc_hzicd,
               dt_hzcsrq,
               vc_shwtgyy1,
               dt_fbrq,
               vc_lczz, 
               vc_xdt, 
               vc_xqm, 
               vc_njy, 
               vc_ndt, 
               vc_xgzy, 
               vc_ct, 
               vc_ckz, 
               vc_sj, 
               vc_sjkysjc, 
               vc_mblx,
               vc_bkdwyy,
               vc_lx,
               vc_zyh,
               rownum as rn
          from (select /*+INDEX(BGK INDEX_XNXG_GLDW)*/ bgk.vc_bgkid,
                       bgk.vc_bgkbh,
                       bgk.vc_bgklx,
                       bgk.vc_shbz,
                       bgk.vc_kzt,
                       bgk.dt_qzrq,
                       bgk.vc_sfcf,
                       bgk.dt_cjsj,
                       bgk.DT_YYSHSJ,
                       bgk.DT_QXSHSJ,
                       bgk.DT_SFSJ,
                       bgk.vc_hzjtdh,
                       bgk.dt_cfsj,
                       bgk.vc_czhks,
                       bgk.vc_czhksi,
                       bgk.vc_czhkqx,
                       bgk.vc_czhkjd,
                       bgk.vc_czhkjw,
                       bgk.vc_czhkxxdz,
                       bgk.vc_hzxm,
                       bgk.vc_hzxb,
                       bgk.VC_HZSFZH,
                       bgk.vc_hzicd,
                       bgk.vc_shwtgyy1,
                       bgk.vc_bkdwyy,
                       bgk.dt_hzcsrq,
                       bgk.dt_fbrq,
                       bgk.vc_lczz, 
                       bgk.vc_xdt, 
                       bgk.vc_xqm, 
                       bgk.vc_njy, 
                       bgk.vc_ndt, 
                       bgk.vc_xgzy, 
                       bgk.vc_ct, 
                       bgk.vc_ckz, 
                       bgk.vc_sj, 
                       bgk.vc_sjkysjc,
                       '脑卒中' vc_mblx,
                       'xn' vc_lx,
                       bgk.vc_zyh,
                       row_number() OVER(PARTITION BY vc_bkdwyy ORDER BY nvl2(bgk.vc_zyh, 0, 1) asc, dbms_random.value) rowsnumber,
                       COUNT(1) over(PARTITION BY vc_bkdwyy) countnumber
                  from zjjk_xnxg_bgk bgk
                 where bgk.vc_scbz = '2'
                   and vc_gxbzd is null
                   and bgk.vc_bkdwyy LIKE '%'||#{vc_bgdw}||'%'
                   AND EXISTS (SELECT 1
                                 FROM p_yljgjb b
                                WHERE bgk.vc_bkdwyy = b.jgdm
                                  AND jbgjb IN ('县级','地市级','省级'))
                   AND EXISTS (SELECT 1
	                               FROM zjjk_zlfh_ccjg ccjg
				                        WHERE ccjg.ywlx = '01'
				                          AND bgk.vc_bkdwyy = ccjg.jgdm)
                   AND EXISTS (SELECT 1
                                 FROM zjjk_zlfhsj sj
                                WHERE trunc(bgk.dt_cjsj) > trunc(sj.dt_ksrq)
                                  AND trunc(bgk.dt_cjsj) <= trunc(sj.dt_jsrq)
                                  AND (sj.nczicd10 IS NULL OR sj.nczicd10||',' LIKE '%'||SUBSTR(bgk.vc_hzicd,0,3)||',%')
                                  AND sj.ccbz LIKE '%1%'
                                  AND sj.zt='1')
                   AND NOT EXISTS(SELECT 1
                                    FROM zjjk_mb_zlfh fh
                                   WHERE fh.bgkid = bgk.vc_bgkid
																	   AND fh.mblx = '1'
                                     AND fh.bccjgid = bgk.vc_bkdwyy
                                     AND fh.zt = '1'
                                     AND fh.fhbz = '1')
                   ) WHERE rowsnumber <= (SELECT tj.ccts FROM zjjk_zlfhsj tj WHERE tj.zt = '1'))                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               