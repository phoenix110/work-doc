select         a.vc_bgkid as vc_xx_bgkid,
               a.vc_bgkid vc_bgkbh_text,
               b.vc_hzxm vc_xm_text,
               decode(b.vc_hzxb,'1','男','2','女') vc_xb_text,
               dts(a.dt_swrq,0) dt_swrq_text,
               to_char(a.vc_bksznl) vc_sznl_text,
               a.vc_swicd10 vc_gbsy_text,
               a.vc_shbz,
                decode(a.vc_shbz,
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
                a.vc_shbz) vc_shbz_text,
               b.vc_hksfdm,
               b.vc_hksdm,
               b.vc_hkqxdm,
               b.vc_hkjddm,
               b.vc_hkjwdm,
               b.vc_hkxxdz,
               decode(b.vc_hksfdm,
              '0',
              '浙江省' ||
              pkg_zjmb_tnb.fun_getxzqhmc(b.vc_hksdm) ||
              pkg_zjmb_tnb.fun_getxzqhmc(b.vc_hkqxdm) ||
              pkg_zjmb_tnb.fun_getxzqhmc(b.vc_hkjddm) ||
              b.vc_hkjwdm || b.vc_hkxxdz,
              '1',
              '外省') vc_hkdz_text,
               
               '' as  vc_ppzt,
               '肿瘤信息' xsxx,
               'zl' type
            from zjjk_zl_bgk a,zjjk_zl_hzxx b
             where a.vc_hzid = b.vc_personid
                and   (a.vc_cjdw like #{vc_gldw} || '%' or
                        a.vc_gldw like #{vc_gldw} || '%')
                and a.vc_bgkid = #{vc_zl_bgkid} 
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
       decode(vc_zlbfzt,
            '0','未做匹配的',
            '1','匹配到的',
            '2','未匹配到的'
       ) vc_ppzt,    
       '死亡卡信息' xsxx,
       'sw' type
     from zjmb_sw_bgk 
     where vc_bgkid = #{vc_bgkid}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
