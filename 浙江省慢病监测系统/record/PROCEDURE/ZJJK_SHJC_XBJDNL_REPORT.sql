create or replace procedure      zjjk_shjc_xbjdnl_report
(
 beginDate in varchar2,--伤害发生时间-开始时间
 endDate in varchar2,--伤害发生时间-结束时间
 jgdm in varchar2,--机构代码-区县为6位-市为4位-省为33
 p_cur out zjjk_report.refcursor,--返回分组后的数据
 p_cursum out zjjk_report.refcursor--返回汇总后的数据
)

is
  begin
       open p_cur for
       select (case when to_number(ty.vc_nl)>=0 and to_number(ty.vc_nl)<=4 then 1  --年龄小于等于4
               when to_number(ty.vc_nl)>4 and to_number(ty.vc_nl)<=14 then 2  --年龄大于4小于等于14
               when to_number(ty.vc_nl)>14 and to_number(ty.vc_nl)<=19 then 3  --年龄大于14小于等于19
               when to_number(ty.vc_nl)>19 and to_number(ty.vc_nl)<=24 then 4  --年龄大于19小于等于24
               when to_number(ty.vc_nl)>24 and to_number(ty.vc_nl)<=44 then 5  --年龄大于24小于等于44
               when to_number(ty.vc_nl)>44 and to_number(ty.vc_nl)<=64 then 6  --年龄大于44小于等于64
               when to_number(ty.vc_nl)>64 then 7 end)  nl,--年龄大于等于64
              sum(case when ty.vc_xb=1 then 1 else 0 end) c1,--男
              sum(case when ty.vc_xb=2 then 1 else 0 end) c2,--女
              sum(case when 1<>2 then 1 else 0 end) total--男女总和
       from zjmb_shjc_bgk ty
       where ty.vc_nl is not null
             and ty.vc_bgkzt='0'
             and (ty.vc_scbz is null or ty.vc_scbz=0)
             and ty.vc_cjdwdm like concat(concat('%',jgdm),'%')
             and to_char(ty.dt_shrq,'yyyy-MM-dd')>=to_char(to_date(beginDate,'yyyy-MM-dd'),'yyyy-MM-dd')
             and to_char(ty.dt_shrq,'yyyy-MM-dd')<=to_char(to_date(endDate,'yyyy-MM-dd'),'yyyy-MM-dd')
       group by (case when to_number(ty.vc_nl)>=0 and to_number(ty.vc_nl)<=4 then 1  --年龄小于等于4
               when to_number(ty.vc_nl)>4 and to_number(ty.vc_nl)<=14 then 2  --年龄大于4小于等于14
               when to_number(ty.vc_nl)>14 and to_number(ty.vc_nl)<=19 then 3  --年龄大于14小于等于19
               when to_number(ty.vc_nl)>19 and to_number(ty.vc_nl)<=24 then 4  --年龄大于19小于等于24
               when to_number(ty.vc_nl)>24 and to_number(ty.vc_nl)<=44 then 5  --年龄大于24小于等于44
               when to_number(ty.vc_nl)>44 and to_number(ty.vc_nl)<=64 then 6  --年龄大于44小于等于64
               when to_number(ty.vc_nl)>64 then 7 end) --年龄大于等于64
        order by (case when to_number(ty.vc_nl)>=0 and to_number(ty.vc_nl)<=4 then 1  --年龄小于等于4
               when to_number(ty.vc_nl)>4 and to_number(ty.vc_nl)<=14 then 2  --年龄大于4小于等于14
               when to_number(ty.vc_nl)>14 and to_number(ty.vc_nl)<=19 then 3  --年龄大于14小于等于19
               when to_number(ty.vc_nl)>19 and to_number(ty.vc_nl)<=24 then 4  --年龄大于19小于等于24
               when to_number(ty.vc_nl)>24 and to_number(ty.vc_nl)<=44 then 5  --年龄大于24小于等于44
               when to_number(ty.vc_nl)>44 and to_number(ty.vc_nl)<=64 then 6  --年龄大于44小于等于64
               when to_number(ty.vc_nl)>64 then 7 end) --年龄大于等于64
               ;

       open p_cursum for
       select
              sum(case when ty.vc_xb=1 then 1 else 0 end) c1,--男
              sum(case when ty.vc_xb=2 then 1 else 0 end) c2,--女
              sum(case when 1<>2 then 1 else 0 end) total--男女和
       from zjmb_shjc_bgk ty
       where ty.vc_nl is not null
             and ty.vc_bgkzt='0'
             and (ty.vc_scbz is null or ty.vc_scbz=0)
             and ty.vc_cjdwdm like concat(concat('%',jgdm),'%')
             and to_char(ty.dt_shrq,'yyyy-MM-dd')>=to_char(to_date(beginDate,'yyyy-MM-dd'),'yyyy-MM-dd')
             and to_char(ty.dt_shrq,'yyyy-MM-dd')<=to_char(to_date(endDate,'yyyy-MM-dd'),'yyyy-MM-dd');
  end zjjk_shjc_xbjdnl_report;

