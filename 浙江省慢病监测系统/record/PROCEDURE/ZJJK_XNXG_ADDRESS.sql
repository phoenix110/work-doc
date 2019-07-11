create or replace procedure      ZJJK_XNXG_ADDRESS is
  p_cur1     zjjk_report.refcursor;
  gldwdm_cur zjjk_report.refcursor;
  bgkid      varchar2(60);
  czhks      varchar2(20);
  czhksi     varchar2(20);
  czhkqx     varchar2(20);
  czhkjd     varchar2(20);
  czhkjw     varchar2(200);
  czhkxxdz   varchar2(100);
  mqjzs      varchar2(20);
  mqjzsi     varchar2(20);
  mqjzqx     varchar2(20);
  mqjzjd     varchar2(20);
  mqjzjw     varchar2(200);
  mqxxdz     varchar2(100);
  code       varchar2(20);
  gldwdm     varchar2(60);
  j          integer;
  sdqrzt     varchar2(20);

begin
  j := 0;
  open p_cur1 for
    select t.vc_bgkid,
           t.vc_czhks,
           t.vc_czhksi,
           t.vc_czhkqx,
           t.vc_czhkjd,
           t.vc_czhkjw,
           t.vc_czhkxxdz,
           t.vc_mqjzs,
           t.vc_mqjzsi,
           t.vc_mqjzqx,
           t.vc_mqjzjd,
           t.vc_mqjzjw,
           t.vc_mqxxdz
      from zjjk_xnxg_bgk t
     where t.vc_bgkbh like '%f';
  loop
    fetch p_cur1
      into bgkid, czhks, czhksi, czhkqx, czhkjd, czhkjw, czhkxxdz, mqjzs, mqjzsi, mqjzqx, mqjzjd, mqjzjw, mqxxdz;
    exit when p_cur1%notfound;
    begin
      code   := null;
      sdqrzt := '1';
      gldwdm := null;

      if (czhks = mqjzs and czhksi = mqjzsi and czhkqx = mqjzqx and
         czhkjd = mqjzjd) then
        update zjjk_xnxg_bgk t
           set t.vc_czhkjw = mqjzjw, t.vc_czhkxxdz = mqxxdz
         where t.vc_bgkid = bgkid;
      end if;

      if (czhks = '1') then
        if (mqjzjd is not null and length(mqjzjd) = 8) then
          open gldwdm_cur for
            select t.code
              from organ_node t
             where t.description like '%' || substr(mqjzjd, 0, 8) || '%';
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
        update zjjk_xnxg_bgk t
           set t.vc_czhks    = mqjzs,
               t.vc_czhksi   = mqjzsi,
               t.vc_czhkqx   = mqjzqx,
               t.vc_czhkjd   = mqjzjd,
               t.vc_czhkjw   = mqjzjw,
               t.vc_czhkxxdz = mqxxdz,
               t.vc_gldwdm   = gldwdm,
               t.vc_sdqrzt   = sdqrzt
         where t.vc_bgkid = bgkid;

      end if;
      commit;
      j := j + 1;
    Exception
      When Others Then
        Rollback;
        prc_err_log('心脑血管', bgkid);
        Commit;
    end;
  end loop;
  close p_cur1;
  prc_err_log('ZJJK_XNXG_LSSJDR',
              '心脑血管成功修改---------' || j || '---------条数据');
  commit;

end ZJJK_XNXG_ADDRESS;

