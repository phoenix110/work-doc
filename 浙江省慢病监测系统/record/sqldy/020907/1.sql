select id, xzqh, xzmc, dts(ksrq,0) ksrq, dts(jsrq,0) jsrq, cjsj, cjyh, cjjgdm, total, rn, mbzl, decode(mbzl, 'tnb', '糖尿病', 'zl', '肿瘤', 'xn', '心脑') mbmc
  from (select id,
               xzqh,
               xzmc,
               ksrq,
               jsrq,
               mbzl,
               cjsj,
               cjyh,
               cjjgdm,
               total,
               rownum rn
          from (select id,
                       xzqh,
                       xzmc,
                       ksrq,
                       jsrq,
                       mbzl,
                       cjsj,
                       cjyh,
                       cjjgdm,
                       count(1) over() total
                  from (select distinct id,
                                        xzqh,
                                        xzmc,
                                        ksrq,
                                        jsrq,
                                        mbzl,
                                        cjsj,
                                        cjyh,
                                        cjjgdm
                          from zjjk_tjbb_nlxbbgfbl
                         where xzqh like #{czyxzqh} || '%'
                         <if if(StringUtils.isNotBlank(#{xzqh}))>
                         and xzqh = #{xzqh}
                         </if>
                          <if if(StringUtils.isNotBlank(#{mbzl}))>
                          and mbzl = #{mbzl}
                         </if>
                         <if if(StringUtils.isNotBlank(#{dt_drsj_ks}))>
                         and ksrq <= std(#{dt_drsj_ks}, 1) and jsrq >= std(#{dt_drsj_ks}, 1)
                         </if>
                         order by cjsj desc))
         where rownum <= #{rn_e})
 where rn >= #{rn_s}                     