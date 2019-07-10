select id,
       dqdm,
       dqmc,
       tjnd,
       cjyh,
       cjjg,
       dts(cjsj, 1) cjsj,
       decode(xb, '1', '男', '2', '女', '合计') xb,
       total,
       rn
  from (select id, dqdm, dqmc, tjnd, cjyh, cjjg, cjsj, xb, total, rownum rn
          from (select id, dqdm, dqmc, tjnd, cjyh, cjjg, cjsj, xb, count(1) over() total
                  from (select a.id,
                               a.dqdm,
                               a.dqmc,
                               a.tjnd,
                               max(a.cjyh) cjyh,
                               max(a.cjjg) cjjg,
                               max(a.cjsj) cjsj,
                               a.xb
                          from TJBB_SW_QWSM a
                         where a.dqdm = #{dqdm}
                           and a.tjnd = #{tjnd}
                         <if if(StringUtils.isNotBlank(#{xb}))>
                           and a.xb = #{xb}
                         </if>
                         group by a.id, a.dqdm, a.dqmc, a.tjnd, a.xb))
         where rownum <= #{rn_e})
 where rn >= #{rn_s}    