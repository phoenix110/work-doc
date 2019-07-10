select cjrxm, dts(cjsj,1) cjsj, xzqx, oname, fileid, total, rn
  from (select cjrxm, cjsj, xzqx, oname, fileid, total, rownum rn
          from (select a.cjrxm,
                       a.cjsj,
                       a.xzqx,
                       b.oname,
                       a.fileid,
                       count(1) over() total
                  from zjjk_file_xzgl a, t_file_source b
                 where a.fileid = b.id
                  <if if("省疾控".equals(#{jgjbmc}))>
                    and 1 = 1
                  </if>
                  <if if(!"省疾控".equals(#{jgjbmc}))>
                    and a.xzqx like '%' || #{jgjbmc} || '%'
                  </if>
                  <if if(StringUtils.isBlank(#{jgjbmc}))>
                    and 1 = 2
                  </if>
                  <if if(StringUtils.isNotBlank(#{dt_drsj_ks}))>
                    and a.cjsj >= std(#{dt_drsj_ks},1)
                  </if>
                  <if if(StringUtils.isNotBlank(#{dt_drsj_js}))>
                    and a.cjsj <= std(#{dt_drsj_js},1)
                  </if>
                  
                  <if if(StringUtils.isNotBlank(#{gjz}))>
                    and b.oname like #{gjz}||'%'
                  </if>
              order by a.cjsj desc
                   )
         where rownum <= #{rn_e})
 where rn >= #{rn_s}       