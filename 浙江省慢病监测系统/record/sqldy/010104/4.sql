select b.xm,
       b.qm,
       b.id,
       b.sfzh,
       b.xb,
       b.lxdh,
       dts(b.csrq,0) csrq,
       a.yhm,
       a.jgid,
       b.dm
  from xtyh a, p_ryxx b
 where a.ryid = b.id
   and a.yhm = #{yhm}
   and a.jgid = #{yhjgid}