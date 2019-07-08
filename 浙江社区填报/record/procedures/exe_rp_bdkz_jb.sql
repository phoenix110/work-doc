CREATE OR REPLACE Procedure exe_rp_bdkz_jb(year in VARCHAR2,month in VARCHAR2,quarter in varchar2) is
v_jddm VARCHAR2(40);
v_djfl VARCHAR2(2);
v_jzsj DATE;
V_JZSJ_LS_1 DATE;
V_JZSJ_LS_2 DATE;
V_JZSJ_LS_3 DATE;
V_JZSJ_LS_4 DATE;
V_CNT NUMBER;
begin
  declare
       --类型游标操作需要插入的数据
       cursor c_user
       is
       select distinct g.code as GROUPCODE,g.name as GROUPNAME,
           o.code as ORGCODE,o.name as ORGNAME,
           o.description as ORGRELATION,ot.code as ORGTYPE
            from SC_USER_GROUP t,SC_GROUP g,SC_USER u,ORGAN_NODE o,NODE_USER nu,ORGAN_TYPE ot
            where u.id=t.security_user_id and ot.id=o.organ_type and u.removed=0
              and nu.organ_node_id=o.id and g.id=t.security_group_id
              and u.id=nu.security_user_id
              and not exists(select 1 from rp_bdkz rp where o.code = rp.jgdm and rp.tjnd = year and rp.tjjd = quarter )
              order by  orgtype;
       --定义一个游标变量v_cinfo c_emp%ROWTYPE ，该类型为游标c_emp中的一行数据类型
       c_row c_user%rowtype;
       cursor r_report
       is
       select t.code,t.name,t.remark1 from CODE_INFO t where t.code_info_id=123 and t.operator like '%S%';
       r_row r_report%rowtype;
    begin
         --初始化时间值
       V_JZSJ_LS_1 :=to_date(year||month||'01','yyyyMMdd');
       V_JZSJ_LS_2 :=to_date(year||month||'05','yyyyMMdd');
       V_JZSJ_LS_3 :=to_date(year||month||'10','yyyyMMdd');
       V_JZSJ_LS_4 :=to_date(year||month||'15','yyyyMMdd');

       for c_row in c_user loop
         --定义相关参数
         if c_row.ORGTYPE='sqzx' then
           v_jddm:=c_row.ORGRELATION;
           v_djfl:=1;
           v_jzsj:=V_JZSJ_LS_1;
         elsif c_row.ORGTYPE='qjk' then
           v_jddm:=c_row.ORGRELATION;
           v_djfl:=2;
           v_jzsj:=V_JZSJ_LS_2;
         elsif c_row.ORGTYPE='sjk' then
           v_jddm:=c_row.ORGRELATION;
           v_djfl:=3;
           v_jzsj:=V_JZSJ_LS_3;
         elsif c_row.ORGTYPE='zjjk' then
           v_jddm:=c_row.ORGRELATION;
           v_jzsj:=V_JZSJ_LS_4;
           v_djfl:=4;
         end if;
         
         -- 第一季度只发21
        IF quarter = '3' THEN
           --套游标 REMARK 1. 只有年度 2. 只有季度 3. 只有月度 4. 年度季度都有 5. 年度月度都有
           for r_row in r_report loop
           --插入控制表数据
           insert into rp_bdkz
              (bbid, bdflbs, cjsj, cjyh, djfl,
              jgdm, jzsj, qxshsj, rqfl, scbz, sclrsj, shbtgyy, shishsj, sjfl,
               sshsj, tjjd, tjnd, tjyd, txzt, xdyy, xdzt, xgsj, xgyh, xtscsj, zhxdsj, zzshzt)
             values
               (SYS_GUID, r_row.code,trunc(sysdate) , 'zjjk', v_djfl,
                c_row.ORGCODE, v_jzsj, null, null, '0', null, null, null, '2',
               null, quarter,year, '/', '0', null, null, null, null, trunc(sysdate), null, null);
           end loop;
         END IF;

    V_CNT := 0;
    SELECT COUNT(*)
      INTO V_CNT
      FROM DUAL
     WHERE EXISTS (SELECT 1
              FROM TB_GXY_YYSZCXYYYMX MX
             WHERE MX.SCBZ = 0--默认值
             AND c_row.ORGCODE= MX.Org_Code
               );

       IF V_CNT<>0 THEN
          insert into rp_bdkz(bbid, bdflbs, cjsj, cjyh, djfl,
            jgdm,hospital_code, jzsj, qxshsj, rqfl, scbz, sclrsj, shbtgyy, shishsj, sjfl,
             sshsj, tjjd, tjnd, tjyd, txzt, xdyy, xdzt, xgsj, xgyh, xtscsj, zhxdsj, zzshzt)
             select SYS_GUID(),'21',trunc(sysdate), 'zjjk',mx.djlevel,mx.hospital_code,mx.hospitalname,v_jzsj,
             null, null, '0', null, null, null, '2',
             null, quarter,year, '/', '0', null, null, null, null, trunc(sysdate), null, null
              from TB_GXY_YYSZCXYYYMX mx where mx.org_code=c_row.ORGCODE;

       END IF;
       end loop;
       commit;

       --注意:应该在表里插入鄞州区江东的医院,暂时没做,直接加入那5条记录,detail不用修改.
       --       select * from ORGAN_NODE o where o.code like'330212%' and removed='0';
       --       select a.*,a.rowid from rp_bdkz a where a.bdflbs='21' and a.tjnd='2017' and a.tjjd='3' and a.jgdm like'330212%';
       --       select * from rp_bdkz a where a.bdflbs='21' and a.tjnd='2017' and a.tjjd='2' and a.jgdm like'330212%';

    end;

end;
