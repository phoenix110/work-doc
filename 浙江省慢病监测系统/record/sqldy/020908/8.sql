with tab as
 (select a.ccd_code,
         a.ccd_name,
         a.ordernum,
         nlhj,
         b.nl0,
         b.nl1,
         b.nl5,
         b.nl10,
         b.nl15,
         b.nl20,
         b.nl25,
         b.nl30,
         b.nl35,
         b.nl40,
         b.nl45,
         b.nl50,
         b.nl55,
         b.nl60,
         b.nl65,
         b.nl70,
         b.nl75,
         b.nl80,
         b.nl85
    from (select QT1 ccd_code, QT2 ccd_name, ordernum
            from temp_zjjk_report_row t
           where reportname = 'jmbsswyyb'
             and rowname = '0'
             and QT1 > 1) a,
         (select ccd_code,
                 count(1) nlhj,
                 sum(case
                       when nld = 'nl0' then
                        1
                       else
                        0
                     end) nl0,
                 sum(case
                       when nld = 'nl1' then
                        1
                       else
                        0
                     end) nl1,
                 sum(case
                       when nld = 'nl5' then
                        1
                       else
                        0
                     end) nl5,
                 sum(case
                       when nld = 'nl10' then
                        1
                       else
                        0
                     end) nl10,
                 sum(case
                       when nld = 'nl15' then
                        1
                       else
                        0
                     end) nl15,
                 sum(case
                       when nld = 'nl20' then
                        1
                       else
                        0
                     end) nl20,
                 sum(case
                       when nld = 'nl25' then
                        1
                       else
                        0
                     end) nl25,
                 sum(case
                       when nld = 'nl30' then
                        1
                       else
                        0
                     end) nl30,
                 sum(case
                       when nld = 'nl35' then
                        1
                       else
                        0
                     end) nl35,
                 sum(case
                       when nld = 'nl40' then
                        1
                       else
                        0
                     end) nl40,
                 sum(case
                       when nld = 'nl45' then
                        1
                       else
                        0
                     end) nl45,
                 sum(case
                       when nld = 'nl50' then
                        1
                       else
                        0
                     end) nl50,
                 sum(case
                       when nld = 'nl55' then
                        1
                       else
                        0
                     end) nl55,
                 sum(case
                       when nld = 'nl60' then
                        1
                       else
                        0
                     end) nl60,
                 sum(case
                       when nld = 'nl65' then
                        1
                       else
                        0
                     end) nl65,
                 sum(case
                       when nld = 'nl70' then
                        1
                       else
                        0
                     end) nl70,
                 sum(case
                       when nld = 'nl75' then
                        1
                       else
                        0
                     end) nl75,
                 sum(case
                       when nld = 'nl80' then
                        1
                       else
                        0
                     end) nl80,
                 sum(case
                       when nld = 'nl85' then
                        1
                       else
                        0
                     end) nl85
            from (select case '1'
                           when '2' then
                            c.ccd_scode
                           when '3' then
                            c.ccd_pcode
                           else
                            to_char(c.ccd_code)
                         end ccd_code,
                         case
                           when fun_get_agebycsrqandywrq(a.dt_csrq, a.dt_swrq) <= 0 then
                            'nl0'
                           when fun_get_agebycsrqandywrq(a.dt_csrq, a.dt_swrq) between 1 and 4 then
                            'nl1'
                           when fun_get_agebycsrqandywrq(a.dt_csrq, a.dt_swrq) between 5 and 9 then
                            'nl5'
                           when fun_get_agebycsrqandywrq(a.dt_csrq, a.dt_swrq) between 10 and 14 then
                            'nl10'
                           when fun_get_agebycsrqandywrq(a.dt_csrq, a.dt_swrq) between 15 and 19 then
                            'nl15'
                           when fun_get_agebycsrqandywrq(a.dt_csrq, a.dt_swrq) between 20 and 24 then
                            'nl20'
                           when fun_get_agebycsrqandywrq(a.dt_csrq, a.dt_swrq) between 25 and 29 then
                            'nl25'
                           when fun_get_agebycsrqandywrq(a.dt_csrq, a.dt_swrq) between 30 and 34 then
                            'nl30'
                           when fun_get_agebycsrqandywrq(a.dt_csrq, a.dt_swrq) between 35 and 39 then
                            'nl35'
                           when fun_get_agebycsrqandywrq(a.dt_csrq, a.dt_swrq) between 40 and 44 then
                            'nl40'
                           when fun_get_agebycsrqandywrq(a.dt_csrq, a.dt_swrq) between 45 and 49 then
                            'nl45'
                           when fun_get_agebycsrqandywrq(a.dt_csrq, a.dt_swrq) between 50 and 54 then
                            'nl50'
                           when fun_get_agebycsrqandywrq(a.dt_csrq, a.dt_swrq) between 55 and 59 then
                            'nl55'
                           when fun_get_agebycsrqandywrq(a.dt_csrq, a.dt_swrq) between 60 and 64 then
                            'nl60'
                           when fun_get_agebycsrqandywrq(a.dt_csrq, a.dt_swrq) between 65 and 69 then
                            'nl65'
                           when fun_get_agebycsrqandywrq(a.dt_csrq, a.dt_swrq) between 70 and 74 then
                            'nl70'
                           when fun_get_agebycsrqandywrq(a.dt_csrq, a.dt_swrq) between 75 and 79 then
                            'nl75'
                           when fun_get_agebycsrqandywrq(a.dt_csrq, a.dt_swrq) between 80 and 84 then
                            'nl80'
                           when fun_get_agebycsrqandywrq(a.dt_csrq, a.dt_swrq) >= 85 then
                            'nl85'
                         end nld
                    from zjmb_sw_bgk a, t_icd10_cc c
                   where a.vc_gbsy = c.icd10_code
                     and a.vc_bgklb = '0'
                     and a.vc_shbz in ('8', '7', '6', '5', '3')
                     and a.vc_scbz = '2'
                     <if if(StringUtils.isNotBlank(#{vc_hks}))>
                         and a.vc_hksdm = #{vc_hks}
                     </if>
                     <if if(StringUtils.isNotBlank(#{vc_hkqx}))>
                         and a.vc_hkqxdm = #{vc_hkqx}
                     </if>
                     <if if(StringUtils.isNotBlank(#{dt_jzsj_ks}))>
                         and a.dt_swrq >= std(#{dt_jzsj_ks},1)
                     </if>
                     <if if(StringUtils.isNotBlank(#{dt_jzsj_js}))>
                         and a.dt_swrq <= std(#{dt_jzsj_js},1)
                     </if>
                     <if if(StringUtils.isNotBlank(#{dt_lrsj_ks}))>
                         and a.dt_cjsj >= std(#{dt_lrsj_ks},1)
                     </if>
                     <if if(StringUtils.isNotBlank(#{dt_lrsj_js}))>
                         and a.dt_cjsj <= std(#{dt_lrsj_js},1)
                     </if>
                     <if if(StringUtils.isNotBlank(#{xb}))>
                         and a.vc_xb = #{xb}
                     </if>
                     <if if("2".equals(#{hjlx}))>
                         and exists(select 1 from p_xzdm xzdm where a.vc_hkjddm = xzdm.dm and xzdm.csbz = '城市')
                     </if>
                     <if if("3".equals(#{hjlx}))>
                         and exists(select 1 from p_xzdm xzdm where a.vc_hkjddm = xzdm.dm and xzdm.csbz = '农村')
                     </if>
                     <if if(1 == 1)>)
           group by ccd_code
          union all
          select ccd_code,
                 count(1) nlhj,
                 sum(case
                       when nld = 'nl0' then
                        1
                       else
                        0
                     end) nl0,
                 sum(case
                       when nld = 'nl1' then
                        1
                       else
                        0
                     end) nl1,
                 sum(case
                       when nld = 'nl5' then
                        1
                       else
                        0
                     end) nl5,
                 sum(case
                       when nld = 'nl10' then
                        1
                       else
                        0
                     end) nl10,
                 sum(case
                       when nld = 'nl15' then
                        1
                       else
                        0
                     end) nl15,
                 sum(case
                       when nld = 'nl20' then
                        1
                       else
                        0
                     end) nl20,
                 sum(case
                       when nld = 'nl25' then
                        1
                       else
                        0
                     end) nl25,
                 sum(case
                       when nld = 'nl30' then
                        1
                       else
                        0
                     end) nl30,
                 sum(case
                       when nld = 'nl35' then
                        1
                       else
                        0
                     end) nl35,
                 sum(case
                       when nld = 'nl40' then
                        1
                       else
                        0
                     end) nl40,
                 sum(case
                       when nld = 'nl45' then
                        1
                       else
                        0
                     end) nl45,
                 sum(case
                       when nld = 'nl50' then
                        1
                       else
                        0
                     end) nl50,
                 sum(case
                       when nld = 'nl55' then
                        1
                       else
                        0
                     end) nl55,
                 sum(case
                       when nld = 'nl60' then
                        1
                       else
                        0
                     end) nl60,
                 sum(case
                       when nld = 'nl65' then
                        1
                       else
                        0
                     end) nl65,
                 sum(case
                       when nld = 'nl70' then
                        1
                       else
                        0
                     end) nl70,
                 sum(case
                       when nld = 'nl75' then
                        1
                       else
                        0
                     end) nl75,
                 sum(case
                       when nld = 'nl80' then
                        1
                       else
                        0
                     end) nl80,
                 sum(case
                       when nld = 'nl85' then
                        1
                       else
                        0
                     end) nl85
            from (select case '2'
                           when '2' then
                            c.ccd_scode
                           when '3' then
                            c.ccd_pcode
                           else
                            to_char(c.ccd_code)
                         end ccd_code,
                         case
                           when fun_get_agebycsrqandywrq(a.dt_csrq, a.dt_swrq) <= 0 then
                            'nl0'
                           when fun_get_agebycsrqandywrq(a.dt_csrq, a.dt_swrq) between 1 and 4 then
                            'nl1'
                           when fun_get_agebycsrqandywrq(a.dt_csrq, a.dt_swrq) between 5 and 9 then
                            'nl5'
                           when fun_get_agebycsrqandywrq(a.dt_csrq, a.dt_swrq) between 10 and 14 then
                            'nl10'
                           when fun_get_agebycsrqandywrq(a.dt_csrq, a.dt_swrq) between 15 and 19 then
                            'nl15'
                           when fun_get_agebycsrqandywrq(a.dt_csrq, a.dt_swrq) between 20 and 24 then
                            'nl20'
                           when fun_get_agebycsrqandywrq(a.dt_csrq, a.dt_swrq) between 25 and 29 then
                            'nl25'
                           when fun_get_agebycsrqandywrq(a.dt_csrq, a.dt_swrq) between 30 and 34 then
                            'nl30'
                           when fun_get_agebycsrqandywrq(a.dt_csrq, a.dt_swrq) between 35 and 39 then
                            'nl35'
                           when fun_get_agebycsrqandywrq(a.dt_csrq, a.dt_swrq) between 40 and 44 then
                            'nl40'
                           when fun_get_agebycsrqandywrq(a.dt_csrq, a.dt_swrq) between 45 and 49 then
                            'nl45'
                           when fun_get_agebycsrqandywrq(a.dt_csrq, a.dt_swrq) between 50 and 54 then
                            'nl50'
                           when fun_get_agebycsrqandywrq(a.dt_csrq, a.dt_swrq) between 55 and 59 then
                            'nl55'
                           when fun_get_agebycsrqandywrq(a.dt_csrq, a.dt_swrq) between 60 and 64 then
                            'nl60'
                           when fun_get_agebycsrqandywrq(a.dt_csrq, a.dt_swrq) between 65 and 69 then
                            'nl65'
                           when fun_get_agebycsrqandywrq(a.dt_csrq, a.dt_swrq) between 70 and 74 then
                            'nl70'
                           when fun_get_agebycsrqandywrq(a.dt_csrq, a.dt_swrq) between 75 and 79 then
                            'nl75'
                           when fun_get_agebycsrqandywrq(a.dt_csrq, a.dt_swrq) between 80 and 84 then
                            'nl80'
                           when fun_get_agebycsrqandywrq(a.dt_csrq, a.dt_swrq) >= 85 then
                            'nl85'
                         end nld
                    from zjmb_sw_bgk a, t_icd10_cc c
                   where a.vc_gbsy = c.icd10_code
                     and a.vc_bgklb = '0'
                     and a.vc_shbz in ('8', '7', '6', '5', '3')
                     and a.vc_scbz = '2'
                     </if>
                     <if if(StringUtils.isNotBlank(#{vc_hks}))>
                         and a.vc_hksdm = #{vc_hks}
                     </if>
                     <if if(StringUtils.isNotBlank(#{vc_hkqx}))>
                         and a.vc_hkqxdm = #{vc_hkqx}
                     </if>
                     <if if(StringUtils.isNotBlank(#{dt_jzsj_ks}))>
                         and a.dt_swrq >= std(#{dt_jzsj_ks},1)
                     </if>
                     <if if(StringUtils.isNotBlank(#{dt_jzsj_js}))>
                         and a.dt_swrq <= std(#{dt_jzsj_js},1)
                     </if>
                     <if if(StringUtils.isNotBlank(#{dt_lrsj_ks}))>
                         and a.dt_cjsj >= std(#{dt_lrsj_ks},1)
                     </if>
                     <if if(StringUtils.isNotBlank(#{dt_lrsj_js}))>
                         and a.dt_cjsj <= std(#{dt_lrsj_js},1)
                     </if>
                     <if if(StringUtils.isNotBlank(#{xb}))>
                         and a.vc_xb = #{xb}
                     </if>
                     <if if("2".equals(#{hjlx}))>
                         and exists(select 1 from p_xzdm xzdm where a.vc_hkjddm = xzdm.dm and xzdm.csbz = '城市')
                     </if>
                     <if if("3".equals(#{hjlx}))>
                         and exists(select 1 from p_xzdm xzdm where a.vc_hkjddm = xzdm.dm and xzdm.csbz = '农村')
                     </if>
                     <if if(1 == 1)>)
           group by ccd_code
          union all
          select ccd_code,
                 count(1) nlhj,
                 sum(case
                       when nld = 'nl0' then
                        1
                       else
                        0
                     end) nl0,
                 sum(case
                       when nld = 'nl1' then
                        1
                       else
                        0
                     end) nl1,
                 sum(case
                       when nld = 'nl5' then
                        1
                       else
                        0
                     end) nl5,
                 sum(case
                       when nld = 'nl10' then
                        1
                       else
                        0
                     end) nl10,
                 sum(case
                       when nld = 'nl15' then
                        1
                       else
                        0
                     end) nl15,
                 sum(case
                       when nld = 'nl20' then
                        1
                       else
                        0
                     end) nl20,
                 sum(case
                       when nld = 'nl25' then
                        1
                       else
                        0
                     end) nl25,
                 sum(case
                       when nld = 'nl30' then
                        1
                       else
                        0
                     end) nl30,
                 sum(case
                       when nld = 'nl35' then
                        1
                       else
                        0
                     end) nl35,
                 sum(case
                       when nld = 'nl40' then
                        1
                       else
                        0
                     end) nl40,
                 sum(case
                       when nld = 'nl45' then
                        1
                       else
                        0
                     end) nl45,
                 sum(case
                       when nld = 'nl50' then
                        1
                       else
                        0
                     end) nl50,
                 sum(case
                       when nld = 'nl55' then
                        1
                       else
                        0
                     end) nl55,
                 sum(case
                       when nld = 'nl60' then
                        1
                       else
                        0
                     end) nl60,
                 sum(case
                       when nld = 'nl65' then
                        1
                       else
                        0
                     end) nl65,
                 sum(case
                       when nld = 'nl70' then
                        1
                       else
                        0
                     end) nl70,
                 sum(case
                       when nld = 'nl75' then
                        1
                       else
                        0
                     end) nl75,
                 sum(case
                       when nld = 'nl80' then
                        1
                       else
                        0
                     end) nl80,
                 sum(case
                       when nld = 'nl85' then
                        1
                       else
                        0
                     end) nl85
            from (select case '3'
                           when '2' then
                            c.ccd_scode
                           when '3' then
                            c.ccd_pcode
                           else
                            to_char(c.ccd_code)
                         end ccd_code,
                         case
                           when fun_get_agebycsrqandywrq(a.dt_csrq, a.dt_swrq) <= 0 then
                            'nl0'
                           when fun_get_agebycsrqandywrq(a.dt_csrq, a.dt_swrq) between 1 and 4 then
                            'nl1'
                           when fun_get_agebycsrqandywrq(a.dt_csrq, a.dt_swrq) between 5 and 9 then
                            'nl5'
                           when fun_get_agebycsrqandywrq(a.dt_csrq, a.dt_swrq) between 10 and 14 then
                            'nl10'
                           when fun_get_agebycsrqandywrq(a.dt_csrq, a.dt_swrq) between 15 and 19 then
                            'nl15'
                           when fun_get_agebycsrqandywrq(a.dt_csrq, a.dt_swrq) between 20 and 24 then
                            'nl20'
                           when fun_get_agebycsrqandywrq(a.dt_csrq, a.dt_swrq) between 25 and 29 then
                            'nl25'
                           when fun_get_agebycsrqandywrq(a.dt_csrq, a.dt_swrq) between 30 and 34 then
                            'nl30'
                           when fun_get_agebycsrqandywrq(a.dt_csrq, a.dt_swrq) between 35 and 39 then
                            'nl35'
                           when fun_get_agebycsrqandywrq(a.dt_csrq, a.dt_swrq) between 40 and 44 then
                            'nl40'
                           when fun_get_agebycsrqandywrq(a.dt_csrq, a.dt_swrq) between 45 and 49 then
                            'nl45'
                           when fun_get_agebycsrqandywrq(a.dt_csrq, a.dt_swrq) between 50 and 54 then
                            'nl50'
                           when fun_get_agebycsrqandywrq(a.dt_csrq, a.dt_swrq) between 55 and 59 then
                            'nl55'
                           when fun_get_agebycsrqandywrq(a.dt_csrq, a.dt_swrq) between 60 and 64 then
                            'nl60'
                           when fun_get_agebycsrqandywrq(a.dt_csrq, a.dt_swrq) between 65 and 69 then
                            'nl65'
                           when fun_get_agebycsrqandywrq(a.dt_csrq, a.dt_swrq) between 70 and 74 then
                            'nl70'
                           when fun_get_agebycsrqandywrq(a.dt_csrq, a.dt_swrq) between 75 and 79 then
                            'nl75'
                           when fun_get_agebycsrqandywrq(a.dt_csrq, a.dt_swrq) between 80 and 84 then
                            'nl80'
                           when fun_get_agebycsrqandywrq(a.dt_csrq, a.dt_swrq) >= 85 then
                            'nl85'
                         end nld
                    from zjmb_sw_bgk a, t_icd10_cc c
                   where a.vc_gbsy = c.icd10_code
                     and a.vc_bgklb = '0'
                     and a.vc_shbz in ('8', '7', '6', '5', '3')
                     and a.vc_scbz = '2'
                     </if>
                     <if if(StringUtils.isNotBlank(#{vc_hks}))>
                         and a.vc_hksdm = #{vc_hks}
                     </if>
                     <if if(StringUtils.isNotBlank(#{vc_hkqx}))>
                         and a.vc_hkqxdm = #{vc_hkqx}
                     </if>
                     <if if(StringUtils.isNotBlank(#{dt_jzsj_ks}))>
                         and a.dt_swrq >= std(#{dt_jzsj_ks},1)
                     </if>
                     <if if(StringUtils.isNotBlank(#{dt_jzsj_js}))>
                         and a.dt_swrq <= std(#{dt_jzsj_js},1)
                     </if>
                     <if if(StringUtils.isNotBlank(#{dt_lrsj_ks}))>
                         and a.dt_cjsj >= std(#{dt_lrsj_ks},1)
                     </if>
                     <if if(StringUtils.isNotBlank(#{dt_lrsj_js}))>
                         and a.dt_cjsj <= std(#{dt_lrsj_js},1)
                     </if>
                     <if if(StringUtils.isNotBlank(#{xb}))>
                         and a.vc_xb = #{xb}
                     </if>
                     <if if("2".equals(#{hjlx}))>
                         and exists(select 1 from p_xzdm xzdm where a.vc_hkjddm = xzdm.dm and xzdm.csbz = '城市')
                     </if>
                     <if if("3".equals(#{hjlx}))>
                         and exists(select 1 from p_xzdm xzdm where a.vc_hkjddm = xzdm.dm and xzdm.csbz = '农村')
                     </if>
                     <if if(1 == 1)>)
           group by ccd_code) b
   where a.ccd_code = b.ccd_code(+))
select *
  from (select ccd_code,
               ccd_name,
               ordernum,
               nlhj,
               nl0,
               nl1,
               nl5,
               nl10,
               nl15,
               nl20,
               nl25,
               nl30,
               nl35,
               nl40,
               nl45,
               nl50,
               nl55,
               nl60,
               nl65,
               nl70,
               nl75,
               nl80,
               nl85
          from tab
        union all
        select '1',
               '总计',
               '1',
               sum(nlhj),
               sum(nl0),
               sum(nl1),
               sum(nl5),
               sum(nl10),
               sum(nl15),
               sum(nl20),
               sum(nl25),
               sum(nl30),
               sum(nl35),
               sum(nl40),
               sum(nl45),
               sum(nl50),
               sum(nl55),
               sum(nl60),
               sum(nl65),
               sum(nl70),
               sum(nl75),
               sum(nl80),
               sum(nl85)
          from tab
         where exists
         (select 1 from t_icd10_cc c where tab.ccd_code = c.ccd_pcode)
        union all
        select '110',
               '人口数',
               '110',
               to_number(max(decode(#{xb}, '1', vc_nhj, '2', vc_vhj, vc_zhj))),
               to_number(max(vc_0nld)),
               to_number(max(vc_1nld)),
               to_number(max(vc_5nld)),
               to_number(max(vc_10nld)),
               to_number(max(vc_15nld)),
               to_number(max(vc_20nld)),
               to_number(max(vc_25nld)),
               to_number(max(vc_30nld)),
               to_number(max(vc_35nld)),
               to_number(max(vc_40nld)),
               to_number(max(vc_45nld)),
               to_number(max(vc_50nld)),
               to_number(max(vc_55nld)),
               to_number(max(vc_60nld)),
               to_number(max(vc_65nld)),
               to_number(max(vc_70nld)),
               to_number(max(vc_75nld)),
               to_number(max(vc_80nld)),
               to_number(max(vc_85nld))
          from zjmb_rkglb
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
         </if>)
 order by to_number(ordernum)                                                        