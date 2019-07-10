with tab as
 (select c.typename bwmc, c.icdtitle bwicd,
         count(1) 合计,
         sum(case when fun_get_agebycsrqandywrq(b.dt_hzcsrq, a.dt_sczdrq) = 0 then 1 else 0 end) 岁0,
         sum(case when fun_get_agebycsrqandywrq(b.dt_hzcsrq, a.dt_sczdrq) between 1 and 4 then 1 else 0 end) 岁1,
         sum(case when fun_get_agebycsrqandywrq(b.dt_hzcsrq, a.dt_sczdrq) between 5 and 4 then 9 else 0 end) 岁5,
         sum(case when fun_get_agebycsrqandywrq(b.dt_hzcsrq, a.dt_sczdrq) between 11 and 14 then 1 else 0 end) 岁10,
         sum(case when fun_get_agebycsrqandywrq(b.dt_hzcsrq, a.dt_sczdrq) between 15 and 19 then 1 else 0 end) 岁15,
         sum(case when fun_get_agebycsrqandywrq(b.dt_hzcsrq, a.dt_sczdrq) between 20 and 24 then 1 else 0 end) 岁20,
         sum(case when fun_get_agebycsrqandywrq(b.dt_hzcsrq, a.dt_sczdrq) between 25 and 29 then 1 else 0 end) 岁25,
         sum(case when fun_get_agebycsrqandywrq(b.dt_hzcsrq, a.dt_sczdrq) between 30 and 34 then 1 else 0 end) 岁30,
         sum(case when fun_get_agebycsrqandywrq(b.dt_hzcsrq, a.dt_sczdrq) between 35 and 39 then 1 else 0 end) 岁35,
         sum(case when fun_get_agebycsrqandywrq(b.dt_hzcsrq, a.dt_sczdrq) between 40 and 44 then 1 else 0 end) 岁40,
         sum(case when fun_get_agebycsrqandywrq(b.dt_hzcsrq, a.dt_sczdrq) between 45 and 49 then 1 else 0 end) 岁45,
         sum(case when fun_get_agebycsrqandywrq(b.dt_hzcsrq, a.dt_sczdrq) between 50 and 54 then 1 else 0 end) 岁50,
         sum(case when fun_get_agebycsrqandywrq(b.dt_hzcsrq, a.dt_sczdrq) between 55 and 59 then 1 else 0 end) 岁55,
         sum(case when fun_get_agebycsrqandywrq(b.dt_hzcsrq, a.dt_sczdrq) between 60 and 64 then 1 else 0 end) 岁60,
         sum(case when fun_get_agebycsrqandywrq(b.dt_hzcsrq, a.dt_sczdrq) between 65 and 69 then 1 else 0 end) 岁65,
         sum(case when fun_get_agebycsrqandywrq(b.dt_hzcsrq, a.dt_sczdrq) between 70 and 74 then 1 else 0 end) 岁70,
         sum(case when fun_get_agebycsrqandywrq(b.dt_hzcsrq, a.dt_sczdrq) between 75 and 79 then 1 else 0 end) 岁75,
         sum(case when fun_get_agebycsrqandywrq(b.dt_hzcsrq, a.dt_sczdrq) between 80 and 84 then 1 else 0 end) 岁80,
         sum(case when fun_get_agebycsrqandywrq(b.dt_hzcsrq, a.dt_sczdrq) >= 85 then 1 else 0 end) 岁85  
    from zjjk_zl_bgk a, zjjk_zl_hzxx b, ZJJK_ZL_ICD_REPORT_CONFIG c
   where a.vc_hzid = b.vc_personid
     and a.vc_shbz in ('3', '5', '6', '7', '8')
     and a.vc_bgkzt in ('0', '2', '6', '7')
     and a.vc_scbz = '0'
     and instr(c.icds, substr(a.vc_icd10, 1, 3)) > 0
     and a.dt_sczdrq between std(#{dt_kssj}, 1) and std(#{dt_jssj}, 1)
     <if if(StringUtils.isNotBlank(#{vc_hks}))>
       and b.vc_hksdm = #{vc_hks}
     </if>
     <if if(StringUtils.isNotBlank(#{vc_hkqx}))>
       and b.vc_hkqxdm = #{vc_hkqx}
     </if>
     <if if("2".equals(#{hjlx}))>
        and exists(select 1 from p_xzdm xzdm where b.vc_hkjddm = xzdm.dm and xzdm.csbz = '城市')
     </if>
     <if if("3".equals(#{hjlx}))>
        and exists(select 1 from p_xzdm xzdm where b.vc_hkjddm = xzdm.dm and xzdm.csbz = '农村')
     </if>
     <if if("1".equals(#{xb}))>
        and b.vc_hzxb = '1'
     </if>
     <if if("2".equals(#{xb}))>
        and b.vc_hzxb = '2'
     </if>
     <if if(1 == 1)>
     and c.icds not in ('ALL', 'ALLbC44')
   group by c.typename, c.icdtitle)
select typename bwmc,
       icdtitle bwicd,
       round(100*合计/vc_zhj, 2) 合计,
       round(100*岁0/vc_0nld, 2)   岁0,    
       round(100*岁1/vc_1nld, 2)   岁1,  
       round(100*岁5/vc_5nld, 2)   岁5,  
       round(100*岁10/vc_10nld, 2)  岁10, 
       round(100*岁15/vc_15nld, 2)  岁15, 
       round(100*岁20/vc_20nld, 2)  岁20, 
       round(100*岁25/vc_25nld, 2)  岁25, 
       round(100*岁30/vc_30nld, 2)  岁30, 
       round(100*岁35/vc_35nld, 2)  岁35, 
       round(100*岁40/vc_40nld, 2)  岁40, 
       round(100*岁45/vc_45nld, 2)  岁45, 
       round(100*岁50/vc_50nld, 2)  岁50, 
       round(100*岁55/vc_55nld, 2)  岁55, 
       round(100*岁60/vc_60nld, 2)  岁60, 
       round(100*岁65/vc_65nld, 2)  岁65, 
       round(100*岁70/vc_70nld, 2)  岁70, 
       round(100*岁75/vc_75nld, 2)  岁75, 
       round(100*岁80/vc_80nld, 2)  岁80, 
       round(100*岁85/vc_85nld, 2)  岁85
  from (select bwmc,
               bwicd,
               合计,
               岁0,
               岁1,
               岁5,
               岁10,
               岁15,
               岁20,
               岁25,
               岁30,
               岁35,
               岁40,
               岁45,
               岁50,
               岁55,
               岁60,
               岁65,
               岁70,
               岁75,
               岁80,
               岁85
          from tab
        union all
        select '所有部位合计',
               'ALL',
               sum(合计),
               sum(岁0),
               sum(岁1),
               sum(岁5),
               sum(岁10),
               sum(岁15),
               sum(岁20),
               sum(岁25),
               sum(岁30),
               sum(岁35),
               sum(岁40),
               sum(岁45),
               sum(岁50),
               sum(岁55),
               sum(岁60),
               sum(岁65),
               sum(岁70),
               sum(岁75),
               sum(岁80),
               sum(岁85)
          from tab
        union all
        select '所有部位除外C44',
               'ALLbC44',
               sum(合计),
               sum(岁0),
               sum(岁1),
               sum(岁5),
               sum(岁10),
               sum(岁15),
               sum(岁20),
               sum(岁25),
               sum(岁30),
               sum(岁35),
               sum(岁40),
               sum(岁45),
               sum(岁50),
               sum(岁55),
               sum(岁60),
               sum(岁65),
               sum(岁70),
               sum(岁75),
               sum(岁80),
               sum(岁85)
          from tab
         where bwicd <> 'C44') a,
       ZJJK_ZL_ICD_REPORT_CONFIG b,(select decode(max(decode(#{xb}, '1', vc_nhj, '2', vc_vhj, vc_zhj)), 0, null, max(decode(#{xb}, '1', vc_nhj, '2', vc_vhj, vc_zhj))) vc_zhj,
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
 where a.bwicd(+) = b.icdtitle
 order by b.sort                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       