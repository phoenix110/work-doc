select vc_bgkid,
       VC_CCID,
       VC_CKBZ,
       VC_QYID,
       vc_xm,
       VC_JKDW,
       NB_JKYYBM,
       VC_SDQR,
       VC_JKYS,
       dts(DT_JKSJ,0) DT_JKSJ,
       vc_xb,
       VC_MZ,
       VC_ZY,
       VC_HJDZLX,
       VC_HJDZ,
       VC_HJDZBM,
       VC_HKQCS,
       VC_HKSDM,
       VC_HKQXDM,
       VC_HKJDDM,
       VC_HKXXDZ,
       VC_HYZK,
       VC_WHCD,
       dts(DT_SWRQ,0) DT_SWRQ,
       vc_sznl,
       VC_SFZHM,
       VC_RQFL,
       pkg_zjmb_tnb.fun_getcommdic('C_SMTJSW_SWDD', VC_SWDD) VC_SWDD,
       VC_SQCZDZLX,
       VC_SQXXDZ,
       VC_SQZGZDDW,
       VC_ICDBM,
       VC_ZDYJ,
       VC_GBSY,
       NB_GBSYBM,
       VC_QTJBZD,
       NB_QTJBZDICD,
       VC_JSXM,
       VC_JSLXDH,
       VC_JSDZ,
       VC_BGKLB,
       VC_ZYH,
       VC_SCBZ,
       VC_GLDWDM,
       VC_CJDWDM,
       dts(DT_CJSJ,0) DT_CJSJ,
       VC_CJYH,
       dts(DT_CJSJ,0) DT_CJSJ,
       VC_XGYH,
       VC_XXLY,
       VC_SHZT,
       VC_AZJSWJB,
       NB_AZJSWJBICD,
       VC_AFBDSWSJJG,
       VC_AFBDSWSJDW,
       VC_BZJSWJB,
       NB_BZJSWJBIDC,
       VC_BFBDSWSJJG,
       VC_BFBDSWSJDW,
       VC_CZJSWJB,
       NB_CZJSWJBICD,
       VC_CFBDSWSJJG,
       VC_CFBDSWSJDW,
       VC_DZJSWJB,
       NB_DAJSWJBICD,
       VC_DFBDSWSJJG,
       VC_DFBDSWSJDW,
       VC_EZJSWJB,
       NB_EAJSWJBICD,
       VC_EFBDSWSJJG,
       VC_EFBDSWSJDW,
       VC_FZJSWJB,
       NB_FAJSWJBICD,
       VC_FFBDSWSJJG,
       VC_FFBDSWSJDW,
       VC_GZJSWJB,
       NB_GAJSWJBICD,
       VC_GFBDSWSJJG,
       VC_GFBDSWSJDW,
       VC_SZSQBLJZZTZ,
       VC_BDCZXM,
       VC_YSZGX,
       VC_LXDZHGZDW,
       VC_BDCZDH,
       VC_SYTD,
       VC_BDCZQM,
       dts(DT_DCRQ,0) DT_DCRQ,
       dts(DT_SCSJ,0) DT_SCSJ,
       dts(DT_SFSJ,0) DT_SFSJ,
       dts(DT_LRSJ,0) DT_LRSJ,
       VC_LRRID,
       VC_SHBZ,
       dts(DT_SHSJ,0) DT_SHSJ,
       dts(DT_YYSHSJ,0) DT_YYSHSJ,
       VC_KPZT,
       VC_KPLY,
       VC_SHID,
       VC_KHID,
       VC_KHZT,
       VC_KHJG,
       VC_HKJW,
       VC_QCJW,
       VC_CSSDM,
       VC_CSQXDM,
       VC_CSJDDM,
       VC_QCSDM,
       VC_QCQXDM,
       VC_QCJDDM,
       VC_HKQC,
       dts(DT_QCSJ,0) DT_QCSJ,
       dts(DT_CSRQ,0) DT_CSRQ,
       dts(DT_QXZSSJ,0) DT_QXZSSJ,
       VC_WBSWYY,
       VC_EBM,
       VC_YSQM,
       decode(vc_hkhs, '1', '1-否', '2', '2-是') VC_HKHS,
       VC_WHSYY,
       VC_BZ,
       VC_QCXXDZ,
       FENLEITJ,
       FENLEITJMC,
       VC_XNXGBFZT,
       VC_TNBBFZT,
       VC_QCSFDM,
       VC_ZLBFZT,
       VC_AZJSWJB1,
       VC_BZJSWJB1,
       VC_CZJSWJB1,
       VC_DZJSWJB1,
       VC_EZJSWJB1,
       VC_FZJSWJB1,
       VC_GZJSWJB1,
       VC_SHWTGYY,
       VC_SHWTGYY1,
       VC_DYQBH,
       
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
       decode(vc_bgklb,
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
              vc_bgklb) vc_bgklb_text,
       decode(vc_xb, '1', '男', '2', '女') vc_xb_text,
        decode(vc_hkqcs,
              '0',
              '浙江省'
              ||pkg_zjmb_tnb.fun_getxzqhmc(vc_hksdm)
              ||pkg_zjmb_tnb.fun_getxzqhmc(vc_hkqxdm)
              ||pkg_zjmb_tnb.fun_getxzqhmc(vc_hkjddm)
              ||vc_hkjw || vc_hkxxdz,
              '1',
              '外省') hkdz_text,
       total,
       rn

  from (select VC_BGKID,
               VC_CCID,
               VC_CKBZ,
               VC_QYID,
               VC_XM,
               VC_JKDW,
               NB_JKYYBM,
               VC_SDQR,
               VC_JKYS,
               DT_JKSJ,
               VC_XB,
               VC_MZ,
               VC_ZY,
               VC_HJDZLX,
               VC_HJDZ,
               VC_HJDZBM,
               VC_HKQCS,
               VC_HKSDM,
               VC_HKQXDM,
               VC_HKJDDM,
               VC_HKXXDZ,
               VC_HYZK,
               VC_WHCD,
               DT_SWRQ,
               VC_SZNL,
               VC_SFZHM,
               VC_RQFL,
               VC_SWDD,
               VC_SQCZDZLX,
               VC_SQXXDZ,
               VC_SQZGZDDW,
               VC_ICDBM,
               VC_ZDYJ,
               VC_GBSY,
               NB_GBSYBM,
               VC_QTJBZD,
               NB_QTJBZDICD,
               VC_JSXM,
               VC_JSLXDH,
               VC_JSDZ,
               VC_BGKLB,
               VC_ZYH,
               VC_SCBZ,
               VC_GLDWDM,
               VC_CJDWDM,
               DT_CJSJ,
               VC_CJYH,
               DT_XGSJ,
               VC_XGYH,
               VC_XXLY,
               VC_SHZT,
               VC_AZJSWJB,
               NB_AZJSWJBICD,
               VC_AFBDSWSJJG,
               VC_AFBDSWSJDW,
               VC_BZJSWJB,
               NB_BZJSWJBIDC,
               VC_BFBDSWSJJG,
               VC_BFBDSWSJDW,
               VC_CZJSWJB,
               NB_CZJSWJBICD,
               VC_CFBDSWSJJG,
               VC_CFBDSWSJDW,
               VC_DZJSWJB,
               NB_DAJSWJBICD,
               VC_DFBDSWSJJG,
               VC_DFBDSWSJDW,
               VC_EZJSWJB,
               NB_EAJSWJBICD,
               VC_EFBDSWSJJG,
               VC_EFBDSWSJDW,
               VC_FZJSWJB,
               NB_FAJSWJBICD,
               VC_FFBDSWSJJG,
               VC_FFBDSWSJDW,
               VC_GZJSWJB,
               NB_GAJSWJBICD,
               VC_GFBDSWSJJG,
               VC_GFBDSWSJDW,
               VC_SZSQBLJZZTZ,
               VC_BDCZXM,
               VC_YSZGX,
               VC_LXDZHGZDW,
               VC_BDCZDH,
               VC_SYTD,
               VC_BDCZQM,
               DT_DCRQ,
               DT_SCSJ,
               DT_SFSJ,
               DT_LRSJ,
               VC_LRRID,
               VC_SHBZ,
               DT_SHSJ,
               DT_YYSHSJ,
               VC_KPZT,
               VC_KPLY,
               VC_SHID,
               VC_KHID,
               VC_KHZT,
               VC_KHJG,
               VC_HKJW,
               VC_QCJW,
               VC_CSSDM,
               VC_CSQXDM,
               VC_CSJDDM,
               VC_QCSDM,
               VC_QCQXDM,
               VC_QCJDDM,
               VC_HKQC,
               DT_QCSJ,
               DT_CSRQ,
               DT_QXZSSJ,
               VC_WBSWYY,
               VC_EBM,
               VC_YSQM,
               VC_HKHS,
               VC_WHSYY,
               VC_BZ,
               VC_QCXXDZ,
               FENLEITJ,
               FENLEITJMC,
               VC_XNXGBFZT,
               VC_TNBBFZT,
               VC_QCSFDM,
               VC_ZLBFZT,
               VC_AZJSWJB1,
               VC_BZJSWJB1,
               VC_CZJSWJB1,
               VC_DZJSWJB1,
               VC_EZJSWJB1,
               VC_FZJSWJB1,
               VC_GZJSWJB1,
               VC_SHWTGYY,
               VC_SHWTGYY1,
               VC_DYQBH,
               VC_ZJLX,
               VC_RSQK,
               VC_WSHKSHENDM,
               VC_WSHKSDM,
               VC_WSHKQXDM,
               VC_WSHKJDDM,
               VC_WSHKJW,
               VC_JZQCS,
               VC_JZSDM,
               VC_JZQXDM,
               VC_JZJDDM,
               VC_JZJW,
               VC_WSJZSHENDM,
               VC_WSJZSDM,
               VC_WSJZQXDM,
               VC_WSJZJDDM,
               VC_WSJZJW,
               VC_GJHDQ,
               
               total,
               rownum as rn
          from (select sw_bgk.VC_BGKID,
                       sw_bgk.VC_CCID,
                       sw_bgk.VC_CKBZ,
                       sw_bgk.VC_QYID,
                       sw_bgk.VC_XM,
                       sw_bgk.VC_JKDW,
                       sw_bgk.NB_JKYYBM,
                       sw_bgk.VC_SDQR,
                       sw_bgk.VC_JKYS,
                       sw_bgk.DT_JKSJ,
                       sw_bgk.VC_XB,
                       sw_bgk.VC_MZ,
                       sw_bgk.VC_ZY,
                       sw_bgk.VC_HJDZLX,
                       sw_bgk.VC_HJDZ,
                       sw_bgk.VC_HJDZBM,
                       sw_bgk.VC_HKQCS,
                       sw_bgk.VC_HKSDM,
                       sw_bgk.VC_HKQXDM,
                       sw_bgk.VC_HKJDDM,
                       sw_bgk.VC_HKXXDZ,
                       sw_bgk.VC_HYZK,
                       sw_bgk.VC_WHCD,
                       sw_bgk.DT_SWRQ,
                       sw_bgk.VC_SZNL,
                       sw_bgk.VC_SFZHM,
                       sw_bgk.VC_RQFL,
                       sw_bgk.VC_SWDD,
                       sw_bgk.VC_SQCZDZLX,
                       sw_bgk.VC_SQXXDZ,
                       sw_bgk.VC_SQZGZDDW,
                       sw_bgk.VC_ICDBM,
                       sw_bgk.VC_ZDYJ,
                       sw_bgk.VC_GBSY,
                       sw_bgk.NB_GBSYBM,
                       sw_bgk.VC_QTJBZD,
                       sw_bgk.NB_QTJBZDICD,
                       sw_bgk.VC_JSXM,
                       sw_bgk.VC_JSLXDH,
                       sw_bgk.VC_JSDZ,
                       sw_bgk.VC_BGKLB,
                       sw_bgk.VC_ZYH,
                       sw_bgk.VC_SCBZ,
                       sw_bgk.VC_GLDWDM,
                       sw_bgk.VC_CJDWDM,
                       sw_bgk.DT_CJSJ,
                       sw_bgk.VC_CJYH,
                       sw_bgk.DT_XGSJ,
                       sw_bgk.VC_XGYH,
                       sw_bgk.VC_XXLY,
                       sw_bgk.VC_SHZT,
                       sw_bgk.VC_AZJSWJB,
                       sw_bgk.NB_AZJSWJBICD,
                       sw_bgk.VC_AFBDSWSJJG,
                       sw_bgk.VC_AFBDSWSJDW,
                       sw_bgk.VC_BZJSWJB,
                       sw_bgk.NB_BZJSWJBIDC,
                       sw_bgk.VC_BFBDSWSJJG,
                       sw_bgk.VC_BFBDSWSJDW,
                       sw_bgk.VC_CZJSWJB,
                       sw_bgk.NB_CZJSWJBICD,
                       sw_bgk.VC_CFBDSWSJJG,
                       sw_bgk.VC_CFBDSWSJDW,
                       sw_bgk.VC_DZJSWJB,
                       sw_bgk.NB_DAJSWJBICD,
                       sw_bgk.VC_DFBDSWSJJG,
                       sw_bgk.VC_DFBDSWSJDW,
                       sw_bgk.VC_EZJSWJB,
                       sw_bgk.NB_EAJSWJBICD,
                       sw_bgk.VC_EFBDSWSJJG,
                       sw_bgk.VC_EFBDSWSJDW,
                       sw_bgk.VC_FZJSWJB,
                       sw_bgk.NB_FAJSWJBICD,
                       sw_bgk.VC_FFBDSWSJJG,
                       sw_bgk.VC_FFBDSWSJDW,
                       sw_bgk.VC_GZJSWJB,
                       sw_bgk.NB_GAJSWJBICD,
                       sw_bgk.VC_GFBDSWSJJG,
                       sw_bgk.VC_GFBDSWSJDW,
                       sw_bgk.VC_SZSQBLJZZTZ,
                       sw_bgk.VC_BDCZXM,
                       sw_bgk.VC_YSZGX,
                       sw_bgk.VC_LXDZHGZDW,
                       sw_bgk.VC_BDCZDH,
                       sw_bgk.VC_SYTD,
                       sw_bgk.VC_BDCZQM,
                       sw_bgk.DT_DCRQ,
                       sw_bgk.DT_SCSJ,
                       sw_bgk.DT_SFSJ,
                       sw_bgk.DT_LRSJ,
                       sw_bgk.VC_LRRID,
                       sw_bgk.VC_SHBZ,
                       sw_bgk.DT_SHSJ,
                       sw_bgk.DT_YYSHSJ,
                       sw_bgk.VC_KPZT,
                       sw_bgk.VC_KPLY,
                       sw_bgk.VC_SHID,
                       sw_bgk.VC_KHID,
                       sw_bgk.VC_KHZT,
                       sw_bgk.VC_KHJG,
                       sw_bgk.VC_HKJW,
                       sw_bgk.VC_QCJW,
                       sw_bgk.VC_CSSDM,
                       sw_bgk.VC_CSQXDM,
                       sw_bgk.VC_CSJDDM,
                       sw_bgk.VC_QCSDM,
                       sw_bgk.VC_QCQXDM,
                       sw_bgk.VC_QCJDDM,
                       sw_bgk.VC_HKQC,
                       sw_bgk.DT_QCSJ,
                       sw_bgk.DT_CSRQ,
                       sw_bgk.DT_QXZSSJ,
                       sw_bgk.VC_WBSWYY,
                       sw_bgk.VC_EBM,
                       sw_bgk.VC_YSQM,
                       sw_bgk.VC_HKHS,
                       sw_bgk.VC_WHSYY,
                       sw_bgk.VC_BZ,
                       sw_bgk.VC_QCXXDZ,
                       sw_bgk.FENLEITJ,
                       sw_bgk.FENLEITJMC,
                       sw_bgk.VC_XNXGBFZT,
                       sw_bgk.VC_TNBBFZT,
                       sw_bgk.VC_QCSFDM,
                       sw_bgk.VC_ZLBFZT,
                       sw_bgk.VC_AZJSWJB1,
                       sw_bgk.VC_BZJSWJB1,
                       sw_bgk.VC_CZJSWJB1,
                       sw_bgk.VC_DZJSWJB1,
                       sw_bgk.VC_EZJSWJB1,
                       sw_bgk.VC_FZJSWJB1,
                       sw_bgk.VC_GZJSWJB1,
                       sw_bgk.VC_SHWTGYY,
                       sw_bgk.VC_SHWTGYY1,
                       sw_bgk.VC_DYQBH,
                       sw_bgk.VC_ZJLX,
                       sw_bgk.VC_RSQK,
                       sw_bgk.VC_WSHKSHENDM,
                       sw_bgk.VC_WSHKSDM,
                       sw_bgk.VC_WSHKQXDM,
                       sw_bgk.VC_WSHKJDDM,
                       sw_bgk.VC_WSHKJW,
                       sw_bgk.VC_JZQCS,
                       sw_bgk.VC_JZSDM,
                       sw_bgk.VC_JZQXDM,
                       sw_bgk.VC_JZJDDM,
                       sw_bgk.VC_JZJW,
                       sw_bgk.VC_WSJZSHENDM,
                       sw_bgk.VC_WSJZSDM,
                       sw_bgk.VC_WSJZQXDM,
                       sw_bgk.VC_WSJZJDDM,
                       sw_bgk.VC_WSJZJW,
                       sw_bgk.VC_GJHDQ,
                       count(1) over() as total
                  from ZJMB_SW_BGK sw_bgk
                 where (sw_bgk.VC_SDQR like '1')
                   and (sw_bgk.VC_BGKLB like '0')
                   and (sw_bgk.VC_SCBZ like '2')
                   and (sw_bgk.VC_SHBZ in ('3', '5', '6', '7', '8'))
                   AND sw_bgk.VC_GLDWDM like #{vc_gldw} || '%'
                   and (sw_bgk.VC_HKHS is null)
                   and sw_bgk.vc_hkqcs = '0'
                   and to_number(to_char(sw_bgk.dt_cjsj,'yyyy')) >= (to_number(to_char(SYSDate, 'YYYY')) - 1)
                   <if if(StringUtils.isNotBlank(#{vc_xm}))>
                      and sw_bgk.vc_xm like '%'||#{vc_xm}||'%'
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hksdm}))>
                      and sw_bgk.vc_hksdm = #{vc_hksdm}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkqxdm}))>
                      and sw_bgk.vc_hkqxdm = #{vc_hkqxdm}
                   </if>
                   <if if(StringUtils.isNotBlank(#{vc_hkjddm}))>
                      and sw_bgk.vc_hkjddm = #{vc_hkjddm}
                   </if>
                   <if if(StringUtils.isNotBlank(#{jgszqh}))>  
                       and sw_bgk.vc_hkjddm like #{jgszqh} || '%'  
                   </if>  
                 order by sw_bgk.DT_CJSJ DESC)
         where rownum <= #{rn_e})
 where rn >= #{rn_s}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                