with tab as
 (select shyy,
         mc,
         hj,
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
         岁85,
         sort
    from (select t.vc_shyy shyy, count(1) hj,
                 sum(case when t.vc_nl = '0' then 1 else 0 end) 岁0,
                 sum(case when t.vc_nl in ('1', '2', '3', '4') then 1 else 0 end) 岁1,
                 sum(case when t.vc_nl in ('5', '6', '7', '8', '9') then 1 else 0 end) 岁5,
                 sum(case when t.vc_nl in ('10', '11', '12', '13', '14') then 1 else 0 end) 岁10,
                 sum(case when t.vc_nl in ('15', '16', '17', '18', '19') then 1 else 0 end) 岁15,
                 sum(case when t.vc_nl in ('20', '21', '22', '23', '24') then 1 else 0 end) 岁20,
                 sum(case when t.vc_nl in ('25', '26', '27', '28', '29') then 1 else 0 end) 岁25,
                 sum(case when t.vc_nl in ('30', '31', '32', '33', '34') then 1 else 0 end) 岁30,
                 sum(case when t.vc_nl in ('35', '36', '37', '38', '39') then 1 else 0 end) 岁35,
                 sum(case when t.vc_nl in ('40', '41', '42', '43', '44') then 1 else 0 end) 岁40,
                 sum(case when t.vc_nl in ('45', '46', '47', '48', '49') then 1 else 0 end) 岁45,
                 sum(case when t.vc_nl in ('50', '51', '52', '53', '54') then 1 else 0 end) 岁50,
                 sum(case when t.vc_nl in ('55', '56', '57', '58', '59') then 1 else 0 end) 岁55,
                 sum(case when t.vc_nl in ('60', '61', '62', '63', '64') then 1 else 0 end) 岁60,
                 sum(case when t.vc_nl in ('65', '66', '67', '68', '69') then 1 else 0 end) 岁65,
                 sum(case when t.vc_nl in ('70', '71', '72', '73', '74') then 1 else 0 end) 岁70,
                 sum(case when t.vc_nl in ('75', '76', '77', '78', '79') then 1 else 0 end) 岁75,
                 sum(case when t.vc_nl in ('80', '81', '82', '83', '84') then 1 else 0 end) 岁80,
                 sum(case when length(t.vc_nl) >= 2 and t.vc_nl >= 85 then 1 else 0 end) 岁85
            from zjmb_shjc_bgk t
           where t.vc_scbz = '0'
             and t.vc_shbz in ('3', '5', '6', '7', '8')
             and t.vc_bgkzt = '0'
             and exists(select 1 from p_yljg_jgsx t1 where t.vc_cjdwdm = t1.jgdm and t1.jgsx = 'sjshjc' and (t1.jgdm = #{vc_sjjg} or #{vc_sjjg} is null))
             <if if(StringUtils.isNotBlank(#{dt_jzsj_ks}))>
               and t.dt_jzrq >= std(#{dt_jzsj_ks},1)
             </if>
             <if if(StringUtils.isNotBlank(#{dt_jzsj_js}))>
               and t.dt_jzrq <= std(#{dt_jzsj_js},1)
             </if>
             <if if(StringUtils.isNotBlank(#{dt_lrsj_ks}))>
               and t.dt_cjsj >= std(#{dt_lrsj_ks},1)
             </if>
             <if if(StringUtils.isNotBlank(#{dt_lrsj_js}))>
               and t.dt_cjsj <= std(#{dt_lrsj_js},1)
             </if>
             <if if(StringUtils.isNotBlank(#{xb}))>
               and t.vc_xb = #{xb}
             </if>
             <if if("1".equals(#{sfgy}))>
               and substr(t.vc_shwbyy, 1, 3) in ('X60','X61','X62','X63','X64','X65','X66','X67','X68','X69','X70','X71','X72','X73','X74','X75','X76','X77','X78','X79','X80','X81','X82','X83','X84','X85','X86','X87','X88','X89','X90','X91','X92','X93','X94','X95','X96','X97','X98','X99','Y00','Y01','Y02','Y03','Y04') 
             </if>
           group by t.vc_shyy) a,
         (select 'A' dm, '交通伤' mc, 1 sort
            from dual
          union
          select 'C' dm, '跌伤坠落' mc, 2 sort
            from dual
          union
          select 'D' dm, '钝器伤' mc, 3 sort
            from dual
          union
          select 'E' dm, '刺割伤' mc, 4 sort
            from dual
          union
          select 'F' dm, '动物伤' mc, 5 sort
            from dual
          union
          select 'G' dm, '烧烫伤' mc, 6 sort
            from dual
          union
          select 'H' dm, '窒息/溺水' mc, 7 sort
            from dual
          union
          select 'B' dm, '性侵犯' mc, 8 sort
            from dual
          union
          select 'I' dm, '中毒' mc, 9 sort
            from dual
          union
          select 'J' dm, '其他' mc, 10 sort
            from dual
          union
          select 'K' dm, '不详' mc, 11 sort
            from dual) b
   where b.dm = a.shyy(+))
select shyy,
       mc,
       hj,
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
  from (select shyy,
               mc,
               hj,
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
               岁85,
               sort
          from tab
        union all
        select '合计',
               '合计',
               sum(hj),
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
               sum(岁85),
               999999 sort
          from tab)
 order by sort                                                                                                                                   