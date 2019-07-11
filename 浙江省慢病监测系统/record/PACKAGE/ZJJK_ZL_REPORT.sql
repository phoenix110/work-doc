create or replace package      ZJJK_ZL_REPORT is

  -- Author  : xujing
  -- Created : 2012-8-2
  -- Purpose : ZJJK ZL REPORT

  --肿瘤-----分部位年龄统计表
  Procedure Proc_Zjjk_fxbjblxdqtjb(bkstart_date varchar2,bkend_date varchar2,
                                lrstart_date varchar2,lrend_date varchar2,
                                fbstart_date varchar2,fbend_date varchar2,
                                jddm varchar2,usertype varchar2,sex varchar2,myrc out ZJJK_MYCUR.myrctype);


  --肿瘤-----分地区年龄统计表
  Procedure Proc_Zjjk_fbsnltjb(bkstart_date varchar2,bkend_date varchar2,
                                lrstart_date varchar2,lrend_date varchar2,
                                fbstart_date varchar2,fbend_date varchar2,
                                jddm varchar2,usertype varchar2,sex varchar2,myrc out ZJJK_MYCUR.myrctype);


end ZJJK_ZL_REPORT;

