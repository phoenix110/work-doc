SELECT id,
       bgkid,
       vc_bgkid,
       cctjid,
       vc_bgkcode vc_bgkbh,
       '脑卒中' vc_mblx,
       ccbz,
       decode(ccbz,
              '101',
              '脑卒中',
              '201',
              '冠心病',
              '301',
              '糖尿病',
              '401',
              '肺癌',
              '402',
              '肝癌',
              '403',
              '胃癌',
              '404',
              '食管癌',
              '405',
              '结、直肠癌',
              '406',
              '女性乳腺癌',
              '407',
              '其他恶性肿瘤') ccbz_text,
       vc_bgkzt,
       vc_hzxm vc_xm,
       decode(vc_hzxb, '1', '男', '2', '女') vc_hzxb_text,
       dts(dt_hzcsrq, 0) csrq,
       dts(dt_sczdrq, 0) qzrq,
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
       (SELECT icd10_code || '-' || icd10_name
          FROM t_icd10
         WHERE t_icd10.icd10_code = vc_icd10) zdmc,
       vc_sfzh,
       (SELECT mc FROM p_yljg WHERE dm = vc_bgdw) bkdw_text,
       ccczrid,
       fn_zjjk_zlfh_mb_getfhjg(#{vc_mblx},vc_bgkid,cctjid) fhjgpd,
       fhzt fhzt,
       decode(fhzt,
              '0',
              '未开始',
              '1',
              '进行中',
              '2',
              '待复核',
              '3',
              '复核通过',
              '4',
              '复核不通过',
              '5',
              '审核通过',
              '6',
              '审核不通过') fhzt_text,
       shyj,
       rn,
       total
  FROM (SELECT id,
               bgkid,
               vc_bgkid,
               cctjid,
               vc_bgkcode,
               ccbz,
               vc_bgkzt,
               vc_hzxm,
               vc_hzxb,
               dt_hzcsrq,
               dt_sczdrq,
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
               vc_icd10,
               vc_sfzh,
               vc_bgdw,
               ccczrid,
               fhzt,
               shyj,
               rownum rn,
               total
          FROM (SELECT a.id,
                       a.bgkid,
                       b.vc_bgkid,
                       a.cctjid,
                       b.vc_bgkbh vc_bgkcode,
                       a.ccbz,
                       b.vc_kzt vc_bgkzt,
                       b.vc_hzxm,
                       b.vc_hzxb,
                       b.dt_hzcsrq,
                       b.dt_qzrq dt_sczdrq,
                       b.vc_lczz,
                       b.vc_xdt,
                       b.vc_xqm,
                       b.vc_njy,
                       b.vc_ndt,
                       b.vc_xgzy,
                       b.vc_ct,
                       b.vc_ckz,
                       b.vc_sj,
                       b.vc_sjkysjc,
                       b.vc_hzicd vc_icd10,
                       b.vc_hzsfzh vc_sfzh,
                       b.vc_bkdwyy vc_bgdw,
                       a.ccczrid,
                       a.fhzt,
                       a.shyj,
                       COUNT(1) over() total
                  FROM zjjk_mb_zlfh a, zjjk_xnxg_bgk b
                 WHERE a.bgkid = b.vc_bgkid
                   AND b.vc_gxbzd is null
                   AND (a.fhzt = '3' OR a.fhzt = '5' OR a.fhzt = '6')
                   AND a.zt = '1'
                   AND a.cctjid = #{ccsjd}
                   AND a.mblx = #{vc_mblx}
                   AND a.ccjgid LIKE #{vc_bkqx} || '%'
                   <if if(StringUtils.isNotBlank(#{sfsh}))>
                     AND a.fhzt = #{sfsh}
                   </if>
                    <if if(1==1)>
                 ORDER BY a.fhzt)
         WHERE rownum <= #{rn_e})
 WHERE rn >= #{rn_s}
                    </if>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            