create or replace procedure      ZJJK_SHJC
is
 p_cur1  zjjk_report.refcursor;
 p_cur2  zjjk_report.refcursor;
  a0     varchar2(100);
  a1     varchar2(100);
  a2     integer;
  a3     varchar2(100);
  i      integer;
  begin
       update zjmb_shjc_bgk t set vc_bgkid='0';
       commit;
       open p_cur1 for
       select t.vc_jkdw a0,t.vc_id a1 from zjmb_shjc_bgk t;
        loop
        fetch p_cur1 into a0,a1;
        exit when p_cur1%notfound;
        select max(t.vc_bgkid)+1 a2 into a2 from zjmb_shjc_bgk t where t.vc_jkdw=a0;
    if (a2 = 1) then
      a3 := '09'||substr(a0,3)||'00001';
    else
      a3 := '0'||a2;
    end if;
        --dbms_output.put_line(a1 || '========' || a2 ||'=========' || a3);
      update zjmb_shjc_bgk t set  t.vc_bgkid=a3
             where t.vc_id=a1 ;
      update zjmb_shjc_bgkdjc t set  t.vc_bgkid=a3
             where t.vc_id=a1 ;
        commit;
      end loop;
      close p_cur1;


end ZJJK_SHJC;

