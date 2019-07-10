select sjdwdm, sjdwdwmc, id, decode(sjlx, '1', '录入日期', '死亡日期') sjlx_text, sjlx, dqlx, cjjgdm, cjsj, total, rn, decode(#{bblx}, 'Y', '年报', 'Q', '季报', 'M', '月报') bblx_text, #{bbqh} bbqh, '户籍地区' tjfs
  from (select sjdwdm, sjdwdwmc, id,sjlx, dqlx, cjjgdm, cjsj, total, rownum rn
          from (select sjdwdm,
                       sjdwdwmc,
                       id,
                       sjlx,
                       dqlx,
                       cjjgdm,
                       cjsj,
                       count(1) over() total
                  from (select a.sjdwdm,
                               a.sjdwdwmc,
                               a.id,
                               max(sjlx) sjlx,
                               max(a.dqlx) dqlx,
                               max(cjjgdm) cjjgdm,
                               dts(max(cjsj), 1) cjsj
                          from zjjk_tjbb_sw_syzk_hjdq a
                         where a.bblx = #{bblx}
                           and a.bbqh = #{bbqh}
                           and a.sjdwdm = #{sjdwdm}
                         group by a.sjdwdm, a.sjdwdwmc, a.id
                         order by cjsj desc))
         where rownum <= #{rn_e})
 where rn >= #{rn_s}                                                        