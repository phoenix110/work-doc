with tab as
 (select a.医院名称,
         b.肿瘤应复核数,
         b.肿瘤实际完成数,
         b.肿瘤确诊数,
         b.肿瘤疑似数,
         b.肿瘤非病例数,
         c.脑卒中应复核数,
         c.脑卒中实际完成数,
         c.脑卒中确诊数,
         c.脑卒中疑似数,
         c.脑卒中非病例数, 
         d.心肌梗死应复核数,
         d.心肌梗死实际完成数,
         d.心肌梗死确诊数,
         d.心肌梗死疑似数,
         d.心肌梗死非病例数,
         e.充血性心力衰竭应复核数,
         e.充血性心力衰竭实际完成数,
         e.充血性心力衰竭确诊数,
         e.充血性心力衰竭疑似数,
         e.充血性心力衰竭非病例数,
         f.慢性肾病应复核数,
         f.慢性肾病实际完成数,
         f.慢性肾病确诊数,
         f.慢性肾病疑似数,
         f.慢性肾病非病例数
    from (select b.mc 医院名称, a.blfhyydm
            from grjbxx a, p_tyzdml b
           where a.blfhyydm = b.dm
             and b.fldm = 'C_YLJG'
             and a.yljgid in (select id
                                from p_yljg jg
                               start with jg.id = #{czyjgid}
                              connect by jg.gljgid = prior jg.id)
             and a.mfzt is not null
             and a.blfhryid is not null
             and a.xzqh_q = #{xzqh_q}
             <if if(StringUtils.isNotBlank(#{kssj}))>
               and a.fhfprq >= std(#{kssj},1) 
             </if>
             <if if(StringUtils.isNotBlank(#{jssj}))>
               and a.fhfprq <= std(#{jssj},1) 
             </if>
             <if if(1 == 1)>
           group by b.mc, a.blfhyydm) a,
         (select count(1) 肿瘤应复核数, 
                 sum(case when c.id is not null then 1 else 0 end) 肿瘤实际完成数,
                 sum(decode(a.sqfhshzt, '0', 1, 0)) 肿瘤确诊数,
                 sum(decode(a.sqfhshzt, '1', 1, 0)) 肿瘤疑似数,
                 sum(decode(a.sqfhshzt, '2', 1, 0)) 肿瘤非病例数,
                 a.blfhyydm
            from grjbxx a, dlmfxx b, blfhxx c
           where a.id = b.grid
             and b.tumor = '1'
             and b.id = c.id(+)
             and c.fhzt(+) = '2'
             and a.blfhryid is not null
             and a.yljgid in (select id
                                from p_yljg jg
                               start with jg.id = #{czyjgid}
                              connect by jg.gljgid = prior jg.id)
             and a.mfzt is not null
             and a.xzqh_q = #{xzqh_q}
             </if>
             <if if(StringUtils.isNotBlank(#{kssj}))>
               and a.fhfprq >= std(#{kssj},1) 
             </if>
             <if if(StringUtils.isNotBlank(#{jssj}))>
               and a.fhfprq <= std(#{jssj},1) 
             </if>
             <if if(1 == 1)>
           group by a.blfhyydm) b,
         (select count(1) 脑卒中应复核数, 
                 sum(case when c.id is not null then 1 else 0 end) 脑卒中实际完成数,
                 sum(decode(a.sqfhshzt, '0', 1, 0)) 脑卒中确诊数,
                 sum(decode(a.sqfhshzt, '1', 1, 0)) 脑卒中疑似数,
                 sum(decode(a.sqfhshzt, '2', 1, 0)) 脑卒中非病例数,
                 a.blfhyydm
            from grjbxx a, dlmfxx b, blfhxx c
           where a.id = b.grid
             and exists(select 1 from dlmfxx_nzz d where b.id = d.id and d.stroke = '1')
             and b.id = c.id(+)
             and c.fhzt(+) = '2'
             and a.blfhryid is not null
             and a.yljgid in (select id
                                from p_yljg jg
                               start with jg.id = #{czyjgid}
                              connect by jg.gljgid = prior jg.id)
             and a.mfzt is not null
             and a.xzqh_q = #{xzqh_q}
             </if>
             <if if(StringUtils.isNotBlank(#{kssj}))>
               and a.fhfprq >= std(#{kssj},1) 
             </if>
             <if if(StringUtils.isNotBlank(#{jssj}))>
               and a.fhfprq <= std(#{jssj},1) 
             </if>
             <if if(1 == 1)>
           group by a.blfhyydm) c,
        (select count(1) 心肌梗死应复核数, 
                 sum(case when c.id is not null then 1 else 0 end) 心肌梗死实际完成数,
                 sum(decode(a.sqfhshzt, '0', 1, 0)) 心肌梗死确诊数,
                 sum(decode(a.sqfhshzt, '1', 1, 0)) 心肌梗死疑似数,
                 sum(decode(a.sqfhshzt, '2', 1, 0)) 心肌梗死非病例数,
                 a.blfhyydm
            from grjbxx a, dlmfxx b, blfhxx c
           where a.id = b.grid
             and exists(select 1 from dlmfxx_xjgs d where b.id = d.id and d.mi = '1')
             and b.id = c.id(+)
             and c.fhzt(+) = '2'
             and a.blfhryid is not null
             and a.yljgid in (select id
                                from p_yljg jg
                               start with jg.id = #{czyjgid}
                              connect by jg.gljgid = prior jg.id)
             and a.mfzt is not null
             and a.xzqh_q = #{xzqh_q}
             </if>
             <if if(StringUtils.isNotBlank(#{kssj}))>
               and a.fhfprq >= std(#{kssj},1) 
             </if>
             <if if(StringUtils.isNotBlank(#{jssj}))>
               and a.fhfprq <= std(#{jssj},1) 
             </if>
             <if if(1 == 1)>
           group by a.blfhyydm) d,
        (select count(1) 充血性心力衰竭应复核数, 
                 sum(case when c.id is not null then 1 else 0 end) 充血性心力衰竭实际完成数,
                 sum(decode(a.sqfhshzt, '0', 1, 0)) 充血性心力衰竭确诊数,
                 sum(decode(a.sqfhshzt, '1', 1, 0)) 充血性心力衰竭疑似数,
                 sum(decode(a.sqfhshzt, '2', 1, 0)) 充血性心力衰竭非病例数,
                 a.blfhyydm
            from grjbxx a, dlmfxx b, blfhxx c
           where a.id = b.grid
             and exists(select 1 from dlmfxx_xsj d where b.id = d.id and d.hf = '1')
             and b.id = c.id(+)
             and c.fhzt(+) = '2'
             and a.blfhryid is not null
             and a.yljgid in (select id
                                from p_yljg jg
                               start with jg.id = #{czyjgid}
                              connect by jg.gljgid = prior jg.id)
             and a.mfzt is not null
             and a.xzqh_q = #{xzqh_q}
             </if>
             <if if(StringUtils.isNotBlank(#{kssj}))>
               and a.fhfprq >= std(#{kssj},1) 
             </if>
             <if if(StringUtils.isNotBlank(#{jssj}))>
               and a.fhfprq <= std(#{jssj},1) 
             </if>
             <if if(1 == 1)>
           group by a.blfhyydm) e,
        (select count(1) 慢性肾病应复核数, 
                 sum(case when c.id is not null then 1 else 0 end) 慢性肾病实际完成数,
                 sum(decode(a.sqfhshzt, '0', 1, 0)) 慢性肾病确诊数,
                 sum(decode(a.sqfhshzt, '1', 1, 0)) 慢性肾病疑似数,
                 sum(decode(a.sqfhshzt, '2', 1, 0)) 慢性肾病非病例数,
                 a.blfhyydm
            from grjbxx a, dlmfxx b, blfhxx c
           where a.id = b.grid
             and b.kd = '1'
             and b.id = c.id(+)
             and c.fhzt(+) = '2'
             and a.blfhryid is not null
             and a.yljgid in (select id
                                from p_yljg jg
                               start with jg.id = #{czyjgid}
                              connect by jg.gljgid = prior jg.id)
             and a.mfzt is not null
             and a.xzqh_q = #{xzqh_q}
             </if>
             <if if(StringUtils.isNotBlank(#{kssj}))>
               and a.fhfprq >= std(#{kssj},1) 
             </if>
             <if if(StringUtils.isNotBlank(#{jssj}))>
               and a.fhfprq <= std(#{jssj},1) 
             </if>
           group by a.blfhyydm) f
   where a.blfhyydm = b.blfhyydm(+)
     and a.blfhyydm = c.blfhyydm(+)
     and a.blfhyydm = d.blfhyydm(+)
     and a.blfhyydm = e.blfhyydm(+)
     and a.blfhyydm = f.blfhyydm(+)
     and (b.肿瘤应复核数 >0 or c.脑卒中应复核数 > 0 or d.心肌梗死应复核数 > 0 or e.充血性心力衰竭应复核数 > 0 or f.慢性肾病应复核数 > 0))
select   医院名称,
         肿瘤应复核数,
         肿瘤实际完成数,
         肿瘤确诊数,
         肿瘤疑似数,
         肿瘤非病例数,
         脑卒中应复核数,
         脑卒中实际完成数,
         脑卒中确诊数,
         脑卒中疑似数,
         脑卒中非病例数, 
         心肌梗死应复核数,
         心肌梗死实际完成数,
         心肌梗死确诊数,
         心肌梗死疑似数,
         心肌梗死非病例数,
         充血性心力衰竭应复核数,
         充血性心力衰竭实际完成数,
         充血性心力衰竭确诊数,
         充血性心力衰竭疑似数,
         充血性心力衰竭非病例数,
         慢性肾病应复核数,
         慢性肾病实际完成数,
         慢性肾病确诊数,
         慢性肾病疑似数,
         慢性肾病非病例数
  from tab
union all
select '合计' 医院名称,
        sum(肿瘤应复核数) 肿瘤应复核数,
        sum(肿瘤实际完成数) 肿瘤实际完成数,
        sum(肿瘤确诊数) 肿瘤确诊数,
        sum(肿瘤疑似数) 肿瘤疑似数,
        sum(肿瘤非病例数) 肿瘤非病例数,
        sum(脑卒中应复核数) 脑卒中应复核数,
        sum(脑卒中实际完成数) 脑卒中实际完成数,
        sum(脑卒中确诊数) 脑卒中确诊数,
        sum(脑卒中疑似数) 脑卒中疑似数,
        sum(脑卒中非病例数) 脑卒中非病例数, 
        sum(心肌梗死应复核数) 心肌梗死应复核数,
        sum(心肌梗死实际完成数) 心肌梗死实际完成数,
        sum(心肌梗死确诊数) 心肌梗死确诊数,
        sum(心肌梗死疑似数) 心肌梗死疑似数,
        sum(心肌梗死非病例数) 心肌梗死非病例数,
        sum(充血性心力衰竭应复核数) 充血性心力衰竭应复核数,
        sum(充血性心力衰竭实际完成数) 充血性心力衰竭实际完成数,
        sum(充血性心力衰竭确诊数) 充血性心力衰竭确诊数,
        sum(充血性心力衰竭疑似数) 充血性心力衰竭疑似数,
        sum(充血性心力衰竭非病例数) 充血性心力衰竭非病例数,
        sum(慢性肾病应复核数) 慢性肾病应复核数,
        sum(慢性肾病实际完成数) 慢性肾病实际完成数,
        sum(慢性肾病确诊数) 慢性肾病确诊数,
        sum(慢性肾病疑似数) 慢性肾病疑似数,
        sum(慢性肾病非病例数) 慢性肾病非病例数
  from tab                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
