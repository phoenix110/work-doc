select a.dm code, a.mc name, a.fldm diccode
   from p_tyzdml a
  where a.bz = 1
    and a.fldm = #{code}
   <if if(StringUtils.isNotBlank(#{dm}))>
     and a.dm = #{dm}
   </if>   
order by  a.disp,a.dm asc