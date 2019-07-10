select vc_bgkid,
       vc_bgklx,
       vc_hzid,
       vc_bgkzt,
       vc_icd10,
       dts(dt_bgrq,0) dt_bgrq,
       dts(dt_cjsj,0) dt_cjsj,
       dts(DT_YYSHSJ,0) DT_YYSHSJ,
       dts(DT_QXSHSJ,0) DT_QXSHSJ,
       dts(dt_sfsj,0) dt_sfsj,
       dts(dt_cfsj,0) dt_cfsj,
       vc_sfcf,
       vc_shbz,
       dts(dt_hzcsrq,0) dt_hzcsrq,
       GetAge(dt_hzcsrq) nl,
       vc_hzxm,
       vc_hzxb,
       vc_sfzh,
       VC_HKSFDM,
       VC_HKSDM,
       VC_HKQXDM,
       VC_HKJDDM,
       VC_HKJWDM,
       VC_HKXXDZ,
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
       decode(vc_hzxb, '1', '男', '2', '女') vc_hzxb_text,
       decode(VC_HKSFDM,
              '0',
              '浙江省' ||
              pkg_zjmb_tnb.fun_getxzqhmc(VC_HKSDM) ||
              pkg_zjmb_tnb.fun_getxzqhmc(VC_HKQXDM) ||
              pkg_zjmb_tnb.fun_getxzqhmc(VC_HKJDDM) ||
              VC_HKXXDZ,
              '1',
              '外省') hkdz_text,  
       pkg_zjmb_tnb.fun_getxzqhmc(vc_qrcs) ||
        pkg_zjmb_tnb.fun_getxzqhmc(vc_qrqx) ||
        pkg_zjmb_tnb.fun_getxzqhmc(vc_qrjd) ||
        vc_qrjw||vc_qrxxdz qrdz_text, 
             vc_jtdh,  
       qrqcid,       
               VC_XTLB,      
               vc_qccs,      
               vc_qcqx,      
               vc_qcjd,      
               VC_QRCS,      
               VC_QRQX,      
               VC_QRJD,      
               VC_QRDL,      
               VC_QRJW,      
               VC_QRXXDZ,    
               DT_CLSJ,      
               VC_CLFS,      
               VC_QCR,       
               VC_CLR,       
               VC_ZHXGR,     
               DT_ZHXGSJ,    
               vc_qyid, 
       total,
       rn
  from (select vc_bgkid,
               vc_bgklx,
               vc_hzid,
               vc_shbz,
               vc_bgkzt,
               vc_icd10,
               dt_bgrq,
               dt_cjsj,
               dt_hzcsrq,
               DT_YYSHSJ,
               DT_QXSHSJ,
               dt_sfsj,
               dt_cfsj,
               vc_sfcf,
               vc_hzxm,
               vc_hzxb,
               vc_sfzh,
               VC_HKSFDM,
               VC_HKSDM,
               VC_HKQXDM,
               VC_HKJDDM,
               VC_HKJWDM,
               VC_HKXXDZ,
               vc_jtdh,
               qrqcid,       
               VC_XTLB,      
               vc_qccs,      
               vc_qcqx,      
               vc_qcjd,      
               VC_QRCS,      
               VC_QRQX,      
               VC_QRJD,      
               VC_QRDL,      
               VC_QRJW,      
               VC_QRXXDZ,    
               DT_CLSJ,      
               VC_CLFS,      
               VC_QCR,       
               VC_CLR,       
               VC_ZHXGR,     
               DT_ZHXGSJ,    
               vc_qyid,
               total,
               rownum as rn
          from (select bgk.vc_bgkid,
                       bgk.vc_bgklx,
                       bgk.vc_hzid,
                       bgk.vc_shbz,
                       bgk.vc_bgkzt,
                       bgk.dt_bgrq,
                       bgk.vc_icd10,
                       bgk.vc_sfcf,
                       bgk.dt_cjsj,
                       bgk.DT_YYSHSJ,
                       bgk.DT_QXSHSJ,
                       bgk.DT_SFSJ,
                       bgk.dt_cfsj,
                       hzxx.vc_hzxm,
                       hzxx.vc_hzxb,
                       hzxx.vc_sfzh,
                       hzxx.dt_hzcsrq,
                       hzxx.VC_HKSFDM,
                       hzxx.VC_HKSDM,
                       hzxx.VC_HKQXDM,
                       hzxx.VC_HKJDDM,
                       hzxx.VC_HKJWDM,
                       hzxx.VC_HKXXDZ,
                       hzxx.vc_jtdh,
                       c.VC_ID as qrqcid,
                       c.VC_XTLB,
                       c.vc_qccs,
                       c.vc_qcqx,
                       c.vc_qcjd,
                       c.VC_QRCS,
                       c.VC_QRQX,
                       c.VC_QRJD,
                       c.VC_QRDL,
                       c.VC_QRJW,
                       c.VC_QRXXDZ,
                       c.DT_CLSJ,
                       c.VC_CLFS,
                       c.VC_QCR,
                       c.VC_CLR,
                       c.VC_ZHXGR,
                       c.DT_ZHXGSJ,
                       c.vc_id vc_qyid,
                       count(1) over() as total
                  from ZJJK_ZL_BGK bgk, ZJJK_ZL_HZXX hzxx, zjjk_zl_qrqcb c
                 where bgk.vc_hzid = hzxx.vc_personid 
                   and c.vc_bgkid = bgk.vc_bgkid
                   and bgk.vc_scbz = '0'
                   and c.vc_clfs = '2'
                   and c.vc_qrqx like #{jgqxdm}||'%'
                   and bgk.vc_shbz in ('3','5','6','7','8')
                   <if if(StringUtils.isNotBlank(#{vc_bgkcode}))>
                     and bgk.vc_bgkcode like #{vc_bgkcode}||'%'
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hzxm}))>
                     and hzxx.vc_hzxm like '%'||#{vc_hzxm}||'%'
                   </if>
                   order by bgk.vc_bgkid)
         where rownum <= #{rn_e})
 where rn >= #{rn_s}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                