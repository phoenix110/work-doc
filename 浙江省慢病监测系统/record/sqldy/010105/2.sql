select loginname,xm,yhxm,rn,total from (select loginname,xm,yhxm,rownum as rn,count(1) over() as total from(select t.yhm as loginname,ry.xm,t.yhm||'-'||ry.xm as yhxm from xtyh t,p_ryxx ry 
where t.ryid=ry.id and  t.jgid =#{orgid} And t.zt=1 And ry.bz=1 
<if if(StringUtils.isNotBlank(#{jsm}))> 
  and (upper(t.yhm) like '%'||upper(#{jsm})||'%' or ry.xm like '%'||#{jsm}||'%'  or ry.pym like '%'||upper(#{jsm})||'%')
</if> 
<if if("WdPhis".equals(#{jsm}) )>
  union all
  select 'wdsysuser' as loginname,'管理员' xm,'wdsysuser-管理员' as yhx from dual
</if> ) tt
where rownum <=#{rn_e}) ttt
where rn>=#{rn_s}        