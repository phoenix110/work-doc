select code, name,icd9, diccode, total, rn
  from (select code, name,icd9, diccode, total, rownum as rn
          from (select a.dm code,
                       a.mc name,
                       b.icd9,
                       a.fldm diccode,
                       count(1) over() as total
                  from p_tyzdml a,T_JCXXGL_ICDO109 b
                 where a.bz = 1
                   and a.dm = b.icd10(+)
                   and a.fldm = #{code}
                   <if if(StringUtils.isNotBlank(#{sjdm}))>
                     and a.sjdm = #{sjdm}
                   </if>
                   <if if(StringUtils.isNotBlank(#{jsm}))>
                     and (a.dm like upper(#{jsm})||'%' or a.mc like '%'||upper(#{jsm})||'%')
                   </if>)
         where rownum <= #{rn_e})
 where rn >= #{rn_s}