create or replace procedure      ZJJK_ZL_PK is
  p_cur1   zjjk_report.refcursor;
  p_cur2   zjjk_report.refcursor;
  jtgz_cur zjjk_report.refcursor;
  personid varchar2(60);
  hzxm     varchar2(20);
  hzxb     varchar2(1);
  hzmz     varchar2(20);
  hzcsrq   date;
  sfzh     varchar2(25);
  jtdh     varchar2(40);
  gzdw     varchar2(100);
  zydm     varchar2(20);
  jtgz     varchar2(20);
  hksfdm   varchar2(20);
  hksdm    varchar2(20);
  hkjddm   varchar2(20);
  hkqxdm   varchar2(20);
  hkjwdm   varchar2(60);
  hkxxdz   varchar2(120);
  sjsfdm   varchar2(20);
  sjsdm    varchar2(20);
  sjqxdm   varchar2(20);
  sjjddm   varchar2(20);
  sjjwdm   varchar2(60);
  sjxxdz   varchar2(60);
  gldwdm   varchar2(60);
  sfsw     varchar2(1);
  sfhs     varchar2(1);
  sjhm     varchar2(60);
  dydz     varchar2(1024);
  jzyb     varchar2(60);
  hkyb     varchar2(60);
  bgkid    varchar2(60);
  bgklx    varchar2(1);
  xzqybm   varchar2(20);
  bqygzbr  varchar2(1);
  mzh      varchar2(60);
  zyh      varchar2(60);
  hzid     varchar2(60);
  icd10    varchar2(10);
  icdo     varchar2(20);
  sznl     number(3);
  zdbw     varchar2(1);
  blxlx    varchar2(1);
  blh      varchar2(60);
  zdsqb    varchar2(1);
  zdrq     date;
  zgzddw   varchar2(1);
  bgdwqx   varchar2(20);
  bgys     varchar2(20);
  bgrq     date;
  swxx     varchar2(1);
  swrq     date;
  swyy     varchar2(1);
  swicd10  varchar2(10);
  zdyh     varchar2(60);
  bszy     varchar2(500);
  dcr      varchar2(20);
  dcrq     date;
  bz       varchar2(1024);
  scbz     varchar2(30);
  ccid     varchar2(60);
  ckbz     varchar2(2);
  xxly     varchar2(2);
  sfbb     varchar2(2);
  sdqrzt   varchar2(60);
  qrsj     date;
  sdqrid   varchar2(60);
  cjsj     date;
  cjyh     varchar2(60);
  xgsj     date;
  xgyh     varchar2(60);
  qcbz     varchar2(1);
  sfbz     varchar2(1);
  cjdw     varchar2(60);
  gldw     varchar2(120);
  smtjid   varchar2(60);
  shbz     varchar2(1);
  bgdws    varchar2(20);
  ylfffs   varchar2(1);
  zdqbt    varchar2(2);
  zdqbn    varchar2(2);
  zdqbm    varchar2(2);
  bgdw     varchar2(60);
  bgkzt    varchar2(1);
  yzd      varchar2(60);
  yzdrq    date;
  sczdrq   date;
  dbwyfid  varchar2(60);
  sfrq     date;
  kspf     number(6);
  zdjg     varchar2(60);
  khjg     varchar2(60);
  cxglrq   date;
  cxglyy   varchar2(1);
  sfcx     varchar2(1);
  cxglqtyy varchar2(60);
  icdm     varchar2(10);
  dlw      varchar2(10);
  khzt     varchar2(1);
  icd9     varchar2(10);
  khid     varchar2(60);
  sfcf     varchar2(1);
  zhycsfrq date;
  shid     varchar2(60);
  swicdmc  varchar2(60);
  qcd      varchar2(60);
  qcsdm    varchar2(60);
  qcqxdm   varchar2(60);
  qcjddm   varchar2(60);
  qcjw     varchar2(60);
  sfqc     varchar2(60);
  qcsj     date;
  qcxxdz   varchar2(60);
  hjhs     varchar2(1);
  khbz     varchar2(1);
  shzt     varchar2(1);
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
    select * from zjjk_zl_bgk_temp t;
  loop
    fetch p_cur1
      into bgkid, bgklx, xzqybm, bqygzbr, mzh, zyh, hzid, icd10, icdo, sznl, zdbw, blxlx, blh, zdsqb, zdrq, zgzddw, bgdwqx, bgys, bgrq, swxx, swrq, swyy, swicd10, zdyh, bszy, dcr, dcrq, bz, scbz, ccid, ckbz, xxly, sfbb, sdqrzt, qrsj, sdqrid, cjsj, cjyh, xgsj, xgyh, qcbz, sfbz, cjdw, gldw, smtjid, shbz, bgdws, ylfffs, zdqbt, zdqbn, zdqbm, bgdw, bgkzt, yzd, yzdrq, sczdrq, dbwyfid, sfrq, kspf, zdjg, khjg, cxglrq, cxglyy, sfcx, cxglqtyy, icdm, dlw, khzt, icd9, khid, sfcf, zhycsfrq, shid, swicdmc, qcd, qcsdm, qcqxdm, qcjddm, qcjw, sfqc, qcsj, qcxxdz, hjhs, khbz, shzt, shwtgyy, shwtgyy1, wtzt, ywtdw, sqsl, jjsl, ywtjd, ywtjw, ywtxxdz, ywtjgdm, lszy, state, yyshsj, qxshsj, bksznl, cfsj, sfsj;
    exit when p_cur1%notfound;

    open p_cur2 for
      select * from zjjk_zl_hzxx_temp t where t.vc_personid = hzid;
    loop
      fetch p_cur2
        into personid, hzxm, hzxb, hzmz, hzcsrq, sfzh, jtdh, gzdw, zydm, jtgz, hksfdm, hksdm, hkjddm, hkqxdm, hkjwdm, hkxxdz, sjsfdm, sjsdm, sjqxdm, sjjddm, sjjwdm, sjxxdz, gldwdm, sfsw, sfhs, sjhm, dydz, jzyb, hkyb;
      exit when p_cur2%notfound;
    end loop;
    close p_cur2;

    begin
      a2    := null;
      a3    := null;
      bkrqn := to_char(bgrq, 'yyyy');
      zy    := substr(lszy, 0, to_number(instr(lszy, '、') - 1));

      select max(to_number(substr(t.vc_bgkid, 0, 14))) + 1
        into a2
        from zjjk_zl_bgk t
       where t.vc_bgdw = bgdw
         and substr(t.vc_bgkid, 0, 2) = substr(bkrqn, 3);

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
          into jtgz, zydm, lszy;
        exit when jtgz_cur%notfound;
      end loop;
      close jtgz_cur;

insert into ZJJK_ZL_HZXX (VC_PERSONID, VC_HZXM, VC_HZXB, VC_HZMZ, DT_HZCSRQ, VC_SFZH, VC_JTDH, VC_GZDW,
VC_ZYDM, VC_JTGZ, VC_HKSFDM, VC_HKSDM, VC_HKJDDM, VC_HKQXDM, VC_HKJWDM, VC_HKXXDZ, VC_SJSFDM, VC_SJSDM,
VC_SJQXDM, VC_SJJDDM, VC_SJJWDM, VC_SJXXDZ, VC_GLDWDM, VC_SFSW, VC_SFHS, VC_SJHM, VC_DYDZ, VC_JZYB, VC_HKYB)
values ('000000'||a3, hzxm, hzxb, hzmz, hzcsrq, sfzh, jtdh, gzdw,
zydm, jtgz, hksfdm, hksdm, hkjddm, hkqxdm, hkjwdm, hkxxdz, sjsfdm, sjsdm,
sjqxdm, sjjddm, sjjwdm, sjxxdz, gldwdm, sfsw, sfhs, sjhm, dydz, jzyb, hkyb);

insert into ZJJK_ZL_BGK (VC_BGKID, VC_BGKLX, VC_XZQYBM, VC_BQYGZBR, VC_MZH, VC_ZYH,
VC_HZID, VC_ICD10, VC_ICDO, VC_SZNL, VC_ZDBW, VC_BLXLX, VC_BLH, VC_ZDSQB, DT_ZDRQ,
VC_ZGZDDW, VC_BGDWQX, VC_BGYS, DT_BGRQ, VC_SWXX, DT_SWRQ, VC_SWYY, VC_SWICD10, VC_ZDYH,
VC_BSZY, VC_DCR, DT_DCRQ, VC_BZ, VC_SCBZ, VC_CCID, VC_CKBZ, VC_XXLY, VC_SFBB, VC_SDQRZT,
DT_QRSJ, VC_SDQRID, DT_CJSJ, VC_CJYH, DT_XGSJ, VC_XGYH, VC_QCBZ, VC_SFBZ, VC_CJDW,
VC_GLDW, VC_SMTJID, VC_SHBZ, VC_BGDWS, VC_YLFFFS, VC_ZDQBT, VC_ZDQBN, VC_ZDQBM, VC_BGDW,
VC_BGKZT, VC_YZD, DT_YZDRQ, DT_SCZDRQ, VC_DBWYFID, DT_SFRQ, NB_KSPF, VC_ZDJG, VC_KHJG,
DT_CXGLRQ, VC_CXGLYY, VC_SFCX, VC_CXGLQTYY, VC_ICDM, VC_DLW, VC_KHZT, VC_ICD9, VC_KHID,
VC_SFCF, DT_ZHYCSFRQ, VC_SHID, VC_SWICDMC, VC_QCD, VC_QCSDM, VC_QCQXDM, VC_QCJDDM, VC_QCJW,
VC_SFQC, DT_QCSJ, VC_QCXXDZ, VC_HJHS, VC_KHBZ, VC_SHZT, VC_SHWTGYY, VC_SHWTGYY1, VC_WTZT,
VC_YWTDW, VC_SQSL, VC_JJSL, VC_YWTJD, VC_YWTJW, VC_YWTXXDZ, VC_YWTJGDM, VC_LSZY,VC_STATE,VC_BKSZNL)
values (a3||'f', bgklx, xzqybm, bqygzbr, mzh, zyh,
'000000'||a3, icd10, icdo, sznl, zdbw, blxlx, blh, zdsqb, zdrq,
zgzddw, bgdwqx, bgys, bgrq, swxx, swrq, swyy, swicd10, zdyh,
bszy, dcr, dcrq, bz, scbz, ccid, ckbz, xxly, sfbb, sdqrzt,
qrsj, sdqrid, sysdate, cjyh, xgsj, xgyh, qcbz, sfbz, cjdw,
gldw, smtjid, shbz, bgdws, ylfffs, zdqbt, zdqbn, zdqbm, bgdw,
bgkzt, yzd, yzdrq, sczdrq, dbwyfid, sfrq, kspf, zdjg, khjg,
cxglrq, cxglyy, sfcx, cxglqtyy, icdm, dlw, khzt, icd9, khid,
sfcf, zhycsfrq, shid, swicdmc, qcd, qcsdm, qcqxdm, qcjddm, qcjw,
sfqc, qcsj, qcxxdz, hjhs, khbz, shzt, shwtgyy, shwtgyy1, wtzt,
ywtdw, sqsl, jjsl, ywtjd, ywtjw, ywtxxdz, ywtjgdm, lszy,state,bksznl);
      commit;
      j := j + 1;
    Exception
      When Others Then
        Rollback;
        prc_err_log('肿瘤', bgkid || ' ---------' || a3 || ' ---------' || hzxm);
        Commit;
    end;
  end loop;
  close p_cur1;
  prc_err_log('ZJJK_ZL_LSSJDR',
              '肿瘤成功导入---------' || j || '---------条数据');
  Commit;

end ZJJK_ZL_PK;

