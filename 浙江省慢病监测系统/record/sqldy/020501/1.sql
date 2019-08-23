select 
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_SHEDM', vc_csdd) as vc_csdd_text,
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_SJDM', vc_cssdm) as vc_cssdm_text,
       (select px.mc from p_xzdm px where px.jb = '3' and px.dm = vc_csqxdm) as vc_csqxdm_text,
       (select px.mc from p_xzdm px where px.jb = '4' and px.dm = vc_csjddm) as vc_csjddm_text,
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_SHEDM', vc_hkshfdm) as vc_hkshfdm_text,
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_SJDM', vc_sdm) as vc_sdm_text,
       (select px.mc from p_xzdm px where px.jb = '3' and px.dm = vc_qdm) as vc_qdm_text,
       (select px.mc from p_xzdm px where px.jb = '4' and px.dm = vc_jddm) as vc_jddm_text,
       case when vc_mqgj = '1' then '中国' else vc_mqgjqt end as vc_mqgj_text,
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_MZ', vc_mqmz) as vc_mqmz_text,
       case when vc_fqgj = '1' then '中国' else vc_fqgjqt end as vc_fqgj_text,
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_MZ', vc_fqmz) as vc_fqmz_text,
       (select py.mc from P_YLJG py where py.lb in ('B1', 'A1') and py.dm = vc_jsdw) as vc_jsdw_text,
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_SF', vc_hjhs) as vc_hjhs_text,
       pkg_zjmb_tnb.fun_getcommdic('C_SMTJSW_WHSYY', vc_whsyy) as vc_whsyy_text,
       pkg_zjmb_tnb.fun_getcommdic('C_COMM_SHZT', vc_shbz) as vc_shbz_text,
       vc_bgkid,
       vc_ccid,
       vc_ckbz,
       vc_xsrid,
       vc_jkdw,
       (select d.mc from p_yljg d where d.dm = vc_jkdw) vc_bgdw_mc,
       vc_jkys,
       dt_jksj,
       vc_qyid,
       vc_xsrxb,
       decode(vc_xsrxb,'1','男','2','女') vc_xsrxb_text,
       dt_csrq,
       vc_csyz,
       nb_cstz,
       nb_cssc,
       vc_csxxdz,
       vc_hkd,
       vc_hjhs,
       vc_whsyy,
       vc_jkzt,
       decode(vc_jkzt,
            '1','良好',
            '2','一般',
            '3','差',
            '4','死亡') vc_jkzt_text,
       vc_mqxm,
       vc_mqnl,
       vc_mqgj,
       vc_mqmz,
       vc_mqsfzbh,
       vc_mqhkszd,
       vc_fqxm,
       vc_fqnl,
       vc_fqgj,
       vc_fqmz,
       vc_fqsfzbh,
       vc_fqhkszd,
       vc_jtjzdz,
       vc_csddfl,
       decode(vc_csddfl,
              '0','医院',
              '1','妇幼保健院',
              '2',' 家庭',
              '3','其他') vc_csddfl_text,
       vc_xsrjhrjz,
       vc_jsrqz,
       vc_jsjgmc,
       vc_lxdh,
       vc_yzbm,
       vc_csyyjlbh,
       vc_mqblh,
       vc_scbz,
       vc_gldwdm,
       vc_czdwdm,
       vc_xsrsfch,
       dt_swrq,
       vc_swyy,
       dts(dt_czsj,'0') dt_czsj,
       vc_czyh,
       dt_xgsj,
       vc_xgyh,
       vc_bgklb,
       vc_bz,
       vc_sdm,
       vc_qdm,
       vc_jddm,
       vc_shbz,
       decode(vc_shbz,
               '0',
               '医院未审核',
               '1',
               '医院审核通过',
               '2',
               '医院审核未通过',
               '3',
               '区县审核通过',
               '4',
                '区县审核未通过',
                '5',
                '市审核通过',
                '6',
                '市审核不通过',
                '7',
                '省审核通过',
                '8',
                '省审核不通过',
                vc_shbz) vc_shbz_text,
       vc_khid,
       vc_khzt,
       vc_shid,
       vc_cssdm,
       vc_csqxdm,
       vc_csjddm,
       vc_hkqc,
       vc_qcsdm,
       vc_qcqxdm,
       vc_qcjddm,
       dt_qcsj,
       vc_qcxxdz,
       vc_cszh,
       vc_hkxxdz,
       vc_csjw,
       vc_hkjw,
       vc_fqgjqt,
       vc_mqgjqt,
       vc_csddflqt,
       vc_jsdw,
       dt_qfrq,
       vc_qcjw,
       vc_csdd,
       vc_hkqcd,
       vc_jsdwszs,
       vc_jsdwszq,
       vc_bgkzt,
        decode(vc_bgkzt,
              '0',
              '可用卡',
              '2',
              '死卡',
              '3',
              '误诊卡',
              '4',
              '重复卡',
              '6',
              '失访卡',
              '5',
              '删除卡',
              '7',
              '死亡卡',
              vc_bgkzt) vc_bgkzt_text,
       vc_xxly,
       vc_shzt,
       vc_khbz,
       vc_sdqr,
       vc_khjg,
       vc_hkshfdm,
       decode(vc_hkshfdm,
              '0',
              '浙江省' ||
              pkg_zjmb_tnb.fun_getxzqhmc(vc_sdm) ||
              pkg_zjmb_tnb.fun_getxzqhmc(vc_qdm) ||
              pkg_zjmb_tnb.fun_getxzqhmc(vc_jddm) ||
              vc_hkjw || vc_hkxxdz,
              '1',
              '外省') hjdz_text,
       vc_sfsw,
       vc_shwtgyy,
       vc_shwtgyy1,
       vc_jkdws,
       vc_jkdwqx,
       dts(dt_qxshsj,0) dt_qxshsj,
       dts(dt_yyshsj,0) dt_yyshsj,
       total,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
       rn
  from (select vc_bgkid,
               vc_ccid,
               vc_ckbz,
               vc_xsrid,
               vc_jkdw,
               vc_jkys,
               dt_jksj,
               vc_qyid,
               vc_xsrxb,
               dt_csrq,
               vc_csyz,
               nb_cstz,
               nb_cssc,
               vc_csxxdz,
               vc_hkd,
               vc_hjhs,
               vc_whsyy,
               vc_jkzt,
               vc_mqxm,
               vc_mqnl,
               vc_mqgj,
               vc_mqmz,
               vc_mqsfzbh,
               vc_mqhkszd,
               vc_fqxm,
               vc_fqnl,
               vc_fqgj,
               vc_fqmz,
               vc_fqsfzbh,
               vc_fqhkszd,
               vc_jtjzdz,
               vc_csddfl,
               vc_xsrjhrjz,
               vc_jsrqz,
               vc_jsjgmc,
               vc_lxdh,
               vc_yzbm,
               vc_csyyjlbh,
               vc_mqblh,
               vc_scbz,
               vc_gldwdm,
               vc_czdwdm,
               vc_xsrsfch,
               dt_swrq,
               vc_swyy,
               dt_czsj,
               vc_czyh,
               dt_xgsj,
               vc_xgyh,
               vc_bgklb,
               vc_bz,
               vc_sdm,
               vc_qdm,
               vc_jddm,
               vc_shbz,
               vc_khid,
               vc_khzt,
               vc_shid,
               vc_cssdm,
               vc_csqxdm,
               vc_csjddm,
               vc_hkqc,
               vc_qcsdm,
               vc_qcqxdm,
               vc_qcjddm,
               dt_qcsj,
               vc_qcxxdz,
               vc_cszh,
               vc_hkxxdz,
               vc_csjw,
               vc_hkjw,
               vc_fqgjqt,
               vc_mqgjqt,
               vc_csddflqt,
               vc_jsdw,
               dt_qfrq,
               vc_qcjw,
               vc_csdd,
               vc_hkqcd,
               vc_jsdwszs,
               vc_jsdwszq,
               vc_bgkzt,
               vc_xxly,
               vc_shzt,
               vc_khbz,
               vc_sdqr,
               vc_khjg,
               vc_hkshfdm,
               vc_sfsw,
               vc_shwtgyy,
               vc_shwtgyy1,
               vc_jkdws,
               vc_jkdwqx,
               dt_qxshsj,
               dt_yyshsj,
               total,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
               rownum as rn
        from (select  /*+INDEX(a INDEX_CS_GLDW)*/   a.vc_bgkid,
                       a.vc_ccid,
                       a.vc_ckbz,
                       a.vc_xsrid,
                       a.vc_jkdw,
                       a.vc_jkys,
                       a.dt_jksj,
                       a.vc_qyid,
                       a.vc_xsrxb,
                       a.dt_csrq,
                       a.vc_csyz,
                       a.nb_cstz,
                       a.nb_cssc,
                       a.vc_csxxdz,
                       a.vc_hkd,
                       a.vc_hjhs,
                       a.vc_whsyy,
                       a.vc_jkzt,
                       a.vc_mqxm,
                       a.vc_mqnl,
                       a.vc_mqgj,
                       a.vc_mqmz,
                       a.vc_mqsfzbh,
                       a.vc_mqhkszd,
                       a.vc_fqxm,
                       a.vc_fqnl,
                       a.vc_fqgj,
                       a.vc_fqmz,
                       a.vc_fqsfzbh,
                       a.vc_fqhkszd,
                       a.vc_jtjzdz,
                       a.vc_csddfl,
                       a.vc_xsrjhrjz,
                       a.vc_jsrqz,
                       a.vc_jsjgmc,
                       a.vc_lxdh,
                       a.vc_yzbm,
                       a.vc_csyyjlbh,
                       a.vc_mqblh,
                       a.vc_scbz,
                       a.vc_gldwdm,
                       a.vc_czdwdm,
                       a.vc_xsrsfch,
                       a.dt_swrq,
                       a.vc_swyy,
                       a.dt_czsj,
                       a.vc_czyh,
                       a.dt_xgsj,
                       a.vc_xgyh,
                       a.vc_bgklb,
                       a.vc_bz,
                       a.vc_sdm,
                       a.vc_qdm,
                       a.vc_jddm,
                       a.vc_shbz,
                       a.vc_khid,
                       a.vc_khzt,
                       a.vc_shid,
                       a.vc_cssdm,
                       a.vc_csqxdm,
                       a.vc_csjddm,
                       a.vc_hkqc,
                       a.vc_qcsdm,
                       a.vc_qcqxdm,
                       a.vc_qcjddm,
                       a.dt_qcsj,
                       a.vc_qcxxdz,
                       a.vc_cszh,
                       a.vc_hkxxdz,
                       a.vc_csjw,
                       a.vc_hkjw,
                       a.vc_fqgjqt,
                       a.vc_mqgjqt,
                       a.vc_csddflqt,
                       a.vc_jsdw,
                       a.dt_qfrq,
                       a.vc_qcjw,
                       a.vc_csdd,
                       a.vc_hkqcd,
                       a.vc_jsdwszs,
                       a.vc_jsdwszq,
                       a.vc_bgkzt,
                       a.vc_xxly,
                       a.vc_shzt,
                       a.vc_khbz,
                       a.vc_sdqr,
                       a.vc_khjg,
                       a.vc_hkshfdm,
                       a.vc_sfsw,
                       a.vc_shwtgyy,
                       a.vc_shwtgyy1,
                       a.vc_jkdws,
                       a.vc_jkdwqx,
                       a.dt_qxshsj,
                       a.dt_yyshsj,
                       count(1) over() as total 
                     from zjmb_cs_bgk a
                     where
                     <if if(StringUtils.isNotBlank(#{jgszqh}))>
                         (a.vc_gldwdm like #{vc_gldw}||'%' or a.vc_czdwdm like #{vc_gldw}||'%' or a.vc_jkdw like #{vc_gldw}||'%' or a.vc_jddm like #{jgszqh} || '%')
                     </if>
                     <if if(StringUtils.isBlank(#{jgszqh}))>
                         (a.vc_gldwdm like #{vc_gldw}||'%' or a.vc_czdwdm like #{vc_gldw}||'%' or a.vc_jkdw like #{vc_gldw}||'%')
                     </if>
                     and a.vc_scbz = '2'
                        <if if(StringUtils.isNotBlank(#{jgjb}) && "1".equals(#{jgjb}))>
                           and (a.vc_shbz in ('1', '3', '5', '6', '7', '8'))
                        </if>
                        <if if(StringUtils.isNotBlank(#{jgjb}) && "2".equals(#{jgjb}))>
                           and (a.vc_shbz in ('3', '5', '6', '7', '8'))
                        </if>
                        <if if(StringUtils.isNotBlank(#{vc_bgkid}))>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
                           and a.vc_bgkid like #{vc_bgkid}||'%'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
                         </if>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
                         <if if(StringUtils.isNotBlank(#{vc_xsrid}))>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
                           and a.vc_xsrid like '%'||#{vc_xsrid}||'%'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
                         </if>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
                         <if if(StringUtils.isNotBlank(#{vc_xsrxb}))>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
                           and a.vc_xsrxb = #{vc_xsrxb}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                         </if>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
                          <if if(StringUtils.isNotBlank(#{vc_jkzt}))>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                           and a.vc_jkzt = #{vc_jkzt}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                         </if>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
                          <if if(StringUtils.isNotBlank(#{vc_csddfl}))>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
                           and a.vc_csddfl = #{vc_csddfl}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
                         </if>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
                         <if if(StringUtils.isNotBlank(#{vc_bgkzt}))>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                           and a.vc_bgkzt = #{vc_bgkzt}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
                         </if>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
                         <if if(StringUtils.isNotBlank(#{vc_csyz}))>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
                           and a.vc_csyz = #{vc_csyz}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
                         </if>    
                         <if if(StringUtils.isNotBlank(#{vc_shbz}))>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
                           and instr(#{vc_shbz},a.vc_shbz) > 0                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
                         </if>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
                         <if if(StringUtils.isNotBlank(#{vc_tz_ks}))>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
                           and a.nb_cstz >= #{vc_tz_ks}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
                         </if>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
                         <if if(StringUtils.isNotBlank(#{vc_tz_js}))>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
                           and a.nb_cstz <= #{vc_tz_js}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
                         </if> 
                         <if if(StringUtils.isNotBlank(#{vc_sc_ks}))>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
                           and a.nb_cssc >= #{vc_sc_ks}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
                         </if>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
                         <if if(StringUtils.isNotBlank(#{vc_sc_js}))>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
                           and a.nb_cssc <= #{vc_sc_js}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
                         </if>
                         <if if(StringUtils.isNotBlank(#{vc_mqnl_ks}))>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
                           and a.vc_mqnl >= #{vc_mqnl_ks}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
                         </if>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
                         <if if(StringUtils.isNotBlank(#{vc_mqnl_js}))>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
                           and a.vc_mqnl <= #{vc_mqnl_js}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
                         </if>
                         <if if(StringUtils.isNotBlank(#{dt_csrq_ks}))>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
                           and a.dt_csrq >= std(#{dt_csrq_ks},1)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
                         </if>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
                         <if if(StringUtils.isNotBlank(#{dt_csrq_js}))>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
                           and a.dt_csrq <= std(#{dt_csrq_js},1)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
                         </if>
                         <if if(StringUtils.isNotBlank(#{dt_qfrq_ks}))>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
                           and a.dt_qfrq >= std(#{dt_qfrq_ks},1)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
                         </if>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
                         <if if(StringUtils.isNotBlank(#{dt_qfrq_js}))>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
                           and a.dt_qfrq <= std(#{dt_qfrq_js},1)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
                         </if>
                         <if if(StringUtils.isNotBlank(#{dt_lrrq_ks}))>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
                           and a.dt_czsj >= std(#{dt_lrrq_ks},1)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
                         </if>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
                         <if if(StringUtils.isNotBlank(#{dt_lrrq_js}))>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
                           and a.dt_czsj <= std(#{dt_lrrq_js},1)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
                         </if>
                         <if if(StringUtils.isNotBlank(#{vc_mqxm}))>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
                           and a.vc_mqxm like '%'||#{vc_mqxm}||'%'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
                         </if>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
                         <if if(StringUtils.isNotBlank(#{vc_hkshfdm}))>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
                           and a.vc_hkshfdm = #{vc_hkshfdm}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
                         </if>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
                          <if if(StringUtils.isNotBlank(#{vc_sdm}))>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
                           and a.vc_sdm = #{vc_sdm}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
                         </if>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
                          <if if(StringUtils.isNotBlank(#{vc_qdm}))>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                           and a.vc_qdm = #{vc_qdm}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                         </if>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
                          <if if(StringUtils.isNotBlank(#{vc_jddm}))>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                           and a.vc_jddm = #{vc_jddm}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                         </if>
                          <if if(StringUtils.isNotBlank(#{vc_hkjw}))>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                           and a.vc_hkjw = #{vc_hkjw}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                         </if>
                         <if if(StringUtils.isNotBlank(#{vc_qx}))>
                           and (a.vc_jsdw like #{vc_qx}||'%')
                         </if>
                         <if if(StringUtils.isNotBlank(#{vc_shi}))>
                           and (a.vc_jsdw like #{vc_shi}||'%')
                         </if>
                         <if if(StringUtils.isNotBlank(#{vc_jsdw}))>
                           and (a.vc_jsdw = #{vc_jsdw})
                         </if>
                         
                         <if if("vc_xsrid".equals(#{orderField}) && "asc".equals(#{orderType}))>
                             order by nlssort(a.vc_xsrid, 'NLS_SORT=SCHINESE_PINYIN_M') asc
                         </if>
                         <if if("vc_xsrid".equals(#{orderField}) && "desc".equals(#{orderType}))>
                             order by nlssort(a.vc_xsrid, 'NLS_SORT=SCHINESE_PINYIN_M') desc
                         </if>
                         <if if("vc_bgkid".equals(#{orderField}) && "asc".equals(#{orderType}))>
                             order by a.vc_bgkid asc
                         </if>
                         <if if("vc_bgkid".equals(#{orderField}) && "desc".equals(#{orderType}))>
                             order by a.vc_bgkid desc
                         </if>
                         <if if("dt_czsj".equals(#{orderField}) && "asc".equals(#{orderType}))>
                             order by a.dt_czsj asc
                         </if>
                         <if if("dt_czsj".equals(#{orderField}) && "desc".equals(#{orderType}))>
                             order by a.dt_czsj desc
                         </if>
                         <if if("dt_yyshsj".equals(#{orderField}) && "asc".equals(#{orderType}))>
                             order by a.dt_yyshsj asc
                         </if>
                         <if if("dt_yyshsj".equals(#{orderField}) && "desc".equals(#{orderType}))>
                             order by a.dt_yyshsj desc
                         </if>
                         <if if("dt_qxshsj".equals(#{orderField}) && "asc".equals(#{orderType}))>
                             order by a.dt_qxshsj asc
                         </if>
                         <if if("dt_qxshsj".equals(#{orderField}) && "desc".equals(#{orderType}))>
                             order by a.dt_qxshsj desc
                         </if>                
                         <if if(StringUtils.isBlank(#{orderField}))>
                             order by a.dt_czsj,a.vc_bgkid
                         </if>   
                      )  
    where rownum <= #{rn_e})
where rn >= #{rn_s}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            