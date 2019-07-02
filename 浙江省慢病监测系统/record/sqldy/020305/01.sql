<if if(StringUtils.isNotBlank(#{xzqh_organ}))>
   with xzqh_list as
     (SELECT REGEXP_SUBSTR(#{xzqh_organ}, '[^,]+', 1, LEVEL, 'i') AS xzqh_item
        FROM DUAL
      CONNECT BY LEVEL <=
                 LENGTH(#{xzqh_organ}) - LENGTH(REGEXP_REPLACE(#{xzqh_organ}, ',', '')) + 1
    )
</if>
select vc_bgkid,
       vc_bgklx,
       vc_hzid,
       vc_bgkzt,
       vc_icd10,
       dts(dt_bgrq,0) dt_bgrq,
       dts(dt_cjsj,0) dt_cjsj,
       dts(DT_YYSHSJ,0) DT_YYSHSJ,
       dts(DT_QXSHSJ,0) DT_QXSHSJ,
       dts(dt_sfsj,0) dt_sfsj,
       dts(dt_cfsj,0) dt_cfsj,
       vc_sfcf,
       vc_shbz,
       dt_hzcsrq,
       GetAge(dt_hzcsrq) nl,
       vc_hzxm,
       vc_hzxb,
       vc_sfzh,
       VC_HKSFDM,
       VC_HKSDM,
       VC_HKQXDM,
       VC_HKJDDM,
       VC_HKJWDM,
       VC_HKXXDZ,
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
       decode(vc_hzxb, '1', '男', '2', '女') vc_hzxb_text,
       decode(VC_HKSFDM,
              '0',
              '浙江省' ||
              pkg_zjmb_tnb.fun_getxzqhmc(VC_HKSDM) ||
              pkg_zjmb_tnb.fun_getxzqhmc(VC_HKQXDM) ||
              pkg_zjmb_tnb.fun_getxzqhmc(VC_HKJDDM) ||
              VC_HKXXDZ,
              '1',
              '外省') hkdz_text,      
       total,
       rn
  from (select vc_bgkid,
               vc_bgklx,
               vc_hzid,
               vc_shbz,
               vc_bgkzt,
               vc_icd10,
               dt_bgrq,
               dt_cjsj,
               dt_hzcsrq,
               DT_YYSHSJ,
               DT_QXSHSJ,
               dt_sfsj,
               dt_cfsj,
               vc_sfcf,
               vc_hzxm,
               vc_hzxb,
               vc_sfzh,
               VC_HKSFDM,
               VC_HKSDM,
               VC_HKQXDM,
               VC_HKJDDM,
               VC_HKJWDM,
               VC_HKXXDZ,
               total,
               rownum as rn
          from (select a.vc_bgkid,
                       a.vc_bgklx,
                       a.vc_hzid,
                       a.vc_shbz,
                       a.vc_bgkzt,
                       a.dt_bgrq,
                       a.vc_icd10,
                       a.vc_sfcf,
                       a.dt_cjsj,
                       a.DT_YYSHSJ,
                       a.DT_QXSHSJ,
                       a.DT_SFSJ,
                       a.dt_cfsj,
                       b.vc_hzxm,
                       b.vc_hzxb,
                       b.vc_sfzh,
                       b.dt_hzcsrq,
                       b.VC_HKSFDM,
                       b.VC_HKSDM,
                       b.VC_HKQXDM,
                       b.VC_HKJDDM,
                       b.VC_HKJWDM,
                       b.VC_HKXXDZ,
                       count(1) over() as total
                  from zjjk_zl_bgk a, zjjk_zl_hzxx b
                 where a.vc_hzid = b.vc_personid
                   <if if(StringUtils.isNotBlank(#{xzqh_organ}))>
                       and exists (select 1 from xzqh_list xt where b.vc_hkjddm like xt.xzqh_item || '%')
                   </if>
                   <if if(StringUtils.isBlank(#{xzqh_organ}))>
                       and b.vc_hkjddm like #{jgszqh} || '%' 
                   </if>
                   and a.vc_sdqrzt = '0'
                   and a.vc_scbz = '0'
                   and a.vc_shbz = '3'
                   <if if(StringUtils.isNotBlank(#{vc_bgkid}))>
                     and a.vc_bgkid like #{vc_bgkid}||'%'
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hzxm}))>
                     and b.vc_hzxm like '%'||#{vc_hzxm}||'%'
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hzxb}))>
                     and b.vc_hzxb = #{vc_hzxb}
                   </if>
                    <if if(StringUtils.isNotBlank(#{vc_sfzh}))>
                     and b.vc_sfzh = #{vc_sfzh}
                   </if>
                    <if if(StringUtils.isNotBlank(#{vc_bksznl}))>
                     and a.vc_bksznl = #{vc_bksznl}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_bgkzt}))>
                     and a.vc_bgkzt = #{vc_bgkzt}
                   </if>
                   <if if(StringUtils.isNotBlank(#{fbnl_ks}))>
                     and a.sznl >= #{fbnl_ks}
                   </if>
                   <if if(StringUtils.isNotBlank(#{fbnl_js}))>
                     and a.sznl <= #{fbnl_js}
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_sczdrq_ks}))>
                     and a.dt_sczdrq >= to_date(#{dt_sczdrq_ks},'yyyy-MM-dd HH24:mi:ss')
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_sczdrq_js}))>
                     and a.dt_sczdrq <= to_date(#{dt_sczdrq_js},'yyyy-MM-dd HH24:mi:ss')
                   </if>
                   <if if(StringUtils.isNotBlank(#{VC_ICD10}))>
                     and a.VC_ICD10 <= #{VC_ICD10}
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_bgrq_ks}))>
                     and a.dt_bgrq >= to_date(#{dt_bgrq_ks},'yyyy-MM-dd HH24:mi:ss')
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_bgrq_js}))>
                     and a.dt_bgrq <= to_date(#{dt_bgrq_js},'yyyy-MM-dd HH24:mi:ss')
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_swrq_ks}))>
                     and a.dt_swrq >= to_date(#{dt_swrq_ks},'yyyy-MM-dd HH24:mi:ss')
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_swrq_js}))>
                     and a.dt_swrq <= to_date(#{dt_swrq_js},'yyyy-MM-dd HH24:mi:ss')
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_cjsj_ks}))>
                     and a.dt_cjsj >= #{dt_cjsj_ks}
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_cjsj_js}))>
                     and a.dt_cjsj <= #{dt_cjsj_js}
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_qxshsj_ks}))>
                     and a.dt_qxshsj >= #{dt_qxshsj_ks}
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_qxshsj_js}))>
                     and a.dt_qxshsj <= #{dt_qxshsj_js}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_wxystz_ks}))>
                     and b.vc_wxystz >= #{vc_wxystz_ks}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_wxystz_js}))>
                     and b.vc_wxystz <= #{vc_wxystz_js}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hksfdm}))>
                     and b.vc_hksfdm = #{vc_hksfdm}
                   </if>
                    <if if(StringUtils.isNotBlank(#{vc_hksdm}))>
                     and b.vc_hksdm = #{vc_hksdm}
                   </if>
                    <if if(StringUtils.isNotBlank(#{vc_hkqxdm}))>
                     and b.vc_hkqxdm = #{vc_hkqxdm}
                   </if>
                    <if if(StringUtils.isNotBlank(#{vc_hkjddm}))>
                     and b.vc_hkjddm = #{vc_hkjddm}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkjw}))>
                     and b.vc_hkjwdm = #{vc_hkjw}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkxxdz}))>
                     and b.vc_hkxxdz = #{vc_hkxxdz}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_bgdw}))>
                     and a.vc_bgdw = #{vc_bgdw}
                   </if>
                   order by a.vc_bgkid
                   )
         where rownum <= #{rn_e})
 where rn >= #{rn_s}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
