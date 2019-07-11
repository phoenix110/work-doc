create or replace procedure      ZJJK_TNB_PK is
  p_cur1   zjjk_report.refcursor;
  p_cur2   zjjk_report.refcursor;
  jtgz_cur zjjk_report.refcursor;
  personid varchar2(60);
  hzxm     varchar2(20);
  hzxb     varchar2(1);
  hzmz     varchar2(20);
  whcd     varchar2(20);
  hzcsrq   date;
  sznl     number(3);
  sfzh     varchar2(30);
  lxdh     varchar2(40);
  hydm     varchar2(100);
  zydm     varchar2(100);
  gzdw     varchar2(100);
  hkshen   varchar2(20);
  hks      varchar2(20);
  hkqx     varchar2(20);
  hkjd     varchar2(20);
  hkjw     varchar2(200);
  hkxxdz   varchar2(600);
  jzds     varchar2(20);
  jzs      varchar2(20);
  jzqx     varchar2(20);
  jzjd     varchar2(20);
  jzjw     varchar2(200);
  jzxxdz   varchar2(600);
  bgkid    varchar2(60);
  bgklx    varchar2(1);
  hzid     varchar2(60);
  icd10    varchar2(10);
  tnblx    varchar2(1);
  wxys     varchar2(20);
  wxystz   number(4, 1);
  wxyssg   number(4, 1);
  tnbs     varchar2(20);
  jzsrs    number(2);
  ywbfz    varchar2(30);
  zslcbx   varchar2(30);
  zslcbxqt varchar2(60);
  kfxtz    number(10, 1);
  sjxtz    number(10, 1);
  xjptt    number(10, 1);
  zdgc     number(10, 1);
  e4hdlc   number(10, 1);
  e5ldlc   number(10, 1);
  gysz     number(10, 1);
  nwldb    number(10, 1);
  thxhdb   number(10, 1);
  bszyqt   varchar2(600);
  sczdrq   date;
  zddw     varchar2(6);
  bgdw     varchar2(9);
  bgys     varchar2(20);
  bgrq     date;
  sfsw     varchar2(1);
  swrq     date;
  swyy     varchar2(200);
  swicd10  varchar2(10);
  swicdmc  varchar2(60);
  bszy     varchar2(500);
  scbz     varchar2(30);
  ccid     varchar2(60);
  ckbz     varchar2(2);
  sfbb     varchar2(2);
  sdqrzt   varchar2(60);
  qrsj     date;
  sdqrid   varchar2(60);
  cjsj     date;
  cjdw     varchar2(60);
  xgsj     date;
  xgdw     varchar2(60);
  gldw     varchar2(120);
  shbz     varchar2(1);
  shwtgyy1 varchar2(60);
  shwtgyy2 varchar2(60);
  khbz     varchar2(1);
  khjg     varchar2(60);
  smtjid   varchar2(60);
  qybz     varchar2(1);
  hkhs     varchar2(1);
  hkwhsyy  varchar2(20);
  jzhs     varchar2(1);
  jzwhsyy  varchar2(1);
  cxgl     varchar2(1);
  qcbz     varchar2(1);
  xgyh     varchar2(50);
  cjyh     varchar2(50);
  xxly     varchar2(100);
  bz       varchar2(200);
  dcrq     date;
  dcr      varchar2(50);
  zdyh     varchar2(50);
  swxx     varchar2(100);
  bgdwqx   varchar2(50);
  zgzddw   varchar2(50);
  fbnl     varchar2(3);
  icdo     varchar2(3);
  zyh      varchar2(20);
  mzh      varchar2(20);
  bqygzbr  varchar2(20);
  xzqybm   varchar2(20);
  bgkzt    varchar2(1);
  bgkcode  varchar2(60);
  qcd      varchar2(20);
  qcsdm    varchar2(20);
  qcqxdm   varchar2(20);
  qcjddm   varchar2(20);
  qcjw     varchar2(20);
  sfqc     varchar2(1);
  qcsj     date;
  qcxxdz   varchar2(200);
  shid     varchar2(60);
  khid     varchar2(60);
  khzt     varchar2(1);
  shzt     varchar2(1);
  cfzt     varchar2(1);
  shwtgyy  varchar2(500);
  bks      varchar2(20);
  bkq      varchar2(20);
  bmi      number(4, 1);
  wtzt     varchar2(1);
  ywtdw    varchar2(60);
  sqsl     varchar2(20);
  jjsl     varchar2(20);
  ywtjd    varchar2(60);
  ywtjw    varchar2(60);
  ywtxxdz  varchar2(60);
  ywtjgdm  varchar2(20);
  lszy     varchar2(60);
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
    select * from zjjk_tnb_bgk_temp t;
  loop
    fetch p_cur1
      into bgkid, bgklx, hzid, icd10, tnblx, wxys, wxystz, wxyssg, tnbs, jzsrs, ywbfz, zslcbx, zslcbxqt, kfxtz, sjxtz, xjptt, zdgc, e4hdlc, e5ldlc, gysz, nwldb, thxhdb, bszyqt, sczdrq, zddw, bgdw, bgys, bgrq, sfsw, swrq, swyy, swicd10, swicdmc, bszy, scbz, ccid, ckbz, sfbb, sdqrzt, qrsj, sdqrid, cjsj, cjdw, xgsj, xgdw, gldw, shbz, shwtgyy1, shwtgyy2, khbz, khjg, smtjid, qybz, hkhs, hkwhsyy, jzhs, jzwhsyy, cxgl, qcbz, xgyh, cjyh, xxly, bz, dcrq, dcr, zdyh, swxx, bgdwqx, zgzddw, fbnl, icdo, zyh, mzh, bqygzbr, xzqybm, bgkzt, bgkcode, qcd, qcsdm, qcqxdm, qcjddm, qcjw, sfqc, qcsj, qcxxdz, shid, khid, khzt, shzt, cfzt, shwtgyy, bks, bkq, bmi, wtzt, ywtdw, sqsl, jjsl, ywtjd, ywtjw, ywtxxdz, ywtjgdm, lszy, state, yyshsj, qxshsj, bksznl, cfsj, sfsj;
    exit when p_cur1%notfound;

    open p_cur2 for
      select * from zjjk_tnb_hzxx_temp t where t.vc_personid = hzid;
    loop
      fetch p_cur2
        into personid, hzxm, hzxb, hzmz, whcd, hzcsrq, sznl, sfzh, lxdh, hydm, zydm, gzdw, hkshen, hks, hkqx, hkjd, hkjw, hkxxdz, jzds, jzs, jzqx, jzjd, jzjw, jzxxdz;
      exit when p_cur2%notfound;
    end loop;
    close p_cur2;

    begin
      a2    := null;
      a3    := null;
      bkrqn := to_char(bgrq, 'yyyy');
      zy    := substr(lszy, 0, to_number(instr(lszy, '、') - 1));

      select max(to_number(substr(t.vc_bgkcode, 0, 14))) + 1
        into a2
        from zjjk_tnb_bgk t
       where t.vc_bgdw = bgdw
         and substr(t.vc_bgkcode, 0, 2) = substr(bkrqn, 3);
      if (a2 is NULL) then
        a2 := 1;
      end if;
      if (a2 = 1) then
        a3 := substr(bkrqn, 3) || substr(bgdw, 3) || '00001';
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
          into zydm, hydm, lszy;
        exit when jtgz_cur%notfound;
      end loop;
      close jtgz_cur;

insert into ZJJK_TNB_HZXX (VC_PERSONID, VC_HZXM, VC_HZXB, VC_HZMZ, VC_WHCD, DT_HZCSRQ, VC_SZNL, VC_SFZH,
VC_LXDH, VC_HYDM, VC_ZYDM, VC_GZDW, VC_HKSHEN, VC_HKS, VC_HKQX, VC_HKJD, VC_HKJW, VC_HKXXDZ, VC_JZDS, VC_JZS, VC_JZQX, VC_JZJD, VC_JZJW, VC_JZXXDZ)
values ('000000'||a3, hzxm, hzxb, hzmz, whcd, hzcsrq, sznl, sfzh,
lxdh, hydm, zydm, gzdw, hkshen, hks, hkqx, hkjd, hkjw, hkxxdz, jzds, jzs, jzqx, jzjd, jzjw, jzxxdz);

insert into ZJJK_TNB_BGK (VC_BGKID, VC_BGKLX, VC_HZID, VC_ICD10, VC_TNBLX, VC_WXYS, VC_WXYSTZ, VC_WXYSSG,
VC_TNBS, VC_JZSRS, VC_YWBFZ, VC_ZSLCBX, VC_ZSLCBXQT, NB_KFXTZ, NB_SJXTZ, NB_XJPTT, NB_ZDGC, NB_E4HDLC,
NB_E5LDLC, NB_GYSZ, NB_NWLDB, NBTHXHDB, VC_BSZYQT, DT_SCZDRQ, VC_ZDDW, VC_BGDW, VC_BGYS, DT_BGRQ,
VC_SFSW, DT_SWRQ, VC_SWYY, VC_SWICD10, VC_SWICDMC, VC_BSZY, VC_SCBZ, VC_CCID, VC_CKBZ, VC_SFBB,
VC_SDQRZT, DT_QRSJ, VC_SDQRID, DT_CJSJ, VC_CJDW, DT_XGSJ, VC_XGDW, VC_GLDW, VC_SHBZ, VC_SHWTGYY1,
VC_SHWTGYY2, VC_KHBZ, VC_KHJG, VC_SMTJID, VC_QYBZ, VC_HKHS, VC_HKWHSYY, VC_JZHS, VC_JZWHSYY, VC_CXGL,
VC_QCBZ, VC_XGYH, VC_CJYH, VC_XXLY, VC_BZ, DT_DCRQ, VC_DCR, VC_ZDYH, VC_SWXX, VC_BGDWQX, VC_ZGZDDW,
VC_SZNL, VC_ICDO, VC_ZYH, VC_MZH, VC_BQYGZBR, VC_XZQYBM, VC_BGKZT, VC_BGKCODE, VC_QCD, VC_QCSDM, VC_QCQXDM,
VC_QCJDDM, VC_QCJW, VC_SFQC, DT_QCSJ, VC_QCXXDZ, VC_SHID, VC_KHID, VC_KHZT, VC_SHZT, VC_CFZT, VC_SHWTGYY,
VC_BKS, VC_BKQ, VC_BMI, VC_WTZT, VC_YWTDW, VC_SQSL, VC_JJSL, VC_YWTJD, VC_YWTJW, VC_YWTXXDZ, VC_YWTJGDM, VC_LSZY,VC_STATE,VC_BKSZNL)
values (a3, bgklx, '000000'||a3, icd10, tnblx, wxys, wxystz, wxyssg,
tnbs, jzsrs, ywbfz, zslcbx, zslcbxqt, kfxtz, sjxtz, xjptt, zdgc, e4hdlc,
e5ldlc, gysz, nwldb, thxhdb, bszyqt, sczdrq, zddw, bgdw, bgys, bgrq,
sfsw, swrq, swyy, swicd10, swicdmc, bszy, scbz, ccid, ckbz, sfbb,
sdqrzt, qrsj, sdqrid, sysdate, cjdw, xgsj, xgdw, gldw, shbz, shwtgyy1,
shwtgyy2, khbz, khjg, smtjid, qybz, hkhs, hkwhsyy, jzhs, jzwhsyy, cxgl,
qcbz, xgyh, cjyh, xxly, bz, dcrq, dcr, zdyh, swxx, bgdwqx, zgzddw,
fbnl, icdo, zyh, mzh, bqygzbr, xzqybm, bgkzt, a3||'f', qcd, qcsdm, qcqxdm,
qcjddm, qcjw, sfqc, qcsj, qcxxdz, shid, khid, khzt, shzt, cfzt, shwtgyy,
bks, bkq, bmi, wtzt, ywtdw, sqsl, jjsl, ywtjd, ywtjw, ywtxxdz, ywtjgdm, lszy,state,bksznl);
      commit;
      j := j + 1;
    Exception
      When Others Then
        Rollback;
        prc_err_log('糖尿病', bgkid || ' ---------' || a3 || ' ---------' || hzxm);
        Commit;
    end;
  end loop;
  close p_cur1;
  prc_err_log('ZJJK_TNB_LSSJDR',
              '糖尿病成功导入---------' || j || '---------条数据');
  Commit;
end ZJJK_TNB_PK;

