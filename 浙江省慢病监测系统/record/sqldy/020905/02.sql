select xzmc,
       ksrq,
       jsrq,
       cjsj_ymd,
       jgdm,
       jgmc,
       bgk_s,
       bgjss,
       bgjsl,
       sort
  from (
select r.xzmc,
       dts(r.ksrq, 0) ksrq,
       dts(r.jsrq, 0) jsrq,
       dts(r.cjsj, 0) cjsj_ymd,
       t.jgdm,
       t.jgmc,
       t.bgk_s,
       t.bgjss,
       trunc(t.bgjss / decode(t.bgk_s, 0, 1, t.bgk_s), 4) * 100 bgjsl,
       0 sort
  from zjjk_tjbb_syzkb1 t, zjjk_tjbb_syzkb_report r
 where t.id = r.id
   and t.id = #{id}
union all
select '' xzmc,
       '' ksrq,
       '' jsrq,
       '' cjsj_ymd,
       '' jgdm,
       '合计' jgmc,
       sum(t.bgk_s) bgk_s,
       sum(t.bgjss) bgjss,
       trunc(sum(t.bgjss) / decode(sum(t.bgk_s), 0, 1, sum(t.bgk_s)), 4) * 100 bgjsl,
       1 sort
  from zjjk_tjbb_syzkb1 t, zjjk_tjbb_syzkb_report r
 where t.id = r.id
   and t.id = #{id}
) order by sort, jgdm  