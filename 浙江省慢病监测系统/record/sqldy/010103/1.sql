select a.id,a.jc text,a.gljgid sjid,
case when (select count(1) from p_yljg c  where c.bz = 1 and c.gljgid = a.id) > 0 then 'true' else 'false' end isParent
 <if if(StringUtils.isNotBlank(#{czyjgid}))>
 ,decode(a.id, #{czyjgid}, 'true', '') open
 </if>
 <if if(1==1)>
  from p_yljg a
 where 1 = 1
 </if>
 <if if("1".equals(#{superadmin}) && StringUtils.isNotBlank(#{czyjgid}))>
     and (a.gljgid = '0' or a.gljgid = (select id from p_yljg where gljgid = '0'))
 </if>
 <if if(StringUtils.isNotBlank(#{czyjgid}) && !"1".equals(#{superadmin}))>
     and (a.id = #{czyjgid} or a.gljgid = #{czyjgid})
 </if>
  <if if(StringUtils.isBlank(#{czyjgid}))>
     and a.gljgid = #{sjid}
 </if>
 order by a.jc