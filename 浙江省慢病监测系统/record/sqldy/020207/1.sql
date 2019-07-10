select count(1) over(partition by
       <if if("1".equals(#{vc_radio}))>
            vc_hzxm
        </if>
        <if if("2".equals(#{vc_radio}))>
            substr(vc_hzxm,1,1)||substr(vc_hzxm,length(vc_hzxm))
        </if>
        <if if("3".equals(#{vc_radio}))>
            substr(vc_hzxm,1,2)
        </if>
        <if if("4".equals(#{vc_radio}))>
            substr(vc_hzxm,length(vc_hzxm)-1)
        </if>
        <if if("5".equals(#{vc_radio}))>
            vc_sfzh
        </if>
        <if if("6".equals(#{vc_radio}))>
            vc_lxdh
        </if>
        <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",1,") < 0))>
            , vc_hzxb
        </if>
        <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",2,") < 0))>
            , to_char(dt_hzcsrq,'yyyy')
        </if>
        <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",3,") < 0))>
            , vc_sfzh
        </if>
        <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",4,") < 0))>
            , vc_lxdh
        </if>
       <if if(1 == 1)>
       ) as group_count,
       DENSE_RANK()over(
       order by 
       </if>
        <if if("1".equals(#{vc_radio}))>
            vc_hzxm
        </if>
        <if if("2".equals(#{vc_radio}))>
            substr(vc_hzxm,1,1)||substr(vc_hzxm,length(vc_hzxm))
        </if>
        <if if("3".equals(#{vc_radio}))>
            substr(vc_hzxm,1,2)
        </if>
        <if if("4".equals(#{vc_radio}))>
            substr(vc_hzxm,length(vc_hzxm)-1)
        </if>
        <if if("5".equals(#{vc_radio}))>
            vc_sfzh
        </if>
        <if if("6".equals(#{vc_radio}))>
            vc_lxdh
        </if>
        <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",1,") < 0))>
            , vc_hzxb
        </if>
        <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",2,") < 0))>
            , to_char(dt_hzcsrq,'yyyy')
        </if>
        <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",3,") < 0))>
            , vc_sfzh
        </if>
        <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",4,") < 0))>
            , vc_lxdh
        </if>
        <if if(1 == 1)>
       ) as group_no,
       vc_bgkid,
       vc_bgklx,
       pkg_zjmb_tnb.fun_getcommdic('C_TNB_TNBLX',vc_tnblx) vc_tnblx_text,
       vc_hzid,
       vc_icd10,
       vc_tnblx,
       vc_wxys,
       vc_wxystz,
       vc_wxyssg,
       vc_tnbs,
       vc_jzsrs,
       vc_ywbfz,
       vc_zslcbx,
       vc_zslcbxqt,
       nb_kfxtz,
       nb_sjxtz,
       nb_xjptt,
       nb_zdgc,
       nb_e4hdlc,
       nb_e5ldlc,
       nb_gysz,
       nb_nwldb,
       nbthxhdb,
       vc_bszyqt,
       dts(dt_sczdrq, 0) dt_sczdrq,
       vc_zddw,
       pkg_zjmb_tnb.fun_getcommdic('C_ZL_ZGZDDW',vc_zddw) vc_zddw_text,
       vc_bgdw,
       vc_bgys,
       dt_bgrq,
       vc_sfsw,
       dts(dt_swrq, 0) dt_swrq,
       vc_swyy,
       vc_swicd10,
       vc_swicdmc,
       vc_bszy,
       vc_scbz,
       vc_ccid,
       vc_ckbz,
       vc_sfbb,
       vc_sdqrzt,
       dt_qrsj,
       vc_sdqrid,
       dts(dt_cjsj, 0) dt_cjsj,
       vc_cjdw,
       dt_xgsj,
       vc_xgdw,
       vc_gldw,
       vc_shbz,
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
       vc_shwtgyy1,
       vc_shwtgyy2,
       vc_khbz,
       vc_khjg,
       vc_smtjid,
       vc_qybz,
       vc_hkhs,
       vc_hkwhsyy,
       vc_jzhs,
       vc_jzwhsyy,
       vc_cxgl,
       vc_qcbz,
       vc_xgyh,
       vc_cjyh,
       vc_xxly,
       vc_bz,
       dt_dcrq,
       vc_dcr,
       vc_zdyh,
       vc_swxx,
       vc_bgdwqx,
       vc_zgzddw,
       vc_sznl,
       vc_icdo,
       vc_zyh,
       vc_mzh,
       vc_bqygzbr,
       vc_xzqybm,
       vc_bgkzt,
       decode(vc_bgkzt,
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
              vc_bgkzt) vc_bgkzt_text,
       vc_bgkcode,
       vc_qcd,
       vc_qcsdm,
       vc_qcqxdm,
       vc_qcjddm,
       vc_qcjw,
       vc_sfqc,
       dt_qcsj,
       vc_qcxxdz,
       vc_shid,
       vc_khid,
       vc_khzt,
       vc_shzt,
       vc_cfzt,
       decode(vc_cfzt,
              '0','未初访',
              '1','已初访',
              '3','已随访') vc_cfzt_text,
       vc_shwtgyy,
       vc_bks,
       vc_bkq,
       vc_bmi,
       vc_wtzt,
       vc_ywtdw,
       vc_sqsl,
       vc_jjsl,
       vc_ywtjd,
       vc_ywtjw,
       vc_ywtxxdz,
       vc_ywtjgdm,
       vc_lszy,
       vc_state,
       dt_yyshsj,
       dts(dt_qxshsj, 0) dt_qxshsj,
       vc_bksznl,
       dt_cfsj,
       dt_sfsj,
       dt_qxzssj,
       vc_id,
       vc_hzxm,
       vc_hzxb,
       decode(vc_hzxb, '1', '男', '2', '女') vc_hzxb_text,
       vc_hzmz,
       vc_whcd,
       dts(dt_hzcsrq, 0) dt_hzcsrq,
       vc_sfzh,
       vc_lxdh,
       vc_hydm,
       vc_zydm,
       vc_gzdw,
       vc_hkshen,
       vc_hks,
       vc_hkqx,
       vc_hkjd,
       vc_hkjw,
       vc_hkxxdz,
       vc_jzds,
       vc_jzs,
       vc_jzqx,
       vc_jzjd,
       vc_jzjw,
       vc_jzxxdz,
       total,
       rn,
       decode(vc_hkshen,
              '0',
              '浙江省' ||
               pkg_zjmb_tnb.fun_getxzqhmc(VC_HKS) ||
              pkg_zjmb_tnb.fun_getxzqhmc(VC_HKQX) ||
              pkg_zjmb_tnb.fun_getxzqhmc(VC_HKJD) ||
              vc_hkjw || vc_jzxxdz,
              '1',
              '外省') hjdz_text
  from (select vc_bgkid,
               vc_bgklx,
               vc_hzid,
               vc_icd10,
               vc_tnblx,
               vc_wxys,
               vc_wxystz,
               vc_wxyssg,
               vc_tnbs,
               vc_jzsrs,
               vc_ywbfz,
               vc_zslcbx,
               vc_zslcbxqt,
               nb_kfxtz,
               nb_sjxtz,
               nb_xjptt,
               nb_zdgc,
               nb_e4hdlc,
               nb_e5ldlc,
               nb_gysz,
               nb_nwldb,
               nbthxhdb,
               vc_bszyqt,
               dt_sczdrq,
               vc_zddw,
               vc_bgdw,
               vc_bgys,
               dt_bgrq,
               vc_sfsw,
               dt_swrq,
               vc_swyy,
               vc_swicd10,
               vc_swicdmc,
               vc_bszy,
               vc_scbz,
               vc_ccid,
               vc_ckbz,
               vc_sfbb,
               vc_sdqrzt,
               dt_qrsj,
               vc_sdqrid,
               dt_cjsj,
               vc_cjdw,
               dt_xgsj,
               vc_xgdw,
               vc_gldw,
               vc_shbz,
               vc_shwtgyy1,
               vc_shwtgyy2,
               vc_khbz,
               vc_khjg,
               vc_smtjid,
               vc_qybz,
               vc_hkhs,
               vc_hkwhsyy,
               vc_jzhs,
               vc_jzwhsyy,
               vc_cxgl,
               vc_qcbz,
               vc_xgyh,
               vc_cjyh,
               vc_xxly,
               vc_bz,
               dt_dcrq,
               vc_dcr,
               vc_zdyh,
               vc_swxx,
               vc_bgdwqx,
               vc_zgzddw,
               vc_sznl,
               vc_icdo,
               vc_zyh,
               vc_mzh,
               vc_bqygzbr,
               vc_xzqybm,
               vc_bgkzt,
               vc_bgkcode,
               vc_qcd,
               vc_qcsdm,
               vc_qcqxdm,
               vc_qcjddm,
               vc_qcjw,
               vc_sfqc,
               dt_qcsj,
               vc_qcxxdz,
               vc_shid,
               vc_khid,
               vc_khzt,
               vc_shzt,
               vc_cfzt,
               vc_shwtgyy,
               vc_bks,
               vc_bkq,
               vc_bmi,
               vc_wtzt,
               vc_ywtdw,
               vc_sqsl,
               vc_jjsl,
               vc_ywtjd,
               vc_ywtjw,
               vc_ywtxxdz,
               vc_ywtjgdm,
               vc_lszy,
               vc_state,
               dt_yyshsj,
               dt_qxshsj,
               vc_bksznl,
               dt_cfsj,
               dt_sfsj,
               dt_qxzssj,
               vc_id,
               vc_hzxm,
               vc_hzxb,
               vc_hzmz,
               vc_whcd,
               dt_hzcsrq,
               vc_sfzh,
               vc_lxdh,
               vc_hydm,
               vc_zydm,
               vc_gzdw,
               vc_hkshen,
               vc_hks,
               vc_hkqx,
               vc_hkjd,
               vc_hkjw,
               vc_hkxxdz,
               vc_jzds,
               vc_jzs,
               vc_jzqx,
               vc_jzjd,
               vc_jzjw,
               vc_jzxxdz,
               total,
               rownum as rn
          from (select a.vc_bgkid,
                       a.vc_bgklx,
                       a.vc_hzid,
                       a.vc_icd10,
                       a.vc_tnblx,
                       a.vc_wxys,
                       a.vc_wxystz,
                       a.vc_wxyssg,
                       a.vc_tnbs,
                       a.vc_jzsrs,
                       a.vc_ywbfz,
                       a.vc_zslcbx,
                       a.vc_zslcbxqt,
                       a.nb_kfxtz,
                       a.nb_sjxtz,
                       a.nb_xjptt,
                       a.nb_zdgc,
                       a.nb_e4hdlc,
                       a.nb_e5ldlc,
                       a.nb_gysz,
                       a.nb_nwldb,
                       a.nbthxhdb,
                       a.vc_bszyqt,
                       a.dt_sczdrq,
                       a.vc_zddw,
                       a.vc_bgdw,
                       a.vc_bgys,
                       a.dt_bgrq,
                       a.vc_sfsw,
                       a.dt_swrq,
                       a.vc_swyy,
                       a.vc_swicd10,
                       a.vc_swicdmc,
                       a.vc_bszy,
                       a.vc_scbz,
                       a.vc_ccid,
                       a.vc_ckbz,
                       a.vc_sfbb,
                       a.vc_sdqrzt,
                       a.dt_qrsj,
                       a.vc_sdqrid,
                       a.dt_cjsj,
                       a.vc_cjdw,
                       a.dt_xgsj,
                       a.vc_xgdw,
                       a.vc_gldw,
                       a.vc_shbz,
                       a.vc_shwtgyy1,
                       a.vc_shwtgyy2,
                       a.vc_khbz,
                       a.vc_khjg,
                       a.vc_smtjid,
                       a.vc_qybz,
                       a.vc_hkhs,
                       a.vc_hkwhsyy,
                       a.vc_jzhs,
                       a.vc_jzwhsyy,
                       a.vc_cxgl,
                       a.vc_qcbz,
                       a.vc_xgyh,
                       a.vc_cjyh,
                       a.vc_xxly,
                       a.vc_bz,
                       a.dt_dcrq,
                       a.vc_dcr,
                       a.vc_zdyh,
                       a.vc_swxx,
                       a.vc_bgdwqx,
                       a.vc_zgzddw,
                       a.vc_sznl,
                       a.vc_icdo,
                       a.vc_zyh,
                       a.vc_mzh,
                       a.vc_bqygzbr,
                       a.vc_xzqybm,
                       a.vc_bgkzt,
                       a.vc_bgkcode,
                       a.vc_qcd,
                       a.vc_qcsdm,
                       a.vc_qcqxdm,
                       a.vc_qcjddm,
                       a.vc_qcjw,
                       a.vc_sfqc,
                       a.dt_qcsj,
                       a.vc_qcxxdz,
                       a.vc_shid,
                       a.vc_khid,
                       a.vc_khzt,
                       a.vc_shzt,
                       a.vc_cfzt,
                       a.vc_shwtgyy,
                       a.vc_bks,
                       a.vc_bkq,
                       a.vc_bmi,
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
                       a.dt_qxzssj,
                       a.vc_id,
                       b.vc_hzxm,
                       b.vc_hzxb,
                       b.vc_hzmz,
                       b.vc_whcd,
                       b.dt_hzcsrq,
                       b.vc_sfzh,
                       b.vc_lxdh,
                       b.vc_hydm,
                       b.vc_zydm,
                       b.vc_gzdw,
                       b.vc_hkshen,
                       b.vc_hks,
                       b.vc_hkqx,
                       b.vc_hkjd,
                       b.vc_hkjw,
                       b.vc_hkxxdz,
                       b.vc_jzds,
                       b.vc_jzs,
                       b.vc_jzqx,
                       b.vc_jzjd,
                       b.vc_jzjw,
                       b.vc_jzxxdz,
                       count(1) over() as total
                  from zjjk_tnb_bgk a, zjjk_tnb_hzxx b
                 where a.vc_hzid = b.vc_personid
                   and a.vc_gldw like #{vc_gldw}||'%'
                   and a.vc_bgkzt in ('0', '7', '2', '6')
                   and a.vc_scbz = '0'
                   and a.vc_shbz in ('1','3','4','5','6','7','8')
                   and b.vc_hkshen = '0'
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_sfzh}))>
                      and b.vc_sfzh = #{vc_sfzh}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_jtdh}))>
                      and b.vc_lxdh = #{vc_jtdh}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hzxm}))>
                      and b.vc_hzxm = #{vc_hzxm}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkshen}))>
                      and b.vc_hkshen = #{vc_hkshen}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hks}))>
                      and b.vc_hks = #{vc_hks}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkqx}))>
                      and b.vc_hkqx = #{vc_hkqx}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkjd}))>
                      and b.vc_hkjd = #{vc_hkjd}
                   </if>
                   <if if("5".equals(#{vc_radio}) || ((StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",3,") < 0))) )>
                      and b.vc_sfzh is not null
                      and b.vc_sfzh <> '不详'
                   </if>
                   <if if(1 == 1)>
                       and (
                   </if>
                   <if if("1".equals(#{vc_radio}))>
                       b.vc_hzxm
                   </if>
                   <if if("2".equals(#{vc_radio}))>
                       substr(b.vc_hzxm,1,1)||substr(b.vc_hzxm,length(b.vc_hzxm))
                   </if>
                   <if if("3".equals(#{vc_radio}))>
                       substr(b.vc_hzxm,1,2)
                   </if>
                   <if if("4".equals(#{vc_radio}))>
                       substr(b.vc_hzxm,length(b.vc_hzxm)-1)
                   </if>
                   <if if("5".equals(#{vc_radio}))>
                       b.vc_sfzh
                   </if>
                   <if if("6".equals(#{vc_radio}))>
                       b.vc_lxdh
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",1,") < 0))>
                       , b.vc_hzxb
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",2,") < 0))>
                       , to_char(b.dt_hzcsrq,'yyyy')
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",3,") < 0))>
                       , b.vc_sfzh
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",4,") < 0))>
                       , b.vc_lxdh
                   </if>
                   <if if(1 == 1)>
                   ) in (select
                   </if>
                   <if if("1".equals(#{vc_radio}))>
                       b.vc_hzxm
                   </if>
                   <if if("2".equals(#{vc_radio}))>
                       substr(b.vc_hzxm,1,1)||substr(b.vc_hzxm,length(b.vc_hzxm))
                   </if>
                   <if if("3".equals(#{vc_radio}))>
                       substr(b.vc_hzxm,1,2)
                   </if>
                   <if if("4".equals(#{vc_radio}))>
                       substr(b.vc_hzxm,length(b.vc_hzxm)-1)
                   </if>
                   <if if("5".equals(#{vc_radio}))>
                       b.vc_sfzh
                   </if>
                   <if if("6".equals(#{vc_radio}))>
                       b.vc_lxdh
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",1,") < 0))>
                       , b.vc_hzxb
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",2,") < 0))>
                       , to_char(b.dt_hzcsrq,'yyyy')
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",3,") < 0))>
                       , b.vc_sfzh
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",4,") < 0))>
                       , b.vc_lxdh
                   </if>
                   <if if(1 == 1)>
                      from zjjk_tnb_bgk a, zjjk_tnb_hzxx b
                      where a.vc_hzid = b.vc_personid
                        and a.vc_gldw like #{vc_gldw}||'%'
                        and a.vc_bgkzt in ('0', '7', '2', '6')
                        and a.vc_scbz = '0'
                        and a.vc_shbz in ('1','3','4','5','6','7','8')
                        and b.vc_hkshen = '0'
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_sfzh}))>
                      and b.vc_sfzh = #{vc_sfzh}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_jtdh}))>
                      and b.vc_lxdh = #{vc_jtdh}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hzxm}))>
                      and b.vc_hzxm = #{vc_hzxm}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkshen}))>
                      and b.vc_hkshen = #{vc_hkshen}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hks}))>
                      and b.vc_hks = #{vc_hks}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkqx}))>
                      and b.vc_hkqx = #{vc_hkqx}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkjd}))>
                      and b.vc_hkjd = #{vc_hkjd}
                   </if>
                   <if if("5".equals(#{vc_radio}) || ((StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",3,") < 0))) )>
                      and b.vc_sfzh is not null
                      and b.vc_sfzh <> '不详'
                   </if>
                   <if if(1 == 1)>
                     group by
                   </if>
                   <if if("1".equals(#{vc_radio}))>
                       b.vc_hzxm
                   </if>
                   <if if("2".equals(#{vc_radio}))>
                       substr(b.vc_hzxm,1,1)||substr(b.vc_hzxm,length(b.vc_hzxm))
                   </if>
                   <if if("3".equals(#{vc_radio}))>
                       substr(b.vc_hzxm,1,2)
                   </if>
                   <if if("4".equals(#{vc_radio}))>
                       substr(b.vc_hzxm,length(b.vc_hzxm)-1)
                   </if>
                   <if if("5".equals(#{vc_radio}))>
                       b.vc_sfzh
                   </if>
                   <if if("6".equals(#{vc_radio}))>
                       b.vc_lxdh
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",1,") < 0))>
                       , b.vc_hzxb
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",2,") < 0))>
                       , to_char(b.dt_hzcsrq,'yyyy')
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",3,") < 0))>
                       , b.vc_sfzh
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",4,") < 0))>
                       , b.vc_lxdh
                   </if>
                   <if if(1 == 1)>
                       Having count(*) > 1 and comp_group_repeat(wm_concat(vc_ccid), count(1)) = 1)
                   </if>
              )
         where rownum <= #{rn_e})
 where rn >= #{rn_s}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              