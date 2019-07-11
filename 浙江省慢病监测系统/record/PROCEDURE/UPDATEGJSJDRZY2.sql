create or replace procedure      updateGJSJDRZY2
is
 p_cur1  zjjk_report.refcursor;
 zy_cur  zjjk_report.refcursor;
  a0     varchar2(100);
  a1     varchar2(100);
  a2     varchar2(100);
  a3     varchar2(100);
  a4     date;
  a5     varchar2(100);
  a6     varchar2(100);
  i      integer;
  begin

       open p_cur1 for
       select t.vc_zyzyjgzbm,t.vc_whcdbm,t1.vc_zy,t1.vc_bgkid
 from  zjjk_swbgk_temp t left join zjmb_sw_bgk t1
 on t1.vc_xm = t.vc_szxm
 where to_date(t.vc_swsj,'yyyy-mm-dd') = t1.dt_swrq and t.vc_bgkid in (



 select t.vc_bgkid
     from zjjk_swbgk_temp1 t
  left join zjmb_sw_bgk t1 on t.vc_szxm = t1.vc_xm
  --left join t_icd10 t2 on upper(t.vc_zjdzswjbicd1) = t2.icd10_code
 where to_date(t.vc_swsj,'yyyy-mm-dd') = t1.dt_swrq group by t.vc_bgkid having count(t.vc_bgkid)=1)
       and  not exists ( select t2.vc_bgkid
       from zjjk_swbgk_temp2 t2 where t.vc_bgkid=t2.vc_bgkid)
       and  not exists ( select t3.vc_bgkid
       from zjjk_swbgk_temp3 t3 where t.vc_bgkid=t3.vc_bgkid);
        loop
        exit when p_cur1%notfound;
        a0:=null;
        a1:=null;
        a2:=null;
        a3:=null;
        a4:=null;
        a5:=null;
        a6:=null;
        fetch p_cur1 into a0,a5,a1,a2;

    if (a5 = '1') then
      a6 := '4';
    end if;
    if (a5 = '2') then
      a6 := '3';
    end if;
    if (a5 = '3') then
      a6 := '2';
    end if;
    if (a5 = '4') then
      a6 := '1';
    end if;
    if (a5 = '9') then
      a6 := '9';
    end if;
    open zy_cur for
    select t.code from code_info t where code_info_id ='1184' and description like '%'||a0||'%';
    loop
    fetch zy_cur into a3 ;
    exit when zy_cur%notfound;
    end loop;
    close zy_cur;

      update zjmb_sw_bgk t set  t.vc_zy=a3,t.vc_whcd=a6 where t.vc_bgkid=a2 ;
        commit;
      end loop;
      close p_cur1;
end updateGJSJDRZY2;

