select a.id, a.sjid, a.text, a.url_path,a.mkbh,a.xtbh,a.cdlx
<if if(StringUtils.isNotBlank(#{xzjgid}))>
  ,case when b.id is not null then 'true' else '' end checked
</if>
<if if(1 == 1)>
 from (
select a.id, a.sjid, a.bt as text, b.url url_path,a.cdlx,a.xtbh,a.mkbh
  from xtcd a, gnmk b
 where a.mkbh = b.dm(+)
</if>
<if if(!"1".equals(#{superadmin}))>
   and exists(select 1 from jgqx qx where a.id = qx.id and qx.jgid = #{czyjgid})
</if>
 <if if(StringUtils.isBlank(#{sjid}))>
     start with a.id = #{cdid}
 </if>
  <if if(StringUtils.isNotBlank(#{sjid}))>
     start with a.sjid = #{sjid}
 </if>
 <if if(1 == 1)>
connect by a.sjid = prior a.id
order by a.xh
) a
</if>
<if if(StringUtils.isNotBlank(#{xzjgid}))>
 , jgqx b 
 where a.id = b.id(+)
   and b.jgid(+) = #{xzjgid}      
</if>