create or replace package ZJJK_DATAEX_VALIDATE is

  -- Author  : xujing
  -- Created : 2011-9-26
  -- Purpose : ZJJK_DATAEX_VALIDATE

  --糖尿病
  Procedure Proc_Zjjk_Tnb_Validate;

  --心脑血管
  Procedure Proc_Zjjk_Xnxg_Validate;

  --肿瘤
  Procedure Proc_Zjjk_Zl_Validate;

  --伤害监测
  Procedure Proc_Zjjk_Shjc_Validate;
  
  --死因
  Procedure Proc_Zjjk_Sw_Validate;

  --exe校验
  Procedure Proc_Zjjk_Exe_Validate;

end ZJJK_DATAEX_VALIDATE;

