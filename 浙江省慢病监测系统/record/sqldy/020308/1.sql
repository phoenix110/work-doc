select group_count,
       group_no,
       vc_bgkid,
       vc_bgklx,
       vc_icd10,
       vc_icdo,
       vc_sznl,
       vc_shzt,
       dt_cfsj,
       dt_sfsj,
       dts(dt_zdrq,0) dt_zdrq,
       vc_personid,
       vc_hzxm,
       vc_hzxb,
       decode(vc_hzxb, '1', '男', '2', '女') vc_hzxb_text,
       vc_hzmz,
       dts(dt_hzcsrq,0) dt_hzcsrq,
       vc_sfzh,
       vc_jtdh,
       vc_gzdw,
       vc_zydm,
       vc_jtgz,
       vc_hksfdm,
       vc_hksdm,
       vc_hkjddm,
       vc_hkqxdm,
       vc_hkjwdm,
       vc_hkxxdz,
       vc_sjsfdm,
       vc_sjsdm,
       vc_sjqxdm,
       vc_sjjddm,
       vc_sjjwdm,
       vc_sjxxdz,
       total,
       rn,
       dts(dt_hzcsrq, 0) dt_hzcsrq,
       decode(vc_hzxb, '1', '男', '2', '女') vc_hzxb_text,
       decode(VC_HKSFDM,
              '0',
              '浙江省' ||
              pkg_zjmb_tnb.fun_getxzqhmc(VC_HKSDM) ||
              pkg_zjmb_tnb.fun_getxzqhmc(VC_HKQXDM) ||
              pkg_zjmb_tnb.fun_getxzqhmc(VC_HKJDDM) ||
              VC_HKXXDZ,
              '1',
              '外省') hjdz_text,
       dts(dt_sczdrq,0) dt_sczdrq,
       VC_BKSZNL,
       NB_KSPF,
       vc_bgdw,
       pkg_zjmb_tnb.fun_getyljgmc(vc_bgdw) vc_bgdwmc,
       vc_zgzddw,
       pkg_zjmb_tnb.fun_getcommdic('C_ZL_ZGZDDW', vc_zgzddw) vc_zgzddw_text,
       vc_bgys,
       dts(dt_bgrq,0) dt_bgrq,
       vc_sfcf,
       decode(vc_sfcf, '1', '已访', '3', '已访','未访') vc_sfcf_text,
       vc_icdo3ms,
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
              vc_bgkzt) vc_bgkzt_text
 from(
select group_count,
       group_no,vc_bgkid,
       vc_bgklx,
       vc_bgkzt,
       vc_icd10,
       vc_icdo,
       vc_sznl,
       vc_shzt,
       dt_cfsj,
       dt_sfsj,
       dt_zdrq,
       vc_personid,
       vc_hzxm,
       vc_hzxb,
       vc_hzmz,
       dt_hzcsrq,
       vc_sfzh,
       vc_jtdh,
       vc_gzdw,
       vc_zydm,
       vc_jtgz,
       vc_hksfdm,
       vc_hksdm,
       vc_hkjddm,
       vc_hkqxdm,
       vc_hkjwdm,
       vc_hkxxdz,
       vc_sjsfdm,
       vc_sjsdm,
       vc_sjqxdm,
       vc_sjjddm,
       vc_sjjwdm,
       vc_sjxxdz,
       dt_sczdrq,
       NB_KSPF,
       VC_BKSZNL,
       vc_bgdw,
       vc_zgzddw,
       vc_bgys,
       dt_bgrq,
       vc_sfcf,
       vc_icdo3ms,
       total,
       rownum as rn
from(
select 
       count(1) over(partition by
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
            vc_jtdh
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
            , vc_jtdh
        </if>
        <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",5,") < 0))>
            , substr(vc_icd10, 0, 3)
        </if>      
       ) as group_count,
       DENSE_RANK()over(
       order by 
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
            vc_jtdh
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
            , vc_jtdh
        </if>
        <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",5,") < 0))>
            , substr(vc_icd10, 0, 3)
        </if>
       ) as group_no,
       a.vc_bgkid,
       a.vc_bgkzt,
       a.vc_bgklx,
       a.vc_icd10,
       a.vc_icdo,
       a.vc_sznl,
       a.vc_shzt,
       a.dt_cfsj,
       a.dt_sfsj,
       a.dt_zdrq,
       b.vc_personid,
       b.vc_hzxm,
       b.vc_hzxb,
       b.vc_hzmz,
       b.dt_hzcsrq,
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
       b.vc_sjsfdm,
       b.vc_sjsdm,
       b.vc_sjqxdm,
       b.vc_sjjddm,
       b.vc_sjjwdm,
       b.vc_sjxxdz,
       a.dt_sczdrq,
       a.NB_KSPF,
       a.VC_BKSZNL,
       a.vc_bgdw,
       a.vc_zgzddw,
       a.vc_bgys,
       a.dt_bgrq,
       a.vc_sfcf,
       a.vc_icdo3ms,
       count(1) over() as total
  from zjjk_zl_bgk a, zjjk_zl_hzxx b
 where a.vc_hzid = b.vc_personid
   <if if(1 == 1)>
   and a.vc_gldw like #{vc_gldw} || '%'
   and a.vc_bgkzt in ('0', '7', '2', '6')
   and a.vc_shbz in ('1','3','5','6','7','8')
   and a.vc_scbz = '0'
   and b.vc_hksfdm = '0'
    </if>
                   <if if(StringUtils.isNotBlank(#{vc_sfzh}))>
                      and b.vc_sfzh = #{vc_sfzh}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_jtdh}))>
                      and b.vc_jtdh = #{vc_jtdh}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hzxm}))>
                      and b.vc_hzxm = #{vc_hzxm}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkshen}))>
                      and b.vc_hksfdm = #{vc_hkshen}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hks}))>
                      and b.vc_hksdm = #{vc_hks}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkqx}))>
                      and b.vc_hkqxdm = #{vc_hkqx}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkjd}))>
                      and b.vc_hkjddm = #{vc_hkjd}
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
                       b.vc_jtdh
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
                       , b.vc_jtdh
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",5,") < 0))>
                        , substr(a.vc_icd10, 0, 3)
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
                       b.vc_jtdh
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
                       , b.vc_jtdh
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",5,") < 0))>
                        , substr(a.vc_icd10, 0, 3)
                   </if>
                   <if if(1 == 1)>
                      from zjjk_zl_bgk a, zjjk_zl_hzxx b
                      where a.vc_hzid = b.vc_personid
                        and a.vc_gldw like #{vc_gldw}||'%'
                        and a.vc_bgkzt in ('0', '7', '2', '6')
                        and a.vc_scbz = '0'
                        and a.vc_shbz in ('1','3','5','6','7','8')
                        and b.vc_hksfdm = '0'
                   </if>
                   <if if("5".equals(#{vc_radio}) || ((StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",3,") < 0))) )>
                      and b.vc_sfzh is not null
                      and b.vc_sfzh <> '不详'
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_sfzh}))>
                      and b.vc_sfzh = #{vc_sfzh}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_jtdh}))>
                      and b.vc_jtdh = #{vc_jtdh}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hzxm}))>
                      and b.vc_hzxm = #{vc_hzxm}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkshen}))>
                      and b.vc_hksfdm = #{vc_hkshen}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hks}))>
                      and b.vc_hksdm = #{vc_hks}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkqx}))>
                      and b.vc_hkqxdm = #{vc_hkqx}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkjd}))>
                      and b.vc_hkjddm = #{vc_hkjd}
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
                       b.vc_jtdh
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
                       , b.vc_jtdh
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",5,") < 0))>
                        , substr(a.vc_icd10, 0, 3)
                   </if>
                   <if if(1 == 1)>
                       Having count(*) > 1 and comp_group_repeat(wm_concat(vc_ccid), count(1)) = 1)
                   </if>
                   
               )where rownum <= #{rn_e}
 )where rn >= #{rn_s}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
