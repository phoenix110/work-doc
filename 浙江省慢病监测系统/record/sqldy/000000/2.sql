select 
       id as code,
       mc as name
  from p_xzdm
 where bz = 1
<if if(StringUtils.isNotBlank(#{jb}))>
     and jb = #{jb}
</if>
<if if(StringUtils.isNotBlank(#{code}))>
     and sjid = #{code}
</if>
<if if(StringUtils.isNotBlank(#{pym}))>
    and pym like '%'||UPPER(#{pym})||'%'
</if>
<if if(StringUtils.isNotBlank(#{id}))>
    and id = #{id}
</if>