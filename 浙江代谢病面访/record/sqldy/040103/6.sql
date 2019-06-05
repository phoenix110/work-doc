with tab as
 (select a.街道名称,
         a.面访质控情况面访人数,
         a.面访质控情况质控人数,
         a.面访质控情况合格人数,
         a.面访质控情况质控人数 - a.面访质控情况合格人数 面访质控情况重访人数,
         b.面访质控情况疾病信息不一致人数,
         b1.肿瘤疾病信息不一致人数,
         b2.慢性肾病疾病信息不一致人数,
         b3.脑卒中疾病信息不一致人数,
         b4.心肌梗死疾病信息不一致人数,
         b5.充血性心力衰竭不一致人数,
         c.肿瘤面访人数,
         c.肿瘤质控人数,
         c.肿瘤合格人数,
         c.肿瘤质控人数 - c.肿瘤合格人数 肿瘤重访人数,
         c1.慢性肾病面访人数,
         c1.慢性肾病质控人数,
         c1.慢性肾病合格人数,
         c1.慢性肾病质控人数 - c1.慢性肾病合格人数 慢性肾病重访人数,
         c2.脑卒中面访人数,
         c2.脑卒中质控人数,
         c2.脑卒中合格人数,
         c2.脑卒中质控人数 - c2.脑卒中合格人数 脑卒中重访人数,
         c3.心肌梗死面访人数,
         c3.心肌梗死质控人数,
         c3.心肌梗死合格人数,
         c3.心肌梗死质控人数 - c3.心肌梗死合格人数 心肌梗死重访人数,
         c4.充血性心力衰竭面访人数,
         c4.充血性心力衰竭质控人数,
         c4.充血性心力衰竭合格人数,
         c4.充血性心力衰竭质控人数 - c4.充血性心力衰竭合格人数 充血性心力衰竭重访人数
    from (select count(1) 面访质控情况面访人数,
                 sum(case
                       when a.mfzkzt in ('1','2') then
                        1
                       else
                        0
                     end) 面访质控情况质控人数,
                 sum(decode(a.mfzkzt, '1', 1, 0)) 面访质控情况合格人数,
                 b.mc 街道名称,
                 a.xzqh_x
            from grjbxx a, p_xzdm b
           where a.xzqh_x = b.dm
             and a.yljgid in (select id
                                from p_yljg jg
                               start with jg.id = #{czyjgid}
                              connect by jg.gljgid = prior jg.id)
             and a.mfzt in ('2', '3')
             and a.xzqh_q = #{xzqh_q}
             <if if(StringUtils.isNotBlank(#{kssj}))>
               and a.mffprq >= std(#{kssj},1) 
             </if>
             <if if(StringUtils.isNotBlank(#{jssj}))>
               and a.mffprq <= std(#{jssj},1) 
             </if>
             <if if(1 == 1)>
           group by b.mc, a.xzqh_x) a,
         (select count(distinct id) 面访质控情况疾病信息不一致人数, xzqh_x
            from (select a.id, a.xzqh_x
                    from grjbxx a, dljbsxx b, dlmfxx c
                   where a.id = b.id(+)
                     and b.ex_zt(+) = '1'
                     and a.id = c.grid
                     and c.tumor = '1'
                     and (nvl(b.exing, '-999') <> nvl(c.exing, '-999') or
                         nvl(b.tudat1, trunc(sysdate)) <>
                         nvl(c.tudat1, trunc(sysdate)) or
                         nvl(b.tuhos1, '-999') <> nvl(c.tuhos1, '-999') or
                         nvl(',' || b.litu || ',' || b.pantu || ',' ||
                              b.stotu || ',' || b.colotu || ',' || b.bretu || ',' ||
                              b.gongtu || ',' || b.luantu || ',' || b.edotu || ',' ||
                              b.qlxtu || ',' || b.pangtu || ',' || b.kidtu || ',' ||
                              b.linbaxu || ',' || b.bxtu || ',' || b.lungtu || ',' ||
                              b.thyrtu || ',' || b.othertu || ',' ||
                              b.othertu1,
                              '-999') <>
                         nvl(',' || c.litu || ',' || c.pantu || ',' ||
                              c.stotu || ',' || c.colotu || ',' || c.bretu || ',' ||
                              c.gongtu || ',' || c.luantu || ',' || c.edotu || ',' ||
                              c.qlxtu || ',' || c.pangtu || ',' || c.kidtu || ',' ||
                              c.linbaxu || ',' || c.bxtu || ',' || c.lungtu || ',' ||
                              c.thyrtu || ',' || c.othertu || ',' ||
                              c.othertu1,
                              '-999') or
                         nvl(',' || b.tutreat1 || ',' || b.tutreat1 || ',' ||
                              b.tutreat3 || ',' || b.tutreat4 || ',' ||
                              b.tutreat5 || ',' || b.tutreat0 || ',' ||
                              b.tutreat9,
                              '-999') <> nvl(',' || c.tutreat1 || ',' ||
                                              c.tutreat2 || ',' || c.tutreat3 || ',' ||
                                              c.tutreat4 || ',' || c.tutreat5 || ',' ||
                                              c.tutreat0 || ',' || c.tutreat9,
                                              '-999') or
                         nvl(b.tuoper_hos1, '-999') <>
                         nvl(c.tuoper_hos1, '-999'))
                     and a.yljgid in
                         (select id
                            from p_yljg jg
                           start with jg.id = #{czyjgid}
                          connect by jg.gljgid = prior jg.id)
                     and a.mfzt in ('2', '3')
                     and a.xzqh_q = #{xzqh_q}
                     </if>
                     <if if(StringUtils.isNotBlank(#{kssj}))>
                         and a.mffprq >= std(#{kssj},1) 
                     </if>
                     <if if(StringUtils.isNotBlank(#{jssj}))>
                         and a.mffprq <= std(#{jssj},1) 
                     </if>
                     <if if(1 == 1)>
                  union all
                  select a.id, a.xzqh_x
                    from grjbxx a, dljbsxx b, dlmfxx c
                   where a.id = b.id(+)
                     and b.ex_zt(+) = '1'
                     and a.id = c.grid
                     and c.kd = '1'
                     and (nvl(b.kd_dat, trunc(sysdate)) <>
                         nvl(c.kd_dat, trunc(sysdate)) or
                         nvl(b.kd_zhu, '-999') <> nvl(c.kd_zhu, '-999') or
                         nvl(b.kd_hos, '-999') <> nvl(c.kd_hos, '-999') or
                         nvl(b.kdhos_id, '-999') <> nvl(c.kdhos_id, '-999') or
                         nvl(b.kdhos_dat, trunc(sysdate)) <>
                         nvl(c.kdhos_dat, trunc(sysdate)) or
                         nvl(b.kd_record, '-999') <> nvl(c.kd_record, '-999') or
                         nvl(b.kd_blood, '-999') <> nvl(c.kd_blood, '-999') or
                         nvl(b.kd_kd, '-999') <> nvl(c.kd_kd, '-999') or
                         nvl(',' || b.kd_crea || ',' || b.kd_crea1, '-999') <>
                         nvl(',' || c.kd_crea || ',' || c.kd_crea1, '-999') or
                         nvl(b.kd_gfr, '-999') <> nvl(c.kd_gfr, '-999'))
                     and a.yljgid in
                         (select id
                            from p_yljg jg
                           start with jg.id = #{czyjgid}
                          connect by jg.gljgid = prior jg.id)
                     and a.mfzt in ('2', '3')
                     and a.xzqh_q = #{xzqh_q}
                     </if>
                     <if if(StringUtils.isNotBlank(#{kssj}))>
                         and a.mffprq >= std(#{kssj},1) 
                     </if>
                     <if if(StringUtils.isNotBlank(#{jssj}))>
                         and a.mffprq <= std(#{jssj},1) 
                     </if>
                     <if if(1 == 1)>
                  union all
                  select distinct a.id, a.xzqh_x
                    from grjbxx a, dljbsxx b, dlmfxx c, dlmfxx_nzz d
                   where a.id = b.id(+)
                     and c.id = d.id
                     and d.stroke = '1'
                     and b.ex_zt(+) = '1'
                     and a.id = c.grid
                     and (nvl(d.stro_dat, trunc(sysdate)) <>
                         nvl(b.stro_dat, trunc(sysdate)) or
                         nvl(d.stro_zhu, '-999') <> nvl(b.stro_zhu, '-999') or
                         nvl(d.stro_hos, '-999') <> nvl(b.stro_hos, '-999') or
                         nvl(d.strohos_id, '-999') <>
                         nvl(b.strohos_id, '-999') or
                         nvl(d.strohos_dat, trunc(sysdate)) <>
                         nvl(b.strohos_dat, trunc(sysdate)) or
                         nvl(d.stro_record, '-999') <>
                         nvl(b.stro_record, '-999') or
                         nvl(',' || d.stro_ct || ',' || d.stro_ct1, '-999') <>
                         nvl(',' || b.stro_ct || ',' || b.stro_ct1, '-999') or
                         nvl(',' || d.stro_mr || ',' || d.stro_mr1, '-999') <>
                         nvl(',' || b.stro_mr || ',' || b.stro_mr1, '-999') or
                         nvl(',' || d.stro_nao || ',' || d.stro_nao1, '-999') <>
                         nvl(',' || b.stro_nao || ',' || b.stro_nao1, '-999') or
                         nvl(',' || d.stro_treat1 || ',' || d.stro_treat2 || ',' ||
                              d.stro_treat3 || ',' || d.stro_treat5 || ',' ||
                              d.stro_treat0 || ',' || d.stro_treat9,
                              '-999') <>
                         nvl(',' || b.stro_treat1 || ',' || b.stro_treat2 || ',' ||
                              b.stro_treat3 || ',' || b.stro_treat5 || ',' ||
                              b.stro_treat0 || ',' || b.stro_treat9,
                              '-999') or
                         nvl(',' || d.stro_diag1 || ',' || d.stro_diag2 || ',' ||
                              d.stro_diag3 || ',' || d.stro_diag4 || ',' ||
                              d.stro_diag5,
                              '-999') <>
                         nvl(',' || b.stro_diag1 || ',' || b.stro_diag2 || ',' ||
                              b.stro_diag3 || ',' || b.stro_diag4 || ',' ||
                              b.stro_diag5,
                              '-999'))
                     and a.yljgid in
                         (select id
                            from p_yljg jg
                           start with jg.id = #{czyjgid}
                          connect by jg.gljgid = prior jg.id)
                     and a.mfzt in ('2', '3')
                     and a.xzqh_q = #{xzqh_q}
                     </if>
                     <if if(StringUtils.isNotBlank(#{kssj}))>
                         and a.mffprq >= std(#{kssj},1) 
                     </if>
                     <if if(StringUtils.isNotBlank(#{jssj}))>
                         and a.mffprq <= std(#{jssj},1) 
                     </if>
                     <if if(1 == 1)>
                  union all
                  select distinct a.id, a.xzqh_x
                    from grjbxx a, dljbsxx b, dlmfxx c, dlmfxx_xjgs d
                   where a.id = b.id(+)
                     and c.id = d.id
                     and b.ex_zt(+) = '1'
                      and d.mi = '1'
                     and a.id = c.grid
                     and (nvl(d.mi_dat, trunc(sysdate)) <>
                         nvl(b.mi_dat, trunc(sysdate)) or
                         nvl(d.mi_zhu, '-999') <> nvl(b.mi_zhu, '-999') or
                         nvl(d.mi_hos, '-999') <> nvl(b.mi_hos, '-999') or
                         nvl(d.mihos_id, '-999') <> nvl(b.mihos_id, '-999') or
                         nvl(d.mihos_dat, trunc(sysdate)) <>
                         nvl(b.mihos_dat, trunc(sysdate)) or
                         nvl(d.mirecord, '-999') <> nvl(b.mirecord, '-999') or
                         nvl(',' || d.mi_ecg || ',' || d.mi_ecg1, '999') <>
                         nvl(',' || b.mi_ecg || ',' || b.mi_ecg1, '999') or
                         nvl(',' || d.mi_enzy || ',' || d.mi_enzy1, '999') <>
                         nvl(',' || b.mi_enzy || ',' || b.mi_enzy1, '999') or
                         nvl(',' || d.mi_ca || ',' || d.mi_ca1, '999') <>
                         nvl(',' || b.mi_ca || ',' || b.mi_ca1, '999') or
                         nvl(',' || d.mi_coro || ',' || d.mi_coro1, '999') <>
                         nvl(',' || b.mi_coro || ',' || b.mi_coro1, '999') or
                         nvl(',' || d.mitreat1 || ',' || d.mitreat2 || ',' ||
                              d.mitreat3 || ',' || d.mitreat4 || ',' ||
                              d.mitreat5 || ',' || d.mitreat0 || ',' ||
                              d.mitreat9,
                              '-999') <> nvl(',' || b.mitreat1 || ',' ||
                                              b.mitreat2 || ',' || b.mitreat3 || ',' ||
                                              b.mitreat4 || ',' || b.mitreat5 || ',' ||
                                              b.mitreat0 || ',' || b.mitreat9,
                                              '-999'))
                     and a.yljgid in
                         (select id
                            from p_yljg jg
                           start with jg.id = #{czyjgid}
                          connect by jg.gljgid = prior jg.id)
                     and a.mfzt in ('2', '3')
                     and a.xzqh_q = #{xzqh_q}
                     </if>
                     <if if(StringUtils.isNotBlank(#{kssj}))>
                         and a.mffprq >= std(#{kssj},1) 
                     </if>
                     <if if(StringUtils.isNotBlank(#{jssj}))>
                         and a.mffprq <= std(#{jssj},1) 
                     </if>
                     <if if(1 == 1)>
                  union all
                  select distinct a.id, a.xzqh_x
                    from grjbxx a, dljbsxx b, dlmfxx c, dlmfxx_xsj d
                   where a.id = b.id(+)
                     and c.id = d.id
                     and b.ex_zt(+) = '1'
                     and a.id = c.grid
                      and d.hf = '1'
                     and (nvl(d.hf_dat, trunc(sysdate)) <>
                         nvl(b.hf_dat, trunc(sysdate)) or
                         nvl(d.hf_zhu, '-999') <> nvl(b.hf_zhu, '-999') or
                         nvl(d.hf_hos, '-999') <> nvl(b.hf_hos, '-999') or
                         nvl(d.hfhos_id, '-999') <> nvl(b.hfhos_id, '-999') or
                         nvl(d.hfhos_dat, trunc(sysdate)) <>
                         nvl(b.hfhos_dat, trunc(sysdate)) or
                         nvl(d.hf_record, '-999') <> nvl(b.hf_record, '-999') or
                         nvl(d.hf_x, '-999') <> nvl(b.hf_x, '-999') or
                         nvl(d.hf_ultra, '-999') <> nvl(b.hf_ultra, '-999') or
                         nvl(d.hf_nuclei, '-999') <> nvl(b.hf_nuclei, '-999') or
                         nvl(d.hf_dao, '-999') <> nvl(b.hf_dao, '-999') or
                         nvl(',' || d.hf_treat1 || ',' || d.hf_treat2 || ',' ||
                              d.hf_treat3 || ',' || d.hf_treat4 || ',' ||
                              d.hf_treat0 || ',' || d.hf_treat9,
                              '-999') <>
                         nvl(',' || b.hf_treat1 || ',' || b.hf_treat2 || ',' ||
                              b.hf_treat3 || ',' || b.hf_treat4 || ',' ||
                              b.hf_treat0 || ',' || b.hf_treat9,
                              '-999'))
                     and a.yljgid in
                         (select id
                            from p_yljg jg
                           start with jg.id = #{czyjgid}
                          connect by jg.gljgid = prior jg.id)
                     and a.mfzt in ('2', '3')
                     and a.xzqh_q = #{xzqh_q}
                     </if>
                     <if if(StringUtils.isNotBlank(#{kssj}))>
                         and a.mffprq >= std(#{kssj},1) 
                     </if>
                     <if if(StringUtils.isNotBlank(#{jssj}))>
                         and a.mffprq <= std(#{jssj},1) 
                     </if>
                     <if if(1 == 1)>
                     )
           group by xzqh_x) b,
         
         (select count(distinct a.id) 肿瘤疾病信息不一致人数, a.xzqh_x
            from grjbxx a, dljbsxx b, dlmfxx c
           where a.id = b.id(+)
             and b.ex_zt(+) = '1'
             and a.id = c.grid
             and c.tumor = '1'
             and (nvl(b.exing, '-999') <> nvl(c.exing, '-999') or
                 nvl(b.tudat1, trunc(sysdate)) <>
                 nvl(c.tudat1, trunc(sysdate)) or
                 nvl(b.tuhos1, '-999') <> nvl(c.tuhos1, '-999') or
                 nvl(',' || b.litu || ',' || b.pantu || ',' || b.stotu || ',' ||
                      b.colotu || ',' || b.bretu || ',' || b.gongtu || ',' ||
                      b.luantu || ',' || b.edotu || ',' || b.qlxtu || ',' ||
                      b.pangtu || ',' || b.kidtu || ',' || b.linbaxu || ',' ||
                      b.bxtu || ',' || b.lungtu || ',' || b.thyrtu || ',' ||
                      b.othertu || ',' || b.othertu1,
                      '-999') <>
                 nvl(',' || c.litu || ',' || c.pantu || ',' || c.stotu || ',' ||
                      c.colotu || ',' || c.bretu || ',' || c.gongtu || ',' ||
                      c.luantu || ',' || c.edotu || ',' || c.qlxtu || ',' ||
                      c.pangtu || ',' || c.kidtu || ',' || c.linbaxu || ',' ||
                      c.bxtu || ',' || c.lungtu || ',' || c.thyrtu || ',' ||
                      c.othertu || ',' || c.othertu1,
                      '-999') or
                 nvl(',' || b.tutreat1 || ',' || b.tutreat1 || ',' ||
                      b.tutreat3 || ',' || b.tutreat4 || ',' || b.tutreat5 || ',' ||
                      b.tutreat0 || ',' || b.tutreat9,
                      '-999') <>
                 nvl(',' || c.tutreat1 || ',' || c.tutreat2 || ',' ||
                      c.tutreat3 || ',' || c.tutreat4 || ',' || c.tutreat5 || ',' ||
                      c.tutreat0 || ',' || c.tutreat9,
                      '-999') or
                 nvl(b.tuoper_hos1, '-999') <> nvl(c.tuoper_hos1, '-999'))
             and a.yljgid in (select id
                                from p_yljg jg
                               start with jg.id = #{czyjgid}
                              connect by jg.gljgid = prior jg.id)
             and a.mfzt in ('2', '3')
             and a.xzqh_q = #{xzqh_q}
             </if>
             <if if(StringUtils.isNotBlank(#{kssj}))>
                 and a.mffprq >= std(#{kssj},1) 
             </if>
             <if if(StringUtils.isNotBlank(#{jssj}))>
                 and a.mffprq <= std(#{jssj},1) 
             </if>
             <if if(1 == 1)>
           group by a.xzqh_x) b1,
         (select count(distinct a.id) 慢性肾病疾病信息不一致人数, a.xzqh_x
            from grjbxx a, dljbsxx b, dlmfxx c
           where a.id = b.id(+)
             and b.ex_zt(+) = '1'
             and a.id = c.grid
             and c.kd = '1'
             and (nvl(b.kd_dat, trunc(sysdate)) <>
                 nvl(c.kd_dat, trunc(sysdate)) or
                 nvl(b.kd_zhu, '-999') <> nvl(c.kd_zhu, '-999') or
                 nvl(b.kd_hos, '-999') <> nvl(c.kd_hos, '-999') or
                 nvl(b.kdhos_id, '-999') <> nvl(c.kdhos_id, '-999') or
                 nvl(b.kdhos_dat, trunc(sysdate)) <>
                 nvl(c.kdhos_dat, trunc(sysdate)) or
                 nvl(b.kd_record, '-999') <> nvl(c.kd_record, '-999') or
                 nvl(b.kd_blood, '-999') <> nvl(c.kd_blood, '-999') or
                 nvl(b.kd_kd, '-999') <> nvl(c.kd_kd, '-999') or
                 nvl(',' || b.kd_crea || ',' || b.kd_crea1, '-999') <>
                 nvl(',' || c.kd_crea || ',' || c.kd_crea1, '-999') or
                 nvl(b.kd_gfr, '-999') <> nvl(c.kd_gfr, '-999'))
             and a.yljgid in (select id
                                from p_yljg jg
                               start with jg.id = #{czyjgid}
                              connect by jg.gljgid = prior jg.id)
             and a.mfzt in ('2', '3')
             and a.xzqh_q = #{xzqh_q}
             </if>
             <if if(StringUtils.isNotBlank(#{kssj}))>
                 and a.mffprq >= std(#{kssj},1) 
             </if>
             <if if(StringUtils.isNotBlank(#{jssj}))>
                 and a.mffprq <= std(#{jssj},1) 
             </if>
             <if if(1 == 1)>
           group by a.xzqh_x) b2,
         (select count(distinct a.id) 脑卒中疾病信息不一致人数, a.xzqh_x
            from grjbxx a, dljbsxx b, dlmfxx c, dlmfxx_nzz d
           where a.id = b.id(+)
             and c.id = d.id
             and b.ex_zt(+) = '1'
             and d.stroke = '1'
             and a.id = c.grid
             and (nvl(d.stro_dat, trunc(sysdate)) <>
                 nvl(b.stro_dat, trunc(sysdate)) or
                 nvl(d.stro_zhu, '-999') <> nvl(b.stro_zhu, '-999') or
                 nvl(d.stro_hos, '-999') <> nvl(b.stro_hos, '-999') or
                 nvl(d.strohos_id, '-999') <> nvl(b.strohos_id, '-999') or
                 nvl(d.strohos_dat, trunc(sysdate)) <>
                 nvl(b.strohos_dat, trunc(sysdate)) or
                 nvl(d.stro_record, '-999') <> nvl(b.stro_record, '-999') or
                 nvl(',' || d.stro_ct || ',' || d.stro_ct1, '-999') <>
                 nvl(',' || b.stro_ct || ',' || b.stro_ct1, '-999') or
                 nvl(',' || d.stro_mr || ',' || d.stro_mr1, '-999') <>
                 nvl(',' || b.stro_mr || ',' || b.stro_mr1, '-999') or
                 nvl(',' || d.stro_nao || ',' || d.stro_nao1, '-999') <>
                 nvl(',' || b.stro_nao || ',' || b.stro_nao1, '-999') or
                 nvl(',' || d.stro_treat1 || ',' || d.stro_treat2 || ',' ||
                      d.stro_treat3 || ',' || d.stro_treat5 || ',' ||
                      d.stro_treat0 || ',' || d.stro_treat9,
                      '-999') <>
                 nvl(',' || b.stro_treat1 || ',' || b.stro_treat2 || ',' ||
                      b.stro_treat3 || ',' || b.stro_treat5 || ',' ||
                      b.stro_treat0 || ',' || b.stro_treat9,
                      '-999') or
                 nvl(',' || d.stro_diag1 || ',' || d.stro_diag2 || ',' ||
                      d.stro_diag3 || ',' || d.stro_diag4 || ',' ||
                      d.stro_diag5,
                      '-999') <> nvl(',' || b.stro_diag1 || ',' ||
                                      b.stro_diag2 || ',' || b.stro_diag3 || ',' ||
                                      b.stro_diag4 || ',' || b.stro_diag5,
                                      '-999'))
             and a.yljgid in (select id
                                from p_yljg jg
                               start with jg.id = #{czyjgid}
                              connect by jg.gljgid = prior jg.id)
             and a.mfzt in ('2', '3')
             and a.xzqh_q = #{xzqh_q}
             </if>
             <if if(StringUtils.isNotBlank(#{kssj}))>
                 and a.mffprq >= std(#{kssj},1) 
             </if>
             <if if(StringUtils.isNotBlank(#{jssj}))>
                 and a.mffprq <= std(#{jssj},1) 
             </if>
             <if if(1 == 1)>
           group by a.xzqh_x) b3,
         (select count(distinct a.id) 心肌梗死疾病信息不一致人数, a.xzqh_x
            from grjbxx a, dljbsxx b, dlmfxx c, dlmfxx_xjgs d
           where a.id = b.id(+)
             and c.id = d.id
             and b.ex_zt(+) = '1'
              and d.mi = '1'
             and a.id = c.grid
             and (nvl(d.mi_dat, trunc(sysdate)) <>
                 nvl(b.mi_dat, trunc(sysdate)) or
                 nvl(d.mi_zhu, '-999') <> nvl(b.mi_zhu, '-999') or
                 nvl(d.mi_hos, '-999') <> nvl(b.mi_hos, '-999') or
                 nvl(d.mihos_id, '-999') <> nvl(b.mihos_id, '-999') or
                 nvl(d.mihos_dat, trunc(sysdate)) <>
                 nvl(b.mihos_dat, trunc(sysdate)) or
                 nvl(d.mirecord, '-999') <> nvl(b.mirecord, '-999') or
                 nvl(',' || d.mi_ecg || ',' || d.mi_ecg1, '999') <>
                 nvl(',' || b.mi_ecg || ',' || b.mi_ecg1, '999') or
                 nvl(',' || d.mi_enzy || ',' || d.mi_enzy1, '999') <>
                 nvl(',' || b.mi_enzy || ',' || b.mi_enzy1, '999') or
                 nvl(',' || d.mi_ca || ',' || d.mi_ca1, '999') <>
                 nvl(',' || b.mi_ca || ',' || b.mi_ca1, '999') or
                 nvl(',' || d.mi_coro || ',' || d.mi_coro1, '999') <>
                 nvl(',' || b.mi_coro || ',' || b.mi_coro1, '999') or
                 nvl(',' || d.mitreat1 || ',' || d.mitreat2 || ',' ||
                      d.mitreat3 || ',' || d.mitreat4 || ',' || d.mitreat5 || ',' ||
                      d.mitreat0 || ',' || d.mitreat9,
                      '-999') <>
                 nvl(',' || b.mitreat1 || ',' || b.mitreat2 || ',' ||
                      b.mitreat3 || ',' || b.mitreat4 || ',' || b.mitreat5 || ',' ||
                      b.mitreat0 || ',' || b.mitreat9,
                      '-999'))
             and a.yljgid in (select id
                                from p_yljg jg
                               start with jg.id = #{czyjgid}
                              connect by jg.gljgid = prior jg.id)
             and a.mfzt in ('2', '3')
             and a.xzqh_q = #{xzqh_q}
             </if>
             <if if(StringUtils.isNotBlank(#{kssj}))>
                 and a.mffprq >= std(#{kssj},1) 
             </if>
             <if if(StringUtils.isNotBlank(#{jssj}))>
                 and a.mffprq <= std(#{jssj},1) 
             </if>
             <if if(1 == 1)>
           group by a.xzqh_x) b4,
         (select count(distinct a.id) 充血性心力衰竭不一致人数, a.xzqh_x
            from grjbxx a, dljbsxx b, dlmfxx c, dlmfxx_xsj d
           where a.id = b.id(+)
             and c.id = d.id
             and b.ex_zt(+) = '1'
              and d.hf = '1'
             and a.id = c.grid
             and (nvl(d.hf_dat, trunc(sysdate)) <>
                 nvl(b.hf_dat, trunc(sysdate)) or
                 nvl(d.hf_zhu, '-999') <> nvl(b.hf_zhu, '-999') or
                 nvl(d.hf_hos, '-999') <> nvl(b.hf_hos, '-999') or
                 nvl(d.hfhos_id, '-999') <> nvl(b.hfhos_id, '-999') or
                 nvl(d.hfhos_dat, trunc(sysdate)) <>
                 nvl(b.hfhos_dat, trunc(sysdate)) or
                 nvl(d.hf_record, '-999') <> nvl(b.hf_record, '-999') or
                 nvl(d.hf_x, '-999') <> nvl(b.hf_x, '-999') or
                 nvl(d.hf_ultra, '-999') <> nvl(b.hf_ultra, '-999') or
                 nvl(d.hf_nuclei, '-999') <> nvl(b.hf_nuclei, '-999') or
                 nvl(d.hf_dao, '-999') <> nvl(b.hf_dao, '-999') or
                 nvl(',' || d.hf_treat1 || ',' || d.hf_treat2 || ',' ||
                      d.hf_treat3 || ',' || d.hf_treat4 || ',' || d.hf_treat0 || ',' ||
                      d.hf_treat9,
                      '-999') <>
                 nvl(',' || b.hf_treat1 || ',' || b.hf_treat2 || ',' ||
                      b.hf_treat3 || ',' || b.hf_treat4 || ',' || b.hf_treat0 || ',' ||
                      b.hf_treat9,
                      '-999'))
             and a.yljgid in (select id
                                from p_yljg jg
                               start with jg.id = #{czyjgid}
                              connect by jg.gljgid = prior jg.id)
             and a.mfzt in ('2', '3')
             and a.xzqh_q = #{xzqh_q}
             </if>
             <if if(StringUtils.isNotBlank(#{kssj}))>
                 and a.mffprq >= std(#{kssj},1) 
             </if>
             <if if(StringUtils.isNotBlank(#{jssj}))>
                 and a.mffprq <= std(#{jssj},1) 
             </if>
             <if if(1 == 1)>
           group by a.xzqh_x) b5,
         (select count(1) 肿瘤面访人数,
                 sum(case
                       when a.mfzkzt in ('1','2') then
                        1
                       else
                        0
                     end) 肿瘤质控人数,
                 sum(decode(a.mfzkzt, '1', 1, 0)) 肿瘤合格人数,
                 a.xzqh_x
            from grjbxx a, dlmfxx b
           where a.id = b.grid
             and b.tumor = '1'
             and a.yljgid in (select id
                                from p_yljg jg
                               start with jg.id = #{czyjgid}
                              connect by jg.gljgid = prior jg.id)
             and a.mfzt in ('2', '3')
             and a.xzqh_q = #{xzqh_q}
             </if>
             <if if(StringUtils.isNotBlank(#{kssj}))>
                 and a.mffprq >= std(#{kssj},1) 
             </if>
             <if if(StringUtils.isNotBlank(#{jssj}))>
                 and a.mffprq <= std(#{jssj},1) 
             </if>
             <if if(1 == 1)>
           group by a.xzqh_x) c,
         (select count(1) 慢性肾病面访人数,
                 sum(case
                       when a.mfzkzt in ('1','2') then
                        1
                       else
                        0
                     end) 慢性肾病质控人数,
                 sum(decode(a.mfzkzt, '1', 1, 0)) 慢性肾病合格人数,
                 a.xzqh_x
            from grjbxx a, dlmfxx b
           where a.id = b.grid
             and b.kd = '1'
             and a.yljgid in (select id
                                from p_yljg jg
                               start with jg.id = #{czyjgid}
                              connect by jg.gljgid = prior jg.id)
             and a.mfzt in ('2', '3')
             and a.xzqh_q = #{xzqh_q}
             </if>
             <if if(StringUtils.isNotBlank(#{kssj}))>
                 and a.mffprq >= std(#{kssj},1) 
             </if>
             <if if(StringUtils.isNotBlank(#{jssj}))>
                 and a.mffprq <= std(#{jssj},1) 
             </if>
             <if if(1 == 1)>
           group by a.xzqh_x) c1,
         (select count(1) 脑卒中面访人数,
                 sum(case
                       when a.mfzkzt in ('1','2') then
                        1
                       else
                        0
                     end) 脑卒中质控人数,
                 sum(decode(a.mfzkzt, '1', 1, 0)) 脑卒中合格人数,
                 a.xzqh_x
            from grjbxx a, dlmfxx b
           where a.id = b.grid
             and exists
           (select 1 from dlmfxx_nzz d where b.id = d.id  and d.stroke = '1')
             and a.yljgid in (select id
                                from p_yljg jg
                               start with jg.id = #{czyjgid}
                              connect by jg.gljgid = prior jg.id)
             and a.mfzt in ('2', '3')
             and a.xzqh_q = #{xzqh_q}
             </if>
             <if if(StringUtils.isNotBlank(#{kssj}))>
                 and a.mffprq >= std(#{kssj},1) 
             </if>
             <if if(StringUtils.isNotBlank(#{jssj}))>
                 and a.mffprq <= std(#{jssj},1) 
             </if>
             <if if(1 == 1)>
           group by a.xzqh_x) c2,
         (select count(1) 心肌梗死面访人数,
                 sum(case
                       when a.mfzkzt in ('1','2') then
                        1
                       else
                        0
                     end) 心肌梗死质控人数,
                 sum(decode(a.mfzkzt, '1', 1, 0)) 心肌梗死合格人数,
                 a.xzqh_x
            from grjbxx a, dlmfxx b
           where a.id = b.grid
             and exists
           (select 1 from dlmfxx_xjgs d where b.id = d.id and d.mi = '1')
             and a.yljgid in (select id
                                from p_yljg jg
                               start with jg.id = #{czyjgid}
                              connect by jg.gljgid = prior jg.id)
             and a.mfzt in ('2', '3')
             and a.xzqh_q = #{xzqh_q}
             </if>
             <if if(StringUtils.isNotBlank(#{kssj}))>
                 and a.mffprq >= std(#{kssj},1) 
             </if>
             <if if(StringUtils.isNotBlank(#{jssj}))>
                 and a.mffprq <= std(#{jssj},1) 
             </if>
             <if if(1 == 1)>
           group by a.xzqh_x) c3,
         (select count(1) 充血性心力衰竭面访人数,
                 sum(case
                       when a.mfzkzt in ('1','2') then
                        1
                       else
                        0
                     end) 充血性心力衰竭质控人数,
                 sum(decode(a.mfzkzt, '1', 1, 0)) 充血性心力衰竭合格人数,
                 a.xzqh_x
            from grjbxx a, dlmfxx b
           where a.id = b.grid
             and exists
           (select 1 from dlmfxx_xsj d where b.id = d.id and d.hf = '1')
             and a.yljgid in (select id
                                from p_yljg jg
                               start with jg.id = #{czyjgid}
                              connect by jg.gljgid = prior jg.id)
             and a.mfzt in ('2', '3')
             and a.xzqh_q = #{xzqh_q}
             </if>
             <if if(StringUtils.isNotBlank(#{kssj}))>
                 and a.mffprq >= std(#{kssj},1) 
             </if>
             <if if(StringUtils.isNotBlank(#{jssj}))>
                 and a.mffprq <= std(#{jssj},1) 
             </if>
           group by a.xzqh_x) c4
   where a.xzqh_x = b.xzqh_x(+)
     and a.xzqh_x = b1.xzqh_x(+)
     and a.xzqh_x = b2.xzqh_x(+)
     and a.xzqh_x = b3.xzqh_x(+)
     and a.xzqh_x = b4.xzqh_x(+)
     and a.xzqh_x = b5.xzqh_x(+)
     and a.xzqh_x = c.xzqh_x(+)
     and a.xzqh_x = c1.xzqh_x(+)
     and a.xzqh_x = c2.xzqh_x(+)
     and a.xzqh_x = c3.xzqh_x(+)
     and a.xzqh_x = c4.xzqh_x(+))
select 街道名称,
       面访质控情况面访人数,
       面访质控情况疾病信息不一致人数,
       面访质控情况质控人数,
       面访质控情况合格人数,
       面访质控情况重访人数,
       round(面访质控情况合格人数 * 100 /
             decode(面访质控情况质控人数, 0, '', 面访质控情况质控人数),
             2) 面访质控情况质控合格率,
       肿瘤面访人数,
       肿瘤疾病信息不一致人数,
       肿瘤质控人数,
       肿瘤合格人数,
       肿瘤重访人数,
       round(肿瘤合格人数 * 100 / decode(肿瘤质控人数, 0, '', 肿瘤质控人数),
             2) 肿瘤质控合格率,
       脑卒中面访人数,
       脑卒中疾病信息不一致人数,
       脑卒中质控人数,
       脑卒中合格人数,
       脑卒中重访人数,
       round(脑卒中合格人数 * 100 / decode(脑卒中质控人数, 0, '', 脑卒中质控人数),
             2) 脑卒中质控合格率,
       心肌梗死面访人数,
       心肌梗死疾病信息不一致人数,
       心肌梗死质控人数,
       心肌梗死合格人数,
       心肌梗死重访人数,
       round(心肌梗死合格人数 * 100 /
             decode(心肌梗死质控人数, 0, '', 心肌梗死质控人数),
             2) 心肌梗死质控合格率,
       充血性心力衰竭面访人数,
       充血性心力衰竭不一致人数,
       充血性心力衰竭质控人数,
       充血性心力衰竭合格人数,
       充血性心力衰竭重访人数,
       round(充血性心力衰竭合格人数 * 100 /
             decode(充血性心力衰竭质控人数, 0, '', 充血性心力衰竭质控人数),
             2) 充血性心力衰竭质控合格率,
       慢性肾病面访人数,
       慢性肾病疾病信息不一致人数,
       慢性肾病质控人数,
       慢性肾病合格人数,
       慢性肾病重访人数,
       round(慢性肾病合格人数 * 100 /
             decode(慢性肾病质控人数, 0, '', 慢性肾病质控人数),
             2) 慢性肾病质控合格率
  from tab
union all
select '合计',
       sum(面访质控情况面访人数) 面访质控情况面访人数,
       sum(面访质控情况疾病信息不一致人数) 面访质控情况疾病信息不一致人数,
       sum(面访质控情况质控人数) 面访质控情况质控人数,
       sum(面访质控情况合格人数) 面访质控情况合格人数,
       sum(面访质控情况重访人数) 面访质控情况重访人数,
       round(sum(面访质控情况合格人数) * 100 /
             decode(sum(面访质控情况质控人数),
                    0,
                    '',
                    sum(面访质控情况质控人数)),
             2) 面访质控情况质控合格率,
       sum(肿瘤面访人数) 肿瘤面访人数,
       sum(肿瘤疾病信息不一致人数) 肿瘤疾病信息不一致人数,
       sum(肿瘤质控人数) 肿瘤质控人数,
       sum(肿瘤合格人数) 肿瘤合格人数,
       sum(肿瘤重访人数) 肿瘤重访人数,
       round(sum(肿瘤合格人数) * 100 /
             decode(sum(肿瘤质控人数), 0, '', sum(肿瘤质控人数)),
             2) 肿瘤质控合格率,
       sum(脑卒中面访人数) 脑卒中面访人数,
       sum(脑卒中疾病信息不一致人数) 脑卒中疾病信息不一致人数,
       sum(脑卒中质控人数) 脑卒中质控人数,
       sum(脑卒中合格人数) 脑卒中合格人数,
       sum(脑卒中重访人数) 脑卒中重访人数,
       round(sum(脑卒中合格人数) * 100 /
             decode(sum(脑卒中质控人数), 0, '', sum(脑卒中质控人数)),
             2) 脑卒中质控合格率,
       sum(心肌梗死面访人数) 心肌梗死面访人数,
       sum(心肌梗死疾病信息不一致人数) 心肌梗死疾病信息不一致人数,
       sum(心肌梗死质控人数) 心肌梗死质控人数,
       sum(心肌梗死合格人数) 心肌梗死合格人数,
       sum(心肌梗死重访人数) 心肌梗死重访人数,
       round(sum(心肌梗死合格人数) * 100 /
             decode(sum(心肌梗死质控人数), 0, '', sum(心肌梗死质控人数)),
             2) 心肌梗死质控合格率,
       sum(充血性心力衰竭面访人数) 充血性心力衰竭面访人数,
       sum(充血性心力衰竭不一致人数) 充血性心力衰竭不一致人数,
       sum(充血性心力衰竭质控人数) 充血性心力衰竭质控人数,
       sum(充血性心力衰竭合格人数) 充血性心力衰竭合格人数,
       sum(充血性心力衰竭重访人数) 充血性心力衰竭重访人数,
       round(sum(充血性心力衰竭合格人数) * 100 /
             decode(sum(充血性心力衰竭质控人数),
                    0,
                    '',
                    sum(充血性心力衰竭质控人数)),
             2) 充血性心力衰竭质控合格率,
       sum(慢性肾病面访人数) 慢性肾病面访人数,
       sum(慢性肾病疾病信息不一致人数) 慢性肾病疾病信息不一致人数,
       sum(慢性肾病质控人数) 慢性肾病质控人数,
       sum(慢性肾病合格人数) 慢性肾病合格人数,
       sum(慢性肾病重访人数) 慢性肾病重访人数,
       round(sum(慢性肾病合格人数) * 100 /
             decode(sum(慢性肾病质控人数), 0, '', sum(慢性肾病质控人数)),
             2) 慢性肾病质控合格率
  from tab                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
