create or replace procedure      updateHJDZ2
is
p_cur1  zjjk_report.refcursor;

p_cur2  zjjk_report.refcursor;
p_cur3  zjjk_report.refcursor;
p_cur4  zjjk_report.refcursor;
p_cur5  zjjk_report.refcursor;
p_cur6  zjjk_report.refcursor;

  a0     varchar2(100);
  a1     varchar2(100);
  a2     varchar2(100);
  a3     varchar2(100);
  a4     varchar2(100);
  a5     varchar2(100);
  a6     varchar2(100);
  a7     varchar2(100);
  a8     varchar2(100);
  a9     varchar2(100);
  a10     varchar2(100);
  a11     varchar2(100);
  a12     varchar2(100);
  a13     varchar2(100);
  a14     varchar2(100);
  a15     varchar2(100);
 -- i      integer;
  begin

  open p_cur1 for
     select t1.vc_bgkid,
     upper(t.vc_zjdzswjbicd1),
     upper(t.vc_zjdzswjbicd2),
     upper(t.vc_zjdzswjbicd3),
     upper(t.vc_zjdzswjbicd4),
     upper(t.vc_Qtjbzdidc) ,
     t.Vc_Zjdzswjb1,
     t.Vc_Zjdzswjb2,
     t.Vc_Zjdzswjb3,
     t.Vc_Zjdzswjb4,
     t.Vc_Qtjbzd
     from zjjk_swbgk_temp1 t
  left join zjmb_sw_bgk t1 on t.vc_szxm = t1.vc_xm
  --left join t_icd10 t2 on upper(t.vc_zjdzswjbicd1) = t2.icd10_code
 where to_date(t.vc_swsj,'yyyy-mm-dd') = t1.dt_swrq and t.vc_bgkid in (

 select t.vc_bgkid
     from zjjk_swbgk_temp1 t
  left join zjmb_sw_bgk t1 on t.vc_szxm = t1.vc_xm
  --left join t_icd10 t2 on upper(t.vc_zjdzswjbicd1) = t2.icd10_code
 where to_date(t.vc_swsj,'yyyy-mm-dd') = t1.dt_swrq group by t.vc_bgkid having count(t.vc_bgkid)=1)
     and  not exists ( select t2.vc_bgkid
     from zjjk_swbgk_temp2 t2 where t2.vc_bgkid=t.vc_bgkid)
     and  not exists ( select t3.vc_bgkid
     from zjjk_swbgk_temp3 t3 where t3.vc_bgkid=t.vc_bgkid);
       loop
       exit when p_cur1%notfound;
       a1:=null;
       a2:=null;
       a3:=null;
       a4:=null;
       a5:=null;
       a6:=null;
       a7:=null;
       a8:=null;
       a9:=null;
       a10:=null;
       a11:=null;
       a12:=null;
       a13:=null;
       a14:=null;
       a15:=null;
        fetch p_cur1 into a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10;

    open p_cur2 for
select icd10_name from t_icd10 where icd10_code=a1;
    loop
    fetch p_cur2 into a11 ;
    exit when p_cur2%notfound;
    end loop;
    close p_cur2;

    open p_cur3 for
select icd10_name from t_icd10 where icd10_code=a2;
    loop
    fetch p_cur3 into a12 ;
    exit when p_cur3%notfound;
    end loop;
    close p_cur3;

    open p_cur4 for
select icd10_name from t_icd10 where icd10_code=a3;
    loop
    fetch p_cur4 into a13 ;
    exit when p_cur4%notfound;
    end loop;
    close p_cur4;

    open p_cur5 for
select icd10_name from t_icd10 where icd10_code=a4;
    loop
    fetch p_cur5 into a14 ;
    exit when p_cur5%notfound;
    end loop;
    close p_cur5;

    open p_cur6 for
select icd10_name from t_icd10 where icd10_code=a5;
    loop
    fetch p_cur6 into a15 ;
    exit when p_cur6%notfound;
    end loop;
    close p_cur6;

      update zjmb_sw_bgk t set
      --t.nb_azjswjbicd=a1,
      --t.nb_bzjswjbidc=a2,
      --t.nb_czjswjbicd=a3,
      --t.nb_dajswjbicd=a4,
      t.Nb_Eajswjbicd=a5,
      --t.Vc_Azjswjb1=a6,
      --t.Vc_Bzjswjb1=a7,
      --t.Vc_Czjswjb1=a8,
      --t.Vc_Dzjswjb1=a9,
      t.Vc_Ezjswjb1=a10,
      --t.Vc_Azjswjb=a11,
      --t.Vc_Bzjswjb=a12,
      --t.Vc_Czjswjb=a13,
      --t.Vc_Dzjswjb=a14,
      t.Vc_Ezjswjb=a15
      where t.vc_bgkid=a0 ;
        commit;
     end loop;
      close p_cur1;
end updateHJDZ2;

