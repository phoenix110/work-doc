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
             <if if(1 == 1)>
             )
   group by 年龄)
select nld 年龄,
       round(100*蛛网膜下腔出血/(case when nld = '合计' then vc_zhj 
                               when nld = '岁0' then vc_0nld
                               when nld = '岁1' then vc_1nld
                               when nld = '岁5' then vc_5nld  
                               when nld = '岁10' then vc_10nld
                               when nld = '岁15' then vc_15nld
                               when nld = '岁20' then vc_20nld
                               when nld = '岁25' then vc_25nld
                               when nld = '岁30' then vc_30nld
                               when nld = '岁35' then vc_35nld
                               when nld = '岁40' then vc_40nld
                               when nld = '岁45' then vc_45nld
                               when nld = '岁50' then vc_50nld
                               when nld = '岁55' then vc_55nld
                               when nld = '岁60' then vc_60nld
                               when nld = '岁65' then vc_65nld
                               when nld = '岁70' then vc_70nld
                               when nld = '岁75' then vc_75nld
                               when nld = '岁80' then vc_80nld  
                               when nld = '岁85' then vc_85nld
                          end), 2) 蛛网膜下腔出血,
        round(100*脑出血/(case when nld = '合计' then vc_zhj 
                               when nld = '岁0' then vc_0nld
                               when nld = '岁1' then vc_1nld
                               when nld = '岁5' then vc_5nld  
                               when nld = '岁10' then vc_10nld
                               when nld = '岁15' then vc_15nld
                               when nld = '岁20' then vc_20nld
                               when nld = '岁25' then vc_25nld
                               when nld = '岁30' then vc_30nld
                               when nld = '岁35' then vc_35nld
                               when nld = '岁40' then vc_40nld
                               when nld = '岁45' then vc_45nld
                               when nld = '岁50' then vc_50nld
                               when nld = '岁55' then vc_55nld
                               when nld = '岁60' then vc_60nld
                               when nld = '岁65' then vc_65nld
                               when nld = '岁70' then vc_70nld
                               when nld = '岁75' then vc_75nld
                               when nld = '岁80' then vc_80nld  
                               when nld = '岁85' then vc_85nld
                          end), 2) 脑出血,
        round(100*脑血栓形成/(case when nld = '合计' then vc_zhj 
                               when nld = '岁0' then vc_0nld
                               when nld = '岁1' then vc_1nld
                               when nld = '岁5' then vc_5nld  
                               when nld = '岁10' then vc_10nld
                               when nld = '岁15' then vc_15nld
                               when nld = '岁20' then vc_20nld
                               when nld = '岁25' then vc_25nld
                               when nld = '岁30' then vc_30nld
                               when nld = '岁35' then vc_35nld
                               when nld = '岁40' then vc_40nld
                               when nld = '岁45' then vc_45nld
                               when nld = '岁50' then vc_50nld
                               when nld = '岁55' then vc_55nld
                               when nld = '岁60' then vc_60nld
                               when nld = '岁65' then vc_65nld
                               when nld = '岁70' then vc_70nld
                               when nld = '岁75' then vc_75nld
                               when nld = '岁80' then vc_80nld  
                               when nld = '岁85' then vc_85nld
                          end), 2) 脑血栓形成,
        round(100*脑栓塞/(case when nld = '合计' then vc_zhj 
                               when nld = '岁0' then vc_0nld
                               when nld = '岁1' then vc_1nld
                               when nld = '岁5' then vc_5nld  
                               when nld = '岁10' then vc_10nld
                               when nld = '岁15' then vc_15nld
                               when nld = '岁20' then vc_20nld
                               when nld = '岁25' then vc_25nld
                               when nld = '岁30' then vc_30nld
                               when nld = '岁35' then vc_35nld
                               when nld = '岁40' then vc_40nld
                               when nld = '岁45' then vc_45nld
                               when nld = '岁50' then vc_50nld
                               when nld = '岁55' then vc_55nld
                               when nld = '岁60' then vc_60nld
                               when nld = '岁65' then vc_65nld
                               when nld = '岁70' then vc_70nld
                               when nld = '岁75' then vc_75nld
                               when nld = '岁80' then vc_80nld  
                               when nld = '岁85' then vc_85nld
                          end), 2) 脑栓塞,
        round(100*部位不明/(case when nld = '合计' then vc_zhj 
                               when nld = '岁0' then vc_0nld
                               when nld = '岁1' then vc_1nld
                               when nld = '岁5' then vc_5nld  
                               when nld = '岁10' then vc_10nld
                               when nld = '岁15' then vc_15nld
                               when nld = '岁20' then vc_20nld
                               when nld = '岁25' then vc_25nld
                               when nld = '岁30' then vc_30nld
                               when nld = '岁35' then vc_35nld
                               when nld = '岁40' then vc_40nld
                               when nld = '岁45' then vc_45nld
                               when nld = '岁50' then vc_50nld
                               when nld = '岁55' then vc_55nld
                               when nld = '岁60' then vc_60nld
                               when nld = '岁65' then vc_65nld
                               when nld = '岁70' then vc_70nld
                               when nld = '岁75' then vc_75nld
                               when nld = '岁80' then vc_80nld  
                               when nld = '岁85' then vc_85nld
                          end), 2) 部位不明,
        round(100*分类不明/(case when nld = '合计' then vc_zhj 
                               when nld = '岁0' then vc_0nld
                               when nld = '岁1' then vc_1nld
                               when nld = '岁5' then vc_5nld  
                               when nld = '岁10' then vc_10nld
                               when nld = '岁15' then vc_15nld
                               when nld = '岁20' then vc_20nld
                               when nld = '岁25' then vc_25nld
                               when nld = '岁30' then vc_30nld
                               when nld = '岁35' then vc_35nld
                               when nld = '岁40' then vc_40nld
                               when nld = '岁45' then vc_45nld
                               when nld = '岁50' then vc_50nld
                               when nld = '岁55' then vc_55nld
                               when nld = '岁60' then vc_60nld
                               when nld = '岁65' then vc_65nld
                               when nld = '岁70' then vc_70nld
                               when nld = '岁75' then vc_75nld
                               when nld = '岁80' then vc_80nld  
                               when nld = '岁85' then vc_85nld
                          end), 2) 分类不明
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
          from dual) b,(select decode(max(decode(#{xb}, '1', vc_nhj, '2', vc_vhj, vc_zhj)), 0, null, max(decode(#{xb}, '1', vc_nhj, '2', vc_vhj, vc_zhj))) vc_zhj,
                                           decode(max(vc_0nld), 0, null, max(vc_0nld)) vc_0nld,
                                           decode(max(vc_1nld), 0, null, max(vc_1nld)) vc_1nld,
                                           decode(max(vc_5nld), 0, null, max(vc_5nld)) vc_5nld,
                                           decode(max(vc_10nld), 0, null, max(vc_10nld)) vc_10nld,
                                           decode(max(vc_15nld), 0, null, max(vc_15nld)) vc_15nld,
                                           decode(max(vc_20nld), 0, null, max(vc_20nld)) vc_20nld,
                                           decode(max(vc_25nld), 0, null, max(vc_25nld)) vc_25nld,
                                           decode(max(vc_30nld), 0, null, max(vc_30nld)) vc_30nld,
                                           decode(max(vc_35nld), 0, null, max(vc_35nld)) vc_35nld,
                                           decode(max(vc_40nld), 0, null, max(vc_40nld)) vc_40nld,
                                           decode(max(vc_45nld), 0, null, max(vc_45nld)) vc_45nld,
                                           decode(max(vc_50nld), 0, null, max(vc_50nld)) vc_50nld,
                                           decode(max(vc_55nld), 0, null, max(vc_55nld)) vc_55nld,
                                           decode(max(vc_60nld), 0, null, max(vc_60nld)) vc_60nld,
                                           decode(max(vc_65nld), 0, null, max(vc_65nld)) vc_65nld,
                                           decode(max(vc_70nld), 0, null, max(vc_70nld)) vc_70nld,
                                           decode(max(vc_75nld), 0, null, max(vc_75nld)) vc_75nld,
                                           decode(max(vc_80nld), 0, null, max(vc_80nld)) vc_80nld,
                                           decode(max(vc_85nld), 0, null, max(vc_85nld)) vc_85nld
                                      from ZJMB_RKGLB 
                                     where vc_nf = #{nf}
                                     </if>
                                     <if if(StringUtils.isBlank(#{xb}))>
                                       and vc_lx = '6'
                                     </if>
                                     <if if("1".equals(#{xb}))>
                                        and vc_lx = '4'
                                     </if>
                                     <if if("2".equals(#{xb}))>
                                        and vc_lx = '5'
                                     </if>
                                     <if if(StringUtils.isNotBlank(#{vc_hkjd}))>
                                       and vc_rkgljd = #{vc_hkjd}
                                     </if>
                                     <if if(StringUtils.isNotBlank(#{vc_hkqx}) && StringUtils.isBlank(#{vc_hkjd}))>
                                       and vc_rkgljd = '99999999'
                                       and vc_rkglq = #{vc_hkqx}
                                     </if>
                                     <if if(StringUtils.isBlank(#{vc_hkqx}) && StringUtils.isNotBlank(#{vc_hks}))>
                                       and vc_rkglq = '99999999'
                                       and vc_rkgls = #{vc_hks}
                                     </if>
                                     <if if(StringUtils.isBlank(#{vc_hks}))>
                                         and vc_rkgls = '99999999'
                                     </if>
                                    
                                    ) c
 where a.年龄(+) = b.nld
 order by b.sort                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    