CREATE OR REPLACE TRIGGER "ZJJK".zjjk_updatezlbgk_trigger
before update of vc_bgkid    ,
  vc_bgklx    ,
  vc_xzqybm   ,
  vc_bqygzbr  ,
  vc_mzh      ,
  vc_zyh      ,
  vc_hzid     ,
  vc_icd10    ,
  vc_icdo     ,
  vc_sznl     ,
  vc_zdbw     ,
  vc_blxlx    ,
  vc_blh      ,
  vc_zdsqb    ,
  dt_zdrq     ,
  vc_zgzddw   ,
  vc_bgdwqx   ,
  vc_bgys     ,
  dt_bgrq     ,
  vc_swxx     ,
  dt_swrq     ,
  vc_swyy     ,
  vc_swicd10  ,
  vc_zdyh     ,
  vc_bszy     ,
  vc_dcr      ,
  dt_dcrq     ,
  vc_bz       ,
  vc_scbz     ,
  vc_ccid     ,
  vc_ckbz     ,
  vc_xxly     ,
  vc_sfbb     ,
  vc_sdqrzt   ,
  dt_qrsj     ,
  vc_sdqrid   ,
  dt_cjsj     ,
  vc_cjyh     ,
  vc_xgyh     ,
  vc_qcbz     ,
  vc_sfbz     ,
  vc_cjdw     ,
  vc_gldw     ,
  vc_smtjid   ,
  vc_shbz     ,
  vc_bgdws    ,
  vc_ylfffs   ,
  vc_zdqbt    ,
  vc_zdqbn    ,
  vc_zdqbm    ,
  vc_bgdw     ,
  vc_bgkzt    ,
  vc_yzd      ,
  dt_yzdrq    ,
  dt_sczdrq   ,
  vc_dbwyfid  ,
  dt_sfrq     ,
  nb_kspf     ,
  vc_zdjg     ,
  vc_khjg     ,
  dt_cxglrq   ,
  vc_cxglyy   ,
  vc_sfcx     ,
  vc_cxglqtyy ,
  vc_icdm     ,
  vc_dlw      ,
  vc_khzt     ,
  vc_icd9     ,
  vc_khid     ,
  vc_sfcf     ,
  dt_zhycsfrq ,
  vc_shid     ,
  vc_swicdmc  ,
  vc_qcd      ,
  vc_qcsdm    ,
  vc_qcqxdm   ,
  vc_qcjddm   ,
  vc_qcjw     ,
  vc_sfqc     ,
  dt_qcsj     ,
  vc_qcxxdz   ,
  vc_hjhs     ,
  vc_khbz     ,
  vc_shzt     ,
  vc_shwtgyy  ,
  vc_shwtgyy1 ,
  vc_wtzt     ,
  vc_ywtdw    ,
  vc_sqsl     ,
  vc_jjsl     ,
  vc_ywtjd    ,
  vc_ywtjw    ,
  vc_ywtxxdz  ,
  vc_ywtjgdm  ,
  vc_lszy     ,
  vc_state    ,
  dt_yyshsj   ,
  dt_qxshsj   ,
  vc_bksznl   ,
  dt_cfsj     ,
  dt_sfsj     ,
  vc_zdbwmc   ,
  dt_qxzssj   ,
  vc_gxbz     ,
  vc_id       ,
  vc_yyrid    ,
  vc_zdbmms   
    ON zjjk_zl_bgk  FOR EACH ROW
BEGIN
  :new.dt_xgsj:=sysdate;
         insert into middlexmldate(vc_bgkid,vc_id,table_name,dt_cjsj,dt_xgsj,createtime,vc_scbz,action) values(:New.vc_bgkid,:New.vc_id,'zjjk_zl_bgk',:New.dt_cjsj,:New.dt_xgsj,sysdate,:New.vc_scbz,'update') ;
END zjjk_updatezlbgk_trigger;
