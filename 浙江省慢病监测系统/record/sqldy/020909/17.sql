with tab as
 (select t.vc_bgdw yljg,
         sum(case  
               when (instr(t.vc_zdyh,'5') > 0 or instr(t.vc_zdyh,'6') > 0
                    or instr(t.vc_zdyh,'7') >0 or instr(t.vc_zdyh,'8') > 0)  then
                1
               else
                0
             end) mv,
         count(1) bks,
         sum(case
               when  t.vc_zdyh='10' then
                1
               else
                0
             end) swbfs,
         sum(case
               when t.vc_bgkzt = '7' then
                1
               else
                0
             end) swbks,
         sum(case
               when instr(t.vc_icd10,'C26') > 0 or instr(t.vc_icd10,'C39') > 0
               or instr(t.vc_icd10,'C48') > 0 or instr(t.vc_icd10,'C76') > 0 
               or instr(t.vc_icd10,'C77') > 0 or instr(t.vc_icd10,'C77') > 0 
               or instr(t.vc_icd10,'C78') > 0 or instr(t.vc_icd10,'C79') > 0
               or instr(t.vc_icd10,'C80') > 0 then
                1
               else
                0
             end) uos
    from zjjk_zl_bgk t, zjjk_zl_hzxx t1
   where t.vc_hzid = t1.vc_personid
     and t.vc_scbz = '0'
     and t.vc_shbz in ('3', '5', '6', '7', '8')
     and t.vc_bgkzt in ('0', '2', '6', '7')  
    <if if("1".equals(#{bblx}))>
     and to_char(t.dt_sczdrq,'yyyy') = #{bbqh}
    </if>
    <if if("2".equals(#{bblx}))>
     and to_char(t.dt_sczdrq,'yyyymm')  >=  to_number(#{bbqh_s})
     and to_char(t.dt_sczdrq,'yyyymm')  <=  to_number(#{bbqh_e})
    </if> 
    <if if("3".equals(#{bblx}))>
     and to_char(t.dt_sczdrq,'yyyymm') = to_number(#{bbqh})
    </if>
   group by t.vc_bgdw)
select dm,
       mc,
       mv,
       dco,
       mi,
       uo
  from (select a.dm,
               a.mc,
               b.mv mv,
               round(100 * b.swbfs / decode(b.bks, 0, null, b.bks), 2) dco,
               round(100 * b.swbks / decode(b.bks, 0, null, b.bks), 2) mi,
               round(100 * b.uos / decode(b.bks, 0, null, b.bks), 2) uo,  
               0 sort
          from tab b, (select dm, mc from p_yljg where dm like substr(#{sjdwdm}, 1, 6)||'%' and lb <> 'J1') a
         where b.yljg(+) = a.dm
        union all
        select '合计',
               '合计',
               sum(mv) mv,
               round(100 * sum(swbfs) /
                     decode(sum(bks), 0, null, sum(bks)),
                     2) dco,
               round(100 * sum(swbks) /
                     decode(sum(bks), 0, null, sum(bks)),
                     2) mi,              
               round(100 * sum(uos) /
                     decode(sum(bks), 0, null, sum(bks)),
                     2) uo,            
               1 sort
          from tab)
 order by sort, dm                                                                                                                                                                                                                                