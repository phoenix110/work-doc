create or replace package body ZJJK_XNXG_REPORT is

  --冠心病发病报告发病数-分性别疾病地区统计表
  Procedure Proc_Zjjk_Gxbfxbjbdqtjb(bkstart_date varchar2,bkend_date varchar2,
                                lrstart_date varchar2,lrend_date varchar2,
                                fbstart_date varchar2,fbend_date varchar2,
                                jddm varchar2,usertype varchar2,myrc out ZJJK_MYCUR.myrctype) is
    sqlstr varchar2(1000);
    --cursor c_data is ;
  begin
    delete from temp_zjjk_report;
    commit;
    if usertype='qjk' then
      for x in (select t1.jdmc,
                       nvl(sum(case when t1.vc_hzxb='1' and t1.vc_gxbzd=1 then t1.ct  end),0) as nan1,
                       nvl(sum(case when t1.vc_hzxb='1' and t1.vc_gxbzd=2 then t1.ct  end),0) as nan2,
                       nvl(sum(case when t1.vc_hzxb='1' and t1.vc_gxbzd=3 then t1.ct  end),0) as nan3,
                       nvl(sum(case when t1.vc_hzxb='2' and t1.vc_gxbzd=1 then t1.ct  end),0) as nv1,
                       nvl(sum(case when t1.vc_hzxb='2' and t1.vc_gxbzd=2 then t1.ct  end),0) as nv2,
                       nvl(sum(case when t1.vc_hzxb='2' and t1.vc_gxbzd=3 then t1.ct  end),0) as nv3
                     from (select t.vc_gxbzd,
                     t.vc_hzxb, t.vc_czhkjd,
                     (select a.name from code_info a where a.code_info_id = 1050 and a.code=t.vc_czhkjd) as jdmc, count(1) as ct
                     from zjjk_xnxg_bgk t
                     where t.vc_gxbzd in ('1', '2', '3') and t.vc_shbz in ('3','5','6','7','8') and t.vc_scbz='2' and t.vc_kzt in ('0','2','6','7')
                     and t.dt_bkrq>=to_date(nvl(bkstart_date,'2000-01-01'),'yyyy-mm-dd') and t.dt_bkrq<=to_date(nvl(bkend_date,'2099-01-01'),'yyyy-mm-dd')
                     and t.dt_cjsj>=to_date(nvl(lrstart_date,'2000-01-01'),'yyyy-mm-dd') and t.dt_cjsj<=to_date(nvl(lrend_date,'2099-01-01'),'yyyy-mm-dd')
                     and t.dt_fbrq>=to_date(nvl(fbstart_date,'2000-01-01'),'yyyy-mm-dd') and t.dt_fbrq<=to_date(nvl(fbend_date,'2099-01-01'),'yyyy-mm-dd')
                     and t.vc_czhkjd like ''||substr(jddm,0,6)||'%'
                     group by t.vc_gxbzd, t.vc_hzxb, t.vc_czhkjd) t1 where t1.jdmc is not null group by t1.jdmc) loop
        sqlstr := 'INSERT INTO TEMP_ZJJK_REPORT tb (A,B,C,D,E,F,G) VALUES ('''||x.jdmc||''',
                '''||x.nan1||''', '''||x.nan2||''','''||x.nan3||''',
                '''||x.nv1||''',  '''||x.nv2||''', '''||x.nv3||''')';
        execute immediate(sqlstr);
    end loop;
    elsif usertype = 'sjk' then
      for x in (select t1.jdmc,
                       nvl(sum(case when t1.vc_hzxb='1' and t1.vc_gxbzd=1 then t1.ct  end),0) as nan1,
                       nvl(sum(case when t1.vc_hzxb='1' and t1.vc_gxbzd=2 then t1.ct  end),0) as nan2,
                       nvl(sum(case when t1.vc_hzxb='1' and t1.vc_gxbzd=3 then t1.ct  end),0) as nan3,
                       nvl(sum(case when t1.vc_hzxb='2' and t1.vc_gxbzd=1 then t1.ct  end),0) as nv1,
                       nvl(sum(case when t1.vc_hzxb='2' and t1.vc_gxbzd=2 then t1.ct  end),0) as nv2,
                       nvl(sum(case when t1.vc_hzxb='2' and t1.vc_gxbzd=3 then t1.ct  end),0) as nv3
                     from (select t.vc_gxbzd,
                     t.vc_hzxb, t.vc_czhkqx,
                     (select a.name from code_info a where a.code_info_id = 1049 and a.code=t.vc_czhkqx) as jdmc, count(1) as ct
                     from zjjk_xnxg_bgk t
                     where t.vc_gxbzd in ('1', '2', '3') and t.vc_shbz in ('3','5','6','7','8') and t.vc_scbz='2' and t.vc_kzt in ('0','2','6','7')
                     and t.dt_bkrq>=to_date(nvl(bkstart_date,'2000-01-01'),'yyyy-mm-dd') and t.dt_bkrq<=to_date(nvl(bkend_date,'2099-01-01'),'yyyy-mm-dd')
                     and t.dt_cjsj>=to_date(nvl(lrstart_date,'2000-01-01'),'yyyy-mm-dd') and t.dt_cjsj<=to_date(nvl(lrend_date,'2099-01-01'),'yyyy-mm-dd')
                     and t.dt_fbrq>=to_date(nvl(fbstart_date,'2000-01-01'),'yyyy-mm-dd') and t.dt_fbrq<=to_date(nvl(fbend_date,'2099-01-01'),'yyyy-mm-dd')
                     and t.vc_czhkjd like ''||substr(jddm,0,4)||'%'
                     group by t.vc_gxbzd, t.vc_hzxb, t.vc_czhkqx) t1 where t1.jdmc is not null group by t1.jdmc) loop
        sqlstr := 'INSERT INTO TEMP_ZJJK_REPORT tb (A,B,C,D,E,F,G) VALUES ('''||x.jdmc||''',
                '''||x.nan1||''', '''||x.nan2||''','''||x.nan3||''',
                '''||x.nv1||''',  '''||x.nv2||''', '''||x.nv3||''')';
        execute immediate(sqlstr);
    end loop;
    elsif usertype = 'zjjk' then
      for x in (select t1.jdmc,
                       nvl(sum(case when t1.vc_hzxb='1' and t1.vc_gxbzd=1 then t1.ct  end),0) as nan1,
                       nvl(sum(case when t1.vc_hzxb='1' and t1.vc_gxbzd=2 then t1.ct  end),0) as nan2,
                       nvl(sum(case when t1.vc_hzxb='1' and t1.vc_gxbzd=3 then t1.ct  end),0) as nan3,
                       nvl(sum(case when t1.vc_hzxb='2' and t1.vc_gxbzd=1 then t1.ct  end),0) as nv1,
                       nvl(sum(case when t1.vc_hzxb='2' and t1.vc_gxbzd=2 then t1.ct  end),0) as nv2,
                       nvl(sum(case when t1.vc_hzxb='2' and t1.vc_gxbzd=3 then t1.ct  end),0) as nv3
                     from (select t.vc_gxbzd,
                     t.vc_hzxb, t.vc_czhksi,
                     (select a.name from code_info a where a.code_info_id = 1048 and a.code=t.vc_czhksi )as jdmc, count(1) as ct
                     from zjjk_xnxg_bgk t
                     where t.vc_gxbzd in ('1', '2', '3') and t.vc_shbz in ('3','5','6','7','8') and t.vc_scbz='2' and t.vc_kzt in ('0','2','6','7')
                     and t.dt_bkrq>=to_date(nvl(bkstart_date,'2000-01-01'),'yyyy-mm-dd') and t.dt_bkrq<=to_date(nvl(bkend_date,'2099-01-01'),'yyyy-mm-dd')
                     and t.dt_cjsj>=to_date(nvl(lrstart_date,'2000-01-01'),'yyyy-mm-dd') and t.dt_cjsj<=to_date(nvl(lrend_date,'2099-01-01'),'yyyy-mm-dd')
                     and t.dt_fbrq>=to_date(nvl(fbstart_date,'2000-01-01'),'yyyy-mm-dd') and t.dt_fbrq<=to_date(nvl(fbend_date,'2099-01-01'),'yyyy-mm-dd')
                     group by t.vc_gxbzd, t.vc_hzxb, t.vc_czhksi) t1 where t1.jdmc is not null) loop
        sqlstr := 'INSERT INTO TEMP_ZJJK_REPORT tb (A,B,C,D,E,F,G) VALUES ('''||x.jdmc||''',
                '''||x.nan1||''', '''||x.nan2||''','''||x.nan3||''',
                '''||x.nv1||''',  '''||x.nv2||''', '''||x.nv3||''')';
        execute immediate(sqlstr);
    end loop;
    end if;


    --添加合计
    sqlstr := ' insert into temp_zjjk_report(a,b,c,d,e,f,g) select a,b,c,d,e,f,g from (
                    select ''合计'' as A,sum(t.b)b,sum(t.c)c,sum(d)d,sum(e)e,sum(f)f,sum(g)g from temp_zjjk_report t) ';
    execute immediate(sqlstr);
    commit;


  open myrc for select * from temp_zjjk_report t; --order by to_number(t.b);

  end;

  --------------------------------------------------------------------------------------------------------

  --脑卒中发病报告发病数-分疾病地区统计表
  Procedure Proc_Zjjk_Nzzfxbjbdqtjb(bkstart_date varchar2,bkend_date varchar2,
                                lrstart_date varchar2,lrend_date varchar2,
                                fbstart_date varchar2,fbend_date varchar2,
                                jddm varchar2,usertype varchar2,myrc out ZJJK_MYCUR.myrctype) is
    sqlstr varchar2(1000);
    --cursor c_data is ;
  begin
    delete from temp_zjjk_report;
    commit;
    if usertype='qjk' then
      for x in (select t1.jdmc,
                       nvl(sum(case when t1.vc_hzxb='1' and t1.vc_nczzd=1 then t1.ct  end),0) as nan1,
                       nvl(sum(case when t1.vc_hzxb='1' and t1.vc_nczzd=2 then t1.ct  end),0) as nan2,
                       nvl(sum(case when t1.vc_hzxb='1' and t1.vc_nczzd=3 then t1.ct  end),0) as nan3,
                       nvl(sum(case when t1.vc_hzxb='1' and t1.vc_nczzd=4 then t1.ct  end),0) as nan4,
                       nvl(sum(case when t1.vc_hzxb='1' and t1.vc_nczzd=5 then t1.ct  end),0) as nan5,
                       nvl(sum(case when t1.vc_hzxb='1' and t1.vc_nczzd=6 then t1.ct  end),0) as nan6,
                       nvl(sum(case when t1.vc_hzxb='2' and t1.vc_nczzd=1 then t1.ct  end),0) as nv1,
                       nvl(sum(case when t1.vc_hzxb='2' and t1.vc_nczzd=2 then t1.ct  end),0) as nv2,
                       nvl(sum(case when t1.vc_hzxb='2' and t1.vc_nczzd=3 then t1.ct  end),0) as nv3,
                       nvl(sum(case when t1.vc_hzxb='2' and t1.vc_nczzd=4 then t1.ct  end),0) as nv4,
                       nvl(sum(case when t1.vc_hzxb='2' and t1.vc_nczzd=5 then t1.ct  end),0) as nv5,
                       nvl(sum(case when t1.vc_hzxb='2' and t1.vc_nczzd=6 then t1.ct  end),0) as nv6
                     from (select t.vc_nczzd,
                     t.vc_hzxb, t.vc_czhkjd,
                     (select a.name from code_info a where a.code_info_id = 1050 and a.code=t.vc_czhkjd) as jdmc, count(1) as ct
                     from zjjk_xnxg_bgk t
                     where t.vc_nczzd in ('1', '2', '3','4','5','6') and t.vc_shbz in ('3','5','6','7','8') and t.vc_scbz='2' and t.vc_kzt in ('0','2','6','7')
                     and t.dt_cjsj>=to_date(nvl(bkstart_date,'2000-01-01'),'yyyy-mm-dd') and t.dt_cjsj<=to_date(nvl(bkend_date,'2099-01-01'),'yyyy-mm-dd')
                     and t.dt_bkrq>=to_date(nvl(lrstart_date,'2000-01-01'),'yyyy-mm-dd') and t.dt_bkrq<=to_date(nvl(lrend_date,'2099-01-01'),'yyyy-mm-dd')
                     and t.dt_fbrq>=to_date(nvl(fbstart_date,'2000-01-01'),'yyyy-mm-dd') and t.dt_fbrq<=to_date(nvl(fbend_date,'2099-01-01'),'yyyy-mm-dd')
                     and t.vc_czhkjd like ''||substr(jddm,0,6)||'%'
                     group by t.vc_nczzd, t.vc_hzxb, t.vc_czhkjd) t1 where t1.jdmc is not null group by t1.jdmc) loop
        sqlstr := 'INSERT INTO TEMP_ZJJK_REPORT tb (A,B,C,D,E,F,G,H,I,J,K,L,M) VALUES ('''||x.jdmc||''',
                '''||x.nan1||''', '''||x.nan2||''','''||x.nan3||''', '''||x.nan4||''', '''||x.nan5||''','''||x.nan6||''',
                '''||x.nv1||''',  '''||x.nv2||''', '''||x.nv3||''', '''||x.nv4||''',  '''||x.nv5||''', '''||x.nv6||''')';
        execute immediate(sqlstr);
    end loop;
    elsif usertype = 'sjk' then
      for x in (select t1.jdmc,
                       nvl(sum(case when t1.vc_hzxb='1' and t1.vc_nczzd=1 then t1.ct  end),0) as nan1,
                       nvl(sum(case when t1.vc_hzxb='1' and t1.vc_nczzd=2 then t1.ct  end),0) as nan2,
                       nvl(sum(case when t1.vc_hzxb='1' and t1.vc_nczzd=3 then t1.ct  end),0) as nan3,
                       nvl(sum(case when t1.vc_hzxb='1' and t1.vc_nczzd=4 then t1.ct  end),0) as nan4,
                       nvl(sum(case when t1.vc_hzxb='1' and t1.vc_nczzd=5 then t1.ct  end),0) as nan5,
                       nvl(sum(case when t1.vc_hzxb='1' and t1.vc_nczzd=6 then t1.ct  end),0) as nan6,
                       nvl(sum(case when t1.vc_hzxb='2' and t1.vc_nczzd=1 then t1.ct  end),0) as nv1,
                       nvl(sum(case when t1.vc_hzxb='2' and t1.vc_nczzd=2 then t1.ct  end),0) as nv2,
                       nvl(sum(case when t1.vc_hzxb='2' and t1.vc_nczzd=3 then t1.ct  end),0) as nv3,
                       nvl(sum(case when t1.vc_hzxb='2' and t1.vc_nczzd=4 then t1.ct  end),0) as nv4,
                       nvl(sum(case when t1.vc_hzxb='2' and t1.vc_nczzd=5 then t1.ct  end),0) as nv5,
                       nvl(sum(case when t1.vc_hzxb='2' and t1.vc_nczzd=6 then t1.ct  end),0) as nv6
                     from (select t.vc_nczzd,
                     t.vc_hzxb, t.vc_czhkqx,
                     (select a.name from code_info a where a.code_info_id = 1049 and a.code=t.vc_czhkqx) as jdmc, count(1) as ct
                     from zjjk_xnxg_bgk t
                     where t.vc_nczzd in ('1', '2', '3','4','5','6') and t.vc_shbz in ('3','5','6','7','8') and t.vc_scbz='2' and t.vc_kzt in ('0','2','6','7')
                     and t.dt_cjsj>=to_date(nvl(bkstart_date,'2000-01-01'),'yyyy-mm-dd') and t.dt_cjsj<=to_date(nvl(bkend_date,'2099-01-01'),'yyyy-mm-dd')
                     and t.dt_bkrq>=to_date(nvl(lrstart_date,'2000-01-01'),'yyyy-mm-dd') and t.dt_bkrq<=to_date(nvl(lrend_date,'2099-01-01'),'yyyy-mm-dd')
                     and t.dt_fbrq>=to_date(nvl(fbstart_date,'2000-01-01'),'yyyy-mm-dd') and t.dt_fbrq<=to_date(nvl(fbend_date,'2099-01-01'),'yyyy-mm-dd')
                     and t.vc_czhkqx like ''||substr(jddm,0,4)||'%'
                     group by t.vc_nczzd, t.vc_hzxb, t.vc_czhkqx) t1 where t1.jdmc is not null group by t1.jdmc) loop
        sqlstr := 'INSERT INTO TEMP_ZJJK_REPORT tb (A,B,C,D,E,F,G,H,I,J,K,L,M) VALUES ('''||x.jdmc||''',
                '''||x.nan1||''', '''||x.nan2||''','''||x.nan3||''', '''||x.nan4||''', '''||x.nan5||''','''||x.nan6||''',
                '''||x.nv1||''',  '''||x.nv2||''', '''||x.nv3||''', '''||x.nv4||''',  '''||x.nv5||''', '''||x.nv6||''')';
        execute immediate(sqlstr);
    end loop;
    elsif usertype = 'zjjk' then
      for x in (select t1.jdmc,
                       nvl(sum(case when t1.vc_hzxb='1' and t1.vc_nczzd=1 then t1.ct  end),0) as nan1,
                       nvl(sum(case when t1.vc_hzxb='1' and t1.vc_nczzd=2 then t1.ct  end),0) as nan2,
                       nvl(sum(case when t1.vc_hzxb='1' and t1.vc_nczzd=3 then t1.ct  end),0) as nan3,
                       nvl(sum(case when t1.vc_hzxb='1' and t1.vc_nczzd=4 then t1.ct  end),0) as nan4,
                       nvl(sum(case when t1.vc_hzxb='1' and t1.vc_nczzd=5 then t1.ct  end),0) as nan5,
                       nvl(sum(case when t1.vc_hzxb='1' and t1.vc_nczzd=6 then t1.ct  end),0) as nan6,
                       nvl(sum(case when t1.vc_hzxb='2' and t1.vc_nczzd=1 then t1.ct  end),0) as nv1,
                       nvl(sum(case when t1.vc_hzxb='2' and t1.vc_nczzd=2 then t1.ct  end),0) as nv2,
                       nvl(sum(case when t1.vc_hzxb='2' and t1.vc_nczzd=3 then t1.ct  end),0) as nv3,
                       nvl(sum(case when t1.vc_hzxb='2' and t1.vc_nczzd=4 then t1.ct  end),0) as nv4,
                       nvl(sum(case when t1.vc_hzxb='2' and t1.vc_nczzd=5 then t1.ct  end),0) as nv5,
                       nvl(sum(case when t1.vc_hzxb='2' and t1.vc_nczzd=6 then t1.ct  end),0) as nv6
                     from (select t.vc_nczzd,
                     t.vc_hzxb, t.vc_czhksi,
                     (select a.name from code_info a where a.code_info_id = 1048 and a.code=t.vc_czhksi )as jdmc, count(1) as ct
                     from zjjk_xnxg_bgk t
                     where t.vc_nczzd in ('1', '2', '3','4','5','6') and t.vc_shbz in ('3','5','6','7','8') and t.vc_scbz='2' and t.vc_kzt in ('0','2','6','7')
                     and t.dt_cjsj>=to_date(nvl(bkstart_date,'2000-01-01'),'yyyy-mm-dd') and t.dt_cjsj<=to_date(nvl(bkend_date,'2099-01-01'),'yyyy-mm-dd')
                     and t.dt_bkrq>=to_date(nvl(lrstart_date,'2000-01-01'),'yyyy-mm-dd') and t.dt_bkrq<=to_date(nvl(lrend_date,'2099-01-01'),'yyyy-mm-dd')
                     and t.dt_fbrq>=to_date(nvl(fbstart_date,'2000-01-01'),'yyyy-mm-dd') and t.dt_fbrq<=to_date(nvl(fbend_date,'2099-01-01'),'yyyy-mm-dd')
                     group by t.vc_nczzd, t.vc_hzxb, t.vc_czhksi) t1 where t1.jdmc is not null group by t1.jdmc) loop
        sqlstr := 'INSERT INTO TEMP_ZJJK_REPORT tb (A,B,C,D,E,F,G,H,I,J,K,L,M) VALUES ('''||x.jdmc||''',
                '''||x.nan1||''', '''||x.nan2||''','''||x.nan3||''', '''||x.nan4||''', '''||x.nan5||''','''||x.nan6||''',
                '''||x.nv1||''',  '''||x.nv2||''', '''||x.nv3||''', '''||x.nv4||''',  '''||x.nv5||''', '''||x.nv6||''')';
        execute immediate(sqlstr);
    end loop;
    end if;


    --添加合计
    sqlstr := ' insert into temp_zjjk_report(a,b,c,d,e,f,g,h,i,j,k,l,m) select a,b,c,d,e,f,g,h,i,j,k,l,m from (
                    select ''合计'' as A,sum(b)b,sum(c)c,sum(d)d,sum(e)e,sum(f)f,sum(g)g,sum(h)h,sum(i)i,sum(j)j,sum(k)k,sum(l)l,sum(m)m from temp_zjjk_report t) ';
    execute immediate(sqlstr);
    commit;


  open myrc for select * from temp_zjjk_report t; --order by to_number(t.b);

  end;


  ------------------------------------------------------------------------------------------------

  --冠心病发病报告发病数-分年龄地区统计表
  Procedure Proc_Zjjk_Gxbnldqtjb(bkstart_date varchar2,bkend_date varchar2,
                                lrstart_date varchar2,lrend_date varchar2,
                                fbstart_date varchar2,fbend_date varchar2,
                                jddm varchar2,usertype varchar2,sex varchar2,
                                myrc out ZJJK_MYCUR.myrctype) is
    sqlstr varchar2(1000);
    in_type varchar2(10);
  begin
    delete from temp_zjjk_report;
    commit;
    if usertype='qjk' then
      in_type := substr(jddm,0,6);
      for x in (
       select      (select gg.name from code_info gg where gg.code_info_id='1050' and  gg.code=xx.vc_czhkjd) title,
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
             select GetAgeRangZero(t.dt_hzcsrq,t.dt_fbrq) nl,t.vc_czhkjd
               from zjjk_xnxg_bgk t
               where 1=1
                  and t.vc_gxbzd in ('1', '2', '3')
                  and t.vc_shbz in ('3','5','6','7','8')
                  and t.vc_scbz='2' and t.vc_kzt in ('0','2','6','7')
                  and t.vc_czhkjd like ''||in_type||'%'
                  and t.dt_cjsj>=to_date(nvl(bkstart_date,'2000-01-01'),'yyyy-mm-dd') and t.dt_cjsj<=to_date(nvl(bkend_date,'2099-01-01'),'yyyy-mm-dd')
                  and t.dt_bkrq>=to_date(nvl(lrstart_date,'2000-01-01'),'yyyy-mm-dd') and t.dt_bkrq<=to_date(nvl(lrend_date,'2099-01-01'),'yyyy-mm-dd')
                  and t.dt_fbrq>=to_date(nvl(fbstart_date,'2000-01-01'),'yyyy-mm-dd') and t.dt_fbrq<=to_date(nvl(fbend_date,'2099-01-01'),'yyyy-mm-dd')
                  )
                  xx group by xx.vc_czhkjd
       ) loop
        sqlstr := 'INSERT INTO TEMP_ZJJK_REPORT tb (A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S) VALUES ('''||x.title||''',
                '''||x.a||''', '''||x.b||''','''||x.c||''','''||x.d||''', '''||x.e||''',
                '''||x.f||''', '''||x.g||''','''||x.h||''','''||x.i||''', '''||x.j||''',
                '''||x.k||''', '''||x.l||''','''||x.m||''','''||x.n||''', '''||x.o||''',
                '''||x.p||''',  '''||x.q||''', '''||x.r||''')';
        execute immediate(sqlstr);
    end loop;
  elsif usertype='sjk' then
    in_type := substr(jddm,0,4);
      for x in (
       select      (select gg.name from code_info gg where gg.code_info_id='1049' and  gg.code=xx.vc_czhkqx) title,
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
             select GetAgeRangZero(t.dt_hzcsrq,t.dt_fbrq) nl,t.vc_czhkqx
               from zjjk_xnxg_bgk t
               where 1=1
                  and t.vc_gxbzd in ('1', '2', '3')
                  and t.vc_shbz in ('3','5','6','7','8')
                  and t.vc_scbz='2' and t.vc_kzt in ('0','2','6','7')
                  and t.vc_czhkjd like ''||in_type||'%'
                  and t.dt_cjsj>=to_date(nvl(bkstart_date,'2000-01-01'),'yyyy-mm-dd') and t.dt_cjsj<=to_date(nvl(bkend_date,'2099-01-01'),'yyyy-mm-dd')
                  and t.dt_bkrq>=to_date(nvl(lrstart_date,'2000-01-01'),'yyyy-mm-dd') and t.dt_bkrq<=to_date(nvl(lrend_date,'2099-01-01'),'yyyy-mm-dd')
                  and t.dt_fbrq>=to_date(nvl(fbstart_date,'2000-01-01'),'yyyy-mm-dd') and t.dt_fbrq<=to_date(nvl(fbend_date,'2099-01-01'),'yyyy-mm-dd')
                  )
                  xx group by xx.vc_czhkqx
       ) loop
        sqlstr := 'INSERT INTO TEMP_ZJJK_REPORT tb (A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S) VALUES ('''||x.title||''',
                '''||x.a||''', '''||x.b||''','''||x.c||''','''||x.d||''', '''||x.e||''',
                '''||x.f||''', '''||x.g||''','''||x.h||''','''||x.i||''', '''||x.j||''',
                '''||x.k||''', '''||x.l||''','''||x.m||''','''||x.n||''', '''||x.o||''',
                '''||x.p||''',  '''||x.q||''', '''||x.r||''')';
        execute immediate(sqlstr);
    end loop;
  elsif usertype='zjjk' then
    in_type := substr(jddm,0,2);
     for x in (
       select      (select gg.name from code_info gg where gg.code_info_id='1048' and  gg.code=xx.vc_czhksi) title,
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
             select GetAgeRangZero(t.dt_hzcsrq,t.dt_fbrq) nl,t.vc_czhksi
               from zjjk_xnxg_bgk t
               where 1=1
                  and t.vc_gxbzd in ('1', '2', '3')
                  and t.vc_shbz in ('3','5','6','7','8')
                  and t.vc_scbz='2' and t.vc_kzt in ('0','2','6','7')
                  and t.vc_czhkjd like ''||in_type||'%'
                  and t.dt_cjsj>=to_date(nvl(bkstart_date,'2000-01-01'),'yyyy-mm-dd') and t.dt_cjsj<=to_date(nvl(bkend_date,'2099-01-01'),'yyyy-mm-dd')
                  and t.dt_bkrq>=to_date(nvl(lrstart_date,'2000-01-01'),'yyyy-mm-dd') and t.dt_bkrq<=to_date(nvl(lrend_date,'2099-01-01'),'yyyy-mm-dd')
                  and t.dt_fbrq>=to_date(nvl(fbstart_date,'2000-01-01'),'yyyy-mm-dd') and t.dt_fbrq<=to_date(nvl(fbend_date,'2099-01-01'),'yyyy-mm-dd')
                  )
                  xx group by xx.vc_czhksi
       ) loop
        sqlstr := 'INSERT INTO TEMP_ZJJK_REPORT tb (A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S) VALUES ('''||x.title||''',
                '''||x.a||''', '''||x.b||''','''||x.c||''','''||x.d||''', '''||x.e||''',
                '''||x.f||''', '''||x.g||''','''||x.h||''','''||x.i||''', '''||x.j||''',
                '''||x.k||''', '''||x.l||''','''||x.m||''','''||x.n||''', '''||x.o||''',
                '''||x.p||''',  '''||x.q||''', '''||x.r||''')';
        execute immediate(sqlstr);
    end loop;
  end if;

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


  ------------------------------------------------------------------------------------------------

  --脑卒中发病报告发病数-分年龄地区统计表
  Procedure Proc_Zjjk_Nsznldqtjb(bkstart_date varchar2,bkend_date varchar2,
                                lrstart_date varchar2,lrend_date varchar2,
                                fbstart_date varchar2,fbend_date varchar2,
                                jddm varchar2,usertype varchar2,sex varchar2,
                                myrc out ZJJK_MYCUR.myrctype) is

   sqlstr varchar2(1000);
    in_type varchar2(10);
  begin
    delete from temp_zjjk_report;
    commit;
    if usertype='qjk' then
      in_type := substr(jddm,0,6);
      for x in (
       select      (select gg.name from code_info gg where gg.code_info_id='1050' and  gg.code=xx.vc_czhkjd) title,
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
             select GetAgeRangZero(t.dt_hzcsrq,t.dt_fbrq) nl,t.vc_czhkjd
               from zjjk_xnxg_bgk t
               where 1=1
                  and t.vc_nczzd in ('1', '2', '3','4','5','6')
                  --and t.vc_gxbzd in ('1', '2', '3')
                  and t.vc_shbz in ('3','5','6','7','8')
                  and t.vc_scbz='2' and t.vc_kzt in ('0','2','6','7')
                  and t.vc_czhkjd like ''||in_type||'%'
                  and t.dt_cjsj>=to_date(nvl(bkstart_date,'2000-01-01'),'yyyy-mm-dd') and t.dt_cjsj<=to_date(nvl(bkend_date,'2099-01-01'),'yyyy-mm-dd')
                  and t.dt_bkrq>=to_date(nvl(lrstart_date,'2000-01-01'),'yyyy-mm-dd') and t.dt_bkrq<=to_date(nvl(lrend_date,'2099-01-01'),'yyyy-mm-dd')
                  and t.dt_fbrq>=to_date(nvl(fbstart_date,'2000-01-01'),'yyyy-mm-dd') and t.dt_fbrq<=to_date(nvl(fbend_date,'2099-01-01'),'yyyy-mm-dd')
                  ) xx group by xx.vc_czhkjd
       ) loop
        sqlstr := 'INSERT INTO TEMP_ZJJK_REPORT tb (A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S) VALUES ('''||x.title||''',
                '''||x.a||''', '''||x.b||''','''||x.c||''','''||x.d||''', '''||x.e||''',
                '''||x.f||''', '''||x.g||''','''||x.h||''','''||x.i||''', '''||x.j||''',
                '''||x.k||''', '''||x.l||''','''||x.m||''','''||x.n||''', '''||x.o||''',
                '''||x.p||''',  '''||x.q||''', '''||x.r||''')';
        execute immediate(sqlstr);
    end loop;

  elsif usertype='sjk' then
    in_type := substr(jddm,0,4);
    for x in (
       select      (select gg.name from code_info gg where gg.code_info_id='1049' and  gg.code=xx.vc_czhkqx) title,
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
             select GetAgeRangZero(t.dt_hzcsrq,t.dt_fbrq) nl,t.vc_czhkqx
               from zjjk_xnxg_bgk t
               where 1=1
                  and t.vc_nczzd in ('1', '2', '3','4','5','6')
                  --and t.vc_gxbzd in ('1', '2', '3')
                  and t.vc_shbz in ('3','5','6','7','8')
                  and t.vc_scbz='2' and t.vc_kzt in ('0','2','6','7')
                  and t.vc_czhkjd like ''||in_type||'%'
                  and t.dt_cjsj>=to_date(nvl(bkstart_date,'2000-01-01'),'yyyy-mm-dd') and t.dt_cjsj<=to_date(nvl(bkend_date,'2099-01-01'),'yyyy-mm-dd')
                  and t.dt_bkrq>=to_date(nvl(lrstart_date,'2000-01-01'),'yyyy-mm-dd') and t.dt_bkrq<=to_date(nvl(lrend_date,'2099-01-01'),'yyyy-mm-dd')
                  and t.dt_fbrq>=to_date(nvl(fbstart_date,'2000-01-01'),'yyyy-mm-dd') and t.dt_fbrq<=to_date(nvl(fbend_date,'2099-01-01'),'yyyy-mm-dd')
                  ) xx group by xx.vc_czhkqx
       ) loop
        sqlstr := 'INSERT INTO TEMP_ZJJK_REPORT tb (A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S) VALUES ('''||x.title||''',
                '''||x.a||''', '''||x.b||''','''||x.c||''','''||x.d||''', '''||x.e||''',
                '''||x.f||''', '''||x.g||''','''||x.h||''','''||x.i||''', '''||x.j||''',
                '''||x.k||''', '''||x.l||''','''||x.m||''','''||x.n||''', '''||x.o||''',
                '''||x.p||''',  '''||x.q||''', '''||x.r||''')';
        execute immediate(sqlstr);
    end loop;
  elsif usertype='zjjk' then
    in_type := substr(jddm,0,2);
    for x in (
       select      (select gg.name from code_info gg where gg.code_info_id='1048' and  gg.code=xx.vc_czhksi) title,
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
             select GetAgeRangZero(t.dt_hzcsrq,t.dt_fbrq) nl,t.vc_czhksi
               from zjjk_xnxg_bgk t
               where 1=1
                  and t.vc_nczzd in ('1', '2', '3','4','5','6')
                  and t.vc_shbz in ('3','5','6','7','8')
                  and t.vc_scbz='2' and t.vc_kzt in ('0','2','6','7')
                  and t.vc_czhkjd like ''||in_type||'%'
                  and t.dt_cjsj>=to_date(nvl(bkstart_date,'2000-01-01'),'yyyy-mm-dd') and t.dt_cjsj<=to_date(nvl(bkend_date,'2099-01-01'),'yyyy-mm-dd')
                  and t.dt_bkrq>=to_date(nvl(lrstart_date,'2000-01-01'),'yyyy-mm-dd') and t.dt_bkrq<=to_date(nvl(lrend_date,'2099-01-01'),'yyyy-mm-dd')
                  and t.dt_fbrq>=to_date(nvl(fbstart_date,'2000-01-01'),'yyyy-mm-dd') and t.dt_fbrq<=to_date(nvl(fbend_date,'2099-01-01'),'yyyy-mm-dd')
                  ) xx group by xx.vc_czhksi
       ) loop
        sqlstr := 'INSERT INTO TEMP_ZJJK_REPORT tb (A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S) VALUES ('''||x.title||''',
                '''||x.a||''', '''||x.b||''','''||x.c||''','''||x.d||''', '''||x.e||''',
                '''||x.f||''', '''||x.g||''','''||x.h||''','''||x.i||''', '''||x.j||''',
                '''||x.k||''', '''||x.l||''','''||x.m||''','''||x.n||''', '''||x.o||''',
                '''||x.p||''',  '''||x.q||''', '''||x.r||''')';
        execute immediate(sqlstr);
    end loop;
  end if;

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


  ------------------------------------------------------------------------------------------------


end ZJJK_XNXG_REPORT;

