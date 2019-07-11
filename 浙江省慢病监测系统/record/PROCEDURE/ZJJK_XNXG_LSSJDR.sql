create or replace procedure      ZJJK_XNXG_LSSJDR is
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
 hy               varchar2(1024);
 csn              varchar2(1024);
 csy              varchar2(1024);
 csr              varchar2(1024);
 sznl             varchar2(1024);
 fbnl             varchar2(1024);
 zy               varchar2(1024);
 jtgz             varchar2(1024);
 sfzh             varchar2(1024);
 whcd             varchar2(1024);
 mz               varchar2(1024);
 jtdhqh           varchar2(1024);
 jtdh             varchar2(1024);
 gzdw             varchar2(1024);
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
 czhkdzshdm         varchar2(1024);
 czhkdzsdm          varchar2(1024);
 czhkdzqdm          varchar2(1024);
 czhkdzjddm         varchar2(1024);
 mqjzdzshdm         varchar2(1024);
 mqjzdzsdm          varchar2(1024);
 mqjzdzqdm          varchar2(1024);
 mqjzdzjddm         varchar2(1024);
 icd10            varchar2(1024);
 swicd            varchar2(1024);
 swicdmc          varchar2(1024);
 jxxjgs           varchar2(1024);
 xxcs             varchar2(1024);
 zwmxqcx          varchar2(1024);
 ncx              varchar2(1024);
 nxsxc            varchar2(1024);
 ngs              varchar2(1024);
 flbm             varchar2(1024);
 sfscfb           varchar2(1024);
 lczd             varchar2(1024);
 xgzy             varchar2(1024);
 xdt              varchar2(1024);
 ct               varchar2(1024);
 xqm              varchar2(1024);
 cgz              varchar2(1024);
 nsy              varchar2(1024);
 sj               varchar2(1024);
 ndt              varchar2(1024);
 sjkysjc          varchar2(1024);
 mxqxxxzb         varchar2(1024);
 gxy              varchar2(1024);
 tnb              varchar2(1024);
 gzxz             varchar2(1024);
 shy              varchar2(1024);
 shj              varchar2(1024);
 fbrqn            varchar2(1024);
 fbrqy            varchar2(1024);
 fbrqr            varchar2(1024);
 qzrqn            varchar2(1024);
 qzrqy            varchar2(1024);
 qzrqr            varchar2(1024);
 qzdw             varchar2(1024);
 mzh              varchar2(1024);
 zyh              varchar2(1024);
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
 sfxg             varchar2(1024);
 czr              varchar2(1024);
 lkdw             varchar2(1024);
  a0              varchar2(1024);
  a1              varchar2(1024);
  a2              integer;
  swrq            date;
  csrq            date;
  fbrq            date;
  bkrq            date;
  qzrq            date;
  a3              varchar2(1024);
 dygxsfdg         varchar2(1024);
 newyydm          varchar2(1024);
 yydm             varchar2(1024);
 zydm             varchar2(1024);
 jtgzdm           varchar2(1024);
 mzdm             varchar2(1024);
 whcddm           varchar2(1024);
 code             varchar2(1024);
 gldwdm           varchar2(1024);
 sdqrzt           varchar2(1024);
 bzw              varchar2(1024);
 lszy             varchar2(1024);
 icdtemp          varchar2(1024);
  j               integer;
  begin
       j:=0;
       open p_cur1 for
       select t.*,t.rowid from zjjk_xnxg_temp t --where vc_bkdw='浙一'
       ;
        loop
        fetch p_cur1 into kpbh,xm,xb,hy,csn,csy,csr,sznl,zy,jtgz,sfzh,whcd,mz,
        jtdhqh,jtdh,gzdw,czhkdzsh,czhkdzs,czhkdzq,czhkdzjd,czhkdzjw,czhkxxdz,mqjzdzsh,mqjzdzs,mqjzdzq,
        mqjzdzjd,mqjzdzjw,mqjzxxdz,icd10,jxxjgs,xxcs,zwmxqcx,ncx,nxsxc,ngs,flbm,
        sfscfb,lczd,xgzy,xdt,ct,xqm,cgz,nsy,sj,ndt,sjkysjc,mxqxxxzb,gxy,tnb,gzxz,
        shy,shj,fbrqn,fbrqy,fbrqr,qzrqn,qzrqy,qzrqr,qzdw,mzh,zyh,bkdw,
        bkys,bkrqn,bkrqy,bkrqr,zhjcsjn,zhjcsjy,zhjcsjr,zhsfqk,swrqn,swrqy,swrqr,
        swicd,sfxg,czr,lkdw,bzw;
        exit when p_cur1%notfound;
        dygxsfdg:='0';
        newyydm:=null;
        yydm:=null;
    open p_cur2 for
    select t.vc_newyydm from zjjk_hospital_relation t where t.vc_newyymc = bkdw and vc_type='TYPE_HOSPITAL'
    ;
    loop
    fetch p_cur2 into newyydm;
    exit when p_cur2%notfound;
        yydm:= yydm||newyydm;
       if (yydm is not null and length(yydm)!=9) then
        dygxsfdg:='1';
       end if;
    end loop;
    close p_cur2;
  --  if (zy is not null and to_number(zy) <= 10) then
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
    czhkdzjddm:=null;
    mqjzdzshdm:=null;
    mqjzdzsdm:=null;
    mqjzdzqdm:=null;
    mqjzdzjddm:=null;
    code:=null;
    sdqrzt:='1';
    gldwdm:=null;
    jtgzdm:=null;
    zydm:=null;
    lszy:=null;
    icdtemp:=null;
    swyy:=null;
    swicdmc:=null;
    icd10:=upper(icd10);
    swicd:=upper(swicd);

    select max(to_number(substr(t.vc_bgkbh,0,14)))+1 into a2 from zjjk_xnxg_bgk t where t.vc_bkdwyy=newyydm and substr(t.vc_bgkbh,0,2)=substr(bkrqn,3);
    if (swrqn is null) then
      a0 := '0';
    else
      a0 := '7';
      swrq:=to_date(swrqr||'-'||swrqy||'-'||swrqn, 'dd-mm-yyyy');
    end if;
     if (a2 is NULL) then
      a2:=1;
    end if;
    if (a2 = 1) then
      a3 := substr(bkrqn,3)||substr(newyydm,3)||'00001';
    else
      a3 := '0'||a2;
    end if;

      qzrq:=to_date(qzrqr||'-'||qzrqy||'-'||qzrqn, 'dd-mm-yyyy');
      csrq:=to_date(csr||'-'||csy||'-'||csn, 'dd-mm-yyyy');
      fbrq:=to_date(fbrqr||'-'||fbrqy||'-'||fbrqn, 'dd-mm-yyyy');
      bkrq:=to_date(bkrqr||'-'||bkrqy||'-'||bkrqn, 'dd-mm-yyyy');

      sznl:=trunc(months_between(bkrq,csrq)/12,0);
      fbnl:=trunc(months_between(fbrq,csrq)/12,0);



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
      if (czhkdzjddm is not null and length(czhkdzjddm)=8) then
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


    open  jtgz_cur for
     select t.vc_newyydm,t.vc_csyymc,t.vc_oldyymc from zjjk_hospital_relation t where t.vc_oldyymc like zy||'、%' and vc_type='TYPE_JTGZ';
    loop
    fetch jtgz_cur into jtgzdm,zydm,lszy ;
    exit when jtgz_cur%notfound;
    end loop;
    close jtgz_cur;

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

    if (whcddm is null) then
      whcddm := '9';
    end if;
    if (mqjzxxdz is null) then
      mqjzxxdz := '空';
    end if;
    if (qzdw is null) then
      qzdw := '9';
    end if;
    if (sfscfb is null) then
      sfscfb := '1';
    end if;
    if (bkys is null) then
      bkys := '空';
    end if;

    if (gxy='1') then
      gxy := '2';
    end if;
    if (tnb='1') then
      tnb := '3';
    end if;
    if (gzxz='1') then
      gzxz := '4';
    end if;
    if (shy ='1') then
      shy := '5';
    end if;
    if (shj ='1') then
      shj := '6';
    end if;

    open  icd_cur for
    select t.icd10_code from t_icd10 t where t.icd10_code = icd10 ;
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
    swicd := substr(swicd,1,3);
 --   prc_err_log('心脑血管',kpbh||' ---------'||xm||'---------'||a3||'---------'||'死亡ICD_10做过修正');
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
      swyy := '1';
    if((substr(swicd,1,1)='I'and to_number(substr(swicd,2))>=20 and to_number(substr(swicd,2))<=25) or (substr(swicd,1,1)='I'and to_number(substr(swicd,2))>=46 and to_number(substr(swicd,2))<47) or (substr(swicd,1,1)='I' and to_number(substr(swicd,2))>= 60 and to_number(substr(swicd,2))<= 64  and to_number(substr(swicd,2,2))!= 62 )) then
      swyy := '0';
    end if;
    end if;

    if (mqjzdzshdm is not null and mqjzdzsdm is not null and mqjzdzqdm is not null and mqjzdzjddm is not null)  then
    if (icdtemp is not null) then

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
values (a3, mzh, zyh, a3||'f', '1', xm,
xb, hy, icd10, csrq, fbnl, zydm, sfzh, jtgzdm,
whcddm, mzdm, jtdhqh||jtdh, gzdw, czhkdzshdm, czhkdzsdm, czhkdzjddm,
mqjzdzshdm, mqjzdzsdm, mqjzdzjddm, mqjzdzjw, jxxjgs||','||xxcs||',0', zwmxqcx||','||ncx||','||nxsxc||','||ngs||',0,'||flbm, lczd,
xdt, xqm, nsy, ndt, xgzy, ct, cgz, sj, sjkysjc,
mxqxxxzb||','||gxy||','||tnb||','||gzxz||','||shy||','||shj, fbrq ,qzrq, sfscfb, qzdw, substr(newyydm,1,4)||'0000', bkys,bkrq,
swrq, swyy, newyydm, '2', gldwdm, newyydm, null,
null, sdqrzt, null, null, sysdate, newyydm, null,
null, '3', null, null, mqjzxxdz, czhkdzjw, czhkxxdz,
czhkdzqdm, mqjzdzqdm, swicd, swicdmc, substr(newyydm,1,6)||'00', newyydm,
null, '0', null, null, null, null, null,
null, null, null, null, null, null, null,
null, null, null, null, null, null, '0', null, null, null, null, null, null, null, lszy, zhsfqk, sznl);

/*insert into ZJJK_XNXG_BGKDJC (VC_BGKID, VC_MZH, VC_ZYH, VC_BGKBH, VC_BGKLX, VC_HZXM,
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
VC_YWTDW, VC_SQSL, VC_JJSL, VC_YWTJD, VC_YWTJW, VC_YWTXXDZ, VC_YWTJGDM)
values (a3, mzh, zyh, a3, '1', xm,
xb, hy, icd10, to_date(csr||'-'||csy||'-'||csn, 'dd-mm-yyyy'), sznl, zy, sfzh, jtgzdm,
whcddm, mzdm, jtdhqh||jtdh, gzdw, czhkdzshdm, czhkdzsdm, czhkdzjddm,
mqjzdzshdm, mqjzdzsdm, mqjzdzjddm, mqjzdzjw, jxxjgs||','||xxcs||',0', zwmxqcx||','||ncx||','||nxsxc||','||ngs||',0,'||flbm, lczd,
xdt, xqm, nsy, ndt, xgzy, ct, cgz, sj, sjkysjc,
mxqxxxzb||'-'||gxy||'-'||tnb||'-'||gzxz||'-'||shy||'-'||shj, to_date(fbrqr||'-'||fbrqy||'-'||fbrqn, 'dd-mm-yyyy'), to_date(qzrqr||'-'||qzrqy||'-'||qzrqn, 'dd-mm-yyyy'), sfscfb, qzdw, substr(newyydm,1,4)||'0000', bkys, to_date(bkrqr||'-'||bkrqy||'-'||bkrqn, 'dd-mm-yyyy'),
swrq, swyy, newyydm, '2', czhkdzqdm, newyydm, null,
null, '1', null, null, sysdate, newyydm, null,
null, '1', null, null, mqjzxxdz, czhkdzjw, czhkxxdz,
czhkdzqdm, mqjzdzqdm, swyy, null, substr(newyydm,1,6)||'00', newyydm,
null, '0', null, null, null, null, null,
null, null, null, null, null, null, null,
null, null, null, null, null, null, '0', null, null, null, null, null, null, null);*/
  commit;
  j:=j+1;
  else
    insert into zjjk_xnxg_temp_error (select * from zjjk_xnxg_temp where rowid=bzw);
    prc_err_log('心脑血管',kpbh||' ---------'||xm||'---------'||a3||'---------'||'ICD_10无法对应');
    Commit;
  end if ;
  else
    insert into zjjk_xnxg_temp_error (select * from zjjk_xnxg_temp where rowid=bzw);
    prc_err_log('心脑血管',kpbh||' ---------'||xm||'---------'||a3||'---------'||'目前居住地址或常住户口地址中的省、市、区县、街道有误');
    Commit;
  end if ;
  Exception
  When Others Then
  Rollback;
    insert into zjjk_xnxg_temp_error (select * from zjjk_xnxg_temp where rowid=bzw);
  prc_err_log('心脑血管',kpbh||'---------'||xm||'---------'||a3||'---------'||'出生日期或死亡日期或报卡日期为空或格式不正确');
  Commit;
  end;
  else
    insert into zjjk_xnxg_temp_error (select * from zjjk_xnxg_temp where rowid=bzw);
  prc_err_log('心脑血管',kpbh||'---------'||xm||'---------'||bkdw||'---------'||'报告单位不存在或者报卡日期不是02-08年的数据');
  Commit;
  end if;
/*  else
    insert into zjjk_xnxg_temp_error (select * from zjjk_xnxg_temp where rowid=bzw);
  prc_err_log('心脑血管',kpbh||'---------'||xm||'---------'||bkdw||'---------'||'历史职业无法对应');
  Commit;
  end if;*/
    end loop;
    close p_cur1;
  prc_err_log('ZJJK_XNXG_LSSJDR','心脑血管成功导入'||'---------'||j||'---------'||'条数据');
  Commit;
end ZJJK_XNXG_LSSJDR;

