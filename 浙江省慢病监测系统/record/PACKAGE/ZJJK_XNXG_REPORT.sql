create or replace package      ZJJK_XNXG_REPORT is

  -- Author  : xujing
  -- Created : 2011-5-3
  -- Purpose : ZJJK SW REPORT

  --冠心病发病报告发病数-分性别疾病地区统计表
  Procedure Proc_Zjjk_Gxbfxbjbdqtjb(bkstart_date varchar2,bkend_date varchar2,
                                lrstart_date varchar2,lrend_date varchar2,
                                fbstart_date varchar2,fbend_date varchar2,
                                jddm varchar2,usertype varchar2,myrc out ZJJK_MYCUR.myrctype);

  --脑卒中发病报告发病数-分性别疾病地区统计表
  Procedure Proc_Zjjk_Nzzfxbjbdqtjb(bkstart_date varchar2,bkend_date varchar2,
                                lrstart_date varchar2,lrend_date varchar2,
                                fbstart_date varchar2,fbend_date varchar2,
                                jddm varchar2,usertype varchar2,myrc out ZJJK_MYCUR.myrctype);


  --冠心病发病报告发病数-分年龄疾病地区统计表
  Procedure Proc_Zjjk_Gxbnldqtjb(bkstart_date varchar2,bkend_date varchar2,
                                lrstart_date varchar2,lrend_date varchar2,
                                fbstart_date varchar2,fbend_date varchar2,
                                jddm varchar2,usertype varchar2,sex varchar2,
                                myrc out ZJJK_MYCUR.myrctype);

  --脑卒中发病报告发病数-分年龄疾病地区统计表
  Procedure Proc_Zjjk_Nsznldqtjb(bkstart_date varchar2,bkend_date varchar2,
                                lrstart_date varchar2,lrend_date varchar2,
                                fbstart_date varchar2,fbend_date varchar2,
                                jddm varchar2,usertype varchar2,sex varchar2,
                                myrc out ZJJK_MYCUR.myrctype);


end ZJJK_XNXG_REPORT;

