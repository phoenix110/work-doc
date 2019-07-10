select count(1) over(partition by
       <if if("1".equals(#{vc_radio}))>
            vc_xm
        </if>
        <if if("2".equals(#{vc_radio}))>
            substr(vc_xm,1,1)||substr(vc_xm,length(vc_xm))
        </if>
        <if if("3".equals(#{vc_radio}))>
            substr(vc_xm,1,2)
        </if>
        <if if("4".equals(#{vc_radio}))>
            substr(vc_xm,length(vc_xm)-1)
        </if>
       
        <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",1,") < 0))>
            , vc_xb
        </if>
        <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",2,") < 0))>
            , vc_nl
        </if>
         <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",3,") < 0))>
            , dt_shrq
        </if>
        <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",4,") < 0))>
            , vc_shyy
        </if>
         <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",5,") < 0))>
            , dt_jzrq
        </if>
       <if if(1 == 1)>
       ) as group_count,
       DENSE_RANK()over(
       order by 
       </if>
        <if if("1".equals(#{vc_radio}))>
            vc_xm
        </if>
        <if if("2".equals(#{vc_radio}))>
            substr(vc_xm,1,1)||substr(vc_xm,length(vc_xm))
        </if>
        <if if("3".equals(#{vc_radio}))>
            substr(vc_xm,1,2)
        </if>
        <if if("4".equals(#{vc_radio}))>
            substr(vc_xm,length(vc_xm)-1)
        </if>
      
        <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",1,") < 0))>
            , vc_xb
        </if>
         <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",2,") < 0))>
            , vc_nl
        </if>
         <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",3,") < 0))>
            , dt_shrq
        </if>
        <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",4,") < 0))>
            , vc_shyy
        </if>
        <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",5,") < 0))>
            , dt_jzrq
        </if>
        <if if(1 == 1)>
       ) as group_no,
       vc_bgkid,
      vc_jkdw,
      (select name from organ_node where code=vc_jkdw) vc_jkdw_mc,
      vc_jkys,
      dt_jksj,
      vc_ccid,
      vc_ckbz,
      vc_xm,
      decode(vc_xb,'1','男','2','女') vc_xb_text,
      vc_xb,
      vc_nl,
      vc_dh,
      vc_mz,
      dt_shrq,
      dt_jzrq,
      vc_hkxxzz,
      vc_hj,
      (select mc from p_tyzdml where fldm = 'DICT_SHJC_HJ' and dm=vc_hj) vc_hj_text,
      vc_zy,
      (select mc from p_tyzdml where fldm = 'DICT_SHJC_ZY' and dm=vc_zy) vc_zy_text,
      vc_fsdd,
      (select mc from p_tyzdml where fldm = 'C_SHJC_FSDD' and dm=vc_fsdd) vc_fsdd_text,
      vc_fsddqt,
      vc_shyy,
      (select mc from p_tyzdml where fldm = 'DICT_SHJC_SSYY' and dm=vc_shyy) vc_shyy_text,
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
      (select mc from p_tyzdml where fldm = 'DICT_SHJC_YZCD' and dm=vc_yzcd) vc_yzcd_text,
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
      dt_bgrq,
      dt_yyshsj,
      vc_gxbz,
      upload_areaeport,
      vc_jksdm,
      vc_jkqxdm, 
       total,
       rn 
  from (select      vc_bgkid,
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
          from (select        a.vc_bgkid,
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
                 where 1=1
                   and a.vc_jkdw like #{vc_gldw}||'%' 
                   and a.vc_bgkzt in ('0','7','2','6') 
                   and a.vc_scbz = '0'
                   and a.vc_shbz in ('1','3','5','6','7','8')             
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_xm}))>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
                           and a.vc_xm = #{vc_xm}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                    </if>
                 
                   <if if(1 == 1)>
                       and (
                   </if>
                   <if if("1".equals(#{vc_radio}))>
                       a.vc_xm
                   </if>
                   <if if("2".equals(#{vc_radio}))>
                       substr(a.vc_xm,1,1)||substr(a.vc_xm,length(a.vc_xm))
                   </if>
                   <if if("3".equals(#{vc_radio}))>
                       substr(a.vc_xm,1,2)
                   </if>
                   <if if("4".equals(#{vc_radio}))>
                       substr(a.vc_xm,length(a.vc_xm)-1)
                   </if>
                   
                   <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",1,") < 0))>
                       , a.vc_xb
                   </if>
                  <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",2,") < 0))>
                      , a.vc_nl
                  </if>
                   <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",3,") < 0))>
                      , a.dt_shrq
                  </if>
                  <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",4,") < 0))>
                      , a.vc_shyy
                  </if>
                  <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",5,") < 0))>
                      , a.dt_jzrq
                  </if>
                   <if if(1 == 1)>
                   ) in (select
                   </if>
                   <if if("1".equals(#{vc_radio}))>
                       a.vc_xm
                   </if>
                   <if if("2".equals(#{vc_radio}))>
                       substr(a.vc_xm,1,1)||substr(a.vc_xm,length(a.vc_xm))
                   </if>
                   <if if("3".equals(#{vc_radio}))>
                       substr(a.vc_xm,1,2)
                   </if>
                   <if if("4".equals(#{vc_radio}))>
                       substr(a.vc_xm,length(a.vc_xm)-1)
                   </if>
                  
                   <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",1,") < 0))>
                       , a.vc_xb
                   </if>
                  <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",2,") < 0))>
                      , a.vc_nl
                  </if>
                   <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",3,") < 0))>
                      , a.dt_shrq
                  </if>
                  <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",4,") < 0))>
                      , a.vc_shyy
                  </if>
                   <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",5,") < 0))>
                      , a.dt_jzrq
                  </if>
                   <if if(1 == 1)>
                      from zjmb_shjc_bgk a
                      where 1=1
                        and a.vc_jkdw like #{vc_gldw}||'%' 
                        and a.vc_scbz = '0'
                        and a.vc_bgkzt in ('0','7','2','6') 
                        and a.vc_shbz in ('1','3','5','6','7','8') 
                   </if>
                  <if if(StringUtils.isNotBlank(#{vc_xm}))>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
                           and a.vc_xm = #{vc_xm}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                    </if>
                   <if if(1 == 1)>
                     group by
                   </if>
                   <if if("1".equals(#{vc_radio}))>
                       a.vc_xm
                   </if>
                   <if if("2".equals(#{vc_radio}))>
                       substr(a.vc_xm,1,1)||substr(a.vc_xm,length(a.vc_xm))
                   </if>
                   <if if("3".equals(#{vc_radio}))>
                       substr(a.vc_xm,1,2)
                   </if>
                   <if if("4".equals(#{vc_radio}))>
                       substr(a.vc_xm,length(a.a.)-1)
                   </if>
                  
                   <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",1,") < 0))>
                       , a.vc_xb
                   </if>
                    <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",2,") < 0))>
                      , a.vc_nl
                  </if>
                   <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",3,") < 0))>
                      , a.dt_shrq
                  </if>
                  <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",4,") < 0))>
                      , a.vc_shyy
                  </if>
                  <if if(StringUtils.isNotBlank(#{vc_checkbox}) && !(#{vc_checkbox}.indexOf(",5,") < 0))>
                      , a.dt_jzrq
                  </if>
                   <if if(1 == 1)>
                       Having count(*) > 1 and comp_group_repeat(wm_concat(vc_ccid), count(1)) = 1)
                   </if>
              )
         where rownum <= #{rn_e})
 where rn >= #{rn_s}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    