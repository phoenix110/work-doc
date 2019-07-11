create or replace procedure      ZJJK_TNB_ADDRESS is
  p_cur1     zjjk_report.refcursor;
  gldwdm_cur zjjk_report.refcursor;
  personid   varchar2(60);
  hkshen     varchar2(20);
  hks        varchar2(20);
  hkqx       varchar2(20);
  hkjd       varchar2(20);
  hkjw       varchar2(200);
  hkxxdz     varchar2(600);
  jzds       varchar2(20);
  jzs        varchar2(20);
  jzqx       varchar2(20);
  jzjd       varchar2(20);
  jzjw       varchar2(200);
  jzxxdz     varchar2(600);
  code       varchar2(20);
  gldwdm     varchar2(60);
  j          integer;
  sdqrzt     varchar2(20);

begin
  j := 0;
  open p_cur1 for
    select t.vc_personid,
           t.vc_hkshen,
           t.vc_hks,
           t.vc_hkqx,
           t.vc_hkjd,
           t.vc_hkjw,
           t.vc_hkxxdz,
           t.vc_jzds,
           t.vc_jzs,
           t.vc_jzqx,
           t.vc_jzjd,
           t.vc_jzjw,
           t.vc_jzxxdz
      from zjjk_tnb_hzxx t, zjjk_tnb_bgk t2
     where t.vc_personid = t2.vc_hzid
       and t2.vc_bgkcode like '%f';
  loop
    fetch p_cur1
      into personid, hkshen, hks, hkqx, hkjd, hkjw, hkxxdz, jzds, jzs, jzqx, jzjd, jzjw, jzxxdz;
    exit when p_cur1%notfound;
    begin
      code   := null;
      sdqrzt := '1';
      gldwdm := null;

      if (hkshen = jzds and hks = jzs and hkqx = jzqx and hkjd = jzjd) then
        update zjjk_tnb_hzxx t
           set t.vc_hkjw = jzjw, t.vc_hkxxdz = jzxxdz
         where t.vc_personid = personid;
      end if;

      if (hkshen = '1') then
        if (jzjd is not null and length(jzjd) = 8) then
          open gldwdm_cur for
            select t.code
              from organ_node t
             where t.description like '%' || substr(jzjd, 0, 8) || '%';
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
        update zjjk_tnb_hzxx t
           set t.vc_hkshen = jzds,
               t.vc_hks    = jzs,
               t.vc_hkqx   = jzqx,
               t.vc_hkjd   = jzjd,
               t.vc_hkjw   = jzjw,
               t.vc_hkxxdz = jzxxdz
         where t.vc_personid = personid;

        update zjjk_tnb_bgk t
           set t.vc_gldw = gldwdm, t.vc_sdqrzt = sdqrzt
         where t.vc_hzid = personid;
      end if;
      commit;
      j := j + 1;
    Exception
      When Others Then
        Rollback;
        prc_err_log('糖尿病', personid);
        Commit;
    end;
  end loop;
  close p_cur1;
  prc_err_log('ZJJK_TNB_LSSJDR',
              '糖尿病成功修改---------' || j || '---------条数据');
  commit;
end ZJJK_TNB_ADDRESS;

