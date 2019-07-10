select a.id, a.sjid, a.bt, a.xh, b.url,b.dm,b.bs,a.mkbh,a.xtbh,a.cdlx,
       p.bt pbt,a.zt
  from xtcd a, gnmk b, xtcd p
 where a.mkbh = b.dm(+)
   and a.id = #{id}
   and a.sjid = p.id(+)