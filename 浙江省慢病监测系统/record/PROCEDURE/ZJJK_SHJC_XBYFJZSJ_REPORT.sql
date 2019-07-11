create or replace procedure      zjjk_shjc_xbyfjzsj_report
(
 beginDate in varchar2,--伤害诊断时间年份
 jgdm in varchar2,--机构代码-区县为6位-市为4位-省为33
 p_cur out zjjk_report.refcursor,--返回分组后的数据
 p_cursum out zjjk_report.refcursor--返回汇总后的数据
)
is
  begin
       open p_cur for
       select to_number(to_char(ty.dt_jzrq,'MM')) dt_shrq,
              sum(case when ty.vc_xb=1 then 1 else 0 end) c1,--男
              sum(case when ty.vc_xb=2 then 1 else 0 end) c2,--女
              sum(case when 1<>2 then 1 else 0 end) total--男女总和
       from zjmb_shjc_bgk ty
       where ty.dt_jzrq is not null
             and ty.vc_bgkzt='0'
             and (ty.vc_scbz is null or ty.vc_scbz=0)
             and ty.vc_cjdwdm like concat(concat('%',jgdm),'%')
             and to_char(ty.dt_shrq,'yyyy')=beginDate
       group by to_char(ty.dt_jzrq,'MM') order by to_char(ty.dt_jzrq,'MM');

       open p_cursum for
       select
              sum(case when ty.vc_xb=1 then 1 else 0 end) c1,--男
              sum(case when ty.vc_xb=2 then 1 else 0 end) c2,--女
              sum(case when 1<>2 then 1 else 0 end) total--男女和
       from zjmb_shjc_bgk ty
       where ty.dt_jzrq is not null
             and ty.vc_bgkzt='0'
             and (ty.vc_scbz is null or ty.vc_scbz=0)
             and ty.vc_cjdwdm like concat(concat('%',jgdm),'%')
             and to_char(ty.dt_jzrq,'yyyy')=beginDate;

  end zjjk_shjc_xbyfjzsj_report;

