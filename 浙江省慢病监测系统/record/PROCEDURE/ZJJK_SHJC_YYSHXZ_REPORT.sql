create or replace procedure      zjjk_shjc_yyshxz_report(
 beginDate in varchar2,--伤害发生时间-开始时间
 endDate in varchar2,--伤害发生时间-结束时间
 jgdm in varchar2,--机构代码-区县为6位-市为4位-省为33
 p_cur out zjjk_report.refcursor,--返回分组后的数据
 p_cursum out zjjk_report.refcursor,--返回汇总后的数据
 p_codeinfo out zjjk_report.refcursor,--返回伤害性质数据
 p_shyy out zjjk_report.refcursor--返回伤害原因数据
)
is
  begin
       open p_cur for
       select ty.vc_shxz1,ty.vc_shyy,
              count(ty.vc_bgkid) c1
       from zjmb_shjc_bgk ty
       where ty.vc_shxz1 is not null
             and ty.vc_bgkzt='0'
             and ty.vc_shyy is not null
             and (ty.vc_scbz is null or ty.vc_scbz=0)
             and ty.vc_cjdwdm like concat(concat('%',jgdm),'%')
             and to_char(ty.dt_shrq,'yyyy-MM-dd')>=to_char(to_date(beginDate,'yyyy-MM-dd'),'yyyy-MM-dd')
             and to_char(ty.dt_shrq,'yyyy-MM-dd')<=to_char(to_date(endDate,'yyyy-MM-dd'),'yyyy-MM-dd')
       group by ty.vc_shxz1,ty.vc_shyy order by ty.vc_shxz1,ty.vc_shyy;

       open p_cursum for
       select ty.vc_shyy,
              count(ty.vc_bgkid) c2
       from zjmb_shjc_bgk ty
       where ty.vc_shxz1 is not null
             and ty.vc_bgkzt='0'
             and ty.vc_shyy is not null
             and (ty.vc_scbz is null or ty.vc_scbz=0)
             and ty.vc_cjdwdm like concat(concat('%',jgdm),'%')
             and to_char(ty.dt_shrq,'yyyy-MM-dd')>=to_char(to_date(beginDate,'yyyy-MM-dd'),'yyyy-MM-dd')
             and to_char(ty.dt_shrq,'yyyy-MM-dd')<=to_char(to_date(endDate,'yyyy-MM-dd'),'yyyy-MM-dd')
       group by ty.vc_shyy order by ty.vc_shyy;
       open p_codeinfo for
       select t.code,t.name from code_info t,code_info s where t.code_info_id=s.id  and (s.code='DICT_SHJC_QSX'
       or s.code='DICT_SHJC_RZZS' or s.code='DICT_SHJC_GGJ')
       order by t.code;
       open p_shyy for
       select t.code,t.name from code_info t,code_info s where t.code_info_id=s.id  and s.code='DICT_SHJC_SSYY'
       order by t.code;
end zjjk_shjc_yyshxz_report;

