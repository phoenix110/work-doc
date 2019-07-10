select a.id, a.sjid, a.bt as text, b.url url_path,a.mkbh,a.xtbh,a.cdlx,
case when (select count(1) from xtcd c  where c.sjid = a.id) > 0 then 'true' else 'false' end isParent
  from xtcd a, gnmk b
 where a.mkbh = b.dm(+)
 <if if(StringUtils.isBlank(#{sjid}))>
     and a.id = #{cdid}
 </if>
 <if if(StringUtils.isNotBlank(#{sjid}))>
     and a.sjid = #{sjid}
 </if>
 order by a.xh