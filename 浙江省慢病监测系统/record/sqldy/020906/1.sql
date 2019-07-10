with tab as
 (select dm, mc qymc, hj, jts, dszl, dqs, cgs, dws, sts, zxns, xqf, qt, bx
    from (select dm, mc from p_xzdm where sjid = #{vc_hks}) a,
         (select substr(vc_cjdwdm, 1, 6) qydm,
                 count(1) hj,
                 sum(decode(t.vc_shyy, 'A', 1, 0)) jts,
                 sum(decode(t.vc_shyy, 'C', 1, 0)) dszl,
                 sum(decode(t.vc_shyy, 'D', 1, 0)) dqs,
                 sum(decode(t.vc_shyy, 'E', 1, 0)) cgs,
                 sum(decode(t.vc_shyy, 'F', 1, 0)) dws,
                 sum(decode(t.vc_shyy, 'G', 1, 0)) sts,
                 sum(decode(t.vc_shyy, 'H', 1, 0)) zxns,
                 sum(decode(t.vc_shyy, 'B', 1, 0)) xqf,
                 sum(decode(t.vc_shyy, 'J', 1, 0)) qt,
                 sum(decode(t.vc_shyy, 'K', 1, 0)) bx
            from zjmb_shjc_bgk t
           where t.vc_scbz = '0'
             and t.vc_shbz in ('3', '5', '6', '7', '8')
             and t.vc_bgkzt = '0'
             and t.vc_cjdwdm like substr(#{vc_hks}, 1, 4)||'%'
             <if if(StringUtils.isNotBlank(#{dt_jzsj_ks}))>
               and t.dt_jzrq >= std(#{dt_jzsj_ks},1)
             </if>
             <if if(StringUtils.isNotBlank(#{dt_jzsj_js}))>
               and t.dt_jzrq <= std(#{dt_jzsj_js},1)
             </if>
             <if if(StringUtils.isNotBlank(#{dt_lrsj_ks}))>
               and t.dt_cjsj >= std(#{dt_lrsj_ks},1)
             </if>
             <if if(StringUtils.isNotBlank(#{dt_lrsj_js}))>
               and t.dt_cjsj <= std(#{dt_lrsj_js},1)
             </if>
             <if if(StringUtils.isNotBlank(#{xb}))>
               and t.vc_xb = #{xb}
             </if>
           group by substr(vc_cjdwdm, 1, 6)) b
   where substr(a.dm, 1, 6) = b.qydm(+))
select qymc, hj, jts, dszl, dqs, cgs, dws, sts, zxns, xqf, qt, bx
  from (select dm,
               qymc,
               hj,
               jts,
               dszl,
               dqs,
               cgs,
               dws,
               sts,
               zxns,
               xqf,
               qt,
               bx,
               0 sort
          from tab
        union
        select '',
               '合计',
               sum(hj),
               sum(jts),
               sum(dszl),
               sum(dqs),
               sum(cgs),
               sum(dws),
               sum(sts),
               sum(zxns),
               sum(xqf),
               sum(qt),
               sum(bx),
               1 sort
          from tab)
 order by sort, dm    