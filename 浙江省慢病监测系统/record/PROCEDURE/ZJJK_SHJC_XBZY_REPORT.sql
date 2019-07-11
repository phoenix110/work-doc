create or replace procedure      zjjk_shjc_xbzy_report
(
 beginDate in varchar2,--伤害发生时间-开始时间
 endDate in varchar2,--伤害发生时间-结束时间
 jgdm in varchar2,--机构代码-区县为6位-市为4位-省为33
 p_cur out zjjk_report.refcursor,--返回分组后的数据
 p_cursum out zjjk_report.refcursor,--返回汇总后的数据
 p_codeinfo out zjjk_report.refcursor--返回职业数据
)
is
  begin
       open p_cur for
       select ty.vc_zy,
              sum(case when ty.vc_xb=1 then 1 else 0 end) c1,--男
              sum(case when ty.vc_xb=2 then 1 else 0 end) c2,--女
              sum(case when 1<>2 then 1 else 0 end) total--男女总和
       from zjmb_shjc_bgk ty
       where ty.vc_zy is not null
             and ty.vc_bgkzt='0'
             and ty.vc_xb is not null
             and (ty.vc_scbz is null or ty.vc_scbz=0)
             and ty.vc_cjdwdm like concat(concat('%',jgdm),'%')
             and to_char(ty.dt_shrq,'yyyy-MM-dd')>=to_char(to_date(beginDate,'yyyy-MM-dd'),'yyyy-MM-dd')
             and to_char(ty.dt_shrq,'yyyy-MM-dd')<=to_char(to_date(endDate,'yyyy-MM-dd'),'yyyy-MM-dd')
       group by ty.vc_zy order by ty.vc_zy;

       open p_cursum for
       select
              sum(case when ty.vc_xb=1 then 1 else 0 end) c1,--男
              sum(case when ty.vc_xb=2 then 1 else 0 end) c2,--女
              sum(case when 1<>2 then 1 else 0 end) total--男女和
       from zjmb_shjc_bgk ty
       where ty.vc_zy is not null
             and ty.vc_bgkzt='0'
             and ty.vc_xb is not null
             and (ty.vc_scbz is null or ty.vc_scbz=0)
             and ty.vc_cjdwdm like concat(concat('%',jgdm),'%')
             and to_char(ty.dt_shrq,'yyyy-MM-dd')>=to_char(to_date(beginDate,'yyyy-MM-dd'),'yyyy-MM-dd')
             and to_char(ty.dt_shrq,'yyyy-MM-dd')<=to_char(to_date(endDate,'yyyy-MM-dd'),'yyyy-MM-dd');

       open p_codeinfo for
       select ty.code,ty.name from code_info ty
       where ty.code_info_id='8'
       order by ty.code;

  end zjjk_shjc_xbzy_report;

