select  count(1) over(partition by
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
            vc_hzsfzh
        </if>
        <if if("6".equals(#{vc_radio}))>
            vc_hzjtdh
        </if>
        <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",1,") < 0))>
            , vc_hzxb
        </if>
        <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",2,") < 0))>
            , to_char(dt_hzcsrq,'yyyy')
        </if>
        <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",3,") < 0))>
            , vc_hzsfzh
        </if>
        <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",4,") < 0))>
            , vc_hzjtdh
        </if>
        <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",5,") < 0))>
            , substr(vc_hzicd, 0, 3)
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
            vc_hzsfzh
        </if>
        <if if("6".equals(#{vc_radio}))>
            vc_hzjtdh
        </if>
        <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",1,") < 0))>
            , vc_hzxb
        </if>
        <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",2,") < 0))>
            , to_char(dt_hzcsrq,'yyyy')
        </if>
        <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",3,") < 0))>
            , vc_hzsfzh
        </if>
        <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",4,") < 0))>
            , vc_hzjtdh
        </if>
        <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",5,") < 0))>
            , substr(vc_hzicd, 0, 3)
        </if>
        <if if(1 == 1)>
       ) as group_no,
       vc_bgkid,
       vc_bgkbh,
       vc_kzt,
       vc_bgklx,
       vc_hzicd,
       vc_shzt,
       dt_cfsj,
       dt_sfsj,
       vc_hzxm,
       vc_hzxb,
       vc_hzmz,
       vc_hzsfzh,
       vc_hzjtdh,
       VC_CZHKS,
       VC_CZHKSi,
       VC_CZHKqx,
       VC_CZHKjd,
       VC_CZHKjw,
       VC_CZHKxxdz,
       dt_fbrq,
       dt_qzrq,
       vc_qzdw,
       vc_sfsf,
       dts(dt_bkrq,0) dt_bkrq,
       vc_bkys,
       decode(vc_sfsf, '1', '是', '2', '否', vc_sfsf) vc_sfsf_text,
       dts(dt_swrq,0) dt_swrq,
       decode(vc_swys, '0', '心脑', '1', '非心脑', vc_swys) vc_swys_text,
       vc_sfcf,
       vc_bszy,
       decode(vc_hzxb, '1', '男', '2', '女') vc_hzxb_text,
       dts(dt_hzcsrq,0) dt_hzcsrq,
       decode(vc_hzxb, '1', '男', '2', '女') vc_hzxb_text,
       decode(VC_CZHKS,
              '0',
              '浙江省' ||
              pkg_zjmb_tnb.fun_getxzqhmc(VC_CZHKSi) ||
              pkg_zjmb_tnb.fun_getxzqhmc(VC_CZHKqx) ||
              pkg_zjmb_tnb.fun_getxzqhmc(VC_CZHKjd) ||
              VC_CZHKxxdz,
              '1',
              '外省') hjdz_text,
       pkg_zjmb_tnb.fun_getcommdic('C_XNXG_ZGZDDW', vc_qzdw) vc_qzdwmc,
       decode(vc_sfcf, '1', '已访', '未访') vc_sfcf_text,
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
              total,
              rn
 from(
select vc_bgkid,
       vc_bgkbh,
       vc_kzt,
       vc_bgklx,
       vc_hzicd,
       vc_shzt,
       dt_cfsj,
       dt_sfsj,
       vc_hzxm,
       vc_hzxb,
       vc_hzmz,
       dt_hzcsrq,
       vc_hzsfzh,
       vc_hzjtdh,
       VC_CZHKS,
       VC_CZHKSi,
       VC_CZHKqx,
       VC_CZHKjd,
       VC_CZHKjw,
       VC_CZHKxxdz,
       dt_fbrq,
       dt_qzrq,
       vc_qzdw,
       vc_sfsf,
       dt_swrq,
       vc_swys,
       vc_sfcf,
       vc_bszy,
       dt_bkrq,
       vc_bkys,
       total,
       rownum as rn
from(
select a.vc_bgkid,
       a.vc_bgkbh,
       a.vc_kzt,
       a.vc_bgklx,
       a.vc_hzicd,
       a.vc_shzt,
       a.dt_cfsj,
       a.dt_sfsj,
       a.vc_hzxm,
       a.vc_hzxb,
       a.vc_hzmz,
       a.dt_hzcsrq,
       a.vc_hzsfzh,
       a.vc_hzjtdh,
       a.VC_CZHKS,
       a.VC_CZHKSi,
       a.VC_CZHKqx,
       a.VC_CZHKjd,
       a.VC_CZHKjw,
       a.VC_CZHKxxdz,
       a.dt_fbrq,
       a.dt_qzrq,
       a.vc_qzdw,
       a.vc_sfsf,
       a.dt_swrq,
       a.vc_swys,
       a.vc_sfcf,
       a.vc_bszy,
       a.dt_bkrq,
       a.vc_bkys,
       count(1) over() as total
  from zjjk_xnxg_bgk a
 where a.vc_gldwdm like #{vc_gldw} || '%'
   and a.vc_kzt in ('0', '7', '2', '6')
   and a.vc_shbz in ('1','3','5','6','7','8')
   and a.vc_scbz = '2'
   and a.vc_czhks = '0'
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_sfzh}))>
                      and a.vc_hzsfzh = #{vc_sfzh}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hzjtdh}))>
                      and a.vc_hzjtdh = #{vc_hzjtdh}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hzxm}))>
                      and a.vc_hzxm = #{vc_hzxm}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkshen}))>
                      and a.VC_CZHKS = #{vc_hkshen}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hks}))>
                      and a.VC_CZHKSi = #{vc_hks}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkqx}))>
                      and a.VC_CZHKqx = #{vc_hkqx}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkjd}))>
                      and a.VC_CZHKjd = #{vc_hkjd}
                   </if>
                   <if if("5".equals(#{vc_radio}) || ((StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",3,") < 0))) )>
                      and a.vc_hzsfzh is not null
                      and a.vc_hzsfzh <> '不详'
                   </if>
                   <if if(1 == 1)>
                       and (
                   </if>
                   <if if("1".equals(#{vc_radio}))>
                       a.vc_hzxm
                   </if>
                   <if if("2".equals(#{vc_radio}))>
                       substr(a.vc_hzxm,1,1)||substr(a.vc_hzxm,length(a.vc_hzxm))
                   </if>
                   <if if("3".equals(#{vc_radio}))>
                       substr(a.vc_hzxm,1,2)
                   </if>
                   <if if("4".equals(#{vc_radio}))>
                       substr(a.vc_hzxm,length(a.vc_hzxm)-1)
                   </if>
                   <if if("5".equals(#{vc_radio}))>
                       a.vc_hzsfzh
                   </if>
                   <if if("6".equals(#{vc_radio}))>
                       a.vc_hzjtdh
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",1,") < 0))>
                       , a.vc_hzxb
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",2,") < 0))>
                       , to_char(a.dt_hzcsrq,'yyyy')
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",3,") < 0))>
                       , a.vc_hzsfzh
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",4,") < 0))>
                       , a.vc_hzjtdh
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",5,") < 0))>
                       , substr(a.vc_hzicd, 0, 3)
                   </if>
                   <if if(1 == 1)>
                   ) in (select
                   </if>
                   <if if("1".equals(#{vc_radio}))>
                       a.vc_hzxm
                   </if>
                   <if if("2".equals(#{vc_radio}))>
                       substr(a.vc_hzxm,1,1)||substr(a.vc_hzxm,length(a.vc_hzxm))
                   </if>
                   <if if("3".equals(#{vc_radio}))>
                       substr(a.vc_hzxm,1,2)
                   </if>
                   <if if("4".equals(#{vc_radio}))>
                       substr(a.vc_hzxm,length(a.vc_hzxm)-1)
                   </if>
                   <if if("5".equals(#{vc_radio}))>
                       a.vc_hzsfzh
                   </if>
                   <if if("6".equals(#{vc_radio}))>
                       a.vc_hzjtdh
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",1,") < 0))>
                       , a.vc_hzxb
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",2,") < 0))>
                       , to_char(a.dt_hzcsrq,'yyyy')
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",3,") < 0))>
                       , a.vc_hzsfzh
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",4,") < 0))>
                       , a.vc_hzjtdh
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",5,") < 0))>
                       , substr(a.vc_hzicd, 0, 3)
                   </if>
                   <if if(1 == 1)>
                      from zjjk_xnxg_bgk a
                      where a.vc_gldwdm like #{vc_gldw}||'%'
                        and a.vc_kzt in ('0', '7', '2', '6')
                        and a.vc_scbz = '2'
                        and a.vc_shbz in ('1','3','5','6','7','8')
                        and a.vc_czhks = '0'
                   </if>
                   <if if("5".equals(#{vc_radio}) || ((StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",3,") < 0))) )>
                      and a.vc_hzsfzh is not null
                      and a.vc_hzsfzh <> '不详'
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_sfzh}))>
                      and a.vc_hzsfzh = #{vc_sfzh}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hzjtdh}))>
                      and a.vc_hzjtdh = #{vc_hzjtdh}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hzxm}))>
                      and a.vc_hzxm = #{vc_hzxm}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkshen}))>
                      and a.VC_CZHKS = #{vc_hkshen}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hks}))>
                      and a.VC_CZHKSi = #{vc_hks}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkqx}))>
                      and a.VC_CZHKqx = #{vc_hkqx}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkjd}))>
                      and a.VC_CZHKjd = #{vc_hkjd}
                   </if>
                   <if if(1 == 1)>
                     group by
                   </if>
                   <if if("1".equals(#{vc_radio}))>
                       a.vc_hzxm
                   </if>
                   <if if("2".equals(#{vc_radio}))>
                       substr(a.vc_hzxm,1,1)||substr(a.vc_hzxm,length(a.vc_hzxm))
                   </if>
                   <if if("3".equals(#{vc_radio}))>
                       substr(a.vc_hzxm,1,2)
                   </if>
                   <if if("4".equals(#{vc_radio}))>
                       substr(a.vc_hzxm,length(a.vc_hzxm)-1)
                   </if>
                   <if if("5".equals(#{vc_radio}))>
                       a.vc_hzsfzh
                   </if>
                   <if if("6".equals(#{vc_radio}))>
                       a.vc_hzjtdh
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",1,") < 0))>
                       , a.vc_hzxb
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",2,") < 0))>
                       , to_char(a.dt_hzcsrq,'yyyy')
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",3,") < 0))>
                       , a.vc_hzsfzh
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",4,") < 0))>
                       , a.vc_hzjtdh
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",5,") < 0))>
                       , substr(a.vc_hzicd, 0, 3)
                   </if>
                   <if if(1 == 1)>
                       Having count(*) > 1 and comp_group_repeat(wm_concat(vc_ccid), count(1)) = 1)
                   </if>
                   
               )where rownum <= #{rn_e}
 )where rn >= #{rn_s}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         