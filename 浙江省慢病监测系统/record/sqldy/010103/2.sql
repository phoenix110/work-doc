select id,
       dm,
       mc,
       jc,
       pym,
       wbm,
       lb,
       lb lb_text,
       gljgid,
       xzqh,
       jjlx,
       jjlx jjlx_text,
       lxr,
       lxdh,
       szddz,
       szdxzqh,
       xgsj,
       xgr,
       dts(cjsj,1) cjsj,
       cjr,
       decode(bz, 1, '正常', '-1', '注销', bz) zt_text, 
       ptjgid,
       wtdm,
       zzjgdm,
       total,
       rn
       from (
select id,
       dm,
       mc,
       jc,
       pym,
       wbm,
       lb,
       gljgid,
       xzqh,
       jjlx,
       lxr,
       lxdh,
       szddz,
       szdxzqh,
       xgsj,
       xgr,
       cjsj,
       cjr,
       bz,
       ptjgid,
       wtdm,
       zzjgdm,
       total,
       rownum rn
from(
select id,
       dm,
       mc,
       jc,
       pym,
       wbm,
       lb,
       gljgid,
       xzqh,
       jjlx,
       lxr,
       lxdh,
       szddz,
       szdxzqh,
       xgsj,
       xgr,
       cjsj,
       cjr,
       bz,
       ptjgid,
       wtdm,
       zzjgdm,
       count(1) over() total
  from p_yljg a
 where 1 = 1
 <if if(StringUtils.isNotBlank(#{sjid}))>
   and (a.id = #{sjid} or a.gljgid = #{sjid})
 </if>
 <if if(!"1".equals(#{superadmin}))>
   and a.id in (select id from p_yljg jg start with jg.id = #{czyjgid} connect by jg.gljgid = prior jg.id)
 </if>
 <if if(StringUtils.isNotBlank(#{mc}))>
   and (a.jc like '%'||#{mc} or a.pym like '%'||upper(#{mc})||'%')
 </if>
 <if if(StringUtils.isNotBlank(#{dm}))>
   and a.dm = #{dm}
 </if>
 order by decode(a.id, #{sjid}, 0, 1), a.jc
 ) where rownum <= #{rn_e}
) tt where rn >= #{rn_s}             