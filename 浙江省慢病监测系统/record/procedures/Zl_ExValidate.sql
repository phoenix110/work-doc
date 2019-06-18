CREATE OR REPLACE Procedure Zl_ExValidate as
  temp_hkqxdm VARCHAR2(60);
  v_bgkmc varchar(60);
  v_bgkid varchar(60);
  v_sqlerrm varchar(4000);
  cursor bgk_cur is select * from zjjk.zjjk_zl_bgk_ex ex
  where ex.is_pass='1';-- and not exists(select 1 from zjjk.zjjk_zl_bgk g where ex.vc_yyrid=g.vc_bgkid);


  begin

       /**患者信息**/
      begin

      update zjjk.zjjk_zl_hzxx_ex ex set ex.is_pass='99',ex.validate_date=sysdate,ex.validate_detail='' where ex.is_pass is null;

      update zjjk.zjjk_zl_hzxx_ex ex set ex.validate_detail=ex.validate_detail||'患者ID为空;'
      where trim(ex.vc_personid) is null and ex.is_pass='99';

      update zjjk.zjjk_zl_hzxx_ex ex set ex.validate_detail=ex.validate_detail||'患者ID长度不得小于15位;'
      where length(ex.vc_personid)<15 and ex.is_pass='99';

      update zjjk.zjjk_zl_hzxx_ex ex set ex.validate_detail=ex.validate_detail||'患者姓名为空'||';'
      where ex.vc_hzxm is null and ex.is_pass='99';

      update zjjk.zjjk_zl_hzxx_ex ex set ex.validate_detail=ex.validate_detail||'患者性别为空'||';'
      where ex.vc_hzxb is null and ex.is_pass='99';

      update zjjk.zjjk_zl_hzxx_ex ex set ex.validate_detail=ex.validate_detail||'患者性别代码错误'||';'
      where ex.vc_hzxb is not null and checkdic('C_COMM_XB',ex.vc_hzxb)=0 and ex.is_pass='99';

      update zjjk.zjjk_zl_hzxx_ex ex set ex.validate_detail=ex.validate_detail||'民族为空'||';'
      where ex.vc_hzmz is null and ex.is_pass='99';

      update zjjk.zjjk_zl_hzxx_ex ex set ex.validate_detail=ex.validate_detail||'民族代码错误'||';'
      where ex.vc_hzmz is not null and checkdic('C_COMM_MZ',ex.vc_hzmz)=0 and ex.is_pass='99';

      update zjjk.zjjk_zl_hzxx_ex ex set ex.validate_detail=ex.validate_detail||'患者出生日期为空'||';'
      where ex.dt_hzcsrq is null and ex.is_pass='99';

      update zjjk.zjjk_zl_hzxx_ex ex set ex.validate_detail=ex.validate_detail||'家庭电话为空'||';'
      where ex.vc_jtdh is null and ex.is_pass='99';

      update zjjk.zjjk_zl_hzxx_ex ex set ex.validate_detail=ex.validate_detail||'职业代码为空'||';'
      where ex.vc_zydm is null and ex.is_pass='99';

      update zjjk.zjjk_zl_hzxx_ex ex set ex.validate_detail=ex.validate_detail||'职业代码错误'||';'
      where ex.vc_zydm is not null and checkdic('C_COMM_HY',ex.vc_zydm)=0 and ex.is_pass='99';

      update zjjk.zjjk_zl_hzxx_ex ex set ex.validate_detail=ex.validate_detail||'具体工种为空'||';'
      where ex.vc_jtgz is null and ex.is_pass='99';

      update zjjk.zjjk_zl_hzxx_ex ex set ex.validate_detail=ex.validate_detail||'具体工种代码错误'||';'
      where ex.vc_jtgz is not null and checkdic('C_COMM_ZY',ex.vc_jtgz)=0 and ex.is_pass='99';

      update zjjk.zjjk_zl_hzxx_ex ex set ex.validate_detail=ex.validate_detail||'户口省份代码为空'||';'
      where ex.vc_hksfdm is null and ex.is_pass='99';

      update zjjk.zjjk_zl_hzxx_ex ex set ex.validate_detail=ex.validate_detail||'户口省份代码错误'||';'
      where ex.vc_hksfdm is not null and checkdic('C_COMM_SHEDM',ex.vc_hksfdm)=0 and ex.is_pass='99';

      update zjjk.zjjk_zl_hzxx_ex ex set ex.validate_detail=ex.validate_detail||'户口市级代码为空'||';'
      where ex.vc_hksdm is null and ex.is_pass='99';

      update zjjk.zjjk_zl_hzxx_ex ex set ex.validate_detail=ex.validate_detail||'户口市级代码错误'||';'
      where ex.vc_hksdm is not null and checkdic('C_COMM_SJDM',ex.vc_hksdm)=0 and ex.is_pass='99';

      update zjjk.zjjk_zl_hzxx_ex ex set ex.validate_detail=ex.validate_detail||'户口区县代码为空'||';'
      where ex.vc_hkqxdm is null and ex.is_pass='99';

      update zjjk.zjjk_zl_hzxx_ex ex set ex.validate_detail=ex.validate_detail||'户口区县代码错误'||';'
      where ex.vc_hkqxdm is not null and checkdic('C_COMM_QXDM',ex.vc_hkqxdm)=0 and ex.is_pass='99';

      update zjjk.zjjk_zl_hzxx_ex ex set ex.validate_detail=ex.validate_detail||'市代码与区县代码不匹配'||';'
      where  substr(ex.vc_hksdm, 1, 4) <> substr(ex.vc_hkqxdm, 1, 4) and ex.is_pass='99';

      update zjjk.zjjk_zl_hzxx_ex ex set ex.validate_detail=ex.validate_detail||'户口街道代码错误'||';'
      where ex.vc_hkjddm is not null and checkdic('C_COMM_JDDM',ex.vc_hkjddm)=0 and ex.is_pass='99';

      update zjjk.zjjk_zl_hzxx_ex ex set ex.validate_detail=ex.validate_detail||'户口详细地址为空'||';'
      where ex.vc_hkxxdz is null and ex.is_pass='99';

      update zjjk.zjjk_zl_hzxx_ex ex set ex.validate_detail=ex.validate_detail||'实际居住省份代码为空'||';'
      where ex.vc_sjsfdm is null and ex.is_pass='99';

      update zjjk.zjjk_zl_hzxx_ex ex set ex.validate_detail=ex.validate_detail||'实际居住省份代码错误'||';'
      where ex.vc_sjsfdm is not null and checkdic('C_COMM_SHEDM',ex.vc_sjsfdm)=0 and ex.is_pass='99';

      update zjjk.zjjk_zl_hzxx_ex ex set ex.validate_detail=ex.validate_detail||'实际市级代码为空'||';'
      where ex.vc_sjsfdm='0' and ex.vc_sjsdm is null and ex.is_pass='99';

      update zjjk.zjjk_zl_hzxx_ex ex set ex.validate_detail=ex.validate_detail||'实际市级代码错误'||';'
      where ex.vc_sjsdm is not null and checkdic('C_COMM_SJDM',ex.vc_sjsdm)=0 and ex.is_pass='99';

      update zjjk.zjjk_zl_hzxx_ex ex set ex.validate_detail=ex.validate_detail||'实际区县代码为空'||';'
      where ex.vc_sjsfdm='0' and ex.vc_sjqxdm is null and ex.is_pass='99';

      update zjjk.zjjk_zl_hzxx_ex ex set ex.validate_detail=ex.validate_detail||'实际区县代码错误'||';'
      where ex.vc_sjqxdm is not null and checkdic('C_COMM_QXDM',ex.vc_sjqxdm)=0 and ex.is_pass='99';

      update zjjk.zjjk_zl_hzxx_ex ex set ex.validate_detail=ex.validate_detail||'实际居住街道代码错误'||';'
      where ex.vc_sjjddm is not null and checkdic('C_COMM_JDDM',ex.vc_sjjddm)=0 and ex.is_pass='99';

      -- update zjjk.zjjk_zl_hzxx_ex ex set ex.validate_detail=ex.validate_detail||'实际居住详细地址为空'||';'
      -- where ex.vc_sjxxdz is null and ex.is_pass='99';
      update zjjk_zl_hzxx_ex ex set ex.validate_detail=ex.validate_detail||'重复上报;'
      where exists(select 1 from zjjk_zl_hzxx h where ex.VC_PERSONID=h.VC_PERSONID) and ex.is_pass='99';

      update zjjk.zjjk_zl_hzxx_ex ex set ex.is_pass=decode(ex.validate_detail,null,'1','2') where ex.is_pass='99';
      commit;

      insert into zjjk.zjjk_zl_hzxx
        (vc_personid, vc_hzxm, vc_hzxb, vc_hzmz, dt_hzcsrq, vc_sfzh, vc_jtdh, vc_gzdw, vc_zydm, vc_jtgz, vc_hksfdm, vc_hksdm, vc_hkjddm, vc_hkqxdm, vc_hkjwdm, vc_hkxxdz, vc_sjsfdm, vc_sjsdm, vc_sjqxdm, vc_sjjddm, vc_sjjwdm, vc_sjxxdz)
      select vc_personid, vc_hzxm, vc_hzxb, vc_hzmz, dt_hzcsrq, trim(vc_sfzh), vc_jtdh, vc_gzdw, vc_zydm, vc_jtgz, vc_hksfdm, vc_hksdm, vc_hkjddm, vc_hkqxdm, vc_hkjwdm, vc_hkxxdz, vc_sjsfdm, vc_sjsdm, vc_sjqxdm, vc_sjjddm, vc_sjjwdm, VC_SJXXDZ
      from zjjk.zjjk_zl_hzxx_ex ex where ex.is_pass='1' and not exists(select 1 from zjjk.zjjk_zl_hzxx g where ex.vc_personid=g.vc_personid);
      v_bgkmc:='insertzlhzxx';
      commit;

      insert into zjjk.zjjk_zl_hzxx_ex_bak
        (uuid, vc_personid, vc_hzxm, vc_hzxb, vc_hzmz, dt_hzcsrq, vc_sfzh, vc_jtdh, vc_zydm, vc_gzdw, vc_jtgz, vc_hksfdm, vc_hksdm, vc_hkqxdm, vc_hkjddm, vc_hkjwdm, vc_hkxxdz, vc_sjsfdm, vc_sjsdm, vc_sjqxdm, vc_sjjddm, vc_sjjwdm, is_pass, validate_detail, validate_date,VC_SJXXDZ)
      select sys_guid(), vc_personid, vc_hzxm, vc_hzxb, vc_hzmz, dt_hzcsrq, trim(vc_sfzh), vc_jtdh, vc_zydm, vc_gzdw, vc_jtgz, vc_hksfdm, vc_hksdm, vc_hkqxdm, vc_hkjddm, vc_hkjwdm, vc_hkxxdz, vc_sjsfdm, vc_sjsdm, vc_sjqxdm, vc_sjjddm, vc_sjjwdm, is_pass, validate_detail, validate_date,VC_SJXXDZ
      from zjjk.zjjk_zl_hzxx_ex ex where ex.is_pass is not null;
      v_bgkmc:='insertzlhzxxexbak';
      delete from zjjk.zjjk_zl_hzxx_ex ex where ex.is_pass is not null;
      commit;
      end;

      /**报告卡**/
      begin
      --校验
      update zjjk.zjjk_zl_bgk_ex ex set ex.is_pass='99',ex.validate_date=sysdate,ex.validate_detail='' where ex.is_pass is null;

      update zjjk.zjjk_zl_bgk_ex ex set ex.validate_detail=ex.validate_detail||'医院唯一标识长度不得小于15位'||';'
      where length(ex.vc_yyrid)<15 and ex.is_pass='99';

      update zjjk.zjjk_zl_bgk_ex ex set ex.validate_detail=ex.validate_detail||'病情已告知病人为空'||';'
      where ex.vc_bqygzbr is null and ex.is_pass='99';

      update zjjk.zjjk_zl_bgk_ex ex set ex.validate_detail=ex.validate_detail||'病情已告知病人代码错误'||';'
      where ex.vc_bqygzbr is not null and checkdic('C_ZL_BQSFGZBR',ex.vc_bqygzbr)=0 and ex.is_pass='99';

      update zjjk.zjjk_zl_bgk_ex ex set ex.validate_detail=ex.validate_detail||'门诊号和住院号为空'||';'
      where ex.vc_mzh is null and ex.vc_zyh is null and ex.is_pass='99';

      update zjjk.zjjk_zl_bgk_ex ex set ex.validate_detail=ex.validate_detail||'对应患者信息未通过校验或患者ID不存在'||';'
      where not exists(select 1 from zjjk_zl_hzxx hz where ex.vc_hzid=hz.VC_PERSONID) and ex.is_pass='99';

      update zjjk.zjjk_zl_bgk_ex ex set ex.validate_detail=ex.validate_detail||'患者ID长度不得小于15位'||';'
      where length(ex.vc_hzid)<15 and ex.is_pass='99';

      update zjjk.zjjk_zl_bgk_ex ex set ex.validate_detail=ex.validate_detail||'ICDOM第一级代码错误'||';'
      where ex.vc_icdm is not null and checkdic('C_COMM_ICDM',ex.vc_icdm)=0 and ex.is_pass='99';

      update zjjk.zjjk_zl_bgk_ex ex set ex.validate_detail=ex.validate_detail||'ICDO诊断部位代码错误'||';'
      where ex.vc_icdo is not null and checkdic('C_COMM_ICDO',ex.vc_icdo)=0 and ex.is_pass='99';

      update zjjk.zjjk_zl_bgk_ex ex set ex.validate_detail=ex.validate_detail||'第六位代码错误'||';'
      where ex.vc_dlw is not null and checkdic('C_COMM_DLW',ex.vc_dlw)=0 and ex.is_pass='99';

      update zjjk.zjjk_zl_bgk_ex ex set ex.validate_detail=ex.validate_detail||'诊断部位为空'||';'
      where ex.vc_zdbw is null and ex.is_pass='99';

      update zjjk.zjjk_zl_bgk_ex ex set ex.validate_detail=ex.validate_detail||'诊断部位代码错误'||';'
      where ex.vc_zdbw is not null and checkdic('C_COMM_ICD10',ex.vc_zdbw)=0 and ex.is_pass='99';

      update zjjk.zjjk_zl_bgk_ex ex set ex.validate_detail=ex.validate_detail||'病理学类型为空'||';'
      where ex.vc_blxlx is null and (ex.vc_zdyh like '%6%' or ex.vc_zdyh like '%7%' or ex.vc_zdyh like '%8%') and ex.is_pass='99';

      ---update zjjk.zjjk_zl_bgk_ex ex set ex.validate_detail=ex.validate_detail||'病理号为空'||';'
      ---where ex.vc_blh is null and (ex.vc_zdyh like '%6%' or ex.vc_zdyh like '%7%' or ex.vc_zdyh like '%8%') and ex.is_pass='99';

      update zjjk.zjjk_zl_bgk_ex ex set ex.validate_detail=ex.validate_detail||'首次诊断日期为空'||';'
      where ex.dt_zdrq is null and ex.is_pass='99';

      update zjjk.zjjk_zl_bgk_ex ex set ex.validate_detail=ex.validate_detail||'最高诊断单位为空'||';'
      where ex.vc_zgzddw is null and ex.is_pass='99';

      update zjjk.zjjk_zl_bgk_ex ex set ex.validate_detail=ex.validate_detail||'最高诊断单位代码错误'||';'
      where ex.vc_zgzddw is not null and checkdic('C_ZL_ZGZDDW',ex.vc_zgzddw)=0 and ex.is_pass='99';

      update zjjk.zjjk_zl_bgk_ex ex set ex.validate_detail=ex.validate_detail||'报卡单位为空'||';'
      where ex.vc_bgdw is null and ex.is_pass='99';

      update zjjk.zjjk_zl_bgk_ex ex set ex.validate_detail=ex.validate_detail||'报卡单位代码错误'||';'
      where ex.vc_bgdw is not null and checkdic('C_COMM_YYDM',ex.vc_bgdw)=0 and  ex.is_pass='99';


      update zjjk.zjjk_zl_bgk_ex ex set ex.validate_detail=ex.validate_detail||'报告医生为空'||';'
      where ex.vc_bgys is null and ex.is_pass='99';

      update zjjk.zjjk_zl_bgk_ex ex set ex.validate_detail=ex.validate_detail||'报告日期为空'||';'
      where ex.dt_bgrq is null and ex.is_pass='99';

      update zjjk.zjjk_zl_bgk_ex ex set ex.validate_detail=ex.validate_detail||'死亡日期小于诊断日期'||';'
      where ex.dt_swrq is not null and ex.dt_swrq-ex.dt_zdrq<0 and ex.is_pass='99';

      update zjjk.zjjk_zl_bgk_ex ex set ex.validate_detail=ex.validate_detail||'死亡原因为空'||';'
      where ex.dt_swrq is not null and ex.vc_swyy is null and ex.is_pass='99';

      update zjjk.zjjk_zl_bgk_ex ex set ex.validate_detail=ex.validate_detail||'死亡原因代码错误'||';'
      where ex.dt_swrq is not null and ex.vc_swyy is not null and checkdic('C_ZL_SWYYDM',ex.vc_swyy)=0 and ex.is_pass='99';

      update zjjk.zjjk_zl_bgk_ex ex set ex.validate_detail=ex.validate_detail||'死亡ICD10为空'||';'
      where ex.dt_swrq is not null and ex.vc_swicd10 is null and ex.is_pass='99';

 --     update zjjk.zjjk_zl_bgk_ex ex set ex.validate_detail=ex.validate_detail||'死亡ICD10代码错误'||';'
 --     where ex.dt_swrq is not null and ex.vc_swicd10 is not null and checkdic('C_COMM_ICD10',ex.vc_swicd10)=0 and ex.is_pass='99';

      update zjjk.zjjk_zl_bgk_ex ex set ex.validate_detail=ex.validate_detail||'诊断依据为空'||';'
      where ex.vc_zdyh is null and ex.is_pass='99';

      update zjjk.zjjk_zl_bgk_ex ex set ex.validate_detail=ex.validate_detail||'诊断依据代码错误'||';'
      where ex.vc_zdyh is not null and checkdic_multi('C_ZL_ZDYJDM',ex.vc_zdyh)=0 and ex.is_pass='99';

      update zjjk.zjjk_zl_bgk_ex ex set ex.validate_detail=ex.validate_detail||'死亡具体原因为空'||';'
      where ex.dt_swrq is not null and ex.vc_swicdmc is null and ex.is_pass='99';

      update zjjk.zjjk_zl_bgk_ex ex set ex.validate_detail=ex.validate_detail||'审核标志为空'||';'
      where ex.vc_shbz is null and ex.is_pass='99';

      update zjjk.zjjk_zl_bgk_ex ex set ex.validate_detail=ex.validate_detail||'审核标志代码错误'||';'
      where ex.vc_shbz is not null and ex.vc_shbz not in ('0','1','2') and ex.is_pass='99';

      update zjjk_zl_bgk_ex ex set ex.validate_detail=ex.validate_detail||'重复上报;'
      where exists(select 1 from zjjk_zl_bgk g where ex.vc_yyrid=g.vc_lszy or ex.vc_hzid=g.vc_hzid) and ex.is_pass='99';

      update zjjk.zjjk_zl_bgk_ex ex set ex.is_pass=decode(ex.validate_detail,null,'1','2') where ex.is_pass='99';
      commit;


      --通过数据入业务表
      for e in bgk_cur loop
      --select hz.vc_hkjddm,hz.vc_hksfdm into temp_hkjddm,temp_hksfdm from zjjk_zl_hzxx hz where e.vc_hzid=hz.VC_PERSONID;
      select hz.vc_hkqxdm into temp_hkqxdm from zjjk_zl_hzxx hz where e.vc_hzid=hz.VC_PERSONID;
      insert into zjjk.zjjk_zl_bgk
      (
      vc_bgklx,
      vc_cjdw,
      vc_gldw,
      vc_lszy,
      vc_bgkid,vc_sznl,vc_bksznl,
      vc_wtzt,vc_sfcf,vc_bgkzt,vc_sdqrzt,vc_scbz, vc_bqygzbr,
      vc_mzh, vc_zyh, vc_hzid, vc_icd9, vc_icdm, vc_icdo, vc_dlw ,
      vc_icd10, vc_blxlx, vc_blh, vc_zdsqb, vc_zdqbt, vc_zdqbn, vc_zdqbm, dt_yzdrq, vc_zdbw, vc_zdbwmc,
      --vc_icd10 与 vc_swicd10 注意原表和新表关系
      dt_zdrq, vc_zgzddw, vc_yzd, vc_bgdw, vc_bgdws, vc_bgdwqx, vc_bgys, dt_bgrq, dt_swrq, vc_swyy, vc_swicd10, vc_zdyh, vc_bszy, vc_swicdmc, vc_shbz,DT_CJSJ, vc_sfbyzd)
      values
      (
      '1',
      e.VC_BGDW,
      temp_hkqxdm,
      --e.VC_BGDW,
      --getgldw(temp_hkjddm,temp_hksfdm),
      e.vc_yyrid,
      zjjk.get_lsh('ex'||to_char(sysdate,'yy'),'zjjk.zjjk_zl_bgk','zjjk_zl_bgk.vc_bgkid'),
      getage((select hz.dt_hzcsrq from zjjk_zl_hzxx hz where e.vc_hzid=hz.VC_PERSONID)),
      getage((select hz.dt_hzcsrq from zjjk_zl_hzxx hz where e.vc_hzid=hz.VC_PERSONID)),
      --(select decode(hz.vc_hksfdm,'1','99999999','') from zjjk.zjjk_zl_hzxx hz where hz.VC_PERSONID=e.vc_hzid and rownum=1),
      '0','2',decode(e.dt_swrq,null,'0','7'),'1','0', e.vc_bqygzbr,
      e.vc_mzh, e.vc_zyh, e.vc_hzid, e.vc_icd9, e.vc_icdm, e.vc_icdo, e.vc_dlw ,
      e.vc_zdbw, e.vc_blxlx, e.vc_blh, e.vc_zdsqb, e.vc_zdqbt, e.vc_zdqbn, e.vc_zdqbm, e.dt_yzdrq,e.vc_zdbw, e.vc_zdbmms,
      e.dt_zdrq, e.vc_zgzddw, e.vc_yzd, e.vc_bgdw, substr(e.vc_bgdw,1,4)||'0000', substr(e.vc_bgdw,1,6)||'00', e.vc_bgys, e.dt_bgrq, e.dt_swrq, e.vc_swyy, e.vc_swicd10, e.vc_zdyh, e.vc_bszy, e.vc_swicdmc, e.vc_shbz,sysdate, '1');
      v_bgkid:=e.vc_yyrid;
      v_bgkmc:='insertzlbgk';
      end loop;
      commit;

      --备份
      insert into zjjk.zjjk_zl_bgk_ex_bak
        (uuid, vc_yyrid, vc_bqygzbr, vc_mzh, vc_zyh, vc_hzid, vc_icd9, vc_icdm, vc_icdo, vc_dlw, vc_zdbmms, vc_zdbw, vc_blxlx, vc_blh, vc_zdsqb, vc_zdqbt, vc_zdqbn, vc_zdqbm, dt_yzdrq, dt_zdrq, vc_zgzddw, vc_yzd, vc_bgdw, vc_bgys, dt_bgrq, dt_swrq, vc_swyy, vc_swicd10, vc_zdyh, vc_bszy, vc_swicdmc, vc_shbz, is_pass, validate_detail, validate_date)
      select sys_guid(), vc_yyrid, vc_bqygzbr, vc_mzh, vc_zyh, vc_hzid, vc_icd9, vc_icdm, vc_icdo, vc_dlw, vc_zdbmms, vc_zdbw, vc_blxlx, vc_blh, vc_zdsqb, vc_zdqbt, vc_zdqbn, vc_zdqbm, dt_yzdrq, dt_zdrq, vc_zgzddw, vc_yzd, vc_bgdw, vc_bgys, dt_bgrq, dt_swrq, vc_swyy, vc_swicd10, vc_zdyh, vc_bszy, vc_swicdmc, vc_shbz, is_pass, validate_detail, validate_date
      from zjjk.zjjk_zl_bgk_ex ex where ex.is_pass is not null;
      v_bgkmc:='insertzlbgkexbak';
      delete from zjjk.zjjk_zl_bgk_ex ex where ex.is_pass is not null;
      commit;
      end;

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
