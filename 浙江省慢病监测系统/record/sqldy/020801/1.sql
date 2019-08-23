select '糖尿病患者信息' sbxt,
       count(1) as hjsbs,
       nvl(sum(decode(b1.is_pass, 1, 1)),0) zqsbs,
       nvl(sum(decode(b1.is_pass, 2, 1)),0) cwsbs,
       '1' type
  from zjjk_tnb_hzxx_ex_bak b1, zjjk_tnb_bgk_ex_bak b2
 where b1.vc_personid = b2.vc_hzid
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
<if if(1 == 1)>   
union all
select '糖尿病报告卡' sbxt,
       count(1) hjsbs,
       nvl(sum(decode(is_pass, 1, 1)),0) zqsbs,
       nvl(sum(decode(is_pass, 2, 1)),0) cwsbs,
       '2' type
  from zjjk_tnb_bgk_ex_bak b1
 where b1.vc_bgdw = #{vc_bgdw}
</if>
   <if if(StringUtils.isNotBlank(#{dt_drsj_ks}))>
      and b1.validate_date >= std(#{dt_drsj_ks}, 1)
   </if>
   <if if(StringUtils.isNotBlank(#{dt_drsj_js}))>
      and b1.validate_date <= std(#{dt_drsj_js}, 1)
   </if>
   <if if(StringUtils.isNotBlank(#{vc_xm}))>
       and exists(select 1 from zjjk_tnb_hzxx_ex_bak b2 where b2.vc_personid = b1.vc_hzid and  b2.vc_hzxm like #{vc_xm} || '%') 
   </if>
<if if(1 == 1)> 
union all
select '心脑血管报告' sbxt,
       count(1) hjsbs,
       nvl(sum(decode(is_pass, 1, 1)),0) zqsbs,
       nvl(sum(decode(is_pass, 2, 1)),0) cwsbs,
       '3' type
  from zjjk_xnxg_bgk_ex_bak b1
 where b1.vc_bkdwyy = #{vc_bgdw}
 </if>
   <if if(StringUtils.isNotBlank(#{dt_drsj_ks}))>
      and b1.validate_date >= std(#{dt_drsj_ks}, 1)
   </if>
   <if if(StringUtils.isNotBlank(#{dt_drsj_js}))>
      and b1.validate_date <= std(#{dt_drsj_js}, 1)
   </if>
<if if(1 == 1)> 
union all
select '肿瘤患者信息' sbxt,
       count(1) hjsbs,
       nvl(sum(decode(b1.is_pass, 1, 1)),0) zqsbs,
       nvl(sum(decode(b1.is_pass, 2, 1)),0) cwsbs,
       '4' type
  from zjjk_zl_hzxx_ex_bak b1, zjjk_zl_bgk_ex_bak b2
 where b1.vc_personid = b2.vc_hzid
   and b2.vc_bgdw = #{vc_bgdw}
</if>
   <if if(StringUtils.isNotBlank(#{dt_drsj_ks}))>
      and b1.validate_date >= std(#{dt_drsj_ks}, 1)
   </if>
   <if if(StringUtils.isNotBlank(#{dt_drsj_js}))>
      and b1.validate_date <= std(#{dt_drsj_js}, 1)
   </if>
   <if if(StringUtils.isNotBlank(#{vc_xm}))>
       and b1.vc_hzxm like #{vc_xm} || '%'
   </if>
<if if(1 == 1)> 
union all
select '肿瘤报告卡' sbxt,
       count(1) hjsbs,
       nvl(sum(decode(is_pass, 1, 1)),0) zqsbs,
       nvl(sum(decode(is_pass, 2, 1)),0) cwsbs,
       '5' type
  from zjjk_zl_bgk_ex_bak b1
 where b1.vc_bgdw = #{vc_bgdw}
</if>
   <if if(StringUtils.isNotBlank(#{dt_drsj_ks}))>
      and b1.validate_date >= std(#{dt_drsj_ks}, 1)
   </if>
   <if if(StringUtils.isNotBlank(#{dt_drsj_js}))>
      and b1.validate_date <= std(#{dt_drsj_js}, 1)
   </if>
   <if if(StringUtils.isNotBlank(#{vc_xm}))>
       and exists(select 1 from zjjk_zl_hzxx_ex_bak b2 where b2.vc_personid = b1.vc_hzid and  b2.vc_hzxm like #{vc_xm} || '%') 
   </if>
<if if(1 == 1)> 
union all
select '伤害报告卡' sbxt,
       count(1) hjsbs,
       nvl(sum(decode(is_pass, 1, 1)),0) zqsbs,
       nvl(sum(decode(is_pass, 2, 1)),0) cwsbs,
       '6' type
  from zjjk_shjc_bgk_ex_bak b1
 where b1.vc_jkdw = #{vc_bgdw}
</if>
   <if if(StringUtils.isNotBlank(#{dt_drsj_ks}))>
      and b1.validate_date >= std(#{dt_drsj_ks}, 1)
   </if>
   <if if(StringUtils.isNotBlank(#{dt_drsj_js}))>
      and b1.validate_date <= std(#{dt_drsj_js}, 1)
   </if>
   <if if(StringUtils.isNotBlank(#{vc_xm}))>
      and  b1.vc_xm like #{vc_xm} || '%'
   </if>
<if if(1 == 1)> 
union all
select '死因报告卡' sbxt,
       count(1) hjsbs,
       nvl(sum(decode(is_pass, 1, 1)),0) zqsbs,
       nvl(sum(decode(is_pass, 2, 1)),0) cwsbs,
       '7' type
  from zjjk_sw_bgk_ex_bak_new b1
 where b1.vc_bkdw = #{vc_bgdw}
</if>
 <if if(StringUtils.isNotBlank(#{dt_drsj_ks}))>
      and b1.validate_date >= std(#{dt_drsj_ks}, 1)
   </if>
   <if if(StringUtils.isNotBlank(#{dt_drsj_js}))>
      and b1.validate_date <= std(#{dt_drsj_js}, 1)
   </if>
   <if if(StringUtils.isNotBlank(#{vc_xm}))>
     and  b1.vc_szxm like #{vc_xm} || '%'
   </if>                                                                                                                                                                                                        