/* 定时任务 每天凌晨 01:00 执行
   每次执行时，发送 updatetime 在 当天01：00 之前的数据，发送完成后，会删除掉 updatetime 在 当天01：00 之前的数据。
*/

-- 死亡报告卡，更新上传
select * from MIDDLEOF_ZJMB_SW_BGK where updatetime <= to_date('2019-07-18 01:00:00','yyyy-MM-dd HH24:mi:ss')
and OPERATE != 'delete' order by updatetime asc;
-- 死亡报告卡，删除上传
select * from MIDDLEOF_ZJMB_SW_BGK where updatetime <= to_date('2019-07-18 01:00:00','yyyy-MM-dd HH24:mi:ss')
and OPERATE = 'delete' order by updatetime asc;


-- 心脑报告卡，更新上传
select * from MIDDLEOF_ZJJK_XNXG_BGK where updatetime <= to_date('2019-07-18 01:00:00','yyyy-MM-dd HH24:mi:ss')
and OPERATE != 'delete' order by updatetime asc;
-- 心脑报告卡，删除上传
select * from MIDDLEOF_ZJJK_XNXG_BGK where updatetime <= to_date('2019-07-18 01:00:00','yyyy-MM-dd HH24:mi:ss')
and OPERATE = 'delete' order by updatetime asc;


-- 心脑初访，更新上传
select * from MIDDLEOF_ZJJK_XNXG_CFK where updatetime <= to_date('2019-07-18 01:00:00','yyyy-MM-dd HH24:mi:ss')
and OPERATE != 'delete' order by updatetime asc;
-- 心脑初访，删除上传
select * from MIDDLEOF_ZJJK_XNXG_CFK where updatetime <= to_date('2019-07-18 01:00:00','yyyy-MM-dd HH24:mi:ss')
and OPERATE = 'delete' order by updatetime asc;


-- 心脑随访，更新上传
select * from MIDDLEOF_ZJJK_XNXG_SFK where updatetime <= to_date('2019-07-18 01:00:00','yyyy-MM-dd HH24:mi:ss')
and OPERATE != 'delete' order by updatetime asc;
-- 心脑随访，删除上传
select * from MIDDLEOF_ZJJK_XNXG_SFK where updatetime <= to_date('2019-07-18 01:00:00','yyyy-MM-dd HH24:mi:ss')
and OPERATE = 'delete' order by updatetime asc;


-- 肿瘤报告卡，更新上传
select * from MIDDLEOF_ZJJK_ZL_BGK where updatetime <= to_date('2019-07-18 01:00:00','yyyy-MM-dd HH24:mi:ss')
and OPERATE != 'delete' order by updatetime asc;
-- 肿瘤报告卡，删除上传
select * from MIDDLEOF_ZJJK_ZL_BGK where updatetime <= to_date('2019-07-18 01:00:00','yyyy-MM-dd HH24:mi:ss')
and OPERATE = 'delete' order by updatetime asc;


-- 肿瘤初访，更新上传
select * from MIDDLEOF_ZJJK_ZL_CCSFK where updatetime <= to_date('2019-07-18 01:00:00','yyyy-MM-dd HH24:mi:ss')
and OPERATE != 'delete' order by updatetime asc;
-- 肿瘤初访，删除上传
select * from MIDDLEOF_ZJJK_ZL_CCSFK where updatetime <= to_date('2019-07-18 01:00:00','yyyy-MM-dd HH24:mi:ss')
and OPERATE = 'delete' order by updatetime asc;


-- 肿瘤随访，更新上传
select * from MIDDLEOF_ZJJK_ZL_SFK where updatetime <= to_date('2019-07-18 01:00:00','yyyy-MM-dd HH24:mi:ss')
and OPERATE != 'delete' order by updatetime asc;
-- 肿瘤随访，删除上传
select * from MIDDLEOF_ZJJK_ZL_SFK where updatetime <= to_date('2019-07-18 01:00:00','yyyy-MM-dd HH24:mi:ss')
and OPERATE = 'delete' order by updatetime asc;


-- 糖尿病随访，更新上传
select * from MIDDLEOF_ZJJK_TNB_SFK where updatetime <= to_date('2019-07-18 01:00:00','yyyy-MM-dd HH24:mi:ss')
and OPERATE != 'delete' order by updatetime asc;
-- 糖尿病随访，删除上传
select * from MIDDLEOF_ZJJK_TNB_SFK where updatetime <= to_date('2019-07-18 01:00:00','yyyy-MM-dd HH24:mi:ss')
and OPERATE = 'delete' order by updatetime asc;


-- 伤害随访，更新上传
select * from MIDDLEOF_ZJMB_SHJC_BGK where updatetime <= to_date('2019-07-18 01:00:00','yyyy-MM-dd HH24:mi:ss')
and OPERATE != 'delete' order by updatetime asc;
-- 伤害随访，删除上传
select * from MIDDLEOF_ZJMB_SHJC_BGK where updatetime <= to_date('2019-07-18 01:00:00','yyyy-MM-dd HH24:mi:ss')
and OPERATE = 'delete' order by updatetime asc;