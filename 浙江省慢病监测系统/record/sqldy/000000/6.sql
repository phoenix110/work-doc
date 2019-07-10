select id as code, mc as name from p_xzdm  where 1=1
<if if(StringUtils.isNotBlank(#{code}))>
and id like #{code}||'%'
</if>
 and jb ='2'