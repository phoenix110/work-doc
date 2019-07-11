create or replace procedure      ZJJK_XNXG_PK is
  p_cur1   zjjk_report.refcursor;
  jtgz_cur zjjk_report.refcursor;
  bgkid    varchar2(60);
  mzh      varchar2(20);
  zyh      varchar2(20);
  bgkbh    varchar2(20);
  bgklx    varchar2(20);
  hzxm     varchar2(20);
  hzxb     varchar2(20);
  hzhy     varchar2(20);
  hzicd    varchar2(20);
  hzcsrq   date;
  sznl     varchar2(20);
  hzzy     varchar2(20);
  hzsfzh   varchar2(20);
  jtgz     varchar2(20);
  hzwhcd   varchar2(20);
  hzmz     varchar2(20);
  hzjtdh   varchar2(40);
  gzdw     varchar2(200);
  czhks    varchar2(20);
  czhksi   varchar2(20);
  czhkjd   varchar2(20);
  mqjzs    varchar2(20);
  mqjzsi   varchar2(20);
  mqjzjd   varchar2(20);
  mqjzjw   varchar2(200);
  gxbzd    varchar2(20);
  nczzd    varchar2(20);
  lczz     varchar2(20);
  xdt      varchar2(20);
  xqm      varchar2(20);
  njy      varchar2(20);
  ndt      varchar2(20);
  xgzy     varchar2(20);
  ct       varchar2(20);
  ckz      varchar2(20);
  sj       varchar2(20);
  sjkysjc  varchar2(20);
  bs       varchar2(20);
  fbrq     date;
  qzrq     date;
  sfsf     varchar2(20);
  qzdw     varchar2(20);
  bkdw     varchar2(20);
  bkys     varchar2(20);
  bkrq     date;
  swrq     date;
  swys     varchar2(1024);
  bszy     varchar2(1024);
  scbz     varchar2(20);
  gldwdm   varchar2(120);
  cjdwdm   varchar2(60);
  ckbz     varchar2(20);
  sfbb     varchar2(20);
  sdqrzt   varchar2(60);
  qrsj     date;
  sdqrid   varchar2(60);
  cjsj     date;
  cjyh     varchar2(60);
  xgsj     date;
  xgyh     varchar2(60);
  shbz     varchar2(20);
  smtjid   varchar2(60);
  qcbz     varchar2(20);
  mqxxdz   varchar2(100);
  czhkjw   varchar2(200);
  czhkxxdz varchar2(100);
  czhkqx   varchar2(20);
  mqjzqx   varchar2(20);
  swysicd  varchar2(20);
  swysmc   varchar2(60);
  bkdwqx   varchar2(20);
  bkdwyy   varchar2(20);
  sfcf     varchar2(20);
  kzt      varchar2(20);
  qcd      varchar2(60);
  qcsdm    varchar2(60);
  qcqxdm   varchar2(60);
  qcjddm   varchar2(60);
  qcjw     varchar2(60);
  sfqc     varchar2(60);
  qcsj     date;
  qcxxdz   varchar2(60);
  shid     varchar2(60);
  khzt     varchar2(1);
  khid     varchar2(60);
  khjg     varchar2(60);
  ccid     varchar2(60);
  khbz     varchar2(1);
  shzt     varchar2(20);
  sfsw     varchar2(1);
  shwtgyy  varchar2(500);
  shwtgyy1 varchar2(60);
  wtzt     varchar2(1);
  ywtdw    varchar2(60);
  sqsl     varchar2(20);
  jjsl     varchar2(20);
  ywtjd    varchar2(60);
  ywtjw    varchar2(60);
  ywtxxdz  varchar2(60);
  ywtjgdm  varchar2(20);
  lszy     varchar2(60);
  cgzsjjg  varchar2(60);
  syzz     varchar2(60);
  shtd     varchar2(60);
  state    varchar2(60);
  yyshsj   date;
  qxshsj   date;
  bksznl   number(3);
  cfsj     date;
  sfsj     date;
  a2       integer;
  a3       varchar2(30);
  bkrqn    varchar2(10);
  j        integer;
  zy       varchar2(10);

begin
  j := 0;
  open p_cur1 for
    select * from zjjk_xnxg_bgk_temp t;
  loop
    fetch p_cur1
      into bgkid, mzh, zyh, bgkbh, bgklx, hzxm, hzxb, hzhy, hzicd, hzcsrq, sznl, hzzy, hzsfzh, jtgz, hzwhcd, hzmz, hzjtdh, gzdw, czhks, czhksi, czhkjd, mqjzs, mqjzsi, mqjzjd, mqjzjw, gxbzd, nczzd, lczz, xdt, xqm, njy, ndt, xgzy, ct, ckz, sj, sjkysjc, bs, fbrq, qzrq, sfsf, qzdw, bkdw, bkys, bkrq, swrq, swys, bszy, scbz, gldwdm, cjdwdm, ckbz, sfbb, sdqrzt, qrsj, sdqrid, cjsj, cjyh, xgsj, xgyh, shbz, smtjid, qcbz, mqxxdz, czhkjw, czhkxxdz, czhkqx, mqjzqx, swysicd, swysmc, bkdwqx, bkdwyy, sfcf, kzt, qcd, qcsdm, qcqxdm, qcjddm, qcjw, sfqc, qcsj, qcxxdz, shid, khzt, khid, khjg, ccid, khbz, shzt, sfsw, shwtgyy, shwtgyy1, wtzt, ywtdw, sqsl, jjsl, ywtjd, ywtjw, ywtxxdz, ywtjgdm, lszy, cgzsjjg, syzz, shtd, state, yyshsj, qxshsj, bksznl, cfsj, sfsj;
    exit when p_cur1%notfound;

    begin
      a2 := null;
      a3 := null;
      bkrqn := to_char(bkrq, 'yyyy');
      zy    := substr(lszy, 0, to_number(instr(lszy, '、') - 1));

    select max(to_number(substr(t.vc_bgkbh, 0, 14))) + 1
      into a2
      from zjjk_xnxg_bgk t
     where t.vc_bkdwyy = bkdwyy
       and substr(t.vc_bgkbh, 0, 2) = substr(bkrqn, 3);

    if (a2 is NULL) then
      a2 := 1;
    end if;
    if (a2 = 1) then
      a3 := substr(bkrqn, 3) || substr(bkdwyy, 3) || '00001';
    else
      a3 := '0' || a2;
    end if;

      if ((zy = '1' or zy = '2') and to_number(bksznl) < 8) then
        zy := '9';
      end if;
      if (zy = '9' and to_number(bksznl) > 8) then
        zy := '1';
      end if;
      if (zy = '3' and to_number(bksznl) < 30) then
        zy := '8';
      end if;
      open jtgz_cur for
        select t.vc_newyydm, t.vc_csyymc, t.vc_oldyymc
          from zjjk_hospital_relation t
         where t.vc_oldyymc like zy || '、%'
           and vc_type = 'TYPE_JTGZ';
      loop
        fetch jtgz_cur
          into jtgz, hzzy, lszy;
        exit when jtgz_cur%notfound;
      end loop;
      close jtgz_cur;
insert into ZJJK_XNXG_BGK (VC_BGKID, VC_MZH, VC_ZYH, VC_BGKBH, VC_BGKLX, VC_HZXM,
VC_HZXB, VC_HZHY, VC_HZICD, DT_HZCSRQ, VC_SZNL, VC_HZZY, VC_HZSFZH, VC_JTGZ,
VC_HZWHCD, VC_HZMZ, VC_HZJTDH, VC_GZDW, VC_CZHKS, VC_CZHKSI, VC_CZHKJD,
VC_MQJZS, VC_MQJZSI, VC_MQJZJD, VC_MQJZJW, VC_GXBZD, VC_NCZZD, VC_LCZZ,
VC_XDT, VC_XQM, VC_NJY, VC_NDT, VC_XGZY, VC_CT, VC_CKZ, VC_SJ, VC_SJKYSJC,
VC_BS, DT_FBRQ, DT_QZRQ, VC_SFSF, VC_QZDW, VC_BKDW, VC_BKYS, DT_BKRQ,
DT_SWRQ, VC_SWYS, VC_BSZY, VC_SCBZ, VC_GLDWDM, VC_CJDWDM, VC_CKBZ,
VC_SFBB, VC_SDQRZT, DT_QRSJ, VC_SDQRID, DT_CJSJ, VC_CJYH, DT_XGSJ,
VC_XGYH, VC_SHBZ, VC_SMTJID, VC_QCBZ, VC_MQXXDZ, VC_CZHKJW, VC_CZHKXXDZ,
VC_CZHKQX, VC_MQJZQX, VC_SWYSICD, VC_SWYSMC, VC_BKDWQX, VC_BKDWYY,
VC_SFCF, VC_KZT, VC_QCD, VC_QCSDM, VC_QCQXDM, VC_QCJDDM, VC_QCJW,
VC_SFQC, DT_QCSJ, VC_QCXXDZ, VC_SHID, VC_KHZT, VC_KHID, VC_KHJG,
VC_CCID, VC_KHBZ, VC_SHZT, VC_SFSW, VC_SHWTGYY, VC_SHWTGYY1, VC_WTZT,
VC_YWTDW, VC_SQSL, VC_JJSL, VC_YWTJD, VC_YWTJW, VC_YWTXXDZ, VC_YWTJGDM, VC_LSZY, VC_STATE, VC_BKSZNL)
values (a3, mzh, zyh, a3||'f', bgklx, hzxm,
hzxb, hzhy, hzicd, hzcsrq, sznl, hzzy, hzsfzh, jtgz,
hzwhcd, hzmz, hzjtdh, gzdw, czhks, czhksi, czhkjd,
mqjzs, mqjzsi, mqjzjd, mqjzjw, gxbzd, nczzd, lczz,
xdt, xqm, njy, ndt, xgzy, ct, ckz, sj, sjkysjc,
bs, fbrq, qzrq, sfsf, qzdw, bkdw, bkys, bkrq,
swrq, swys, bszy, scbz, gldwdm, cjdwdm, ckbz,
sfbb, sdqrzt, qrsj, sdqrid, sysdate, cjyh, xgsj,
xgyh, shbz, smtjid, qcbz, mqxxdz, czhkjw, czhkxxdz,
czhkqx, mqjzqx, swysicd, swysmc, bkdwqx, bkdwyy,
sfcf, kzt, qcd, qcsdm, qcqxdm, qcjddm, qcjw,
sfqc, qcsj, qcxxdz, shid, khzt, khid, khjg,
ccid, khbz, shzt, sfsw, shwtgyy, shwtgyy1, wtzt,
ywtdw, sqsl, jjsl, ywtjd, ywtjw, ywtxxdz, ywtjgdm, lszy, state, bksznl);
      commit;
      j := j + 1;
    Exception
      When Others Then
        Rollback;
        prc_err_log('心脑血管', bgkid || ' ---------' || a3 || ' ---------' || hzxm);
        Commit;
    end;
  end loop;
  close p_cur1;
  prc_err_log('ZJJK_XNXG_LSSJDR',
              '心脑血管成功导入---------' || j || '---------条数据');
  Commit;
end ZJJK_XNXG_PK;

