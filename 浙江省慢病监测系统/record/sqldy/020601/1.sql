select VC_BGKID,
       VC_CCID,
       VC_CKBZ,
       VC_QYID,
       VC_XM,
       VC_JKDW,
       (select d.mc from p_yljg d where d.dm = vc_jkdw) vc_bgdw_mc,
       NB_JKYYBM,
       VC_SDQR,
       VC_JKYS,
       dts(DT_JKSJ,0) DT_JKSJ,
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
       dts(DT_SWRQ,0) DT_SWRQ,
       VC_SZNL,
       VC_SFZHM,
       VC_RQFL,
       VC_SWDD,
       VC_SQCZDZLX,
       VC_SQXXDZ,
       VC_SQZGZDDW,
       VC_ICDBM,
       VC_ZDYJ,
       VC_GBSY||'-'||NB_GBSYBM VC_GBSY,
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
       dts(DT_XGSJ,0) DT_XGSJ,
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
               total,
               
               rownum as rn
          from (SELECT /*+INDEX(BGK INDEX_SW_GLDW)*/ BGK.VC_BGKID,
                       BGK.VC_CCID,
                       BGK.VC_CKBZ,
                       BGK.VC_QYID,
                       BGK.VC_XM,
                       BGK.VC_JKDW,
                       BGK.NB_JKYYBM,
                       BGK.VC_SDQR,
                       BGK.VC_JKYS,
                       BGK.DT_JKSJ,
                       BGK.VC_XB,
                       BGK.VC_MZ,
                       BGK.VC_ZY,
                       BGK.VC_HJDZLX,
                       BGK.VC_HJDZ,
                       BGK.VC_HJDZBM,
                       BGK.VC_HKQCS,
                       BGK.VC_HKSDM,
                       BGK.VC_HKQXDM,
                       BGK.VC_HKJDDM,
                       BGK.VC_HKXXDZ,
                       BGK.VC_HYZK,
                       BGK.VC_WHCD,
                       BGK.DT_SWRQ,
                       BGK.VC_SZNL,
                       BGK.VC_SFZHM,
                       BGK.VC_RQFL,
                       BGK.VC_SWDD,
                       BGK.VC_SQCZDZLX,
                       BGK.VC_SQXXDZ,
                       BGK.VC_SQZGZDDW,
                       BGK.VC_ICDBM,
                       BGK.VC_ZDYJ,
                       BGK.VC_GBSY,
                       BGK.NB_GBSYBM,
                       BGK.VC_QTJBZD,
                       BGK.NB_QTJBZDICD,
                       BGK.VC_JSXM,
                       BGK.VC_JSLXDH,
                       BGK.VC_JSDZ,
                       BGK.VC_BGKLB,
                       BGK.VC_ZYH,
                       BGK.VC_SCBZ,
                       BGK.VC_GLDWDM,
                       BGK.VC_CJDWDM,
                       BGK.DT_CJSJ,
                       BGK.VC_CJYH,
                       BGK.DT_XGSJ,
                       BGK.VC_XGYH,
                       BGK.VC_XXLY,
                       BGK.VC_SHZT,
                       BGK.VC_AZJSWJB,
                       BGK.NB_AZJSWJBICD,
                       BGK.VC_AFBDSWSJJG,
                       BGK.VC_AFBDSWSJDW,
                       BGK.VC_BZJSWJB,
                       BGK.NB_BZJSWJBIDC,
                       BGK.VC_BFBDSWSJJG,
                       BGK.VC_BFBDSWSJDW,
                       BGK.VC_CZJSWJB,
                       BGK.NB_CZJSWJBICD,
                       BGK.VC_CFBDSWSJJG,
                       BGK.VC_CFBDSWSJDW,
                       BGK.VC_DZJSWJB,
                       BGK.NB_DAJSWJBICD,
                       BGK.VC_DFBDSWSJJG,
                       BGK.VC_DFBDSWSJDW,
                       BGK.VC_EZJSWJB,
                       BGK.NB_EAJSWJBICD,
                       BGK.VC_EFBDSWSJJG,
                       BGK.VC_EFBDSWSJDW,
                       BGK.VC_FZJSWJB,
                       BGK.NB_FAJSWJBICD,
                       BGK.VC_FFBDSWSJJG,
                       BGK.VC_FFBDSWSJDW,
                       BGK.VC_GZJSWJB,
                       BGK.NB_GAJSWJBICD,
                       BGK.VC_GFBDSWSJJG,
                       BGK.VC_GFBDSWSJDW,
                       BGK.VC_SZSQBLJZZTZ,
                       BGK.VC_BDCZXM,
                       BGK.VC_YSZGX,
                       BGK.VC_LXDZHGZDW,
                       BGK.VC_BDCZDH,
                       BGK.VC_SYTD,
                       BGK.VC_BDCZQM,
                       BGK.DT_DCRQ,
                       BGK.DT_SCSJ,
                       BGK.DT_SFSJ,
                       BGK.DT_LRSJ,
                       BGK.VC_LRRID,
                       BGK.VC_SHBZ,
                       BGK.DT_SHSJ,
                       BGK.DT_YYSHSJ,
                       BGK.VC_KPZT,
                       BGK.VC_KPLY,
                       BGK.VC_SHID,
                       BGK.VC_KHID,
                       BGK.VC_KHZT,
                       BGK.VC_KHJG,
                       BGK.VC_HKJW,
                       BGK.VC_QCJW,
                       BGK.VC_CSSDM,
                       BGK.VC_CSQXDM,
                       BGK.VC_CSJDDM,
                       BGK.VC_QCSDM,
                       BGK.VC_QCQXDM,
                       BGK.VC_QCJDDM,
                       BGK.VC_HKQC,
                       BGK.DT_QCSJ,
                       BGK.DT_CSRQ,
                       BGK.DT_QXZSSJ,
                       BGK.VC_WBSWYY,
                       BGK.VC_EBM,
                       BGK.VC_YSQM,
                       BGK.VC_HKHS,
                       BGK.VC_WHSYY,
                       BGK.VC_BZ,
                       BGK.VC_QCXXDZ,
                       BGK.FENLEITJ,
                       BGK.FENLEITJMC,
                       BGK.VC_XNXGBFZT,
                       BGK.VC_TNBBFZT,
                       BGK.VC_QCSFDM,
                       BGK.VC_ZLBFZT,
                       BGK.VC_AZJSWJB1,
                       BGK.VC_BZJSWJB1,
                       BGK.VC_CZJSWJB1,
                       BGK.VC_DZJSWJB1,
                       BGK.VC_EZJSWJB1,
                       BGK.VC_FZJSWJB1,
                       BGK.VC_GZJSWJB1,
                       BGK.VC_SHWTGYY,
                       BGK.VC_SHWTGYY1,
                       BGK.VC_DYQBH,
                       BGK.VC_ZJLX,
                       BGK.VC_RSQK,
                       BGK.VC_WSHKSHENDM,
                       BGK.VC_WSHKSDM,
                       BGK.VC_WSHKQXDM,
                       BGK.VC_WSHKJDDM,
                       BGK.VC_WSHKJW,
                       BGK.VC_JZQCS,
                       BGK.VC_JZSDM,
                       BGK.VC_JZQXDM,
                       BGK.VC_JZJDDM,
                       BGK.VC_JZJW,
                       BGK.VC_WSJZSHENDM,
                       BGK.VC_WSJZSDM,
                       BGK.VC_WSJZQXDM,
                       BGK.VC_WSJZJDDM,
                       BGK.VC_WSJZJW,
                       BGK.VC_GJHDQ,
                       count(1) over() as total
                  FROM ZJMB_SW_BGK BGK
                 WHERE (BGK.VC_SCBZ LIKE '2')
                   <if if("A1".equals(#{jglx}))>
                       and BGK.vc_jkdw like #{vc_gldw} || '%'
                   </if>
                   <if if("B1".equals(#{jglx}))>
                       and ((bgk.vc_shbz = '1' and BGK.vc_jkdw like #{vc_gldw} || '%') or 
                       (bgk.vc_shbz != '1' and (BGK.VC_CJDWDM like #{vc_gldw}|| '%' OR BGK.VC_GLDWDM like #{vc_gldw}|| '%' or BGK.VC_HKJDDM like #{jgszqh} || '%')))
                   </if>
                 <if if(!"A1".equals(#{jglx}) && !"B1".equals(#{jglx}) && StringUtils.isNotBlank(#{jgszqh}))>
                   AND (BGK.VC_CJDWDM like #{vc_gldw}|| '%' OR BGK.VC_GLDWDM like #{vc_gldw}|| '%' or BGK.VC_HKJDDM like #{jgszqh} || '%')
                 </if>
                 <if if(!"A1".equals(#{jglx}) && !"B1".equals(#{jglx}) && StringUtils.isBlank(#{jgszqh}))>
                   AND (BGK.VC_CJDWDM like #{vc_gldw}|| '%' OR BGK.VC_GLDWDM like #{vc_gldw}|| '%')
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_bgklb}))>
                      AND BGK.vc_bgklb = #{vc_bgklb}
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_shbz}) && !#{vc_shbz}.contains(","))>
                   and BGK.vc_shbz = #{vc_shbz}
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_shbz}) && #{vc_shbz}.contains(","))>
                   and instr(#{vc_shbz},bgk.vc_shbz) > 0
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_qx}))>
                      AND (BGK.VC_JKDW like #{vc_qx}||'%')
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_shi}))>
                      AND (BGK.VC_JKDW like #{vc_shi}||'%')
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_jkdw}))>
                      AND (BGK.VC_JKDW = #{vc_jkdw})
                 </if>
                 <if if(StringUtils.isNotBlank(#{lrsj_ks}))>
                      AND (BGK.DT_LRSJ >= std(#{lrsj_ks},1))
                 </if>
                 <if if(StringUtils.isNotBlank(#{lrsj_js}))>
                      AND (BGK.DT_LRSJ <= std(#{lrsj_js},1))
                 </if>
                 <if if(StringUtils.isNotBlank(#{cxsjlx}) && "2".equals(#{cxsjlx}) && StringUtils.isNotBlank(#{dt_sjd_ks}))>
                      AND (BGK.DT_SHSJ >= std(#{dt_sjd_ks},1))
                 </if>
                 <if if(StringUtils.isNotBlank(#{cxsjlx}) && "2".equals(#{cxsjlx}) && StringUtils.isNotBlank(#{dt_sjd_js}))>
                      AND (BGK.DT_SHSJ <= std(#{dt_sjd_js},1))
                 </if>
                 <if if(StringUtils.isNotBlank(#{cxsjlx}) && "3".equals(#{cxsjlx}) && StringUtils.isNotBlank(#{dt_sjd_ks}))>
                      AND (BGK.DT_SWRQ >= std(#{dt_sjd_ks},1))
                 </if>
                 <if if(StringUtils.isNotBlank(#{cxsjlx}) && "3".equals(#{cxsjlx}) && StringUtils.isNotBlank(#{dt_sjd_js}))>
                      AND (BGK.DT_SWRQ <= std(#{dt_sjd_js},1))
                 </if>
                 <if if(StringUtils.isNotBlank(#{cxsjlx}) && "4".equals(#{cxsjlx}) && StringUtils.isNotBlank(#{dt_sjd_ks}))>
                      AND (BGK.DT_DCRQ >= std(#{dt_sjd_ks},1))
                 </if>
                 <if if(StringUtils.isNotBlank(#{cxsjlx}) && "4".equals(#{cxsjlx}) && StringUtils.isNotBlank(#{dt_sjd_js}))>
                      AND (BGK.DT_DCRQ <= std(#{dt_sjd_js},1))
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_bgkid}))>
                      AND (BGK.VC_BGKID = #{vc_bgkid})
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_xm}))>
                      AND (BGK.VC_XM like '%'||#{vc_xm}||'%')
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_xb}))>
                      AND (BGK.VC_XB = #{vc_xb})
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_gbsy}))>
                      AND ((BGK.VC_GBSY LIKE '%'||#{vc_gbsy}||'%') OR (BGK.NB_GBSYBM LIKE  '%'||#{vc_gbsy}||'%'))
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_swdd}))>
                      AND (BGK.VC_SWDD = #{vc_swdd})
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_sznl_ks}))>
                      AND (to_number(BGK.VC_SZNL) >= to_number(#{vc_sznl_ks}))
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_sznl_js}))>
                      AND (to_number(BGK.VC_SZNL) <= to_number(#{vc_sznl_js}))
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_hkshen}))>
                      AND (BGK.VC_HKQCS = #{vc_hkshen})
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_hks}))>
                      AND (BGK.VC_HKSDM = #{vc_hks})
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_hkqx}))>
                      AND (BGK.VC_HKQXDM = #{vc_hkqx})
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_hkjd}))>
                      AND (BGK.VC_HKJDDM = #{vc_hkjd})
                 </if>
                 <if if(StringUtils.isNotBlank(#{vc_hkjw}))>
                      AND (BGK.VC_HKJW = #{vc_hkjw})
                 </if>
                 <if if(StringUtils.isNotBlank(#{fenleitjks}))>
                      AND (to_number(BGK.FENLEITJ) >= to_number(#{fenleitjks}))
                 </if>
                 <if if(StringUtils.isNotBlank(#{fenleitjjs}))>
                      AND (to_number(BGK.FENLEITJ) <= to_number(#{fenleitjjs}))
                 </if>
                 
                  <if if("vc_xm".equals(#{orderField}) && "asc".equals(#{orderType}))>
                     order by nlssort(BGK.VC_XM, 'NLS_SORT=SCHINESE_PINYIN_M') asc
                   </if>
                   <if if("vc_xm".equals(#{orderField}) && "desc".equals(#{orderType}))>
                     order by nlssort(BGK.VC_XM, 'NLS_SORT=SCHINESE_PINYIN_M') desc
                   </if>
                   <if if("vc_bgkid".equals(#{orderField}) && "asc".equals(#{orderType}))>
                     order by BGK.vc_bgkid asc
                   </if>
                   <if if("vc_bgkid".equals(#{orderField}) && "desc".equals(#{orderType}))>
                     order by BGK.vc_bgkid desc
                   </if>
                    <if if("dt_lrsj".equals(#{orderField}) && "asc".equals(#{orderType}))>
                     order by BGK.dt_lrsj asc
                   </if>
                   <if if("dt_lrsj".equals(#{orderField}) && "desc".equals(#{orderType}))>
                     order by BGK.dt_lrsj desc
                   </if>
                     <if if("dt_yyshsj".equals(#{orderField}) && "asc".equals(#{orderType}))>
                     order by BGK.dt_yyshsj asc
                   </if>
                   <if if("dt_yyshsj".equals(#{orderField}) && "desc".equals(#{orderType}))>
                     order by BGK.dt_yyshsj desc
                   </if>
                   <if if("dt_shsj".equals(#{orderField}) && "asc".equals(#{orderType}))>
                     order by BGK.dt_shsj asc
                   </if>
                   <if if("dt_shsj".equals(#{orderField}) && "desc".equals(#{orderType}))>
                     order by BGK.dt_shsj desc
                   </if>                                                      
                   <if if(StringUtils.isBlank(#{orderField}))>
                     ORDER BY BGK.DT_CJSJ
                   </if>  
                 )
         where rownum <= #{rn_e})
 where rn >= #{rn_s}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              