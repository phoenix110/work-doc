CREATE OR REPLACE Procedure pro_zjjk_bkbh_recreate is
  v_bgkcode varchar2(50);
  v_dm      varchar2(50);
begin
  --处理糖尿病报卡编号重复
  for rec_tnb in (select vc_bgkid, vc_bgkcode, vc_bgdw, dt_cjsj
                    from (select a.vc_bgkid,
                                 a.vc_bgkcode,
                                 a.vc_bgdw,
                                 a.dt_cjsj,
                                 row_number() OVER(PARTITION BY a.vc_bgkcode ORDER BY a.dt_cjsj) xh
                            from zjjk_tnb_bgk a,
                                 (select vc_bgkcode
                                    from zjjk_tnb_bgk
                                   group by vc_bgkcode
                                  having count(1) > 1) b
                           where a.vc_bgkcode = b.vc_bgkcode)
                   where xh > 1) loop
    --获取报告卡编号
    if length(rec_tnb.vc_bgdw) = 9 and rec_tnb.dt_cjsj is not null then
      v_dm := to_char(rec_tnb.dt_cjsj, 'yy') || substr(rec_tnb.vc_bgdw, 3);
      select case
               when max(substr(VC_BGKCODE, 0, 14)) is null then
                v_dm || '00001'
               else
                to_char(max(substr(VC_BGKCODE, 0, 14)) + 1)
             end
        into v_bgkcode
        from ZJJK_TNB_BGK
       where VC_BGKCODE like v_dm || '%'
         and length(VC_BGKCODE) = 14
         and stn(VC_BGKCODE, 1) is not null;
      if v_bgkcode is not null then
        update ZJJK_TNB_BGK a
           set a.vc_bgkcode = v_bgkcode
         where a.vc_bgkid = rec_tnb.vc_bgkid;
      end if;
    end if;
  end loop;
  commit;
  --处理心脑血管
  for rec_xn in (select vc_bgkid, vc_bgkbh, vc_bkdwyy, dt_cjsj
                   from (select a.vc_bgkid,
                                a.vc_bgkbh,
                                a.vc_bkdwyy,
                                a.dt_cjsj,
                                row_number() OVER(PARTITION BY a.vc_bgkbh ORDER BY a.dt_cjsj) xh
                           from zjjk_xnxg_bgk a,
                                (select vc_bgkbh
                                   from zjjk_xnxg_bgk
                                  group by vc_bgkbh
                                 having count(1) > 1) b
                          where a.vc_bgkbh = b.vc_bgkbh)
                  where xh > 1) loop
    --获取报告卡编号
    if length(rec_xn.vc_bkdwyy) = 9 and rec_xn.dt_cjsj is not null then
      v_dm := to_char(rec_xn.dt_cjsj, 'yy') || substr(rec_xn.vc_bkdwyy, 3);
      select case
               when max(substr(vc_bgkbh, 0, 14)) is null then
                v_dm || '00001'
               else
                to_char(max(substr(vc_bgkbh, 0, 14)) + 1)
             end
        into v_bgkcode
        from ZJJK_XNXG_BGK
       where vc_bgkbh like v_dm || '%'
         and length(vc_bgkbh) = 14
         and stn(vc_bgkbh, 1) is not null;
      if v_bgkcode is not null then
        update ZJJK_xnxg_BGK a
           set a.vc_bgkbh = v_bgkcode
         where a.vc_bgkid = rec_xn.vc_bgkid;
      end if;
    end if;
  end loop;
  commit;
  --处理伤害报卡
  for rec_sh in (select vc_id, vc_bgkid, vc_jkdw, dt_cjsj
                   from (select a.vc_id,
                                a.vc_bgkid,
                                a.vc_jkdw,
                                a.dt_cjsj,
                                row_number() OVER(PARTITION BY a.vc_bgkid ORDER BY a.dt_cjsj) xh
                           from zjmb_shjc_bgk a,
                                (select vc_bgkid
                                   from zjmb_shjc_bgk
                                  group by vc_bgkid
                                 having count(1) > 1) b
                          where a.vc_bgkid = b.vc_bgkid)
                  where xh > 1) loop
    --获取报告卡编号
    if length(rec_sh.vc_jkdw) = 9 and rec_sh.dt_cjsj is not null then
      v_dm := to_char(rec_sh.dt_cjsj, 'yyyy') || substr(rec_sh.vc_jkdw, 3);
      select nvl(max(VC_BGKID) + 1, v_dm || '00001')
        into v_bgkcode
        from zjmb_shjc_bgk
       where vc_bgkid like v_dm || '%';
      if v_bgkcode is not null then
        update zjmb_shjc_bgk a
           set a.VC_BGKID = v_bgkcode
         where a.vc_id = rec_sh.vc_id;
      end if;
    end if;
  end loop;
  commit;
EXCEPTION
  WHEN OTHERS THEN
    rollback;
end;
