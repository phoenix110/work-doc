create or replace procedure      zjjk_shjc_nlfsyy_report
(
 beginDate in varchar2,--伤害发生时间-开始时间
 endDate in varchar2,--伤害发生时间-结束时间
 jgdm in varchar2,--机构代码-区县为6位-市为4位-省为空
 p_cur out zjjk_report.refcursor,--返回分句性别分组后的数据
 p_cursum out zjjk_report.refcursor--返回男女汇总后的数据
)
is
  begin
       open p_cur for
       select ty.vc_shyy,
              --decode(ty.vc_xb,1,'man',2,'women','other') vc_xbname,
              sum(case when ty.vc_nl<=4 then 1 else 0 end) c1,--年龄小于等于4
              sum(case when ty.vc_nl>4 and ty.vc_nl<=14 then 1 else 0 end) c2,--年龄大于4小于等于14
              sum(case when ty.vc_nl>14 and ty.vc_nl<=19 then 1 else 0 end) c3,--年龄大于14小于等于19
              sum(case when ty.vc_nl>19 and ty.vc_nl<=24 then 1 else 0 end) c4,--年龄大于19小于等于24
              sum(case when ty.vc_nl>24 and ty.vc_nl<=44 then 1 else 0 end) c5,--年龄大于24小于等于44
              sum(case when ty.vc_nl>44 and ty.vc_nl<=64 then 1 else 0 end) c6,--年龄大于44小于等于64
              sum(case when ty.vc_nl>64 then 1 else 0 end) c7,--年龄大于64
               sum(case when 1<>2 then 1 else 0 end) total--年龄大于64
       from zjmb_shjc_bgk ty
       where ty.vc_shyy is not null
             --and ty.vc_scbz='0'
             and ty.vc_bgkzt='0'
             and ty.vc_cjdwdm like concat(concat('%',jgdm),'%')
             and to_char(ty.dt_shrq,'yyyy-MM-dd')>=to_char(to_date(beginDate,'yyyy-MM-dd'),'yyyy-MM-dd')
             and to_char(ty.dt_shrq,'yyyy-MM-dd')<=to_char(to_date(endDate,'yyyy-MM-dd'),'yyyy-MM-dd')
       group by ty.vc_shyy order by ty.vc_shyy;

       open p_cursum for
       select --ty.vc_xb,
              --decode(ty.vc_xb,1,'man',2,'women','other') vc_xbname,
              sum(case when ty.vc_nl<=4 then 1 else 0 end) c1,--年龄小于等于4
              sum(case when ty.vc_nl>4 and ty.vc_nl<=14 then 1 else 0 end) c2,--年龄大于4小于等于14
              sum(case when ty.vc_nl>14 and ty.vc_nl<=19 then 1 else 0 end) c3,--年龄大于14小于等于19
              sum(case when ty.vc_nl>19 and ty.vc_nl<=24 then 1 else 0 end) c4,--年龄大于19小于等于24
              sum(case when ty.vc_nl>24 and ty.vc_nl<=44 then 1 else 0 end) c5,--年龄大于24小于等于44
              sum(case when ty.vc_nl>44 and ty.vc_nl<=64 then 1 else 0 end) c6,--年龄大于44小于等于64
              sum(case when ty.vc_nl>64 then 1 else 0 end) c7,--年龄大于64
               sum(case when 1<>2 then 1 else 0 end) total--年龄大于64
       from zjmb_shjc_bgk ty
       where ty.vc_shyy is not null
             --and ty.vc_scbz='0'
             and ty.vc_bgkzt='0'
             and ty.vc_cjdwdm like concat(concat('%',jgdm),'%')
             and to_char(ty.dt_shrq,'yyyy-MM-dd')>=to_char(to_date(beginDate,'yyyy-MM-dd'),'yyyy-MM-dd')
             and to_char(ty.dt_shrq,'yyyy-MM-dd')<=to_char(to_date(endDate,'yyyy-MM-dd'),'yyyy-MM-dd')
       order by ty.vc_shyy;
  end zjjk_shjc_nlfsyy_report;

