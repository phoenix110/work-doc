select vc_bgkid,
       vc_xm,
       vc_xb,
       vc_csrq,
       vc_fqxm,
       vc_mqxm,
       vc_qfrq,
       vc_mqnl,
       vc_fqnl,
       vc_csd,
       vc_yz,
       vc_jkzk,
       vc_sc,
       vc_tz,
       vc_fqgj,
       vc_fqmz,
       vc_mqgj,
       vc_mqmz,
       vc_fqsfz,
       vc_mqsfz,
       vc_jsjgmc,
       vc_jsr,
       vc_hjszd,
       vc_lxdh,
       vc_jtzz,
       vc_csddfl,
       vc_dryhmc,
       vc_dryhqxdm,
       vc_drsj,
       vc_drbz,
       vc_hjjd,
       vc_drsbyy,
       total,
       rn
 from (select  vc_bgkid,
               vc_xm,
               vc_xb,
               vc_csrq,
               vc_fqxm,
               vc_mqxm,
               vc_qfrq,
               vc_mqnl,
               vc_fqnl,
               vc_csd,
               vc_yz,
               vc_jkzk,
               vc_sc,
               vc_tz,
               vc_fqgj,
               vc_fqmz,
               vc_mqgj,
               vc_mqmz,
               vc_fqsfz,
               vc_mqsfz,
               vc_jsjgmc,
               vc_jsr,
               vc_hjszd,
               vc_lxdh,
               vc_jtzz,
               vc_csddfl,
               vc_dryhmc,
               vc_dryhqxdm,
               vc_drsj,
               vc_drbz,
               vc_hjjd,
               vc_drsbyy,
               total,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
               rownum as rn
           from (select a.vc_bgkid,
                        a.vc_xm,
                        a.vc_xb,
                        a.vc_csrq,
                        a.vc_fqxm,
                        a.vc_mqxm,
                        a.vc_qfrq,
                        a.vc_mqnl,
                        a.vc_fqnl,
                        a.vc_csd,
                        a.vc_yz,
                        a.vc_jkzk,
                        a.vc_sc,
                        a.vc_tz,
                        a.vc_fqgj,
                        a.vc_fqmz,
                        a.vc_mqgj,
                        a.vc_mqmz,
                        a.vc_fqsfz,
                        a.vc_mqsfz,
                        a.vc_jsjgmc,
                        a.vc_jsr,
                        a.vc_hjszd,
                        a.vc_lxdh,
                        a.vc_jtzz,
                        a.vc_csddfl,
                        a.vc_dryhmc,
                        a.vc_dryhqxdm,
                        a.vc_drsj,
                        a.vc_drbz,
                        a.vc_hjjd,
                        a.vc_drsbyy,
                        count(1) over() as total 
                     from zjjk_csbgk_temp a
                     where a.vc_dryhmc like #{vc_gldw}||'%'
                       <if if(StringUtils.isNotBlank(#{vc_drbz}))>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
                           and a.vc_drbz = #{vc_drbz}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
                       </if>     
                       <if if(StringUtils.isNotBlank(#{vc_bgkid}))>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
                           and a.vc_bgkid like #{vc_bgkid}||'%'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
                       </if>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
                       <if if(StringUtils.isNotBlank(#{vc_xm}))>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
                           and a.vc_xm like '%'||#{vc_xm}||'%'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                       </if>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
                       <if if(StringUtils.isNotBlank(#{vc_xb}))>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
                           and a.vc_xb = #{vc_xb}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                       </if> 
                       <if if(StringUtils.isNotBlank(#{dt_drsj_ks}))>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
                           and std(a.vc_drsj,1) >= std(#{dt_drsj_ks},1)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
                       </if>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
                       <if if(StringUtils.isNotBlank(#{dt_drsj_js}))>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
                           and std(a.vc_drsj,1) <= std(#{dt_drsj_js},1)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
                       </if>
                       order by a.vc_hjjd asc )
   where rownum <= #{rn_e})
where rn >= #{rn_s} 
  