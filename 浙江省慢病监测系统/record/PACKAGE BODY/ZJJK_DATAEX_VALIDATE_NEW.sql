create or replace package body ZJJK_DATAEX_VALIDATE_NEW is
  v_bgkmc varchar(60);
  v_bgkid varchar(60);
  v_sqlerrm varchar(4000);
  --心脑血管
  Procedure Proc_Zjjk_Xnxg_Validate is
  cursor bgk_cur_xn is select * from zjjk.zjjk_xnxg_bgk_ex ex
  where ex.is_pass='1'; -- and not exists(select 1 from zjjk.zjjk_xnxg_bgk g where ex.vc_yyrid=g.vc_bgkid);

  begin

  --delete from zjjk.zjjk_xnxg_bgk_ex_bak;

  --if zjjk.zjjk_xnxg_bgk_ex.vc_yyrid is null
 --------part1

   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '医院唯一标识为空;'
   where trim(ex.vc_yyrid) is null;
   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '医院唯一标识长度不得不得小于15位;'
   where length(ex.vc_yyrid)<15;
   --门诊号和住院号判断
   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '门诊与住院号都为空;'
   where ex.vc_mzh  is null and ex.vc_zyh  is null ;
   commit;
   --患者姓名
   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '患者姓名为空;'
   where ex.vc_hzxm is null;

   --患者性别
   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '患者性别为空;'
   where ex.vc_hzxb is null;
   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '患者性别错误;'
   where checkdic('C_COMM_XB',ex.vc_hzxb)=0  and ex.vc_hzxb is not null;

   --患者婚姻
   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '婚姻状况为空;'
   where ex.vc_hzhy is null;
   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '婚姻状况错误;'
   where checkdic('C_COMM_HYZK',ex.vc_hzhy)=0 and ex.vc_hzhy is not null ;

   --患者ICD编码
   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || 'ICD编码为空;'
   where ex.vc_hzicd is null;
   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || 'ICD编码错误;'
   where checkdic('C_XNXG_ICD10',ex.vc_hzicd)=0  and ex.vc_hzicd is not null;

   --患者出生日期
   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '出生日期为空;'
   where ex.dt_hzcsrq is null ;
   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '出生日期大于发病日期;'
   where ex.dt_hzcsrq > ex.dt_fbrq  and ex.dt_hzcsrq is not null and ex.dt_fbrq is not null;

   --职业
   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '职业为空;'
   where ex.vc_hzzy is null;
   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '职业错误;'
   where checkdic('C_COMM_HY',ex.vc_hzzy)=0  and ex.vc_hzzy is not null;

   --具体工种
   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '工种为空;'
   where ex.vc_jtgz is null;
   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '工种错误;'
   where checkdic('C_COMM_ZY',ex.vc_jtgz)=0 and ex.vc_jtgz is not null;
   commit;
   /*--患者身份证号
   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '身份证与出生日期不符合'
   where to_date(substr(ex.vc_hzsfzh,7,14),'yyyymmdd') != ex.dt_hzcsrq
   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '身份证与性别不符合'
   where
   */

   --患者文化程度
   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '文化程度为空;'
   where ex.vc_hzwhcd is null;
   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '文化程度错误;'
   where checkdic('C_COMM_WHCD',ex.vc_hzwhcd)=0 and ex.vc_hzwhcd is not null;

   --患者民族
   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '患者民族为空;'
   where ex.vc_hzmz is null;
   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '患者民族错误;'
   where checkdic('C_COMM_MZ',ex.vc_hzmz)=0 and ex.vc_hzmz is not null;

   --联系电话
   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '联系电话为空;'
   where ex.vc_hzjtdh is null;

   --常住户口地址省
   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '户口省为空;'
   where ex.vc_czhks is null;
   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '户口省错误;'
   where checkdic('C_COMM_SHEDM',ex.vc_czhks)=0 and ex.vc_czhks is not null;

   --常住户口地址市
   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '户口市为空;'
   where ex.vc_czhksi is null;
   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '户口市错误;'
   where checkdic('C_COMM_SJDM',ex.vc_czhksi)=0 and ex.vc_czhksi is not null;

   --常住户口地址区县
   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '户口县为空;'
   where ex.vc_czhkqx is null;
   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '户口县错误;'
   where checkdic('C_COMM_QXDM',ex.vc_czhkqx)=0 and ex.vc_czhkqx is not null;
   
   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail ||'市代码与区县代码不匹配;'
      where  substr(ex.vc_czhkqx, 1, 4) <> substr(ex.vc_czhksi, 1, 4);
   --常住户口地址街道
   --update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '户口街道为空;'
  -- where ex.vc_czhkjd is null;
   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '户口街道错误;'
   where checkdic('C_COMM_JDDM',ex.vc_czhkjd)=0 and ex.vc_czhkjd is not null;

   --常住户口居委

   --常住户口详细地址
   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '户口地址为空;'
   where ex.vc_czhkxxdz is null;

   --目前居住地址省
   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '居住省为空;'
   where ex.vc_mqjzs is null;
   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '居住省错误;'
   where checkdic('C_COMM_SHEDM',ex.vc_mqjzs)=0 and ex.vc_mqjzs is not null;

   --目前居住地址市
   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '居住市为空;'
   where ex.vc_mqjzs='0' and ex.vc_mqjzsi is null;
   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '居住市错误;'
   where checkdic('C_COMM_SJDM',ex.vc_mqjzsi)=0 and ex.vc_mqjzsi is not null;

   --目前居住地址区县
   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '居住县为空;'
   where ex.vc_mqjzs='0' and ex.vc_mqjzqx is null;
   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '居住县错误;'
   where checkdic('C_COMM_QXDM',ex.vc_mqjzqx)=0 and ex.vc_mqjzqx is not null;

   --目前居住地址街道
   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '居住街道错误;'
   where checkdic('C_COMM_JDDM',ex.vc_mqjzjd)=0  and ex.vc_mqjzjd is not null;

   --目前居住地址居委

   --目前居住详细地址
   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '居住地址为空;'
   where ex.vc_mqxxdz is null ;

   --冠心病、脑卒中二选一必填
   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '冠心病与脑卒诊断中都为空;'
   where ex.vc_gxbzd  is null and ex.vc_nczzd  is null ;

   --冠心病诊断
   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '冠心病诊断错误'
   where  checkdic('C_XNXG_GXBZD',ex.vc_gxbzd)=0 and ex.vc_gxbzd is not null;

   --脑卒中诊断
   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '脑卒中诊断错误'
   where checkdic('C_XNXG_NCZZD',ex.vc_nczzd)=0 and ex.vc_nczzd is not null;

   --临床症状诊断依据
   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '临床症状诊断为空;'
   where ex.vc_lczz is null;
   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '临床症状诊断错误;'
   where checkdic('C_XNXG_ZDYJ',ex.vc_lczz)=0 and ex.vc_lczz is not null;

   --心电图诊断依据
   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '心电图诊断为空;'
   where ex.vc_xdt is null;
   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '心电图诊断错误;'
   where checkdic('C_XNXG_ZDYJ',ex.vc_xdt)=0 and ex.vc_xdt is not null;

   --血清酶诊断依据
   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '血清酶诊断为空;'
   where ex.vc_xqm is null;
   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '血清酶诊断错误;'
   where checkdic('C_XNXG_ZDYJ',ex.vc_xqm)=0 and ex.vc_xqm is not null;
   commit;
   --脑脊液诊断依据
   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '脑脊液状诊断为空;'
   where ex.vc_njy is null;
   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '脑脊液状诊断错误;'
   where checkdic('C_XNXG_ZDYJ',ex.vc_njy)=0 and ex.vc_njy is not null;

   --脑电图诊断依据
   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '脑电图诊断为空;'
   where ex.vc_ndt is null;
   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '脑电图诊断错误;'
   where checkdic('C_XNXG_ZDYJ',ex.vc_ndt)=0 and ex.vc_ndt is not null;

   --血管造影诊断依据
   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '血管造影诊断为空;'
   where ex.vc_xgzy is null;
   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '血管造影诊断错误;'
   where checkdic('C_XNXG_ZDYJ',ex.vc_xgzy)=0 and ex.vc_xgzy is not null;

   --CT诊断依据
   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || 'CT诊断为空;'
   where ex.vc_ct is null;
   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || 'CT诊断错误;'
   where checkdic('C_XNXG_ZDYJ',ex.vc_ct)=0 and ex.vc_ct is not null;

   --磁共振诊断依据
   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '磁共振诊断为空;'
   where ex.vc_ckz is null;
   update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '磁共振诊断错误;'
   where checkdic('C_XNXG_ZDYJ',ex.vc_ckz)=0 and ex.vc_ckz is not null;

  --尸检诊断依据
  --update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '尸检为空;'
  --where ex.vc_sj is null;
  update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '尸检错误;'
  where checkdic('C_XNXG_ZDYJ',ex.vc_sj)=0 and ex.vc_sj is not null;

  --神经科医生检查诊断依
  update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '神经科医生检查诊断为空;'
  where ex.vc_sjkysjc is null;
  update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '神经科医生检查诊断错误;'
  where checkdic('C_XNXG_ZDYJ',ex.vc_sjkysjc)=0 and ex.vc_sjkysjc is not null ;

  --病史
  update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '病史为空;'
  where ex.vc_bs is null;
  update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '病史错误;'
  where checkdic_multi('C_XNXG_BS',ex.vc_bs)=0 and ex.vc_bs is not null;

  --死后推断
  --update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '死后推断为空;'
  --where ex.vc_shtd is null;
  update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '死后推断错误;'
  where checkdic('C_COMM_SF',ex.vc_shtd)=0 and ex.vc_shtd is not null;

  --本次卒中发病时间与CT/核磁共振检查时间间隔
  --update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '本次卒中发病时间与CT/核磁共振检查时间间隔为空;'
  --where ex.vc_cgzsjjg is null;
  update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '本次卒中发病时间与CT/核磁共振检查时间间隔错误;'
  where checkdic_multi('C_XNXG_CGZSJJG',ex.vc_cgzsjjg)=0 and ex.vc_cgzsjjg is not null;

  --发病日期
  update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '发病日期为空;'
  where ex.dt_fbrq is null;

  --出生日期
  update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '出生日期有误;'
  where ex.dt_hzcsrq<to_date('1900-01-01','yyyy-mm-dd') or ex.dt_hzcsrq>to_date('2020-01-01','yyyy-mm-dd');

  --确诊日期
  update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '确诊日期为空;'
  where ex.dt_qzrq is null;
  update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '确诊日期小于发病日期;'
  where ex.dt_qzrq < ex.dt_fbrq and ex.dt_qzrq is not null and ex.dt_fbrq is not null;

  --是否首次发病
  update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '是否首次发病为空;'
  where ex.vc_sfsf is null;
  update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '是否首次发病错误;'
  where checkdic('C_COMM_SF',ex.vc_sfsf)=0 and ex.vc_sfsf is not null;

  --确诊单位
  update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '确诊单位为空;'
  where ex.vc_qzdw is null;
  update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '确诊单位错误;'
  where checkdic('C_ZL_ZGZDDW',ex.vc_qzdw)=0 and ex.vc_qzdw is not null ;

  --报卡单位医院
  update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '报卡单位医院位为空;'
  where ex.vc_bkdwyy is null;
  update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '报卡单位医院位错误;'
  where checkdic('C_COMM_YYDM',ex.vc_bkdwyy)=0 and ex.vc_bkdwyy is not null;

  --报卡医师
  update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '报卡医师为空;'
  where ex.vc_bkys is null;

  --报卡日期
  update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '报卡日期为空;'
  where ex.dt_bkrq is null;
  update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '报卡日期小于确诊日期;'
  where ex.dt_bkrq < ex.dt_qzrq and ex.dt_bkrq is not null and ex.dt_qzrq is not null;

  --死亡日期
  --update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '死亡日期为空;'
  --where ex.dt_swrq is null;
  update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '死亡日期小于发病日期;'
  where ex.dt_swrq < ex.dt_fbrq and ex.dt_swrq is not null and ex.dt_fbrq is not null;

  --死亡原因
  update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '死亡原因为空;'
  where ex.dt_swrq is not null and ex.vc_swys is null;
  update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '死亡原因错误;'
  where checkdic('C_XNXG_SWYX',ex.vc_swys)=0 and ex.vc_swys is not null ;

  --死亡原因ICD
  --update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '死亡原因ICD为空;'
  --where ex.dt_swrq is not null and ex.vc_swysicd is null;
  --update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '死亡原因ICD错误;'
  --where checkdic('C_XNXG_ICD10',ex.vc_swysicd)=0 and ex.vc_swysicd is not null ;

  --死亡具体原因
  --update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '死亡具体原因为空;'
  --where ex.dt_swrq is not null and ex.vc_swysmc is null;

  --新增心脑校验条件
    update zjjk_xnxg_bgk_ex ex set ex.validate_detail=ex.validate_detail||'该疾病存活病例不需上报;'
    where substr(ex.vc_hzicd,1,3) in ('I20','I24','I25')
    and ex.dt_swrq is null;

  --审核标志
  update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '审核标志为空;'
  where ex.vc_shbz is null;
  update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_detail = ex.validate_detail || '审核标志错误;'
  where checkdic('C_COMM_SHZT',ex.vc_shbz)=0 and ex.vc_shbz is not null ;
   commit;
  --校验重复数据
 update zjjk_xnxg_bgk_ex ex set ex.validate_detail=ex.validate_detail || '重复上报;'
 where exists(select 1 from zjjk.zjjk_xnxg_bgk g where ex.vc_yyrid=g.vc_bgkid);

  --设置审核时间
  update zjjk.zjjk_xnxg_bgk_ex ex set ex.validate_date=sysdate;

  --设置审核是否通过
  update zjjk.zjjk_xnxg_bgk_ex ex set ex.is_pass=1
  where ex.validate_detail is null;
  update zjjk.zjjk_xnxg_bgk_ex ex set ex.is_pass=2
  where ex.validate_detail is not null;
  commit;

  --------part2

  for e in bgk_cur_xn loop


  insert into  zjjk.zjjk_xnxg_bgk
  (vc_bgkid, vc_mzh, vc_zyh, vc_bgkbh, vc_bgklx, vc_hzxm,
  vc_hzxb, vc_hzhy, vc_hzicd, dt_hzcsrq, vc_sznl,vc_bksznl,
  vc_hzzy, vc_jtgz, vc_hzsfzh, vc_hzwhcd, vc_hzmz,
  vc_hzjtdh, vc_gzdw, vc_czhks, vc_czhksi, vc_czhkqx,
  vc_czhkjd, vc_czhkjw, vc_czhkxxdz, vc_mqjzs, vc_mqjzsi,

  vc_mqjzqx, vc_mqjzjd, vc_mqjzjw, vc_mqxxdz, vc_gxbzd,
  vc_nczzd, vc_lczz, vc_xdt, vc_xqm, vc_njy,
  vc_ndt, vc_xgzy, vc_ct, vc_ckz, vc_sj,
  vc_sjkysjc, vc_bs, vc_shtd, vc_cgzsjjg, vc_syzz, dt_fbrq,
  dt_qzrq, vc_sfsf, vc_qzdw, vc_bkdw, vc_bkdwyy,vc_bkys,

  dt_bkrq, dt_swrq, vc_swys, vc_scbz, vc_gldwdm, vc_cjdwdm,
  vc_sdqrzt, dt_cjsj, vc_cjyh, vc_swysicd, vc_swysmc, vc_bszy, vc_shbz,
  vc_bkdwqx, vc_sfcf, vc_kzt, vc_sfsw, vc_wtzt)
  values
  (
   e.vc_yyrid,   e.vc_mzh,   e.vc_zyh,zjjk.get_lsh('ex'||to_char(sysdate,'yy'),'zjjk.zjjk_xnxg_bgk','zjjk_xnxg_bgk.vc_bgkbh'), '1',   e.vc_hzxm,
    e.vc_hzxb,   e.vc_hzhy,  e. vc_hzicd,   e.dt_hzcsrq,getage(  e.dt_hzcsrq),getage(  e.dt_hzcsrq),
    e.vc_hzzy,   e.vc_jtgz,   trim(e.vc_hzsfzh),   e.vc_hzwhcd,   e.vc_hzmz,
    e.vc_hzjtdh,   e.vc_gzdw,   e.vc_czhks,   e.vc_czhksi,   e.vc_czhkqx,
    e.vc_czhkjd,   e.vc_czhkjw,   e.vc_czhkxxdz,   e.vc_mqjzs,   e.vc_mqjzsi,

    e.vc_mqjzqx,   e.vc_mqjzjd,   e.vc_mqjzjw,   e.vc_mqxxdz,   e.vc_gxbzd,
    e.vc_nczzd,   e.vc_lczz,   e.vc_xdt,   e.vc_xqm,   e.vc_njy,
    e.vc_ndt,   e.vc_xgzy,   e.vc_ct,   e.vc_ckz,   e.vc_sj,
    e.vc_sjkysjc,   e.vc_bs,   e.vc_shtd,   e.vc_cgzsjjg, e.vc_nzzzyzz,  e.dt_fbrq,
    e.dt_qzrq,   e.vc_sfsf,   e.vc_qzdw, substr(e.vc_bkdwyy,1,4)||'0000' , e.vc_bkdwyy,  e.vc_bkys ,

    e.dt_bkrq,   e.dt_swrq,   e.vc_swys, '2',e.vc_czhkqx ,  e.vc_bkdwyy ,
     '1', sysdate,  e.vc_bkdwyy ,  e.vc_swysicd,   e.vc_swysmc,   e.vc_bszy,   e.vc_shbz,
  substr(e.vc_bkdwyy,1,6)||'00', '2', '0', decode(  e.dt_swrq,null,0,1), '0'
  );--substr(  e.vc_bkdwyy,1,8)
  v_bgkid:=e.vc_yyrid;
  v_bgkmc:='insertxnxgbgk';
  end loop;
   --------part3insert into zjjk_xnxg_bgk_ex
   insert into zjjk.zjjk_xnxg_bgk_ex_bak
     (uuid, vc_yyrid, vc_mzh, vc_zyh, vc_hzxm, vc_hzxb, vc_hzhy, vc_hzicd, dt_hzcsrq, vc_hzzy, vc_jtgz, vc_hzsfzh, vc_hzwhcd, vc_hzmz, vc_hzjtdh, vc_gzdw, vc_czhks, vc_czhksi, vc_czhkqx, vc_czhkjd, vc_czhkjw, vc_czhkxxdz, vc_mqjzs, vc_mqjzsi, vc_mqjzqx, vc_mqjzjd, vc_mqjzjw, vc_mqxxdz, vc_gxbzd, vc_nczzd, vc_lczz, vc_xdt, vc_xqm, vc_njy, vc_ndt, vc_xgzy, vc_ct, vc_ckz, vc_sj, vc_sjkysjc, vc_bs, vc_shtd, vc_cgzsjjg, vc_nzzzyzz,dt_fbrq, dt_qzrq, vc_sfsf, vc_qzdw, vc_bkdwyy, vc_bkys, dt_bkrq, dt_swrq, vc_swys, vc_swysicd, vc_swysmc, vc_bszy, vc_shbz, is_pass, validate_detail, validate_date)
   select
      sys_guid(), vc_yyrid, vc_mzh, vc_zyh, vc_hzxm, vc_hzxb, vc_hzhy, vc_hzicd, dt_hzcsrq, vc_hzzy, vc_jtgz, trim(vc_hzsfzh), vc_hzwhcd, vc_hzmz, vc_hzjtdh, vc_gzdw, vc_czhks, vc_czhksi, vc_czhkqx, vc_czhkjd, vc_czhkjw, vc_czhkxxdz, vc_mqjzs, vc_mqjzsi, vc_mqjzqx, vc_mqjzjd, vc_mqjzjw, vc_mqxxdz, vc_gxbzd, vc_nczzd, vc_lczz, vc_xdt, vc_xqm, vc_njy, vc_ndt, vc_xgzy, vc_ct, vc_ckz, vc_sj, vc_sjkysjc, vc_bs, vc_shtd, vc_cgzsjjg, vc_nzzzyzz,dt_fbrq, dt_qzrq, vc_sfsf, vc_qzdw, vc_bkdwyy, vc_bkys, dt_bkrq, dt_swrq, vc_swys, vc_swysicd, vc_swysmc, vc_bszy, vc_shbz, is_pass, validate_detail, validate_date
   from zjjk.zjjk_xnxg_bgk_ex;
   v_bgkmc:='insertxnxgexbak';
   delete from zjjk.zjjk_xnxg_bgk_ex;

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

  --伤害监测========================================================================
  Procedure Proc_Zjjk_Shjc_Validate is
  cursor bgk_cur_sh is select * from zjjk.zjjk_shjc_bgk_ex ex
  where ex.is_pass='1';  --and not exists(select 1 from zjjk.zjmb_shjc_bgk g where ex.vc_yyrid=g.vc_id);
  begin

      --VC_YYRID  医院唯一标识    必填  GUID  VARCHAR2(50)  医院唯一标识用于医院回溯错误记录
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '医院唯一标识为空;'
      where ex.VC_YYRID  is null;

      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '医院唯一标识不正确;'
      where length(ex.VC_YYRID)<18;

      --DT_YYTJRQ  医院记录生成日期    必填    DATETIME  开发商将其默认为卡片录入时的系统当前时间
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '医院记录生成日期为空;'
      where ex.DT_YYTJRQ  is null;

      --VC_JKDW  监测医院  本院登录《浙江省慢性病监测信息管理系统》用户代码  必填    VARCHAR2(20)  由省中心慢病所统一分配
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '监测医院为空;'
      where ex.VC_JKDW  is null;

      --VC_XM  姓名    必填    VARCHAR2(20)  接口校验必填
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '姓名为空;'
      where ex.VC_XM  is null;

      --VC_XB  性别  1男；2女  必填    VARCHAR2(1)  接口校验必填
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '患者性别为空;'
      where ex.VC_XB is null;
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '患者性别错误;'
      where checkdic('C_COMM_XB',ex.VC_XB)=0  and ex.VC_XB is not null;

      --VC_NL  年龄（周岁）    必填    VARCHAR2(20)  接口校验必填
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '年龄为空;'
      where ex.VC_NL is null;

      --VC_DH  联系电话    选填    VARCHAR2(40)  接口校验参见特别说明
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '联系电话为空;'
      where ex.VC_DH is null;

      --DT_SHRQ  受伤日期    必填    DATETIME  校验日期格式
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '受伤日期为空;'
      where ex.DT_SHRQ is null ;

      --DT_JZRQ  就诊日期    必填    DATETIME  校验日期格式（不能小于受伤日期）
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '就诊日期为空;'
      where ex.DT_JZRQ is null ;
      ---update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '受伤日期大于就诊日期;'
      ---where ex.DT_SHRQ > ex.DT_JZRQ  and ex.DT_JZRQ is not null and ex.DT_SHRQ is not null;

      --VC_ZZ  住址    选填    VARCHAR2(200)
      --VC_HJ  户籍  1本辖区居民;2省内外地;3外省;4外籍  必填    VARCHAR2(10)  接口校验代码
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '户籍为空;'
      where ex.VC_HJ is null;
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '户籍代码错误;'
      where checkdic('C_SHJC_HJ',ex.VC_HJ)=0  and ex.VC_HJ is not null;

      --VC_ZY  职业  ID:8   必填    VARCHAR2(2)  接口校验必填
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '职业为空;'
      where ex.VC_ZY is null and ex.VC_NL>9;
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '职业代码错误;'
      where checkdic('DICT_SHJC_ZY',ex.VC_ZY)=0 and ex.VC_ZY is null and ex.VC_NL>9;

      --VC_ZYQT  职业其他  填入   条件必选    VARCHAR2(60)  职业选其他时,该项必填
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '职业其他为空;'
      where ex.vc_zy='11' and ex.VC_ZYQT is null;

      --VC_FSDD  发生地点  ID:20  必填    VARCHAR2(10)  接口校验代码
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '发生地点为空;'
      where ex.VC_FSDD is null;
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '发生地点代码错误;'
      where checkdic('DICT_SHJC_FSDD',ex.VC_FSDD)=0  and ex.VC_FSDD is not null;

      --VC_FSDDQT  发生地点其它    条件必填    VARCHAR2(50)  发生地点选其他时,该项必填 9
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '发生地点其它为空;'
      where ex.VC_FSDD='9' and ex.VC_FSDDQT is null;

      --VC_SHYY  受伤原因  ID:19  必填    VARCHAR2(20)  接口校验代码
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '受伤原因为空;'
      where ex.VC_SHYY is null;
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '受伤原因代码错误;'
      where checkdic('DICT_SHJC_SSYY',ex.VC_SHYY)=0  and ex.VC_SHYY is not null;

      --VC_SHYYQT  受伤原因其它    条件必填    VARCHAR2(50)  受伤原因选其他时,该项必填
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '受伤原因其它其它为空;'
      where ex.VC_SHYY='J' and ex.VC_SHYYQT is null;

      --VC_SHSZSM  受伤时在做什么  ID:21  必填    VARCHAR2(10)  接口校验代码
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '受伤时在做什么为空;'
      where ex.VC_SHSZSM is null;
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '受伤时在做什么代码错误;'
      where checkdic('DICT_SHJC_SSSZZSM',ex.VC_SHSZSM)=0  and ex.VC_SHSZSM is not null;

      --VC_SHSZSMQT  受伤时在做什么其他    条件必填    VARCHAR2(50)  受伤时在做什么选其他时,该项必填
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '受伤时在做什么其他为空;'
      where ex.VC_SHSZSM='6' and ex.VC_SHSZSMQT is null;

      --VC_YZCD  严重程度  ID:22  必填    VARCHAR2(10)  接口校验代码
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '严重程度为空;'
      where ex.VC_YZCD is null;
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '严重程度代码错误;'
      where checkdic('DICT_SHJC_YZCD',ex.VC_YZCD)=0  and ex.VC_YZCD is not null;

      --VC_FSQSFYJ  发生前是否饮酒  0是；1否；2不详  必填    VARCHAR2(10)  接口校验代码
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '发生前是否饮酒为空;'
      where ex.VC_FSQSFYJ is null;
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '发生前是否饮酒码错误;'
      where checkdic('C_SHJC_SFYJ',ex.VC_FSQSFYJ)=0  and ex.VC_FSQSFYJ is not null;

      --VC_BRDDQK  病人抵达情况  0.救护车;1.出租车;2.其他机动车;3.非机动车;4.自己步行;5.其他  必填    VARCHAR2(10)  接口校验代码
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '病人抵达情况为空;'
      where ex.VC_BRDDQK is null;
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '病人抵达情况码错误;'
      where checkdic('DICT_SHJC_BRDDQK',ex.VC_BRDDQK)=0  and ex.VC_BRDDQK is not null;

      --VC_BRDDQKQT  病人抵达情况其它    条件必填    VARCHAR2(50)  病人抵达情况选其他时,该项必填
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '病人抵达情况其它为空;'
      where ex.VC_BRDDQK='5' and ex.VC_BRDDQKQT is null;

      --VC_SFGY  是否故意  0非故意;1自己故意;2他人故意;3不详  必填    VARCHAR2(10)  接口校验代码
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '是否故意为空;'
      where ex.VC_SFGY is null;
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '是否故意码错误;'
      where checkdic('DICT_SHJC_SFGY',ex.VC_SFGY)=0  and ex.VC_SFGY is not null;

      --VC_JJ  结局  0.处理后回家;1.留观;2.住院;3.转送其他医院;4.死亡;5.不详  必填    VARCHAR2(10)  接口校验代码
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '结局为空;'
      where ex.VC_JJ is null;
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '结局码错误;'
      where checkdic('DICT_SHJC_JJ',ex.VC_JJ)=0  and ex.VC_JJ is not null;

      --VC_SFJDC  伤害是否由机动车造成  1是；2否  必填    VARCHAR2(10)  接口校验必填
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '伤害是否由机动车造成为空;'
      where ex.VC_SFJDC is null;
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '伤害是否由机动车造成码错误;'
      where checkdic('C_COMM_SF',ex.VC_SFJDC)=0  and ex.VC_SFJDC is not null;

      --VC_SSZJTGJ  受伤者交通工具  ID:27  条件必填    VARCHAR2(20)  伤害是否由机动车造成VC_SFJDC为1时该项必填
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '受伤者交通工具码错误;'
      where checkdic('DICT_SHJC_SSZDJTGJ',ex.VC_SSZJTGJ)=0  and ex.VC_SFJDC = '1';

      --VC_SSZJTGJQT  受伤者交通工具其它    条件必填    VARCHAR2(50)  受伤者交通工具选其他时,该项必填
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '受伤者交通工具其它为空;'
      where VC_SSZJTGJ='J'  and ex.VC_SSZJTGJQT is null;

      --VC_SSZQK  受伤者情况  ID:28  条件必填    VARCHAR2(10)  伤害是否由机动车造成VC_SFJDC为1时该项必填
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '受伤者情况为空或代码错误;'
      where VC_SFJDC='1'  and checkdic('DICT_SHJC_SSZDQK',ex.VC_SSZQK)=0;

      --VC_SSZQKQT  受伤者情况其它    条件必填    VARCHAR2(50)  伤害是否由机动车造成VC_SSZQK为1时该项必填
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '受伤者情况其它为空;'
      where ex.VC_SSZQK='5' and ex.VC_SSZQKQT is null;

      --VC_SSZHSMFSPZ    受伤者和什么发生碰撞  ID:29  条件必填    VARCHAR2(10)  伤害是否由机动车造成VC_SFJDC为1时该项必填
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '受伤者和什么发生碰撞为空或代码错误;'
      where VC_SFJDC='1'  and checkdic('DICT_SHJC_SSZFSPZ',ex.VC_SSZHSMFSPZ)=0;

      --VC_SSZHSMFSPZQT  受伤者和什么发生碰撞其它    条件必填    VARCHAR2(10)  受伤者和什么发生碰撞选其他时,该项必填
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '受伤者情况其它为空;'
      where ex.VC_SSZHSMFSPZ='6' and ex.VC_SSZHSMFSPZQT is null;

      --VC_CZJDCSSZDWZ  受伤者的位置  1-9整数形式  条件必填    VARCHAR2(10)  受伤者交通工具选5,6,7,8时,该项必填
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '受伤者的位置为空;'
      where ex.VC_SFJDC = '1'
      and (VC_SSZJTGJ='E' or VC_SSZJTGJ='F' or VC_SSZJTGJ='G' or VC_SSZJTGJ='H')
      and ex.VC_CZJDCSSZDWZ is null;

      --VC_ZWYWANQD  座位有无安全带  1是；2否  条件必填    VARCHAR2(10)  受伤者交通工具选5,6,7,8时,该项必填
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '座位有无安全带为空;'
      where ex.VC_SFJDC = '1'
      and (VC_SSZJTGJ='E' or VC_SSZJTGJ='F' or VC_SSZJTGJ='G' or VC_SSZJTGJ='H')
      and ex.VC_ZWYWANQD is null;

      --VC_ANQDSY  安全带使用  1是；2否  条件必填    VARCHAR2(10)  受伤者交通工具选5,6,7,8时,该项必填
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '安全带使用为空;'
      where ex.VC_SFJDC = '1'
      and (VC_SSZJTGJ='E' or VC_SSZJTGJ='F' or VC_SSZJTGJ='G' or VC_SSZJTGJ='H')
      and ex.VC_ANQDSY is null;

      --VC_YWBHZZ  有无保护装置  1是；2否  条件必填    VARCHAR2(10)  受伤者交通工具为3时,该项必填
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '有无保护装置为空;'
      where ex.VC_SFJDC = '1'
      and VC_SSZJTGJ='C'
      and ex.VC_YWBHZZ is null;

      --VC_BHZZSY  保护装置使用  1是；2否  条件必填    VARCHAR2(10)  受伤者交通工具为3时,该项必填
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '保护装置使用为空;'
      where ex.VC_SFJDC = '1'
      and VC_SSZJTGJ='C'
      and ex.VC_BHZZSY is null;

      --VC_ZYXGYS  自伤主要相关因素  ID:33  条件必填    VARCHAR2(20)  VC_SFGY选1自己故意时该项必填
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '自伤主要相关因素;'
      where ex.VC_SFGY = '1' and ex.VC_ZYXGYS is null;

      --VC_ZYXGYSQT  自伤主要相关因素其它    条件必填    VARCHAR2(50)  主要相关因素选其他时,该项必填
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '自伤主要相关因素其它为空;'
      where ex.VC_SFGY = '1' and ex.VC_ZYXGYS='H' and ex.VC_ZYXGYSQT is null;

      --VC_YQZSFSDCS  以前自伤发生的次数    条件必填    VARCHAR2(10)  VC_SFGY选1自己故意时该项必填
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '以前自伤发生的次数为空;'
      where ex.VC_SFGY = '1' and ex.VC_YQZSFSDCS is null;

      --VC_SHQY  他伤-伤害起因  ID:34  条件必填    VARCHAR2(10)  VC_SFGY选2他人故意时该项必填
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '伤害起因为空;'
      where ex.VC_SFGY = '2' and ex.VC_SHQY is null;

      --VC_SHQYQT  他伤-伤害起因其它    条件必填    VARCHAR2(50)  伤害起因选其他时,该项必填
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '他伤-伤害起因其它为空;'
      where ex.VC_SFGY = '2' and ex.VC_ZYXGYS='6' and ex.VC_SHQYQT is null;

      --VC_SSZYSRG   他伤-受伤者与伤人者之间的关系  ID:35  条件必填    VARCHAR2(10)  VC_SFGY选2他人故意时该项必填
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '受伤者与伤人者之间的关系为空;'
      where ex.VC_SFGY = '2' and ex.VC_SSZYSRG is null;

      --VC_SSZYSRGXQT  他伤-受伤者与伤人者之间的关系其它    条件必填    VARCHAR2(50)  受伤者与伤人者之间的关系选其他时,该项必填
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '受伤者与伤人者之间的关系其它为空;'
      where ex.VC_SFGY = '2' and ex.VC_SSZYSRG='6' and ex.VC_SSZYSRGXQT is null;

      --VC_SYGJ  他伤-使用工具  ID:36  条件必填    VARCHAR2(20)  VC_SFGY选2他人故意时该项必填
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '使用工具为空;'
      where ex.VC_SFGY = '2' and ex.VC_SYGJ is null;

      --VC_SYGJQT  他伤-使用工具其它    条件必填    VARCHAR2(50)  使用工具选其他时,该项必填
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '使用工具其它为空;'
      where ex.VC_SFGY = '2' and ex.VC_SYGJ='F' and ex.VC_SYGJQT is null;

      --VC_SHXZ1  伤害性质最严重  ID:37  必填    VARCHAR2(10)  接口校验必填
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '伤害性质最严重为空;'
      where ex.VC_SHXZ1 is null;

--VC_SHXZ2  伤害性质第二  ID:37  选填    VARCHAR2(10)  接口校验必填
--VC_SHXZ3  伤害性质第三  ID:37  选填    VARCHAR2(10)  接口校验必填

      --VC_SSBW1  受伤部位最严重  ID:38  必填    VARCHAR2(10)  接口校验必填
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '受伤部位最严重为空;'
      where ex.VC_SSBW1 is null;

--VC_SSBW2  受伤部位第二  ID:38  选填    VARCHAR2(10)  接口校验必填
--VC_SSBW3  受伤部位第三  ID:38  选填    VARCHAR2(10)  接口校验必填
--VC_SJZY  事件摘要    选填    VARCHAR2(200)
--VC_SHWBYY  伤害外部原因编码    选填    VARCHAR2(10)

      --VC_HZJZKB  患者就诊科别  0.急诊室;1.内科;2.外科;3.眼科/五官科;4.骨科;5.其他  必填    VARCHAR2(10)  接口校验代码
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '患者就诊科别为空;'
      where ex.VC_HZJZKB is null;
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '患者就诊科别码错误;'
      where checkdic('DICT_SHJC_HZJZKB',ex.VC_HZJZKB)=0  and ex.VC_HZJZKB is not null;

      --VC_HZJZKBQT  患者就诊科别其他    条件必填    VARCHAR2(50)  患者就诊科别选其他时,该项必填
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '患者就诊科别其他其它为空;'
      where ex.VC_HZJZKB = '5' and ex.VC_HZJZKBQT is null;

      --VC_TXYSHS  填写医生/护士    必填    VARCHAR2(20)  接口校验必填
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '填写医生/护士为空;'
      where ex.VC_TXYSHS is null;

      --VC_SHBZ  审核标志  1.医院审核通过，2待医院审核  必填    VARCHAR2(2)  各医院可按实际情况自行选择
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '审核标志为空;'
      where ex.VC_SHBZ is null;
      update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_detail = ex.validate_detail || '审核标志错误;'
      where checkdic('C_COMM_SHZT',ex.vc_shbz)=0 and ex.vc_shbz is not null ;

      --校验重复数据
      update zjjk_shjc_bgk_ex ex set ex.validate_detail=ex.validate_detail || '重复上报;'
      where exists(select 1 from zjmb_shjc_bgk g where ex.vc_yyrid=g.vc_id) ;

      --设置审核时间
  update zjjk.zjjk_shjc_bgk_ex ex set ex.validate_date=sysdate;

  --设置审核是否通过
  update zjjk.zjjk_shjc_bgk_ex ex set ex.is_pass=1
  where ex.validate_detail is null;
  update zjjk.zjjk_shjc_bgk_ex ex set ex.is_pass=2
  where ex.validate_detail is not null;



  --------part2 dt_yytjrq, vc_jkys, dt_jksj, vc_ccid, vc_ckbz, vc_bgkzt
  --vc_mz, vc_scbz, vc_glbz, vc_cjdwdm, dt_cjsj, vc_cjyh, dt_xgsj, vc_xgyh,
  -- vc_txyshs, vc_shbz, dt_shsj,  vc_sfjdc（新表核实是什么）   vc_qsx, vc_tb, vc_xz, vc_rzzs, vc_ggj, vc_sz, vc_qg, vc_hxd, vc_xhd, vc_sjxt,
   --vc_jkdwmc, vc_khjg, vc_khid, vc_shid, vc_hkjwdm, vc_hkjddm, vc_hkqxdm, vc_hksdm, vc_hjqt, vc_zyqt, vc_sfjdc, vc_sfzs, vc_sfytrgyzc, vc_zz, vc_id, vc_shzt, vc_shwtgyy, vc_shwtgyy1, vc_shxzmc1, vc_ssbwmc1, vc_shxzmc2, vc_shxzmc3, vc_ssbwmc2, vc_ssbwmc3, dt_bgrq, dt_yyshsj)

      for e in bgk_cur_sh loop

      insert into zjmb_shjc_bgk
     (vc_scbz,vc_cjdwdm,vc_bgkzt,vc_zz,dt_jksj,vc_cjyh,
      vc_bgkid,
      VC_JKDW, vc_xm, vc_xb, vc_nl, vc_dh, dt_shrq,
      dt_jzrq, vc_hkxxzz, vc_hj, vc_zy, vc_fsdd, vc_fsddqt,
      vc_shyy, vc_shyyqt, vc_shszsm, vc_shszsmqt, vc_yzcd,
      vc_fsqsfyj, vc_brddqk, vc_brddqkqt, vc_sfgy, vc_jj,
      vc_sszjtgj, vc_sszjtgjqt, vc_sszqk, vc_sszqkqt,
      vc_sszhsmfspz, vc_sszhsmfspzqt, vc_czjdcsszdwz,
      vc_zwywanqd, vc_anqdsy, vc_ywbhzz, vc_bhzzsy, vc_zyxgys,
      vc_zyxgysqt, vc_yqzsfsdcs, vc_shqy, vc_shqyqt, vc_sszysrgx,
      vc_sszysrgxqt, vc_sygj, vc_sygjqt, vc_shxz1, vc_ssbw1, vc_sjzy,
      vc_shwbyy, vc_hzjzkb, vc_hzjzkbqt, vc_shxz2, vc_shxz3, vc_ssbw2,
      vc_ssbw3, vc_txyshs, vc_zyqt, vc_shbz ,vc_id)
      values
      ('0',e.VC_JKDW,'0',e.vc_zz,sysdate,e.VC_JKDW,
      zjjk.get_lsh('ex'||to_char(sysdate,'yy'),'zjjk.zjmb_shjc_bgk','zjmb_shjc_bgk.vc_bgkid'),
      e.VC_JKDW, e.vc_xm, e.vc_xb, e.vc_nl, e.vc_dh, e.dt_shrq,
      e.dt_jzrq, null, e.vc_hj, e.vc_zy, e.vc_fsdd, e.vc_fsddqt,
      e.vc_shyy, e.vc_shyyqt, e.vc_shszsm, e.vc_shszsmqt, e.vc_yzcd,
      e.vc_fsqsfyj, e.vc_brddqk, e.vc_brddqkqt, e.vc_sfgy, e.vc_jj,
      e.vc_sszjtgj, e.vc_sszjtgjqt, e.vc_sszqk, e.vc_sszqkqt,
      e.vc_sszhsmfspz, e.vc_sszhsmfspzqt, e.vc_czjdcsszdwz,
      e.vc_zwywanqd, e.vc_anqdsy, e.vc_ywbhzz, e.vc_bhzzsy, e.vc_zyxgys,
      e.vc_zyxgysqt, e.vc_yqzsfsdcs, e.vc_shqy, e.vc_shqyqt, e.vc_sszysrg,
      e.vc_sszysrgxqt, e.vc_sygj, e.vc_sygjqt, e.vc_shxz1, e.vc_ssbw1, e.vc_sjzy,
      e.vc_shwbyy, e.vc_hzjzkb, e.vc_hzjzkbqt, e.vc_shxz2, e.vc_shxz3, e.vc_ssbw2,
      e.vc_ssbw3, e.vc_txyshs, e.vc_zyqt, e.vc_shbz , e.vc_yyrid);
      v_bgkid:=e.vc_yyrid;
      v_bgkmc:='insertshjcbgk';
      end loop;
      commit;



   --------part3
   insert into zjjk_shjc_bgk_ex_bak
     (uuid, vc_yyrid, dt_yytjrq, vc_jkdw, vc_xm, vc_xb, vc_nl, vc_dh, dt_shrq, dt_jzrq, vc_zz, vc_hj, vc_zy, vc_zyqt, vc_fsdd, vc_fsddqt, vc_shyy, vc_shyyqt, vc_shszsm, vc_shszsmqt, vc_yzcd, vc_fsqsfyj, vc_brddqk, vc_brddqkqt, vc_sfgy, vc_jj, vc_sfjdc, vc_sszjtgj, vc_sszjtgjqt, vc_sszqk, vc_sszqkqt, vc_sszhsmfspz, vc_sszhsmfspzqt, vc_czjdcsszdwz, vc_zwywanqd, vc_anqdsy, vc_ywbhzz, vc_bhzzsy, vc_zyxgys, vc_zyxgysqt, vc_yqzsfsdcs, vc_shqy, vc_shqyqt, vc_sszysrg, vc_sszysrgxqt, vc_sygj, vc_sygjqt, vc_shxz1, vc_shxz2, vc_shxz3, vc_ssbw1, vc_ssbw2, vc_ssbw3, vc_sjzy, vc_shwbyy, vc_hzjzkb, vc_hzjzkbqt, vc_txyshs, vc_shbz, is_pass, validate_detail, validate_date)
   select sys_guid(), vc_yyrid, dt_yytjrq, vc_jkdw, vc_xm, vc_xb, vc_nl, vc_dh, dt_shrq, dt_jzrq, vc_zz, vc_hj, vc_zy, vc_zyqt, vc_fsdd, vc_fsddqt, vc_shyy, vc_shyyqt, vc_shszsm, vc_shszsmqt, vc_yzcd, vc_fsqsfyj, vc_brddqk, vc_brddqkqt, vc_sfgy, vc_jj, vc_sfjdc, vc_sszjtgj, vc_sszjtgjqt, vc_sszqk, vc_sszqkqt, vc_sszhsmfspz, vc_sszhsmfspzqt, vc_czjdcsszdwz, vc_zwywanqd, vc_anqdsy, vc_ywbhzz, vc_bhzzsy, vc_zyxgys, vc_zyxgysqt, vc_yqzsfsdcs, vc_shqy, vc_shqyqt, vc_sszysrg, vc_sszysrgxqt, vc_sygj, vc_sygjqt, vc_shxz1, vc_shxz2, vc_shxz3, vc_ssbw1, vc_ssbw2, vc_ssbw3, vc_sjzy, vc_shwbyy, vc_hzjzkb, vc_hzjzkbqt, vc_txyshs, vc_shbz, is_pass, validate_detail, validate_date from zjjk_shjc_bgk_ex;
   v_bgkmc:='insertshjcexbak';
   delete from zjjk.zjjk_shjc_bgk_ex;

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
--死亡（死因）========================================================================
  Procedure Proc_Zjjk_Sw_Validate is
  v_sw_bgkid     zjjk.zjmb_sw_bgk.vc_bgkid%TYPE; --插入 zjmb_sw_bgk表时实际生成的 vc_bgkid；
  v_sysdate     date;                            -- 当前系统时间
  cursor bgk_cur_sw is select * from zjjk.zjjk_sw_bgk_ex ex
  where ex.is_pass='1'; -- and not exists(select 1 from zjjk.zjmb_sw_bgk g where ex.vc_yyrid=g.vc_bgkid);
  begin
    v_sysdate := sysdate;

  --delete from zjjk.zjjk_sw_bgk_ex_bak;

  --if zjjk.zjjk_sw_bgk_ex.vc_yyrid is null
 --------part1

   update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '医院唯一标识为空;'
   where trim(ex.VC_YYRID) is null;
   --update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '医院唯一标识长度不得不得小于15位;'
   --where length(ex.vc_id)<15;

   --死者姓名
   update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '死者姓名为空;'
   where ex.vc_szxm is null;

   --死者性别
   update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '死者性别为空;'
   where ex.vc_xb is null;
   update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '死者性别错误;'
   where checkdic('C_SMTJSW_XB',ex.vc_xb)=0  and ex.vc_xb is not null;

   --死者婚姻
   update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '婚姻状况为空;'
   where ex.VC_HYZK is null;
   update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '婚姻状况错误;'
   where checkdic('C_COMM_HYZK',ex.VC_HYZK)=0 and ex.VC_HYZK is not null ;

   --死者根本死因ICD编码
   update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || 'ICD编码错误;'
   where checkdic('t_ICD10',ex.vc_hzicd)=0  and ex.vc_hzicd is not null;


   --死者出生日期
   update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '出生日期为空;'
   where ex.dt_csrq is null ;
   update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '出生日期大于死亡日期;'
   where ex.dt_csrq > ex.dt_swrq  and ex.dt_csrq is not null and ex.dt_swrq is not null;

   --死者死亡日期
   update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '死亡日期为空;'
   where ex.dt_swrq is null ;
   update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '死亡日期大于报告日期;'
   where ex.dt_swrq > ex.dt_bkrq  and ex.dt_bkrq is not null and ex.dt_swrq is not null;

   --个人身份
   update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '个人身份为空;'
   where ex.VC_GRSF is null;
   update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '个人身份错误;'
   where checkdic('C_SMTJSW_GRSF',ex.VC_GRSF)=0  and ex.VC_GRSF is not null;

   /*--死者身份证号
   ---update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '身份证与出生日期不符合'
   ---where to_date(substr(ex.vc_hzsfzh,7,14),'yyyymmdd') != ex.dt_hzcsrq
   ---update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '身份证与性别不符合'
   ---where
   */

   --死者文化程度
   update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '文化程度为空;'
   where ex.vc_whcd is null;
   update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '文化程度错误;'
   where checkdic('C_SMTJSW_WHCD',ex.vc_whcd)=0 and ex.vc_whcd is not null;

   --死者民族
   update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '死者民族为空;'
   where ex.vc_mz is null;
   update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '死者民族错误;'
   where checkdic('C_COMM_MZ',ex.vc_mz)=0 and ex.vc_mz is not null;

   --证件类型
   update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '证件类型为空;'
   where ex.VC_zjlx is null;
   update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '证件类型错误;'
   where checkdic('C_SMTJSW_ZJLX',ex.VC_zjlx)=0 and ex.VC_zjlx is not null;

   --身份证号
   update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '证件类型为身份证，身份证号不能为空;'
   where ex.VC_ZJHM is null and ex.VC_zjlx='1';

   --死亡地点
   update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '死亡地点为空;'
   where ex.vc_swdd is null;
   update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '死亡地点错误;'
   where checkdic('C_SMTJSW_SWDD',ex.vc_swdd)=0 and ex.vc_swdd is not null;

   --最高诊断单位
   update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '最高诊断单位为空;'
   where ex.VC_ZGZDDW is null;
   update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '最高诊断单位错误;'
   where checkdic('C_SMTJSW_ZGZZDW',ex.VC_ZGZDDW)=0 and ex.VC_ZGZDDW is not null;

   --最高诊断依据
   update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '最高诊断依据为空;'
   where ex.VC_ZDYJ is null;
   update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '最高诊断依据错误;'
   where checkdic('C_ZJMB_ZDYJDMWH',ex.VC_ZDYJ)=0 and ex.VC_ZDYJ is not null;

   --妊娠情况
   update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '妊娠情况为空;'
   where ex.VC_RSQK is null and ex.VC_XB='2';

   --死因链a
   update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '死因链a为空;'
   where ex.VC_AICD10BM is null;

   --死亡时间间隔a
   update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '死亡时间间隔a为空;'
   where VC_AFBDSWSJJG is null;

   --常住户口地址省
   update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '户口省为空;'
   where ex.VC_HKSHEDMWS is null and ex.VC_HKSDMZJS is null;
   --省外
   update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '户口省错误;'
   where ex.VC_HKSHEDMWS is not null
     and ex.vc_hjdzlx = '1'
     and not exists(select 1 from area_qg gg where ex.VC_HKSHEDMWS = gg.code and type = 1);
     
   --常住户口地址市
   update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '户口市为空;'
   where ex.VC_HKSDMZJS is null and ex.vc_hkshidmws is null;
   --省内
   update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '户口市错误;'
   where checkdic('C_COMM_SJDM',ex.vc_hksdmzjs)=0 and ex.vc_hksdmzjs is not null;
   --省外
   update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '户口市错误;'
   where ex.vc_hkshidmws is not null
     and ex.vc_hjdzlx = '1'
     and not exists(select 1 from area_qg gg where ex.vc_hkshidmws = gg.code and type = 2);

   --常住户口地址区县
   update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '户口县为空;'
   where ex.VC_HKQXDMZJS is null and ex.vc_hkqxdmws is null;
   --省内
   update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '户口县错误;'
   where checkdic('C_COMM_QXDM',ex.VC_HKQXDMZJS)=0 and ex.VC_HKQXDMZJS is not null;
   --省外
   update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '户口县错误;'
   where ex.vc_hkqxdmws is not null
     and ex.vc_hjdzlx = '1'
     and not exists(select 1 from area_qg gg where ex.vc_hkqxdmws = gg.code and type = 3);
   --常住户口地址街道
   --update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '户口街道为空;'
  -- where ex.vc_hkjddm is null;
   --省内
   update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '户口街道错误;'
   where checkdic('C_COMM_JDDM',ex.VC_HKJDDMZJS)=0 and ex.VC_HKJDDMZJS is not null;
   --省外
   update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '户口街道错误;'
   where VC_HKJDDMWS is not null
     and ex.vc_hjdzlx = '1'
     and not exists(select 1 from area_qg gg where ex.VC_HKJDDMWS = gg.code and type = 4);

   --常住户口居委

   --常住户口详细地址
   update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '户口地址为空;'
   where ex.VC_HKXXDZZJS is null and ex.vc_hkxxdzws is null;

   --目前居住地址省
   update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '居住省为空;'
   where ex.VC_JZSHEDMWS is null and ex.VC_JZSDMZJS is null;
   --省外
   update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '户口省错误;'
   where ex.VC_JZSHEDMWS is not null
     and ex.vc_hjdzlx = '1'
     and not exists(select 1 from area_qg gg where ex.VC_JZSHEDMWS = gg.code and type = 1);
   
   --目前居住地址市
   update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '居住市为空;'
   where ex.VC_JZSDMZJS is null and VC_JZSHIDMWS is null;
   --省内
   update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '居住市错误;'
   where (checkdic('C_COMM_SJDM',ex.VC_JZSDMZJS)=0 and ex.VC_JZSDMZJS is not null) ;
   --省外
   update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '居住市错误;'
   where ex.VC_JZSHIDMWS is not null
     and ex.vc_hjdzlx = '1'
     and not exists(select 1 from area_qg gg where ex.VC_JZSHIDMWS = gg.code and type = 2);
   --目前居住地址区县
   update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '居住县为空;'
   where ex.VC_JZQXDMZJS is null and ex.VC_JZQXDMWS is null;
   --省内
   update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '居住县错误;'
   where (checkdic('C_COMM_QXDM',ex.VC_JZQXDMZJS)=0 and ex.VC_JZQXDMZJS is not null);
   --省外
   update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '居住县错误;'
   where ex.VC_JZQXDMWS is not null
     and ex.vc_hjdzlx = '1'
     and not exists(select 1 from area_qg gg where ex.VC_JZQXDMWS = gg.code and type = 3);
   --省内
   --目前居住地址街道
   update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '居住街道错误;'
   where (checkdic('C_COMM_JDDM',ex.VC_JZJDDMZJS)=0  and ex.VC_JZJDDMZJS is not null);
   --省外
    update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '居住街道错误;'
   where ex.VC_JZJDDMWS is not null
     and ex.vc_hjdzlx = '1'
     and not exists(select 1 from area_qg gg where ex.VC_JZJDDMWS = gg.code and type = 4);
   --目前居住地址居委

   --目前居住详细地址
   update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '居住地址为空;'
   where ex.VC_JZXXDZZJS is null and VC_JZXXDZWS is null;

  --报卡单位医院
  update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '报卡单位医院位为空;'
  where ex.VC_BKDW is null;
  update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '报卡单位医院位错误;'
  where checkdic('C_COMM_YYDM',ex.VC_BKDW)=0 and ex.VC_BKDW is not null;

  --报卡医师
  update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '报卡医师为空;'
  where ex.VC_BKYS is null;

  --报卡日期
  update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '报卡日期为空;'
  where ex.DT_BKRQ is null;
  update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '报卡日期大于平台创建日期;'
  where ex.DT_BKRQ > ex.dt_cjsj and ex.DT_BKRQ is not null and ex.dt_cjsj is not null;

  --审核标志
  update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '审核标志为空;'
  where ex.vc_shbz is null;
  update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '审核标志错误;'
  where checkdic('C_COMM_SHZT',ex.vc_shbz)=0 and ex.vc_shbz is not null ;

  update zjjk.zjjk_sw_bgk_ex ex set ex.vc_hkshedmws='1' where trim(ex.vc_bgklx) is not null;--户口0省内1省外
  update zjjk.zjjk_sw_bgk_ex ex set ex.vc_jzshedmws='1' where trim(ex.vc_bgklx) is not null;--居住0省内1省外

  update zjjk.zjjk_sw_bgk_ex ex set ex.vc_hkshedmws='0' where trim(ex.vc_bgklx) is null;--户口0省内1省外
  update zjjk.zjjk_sw_bgk_ex ex set ex.vc_jzshedmws='0' where trim(ex.vc_bgklx) is null;--居住0省内1省外
  --校验区域平台管理字段
   ---update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || 'ICD编码为空;'
   ---where ex.VC_GBSWBM is null;

   --死者统计分类号
   ---update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail = ex.validate_detail || '统计分类号为空;'
   ---where ex.VC_GBSWBM is not null and ex.VC_TJFLH is null;

   ---update zjjk_sw_bgk_ex ex set ex.validate_detail=ex.validate_detail||'审核时间为空;' where trim(ex.dt_shsj) is null and trim(ex.vc_shbz)='3';
  ---update zjjk_sw_bgk_ex ex set ex.validate_detail=ex.validate_detail||'报告卡状态为空;' where trim(ex.vc_bgklb) is null;
  ---update zjjk_sw_bgk_ex ex set ex.validate_detail=ex.validate_detail||'报告卡类别为空;' where trim(ex.vc_bgklx) is null;
  --update zjjk_sw_bgk_ex ex set ex.validate_detail=ex.validate_detail||'完成初访的卡片，初访时间不得为空;' where trim(ex.dt_cfsj) is null and trim(ex.vc_bgklb) in('2','6');
  --update zjjk_sw_bgk_ex ex set ex.validate_detail=ex.validate_detail||'已经失访的卡片，最后一次随访时间不得为空;' where trim(ex.dt_sfsj) is null and trim(ex.vc_kzt) in('6');

 ---入库程序（略）

 --校验重复数据
 update zjjk.zjjk_sw_bgk_ex ex set ex.validate_detail=ex.validate_detail || '重复上报;'
 where exists(select 1 from zjjk.zjmb_sw_bgk g where ex.vc_yyrid=g.vc_bgkid);

  --设置审核时间
  update zjjk.zjjk_sw_bgk_ex ex set ex.validate_date=v_sysdate;

  --设置审核是否通过
  update zjjk.zjjk_sw_bgk_ex ex set ex.is_pass=1
  where ex.validate_detail is null;
  update zjjk.zjjk_sw_bgk_ex ex set ex.is_pass=2
  where ex.validate_detail is not null;

  --------part2

  for e in bgk_cur_sw loop

  -- 生成vc_bgkid
  v_sw_bgkid := zjjk.get_lsh('ex'||to_char(sysdate,'yy'),'zjjk.zjmb_sw_bgk','zjmb_sw_bgk.vc_bgkid');
  
  -- 插入 zjmb_sw_bgk 表
  insert into  zjjk.zjmb_sw_bgk
  (VC_BGKID,VC_XM,VC_XB,VC_MZ,VC_ZY,
VC_HYZK,VC_WHCD,DT_CSRQ,DT_SWRQ,VC_ZJLX,
VC_SFZHM,VC_SWDD,VC_SQZGZDDW,VC_ZDYJ,NB_GBSYBM,
FENLEITJ,VC_JSXM,VC_JSLXDH,VC_JSDZ,VC_SQGZDW,VC_ZYH,NB_JKYYBM,DT_JKSJ,
VC_JKYS,
VC_AZJSWJB1,NB_AZJSWJBICD,VC_AFBDSWSJJG,VC_BZJSWJB1,NB_BZJSWJBIDC,VC_BFBDSWSJJG,VC_CZJSWJB1,NB_CZJSWJBICD,VC_CFBDSWSJJG,VC_DZJSWJB1,NB_DAJSWJBICD,VC_DFBDSWSJJG,VC_EZJSWJB1,NB_EAJSWJBICD,VC_EFBDSWSJJG,VC_FZJSWJB1,NB_FAJSWJBICD,VC_FFBDSWSJJG,VC_GZJSWJB1,NB_GAJSWJBICD,VC_GFBDSWSJJG,
VC_RSQK,
VC_HJDZLX,VC_HKSDM,VC_HKQXDM,VC_HKJDDM,VC_HKXXDZ,
VC_WSHKSHENDM,VC_WSHKSDM,VC_WSHKQXDM,VC_WSHKJDDM,VC_WSHKJW,
VC_GJHDQ,VC_JZSDM,VC_JZQXDM,VC_JZJDDM,VC_JZJW,VC_WSJZSHENDM,
VC_WSJZSDM,VC_WSJZQXDM,VC_WSJZJDDM,VC_WSJZJW,VC_SHBZ,VC_SZSQBLJZZTZ,VC_SCBZ,DT_CJSJ,
VC_JKDW,VC_BGKLB,vc_gldwdm,vc_cjdwdm,vc_cjyh,dt_dcrq,dt_lrsj,vc_ysqm,vc_hkjw,
vc_hkqcs,vc_jzqcs)

  values
 (v_sw_bgkid,
e.vc_Szxm,
e.vc_Xb,
e.vc_Mz,
e.vc_Grsf,

e.vc_Hyzk,
e.vc_Whcd,
e.dt_Csrq,
e.dt_Swrq,
e.vc_Zjlx,

e.vc_Zjhm,
e.vc_Swdd,
e.vc_Zgzddw,
e.vc_Zdyj,
e.vc_Gbswbm,

e.vc_Tjflh,
e.vc_lxjsxm,
e.vc_jsdh,
e.vc_Jsdz,
e.VC_SZSQGZDW,
e.vc_Zyh,
e.vc_Bkdw,
e.dt_Bkrq,
e.vc_Bkys,

e.VC_AZJDZSWDJB,
e.VC_AICD10BM,
e.VC_AFBDSWSJJG,

e.VC_BZJDZSWDJB,
e.VC_BICD10BM,
e.VC_BFBDSWSJJG,

e.VC_CZJDZSWDJB,
e.VC_CICD11BM,
e.VC_CFBDSWSJJG,

e.VC_DZJDZSWDJB,
e.VC_DICD12BM,
e.VC_DFBDSWSJJG,

e.VC_QTJBZD1,
e.VC_QTJBZD1ICD10DM,
e.VC_QTFB1DSWSJJG,

e.VC_QTJBZD2,
e.VC_QTJBZD2ICD10DM,
e.VC_QTFB2DSWSJJG,

e.VC_QTJBZD3,
e.VC_QTJBZD3ICD10DM,
e.VC_QTFB3DSWSJJG,


e.vc_Rsqk,
e.vc_Hjdzlx,

e.vc_Hksdmzjs,
e.vc_Hkqxdmzjs,
e.vc_Hkjddmzjs,
e.vc_Hkxxdzzjs,
e.vc_Hkshedmws,
e.vc_Hkshidmws,
e.vc_Hkqxdmws,
e.vc_Hkjddmws,
e.vc_Hkxxdzws,
e.vc_Gjhdq,

e.vc_Jzsdmzjs,
e.vc_Jzqxdmzjs,
e.vc_Jzjddmzjs,
e.vc_Jzxxdzzjs,
e.vc_Jzshedmws,
e.vc_Jzshidmws,
e.vc_Jzqxdmws,
e.vc_Jzjddmws,
e.vc_Jzxxdzws,

e.vc_Shbz,
e.vc_szsqbsjzztz,
'2',
v_sysdate,
e.vc_bkdw,
'0',
e.vc_bkdw,
e.vc_bkdw,
e.vc_bkdw,
e.dt_bkrq,
v_sysdate,
e.vc_bkys,
e.vc_Hkxxdzzjs,
e.VC_HKSHEDMWS,
e.VC_JZSHEDMWS
);

  -- 插入 zjmb_sw_wjw_bgk 表
  insert into  zjjk.zjmb_sw_wjw_bgk
  (VC_BGKID,VC_XM,VC_XB,VC_MZ,VC_ZY,
VC_HYZK,VC_WHCD,DT_CSRQ,DT_SWRQ,VC_ZJLX,
VC_SFZHM,VC_SWDD,VC_SQZGZDDW,VC_ZDYJ,NB_GBSYBM,
FENLEITJ,VC_JSXM,VC_JSLXDH,VC_JSDZ,VC_SQGZDW,VC_ZYH,NB_JKYYBM,DT_JKSJ,
VC_JKYS,
VC_AZJSWJB1,NB_AZJSWJBICD,VC_AFBDSWSJJG,VC_BZJSWJB1,NB_BZJSWJBIDC,VC_BFBDSWSJJG,VC_CZJSWJB1,NB_CZJSWJBICD,VC_CFBDSWSJJG,VC_DZJSWJB1,NB_DAJSWJBICD,VC_DFBDSWSJJG,VC_EZJSWJB1,NB_EAJSWJBICD,VC_EFBDSWSJJG,VC_FZJSWJB1,NB_FAJSWJBICD,VC_FFBDSWSJJG,VC_GZJSWJB1,NB_GAJSWJBICD,VC_GFBDSWSJJG,
VC_RSQK,
VC_HJDZLX,VC_HKSDM,VC_HKQXDM,VC_HKJDDM,VC_HKXXDZ,
VC_WSHKSHENDM,VC_WSHKSDM,VC_WSHKQXDM,VC_WSHKJDDM,VC_WSHKJW,
VC_GJHDQ,VC_JZSDM,VC_JZQXDM,VC_JZJDDM,VC_JZJW,VC_WSJZSHENDM,
VC_WSJZSDM,VC_WSJZQXDM,VC_WSJZJDDM,VC_WSJZJW,VC_SHBZ,VC_SZSQBLJZZTZ,VC_SCBZ,DT_CJSJ,
VC_JKDW,VC_BGKLB,vc_gldwdm,vc_cjdwdm,vc_cjyh,dt_dcrq,dt_lrsj,vc_ysqm,vc_hkjw,
vc_hkqcs,vc_jzqcs)

  values
 (v_sw_bgkid,
e.vc_Szxm,
e.vc_Xb,
e.vc_Mz,
e.vc_Grsf,

e.vc_Hyzk,
e.vc_Whcd,
e.dt_Csrq,
e.dt_Swrq,
e.vc_Zjlx,

e.vc_Zjhm,
e.vc_Swdd,
e.vc_Zgzddw,
e.vc_Zdyj,
e.vc_Gbswbm,

e.vc_Tjflh,
e.vc_lxjsxm,
e.vc_jsdh,
e.vc_Jsdz,
e.VC_SZSQGZDW,
e.vc_Zyh,
e.vc_Bkdw,
e.dt_Bkrq,
e.vc_Bkys,

e.VC_AZJDZSWDJB,
e.VC_AICD10BM,
e.VC_AFBDSWSJJG,

e.VC_BZJDZSWDJB,
e.VC_BICD10BM,
e.VC_BFBDSWSJJG,

e.VC_CZJDZSWDJB,
e.VC_CICD11BM,
e.VC_CFBDSWSJJG,

e.VC_DZJDZSWDJB,
e.VC_DICD12BM,
e.VC_DFBDSWSJJG,

e.VC_QTJBZD1,
e.VC_QTJBZD1ICD10DM,
e.VC_QTFB1DSWSJJG,

e.VC_QTJBZD2,
e.VC_QTJBZD2ICD10DM,
e.VC_QTFB2DSWSJJG,

e.VC_QTJBZD3,
e.VC_QTJBZD3ICD10DM,
e.VC_QTFB3DSWSJJG,


e.vc_Rsqk,
e.vc_Hjdzlx,

e.vc_Hksdmzjs,
e.vc_Hkqxdmzjs,
e.vc_Hkjddmzjs,
e.vc_Hkxxdzzjs,
e.vc_Hkshedmws,
e.vc_Hkshidmws,
e.vc_Hkqxdmws,
e.vc_Hkjddmws,
e.vc_Hkxxdzws,
e.vc_Gjhdq,

e.vc_Jzsdmzjs,
e.vc_Jzqxdmzjs,
e.vc_Jzjddmzjs,
e.vc_Jzxxdzzjs,
e.vc_Jzshedmws,
e.vc_Jzshidmws,
e.vc_Jzqxdmws,
e.vc_Jzjddmws,
e.vc_Jzxxdzws,

e.vc_Shbz,
e.vc_szsqbsjzztz,
'2',
v_sysdate,
e.vc_bkdw,
'0',
e.vc_bkdw,
e.vc_bkdw,
e.vc_bkdw,
e.dt_bkrq,
v_sysdate,
e.vc_bkys,
e.vc_Hkxxdzzjs,
e.VC_HKSHEDMWS,
e.VC_JZSHEDMWS
);

 v_bgkid:=e.vc_Szxm;
 v_bgkmc:='insertswbgk';
  end loop;

   --------part3insert into zjjk_sw_bgk_ex
   insert into zjjk.zjjk_sw_bgk_ex_bak_new
            (uuid, VC_YYRID, VC_SZXM, VC_ZYH, VC_MZ, VC_GRSF, VC_HYZK, VC_WHCD, DT_CSRQ, DT_SWRQ, VC_ZJLX, VC_ZJHM, VC_SWDD, VC_ZGZDDW, VC_ZDYJ, VC_GBSWBM, VC_TJFLH, VC_LXJSXM, VC_JSDH, VC_JSDZ, VC_SZSQGZDW, VC_BKDW, DT_BKRQ, VC_BKYS, VC_AICD10BM, VC_AFBDSWSJJG, VC_BICD10BM, VC_BFBDSWSJJG, VC_CICD11BM, VC_CFBDSWSJJG, VC_DICD12BM, VC_DFBDSWSJJG, VC_QTJBZD1ICD10DM, VC_QTFB1DSWSJJG, VC_QTJBZD2ICD10DM, VC_QTFB2DSWSJJG, VC_QTJBZD3ICD10DM, VC_QTFB3DSWSJJG, VC_AZJDZSWDJB, VC_BZJDZSWDJB, VC_CZJDZSWDJB, VC_DZJDZSWDJB, VC_QTJBZD1, VC_QTJBZD2, VC_QTJBZD3, VC_RSQK, VC_HJDZLX, VC_HKSDMZJS, VC_HKQXDMZJS, VC_HKJDDMZJS, VC_HKXXDZZJS, VC_HKSHEDMWS, VC_HKSHIDMWS, VC_HKQXDMWS, VC_HKJDDMWS, VC_HKXXDZWS, VC_GJHDQ, VC_JZDZLX, VC_JZSDMZJS, VC_JZQXDMZJS, VC_JZJDDMZJS, VC_JZXXDZZJS, VC_JZSHEDMWS, VC_JZSHIDMWS, VC_JZQXDMWS, VC_JZJDDMWS, VC_JZXXDZWS, VC_SZSQBSJZZTZ, VC_XB, VC_SHBZ, VC_ID, IS_PASS, VALIDATE_DETAIL, VALIDATE_DATE, VC_BGKLB, DT_SHSJ, VC_HZICD, DT_CJSJ, VC_BGKLX)
   select 
         sys_guid(), VC_YYRID, VC_SZXM, VC_ZYH, VC_MZ, VC_GRSF, VC_HYZK, VC_WHCD, DT_CSRQ, DT_SWRQ, VC_ZJLX, VC_ZJHM, VC_SWDD, VC_ZGZDDW, VC_ZDYJ, VC_GBSWBM, VC_TJFLH, VC_LXJSXM, VC_JSDH, VC_JSDZ, VC_SZSQGZDW, VC_BKDW, DT_BKRQ, VC_BKYS, VC_AICD10BM, VC_AFBDSWSJJG, VC_BICD10BM, VC_BFBDSWSJJG, VC_CICD11BM, VC_CFBDSWSJJG, VC_DICD12BM, VC_DFBDSWSJJG, VC_QTJBZD1ICD10DM, VC_QTFB1DSWSJJG, VC_QTJBZD2ICD10DM, VC_QTFB2DSWSJJG, VC_QTJBZD3ICD10DM, VC_QTFB3DSWSJJG, VC_AZJDZSWDJB, VC_BZJDZSWDJB, VC_CZJDZSWDJB, VC_DZJDZSWDJB, VC_QTJBZD1, VC_QTJBZD2, VC_QTJBZD3, VC_RSQK, VC_HJDZLX, VC_HKSDMZJS, VC_HKQXDMZJS, VC_HKJDDMZJS, VC_HKXXDZZJS, VC_HKSHEDMWS, VC_HKSHIDMWS, VC_HKQXDMWS, VC_HKJDDMWS, VC_HKXXDZWS, VC_GJHDQ, VC_JZDZLX, VC_JZSDMZJS, VC_JZQXDMZJS, VC_JZJDDMZJS, VC_JZXXDZZJS, VC_JZSHEDMWS, VC_JZSHIDMWS, VC_JZQXDMWS, VC_JZJDDMWS, VC_JZXXDZWS, VC_SZSQBSJZZTZ, VC_XB, VC_SHBZ, VC_ID, IS_PASS, VALIDATE_DETAIL, VALIDATE_DATE, VC_BGKLB, DT_SHSJ, VC_HZICD, DT_CJSJ, VC_BGKLX
   from zjjk.zjjk_sw_bgk_ex;
   v_bgkmc:='insertswexbaknew';
   delete from zjjk.zjjk_sw_bgk_ex;

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


/*
  Excel导入校验，心脑，伤害监测
*/
Procedure Proc_Zjjk_Exe_Validate is

  begin
      zjjk.zjjk_dataex_validate_new.Proc_Zjjk_Xnxg_Validate;
      zjjk.zjjk_dataex_validate_new.Proc_Zjjk_Shjc_Validate;
  end;

end ZJJK_DATAEX_VALIDATE_NEW;
