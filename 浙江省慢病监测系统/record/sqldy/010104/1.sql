select tt.xm,
       tt.id,
       tt.sfzh,
       tt.xb,
       decode(tt.xb, '1', '男', '2', '女', tt.xb) xb_text,
       tt.lxdh,
       tt.zt,
       decode(tt.zt, 1, '正常', -1, '停用', tt.zt) zt_text,
       tt.jgid yhjgid,
       tt.yhm,
       tt.dm,
       tt.csrq,
       tt.total,
       tt.rn,
       jg.mc jgmc,
       wm_concat((select mc from xtjs js where js.id = yh.jsid)) jsmc
  from (select xm, id, sfzh, xb, lxdh, zt, yhm, jgid, dm, csrq, total, rownum rn
          from (select b.xm,
                       b.id,
                       b.sfzh,
                       b.xb,
                       b.lxdh,
                       a.zt,
                       a.yhm,
                       a.jgid,
                       b.dm,
                       b.csrq,
                       count(1) over() as total
                  from xtyh a, p_ryxx b
                 where a.ryid = b.id
                   and nvl(a.issuperadmin, 0) <> 1
                <if if(!"1".equals(#{superadmin}))>
                  and a.jgid in (select id from p_yljg jg start with jg.id = #{czyjgid} connect by jg.gljgid = prior jg.id)
                </if>
                <if if(StringUtils.isNotBlank(#{xzjgid}))>
                  and a.jgid = #{xzjgid}
                </if>
                <if if(StringUtils.isNotBlank(#{yhm}))>
                  and upper(a.yhm) like '%'||upper(#{yhm})||'%'
                </if>
                <if if(StringUtils.isNotBlank(#{xm}))>
                  and (b.xm like '%'||#{xm}||'%' or b.pym like '%'||upper(#{xm})||'%')
                </if>
                )
         where rownum <= #{rn_e}) tt,
       yhjs yh,
       p_yljg jg
 where rn >= #{rn_s}
   and tt.yhm = yh.yhm(+)
   and tt.jgid = yh.jgid(+)
   and tt.jgid = jg.id
 group by tt.xm,
          tt.id,
          tt.sfzh,
          tt.xb,
          tt.lxdh,
          tt.zt,
          tt.jgid,
          tt.yhm,
          tt.dm,
          tt.csrq,
          tt.total,
          tt.rn,
          jg.mc        
     order by tt.rn                        