select vc_bgkid,
       vc_jkdw,
       (select mc from p_yljg where dm=vc_jkdw) vc_jkdw_text,
       vc_jkdw || ' ' || (select mc from p_yljg where dm=vc_jkdw) as vc_jkdw_dc,
       vc_jkys,
       dt_jksj,
       vc_ccid,
       vc_ckbz,
       vc_xm,
       vc_xb,
       decode(vc_xb,'1','男','2','女') vc_xb_text,
       vc_nl,
       vc_nl vc_nl2,
       vc_dh,
       vc_mz,
       dts(dt_shrq,0) dt_shrq,
       dts(dt_jzrq,0) dt_jzrq,
       vc_hkxxzz,
       vc_hj,
       pkg_zjmb_tnb.fun_getcommdic('DICT_SHJC_HJ', vc_hj) as vc_hj_text,
       vc_zy,
       pkg_zjmb_tnb.fun_getcommdic('DICT_SHJC_ZY', vc_zy) as vc_zy_text,
       vc_fsdd,
       vc_fsddqt,
       nvl2(vc_fsdd, pkg_zjmb_tnb.fun_getcommdic('C_SHJC_FSDD', vc_fsdd), vc_fsddqt) as vc_fsdd_text,
       vc_shyy,
       vc_shyyqt,
       nvl2(vc_shyy, pkg_zjmb_tnb.fun_getcommdic('DICT_SHJC_SSYY', vc_shyy), vc_shyyqt) as vc_shyy_text,
       vc_scbz,
       vc_glbz,
       vc_cjdwdm,
       dts(dt_cjsj,0) dt_cjsj,
       vc_cjyh,
       dt_xgsj,
       vc_xgyh,
       vc_shszsm,
       vc_shszsmqt,
       nvl2(vc_shszsm, pkg_zjmb_tnb.fun_getcommdic('DICT_SHJC_SSSZZSM', vc_shszsm), vc_shszsmqt) as vc_shszsm_text,
       vc_yzcd,
       pkg_zjmb_tnb.fun_getcommdic('DICT_SHJC_YZCD', vc_yzcd) as vc_yzcd_text,
       vc_fsqsfyj,
       pkg_zjmb_tnb.fun_getcommdic('DICT_SHJC_FSQSFYJ', vc_fsqsfyj) as vc_fsqsfyj_text,
       vc_brddqk,
       vc_brddqkqt,
       nvl2(vc_brddqk, pkg_zjmb_tnb.fun_getcommdic('DICT_SHJC_BRDDQK', vc_brddqk), vc_brddqkqt) as vc_brddqk_text,
       vc_sfgy,
       pkg_zjmb_tnb.fun_getcommdic('DICT_SHJC_SFGY', vc_sfgy) as vc_sfgy_text,
       vc_jj,
       pkg_zjmb_tnb.fun_getcommdic('DICT_SHJC_JJ', vc_jj) as vc_jj_text,
       vc_sszjtgj,
       vc_sszjtgjqt,
       nvl2(vc_sszjtgj, pkg_zjmb_tnb.fun_getcommdic('DICT_SHJC_SSZDJTGJ', vc_sszjtgj), vc_sszjtgjqt) as vc_sszjtgj_text,
       vc_sszqk,
       vc_sszqkqt,
       nvl2(vc_sszqk, pkg_zjmb_tnb.fun_getcommdic('DICT_SHJC_SSZDQK', vc_sszqk), vc_sszqkqt) as vc_sszqk_text,
       vc_sszhsmfspz,
       vc_sszhsmfspzqt,
       nvl2(vc_sszhsmfspz, pkg_zjmb_tnb.fun_getcommdic('DICT_SHJC_SSZFSPZ', vc_sszhsmfspz), vc_sszhsmfspzqt) as vc_sszhsmfspz_text,
       vc_czjdcsszdwz,
       pkg_zjmb_tnb.fun_getcommdic('DICT_SHJC_SSZWZ', vc_czjdcsszdwz) as vc_czjdcsszdwz_text,
       vc_zwywanqd,
       case when vc_zwywanqd = '1' then '有'
       when vc_zwywanqd = '2' then '无'
       else '' end as vc_zwywanqd_text,
       vc_anqdsy,
       case when vc_anqdsy = '1' then '有'
       when vc_anqdsy = '2' then '无'
       else '' end as vc_anqdsy_text,
       vc_ywbhzz,
       case when vc_ywbhzz = '1' then '有'
       when vc_ywbhzz = '2' then '无'
       else '' end as vc_ywbhzz_text,
       vc_bhzzsy,
       case when vc_bhzzsy = '1' then '有'
       when vc_bhzzsy = '2' then '无'
       else '' end as vc_bhzzsy_text,
       vc_zyxgys,
       vc_zyxgysqt,
       vc_yqzsfsdcs,
       vc_shqy,
       vc_shqyqt,
       vc_sszysrgx,
       vc_sszysrgxqt,
       vc_sygj,
       vc_sygjqt,
       vc_shxz1,
       vc_ssbw1,
       vc_qsx,
       vc_tb,
       vc_xz,
       vc_rzzs,
       vc_ggj,
       vc_sz,
       vc_qg,
       vc_hxd,
       vc_xhd,
       vc_sjxt,
       vc_sjzy,
       vc_shwbyy,
       vc_hzjzkb,
       nvl2(vc_hzjzkb, pkg_zjmb_tnb.fun_getcommdic('DICT_SHJC_HZJZKB', vc_hzjzkb), vc_hzjzkbqt) as vc_hzjzkb_text,
       vc_txyshs,
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
       dts(dt_shsj,0) dt_shsj,
       vc_hzjzkbqt,
       vc_shxz2,
       vc_shxz3,
       vc_ssbw2,
       vc_ssbw3,
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
       vc_jkdwmc,
       vc_khjg,
       vc_khzt,
       vc_khid,
       vc_shid,
       vc_hkjwdm,
       vc_hkjddm,
       vc_hkqxdm,
       vc_hksdm,
       vc_hjqt,
       vc_zyqt,
       vc_sfjdc,
       vc_sfzs,
       vc_sfytrgyzc,
       vc_zz,
       vc_id,
       vc_shzt,
       vc_shwtgyy,
       vc_shwtgyy1,
       vc_shxzmc1,
       vc_ssbwmc1,
       vc_shxzmc2,
       vc_shxzmc3,
       vc_ssbwmc2,
       vc_ssbwmc3,
       dts(dt_bgrq,0) dt_bgrq,
       dts(dt_yyshsj,0) dt_yyshsj,
       vc_gxbz,
       upload_areaeport,
       vc_jksdm,
       vc_jkqxdm,
       total,
       rn
  from (select vc_bgkid,
               vc_jkdw,
               vc_jkys,
               dt_jksj,
               vc_ccid,
               vc_ckbz,
               vc_xm,
               vc_xb,
               vc_nl,
               vc_dh,
               vc_mz,
               dt_shrq,
               dt_jzrq,
               vc_hkxxzz,
               vc_hj,
               vc_zy,
               vc_fsdd,
               vc_fsddqt,
               vc_shyy,
               vc_shyyqt,
               vc_scbz,
               vc_glbz,
               vc_cjdwdm,
               dt_cjsj,
               vc_cjyh,
               dt_xgsj,
               vc_xgyh,
               vc_shszsm,
               vc_shszsmqt,
               vc_yzcd,
               vc_fsqsfyj,
               vc_brddqk,
               vc_brddqkqt,
               vc_sfgy,
               vc_jj,
               vc_sszjtgj,
               vc_sszjtgjqt,
               vc_sszqk,
               vc_sszqkqt,
               vc_sszhsmfspz,
               vc_sszhsmfspzqt,
               vc_czjdcsszdwz,
               vc_zwywanqd,
               vc_anqdsy,
               vc_ywbhzz,
               vc_bhzzsy,
               vc_zyxgys,
               vc_zyxgysqt,
               vc_yqzsfsdcs,
               vc_shqy,
               vc_shqyqt,
               vc_sszysrgx,
               vc_sszysrgxqt,
               vc_sygj,
               vc_sygjqt,
               vc_shxz1,
               vc_ssbw1,
               vc_qsx,
               vc_tb,
               vc_xz,
               vc_rzzs,
               vc_ggj,
               vc_sz,
               vc_qg,
               vc_hxd,
               vc_xhd,
               vc_sjxt,
               vc_sjzy,
               vc_shwbyy,
               vc_hzjzkb,
               vc_txyshs,
               vc_shbz,
               dt_shsj,
               vc_hzjzkbqt,
               vc_shxz2,
               vc_shxz3,
               vc_ssbw2,
               vc_ssbw3,
               vc_bgkzt,
               vc_jkdwmc,
               vc_khjg,
               vc_khzt,
               vc_khid,
               vc_shid,
               vc_hkjwdm,
               vc_hkjddm,
               vc_hkqxdm,
               vc_hksdm,
               vc_hjqt,
               vc_zyqt,
               vc_sfjdc,
               vc_sfzs,
               vc_sfytrgyzc,
               vc_zz,
               vc_id,
               vc_shzt,
               vc_shwtgyy,
               vc_shwtgyy1,
               vc_shxzmc1,
               vc_ssbwmc1,
               vc_shxzmc2,
               vc_shxzmc3,
               vc_ssbwmc2,
               vc_ssbwmc3,
               dt_bgrq,
               dt_yyshsj,
               vc_gxbz,
               upload_areaeport,
               vc_jksdm,
               vc_jkqxdm,
               total,
               rownum as rn
              from(select /*+INDEX(a INDEX_SHJC_GLDW)*/  a.vc_bgkid,
                           a.vc_jkdw,
                           a.vc_jkys,
                           a.dt_jksj,
                           a.vc_ccid,
                           a.vc_ckbz,
                           a.vc_xm,
                           a.vc_xb,
                           a.vc_nl,
                           a.vc_dh,
                           a.vc_mz,
                           a.dt_shrq,
                           a.dt_jzrq,
                           a.vc_hkxxzz,
                           a.vc_hj,
                           a.vc_zy,
                           a.vc_fsdd,
                           a.vc_fsddqt,
                           a.vc_shyy,
                           a.vc_shyyqt,
                           a.vc_scbz,
                           a.vc_glbz,
                           a.vc_cjdwdm,
                           a.dt_cjsj,
                           a.vc_cjyh,
                           a.dt_xgsj,
                           a.vc_xgyh,
                           a.vc_shszsm,
                           a.vc_shszsmqt,
                           a.vc_yzcd,
                           a.vc_fsqsfyj,
                           a.vc_brddqk,
                           a.vc_brddqkqt,
                           a.vc_sfgy,
                           a.vc_jj,
                           a.vc_sszjtgj,
                           a.vc_sszjtgjqt,
                           a.vc_sszqk,
                           a.vc_sszqkqt,
                           a.vc_sszhsmfspz,
                           a.vc_sszhsmfspzqt,
                           a.vc_czjdcsszdwz,
                           a.vc_zwywanqd,
                           a.vc_anqdsy,
                           a.vc_ywbhzz,
                           a.vc_bhzzsy,
                           a.vc_zyxgys,
                           a.vc_zyxgysqt,
                           a.vc_yqzsfsdcs,
                           a.vc_shqy,
                           a.vc_shqyqt,
                           a.vc_sszysrgx,
                           a.vc_sszysrgxqt,
                           a.vc_sygj,
                           a.vc_sygjqt,
                           a.vc_shxz1,
                           a.vc_ssbw1,
                           a.vc_qsx,
                           a.vc_tb,
                           a.vc_xz,
                           a.vc_rzzs,
                           a.vc_ggj,
                           a.vc_sz,
                           a.vc_qg,
                           a.vc_hxd,
                           a.vc_xhd,
                           a.vc_sjxt,
                           a.vc_sjzy,
                           a.vc_shwbyy,
                           a.vc_hzjzkb,
                           a.vc_txyshs,
                           a.vc_shbz,
                           a.dt_shsj,
                           a.vc_hzjzkbqt,
                           a.vc_shxz2,
                           a.vc_shxz3,
                           a.vc_ssbw2,
                           a.vc_ssbw3,
                           a.vc_bgkzt,
                           a.vc_jkdwmc,
                           a.vc_khjg,
                           a.vc_khzt,
                           a.vc_khid,
                           a.vc_shid,
                           a.vc_hkjwdm,
                           a.vc_hkjddm,
                           a.vc_hkqxdm,
                           a.vc_hksdm,
                           a.vc_hjqt,
                           a.vc_zyqt,
                           a.vc_sfjdc,
                           a.vc_sfzs,
                           a.vc_sfytrgyzc,
                           a.vc_zz,
                           a.vc_id,
                           a.vc_shzt,
                           a.vc_shwtgyy,
                           a.vc_shwtgyy1,
                           a.vc_shxzmc1,
                           a.vc_ssbwmc1,
                           a.vc_shxzmc2,
                           a.vc_shxzmc3,
                           a.vc_ssbwmc2,
                           a.vc_ssbwmc3,
                           a.dt_bgrq,
                           a.dt_yyshsj,
                           a.vc_gxbz,
                           a.upload_areaeport,
                           a.vc_jksdm,
                           a.vc_jkqxdm,
                           count(1) over() as total
                        from zjmb_shjc_bgk a
                        where a.vc_scbz = '0'
                   <if if("A1".equals(#{jglx}))>
                       and a.vc_jkdw like #{vc_gldw} || '%'
                   </if>
                   <if if("B1".equals(#{jglx}))>
                       and ((a.vc_shbz = '1' and a.vc_jkdw like #{vc_gldw} || '%') or 
                       (a.vc_shbz != '1' and (a.vc_glbz like #{vc_gldw}||'%' or a.vc_cjdwdm like #{vc_gldw}||'%' or a.vc_jkdw like #{vc_gldw}||'%')))
                   </if>
                   <if if(!"A1".equals(#{jglx}) && !"B1".equals(#{jglx}))>
                       and (a.vc_glbz like #{vc_gldw}||'%' or a.vc_cjdwdm like #{vc_gldw}||'%' or a.vc_jkdw like #{vc_gldw}||'%')
                   </if>     
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
                        <if if(StringUtils.isNotBlank(#{vc_shbz}) && !#{vc_shbz}.contains(","))>
                             and a.vc_shbz = #{vc_shbz}
                         </if>
                         <if if(StringUtils.isNotBlank(#{vc_shbz}) && #{vc_shbz}.contains(","))>
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
                        
                        <if if("vc_xm".equals(#{orderField}) && "asc".equals(#{orderType}))>
                            order by nlssort(a.vc_xm, 'NLS_SORT=SCHINESE_PINYIN_M') asc
                        </if>
                        <if if("vc_xm".equals(#{orderField}) && "desc".equals(#{orderType}))>
                            order by nlssort(a.vc_xm, 'NLS_SORT=SCHINESE_PINYIN_M') desc
                        </if>
                        <if if("vc_bgkid".equals(#{orderField}) && "asc".equals(#{orderType}))>
                            order by a.vc_bgkid asc
                        </if>
                        <if if("vc_bgkid".equals(#{orderField}) && "desc".equals(#{orderType}))>
                            order by a.vc_bgkid desc
                        </if>
                        <if if("dt_yyshsj".equals(#{orderField}) && "asc".equals(#{orderType}))>
                            order by a.dt_yyshsj asc
                        </if>
                        <if if("dt_yyshsj".equals(#{orderField}) && "desc".equals(#{orderType}))>
                            order by a.dt_yyshsj desc
                        </if>
                        <if if("dt_shsj".equals(#{orderField}) && "asc".equals(#{orderType}))>
                            order by a.dt_shsj asc
                        </if>
                        <if if("dt_shsj".equals(#{orderField}) && "desc".equals(#{orderType}))>
                            order by a.dt_shsj desc
                        </if>
                        <if if("dt_cjsj".equals(#{orderField}) && "asc".equals(#{orderType}))>
                            order by a.dt_cjsj asc
                        </if>
                        <if if("dt_cjsj".equals(#{orderField}) && "desc".equals(#{orderType}))>
                            order by a.dt_cjsj desc
                        </if>                    
                        <if if(StringUtils.isBlank(#{orderField}))>
                            order by a.dt_cjsj
                        </if>
                        )
     where rownum <= #{rn_e})
 where rn >= #{rn_s}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        