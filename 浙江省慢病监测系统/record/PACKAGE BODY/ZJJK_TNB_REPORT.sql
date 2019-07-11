create or replace package body      ZJJK_TNB_REPORT is

  --分性别疾病地区统计表
  Procedure Proc_Zjjk_fxbjblxdqtjb(bkstart_date varchar2,bkend_date varchar2,
                                lrstart_date varchar2,lrend_date varchar2,
                                fbstart_date varchar2,fbend_date varchar2,
                                jddm varchar2,usertype varchar2,myrc out ZJJK_MYCUR.myrctype) is
    sqlstr varchar2(1000);
  begin
    delete from temp_zjjk_report;
    commit;
    if usertype='qjk' then
      for x in (  select t1.jdmc,
                       nvl(sum(case when t1.vc_hzxb='1' and t1.vc_tnblx=1 then t1.ct  end),0) as nan1,
                       nvl(sum(case when t1.vc_hzxb='1' and t1.vc_tnblx=2 then t1.ct  end),0) as nan2,
                       nvl(sum(case when t1.vc_hzxb='1' and t1.vc_tnblx=3 then t1.ct  end),0) as nan3,
                       nvl(sum(case when t1.vc_hzxb='1' and t1.vc_tnblx=4 then t1.ct  end),0) as nan4,
                       nvl(sum(case when t1.vc_hzxb='1' and t1.vc_tnblx=5 then t1.ct  end),0) as nan5,
                       nvl(sum(case when t1.vc_hzxb='2' and t1.vc_tnblx=1 then t1.ct  end),0) as nv1,
                       nvl(sum(case when t1.vc_hzxb='2' and t1.vc_tnblx=2 then t1.ct  end),0) as nv2,
                       nvl(sum(case when t1.vc_hzxb='2' and t1.vc_tnblx=3 then t1.ct  end),0) as nv3,
                       nvl(sum(case when t1.vc_hzxb='2' and t1.vc_tnblx=4 then t1.ct  end),0) as nv4,
                       nvl(sum(case when t1.vc_hzxb='2' and t1.vc_tnblx=5 then t1.ct  end),0) as nv5
                     from (select x.vc_tnblx,x.vc_hzxb, x.vc_hkjd,(select a.name from code_info a where a.code_info_id = 1050 and a.code = x.vc_hkjd) as jdmc,count(1) as ct
                        from (select u.vc_hzxb, u.vc_hks, u.vc_hkqx, u.vc_hkjd, t.vc_tnblx
                        from zjjk_tnb_bgk t, zjjk_tnb_hzxx u
                     where t.vc_hzid = u.vc_personid and t.vc_shbz in ('3','5','6','7','8') and t.vc_scbz='0' and t.vc_bgkzt in ('0','2','6','7')
                     and t.dt_bgrq>=to_date(nvl(bkstart_date,'2000-01-01'),'yyyy-mm-dd') and t.dt_bgrq<=to_date(nvl(bkend_date,'2099-01-01'),'yyyy-mm-dd')
                     and t.dt_cjsj>=to_date(nvl(lrstart_date,'2000-01-01'),'yyyy-mm-dd') and t.dt_cjsj<=to_date(nvl(lrend_date,'2099-01-01'),'yyyy-mm-dd')
                     and t.dt_sczdrq>=to_date(nvl(fbstart_date,'1000-01-01'),'yyyy-mm-dd') and t.dt_sczdrq<=to_date(nvl(fbend_date,'2099-01-01'),'yyyy-mm-dd')
                     and substr(u.vc_hkjd,0,6) = substr(jddm,0,6) ) x
                     group by x.vc_tnblx, x.vc_hzxb, x.vc_hkjd ) t1 where t1.jdmc is not null group by t1.jdmc) loop
        sqlstr := 'INSERT INTO TEMP_ZJJK_REPORT tb (A,B,C,D,E,F,G,H,I,J,K) VALUES ('''||x.jdmc||''',
                '''||x.nan1||''', '''||x.nan2||''','''||x.nan3||''','''||x.nan4||''', '''||x.nan5||''',
                '''||x.nv1||''',  '''||x.nv2||''', '''||x.nv3||''','''||x.nv4||''',  '''||x.nv5||''')';
        execute immediate(sqlstr);
    end loop;
    elsif usertype = 'sjk' then
      for x in (select t1.jdmc,
                       nvl(sum(case when t1.vc_hzxb='1' and t1.vc_tnblx=1 then t1.ct  end),0) as nan1,
                       nvl(sum(case when t1.vc_hzxb='1' and t1.vc_tnblx=2 then t1.ct  end),0) as nan2,
                       nvl(sum(case when t1.vc_hzxb='1' and t1.vc_tnblx=3 then t1.ct  end),0) as nan3,
                       nvl(sum(case when t1.vc_hzxb='1' and t1.vc_tnblx=4 then t1.ct  end),0) as nan4,
                       nvl(sum(case when t1.vc_hzxb='1' and t1.vc_tnblx=5 then t1.ct  end),0) as nan5,
                       nvl(sum(case when t1.vc_hzxb='2' and t1.vc_tnblx=1 then t1.ct  end),0) as nv1,
                       nvl(sum(case when t1.vc_hzxb='2' and t1.vc_tnblx=2 then t1.ct  end),0) as nv2,
                       nvl(sum(case when t1.vc_hzxb='2' and t1.vc_tnblx=3 then t1.ct  end),0) as nv3,
                       nvl(sum(case when t1.vc_hzxb='2' and t1.vc_tnblx=4 then t1.ct  end),0) as nv4,
                       nvl(sum(case when t1.vc_hzxb='2' and t1.vc_tnblx=5 then t1.ct  end),0) as nv5
                     from (select x.vc_tnblx,x.vc_hzxb, x.vc_hkqx,(select a.name from code_info a where a.code_info_id = 1049 and a.code = x.vc_hkqx) as jdmc,count(1) as ct
                        from (select u.vc_hzxb, u.vc_hks, u.vc_hkqx, u.vc_hkjd, t.vc_tnblx
                        from zjjk_tnb_bgk t, zjjk_tnb_hzxx u
                     where t.vc_hzid = u.vc_personid and t.vc_shbz in ('3','5','6','7','8') and t.vc_scbz='0'and t.vc_bgkzt in ('0','2','6','7')
                     and t.dt_bgrq>=to_date(nvl(bkstart_date,'2000-01-01'),'yyyy-mm-dd') and t.dt_bgrq<=to_date(nvl(bkend_date,'2099-01-01'),'yyyy-mm-dd')
                     and t.dt_cjsj>=to_date(nvl(lrstart_date,'2000-01-01'),'yyyy-mm-dd') and t.dt_cjsj<=to_date(nvl(lrend_date,'2099-01-01'),'yyyy-mm-dd')
                     and t.dt_sczdrq>=to_date(nvl(fbstart_date,'2000-01-01'),'yyyy-mm-dd') and t.dt_sczdrq<=to_date(nvl(fbend_date,'2099-01-01'),'yyyy-mm-dd')
                     and substr(u.vc_hkjd,0,4) = substr(jddm,0,4) ) x
                     group by x.vc_tnblx, x.vc_hzxb, x.vc_hkqx ) t1 where t1.jdmc is not null group by t1.jdmc) loop
        sqlstr := 'INSERT INTO TEMP_ZJJK_REPORT tb (A,B,C,D,E,F,G,H,I,J,K) VALUES ('''||x.jdmc||''',
                '''||x.nan1||''', '''||x.nan2||''','''||x.nan3||''','''||x.nan4||''', '''||x.nan5||''',
                '''||x.nv1||''',  '''||x.nv2||''', '''||x.nv3||''','''||x.nv4||''',  '''||x.nv5||''')';
        execute immediate(sqlstr);
    end loop;
    elsif usertype = 'zjjk' then
      for x in (select t1.jdmc,
                       nvl(sum(case when t1.vc_hzxb='1' and t1.vc_tnblx=1 then t1.ct  end),0) as nan1,
                       nvl(sum(case when t1.vc_hzxb='1' and t1.vc_tnblx=2 then t1.ct  end),0) as nan2,
                       nvl(sum(case when t1.vc_hzxb='1' and t1.vc_tnblx=3 then t1.ct  end),0) as nan3,
                       nvl(sum(case when t1.vc_hzxb='1' and t1.vc_tnblx=4 then t1.ct  end),0) as nan4,
                       nvl(sum(case when t1.vc_hzxb='1' and t1.vc_tnblx=5 then t1.ct  end),0) as nan5,
                       nvl(sum(case when t1.vc_hzxb='2' and t1.vc_tnblx=1 then t1.ct  end),0) as nv1,
                       nvl(sum(case when t1.vc_hzxb='2' and t1.vc_tnblx=2 then t1.ct  end),0) as nv2,
                       nvl(sum(case when t1.vc_hzxb='2' and t1.vc_tnblx=3 then t1.ct  end),0) as nv3,
                       nvl(sum(case when t1.vc_hzxb='2' and t1.vc_tnblx=4 then t1.ct  end),0) as nv4,
                       nvl(sum(case when t1.vc_hzxb='2' and t1.vc_tnblx=5 then t1.ct  end),0) as nv5
                     from (select x.vc_tnblx,x.vc_hzxb, x.vc_hks,(select a.name from code_info a where a.code_info_id = 1048 and a.code = x.vc_hks) as jdmc,count(1) as ct
                        from (select u.vc_hzxb, u.vc_hks, u.vc_hkqx, u.vc_hkjd, t.vc_tnblx
                        from zjjk_tnb_bgk t, zjjk_tnb_hzxx u
                     where 1=1 and t.vc_hzid = u.vc_personid and t.vc_shbz in ('3','5','6','7','8') and t.vc_scbz='0' and t.vc_bgkzt in ('0','2','6','7')
                     and t.dt_bgrq>=to_date(nvl(bkstart_date,'2000-01-01'),'yyyy-mm-dd') and t.dt_bgrq<=to_date(nvl(bkend_date,'2099-01-01'),'yyyy-mm-dd')
                     and t.dt_cjsj>=to_date(nvl(lrstart_date,'2000-01-01'),'yyyy-mm-dd') and t.dt_cjsj<=to_date(nvl(lrend_date,'2099-01-01'),'yyyy-mm-dd')
                     and t.dt_sczdrq>=to_date(nvl(fbstart_date,'1000-01-01'),'yyyy-mm-dd') and t.dt_sczdrq<=to_date(nvl(fbend_date,'2099-01-01'),'yyyy-mm-dd')
                     ) x
                     group by x.vc_tnblx, x.vc_hzxb, x.vc_hks ) t1 where t1.jdmc is not null group by t1.jdmc) loop
        sqlstr := 'INSERT INTO TEMP_ZJJK_REPORT tb (A,B,C,D,E,F,G,H,I,J,K) VALUES ('''||x.jdmc||''',
                '''||x.nan1||''', '''||x.nan2||''','''||x.nan3||''','''||x.nan4||''', '''||x.nan5||''',
                '''||x.nv1||''',  '''||x.nv2||''', '''||x.nv3||''','''||x.nv4||''',  '''||x.nv5||''')';
        execute immediate(sqlstr);
    end loop;
    end if;


    --添加合计
    sqlstr := ' insert into temp_zjjk_report(a,b,c,d,e,f,g,h,i,j,k) select a,b,c,d,e,f,g,h,i,j,k from (
                    select ''合计'' as A,sum(t.b)b,sum(t.c)c,sum(d)d,sum(e)e,sum(f)f,sum(g)g,sum(h)h,sum(i)i,sum(j)j,sum(k)k from temp_zjjk_report t) ';
    execute immediate(sqlstr);
    commit;


  open myrc for select * from temp_zjjk_report t; --order by to_number(t.b);

  end;

  --------------------------------------------------------------------------------------------------------

  --糖尿病-----分年龄年龄统计表
  Procedure Proc_Zjjk_fbsnltjb(bkstart_date varchar2,bkend_date varchar2,
                                lrstart_date varchar2,lrend_date varchar2,
                                fbstart_date varchar2,fbend_date varchar2,
                                jddm varchar2,usertype varchar2,myrc out ZJJK_MYCUR.myrctype) is
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
       select      substr(xx.vc_hkjd,0,in_street_len) title,
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
             select GetAgeRangZero(a.dt_hzcsrq,b.dt_sczdrq) nl,a.vc_hkjd
               from zjjk_tnb_hzxx a, zjjk_tnb_bgk b
               where a.vc_personid = b.vc_hzid
                  and b.vc_shbz in ('3','5','6','7','8')
                  and b.vc_bgkzt in ('0','2','6','7')
                  and b.vc_scbz='0'
                  and a.vc_hkjd like ''||in_type||'%'
                  and b.dt_bgrq>=to_date(nvl(bkstart_date,'2000-01-01'),'yyyy-mm-dd') and b.dt_bgrq<=to_date(nvl(bkend_date,'2099-01-01'),'yyyy-mm-dd')
                  and b.dt_cjsj>=to_date(nvl(lrstart_date,'2000-01-01'),'yyyy-mm-dd') and b.dt_cjsj<=to_date(nvl(lrend_date,'2099-01-01'),'yyyy-mm-dd')
                  and b.dt_sczdrq>=to_date(nvl(fbstart_date,'1000-01-01'),'yyyy-mm-dd') and b.dt_sczdrq<=to_date(nvl(fbend_date,'2099-01-01'),'yyyy-mm-dd')
                  ) xx group by substr(xx.vc_hkjd,0,in_street_len)
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


end ZJJK_TNB_REPORT;

