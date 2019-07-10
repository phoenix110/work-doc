with tab as
 (select t1.vc_hksdm xzdm,
         sum(case  
               when (instr(t.vc_zdyh,'5') > 0 or instr(t.vc_zdyh,'6') > 0
                    or instr(t.vc_zdyh,'7') >0 or instr(t.vc_zdyh,'8') > 0) 
                    and instr(t.vc_zdyh,'9') < 1 and instr(t.vc_zdyh,'10') < 1 then
                1
               else
                0
             end) bls,
         count(1) zdyhs,
         sum(case
               when instr(t.vc_zdyh, '1') > 0 and instr(t.vc_zdyh, '2') > 0  
                    and instr(t.vc_zdyh, '5') < 1 and instr(t.vc_zdyh, '6') < 1
                    and instr(t.vc_zdyh, '7') < 1 and instr(t.vc_zdyh, '8') < 1 
                    and instr(t.vc_zdyh, '9') < 1 and instr(t.vc_zdyh, '10') < 1 then
                1
               else
                0
             end) lclhs,
         sum(case
               when t.vc_zdyh = '1' then
                1
               else
                0
             end) lcs,
         sum(case
               when instr(t.vc_zdyh, '10') > 0 then
                1
               else
                0
             end) swbfs,
         sum(case
               when instr(t.vc_zdyh, '9') > 0 and instr(t.vc_zdyh, '10') < 1 then
                1
               else
                0
             end) bxs
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
   group by t1.vc_hksdm)
select dm,
       mc,
       病理,
       临床理化,
       临床,
       死亡补发病,
       不详
  from (select a.dm,
               a.mc,
               b.bls 病理,
               b.lclhs 临床理化,
               b.lcs 临床,
               b.swbfs 死亡补发病,
               b.bxs 不详,  
               0 sort
          from tab b, p_xzdm a
         where b.xzdm(+) = a.dm
           and a.sjid = '33000000'
        union all
        select '合计',
               '合计',
               sum(bls),
               sum(lclhs),
               sum(lcs),               
               sum(swbfs),             
               sum(bxs),
               1 sort
          from tab)
 order by sort, dm                                                                                                                                                                                                            