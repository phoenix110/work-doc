with tab as
 (select vc_icd10,
         count(1) zrs,
         sum(count(1)) over() zrs_zj,
         sum(decode(t1.vc_hzxb, '1', 1, 0)) mrs,
         sum(sum(decode(t1.vc_hzxb, '1', 1, 0))) over() mrs_zj,
         sum(decode(t1.vc_hzxb, '2', 1, 0)) wrs,
         sum(sum(decode(t1.vc_hzxb, '2', 1, 0))) over() wrs_zj
    from zjjk_zl_bgk t, zjjk_zl_hzxx t1
   where t.vc_hzid = t1.vc_personid
     and t.vc_scbz = '0'
     and t.vc_shbz in ('3', '5', '6', '7', '8')
     and t.vc_bgkzt in ('0', '2', '6', '7')
     <if if(StringUtils.isNotBlank(#{vc_hkqx}))>
       and t1.vc_hkqxdm = #{vc_hkqx}
     </if>
     <if if(StringUtils.isBlank(#{vc_hkqx}) && StringUtils.isNotBlank(#{vc_hks}))>
       and t1.vc_hksdm = #{vc_hks}
     </if>
     <if if(StringUtils.isNotBlank(#{dt_qzsj_ks}))>
        and t.dt_sczdrq >= std(#{dt_qzsj_ks},1)
     </if>
     <if if(StringUtils.isNotBlank(#{dt_qzsj_js}))>
        and t.dt_sczdrq <= std(#{dt_qzsj_js},1)
     </if>
     <if if(StringUtils.isNotBlank(#{dt_lrsj_ks}))>
        and t.dt_cjsj >= std(#{dt_lrsj_ks},1)
     </if>
     <if if(StringUtils.isNotBlank(#{dt_lrsj_js}))>
        and t.dt_cjsj <= std(#{dt_lrsj_js},1)
     </if>
     <if if("2".equals(#{hjlx}))>
        and exists(select 1 from p_xzdm xzdm where t1.vc_hkjddm = xzdm.dm and xzdm.csbz = '城市')
     </if>
     <if if("3".equals(#{hjlx}))>
        and exists(select 1 from p_xzdm xzdm where t1.vc_hkjddm = xzdm.dm and xzdm.csbz = '农村')
     </if>
     <if if(1 == 1)>
   group by vc_icd10)
select a.rn 顺位,
       a.icd10_zrs || ' ' ||
       pkg_zjmb_tnb.fun_getcommdic('C_ZL_JCZDBW', a.icd10_zrs) 肿瘤部位合计,
       b.icd10_mrs || ' ' ||
       pkg_zjmb_tnb.fun_getcommdic('C_ZL_JCZDBW', b.icd10_mrs) 肿瘤部位男,
       c.icd10_wrs || ' ' ||
       pkg_zjmb_tnb.fun_getcommdic('C_ZL_JCZDBW', c.icd10_wrs) 肿瘤部位女,
       a.zrs 发病数合计,
       a.zrs_zj,
       round(100 * a.zrs / decode(a.zrs_zj, 0, null, a.zrs_zj), 2) 构成比合计,
       b.mrs 发病数男,
       b.mrs_zj,
       round(100 * b.mrs / decode(b.mrs_zj, 0, null, b.mrs_zj), 2) 构成比男,
       c.wrs 发病数女,
       c.wrs_zj,
       round(100 * c.wrs / decode(c.wrs_zj, 0, null, c.wrs_zj), 2) 构成比女,
       round(100 * a.zrs / (select decode(max(a.vc_zhj), 0, null, max(a.vc_zhj))
                  from ZJMB_RKGLB a
                 where vc_lx = '6'
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkqx}))>
                     and a.vc_rkgljd = '99999999'
                     and a.vc_rkglq = #{vc_hkqx}
                   </if>
                   <if if(StringUtils.isBlank(#{vc_hkqx}) && StringUtils.isNotBlank(#{vc_hks}))>
                     and a.vc_rkglq = '99999999'
                     and a.vc_rkgls = #{vc_hks}
                   </if>
                   <if if(StringUtils.isBlank(#{vc_hks}))>
                       and a.vc_rkgls = '99999999'
                   </if>
                   <if if(1 == 1)>
                   and a.vc_nf = #{nf}),2) 发病率合计,
       round(100 * b.mrs / (select decode(max(a.vc_nhj), 0, null, max(a.vc_nhj))
                  from ZJMB_RKGLB a
                 where vc_lx = '4'
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkqx}))>
                     and a.vc_rkgljd = '99999999'
                     and a.vc_rkglq = #{vc_hkqx}
                   </if>
                   <if if(StringUtils.isBlank(#{vc_hkqx}) && StringUtils.isNotBlank(#{vc_hks}))>
                     and a.vc_rkglq = '99999999'
                     and a.vc_rkgls = #{vc_hks}
                   </if>
                   <if if(StringUtils.isBlank(#{vc_hks}))>
                       and a.vc_rkgls = '99999999'
                   </if>
                   <if if(1 == 1)>
                   and a.vc_nf = #{nf}),2) 发病率男,
       round(100 * c.wrs / (select decode(max(a.vc_vhj), 0, null, max(a.vc_vhj))
                  from ZJMB_RKGLB a
                 where vc_lx = '5'
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkqx}))>
                     and a.vc_rkgljd = '99999999'
                     and a.vc_rkglq = #{vc_hkqx}
                   </if>
                   <if if(StringUtils.isBlank(#{vc_hkqx}) && StringUtils.isNotBlank(#{vc_hks}))>
                     and a.vc_rkglq = '99999999'
                     and a.vc_rkgls = #{vc_hks}
                   </if>
                   <if if(StringUtils.isBlank(#{vc_hks}))>
                       and a.vc_rkgls = '99999999'
                   </if>
                   and a.vc_nf = #{nf}),2) 发病率女
  from (select zrs, icd10_zrs, zrs_zj, rownum rn
          from (select zrs, vc_icd10 icd10_zrs, zrs_zj
                  from tab
                 where zrs > 0
                 order by zrs desc)
         where rownum <= 10) a,
       (select mrs, icd10_mrs, mrs_zj, rownum rn
          from (select mrs, vc_icd10 icd10_mrs, mrs_zj
                  from tab
                 where mrs > 0
                 order by mrs desc)
         where rownum <= 10) b,
       (select wrs, icd10_wrs, wrs_zj, rownum rn
          from (select wrs, vc_icd10 icd10_wrs, wrs_zj
                  from tab
                 where wrs > 0
                 order by wrs desc)
         where rownum <= 10) c
 where a.rn = b.rn(+)
   and a.rn = c.rn(+)
 order by a.rn                                                                                                                          