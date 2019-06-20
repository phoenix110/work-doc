with tab as
 (select a.应调查人数,
         a.街道名称,
         a.面访完成数,
         a.面访率,
         b.存活数,
         b.死亡数,
         b.失访数,
         b.发现糖尿病,
         b.发现肿瘤,
         b1.发现脑卒中,
         b2.发现心肌梗死,
         b3.发现充血性心力衰竭,
         b.发现慢性肾病,
         (nvl(b.发现糖尿病,0) + nvl(b.发现肿瘤,0) + nvl(b1.发现脑卒中,0) + nvl(b2.发现心肌梗死,0) +nvl( b3.发现充血性心力衰竭,0) + nvl(b.发现慢性肾病,0)) 发现小计,
         b.复核肿瘤,
         b1.复核脑卒中,
         b2.复核心肌梗死,
         b3.复核充血性心力衰竭,
         b.复核慢性肾病,
         (nvl(b.复核肿瘤,0) + nvl(b1.复核脑卒中,0) + nvl(b2.复核心肌梗死,0) + nvl(b3.复核充血性心力衰竭,0) + nvl(b.复核慢性肾病,0)) 复核小计
    from (select count(1) 应调查人数,
                 b.mc 街道名称,
                 a.xzqh_x,
                 sum(decode(a.mfzt, '2', 1, 0)) 面访完成数,
                 round(sum(decode(a.mfzt, '2', 1, 0)) * 100 / count(1), 2) 面访率
            from grjbxx a, p_xzdm b
           where a.xzqh_x = b.dm
             and a.yljgid in (select id
                                from p_yljg jg
                               start with jg.id = #{czyjgid}
                              connect by jg.gljgid = prior jg.id)
             and a.mfzt is not null
             <if if(StringUtils.isNotBlank(#{kssj}))>
               and a.mffprq >= std(#{kssj},1) 
             </if>
             <if if(StringUtils.isNotBlank(#{jssj}))>
               and a.mffprq <= std(#{jssj},1) 
             </if>
             <if if(1 == 1)>
             and a.xzqh_q = #{xzqh_q}
           group by b.mc, a.xzqh_x) a,
         (select sum(decode(b.sczt, '1', 1, 0)) 存活数,
                 sum(decode(b.sczt, '2', 1, 0)) 死亡数,
                 sum(decode(b.sczt, '3', 1, 0)) 失访数,
                 sum(decode(b.dia, '1', 1, 0)) 发现糖尿病,
                 sum(decode(b.tumor, '1', 1, 0)) 发现肿瘤,
                 sum(decode(b.kd, '1', 1, 0)) 发现慢性肾病,
                 sum(case when b.tumor = '1' and c.id is not null then 1 else 0 end) 复核肿瘤,
                 sum(case when b.kd = '1' and c.id is not null then 1 else 0 end) 复核慢性肾病,
                 a.xzqh_x
            from grjbxx      a,
                 dlmfxx      b,
                 sqfhxx c
           where a.id = b.grid
             and b.id = c.id(+)
             and c.fhzt(+) = '2'
             and a.yljgid in (select id
                                from p_yljg jg
                               start with jg.id = #{czyjgid}
                              connect by jg.gljgid = prior jg.id)
             and a.mfzt is not null
             and a.mfzt = '2'
             </if>
             <if if(StringUtils.isNotBlank(#{kssj}))>
               and a.mffprq >= std(#{kssj},1) 
             </if>
             <if if(StringUtils.isNotBlank(#{jssj}))>
               and a.mffprq <= std(#{jssj},1) 
             </if>
             <if if(1 == 1)>
             and a.xzqh_q = #{xzqh_q}
           group by a.xzqh_x) b,
         (select count(1) 发现脑卒中,
                 sum(case when c.id is not null then 1 else 0 end) 复核脑卒中,
                 a.xzqh_x
            from grjbxx      a,
                 dlmfxx      b,
                 sqfhxx c
           where a.id = b.grid
             and b.id = c.id(+)
             and c.fhzt(+) = '2'
             and exists(select 1 from dlmfxx_nzz d where b.id = d.id and d.stroke = '1')
             and a.yljgid in (select id
                                from p_yljg jg
                               start with jg.id = #{czyjgid}
                              connect by jg.gljgid = prior jg.id)
             and a.mfzt is not null
             and a.mfzt = '2'
             
             </if>
             <if if(StringUtils.isNotBlank(#{kssj}))>
               and a.mffprq >= std(#{kssj},1) 
             </if>
             <if if(StringUtils.isNotBlank(#{jssj}))>
               and a.mffprq <= std(#{jssj},1) 
             </if>
             <if if(1 == 1)>
             and a.xzqh_q = #{xzqh_q}
           group by a.xzqh_x) b1,
         (select count(1) 发现心肌梗死,
                 sum(case when c.id is not null then 1 else 0 end) 复核心肌梗死,
                 a.xzqh_x
            from grjbxx      a,
                 dlmfxx      b,
                 sqfhxx  c
           where a.id = b.grid
             and b.id = c.id(+)
             and c.fhzt(+) = '2'
             and exists(select 1 from dlmfxx_xjgs d where b.id = d.id and d.mi = '1')
             and a.yljgid in (select id
                                from p_yljg jg
                               start with jg.id = #{czyjgid}
                              connect by jg.gljgid = prior jg.id)
             and a.mfzt is not null
             and a.mfzt = '2'
             and b.id = c.id(+)
             and c.fhzt(+) = '2'
             </if>
             <if if(StringUtils.isNotBlank(#{kssj}))>
               and a.mffprq >= std(#{kssj},1) 
             </if>
             <if if(StringUtils.isNotBlank(#{jssj}))>
               and a.mffprq <= std(#{jssj},1) 
             </if>
             <if if(1 == 1)>
             and a.xzqh_q = #{xzqh_q}
           group by a.xzqh_x) b2,
         (select count(1) 发现充血性心力衰竭,
                 sum(case when c.id is not null then 1 else 0 end) 复核充血性心力衰竭,
                 a.xzqh_x
            from grjbxx      a,
                 dlmfxx      b,
                 sqfhxx  c
           where a.id = b.grid
             and b.id = c.id(+)
             and c.fhzt(+) = '2'
             and exists(select 1 from dlmfxx_xsj d where b.id = d.id and d.hf = '1')
             and a.yljgid in (select id
                                from p_yljg jg
                               start with jg.id = #{czyjgid}
                              connect by jg.gljgid = prior jg.id)
             and a.mfzt is not null
             and a.mfzt = '2'
             </if>
             <if if(StringUtils.isNotBlank(#{kssj}))>
               and a.mffprq >= std(#{kssj},1) 
             </if>
             <if if(StringUtils.isNotBlank(#{jssj}))>
               and a.mffprq <= std(#{jssj},1) 
             </if>
             and a.xzqh_q = #{xzqh_q}
           group by a.xzqh_x) b3
   where a.xzqh_x = b.xzqh_x(+)
     and a.xzqh_x = b1.xzqh_x(+)
     and a.xzqh_x = b2.xzqh_x(+)
     and a.xzqh_x = b3.xzqh_x(+))
select 应调查人数,
       街道名称,
       面访完成数,
       面访率,
       存活数,
       死亡数,
       失访数,
       发现糖尿病,
       发现肿瘤,
       发现脑卒中,
       发现心肌梗死,
       发现充血性心力衰竭,
       发现慢性肾病,
       发现小计,
       复核肿瘤,
       复核脑卒中,
       复核心肌梗死,
       复核充血性心力衰竭,
       复核慢性肾病,
       复核小计
  from tab
union all
select sum(应调查人数) 应调查人数,
       '合计',
       sum(面访完成数),
       round(sum(面访完成数) * 100 / sum(应调查人数),2) 面访率,
       sum(存活数) 存活数,
       sum(死亡数) 死亡数,
       sum(失访数) 失访数,
       sum(发现糖尿病) 发现糖尿病,
       sum(发现肿瘤) 发现肿瘤,
       sum(发现脑卒中) 发现脑卒中,
       sum(发现心肌梗死) 发现心肌梗死,
       sum(发现充血性心力衰竭) 发现充血性心力衰竭,
       sum(发现慢性肾病) 发现慢性肾病,
       sum(发现小计) 发现小计,
       sum(复核肿瘤) 复核肿瘤,
       sum(复核脑卒中) 复核脑卒中,
       sum(复核心肌梗死) 复核心肌梗死,
       sum(复核充血性心力衰竭) 复核充血性心力衰竭,
       sum(复核慢性肾病) 复核慢性肾病,
       sum(复核小计) 复核小计
  from tab                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
