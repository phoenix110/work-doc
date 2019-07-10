select dwdm,
       dwmc,
       bblx,
       bbqh,
       sjdwdm,
       sjdwdwmc,
       bks,
       bgjss,
       sfzhtbs,
       dsyltbs,
       cks,
       sybms,
       gbbmbzqs,
       bgjss_l,
       sfzhtbs_l,
       dsyltbs_l,
       cks_l,
       sybms_l,
       gbbmbzqs_l,
       cjsj,
       decode(bblx, 'Y', '年报', 'Q', '季报', 'M', '月报') bblx_text
  from (select dwdm,
               dwmc,
               bblx,
               bbqh,
               sjdwdm,
               sjdwdwmc,
               bks,
               bgjss,
               sfzhtbs,
               dsyltbs,
               cks,
               sybms,
               gbbmbzqs,
               trunc(bgjss / decode(bks, 0, 1, bks), 4) * 100 bgjss_l,
               trunc(sfzhtbs / decode(bks, 0, 1, bks), 4) * 100 sfzhtbs_l,
               trunc(dsyltbs / decode(bks, 0, 1, bks), 4) * 100 dsyltbs_l,
               trunc(cks / decode(bks, 0, 1, bks), 4) * 100 cks_l,
               trunc(sybms / decode(bks, 0, 1, bks), 4) * 100 sybms_l,
               trunc(gbbmbzqs / decode(bks, 0, 1, bks), 4) * 100 gbbmbzqs_l,
               0 sort,
               dts(cjsj, 0) cjsj
          from zjjk_tjbb_sw_syzk_bgdq
         where id = #{id}
        union all
        select '' dwdm,
               '合计' dwmc,
               max(bblx) bblx,
               max(bbqh) bbqh,
               max(sjdwdm) sjdwdm,
               max(sjdwdwmc) sjdwdwmc,
               sum(bks),
               sum(bgjss),
               sum(sfzhtbs),
               sum(dsyltbs),
               sum(cks),
               sum(sybms),
               sum(gbbmbzqs),
               trunc(sum(bgjss) / decode(sum(bks), 0, 1, sum(bks)), 4) * 100 bgjss_l,
               trunc(sum(sfzhtbs) / decode(sum(bks), 0, 1, sum(bks)), 4) * 100 sfzhtbs_l,
               trunc(sum(dsyltbs) / decode(sum(bks), 0, 1, sum(bks)), 4) * 100 dsyltbs_l,
               trunc(sum(cks) / decode(sum(bks), 0, 1, sum(bks)), 4) * 100 cks_l,
               trunc(sum(sybms) / decode(sum(bks), 0, 1, sum(bks)), 4) * 100 sybms_l,
               trunc(sum(gbbmbzqs) / decode(sum(bks), 0, 1, sum(bks)), 4) * 100 gbbmbzqs_l,
               1 sort,
               dts(max(cjsj), 0) cjsj
          from zjjk_tjbb_sw_syzk_bgdq
         where id = #{id})
 order by sort, dwdm        