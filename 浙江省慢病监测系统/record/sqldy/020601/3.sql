select area.code, area.name, area.type
  from area_qg area
 where 1=1
   <if if(StringUtils.isNotBlank(#{type}))>
      and area.type = #{type}
   </if>
   
  <if if(StringUtils.isNotBlank(#{code}))>
       and (
            area.CODE like #{code}||'%'
        ) 
  </if>
 order by area.code