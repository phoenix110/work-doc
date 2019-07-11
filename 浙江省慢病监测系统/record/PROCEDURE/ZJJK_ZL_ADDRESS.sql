create or replace procedure      ZJJK_ZL_ADDRESS is
  p_cur1     zjjk_report.refcursor;
  gldwdm_cur zjjk_report.refcursor;
  personid   varchar2(60);
  hksfdm     varchar2(20);
  hksdm      varchar2(20);
  hkjddm     varchar2(20);
  hkqxdm     varchar2(20);
  hkjwdm     varchar2(60);
  hkxxdz     varchar2(120);
  sjsfdm     varchar2(20);
  sjsdm      varchar2(20);
  sjqxdm     varchar2(20);
  sjjddm     varchar2(20);
  sjjwdm     varchar2(60);
  sjxxdz     varchar2(60);
  code       varchar2(20);
  gldwdm     varchar2(60);
  j          integer;
  sdqrzt     varchar2(20);
begin
  j := 0;
  open p_cur1 for
    select t.vc_personid,
           t.vc_hksfdm,
           t.vc_hksdm,
           t.vc_hkqxdm,
           t.vc_hkjddm,
           t.vc_hkjwdm,
           t.vc_hkxxdz,
           t.vc_sjsfdm,
           t.vc_sjsdm,
           t.vc_sjqxdm,
           t.vc_sjjddm,
           t.vc_sjjwdm,
           t.vc_sjxxdz
      from zjjk_zl_hzxx t, zjjk_zl_bgk t2
     where t.vc_personid = t2.vc_hzid
       and t2.vc_bgkid like '%f';
  loop
    fetch p_cur1
      into personid, hksfdm, hksdm, hkqxdm, hkjddm, hkjwdm, hkxxdz, sjsfdm, sjsdm, sjqxdm, sjjddm, sjjwdm, sjxxdz;
    exit when p_cur1%notfound;
    begin
      code   := null;
      sdqrzt := '1';
      gldwdm := null;

      if (hksfdm = sjsfdm and hksdm = sjsdm and hkqxdm = sjqxdm and
         hkjddm = sjjddm) then
        update zjjk_zl_hzxx t
           set t.vc_hkjwdm = sjjwdm, t.vc_hkxxdz = sjxxdz
         where t.vc_personid = personid;
      end if;

      if (hksfdm = '1') then
        if (sjjddm is not null and length(sjjddm) = 8) then
          open gldwdm_cur for
            select t.code
              from organ_node t
             where t.description like '%' || substr(sjjddm, 0, 8) || '%';
          loop
            fetch gldwdm_cur
              into code;
            exit when gldwdm_cur%notfound;
            if (gldwdm is not null) then
              gldwdm := code || ',' || gldwdm;
              sdqrzt := '0';
            else
              gldwdm := code;
              sdqrzt := '1';
            end if;
          end loop;
          close gldwdm_cur;
        end if;
        update zjjk_zl_hzxx t
           set t.vc_hksfdm = sjsfdm,
               t.vc_hksdm  = sjsdm,
               t.vc_hkqxdm = sjqxdm,
               t.vc_hkjddm = sjjddm,
               t.vc_hkjwdm = sjjwdm,
               t.vc_hkxxdz = sjxxdz
         where t.vc_personid = personid;

        update zjjk_zl_bgk t
           set t.vc_gldw = gldwdm, t.vc_sdqrzt = sdqrzt
         where t.vc_hzid = personid;
      end if;
      commit;
      j := j + 1;
    Exception
      When Others Then
        Rollback;
        prc_err_log('肿瘤', personid);
        Commit;
    end;
  end loop;
  close p_cur1;
  prc_err_log('ZJJK_ZL_LSSJDR',
              '肿瘤成功修改---------' || j || '---------条数据');
  commit;

end ZJJK_ZL_ADDRESS;

