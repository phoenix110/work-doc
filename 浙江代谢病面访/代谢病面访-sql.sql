/*select * from sqldy where mkbh='040101' and ywdm = '23'

select * from sqldy where mkbh='040102' and ywdm='7'

select t.dm,t.lx,t.ip,t.port,t.filepath,t.username,t.pwd from t_file_server t where t.dm ='04'
*/

select id,
       mfid,
       name,
       sex,
       idcard,
       birth,
       home,
       yljgid,
       jc,
       phone1,
       phone2,
       mfzt,
       mfztmc,
       total,
       rn
       from (
select id,
       mfid,
       name,
       sex,
       idcard,
       birth,
       home,
       yljgid,
       jc,
       phone1,
       phone2,
       mfzt,
       mfztmc,
       total,
       rownum rn
from(
select a.id,
       a.mfid,
       a.name,
       decode(a.sex,'1','男','2','女') as sex,
       a.idcard,
       dts(a.brith,0) birth,
       a.home,
       a.yljgid,
       b.jc,
       a.phone1,
       a.phone2,
       a.mfzt,
       decode(a.mfzt,'','未面访','0','未面访','1','面访未完成','2','面访完成','3','失访') as mfztmc,
       count(1) over() total
  from grjbxx a,p_yljg b, dlmf_fpry c
 where a.yljgid=b.id 
   and a.id = c.grid
   
  /* update grjbxx set yljgid = '1' where yljgid = '71DE7941AA956131E05010AC296E7DB8'
    update p_yljg set id = '1' where id = '71DE7941AA956131E05010AC296E7DB8'*/
    
/*    update dlmf_fpry c set c.mfryid = '71DE7941AA956131E05010AC296E7DB8'
    where c.grid in (select a.id from grjbxx  a where a.yljgid = '1')
*/

/*select * from dlmf_fpry for update 
*/   
   and a.yljgid = '1'
  and c.mfryid = '71DE7941AA956131E05010AC296E7DB8'
   
/* <if if(StringUtils.isNotBlank(#{gljgid}))>
   and a.yljgid = '71DE7941AA956131E05010AC296E7DB8'
 </if> 
 <if if(StringUtils.isNotBlank(#{glryid}))>
   and c.mfryid = '71DE7941AA956131E05010AC296E7DB8'
 </if> 
 <if if(StringUtils.isNotBlank(#{filter}))>
   and (a.id like '%'||#{filter}||'%' or  a.name like '%'||#{filter}||'%' or a.idcard like '%'||#{filter}||'%') 
 </if>*/
 ) where rownum <= 20
) tt where rn >= 0                                                                  
