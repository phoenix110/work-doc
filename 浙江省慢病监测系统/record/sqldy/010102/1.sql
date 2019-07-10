select id, lx, mc, sm, jgid, groupid, groupmc, total, rn,decode(lx, 1, '系统', '机构') ty_text, decode(zt, 1, '启用', -1, '停用', zt) zt_text
  from (select id, lx, mc, sm, jgid, groupid, groupmc, zt, total, rownum as rn
          from (select a.id,
                       a.lx,
                       a.mc,
                       a.sm,
                       a.jgid,
                       b.id groupid,
                       b.mc groupmc,
                       a.zt,
                       count(1) over() as total
                  from xtjs a, jsgroup b
                 where a.jsgroup = b.id(+)
                  and (a.lx = '1' or a.jgid = #{czyjgid})
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
         where rownum <= #{rn_e})
 where rn >= #{rn_s}                            