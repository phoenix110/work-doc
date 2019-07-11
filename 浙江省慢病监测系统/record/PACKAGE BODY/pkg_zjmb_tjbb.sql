CREATE OR REPLACE PACKAGE BODY pkg_zjmb_tjbb AS
  --初始化包序号--
  /******************************************************************************/
  /*  程序包名 ：pkg_zjmb_tjbb                                                  */
  /*  业务环节 ：浙江慢病_统计报表                                          */
  /*  功能描述 ：为慢病统计报表相关的存储过程及函数                           */
  /*                                                                            */
  /*  作    者 ：          作成日期 ：2018-06-04   版本编号 ：Ver 1.0.0  */
  /*----------------------------------------------------------------------------*/
  /*  修改记录 ：                                                               */
  /******************************************************************************/
  /*-------------------------------------------------------------------------*/
  /*-------------------------------------------------------------------------*/
  /*--------------------------------------------------------------------------
  || 功能描述 ：人口数报表年统计表
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_tjbb_rksbb(Data_In In Clob, Result_Out Out Varchar2) Is
    v_Json_Data Json;
    Err_Custom Exception;
    v_Err           Varchar2(2000);
    v_json_list_rks json_list;
    v_json_rks      json;
    v_json_return   json := json();
    v_json_yw_log   json;
    v_vc_rkgls      ZJMB_RKGLB.vc_rkgls%TYPE;
    v_vc_rkglq      ZJMB_RKGLB.vc_rkglq%TYPE;
    v_vc_rkgljd     ZJMB_RKGLB.vc_rkgljd%TYPE;
    v_vc_nf         ZJMB_RKGLB.vc_nf%TYPE;
    v_vc_lx         ZJMB_RKGLB.vc_lx%TYPE;
    v_vc_0nld       ZJMB_RKGLB.vc_0nld%TYPE;
    v_vc_1nld       ZJMB_RKGLB.vc_1nld%TYPE;
    v_vc_5nld       ZJMB_RKGLB.vc_5nld%TYPE;
    v_vc_10nld      ZJMB_RKGLB.vc_10nld%TYPE;
    v_vc_15nld      ZJMB_RKGLB.vc_15nld%TYPE;
    v_vc_20nld      ZJMB_RKGLB.vc_20nld%TYPE;
    v_vc_25nld      ZJMB_RKGLB.vc_25nld%TYPE;
    v_vc_30nld      ZJMB_RKGLB.vc_30nld%TYPE;
    v_vc_35nld      ZJMB_RKGLB.vc_35nld%TYPE;
    v_vc_40nld      ZJMB_RKGLB.vc_40nld%TYPE;
    v_vc_45nld      ZJMB_RKGLB.vc_45nld%TYPE;
    v_vc_50nld      ZJMB_RKGLB.vc_50nld%TYPE;
    v_vc_55nld      ZJMB_RKGLB.vc_55nld%TYPE;
    v_vc_60nld      ZJMB_RKGLB.vc_60nld%TYPE;
    v_vc_65nld      ZJMB_RKGLB.vc_65nld%TYPE;
    v_vc_70nld      ZJMB_RKGLB.vc_70nld%TYPE;
    v_vc_75nld      ZJMB_RKGLB.vc_75nld%TYPE;
    v_vc_80nld      ZJMB_RKGLB.vc_80nld%TYPE;
    v_vc_85nld      ZJMB_RKGLB.vc_85nld%TYPE;
    v_vc_zrks       ZJMB_RKGLB.vc_zrks%TYPE;
    v_vc_nhj        ZJMB_RKGLB.vc_nhj%TYPE;
    v_vc_vhj        ZJMB_RKGLB.vc_vhj%TYPE;
    v_vc_zhj        ZJMB_RKGLB.vc_zhj%TYPE;
    v_vc_ganhj      ZJMB_RKGLB.vc_ganhj%TYPE;
    v_vc_gavhj      ZJMB_RKGLB.vc_gavhj%TYPE;
    v_vc_gazhj      ZJMB_RKGLB.vc_gazhj%TYPE;
    v_count         number;
  Begin
    Json_Data(Data_In, '人口数报表保存', v_Json_Data);
    v_vc_rkgls      := Json_Str(v_Json_Data, 'vc_hks');
    v_vc_rkglq      := Json_Str(v_Json_Data, 'vc_hkqx');
    v_vc_rkgljd     := Json_Str(v_Json_Data, 'vc_hkjd');
    v_vc_nf         := Json_Str(v_Json_Data, 'nf');
    v_json_list_rks := json_ext.get_json_list(v_Json_Data, 'rklist');
  
    BEGIN
      IF v_vc_rkgls IS NULL THEN
        v_Err := '市级行政区划不能为空';
        Raise Err_Custom;
      END if;
      IF v_vc_rkglq IS NULL THEN
        v_Err := '区县级行政区划不能为空';
        Raise Err_Custom;
      END if;
      IF v_vc_rkgljd IS NULL THEN
        v_Err := '街道级行政区划不能为空';
        Raise Err_Custom;
      END if;
      IF v_vc_nf IS NULL THEN
        v_Err := '年份不能为空';
        Raise Err_Custom;
      END if;
      --检查是否存在
      select count(1)
        into v_count
        from ZJMB_RKGLB
       WHERE vc_rkgls = v_vc_rkgls
         AND vc_rkglq = v_vc_rkglq
         AND vc_rkgljd = v_vc_rkgljd
         AND vc_nf = v_vc_nf;
      if v_count > 0 then
        v_err := '本年度已存在人口信息报表!';
        raise err_custom;
      end if;
      /*DELETE ZJMB_RKGLB
      WHERE vc_rkgls = v_vc_rkgls
        AND vc_rkglq = v_vc_rkglq
        AND vc_rkgljd = v_vc_rkgljd
        AND vc_nf = v_vc_nf;*/
    
      FOR i IN 1 .. v_json_list_rks.count LOOP
        v_json_rks := json(v_json_list_rks.get(i));
        v_vc_0nld  := Json_Str(v_json_rks, 'vc_0nld');
        v_vc_1nld  := Json_Str(v_json_rks, 'vc_1nld');
        v_vc_5nld  := Json_Str(v_json_rks, 'vc_5nld');
        v_vc_10nld := Json_Str(v_json_rks, 'vc_10nld');
        v_vc_15nld := Json_Str(v_json_rks, 'vc_15nld');
        v_vc_20nld := Json_Str(v_json_rks, 'vc_20nld');
        v_vc_25nld := Json_Str(v_json_rks, 'vc_25nld');
        v_vc_30nld := Json_Str(v_json_rks, 'vc_30nld');
        v_vc_35nld := Json_Str(v_json_rks, 'vc_35nld');
        v_vc_40nld := Json_Str(v_json_rks, 'vc_40nld');
        v_vc_45nld := Json_Str(v_json_rks, 'vc_45nld');
        v_vc_50nld := Json_Str(v_json_rks, 'vc_50nld');
        v_vc_55nld := Json_Str(v_json_rks, 'vc_55nld');
        v_vc_60nld := Json_Str(v_json_rks, 'vc_60nld');
        v_vc_65nld := Json_Str(v_json_rks, 'vc_65nld');
        v_vc_70nld := Json_Str(v_json_rks, 'vc_70nld');
        v_vc_75nld := Json_Str(v_json_rks, 'vc_75nld');
        v_vc_80nld := Json_Str(v_json_rks, 'vc_80nld');
        v_vc_85nld := Json_Str(v_json_rks, 'vc_85nld');
        v_vc_zrks  := Json_Str(v_json_rks, 'vc_zrks');
        v_vc_lx    := Json_Str(v_json_rks, 'vc_lx');
        v_vc_nhj   := Json_Str(v_json_rks, 'vc_nhj');
        v_vc_vhj   := Json_Str(v_json_rks, 'vc_vhj');
        v_vc_zhj   := Json_Str(v_json_rks, 'vc_zhj');
        v_vc_ganhj := Json_Str(v_json_rks, 'vc_ganhj');
        v_vc_gavhj := Json_Str(v_json_rks, 'vc_gavhj');
        v_vc_gazhj := Json_Str(v_json_rks, 'vc_gazhj');
      
        BEGIN
          INSERT INTO ZJMB_RKGLB
            (vc_rkglid,
             vc_rkgls,
             vc_rkglq,
             vc_rkgljd,
             vc_lx,
             vc_nf,
             vc_0nld,
             vc_1nld,
             vc_5nld,
             vc_10nld,
             vc_15nld,
             vc_20nld,
             vc_25nld,
             vc_30nld,
             vc_35nld,
             vc_40nld,
             vc_45nld,
             vc_50nld,
             vc_55nld,
             vc_60nld,
             vc_65nld,
             vc_70nld,
             vc_75nld,
             vc_80nld,
             vc_85nld,
             vc_zrks,
             vc_nhj,
             vc_vhj,
             vc_zhj,
             vc_ganhj,
             vc_gavhj,
             vc_gazhj)
          VALUES
            (sys_guid(),
             v_vc_rkgls,
             v_vc_rkglq,
             v_vc_rkgljd,
             v_vc_lx,
             v_vc_nf,
             v_vc_0nld,
             v_vc_1nld,
             v_vc_5nld,
             v_vc_10nld,
             v_vc_15nld,
             v_vc_20nld,
             v_vc_25nld,
             v_vc_30nld,
             v_vc_35nld,
             v_vc_40nld,
             v_vc_45nld,
             v_vc_50nld,
             v_vc_55nld,
             v_vc_60nld,
             v_vc_65nld,
             v_vc_70nld,
             v_vc_75nld,
             v_vc_80nld,
             v_vc_85nld,
             v_vc_zrks,
             v_vc_nhj,
             v_vc_vhj,
             v_vc_zhj,
             v_vc_ganhj,
             v_vc_gavhj,
             v_vc_gazhj);
        END;
      
      END LOOP;
    End;
    --记录日志
    v_json_yw_log := Json_ext.get_json(v_json_data, 'ywjllog');
    if v_json_yw_log is not null then
      v_json_yw_log.put('bgkid', '');
      v_json_yw_log.put('bgklx', '00');
      v_json_yw_log.put('ywjlid', '');
      v_json_yw_log.put('gnmk', '00');
      v_json_yw_log.put('gnmc', '人口数据维护');
      v_json_yw_log.put('czlx', '01');
      pkg_zjmb_xtfz.prc_zjjk_yw_log_update(v_json_yw_log, v_err);
      if v_err is not null then
        raise err_custom;
      end if;
    end if;
    commit;
    Result_Out := return_succ_json(json('{}'));
  EXCEPTION
    When Err_Custom Then
      Result_Out := Return_Fail(v_Err, 2);
    When Others Then
      v_Err      := Sqlerrm;
      Result_Out := Return_Fail(v_Err, 0);
  END prc_tjbb_rksbb;
  /*--------------------------------------------------------------------------
  || 功能描述 ：人口年龄分布导入
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_tjbb_rknlfb_imp(Data_In    In Clob, --入参
                                result_out OUT VARCHAR2) --返回
   is
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err         VARCHAR2(2000);
    v_json_yw_log json;
    v_ywjl_czlx   varchar2(3);
    --公共变量
    v_sysdate        date;
    v_czyjgdm        varchar2(50);
    v_czyjgjb        varchar2(3);
    v_czyyhid        varchar2(50);
    v_json_list_rks  json_List; --出生报告卡
    v_json_list_temp json_List;
    v_dqdm           ZJJK_RKS_NLFB.dqdm%type;
    v_nd             ZJJK_RKS_NLFB.nd%type;
    v_xb             ZJJK_RKS_NLFB.xb%type;
    v_count          number;
    v_dq1            varchar2(8); --地区省
    v_dq2            varchar2(8); --地区市
    v_dq3            varchar2(8); --地区县
  
  BEGIN
    json_data(data_in, 'ZJJK_RKS_NLFB人口年龄分布导入', v_json_data);
    v_sysdate       := sysdate;
    v_czyjgdm       := Json_Str(v_Json_Data, 'czyjgdm'); --操作员机构代码
    v_czyyhid       := Json_Str(v_Json_Data, 'czyyhid');
    v_czyjgjb       := Json_Str(v_Json_Data, 'czyjgjb'); --获取机构级别
    v_nd            := Json_Str(v_Json_Data, 'nd'); --获取机构级别
    v_Json_List_rks := Json_Ext.Get_Json_List(v_Json_Data, 'rks_arr'); --人口信息
  
    if v_czyjgdm is null then
      v_err := '未获取到操作员信息!';
      raise err_custom;
    end if;
    if v_czyjgjb not in ('1') then
      v_err := '当前机构无导入权限!';
      raise err_custom;
    end if;
    if v_nd is null then
      v_err := '未获取到导入年度!';
      raise err_custom;
    end if;
    --检查年度是否已导入
    select count(1)
      into v_count
      from ZJJK_RKS_NLFB
     where nd = v_nd
       and zt = 1
       and rownum = 1;
    if v_count > 0 then
      v_err := '年度【' || v_nd || '】已导入人口数据!';
      raise err_custom;
    end if;
    --写入数据
    if v_Json_List_rks.count > 0 then
      for i in 1 .. v_Json_List_rks.count loop
        v_json_list_temp := json_List(v_Json_List_rks.Get(i));
        if v_json_list_temp.count > 0 then
          v_dqdm := v_json_list_temp.Get(1).get_string;
          if v_dqdm is null then
            v_err := '地区代码不能为空!';
            raise err_custom;
          end if;
          v_xb := v_json_list_temp.Get(3).get_string;
          if v_xb is null then
            v_err := '性别不能为空!';
            raise err_custom;
          end if;
          insert into zjjk_rks_nlfb
            (dqdm,
             dqmc,
             nd,
             xb,
             nld_0,
             nld_1,
             nld_2,
             nld_3,
             nld_4,
             nld_5,
             nld_6,
             nld_7,
             nld_8,
             nld_9,
             nld_10,
             nld_11,
             nld_12,
             nld_13,
             nld_14,
             nld_15,
             nld_16,
             nld_17,
             nld_18,
             nld_19,
             nld_20,
             nld_21,
             nld_22,
             nld_23,
             nld_24,
             nld_25,
             nld_26,
             nld_27,
             nld_28,
             nld_29,
             nld_30,
             nld_31,
             nld_32,
             nld_33,
             nld_34,
             nld_35,
             nld_36,
             nld_37,
             nld_38,
             nld_39,
             nld_40,
             nld_41,
             nld_42,
             nld_43,
             nld_44,
             nld_45,
             nld_46,
             nld_47,
             nld_48,
             nld_49,
             nld_50,
             nld_51,
             nld_52,
             nld_53,
             nld_54,
             nld_55,
             nld_56,
             nld_57,
             nld_58,
             nld_59,
             nld_60,
             nld_61,
             nld_62,
             nld_63,
             nld_64,
             nld_65,
             nld_66,
             nld_67,
             nld_68,
             nld_69,
             nld_70,
             nld_71,
             nld_72,
             nld_73,
             nld_74,
             nld_75,
             nld_76,
             nld_77,
             nld_78,
             nld_79,
             nld_80,
             nld_81,
             nld_82,
             nld_83,
             nld_84,
             nld_85,
             nld_86,
             nld_87,
             nld_88,
             nld_89,
             nld_90,
             nld_91,
             nld_92,
             nld_93,
             nld_94,
             nld_95,
             nld_96,
             nld_97,
             nld_98,
             nld_99,
             nld_100,
             nld_101,
             cjsj,
             cjyh,
             cjjg,
             zt,
             xh)
          values
            (v_dqdm,
             v_json_list_temp.Get(2).get_string,
             v_nd,
             v_xb,
             v_json_list_temp.Get(4).get_string,
             v_json_list_temp.Get(5).get_string,
             v_json_list_temp.Get(6).get_string,
             v_json_list_temp.Get(7).get_string,
             v_json_list_temp.Get(8).get_string,
             v_json_list_temp.Get(9).get_string,
             v_json_list_temp.Get(10).get_string,
             v_json_list_temp.Get(11).get_string,
             v_json_list_temp.Get(12).get_string,
             v_json_list_temp.Get(13).get_string,
             v_json_list_temp.Get(14).get_string,
             v_json_list_temp.Get(15).get_string,
             v_json_list_temp.Get(16).get_string,
             v_json_list_temp.Get(17).get_string,
             v_json_list_temp.Get(18).get_string,
             v_json_list_temp.Get(19).get_string,
             v_json_list_temp.Get(20).get_string,
             v_json_list_temp.Get(21).get_string,
             v_json_list_temp.Get(22).get_string,
             v_json_list_temp.Get(23).get_string,
             v_json_list_temp.Get(24).get_string,
             v_json_list_temp.Get(25).get_string,
             v_json_list_temp.Get(26).get_string,
             v_json_list_temp.Get(27).get_string,
             v_json_list_temp.Get(28).get_string,
             v_json_list_temp.Get(29).get_string,
             v_json_list_temp.Get(30).get_string,
             v_json_list_temp.Get(31).get_string,
             v_json_list_temp.Get(32).get_string,
             v_json_list_temp.Get(33).get_string,
             v_json_list_temp.Get(34).get_string,
             v_json_list_temp.Get(35).get_string,
             v_json_list_temp.Get(36).get_string,
             v_json_list_temp.Get(37).get_string,
             v_json_list_temp.Get(38).get_string,
             v_json_list_temp.Get(39).get_string,
             v_json_list_temp.Get(40).get_string,
             v_json_list_temp.Get(41).get_string,
             v_json_list_temp.Get(42).get_string,
             v_json_list_temp.Get(43).get_string,
             v_json_list_temp.Get(44).get_string,
             v_json_list_temp.Get(45).get_string,
             v_json_list_temp.Get(46).get_string,
             v_json_list_temp.Get(47).get_string,
             v_json_list_temp.Get(48).get_string,
             v_json_list_temp.Get(49).get_string,
             v_json_list_temp.Get(50).get_string,
             v_json_list_temp.Get(51).get_string,
             v_json_list_temp.Get(52).get_string,
             v_json_list_temp.Get(53).get_string,
             v_json_list_temp.Get(54).get_string,
             v_json_list_temp.Get(55).get_string,
             v_json_list_temp.Get(56).get_string,
             v_json_list_temp.Get(57).get_string,
             v_json_list_temp.Get(58).get_string,
             v_json_list_temp.Get(59).get_string,
             v_json_list_temp.Get(60).get_string,
             v_json_list_temp.Get(61).get_string,
             v_json_list_temp.Get(62).get_string,
             v_json_list_temp.Get(63).get_string,
             v_json_list_temp.Get(64).get_string,
             v_json_list_temp.Get(65).get_string,
             v_json_list_temp.Get(66).get_string,
             v_json_list_temp.Get(67).get_string,
             v_json_list_temp.Get(68).get_string,
             v_json_list_temp.Get(69).get_string,
             v_json_list_temp.Get(70).get_string,
             v_json_list_temp.Get(71).get_string,
             v_json_list_temp.Get(72).get_string,
             v_json_list_temp.Get(73).get_string,
             v_json_list_temp.Get(74).get_string,
             v_json_list_temp.Get(75).get_string,
             v_json_list_temp.Get(76).get_string,
             v_json_list_temp.Get(77).get_string,
             v_json_list_temp.Get(78).get_string,
             v_json_list_temp.Get(79).get_string,
             v_json_list_temp.Get(80).get_string,
             v_json_list_temp.Get(81).get_string,
             v_json_list_temp.Get(82).get_string,
             v_json_list_temp.Get(83).get_string,
             v_json_list_temp.Get(84).get_string,
             v_json_list_temp.Get(85).get_string,
             v_json_list_temp.Get(86).get_string,
             v_json_list_temp.Get(87).get_string,
             v_json_list_temp.Get(88).get_string,
             v_json_list_temp.Get(89).get_string,
             v_json_list_temp.Get(90).get_string,
             v_json_list_temp.Get(91).get_string,
             v_json_list_temp.Get(92).get_string,
             v_json_list_temp.Get(93).get_string,
             v_json_list_temp.Get(94).get_string,
             v_json_list_temp.Get(95).get_string,
             v_json_list_temp.Get(96).get_string,
             v_json_list_temp.Get(97).get_string,
             v_json_list_temp.Get(98).get_string,
             v_json_list_temp.Get(99).get_string,
             v_json_list_temp.Get(100).get_string,
             v_json_list_temp.Get(101).get_string,
             v_json_list_temp.Get(102).get_string,
             v_json_list_temp.Get(103).get_string,
             v_json_list_temp.Get(104).get_string,
             v_json_list_temp.Get(105).get_string,
             v_sysdate,
             v_czyyhid,
             v_czyjgdm,
             1,
             i);
        end if;
      end loop;
    else
      v_err := '未获取到需要导入的数据!';
      raise err_custom;
    end if;
    --处理人口信息，需先处理完人口年龄分布
    for rec_rkdq in (select distinct dqdm from ZJJK_RKS_NLFB where nd = v_nd) loop
      --获取导入地区
      if substr(rec_rkdq.dqdm, 3) = '0000000000' then
        --省
        v_dq2 := '99999999';
        v_dq3 := '99999999';
      elsif substr(rec_rkdq.dqdm, 5) = '00000000' then
        --市
        v_dq2 := substr(rec_rkdq.dqdm, 1, 8);
        v_dq3 := '99999999';
      elsif substr(rec_rkdq.dqdm, 7) = '000000' then
        --县
        v_dq2 := substr(rec_rkdq.dqdm, 1, 4) + '0000';
        v_dq3 := substr(rec_rkdq.dqdm, 1, 8);
      else
        v_err := '导入地区代码有误';
        raise err_custom;
      end if;
      --检查导入年度是否已经填报
      select count(1)
        into v_count
        from ZJMB_RKGLB a
       where a.vc_rkgls = v_dq2
         and a.vc_rkglq = v_dq3
         and a.vc_rkgljd = '99999999'
         and a.vc_nf = substr(v_nd, 3, 2);
      if v_count = 0 then
        --写入本年度男
        insert into zjmb_rkglb
          (vc_rkglid,
           vc_rkglsf,
           vc_rkgls,
           vc_rkglq,
           vc_rkgljd,
           vc_lx,
           vc_nf,
           vc_0nld,
           vc_1nld,
           vc_5nld,
           vc_10nld,
           vc_15nld,
           vc_20nld,
           vc_25nld,
           vc_30nld,
           vc_35nld,
           vc_40nld,
           vc_45nld,
           vc_50nld,
           vc_55nld,
           vc_60nld,
           vc_65nld,
           vc_70nld,
           vc_75nld,
           vc_80nld,
           vc_85nld,
           vc_nhj)
          select sys_guid(),
                 '33000000',
                 v_dq2,
                 v_dq3,
                 '99999999',
                 '4',
                 substr(v_nd, 3, 2),
                 NVL(NLD_0, 0),
                 NVL(NLD_1, 0) + NVL(NLD_2, 0) + NVL(NLD_3, 0) +
                 NVL(NLD_4, 0),
                 NVL(NLD_5, 0) + NVL(NLD_6, 0) + NVL(NLD_7, 0) +
                 NVL(NLD_8, 0) + NVL(NLD_9, 0),
                 NVL(NLD_10, 0) + NVL(NLD_11, 0) + NVL(NLD_12, 0) +
                 NVL(NLD_13, 0) + NVL(NLD_14, 0),
                 NVL(NLD_15, 0) + NVL(NLD_16, 0) + NVL(NLD_17, 0) +
                 NVL(NLD_18, 0) + NVL(NLD_19, 0),
                 NVL(NLD_20, 0) + NVL(NLD_21, 0) + NVL(NLD_22, 0) +
                 NVL(NLD_23, 0) + NVL(NLD_24, 0),
                 NVL(NLD_25, 0) + NVL(NLD_26, 0) + NVL(NLD_27, 0) +
                 NVL(NLD_28, 0) + NVL(NLD_29, 0),
                 NVL(NLD_30, 0) + NVL(NLD_31, 0) + NVL(NLD_32, 0) +
                 NVL(NLD_33, 0) + NVL(NLD_34, 0),
                 NVL(NLD_35, 0) + NVL(NLD_36, 0) + NVL(NLD_37, 0) +
                 NVL(NLD_38, 0) + NVL(NLD_39, 0),
                 NVL(NLD_40, 0) + NVL(NLD_41, 0) + NVL(NLD_42, 0) +
                 NVL(NLD_43, 0) + NVL(NLD_44, 0),
                 NVL(NLD_45, 0) + NVL(NLD_46, 0) + NVL(NLD_47, 0) +
                 NVL(NLD_48, 0) + NVL(NLD_49, 0),
                 NVL(NLD_50, 0) + NVL(NLD_51, 0) + NVL(NLD_52, 0) +
                 NVL(NLD_53, 0) + NVL(NLD_54, 0),
                 NVL(NLD_55, 0) + NVL(NLD_56, 0) + NVL(NLD_57, 0) +
                 NVL(NLD_58, 0) + NVL(NLD_59, 0),
                 NVL(NLD_60, 0) + NVL(NLD_61, 0) + NVL(NLD_62, 0) +
                 NVL(NLD_63, 0) + NVL(NLD_64, 0),
                 NVL(NLD_65, 0) + NVL(NLD_66, 0) + NVL(NLD_67, 0) +
                 NVL(NLD_68, 0) + NVL(NLD_69, 0),
                 NVL(NLD_70, 0) + NVL(NLD_71, 0) + NVL(NLD_72, 0) +
                 NVL(NLD_73, 0) + NVL(NLD_74, 0),
                 NVL(NLD_75, 0) + NVL(NLD_76, 0) + NVL(NLD_77, 0) +
                 NVL(NLD_78, 0) + NVL(NLD_79, 0),
                 NVL(NLD_80, 0) + NVL(NLD_81, 0) + NVL(NLD_82, 0) +
                 NVL(NLD_83, 0) + NVL(NLD_84, 0),
                 NVL(NLD_85, 0) + NVL(NLD_86, 0) + NVL(NLD_87, 0) +
                 NVL(NLD_88, 0) + NVL(NLD_89, 0) + NVL(NLD_90, 0) +
                 NVL(NLD_91, 0) + NVL(NLD_92, 0) + NVL(NLD_93, 0) +
                 NVL(NLD_94, 0) + NVL(NLD_95, 0) + NVL(NLD_96, 0) +
                 NVL(NLD_97, 0) + NVL(NLD_98, 0) + NVL(NLD_99, 0) +
                 NVL(NLD_100, 0) + NVL(NLD_101, 0),
                 NVL(NLD_0, 0) + NVL(NLD_1, 0) + NVL(NLD_2, 0) +
                 NVL(NLD_3, 0) + NVL(NLD_4, 0) + NVL(NLD_5, 0) +
                 NVL(NLD_6, 0) + NVL(NLD_7, 0) + NVL(NLD_8, 0) +
                 NVL(NLD_9, 0) + NVL(NLD_10, 0) + NVL(NLD_11, 0) +
                 NVL(NLD_12, 0) + NVL(NLD_13, 0) + NVL(NLD_14, 0) +
                 NVL(NLD_15, 0) + NVL(NLD_16, 0) + NVL(NLD_17, 0) +
                 NVL(NLD_18, 0) + NVL(NLD_19, 0) + NVL(NLD_20, 0) +
                 NVL(NLD_21, 0) + NVL(NLD_22, 0) + NVL(NLD_23, 0) +
                 NVL(NLD_24, 0) + NVL(NLD_25, 0) + NVL(NLD_26, 0) +
                 NVL(NLD_27, 0) + NVL(NLD_28, 0) + NVL(NLD_29, 0) +
                 NVL(NLD_30, 0) + NVL(NLD_31, 0) + NVL(NLD_32, 0) +
                 NVL(NLD_33, 0) + NVL(NLD_34, 0) + NVL(NLD_35, 0) +
                 NVL(NLD_36, 0) + NVL(NLD_37, 0) + NVL(NLD_38, 0) +
                 NVL(NLD_39, 0) + NVL(NLD_40, 0) + NVL(NLD_41, 0) +
                 NVL(NLD_42, 0) + NVL(NLD_43, 0) + NVL(NLD_44, 0) +
                 NVL(NLD_45, 0) + NVL(NLD_46, 0) + NVL(NLD_47, 0) +
                 NVL(NLD_48, 0) + NVL(NLD_49, 0) + NVL(NLD_50, 0) +
                 NVL(NLD_51, 0) + NVL(NLD_52, 0) + NVL(NLD_53, 0) +
                 NVL(NLD_54, 0) + NVL(NLD_55, 0) + NVL(NLD_56, 0) +
                 NVL(NLD_57, 0) + NVL(NLD_58, 0) + NVL(NLD_59, 0) +
                 NVL(NLD_60, 0) + NVL(NLD_61, 0) + NVL(NLD_62, 0) +
                 NVL(NLD_63, 0) + NVL(NLD_64, 0) + NVL(NLD_65, 0) +
                 NVL(NLD_66, 0) + NVL(NLD_67, 0) + NVL(NLD_68, 0) +
                 NVL(NLD_69, 0) + NVL(NLD_70, 0) + NVL(NLD_71, 0) +
                 NVL(NLD_72, 0) + NVL(NLD_73, 0) + NVL(NLD_74, 0) +
                 NVL(NLD_75, 0) + NVL(NLD_76, 0) + NVL(NLD_77, 0) +
                 NVL(NLD_78, 0) + NVL(NLD_79, 0) + NVL(NLD_80, 0) +
                 NVL(NLD_81, 0) + NVL(NLD_82, 0) + NVL(NLD_83, 0) +
                 NVL(NLD_84, 0) + NVL(NLD_85, 0) + NVL(NLD_86, 0) +
                 NVL(NLD_87, 0) + NVL(NLD_88, 0) + NVL(NLD_89, 0) +
                 NVL(NLD_90, 0) + NVL(NLD_91, 0) + NVL(NLD_92, 0) +
                 NVL(NLD_93, 0) + NVL(NLD_94, 0) + NVL(NLD_95, 0) +
                 NVL(NLD_96, 0) + NVL(NLD_97, 0) + NVL(NLD_98, 0) +
                 NVL(NLD_99, 0) + NVL(NLD_100, 0) + NVL(NLD_101, 0)
            from zjjk_rks_nlfb a
           where a.dqdm = rec_rkdq.dqdm
             and a.nd = v_nd
             and a.xb = 1;
        --写入本年度女
        insert into zjmb_rkglb
          (vc_rkglid,
           vc_rkglsf,
           vc_rkgls,
           vc_rkglq,
           vc_rkgljd,
           vc_lx,
           vc_nf,
           vc_0nld,
           vc_1nld,
           vc_5nld,
           vc_10nld,
           vc_15nld,
           vc_20nld,
           vc_25nld,
           vc_30nld,
           vc_35nld,
           vc_40nld,
           vc_45nld,
           vc_50nld,
           vc_55nld,
           vc_60nld,
           vc_65nld,
           vc_70nld,
           vc_75nld,
           vc_80nld,
           vc_85nld,
           vc_vhj)
          select sys_guid(),
                 '33000000',
                 v_dq2,
                 v_dq3,
                 '99999999',
                 '5',
                 substr(v_nd, 3, 2),
                 NVL(NLD_0, 0),
                 NVL(NLD_1, 0) + NVL(NLD_2, 0) + NVL(NLD_3, 0) +
                 NVL(NLD_4, 0),
                 NVL(NLD_5, 0) + NVL(NLD_6, 0) + NVL(NLD_7, 0) +
                 NVL(NLD_8, 0) + NVL(NLD_9, 0),
                 NVL(NLD_10, 0) + NVL(NLD_11, 0) + NVL(NLD_12, 0) +
                 NVL(NLD_13, 0) + NVL(NLD_14, 0),
                 NVL(NLD_15, 0) + NVL(NLD_16, 0) + NVL(NLD_17, 0) +
                 NVL(NLD_18, 0) + NVL(NLD_19, 0),
                 NVL(NLD_20, 0) + NVL(NLD_21, 0) + NVL(NLD_22, 0) +
                 NVL(NLD_23, 0) + NVL(NLD_24, 0),
                 NVL(NLD_25, 0) + NVL(NLD_26, 0) + NVL(NLD_27, 0) +
                 NVL(NLD_28, 0) + NVL(NLD_29, 0),
                 NVL(NLD_30, 0) + NVL(NLD_31, 0) + NVL(NLD_32, 0) +
                 NVL(NLD_33, 0) + NVL(NLD_34, 0),
                 NVL(NLD_35, 0) + NVL(NLD_36, 0) + NVL(NLD_37, 0) +
                 NVL(NLD_38, 0) + NVL(NLD_39, 0),
                 NVL(NLD_40, 0) + NVL(NLD_41, 0) + NVL(NLD_42, 0) +
                 NVL(NLD_43, 0) + NVL(NLD_44, 0),
                 NVL(NLD_45, 0) + NVL(NLD_46, 0) + NVL(NLD_47, 0) +
                 NVL(NLD_48, 0) + NVL(NLD_49, 0),
                 NVL(NLD_50, 0) + NVL(NLD_51, 0) + NVL(NLD_52, 0) +
                 NVL(NLD_53, 0) + NVL(NLD_54, 0),
                 NVL(NLD_55, 0) + NVL(NLD_56, 0) + NVL(NLD_57, 0) +
                 NVL(NLD_58, 0) + NVL(NLD_59, 0),
                 NVL(NLD_60, 0) + NVL(NLD_61, 0) + NVL(NLD_62, 0) +
                 NVL(NLD_63, 0) + NVL(NLD_64, 0),
                 NVL(NLD_65, 0) + NVL(NLD_66, 0) + NVL(NLD_67, 0) +
                 NVL(NLD_68, 0) + NVL(NLD_69, 0),
                 NVL(NLD_70, 0) + NVL(NLD_71, 0) + NVL(NLD_72, 0) +
                 NVL(NLD_73, 0) + NVL(NLD_74, 0),
                 NVL(NLD_75, 0) + NVL(NLD_76, 0) + NVL(NLD_77, 0) +
                 NVL(NLD_78, 0) + NVL(NLD_79, 0),
                 NVL(NLD_80, 0) + NVL(NLD_81, 0) + NVL(NLD_82, 0) +
                 NVL(NLD_83, 0) + NVL(NLD_84, 0),
                 NVL(NLD_85, 0) + NVL(NLD_86, 0) + NVL(NLD_87, 0) +
                 NVL(NLD_88, 0) + NVL(NLD_89, 0) + NVL(NLD_90, 0) +
                 NVL(NLD_91, 0) + NVL(NLD_92, 0) + NVL(NLD_93, 0) +
                 NVL(NLD_94, 0) + NVL(NLD_95, 0) + NVL(NLD_96, 0) +
                 NVL(NLD_97, 0) + NVL(NLD_98, 0) + NVL(NLD_99, 0) +
                 NVL(NLD_100, 0) + NVL(NLD_101, 0),
                 NVL(NLD_0, 0) + NVL(NLD_1, 0) + NVL(NLD_2, 0) +
                 NVL(NLD_3, 0) + NVL(NLD_4, 0) + NVL(NLD_5, 0) +
                 NVL(NLD_6, 0) + NVL(NLD_7, 0) + NVL(NLD_8, 0) +
                 NVL(NLD_9, 0) + NVL(NLD_10, 0) + NVL(NLD_11, 0) +
                 NVL(NLD_12, 0) + NVL(NLD_13, 0) + NVL(NLD_14, 0) +
                 NVL(NLD_15, 0) + NVL(NLD_16, 0) + NVL(NLD_17, 0) +
                 NVL(NLD_18, 0) + NVL(NLD_19, 0) + NVL(NLD_20, 0) +
                 NVL(NLD_21, 0) + NVL(NLD_22, 0) + NVL(NLD_23, 0) +
                 NVL(NLD_24, 0) + NVL(NLD_25, 0) + NVL(NLD_26, 0) +
                 NVL(NLD_27, 0) + NVL(NLD_28, 0) + NVL(NLD_29, 0) +
                 NVL(NLD_30, 0) + NVL(NLD_31, 0) + NVL(NLD_32, 0) +
                 NVL(NLD_33, 0) + NVL(NLD_34, 0) + NVL(NLD_35, 0) +
                 NVL(NLD_36, 0) + NVL(NLD_37, 0) + NVL(NLD_38, 0) +
                 NVL(NLD_39, 0) + NVL(NLD_40, 0) + NVL(NLD_41, 0) +
                 NVL(NLD_42, 0) + NVL(NLD_43, 0) + NVL(NLD_44, 0) +
                 NVL(NLD_45, 0) + NVL(NLD_46, 0) + NVL(NLD_47, 0) +
                 NVL(NLD_48, 0) + NVL(NLD_49, 0) + NVL(NLD_50, 0) +
                 NVL(NLD_51, 0) + NVL(NLD_52, 0) + NVL(NLD_53, 0) +
                 NVL(NLD_54, 0) + NVL(NLD_55, 0) + NVL(NLD_56, 0) +
                 NVL(NLD_57, 0) + NVL(NLD_58, 0) + NVL(NLD_59, 0) +
                 NVL(NLD_60, 0) + NVL(NLD_61, 0) + NVL(NLD_62, 0) +
                 NVL(NLD_63, 0) + NVL(NLD_64, 0) + NVL(NLD_65, 0) +
                 NVL(NLD_66, 0) + NVL(NLD_67, 0) + NVL(NLD_68, 0) +
                 NVL(NLD_69, 0) + NVL(NLD_70, 0) + NVL(NLD_71, 0) +
                 NVL(NLD_72, 0) + NVL(NLD_73, 0) + NVL(NLD_74, 0) +
                 NVL(NLD_75, 0) + NVL(NLD_76, 0) + NVL(NLD_77, 0) +
                 NVL(NLD_78, 0) + NVL(NLD_79, 0) + NVL(NLD_80, 0) +
                 NVL(NLD_81, 0) + NVL(NLD_82, 0) + NVL(NLD_83, 0) +
                 NVL(NLD_84, 0) + NVL(NLD_85, 0) + NVL(NLD_86, 0) +
                 NVL(NLD_87, 0) + NVL(NLD_88, 0) + NVL(NLD_89, 0) +
                 NVL(NLD_90, 0) + NVL(NLD_91, 0) + NVL(NLD_92, 0) +
                 NVL(NLD_93, 0) + NVL(NLD_94, 0) + NVL(NLD_95, 0) +
                 NVL(NLD_96, 0) + NVL(NLD_97, 0) + NVL(NLD_98, 0) +
                 NVL(NLD_99, 0) + NVL(NLD_100, 0) + NVL(NLD_101, 0)
            from zjjk_rks_nlfb a
           where a.dqdm = rec_rkdq.dqdm
             and a.nd = v_nd
             and a.xb = 2;
        --写入本年度合计
        insert into zjmb_rkglb
          (vc_rkglid,
           vc_rkglsf,
           vc_rkgls,
           vc_rkglq,
           vc_rkgljd,
           vc_lx,
           vc_nf,
           vc_0nld,
           vc_1nld,
           vc_5nld,
           vc_10nld,
           vc_15nld,
           vc_20nld,
           vc_25nld,
           vc_30nld,
           vc_35nld,
           vc_40nld,
           vc_45nld,
           vc_50nld,
           vc_55nld,
           vc_60nld,
           vc_65nld,
           vc_70nld,
           vc_75nld,
           vc_80nld,
           vc_85nld,
           vc_zhj)
          select sys_guid(),
                 '33000000',
                 v_dq2,
                 v_dq3,
                 '99999999',
                 '6',
                 substr(v_nd, 3, 2),
                 sum(vc_0nld),
                 sum(vc_1nld),
                 sum(vc_5nld),
                 sum(vc_10nld),
                 sum(vc_15nld),
                 sum(vc_20nld),
                 sum(vc_25nld),
                 sum(vc_30nld),
                 sum(vc_35nld),
                 sum(vc_40nld),
                 sum(vc_45nld),
                 sum(vc_50nld),
                 sum(vc_55nld),
                 sum(vc_60nld),
                 sum(vc_65nld),
                 sum(vc_70nld),
                 sum(vc_75nld),
                 sum(vc_80nld),
                 sum(vc_85nld),
                 nvl(max(vc_nhj), 0) + nvl(max(vc_vhj), 0)
            from zjmb_rkglb
           where vc_rkgls = v_dq2
             and vc_rkglq = v_dq3
             and vc_rkgljd = '99999999'
             and vc_lx in ('4', '5')
             and vc_nf = substr(v_nd, 3, 2);
        --获取上年度人口信息
        --写入上年度男
        insert into zjmb_rkglb
          (vc_rkglid,
           vc_rkglsf,
           vc_rkgls,
           vc_rkglq,
           vc_rkgljd,
           vc_lx,
           vc_nf,
           vc_0nld,
           vc_1nld,
           vc_5nld,
           vc_10nld,
           vc_15nld,
           vc_20nld,
           vc_25nld,
           vc_30nld,
           vc_35nld,
           vc_40nld,
           vc_45nld,
           vc_50nld,
           vc_55nld,
           vc_60nld,
           vc_65nld,
           vc_70nld,
           vc_75nld,
           vc_80nld,
           vc_85nld,
           vc_zrks,
           vc_nhj,
           vc_vhj,
           vc_zhj,
           vc_xtlb,
           vc_ganhj,
           vc_gavhj,
           vc_gazhj)
          select sys_guid(),
                 vc_rkglsf,
                 vc_rkgls,
                 vc_rkglq,
                 vc_rkgljd,
                 '1',
                 to_number(vc_nf) + 1,
                 vc_0nld,
                 vc_1nld,
                 vc_5nld,
                 vc_10nld,
                 vc_15nld,
                 vc_20nld,
                 vc_25nld,
                 vc_30nld,
                 vc_35nld,
                 vc_40nld,
                 vc_45nld,
                 vc_50nld,
                 vc_55nld,
                 vc_60nld,
                 vc_65nld,
                 vc_70nld,
                 vc_75nld,
                 vc_80nld,
                 vc_85nld,
                 vc_zrks,
                 vc_nhj,
                 vc_vhj,
                 vc_zhj,
                 vc_xtlb,
                 vc_ganhj,
                 vc_gavhj,
                 vc_gazhj
            from zjmb_rkglb
           where vc_rkgls = v_dq2
             and vc_rkglq = v_dq3
             and vc_rkgljd = '99999999'
             and vc_lx = '4'
             and vc_nf = substr(v_nd, 3, 2) - 1;
        if sql%rowcount = 0 then
          --未获取到上年
          insert into zjmb_rkglb
            (vc_rkglid,
             vc_rkglsf,
             vc_rkgls,
             vc_rkglq,
             vc_rkgljd,
             vc_lx,
             vc_nf,
             vc_0nld,
             vc_1nld,
             vc_5nld,
             vc_10nld,
             vc_15nld,
             vc_20nld,
             vc_25nld,
             vc_30nld,
             vc_35nld,
             vc_40nld,
             vc_45nld,
             vc_50nld,
             vc_55nld,
             vc_60nld,
             vc_65nld,
             vc_70nld,
             vc_75nld,
             vc_80nld,
             vc_85nld,
             vc_zrks,
             vc_nhj,
             vc_vhj,
             vc_zhj,
             vc_xtlb,
             vc_ganhj,
             vc_gavhj,
             vc_gazhj)
            select sys_guid(),
                   vc_rkglsf,
                   vc_rkgls,
                   vc_rkglq,
                   vc_rkgljd,
                   '1',
                   vc_nf,
                   vc_0nld,
                   vc_1nld,
                   vc_5nld,
                   vc_10nld,
                   vc_15nld,
                   vc_20nld,
                   vc_25nld,
                   vc_30nld,
                   vc_35nld,
                   vc_40nld,
                   vc_45nld,
                   vc_50nld,
                   vc_55nld,
                   vc_60nld,
                   vc_65nld,
                   vc_70nld,
                   vc_75nld,
                   vc_80nld,
                   vc_85nld,
                   vc_zrks,
                   vc_nhj,
                   vc_vhj,
                   vc_zhj,
                   vc_xtlb,
                   vc_ganhj,
                   vc_gavhj,
                   vc_gazhj
              from zjmb_rkglb
             where vc_rkgls = v_dq2
               and vc_rkglq = v_dq3
               and vc_rkgljd = '99999999'
               and vc_lx = '4'
               and vc_nf = substr(v_nd, 3, 2);
        end if;
        --写入上年度女
        insert into zjmb_rkglb
          (vc_rkglid,
           vc_rkglsf,
           vc_rkgls,
           vc_rkglq,
           vc_rkgljd,
           vc_lx,
           vc_nf,
           vc_0nld,
           vc_1nld,
           vc_5nld,
           vc_10nld,
           vc_15nld,
           vc_20nld,
           vc_25nld,
           vc_30nld,
           vc_35nld,
           vc_40nld,
           vc_45nld,
           vc_50nld,
           vc_55nld,
           vc_60nld,
           vc_65nld,
           vc_70nld,
           vc_75nld,
           vc_80nld,
           vc_85nld,
           vc_zrks,
           vc_nhj,
           vc_vhj,
           vc_zhj,
           vc_xtlb,
           vc_ganhj,
           vc_gavhj,
           vc_gazhj)
          select sys_guid(),
                 vc_rkglsf,
                 vc_rkgls,
                 vc_rkglq,
                 vc_rkgljd,
                 '2',
                 to_number(vc_nf) + 1,
                 vc_0nld,
                 vc_1nld,
                 vc_5nld,
                 vc_10nld,
                 vc_15nld,
                 vc_20nld,
                 vc_25nld,
                 vc_30nld,
                 vc_35nld,
                 vc_40nld,
                 vc_45nld,
                 vc_50nld,
                 vc_55nld,
                 vc_60nld,
                 vc_65nld,
                 vc_70nld,
                 vc_75nld,
                 vc_80nld,
                 vc_85nld,
                 vc_zrks,
                 vc_nhj,
                 vc_vhj,
                 vc_zhj,
                 vc_xtlb,
                 vc_ganhj,
                 vc_gavhj,
                 vc_gazhj
            from zjmb_rkglb
           where vc_rkgls = v_dq2
             and vc_rkglq = v_dq3
             and vc_rkgljd = '99999999'
             and vc_lx = '5'
             and vc_nf = substr(v_nd, 3, 2) - 1;
        if sql%rowcount = 0 then
          --未获取到上年
          insert into zjmb_rkglb
            (vc_rkglid,
             vc_rkglsf,
             vc_rkgls,
             vc_rkglq,
             vc_rkgljd,
             vc_lx,
             vc_nf,
             vc_0nld,
             vc_1nld,
             vc_5nld,
             vc_10nld,
             vc_15nld,
             vc_20nld,
             vc_25nld,
             vc_30nld,
             vc_35nld,
             vc_40nld,
             vc_45nld,
             vc_50nld,
             vc_55nld,
             vc_60nld,
             vc_65nld,
             vc_70nld,
             vc_75nld,
             vc_80nld,
             vc_85nld,
             vc_zrks,
             vc_nhj,
             vc_vhj,
             vc_zhj,
             vc_xtlb,
             vc_ganhj,
             vc_gavhj,
             vc_gazhj)
            select sys_guid(),
                   vc_rkglsf,
                   vc_rkgls,
                   vc_rkglq,
                   vc_rkgljd,
                   '2',
                   vc_nf,
                   vc_0nld,
                   vc_1nld,
                   vc_5nld,
                   vc_10nld,
                   vc_15nld,
                   vc_20nld,
                   vc_25nld,
                   vc_30nld,
                   vc_35nld,
                   vc_40nld,
                   vc_45nld,
                   vc_50nld,
                   vc_55nld,
                   vc_60nld,
                   vc_65nld,
                   vc_70nld,
                   vc_75nld,
                   vc_80nld,
                   vc_85nld,
                   vc_zrks,
                   vc_nhj,
                   vc_vhj,
                   vc_zhj,
                   vc_xtlb,
                   vc_ganhj,
                   vc_gavhj,
                   vc_gazhj
              from zjmb_rkglb
             where vc_rkgls = v_dq2
               and vc_rkglq = v_dq3
               and vc_rkgljd = '99999999'
               and vc_lx = '5'
               and vc_nf = substr(v_nd, 3, 2);
        end if;
        --写入上年度合计
        insert into zjmb_rkglb
          (vc_rkglid,
           vc_rkglsf,
           vc_rkgls,
           vc_rkglq,
           vc_rkgljd,
           vc_lx,
           vc_nf,
           vc_0nld,
           vc_1nld,
           vc_5nld,
           vc_10nld,
           vc_15nld,
           vc_20nld,
           vc_25nld,
           vc_30nld,
           vc_35nld,
           vc_40nld,
           vc_45nld,
           vc_50nld,
           vc_55nld,
           vc_60nld,
           vc_65nld,
           vc_70nld,
           vc_75nld,
           vc_80nld,
           vc_85nld,
           vc_zrks,
           vc_nhj,
           vc_vhj,
           vc_zhj,
           vc_xtlb,
           vc_ganhj,
           vc_gavhj,
           vc_gazhj)
          select sys_guid(),
                 vc_rkglsf,
                 vc_rkgls,
                 vc_rkglq,
                 vc_rkgljd,
                 '3',
                 to_number(vc_nf) + 1,
                 vc_0nld,
                 vc_1nld,
                 vc_5nld,
                 vc_10nld,
                 vc_15nld,
                 vc_20nld,
                 vc_25nld,
                 vc_30nld,
                 vc_35nld,
                 vc_40nld,
                 vc_45nld,
                 vc_50nld,
                 vc_55nld,
                 vc_60nld,
                 vc_65nld,
                 vc_70nld,
                 vc_75nld,
                 vc_80nld,
                 vc_85nld,
                 vc_zrks,
                 vc_nhj,
                 vc_vhj,
                 vc_zhj,
                 vc_xtlb,
                 vc_ganhj,
                 vc_gavhj,
                 vc_gazhj
            from zjmb_rkglb
           where vc_rkgls = v_dq2
             and vc_rkglq = v_dq3
             and vc_rkgljd = '99999999'
             and vc_lx = '6'
             and vc_nf = substr(v_nd, 3, 2) - 1;
        if sql%rowcount = 0 then
          --未获取到上年
          insert into zjmb_rkglb
            (vc_rkglid,
             vc_rkglsf,
             vc_rkgls,
             vc_rkglq,
             vc_rkgljd,
             vc_lx,
             vc_nf,
             vc_0nld,
             vc_1nld,
             vc_5nld,
             vc_10nld,
             vc_15nld,
             vc_20nld,
             vc_25nld,
             vc_30nld,
             vc_35nld,
             vc_40nld,
             vc_45nld,
             vc_50nld,
             vc_55nld,
             vc_60nld,
             vc_65nld,
             vc_70nld,
             vc_75nld,
             vc_80nld,
             vc_85nld,
             vc_zrks,
             vc_nhj,
             vc_vhj,
             vc_zhj,
             vc_xtlb,
             vc_ganhj,
             vc_gavhj,
             vc_gazhj)
            select sys_guid(),
                   vc_rkglsf,
                   vc_rkgls,
                   vc_rkglq,
                   vc_rkgljd,
                   '3',
                   vc_nf,
                   vc_0nld,
                   vc_1nld,
                   vc_5nld,
                   vc_10nld,
                   vc_15nld,
                   vc_20nld,
                   vc_25nld,
                   vc_30nld,
                   vc_35nld,
                   vc_40nld,
                   vc_45nld,
                   vc_50nld,
                   vc_55nld,
                   vc_60nld,
                   vc_65nld,
                   vc_70nld,
                   vc_75nld,
                   vc_80nld,
                   vc_85nld,
                   vc_zrks,
                   vc_nhj,
                   vc_vhj,
                   vc_zhj,
                   vc_xtlb,
                   vc_ganhj,
                   vc_gavhj,
                   vc_gazhj
              from zjmb_rkglb
             where vc_rkgls = v_dq2
               and vc_rkglq = v_dq3
               and vc_rkgljd = '99999999'
               and vc_lx = '6'
               and vc_nf = substr(v_nd, 3, 2);
        end if;
        --写入平均人口
        --处理男平均
        insert into zjmb_rkglb
          (vc_rkglid,
           vc_rkglsf,
           vc_rkgls,
           vc_rkglq,
           vc_rkgljd,
           vc_lx,
           vc_nf,
           vc_0nld,
           vc_1nld,
           vc_5nld,
           vc_10nld,
           vc_15nld,
           vc_20nld,
           vc_25nld,
           vc_30nld,
           vc_35nld,
           vc_40nld,
           vc_45nld,
           vc_50nld,
           vc_55nld,
           vc_60nld,
           vc_65nld,
           vc_70nld,
           vc_75nld,
           vc_80nld,
           vc_85nld,
           vc_nhj)
          select sys_guid(),
                 max(vc_rkglsf),
                 max(vc_rkgls),
                 max(vc_rkglq),
                 max(vc_rkgljd),
                 '7',
                 max(vc_nf),
                 sum(vc_0nld) / 2,
                 sum(vc_1nld) / 2,
                 sum(vc_5nld) / 2,
                 sum(vc_10nld) / 2,
                 sum(vc_15nld) / 2,
                 sum(vc_20nld) / 2,
                 sum(vc_25nld) / 2,
                 sum(vc_30nld) / 2,
                 sum(vc_35nld) / 2,
                 sum(vc_40nld) / 2,
                 sum(vc_45nld) / 2,
                 sum(vc_50nld) / 2,
                 sum(vc_55nld) / 2,
                 sum(vc_60nld) / 2,
                 sum(vc_65nld) / 2,
                 sum(vc_70nld) / 2,
                 sum(vc_75nld) / 2,
                 sum(vc_80nld) / 2,
                 sum(vc_85nld) / 2,
                 sum(vc_nhj) / 2
            from zjmb_rkglb
           where vc_rkgls = v_dq2
             and vc_rkglq = v_dq3
             and vc_rkgljd = '99999999'
             and vc_lx in ('1', '4')
             and vc_nf = substr(v_nd, 3, 2);
        --处理女平均
        insert into zjmb_rkglb
          (vc_rkglid,
           vc_rkglsf,
           vc_rkgls,
           vc_rkglq,
           vc_rkgljd,
           vc_lx,
           vc_nf,
           vc_0nld,
           vc_1nld,
           vc_5nld,
           vc_10nld,
           vc_15nld,
           vc_20nld,
           vc_25nld,
           vc_30nld,
           vc_35nld,
           vc_40nld,
           vc_45nld,
           vc_50nld,
           vc_55nld,
           vc_60nld,
           vc_65nld,
           vc_70nld,
           vc_75nld,
           vc_80nld,
           vc_85nld,
           vc_vhj)
          select sys_guid(),
                 max(vc_rkglsf),
                 max(vc_rkgls),
                 max(vc_rkglq),
                 max(vc_rkgljd),
                 '8',
                 max(vc_nf),
                 sum(vc_0nld) / 2,
                 sum(vc_1nld) / 2,
                 sum(vc_5nld) / 2,
                 sum(vc_10nld) / 2,
                 sum(vc_15nld) / 2,
                 sum(vc_20nld) / 2,
                 sum(vc_25nld) / 2,
                 sum(vc_30nld) / 2,
                 sum(vc_35nld) / 2,
                 sum(vc_40nld) / 2,
                 sum(vc_45nld) / 2,
                 sum(vc_50nld) / 2,
                 sum(vc_55nld) / 2,
                 sum(vc_60nld) / 2,
                 sum(vc_65nld) / 2,
                 sum(vc_70nld) / 2,
                 sum(vc_75nld) / 2,
                 sum(vc_80nld) / 2,
                 sum(vc_85nld) / 2,
                 sum(vc_vhj) / 2
            from zjmb_rkglb
           where vc_rkgls = v_dq2
             and vc_rkglq = v_dq3
             and vc_rkgljd = '99999999'
             and vc_lx in ('2', '5')
             and vc_nf = substr(v_nd, 3, 2);
        --处理男女合计
        insert into zjmb_rkglb
          (vc_rkglid,
           vc_rkglsf,
           vc_rkgls,
           vc_rkglq,
           vc_rkgljd,
           vc_lx,
           vc_nf,
           vc_0nld,
           vc_1nld,
           vc_5nld,
           vc_10nld,
           vc_15nld,
           vc_20nld,
           vc_25nld,
           vc_30nld,
           vc_35nld,
           vc_40nld,
           vc_45nld,
           vc_50nld,
           vc_55nld,
           vc_60nld,
           vc_65nld,
           vc_70nld,
           vc_75nld,
           vc_80nld,
           vc_85nld,
           vc_zhj)
          select sys_guid(),
                 max(vc_rkglsf),
                 max(vc_rkgls),
                 max(vc_rkglq),
                 max(vc_rkgljd),
                 '9',
                 max(vc_nf),
                 sum(vc_0nld) / 2,
                 sum(vc_1nld) / 2,
                 sum(vc_5nld) / 2,
                 sum(vc_10nld) / 2,
                 sum(vc_15nld) / 2,
                 sum(vc_20nld) / 2,
                 sum(vc_25nld) / 2,
                 sum(vc_30nld) / 2,
                 sum(vc_35nld) / 2,
                 sum(vc_40nld) / 2,
                 sum(vc_45nld) / 2,
                 sum(vc_50nld) / 2,
                 sum(vc_55nld) / 2,
                 sum(vc_60nld) / 2,
                 sum(vc_65nld) / 2,
                 sum(vc_70nld) / 2,
                 sum(vc_75nld) / 2,
                 sum(vc_80nld) / 2,
                 sum(vc_85nld) / 2,
                 sum(vc_zhj) / 2
            from zjmb_rkglb
           where vc_rkgls = v_dq2
             and vc_rkglq = v_dq3
             and vc_rkgljd = '99999999'
             and vc_lx in ('3', '6')
             and vc_nf = substr(v_nd, 3, 2);
        --更新个案合计
        update zjmb_rkglb a
           set a.vc_ganhj =
               (select max(vc_nhj)
                  from zjmb_rkglb b
                 where a.vc_nf = b.vc_nf
                   and a.vc_rkgls = b.vc_rkgls
                   and a.vc_rkglq = b.vc_rkglq
                   and a.vc_rkgljd = b.vc_rkgljd
                   and b.vc_lx = '4'),
               a.vc_gavhj =
               (select max(vc_vhj)
                  from zjmb_rkglb b
                 where a.vc_nf = b.vc_nf
                   and a.vc_rkgls = b.vc_rkgls
                   and a.vc_rkglq = b.vc_rkglq
                   and a.vc_rkgljd = b.vc_rkgljd
                   and b.vc_lx = '5'),
               a.vc_gazhj =
               (select max(vc_zhj)
                  from zjmb_rkglb b
                 where a.vc_nf = b.vc_nf
                   and a.vc_rkgls = b.vc_rkgls
                   and a.vc_rkglq = b.vc_rkglq
                   and a.vc_rkgljd = b.vc_rkgljd
                   and b.vc_lx = '6')
         where a.vc_rkgls = v_dq2
           and a.vc_rkglq = v_dq3
           and a.vc_rkgljd = '99999999'
           and a.vc_nf = substr(v_nd, 3, 2);
      end if;
    end loop;
    --添加操作日志
    v_json_yw_log := Json_ext.get_json(v_json_data, 'ywjllog');
    if v_json_yw_log is not null then
      v_json_yw_log.put('bgkid', '');
      v_json_yw_log.put('bgklx', '04');
      v_json_yw_log.put('ywjlid', '');
      v_json_yw_log.put('gnmk', '09');
      v_json_yw_log.put('gnmc', '导入');
      v_json_yw_log.put('czlx', '05');
      pkg_zjmb_xtfz.prc_zjjk_yw_log_update(v_json_yw_log, v_err);
      if v_err is not null then
        raise err_custom;
      end if;
    end if;
    commit;
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_tjbb_rknlfb_imp;
  /*--------------------------------------------------------------------------
  || 功能描述 ：人口出生数导入
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_tjbb_rkcss_imp(Data_In    In Clob, --入参
                               result_out OUT VARCHAR2) --返回
   is
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err         VARCHAR2(2000);
    v_json_yw_log json;
    v_ywjl_czlx   varchar2(3);
    --公共变量
    v_sysdate        date;
    v_czyjgdm        varchar2(50);
    v_czyjgjb        varchar2(3);
    v_czyyhid        varchar2(50);
    v_json_list_rks  json_List; --出生报告卡
    v_json_list_temp json_List;
    v_dqdm           ZJJK_RKS_CSS.dqdm%type;
    v_nd             ZJJK_RKS_CSS.nd%type;
    v_count          number;
  BEGIN
    json_data(data_in, 'ZJJK_RKS_NLFB人口年龄分布导入', v_json_data);
    v_sysdate       := sysdate;
    v_czyjgdm       := Json_Str(v_Json_Data, 'czyjgdm'); --操作员机构代码
    v_czyyhid       := Json_Str(v_Json_Data, 'czyyhid');
    v_czyjgjb       := Json_Str(v_Json_Data, 'czyjgjb'); --获取机构级别
    v_nd            := Json_Str(v_Json_Data, 'nd'); --获取机构级别
    v_Json_List_rks := Json_Ext.Get_Json_List(v_Json_Data, 'rks_arr'); --人口信息
  
    if v_czyjgdm is null then
      v_err := '未获取到操作员信息!';
      raise err_custom;
    end if;
    if v_czyjgjb not in ('1') then
      v_err := '当前机构无导入权限!';
      raise err_custom;
    end if;
    if v_nd is null then
      v_err := '未获取到导入年度!';
      raise err_custom;
    end if;
    --检查年度是否已导入
    select count(1)
      into v_count
      from ZJJK_RKS_CSS
     where nd = v_nd
       and zt = 1
       and rownum = 1;
    if v_count > 0 then
      v_err := '年度【' || v_nd || '】已导入人口数据!';
      raise err_custom;
    end if;
    --写入数据
    if v_Json_List_rks.count > 0 then
      for i in 1 .. v_Json_List_rks.count loop
        v_json_list_temp := json_List(v_Json_List_rks.Get(i));
        if v_json_list_temp.count > 0 then
          v_dqdm := v_json_list_temp.Get(1).get_string;
          if v_dqdm is null then
            v_err := '地区代码不能为空!';
            raise err_custom;
          end if;
          insert into zjjk_rks_css
            (dqdm, dqmc, nd, cssm, cssn, cjsj, cjyh, cjjg, zt, xh)
          values
            (v_dqdm,
             v_json_list_temp.Get(2).get_string,
             v_nd,
             v_json_list_temp.Get(3).get_string,
             v_json_list_temp.Get(4).get_string,
             v_sysdate,
             v_czyyhid,
             v_czyjgdm,
             1,
             i);
        end if;
      end loop;
    else
      v_err := '未获取到需要导入的数据!';
      raise err_custom;
    end if;
    --添加操作日志
    v_json_yw_log := Json_ext.get_json(v_json_data, 'ywjllog');
    if v_json_yw_log is not null then
      v_json_yw_log.put('bgkid', '');
      v_json_yw_log.put('bgklx', '04');
      v_json_yw_log.put('ywjlid', '');
      v_json_yw_log.put('gnmk', '09');
      v_json_yw_log.put('gnmc', '导入');
      v_json_yw_log.put('czlx', '05');
      pkg_zjmb_xtfz.prc_zjjk_yw_log_update(v_json_yw_log, v_err);
      if v_err is not null then
        raise err_custom;
      end if;
    end if;
    commit;
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_tjbb_rkcss_imp;
  /*--------------------------------------------------------------------------
  || 功能描述 ：死因质控报告地区
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_tjbb_sw_syzk_bgdq(Data_In    In Clob, --入参
                                  result_out OUT VARCHAR2) --返回 
   is
    v_json_data   json;
    v_json_yw_log json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
    --公共变量
    v_sysdate date;
    v_czyjgdm varchar2(50);
    v_czyyhid varchar2(50);
    v_czyjgjb varchar2(3);
    v_czyyhxm varchar2(50);
    v_id      zjjk_tjbb_sw_syzk_bgdq.id%type;
    v_bblx    zjjk_tjbb_sw_syzk_bgdq.bblx%type;
    v_bbqh    zjjk_tjbb_sw_syzk_bgdq.bbqh%type;
    v_sjlx    zjjk_tjbb_sw_syzk_bgdq.sjlx%type;
    v_kssj    date;
    v_jssj    date;
    v_vc_hks  varchar2(50);
    v_vc_hkqx varchar2(50);
    v_vc_hkjd varchar2(50);
    v_sj_xzqh varchar2(50);
    v_sj_xzmc varchar2(50);
    v_vc_gldw varchar2(50);
    v_y       number(4);
    v_q       number(4);
    v_m       number(4);
  
  BEGIN
    json_data(data_in, '死因监测报告地区', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm'); --操作员机构代码
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb'); --获取机构级别
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid'); --操作员id
    v_czyyhxm := Json_Str(v_Json_Data, 'czyyhxm'); --操作员姓名
  
    v_bblx    := Json_Str(v_Json_Data, 'bblx');
    v_sjlx    := Json_Str(v_Json_Data, 'sjlx');
    v_bbqh    := Json_Str(v_Json_Data, 'bbqh');
    v_vc_hks  := Json_Str(v_Json_Data, 'vc_hks');
    v_vc_hkqx := Json_Str(v_Json_Data, 'vc_hkqx');
    v_vc_hkjd := Json_Str(v_Json_Data, 'vc_hkjd');
    v_vc_gldw := Json_Str(v_Json_Data, 'vc_gldw');
    --判断操作员级别
    if v_czyjgjb not in ('1', '2', '3') then
      v_err := '操作员无此权限!';
      raise err_custom;
    end if;
    --判断市代码
    if v_vc_hks is null and v_czyjgjb <> '1' then
      v_err := '请选择统计市代码!';
      raise err_custom;
    end if;
    --判断区县
    if v_vc_hkqx is null and v_czyjgjb = '3' then
      v_err := '请选择统计区县代码!';
      raise err_custom;
    end if;
    --判断时间类型
    if nvl(v_sjlx, '0') not in ('1', '2') then
      v_err := '请选择时间类型!';
      raise err_custom;
    end if;
    --判断统计行政区划
    --统计地市,上级区划取浙江省
    if v_vc_hks is null then
      v_sj_xzqh := '33000000';
    end if;
    --统计区县，上级取市
    if v_vc_hks is not null and v_vc_hkqx is null then
      v_sj_xzqh := v_vc_hks;
    end if;
    --统计机构上级取区县
    if v_vc_hkqx is not null then
      v_sj_xzqh := v_vc_hkqx;
    end if;
    --获取上级行政名称
    select max(mc) into v_sj_xzmc from p_xzdm where dm = v_sj_xzqh;
    v_id := sys_guid();
    --计算时间
    if v_bblx is null then
      v_err := '报表类型不能为空!';
      raise err_custom;
    end if;
    if v_bbqh is null then
      v_err := '报表期号不能为空!';
      raise err_custom;
    end if;
    --年报
    begin
      if v_bblx = 'Y' then
        v_kssj := to_date(v_bbqh || '-01-01 00:00:00',
                          'yyyy-MM-dd hh24:mi:ss');
        v_jssj := to_date(v_bbqh || '-12-31 23:59:59',
                          'yyyy-MM-dd hh24:mi:ss');
      elsif v_bblx = 'Q' then
        v_y := substr(v_bbqh, 1, 4);
        v_q := to_number(substr(v_bbqh, 5, 1));
        if v_q = 1 then
          v_kssj := to_date(v_y || '-01-01 00:00:00',
                            'yyyy-MM-dd hh24:mi:ss');
          v_jssj := to_date(v_y || '-03-31 23:59:59',
                            'yyyy-MM-dd hh24:mi:ss');
        elsif v_q = 2 then
          v_kssj := to_date(v_y || '-04-01 00:00:00',
                            'yyyy-MM-dd hh24:mi:ss');
          v_jssj := to_date(v_y || '-06-30 23:59:59',
                            'yyyy-MM-dd hh24:mi:ss');
        elsif v_q = 3 then
          v_kssj := to_date(v_y || '-07-01 00:00:00',
                            'yyyy-MM-dd hh24:mi:ss');
          v_jssj := to_date(v_y || '-09-30 23:59:59',
                            'yyyy-MM-dd hh24:mi:ss');
        elsif v_q = 4 then
          v_kssj := to_date(v_y || '-10-01 00:00:00',
                            'yyyy-MM-dd hh24:mi:ss');
          v_jssj := to_date(v_y || '-12-31 23:59:59',
                            'yyyy-MM-dd hh24:mi:ss');
        else
          v_err := '期号格式不正确!';
          raise err_custom;
        end if;
      elsif v_bblx = 'M' then
        v_y    := substr(v_bbqh, 1, 4);
        v_m    := to_number(substr(v_bbqh, 5, 2));
        v_kssj := to_date(v_y || '-' || v_m || '-01 00:00:00',
                          'yyyy-MM-dd hh24:mi:ss');
        v_jssj := trunc(add_months(v_kssj, 1)) - 1 / (24 * 60 * 60);
      end if;
    exception
      WHEN OTHERS THEN
        v_err := '期号格式不正确!';
        raise err_custom;
    end;
    --统计机构
    if v_vc_hkqx is not null then
      v_sj_xzqh := substr(v_vc_hkqx, 0, 6);
      --J1为疾控中心，需排除
      for jg_list in (select dm, mc
                        from p_yljg
                       where dm like v_sj_xzqh || '%'
                         and lb <> 'J1') loop
        insert into zjjk_tjbb_sw_syzk_bgdq
          (id,
           dwdm,
           dwmc,
           bblx,
           bbqh,
           sjdwdm,
           sjdwdwmc,
           bks,
           bgjss,
           sfzhtbs,
           dsyltbs,
           cks,
           sybms,
           gbbmbzqs,
           cjsj,
           cjyh,
           cjjgdm,
           sjlx)
        values
          (v_id,
           jg_list.dm,
           jg_list.mc,
           v_bblx,
           v_bbqh,
           v_vc_hkqx,
           v_sj_xzmc,
           0,
           0,
           0,
           0,
           0,
           0,
           0,
           v_sysdate,
           v_czyyhid,
           v_czyjgdm,
           v_sjlx);
      end loop;
      --查询报卡数据
      for tj_list in (select t.vc_cjdwdm,
                             count(*) as bks,
                             sum(case
                                   when (dt_cjsj - dt_swrq <= 7 or
                                        dt_cjsj - dt_dcrq <= 7) and
                                        vc_swdd <> '1' then
                                    1
                                   else
                                    0
                                 end) as bgjss,
                             sum(case
                                   when vc_sfzhm is not null then
                                    1
                                   else
                                    0
                                 end) sfzhtbs,
                             sum(case
                                   when t.nb_azjswjbicd is not null and
                                        t.nb_azjswjbicd not in
                                        ('J96', 'R57.9', 'R99', 'R53', 'I50') and
                                        t.nb_bzjswjbidc is not null then
                                    1
                                   else
                                    0
                                 end) dsyltbs,
                             sum(case
                                   when (upper(substr(t.vc_gbsy, 1, 1)) in
                                        ('R', 'S', 'T')) or
                                        upper(t.vc_gbsy) in
                                        ('Y87.2',
                                         'I47.2',
                                         'I49.0',
                                         'I46',
                                         'I50-',
                                         'I51.4',
                                         'I51.5',
                                         'I51.6',
                                         'I51.9',
                                         'I70.9',
                                         'I10',
                                         'J96.-',
                                         'K72.-',
                                         'C76.-',
                                         'C80.-',
                                         'C97.-',
                                         'N17',
                                         'N18',
                                         'N19',
                                         'Y10',
                                         'Y11',
                                         'Y12',
                                         'Y13',
                                         'Y14',
                                         'Y15',
                                         'Y16',
                                         'Y17',
                                         'Y18',
                                         'Y19',
                                         'Y20',
                                         'Y21',
                                         'Y22',
                                         'Y23',
                                         'Y24',
                                         'Y25',
                                         'Y26',
                                         'Y27',
                                         'Y28',
                                         'Y29',
                                         'Y30',
                                         'Y31',
                                         'Y32',
                                         'Y33',
                                         'Y34') then
                                    1
                                   else
                                    0
                                 end) gbbmbzqs,
                             sum(case
                                   when fenleitj in ('80', '90') then
                                    1
                                   else
                                    0
                                 end) sybms
                        from zjmb_sw_bgk t
                       where t.vc_scbz = '2'
                         and t.vc_shbz in ('3', '5', '6', '7', '8')
                         and t.vc_bgklb = '0'
                         and t.vc_cjdwdm like v_sj_xzqh || '%'
                         and decode(v_sjlx, '1', t.dt_cjsj, t.dt_swrq) >=
                             v_kssj
                         and decode(v_sjlx, '1', t.dt_cjsj, t.dt_swrq) <=
                             v_jssj
                       group by t.vc_cjdwdm) loop
        --更新数据
        update zjjk_tjbb_sw_syzk_bgdq
           set bks      = tj_list.bks,
               bgjss    = tj_list.bgjss,
               sfzhtbs  = tj_list.sfzhtbs,
               dsyltbs  = tj_list.dsyltbs,
               sybms    = tj_list.sybms,
               gbbmbzqs = tj_list.gbbmbzqs
         where id = v_id
           and dwdm = tj_list.vc_cjdwdm;
      end loop;
      for ck_list in (select count(distinct a.vc_bgkid) cks, a.vc_cjdwdm
                        from zjmb_sw_bgk a, zjmb_sw_bgk b
                       where a.vc_bgkid <> b.vc_bgkid
                         and a.vc_cjdwdm = b.vc_cjdwdm
                         and ((a.vc_xm = b.vc_xm and a.vc_xb = b.vc_xb and
                             a.dt_csrq = b.dt_csrq and
                             a.dt_swrq = b.dt_swrq and
                             a.vc_gbsy = b.vc_gbsy and
                             (a.vc_sfzhm <> b.vc_sfzhm or
                             (a.vc_sfzhm is null or b.vc_sfzhm is null))) or
                             (a.vc_sfzhm = b.vc_sfzhm and
                             length(a.vc_sfzhm) > 14 and
                             length(b.vc_sfzhm) > 14))
                         and a.vc_scbz = '2'
                         and a.vc_shbz in ('3', '5', '6', '7', '8')
                         and a.vc_bgklb = '0'
                         and a.vc_cjdwdm like v_sj_xzqh || '%'
                         and decode(v_sjlx, '1', a.dt_cjsj, a.dt_swrq) >=
                             v_kssj
                         and decode(v_sjlx, '1', a.dt_cjsj, a.dt_swrq) <=
                             v_jssj
                         and b.vc_scbz = '2'
                         and b.vc_shbz in ('3', '5', '6', '7', '8')
                         and b.vc_bgklb = '0'
                         and decode(v_sjlx, '1', b.dt_cjsj, b.dt_swrq) <=
                             v_jssj
                       group by a.vc_cjdwdm) loop
        --更新重卡
        update zjjk_tjbb_sw_syzk_bgdq
           set cks = ck_list.cks
         where id = v_id
           and dwdm = ck_list.vc_cjdwdm;
      end loop;
    else
      --统计地市或区县
      insert into zjjk_tjbb_sw_syzk_bgdq
        (id,
         dwdm,
         dwmc,
         bblx,
         bbqh,
         sjdwdm,
         sjdwdwmc,
         bks,
         bgjss,
         sfzhtbs,
         dsyltbs,
         cks,
         sybms,
         gbbmbzqs,
         cjsj,
         cjyh,
         cjjgdm,
         sjlx)
        select v_id,
               dm,
               mc,
               v_bblx,
               v_bbqh,
               v_sj_xzqh,
               v_sj_xzmc,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               v_sysdate,
               v_czyyhid,
               v_czyjgdm,
               v_sjlx
          from p_xzdm
         where sjid = v_sj_xzqh;
      --查询报卡数据
      for tj_list in (select qh.dm,
                             count(*) as bks,
                             sum(case
                                   when (dt_cjsj - dt_swrq <= 7 or
                                        dt_cjsj - dt_dcrq <= 7) and
                                        vc_swdd <> '1' then
                                    1
                                   else
                                    0
                                 end) as bgjss,
                             sum(case
                                   when vc_sfzhm is not null then
                                    1
                                   else
                                    0
                                 end) sfzhtbs,
                             sum(case
                                   when t.nb_azjswjbicd is not null and
                                        t.nb_azjswjbicd not in
                                        ('J96', 'R57.9', 'R99', 'R53', 'I50') and
                                        t.nb_bzjswjbidc is not null then
                                    1
                                   else
                                    0
                                 end) dsyltbs,
                             sum(case
                                   when vc_bgklb = '4' then
                                    1
                                   else
                                    0
                                 end) cks,
                             sum(case
                                   when (upper(substr(t.vc_gbsy, 1, 1)) in
                                        ('R', 'S', 'T')) or
                                        upper(t.vc_gbsy) in
                                        ('Y87.2',
                                         'I47.2',
                                         'I49.0',
                                         'I46',
                                         'I50-',
                                         'I51.4',
                                         'I51.5',
                                         'I51.6',
                                         'I51.9',
                                         'I70.9',
                                         'I10',
                                         'J96.-',
                                         'K72.-',
                                         'C76.-',
                                         'C80.-',
                                         'C97.-',
                                         'N17',
                                         'N18',
                                         'N19',
                                         'Y10',
                                         'Y11',
                                         'Y12',
                                         'Y13',
                                         'Y14',
                                         'Y15',
                                         'Y16',
                                         'Y17',
                                         'Y18',
                                         'Y19',
                                         'Y20',
                                         'Y21',
                                         'Y22',
                                         'Y23',
                                         'Y24',
                                         'Y25',
                                         'Y26',
                                         'Y27',
                                         'Y28',
                                         'Y29',
                                         'Y30',
                                         'Y31',
                                         'Y32',
                                         'Y33',
                                         'Y34') then
                                    1
                                   else
                                    0
                                 end) gbbmbzqs,
                             sum(case
                                   when fenleitj in ('80', '90') then
                                    1
                                   else
                                    0
                                 end) sybms
                        from zjmb_sw_bgk t, p_xzdm qh
                       where t.vc_scbz = '2'
                         and t.vc_cjdwdm like (case
                               when v_vc_hks is null then
                                substr(qh.dm, 1, 4) || '%'
                               else
                                substr(qh.dm, 1, 6) || '%'
                             end)
                         and qh.sjid = v_sj_xzqh
                         and t.vc_shbz in ('3', '5', '6', '7', '8')
                         and t.vc_bgklb = '0'
                         and decode(v_sjlx, '1', t.dt_cjsj, t.dt_swrq) >=
                             v_kssj
                         and decode(v_sjlx, '1', t.dt_cjsj, t.dt_swrq) <=
                             v_jssj
                       group by qh.dm) loop
        --更新数据
        update zjjk_tjbb_sw_syzk_bgdq
           set bks      = tj_list.bks,
               bgjss    = tj_list.bgjss,
               sfzhtbs  = tj_list.sfzhtbs,
               cks      = tj_list.cks,
               dsyltbs  = tj_list.dsyltbs,
               sybms    = tj_list.sybms,
               gbbmbzqs = tj_list.gbbmbzqs
         where id = v_id
           and dwdm = tj_list.dm;
      end loop;
      for ck_list in (select count(distinct a.vc_bgkid) cks, qh.dm
                        from zjmb_sw_bgk a, zjmb_sw_bgk b, p_xzdm qh
                       where a.vc_bgkid <> b.vc_bgkid
                         and case
                               when v_vc_hks is null then
                                substr(a.vc_cjdwdm, 1, 4)
                               else
                                substr(a.vc_cjdwdm, 1, 6)
                             end = case
                               when v_vc_hks is null then
                                substr(b.vc_cjdwdm, 1, 4)
                               else
                                substr(b.vc_cjdwdm, 1, 6)
                             end
                         and ((a.vc_xm = b.vc_xm and a.vc_xb = b.vc_xb and
                             a.dt_csrq = b.dt_csrq and
                             a.dt_swrq = b.dt_swrq and
                             a.vc_gbsy = b.vc_gbsy and
                             (a.vc_sfzhm <> b.vc_sfzhm or
                             (a.vc_sfzhm is null or b.vc_sfzhm is null))) or
                             (a.vc_sfzhm = b.vc_sfzhm and
                             length(a.vc_sfzhm) > 14 and
                             length(b.vc_sfzhm) > 14))
                         and qh.sjid = v_sj_xzqh
                         and a.vc_scbz = '2'
                         and a.vc_shbz in ('3', '5', '6', '7', '8')
                         and a.vc_bgklb = '0'
                         and a.vc_cjdwdm like (case
                               when v_vc_hks is null then
                                substr(qh.dm, 1, 4) || '%'
                               else
                                substr(qh.dm, 1, 6) || '%'
                             end)
                         and decode(v_sjlx, '1', a.dt_cjsj, a.dt_swrq) >=
                             v_kssj
                         and decode(v_sjlx, '1', a.dt_cjsj, a.dt_swrq) <=
                             v_jssj
                         and b.vc_scbz = '2'
                         and b.vc_shbz in ('3', '5', '6', '7', '8')
                         and b.vc_bgklb = '0'
                         and decode(v_sjlx, '1', b.dt_cjsj, b.dt_swrq) <=
                             v_jssj
                       group by qh.dm) loop
        --更新重卡
        update zjjk_tjbb_sw_syzk_bgdq
           set cks = ck_list.cks
         where id = v_id
           and dwdm = ck_list.dm;
      end loop;
    end if;
    commit;
    result_out := Return_Succ_Json(v_json_return);
  
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_tjbb_sw_syzk_bgdq;
  /*--------------------------------------------------------------------------
  || 功能描述 ：死因质控户籍地区
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_tjbb_sw_syzk_hjdq(Data_In    In Clob, --入参
                                  result_out OUT VARCHAR2) --返回
   is
    v_json_data   json;
    v_json_yw_log json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
    --公共变量
    v_sysdate date;
    v_czyjgdm varchar2(50);
    v_czyyhid varchar2(50);
    v_czyjgjb varchar2(3);
    v_czyyhxm varchar2(50);
    v_id      zjjk_tjbb_sw_syzk_hjdq.id%type;
    v_bblx    zjjk_tjbb_sw_syzk_hjdq.bblx%type;
    v_bbqh    zjjk_tjbb_sw_syzk_hjdq.bbqh%type;
    v_sjlx    zjjk_tjbb_sw_syzk_hjdq.sjlx%type;
    v_kssj    date;
    v_jssj    date;
    v_vc_hks  varchar2(50);
    v_vc_hkqx varchar2(50);
    v_vc_hkjd varchar2(50);
    v_sj_xzqh varchar2(50);
    v_sj_xzmc varchar2(50);
    v_vc_gldw varchar2(50);
    v_y       number(4);
    v_q       number(4);
    v_m       number(4);
  
  BEGIN
    json_data(data_in, '死因监测户籍地区', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm'); --操作员机构代码
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb'); --获取机构级别
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid'); --操作员id
    v_czyyhxm := Json_Str(v_Json_Data, 'czyyhxm'); --操作员姓名
  
    v_bblx    := Json_Str(v_Json_Data, 'bblx');
    v_sjlx    := Json_Str(v_Json_Data, 'sjlx');
    v_bbqh    := Json_Str(v_Json_Data, 'bbqh');
    v_vc_hks  := Json_Str(v_Json_Data, 'vc_hks');
    v_vc_hkqx := Json_Str(v_Json_Data, 'vc_hkqx');
    v_vc_hkjd := Json_Str(v_Json_Data, 'vc_hkjd');
    v_vc_gldw := Json_Str(v_Json_Data, 'vc_gldw');
    --判断操作员级别
    if v_czyjgjb not in ('1', '2', '3') then
      v_err := '操作员无此权限!';
      raise err_custom;
    end if;
    --判断市代码
    if v_vc_hks is null and v_czyjgjb <> '1' then
      v_err := '请选择统计市代码!';
      raise err_custom;
    end if;
    --判断区县
    if v_vc_hkqx is null and v_czyjgjb = '3' then
      v_err := '请选择统计区县代码!';
      raise err_custom;
    end if;
    --判断时间类型
    if nvl(v_sjlx, '0') not in ('1', '2') then
      v_err := '请选择时间类型!';
      raise err_custom;
    end if;
    --判断统计行政区划
    --统计地市,上级区划取浙江省
    if v_vc_hks is null then
      v_sj_xzqh := '33000000';
    end if;
    --统计区县，上级取市
    if v_vc_hks is not null and v_vc_hkqx is null then
      v_sj_xzqh := v_vc_hks;
    end if;
    --统计机构上级取区县
    if v_vc_hkqx is not null then
      v_sj_xzqh := v_vc_hkqx;
    end if;
    --获取上级行政名称
    select max(mc) into v_sj_xzmc from p_xzdm where dm = v_sj_xzqh;
    v_id := sys_guid();
    --计算时间
    if v_bblx is null then
      v_err := '报表类型不能为空!';
      raise err_custom;
    end if;
    if v_bbqh is null then
      v_err := '报表期号不能为空!';
      raise err_custom;
    end if;
    --年报
    begin
      if v_bblx = 'Y' then
        v_y    := v_bbqh;
        v_kssj := to_date(v_bbqh || '-01-01 00:00:00',
                          'yyyy-MM-dd hh24:mi:ss');
        v_jssj := to_date(v_bbqh || '-12-31 23:59:59',
                          'yyyy-MM-dd hh24:mi:ss');
      elsif v_bblx = 'Q' then
        v_y := substr(v_bbqh, 1, 4);
        v_q := to_number(substr(v_bbqh, 5, 1));
        if v_q = 1 then
          v_kssj := to_date(v_y || '-01-01 00:00:00',
                            'yyyy-MM-dd hh24:mi:ss');
          v_jssj := to_date(v_y || '-03-31 23:59:59',
                            'yyyy-MM-dd hh24:mi:ss');
        elsif v_q = 2 then
          v_kssj := to_date(v_y || '-04-01 00:00:00',
                            'yyyy-MM-dd hh24:mi:ss');
          v_jssj := to_date(v_y || '-06-30 23:59:59',
                            'yyyy-MM-dd hh24:mi:ss');
        elsif v_q = 3 then
          v_kssj := to_date(v_y || '-07-01 00:00:00',
                            'yyyy-MM-dd hh24:mi:ss');
          v_jssj := to_date(v_y || '-09-30 23:59:59',
                            'yyyy-MM-dd hh24:mi:ss');
        elsif v_q = 4 then
          v_kssj := to_date(v_y || '-10-01 00:00:00',
                            'yyyy-MM-dd hh24:mi:ss');
          v_jssj := to_date(v_y || '-12-31 23:59:59',
                            'yyyy-MM-dd hh24:mi:ss');
        else
          v_err := '期号格式不正确!';
          raise err_custom;
        end if;
      elsif v_bblx = 'M' then
        v_y    := substr(v_bbqh, 1, 4);
        v_m    := to_number(substr(v_bbqh, 5, 2));
        v_kssj := to_date(v_y || '-' || v_m || '-01 00:00:00',
                          'yyyy-MM-dd hh24:mi:ss');
        v_jssj := trunc(add_months(v_kssj, 1)) - 1 / (24 * 60 * 60);
      end if;
    exception
      WHEN OTHERS THEN
        v_err := '期号格式不正确!';
        raise err_custom;
    end;
    --统计机构
    if v_vc_hkqx is not null then
      v_sj_xzqh := substr(v_vc_hkqx, 0, 6);
      --J1为疾控中心，需排除
      for jg_list in (select dm, mc
                        from p_yljg
                       where dm like v_sj_xzqh || '%'
                         and lb <> 'J1') loop
        insert into zjjk_tjbb_sw_syzk_hjdq
          (id,
           dwdm,
           dwmc,
           bblx,
           bbqh,
           sjdwdm,
           sjdwdwmc,
           bks,
           hjrs,
           shjss,
           sfzhtbs,
           cks,
           dsyltbs,
           sybms,
           gbbmbzqs,
           cfwcs,
           cfjss,
           cjsj,
           cjyh,
           cjjgdm,
           dqlx,
           sjlx)
        values
          (v_id,
           jg_list.dm,
           jg_list.mc,
           v_bblx,
           v_bbqh,
           v_vc_hkqx,
           v_sj_xzmc,
           0,
           0,
           0,
           0,
           0,
           0,
           0,
           0,
           0,
           0,
           v_sysdate,
           v_czyyhid,
           v_czyjgdm,
           '2',
           v_sjlx);
      end loop;
      --查询报卡数据
      for tj_list in (select t.vc_gldwdm,
                             count(*) as bks,
                             sum(case
                                   when t.dt_shsj - t.dt_cjsj <= 7 then
                                    1
                                   else
                                    0
                                 end) as shjss,
                             sum(case
                                   when vc_sfzhm is not null then
                                    1
                                   else
                                    0
                                 end) sfzhtbs,
                             sum(case
                                   when t.nb_azjswjbicd is not null and
                                        t.nb_azjswjbicd not in
                                        ('J96', 'R57.9', 'R99', 'R53', 'I50') and
                                        t.nb_bzjswjbidc is not null then
                                    1
                                   else
                                    0
                                 end) dsyltbs,
                             sum(case
                                   when (upper(substr(t.vc_gbsy, 1, 1)) in
                                        ('R', 'S', 'T')) or
                                        upper(t.vc_gbsy) in
                                        ('Y87.2',
                                         'I47.2',
                                         'I49.0',
                                         'I46',
                                         'I50-',
                                         'I51.4',
                                         'I51.5',
                                         'I51.6',
                                         'I51.9',
                                         'I70.9',
                                         'I10',
                                         'J96.-',
                                         'K72.-',
                                         'C76.-',
                                         'C80.-',
                                         'C97.-',
                                         'N17',
                                         'N18',
                                         'N19',
                                         'Y10',
                                         'Y11',
                                         'Y12',
                                         'Y13',
                                         'Y14',
                                         'Y15',
                                         'Y16',
                                         'Y17',
                                         'Y18',
                                         'Y19',
                                         'Y20',
                                         'Y21',
                                         'Y22',
                                         'Y23',
                                         'Y24',
                                         'Y25',
                                         'Y26',
                                         'Y27',
                                         'Y28',
                                         'Y29',
                                         'Y30',
                                         'Y31',
                                         'Y32',
                                         'Y33',
                                         'Y34') then
                                    1
                                   else
                                    0
                                 end) gbbmbzqs,
                             sum(case
                                   when fenleitj in ('80', '90') then
                                    1
                                   else
                                    0
                                 end) sybms,
                             sum(case
                                   when vc_hkhs is not null then
                                    1
                                   else
                                    0
                                 end) as cfwcs,
                             sum(case
                                   when vc_hkhs is not null and
                                        dt_shsj - dt_cjsj <= 7 then
                                    1
                                   else
                                    0
                                 end) as cfjss
                        from zjmb_sw_bgk t
                       where t.vc_scbz = '2'
                         and t.vc_shbz in ('3', '5', '6', '7', '8')
                         and t.vc_bgklb = '0'
                         and t.vc_gldwdm like v_sj_xzqh || '%'
                         and t.vc_hkqxdm = v_vc_hkqx
                         and decode(v_sjlx, '1', t.dt_cjsj, t.dt_swrq) >=
                             v_kssj
                         and decode(v_sjlx, '1', t.dt_cjsj, t.dt_swrq) <=
                             v_jssj
                       group by t.vc_gldwdm) loop
        --更新数据
        update zjjk_tjbb_sw_syzk_hjdq
           set bks      = tj_list.bks,
               shjss    = tj_list.shjss,
               sfzhtbs  = tj_list.sfzhtbs,
               dsyltbs  = tj_list.dsyltbs,
               sybms    = tj_list.sybms,
               gbbmbzqs = tj_list.gbbmbzqs,
               cfwcs    = tj_list.cfwcs,
               cfjss    = tj_list.cfjss
         where id = v_id
           and dwdm = tj_list.vc_gldwdm;
      end loop;
      for ck_list in (select count(distinct a.vc_bgkid) cks, a.vc_gldwdm
                        from zjmb_sw_bgk a, zjmb_sw_bgk b
                       where a.vc_bgkid <> b.vc_bgkid
                         and a.vc_gldwdm = b.vc_gldwdm
                         and a.vc_hkqxdm = b.vc_hkqxdm
                         and a.vc_hkqxdm = v_vc_hkqx
                         and ((a.vc_xm = b.vc_xm and a.vc_xb = b.vc_xb and
                             a.dt_csrq = b.dt_csrq and
                             a.dt_swrq = b.dt_swrq and
                             a.vc_gbsy = b.vc_gbsy and
                             (a.vc_sfzhm <> b.vc_sfzhm or
                             (a.vc_sfzhm is null or b.vc_sfzhm is null))) or
                             (a.vc_sfzhm = b.vc_sfzhm and
                             length(a.vc_sfzhm) > 14 and
                             length(b.vc_sfzhm) > 14))
                         and a.vc_scbz = '2'
                         and a.vc_shbz in ('3', '5', '6', '7', '8')
                         and a.vc_bgklb = '0'
                         and a.vc_gldwdm like v_sj_xzqh || '%'
                         and decode(v_sjlx, '1', a.dt_cjsj, a.dt_swrq) >=
                             v_kssj
                         and decode(v_sjlx, '1', a.dt_cjsj, a.dt_swrq) <=
                             v_jssj
                         and b.vc_scbz = '2'
                         and b.vc_shbz in ('3', '5', '6', '7', '8')
                         and b.vc_bgklb = '0'
                         and decode(v_sjlx, '1', b.dt_cjsj, b.dt_swrq) <=
                             v_jssj
                       group by a.vc_gldwdm) loop
        --更新重卡
        update zjjk_tjbb_sw_syzk_bgdq
           set cks = ck_list.cks
         where id = v_id
           and dwdm = ck_list.vc_gldwdm;
      end loop;
    else
      --统计地市或区县
      insert into zjjk_tjbb_sw_syzk_hjdq
        (id,
         dwdm,
         dwmc,
         bblx,
         bbqh,
         sjdwdm,
         sjdwdwmc,
         bks,
         hjrs,
         shjss,
         sfzhtbs,
         cks,
         dsyltbs,
         sybms,
         gbbmbzqs,
         cfwcs,
         cfjss,
         cjsj,
         cjyh,
         cjjgdm,
         dqlx,
         sjlx)
        select v_id,
               dm,
               mc,
               v_bblx,
               v_bbqh,
               v_sj_xzqh,
               v_sj_xzmc,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               v_sysdate,
               v_czyyhid,
               v_czyjgdm,
               '1',
               v_sjlx
          from p_xzdm
         where sjid = v_sj_xzqh;
      --查询报卡数据
      for tj_list in (select qh.dm,
                             count(*) as bks,
                             sum(case
                                   when t.dt_shsj - t.dt_cjsj <= 7 then
                                    1
                                   else
                                    0
                                 end) as shjss,
                             sum(case
                                   when vc_sfzhm is not null then
                                    1
                                   else
                                    0
                                 end) sfzhtbs,
                             sum(case
                                   when t.nb_azjswjbicd is not null and
                                        t.nb_azjswjbicd not in
                                        ('J96', 'R57.9', 'R99', 'R53', 'I50') and
                                        t.nb_bzjswjbidc is not null then
                                    1
                                   else
                                    0
                                 end) dsyltbs,
                             sum(case
                                   when (upper(substr(t.vc_gbsy, 1, 1)) in
                                        ('R', 'S', 'T')) or
                                        upper(t.vc_gbsy) in
                                        ('Y87.2',
                                         'I47.2',
                                         'I49.0',
                                         'I46',
                                         'I50-',
                                         'I51.4',
                                         'I51.5',
                                         'I51.6',
                                         'I51.9',
                                         'I70.9',
                                         'I10',
                                         'J96.-',
                                         'K72.-',
                                         'C76.-',
                                         'C80.-',
                                         'C97.-',
                                         'N17',
                                         'N18',
                                         'N19',
                                         'Y10',
                                         'Y11',
                                         'Y12',
                                         'Y13',
                                         'Y14',
                                         'Y15',
                                         'Y16',
                                         'Y17',
                                         'Y18',
                                         'Y19',
                                         'Y20',
                                         'Y21',
                                         'Y22',
                                         'Y23',
                                         'Y24',
                                         'Y25',
                                         'Y26',
                                         'Y27',
                                         'Y28',
                                         'Y29',
                                         'Y30',
                                         'Y31',
                                         'Y32',
                                         'Y33',
                                         'Y34') then
                                    1
                                   else
                                    0
                                 end) gbbmbzqs,
                             sum(case
                                   when fenleitj in ('80', '90') then
                                    1
                                   else
                                    0
                                 end) sybms,
                             sum(case
                                   when vc_hkhs is not null then
                                    1
                                   else
                                    0
                                 end) as cfwcs,
                             sum(case
                                   when vc_hkhs is not null and
                                        dt_shsj - dt_cjsj <= 7 then
                                    1
                                   else
                                    0
                                 end) as cfjss
                        from zjmb_sw_bgk t, p_xzdm qh
                       where t.vc_scbz = '2'
                         and t.vc_gldwdm like (case
                               when v_vc_hks is null then
                                substr(qh.dm, 1, 4) || '%'
                               else
                                substr(qh.dm, 1, 6) || '%'
                             end)
                         and case
                               when v_vc_hks is null then
                                t.vc_hksdm
                               else
                                t.vc_hkqxdm
                             end = qh.dm
                         and qh.sjid = v_sj_xzqh
                         and t.vc_shbz in ('3', '5', '6', '7', '8')
                         and t.vc_bgklb = '0'
                         and decode(v_sjlx, '1', t.dt_cjsj, t.dt_swrq) >=
                             v_kssj
                         and decode(v_sjlx, '1', t.dt_cjsj, t.dt_swrq) <=
                             v_jssj
                       group by qh.dm) loop
        --更新数据
        update zjjk_tjbb_sw_syzk_hjdq
           set bks      = tj_list.bks,
               shjss    = tj_list.shjss,
               sfzhtbs  = tj_list.sfzhtbs,
               dsyltbs  = tj_list.dsyltbs,
               sybms    = tj_list.sybms,
               gbbmbzqs = tj_list.gbbmbzqs,
               cfwcs    = tj_list.cfwcs,
               cfjss    = tj_list.cfjss
         where id = v_id
           and dwdm = tj_list.dm;
      end loop;
      for ck_list in (select count(distinct a.vc_bgkid) cks, qh.dm
                        from zjmb_sw_bgk a, zjmb_sw_bgk b, p_xzdm qh
                       where a.vc_bgkid <> b.vc_bgkid
                         and case
                               when v_vc_hks is null then
                                a.vc_hksdm
                               else
                                a.vc_hkqxdm
                             end = case
                               when v_vc_hks is null then
                                b.vc_hksdm
                               else
                                b.vc_hkqxdm
                             end
                         and ((a.vc_xm = b.vc_xm and a.vc_xb = b.vc_xb and
                             a.dt_csrq = b.dt_csrq and
                             a.dt_swrq = b.dt_swrq and
                             a.vc_gbsy = b.vc_gbsy and
                             (a.vc_sfzhm <> b.vc_sfzhm or
                             (a.vc_sfzhm is null or b.vc_sfzhm is null))) or
                             (a.vc_sfzhm = b.vc_sfzhm and
                             length(a.vc_sfzhm) > 14 and
                             length(b.vc_sfzhm) > 14))
                         and qh.sjid = v_sj_xzqh
                         and case
                               when v_vc_hks is null then
                                a.vc_hksdm
                               else
                                a.vc_hkqxdm
                             end = qh.dm
                         and a.vc_scbz = '2'
                         and a.vc_shbz in ('3', '5', '6', '7', '8')
                         and a.vc_bgklb = '0'
                         and a.vc_gldwdm like (case
                               when v_vc_hks is null then
                                substr(qh.dm, 1, 4) || '%'
                               else
                                substr(qh.dm, 1, 6) || '%'
                             end)
                         and decode(v_sjlx, '1', a.dt_cjsj, a.dt_swrq) >=
                             v_kssj
                         and decode(v_sjlx, '1', a.dt_cjsj, a.dt_swrq) <=
                             v_jssj
                         and b.vc_scbz = '2'
                         and b.vc_shbz in ('3', '5', '6', '7', '8')
                         and b.vc_bgklb = '0'
                         and decode(v_sjlx, '1', b.dt_cjsj, b.dt_swrq) <=
                             v_jssj
                       group by qh.dm) loop
        --更新重卡
        update zjjk_tjbb_sw_syzk_hjdq
           set cks = ck_list.cks
         where id = v_id
           and dwdm = ck_list.dm;
      end loop;
      --更新人口数
      for rk_list in (select max(vc_zhj) hjrs, b.dm
                        from ZJMB_RKGLB a, p_xzdm b
                       where a.vc_rkgljd = '99999999'
                         and case
                               when v_vc_hks is null then
                                a.vc_rkgls
                               else
                                a.vc_rkglq
                             end = b.dm
                         and case
                               when v_vc_hks is null then
                                '99999999'
                               else
                                a.vc_rkglq
                             end = a.vc_rkglq
                         and b.sjid = v_sj_xzqh
                         and vc_nf = substr(v_y, 3, 2)
                         and vc_lx = '6'
                       group by b.dm) loop
        update zjjk_tjbb_sw_syzk_hjdq
           set hjrs = rk_list.hjrs
         where id = v_id
           and dwdm = rk_list.dm;
      end loop;
    end if;
    commit;
    result_out := Return_Succ_Json(v_json_return);
  
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_tjbb_sw_syzk_hjdq;
  /*--------------------------------------------------------------------------
  || 功能描述 ：死因期望寿命
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_tjbb_sw_qwsm(Data_In    In Clob, --入参
                             result_out OUT VARCHAR2) --返回
  
   is
    v_json_data   json;
    v_json_yw_log json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
    --公共变量
    v_sysdate     date;
    v_czyjgdm     varchar2(50);
    v_czyyhid     varchar2(50);
    v_czyjgjb     varchar2(3);
    v_czyyhxm     varchar2(50);
    v_tjnd        varchar2(4);
    v_xb          varchar2(1);
    v_kssj        date;
    v_jssj        date;
    v_id          tjbb_sw_qwsm.id%type;
    v_vc_hks      varchar2(50);
    v_vc_hkqx     varchar2(50);
    v_vc_hkjd     varchar2(50);
    v_dqdm        varchar2(20);
    v_scrs_prior  tjbb_sw_qwsm.scrs%type;
    v_scrs_next   tjbb_sw_qwsm.scrs%type;
    v_qwsws_prior tjbb_sw_qwsm.qwsws%type;
    v_sczrns      tjbb_sw_qwsm.sczrns%type;
  BEGIN
    json_data(data_in, '死因期望寿命', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm'); --操作员机构代码
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb'); --获取机构级别
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid'); --操作员id
    v_czyyhxm := Json_Str(v_Json_Data, 'czyyhxm'); --操作员姓名
  
    v_tjnd    := Json_Str(v_Json_Data, 'tjnd');
    v_xb      := Json_Str(v_Json_Data, 'xb');
    v_vc_hks  := Json_Str(v_Json_Data, 'vc_hks');
    v_vc_hkqx := Json_Str(v_Json_Data, 'vc_hkqx');
    v_vc_hkjd := Json_Str(v_Json_Data, 'vc_hkjd');
    --判断操作员级别
    if v_czyjgjb not in ('1', '2', '3') then
      v_err := '操作员无此权限!';
      raise err_custom;
    end if;
    if v_vc_hks is null then
      v_dqdm := '33000000';
    else 
      v_dqdm := v_vc_hks;
    end if;
    if v_vc_hkqx is not null then
      v_dqdm := v_vc_hkqx;
    end if;
    if v_vc_hkjd is not null then
      v_dqdm := v_vc_hkjd;
    end if;
    --判断区县
    if v_vc_hkqx is null and v_czyjgjb = '3' then
      v_err := '请选择统计区县代码!';
      raise err_custom;
    end if;
    --判断年度
    if v_tjnd is null then
      v_err := '请选择统计年度!';
      raise err_custom;
    end if;
    v_kssj := std(v_tjnd || '-01-01 00:00:00', 1);
    v_jssj := std(v_tjnd || '-12-31 23:59:59', 1);
    v_id   := sys_guid();
    --生成人口数
    insert into tjbb_sw_qwsm
      (id, dqdm, dqmc, tjnd, xb, nlz, nlzw, rks, cjsj, cjyh, cjjg)
      select v_id,
             v_dqdm,
             pkg_zjmb_tnb.fun_getxzqhmc(v_dqdm),
             v_tjnd,
             v_xb,
             sort,
             nld,
             decode(a.nld,
                    '合计',
                    c.vc_zhj,
                    '0-岁',
                    c.vc_0nld,
                    '1-岁',
                    c.vc_1nld,
                    '5-岁',
                    c.vc_5nld,
                    '10-岁',
                    c.vc_10nld,
                    '15-岁',
                    c.vc_15nld,
                    '20-岁',
                    c.vc_20nld,
                    '25-岁',
                    c.vc_25nld,
                    '30-岁',
                    c.vc_30nld,
                    '35-岁',
                    c.vc_35nld,
                    '40-岁',
                    c.vc_40nld,
                    '45-岁',
                    c.vc_45nld,
                    '50-岁',
                    c.vc_50nld,
                    '55-岁',
                    c.vc_55nld,
                    '60-岁',
                    c.vc_60nld,
                    '65-岁',
                    c.vc_65nld,
                    '70-岁',
                    c.vc_70nld,
                    '75-岁',
                    c.vc_75nld,
                    '80-岁',
                    c.vc_80nld,
                    '85-岁',
                    c.vc_85nld),
             v_sysdate,
             v_czyyhid,
             v_czyjgdm
        from (select nld, sort
                from (select '合计' nld, 0 sort
                        from dual
                      union
                      select '0-岁' nld, 1 sort
                        from dual
                      union
                      select '1-岁' nld, 2 sort
                        from dual
                      union
                      select '5-岁' nld, 3 sort
                        from dual
                      union
                      select '10-岁' nld, 4 sort
                        from dual
                      union
                      select '15-岁' nld, 5 sort
                        from dual
                      union
                      select '20-岁' nld, 6 sort
                        from dual
                      union
                      select '25-岁' nld, 7 sort
                        from dual
                      union
                      select '30-岁' nld, 8 sort
                        from dual
                      union
                      select '35-岁' nld, 9 sort
                        from dual
                      union
                      select '40-岁' nld, 10 sort
                        from dual
                      union
                      select '45-岁' nld, 11 sort
                        from dual
                      union
                      select '50-岁' nld, 12 sort
                        from dual
                      union
                      select '55-岁' nld, 13 sort
                        from dual
                      union
                      select '60-岁' nld, 14 sort
                        from dual
                      union
                      select '65-岁' nld, 15 sort
                        from dual
                      union
                      select '70-岁' nld, 16 sort
                        from dual
                      union
                      select '75-岁' nld, 17 sort
                        from dual
                      union
                      select '80-岁' nld, 18 sort
                        from dual
                      union
                      select '85-岁' nld, 19 sort
                        from dual)) a,
             (select decode(max(decode(v_xb,
                                       '1',
                                       vc_nhj,
                                       '2',
                                       vc_vhj,
                                       vc_zhj)),
                            0,
                            null,
                            max(decode(v_xb, '1', vc_nhj, '2', vc_vhj, vc_zhj))) vc_zhj,
                     decode(max(vc_0nld), 0, null, max(vc_0nld)) vc_0nld,
                     decode(max(vc_1nld), 0, null, max(vc_1nld)) vc_1nld,
                     decode(max(vc_5nld), 0, null, max(vc_5nld)) vc_5nld,
                     decode(max(vc_10nld), 0, null, max(vc_10nld)) vc_10nld,
                     decode(max(vc_15nld), 0, null, max(vc_15nld)) vc_15nld,
                     decode(max(vc_20nld), 0, null, max(vc_20nld)) vc_20nld,
                     decode(max(vc_25nld), 0, null, max(vc_25nld)) vc_25nld,
                     decode(max(vc_30nld), 0, null, max(vc_30nld)) vc_30nld,
                     decode(max(vc_35nld), 0, null, max(vc_35nld)) vc_35nld,
                     decode(max(vc_40nld), 0, null, max(vc_40nld)) vc_40nld,
                     decode(max(vc_45nld), 0, null, max(vc_45nld)) vc_45nld,
                     decode(max(vc_50nld), 0, null, max(vc_50nld)) vc_50nld,
                     decode(max(vc_55nld), 0, null, max(vc_55nld)) vc_55nld,
                     decode(max(vc_60nld), 0, null, max(vc_60nld)) vc_60nld,
                     decode(max(vc_65nld), 0, null, max(vc_65nld)) vc_65nld,
                     decode(max(vc_70nld), 0, null, max(vc_70nld)) vc_70nld,
                     decode(max(vc_75nld), 0, null, max(vc_75nld)) vc_75nld,
                     decode(max(vc_80nld), 0, null, max(vc_80nld)) vc_80nld,
                     decode(max(vc_85nld), 0, null, max(vc_85nld)) vc_85nld
                from ZJMB_RKGLB
               where vc_nf = substr(v_tjnd, 3, 2)
                 and vc_lx = decode(v_xb, '1', '4', '2', '5', '6')
                 and VC_RKGLS = decode(v_vc_hks, null, '99999999', v_vc_hks)
                 and VC_RKGLQ =
                     decode(v_vc_hkqx, null, '99999999', v_vc_hkqx)
                 and VC_RKGLJD =
                     decode(v_vc_hkjd, null, '99999999', v_vc_hkjd)) c;
    --更新死亡数
    for rec_sw in (select count(1) sws, nld
                     from (select case
                                    when fun_get_agebycsrqandywrq(a.dt_csrq,
                                                                  a.dt_swrq) <= 0 then
                                     '1'
                                    when fun_get_agebycsrqandywrq(a.dt_csrq,
                                                                  a.dt_swrq) between 1 and 4 then
                                     '2'
                                    when fun_get_agebycsrqandywrq(a.dt_csrq,
                                                                  a.dt_swrq) between 5 and 9 then
                                     '3'
                                    when fun_get_agebycsrqandywrq(a.dt_csrq,
                                                                  a.dt_swrq) between 10 and 14 then
                                     '4'
                                    when fun_get_agebycsrqandywrq(a.dt_csrq,
                                                                  a.dt_swrq) between 15 and 19 then
                                     '5'
                                    when fun_get_agebycsrqandywrq(a.dt_csrq,
                                                                  a.dt_swrq) between 20 and 24 then
                                     '6'
                                    when fun_get_agebycsrqandywrq(a.dt_csrq,
                                                                  a.dt_swrq) between 25 and 29 then
                                     '7'
                                    when fun_get_agebycsrqandywrq(a.dt_csrq,
                                                                  a.dt_swrq) between 30 and 34 then
                                     '8'
                                    when fun_get_agebycsrqandywrq(a.dt_csrq,
                                                                  a.dt_swrq) between 35 and 39 then
                                     '9'
                                    when fun_get_agebycsrqandywrq(a.dt_csrq,
                                                                  a.dt_swrq) between 40 and 44 then
                                     '10'
                                    when fun_get_agebycsrqandywrq(a.dt_csrq,
                                                                  a.dt_swrq) between 45 and 49 then
                                     '11'
                                    when fun_get_agebycsrqandywrq(a.dt_csrq,
                                                                  a.dt_swrq) between 50 and 54 then
                                     '12'
                                    when fun_get_agebycsrqandywrq(a.dt_csrq,
                                                                  a.dt_swrq) between 55 and 59 then
                                     '13'
                                    when fun_get_agebycsrqandywrq(a.dt_csrq,
                                                                  a.dt_swrq) between 60 and 64 then
                                     '14'
                                    when fun_get_agebycsrqandywrq(a.dt_csrq,
                                                                  a.dt_swrq) between 65 and 69 then
                                     '16'
                                    when fun_get_agebycsrqandywrq(a.dt_csrq,
                                                                  a.dt_swrq) between 70 and 74 then
                                     '16'
                                    when fun_get_agebycsrqandywrq(a.dt_csrq,
                                                                  a.dt_swrq) between 75 and 79 then
                                     '17'
                                    when fun_get_agebycsrqandywrq(a.dt_csrq,
                                                                  a.dt_swrq) between 80 and 84 then
                                     '18'
                                    when fun_get_agebycsrqandywrq(a.dt_csrq,
                                                                  a.dt_swrq) >= 85 then
                                     '19'
                                  end nld
                             from zjmb_sw_bgk a
                            where a.vc_scbz = '2'
                              and a.vc_shbz in ('3', '5', '6', '7', '8')
                              and a.vc_bgklb = '0'
                              and a.vc_hksdm =
                                  decode(v_vc_hks, null, a.vc_hksdm, v_vc_hks)
                              and a.vc_hkqxdm =
                                  decode(v_vc_hkqx,
                                         null,
                                         a.vc_hkqxdm,
                                         v_vc_hkqx)
                              and a.vc_hkjddm =
                                  decode(v_vc_hkjd,
                                         null,
                                         a.vc_hkjddm,
                                         v_vc_hkjd))
                    group by nld) loop
      --更新死亡数,死亡率，死亡概率
      update tjbb_sw_qwsm a
         set a.sws  = rec_sw.sws,
             a.swl  = round(rec_sw.sws / decode(a.rks, 0, null, a.rks), 9),
             a.swgl = case
                        when a.nlz = '1' then
                         round(rec_sw.sws / decode(a.rks, 0, null, a.rks), 9)
                        else
                         2 * 5 *
                         round(rec_sw.sws / decode(a.rks, 0, null, a.rks), 9) /
                         (2 +
                         5 *
                         round(rec_sw.sws / decode(a.rks, 0, null, a.rks), 9))
                      end
       where a.id = v_id
         and a.dqdm = v_dqdm
         and a.nlz = rec_sw.nld;
    end loop;
    --更新尚存人数
    for rec_scrs in (select *
                       from tjbb_sw_qwsm
                      where id = v_id
                        and dqdm = v_dqdm
                      order by nlz) loop
      --0岁
      if rec_scrs.nlz = 1 then
        update tjbb_sw_qwsm a
           set a.scrs = 100000, a.qwsws = round(100000 * rec_scrs.swl, 9)
         where a.id = rec_scrs.id
           and dqdm = rec_scrs.dqdm
           and a.nlz = 1;
      elsif rec_scrs.nlz > 1 then
        --获取上年人数
        select nvl(max(scrs), 0), nvl(max(qwsws), 0)
          into v_scrs_prior, v_qwsws_prior
          from tjbb_sw_qwsm a
         where a.id = rec_scrs.id
           and dqdm = rec_scrs.dqdm
           and a.nlz = rec_scrs.nlz - 1;
        --尚存人数 = 上个年龄组的尚存人数-上个年龄组的期望死亡数
        update tjbb_sw_qwsm a
           set a.scrs  = round(nvl(v_scrs_prior, 0) - nvl(v_qwsws_prior, 0),
                               9),
               a.qwsws = round((nvl(v_scrs_prior, 0) - nvl(v_qwsws_prior, 0)) *
                               rec_scrs.swl,
                               9)
         where a.id = rec_scrs.id
           and dqdm = rec_scrs.dqdm
           and a.nlz = rec_scrs.nlz;
      end if;
    end loop;
    --更新生存人年数
    for rec_scrns in (select *
                        from tjbb_sw_qwsm
                       where id = v_id
                         and dqdm = v_dqdm
                       order by nlz) loop
      --0岁
      if rec_scrns.nlz = 1 then
        --（0-岁时等于尚存人数+0.15*期望死亡率）
        update tjbb_sw_qwsm a
           set a.scrns = round(nvl(a.scrs, 0) + 0.15 * nvl(a.qwsws, 0), 0)
         where a.id = rec_scrns.id
           and dqdm = rec_scrns.dqdm
           and a.nlz = 1;
      elsif rec_scrns.nlz > 1 then
        --获取下年人数
        select nvl(max(scrs), 0)
          into v_scrs_next
          from tjbb_sw_qwsm a
         where a.id = rec_scrns.id
           and dqdm = rec_scrns.dqdm
           and a.nlz = rec_scrns.nlz + 1;
        -- 生存人年数 = 2.5*（该年龄组的尚存人数+下个年龄组的尚存人数,85岁的话，就直接2.5×该年龄组的尚存人数
        update tjbb_sw_qwsm a
           set a.scrns = round(2.5 * (nvl(a.scrs, 0) + v_scrs_next), 0)
         where a.id = rec_scrns.id
           and dqdm = rec_scrns.dqdm
           and a.nlz = rec_scrns.nlz;
      end if;
    end loop;
    --更新生存总人年数
    for rec_sczrns in (select *
                         from tjbb_sw_qwsm
                        where id = v_id
                          and dqdm = v_dqdm
                        order by nlz) loop
      if rec_sczrns.nlz > 0 then
        --生存总人年数 = 该年龄组的生存人年数到85-岁年龄组的生存人年数的总和
        select round(sum(b.scrns),9)
          into v_sczrns
          from tjbb_sw_qwsm b
         where b.id = rec_sczrns.id
           and b.dqdm = rec_sczrns.dqdm
           and b.nlz >= rec_sczrns.nlz;
          --201X年期望寿命 = 生存年总人数 /尚存人数 (x为当年上一年的年份，如2018年取2017
          
        update tjbb_sw_qwsm a
           set a.sczrns = v_sczrns,
               a.qwsm = round(v_sczrns/decode(a.scrs, 0, null, a.scrs),9)
         where a.id = rec_sczrns.id
           and dqdm = rec_sczrns.dqdm
           and a.nlz = rec_sczrns.nlz;
      end if;
    end loop;
    commit;
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_tjbb_sw_qwsm;
END pkg_zjmb_tjbb;
