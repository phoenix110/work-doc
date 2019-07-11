create or replace package ZJJK_DATAEX_VALIDATE_NEW is

  -- Author  : huangyongzheng
  -- Created : 2017-12-15
  -- Purpose : ZJJK_DATAEX_VALIDATE_NEW

  --心脑血管
  Procedure Proc_Zjjk_Xnxg_Validate;

  --伤害监测
  Procedure Proc_Zjjk_Shjc_Validate;

  --死因
  Procedure Proc_Zjjk_Sw_Validate;

  --exe校验
  Procedure Proc_Zjjk_Exe_Validate;

end ZJJK_DATAEX_VALIDATE_NEW;
