select vc_bgkid,
       vc_bgklx,
       vc_hzid,
       vc_bgkzt,
       vc_icd10,
       dts(dt_cjsj,0) dt_cjsj,
       dts(DT_YYSHSJ,0) dt_yyshsj,
       dts(DT_QXSHSJ,0) dt_qxshsj,
       dts(dt_sczdrq,0) dt_sczdrq,
       VC_SFCF,
       decode(VC_SFCF, '2','未访','已访') vc_cfzt_text,
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
              (select name
                 from code_info
                where code = VC_HKSDM
                  and code_info_id =
                      (select id from code_info where code = 'C_COMM_SJDM')) ||
              (select name
                 from code_info
                where code = VC_HKQXDM
                  and code_info_id =
                      (select id from code_info where code = 'C_COMM_QXDM')) ||
              (select name
                 from code_info
                where code = VC_HKJDDM
                  and code_info_id =
                      (select id from code_info where code = 'C_COMM_JDDM')) ||
              VC_HKJWDM || VC_HKXXDZ,
              '1',
              '外省') hjdz_text,
        vc_zkid,
        vc_fkid,
        decode(vc_zkid, vc_fkid, '主卡', '副卡') zfkbz_text,
       total,
       rn
  from (select vc_bgkid,
               vc_bgklx,
               vc_hzid,
               vc_shbz,
               vc_bgkzt,
               vc_icd10,
               dt_cjsj,
               DT_YYSHSJ,
               DT_QXSHSJ,
               dt_sczdrq,
               VC_SFCF,
               vc_hzxm,
               vc_hzxb,
               vc_sfzh,
               VC_HKSFDM,
               VC_HKSDM,
               VC_HKQXDM,
               VC_HKJDDM,
               VC_HKJWDM,
               VC_HKXXDZ,
               vc_zkid,
               vc_fkid,
               total,
               rownum as rn
          from (select bgk.vc_bgkid,
                       bgk.vc_bgklx,
                       bgk.vc_hzid,
                       bgk.vc_shbz,
                       bgk.vc_bgkzt,
                       bgk.vc_icd10,
                       bgk.dt_cjsj,
                       bgk.DT_YYSHSJ,
                       bgk.DT_QXSHSJ,
                       bgk.dt_sczdrq,
                       bgk.VC_SFCF,
                       hzxx.vc_hzxm,
                       hzxx.vc_hzxb,
                       hzxx.vc_sfzh,
                       hzxx.VC_HKSFDM,
                       hzxx.VC_HKSDM,
                       hzxx.VC_HKQXDM,
                       hzxx.VC_HKJDDM,
                       hzxx.VC_HKJWDM,
                       hzxx.VC_HKXXDZ,
                       zfk.vc_zkid,
                       zfk.vc_fkid,
                       count(1) over() as total
                  from ZJJK_ZL_BGK bgk, ZJJK_ZL_HZXX hzxx, zjjk_zl_bgk_zfgx zfk
                 where BGK.VC_HZID = HZXX.VC_PERSONID
                   and bgk.vc_bgkid = zfk.vc_fkid
                   and bgk.vc_scbz = '0'
                   AND bgk.VC_GLDW like #{vc_gldw}|| '%'
                   and bgk.vc_sfcf <> '2'
                    <if if(StringUtils.isNotBlank(#{vc_icd10}))>
                       and BGK.vc_icd10 LIKE '%'||#{vc_icd10}||'%'
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_bgdw}))>
                       and BGK.VC_BGDW = #{vc_bgdw}
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_sczdrq_ks}))>
                       and BGK.dt_sczdrq >= std(#{dt_sczdrq_ks},1)
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_sczdrq_js}))>
                       and BGK.dt_sczdrq <= std(#{dt_sczdrq_js},1)
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_bgkid}))>
                       and BGK.VC_BGKID = #{vc_bgkid}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hzxb}))>
                       and hzxx.Vc_Hzxb = #{vc_hzxb}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_sfzh}))>
                       and hzxx.Vc_Sfzh = #{vc_sfzh}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_shbz}))>
                       AND BGK.VC_SHBZ IN (#{vc_shbz})
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_sfhs}))>
                       and hzxx.Vc_Sfhs = #{vc_sfhs}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_bgkzt}))>
                       and BGK.VC_BGKZT = #{vc_bgkzt}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_sfsw}))>
                       and hzxx.vc_sfsw = #{vc_sfsw}
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_zdrq_ks}))>
                       and bgk.dt_zdrq >= std(#{dt_zdrq_ks},1)
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_zdrq_js}))>
                       and bgk.dt_zdrq <= std(#{dt_zdrq_js},1)
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_bgrq_ks}))>
                       and bgk.dt_bgrq >= std(#{dt_bgrq_ks},1)
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_bgrq_js}))>
                       and bgk.dt_bgrq <= std(#{dt_bgrq_js},1)
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hzxm}))>
                       and hzxx.vc_hzxm like #{vc_hzxm} || '%'
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_cjsj_ks}))>
                       and bgk.dt_cjsj >= std(#{dt_cjsj_ks},1)
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_cjsj_js}))>
                       and bgk.dt_cjsj <= std(#{dt_cjsj_js},1)
                   </if>
                   <if if(StringUtils.isNotBlank(#{fbnl_ks}))>
                       and bgk.vc_sznl >= #{fbnl_ks}
                   </if>
                   <if if(StringUtils.isNotBlank(#{fbnl_js}))>
                       and bgk.vc_sznl <= #{fbnl_js}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkshen}))>
                       and hzxx.VC_HKSFDM = #{vc_hkshen}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hks}))>
                       and (hzxx.VC_HKSDM = #{vc_hks})
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkqx}))>
                       and hzxx.VC_HKQXDM = #{vc_hkqx}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkjd}))>
                       and hzxx.VC_HKJDDM = #{vc_hkjd}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkjw}))>
                       and hzxx.VC_HKJWDM = #{vc_hkjw}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkxxdz}))>
                       and hzxx.vc_hkxxdz like '%'||#{vc_hkxxdz}||'%'
                   </if>
                   <if if("1".equals(#{zfklx}))>
                     and zfk.vc_zkid = zfk.vc_fkid 
                   </if>
                   <if if("2".equals(#{zfklx}))>
                     and zfk.vc_zkid <> zfk.vc_fkid 
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_bks}))>
                       and BGK.vc_bgdws = #{vc_bks}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_bkq}))>
                       and BGK.vc_bgdwqx = #{vc_bkq}
                   </if>
                 order by bgk.vc_bgkid)
         where rownum <= #{rn_e})
 where rn >= #{rn_s}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                