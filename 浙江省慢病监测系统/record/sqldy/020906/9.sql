with tab as
 (select dm, qymc, bks, bgjss, shjss, zzqss, cks
    from (select jgdm dm, jgmc qymc from p_yljg_jgsx where jgsx = 'sjshjc') a,
         (select vc_cjdwdm qydm,
                 count(1) as bks,
                 sum(case
                       when dt_cjsj - dt_jzrq <= 7 then
                        1
                       else
                        0
                     end) as bgjss,
                 sum(case
                       when dt_shsj - dt_cjsj <= 7 then
                        1
                       else
                        0
                     end) as shjss,
                 sum(case
                       when vc_sjzy is null then
                        1
                       else
                        0
                     end) as zzqss
            from zjmb_shjc_bgk t, p_yljg_jgsx t1
           where t.vc_scbz = '0'
             and t.vc_shbz in ('3', '5', '6', '7', '8')
             and t.vc_bgkzt = '0'
             and t.vc_cjdwdm = t1.jgdm
             and t1.jgsx = 'sjshjc'
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
             <if if(1 == 1)>
           group by vc_cjdwdm) b,
         (select count(distinct t1.vc_bgkid) cks,
                 t1.vc_cjdwdm qydm
            from zjmb_shjc_bgk t1, zjmb_shjc_bgk t2, p_yljg_jgsx t3
           where t1.vc_bgkid <> t2.vc_bgkid
             and (t1.vc_xm = t2.vc_xm and t1.vc_xb = t2.vc_xb and
                 t1.vc_nl = t2.vc_nl and t1.dt_shrq = t2.dt_shrq and
                 t1.vc_shyy = t2.vc_shyy)
             and t1.vc_scbz = '0'
             and t1.vc_shbz in ('3', '5', '6', '7', '8')
             and t1.vc_bgkzt = '0'
             and t2.vc_scbz = '0'
             and t2.vc_shbz in ('3', '5', '6', '7', '8')
             and t2.vc_bgkzt = '0'
             and t1.vc_cjdwdm = t2.vc_cjdwdm
             and t1.vc_cjdwdm = t3.jgdm
             and t3.jgsx = 'sjshjc'
             </if>
             <if if(StringUtils.isNotBlank(#{dt_jzsj_ks}))>
               and t1.dt_jzrq >= std(#{dt_jzsj_ks},1)
             </if>
             <if if(StringUtils.isNotBlank(#{dt_jzsj_js}))>
               and t1.dt_jzrq <= std(#{dt_jzsj_js},1)
               and t2.dt_jzrq <= std(#{dt_jzsj_js},1)
             </if>
             <if if(StringUtils.isNotBlank(#{dt_lrsj_ks}))>
               and t1.dt_cjsj >= std(#{dt_lrsj_ks},1)
             </if>
             <if if(StringUtils.isNotBlank(#{dt_lrsj_js}))>
               and t1.dt_cjsj <= std(#{dt_lrsj_js},1)
               and t2.dt_cjsj <= std(#{dt_lrsj_js},1)
             </if>
             <if if(StringUtils.isNotBlank(#{xb}))>
               and t1.vc_xb = #{xb}
               and t2.vc_xb = #{xb}
             </if>
             group by t1.vc_cjdwdm
             ) c
   where a.dm = b.qydm(+)
     and a.dm = c.qydm(+))
select qymc, bks, bgjss, shjss, zzqss, cks
  from (select dm,
               qymc,
               bks, 
               bgjss, 
               100 * bgjss/decode(bks, 0, null, bks) bgjss_l,
               shjss, 
               100 * shjss/decode(bks, 0, null, bks) shjss_l,
               zzqss, 
               100 * zzqss/decode(bks, 0, null, bks) zzqss_l,
               cks,
               0 sort
          from tab
        union
        select '',
               '合计',
               sum(bks), 
               sum(bgjss), 
               100 * sum(bgjss)/decode(sum(bks), 0, null, sum(bks)),
               sum(shjss), 
               100 * sum(shjss)/decode(sum(bks), 0, null, sum(bks)),
               sum(zzqss), 
               100 * sum(zzqss)/decode(sum(bks), 0, null, sum(bks)),
               sum(cks),
               1 sort
          from tab)
 order by sort, dm        