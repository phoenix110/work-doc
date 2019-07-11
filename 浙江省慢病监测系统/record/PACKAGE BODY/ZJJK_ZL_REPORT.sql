create or replace package body ZJJK_ZL_REPORT is

  --肿瘤-----分部位年龄统计表
  Procedure Proc_Zjjk_fxbjblxdqtjb(bkstart_date varchar2,bkend_date varchar2,
                                lrstart_date varchar2,lrend_date varchar2,
                                fbstart_date varchar2,fbend_date varchar2,
                                jddm varchar2,usertype varchar2,sex varchar2,myrc out ZJJK_MYCUR.myrctype) is
    sqlstr varchar2(1000);
    in_type varchar2(10);
  begin
    delete from TEMP_ZJJK_REPORT;
    commit;
    if usertype='qjk' then
      in_type := substr(jddm,0,6);
    elsif usertype='sjk' then
      in_type := substr(jddm,0,4);
    elsif usertype='zjjk' then
      in_type := substr(jddm,0,2);
    end if;

      for x in (
          select distinct tt.ct_name,uu.a,uu.b,uu.c,uu.d,uu.e,uu.f,uu.g,uu.h,uu.i,uu.j,uu.k,uu.l,uu.m,uu.n,uu.o,uu.p,uu.q,uu.r,
                tt.dis_order from zjjk_zl_icd_rela tt
       left join
       (select      xx.title,xx.dispord,
                    nvl(sum(case xx.nl when '0～' then 1 end),0) as a,
                    nvl(sum(case xx.nl when '5～' then 1 end),0) as b ,
                    nvl(sum(case xx.nl when '10～' then 1 end),0) as c,
                    nvl(sum(case xx.nl when '15～' then 1 end),0) as d,
                    nvl(sum(case xx.nl when '20～' then 1 end),0) as e,
                    nvl(sum(case xx.nl when '25～' then 1 end),0) as f,
                    nvl(sum(case xx.nl when '30～' then 1 end),0) as g,
                    nvl(sum(case xx.nl when '35～' then 1 end),0) as h,
                    nvl(sum(case xx.nl when '40～' then 1 end),0) as i,
                    nvl(sum(case xx.nl when '45～' then 1 end),0) as j,
                    nvl(sum(case xx.nl when '50～' then 1 end),0) as k,
                    nvl(sum(case xx.nl when '55～' then 1 end),0) as l,
                    nvl(sum(case xx.nl when '60～' then 1 end),0) as m,
                    nvl(sum(case xx.nl when '65～' then 1 end),0) as n,
                    nvl(sum(case xx.nl when '70～' then 1 end),0) as o,
                    nvl(sum(case xx.nl when '75～' then 1 end),0) as p,
                    nvl(sum(case xx.nl when '80～' then 1 end),0) as q,
                    nvl(sum(case xx.nl when '85～' then 1 end),0) as r
                       from (
            select GetAgeRangZero(a.dt_hzcsrq,b.dt_zdrq) nl, a.vc_hzxb xb, b.vc_icd10, c.ct_name title, c.dis_order dispord
               from zjjk_zl_hzxx a, zjjk_zl_bgk b, zjjk_zl_icd_rela c
               where a.vc_personid = b.vc_hzid
                  and substr(b.vc_icd10, 0, 3) = c.idc_code
                  and b.vc_shbz in ('3','5','6','7','8')
                  and b.vc_bgkzt in ('0','2','6','7')
                  and b.vc_scbz='0'
                  and a.vc_hzxb like (decode( sex , '1' , '1', '2' , '2','3','%%'))
                  and b.dt_cjsj>=to_date(nvl(bkstart_date,'2000-01-01'),'yyyy-mm-dd') and b.dt_cjsj<=to_date(nvl(bkend_date,'2099-01-01'),'yyyy-mm-dd')
                  and b.dt_bgrq>=to_date(nvl(lrstart_date,'2000-01-01'),'yyyy-mm-dd') and b.dt_bgrq<=to_date(nvl(lrend_date,'2099-01-01'),'yyyy-mm-dd')
                  and b.dt_zdrq>=to_date(nvl(fbstart_date,'2000-01-01'),'yyyy-mm-dd') and b.dt_zdrq<=to_date(nvl(fbend_date,'2099-01-01'),'yyyy-mm-dd')
                  and a.vc_hkjddm like ''||in_type||'%'
                   ) xx group by xx.title,xx.dispord ) uu
         on tt.ct_name=uu.title order by tt.dis_order
       ) loop
        sqlstr := 'INSERT INTO TEMP_ZJJK_REPORT tb (A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S) VALUES ('''||x.ct_name||''',
                '''||x.a||''', '''||x.b||''','''||x.c||''','''||x.d||''', '''||x.e||''',
                '''||x.f||''', '''||x.g||''','''||x.h||''','''||x.i||''', '''||x.j||''',
                '''||x.k||''', '''||x.l||''','''||x.m||''','''||x.n||''', '''||x.o||''',
                '''||x.p||''',  '''||x.q||''', '''||x.r||''')';
        execute immediate(sqlstr);
    end loop;

    --添加合计
    sqlstr := ' insert into temp_zjjk_report(A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S)
                    select ''合计'' as A,sum(b)b,sum(c)c,sum(d)d,sum(e)e,sum(f)f,sum(g)g,
                                         sum(h)h,sum(i)i,sum(j)j,sum(k)k,
                                         sum(l)l,sum(m)m,sum(n)n,sum(o)o,sum(p)p,sum(q)q,sum(r)r,sum(s)s
                         from temp_zjjk_report t ';
    execute immediate(sqlstr);
    commit;


  open myrc for select * from temp_zjjk_report t; --order by to_number(t.b);

  end;

  --------------------------------------------------------------------------------------------------------

  --肿瘤-----分年龄年龄统计表
  Procedure Proc_Zjjk_fbsnltjb(bkstart_date varchar2,bkend_date varchar2,
                                lrstart_date varchar2,lrend_date varchar2,
                                fbstart_date varchar2,fbend_date varchar2,
                                jddm varchar2,usertype varchar2,sex varchar2,myrc out ZJJK_MYCUR.myrctype) is
    sqlstr varchar2(1000);
    in_type varchar2(10);
    in_street_len number(2);
  begin
    delete from temp_zjjk_report;
    commit;
    if usertype='qjk' then
      in_type := substr(jddm,0,6);
      in_street_len := 8;
    elsif usertype='sjk' then
      in_type := substr(jddm,0,4);
      in_street_len := 6;
    elsif usertype='zjjk' then
      in_type := substr(jddm,0,2);
      in_street_len := 4;
    end if;
      for x in (
       select      substr(xx.vc_hkjddm,0,in_street_len) title,
                    nvl(sum(case xx.nl when '0～' then 1 end),0) as a,
                    nvl(sum(case xx.nl when '5～' then 1 end),0) as b ,
                    nvl(sum(case xx.nl when '10～' then 1 end),0) as c,
                    nvl(sum(case xx.nl when '15～' then 1 end),0) as d,
                    nvl(sum(case xx.nl when '20～' then 1 end),0) as e,
                    nvl(sum(case xx.nl when '25～' then 1 end),0) as f,
                    nvl(sum(case xx.nl when '30～' then 1 end),0) as g,
                    nvl(sum(case xx.nl when '35～' then 1 end),0) as h,
                    nvl(sum(case xx.nl when '40～' then 1 end),0) as i,
                    nvl(sum(case xx.nl when '45～' then 1 end),0) as j,
                    nvl(sum(case xx.nl when '50～' then 1 end),0) as k,
                    nvl(sum(case xx.nl when '55～' then 1 end),0) as l,
                    nvl(sum(case xx.nl when '60～' then 1 end),0) as m,
                    nvl(sum(case xx.nl when '65～' then 1 end),0) as n,
                    nvl(sum(case xx.nl when '70～' then 1 end),0) as o,
                    nvl(sum(case xx.nl when '75～' then 1 end),0) as p,
                    nvl(sum(case xx.nl when '80～' then 1 end),0) as q,
                    nvl(sum(case xx.nl when '85～' then 1 end),0) as r
                       from (
             select GetAgeRangZero(a.dt_hzcsrq,b.dt_zdrq) nl,a.vc_hkjddm
               from zjjk_zl_hzxx a, zjjk_zl_bgk b
               where a.vc_personid = b.vc_hzid
                  and exists (select 1 from zjjk_zl_icd_rela x where substr(b.vc_icd10,0,3) = x.idc_code)
                  and b.vc_shbz in ('3','5','6','7','8')
                  and b.vc_bgkzt in ('0','2','6','7')
                  and b.vc_scbz='0'
                  and a.vc_hkjddm like ''||in_type||'%'
                  and b.dt_cjsj>=to_date(nvl(bkstart_date,'2000-01-01'),'yyyy-mm-dd') and b.dt_cjsj<=to_date(nvl(bkend_date,'2099-01-01'),'yyyy-mm-dd')
                  and b.dt_bgrq>=to_date(nvl(lrstart_date,'2000-01-01'),'yyyy-mm-dd') and b.dt_bgrq<=to_date(nvl(lrend_date,'2099-01-01'),'yyyy-mm-dd')
                  and b.dt_zdrq>=to_date(nvl(fbstart_date,'2000-01-01'),'yyyy-mm-dd') and b.dt_zdrq<=to_date(nvl(fbend_date,'2099-01-01'),'yyyy-mm-dd')
                  ) xx group by substr(xx.vc_hkjddm,0,in_street_len)
       ) loop
        sqlstr := 'INSERT INTO TEMP_ZJJK_REPORT tb (A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S) VALUES ('''||x.title||''',
                '''||x.a||''', '''||x.b||''','''||x.c||''','''||x.d||''', '''||x.e||''',
                '''||x.f||''', '''||x.g||''','''||x.h||''','''||x.i||''', '''||x.j||''',
                '''||x.k||''', '''||x.l||''','''||x.m||''','''||x.n||''', '''||x.o||''',
                '''||x.p||''',  '''||x.q||''', '''||x.r||''')';
        execute immediate(sqlstr);
    end loop;

    --添加合计
    sqlstr := ' insert into temp_zjjk_report(A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S)
                    select ''合计'' as A,sum(b)b,sum(c)c,sum(d)d,sum(e)e,sum(f)f,sum(g)g,
                                         sum(h)h,sum(i)i,sum(j)j,sum(k)k,
                                         sum(l)l,sum(m)m,sum(n)n,sum(o)o,sum(p)p,sum(q)q,sum(r)r,sum(s)s
                         from temp_zjjk_report t ';
    execute immediate(sqlstr);
    commit;


  --open myrc for select * from temp_zjjk_report t;
    if usertype='qjk' then
      open myrc for select nvl((select ff.name from code_info ff where ff.code_info_id=1050 and ff.code=t.a),'合计'),
       t.b,t.c,t.d,t.e,t.f,t.g,t.h,t.i,t.j,t.k,t.l,t.m,t.n,t.o,t.p,t.q,t.r,t.s from temp_zjjk_report t;
    elsif usertype='sjk' then
      open myrc for select nvl((select ff.name from code_info ff where ff.code_info_id=1049 and substr(ff.code,0,6)=t.a),'合计'),
       t.b,t.c,t.d,t.e,t.f,t.g,t.h,t.i,t.j,t.k,t.l,t.m,t.n,t.o,t.p,t.q,t.r,t.s from temp_zjjk_report t;
    elsif usertype='zjjk' then
      open myrc for select nvl((select ff.name from code_info ff where ff.code_info_id=1048 and substr(ff.code,0,4)=t.a),'合计'),
       t.b,t.c,t.d,t.e,t.f,t.g,t.h,t.i,t.j,t.k,t.l,t.m,t.n,t.o,t.p,t.q,t.r,t.s from temp_zjjk_report t;
    end if;

  end;

  --------------------------------------------------------------------------------------------------------


end ZJJK_ZL_REPORT;

