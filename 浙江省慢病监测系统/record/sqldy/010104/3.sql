select count(1) count from p_ryxx a,xtyh b where a.id = b.ryid(+) and a.jgid = #{yhjgid}
<if if(StringUtils.isNotBlank(yhm))>
  and b.yhm = #{yhm}
</if>
<if if(StringUtils.isNotBlank(xm))>
  and a.xm = #{xm}
</if>
<if if(StringUtils.isNotBlank(sfzh))>
  and a.sfzh = #{sfzh}
</if>