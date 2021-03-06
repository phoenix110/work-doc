select vc_bgkid,
       vc_bgkbh,
       vc_bgklx,
       vc_shbz,
       vc_bgkzt,
       DT_HZCSRQ,
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
       decode(VC_SFCF, '2', '未访', '已访') vc_cfzt_text,
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
              '浙江省' || pkg_zjmb_tnb.fun_getxzqhmc(VC_HKSDM) ||
              pkg_zjmb_tnb.fun_getxzqhmc(VC_HKQXDM) ||
              pkg_zjmb_tnb.fun_getxzqhmc(VC_HKJDDM) || VC_HKXXDZ,
              '1',
              '外省') hkdz_text,
       GetAge(dt_hzcsrq) nl,
       vc_icd10,
       dts(dt_bgrq, 0) dt_bgrq,
       dts(dt_cjsj, 0) dt_cjsj,
       dts(DT_YYSHSJ, 0) DT_YYSHSJ,
       dts(DT_QXSHSJ, 0) DT_QXSHSJ,
       dts(dt_sfsj, 0) dt_sfsj,
       dts(dt_cfsj, 0) dt_cfsj,
       decode(vc_zkid, vc_fkid, '主卡', '副卡') zfkbz_text,
       rn
  from (select t.*, rownum as rn
          from (select a.vc_bgkid,
                       a.vc_bgkbh,
                       a.vc_bgklx,
                       a.vc_shbz,
                       a.VC_KZT vc_bgkzt,
                       a.DT_BKRQ dt_bgrq,
                       a.dt_cjsj,
                       a.DT_YYSHSJ,
                       a.DT_QXSHSJ,
                       a.dt_sfsj,
                       a.dt_cfsj,
                       a.DT_HZCSRQ,
                       a.vc_sfcf,
                       a.vc_hzxm,
                       a.vc_hzxb,
                       a.VC_HZSFZH vc_sfzh,
                       a.VC_CZHKS VC_HKSFDM,
                       a.VC_CZHKSI VC_HKSDM,
                       a.VC_CZHKQX VC_HKQXDM,
                       a.VC_CZHKJD VC_HKJDDM,
                       a.vc_czhkjw VC_HKJWDM,
                       a.VC_HZICD vc_icd10,
                       a.VC_CZHKXXDZ VC_HKXXDZ,
                       b.vc_zkid,
                       b.vc_fkid,
                       count(1) over() as total
                  from zjjk_xnxg_bgk a,zjjk_xnxg_bgk_zfgx b
                  where a.vc_bgkid=b.vc_fkid
                   and a.vc_scbz = '2'
                   and a.vc_gldwdm like #{vc_gldw} || '%'
                   and a.vc_sfcf <> '2'
                   <if if(StringUtils.isNotBlank(#{vc_bgkbh}))>
                     and a.vc_bgkbh like #{vc_bgkbh}||'%'
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hzxm}))>
                     and a.vc_hzxm = #{vc_hzxm}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hzxb}))>
                     and a.vc_hzxb = #{vc_hzxb}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_sfzh}))>
                     and a.vc_hzsfzh = #{vc_sfzh}
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_sczdrq_ks}))>
                     and a.DT_QZRQ >= to_date(#{dt_sczdrq_ks},'yyyy-MM-dd HH24:mi:ss')
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_sczdrq_js}))>
                     and a.DT_QZRQ <= to_date(#{dt_sczdrq_js},'yyyy-MM-dd HH24:mi:ss')
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_bgrq_ks}))>
                     and a.DT_BKRQ >= to_date(#{dt_bgrq_ks},'yyyy-MM-dd HH24:mi:ss')
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_bgrq_js}))>
                     and a.DT_BKRQ <= to_date(#{dt_bgrq_js},'yyyy-MM-dd HH24:mi:ss')
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_cjsj_ks}))>
                     and a.Dt_Cjsj >= to_date(#{dt_cjsj_ks},'yyyy-MM-dd HH24:mi:ss')
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_cjsj_js}))>
                     and a.Dt_Cjsj <= to_date(#{dt_cjsj_js},'yyyy-MM-dd HH24:mi:ss')
                   </if>
                   <if if(StringUtils.isNotBlank(#{fbnl_ks}))>
                     and a.VC_BKSZNL >= #{fbnl_ks}
                   </if>
                   <if if(StringUtils.isNotBlank(#{fbnl_js}))>
                     and a.VC_BKSZNL <= #{fbnl_js}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkshen}))>
                     and a.VC_CZHKS = #{vc_hkshen}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hks}))>
                     and a.VC_CZHKSI = #{vc_hks}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkqx}))>
                     and a.VC_CZHKQX = #{vc_hkqx}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkjd}))>
                     and a.VC_CZHKJD = #{vc_hkjd}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkjw}))>
                     and a.vc_czhkjw = #{vc_hkjw}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkxxdz}))>
                     and a.vc_czhkxxdz = #{vc_hkxxdz}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_icd10}))>
                     and a.vc_hzicd = #{vc_icd10}
                   </if>
                    <if if(StringUtils.isNotBlank(#{vc_bks}))>
                     and a.Vc_Bkdw = #{vc_bks}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_bkq}))>
                     and a.vc_bkdwqx = #{vc_bkq}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_bgdw}))>
                     and a.Vc_Bkdwyy = #{vc_bgdw}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_bgkzt}))>
                     and a.vc_kzt = #{vc_bgkzt}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_shbz}))>
                     and a.vc_shbz = #{vc_shbz}
                   </if>
                   <if if("1".equals(#{zfklx}))>
                     and b.vc_zkid = b.vc_fkid 
                   </if>
                   <if if("2".equals(#{zfklx}))>
                     and b.vc_zkid <> b.vc_fkid 
                   </if>
                   order by a.vc_bgkid) t
         where rownum <= #{rn_e})
 where rn >= #{rn_s}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                