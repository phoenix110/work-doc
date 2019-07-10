 select dm, mc, jb, total, rn
   from (select dm, mc, jb, total, rownum rn
           from (select dm, mc, jb, count(1) over() total
                   from p_xzdm a
                  where a.dm like #{dm} || '%'
                    and (a.dm like '%' || #{jsm} || '%' or
                        a.mc like '%' || #{jsm} || '%' or
                        a.pym like '%' || upper(#{jsm}) || '%'))
          where rownum <= #{rn_e})
  where rn >= #{rn_s}