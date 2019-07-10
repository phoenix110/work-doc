with tab as (
select 年龄,
       sum(case when substr(vc_hzicd,1,3) in ('I60') then 1 else 0 end ) 蛛网膜下腔出血,
       sum(case when substr(vc_hzicd,1,3) in ('I61') then 1 else 0 end ) 脑出血,
       sum(case when vc_hzicd in ('I63.0','I63.3','I63.6') then 1 else 0 end ) 脑血栓形成,
       sum(case when vc_hzicd in ('I63.1','I63.4') then 1 else 0 end ) 脑栓塞,
       sum(case when vc_hzicd in ('I63','I63.2','I63.5','I63.8','I63.9') then 1 else 0 end ) 部位不明,
       sum(case when substr(vc_hzicd,1,3) in ('I64') then 1 else 0 end ) 分类不明
from (
SELECT a.vc_hzicd,
       case when fun_get_agebycsrqandywrq(a.dt_hzcsrq, a.dt_fbrq) <= 0 then  '岁0'
            when fun_get_agebycsrqandywrq(a.dt_hzcsrq, a.dt_fbrq) between 1 and 4 then    '岁1'
            when fun_get_agebycsrqandywrq(a.dt_hzcsrq, a.dt_fbrq) between 5 and 4 then    '岁5'
            when fun_get_agebycsrqandywrq(a.dt_hzcsrq, a.dt_fbrq) between 11 and 14 then  '岁10'
            when fun_get_agebycsrqandywrq(a.dt_hzcsrq, a.dt_fbrq) between 15 and 19 then  '岁15'
            when fun_get_agebycsrqandywrq(a.dt_hzcsrq, a.dt_fbrq) between 20 and 24 then  '岁20'
            when fun_get_agebycsrqandywrq(a.dt_hzcsrq, a.dt_fbrq) between 25 and 29 then  '岁25'
            when fun_get_agebycsrqandywrq(a.dt_hzcsrq, a.dt_fbrq) between 30 and 34 then  '岁30'
            when fun_get_agebycsrqandywrq(a.dt_hzcsrq, a.dt_fbrq) between 35 and 39 then  '岁35'
            when fun_get_agebycsrqandywrq(a.dt_hzcsrq, a.dt_fbrq) between 40 and 44 then  '岁40'
            when fun_get_agebycsrqandywrq(a.dt_hzcsrq, a.dt_fbrq) between 45 and 49 then  '岁45'
            when fun_get_agebycsrqandywrq(a.dt_hzcsrq, a.dt_fbrq) between 50 and 54 then  '岁50'
            when fun_get_agebycsrqandywrq(a.dt_hzcsrq, a.dt_fbrq) between 55 and 59 then  '岁55'
            when fun_get_agebycsrqandywrq(a.dt_hzcsrq, a.dt_fbrq) between 60 and 64 then  '岁60'
            when fun_get_agebycsrqandywrq(a.dt_hzcsrq, a.dt_fbrq) between 65 and 69 then  '岁65'
            when fun_get_agebycsrqandywrq(a.dt_hzcsrq, a.dt_fbrq) between 70 and 74 then  '岁70'
            when fun_get_agebycsrqandywrq(a.dt_hzcsrq, a.dt_fbrq) between 75 and 79 then  '岁75'
            when fun_get_agebycsrqandywrq(a.dt_hzcsrq, a.dt_fbrq) between 80 and 84 then  '岁80'
            when fun_get_agebycsrqandywrq(a.dt_hzcsrq, a.dt_fbrq) >= 85 then  '岁85'  end 年龄
            from zjjk_xnxg_bgk a
           where a.vc_nczzd is not null
             and a.vc_scbz = '2'
             and a.vc_shbz in ('3', '5', '6', '7', '8')
             and a.vc_kzt in ('0', '2', '6', '7')
             and a.dt_fbrq between std(#{dt_kssj}, 1) and std(#{dt_jssj}, 1)
             <if if(StringUtils.isNotBlank(#{vc_hks}))>
               and a.vc_czhksi = #{vc_hks}
             </if>
             <if if(StringUtils.isNotBlank(#{vc_hkqx}))>
               and a.vc_czhkqx = #{vc_hkqx}
             </if>
             <if if("2".equals(#{hjlx}))>
                and exists(select 1 from p_xzdm xzdm where a.vc_czhkjd = xzdm.dm and xzdm.csbz = '城市')
             </if>
             <if if("3".equals(#{hjlx}))>
                and exists(select 1 from p_xzdm xzdm where a.vc_czhkjd = xzdm.dm and xzdm.csbz = '农村')
             </if>
             <if if("1".equals(#{xb}))>
                and a.vc_hzxb = '1'
             </if>
             <if if("2".equals(#{xb}))>
                and a.vc_hzxb = '2'
             </if>
             )
   group by 年龄)
select nld 年龄,
       蛛网膜下腔出血,
       脑出血,
       脑血栓形成,
       脑栓塞,
       部位不明,
       分类不明
  from (select 年龄,
               蛛网膜下腔出血,
               脑出血,
               脑血栓形成,
               脑栓塞,
               部位不明,
               分类不明
          from tab
        union all
        select '合计',
               sum(蛛网膜下腔出血),
               sum(脑出血),
               sum(脑血栓形成),
               sum(脑栓塞),
               sum(部位不明),
               sum(分类不明)
          from tab) a,
       (select '合计' nld, 0 sort
          from dual
        union
        select '岁0' nld, 1 sort
          from dual
        union
        select '岁1' nld, 2 sort
          from dual
        union
        select '岁5' nld, 3 sort
          from dual
        union
        select '岁10' nld, 4 sort
          from dual
        union
        select '岁15' nld, 5 sort
          from dual
        union
        select '岁20' nld, 6 sort
          from dual
        union
        select '岁25' nld, 7 sort
          from dual
        union
        select '岁30' nld, 8 sort
          from dual
        union
        select '岁35' nld, 9 sort
          from dual
        union
        select '岁40' nld, 10 sort
          from dual
        union
        select '岁45' nld, 11 sort
          from dual
        union
        select '岁50' nld, 12 sort
          from dual
        union
        select '岁55' nld, 13 sort
          from dual
        union
        select '岁60' nld, 14 sort
          from dual
        union
        select '岁65' nld, 15 sort
          from dual
        union
        select '岁70' nld, 16 sort
          from dual
        union
        select '岁75' nld, 17 sort
          from dual
        union
        select '岁80' nld, 18 sort
          from dual
        union
        select '岁85' nld, 19 sort
          from dual) b
 where a.年龄(+) = b.nld
 order by b.sort                                                                                                                                                                                                                                                                                                                                    