select vc_bgkid as vc_bgkid,
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_BGKLX', vc_bgklx) as vc_bgklx,
       vc_mzh,
       vc_zyh,
       vc_icd10,
       vc_icd9,
       vc_bqygzbr,
       vc_hzxm,
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_XB', vc_hzxb) as vc_hzxb,
       to_char(dt_hzcsrq, 'yyyy-mm-dd') as dt_hzcsrq,
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_BGKZT', vc_bgkzt) as vc_bgkzt,
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_HY', vc_zydm) as vc_zydm,
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_ZY', vc_jtgz) as vc_jtgz,
       vc_bksznl,
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_MZ', vc_hzmz) as vc_hzmz,
       vc_sfzh as vc_sfzh,
       vc_gzdw,
       vc_jtdh as vc_jtdh,
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_SHEDM', vc_hksfdm) as vc_hksfdm,
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_SJDM', vc_hksdm) as vc_hksdm,
       (select px.mc from p_xzdm px where px.jb = '3' and px.dm = vc_hkqxdm) as vc_hkqxdm,
       (select px.mc from p_xzdm px where px.jb = '4' and px.dm = vc_hkjddm) as vc_hkjddm,
       vc_hkjwdm,
       vc_hkxxdz,
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_SHEDM', vc_sjsfdm) as vc_sjsfdm,
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_SJDM', vc_sjsdm) as vc_sjsdm,
       (select px.mc from p_xzdm px where px.jb = '3' and px.dm = vc_sjqxdm) as vc_sjqxdm,
       (select px.mc from p_xzdm px where px.jb = '4' and px.dm = vc_sjjddm) as vc_sjjddm,
       vc_sjjwdm,
       vc_sjxxdz,
       vc_icdo as vc_icdO,
       vc_icdM as vc_icdm,
       vc_dlw,
       vc_blh,
       vc_zdqbt,
       vc_zdqbN,
       vc_zdqbM,
       vc_zdsqb,
       pkg_zjmb_tnb.fun_getcommdic('C_XNXG_ZGZDDW', vc_zgzddw) as vc_zgzddw,
       to_char(dt_zdrq, 'yyyy-mm-dd') as dt_zdrq,
       vc_yzd,
       to_char(dt_yzdrq, 'yyyy-mm-dd') as dt_yzdrq,
       vc_bgdw || ' ' || (select d.mc from p_yljg d where d.dm(+) = vc_bgdw) as vc_bgdw,
       vc_bgys,
       to_char(dt_bgrq, 'yyyy-mm-dd') as dt_bgrq,
       to_char(dt_swrq, 'yyyy-mm-dd') as dt_swrq,
       vc_swyy,
       vc_swicd10,
       vc_swicdmc,
       vc_zdyh,
       vc_bszy,
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_SHZT', vc_shbz) as vc_shbz,
       to_char(dt_cjsj, 'yyyy-mm-dd') as dt_cjsj,
       to_char(dt_yyshsj, 'yyyy-mm-dd') as dt_yyshsj,
       to_char(dt_qxshsj, 'yyyy-mm-dd') as dt_qxshsj,
       to_char(dt_cfsj, 'yyyy-mm-dd') as dt_cfsj,
       to_char(dt_sfrq, 'yyyy-mm-dd') as dt_sfrq,
       vc_blxlx,
       vc_gldw as vc_gldw,
       vc_sfqc,
       vc_qcjddm,
       vc_qcxxdz,
       total,
       rn
  from (select vc_bgkid,
               vc_bgklx,
               vc_mzh,
               vc_zyh,
               vc_icd10,
               vc_icd9,
               vc_bqygzbr,
               vc_hzxm,
               vc_hzxb,
               dt_hzcsrq,
               vc_bgkzt,
               vc_zydm,
               vc_jtgz,
               vc_bksznl,
               vc_hzmz,
               vc_sfzh,
               vc_gzdw,
               vc_jtdh,
               vc_hksfdm,
               vc_hksdm,
               vc_hkqxdm,
               vc_hkjddm,
               vc_hkjwdm,
               vc_hkxxdz,
               vc_sjsfdm,
               vc_sjsdm,
               vc_sjqxdm,
               vc_sjjddm,
               vc_sjjwdm,
               vc_sjxxdz,
               vc_icdO,
               vc_icdM,
               vc_dlw,
               vc_blh,
               vc_zdqbt,
               vc_zdqbN,
               vc_zdqbM,
               vc_zdsqb,
               vc_zgzddw,
               dt_zdrq,
               vc_yzd,
               dt_yzdrq,
               vc_bgdw,
               vc_bgys,
               dt_bgrq,
               dt_swrq,
               vc_swyy,
               vc_swicd10,
               vc_swicdmc,
               vc_zdyh,
               vc_bszy,
               vc_shbz,
               dt_cjsj,
               dt_yyshsj,
               dt_qxshsj,
               dt_cfsj,
               dt_sfrq,
               vc_blxlx,
               vc_gldw,
               vc_sfqc,
               vc_qcjddm,
               vc_qcxxdz,
               total,
               rownum as rn
          from (select a.vc_bgkid,
                       a.vc_bgklx,
                       a.vc_mzh,
                       a.vc_zyh,
                       a.vc_icd10,
                       a.vc_icd9,
                       a.vc_bqygzbr,
                       b.vc_hzxm,
                       b.vc_hzxb,
                       b.dt_hzcsrq,
                       a.vc_bgkzt,
                       b.vc_zydm,
                       b.vc_jtgz,
                       a.vc_bksznl,
                       b.vc_hzmz,
                       b.vc_sfzh,
                       b.vc_gzdw,
                       b.vc_jtdh,
                       b.vc_hksfdm,
                       b.vc_hksdm,
                       b.vc_hkqxdm,
                       b.vc_hkjddm,
                       b.vc_hkjwdm,
                       b.vc_hkxxdz,
                       b.vc_sjsfdm,
                       b.vc_sjsdm,
                       b.vc_sjqxdm,
                       b.vc_sjjddm,
                       b.vc_sjjwdm,
                       b.vc_sjxxdz,
                       a.vc_icdO,
                       a.vc_icdM,
                       a.vc_dlw,
                       a.vc_blh,
                       a.vc_zdqbt,
                       a.vc_zdqbN,
                       a.vc_zdqbM,
                       a.vc_zdsqb,
                       a.vc_zgzddw,
                       a.dt_zdrq,
                       a.vc_yzd,
                       a.dt_yzdrq,
                       a.vc_bgdw,
                       a.vc_bgys,
                       a.dt_bgrq,
                       a.dt_swrq,
                       a.vc_swyy,
                       a.vc_swicd10,
                       a.vc_swicdmc,
                       a.vc_zdyh,
                       a.vc_bszy,
                       a.vc_shbz,
                       a.dt_cjsj,
                       a.dt_yyshsj,
                       a.dt_qxshsj,
                       a.dt_cfsj,
                       a.dt_sfrq,
                       a.vc_blxlx,
                       a.vc_gldw,
                       a.vc_sfqc,
                       a.vc_qcjddm,
                       a.vc_qcxxdz,
                       count(1) over() as total
                  from ZJJK_ZL_BGK a, ZJJK_ZL_HZXX b
                 where a.VC_HZID = b.VC_PERSONID
                   and a.vc_scbz = '0'
                  <if if("A1".equals(#{jglx}))>
                       and a.vc_bgdw like #{vc_gldw} || '%'
                   </if>
                   <if if("B1".equals(#{jglx}))>
                       and ((a.vc_shbz = '1' and a.vc_bgdw like #{vc_gldw} || '%') or 
                       (a.vc_shbz != '1' and (a.VC_CJDW like #{vc_gldw}|| '%' OR a.VC_GLDW like #{vc_gldw}|| '%' or b.VC_HKJDDM like #{jgszqh} || '%')))
                   </if>
                   <if if(!"A1".equals(#{jglx}) && !"B1".equals(#{jglx}) && StringUtils.isNotBlank(#{jgszqh}))>
                     AND (a.VC_CJDW like #{vc_gldw}|| '%' OR a.VC_GLDW like #{vc_gldw}|| '%' or b.VC_HKJDDM like #{jgszqh} || '%')
                   </if>
                   <if if(!"A1".equals(#{jglx}) && !"B1".equals(#{jglx}) && StringUtils.isBlank(#{jgszqh}))>
                     AND (a.VC_CJDW like #{vc_gldw}|| '%' OR a.VC_GLDW like #{vc_gldw}|| '%')
                   </if>
                   
                   <if if(StringUtils.isNotBlank(#{vc_bghks}))>
                       and a.VC_BGDWS = #{vc_bghks}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_bghkqx}))>
                       and a.VC_BGDWQX = #{vc_bghkqx}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_bgdw}))>
                       and a.VC_BGDW = #{vc_bgdw}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_icd10}))>
                       and a.vc_icd10 LIKE '%'||#{vc_icd10}||'%'
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_bgkid}))>
                       and a.VC_BGKID = #{vc_bgkid}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hzxb}))>
                       and b.Vc_Hzxb = #{vc_hzxb}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_sfzh}))>
                       and b.Vc_Sfzh = #{vc_sfzh}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_shbz}) && !#{vc_shbz}.contains(","))>
                     and a.vc_shbz = #{vc_shbz}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_shbz}) && #{vc_shbz}.contains(","))>
                     and instr(#{vc_shbz},a.vc_shbz) > 0
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_sfhs}))>
                       and b.Vc_Sfhs = #{vc_sfhs}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_bgkzt}))>
                       and a.VC_BGKZT = #{vc_bgkzt}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_sfsw}))>
                       and b.vc_sfsw = #{vc_sfsw}
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_zdrq_ks}))>
                       and a.DT_SCZDRQ >= std(#{dt_zdrq_ks},1)
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_zdrq_js}))>
                       and a.DT_SCZDRQ <= std(#{dt_zdrq_js},1)
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_bgrq_ks}))>
                       and a.dt_bgrq >= std(#{dt_bgrq_ks},1)
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_bgrq_js}))>
                       and a.dt_bgrq <= std(#{dt_bgrq_js},1)
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_xm}))>
                       and b.vc_hzxm like '%' ||#{vc_xm} || '%'
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_cjsj_ks}))>
                       and a.dt_cjsj >= std(#{dt_cjsj_ks},1)
                   </if>
                   <if if(StringUtils.isNotBlank(#{dt_cjsj_js}))>
                       and a.dt_cjsj <= std(#{dt_cjsj_js},1)
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_sznl_ks}))>
                       and a.vc_sznl >= to_number(#{vc_sznl_ks})
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_sznl_js}))>
                       and a.vc_sznl <=to_number(#{vc_sznl_js})
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkshen}))>
                       and b.VC_HKSFDM = #{vc_hkshen}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hks}))>
                       and (b.VC_HKSDM = #{vc_hks})
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkqx}))>
                       and b.VC_HKQXDM = #{vc_hkqx}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkjd}))>
                       and b.VC_HKJDDM = #{vc_hkjd}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkjw}))>
                       and b.VC_HKJWDM = #{vc_hkjw}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_mzh}))>
                       and b.VC_MZH = #{vc_mzh}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_zyh}))>
                       and b.VC_ZYH = #{vc_zyh}
                   </if>
                 order by a.vc_bgkid)
         where rownum <= #{rn_e})
 where rn >= #{rn_s}