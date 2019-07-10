select a.id, a.sjid, a.bt as text, b.url url_path,a.mkbh,a.xtbh,a.cdlx
  from xtcd a, gnmk b
 where a.mkbh = b.dm(+)
 <if if(StringUtils.isBlank(#{sjid}))>
     start with a.sjid is null
 </if>
  <if if(StringUtils.isNotBlank(#{sjid}))>
     start with a.sjid = #{sjid}
 </if>
connect by a.sjid = prior a.id
order by a.xh