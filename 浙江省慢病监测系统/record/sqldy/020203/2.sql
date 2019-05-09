select         a.vc_bgkid as vc_xx_bgkid,
               a.vc_bgkcode vc_bgkbh_text,
               b.vc_hzxm vc_xm_text,
               decode(b.vc_hzxb,'1','男','2','女') vc_xb_text,
               dts(a.dt_swrq,0) dt_swrq_text,
               to_char(b.vc_sznl) vc_sznl_text,
               a.vc_swicd10 vc_gbsy_text,
               a.vc_shbz,
               pkg_zjmb_tnb.fun_getcommdic('C_COMM_SHZT',a.vc_shbz) vc_shbz_text,
               b.vc_hkshen,
               b.vc_hks,
               b.vc_hkqx,
               b.vc_hkjd,
               b.vc_hkjw,
               b.vc_hkxxdz,
               decode(b.vc_hkshen,
              '0',
              '浙江省' ||
              pkg_zjmb_tnb.fun_getxzqhmc(vc_hks) ||
              pkg_zjmb_tnb.fun_getxzqhmc(vc_hkqx) ||
              pkg_zjmb_tnb.fun_getxzqhmc(vc_hkjd) ||
              vc_hkjw || vc_hkxxdz,
              '1',
              '外省') vc_hkdz_text,
               
               '' as  vc_ppzt,
               '糖尿病信息' xsxx,
               'tnb' type
            from zjjk_tnb_bgk a,zjjk_tnb_hzxx b
             where a.vc_hzid = b.vc_personid
                and   (a.vc_cjdw like #{vc_gldw} || '%' or
                        a.vc_gldw like #{vc_gldw} || '%')
                and a.vc_bgkcode = #{vc_bgkcode} 
                and a.vc_shbz in ('3' , '5' , '6' , '7' , '8')    
                and rownum = 1
                            
union all
select 
       vc_bgkid as vc_xx_bgkid,
       vc_bgkid,
       vc_xm,      
       decode(vc_xb,'1','男','2','女') vc_xb_text,           
       dts(dt_swrq,0) dt_swrq_text,
       to_char(vc_sznl) vc_sznl,      
       vc_gbsy,   
       vc_shbz,
        pkg_zjmb_tnb.fun_getcommdic('C_COMM_SHZT',vc_shbz) vc_shbz_text,
       vc_hkqcs,
       vc_hksdm,
       vc_hkqxdm,
       vc_hkjddm,
       vc_hkjw,      
       vc_hkxxdz,
       decode(vc_hkqcs,
              '0',
              '浙江省' ||
              pkg_zjmb_tnb.fun_getxzqhmc(vc_hksdm) ||
              pkg_zjmb_tnb.fun_getxzqhmc(vc_hkqxdm) ||
              pkg_zjmb_tnb.fun_getxzqhmc(vc_hkjddm) ||
              vc_hkjw || vc_hkxxdz,
              '1',
              '外省') vc_hkdz_text,
        
       decode(vc_tnbbfzt,
            '0','未做匹配的',
            '1','匹配到的',
            '2','未匹配到的'
       ) vc_ppzt,    
       '死亡卡信息' xsxx,
       'sw' type
     from zjmb_sw_bgk 
     where vc_bgkid = #{vc_bgkid}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
