select dwdm,
       dwmc,
       bblx,
       bbqh,
       sjdwdm,
       sjdwdwmc,
       bks,
       
       sfzhtbs,
       dsyltbs,
       cks,
       sybms,
       gbbmbzqs,
       gsnbgsw_l,
       shjss_l,       
       sfzhtbs_l,
       dsyltbs_l,
       cks_l,
       sybms_l,
       gbbmbzqs_l,
       cfwc_l,
       cfjs_l,
       cjsj,
       decode(bblx, 'Y', '年报', 'Q', '季报', 'M', '月报') bblx_text
  from (select dwdm,
               dwmc,
               bblx,
               bbqh,
               sjdwdm,
               sjdwdwmc,
               bks,
              
               sfzhtbs,
               dsyltbs,
               cks,
               sybms,
               gbbmbzqs,
               (case bblx 
                 when 'Y' then trunc(bks / decode(hjrs, 0, 1, hjrs),5) * 1000
                 when 'Q' then trunc(bks * 4 /decode(hjrs, 0, 1, hjrs),5) * 1000 
                 else  trunc(bks * 12 /decode(hjrs, 0, 1, hjrs),5) * 1000 
                end ) gsnbgsw_l,
               trunc(shjss / decode(bks, 0, 1, bks), 4) * 100 shjss_l,     
               trunc(sfzhtbs / decode(bks, 0, 1, bks), 4) * 100 sfzhtbs_l,
               trunc(dsyltbs / decode(bks, 0, 1, bks), 4) * 100 dsyltbs_l,
               trunc(cks / decode(bks, 0, 1, bks), 4) * 100 cks_l,
               trunc(sybms / decode(bks, 0, 1, bks), 4) * 100 sybms_l,
               trunc(gbbmbzqs / decode(bks, 0, 1, bks), 4) * 100 gbbmbzqs_l,
               trunc(cfwcs / decode(bks, 0, 1, bks), 4) * 100 cfwc_l,
               trunc(cfjss / decode(cfwcs, 0, 1, cfwcs), 4) * 100 cfjs_l,
               0 sort,
               dts(cjsj, 0) cjsj
          from zjjk_tjbb_sw_syzk_hjdq
         where id = #{id}
        union all
        select '' dwdm,
               '合计' dwmc,
               max(bblx) bblx,
               max(bbqh) bbqh,
               max(sjdwdm) sjdwdm,
               max(sjdwdwmc) sjdwdwmc,
               sum(bks),
               
               sum(sfzhtbs),
               sum(dsyltbs),
               sum(cks),
               sum(sybms),
               sum(gbbmbzqs),
               (case max(bblx) 
                 when 'Y' then trunc(sum(bks) / decode(sum(hjrs), 0, 1, sum(hjrs)),5) * 1000
                 when 'Q' then trunc(sum(bks) * 4 /decode(sum(hjrs), 0, 1, sum(hjrs)),5) * 1000 
                 else  trunc(sum(bks) * 12 /decode(sum(hjrs), 0, 1, sum(hjrs)),5) * 1000 
                end ) gsnbgsw_l,
               trunc(sum(shjss) / decode(sum(bks), 0, 1, sum(bks)), 4) * 100 shjss_l,               
               trunc(sum(sfzhtbs) / decode(sum(bks), 0, 1, sum(bks)), 4) * 100 sfzhtbs_l,
               trunc(sum(dsyltbs) / decode(sum(bks), 0, 1, sum(bks)), 4) * 100 dsyltbs_l,
               trunc(sum(cks) / decode(sum(bks), 0, 1, sum(bks)), 4) * 100 cks_l,
               trunc(sum(sybms) / decode(sum(bks), 0, 1, sum(bks)), 4) * 100 sybms_l,
               trunc(sum(gbbmbzqs) / decode(sum(bks), 0, 1, sum(bks)), 4) * 100 gbbmbzqs_l,
               trunc(sum(cfwcs) / decode(sum(bks), 0, 1, sum(bks)), 4) * 100 cfwc_l,
               trunc(sum(cfjss) / decode(sum(cfwcs), 0, 1, sum(cfwcs)), 4) * 100 cfjs_l,
               1 sort,
               dts(max(cjsj), 0) cjsj
          from zjjk_tjbb_sw_syzk_hjdq
         where id = #{id})
 order by sort, dwdm                                        