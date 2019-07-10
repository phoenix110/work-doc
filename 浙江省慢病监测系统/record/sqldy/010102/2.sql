select id, lx, mc, sm, jgid,  nvl(groupid,0) groupid, groupmc,decode(lx, 1, '系统', 2, '机构', '') ty_text
  from (select 'groupid' || id as id,
               null lx,
               mc mc,
               mc sm,
               a.jgid,
               '' groupid,
               '' groupmc,
               'true' isparent
          from jsgroup a
        union all
        select a.id, a.lx, a.mc, a.sm, a.jgid, 'groupid' || b.id groupid, b.mc groupmc,'fasle' isparent
          from xtjs a, jsgroup b
         where a.jsgroup = b.id(+)
        and (a.lx = '1' or 
        <if if("0".equals(#{xsxj}))>
            a.jgid = #{czyjgid} )
        </if>
        <if if(!"0".equals(#{xsxj}))>
            exists(select 1 from p_yljg jg where jg.bz = 1  start with jg.id = #{dqjgid} connect by jg.gljgid = prior jg.id ) )
        </if>
        <if if(StringUtils.isNotBlank(#{mc}))>
           and a.mc like '%'||#{mc}||'%'
        </if>
        <if if(StringUtils.isNotBlank(#{lx}))>
           and a.lx = #{lx}
        </if>
        <if if(StringUtils.isNotBlank(#{groupid}))>
           and a.jsgroup = #{groupid}
        </if>
        )
 start with groupid is null and lx is null
connect by groupid = prior id    