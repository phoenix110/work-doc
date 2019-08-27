
select CODE, NAME from organ_node
    where removed = 0
    <if if("sq".equals(#{type}))>
        and description like '%' || #{xzqh} || '%'
    </if>
    <if if(!"sq".equals(#{type}))>
        and (description like '%' || #{xzqh} || '%' or code like '%' || #{xzqh} || '%')
    </if>

<if if(1!=1)>
select DM AS CODE, MC AS NAME
  from P_YLJG a
  where 1 = 1
    and a.xzqh like #{xzqh}||'%' 
    AND a.lb in ('B1','A1')
    and bz = 1
</if>    