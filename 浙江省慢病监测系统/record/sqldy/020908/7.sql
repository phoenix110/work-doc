select id,
       dqdm,
       dqmc,
       tjnd,
       xb,
       nlz,
       nlzw,
       rks,
       sws,
       swl,
       swgl,
       scrs,
       qwsws,
       scrns,
       sczrns,
       qwsm,
       tjnd - 1 ||'年期望寿命' ndqwsm
  from tjbb_sw_qwsm
where id = #{id}
  and nlz > 0
  order by nlz
       