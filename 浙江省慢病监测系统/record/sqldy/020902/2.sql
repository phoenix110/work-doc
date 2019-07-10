with tab as
 (select t1.vc_hksdm xzdm,
         sum(case
               when t.dt_swrq between std(#{dt_kssj}, 1) and std(#{dt_jssj}, 1) then
                1
               else
                0
             end) dnsws,
         count(1) dnfbs,
         sum(case
               when instr(t.vc_zdyh, '5') > 0 or instr(t.vc_zdyh, '6') > 0 or
                    instr(t.vc_zdyh, '7') > 0 or instr(t.vc_zdyh, '8') > 0 then
                1
               else
                0
             end) mv,
         sum(case
               when instr(t.vc_icd10, 'C48') > 0 or instr(t.vc_icd10, 'C97') > 0 then
                1
               else
                0
             end) bwbm,
         sum(case
               when vc_zdyh = '10' then
                1
               else
                0
             end) dco
    from zjjk_zl_bgk t, zjjk_zl_hzxx t1
   where t.vc_hzid = t1.vc_personid
     and t.vc_scbz = '0'
     and t.vc_shbz in ('3', '5', '6', '7', '8')
     and t.vc_bgkzt in ('0', '2', '6', '7')
     and t.dt_sczdrq between std(#{dt_kssj}, 1) and std(#{dt_jssj}, 1)
   group by t1.vc_hksdm)
select dm,
       mc,
       dnsws,
       dnfbs,
       mv,
       bwbm,
       dco,
       死亡发病比,
       mv百分比,
       部位不明百分比,
       dco卡百分比
  from (select a.dm,
               a.mc,
               b.dnsws,
               b.dnfbs,
               round(100 * b.dnsws / decode(b.dnfbs, 0, null, b.dnfbs), 2) 死亡发病比,
               b.mv,
               round(100 * b.mv / decode(b.dnfbs, 0, null, b.dnfbs), 2) mv百分比,
               b.bwbm,
               round(100 * b.bwbm / decode(b.dnfbs, 0, null, b.dnfbs), 2) 部位不明百分比,
               b.dco,
               round(100 * b.dco / decode(b.dnfbs, 0, null, b.dnfbs), 2) DCO卡百分比,
               0 sort
          from tab b, p_xzdm a
         where b.xzdm(+) = a.dm
           and a.sjid = '33000000'
        union all
        select '合计',
               '合计',
               sum(dnsws),
               sum(dnfbs),
               round(100 * sum(dnsws) /
                     decode(sum(dnfbs), 0, null, sum(dnfbs)),
                     2) 死亡发病比,
               sum(mv),
               round(100 * sum(mv) / decode(sum(dnfbs), 0, null, sum(dnfbs)),
                     2) mv百分比,
               sum(bwbm),
               round(100 * sum(bwbm) /
                     decode(sum(dnfbs), 0, null, sum(dnfbs)),
                     2) 部位不明百分比,
               sum(dco),
               round(100 * sum(dco) /
                     decode(sum(dnfbs), 0, null, sum(dnfbs)),
                     2) DCO卡百分比,
               1 sort
          from tab)
 order by sort, dm                                                             