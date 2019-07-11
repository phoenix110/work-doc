create or replace procedure      ZJJK_TNB_LSSJDR is
 p_cur1           zjjk_report.refcursor;
 p_cur2           zjjk_report.refcursor;

 czhkdzs_cur      zjjk_report.refcursor;
 czhkdzq_cur      zjjk_report.refcursor;
 czhkdzjd_cur     zjjk_report.refcursor;
 mqjzdzs_cur      zjjk_report.refcursor;
 mqjzdzq_cur      zjjk_report.refcursor;
 mqjzdzjd_cur     zjjk_report.refcursor;
 gldwdm_cur       zjjk_report.refcursor;
 jtgz_cur         zjjk_report.refcursor;
 mz_cur           zjjk_report.refcursor;
 whcd_cur         zjjk_report.refcursor;
 icd_cur          zjjk_report.refcursor;
 swicd_cur        zjjk_report.refcursor;
 swicdmc_cur      zjjk_report.refcursor;
 kpbh             varchar2(1024);
 xm               varchar2(1024);
 xb               varchar2(1024);
 csn              varchar2(1024);
 csy              varchar2(1024);
 csr              varchar2(1024);
 sznl             varchar2(1024);
 fbnl             varchar2(1024);
 zy               varchar2(1024);
 jtgz             varchar2(1024);
 mz               varchar2(1024);
 whcd             varchar2(1024);
 sfzh             varchar2(1024);
 gzdw             varchar2(1024);
 lxdhqh           varchar2(1024);
 lxdh             varchar2(1024);
 czhkdzsh         varchar2(1024);
 czhkdzs          varchar2(1024);
 czhkdzq          varchar2(1024);
 czhkdzjd         varchar2(1024);
 czhkdzjw         varchar2(1024);
 czhkxxdz         varchar2(1024);
 mqjzdzsh         varchar2(1024);
 mqjzdzs          varchar2(1024);
 mqjzdzq          varchar2(1024);
 mqjzdzjd         varchar2(1024);
 mqjzdzjw         varchar2(1024);
 mqjzxxdz         varchar2(1024);
 czhkdzshdm       varchar2(1024);
 czhkdzsdm        varchar2(1024);
 czhkdzqdm        varchar2(1024);
 czhkdzjddm       varchar2(1024);
 mqjzdzshdm       varchar2(1024);
 mqjzdzsdm        varchar2(1024);
 mqjzdzqdm        varchar2(1024);
 mqjzdzjddm       varchar2(1024);
 tnblx            varchar2(1024);
 ywbfz1           varchar2(1024);
 ywbfz2           varchar2(1024);
 ywbfz3           varchar2(1024);
 ywbfz4           varchar2(1024);
 ywbfz5           varchar2(1024);
 ywbfz6           varchar2(1024);
 tz               varchar2(1024);
 sg               varchar2(1024);
 fp               varchar2(1024);
 gxy              varchar2(1024);
 gxz              varchar2(1024);
 jdefms           varchar2(1024);
 xdjm             varchar2(1024);
 fq               varchar2(1024);
 mq               varchar2(1024);
 xd               varchar2(1024);
 jm               varchar2(1024);
 zddw             varchar2(1024);
 zdrqn            varchar2(1024);
 zdrqy            varchar2(1024);
 zdrqr            varchar2(1024);
 icdbm            varchar2(1024);
 bkdw             varchar2(1024);
 bkys             varchar2(1024);
 bkrqn            varchar2(1024);
 bkrqy            varchar2(1024);
 bkrqr            varchar2(1024);
 zhjcsjn          varchar2(1024);
 zhjcsjy          varchar2(1024);
 zhjcsjr          varchar2(1024);
 zhsfqk           varchar2(1024);
 swrqn            varchar2(1024);
 swrqy            varchar2(1024);
 swrqr            varchar2(1024);
 swyy             varchar2(1024);
 swicd            varchar2(1024);
 swicdmc          varchar2(1024);
 sfxg             varchar2(1024);
 czr              varchar2(1024);
 lkdw             varchar2(1024);
  a0              varchar2(1024);
  a1              varchar2(1024);
  a2              integer;
  a3              varchar2(1024);
 swrq             date;
 csrq             date;
 zdrq             date;
 bkrq             date;
 dygxsfdg         varchar2(1024);
 newyydm          varchar2(1024);
 yydm             varchar2(1024);
 zydm             varchar2(1024);
 jtgzdm           varchar2(1024);
 mzdm             varchar2(1024);
 whcddm           varchar2(1024);
  j               integer;
 code             varchar2(1024);
 gldwdm           varchar2(1024);
 sdqrzt           varchar2(1024);
 bzw              varchar2(1024);
 lszy             varchar2(1024);
 icdtemp          varchar2(1024);
 bmi              varchar2(1024);
  begin
       j:=0;
       open p_cur1 for
       select t.* ,t.rowid from zjjk_tnb_temp t
       ;
        loop
        fetch p_cur1 into kpbh,xm,xb,csn,csy,csr,sznl,zy,jtgz,mz,whcd,sfzh,gzdw,
        lxdhqh,lxdh,czhkdzsh,czhkdzs,czhkdzq,czhkdzjd,czhkdzjw,czhkxxdz,mqjzdzsh,mqjzdzs,mqjzdzq,
        mqjzdzjd,mqjzdzjw,mqjzxxdz,tnblx,ywbfz1,ywbfz2,ywbfz3,ywbfz4,ywbfz5,tz,
        sg,fp,gxy,gxz,jdefms,xdjm,fq,mq,xd,jm,zddw,zdrqn,zdrqy,zdrqr,icdbm,bkdw,
        bkys,bkrqn,bkrqy,bkrqr,zhjcsjn,zhjcsjy,zhjcsjr,zhsfqk,swrqn,swrqy,swrqr,
        swicd,sfxg,czr,lkdw,bzw;
        exit when p_cur1%notfound;
         dygxsfdg:='0';
         newyydm:=null;
         yydm:=null;
    open p_cur2 for
    select t.vc_newyydm from zjjk_hospital_relation t where t.vc_newyymc = bkdw and vc_type='TYPE_HOSPITAL' ;
    loop
    fetch p_cur2 into newyydm ;
    exit when p_cur2%notfound;
       yydm:= yydm||newyydm;
       if (yydm is not null and length(yydm)!=9) then
            dygxsfdg:='1';
         end if;
    end loop;
    close p_cur2;

--    if (zy is not null and to_number(zy) <= 10) then
    if (newyydm is not null and dygxsfdg='0' and substr(bkrqn,3,1)='0' and substr(bkrqn,4)!='0') then
    begin
    a1:=null;
    a2:=null;
    a3:=null;
    a0:=null;
    swrq:=null;
    czhkdzshdm:=null;
    czhkdzsdm:=null;
    czhkdzqdm:=null;
    czhkdzjddm :=null;
    mqjzdzshdm :=null;
    mqjzdzsdm :=null;
    mqjzdzqdm :=null;
    mqjzdzjddm :=null;
    code:=null;
    sdqrzt:='1';
    gldwdm:=null;
    jtgzdm:=null;
    zydm:=null;
    lszy:=null;
    icdtemp:=null;
    swyy:=null;
    bmi:=null;
    swicdmc:=null;
    ywbfz6:='0';
    tz:=to_number(tz);
    sg:=to_number(sg);
    icdbm:=upper(icdbm);
    swicd:=upper(swicd);
    select max(to_number(substr(t.vc_bgkcode,0,14)))+1 into a2 from zjjk_tnb_bgk t where t.vc_bgdw=newyydm and substr(t.vc_bgkcode,0,2)=substr(bkrqn,3);
    if (a2 is NULL) then
      a2:=1;
    end if;
    if (a2 = 1) then
      a3 := substr(bkrqn,3)||substr(newyydm,3)||'00001';
    else
      a3 := '0'||a2;
    end if;
    if (swrqn is null) then
      a0 := '0';
    else
      a0 := '7';
      swrq:=to_date(swrqr||'-'||swrqy||'-'||swrqn, 'dd-mm-yyyy');
    end if;

      csrq:=to_date(csr||'-'||csy||'-'||csn, 'dd-mm-yyyy');
      zdrq:=to_date(zdrqr||'-'||zdrqy||'-'||zdrqn, 'dd-mm-yyyy');
      bkrq:=to_date(bkrqr||'-'||bkrqy||'-'||bkrqn, 'dd-mm-yyyy');

      sznl:=trunc(months_between(bkrq,csrq)/12,0);
      fbnl:=trunc(months_between(zdrq,csrq)/12,0);

    if (substr(mqjzdzsh,0,2) ='浙江') then
      mqjzdzshdm := '0';
      open  mqjzdzs_cur for
      select t.code from code_info t where t.name = mqjzdzs or t.name like mqjzdzs||'_';
      loop
      fetch mqjzdzs_cur into mqjzdzsdm ;
      exit when mqjzdzs_cur%notfound;

      end loop;
      close mqjzdzs_cur;

      open  mqjzdzq_cur for
      select t.code from code_info t where (t.name like mqjzdzq or t.name like mqjzdzq||'_') and substr(t.code,0,4)=substr(mqjzdzsdm,0,4);
      loop
      fetch mqjzdzq_cur into mqjzdzqdm ;
      exit when mqjzdzq_cur%notfound;
      end loop;
      close mqjzdzq_cur;

      open  mqjzdzjd_cur for
      select t.code from code_info t where (t.name like mqjzdzjd or t.name like mqjzdzjd||'_' or t.name like mqjzdzjd||'__') and substr(t.code,0,6)=substr(mqjzdzqdm,0,6);
      loop
      fetch mqjzdzjd_cur into mqjzdzjddm ;
      exit when mqjzdzjd_cur%notfound;
      end loop;
      close mqjzdzjd_cur;

    else
      mqjzdzshdm := '1';
    end if;



    open  jtgz_cur for
    select t.vc_newyydm,t.vc_csyymc,t.vc_oldyymc from zjjk_hospital_relation t where t.vc_oldyymc like zy||'、%' and vc_type='TYPE_JTGZ';
    loop
    fetch jtgz_cur into jtgzdm,zydm,lszy;
    exit when jtgz_cur%notfound;
    end loop;
    close jtgz_cur;

    if (substr(czhkdzsh,0,2) ='浙江') then
      czhkdzshdm := '0';
      open  czhkdzs_cur for
      select t.code from code_info t where t.name = czhkdzs or t.name like czhkdzs||'_';
      loop
      fetch czhkdzs_cur into czhkdzsdm ;
      exit when czhkdzs_cur%notfound;
      end loop;
      close czhkdzs_cur;

      open  czhkdzq_cur for
      select t.code from code_info t where (t.name like czhkdzq or t.name like czhkdzq||'_') and substr(t.code,0,4)=substr(czhkdzsdm,0,4);
      loop
      fetch czhkdzq_cur into czhkdzqdm ;
      exit when czhkdzq_cur%notfound;
      end loop;
      close czhkdzq_cur;

      open  czhkdzjd_cur for
      select t.code from code_info t where (t.name like czhkdzjd or t.name like czhkdzjd||'_' or t.name like czhkdzjd||'__') and substr(t.code,0,6)=substr(czhkdzqdm,0,6);
      loop
      fetch czhkdzjd_cur into czhkdzjddm ;
      exit when czhkdzjd_cur%notfound;
      end loop;
      close czhkdzjd_cur;
      if (czhkdzshdm is null) then
         czhkdzshdm:=mqjzdzshdm;
      end if;
      if (czhkdzsdm is null) then
         czhkdzsdm:=mqjzdzsdm;
      end if;
      if (czhkdzqdm is null) then
         czhkdzqdm:=mqjzdzqdm;
      end if;
      if (czhkdzjddm is null) then
         czhkdzjddm:=mqjzdzjddm;
      end if;
      if (czhkdzjddm  is not null and length(czhkdzjddm)=8) then
          open  gldwdm_cur for
          select t.code from organ_node t where t.description like '%'||substr(czhkdzjddm,0,8)||'%';
          loop
          fetch gldwdm_cur into code ;
          exit when gldwdm_cur%notfound;
          if (gldwdm is not null) then
             gldwdm:= code||','||gldwdm;
             sdqrzt:='0';
          else
             gldwdm:= code;
             sdqrzt:='1';
          end if;
          end loop;
          close gldwdm_cur;
     end if;
    else
      czhkdzshdm := '1';
      gldwdm:= '99999999';
    end if;


    /*open p_cur2 for
    select t.vc_newyydm from zjjk_hospital_relation t where t.vc_oldyymc like '%'||bkdw||'%' and vc_type='TYPE_HOSPITAL';
    loop
    fetch p_cur2 into newyydm ;
    exit when p_cur2%notfound;
    end loop;
    close p_cur2;*/

    open mz_cur for
    select t.vc_newyydm from zjjk_hospital_relation t where t.vc_oldyymc like '%'||mz||'%' and vc_type='TYPE_MZ';
    loop
    fetch mz_cur into mzdm ;
    exit when mz_cur%notfound;
    end loop;
    close mz_cur;

    open whcd_cur for
    select t.vc_newyydm from zjjk_hospital_relation t where t.vc_oldyymc like '%'||whcd||'%' and vc_type='TYPE_WHCD';
    loop
    fetch whcd_cur into whcddm ;
    exit when whcd_cur%notfound;
    end loop;
    close whcd_cur;


    if (mqjzxxdz is null) then
      mqjzxxdz := '空';
    end if;
    if (bkys is null) then
      bkys := '空';
    end if;
    if (zddw is null) then
      zddw := '9';
    end if;



    if (ywbfz2 = '1') then
      ywbfz2 := '2';
    end if;
    if (ywbfz3 = '1') then
      ywbfz3 := '3';
    end if;
    if (ywbfz4 = '1') then
      ywbfz4 := '4';
    end if;
    if (ywbfz5 = '1') then
      ywbfz5 := '5';
    end if;
    if (ywbfz1 = '0' and ywbfz2 = '0' and ywbfz3 = '0' and ywbfz4 = '0' and ywbfz5 = '0') then
       ywbfz6:= '6';
    end if;

    if (gxy = '1') then
      gxy := '2';
    end if;
    if (gxz = '1') then
      gxz := '3';
    end if;
    if (jdefms = '1') then
      jdefms := '4';
    end if;

    if (mq = '1') then
      mq := '2';
    end if;
    if (xd = '1') then
      xd := '3';
    end if;
    if (jm = '1') then
      jm := '4';
    end if;

    if(sg is not null and tz is not null) then
      bmi:=trunc(10000*tz/(sg*sg), 2) ;
    end if;



    open  icd_cur for
    select t.icd10_code from t_icd10 t where t.icd10_code = icdbm ;
    loop
    fetch icd_cur into icdtemp ;
    exit when icd_cur%notfound;
    end loop;
    close icd_cur;

    open  swicd_cur for
    select t.icd10_code from t_icd10 t where t.icd10_code = swicd ;
    loop
    fetch swicd_cur into a1 ;
    exit when swicd_cur%notfound;
    end loop;
    if(a1 is null) then
   -- prc_err_log('糖尿病',kpbh||' ---------'||xm||'---------'||a3||'---------'||'死亡ICD_10做过修正');
    swicd := substr(swicd,1,3);
    end if;
    close swicd_cur;

    open  swicdmc_cur for
    select t.icd10_name  from t_icd10 t where t.icd10_code = swicd ;
    loop
    fetch swicdmc_cur into swicdmc ;
    exit when swicdmc_cur%notfound;
    end loop;
    close swicdmc_cur;

    if(swicd is not null) then
      swyy := '2';
    if((substr(swicd,1,1)='E'and to_number(substr(swicd,2))>=10 and to_number(substr(swicd,2))<=14) or (substr(swicd,1,1)='O'and to_number(substr(swicd,2))>=24 and to_number(substr(swicd,2))<25) or (substr(swicd,1,1)='P'and to_number(substr(swicd,2))= 70.2)) then
      swyy := '1';
    end if;
    end if;


    if (mqjzdzshdm is not null and mqjzdzsdm is not null and mqjzdzqdm is not null and mqjzdzjddm is not null)  then
    if (icdtemp is not null) then

insert into ZJJK_TNB_HZXX (VC_PERSONID, VC_HZXM, VC_HZXB, VC_HZMZ, VC_WHCD, DT_HZCSRQ, VC_SZNL, VC_SFZH,
VC_LXDH, VC_HYDM, VC_ZYDM, VC_GZDW, VC_HKSHEN, VC_HKS, VC_HKQX, VC_HKJD, VC_HKJW, VC_HKXXDZ, VC_JZDS, VC_JZS, VC_JZQX, VC_JZJD, VC_JZJW, VC_JZXXDZ)
values ('000000'||a3, xm, xb, mzdm, whcddm, csrq, fbnl, sfzh,
lxdhqh||lxdh, zydm, jtgzdm, gzdw, czhkdzshdm, czhkdzsdm, czhkdzqdm, czhkdzjddm, czhkdzjw,czhkxxdz, mqjzdzshdm, mqjzdzsdm, mqjzdzqdm, mqjzdzjddm, mqjzdzjw, mqjzxxdz);

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
values (a3, '1', '000000'||a3, icdbm, tnblx, fp||','||gxy||','||gxz||','||jdefms, tz, sg,
fq||','||mq||','||xd||','||jm,to_number(xdjm), ywbfz6||','||ywbfz1||','||ywbfz2||','||ywbfz3||','||ywbfz4||','||ywbfz5, null, null,null, null, null, null, null,
null, null, null, null, null, zdrq, zddw, newyydm, bkys, bkrq,
null, swrq, swyy, swicd, swicdmc, null, '0', null, null, null,
sdqrzt, null, null, sysdate, newyydm, null, null, gldwdm, '3', null,
null, null, null, null, '0', null, null, null, null, null,
null, null, null, null, newyydm, null, null, null, null, null, zddw,
fbnl, null, null, null, null, null,  a0, a3||'f', null, null, null, null,
null, null, null, null, null, null, null, null, '0', null, substr(newyydm,1,4)||'0000', substr(newyydm,1,6)||'00',
bmi, '0', null, null, null, null, null, null, null, lszy,zhsfqk, sznl);

/*insert into ZJJK_TNB_BGKDJC (VC_BGKID, VC_BGKLX, VC_HZID, VC_ICD10, VC_TNBLX, VC_WXYS, VC_WXYSTZ, VC_WXYSSG,
VC_TNBS, VC_JZSRS, VC_YWBFZ, VC_ZSLCBX, VC_ZSLCBXQT, NB_KFXTZ, NB_SJXTZ, NB_XJPTT, NB_ZDGC, NB_E4HDLC,
NB_E5LDLC, NB_GYSZ, NB_NWLDB, NBTHXHDB, VC_BSZYQT, DT_SCZDRQ, VC_ZDDW, VC_BGDW, VC_BGYS, DT_BGRQ,
VC_SFSW, DT_SWRQ, VC_SWYY, VC_SWICD10, VC_SWICDMC, VC_BSZY, VC_SCBZ, VC_CCID, VC_CKBZ, VC_SFBB,
VC_SDQRZT, DT_QRSJ, VC_SDQRID, DT_CJSJ, VC_CJDW, DT_XGSJ, VC_XGDW, VC_GLDW, VC_SHBZ, VC_SHWTGYY1,
VC_SHWTGYY2, VC_KHBZ, VC_KHJG, VC_SMTJID, VC_QYBZ, VC_HKHS, VC_HKWHSYY, VC_JZHS, VC_JZWHSYY, VC_CXGL,
VC_QCBZ, VC_XGYH, VC_CJYH, VC_XXLY, VC_BZ, DT_DCRQ, VC_DCR, VC_ZDYH, VC_SWXX, VC_BGDWQX, VC_ZGZDDW,
VC_SZNL, VC_ICDO, VC_ZYH, VC_MZH, VC_BQYGZBR, VC_XZQYBM, VC_BGKZT, VC_BGKCODE, VC_QCD, VC_QCSDM, VC_QCQXDM,
VC_QCJDDM, VC_QCJW, VC_SFQC, DT_QCSJ, VC_QCXXDZ, VC_SHID, VC_KHID, VC_KHZT, VC_SHZT, VC_CFZT, VC_SHWTGYY,
VC_BKS, VC_BKQ, VC_BMI, VC_WTZT, VC_YWTDW, VC_SQSL, VC_JJSL, VC_YWTJD, VC_YWTJW, VC_YWTXXDZ, VC_YWTJGDM)
values (a3, '1', '000000'||a3, icdbm, tnblx, fp, to_number(tz), to_number(sg),
null,to_number(xdjm), ywbfz1||','||ywbfz2||','||ywbfz3||','||ywbfz4||','||ywbfz5, null, null,null, null, null, null, null,
null, null, null, null, null, to_date(zdrqr||'-'||zdrqy||'-'||zdrqn, 'dd-mm-yyyy'), zddw, newyydm, bkys, to_date(bkrqr||'-'||bkrqy||'-'||bkrqn, 'dd-mm-yyyy'),
null, swrq, swyy, swyy, null, null, '0', null, null, null,
'1', null, null, sysdate, newyydm, null, null, czhkdzqdm, '1', null,
null, null, null, null, '0', null, null, null, null, null,
null, null, null, null, '000000', null, null, null, null, null, zddw,
null, null, null, null, null, null, a0, a3, null, null, null, null,
null, null, null, null, null, null, null, null, '0', null, substr(newyydm,1,4)||'0000', substr(newyydm,1,6)||'00',
null, '0', null, null, null, null, null, null, null);  */
      commit;
      j:=j+1;
  else
    insert into zjjk_tnb_temp_error (select * from zjjk_tnb_temp where rowid=bzw);
    prc_err_log('糖尿病',kpbh||' ---------'||xm||'---------'||a3||'---------'||'ICD_10无法对应');
    Commit;
  end if ;
  else
    insert into zjjk_tnb_temp_error (select * from zjjk_tnb_temp where rowid=bzw);
    prc_err_log('糖尿病',kpbh||' ---------'||xm||'---------'||a3||'---------'||'目前居住地址或常住户口地址中的省、市、区县、街道有误');
    Commit;
  end if ;
      Exception
  When Others Then
  Rollback;
    insert into zjjk_tnb_temp_error (select * from zjjk_tnb_temp where rowid=bzw);
  prc_err_log('糖尿病',kpbh||' ---------'||xm||'---------'||a3||'---------'||'出生日期或死亡日期或报卡日期为空或格式不正确');
  Commit;
    end;

  else
    insert into zjjk_tnb_temp_error (select * from zjjk_tnb_temp where rowid=bzw);
  prc_err_log('糖尿病',kpbh||' ---------'||xm||'---------'||bkdw||'---------'||'报告单位不存在或者报卡日期不是02-08年的数据');
  Commit;
  end if ;
/*  else
    insert into zjjk_tnb_temp_error (select * from zjjk_tnb_temp where rowid=bzw);
  prc_err_log('糖尿病',kpbh||' ---------'||xm||'---------'||bkdw||'---------'||'历史职业无法对应');
  Commit;
  end if ;*/
       end loop;
close p_cur1;
 prc_err_log('ZJJK_TNB_LSSJDR','糖尿病成功导入'||'---------'||j||'---------'||'条数据');
 Commit;
end ZJJK_TNB_LSSJDR;

