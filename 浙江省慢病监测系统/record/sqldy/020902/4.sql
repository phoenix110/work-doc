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
     and c.icds not in ('ALL', 'ALLbC44')
   group by c.typename, c.icdtitle)
select typename bwmc,
       icdtitle bwicd,
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
       ZJJK_ZL_ICD_REPORT_CONFIG b
 where a.bwicd(+) = b.icdtitle
 order by b.sort                                                                                                                                                                                                                                                                                                                                                                   