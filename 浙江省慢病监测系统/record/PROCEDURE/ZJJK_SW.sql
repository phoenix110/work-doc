create or replace procedure      ZJJK_SW
is
 p_cur1  zjjk_report.refcursor;
 p_cur2  zjjk_report.refcursor;
  a0     varchar2(100);
  a1     varchar2(100);
  a2     integer;
  a3     varchar2(100);
  i      integer;
  begin

       open p_cur1 for
       select t.vc_bgkid,t1.icd10_name--t.vc_azjswjb,t.vc_azjswjb1,t.nb_azjswjbicd,t.vc_bzjswjb,t.vc_bzjswjb1,t.nb_bzjswjbidc
 from zjmb_sw_bgk t left join t_icd10 t1 on t.nb_azjswjbicd = T1.icd10_code
 WHERE T.VC_SHBZ >= 3 AND T.nb_jkyybm is not null and nb_azjswjbicd is not null;
        loop
        fetch p_cur1 into a0,a1;
        exit when p_cur1%notfound;

     update zjmb_sw_bgk t2 set t2.vc_azjswjb = a1 where t2.vc_bgkid =a0;

        commit;
      end loop;
      close p_cur1;

--set escape on
--where vc_icd10)
end ZJJK_SW;

