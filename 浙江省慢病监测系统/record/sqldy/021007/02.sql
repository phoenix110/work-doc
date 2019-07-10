SELECT id fhid,
       sfkid,
       '0' vc_bgkzt,
       decode(csflx, '1', '初访', '2', '随访') csflx,
       decode(bllx,
              '1',
              '脑卒中',
              '2',
              '冠心病',
              '3',
              '糖尿病',
              '4',
              '肿瘤',
              '5',
              '死亡') bllx,
       csflx vc_csflx,
       bllx vc_bllx,
       cctjid,
       kpbm bgkbh,
       szxm xm,
       xb xb,
       sfzh sfzh,
       hjdz hjdz,
       lxdh lxdh,
       shyj,
       fn_zjjk_zlfh_csf_getfhjg(#{vc_csflx}, #{vc_bllx},id) sffh,
       decode(fhzt,
              '0',
              '未开始',
              '1',
              '进行中',
              '2',
              '待复核',
              '3',
              '复核通过',
              '4',
              '复核不通过',
              '5',
              '审核通过',
              '6',
              '审核不通过') fhzt,
       fhzt vc_fhzt,
       total,
       rn
  FROM (SELECT id,
               sfkid,
               csflx,
               bllx,
               cctjid,
               kpbm,
               szxm,
               xb,
               sfzh,
               hjdz,
               lxdh,
               shyj,
               fhzt,
               total,
               rownum rn
          FROM (SELECT a.id,
                       b.sfkid,
                       b.csflx,
                       b.bllx,
                       b.cctjid,
                       a.kpbm,
                       a.szxm,
                       a.xb,
                       a.sfzh,
                       a.hjdz,
                       a.lxdh,
                       b.shyj,
                       b.fhzt,
                       COUNT(1) over() total
                  FROM zjjk_cf_zlfh_swga a, zjjk_csf_zlfh b
                 WHERE a.id = b.id
                   AND (b.fhzt = '3' OR b.fhzt = '5' OR b.fhzt = '6')
                   AND b.zt = '1'
                   AND (('1' = #{vc_csflx} AND cctjid=#{cfccsjd}) OR ('2' = #{vc_csflx} AND cctjid=#{sfccsjd}))
                   AND b.bllx = #{vc_bllx}
                   AND b.ccjgid LIKE #{vc_bkqx} || '%'
                 <if if(StringUtils.isNotBlank(#{sfsh}))>
                   AND (('0' = #{sfsh} AND b.fhzt != '3') OR
                       ('1' = #{sfsh} AND b.fhzt = '3'))
                 </if>
                 <if if(1==1)>
                )
         WHERE rownum < #{rn_e})
 WHERE rn >= #{rn_s}  
                </if>                                                                                         