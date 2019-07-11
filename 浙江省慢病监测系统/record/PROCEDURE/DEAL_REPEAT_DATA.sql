create or replace procedure Deal_Repeat_Data is
  --aVC_BGKID    VARCHAR2(60)   ;-- 报告卡ID
  aVC_BGDW    VARCHAR2(60)    ;-- 报告卡类型
  aVC_HZXM      VARCHAR2(60)   ;-- 门诊号
  aVC_ZYH      VARCHAR2(60)   ;-- 住院号
  aVC_HZXB     VARCHAR2(60)   ;-- 患者ID
  aVC_ICD10    VARCHAR2(10)   ;-- ICD—10
  aDT_HZCSRQ   DATE;-- ICD—10

  cursor c_Data is select a.vc_bgdw, a.vc_zyh, b.vc_hzxm, b.vc_hzxb, b.dt_hzcsrq,
    substr(a.vc_icd10, 1, 3) icd10, count(1) from zjjk_zl_bgk a
    left join zjjk_zl_hzxx b on b.vc_personid = a.vc_hzid
    group by vc_hzxm, vc_hzxb, dt_hzcsrq, vc_bgdw, vc_zyh, substr(a.vc_icd10, 1, 3) having count(1) > 1
    order by vc_bgdw;

  --sqlstr       varchar2(1000);
  --vID          varchar2(40);
  --iUpdate      integer;
begin
  for d in c_data loop
    --aVC_BGKID    := d.VC_BGKID       ;
    aVC_BGDW    := d.vc_bgdw       ;
    aVC_HZXM   := d.vc_hzxm      ;
    aVC_ZYH  := d.vc_zyh     ;
    aVC_HZXB      := d.vc_hzxb         ;
    aDT_HZCSRQ     :=  d.dt_hzcsrq       ;
    aVC_ICD10        := d.icd10      ;

    insert into zjjk_zl_bgk_import_delete select a.* from zjjk_zl_bgk a
    left join zjjk_zl_hzxx b on b.vc_personid = a.vc_hzid
    where a.vc_bgdw = aVC_BGDW and a.vc_zyh = aVC_ZYH and b.vc_hzxm = aVC_HZXM and b.vc_hzxb = aVC_HZXB
      and b.dt_hzcsrq = aDT_HZCSRQ and substr(a.vc_icd10, 1, 3) = aVC_ICD10 and a.vc_bgkid like 'F%';

  end loop;

  commit;

  Exception
    when others then
      rollback;
end Deal_Repeat_Data;

