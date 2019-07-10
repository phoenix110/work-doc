select uuid, vc_bgdw, vc_yywybs, dts(vc_yzsj,1) vc_yzsj, vc_hzxm, vc_cwyy, total, rn
from (
select uuid, vc_bgdw, vc_yywybs, vc_yzsj, vc_hzxm, vc_cwyy, total, rownum rn
from(
select b2.vc_bgdw,
       b1.uuid,
       b1.VC_PERSONID vc_yywybs,
       b1.validate_date vc_yzsj,
       b1.vc_hzxm,
       b1.validate_detail vc_cwyy,
       count(1) over() total
  from zjjk_zl_hzxx_ex_bak b1, zjjk_zl_bgk_ex_bak b2
 where b1.vc_personid = b2.vc_hzid
   and b1.is_pass = '2' 
   and b2.vc_bgdw = #{vc_bgdw}
   <if if(StringUtils.isNotBlank(#{dt_drsj_ks}))>
      and b1.validate_date >= std(#{dt_drsj_ks}, 1)
   </if>
   <if if(StringUtils.isNotBlank(#{dt_drsj_js}))>
      and b1.validate_date <= std(#{dt_drsj_js}, 1)
   </if>
   <if if(StringUtils.isNotBlank(#{vc_xm}))>
      and b1.vc_hzxm like #{vc_xm} || '%'
   </if>
   order by b1.validate_date desc
 ) where rownum <= #{rn_e}
 ) where rn >= #{rn_s}