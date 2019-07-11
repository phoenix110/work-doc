create or replace procedure      updateGJSJDR
is
 p_cur1  zjjk_report.refcursor;
  a0     date;
  a1     date;
  a2     varchar2(100);
  a3     varchar2(100);
  a4     date;
  a5     varchar2(100);
  a6     date;
  i      integer;
  begin

       open p_cur1 for
       select to_date(t.vc_swsj, 'yyyy-MM-dd') a,to_date(t.vc_csrq,'yyyy-MM-dd') b
       ,t.vc_nl c
       ,to_date(t.vc_lrsj,'yyyy-MM-dd') d
       ,to_date(t.vc_shsj,'yyyy-MM-dd') g
       ,t1.vc_bgkid e,t.vc_bgkid f
 from  zjjk_swbgk_temp1 t left join zjmb_sw_bgk t1
 on t1.vc_xm = t.vc_szxm
 where to_date(t.vc_ystkrq,'yyyy-MM-dd') = t1.dt_dcrq and t.vc_bgkid in (
 select t.vc_bgkid
     from zjjk_swbgk_temp1 t
  left join zjmb_sw_bgk t1 on t.vc_szxm = t1.vc_xm
  --left join t_icd10 t2 on upper(t.vc_zjdzswjbicd1) = t2.icd10_code
 where to_date(t.vc_ystkrq,'yyyy-mm-dd') = t1.dt_dcrq group by t.vc_bgkid having count(t.vc_bgkid)=1);
        loop
        a0:=null;
        a1:=null;
        a2:=null;
        a3:=null;
        a4:=null;
        a5:=null;
        a6:=null;
        fetch p_cur1 into a0,a1,a2,a4,a6,a3,a5;
        exit when p_cur1%notfound;

    if (length(trim(a2)) = 2) then
      a2 := substr(a2,1,1);
    else
      a2 := substr(a2,1,2);
    end if;
      update zjmb_sw_bgk t set  t.dt_swrq=a0,t.dt_csrq=a1--,t.vc_sznl=a2
      ,t.dt_lrsj=a4,t.dt_shsj=a6
             where t.vc_bgkid=a3 ;
       insert into zjjk_swbgk_temp2 (select * from zjjk_swbgk_temp1 where vc_bgkid=a5);
        commit;
      end loop;
      close p_cur1;
end updateGJSJDR;

