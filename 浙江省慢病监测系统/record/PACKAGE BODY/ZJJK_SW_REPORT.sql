create or replace package body      ZJJK_SW_REPORT is

    --居民病伤死亡原因表
  Procedure Proc_Zjjk_Jmbsswyyb(lrstart_date varchar2,lrend_date varchar2,
                                bkstart_date varchar2,bkend_date varchar2,
                                swstart_date varchar2,swend_date varchar2,
                                jddm varchar2,myrc out ZJJK_MYCUR.myrctype) is
    --cursor c_pre is select * from (select distinct z.ccd_code ccd_code, z.ccd_name ccd_name from t_icd10 z where not z.ccd_code = 0 union
                        --select distinct to_number(x.ccd_pcode), x.ccd_parent from t_icd10 x where not x.ccd_code = 0 and x.ccd_parent is not null) order by ccd_code;
    /***
    cursor c_pre is select distinct z.ccd_code ccd_code, z.ccd_name ccd_name from t_icd10 z where not z.ccd_code = 0 order by ccd_code;
    **/
    cursor c_pre is select QT1 ccd_code,QT2 ccd_name from temp_zjjk_report_row t where reportname='jmbsswyyb' and rowname='0'
    and QT1>1  order by ordernum;
    nf varchar2(2);
    type2 varchar2(10);
    sqlstr varchar2(1000);
    cursor c_data(groupId varchar2) is select
                     xx.ccd_code as code,xx.xb as xb,
                     sum(case xx.nl when '0岁' then xx.ct end) as a ,
                     sum(case xx.nl when '新生儿' then xx.ct end) as b ,
                     sum(case xx.nl when '1～' then xx.ct end) as c ,
                     sum(case xx.nl when '5～' then xx.ct end) as d ,
                     sum(case xx.nl when '10～' then xx.ct end) as e ,
                     sum(case xx.nl when '15～' then xx.ct end) as f ,
                     sum(case xx.nl when '20～' then xx.ct end) as g ,
                     sum(case xx.nl when '25～' then xx.ct end) as h ,
                     sum(case xx.nl when '30～' then xx.ct end) as i ,
                     sum(case xx.nl when '35～' then xx.ct end) as j ,
                     sum(case xx.nl when '40～' then xx.ct end) as k ,
                     sum(case xx.nl when '45～' then xx.ct end) as l ,
                     sum(case xx.nl when '50～' then xx.ct end) as m ,
                     sum(case xx.nl when '55～' then xx.ct end) as n ,
                     sum(case xx.nl when '60～' then xx.ct end) as o ,
                     sum(case xx.nl when '65～' then xx.ct end) as p ,
                     sum(case xx.nl when '70～' then xx.ct end) as q ,
                     sum(case xx.nl when '75～' then xx.ct end) as r ,
                     sum(case xx.nl when '80～' then xx.ct end) as s ,
                     sum(case xx.nl when '85～' then xx.ct end) as t ,
                     sum(ct) as act
                       from (
                     select
                     (case groupId when '2' then c.ccd_scode when '3' then c.ccd_pcode else to_char(c.ccd_code) end) ccd_code,GetAgeRangSw(t.dt_csrq,t.dt_swrq) as nl,t.vc_xb as xb,count(1) as ct
                       from zjmb_sw_bgk t, t_icd10_cc c
                      where t.vc_gbsy is not null
                        and t.vc_gbsy = c.icd10_code
                        and t.dt_dcrq>=to_date(nvl(bkstart_date,'2000-01-01'),'yyyy-mm-dd') and t.dt_dcrq<=to_date(nvl(bkend_date,'2099-01-01'),'yyyy-mm-dd')
                        and t.dt_lrsj>=to_date(nvl(lrstart_date,'2000-01-01'),'yyyy-mm-dd') and t.dt_lrsj<=to_date(nvl(lrend_date,'2099-01-01'),'yyyy-mm-dd')
                        and t.dt_swrq>=to_date(nvl(swstart_date,'2000-01-01'),'yyyy-mm-dd') and t.dt_swrq<=to_date(nvl(swend_date,'2099-01-01'),'yyyy-mm-dd')
                        and t.vc_bgklb = '0' and t.vc_shbz in ('8','7','6','5','3') and t.vc_scbz='2'
                        and t.vc_gldwdm like ''||jddm||'%'
                      group by (case groupId when '2' then c.ccd_scode when '3' then c.ccd_pcode else to_char(c.ccd_code) end),GetAgeRangSw(t.dt_csrq,t.dt_swrq),t.vc_xb ) xx group by xx.ccd_code,xx.xb;
  begin

    delete from TEMP_ZJJK_REPORT;
    commit;
    nf:=substr(lrstart_date,3,2);

    for e in c_pre loop
        sqlstr := ' insert into temp_zjjk_report (A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z) values (''2'','''||e.ccd_code||''','''||e.ccd_name||''',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0) ';
        execute immediate(sqlstr);
    end loop;
    for e in c_pre loop
        sqlstr := ' insert into temp_zjjk_report (A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z) values (''1'','''||e.ccd_code||''','''||e.ccd_name||''',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0) ';
        execute immediate(sqlstr);
    end loop;
    commit;
    for x in c_data('1') loop
        sqlstr := 'UPDATE temp_zjjk_report tb
            SET tb.d = '''||x.a||''', tb.e = '''||x.b||''', tb.f = '''||x.c||''',
                tb.g = '''||x.d||''', tb.h = '''||x.e||''', tb.i = '''||x.f||''',
                tb.j = '''||x.g||''', tb.k = '''||x.h||''', tb.l = '''||x.i||''',
                tb.m = '''||x.j||''', tb.n = '''||x.k||''', tb.o = '''||x.l||''',
                tb.p = '''||x.m||''', tb.q = '''||x.n||''', tb.r = '''||x.o||''',
                tb.s = '''||x.p||''', tb.t = '''||x.q||''', tb.u = '''||x.r||''',
                tb.v = '''||x.s||''', tb.w = '''||x.t||''',tb.x = '''||x.act||''',y=0,z=0
            where tb.b='''||x.code||''' and tb.a='''||x.xb||'''';
        execute immediate(sqlstr);
    end loop;



    for x in c_data('2') loop
        sqlstr := 'UPDATE temp_zjjk_report tb
            SET tb.d = '''||x.a||''', tb.e = '''||x.b||''', tb.f = '''||x.c||''',
                tb.g = '''||x.d||''', tb.h = '''||x.e||''', tb.i = '''||x.f||''',
                tb.j = '''||x.g||''', tb.k = '''||x.h||''', tb.l = '''||x.i||''',
                tb.m = '''||x.j||''', tb.n = '''||x.k||''', tb.o = '''||x.l||''',
                tb.p = '''||x.m||''', tb.q = '''||x.n||''', tb.r = '''||x.o||''',
                tb.s = '''||x.p||''', tb.t = '''||x.q||''', tb.u = '''||x.r||''',
                tb.v = '''||x.s||''', tb.w = '''||x.t||''',tb.x = '''||x.act||''',y=0,z=0
            where tb.b='''||x.code||''' and tb.a='''||x.xb||'''';
        execute immediate(sqlstr);
    end loop;


    for x in c_data('3') loop
        sqlstr := 'UPDATE temp_zjjk_report tb
            SET tb.d = '''||x.a||''', tb.e = '''||x.b||''', tb.f = '''||x.c||''',
                tb.g = '''||x.d||''', tb.h = '''||x.e||''', tb.i = '''||x.f||''',
                tb.j = '''||x.g||''', tb.k = '''||x.h||''', tb.l = '''||x.i||''',
                tb.m = '''||x.j||''', tb.n = '''||x.k||''', tb.o = '''||x.l||''',
                tb.p = '''||x.m||''', tb.q = '''||x.n||''', tb.r = '''||x.o||''',
                tb.s = '''||x.p||''', tb.t = '''||x.q||''', tb.u = '''||x.r||''',
                tb.v = '''||x.s||''', tb.w = '''||x.t||''',tb.x = '''||x.act||''',y=0,z=0
            where tb.b='''||x.code||''' and tb.a='''||x.xb||'''';
        execute immediate(sqlstr);
    end loop;

    --添加男女合计
    for e in c_pre loop
        sqlstr := ' insert into temp_zjjk_report select a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,0,0,0,0,0,0 from (
                        select ''0'' as a,t.b,t.c,sum(d)d,sum(e)e,sum(f)f,sum(g)g,sum(h)h,sum(i)i,sum(j)j,sum(k)k,sum(l)l,sum(m)m,sum(n)n,sum(o)o,sum(p)p,sum(q)q,sum(r)r,sum(s)s,sum(t)t,sum(u)u,sum(v)v,sum(w)w,sum(x)x from temp_zjjk_report t where t.b='''||e.ccd_code||''' group by t.b,t.c)';
        execute immediate(sqlstr);
    end loop;

    --合计总数
    insert into temp_zjjk_report select a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,0,0,0,0,0,0 from (
     select t.a as a, '1' as b, '合计' as C,sum(d)d,sum(e)e,sum(f)f,sum(g)g,sum(h)h,sum(i)i,sum(j)j,sum(k)k,sum(l)l,sum(m)m,sum(n)n,sum(o)o,sum(p)p,sum(q)q,sum(r)r,sum(s)s,sum(t)t,sum(u)u,sum(v)v,sum(w)w,sum(x)x
     from temp_zjjk_report t where exists(select 1 from  t_icd10_cc c  where  t.b = c.ccd_pcode)  group by t.a);

    /**
    --合计各分类
    insert into temp_zjjk_report select a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,null,null,null,null,null,null from (
        select z.a,t.ccd_pcode b,t.ccd_parent c,sum(z.d)d,sum(z.e)e,sum(z.f)f,sum(z.g)g,sum(z.h)h,sum(z.i)i,sum(z.j)j,sum(z.k)k,sum(z.l)l,sum(z.m)m,sum(z.n)n,sum(z.o)o,sum(z.p)p,sum(z.q)q,sum(z.r)r,sum(z.s)s,sum(z.t)t,sum(z.u)u,sum(z.v)v,sum(z.w)w,sum(z.x)x,sum(z.y)y
            from (select b.ccd_code,b.ccd_pcode,b.ccd_parent from t_icd10 b group by b.ccd_code,b.ccd_pcode,b.ccd_parent) t,temp_zjjk_report z where t.ccd_code=z.b and t.ccd_pcode is not null
            group by z.a,t.ccd_pcode,t.ccd_parent);
    --commit;
    */


--获得平均人口数据

    type2:='zjjk';
    if(length(jddm)=4) then type2:='sjk';
    elsif(length(jddm)=6)then type2:='qjk';
    elsif(length(jddm)=8)then type2:='kong';
    end if;

    if (type2='zjjk') then

    insert into temp_zjjk_report (A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z)
    select '1','110','人口数',round(nvl(vc_0nld,0)),0, round(nvl(vc_1nld,0)), round(nvl(vc_5nld,0)), round(nvl(vc_10nld,0)), round(nvl(vc_15nld,0)), round(nvl(vc_20nld,0)), round(nvl(vc_25nld,0)), round(nvl(vc_30nld,0)), round(nvl(vc_35nld,0)), round(nvl(vc_40nld,0)), round(nvl(vc_45nld,0)), round(nvl(vc_50nld,0)), round(nvl(vc_55nld,0)), round(nvl(vc_60nld,0)), round(nvl(vc_65nld,0)), round(nvl(vc_70nld,0)), round(nvl(vc_75nld,0)), round(nvl(vc_80nld,0)), round(nvl(vc_85nld,0)),round(nvl(vc_nhj,0)), 0,0
       from zjmb_rkglb t where t.vc_rkglsf=33000000 and t.VC_RKGLS=99999999 and t.VC_RKGLQ=99999999 and t.VC_RKGLJD=99999999 and t.VC_NF=nf and t.vc_lx =7 and t.vc_xtlb='sw';
    insert into temp_zjjk_report (A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z)
     select '2','110','人口数',round(nvl(vc_0nld,0)),0, round(nvl(vc_1nld,0)), round(nvl(vc_5nld,0)), round(nvl(vc_10nld,0)), round(nvl(vc_15nld,0)), round(nvl(vc_20nld,0)), round(nvl(vc_25nld,0)), round(nvl(vc_30nld,0)), round(nvl(vc_35nld,0)), round(nvl(vc_40nld,0)), round(nvl(vc_45nld,0)), round(nvl(vc_50nld,0)), round(nvl(vc_55nld,0)), round(nvl(vc_60nld,0)), round(nvl(vc_65nld,0)), round(nvl(vc_70nld,0)), round(nvl(vc_75nld,0)), round(nvl(vc_80nld,0)), round(nvl(vc_85nld,0)),round(nvl(vc_vhj,0)), 0,0
     from zjmb_rkglb t where t.vc_rkglsf=33000000 and t.VC_RKGLS=99999999 and t.VC_RKGLQ=99999999 and t.VC_RKGLJD=99999999 and t.VC_NF=nf and t.vc_lx =8 and t.vc_xtlb='sw';
    insert into temp_zjjk_report (A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z)
      select '0','110','人口数',round(nvl(vc_0nld,0)),0, round(nvl(vc_1nld,0)), round(nvl(vc_5nld,0)), round(nvl(vc_10nld,0)), round(nvl(vc_15nld,0)), round(nvl(vc_20nld,0)), round(nvl(vc_25nld,0)), round(nvl(vc_30nld,0)), round(nvl(vc_35nld,0)), round(nvl(vc_40nld,0)), round(nvl(vc_45nld,0)), round(nvl(vc_50nld,0)), round(nvl(vc_55nld,0)), round(nvl(vc_60nld,0)), round(nvl(vc_65nld,0)), round(nvl(vc_70nld,0)), round(nvl(vc_75nld,0)), round(nvl(vc_80nld,0)), round(nvl(vc_85nld,0)),round(nvl(vc_zhj,0)), 0,0
    from zjmb_rkglb t where t.vc_rkglsf=33000000 and t.VC_RKGLS=99999999 and t.VC_RKGLQ=99999999 and t.VC_RKGLJD=99999999 and t.VC_NF=nf and t.vc_lx =9 and t.vc_xtlb='sw';
  end if;

    if (type2='sjk') then
    insert into temp_zjjk_report (A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z)
    select '1','110','人口数',round(nvl(vc_0nld,0)),0, round(nvl(vc_1nld,0)), round(nvl(vc_5nld,0)), round(nvl(vc_10nld,0)), round(nvl(vc_15nld,0)), round(nvl(vc_20nld,0)), round(nvl(vc_25nld,0)), round(nvl(vc_30nld,0)), round(nvl(vc_35nld,0)), round(nvl(vc_40nld,0)), round(nvl(vc_45nld,0)), round(nvl(vc_50nld,0)), round(nvl(vc_55nld,0)), round(nvl(vc_60nld,0)), round(nvl(vc_65nld,0)), round(nvl(vc_70nld,0)), round(nvl(vc_75nld,0)), round(nvl(vc_80nld,0)), round(nvl(vc_85nld,0)),round(nvl(vc_nhj,0)), 0,0
       from zjmb_rkglb t where t.VC_RKGLS=''||jddm||'0000' and t.VC_RKGLQ=99999999 and t.VC_RKGLJD=99999999 and t.VC_NF=nf and t.vc_lx =7 and t.vc_xtlb='sw';
    insert into temp_zjjk_report (A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z)
     select '2','110','人口数',round(nvl(vc_0nld,0)),0, round(nvl(vc_1nld,0)), round(nvl(vc_5nld,0)), round(nvl(vc_10nld,0)), round(nvl(vc_15nld,0)), round(nvl(vc_20nld,0)), round(nvl(vc_25nld,0)), round(nvl(vc_30nld,0)), round(nvl(vc_35nld,0)), round(nvl(vc_40nld,0)), round(nvl(vc_45nld,0)), round(nvl(vc_50nld,0)), round(nvl(vc_55nld,0)), round(nvl(vc_60nld,0)), round(nvl(vc_65nld,0)), round(nvl(vc_70nld,0)), round(nvl(vc_75nld,0)), round(nvl(vc_80nld,0)), round(nvl(vc_85nld,0)),round(nvl(vc_vhj,0)), 0,0
     from zjmb_rkglb t where t.VC_RKGLS=''||jddm||'0000' and t.VC_RKGLQ=99999999 and t.VC_RKGLJD=99999999 and t.VC_NF=nf and t.vc_lx =8 and t.vc_xtlb='sw';
    insert into temp_zjjk_report (A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z)
      select '0','110','人口数',round(nvl(vc_0nld,0)),0, round(nvl(vc_1nld,0)), round(nvl(vc_5nld,0)), round(nvl(vc_10nld,0)), round(nvl(vc_15nld,0)), round(nvl(vc_20nld,0)), round(nvl(vc_25nld,0)), round(nvl(vc_30nld,0)), round(nvl(vc_35nld,0)), round(nvl(vc_40nld,0)), round(nvl(vc_45nld,0)), round(nvl(vc_50nld,0)), round(nvl(vc_55nld,0)), round(nvl(vc_60nld,0)), round(nvl(vc_65nld,0)), round(nvl(vc_70nld,0)), round(nvl(vc_75nld,0)), round(nvl(vc_80nld,0)), round(nvl(vc_85nld,0)),round(nvl(vc_zhj,0)), 0,0
    from zjmb_rkglb t where t.VC_RKGLS=''||jddm||'0000' and t.VC_RKGLQ=99999999 and t.VC_RKGLJD=99999999 and t.VC_NF=nf and t.vc_lx =9 and t.vc_xtlb='sw';
   end if;

    if (type2='qjk') then
    insert into temp_zjjk_report (A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z)
    select '1','110','人口数',round(nvl(vc_0nld,0)),0, round(nvl(vc_1nld,0)), round(nvl(vc_5nld,0)), round(nvl(vc_10nld,0)), round(nvl(vc_15nld,0)), round(nvl(vc_20nld,0)), round(nvl(vc_25nld,0)), round(nvl(vc_30nld,0)), round(nvl(vc_35nld,0)), round(nvl(vc_40nld,0)), round(nvl(vc_45nld,0)), round(nvl(vc_50nld,0)), round(nvl(vc_55nld,0)), round(nvl(vc_60nld,0)), round(nvl(vc_65nld,0)), round(nvl(vc_70nld,0)), round(nvl(vc_75nld,0)), round(nvl(vc_80nld,0)), round(nvl(vc_85nld,0)),round(nvl(vc_nhj,0)), 0,0
       from zjmb_rkglb t where t.VC_RKGLQ=''||jddm||'00' and t.VC_RKGLJD=99999999 and t.VC_NF=nf and t.vc_lx =7 ;
    insert into temp_zjjk_report (A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z)
     select '2','110','人口数',round(nvl(vc_0nld,0)),0, round(nvl(vc_1nld,0)), round(nvl(vc_5nld,0)), round(nvl(vc_10nld,0)), round(nvl(vc_15nld,0)), round(nvl(vc_20nld,0)), round(nvl(vc_25nld,0)), round(nvl(vc_30nld,0)), round(nvl(vc_35nld,0)), round(nvl(vc_40nld,0)), round(nvl(vc_45nld,0)), round(nvl(vc_50nld,0)), round(nvl(vc_55nld,0)), round(nvl(vc_60nld,0)), round(nvl(vc_65nld,0)), round(nvl(vc_70nld,0)), round(nvl(vc_75nld,0)), round(nvl(vc_80nld,0)), round(nvl(vc_85nld,0)),round(nvl(vc_vhj,0)), 0,0
     from zjmb_rkglb t where t.VC_RKGLQ=''||jddm||'00' and t.VC_RKGLJD=99999999 and t.VC_NF=nf and t.vc_lx =8 ;
    insert into temp_zjjk_report (A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z)
      select '0','110','人口数',round(nvl(vc_0nld,0)),0, round(nvl(vc_1nld,0)), round(nvl(vc_5nld,0)), round(nvl(vc_10nld,0)), round(nvl(vc_15nld,0)), round(nvl(vc_20nld,0)), round(nvl(vc_25nld,0)), round(nvl(vc_30nld,0)), round(nvl(vc_35nld,0)), round(nvl(vc_40nld,0)), round(nvl(vc_45nld,0)), round(nvl(vc_50nld,0)), round(nvl(vc_55nld,0)), round(nvl(vc_60nld,0)), round(nvl(vc_65nld,0)), round(nvl(vc_70nld,0)), round(nvl(vc_75nld,0)), round(nvl(vc_80nld,0)), round(nvl(vc_85nld,0)),round(nvl(vc_zhj,0)), 0,0
    from zjmb_rkglb t where t.VC_RKGLQ=''||jddm||'00' and t.VC_RKGLJD=99999999 and t.VC_NF=nf and t.vc_lx =9 ;

    end if;

    /**计算出生人数*/
    update temp_zjjk_report r set  r.e=nvl(
    (select count(1) from zjmb_cs_bgk t where
                         t.DT_JKSJ>=to_date(nvl(bkstart_date,'2000-01-01'),'yyyy-mm-dd') and t.DT_JKSJ<=to_date(nvl(bkend_date,'2099-01-01'),'yyyy-mm-dd')
                        and t.DT_CZSJ>=to_date(nvl(lrstart_date,'2000-01-01'),'yyyy-mm-dd') and t.DT_CZSJ<=to_date(nvl(lrend_date,'2099-01-01'),'yyyy-mm-dd')
                        and t.dt_csrq>=to_date(nvl(swstart_date,'2000-01-01'),'yyyy-mm-dd') and t.dt_csrq<=to_date(nvl(swend_date,'2099-01-01'),'yyyy-mm-dd')
                        and t.vc_shbz in ('8','7','6','5','3') and t.vc_scbz='2'  and nvl(VC_BGKZT,0) in ('0','7')
                        and VC_XSRXB=r.a and t.VC_JDDM like ''||jddm||'%')
                        ,0)

     where r.b='110' and r.a in ('2','1');

    update temp_zjjk_report r set  r.e=nvl(
    (select count(1) from zjmb_cs_bgk t where
                         t.DT_JKSJ>=to_date(nvl(bkstart_date,'2000-01-01'),'yyyy-mm-dd') and t.DT_JKSJ<=to_date(nvl(bkend_date,'2099-01-01'),'yyyy-mm-dd')
                        and t.DT_CZSJ>=to_date(nvl(lrstart_date,'2000-01-01'),'yyyy-mm-dd') and t.DT_CZSJ<=to_date(nvl(lrend_date,'2099-01-01'),'yyyy-mm-dd')
                        and t.dt_csrq>=to_date(nvl(swstart_date,'2000-01-01'),'yyyy-mm-dd') and t.dt_csrq<=to_date(nvl(swend_date,'2099-01-01'),'yyyy-mm-dd')
                        and t.vc_shbz in ('8','7','6','5','3') and t.vc_scbz='2' and nvl(VC_BGKZT,0) in ('0','7')
                        and t.VC_JDDM like ''||jddm||'%')
                        ,0)

     where r.b='110' and r.a='0';


  open myrc for select * from temp_zjjk_report t order by t.a,to_number(t.b);
  commit;

  end;

  --------------------------------------------------------------------------------------------------------
  --婴儿死亡日月年龄表
  Procedure Proc_Zjjk_Yeswrynlb(lrstart_date varchar2,lrend_date varchar2,
                                bkstart_date varchar2,bkend_date varchar2,
                                swstart_date varchar2,swend_date varchar2,
                                jddm varchar2,myrc out ZJJK_MYCUR.myrctype) is
    sqlstr varchar2(1000);
    hj_nan number(30);
    hj_nv  number(30);
    cursor c_pre is select GetDeathAge(t.dt_csrq, t.dt_swrq) nf,
                        count(case when t.vc_xb='1' then t.vc_xb  end) as nan,
                        count(case when t.vc_xb='2' then t.vc_xb  end) as nv,
                        count(1) as hj
                    from zjmb_sw_bgk t
                    where (t.dt_swrq - t.dt_csrq) >= 0 and (t.dt_swrq - t.dt_csrq) < 365
                    --业务条件
                    and t.dt_dcrq>=to_date(nvl(bkstart_date,'2000-01-01'),'yyyy-mm-dd') and t.dt_dcrq<=to_date(nvl(bkend_date,'2099-01-01'),'yyyy-mm-dd')
                    and t.dt_lrsj>=to_date(nvl(lrstart_date,'2000-01-01'),'yyyy-mm-dd') and t.dt_lrsj<=to_date(nvl(lrend_date,'2099-01-01'),'yyyy-mm-dd')
                    and t.dt_swrq>=to_date(nvl(swstart_date,'2000-01-01'),'yyyy-mm-dd') and t.dt_swrq<=to_date(nvl(swend_date,'2099-01-01'),'yyyy-mm-dd')
                    and t.vc_bgklb = '0' and t.vc_shbz in ('8','7','6','5','3') and t.vc_scbz='2'
                    and t.vc_gldwdm like ''||jddm||'%'
                    group by GetDeathAge(t.dt_csrq, t.dt_swrq)
                    order by nf;
  begin

    delete from TEMP_ZJJK_REPORT;
    commit;
    for e in c_pre loop
        sqlstr := ' insert into TEMP_ZJJK_REPORT (A,B,C,D) values ('''||e.nf||''','''||e.nan||''','''||e.nv||''','''||e.hj||''') ';
        execute immediate(sqlstr);
    end loop;
    --合计
    select  sum(x.b) into hj_nan from TEMP_ZJJK_REPORT x;
    select  sum(x.c) into hj_nv from TEMP_ZJJK_REPORT x;
    sqlstr := ' insert into TEMP_ZJJK_REPORT (A,B,C,D) values (''合计'','''||hj_nan||''','''||hj_nv||''','''||(hj_nan+hj_nv)||''') ';
    execute immediate(sqlstr);
    DELETE FROM temp_zjjk_report_test;
    insert into temp_zjjk_report_test(A,B,C,D,E,F,G)
    SELECT A,B,C,D,lrend_date,swend_date,jddm FROM temp_zjjk_report;

  --select x.rowname from temp_zjjk_report_row x where x.sysname='sw' and x.reportname='yeswnlfz'
  open myrc for select x.rowname as a,t.b,t.c,t.d
      ,t.e,t.f,t.g,t.h,t.i,t.j,t.k,t.l,t.m,t.n,t.o,t.p,t.q,t.r,t.s,t.t,t.u,t.v,t.w
      from temp_zjjk_report_row x
                left join
                temp_zjjk_report t
                on x.rowname=t.a
                    where x.sysname='sw' and x.reportname='yeswnlfz' order by x.ordernum;
    commit;
  end;


   --------------------------------------------------------------------------------------------------------
  --居民死亡率分析表
  Procedure Proc_Zjjk_Swlfxb(lrstart_date varchar2,lrend_date varchar2,
                                bkstart_date varchar2,bkend_date varchar2,
                                swstart_date varchar2,swend_date varchar2,
                                jddm varchar2,type varchar2,myrc out ZJJK_MYCUR.myrctype) is
    /***
    cursor c_pre is select distinct z.ccd_code,z.ccd_name  from t_icd10 z where not z.ccd_code=0 order by z.ccd_code;
    */

    cursor c_pre is select QT1 ccd_code,QT2 ccd_name from temp_zjjk_report_row t where reportname='jmbsswyyb' and rowname='0'
    and QT1>1  order by ordernum;

    nf varchar2(2);
    sqlstr varchar2(1000);
    m_a1 number(20,2);           f_a1 number(20,2);             c_a1 number(20,2);
    m_a2 number(20,2);           f_a2 number(20,2);             c_a2 number(20,2);
    m_a3 number(20,2);           f_a3 number(20,2);             c_a3 number(20,2);
    m_a4 number(20,2);           f_a4 number(20,2);             c_a4 number(20,2);
    m_a5 number(20,2);           f_a5 number(20,2);             c_a5 number(20,2);
    m_a6 number(20,2);           f_a6 number(20,2);             c_a6 number(20,2);
    m_a7 number(20,2);           f_a7 number(20,2);             c_a7 number(20,2);
    m_a8 number(20,2);           f_a8 number(20,2);             c_a8 number(20,2);
    m_a9 number(20,2);           f_a9 number(20,2);             c_a9 number(20,2);
    m_a10 number(20,2);          f_a10 number(20,2);            c_a10 number(20,2);
    m_a11 number(20,2);          f_a11 number(20,2);            c_a11 number(20,2);
    m_a12 number(20,2);          f_a12 number(20,2);            c_a12 number(20,2);
    m_a13 number(20,2);          f_a13 number(20,2);            c_a13 number(20,2);
    m_a14 number(20,2);          f_a14 number(20,2);            c_a14 number(20,2);
    m_a15 number(20,2);          f_a15 number(20,2);            c_a15 number(20,2);
    m_a16 number(20,2);          f_a16 number(20,2);            c_a16 number(20,2);
    m_a17 number(20,2);          f_a17 number(20,2);            c_a17 number(20,2);
    m_a18 number(20,2);          f_a18 number(20,2);            c_a18 number(20,2);
    m_a19 number(20,2);          f_a19 number(20,2);            c_a19 number(20,2);
    m_all number(20,2);          f_all number(20,2);            c_all number(20,2);

    am_a1 number(20,2);           af_a1 number(20,2);             ac_a1 number(20,2);
    am_a2 number(20,2);           af_a2 number(20,2);             ac_a2 number(20,2);
    am_a3 number(20,2);           af_a3 number(20,2);             ac_a3 number(20,2);
    am_a4 number(20,2);           af_a4 number(20,2);             ac_a4 number(20,2);
    am_a5 number(20,2);           af_a5 number(20,2);             ac_a5 number(20,2);
    am_a6 number(20,2);           af_a6 number(20,2);             ac_a6 number(20,2);
    am_a7 number(20,2);           af_a7 number(20,2);             ac_a7 number(20,2);
    am_a8 number(20,2);           af_a8 number(20,2);             ac_a8 number(20,2);
    am_a9 number(20,2);           af_a9 number(20,2);             ac_a9 number(20,2);
    am_a10 number(20,2);          af_a10 number(20,2);            ac_a10 number(20,2);
    am_a11 number(20,2);          af_a11 number(20,2);            ac_a11 number(20,2);
    am_a12 number(20,2);          af_a12 number(20,2);            ac_a12 number(20,2);
    am_a13 number(20,2);          af_a13 number(20,2);            ac_a13 number(20,2);
    am_a14 number(20,2);          af_a14 number(20,2);            ac_a14 number(20,2);
    am_a15 number(20,2);          af_a15 number(20,2);            ac_a15 number(20,2);
    am_a16 number(20,2);          af_a16 number(20,2);            ac_a16 number(20,2);
    am_a17 number(20,2);          af_a17 number(20,2);            ac_a17 number(20,2);
    am_a18 number(20,2);          af_a18 number(20,2);            ac_a18 number(20,2);
    --am_a19 number(11,2);          af_a19 number(11,2);            ac_a19 number(11,2);
    am_all number(20,2);          af_all number(20,2);            ac_all number(20,2);
    --疾病合计
    dis_nan number(11,2);
    dis_nv number(11,2);
    dis_hj number(11,2);
    cursor c_data(groupId varchar2) is select
                     xx.ccd_code as code,xx.xb as xb,
                     nvl(sum(ct),0) as a,
                     nvl(sum(case xx.nl when '0岁' then xx.ct end),0) as b ,
                     nvl(sum(case xx.nl when '1～' then xx.ct end),0) as c ,
                     nvl(sum(case xx.nl when '5～' then xx.ct end),0) as d ,
                     nvl(sum(case xx.nl when '10～' then xx.ct end),0) as e ,
                     nvl(sum(case xx.nl when '15～' then xx.ct end),0) as f ,
                     nvl(sum(case xx.nl when '20～' then xx.ct end),0) as g ,
                     nvl(sum(case xx.nl when '25～' then xx.ct end),0) as h ,
                     nvl(sum(case xx.nl when '30～' then xx.ct end),0) as i ,
                     nvl(sum(case xx.nl when '35～' then xx.ct end),0) as j ,
                     nvl(sum(case xx.nl when '40～' then xx.ct end),0) as k ,
                     nvl(sum(case xx.nl when '45～' then xx.ct end),0) as l ,
                     nvl(sum(case xx.nl when '50～' then xx.ct end),0) as m ,
                     nvl(sum(case xx.nl when '55～' then xx.ct end),0) as n ,
                     nvl(sum(case xx.nl when '60～' then xx.ct end),0) as o ,
                     nvl(sum(case xx.nl when '65～' then xx.ct end),0) as p ,
                     nvl(sum(case xx.nl when '70～' then xx.ct end),0) as q ,
                     nvl(sum(case xx.nl when '75～' then xx.ct end),0) as r ,
                     nvl(sum(case xx.nl when '80～' then xx.ct end),0) as s ,
                     nvl(sum(case xx.nl when '85～' then xx.ct end),0) as t
                       from (
                     select
                     (case groupId when '2' then c.ccd_scode when '3' then c.ccd_pcode else to_char(c.ccd_code) end) ccd_code,GetAgeRangSwl(t.dt_csrq,t.dt_swrq) as nl,t.vc_xb as xb,count(1) as ct
                       from zjmb_sw_bgk t, t_icd10_cc c
                      where t.vc_gbsy is not null
                        and t.vc_gbsy = c.icd10_code
                        and t.dt_dcrq>=to_date(nvl(bkstart_date,'2000-01-01'),'yyyy-mm-dd') and t.dt_dcrq<=to_date(nvl(bkend_date,'2099-01-01'),'yyyy-mm-dd')
                        and t.dt_lrsj>=to_date(nvl(lrstart_date,'2000-01-01'),'yyyy-mm-dd') and t.dt_lrsj<=to_date(nvl(lrend_date,'2099-01-01'),'yyyy-mm-dd')
                        and t.dt_swrq>=to_date(nvl(swstart_date,'2000-01-01'),'yyyy-mm-dd') and t.dt_swrq<=to_date(nvl(swend_date,'2099-01-01'),'yyyy-mm-dd')
                        and t.vc_bgklb = '0' and t.vc_shbz in ('8','7','6','5','3') and t.vc_scbz='2'
                        and t.vc_gldwdm like ''||jddm||'%'
                      group by (case groupId when '2' then c.ccd_scode when '3' then c.ccd_pcode else to_char(c.ccd_code) end),GetAgeRangSwl(t.dt_csrq,t.dt_swrq),t.vc_xb ) xx group by xx.ccd_code,xx.xb;
  begin
      --
    nf:=substr(lrstart_date,3,2);
    --获得平均人口数据
    if (type='zjjk') then
    select vc_0nld, vc_1nld, vc_5nld, vc_10nld, vc_15nld, vc_20nld, vc_25nld, vc_30nld, vc_35nld, vc_40nld, vc_45nld, vc_50nld, vc_55nld, vc_60nld, vc_65nld, vc_70nld, vc_75nld, vc_80nld, vc_85nld, vc_nhj
      into   m_a1 ,m_a2 ,m_a3 ,m_a4 ,m_a5 ,m_a6 ,m_a7 ,m_a8 ,m_a9 ,m_a10 ,m_a11 ,m_a12 ,m_a13 ,m_a14 ,m_a15 ,m_a16 ,m_a17 ,m_a18 ,m_a19 ,m_all
      from zjmb_rkglb t where t.vc_rkglsf=33000000 and t.VC_RKGLS=99999999 and t.VC_RKGLQ=99999999 and t.VC_RKGLJD=99999999 and t.VC_NF=nf and t.vc_lx =7 and t.vc_xtlb='sw';
    select vc_0nld, vc_1nld, vc_5nld, vc_10nld, vc_15nld, vc_20nld, vc_25nld, vc_30nld, vc_35nld, vc_40nld, vc_45nld, vc_50nld, vc_55nld, vc_60nld, vc_65nld, vc_70nld, vc_75nld, vc_80nld, vc_85nld, vc_vhj
      into   f_a1 ,f_a2 ,f_a3 ,f_a4 ,f_a5 ,f_a6 ,f_a7 ,f_a8 ,f_a9 ,f_a10 ,f_a11 ,f_a12 ,f_a13 ,f_a14 ,f_a15 ,f_a16 ,f_a17 ,f_a18 ,f_a19 ,f_all
      from zjmb_rkglb t where t.vc_rkglsf=33000000 and t.VC_RKGLS=99999999 and t.VC_RKGLQ=99999999 and t.VC_RKGLJD=99999999 and t.VC_NF=nf and t.vc_lx =8 and t.vc_xtlb='sw';
    select vc_0nld, vc_1nld, vc_5nld, vc_10nld, vc_15nld, vc_20nld, vc_25nld, vc_30nld, vc_35nld, vc_40nld, vc_45nld, vc_50nld, vc_55nld, vc_60nld, vc_65nld, vc_70nld, vc_75nld, vc_80nld, vc_85nld, vc_zhj
      into   c_a1 ,c_a2 ,c_a3 ,c_a4 ,c_a5 ,c_a6 ,c_a7 ,c_a8 ,c_a9 ,c_a10 ,c_a11 ,c_a12 ,c_a13 ,c_a14 ,c_a15 ,c_a16 ,c_a17 ,c_a18 ,c_a19 ,c_all
      from zjmb_rkglb t where t.vc_rkglsf=33000000 and t.VC_RKGLS=99999999 and t.VC_RKGLQ=99999999 and t.VC_RKGLJD=99999999 and t.VC_NF=nf and t.vc_lx =9 and t.vc_xtlb='sw';
    end if;

    if (type='sjk') then
    select vc_0nld, vc_1nld, vc_5nld, vc_10nld, vc_15nld, vc_20nld, vc_25nld, vc_30nld, vc_35nld, vc_40nld, vc_45nld, vc_50nld, vc_55nld, vc_60nld, vc_65nld, vc_70nld, vc_75nld, vc_80nld, vc_85nld, vc_nhj
      into   m_a1 ,m_a2 ,m_a3 ,m_a4 ,m_a5 ,m_a6 ,m_a7 ,m_a8 ,m_a9 ,m_a10 ,m_a11 ,m_a12 ,m_a13 ,m_a14 ,m_a15 ,m_a16 ,m_a17 ,m_a18 ,m_a19 ,m_all
      from zjmb_rkglb t where t.VC_RKGLS=''||jddm||'0000' and t.VC_RKGLQ=99999999 and t.VC_RKGLJD=99999999 and t.VC_NF=nf and t.vc_lx =7 and t.vc_xtlb='sw';
    select vc_0nld, vc_1nld, vc_5nld, vc_10nld, vc_15nld, vc_20nld, vc_25nld, vc_30nld, vc_35nld, vc_40nld, vc_45nld, vc_50nld, vc_55nld, vc_60nld, vc_65nld, vc_70nld, vc_75nld, vc_80nld, vc_85nld, vc_vhj
      into   f_a1 ,f_a2 ,f_a3 ,f_a4 ,f_a5 ,f_a6 ,f_a7 ,f_a8 ,f_a9 ,f_a10 ,f_a11 ,f_a12 ,f_a13 ,f_a14 ,f_a15 ,f_a16 ,f_a17 ,f_a18 ,f_a19 ,f_all
      from zjmb_rkglb t where t.VC_RKGLS=''||jddm||'0000' and t.VC_RKGLQ=99999999 and t.VC_RKGLJD=99999999 and t.VC_NF=nf and t.vc_lx =8 and t.vc_xtlb='sw';
    select vc_0nld, vc_1nld, vc_5nld, vc_10nld, vc_15nld, vc_20nld, vc_25nld, vc_30nld, vc_35nld, vc_40nld, vc_45nld, vc_50nld, vc_55nld, vc_60nld, vc_65nld, vc_70nld, vc_75nld, vc_80nld, vc_85nld, vc_zhj
      into   c_a1 ,c_a2 ,c_a3 ,c_a4 ,c_a5 ,c_a6 ,c_a7 ,c_a8 ,c_a9 ,c_a10 ,c_a11 ,c_a12 ,c_a13 ,c_a14 ,c_a15 ,c_a16 ,c_a17 ,c_a18 ,c_a19 ,c_all
      from zjmb_rkglb t where t.VC_RKGLS=''||jddm||'0000' and t.VC_RKGLQ=99999999 and t.VC_RKGLJD=99999999 and t.VC_NF=nf and t.vc_lx =9 and t.vc_xtlb='sw';
    end if;

    if (type='qjk') then
    select vc_0nld, vc_1nld, vc_5nld, vc_10nld, vc_15nld, vc_20nld, vc_25nld, vc_30nld, vc_35nld, vc_40nld, vc_45nld, vc_50nld, vc_55nld, vc_60nld, vc_65nld, vc_70nld, vc_75nld, vc_80nld, vc_85nld, vc_nhj
      into   m_a1 ,m_a2 ,m_a3 ,m_a4 ,m_a5 ,m_a6 ,m_a7 ,m_a8 ,m_a9 ,m_a10 ,m_a11 ,m_a12 ,m_a13 ,m_a14 ,m_a15 ,m_a16 ,m_a17 ,m_a18 ,m_a19 ,m_all
      from zjmb_rkglb t where t.VC_RKGLQ=''||jddm||'00' and t.VC_RKGLJD=99999999 and t.VC_NF=nf and t.vc_lx =7;
    select vc_0nld, vc_1nld, vc_5nld, vc_10nld, vc_15nld, vc_20nld, vc_25nld, vc_30nld, vc_35nld, vc_40nld, vc_45nld, vc_50nld, vc_55nld, vc_60nld, vc_65nld, vc_70nld, vc_75nld, vc_80nld, vc_85nld, vc_vhj
      into   f_a1 ,f_a2 ,f_a3 ,f_a4 ,f_a5 ,f_a6 ,f_a7 ,f_a8 ,f_a9 ,f_a10 ,f_a11 ,f_a12 ,f_a13 ,f_a14 ,f_a15 ,f_a16 ,f_a17 ,f_a18 ,f_a19 ,f_all
      from zjmb_rkglb t where t.VC_RKGLQ=''||jddm||'00' and t.VC_RKGLJD=99999999 and t.VC_NF=nf and t.vc_lx =8;
    select vc_0nld, vc_1nld, vc_5nld, vc_10nld, vc_15nld, vc_20nld, vc_25nld, vc_30nld, vc_35nld, vc_40nld, vc_45nld, vc_50nld, vc_55nld, vc_60nld, vc_65nld, vc_70nld, vc_75nld, vc_80nld, vc_85nld, vc_zhj
      into   c_a1 ,c_a2 ,c_a3 ,c_a4 ,c_a5 ,c_a6 ,c_a7 ,c_a8 ,c_a9 ,c_a10 ,c_a11 ,c_a12 ,c_a13 ,c_a14 ,c_a15 ,c_a16 ,c_a17 ,c_a18 ,c_a19 ,c_all
      from zjmb_rkglb t where t.VC_RKGLQ=''||jddm||'00' and t.VC_RKGLJD=99999999 and t.VC_NF=nf and t.vc_lx =9;
    end if;

    --获得标化人口数
    select vc_0nld, vc_5nld, vc_10nld, vc_15nld, vc_20nld, vc_25nld, vc_30nld, vc_35nld, vc_40nld, vc_45nld, vc_50nld, vc_55nld, vc_60nld, vc_65nld, vc_70nld, vc_75nld, vc_80nld, vc_85nld, vc_zhj
    into   am_a1 ,am_a2 ,am_a3 ,am_a4 ,am_a5 ,am_a6 ,am_a7 ,am_a8 ,am_a9 ,am_a10 ,am_a11 ,am_a12 ,am_a13 ,am_a14 ,am_a15 ,am_a16 ,am_a17 ,am_a18 ,am_all
    from zjmb_bzrkb t where t.vc_lb ='中国2000年' and t.vc_xb='男性';

    select vc_0nld, vc_5nld, vc_10nld, vc_15nld, vc_20nld, vc_25nld, vc_30nld, vc_35nld, vc_40nld, vc_45nld, vc_50nld, vc_55nld, vc_60nld, vc_65nld, vc_70nld, vc_75nld, vc_80nld, vc_85nld, vc_zhj
    into   af_a1 ,af_a2 ,af_a3 ,af_a4 ,af_a5 ,af_a6 ,af_a7 ,af_a8 ,af_a9 ,af_a10 ,af_a11 ,af_a12 ,af_a13 ,af_a14 ,af_a15 ,af_a16 ,af_a17 ,af_a18 ,af_all
    from zjmb_bzrkb t where t.vc_lb ='中国2000年' and t.vc_xb='女性';

    select vc_0nld, vc_5nld, vc_10nld, vc_15nld, vc_20nld, vc_25nld, vc_30nld, vc_35nld, vc_40nld, vc_45nld, vc_50nld, vc_55nld, vc_60nld, vc_65nld, vc_70nld, vc_75nld, vc_80nld, vc_85nld, vc_zhj
    into   ac_a1 ,ac_a2 ,ac_a3 ,ac_a4 ,ac_a5 ,ac_a6 ,ac_a7 ,ac_a8 ,ac_a9 ,ac_a10 ,ac_a11 ,ac_a12 ,ac_a13 ,ac_a14 ,ac_a15 ,ac_a16 ,ac_a17 ,ac_a18 ,ac_all
    from zjmb_bzrkb t where t.vc_lb ='中国2000年' and t.vc_xb='合计';

    delete from TEMP_ZJJK_REPORT;
    commit;


    for e in c_pre loop
        sqlstr := ' insert into TEMP_ZJJK_REPORT (A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y) values (''2'','''||e.ccd_code||''','''||e.ccd_name||''',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0) ';
        execute immediate(sqlstr);
    end loop;
    for e in c_pre loop
        sqlstr := ' insert into TEMP_ZJJK_REPORT (A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y) values (''1'','''||e.ccd_code||''','''||e.ccd_name||''',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0) ';
        execute immediate(sqlstr);
    end loop;

    commit;

    /**明细统计**/
    for x in c_data('1') loop
        sqlstr := 'UPDATE TEMP_ZJJK_REPORT tb
            SET tb.d = '''||x.a||''', tb.e = '''||x.b||''', tb.f = '''||x.c||''',
                tb.g = '''||x.d||''', tb.h = '''||x.e||''', tb.i = '''||x.f||''',
                tb.j = '''||x.g||''', tb.k = '''||x.h||''', tb.l = '''||x.i||''',
                tb.m = '''||x.j||''', tb.n = '''||x.k||''', tb.o = '''||x.l||''',
                tb.p = '''||x.m||''', tb.q = '''||x.n||''', tb.r = '''||x.o||''',
                tb.s = '''||x.p||''', tb.t = '''||x.q||''', tb.u = '''||x.r||''',
                tb.v = '''||x.s||''', tb.w = '''||x.t||''',tb.x = '''||x.a||'''
            where tb.b='''||x.code||''' and tb.a='''||x.xb||'''';
        execute immediate(sqlstr);
    end loop;



    /**小类统计**/
    for x in c_data('2') loop
        sqlstr := 'UPDATE TEMP_ZJJK_REPORT tb
            SET tb.d = '''||x.a||''', tb.e = '''||x.b||''', tb.f = '''||x.c||''',
                tb.g = '''||x.d||''', tb.h = '''||x.e||''', tb.i = '''||x.f||''',
                tb.j = '''||x.g||''', tb.k = '''||x.h||''', tb.l = '''||x.i||''',
                tb.m = '''||x.j||''', tb.n = '''||x.k||''', tb.o = '''||x.l||''',
                tb.p = '''||x.m||''', tb.q = '''||x.n||''', tb.r = '''||x.o||''',
                tb.s = '''||x.p||''', tb.t = '''||x.q||''', tb.u = '''||x.r||''',
                tb.v = '''||x.s||''', tb.w = '''||x.t||''',tb.x = '''||x.a||'''
            where tb.b='''||x.code||''' and tb.a='''||x.xb||'''';
        execute immediate(sqlstr);
    end loop;


    /**大类统计**/
    for x in c_data('3') loop
        sqlstr := 'UPDATE TEMP_ZJJK_REPORT tb
            SET tb.d = '''||x.a||''', tb.e = '''||x.b||''', tb.f = '''||x.c||''',
                tb.g = '''||x.d||''', tb.h = '''||x.e||''', tb.i = '''||x.f||''',
                tb.j = '''||x.g||''', tb.k = '''||x.h||''', tb.l = '''||x.i||''',
                tb.m = '''||x.j||''', tb.n = '''||x.k||''', tb.o = '''||x.l||''',
                tb.p = '''||x.m||''', tb.q = '''||x.n||''', tb.r = '''||x.o||''',
                tb.s = '''||x.p||''', tb.t = '''||x.q||''', tb.u = '''||x.r||''',
                tb.v = '''||x.s||''', tb.w = '''||x.t||''',tb.x = '''||x.a||''',tb.z=1
            where tb.b='''||x.code||''' and tb.a='''||x.xb||'''';
        execute immediate(sqlstr);
    end loop;





    --处理合计
    for e in c_pre loop
        sqlstr := ' insert into temp_zjjk_report select a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,null,null,null,null from (
                        select ''0'' as a,t.b,t.c,sum(d)d,sum(e)e,sum(f)f,sum(g)g,sum(h)h,sum(i)i,sum(j)j,sum(k)k,sum(l)l,sum(m)m,sum(n)n,sum(o)o,sum(p)p,sum(q)q,sum(r)r,sum(s)s,sum(t)t,sum(u)u,sum(v)v,sum(w)w,sum(x)x,sum(y)y,max(z)z
                        from temp_zjjk_report t where t.b='''||e.ccd_code||''' group by t.b,t.c)';
        execute immediate(sqlstr);
    end loop;


    --处理构成比
    select sum(t.d) into dis_nan from TEMP_ZJJK_REPORT t where t.a='1' and t.z=1;
    select sum(t.d) into dis_nv from TEMP_ZJJK_REPORT t where t.a='2' and t.z=1;
    select sum(t.d) into dis_hj from TEMP_ZJJK_REPORT t where t.a='0' and t.z=1;
    update TEMP_ZJJK_REPORT t set t.y = t.d/dis_nan where t.a='1';
    update TEMP_ZJJK_REPORT t set t.y = t.d/dis_nv where t.a='2';
    update TEMP_ZJJK_REPORT t set t.y = t.d/dis_hj where t.a='0';


    --处理小计
     insert into temp_zjjk_report select a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,null,null,null,null,null from (
     select t.a as a,'1' b,'总计' c,sum(d)d,sum(e)e,sum(f)f,sum(g)g,sum(h)h,sum(i)i,sum(j)j,sum(k)k,sum(l)l,sum(m)m,sum(n)n,sum(o)o,sum(p)p,sum(q)q,sum(r)r,sum(s)s,sum(t)t,sum(u)u,sum(v)v,sum(w)w,sum(x)x,sum(y)y
     from temp_zjjk_report t where t.z='1' group by t.a);



    update TEMP_ZJJK_REPORT t
        set t.d = t.d/m_all , t.e = t.e/m_a1 , t.f = t.f/m_a2 , t.g = t.g/m_a3,
            t.h = t.h/m_a4 , t.i = t.i/m_a5 , t.j = t.j/m_a6 , t.k = t.k/m_a7,
            t.l = t.l/m_a8 , t.m = t.m/m_a9 , t.n = t.n/m_a10 , t.o = t.o/m_a11,
            t.p = t.p/m_a12 , t.q = t.q/m_a13 , t.r = t.r/m_a14 , t.s = t.s/m_a15,
            t.t = t.t/m_a16 , t.u = t.u/m_a17 , t.v = t.v/m_a18 , t.w = t.w/m_a19
        where t.a = '1';
    update TEMP_ZJJK_REPORT t
        set t.d = t.d/f_all , t.e = t.e/f_a1 , t.f = t.f/f_a2 , t.g = t.g/f_a3,
            t.h = t.h/f_a4 , t.i = t.i/f_a5 , t.j = t.j/f_a6 , t.k = t.k/f_a7,
            t.l = t.l/f_a8 , t.m = t.m/f_a9 , t.n = t.n/f_a10 , t.o = t.o/f_a11,
            t.p = t.p/f_a12 , t.q = t.q/f_a13 , t.r = t.r/f_a14 , t.s = t.s/f_a15,
            t.t = t.t/f_a16 , t.u = t.u/f_a17 , t.v = t.v/f_a18 , t.w = t.w/f_a19
        where t.a = '2';
    update TEMP_ZJJK_REPORT t
        set t.d = t.d/c_all , t.e = t.e/c_a1 , t.f = t.f/c_a2 , t.g = t.g/c_a3,
            t.h = t.h/c_a4 , t.i = t.i/c_a5 , t.j = t.j/c_a6 , t.k = t.k/c_a7,
            t.l = t.l/c_a8 , t.m = t.m/c_a9 , t.n = t.n/c_a10 , t.o = t.o/c_a11,
            t.p = t.p/c_a12 , t.q = t.q/c_a13 , t.r = t.r/c_a14 , t.s = t.s/c_a15,
            t.t = t.t/c_a16 , t.u = t.u/c_a17 , t.v = t.v/c_a18 , t.w = t.w/c_a19
        where t.a = '0';


  open myrc for select * from temp_zjjk_report t order by t.a,to_number(t.b);
  commit;
  end;


end ZJJK_SW_REPORT;

