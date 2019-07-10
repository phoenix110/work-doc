SELECT id fhid,
       sfkid,
       kpzt vc_bgkzt,
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
       hzxm xm,
       xb xb,
       sfzh sfzh,
       hjdz hjdz,
       lxdh lxdh,
       zdyy bkdw,
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
               kpzt,
               csflx,
               bllx,
               cctjid,
               kpbm,
               hzxm,
               xb,
               sfzh,
               hjdz,
               lxdh,
               zdyy,
               shyj,
               fhzt,
               total,
               rownum rn
          FROM (SELECT a.id,
                       b.sfkid,
                       a.kpzt,
                       b.csflx,
                       b.bllx,
                       b.cctjid,
                       a.kpbm,
                       a.hzxm,
                       a.xb,
                       a.sfzh,
                       a.hjdz,
                       a.lxdh,
                       a.zdyy,
                       b.shyj,
                       b.fhzt,
                       COUNT(1) over() total
                  FROM zjjk_cf_zlfh_mxbjc a, zjjk_csf_zlfh b
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