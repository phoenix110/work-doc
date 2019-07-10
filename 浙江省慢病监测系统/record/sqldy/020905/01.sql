select id, xzqh, xzmc,tjnd,type,decode(type,'1','质控表一','2','质控表二') as type_mc,dts(ksrq,0) ksrq, dts(jsrq,0) jsrq, dts(cjsj,0) cjsj, cjyh, cjjgdm, total, rn
  from (select id,
               xzqh,
               xzmc,
               tjnd,
               type,
               ksrq,
               jsrq,
               cjsj,
               cjyh,
               cjjgdm,
               total,
               rownum rn
          from (select id,
                       xzqh,
                       xzmc,
                       tjnd,
                       type,
                       ksrq,
                       jsrq,
                       cjsj,
                       cjyh,
                       cjjgdm,
                       count(1) over() total
                  from (select distinct id,
                                        xzqh,
                                        xzmc,
                                        tjnd,
                                        ksrq,
                                        jsrq,
                                        type,
                                        cjsj,
                                        cjyh,
                                        cjjgdm
                          from ZJJK_TJBB_SYZKB_REPORT
                         where xzqh like #{czyxzqh} || '%'
                         <if if(StringUtils.isNotBlank(#{xzqh}))>
                             and xzqh = #{xzqh}
                         </if>
                         <if if(StringUtils.isNotBlank(#{vc_tjnd}))>
                             and tjnd = #{vc_tjnd}
                         </if>
                         <if if(StringUtils.isNotBlank(#{bblx}))>
                             and type = #{bblx}
                         </if>
                         <if if(StringUtils.isNotBlank(#{dt_drsj_ks}))>
                           and ksrq >= std(#{dt_drsj_ks}, 1) and JSRQ <= std(#{dt_drsj_js}, 1)
                         </if>
                         order by cjsj desc))
         where rownum <= #{rn_e})
 where rn >= #{rn_s}
                