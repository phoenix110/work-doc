CREATE OR REPLACE Procedure Tnb_ExValidate as
  temp_hkqxdm VARCHAR2(60);
  v_bgkmc varchar(60);
  v_bgkid varchar(60);
  v_sqlerrm varchar(4000);
  cursor bgk_cur is select * from zjjk.zjjk_tnb_bgk_ex ex
  where ex.is_pass='1' ; --and not exists(select 1 from zjjk.zjjk_tnb_bgk g where ex.vc_yyrid=g.vc_bgkid);
  begin

    /*zjjk_tnb_hzxx_ex*/

    --设置校验标志 0-待校验
    update zjjk_tnb_hzxx_ex x set x.is_pass='0' where trim(x.is_pass) is null;

    --校验必填项
    update zjjk_tnb_hzxx_ex x set x.validate_detail=x.validate_detail||'患者ID为空;' where trim(x.vc_personid) is null;
    update zjjk_tnb_hzxx_ex x set x.validate_detail=x.validate_detail||'患者ID长度不得不得小于15位;' where length(x.vc_personid)<15;
    update zjjk_tnb_hzxx_ex x set x.validate_detail=x.validate_detail||'患者姓名为空;' where trim(x.vc_hzxm) is null;
    update zjjk_tnb_hzxx_ex x set x.validate_detail=x.validate_detail||'患者性别为空;' where trim(x.vc_hzxb) is null;
    update zjjk_tnb_hzxx_ex x set x.validate_detail=x.validate_detail||'患者民族为空;' where trim(x.vc_hzmz) is null;
    update zjjk_tnb_hzxx_ex x set x.validate_detail=x.validate_detail||'文化程度为空;' where trim(x.vc_whcd) is null;
    update zjjk_tnb_hzxx_ex x set x.validate_detail=x.validate_detail||'患者出生日期为空;' where trim(x.dt_hzcsrq) is null;
    update zjjk_tnb_hzxx_ex x set x.validate_detail=x.validate_detail||'患者出生年份不合理;' where to_char(x.dt_hzcsrq,'yyyy')<1900 or to_char(x.dt_hzcsrq,'yyyy')>2100;
    update zjjk_tnb_hzxx_ex x set x.validate_detail=x.validate_detail||'联系电话为空;' where trim(x.vc_lxdh) is null;
    update zjjk_tnb_hzxx_ex x set x.validate_detail=x.validate_detail||'行业代码为空;' where trim(x.vc_hydm) is null;
    update zjjk_tnb_hzxx_ex x set x.validate_detail=x.validate_detail||'职业代码-具体工种为空;' where trim(x.vc_zydm) is null;
    update zjjk_tnb_hzxx_ex x set x.validate_detail=x.validate_detail||'户口省份为空;' where trim(x.vc_hkshen) is null;
    update zjjk_tnb_hzxx_ex x set x.validate_detail=x.validate_detail||'户口市为空;' where trim(x.vc_hks) is null;
    update zjjk_tnb_hzxx_ex x set x.validate_detail=x.validate_detail||'户口区县为空;' where trim(x.vc_hkqx) is null;
    update zjjk_tnb_hzxx_ex x set x.validate_detail=x.validate_detail||'户口详细地址为空;' where trim(x.vc_hkxxdz) is null;
    update zjjk_tnb_hzxx_ex x set x.validate_detail=x.validate_detail||'居住地址省为空;' where trim(x.vc_jzds) is null;
    update zjjk_tnb_hzxx_ex x set x.validate_detail=x.validate_detail||'居住地址市为空;' where x.vc_jzds='0' and trim(x.vc_jzs) is null;
    update zjjk_tnb_hzxx_ex x set x.validate_detail=x.validate_detail||'居住地址区县为空;' where x.vc_jzds='0' and trim(x.vc_jzqx) is null;
    update zjjk_tnb_hzxx_ex x set x.validate_detail=x.validate_detail||'居住详细地址为空;' where trim(x.vc_jzxxdz) is null;

    --校验代码
    update zjjk_tnb_hzxx_ex x set x.validate_detail=x.validate_detail||'患者性别编码无效;' where trim(x.VC_HZXB) is not null and checkdic('C_COMM_XB',trim(x.VC_HZXB))=0;------
    update zjjk_tnb_hzxx_ex x set x.validate_detail=x.validate_detail||'患者民族编码无效;' where trim(x.VC_HZMZ) is not null and checkdic('C_COMM_MZ',trim(x.VC_HZMZ))=0;
    update zjjk_tnb_hzxx_ex x set x.validate_detail=x.validate_detail||'文化程度编码无效;' where trim(x.VC_WHCD) is not null and checkdic('C_COMM_WHCD',trim(x.VC_WHCD))=0;
    --update zjjk_tnb_hzxx_ex x set x.validate_detail=x.validate_detail||'患者出生日期不小于诊断日期;' where trim(x.DT_HZCSRQ) is not null and x.DT_HZCSRQ>
    update zjjk_tnb_hzxx_ex x set x.validate_detail=x.validate_detail||'行业代码编码无效;' where trim(x.VC_HYDM) is not null and checkdic('C_COMM_HY',trim(x.VC_HYDM))=0;
    update zjjk_tnb_hzxx_ex x set x.validate_detail=x.validate_detail||'职业代码-具体工种编码无效;' where trim(x.VC_ZYDM) is not null and checkdic('C_COMM_ZY',trim(x.VC_ZYDM))=0;
    update zjjk_tnb_hzxx_ex x set x.validate_detail=x.validate_detail||'户口省份编码无效;' where trim(x.VC_HKSHEN) is not null and checkdic('C_COMM_SHEDM',trim(x.VC_HKSHEN))=0;
    update zjjk_tnb_hzxx_ex x set x.validate_detail=x.validate_detail||'户口市编码无效;' where trim(x.VC_HKS) is not null and checkdic('C_COMM_SJDM',trim(x.VC_HKS))=0;
    update zjjk_tnb_hzxx_ex x set x.validate_detail=x.validate_detail||'户口区县编码无效;' where trim(x.VC_HKQX) is not null and checkdic('C_COMM_QXDM',trim(x.VC_HKQX))=0;
    update zjjk_tnb_hzxx_ex x set x.validate_detail=x.validate_detail||'户口街道无效;' where trim(x.VC_HKJD) is not null and checkdic('C_COMM_JDDM',trim(x.VC_HKJD))=0;--------
    update zjjk_tnb_hzxx_ex x set x.validate_detail=x.validate_detail||'居住地址省无效;' where trim(x.VC_JZDS) is not null and checkdic('C_COMM_SHEDM',trim(x.VC_JZDS))=0;
    update zjjk_tnb_hzxx_ex x set x.validate_detail=x.validate_detail||'居住地址市无效;' where trim(x.VC_JZS) is not null and checkdic('C_COMM_SJDM',trim(x.VC_JZS))=0;
    update zjjk_tnb_hzxx_ex x set x.validate_detail=x.validate_detail||'居住地址区县无效;' where trim(x.VC_JZQX) is not null and checkdic('C_COMM_QXDM',trim(x.VC_JZQX))=0;
    update zjjk_tnb_hzxx_ex x set x.validate_detail=x.validate_detail||'居住街道无效;' where trim(x.VC_JZJD) is not null and checkdic('C_COMM_JDDM',trim(x.VC_JZJD))=0;---------
    update zjjk_tnb_hzxx_ex x set x.validate_detail=x.validate_detail||'重复上报;' where exists(select 1 from zjjk.zjjk_tnb_hzxx h where x.vc_personid=h.vc_personid);
  commit;
    --设置校验标志 1-通过 2-不通过
    update zjjk_tnb_hzxx_ex x set x.is_pass='2' where x.is_pass='0' and trim(x.validate_detail) is not null;
    update zjjk_tnb_hzxx_ex x set x.is_pass='1' where x.is_pass='0' and trim(x.validate_detail) is null;
    commit;

    insert into zjjk_tnb_hzxx_ex_bak
          (uuid, vc_personid, vc_hzxm, vc_hzxb, vc_hzmz, vc_whcd, dt_hzcsrq, vc_sfzh, vc_lxdh, vc_hydm, vc_zydm, vc_gzdw, vc_hkshen, vc_hks, vc_hkqx, vc_hkjd, vc_hkjw, vc_hkxxdz, vc_jzds, vc_jzs, vc_jzqx, vc_jzjd, vc_jzjw, vc_jzxxdz, is_pass, validate_detail, validate_date)
    select sys_guid(), vc_personid, vc_hzxm, vc_hzxb, vc_hzmz, vc_whcd, dt_hzcsrq, trim(vc_sfzh), vc_lxdh, vc_hydm, vc_zydm, vc_gzdw, vc_hkshen, vc_hks, vc_hkqx, vc_hkjd, vc_hkjw, vc_hkxxdz, vc_jzds, vc_jzs, vc_jzqx, vc_jzjd, vc_jzjw, vc_jzxxdz, is_pass, validate_detail, sysdate
    from zjjk_tnb_hzxx_ex ;
    v_bgkmc:='inserttnbhzxxexbak';
    insert into zjjk_tnb_hzxx
          (vc_personid, vc_hzxm, vc_hzxb, vc_hzmz, vc_whcd, dt_hzcsrq, vc_sznl, vc_sfzh, vc_lxdh, vc_hydm, vc_zydm, vc_gzdw, vc_hkshen, vc_hks, vc_hkqx, vc_hkjd, vc_hkjw, vc_hkxxdz, vc_jzds, vc_jzs, vc_jzqx, vc_jzjd, vc_jzjw, vc_jzxxdz)
    select vc_personid, vc_hzxm, vc_hzxb, vc_hzmz, vc_whcd, dt_hzcsrq, getage(dt_hzcsrq), trim(vc_sfzh), vc_lxdh, vc_hydm, vc_zydm, vc_gzdw, vc_hkshen, vc_hks, vc_hkqx, vc_hkjd, vc_hkjw, vc_hkxxdz, vc_jzds, vc_jzs, vc_jzqx, vc_jzjd, vc_jzjw, vc_jzxxdz
    from zjjk_tnb_hzxx_ex x
    where x.is_pass='1' and not exists(select 1 from zjjk.zjjk_tnb_hzxx g where x.vc_personid=g.vc_personid);
    v_bgkmc:='inserttnbhzxx';
    commit;
    /*zjjk_tnb_bgk_ex*/

    --设置校验标志 0-待校验
    update zjjk_tnb_bgk_ex e set e.is_pass='0',e.validate_date=sysdate where trim(e.is_pass) is null;

    --校验必填项
    update zjjk_tnb_bgk_ex e set e.validate_detail=e.validate_detail||'医院唯一标识为空;' where trim(e.vc_yyrid) is null;
    update zjjk_tnb_bgk_ex e set e.validate_detail=e.validate_detail||'医院唯一标识长度不得小于15位;' where length(e.vc_yyrid)<15;
    update zjjk_tnb_bgk_ex e set e.validate_detail=e.validate_detail||'ICD-10为空;' where trim(e.vc_icd10) is null;
    update zjjk_tnb_bgk_ex e set e.validate_detail=e.validate_detail||'糖尿病类型为空;' where trim(e.vc_tnblx) is null;
    update zjjk_tnb_bgk_ex e set e.validate_detail=e.validate_detail||'有无并发症为空;' where trim(e.vc_ywbfz) is null;
    update zjjk_tnb_bgk_ex e set e.validate_detail=e.validate_detail||'主诉、临床表现为空;' where trim(e.vc_zslcbx) is null;
    update zjjk_tnb_bgk_ex e set e.validate_detail=e.validate_detail||'临床表现其它为空;' where trim(e.vc_zslcbxqt) is null and vc_zslcbx='10';
    update zjjk_tnb_bgk_ex e set e.validate_detail=e.validate_detail||'首次诊断日期为空;' where trim(e.dt_sczdrq) is null;
    update zjjk_tnb_bgk_ex e set e.validate_detail=e.validate_detail||'诊断单位为空;' where trim(e.vc_zddw) is null;
    update zjjk_tnb_bgk_ex e set e.validate_detail=e.validate_detail||'报卡单位为空;' where trim(e.vc_bgdw) is null;
    update zjjk_tnb_bgk_ex e set e.validate_detail=e.validate_detail||'报告医生为空;' where trim(e.vc_bgys) is null;
    update zjjk_tnb_bgk_ex e set e.validate_detail=e.validate_detail||'报告日期为空;' where trim(e.dt_bgrq) is null;
    update zjjk_tnb_bgk_ex e set e.validate_detail=e.validate_detail||'死亡原因为空;' where trim(e.vc_swyy) is null and trim(e.dt_swrq) is not null;
    --update zjjk_tnb_bgk_ex e set e.validate_detail=e.validate_detail||'死亡ICD-10为空;' where trim(e.vc_swicd10) is null and trim(e.dt_swrq) is not null;
    --update zjjk_tnb_bgk_ex e set e.validate_detail=e.validate_detail||'死亡具体原因为空;' where trim(e.vc_swicdmc) is null and trim(e.vc_swicd10) is not null;
    update zjjk_tnb_bgk_ex e set e.validate_detail=e.validate_detail||'患者ID为空;' where trim(e.vc_hzid) is null;
    update zjjk_tnb_bgk_ex e set e.validate_detail=e.validate_detail||'门诊与住院号都为空;' where trim(e.vc_zyh) is null and trim(e.vc_mzh) is null;
    update zjjk_tnb_bgk_ex e set e.validate_detail=e.validate_detail||'审核标志为空;' where trim(e.vc_shbz) is null;
    commit;
    --校验代码
    update zjjk_tnb_bgk_ex e set e.validate_detail=e.validate_detail||'ICD-10编码无效;' where trim(e.VC_ICD10) is not null and e.VC_ICD10 not in (select t1.icd10_code from T_ICD10 t1 where t1.icd10_code like '%E10%'
          or t1.icd10_code like '%E11%' or t1.icd10_code like '%E12%'
          or t1.icd10_code like '%E13%' or t1.icd10_code like '%E14%'
          or t1.icd10_code like '%N08.3%' or  t1.icd10_code like '%H28.0%'
          or  t1.icd10_code like '%P70.2%' or  t1.icd10_code like '%O24%');
    update zjjk_tnb_bgk_ex e set e.validate_detail=e.validate_detail||'糖尿病类型编码无效;' where trim(e.VC_TNBLX) is not null and checkdic('C_TNB_TNBLX',trim(e.VC_TNBLX))=0;
    update zjjk_tnb_bgk_ex e set e.validate_detail=e.validate_detail||'危险因素编码无效;' where trim(e.VC_WXYS) is not null and checkdic_multi('C_TNB_WXYS',trim(e.VC_WXYS))=0;
    update zjjk_tnb_bgk_ex e set e.validate_detail=e.validate_detail||'体重超出逻辑范围;' where trim(e.VC_WXYSTZ) is not null and (e.VC_WXYSTZ<0 or e.VC_WXYSTZ>200);
    update zjjk_tnb_bgk_ex e set e.validate_detail=e.validate_detail||'身高超出逻辑范围;' where trim(e.VC_WXYSSG) is not null and (e.VC_WXYSSG<40 or e.VC_WXYSSG>240) and e.VC_WXYSSG<>0;---放宽校验条件，允许身高为0（未填）的记录导入 (by Pan 2016-2-25)
    update zjjk_tnb_bgk_ex e set e.validate_detail=e.validate_detail||'糖尿病家族史编码无效;' where trim(e.VC_TNBS) is not null and checkdic_multi('C_TNB_TNBS',trim(e.VC_TNBS))=0;
    update zjjk_tnb_bgk_ex e set e.validate_detail=e.validate_detail||'有无并发症编码无效;' where trim(e.VC_YWBFZ) is not null and checkdic_multi('C_TNB_YWBFZ',trim(e.VC_YWBFZ))=0;
    update zjjk_tnb_bgk_ex e set e.validate_detail=e.validate_detail||'主诉、临床表现编码无效;' where trim(e.VC_ZSLCBX) is not null and checkdic_multi('C_TNB_LCBX',trim(e.VC_ZSLCBX))=0;
    update zjjk_tnb_bgk_ex e set e.validate_detail=e.validate_detail||'E1 空腹血糖值超出逻辑范围;' where trim(e.NB_KFXTZ) is not null and (e.NB_KFXTZ<0 or e.NB_KFXTZ>50);
    update zjjk_tnb_bgk_ex e set e.validate_detail=e.validate_detail||'E2 随机血糖值超出逻辑范围;' where trim(e.NB_SJXTZ) is not null and (e.NB_SJXTZ<0 or e.NB_SJXTZ>50);
    update zjjk_tnb_bgk_ex e set e.validate_detail=e.validate_detail||'E3 OGTT超出逻辑范围;' where trim(e.NB_XJPTT) is not null and (e.NB_XJPTT<0 or e.NB_XJPTT>50);
    update zjjk_tnb_bgk_ex e set e.validate_detail=e.validate_detail||'E4 总胆固醇超出逻辑范围;' where trim(e.NB_ZDGC) is not null and (e.NB_ZDGC<0 or e.NB_ZDGC>1000);
    update zjjk_tnb_bgk_ex e set e.validate_detail=e.validate_detail||'E5 HDL-C超出逻辑范围;' where trim(e.NB_E4HDLC) is not null and (e.NB_E4HDLC<0 or e.NB_E4HDLC>1000);
    update zjjk_tnb_bgk_ex e set e.validate_detail=e.validate_detail||'E6 LDL-C超出逻辑范围;' where trim(e.NB_E5LDLC) is not null and (e.NB_E5LDLC<0 or e.NB_E5LDLC>1000);
    update zjjk_tnb_bgk_ex e set e.validate_detail=e.validate_detail||'E7 甘油三酯超出逻辑范围;' where trim(e.NB_GYSZ) is not null and (e.NB_GYSZ<0 or e.NB_GYSZ>1000);
    update zjjk_tnb_bgk_ex e set e.validate_detail=e.validate_detail||'E8 尿微量蛋白超出逻辑范围;' where trim(e.NB_NWLDB) is not null and (e.NB_NWLDB<0 or e.NB_NWLDB>10000);
    update zjjk_tnb_bgk_ex e set e.validate_detail=e.validate_detail||'E9 糖化血红蛋白超出逻辑范围;' where trim(e.NBTHXHDB) is not null and (e.NBTHXHDB<0 or e.NBTHXHDB>100);
    update zjjk_tnb_bgk_ex e set e.validate_detail=e.validate_detail||'诊断单位编码无效;' where trim(e.VC_ZDDW) is not null and checkdic('C_ZL_ZGZDDW',trim(e.VC_ZDDW))=0;
    update zjjk_tnb_bgk_ex e set e.validate_detail=e.validate_detail||'患者ID长度不得小于15位;' where length(e.VC_HZID)<15;
    update zjjk_tnb_bgk_ex e set e.validate_detail=e.validate_detail||'对应患者信息未通过校验或患者ID不存在;' where e.VC_HZID not in (select h.VC_PERSONID from zjjk_tnb_hzxx h);
    update zjjk_tnb_bgk_ex e set e.validate_detail=e.validate_detail||'审核标志错误;' where checkdic('C_COMM_SHZT',e.vc_shbz)=0 and e.vc_shbz is not null ;
    update zjjk_tnb_bgk_ex e set e.validate_detail=e.validate_detail || '重复上报;' where exists(select 1 from zjjk.zjjk_tnb_bgk g where e.vc_yyrid=g.vc_bgkid or e.vc_hzid=g.vc_hzid);
    commit;

    --设置校验标志 1-通过 2-不通过
    update zjjk_tnb_bgk_ex e set e.is_pass='2' where e.is_pass='0' and trim(e.validate_detail) is not null;
    update zjjk_tnb_bgk_ex e set e.is_pass='1' where e.is_pass='0' and trim(e.validate_detail) is null;
     commit;

      for e in bgk_cur loop
      --select hz.vc_hkjd,hz.vc_hkshen into temp_hkjddm,temp_hksfdm from zjjk_tnb_hzxx hz where e.vc_hzid=hz.VC_PERSONID;
      --getgldw(temp_hkjddm,temp_hksfdm)
      select hz.vc_hkqx into temp_hkqxdm from zjjk_tnb_hzxx hz where e.vc_hzid=hz.VC_PERSONID;
      --dbms_output.put_line(e.vc_yyrid);
      insert into zjjk.zjjk_tnb_bgk
     (vc_bgkid, vc_bgklx, vc_hzid, vc_icd10, vc_tnblx, vc_wxys, vc_wxystz,
      vc_wxyssg, vc_tnbs, vc_jzsrs, vc_ywbfz, vc_zslcbx, vc_zslcbxqt, nb_kfxtz,
      nb_sjxtz, nb_xjptt, nb_zdgc, nb_e4hdlc, nb_e5ldlc, nb_gysz, nb_nwldb,
      nbthxhdb, vc_bszyqt, dt_sczdrq, vc_zddw, vc_bgdw, vc_bks, vc_bkq, vc_bgys, dt_bgrq,
      vc_sfsw, dt_swrq, vc_swyy, vc_swicd10, vc_swicdmc, vc_bszy, vc_scbz,
      vc_ccid, vc_ckbz, vc_sfbb, vc_sdqrzt, dt_qrsj, vc_sdqrid, dt_cjsj,
      vc_cjdw, dt_xgsj, vc_xgdw, vc_gldw, vc_shbz, vc_zyh, vc_mzh, vc_qybz,
      vc_wtzt, vc_bgkzt,
      vc_sznl,
      vc_bksznl,
      vc_bgkcode)
      values
     (e.vc_yyrid, '1',e.vc_hzid, e.vc_icd10, e.vc_tnblx, e.vc_wxys, e.vc_wxystz,
     e.vc_wxyssg, e.vc_tnbs, e.vc_jzsrs, e.vc_ywbfz, e.vc_zslcbx, e.vc_zslcbxqt, e.nb_kfxtz,
     e.nb_sjxtz, e.nb_xjptt, e.nb_zdgc, e.nb_e4hdlc, e.nb_e5ldlc, e.nb_gysz, e.nb_nwldb,
     e.nbthxhdb, e.vc_bszyqt, e.dt_sczdrq, e.vc_zddw, e.vc_bgdw,substr(e.vc_bgdw,1,4)||'0000',substr(e.vc_bgdw,1,6)||'00', e.vc_bgys, e.dt_bgrq,
     '',      e.dt_swrq, e.vc_swyy, e.vc_swicd10, e.vc_swicdmc,      '',     '0',
     '',      '',      '',       '1',      '',        '', sysdate,
     e.VC_BGDW,      '',      '',     temp_hkqxdm,   e.vc_shbz , e.vc_zyh, e.vc_mzh,     '0',
         '0',   '0'   ,
     getage((select x.dt_hzcsrq from zjjk_tnb_hzxx x where x.vc_personid = e.vc_hzid)),
     getage((select x.dt_hzcsrq from zjjk_tnb_hzxx x where x.vc_personid = e.vc_hzid)),
     zjjk.get_lsh('ex'||to_char(sysdate,'yy'),'zjjk.zjjk_tnb_bgk','zjjk_tnb_bgk.vc_bgkcode'));
     v_bgkid:=e.vc_yyrid;
     v_bgkmc:='inserttnbbgk';
      end loop;
      commit;

    insert into zjjk.zjjk_tnb_bgk_ex_bak
          (uuid, vc_yyrid, vc_icd10, vc_tnblx, vc_wxys, vc_wxystz, vc_wxyssg, vc_tnbs, vc_jzsrs, vc_ywbfz, vc_zslcbx, vc_zslcbxqt, nb_kfxtz, nb_sjxtz, nb_xjptt, nb_zdgc, nb_e4hdlc, nb_e5ldlc, nb_gysz, nb_nwldb, nbthxhdb, vc_bszyqt, dt_sczdrq, vc_zddw, vc_bgdw, vc_bgys, dt_bgrq, dt_swrq, vc_swyy, vc_swicd10, vc_swicdmc, vc_hzid, vc_zyh, vc_mzh, vc_shbz, is_pass, validate_detail, validate_date)
    select sys_guid(), vc_yyrid, vc_icd10, vc_tnblx, vc_wxys, vc_wxystz, vc_wxyssg, vc_tnbs, vc_jzsrs, vc_ywbfz, vc_zslcbx, vc_zslcbxqt, nb_kfxtz, nb_sjxtz, nb_xjptt, nb_zdgc, nb_e4hdlc, nb_e5ldlc, nb_gysz, nb_nwldb, nbthxhdb, vc_bszyqt, dt_sczdrq, vc_zddw, vc_bgdw, vc_bgys, dt_bgrq, dt_swrq, vc_swyy, vc_swicd10, vc_swicdmc, vc_hzid, vc_zyh, vc_mzh, vc_shbz, is_pass, validate_detail, sysdate
    from zjjk_tnb_bgk_ex ex where ex.is_pass is not null;
    v_bgkmc:='inserttnbbgkexbak';
     commit;



    --清空
  delete from zjjk.zjjk_tnb_hzxx_ex ex where ex.is_pass is not null;
  delete from zjjk.zjjk_tnb_bgk_ex ex where ex.is_pass is not null;


    commit;

     Exception
   WHEN OTHERS Then
    v_sqlerrm := (Sqlerrm || chr(10) || dbms_utility.format_error_backtrace);
    Insert Into VALIDATEEX_ERRLOG
    Values
      (v_bgkmc,
       v_bgkid,
       v_sqlerrm,
       sysdate);

  end;
