select distinct 'group' || a.id id,
                a.mc text,
                '' sjid,
                'true' isParent,
                'true' open,
                'true' chkDisabled
<if if(StringUtils.isNotBlank(#{yhm}))>
  , '' checked
</if>        
<if if(1 == 1)>     
  from jsgroup a, xtjs b
 where a.id = b.jsgroup
   and (a.lx = '1' or a.jgid = #{czyjgid}
</if>
   <if if(StringUtils.isBlank(#{yhm}))>
       )
   </if>
   <if if(StringUtils.isNotBlank(#{yhm}))>
       or a.jgid = #{yhjgid}
       or (b.id in (select jsid
                    from yhjs yhjs
                   where yhjs.jgid = #{yhjgid}
                     and yhjs.yhm = #{yhm})))
   </if>
<if if(1 == 1)>
 union
select js.id, js.mc, 'group' || js.jsgroup sjid, 'false' isParent, '' open, '' chkDisabled
</if>
<if if(StringUtils.isNotBlank(#{yhm}))>
  , case when (select count(1) from yhjs yhjs where yhjs.jsid = js.id and yhjs.jgid = #{yhjgid}
                      and yhjs.yhm = #{yhm}) > 0 then 'true' else '' end checked
</if>
<if if(1 == 1)>
  from xtjs js
  where (js.lx = '1' or js.jgid = #{czyjgid}
</if> 
<if if(StringUtils.isBlank(#{yhm}))>
       )
</if>       
<if if(StringUtils.isNotBlank(#{yhm}))>
    or js.jgid = #{yhjgid} 
    or (js.id in (select jsid
                     from yhjs yhjs
                    where yhjs.jgid = #{yhjgid}
                      and yhjs.yhm = #{yhm})))
</if>