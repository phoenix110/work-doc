select a.id, a.sjid, a.text, a.url_path,a.mkbh,a.xtbh,a.cdlx
<if if(StringUtils.isNotBlank(#{jsid}))>
  ,case when b.id is not null then 'true' else '' end checked
</if>
<if if(1 == 1)>
 from (
select a.id, a.sjid, a.bt as text, b.url url_path,a.cdlx,a.xtbh,a.mkbh
  from xtcd a, gnmk b
 where a.mkbh = b.dm(+)
</if>
<if if(!"1".equals(#{superadmin}))>
   and exists (select 1 from jsqx jsqx, yhjs yhjs
                         where jsqx.jsid = yhjs.jsid and yhjs.yhm = #{yhm} and
                               yhjs.jgid = #{czyjgid} and a.id = jsqx.id)
</if>
<if if(!"1".equals(#{superadmin}) && 1 == 2)>
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
<if if(StringUtils.isNotBlank(#{jsid}))>
 , jsqx b 
 where a.id = b.id(+)
   and b.jsid(+) = #{jsid}    
</if>