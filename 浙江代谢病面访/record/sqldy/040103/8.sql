with tab as
 (select 面访完成数,
         社区复核人数,
         社区复核完成人数,
         质控人数,
         质控通过人数,
         d.人员id,
         d.人员名称
    from (select count(1) 面访完成数,
                 a.mfrymc 人员名称,
                 a.mfryid 人员id
            from grjbxx a
           where a.yljgid in (select id
                                from p_yljg jg
                               start with jg.id = #{gljgid}
                              connect by jg.gljgid = prior jg.id)
             and a.mfzt = '2'
             <if if(StringUtils.isNotBlank(#{glryid}))>
               and a.mfryid = #{glryid}
             </if>
             <if if(StringUtils.isNotBlank(#{kssj}))>
               and a.mffprq >= std(#{kssj},1) 
             </if>
             <if if(StringUtils.isNotBlank(#{jssj}))>
               and a.mffprq <= std(#{jssj},1) 
             </if>
             <if if(1 == 1)>
           group by a.mfryid, a.mfrymc) a,
         (select a.sqfhryid 人员id,
                 a.sqfhrymc 人员名称,
                 count(1) 社区复核人数,
                 sum(decode(c.fhzt, '2', 1, 0)) 社区复核完成人数
            from grjbxx a, dlmfxx b, sqfhxx c
           where a.id = b.grid
             and b.id = c.id
             and a.yljgid in (select id
                                from p_yljg jg
                               start with jg.id = #{gljgid}
                              connect by jg.gljgid = prior jg.id)
             and a.mfzt is not null
             </if>
             <if if(StringUtils.isNotBlank(#{glryid}))>
               and a.sqfhryid = #{glryid}
             </if>
             <if if(StringUtils.isNotBlank(#{kssj}))>
               and c.fhsj >= std(#{kssj},1) 
             </if>
             <if if(StringUtils.isNotBlank(#{jssj}))>
               and c.fhsj <= std(#{jssj},1) 
             </if>
             <if if(1 == 1)>
           group by a.sqfhryid, a.sqfhrymc) b,
         (select a.mfzkrymc 人员名称,
                 a.mfzkryid 人员id,
                  count(1) 质控人数, 
                  sum(decode(a.mfzkzt, '1', 1, 0)) 质控通过人数
            from grjbxx a
           where a.yljgid in (select id
                                from p_yljg jg
                               start with jg.id = #{gljgid}
                              connect by jg.gljgid = prior jg.id)
             and a.mfzt is not null
             and a.mfzkzt in ('1', '2')
             </if>
             <if if(StringUtils.isNotBlank(#{glryid}))>
               and a.mfzkryid = #{glryid}
             </if>
             <if if(StringUtils.isNotBlank(#{kssj}))>
               and a.mfzksj >= std(#{kssj},1) 
             </if>
             <if if(StringUtils.isNotBlank(#{jssj}))>
               and a.mfzksj <= std(#{jssj},1) 
             </if>
             <if if(1 == 1)>
           group by a.mfzkryid, a.mfzkrymc) c,
         (select a.mfryid 人员id, a.mfrymc 人员名称
            from grjbxx a
           where a.yljgid in (select id
                                from p_yljg jg
                               start with jg.id = #{gljgid}
                              connect by jg.gljgid = prior jg.id)
             and a.mfzt = '2'
             </if>
             <if if(StringUtils.isNotBlank(#{glryid}))>
               and a.mfryid = #{glryid}
             </if>
             <if if(StringUtils.isNotBlank(#{kssj}))>
               and a.mffprq >= std(#{kssj},1) 
             </if>
             <if if(StringUtils.isNotBlank(#{jssj}))>
               and a.mffprq <= std(#{jssj},1) 
             </if>
             <if if(1 == 1)>
           group by a.mfryid, a.mfrymc
          union
          select a.sqfhryid 人员id, a.sqfhrymc 人员名称
            from grjbxx a, dlmfxx b, sqfhxx c
           where a.id = b.grid
             and b.id = c.id
             and a.yljgid in (select id
                                from p_yljg jg
                               start with jg.id = #{gljgid}
                              connect by jg.gljgid = prior jg.id)
             and a.mfzt is not null
             and a.sqfhryid is not null
             </if>
             <if if(StringUtils.isNotBlank(#{glryid}))>
               and a.sqfhryid = #{glryid}
             </if>
             <if if(StringUtils.isNotBlank(#{kssj}))>
               and c.fhsj >= std(#{kssj},1) 
             </if>
             <if if(StringUtils.isNotBlank(#{jssj}))>
               and c.fhsj <= std(#{jssj},1) 
             </if>
             <if if(1 == 1)>
           group by a.sqfhryid, a.sqfhrymc
          union
          select a.mfzkryid 人员id, a.mfzkrymc 人员名称
            from grjbxx a
           where a.yljgid in (select id
                                from p_yljg jg
                               start with jg.id = #{gljgid}
                              connect by jg.gljgid = prior jg.id)
             and a.mfzt is not null
             and a.mfzkzt in ('1', '2')
             and a.mfzkryid is not null
             </if>
             <if if(StringUtils.isNotBlank(#{glryid}))>
               and a.mfzkryid = #{glryid}
             </if>
             <if if(StringUtils.isNotBlank(#{kssj}))>
               and a.mfzksj >= std(#{kssj},1) 
             </if>
             <if if(StringUtils.isNotBlank(#{jssj}))>
               and a.mfzksj <= std(#{jssj},1) 
             </if>
           group by a.mfzkryid, a.mfzkrymc) d
   where d.人员id = a.人员id(+)
     and d.人员id = b.人员id(+)
     and d.人员id = c.人员id(+))
select 面访完成数,
       社区复核人数,
       社区复核完成人数,
       社区复核完成率,
       质控人数,
       质控通过人数,
       质控通过率,
       人员名称
  from (select 面访完成数,
               社区复核人数,
               社区复核完成人数,
               round(100 * 社区复核完成人数 /
                     (decode(社区复核人数, 0, null, 社区复核人数)),
                     2) 社区复核完成率,
               质控人数,
               质控通过人数,
                round(100 * 质控通过人数 /
                     (decode(质控人数, 0, null, 质控人数)),
                     2) 质控通过率,
               人员id,
               人员名称,
               0 sort
          from tab
        union all
        select sum(面访完成数),
               sum(社区复核人数),
               sum(社区复核完成人数),
               round(100 * sum(社区复核完成人数) /
                     (decode(sum(社区复核人数), 0, null, sum(社区复核人数))),
                     2) 社区复核完成率,
               sum(质控人数),
               sum(质控通过人数),
               round(100 * sum(质控通过人数) /
                     (decode(sum(质控人数), 0, null, sum(质控人数))),
                     2) 质控通过率,
               '合计',
               '合计',
               1 sort
          from tab)
 order by sort                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
