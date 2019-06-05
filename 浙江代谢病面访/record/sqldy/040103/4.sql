with tab as
 (select a.街道名称,
         b.肿瘤发现病例数,
         b.肿瘤复核数,
         b.肿瘤确诊数,
         b.肿瘤疑似数,
         b.肿瘤非病例数,
         c.脑卒中发现病例数,
         c.脑卒中复核数,
         c.脑卒中确诊数,
         c.脑卒中疑似数,
         c.脑卒中非病例数,
         d.心肌梗死发现病例数,
         d.心肌梗死复核数,
         d.心肌梗死确诊数,
         d.心肌梗死疑似数,
         d.心肌梗死非病例数,
         e.充血性心力衰竭发现病例数,
         e.充血性心力衰竭复核数,
         e.充血性心力衰竭确诊数,
         e.充血性心力衰竭疑似数,
         e.充血性心力衰竭非病例数,
         f.慢性肾病发现病例数,
         f.慢性肾病复核数,
         f.慢性肾病确诊数,
         f.慢性肾病疑似数,
         f.慢性肾病非病例数
    from (select a.mfrymc 街道名称, a.mfryid ryid
            from grjbxx a, dlmfxx c
           where a.id = c.grid
             and a.yljgid in (select id
                                from p_yljg jg
                               start with jg.id = #{czyjgid}
                              connect by jg.gljgid = prior jg.id)
             and a.mfzt is not null
             and a.xzqh_q = #{xzqh_q}
             and a.xzqh_x = #{xzqh_x}
             and a.mfryid is not null
             and a.mfzt = '2'
             <if if(StringUtils.isNotBlank(#{kssj}))>
               and c.gxsj >= std(#{kssj},1) 
             </if>
             <if if(StringUtils.isNotBlank(#{jssj}))>
               and c.gxsj <= std(#{jssj},1) 
             </if>
             <if if(1 == 1)>
           group by a.mfryid, a.mfrymc) a,
         (select count(1) 肿瘤发现病例数, 
                 sum(case when c.id is not null then 1 else 0 end) 肿瘤复核数,
                 sum(decode(a.sqfhshzt, '0', 1, 0)) 肿瘤确诊数,
                 sum(decode(a.sqfhshzt, '1', 1, 0)) 肿瘤疑似数,
                 sum(decode(a.sqfhshzt, '2', 1, 0)) 肿瘤非病例数,
                 a.mfryid
            from grjbxx a, dlmfxx b, sqfhxx c
           where a.id = b.grid
             and b.tumor = '1'
             and b.id = c.id(+)
             and c.fhzt(+) = '2'
             and a.yljgid in (select id
                                from p_yljg jg
                               start with jg.id = #{czyjgid}
                              connect by jg.gljgid = prior jg.id)
             and a.mfzt is not null
             and a.xzqh_q = #{xzqh_q}
             and a.xzqh_x = #{xzqh_x}
             and a.mfzt = '2'
             </if>
             <if if(StringUtils.isNotBlank(#{kssj}))>
               and b.gxsj >= std(#{kssj},1) 
             </if>
             <if if(StringUtils.isNotBlank(#{jssj}))>
               and b.gxsj <= std(#{jssj},1) 
             </if>
             <if if(1 == 1)>
           group by a.mfryid) b,
         (select count(1) 脑卒中发现病例数, 
                 sum(case when c.id is not null then 1 else 0 end) 脑卒中复核数,
                 sum(decode(a.sqfhshzt, '0', 1, 0)) 脑卒中确诊数,
                 sum(decode(a.sqfhshzt, '1', 1, 0)) 脑卒中疑似数,
                 sum(decode(a.sqfhshzt, '2', 1, 0)) 脑卒中非病例数,
                 a.mfryid
            from grjbxx a, dlmfxx b, sqfhxx c
           where a.id = b.grid
             and exists(select 1 from dlmfxx_nzz d where b.id = d.id and d.stroke = '1')
             and b.id = c.id(+)
             and c.fhzt(+) = '2'
             and a.yljgid in (select id
                                from p_yljg jg
                               start with jg.id = #{czyjgid}
                              connect by jg.gljgid = prior jg.id)
             and a.mfzt is not null
             and a.xzqh_q = #{xzqh_q}
             and a.xzqh_x = #{xzqh_x}
             and a.mfzt = '2'
             </if>
             <if if(StringUtils.isNotBlank(#{kssj}))>
               and b.gxsj >= std(#{kssj},1) 
             </if>
             <if if(StringUtils.isNotBlank(#{jssj}))>
               and b.gxsj <= std(#{jssj},1) 
             </if>
             <if if(1 == 1)>
           group by a.mfryid) c,
         (select count(1) 心肌梗死发现病例数, 
                 sum(case when c.id is not null then 1 else 0 end) 心肌梗死复核数,
                 sum(decode(a.sqfhshzt, '0', 1, 0)) 心肌梗死确诊数,
                 sum(decode(a.sqfhshzt, '1', 1, 0)) 心肌梗死疑似数,
                 sum(decode(a.sqfhshzt, '2', 1, 0)) 心肌梗死非病例数,
                 a.mfryid
            from grjbxx a, dlmfxx b, sqfhxx c
           where a.id = b.grid
             and exists(select 1 from dlmfxx_xjgs d where b.id = d.id and d.mi = '1')
             and b.id = c.id(+)
             and c.fhzt(+) = '2'
             and a.yljgid in (select id
                                from p_yljg jg
                               start with jg.id = #{czyjgid}
                              connect by jg.gljgid = prior jg.id)
             and a.mfzt is not null
             and a.xzqh_q = #{xzqh_q}
             and a.xzqh_x = #{xzqh_x}
             and a.mfzt = '2'
             </if>
             <if if(StringUtils.isNotBlank(#{kssj}))>
               and b.gxsj >= std(#{kssj},1) 
             </if>
             <if if(StringUtils.isNotBlank(#{jssj}))>
               and b.gxsj <= std(#{jssj},1) 
             </if>
             <if if(1 == 1)>
           group by a.mfryid) d,
         (select count(1) 充血性心力衰竭发现病例数, 
                 sum(case when c.id is not null then 1 else 0 end) 充血性心力衰竭复核数,
                 sum(decode(a.sqfhshzt, '0', 1, 0)) 充血性心力衰竭确诊数,
                 sum(decode(a.sqfhshzt, '1', 1, 0)) 充血性心力衰竭疑似数,
                 sum(decode(a.sqfhshzt, '2', 1, 0)) 充血性心力衰竭非病例数,
                 a.mfryid
            from grjbxx a, dlmfxx b, sqfhxx c
           where a.id = b.grid
             and exists(select 1 from dlmfxx_xsj d where b.id = d.id and d.hf = '1')
             and b.id = c.id(+)
             and c.fhzt(+) = '2'
             and a.yljgid in (select id
                                from p_yljg jg
                               start with jg.id = #{czyjgid}
                              connect by jg.gljgid = prior jg.id)
             and a.mfzt is not null
             and a.xzqh_q = #{xzqh_q}
             and a.xzqh_x = #{xzqh_x}
             and a.mfzt = '2'
             </if>
             <if if(StringUtils.isNotBlank(#{kssj}))>
               and b.gxsj >= std(#{kssj},1) 
             </if>
             <if if(StringUtils.isNotBlank(#{jssj}))>
               and b.gxsj <= std(#{jssj},1) 
             </if>
             <if if(1 == 1)>
           group by a.mfryid) e,
         (select count(1) 慢性肾病发现病例数, 
                 sum(case when c.id is not null then 1 else 0 end) 慢性肾病复核数,
                 sum(decode(a.sqfhshzt, '0', 1, 0)) 慢性肾病确诊数,
                 sum(decode(a.sqfhshzt, '1', 1, 0)) 慢性肾病疑似数,
                 sum(decode(a.sqfhshzt, '2', 1, 0)) 慢性肾病非病例数,
                 a.mfryid
            from grjbxx a, dlmfxx b, sqfhxx c
           where a.id = b.grid
             and b.kd = '1'
             and b.id = c.id(+)
             and c.fhzt(+) = '2'
             and a.yljgid in (select id
                                from p_yljg jg
                               start with jg.id = #{czyjgid}
                              connect by jg.gljgid = prior jg.id)
             and a.mfzt is not null
             and a.xzqh_q = #{xzqh_q}
             and a.xzqh_x = #{xzqh_x}
             and a.mfzt = '2'
             </if>
             <if if(StringUtils.isNotBlank(#{kssj}))>
               and b.gxsj >= std(#{kssj},1) 
             </if>
             <if if(StringUtils.isNotBlank(#{jssj}))>
               and b.gxsj <= std(#{jssj},1) 
             </if>
           group by a.mfryid) f
   where a.ryid = b.mfryid(+)
     and a.ryid = c.mfryid(+)
     and a.ryid = d.mfryid(+)
     and a.ryid = e.mfryid(+)
     and a.ryid = f.mfryid(+))
select 街道名称,
       肿瘤发现病例数,
       肿瘤复核数,
       肿瘤确诊数,
       肿瘤疑似数,
       肿瘤非病例数,
       脑卒中发现病例数,
       脑卒中复核数,
       脑卒中确诊数,
       脑卒中疑似数,
       脑卒中非病例数,
       心肌梗死发现病例数,
       心肌梗死复核数,
       心肌梗死确诊数,
       心肌梗死疑似数,
       心肌梗死非病例数,
       充血性心力衰竭发现病例数,
       充血性心力衰竭复核数,
       充血性心力衰竭确诊数,
       充血性心力衰竭疑似数,
       充血性心力衰竭非病例数,
       慢性肾病发现病例数,
       慢性肾病复核数,
       慢性肾病确诊数,
       慢性肾病疑似数,
       慢性肾病非病例数
  from tab
union all
select '合计',
       sum(肿瘤发现病例数) 肿瘤发现病例数,
       sum(肿瘤复核数) 肿瘤复核数,
       sum(肿瘤确诊数) 肿瘤确诊数,
       sum(肿瘤疑似数) 肿瘤疑似数,
       sum(肿瘤非病例数) 肿瘤非病例数,
       sum(脑卒中发现病例数) 脑卒中发现病例数,
       sum(脑卒中复核数) 脑卒中复核数,
       sum(脑卒中确诊数) 脑卒中确诊数,
       sum(脑卒中疑似数) 脑卒中疑似数,
       sum(脑卒中非病例数) 脑卒中非病例数,
       sum(心肌梗死发现病例数) 心肌梗死发现病例数,
       sum(心肌梗死复核数) 心肌梗死复核数,
       sum(心肌梗死确诊数) 心肌梗死确诊数,
       sum(心肌梗死疑似数) 心肌梗死疑似数,
       sum(心肌梗死非病例数) 心肌梗死非病例数,
       sum(充血性心力衰竭发现病例数) 充血性心力衰竭发现病例数,
       sum(充血性心力衰竭复核数) 充血性心力衰竭复核数,
       sum(充血性心力衰竭确诊数) 充血性心力衰竭确诊数,
       sum(充血性心力衰竭疑似数) 充血性心力衰竭疑似数,
       sum(充血性心力衰竭非病例数) 充血性心力衰竭非病例数,
       sum(慢性肾病发现病例数) 慢性肾病发现病例数,
       sum(慢性肾病复核数) 慢性肾病复核数,
       sum(慢性肾病确诊数) 慢性肾病确诊数,
       sum(慢性肾病疑似数) 慢性肾病疑似数,
       sum(慢性肾病非病例数) 慢性肾病非病例数
  from tab                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
