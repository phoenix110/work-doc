/* begin 数据回传-省网(即慢病监测，传数据给地市) begin*/

-- 每天凌晨3点会定时回传，传昨天的数据。 Task_https.initCallService
-- area_upload_log 表的 upresult 1为成功的，2为失败的
/*
area_upload_log 表的 DATATYPE 
    DISEASE_TUMOR_ZX("1", "肿瘤报卡", "ZjjkZlHzxxBgks"),
    DISEASE_DIABETES_ZX("2", "糖尿病报卡", "ZjjkTnbHzxxBgks"),
    DISEASE_HEART_ZX("3", "心脑报卡", "ZjjkXnxgBgks"),
    DISEASE_HARM("4", "伤害报卡", "ZjmbShjcBgks"),
    DISEASE_DIE("5", "死亡报卡", "ZjmbSwBgks"),
    DISEASE_DIABETES_CF("6", "糖尿病初访卡", "ZjjkTnbSfks"),
    DISEASE_DIABETES_SF("7", "糖尿病随访卡", "ZjjkTnbSfks"),
    DISEASE_HEART_CF("8", "心脑初访卡", "ZjjkXnxgCfks"),
    DISEASE_HEART_SF("9", "心脑随访卡", "ZjjkXnxgSfks"),
    DISEASE_TUMOR_CF("10", "肿瘤初访卡", "ZjjkZlCcsfks"),
  	DISEASE_TUMOR_SF("11", "肿瘤随访卡", "ZjjkZlSfks"),
  	BACK_DISEASE("12", "校验结果", "ZjjkDzCxs");
*/

-- 要回推的地区配置表
select * from zjsjk_ws_config
  
-- 所有病种失败的记录 
select log.* from area_upload_log log, zjsjk_ws_config conf
where log.aera = conf.areacode
and conf.areaname = '嘉兴'
and upresult = '2'
and insert_time >= to_date('2019-05-01 00:00:00','yyyy-mm-dd hh24:mi:ss') 

-- 肿瘤失败的记录 
select count(*) from area_upload_log log, zjsjk_ws_config conf, ZJJK_ZL_BGK bgk, ZJJK_ZL_HZXX hzxx
where log.aera = conf.areacode
and log.operation_id = bgk.VC_BGKID
and BGK.VC_HZID = HZXX.VC_PERSONID
and log.datatype = '1'
and conf.areaname = '嘉兴'
and log.upresult = '2'
and log.insert_time >= to_date('2019-05-01 00:00:00','yyyy-mm-dd hh24:mi:ss') 

-- 糖尿病失败的记录 
select count(*) from area_upload_log log, zjsjk_ws_config conf, ZJJK_TNB_BGK bgk, ZJJK_TNB_HZXX hzxx
where log.aera = conf.areacode
and log.operation_id = bgk.VC_BGKID
and BGK.VC_HZID = HZXX.VC_PERSONID
and log.datatype = '2'
and conf.areaname = '嘉兴'
and upresult = '2'
and insert_time >= to_date('2019-05-01 00:00:00','yyyy-mm-dd hh24:mi:ss') 

-- 心脑血管失败的记录 
select count(*) from area_upload_log log, zjsjk_ws_config conf, ZJJK_XNXG_BGK bgk
where log.aera = conf.areacode
and log.operation_id = bgk.VC_BGKID
and log.datatype = '3'
and conf.areaname = '嘉兴'
and log.upresult = '2'
and log.insert_time >= to_date('2019-05-01 00:00:00','yyyy-mm-dd hh24:mi:ss') 

-- 死亡失败的记录 
select count(*) from area_upload_log log, zjsjk_ws_config conf, ZJMB_SW_BGK bgk
where log.aera = conf.areacode
and log.operation_id = bgk.VC_BGKID
and conf.areaname = '嘉兴'
and log.datatype = '5'
and upresult = '2'
and insert_time >= to_date('2019-05-01 00:00:00','yyyy-mm-dd hh24:mi:ss') 


-- 重新回传，把相应报告卡的 dt_xgsj改成 sysdate
-- 肿瘤重传
update ZJJK_ZL_BGK t set t.dt_xgsj = sysdate where t.vc_bgkid in (
    select distinct bgk.vc_bgkid from area_upload_log log, zjsjk_ws_config conf, ZJJK_ZL_BGK bgk, ZJJK_ZL_HZXX hzxx
    where log.aera = conf.areacode
    and log.operation_id = bgk.VC_BGKID
    and BGK.VC_HZID = HZXX.VC_PERSONID
    and log.datatype = '1'
    and conf.areaname = '嘉兴'
    and log.upresult = '2'
    and log.insert_time >= to_date('2019-05-01 00:00:00','yyyy-mm-dd hh24:mi:ss') 
 )
 
 -- 糖尿病重传
update ZJJK_TNB_BGK t set t.dt_xgsj = sysdate where t.vc_bgkid in (
    select distinct bgk.vc_bgkid from area_upload_log log, zjsjk_ws_config conf, ZJJK_TNB_BGK bgk, ZJJK_TNB_HZXX hzxx
    where log.aera = conf.areacode
    and log.operation_id = bgk.VC_BGKID
    and BGK.VC_HZID = HZXX.VC_PERSONID
    and log.datatype = '2'
    and conf.areaname = '嘉兴'
    and upresult = '2'
    and insert_time >= to_date('2019-05-01 00:00:00','yyyy-mm-dd hh24:mi:ss') 
 )
 
  -- 心脑血管重传
update ZJJK_XNXG_BGK t set t.dt_xgsj = sysdate  where t.vc_bgkid in (
    select distinct bgk.vc_bgkid from area_upload_log log, zjsjk_ws_config conf, ZJJK_XNXG_BGK bgk
    where log.aera = conf.areacode
    and log.operation_id = bgk.VC_BGKID
    and log.datatype = '3'
    and conf.areaname = '嘉兴'
    and log.upresult = '2'
    and log.insert_time >= to_date('2019-05-01 00:00:00','yyyy-mm-dd hh24:mi:ss') 
 )

  -- 死亡重传
update ZJMB_SW_BGK t set t.dt_xgsj = sysdate where t.vc_bgkid in (
    select distinct bgk.vc_bgkid from area_upload_log log, zjsjk_ws_config conf, ZJMB_SW_BGK bgk
    where log.aera = conf.areacode
    and log.operation_id = bgk.VC_BGKID
    and conf.areaname = '嘉兴'
    and log.datatype = '5'
    and upresult = '2'
    and insert_time >= to_date('2019-05-01 00:00:00','yyyy-mm-dd hh24:mi:ss') 
 )

/* end 数据回传-省网(即慢病监测，传数据给地市) end*/


-- 接收地市上传数据，并且回推对账结果，每6分钟推送一次结果
-- zjjk_dz 对账表，VC_SCBZ 1接收成功，未回传对账结果；2表示已回传对账结果到地市， vc_dzjg 1表示接收到的数据校验成功，并且入库，否则为校验失败 
-- 接收时，如果不带vc_bgkid，则为新增。如果带了vc_bgkid则为修改。
select * from zjjk_dz where vc_id = '' or vc_bgkid = '';
-- 重新推送结果，把 zjjk_dz 表的要重推的数据的 VC_SCBZ 改成 1
-- update zjjk_dz set vc_scbz = '1' where vc_bgkid = 'xxxx'



--
select *
  from ZJJK_ZL_BGK
 where 1 = 1
   and ((dt_cjsj >= to_date('2019-06-25 00:00:00', 'yyyy-MM-dd HH24:mi:ss') and
       dt_cjsj <= to_date('2019-06-25 23:59:59', 'yyyy-MM-dd HH24:mi:ss')) or
       (dt_xgsj >= to_date('2019-06-25 00:00:00', 'yyyy-MM-dd HH24:mi:ss') and
       dt_xgsj <= to_date('2019-06-25 23:59:59', 'yyyy-MM-dd HH24:mi:ss')))
   and (not exists
        (select 1
           from area_upload_log log
          where log.operation_id = vc_bgkid
            and log.upresult = '1'
            and log.datatype = '1'
            and log.aera = '330782'
             or (select max(insert_time)
                   from area_upload_log log
                  where log.upresult = '1'
                    and log.datatype = '1'
                    and log.aera = '330782'
                    and log.operation_id = vc_bgkid) < dt_xgsj))
      
   and VC_BGKID in ('ex1700000222966', 'ex1900000067903')
