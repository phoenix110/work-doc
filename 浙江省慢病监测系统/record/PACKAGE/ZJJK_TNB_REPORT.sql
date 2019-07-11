create or replace package      ZJJK_TNB_REPORT is

  -- Author  : xujing
  -- Created : 2011-5-3
  -- Purpose : ZJJK TNB REPORT

  --糖尿病发病报告发病数-分性别疾病地区统计表
  Procedure Proc_Zjjk_fxbjblxdqtjb(bkstart_date varchar2,bkend_date varchar2,
                                lrstart_date varchar2,lrend_date varchar2,
                                fbstart_date varchar2,fbend_date varchar2,
                                jddm varchar2,usertype varchar2,myrc out ZJJK_MYCUR.myrctype);

  --糖尿病发病报告发病数-分性别疾病地区统计表
  Procedure Proc_Zjjk_fbsnltjb(bkstart_date varchar2,bkend_date varchar2,
                                lrstart_date varchar2,lrend_date varchar2,
                                fbstart_date varchar2,fbend_date varchar2,
                                jddm varchar2,usertype varchar2,myrc out ZJJK_MYCUR.myrctype);


end ZJJK_TNB_REPORT;

