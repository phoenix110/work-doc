select  /*+INDEX(a INDEX_SHJC_GLDW)*/ nvl(sum(decode(a.vc_shbz, '4', 1, 0)),0) qxshbtg,
       nvl(sum(decode(a.vc_shbz, '3', 1, 0)),0) qxshtg
  from zjmb_shjc_bgk a
 where (a.vc_glbz like #{vc_gldw}||'%' or a.vc_cjdwdm like #{vc_gldw}||'%' or a.vc_jkdw like #{vc_gldw}||'%')
                           and a.vc_scbz = '0'
                        <if if(StringUtils.isNotBlank(#{jgjb}) && "1".equals(#{jgjb}))>
                           and (a.vc_shbz in ('1', '3', '5', '6', '7', '8'))
                        </if>
                        <if if(StringUtils.isNotBlank(#{jgjb}) && "2".equals(#{jgjb}))>
                           and (a.vc_shbz in ('3', '5', '6', '7', '8'))
                        </if> 
                        <if if(StringUtils.isNotBlank(#{vc_bgkid}))>
                           and a.vc_bgkid like #{vc_bgkid}||'%'
                        </if>
                        <if if(StringUtils.isNotBlank(#{vc_xm}))>
                           and a.vc_xm like '%'||#{vc_xm}||'%'
                        </if>
                        <if if(StringUtils.isNotBlank(#{vc_hj}))>
                           and a.vc_hj = #{vc_hj}
                        </if>
                        <if if(StringUtils.isNotBlank(#{vc_shyy}))>
                           and a.vc_shyy = #{vc_shyy}
                        </if>
                        <if if(StringUtils.isNotBlank(#{dt_shrq_ks}))>
                           and a.dt_shrq >= std(#{dt_shrq_ks},1)
                        </if>
                        <if if(StringUtils.isNotBlank(#{dt_shrq_js}))>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
                           and a.dt_shrq <= std(#{dt_shrq_js},1)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
                        </if>              
                        <if if(StringUtils.isNotBlank(#{dt_cjsj_ks}))>
                           and a.dt_cjsj >= std(#{dt_cjsj_ks},1)
                        </if>
                        <if if(StringUtils.isNotBlank(#{dt_cjsj_js}))>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
                           and a.dt_cjsj <= std(#{dt_cjsj_js},1)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
                        </if>
                        <if if(StringUtils.isNotBlank(#{vc_bgkzt}))>
                           and a.vc_bgkzt = #{vc_bgkzt}
                        </if>
                        <if if(StringUtils.isNotBlank(#{vc_shbz}))>
                           and instr(#{vc_shbz},a.vc_shbz) > 0   
                        </if>
                        <if if(StringUtils.isNotBlank(#{vc_zz}))>
                           and a.vc_zz like #{vc_zz}||'%'
                        </if>
                        <if if(StringUtils.isNotBlank(#{vc_jksdm}))>
                           and a.vc_jksdm like #{vc_jksdm}||'%'
                        </if>
                        <if if(StringUtils.isNotBlank(#{vc_jkqxdm}))>
                           and a.vc_jkqxdm like #{vc_jkqxdm}||'%'
                        </if>
                        <if if(StringUtils.isNotBlank(#{vc_jkdw}))>
                           and a.vc_jkdw like #{vc_jkdw}||'%'
                        </if>