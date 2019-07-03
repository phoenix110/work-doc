CREATE OR REPLACE Procedure exe_rp_detail is
v_initial NUMBER(10,0);
begin
  declare
       --类型游标操作需要插入的数据
       cursor c_detail
       is
       select t.bbid,t.bdflbs,t.jgdm,t.sjfl,t.tjnd ,tjyd,tjjd from rp_bdkz t where t.txzt=0  and nvl(t.xfbz,'0') = '0' order by t.bdflbs;
       --定义一个游标变量v_cinfo c_emp%ROWTYPE ，该类型为游标c_emp中的一行数据类型
       c_bdkz c_detail%rowtype;
    begin
       for c_bdkz in c_detail loop
        --更新下发标识
         update rp_bdkz a
            set a.xfbz = '1'
          where a.bbid = c_bdkz.bbid;
         --初始化数据
         v_initial:=0;
         --插入45类报表
         if c_bdkz.bdflbs='1' then
           insert into rp_rkfnlxb (rid,bbid) values (SYS_GUID,c_bdkz.bbid);
         elsif c_bdkz.bdflbs='2' then
           insert into rp_czrk_bdqk (rid,bbid) values (SYS_GUID,c_bdkz.bbid);
         elsif c_bdkz.bdflbs='3' then
           insert into rp_rkfnlxb (rid,bbid) values (SYS_GUID,c_bdkz.bbid);
         elsif c_bdkz.bdflbs='4' then
           insert into rp_ldrk_bdqk (rid,bbid) values (SYS_GUID,c_bdkz.bbid);
         elsif c_bdkz.bdflbs='5' then
           insert into rp_Czrk_Jkdahz (rid,bbid) values (SYS_GUID,c_bdkz.bbid);
         elsif c_bdkz.bdflbs='6' then
           insert into rp_Czrk_Grdahz (rid,bbid) values (SYS_GUID,c_bdkz.bbid);
         elsif c_bdkz.bdflbs='7' then
           insert into rp_Ldrk_Jtdahz (rid,bbid) values (SYS_GUID,c_bdkz.bbid);
         elsif c_bdkz.bdflbs='8' then
           insert into rp_Ldrk_Grdahz (rid,bbid) values (SYS_GUID,c_bdkz.bbid);
         elsif c_bdkz.bdflbs='9' then
           insert into rp_Czrk_Jkdazk (rid,bbid) values (SYS_GUID,c_bdkz.bbid);
         elsif c_bdkz.bdflbs='10' then
           insert into RP_LDRK_JKDAZK (rid,bbid) values (SYS_GUID,c_bdkz.bbid);
         elsif c_bdkz.bdflbs='11' then
           begin
            select x.nc into v_initial  from (
                   select xb.NMDJHZS as nc from rp_Gxy_Hzsqgzqk xb join rp_bdkz a on  xb.bbid=a.bbid
                             and a.jgdm=c_bdkz.jgdm and  a.bdflbs=c_bdkz.bdflbs
                                 and  ncdjhzs >=1  order by jzsj desc
                                       ) x where rownum=1;
                                       exception
                                         when no_data_found   then
                                           v_initial :=0;
                                           end;
           insert into rp_Gxy_Hzsqgzqk (rid,bbid,NCDJHZS) values (SYS_GUID,c_bdkz.bbid,v_initial);
         elsif c_bdkz.bdflbs='12' then
           begin
            select x.nc into v_initial  from (
                   select xb.NMDJHZS as nc from rp_Gxy_Hzsqgzqk xb join rp_bdkz a on  xb.bbid=a.bbid
                             and a.jgdm=c_bdkz.jgdm and  a.bdflbs=c_bdkz.bdflbs
                                 and  ncdjhzs >=1 order by jzsj desc
                                       ) x where rownum=1;
                                         exception
                                         when no_data_found   then
                                           v_initial :=0;
                                           end;
           insert into rp_Gxy_Hzsqgzqk (rid,bbid,NCDJHZS) values (SYS_GUID,c_bdkz.bbid,v_initial);
         elsif c_bdkz.bdflbs='13' then
           begin
            select x.nc into v_initial  from (
                   select xb.NMDJHZS as nc from rp_Gxy_Hzsqgzqk xb join rp_bdkz a on  xb.bbid=a.bbid
                             and a.jgdm=c_bdkz.jgdm and  a.bdflbs=c_bdkz.bdflbs
                                 and  ncdjhzs >=1 order by jzsj desc
                                       ) x where rownum=1;
                                         exception
                                         when no_data_found   then
                                           v_initial :=0;
                                           end;
           insert into rp_Gxy_Hzsqgzqk (rid,bbid,NCDJHZS) values (SYS_GUID,c_bdkz.bbid,v_initial);
         elsif c_bdkz.bdflbs='14' then
           begin
            select x.nc into v_initial  from (
                   select xb.NMDJHZS as nc from rp_Gxy_Hzsqgzqk xb join rp_bdkz a on  xb.bbid=a.bbid
                             and a.jgdm=c_bdkz.jgdm and  a.bdflbs=c_bdkz.bdflbs
                                 and  ncdjhzs >=1   order by jzsj desc
                                       ) x where rownum=1;
                                         exception
                                         when no_data_found   then
                                           v_initial :=0;
                                           end;
           insert into rp_Gxy_Hzsqgzqk (rid,bbid,NCDJHZS) values (SYS_GUID,c_bdkz.bbid,v_initial);
         elsif c_bdkz.bdflbs='15' then
           insert into rp_Gxy_Gzsqglxg (rid,bbid) values (SYS_GUID,c_bdkz.bbid);
         elsif c_bdkz.bdflbs='16' then
           insert into rp_Gxy_Gzsqglxg (rid,bbid) values (SYS_GUID,c_bdkz.bbid);
         elsif c_bdkz.bdflbs='17' then
           insert into rp_Gxy_Gzsqglxg (rid,bbid) values (SYS_GUID,c_bdkz.bbid);
         elsif c_bdkz.bdflbs='18' then
           insert into rp_Gxy_Gzsqglxg (rid,bbid) values (SYS_GUID,c_bdkz.bbid);
         elsif c_bdkz.bdflbs='19' then
           begin
              select x.nc into v_initial  from (
                   select xb.NMDJRS as nc from rp_Gxy_Gwrqgzqk xb join rp_bdkz a on  xb.bbid=a.bbid
                             and a.jgdm=c_bdkz.jgdm and  a.bdflbs=c_bdkz.bdflbs
                                 and  xb.NCDJRS >=1 order by jzsj desc
                                       ) x where rownum=1;
                                         exception
                                         when no_data_found   then
                                           v_initial :=0;
                                           end;
           insert into rp_Gxy_Gwrqgzqk (rid,bbid,NCDJRS) values (SYS_GUID,c_bdkz.bbid,v_initial);
         elsif c_bdkz.bdflbs='20' then
           insert into rp_Gxy_Jcswyscyqk (rid,bbid) values (SYS_GUID,c_bdkz.bbid);
         elsif c_bdkz.bdflbs='21' then
           insert into rp_Gxy_Xjysswyscyqk (rid,bbid) values (SYS_GUID,c_bdkz.bbid);
         elsif c_bdkz.bdflbs='22' then
           insert into rp_Gxy_Sqgzzk (rid,bbid) values (SYS_GUID,c_bdkz.bbid);
         elsif c_bdkz.bdflbs='23' then
           begin
            select x.nc into v_initial  from (
                   select xb.NMDJHZS as nc from rp_Tnb_Cgglsqgzqk xb join rp_bdkz a on  xb.bbid=a.bbid
                             and a.jgdm=c_bdkz.jgdm and  a.bdflbs=c_bdkz.bdflbs
                                 and  xb.NCDJHZS >=1   order by jzsj desc
                                       ) x where rownum=1;
                                         exception
                                         when no_data_found   then
                                           v_initial :=0;
                                           end;
           insert into rp_Tnb_Cgglsqgzqk (rid,bbid,NCDJHZS) values (SYS_GUID,c_bdkz.bbid,v_initial);
         elsif c_bdkz.bdflbs='24' then
           begin
            select x.nc into v_initial  from (
                   select xb.NMDJHZS as nc from rp_Tnb_Cgglsqgzqk xb join rp_bdkz a on  xb.bbid=a.bbid
                             and a.jgdm=c_bdkz.jgdm and  a.bdflbs=c_bdkz.bdflbs
                                 and  xb.NCDJHZS >=1   order by jzsj desc
                                       ) x where rownum=1;
                                         exception
                                         when no_data_found   then
                                           v_initial :=0;
                                           end;
           insert into rp_Tnb_Cgglsqgzqk (rid,bbid,NCDJHZS) values (SYS_GUID,c_bdkz.bbid,v_initial);
         elsif c_bdkz.bdflbs='25' then
           begin
            select x.nc into v_initial  from (
                   select xb.NMDJHZS as nc from rp_Tnb_Cgglsqgzqk xb join rp_bdkz a on  xb.bbid=a.bbid
                             and a.jgdm=c_bdkz.jgdm and  a.bdflbs=c_bdkz.bdflbs
                                 and  xb.NCDJHZS >=1 order by jzsj desc
                                       ) x where rownum=1;
                                         exception
                                         when no_data_found   then
                                           v_initial :=0;
                                           end;
           insert into rp_Tnb_Cgglsqgzqk (rid,bbid,NCDJHZS) values (SYS_GUID,c_bdkz.bbid,v_initial);
         elsif c_bdkz.bdflbs='26' then
           insert into rp_Tnb_Cgglsqglxg (rid,bbid) values (SYS_GUID,c_bdkz.bbid);
         elsif c_bdkz.bdflbs='27' then
           insert into rp_Tnb_Cgglsqglxg (rid,bbid) values (SYS_GUID,c_bdkz.bbid);
         elsif c_bdkz.bdflbs='28' then
           insert into rp_Tnb_Cgglsqglxg (rid,bbid) values (SYS_GUID,c_bdkz.bbid);
         elsif c_bdkz.bdflbs='29' then
           begin
             select x.nc into v_initial  from (
                   select xb.NMDJRS as nc from rp_Tnb_Gwrqsqgzqk xb join rp_bdkz a on  xb.bbid=a.bbid
                             and a.jgdm=c_bdkz.jgdm and  a.bdflbs=c_bdkz.bdflbs
                                 and  xb.NCDJRS >=1 order by jzsj desc
                                       ) x where rownum=1;
                                         exception
                                         when no_data_found   then
                                           v_initial :=0;
                                           end;
           insert into rp_Tnb_Gwrqsqgzqk (rid,bbid,NCDJRS) values (SYS_GUID,c_bdkz.bbid,v_initial);
         elsif c_bdkz.bdflbs='30' then
           insert into rp_Tnb_Jcswyscxtqk (rid,bbid) values (SYS_GUID,c_bdkz.bbid);
         elsif c_bdkz.bdflbs='31' then
           insert into rp_Tnb_Qjysswyscxtqk (rid,bbid) values (SYS_GUID,c_bdkz.bbid);
         elsif c_bdkz.bdflbs='32' then
           insert into rp_Tnb_Sqglgzzk (rid,bbid) values (SYS_GUID,c_bdkz.bbid);
         elsif c_bdkz.bdflbs='33' then
           begin
            select x.nc into v_initial  from (
                   select xb.NMDJHZS as nc from rp_Jsb_Bqwdsqgzqk xb join rp_bdkz a on  xb.bbid=a.bbid
                             and a.jgdm=c_bdkz.jgdm and  a.bdflbs=c_bdkz.bdflbs
                                 and  xb.NCDJHZS >=1   order by jzsj desc
                                       ) x where rownum=1;
                                         exception
                                         when no_data_found   then
                                           v_initial :=0;
                                           end;
           insert into rp_Jsb_Bqwdsqgzqk (rid,bbid,NCDJHZS) values (SYS_GUID,c_bdkz.bbid,v_initial);
         elsif c_bdkz.bdflbs='34' then
           begin
            select x.nc into v_initial  from (
                   select xb.NMDJHZS as nc from rp_Jsb_Bqwdsqgzqk xb join rp_bdkz a on  xb.bbid=a.bbid
                             and a.jgdm=c_bdkz.jgdm and  a.bdflbs=c_bdkz.bdflbs
                                 and  xb.NCDJHZS >=1   order by jzsj desc
                                       ) x where rownum=1;
                                         exception
                                         when no_data_found   then
                                           v_initial :=0;
                                           end;
           insert into rp_Jsb_Bqwdsqgzqk (rid,bbid,NCDJHZS) values (SYS_GUID,c_bdkz.bbid,v_initial);
         elsif c_bdkz.bdflbs='35' then
           begin
            select x.nc into v_initial  from (
                   select xb.NMDJHZS as nc from rp_Jsb_Bqwdsqgzqk xb join rp_bdkz a on  xb.bbid=a.bbid
                             and a.jgdm=c_bdkz.jgdm and  a.bdflbs=c_bdkz.bdflbs
                                 and  xb.NCDJHZS >=1   order by jzsj desc
                                       ) x where rownum=1;
                                         exception
                                         when no_data_found   then
                                           v_initial :=0;
                                           end;
           insert into rp_Jsb_Bqwdsqgzqk (rid,bbid,NCDJHZS) values (SYS_GUID,c_bdkz.bbid,v_initial);
         elsif c_bdkz.bdflbs='36' then
           begin
            select x.nc into v_initial  from (
                   select xb.NMDJHZS as nc from rp_Jsb_Bqwdsqgzqk xb join rp_bdkz a on  xb.bbid=a.bbid
                             and a.jgdm=c_bdkz.jgdm and  a.bdflbs=c_bdkz.bdflbs
                                 and  xb.NCDJHZS >=1   order by jzsj desc
                                       ) x where rownum=1;
                                         exception
                                         when no_data_found   then
                                           v_initial :=0;
                                           end;
           insert into rp_Jsb_Bqwdsqgzqk (rid,bbid,NCDJHZS) values (SYS_GUID,c_bdkz.bbid,v_initial);
         elsif c_bdkz.bdflbs='37' then
           insert into rp_Jsb_Bqwdsqglxg (rid,bbid) values (SYS_GUID,c_bdkz.bbid);
         elsif c_bdkz.bdflbs='38' then
           insert into rp_Jsb_Bqwdsqglxg (rid,bbid) values (SYS_GUID,c_bdkz.bbid);
         elsif c_bdkz.bdflbs='39' then
           insert into rp_Jsb_Bqwdsqglxg (rid,bbid) values (SYS_GUID,c_bdkz.bbid);
         elsif c_bdkz.bdflbs='40' then
           insert into rp_Jsb_Bqwdsqglxg (rid,bbid) values (SYS_GUID,c_bdkz.bbid);
         elsif c_bdkz.bdflbs='41' then
           insert into rp_Jsb_Sqgzqk (rid,bbid) values (SYS_GUID,c_bdkz.bbid);
         elsif c_bdkz.bdflbs='42' then
           begin
            select x.nc into v_initial  from (
                   select xb.NMDJHZS as nc from rp_Gxy_Hzsqgzqk xb join rp_bdkz a on  xb.bbid=a.bbid
                           and  a.sjfl=c_bdkz.sjfl  and a.jgdm=c_bdkz.jgdm and  a.bdflbs=c_bdkz.bdflbs
                                 and  xb.NCDJHZS >=1    order by jzsj desc
                                       ) x where rownum=1;
                                         exception
                                         when no_data_found   then
                                           v_initial :=0;
                                           end;
           insert into rp_Gxy_Hzsqgzqk (rid,bbid,NCDJHZS) values (SYS_GUID,c_bdkz.bbid,v_initial);
         elsif c_bdkz.bdflbs='43' then
           begin
             select x.nc into v_initial  from (
                   select xb.NMDJHZS as nc from rp_Gxy_Hzsqgzqk xb join rp_bdkz a on  xb.bbid=a.bbid
                             and a.jgdm=c_bdkz.jgdm and  a.bdflbs=c_bdkz.bdflbs
                                 and  xb.NCDJHZS >=1   order by jzsj desc
                                       ) x where rownum=1;
                                         exception
                                         when no_data_found   then
                                           v_initial :=0;
                                           end;
           insert into rp_Tnb_Cgglsqgzqk (rid,bbid,NCDJHZS) values (SYS_GUID,c_bdkz.bbid,v_initial);
         elsif c_bdkz.bdflbs='44' then
           insert into rp_Gxy_Sqgzzk (rid,bbid) values (SYS_GUID,c_bdkz.bbid);
         elsif c_bdkz.bdflbs='45' then
           insert into rp_Tnb_Sqglgzzk (rid,bbid) values (SYS_GUID,c_bdkz.bbid);
         end if;
         --COMMIT;
       end loop;
       commit;
    end;

end;
