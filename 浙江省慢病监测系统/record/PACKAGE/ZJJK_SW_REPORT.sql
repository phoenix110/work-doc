create or replace package      ZJJK_SW_REPORT is

  -- Author  : xujing
  -- Created : 2011-3-3
  -- Purpose : ZJJK SW REPORT

  --居民病伤死亡原因表
  Procedure Proc_Zjjk_Jmbsswyyb(lrstart_date varchar2,lrend_date varchar2,
                                bkstart_date varchar2,bkend_date varchar2,
                                swstart_date varchar2,swend_date varchar2,
                                jddm varchar2,myrc out ZJJK_MYCUR.myrctype);

  --婴儿死亡日月年龄表
  Procedure Proc_Zjjk_Yeswrynlb(lrstart_date varchar2,lrend_date varchar2,
                                bkstart_date varchar2,bkend_date varchar2,
                                swstart_date varchar2,swend_date varchar2,
                                jddm varchar2,myrc out ZJJK_MYCUR.myrctype);
  --居民死亡率分析表
  Procedure Proc_Zjjk_Swlfxb(lrstart_date varchar2,lrend_date varchar2,
                                bkstart_date varchar2,bkend_date varchar2,
                                swstart_date varchar2,swend_date varchar2,
                                jddm varchar2,type varchar2,myrc out ZJJK_MYCUR.myrctype);

end ZJJK_SW_REPORT;

