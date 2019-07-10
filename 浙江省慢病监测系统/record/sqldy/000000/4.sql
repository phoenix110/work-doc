select code, name 
  from organ_node a
  where a.organ_type = '1045'
 <if if("1".equals(#{jbbz}))>
    and a.code like #{xzqh_gl}||'%' 
 </if>
 <if if(!"1".equals(#{jbbz}))>
    and a.description like #{xzqh_jg}||'%' 
 </if>