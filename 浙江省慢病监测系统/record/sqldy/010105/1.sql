select orgid,orgcode,orgname,jc,pym,rn,total from(select orgid,orgcode,orgname,jc,pym,rownum as rn,count(1) over() as total from(select t.id as orgid,t.dm as orgcode,t.mc as orgname,t.jc,t.pym from P_YLJG t 
<if if(StringUtils.isNotBlank(#{jsm}))>
  where (t.dm like '%'||#{jsm}||'%' or t.mc like '%'||#{jsm}||'%' or t.jc like '%'||#{jsm}||'%' or t.pym like '%'||upper(#{jsm})||'%')
</if>
<if if("WDPHISJG".equals(#{jsm}) )>
  union all
  select '0' as orgid,'0' as orgcode,'系统初始化机构' as orgname,'系统初始化机构' jc,'WDPHISJG' pym from dual
</if> ) tt
where rownum<=#{rn_e}) ttt
where ttt.rn>=#{rn_s}                