select replace(wm_concat(mc), ',', '') as mc
  from (select mc, rownum as rn
          from (
            <if if(StringUtils.isNotBlank(#{vc_fldm}))>
                select mc
                  from p_yljg
                 where dm = #{jgdm}
                union
            </if>
                select to_char(replace(wm_concat(mc), ',', '')) as mc
                  from (select mc
                           from p_xzdm t
                          start with t.dm = (select SZDXZQH
                                               from p_yljg
                                              where dm = #{jgdm})
                         connect by t.id = prior t.sjid
                          order by jb asc))
         order by rn desc)