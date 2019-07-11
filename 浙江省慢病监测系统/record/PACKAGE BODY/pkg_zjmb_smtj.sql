CREATE OR REPLACE PACKAGE BODY pkg_zjmb_smtj AS
  /******************************************************************************/
  /*  程序包名 ：pkg_zjmb_smtj                                                        */
  /*  业务环节 ：浙江慢病_生命统计                                               */
  /*  功能描述 ：为慢病生命统计相关的存储过程及函数                                  */
  /*                                                                            */
  /*  作    者 ：     作成日期 ：2011-05-11   版本编号 ：Ver 1.0.0  */
  /*----------------------------------------------------------------------------*/
  /*  修改记录 ：                                                               */
  /******************************************************************************/
  /*-------------------------------------------------------------------------*/
  /*-------------------------------------------------------------------------*/
  /*--------------------------------------------------------------------------
  || 功能描述 ：死亡新增及修改
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_sw_bgk_update(Data_In    In Clob, --入参
                              result_out OUT VARCHAR2) --返回
   is
    v_json_data   json;
    v_json_return json := json();
    v_json_yw_log json;
    v_ywjl_czlx   varchar2(3);
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
  
    --公共变量
    v_sysdate date;
    v_czyjgjb varchar2(3);
    v_czyjgdm varchar2(50);
    v_czyyhid varchar2(50);
    v_count   number;
  
    v_vc_xm          zjmb_sw_bgk.vc_xm%TYPE; --姓名
    v_vc_xb          zjmb_sw_bgk.vc_xb%TYPE; --性别
    v_vc_mz          zjmb_sw_bgk.vc_mz%TYPE; --民族
    v_vc_gjhdq       zjmb_sw_bgk.vc_gjhdq%TYPE; --国家或地区
    v_vc_zjlx        zjmb_sw_bgk.vc_zjlx%TYPE; --证件类型
    v_vc_sfzhm       zjmb_sw_bgk.vc_sfzhm%TYPE; --身份证号码
    v_vc_hyzk        zjmb_sw_bgk.vc_hyzk%TYPE; --婚姻状况
    v_vc_whcd        zjmb_sw_bgk.vc_whcd%TYPE; --文化程度
    v_vc_hkqcs       zjmb_sw_bgk.vc_hkqcs%TYPE; --户口省代码
    v_vc_hksdm       zjmb_sw_bgk.vc_hksdm%TYPE; --户口市代码
    v_vc_hkqxdm      zjmb_sw_bgk.vc_hkqxdm%TYPE; --户口区县代码
    v_vc_hkjddm      zjmb_sw_bgk.vc_hkjddm%TYPE; --户口街道代码
    v_vc_hkjw        zjmb_sw_bgk.vc_hkjw%TYPE; --户口居委
    v_vc_wshkshendm  zjmb_sw_bgk.vc_wshkshendm%TYPE; --外省户口省代码
    v_vc_wshksdm     zjmb_sw_bgk.vc_wshksdm%TYPE; --外省户口市代码
    v_vc_wshkqxdm    zjmb_sw_bgk.vc_wshkqxdm%TYPE; --外省户口区县代码
    v_vc_wshkjddm    zjmb_sw_bgk.vc_wshkjddm%TYPE; --外省户口街道代码
    v_vc_wshkjw      zjmb_sw_bgk.vc_wshkjw%TYPE; --外省户口居委
    v_vc_jzqcs       zjmb_sw_bgk.vc_jzqcs%TYPE; --居住省代码
    v_vc_jzsdm       zjmb_sw_bgk.vc_jzsdm%TYPE; --居住市代码
    v_vc_jzqxdm      zjmb_sw_bgk.vc_jzqxdm%TYPE; --居住区县代码
    v_vc_jzjddm      zjmb_sw_bgk.vc_jzjddm%TYPE; --居住街道代码
    v_vc_jzjw        zjmb_sw_bgk.vc_jzjw%TYPE; --居住居委
    v_vc_wsjzshendm  zjmb_sw_bgk.vc_wsjzshendm%TYPE; --外省居住省代码
    v_vc_wsjzsdm     zjmb_sw_bgk.vc_wsjzsdm%TYPE; --外省居住市代码
    v_vc_wsjzqxdm    zjmb_sw_bgk.vc_wsjzqxdm%TYPE; --外省居住区县代码
    v_vc_wsjzjddm    zjmb_sw_bgk.vc_wsjzjddm%TYPE; --外省居住街道代码
    v_vc_wsjzjw      zjmb_sw_bgk.vc_wsjzjw%TYPE; --外省居住居委
    v_vc_zy          zjmb_sw_bgk.vc_zy%TYPE; --职业
    v_vc_lxdzhgzdw   zjmb_sw_bgk.vc_lxdzhgzdw%TYPE; --联系地址或工作单位
    v_dt_csrq        zjmb_sw_bgk.dt_csrq%TYPE; --出生日期
    v_dt_swrq        zjmb_sw_bgk.dt_swrq%TYPE; --死亡日期
    v_vc_jsxm        zjmb_sw_bgk.vc_jsxm%TYPE; --家属姓名
    v_vc_jslxdh      zjmb_sw_bgk.vc_jslxdh%TYPE; --家属联系电话
    v_vc_jsdz        zjmb_sw_bgk.vc_jsdz%TYPE; --家属地址或工作单位
    v_vc_sznl        zjmb_sw_bgk.vc_sznl%TYPE; --实足年龄
    v_vc_swdd        zjmb_sw_bgk.vc_swdd%TYPE; --死亡地点
    v_vc_rsqk        zjmb_sw_bgk.vc_rsqk%TYPE; --妊娠情况
    v_vc_azjswjb1    zjmb_sw_bgk.vc_azjswjb1%TYPE; --
    v_vc_bzjswjb1    zjmb_sw_bgk.vc_bzjswjb1%TYPE; --
    v_vc_czjswjb1    zjmb_sw_bgk.vc_czjswjb1%TYPE; --
    v_vc_dzjswjb1    zjmb_sw_bgk.vc_dzjswjb1%TYPE; --
    v_vc_ezjswjb1    zjmb_sw_bgk.vc_ezjswjb1%TYPE; --
    v_vc_fzjswjb1    zjmb_sw_bgk.vc_fzjswjb1%TYPE; --
    v_vc_gzjswjb1    zjmb_sw_bgk.vc_gzjswjb1%TYPE; --
    v_vc_azjswjb     zjmb_sw_bgk.vc_azjswjb%TYPE; --a直接导致死亡的疾病
    v_nb_azjswjbicd  zjmb_sw_bgk.nb_azjswjbicd%TYPE; --a直接导致死亡的疾病ICD10编码
    v_vc_afbdswsjjg  zjmb_sw_bgk.vc_afbdswsjjg%TYPE; --a发病到死亡的时间间隔
    v_vc_afbdswsjdw  zjmb_sw_bgk.vc_afbdswsjdw%TYPE; --a发病到死亡的时间间隔单位
    v_vc_bzjswjb     zjmb_sw_bgk.vc_bzjswjb%TYPE; --b直接导致死亡的疾病
    v_nb_bzjswjbidc  zjmb_sw_bgk.nb_bzjswjbidc%TYPE; --b直接导致死亡的疾病ICD10编码
    v_vc_bfbdswsjjg  zjmb_sw_bgk.vc_bfbdswsjjg%TYPE; --b发病到死亡的时间间隔
    v_vc_bfbdswsjdw  zjmb_sw_bgk.vc_bfbdswsjdw%TYPE; --b发病到死亡的时间间隔单位
    v_vc_czjswjb     zjmb_sw_bgk.vc_czjswjb%TYPE; --c直接导致死亡的疾病
    v_nb_czjswjbicd  zjmb_sw_bgk.nb_czjswjbicd%TYPE; --c直接导致死亡的疾病ICD10编码
    v_vc_cfbdswsjjg  zjmb_sw_bgk.vc_cfbdswsjjg%TYPE; --c发病到死亡的时间间隔
    v_vc_cfbdswsjdw  zjmb_sw_bgk.vc_cfbdswsjdw%TYPE; --c发病到死亡的时间间隔单位
    v_vc_dzjswjb     zjmb_sw_bgk.vc_dzjswjb%TYPE; --d直接导致死亡的疾病
    v_nb_dajswjbicd  zjmb_sw_bgk.nb_dajswjbicd%TYPE; --d直接导致死亡的疾病ICD10编码
    v_vc_dfbdswsjjg  zjmb_sw_bgk.vc_dfbdswsjjg%TYPE; --d发病到死亡的时间间隔
    v_vc_dfbdswsjdw  zjmb_sw_bgk.vc_dfbdswsjdw%TYPE; --d发病到死亡的时间间隔单位
    v_vc_ezjswjb     zjmb_sw_bgk.vc_ezjswjb%TYPE; --e直接导致死亡的疾病
    v_nb_eajswjbicd  zjmb_sw_bgk.nb_eajswjbicd%TYPE; --e直接导致死亡的疾病ICD10编码
    v_vc_efbdswsjjg  zjmb_sw_bgk.vc_efbdswsjjg%TYPE; --e发病到死亡的时间间隔
    v_vc_efbdswsjdw  zjmb_sw_bgk.vc_efbdswsjdw%TYPE; --e发病到死亡的时间间隔单位
    v_vc_fzjswjb     zjmb_sw_bgk.vc_fzjswjb%TYPE; --f直接导致死亡的疾病
    v_nb_fajswjbicd  zjmb_sw_bgk.nb_fajswjbicd%TYPE; --f直接导致死亡的疾病ICD10编码
    v_vc_ffbdswsjjg  zjmb_sw_bgk.vc_ffbdswsjjg%TYPE; --f发病到死亡的时间间隔
    v_vc_ffbdswsjdw  zjmb_sw_bgk.vc_ffbdswsjdw%TYPE; --f发病到死亡的时间间隔单位
    v_vc_gzjswjb     zjmb_sw_bgk.vc_gzjswjb%TYPE; --g直接导致死亡的疾病
    v_nb_gajswjbicd  zjmb_sw_bgk.nb_gajswjbicd%TYPE; --g直接导致死亡的疾病ICD10编码
    v_vc_gfbdswsjjg  zjmb_sw_bgk.vc_gfbdswsjjg%TYPE; --g发病到死亡的时间间隔
    v_vc_gfbdswsjdw  zjmb_sw_bgk.vc_gfbdswsjdw%TYPE; --g发病到死亡的时间间隔单位
    v_vc_sqzgzddw    zjmb_sw_bgk.vc_sqzgzddw%TYPE; --生前最高诊断单位
    v_vc_zdyj        zjmb_sw_bgk.vc_zdyj%TYPE; --诊断依据
    v_vc_zyh         zjmb_sw_bgk.vc_zyh%TYPE; --住院号
    v_vc_ysqm        zjmb_sw_bgk.vc_ysqm%TYPE; --医生签名
    v_vc_gbsy        zjmb_sw_bgk.vc_gbsy%TYPE; --根本死因
    v_nb_gbsybm      zjmb_sw_bgk.nb_gbsybm%TYPE; -- 根本死因名称
    v_fenleitj       zjmb_sw_bgk.fenleitj%TYPE; --分类统计号
    v_fenleitjmc     zjmb_sw_bgk.fenleitjmc%TYPE; --分类统计号
    v_dt_dcrq        zjmb_sw_bgk.dt_dcrq%TYPE; --调查日期
    v_vc_jkdw        zjmb_sw_bgk.vc_jkdw%TYPE; --建卡医院
    v_vc_szsqbljzztz zjmb_sw_bgk.vc_szsqbljzztz%TYPE; --死者生前病史及症状体征
    v_vc_hkhs        zjmb_sw_bgk.vc_hkhs%TYPE; --户口核实
    v_vc_hkhs_bgq    zjmb_sw_bgk.vc_hkhs%TYPE; --户口核实变更前
    v_vc_whsyy       zjmb_sw_bgk.vc_whsyy%TYPE; --未核实原因
    v_vc_bgkid       zjmb_sw_bgk.vc_bgkid%TYPE; --报告卡id
    v_vc_gldwdm      zjmb_sw_bgk.vc_gldwdm%TYPE; --管理单位
    v_vc_sdqr        zjmb_sw_bgk.vc_sdqr%TYPE; --属地确认标志
    v_vc_shbz        zjmb_sw_bgk.vc_shbz%TYPE; --审核标志
    v_vc_hkqxdm_bgq  zjmb_sw_bgk.vc_hkqxdm%TYPE; --变更前区县代码
    v_vc_hkjddm_bgq  zjmb_sw_bgk.vc_hkjddm%TYPE; --变更前街道代码
    v_vc_hkjw_bgq    zjmb_sw_bgk.vc_hkjw%TYPE; --户口居委   
  
    v_ywrzid      zjjk_yw_log.id%TYPE; --业务日志id
    v_tab_bgk_old zjmb_sw_bgk%rowtype; --死亡报告卡变更前
    v_tab_bgk_new zjmb_sw_bgk%rowtype; --死亡报告卡变更后
  BEGIN
    json_data(data_in, 'zjmb_sw_bgk新增或修改', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm'); --操作员机构代码
    v_czyyhid := Json_Str(v_Json_Data, 'v_czyyhid');
    --获取机构级别
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
  
    v_vc_bgkid       := Json_Str(v_Json_Data, 'vc_bgkid');
    v_nb_gbsybm      := json_str(v_json_data, 'nb_gbsybm');
    v_vc_wshkqxdm    := Json_Str(v_Json_Data, 'vc_wshkqxdm');
    v_vc_wshkjddm    := Json_Str(v_Json_Data, 'vc_wshkjddm');
    v_vc_wshkjw      := Json_Str(v_Json_Data, 'vc_wshkjw');
    v_vc_gjhdq       := Json_Str(v_Json_Data, 'vc_gjhdq');
    v_vc_wshkshendm  := Json_Str(v_Json_Data, 'vc_wshkshendm');
    v_vc_jzqcs       := Json_Str(v_Json_Data, 'vc_jzqcs');
    v_vc_jzsdm       := Json_Str(v_Json_Data, 'vc_jzsdm');
    v_vc_jzqxdm      := Json_Str(v_Json_Data, 'vc_jzqxdm');
    v_vc_jzjddm      := Json_Str(v_Json_Data, 'vc_jzjddm');
    v_vc_jzjw        := Json_Str(v_Json_Data, 'vc_jzjw');
    v_vc_wsjzshendm  := Json_Str(v_Json_Data, 'vc_wsjzshendm');
    v_vc_wsjzsdm     := Json_Str(v_Json_Data, 'vc_wsjzsdm');
    v_vc_wsjzqxdm    := Json_Str(v_Json_Data, 'vc_wsjzqxdm');
    v_vc_wsjzjddm    := Json_Str(v_Json_Data, 'vc_wsjzjddm');
    v_vc_wsjzjw      := Json_Str(v_Json_Data, 'vc_wsjzjw');
    v_dt_swrq        := std(Json_Str(v_Json_Data, 'dt_swrq'), 0);
    v_vc_sznl        := Json_Str(v_Json_Data, 'vc_sznl');
    v_vc_sfzhm       := Json_Str(v_Json_Data, 'vc_sfzhm');
    v_vc_swdd        := Json_Str(v_Json_Data, 'vc_swdd');
    v_vc_sqzgzddw    := Json_Str(v_Json_Data, 'vc_sqzgzddw');
    v_vc_zdyj        := Json_Str(v_Json_Data, 'vc_zdyj');
    v_vc_gbsy        := Json_Str(v_Json_Data, 'vc_gbsy');
    v_vc_jsxm        := Json_Str(v_Json_Data, 'vc_jsxm');
    v_vc_jslxdh      := Json_Str(v_Json_Data, 'vc_jslxdh');
    v_vc_jsdz        := Json_Str(v_Json_Data, 'vc_jsdz');
    v_vc_zyh         := Json_Str(v_Json_Data, 'vc_zyh');
    v_vc_azjswjb     := Json_Str(v_Json_Data, 'vc_azjswjb');
    v_nb_azjswjbicd  := Json_Str(v_Json_Data, 'nb_azjswjbicd');
    v_vc_afbdswsjjg  := Json_Str(v_Json_Data, 'vc_afbdswsjjg');
    v_vc_afbdswsjdw  := Json_Str(v_Json_Data, 'vc_afbdswsjdw');
    v_vc_bzjswjb     := Json_Str(v_Json_Data, 'vc_bzjswjb');
    v_nb_bzjswjbidc  := Json_Str(v_Json_Data, 'nb_bzjswjbidc');
    v_vc_bfbdswsjjg  := Json_Str(v_Json_Data, 'vc_bfbdswsjjg');
    v_vc_bfbdswsjdw  := Json_Str(v_Json_Data, 'vc_bfbdswsjdw');
    v_vc_czjswjb     := Json_Str(v_Json_Data, 'vc_czjswjb');
    v_nb_czjswjbicd  := Json_Str(v_Json_Data, 'nb_czjswjbicd');
    v_vc_cfbdswsjjg  := Json_Str(v_Json_Data, 'vc_cfbdswsjjg');
    v_vc_cfbdswsjdw  := Json_Str(v_Json_Data, 'vc_cfbdswsjdw');
    v_vc_dzjswjb     := Json_Str(v_Json_Data, 'vc_dzjswjb');
    v_nb_dajswjbicd  := Json_Str(v_Json_Data, 'nb_dajswjbicd');
    v_vc_dfbdswsjjg  := Json_Str(v_Json_Data, 'vc_dfbdswsjjg');
    v_vc_dfbdswsjdw  := Json_Str(v_Json_Data, 'vc_dfbdswsjdw');
    v_vc_szsqbljzztz := Json_Str(v_Json_Data, 'vc_szsqbljzztz');
    v_vc_lxdzhgzdw   := Json_Str(v_Json_Data, 'vc_lxdzhgzdw');
    v_dt_dcrq        := std(Json_Str(v_Json_Data, 'dt_dcrq'), 0);
    v_vc_hksdm       := Json_Str(v_Json_Data, 'vc_hksdm');
    v_vc_hkqxdm      := Json_Str(v_Json_Data, 'vc_hkqxdm');
    v_vc_hkjddm      := Json_Str(v_Json_Data, 'vc_hkjddm');
    v_dt_csrq        := std(Json_Str(v_Json_Data, 'dt_csrq'), 0);
    v_vc_ysqm        := Json_Str(v_Json_Data, 'vc_ysqm');
    v_vc_hkhs        := Json_Str(v_Json_Data, 'vc_hkhs');
    v_vc_whsyy       := Json_Str(v_Json_Data, 'vc_whsyy');
    v_vc_hkjw        := Json_Str(v_Json_Data, 'vc_hkjw');
    v_fenleitj       := Json_Str(v_Json_Data, 'fenleitj');
    v_vc_ezjswjb     := Json_Str(v_Json_Data, 'vc_ezjswjb');
    v_nb_eajswjbicd  := Json_Str(v_Json_Data, 'nb_eajswjbicd');
    v_vc_efbdswsjjg  := Json_Str(v_Json_Data, 'vc_efbdswsjjg');
    v_vc_efbdswsjdw  := Json_Str(v_Json_Data, 'vc_efbdswsjdw');
    v_vc_fzjswjb     := Json_Str(v_Json_Data, 'vc_fzjswjb');
    v_nb_fajswjbicd  := Json_Str(v_Json_Data, 'nb_fajswjbicd');
    v_vc_ffbdswsjjg  := Json_Str(v_Json_Data, 'vc_ffbdswsjjg');
    v_vc_ffbdswsjdw  := Json_Str(v_Json_Data, 'vc_ffbdswsjdw');
    v_vc_gzjswjb     := Json_Str(v_Json_Data, 'vc_gzjswjb');
    v_nb_gajswjbicd  := Json_Str(v_Json_Data, 'nb_gajswjbicd');
    v_vc_gfbdswsjjg  := Json_Str(v_Json_Data, 'vc_gfbdswsjjg');
    v_vc_gfbdswsjdw  := Json_Str(v_Json_Data, 'vc_gfbdswsjdw');
    v_vc_hkqcs       := Json_Str(v_Json_Data, 'vc_hkqcs');
    v_fenleitjmc     := Json_Str(v_Json_Data, 'fenleitjmc');
    v_vc_azjswjb1    := Json_Str(v_Json_Data, 'vc_azjswjb1');
    v_vc_bzjswjb1    := Json_Str(v_Json_Data, 'vc_bzjswjb1');
    v_vc_czjswjb1    := Json_Str(v_Json_Data, 'vc_czjswjb1');
    v_vc_dzjswjb1    := Json_Str(v_Json_Data, 'vc_dzjswjb1');
    v_vc_ezjswjb1    := Json_Str(v_Json_Data, 'vc_ezjswjb1');
    v_vc_fzjswjb1    := Json_Str(v_Json_Data, 'vc_fzjswjb1');
    v_vc_gzjswjb1    := Json_Str(v_Json_Data, 'vc_gzjswjb1');
    v_vc_zjlx        := Json_Str(v_Json_Data, 'vc_zjlx');
    v_vc_rsqk        := Json_Str(v_Json_Data, 'vc_rsqk');
    v_vc_wshksdm     := Json_Str(v_Json_Data, 'vc_wshksdm');
    v_vc_xm          := Json_Str(v_Json_Data, 'vc_xm');
    v_vc_jkdw        := Json_Str(v_Json_Data, 'vc_jkdw');
    v_vc_xb          := Json_Str(v_Json_Data, 'vc_xb');
    v_vc_mz          := Json_Str(v_Json_Data, 'vc_mz');
    v_vc_zy          := Json_Str(v_Json_Data, 'vc_zy');
    v_vc_hyzk        := Json_Str(v_Json_Data, 'vc_hyzk');
    v_vc_whcd        := Json_Str(v_Json_Data, 'vc_whcd');
  
    --检验字段必填
    --校验数据是否合法
    if v_vc_xm is null then
      v_err := '姓名不能为空!';
      raise err_custom;
    end if;
    if v_vc_xb is null then
      v_err := '性别不能为空!';
      raise err_custom;
    end if;
    if v_vc_mz is null then
      v_err := '民族不能为空!';
      raise err_custom;
    end if;
    if v_vc_zjlx is null then
      v_err := '证件类型不能为空!';
      raise err_custom;
    end if;
    if v_vc_zjlx <> '99' and v_vc_sfzhm is null then
      v_err := '证件号码不能为空!';
      raise err_custom;
    end if;
    if v_vc_hyzk is null then
      v_err := '婚姻状况不能为空!';
      raise err_custom;
    end if;
    if v_vc_hkqcs is null then
      v_err := '户籍地址省不能为空!';
      raise err_custom;
    end if;
    --户籍地址浙江
    if v_vc_hkqcs = '0' then
      if v_vc_hksdm is null then
        v_err := '户籍地址市不能为空!';
        raise err_custom;
      end if;
      if v_vc_hkqxdm is null then
        v_err := '户籍地址区县不能为空!';
        raise err_custom;
      end if;
      if v_vc_hkjddm is null then
        v_err := '户籍地址街道不能为空!';
        raise err_custom;
      end if;
      if substr(v_vc_hksdm, 1, 4) <> substr(v_vc_hkqxdm, 1, 4) or
         substr(v_vc_hksdm, 1, 4) <> substr(v_vc_hkjddm, 1, 4) then
        v_err := '户籍地址区划不匹配!';
        raise err_custom;
      end if;
    end if;
    --户籍地址外省
    if v_vc_hkqcs = '1' then
      if v_vc_wshkshendm is null then
        v_err := '外省户籍地址省不能为空!';
        raise err_custom;
      end if;
      if v_vc_wshksdm is null then
        v_err := '外省户籍地址市不能为空!';
        raise err_custom;
      end if;
      if v_vc_wshkqxdm is null then
        v_err := '外省户籍地址区县不能为空!';
        raise err_custom;
      end if;
      if v_vc_wshkjddm is null then
        v_err := '外省户籍地址街道不能为空!';
        raise err_custom;
      end if;
    end if;
    --居住地址
    if v_vc_jzqcs is null then
      v_err := '居住地址省不能为空!';
      raise err_custom;
    end if;
    --居住地址浙江
    if v_vc_jzqcs = '0' then
      if v_vc_jzsdm is null then
        v_err := '居住地址市不能为空!';
        raise err_custom;
      end if;
      if v_vc_jzqxdm is null then
        v_err := '居住地址区县不能为空!';
        raise err_custom;
      end if;
      if v_vc_jzjddm is null then
        v_err := '居住地址街道不能为空!';
        raise err_custom;
      end if;
      if substr(v_vc_jzsdm, 1, 4) <> substr(v_vc_jzqxdm, 1, 4) or
         substr(v_vc_jzsdm, 1, 4) <> substr(v_vc_jzjddm, 1, 4) then
        v_err := '居住地址区划不匹配!';
        raise err_custom;
      end if;
    end if;
    --居住地址外省
    if v_vc_jzqcs = '1' then
      if v_vc_wsjzshendm is null then
        v_err := '外省居住地址省不能为空!';
        raise err_custom;
      end if;
      if v_vc_wsjzsdm is null then
        v_err := '外省居住地址市不能为空!';
        raise err_custom;
      end if;
      if v_vc_wsjzqxdm is null then
        v_err := '外省居住地址区县不能为空!';
        raise err_custom;
      end if;
      if v_vc_wsjzjddm is null then
        v_err := '外省居住地址街道不能为空!';
        raise err_custom;
      end if;
    end if;
    if v_vc_whcd is null then
      v_err := '文化程度不能为空!';
      raise err_custom;
    end if;
    if v_vc_zy is null then
      v_err := '个人身份不能为空!';
      raise err_custom;
    end if;
    if v_dt_swrq is null then
      v_err := '死亡日期不能为空!';
      raise err_custom;
    end if;
    if v_vc_swdd is null then
      v_err := '死亡地点不能为空!';
      raise err_custom;
    end if;
  
    if v_vc_azjswjb1 is null then
      v_err := 'a直接导致死亡的疾病名不能为空!';
      raise err_custom;
    end if;
    /*if v_nb_azjswjbicd is null then
      v_err := 'a直接导致死亡的疾病ICD10编码不能为空!';
      raise err_custom;
    end if;
    if v_vc_azjswjb is null then
      v_err := 'a直接导致死亡的疾病的疾病诊断不能为空!';
      raise err_custom;
    end if;*/
    if v_vc_afbdswsjjg is null then
      v_err := 'a发病到死亡的时间间隔不能为空!';
      raise err_custom;
    end if;
    if v_vc_sqzgzddw is null then
      v_err := '最高诊断单位不能为空!';
      raise err_custom;
    end if;
    if v_vc_zdyj is null then
      v_err := '最高诊断依据不能为空!';
      raise err_custom;
    end if;
    if v_vc_ysqm is null then
      v_err := '医师签名不能为空!';
      raise err_custom;
    end if;
    if v_dt_dcrq is null then
      v_err := '填报日期不能为空!';
      raise err_custom;
    end if;
    if v_vc_jkdw is null then
      v_err := '报卡单位医院不能为空!';
      raise err_custom;
    end if;
    if v_vc_hkhs = '2' and v_vc_whsyy is null then
      v_err := '未核实原因不能为空!';
      raise err_custom;
    end if;
    --校验日期
    if v_dt_dcrq > v_sysdate then
      v_err := '填报日期不能晚于当前时间!';
      raise err_custom;
    end if;
    if v_dt_swrq > v_dt_dcrq then
      v_err := '死亡日期不能晚于填报日期!';
      raise err_custom;
    end if;
    --校验身份证号码合法性
    if v_vc_sfzhm is not null and (v_vc_zjlx = '1' or v_vc_zjlx = '2') then
      if substr(v_vc_sfzhm, 7, 8) <> to_char(v_dt_csrq, 'yyyymmdd') then
        v_err := '身份证号码与出生日期不匹配!';
        raise err_custom;
      end if;
      if (mod(substr(v_vc_sfzhm, 17, 1), 2) = 0 and v_vc_xb <> '2') or
         (mod(substr(v_vc_sfzhm, 17, 1), 2) = 1 and v_vc_xb <> '1') then
        v_err := '身份证号码与性别不匹配!';
        raise err_custom;
      end if;
    end if;
  
    --新增
    if v_vc_bgkid is null then
      if v_czyjgjb <> '4' then
        v_err := '当前机构无新增权限!';
        raise err_custom;
      end if;
      --修改
      v_ywjl_czlx := '01';
      --获取报告卡id
      select fun_getbgkid_sw(v_czyjgdm) into v_vc_bgkid from dual;
      --属地确认标志
      if v_vc_hkjddm is not null then
        select count(1), wm_concat(a.code)
          into v_count, v_vc_gldwdm
          from organ_node a
         where a.removed = 0
           and a.description like '%' || v_vc_hkjddm || '%';
        if v_count = 1 then
          --确定属地
          v_vc_sdqr := '1';
        else
          v_vc_gldwdm := v_vc_hkqxdm;
          v_vc_sdqr   := '0';
        end if;
      else 
        v_vc_sdqr   := '1';
      end if;
      if v_vc_hkqcs = '1' then
        --2.外省户籍数据（vc_hkqcs=1)，管理单位取报告卡单位前6位（vc_gldwdm=substr(vc_jkdw,1,6)||'00')
        v_vc_sdqr   := '1';
        v_vc_gldwdm := substr(v_czyjgdm, 1, 6) || '00';
      end if;
      --本地户籍卡片由管理单位自己报卡时,户口核实为1
      if v_vc_gldwdm = v_czyjgdm then
        v_vc_hkhs := '1';
      end if;
      --写入死亡报告卡
      insert into zjmb_sw_bgk
        (vc_bgkid,
         vc_wshkqxdm,
         vc_wshkjddm,
         vc_wshkjw,
         vc_gjhdq,
         vc_wshkshendm,
         vc_jzqcs,
         vc_jzsdm,
         vc_jzqxdm,
         vc_jzjddm,
         vc_jzjw,
         vc_wsjzshendm,
         vc_wsjzsdm,
         vc_wsjzqxdm,
         vc_wsjzjddm,
         vc_wsjzjw,
         dt_swrq,
         vc_sznl,
         vc_sfzhm,
         vc_swdd,
         vc_sqzgzddw,
         vc_zdyj,
         vc_gbsy,
         vc_jsxm,
         vc_jslxdh,
         vc_jsdz,
         vc_zyh,
         vc_azjswjb,
         nb_azjswjbicd,
         vc_afbdswsjjg,
         vc_afbdswsjdw,
         vc_bzjswjb,
         nb_bzjswjbidc,
         vc_bfbdswsjjg,
         vc_bfbdswsjdw,
         vc_czjswjb,
         nb_czjswjbicd,
         vc_cfbdswsjjg,
         vc_cfbdswsjdw,
         vc_dzjswjb,
         nb_dajswjbicd,
         vc_dfbdswsjjg,
         vc_dfbdswsjdw,
         vc_szsqbljzztz,
         vc_lxdzhgzdw,
         dt_dcrq,
         vc_hksdm,
         vc_hkqxdm,
         vc_hkjddm,
         dt_csrq,
         vc_ysqm,
         vc_hkhs,
         vc_whsyy,
         vc_hkjw,
         fenleitj,
         vc_ezjswjb,
         nb_eajswjbicd,
         vc_efbdswsjjg,
         vc_efbdswsjdw,
         vc_fzjswjb,
         nb_fajswjbicd,
         vc_ffbdswsjjg,
         vc_ffbdswsjdw,
         vc_gzjswjb,
         nb_gajswjbicd,
         vc_gfbdswsjjg,
         vc_gfbdswsjdw,
         vc_hkqcs,
         fenleitjmc,
         vc_azjswjb1,
         vc_bzjswjb1,
         vc_czjswjb1,
         vc_dzjswjb1,
         vc_ezjswjb1,
         vc_fzjswjb1,
         vc_gzjswjb1,
         vc_zjlx,
         vc_rsqk,
         vc_wshksdm,
         vc_xm,
         vc_jkdw,
         vc_xb,
         vc_mz,
         vc_zy,
         vc_hyzk,
         vc_whcd,
         dt_jksj,
         vc_qyid,
         vc_scbz,
         vc_shbz,
         dt_lrsj,
         dt_xgsj,
         vc_sdqr,
         vc_gldwdm,
         vc_bgklb,
         vc_cjyh,
         vc_xgyh,
         dt_cjsj,
         vc_cjdwdm,
         vc_zlbfzt,
         vc_tnbbfzt,
         vc_xnxgbfzt,
         nb_gbsybm)
      values
        (v_vc_bgkid,
         v_vc_wshkqxdm,
         v_vc_wshkjddm,
         v_vc_wshkjw,
         v_vc_gjhdq,
         v_vc_wshkshendm,
         v_vc_jzqcs,
         v_vc_jzsdm,
         v_vc_jzqxdm,
         v_vc_jzjddm,
         v_vc_jzjw,
         v_vc_wsjzshendm,
         v_vc_wsjzsdm,
         v_vc_wsjzqxdm,
         v_vc_wsjzjddm,
         v_vc_wsjzjw,
         v_dt_swrq,
         v_vc_sznl,
         v_vc_sfzhm,
         v_vc_swdd,
         v_vc_sqzgzddw,
         v_vc_zdyj,
         v_vc_gbsy,
         v_vc_jsxm,
         v_vc_jslxdh,
         v_vc_jsdz,
         v_vc_zyh,
         v_vc_azjswjb,
         v_nb_azjswjbicd,
         v_vc_afbdswsjjg,
         v_vc_afbdswsjdw,
         v_vc_bzjswjb,
         v_nb_bzjswjbidc,
         v_vc_bfbdswsjjg,
         v_vc_bfbdswsjdw,
         v_vc_czjswjb,
         v_nb_czjswjbicd,
         v_vc_cfbdswsjjg,
         v_vc_cfbdswsjdw,
         v_vc_dzjswjb,
         v_nb_dajswjbicd,
         v_vc_dfbdswsjjg,
         v_vc_dfbdswsjdw,
         v_vc_szsqbljzztz,
         v_vc_lxdzhgzdw,
         v_dt_dcrq,
         v_vc_hksdm,
         v_vc_hkqxdm,
         v_vc_hkjddm,
         v_dt_csrq,
         v_vc_ysqm,
         v_vc_hkhs,
         v_vc_whsyy,
         v_vc_hkjw,
         v_fenleitj,
         v_vc_ezjswjb,
         v_nb_eajswjbicd,
         v_vc_efbdswsjjg,
         v_vc_efbdswsjdw,
         v_vc_fzjswjb,
         v_nb_fajswjbicd,
         v_vc_ffbdswsjjg,
         v_vc_ffbdswsjdw,
         v_vc_gzjswjb,
         v_nb_gajswjbicd,
         v_vc_gfbdswsjjg,
         v_vc_gfbdswsjdw,
         v_vc_hkqcs,
         v_fenleitjmc,
         v_vc_azjswjb1,
         v_vc_bzjswjb1,
         v_vc_czjswjb1,
         v_vc_dzjswjb1,
         v_vc_ezjswjb1,
         v_vc_fzjswjb1,
         v_vc_gzjswjb1,
         v_vc_zjlx,
         v_vc_rsqk,
         v_vc_wshksdm,
         v_vc_xm,
         v_vc_jkdw,
         v_vc_xb,
         v_vc_mz,
         v_vc_zy,
         v_vc_hyzk,
         v_vc_whcd,
         v_sysdate,
         '0',
         '2', --未删除
         '1', --医院审核通过
         v_sysdate, --录入时间
         v_sysdate, --修改时间
         v_vc_sdqr,
         v_vc_gldwdm,
         '0', --报告卡类别
         v_czyyhid,
         v_czyyhid,
         v_sysdate,
         v_czyjgdm,
         '0',
         '0',
         '0',
         v_nb_gbsybm);
    else
      --修改
      v_ywjl_czlx := '02';
      --修改
      begin
        select vc_shbz, vc_sdqr, vc_hkhs, vc_hkqxdm, vc_hkjddm, vc_gldwdm,vc_hkjw
          into v_vc_shbz,
               v_vc_sdqr,
               v_vc_hkhs_bgq,
               v_vc_hkqxdm_bgq,
               v_vc_hkjddm_bgq,
               v_vc_gldwdm,
               v_vc_hkjw_bgq
          from zjmb_sw_bgk
         where vc_bgkid = v_vc_bgkid
           and vc_scbz = '2';
      exception
        when no_data_found then
          v_err := 'id[' || v_vc_bgkid || ']未获取到有效报告卡信息!';
          raise err_custom;
      end;
      --校验管理单位审核权限
      if v_czyjgjb = '3' then
        if substr(v_vc_gldwdm, 1, 6) <> substr(v_czyjgdm, 1, 6) then
          v_err := '非管理单位无此操作权限!';
          raise err_custom;
        end if;
        if v_vc_hkhs_bgq is not null THEN
          if v_vc_hkqxdm_bgq <> v_vc_hkqxdm or v_vc_hkjddm_bgq <> v_vc_hkjddm 
              /* OR v_vc_hkjw_bgq <> v_vc_hkjw */ THEN
            v_err := '已做户口核实操作,当前机构无操作权限!';
            raise err_custom;
          END IF;
        end if;
        
      end if;
      if v_czyjgjb = '4' then
        --社区
        /* 医院社区可以修改已初访的卡，前端限制只能修改 户籍地址和目前居住地址中的居委会和详细地址四个字段
        if v_vc_hkhs_bgq is not null then
          v_err := '已做户口核实操作,当前机构无操作权限!';
          raise err_custom;
        end if;
        */
        --审核不通过
        if v_vc_shbz in ('0', '2', '4') then
          --修改为审核通过
          v_vc_shbz := '1';
        end if;
        --修改了户籍地址
        if v_vc_hkqxdm_bgq <> v_vc_hkqxdm or v_vc_hkjddm_bgq <> v_vc_hkjddm then
          --审核状态改为医院通过
          v_vc_shbz := '1';
          --属地确认标志
          select count(1), wm_concat(a.code)
            into v_count, v_vc_gldwdm
            from organ_node a
           where a.removed = 0
             and a.description like '%' || v_vc_hkjddm || '%';
          if v_count = 1 then
            --确定属地
            v_vc_sdqr := '1';
          else
            v_vc_gldwdm := v_vc_hkqxdm;
            v_vc_sdqr   := '0';
          end if;
          if v_vc_hkqcs = '1' then
            --2.外省户籍数据（vc_hkqcs=1)，管理单位取报告卡单位前6位（vc_gldwdm=substr(vc_jkdw,1,6)||'00')
            v_vc_sdqr   := '1';
            v_vc_gldwdm := substr(v_czyjgdm, 1, 6) || '00';
          end if;
        end if;
      elsif v_czyjgjb = '3' then
        --区县
        v_vc_shbz := '3';
        --修改了户籍地址
        if v_vc_hkqxdm_bgq <> v_vc_hkqxdm or v_vc_hkjddm_bgq <> v_vc_hkjddm then
          --审核状态改为医院通过
          v_vc_shbz := '1';
          --属地确认标志
          select count(1), wm_concat(a.code)
            into v_count, v_vc_gldwdm
            from organ_node a
           where a.removed = 0
             and a.description like '%' || v_vc_hkjddm || '%';
          if v_count = 1 then
            --确定属地
            v_vc_sdqr := '1';
          else
            v_vc_gldwdm := '';
            v_vc_sdqr   := '0';
          end if;
          if v_vc_hkqcs = '1' then
            --2.外省户籍数据（vc_hkqcs=1)，管理单位取报告卡单位前6位（vc_gldwdm=substr(vc_jkdw,1,6)||'00')
            v_vc_sdqr   := '1';
            v_vc_gldwdm := substr(v_czyjgdm, 1, 6) || '00';
          end if;
        end if;
      else
        v_err := '当前机构无修改权限!';
        raise err_custom;
      end if;
      --获取变更前信息
      select *
        into v_tab_bgk_old
        from zjmb_sw_bgk
       where vc_bgkid = v_vc_bgkid;
      --更新报告卡信息
      update zjmb_sw_bgk
         set vc_wshkqxdm    = v_vc_wshkqxdm,
             vc_wshkjddm    = v_vc_wshkjddm,
             vc_wshkjw      = v_vc_wshkjw,
             vc_gjhdq       = v_vc_gjhdq,
             vc_wshkshendm  = v_vc_wshkshendm,
             vc_jzqcs       = v_vc_jzqcs,
             vc_jzsdm       = v_vc_jzsdm,
             vc_jzqxdm      = v_vc_jzqxdm,
             vc_jzjddm      = v_vc_jzjddm,
             vc_jzjw        = v_vc_jzjw,
             vc_wsjzshendm  = v_vc_wsjzshendm,
             vc_wsjzsdm     = v_vc_wsjzsdm,
             vc_wsjzqxdm    = v_vc_wsjzqxdm,
             vc_wsjzjddm    = v_vc_wsjzjddm,
             vc_wsjzjw      = v_vc_wsjzjw,
             dt_swrq        = v_dt_swrq,
             vc_sznl        = v_vc_sznl,
             vc_sfzhm       = v_vc_sfzhm,
             vc_swdd        = v_vc_swdd,
             vc_sqzgzddw    = v_vc_sqzgzddw,
             vc_zdyj        = v_vc_zdyj,
             vc_gbsy        = v_vc_gbsy,
             vc_jsxm        = v_vc_jsxm,
             vc_jslxdh      = v_vc_jslxdh,
             vc_jsdz        = v_vc_jsdz,
             vc_zyh         = v_vc_zyh,
             vc_azjswjb     = v_vc_azjswjb,
             nb_azjswjbicd  = v_nb_azjswjbicd,
             vc_afbdswsjjg  = v_vc_afbdswsjjg,
             vc_afbdswsjdw  = v_vc_afbdswsjdw,
             vc_bzjswjb     = v_vc_bzjswjb,
             nb_bzjswjbidc  = v_nb_bzjswjbidc,
             vc_bfbdswsjjg  = v_vc_bfbdswsjjg,
             vc_bfbdswsjdw  = v_vc_bfbdswsjdw,
             vc_czjswjb     = v_vc_czjswjb,
             nb_czjswjbicd  = v_nb_czjswjbicd,
             vc_cfbdswsjjg  = v_vc_cfbdswsjjg,
             vc_cfbdswsjdw  = v_vc_cfbdswsjdw,
             vc_dzjswjb     = v_vc_dzjswjb,
             nb_dajswjbicd  = v_nb_dajswjbicd,
             vc_dfbdswsjjg  = v_vc_dfbdswsjjg,
             vc_dfbdswsjdw  = v_vc_dfbdswsjdw,
             vc_szsqbljzztz = v_vc_szsqbljzztz,
             vc_lxdzhgzdw   = v_vc_lxdzhgzdw,
             dt_dcrq        = v_dt_dcrq,
             vc_hksdm       = v_vc_hksdm,
             vc_hkqxdm      = v_vc_hkqxdm,
             vc_hkjddm      = v_vc_hkjddm,
             dt_csrq        = v_dt_csrq,
             vc_ysqm        = v_vc_ysqm,
             vc_hkhs = case
                 when v_vc_shbz = '1' then
                  null
                 else
                  v_vc_hkhs
             end,
             vc_whsyy       = v_vc_whsyy,
             vc_hkjw        = v_vc_hkjw,
             fenleitj       = v_fenleitj,
             vc_ezjswjb     = v_vc_ezjswjb,
             nb_eajswjbicd  = v_nb_eajswjbicd,
             vc_efbdswsjjg  = v_vc_efbdswsjjg,
             vc_efbdswsjdw  = v_vc_efbdswsjdw,
             vc_fzjswjb     = v_vc_fzjswjb,
             nb_fajswjbicd  = v_nb_fajswjbicd,
             vc_ffbdswsjjg  = v_vc_ffbdswsjjg,
             vc_ffbdswsjdw  = v_vc_ffbdswsjdw,
             vc_gzjswjb     = v_vc_gzjswjb,
             nb_gajswjbicd  = v_nb_gajswjbicd,
             vc_gfbdswsjjg  = v_vc_gfbdswsjjg,
             vc_gfbdswsjdw  = v_vc_gfbdswsjdw,
             vc_hkqcs       = v_vc_hkqcs,
             fenleitjmc     = v_fenleitjmc,
             vc_azjswjb1    = v_vc_azjswjb1,
             vc_bzjswjb1    = v_vc_bzjswjb1,
             vc_czjswjb1    = v_vc_czjswjb1,
             vc_dzjswjb1    = v_vc_dzjswjb1,
             vc_ezjswjb1    = v_vc_ezjswjb1,
             vc_fzjswjb1    = v_vc_fzjswjb1,
             vc_gzjswjb1    = v_vc_gzjswjb1,
             vc_zjlx        = v_vc_zjlx,
             vc_rsqk        = v_vc_rsqk,
             vc_wshksdm     = v_vc_wshksdm,
             vc_xm          = v_vc_xm,
             vc_xb          = v_vc_xb,
             vc_mz          = v_vc_mz,
             vc_zy          = v_vc_zy,
             vc_hyzk        = v_vc_hyzk,
             vc_whcd        = v_vc_whcd,
             vc_shbz        = v_vc_shbz,
             vc_sdqr        = v_vc_sdqr,
             vc_gldwdm      = v_vc_gldwdm,
             vc_xgyh        = v_czyyhid,
             nb_gbsybm      = v_nb_gbsybm,
             dt_shsj = case
                         when v_vc_shbz = '3' and dt_shsj is null then
                          v_sysdate
                         else
                          dt_shsj
                       end,
             dt_xgsj        = v_sysdate,
             dt_qxzssj = case
                           when v_vc_shbz = '3' and dt_qxzssj is null then
                            null
                           when v_vc_shbz = '3' and dt_qxzssj is not null then
                            v_sysdate
                           else
                            null
                         end
       where vc_bgkid = v_vc_bgkid;
      --记录报卡变更日志
      v_ywrzid := sys_guid();
      --获取变更后信息
      select *
        into v_tab_bgk_new
        from zjmb_sw_bgk
       where vc_bgkid = v_vc_bgkid;
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_wshkqxdm',
                                         '外省户口区县代码',
                                         v_tab_bgk_old.vc_wshkqxdm,
                                         v_tab_bgk_new.vc_wshkqxdm,
                                         'P_XZDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_wshkjddm',
                                         '外省户口街道代码',
                                         v_tab_bgk_old.vc_wshkjddm,
                                         v_tab_bgk_new.vc_wshkjddm,
                                         'P_XZDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_wshkjw',
                                         '外省户口居委',
                                         v_tab_bgk_old.vc_wshkjw,
                                         v_tab_bgk_new.vc_wshkjw,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_gjhdq',
                                         '国家或地区',
                                         v_tab_bgk_old.vc_gjhdq,
                                         v_tab_bgk_new.vc_gjhdq,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_wshkshendm',
                                         '外省户口省代码',
                                         v_tab_bgk_old.vc_wshkshendm,
                                         v_tab_bgk_new.vc_wshkshendm,
                                         'P_XZDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_jzqcs',
                                         '居住地址省',
                                         v_tab_bgk_old.vc_jzqcs,
                                         v_tab_bgk_new.vc_jzqcs,
                                         'C_COMM_SHEDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_jzsdm',
                                         '居住地址市',
                                         v_tab_bgk_old.vc_jzsdm,
                                         v_tab_bgk_new.vc_jzsdm,
                                         'P_XZDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_jzqxdm',
                                         '居住地址区县',
                                         v_tab_bgk_old.vc_jzqxdm,
                                         v_tab_bgk_new.vc_jzqxdm,
                                         'P_XZDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_jzjddm',
                                         '居住地址街道',
                                         v_tab_bgk_old.vc_jzjddm,
                                         v_tab_bgk_new.vc_jzjddm,
                                         'P_XZDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_jzjw',
                                         '居住地址居委',
                                         v_tab_bgk_old.vc_jzjw,
                                         v_tab_bgk_new.vc_jzjw,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_wsjzshendm',
                                         '外省居住地址省',
                                         v_tab_bgk_old.vc_wsjzshendm,
                                         v_tab_bgk_new.vc_wsjzshendm,
                                         'P_XZDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_wsjzsdm',
                                         '外省居住地址市',
                                         v_tab_bgk_old.vc_wsjzsdm,
                                         v_tab_bgk_new.vc_wsjzsdm,
                                         'P_XZDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_wsjzqxdm',
                                         '外省居住地址区县',
                                         v_tab_bgk_old.vc_wsjzqxdm,
                                         v_tab_bgk_new.vc_wsjzqxdm,
                                         'P_XZDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_wsjzjddm',
                                         '外省居住地址街道',
                                         v_tab_bgk_old.vc_wsjzjddm,
                                         v_tab_bgk_new.vc_wsjzjddm,
                                         'P_XZDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_wsjzjw',
                                         '外省居住地址居委',
                                         v_tab_bgk_old.vc_wsjzjw,
                                         v_tab_bgk_new.vc_wsjzjw,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'dt_swrq',
                                         '死亡日期',
                                         dts(v_tab_bgk_old.dt_swrq, 0),
                                         dts(v_tab_bgk_new.dt_swrq, 0),
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_sznl',
                                         '实足年龄',
                                         v_tab_bgk_old.vc_sznl,
                                         v_tab_bgk_new.vc_sznl,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_sfzhm',
                                         '证件号码',
                                         v_tab_bgk_old.vc_sfzhm,
                                         v_tab_bgk_new.vc_sfzhm,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_swdd',
                                         '死亡地点',
                                         v_tab_bgk_old.vc_swdd,
                                         v_tab_bgk_new.vc_swdd,
                                         'C_SMTJSW_SWDD',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_sqzgzddw',
                                         '主要疾病最高诊断单位',
                                         v_tab_bgk_old.vc_sqzgzddw,
                                         v_tab_bgk_new.vc_sqzgzddw,
                                         'C_SMTJSW_ZGZZDW',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_zdyj',
                                         '主要疾病最高诊断依据',
                                         v_tab_bgk_old.vc_zdyj,
                                         v_tab_bgk_new.vc_zdyj,
                                         'C_SMTJSW_ZGZDYJ',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_gbsy',
                                         '根本死亡原因',
                                         v_tab_bgk_old.vc_gbsy,
                                         v_tab_bgk_new.vc_gbsy,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_jsxm',
                                         '可联系家属姓名',
                                         v_tab_bgk_old.vc_jsxm,
                                         v_tab_bgk_new.vc_jsxm,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_jslxdh',
                                         '家属联系电话',
                                         v_tab_bgk_old.vc_jslxdh,
                                         v_tab_bgk_new.vc_jslxdh,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_jsdz',
                                         '家属住址或工作单位',
                                         v_tab_bgk_old.vc_jsdz,
                                         v_tab_bgk_new.vc_jsdz,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_zyh',
                                         '医院号',
                                         v_tab_bgk_old.vc_zyh,
                                         v_tab_bgk_new.vc_zyh,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_azjswjb',
                                         'a直接导致死亡的疾病',
                                         v_tab_bgk_old.vc_azjswjb,
                                         v_tab_bgk_new.vc_azjswjb,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'nb_azjswjbicd',
                                         'a直接导致死亡的疾病ICD10编码',
                                         v_tab_bgk_old.nb_azjswjbicd,
                                         v_tab_bgk_new.nb_azjswjbicd,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_afbdswsjjg',
                                         'a发病到死亡的时间间隔',
                                         v_tab_bgk_old.vc_afbdswsjjg,
                                         v_tab_bgk_new.vc_afbdswsjjg,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_afbdswsjdw',
                                         'a发病到死亡的时间间隔单位',
                                         v_tab_bgk_old.vc_afbdswsjdw,
                                         v_tab_bgk_new.vc_afbdswsjdw,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_bzjswjb',
                                         'b直接导致死亡的疾病',
                                         v_tab_bgk_old.vc_bzjswjb,
                                         v_tab_bgk_new.vc_bzjswjb,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'nb_bzjswjbidc',
                                         'b直接导致死亡的疾病ICD10编码',
                                         v_tab_bgk_old.nb_bzjswjbidc,
                                         v_tab_bgk_new.nb_bzjswjbidc,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_bfbdswsjjg',
                                         'b发病到死亡的时间间隔',
                                         v_tab_bgk_old.vc_bfbdswsjjg,
                                         v_tab_bgk_new.vc_bfbdswsjjg,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_bfbdswsjdw',
                                         'b发病到死亡的时间间隔单位',
                                         v_tab_bgk_old.vc_bfbdswsjdw,
                                         v_tab_bgk_new.vc_bfbdswsjdw,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_czjswjb',
                                         'c直接导致死亡的疾病',
                                         v_tab_bgk_old.vc_czjswjb,
                                         v_tab_bgk_new.vc_czjswjb,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'nb_czjswjbicd',
                                         'c直接导致死亡的疾病ICD10编码',
                                         v_tab_bgk_old.nb_czjswjbicd,
                                         v_tab_bgk_new.nb_czjswjbicd,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_bszy',
                                         'c发病到死亡的时间间隔',
                                         v_tab_bgk_old.vc_cfbdswsjjg,
                                         v_tab_bgk_new.vc_cfbdswsjjg,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_cfbdswsjdw',
                                         'c发病到死亡的时间间隔单位',
                                         v_tab_bgk_old.vc_cfbdswsjdw,
                                         v_tab_bgk_new.vc_cfbdswsjdw,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_dzjswjb',
                                         'd直接导致死亡的疾病',
                                         v_tab_bgk_old.vc_dzjswjb,
                                         v_tab_bgk_new.vc_dzjswjb,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'nb_dajswjbicd',
                                         'd直接导致死亡的疾病ICD10编码',
                                         v_tab_bgk_old.nb_dajswjbicd,
                                         v_tab_bgk_new.nb_dajswjbicd,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_dfbdswsjjg',
                                         'd发病到死亡的时间间隔',
                                         v_tab_bgk_old.vc_dfbdswsjjg,
                                         v_tab_bgk_new.vc_dfbdswsjjg,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_dfbdswsjdw',
                                         'd发病到死亡的时间间隔单位',
                                         v_tab_bgk_old.vc_dfbdswsjdw,
                                         v_tab_bgk_new.vc_dfbdswsjdw,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_szsqbljzztz',
                                         '死者生前病史及症状体征',
                                         v_tab_bgk_old.vc_szsqbljzztz,
                                         v_tab_bgk_new.vc_szsqbljzztz,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_lxdzhgzdw',
                                         '联系地址或工作单位',
                                         v_tab_bgk_old.vc_lxdzhgzdw,
                                         v_tab_bgk_new.vc_lxdzhgzdw,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'dt_dcrq',
                                         '调查日期',
                                         dts(v_tab_bgk_old.dt_dcrq, 0),
                                         dts(v_tab_bgk_new.dt_dcrq, 0),
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_hksdm',
                                         '户口省代码',
                                         v_tab_bgk_old.vc_hksdm,
                                         v_tab_bgk_new.vc_hksdm,
                                         'C_COMM_SHEDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_hksdm',
                                         '户口市代码',
                                         v_tab_bgk_old.vc_hksdm,
                                         v_tab_bgk_new.vc_hksdm,
                                         'P_XZDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_hkqxdm',
                                         '户口区县代码',
                                         v_tab_bgk_old.vc_hkqxdm,
                                         v_tab_bgk_new.vc_hkqxdm,
                                         'P_XZDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_hkjddm',
                                         '户口街道代码',
                                         v_tab_bgk_old.vc_hkjddm,
                                         v_tab_bgk_new.vc_hkjddm,
                                         'P_XZDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'dt_csrq',
                                         '出生日期',
                                         dts(v_tab_bgk_old.dt_csrq, 0),
                                         dts(v_tab_bgk_new.dt_csrq, 0),
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_ysqm',
                                         '医师签名',
                                         v_tab_bgk_old.vc_ysqm,
                                         v_tab_bgk_new.vc_ysqm,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_hkhs',
                                         '户口核实',
                                         v_tab_bgk_old.vc_hkhs,
                                         v_tab_bgk_new.vc_hkhs,
                                         'C_COMM_SF',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_whsyy',
                                         '未核实原因',
                                         v_tab_bgk_old.vc_whsyy,
                                         v_tab_bgk_new.vc_whsyy,
                                         'C_SMTJSW_WHSYY',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_hkjw',
                                         '户口居委',
                                         v_tab_bgk_old.vc_hkjw,
                                         v_tab_bgk_new.vc_hkjw,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'fenleitj',
                                         '分类统计号',
                                         v_tab_bgk_old.fenleitj,
                                         v_tab_bgk_new.fenleitj,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_ezjswjb',
                                         'e直接导致死亡的疾病',
                                         v_tab_bgk_old.vc_ezjswjb,
                                         v_tab_bgk_new.vc_ezjswjb,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'nb_eajswjbicd',
                                         'e直接导致死亡的疾病ICD10编码',
                                         v_tab_bgk_old.nb_eajswjbicd,
                                         v_tab_bgk_new.nb_eajswjbicd,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_efbdswsjjg',
                                         'e发病到死亡的时间间隔',
                                         v_tab_bgk_old.vc_efbdswsjjg,
                                         v_tab_bgk_new.vc_efbdswsjjg,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_efbdswsjdw',
                                         'e发病到死亡的时间间隔单位',
                                         v_tab_bgk_old.vc_efbdswsjdw,
                                         v_tab_bgk_new.vc_efbdswsjdw,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_fzjswjb',
                                         'f直接导致死亡的疾病',
                                         v_tab_bgk_old.vc_fzjswjb,
                                         v_tab_bgk_new.vc_fzjswjb,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'nb_fajswjbicd',
                                         'f直接导致死亡的疾病ICD10编码',
                                         v_tab_bgk_old.nb_fajswjbicd,
                                         v_tab_bgk_new.nb_fajswjbicd,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_ffbdswsjjg',
                                         'f发病到死亡的时间间隔',
                                         v_tab_bgk_old.vc_ffbdswsjjg,
                                         v_tab_bgk_new.vc_ffbdswsjjg,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_ffbdswsjdw',
                                         'f发病到死亡的时间间隔单位',
                                         v_tab_bgk_old.vc_ffbdswsjdw,
                                         v_tab_bgk_new.vc_ffbdswsjdw,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_gzjswjb',
                                         'g直接导致死亡的疾病',
                                         v_tab_bgk_old.vc_gzjswjb,
                                         v_tab_bgk_new.vc_gzjswjb,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'nb_gajswjbicd',
                                         'g直接导致死亡的疾病ICD10编码',
                                         v_tab_bgk_old.nb_gajswjbicd,
                                         v_tab_bgk_new.nb_gajswjbicd,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_gfbdswsjjg',
                                         'g发病到死亡的时间间隔',
                                         v_tab_bgk_old.vc_gfbdswsjjg,
                                         v_tab_bgk_new.vc_gfbdswsjjg,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_gfbdswsjdw',
                                         'g发病到死亡的时间间隔单位',
                                         v_tab_bgk_old.vc_gfbdswsjdw,
                                         v_tab_bgk_new.vc_gfbdswsjdw,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_hkqcs',
                                         '户口省代码',
                                         v_tab_bgk_old.vc_hkqcs,
                                         v_tab_bgk_new.vc_hkqcs,
                                         'C_COMM_SHEDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'fenleitjmc',
                                         '分类统计名称',
                                         v_tab_bgk_old.fenleitjmc,
                                         v_tab_bgk_new.fenleitjmc,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_azjswjb1',
                                         '具体的疾病名a',
                                         v_tab_bgk_old.vc_azjswjb1,
                                         v_tab_bgk_new.vc_azjswjb1,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_bzjswjb1',
                                         '具体的疾病名b',
                                         v_tab_bgk_old.vc_bzjswjb1,
                                         v_tab_bgk_new.vc_bzjswjb1,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_czjswjb1',
                                         '具体的疾病名c',
                                         v_tab_bgk_old.vc_czjswjb1,
                                         v_tab_bgk_new.vc_czjswjb1,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_dzjswjb1',
                                         '具体的疾病名d',
                                         v_tab_bgk_old.vc_dzjswjb1,
                                         v_tab_bgk_new.vc_dzjswjb1,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_ezjswjb1',
                                         '具体的疾病名e',
                                         v_tab_bgk_old.vc_ezjswjb1,
                                         v_tab_bgk_new.vc_ezjswjb1,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_fzjswjb1',
                                         '具体的疾病名f',
                                         v_tab_bgk_old.vc_fzjswjb1,
                                         v_tab_bgk_new.vc_fzjswjb1,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_gzjswjb1',
                                         '具体的疾病名g',
                                         v_tab_bgk_old.vc_gzjswjb1,
                                         v_tab_bgk_new.vc_gzjswjb1,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_zjlx',
                                         '有效证件类别',
                                         v_tab_bgk_old.vc_zjlx,
                                         v_tab_bgk_new.vc_zjlx,
                                         'C_SMTJSW_ZJLX',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_rsqk',
                                         '死亡时是否处于妊娠期或妊娠终止后42天内',
                                         v_tab_bgk_old.vc_rsqk,
                                         v_tab_bgk_new.vc_rsqk,
                                         'C_COMM_SF',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_wshksdm',
                                         '外省户口市',
                                         v_tab_bgk_old.vc_wshksdm,
                                         v_tab_bgk_new.vc_wshksdm,
                                         'P_XZDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_xm',
                                         '姓名',
                                         v_tab_bgk_old.vc_xm,
                                         v_tab_bgk_new.vc_xm,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_xb',
                                         '性别',
                                         v_tab_bgk_old.vc_xb,
                                         v_tab_bgk_new.vc_xb,
                                         'C_SMTJSW_XB',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_mz',
                                         '民族',
                                         v_tab_bgk_old.vc_mz,
                                         v_tab_bgk_new.vc_mz,
                                         'C_COMM_MZ',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_zy',
                                         '个人身份',
                                         v_tab_bgk_old.vc_zy,
                                         v_tab_bgk_new.vc_zy,
                                         'C_SMTJSW_GRSF',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_hyzk',
                                         '婚姻状况',
                                         v_tab_bgk_old.vc_hyzk,
                                         v_tab_bgk_new.vc_hyzk,
                                         'C_COMM_HYZK',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_whcd',
                                         '文化程度',
                                         v_tab_bgk_old.vc_whcd,
                                         v_tab_bgk_new.vc_whcd,
                                         'C_SMTJSW_WHCD',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_shbz',
                                         '审核标志',
                                         v_tab_bgk_old.vc_shbz,
                                         v_tab_bgk_new.vc_shbz,
                                         'C_COMM_SHZT',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_sdqr',
                                         '属地确认',
                                         v_tab_bgk_old.vc_sdqr,
                                         v_tab_bgk_new.vc_sdqr,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'vc_gldwdm',
                                         '管理单位',
                                         v_tab_bgk_old.vc_gldwdm,
                                         v_tab_bgk_new.vc_gldwdm,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'nb_gbsybm',
                                         '根本死因ICD编码',
                                         v_tab_bgk_old.nb_gbsybm,
                                         v_tab_bgk_new.nb_gbsybm,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'dt_shsj',
                                         '审核时间',
                                         dts(v_tab_bgk_old.dt_shsj, 0),
                                         dts(v_tab_bgk_new.dt_shsj, 0),
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '05',
                                         'dt_qxzssj',
                                         '区县终审时间',
                                         dts(v_tab_bgk_old.dt_qxzssj, 0),
                                         dts(v_tab_bgk_new.dt_qxzssj, 0),
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
    
    end if;
    --添加操作日志
    v_json_yw_log := Json_ext.get_json(v_json_data, 'ywjllog');
    if v_json_yw_log is not null then
      v_json_yw_log.put('ywrzid', v_ywrzid);
      v_json_yw_log.put('bgkid', v_vc_bgkid);
      v_json_yw_log.put('bgklx', '05');
      v_json_yw_log.put('ywjlid', v_vc_bgkid);
      v_json_yw_log.put('gnmk', '01');
      v_json_yw_log.put('gnmc', '报卡管理');
      v_json_yw_log.put('czlx', v_ywjl_czlx);
      v_json_yw_log.put('ywjlid', v_vc_bgkid);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_update(v_json_yw_log, v_err);
      if v_err is not null then
        raise err_custom;
      end if;
    end if;
    --返回
    v_Json_Return.put('id', v_vc_bgkid);
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_sw_bgk_update;
  /*--------------------------------------------------------------------------
  || 功能描述 ：获取报告卡编码
  ||------------------------------------------------------------------------*/
  FUNCTION fun_getbgkid_sw(prm_jgdm VARCHAR2) --市区及医院码
   RETURN VARCHAR2 is
    v_id zjmb_sw_bgk.vc_bgkid%type;
    v_dm VARCHAR2(30);
  begin
    if prm_jgdm is null then
      return '';
    end if;
    v_dm := prm_jgdm || to_char(sysdate, 'yyyy');
    select nvl(max(VC_BGKID) + 1, v_dm || '0001')
      into v_id
      from zjmb_sw_bgk
     where vc_bgkid like v_dm || '%';
    return v_id;
  END fun_getbgkid_sw;
  /*--------------------------------------------------------------------------
  || 功能描述 ：死因初访
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_sw_bgk_cf(Data_In    In Clob, --入参
                          result_out OUT VARCHAR2) --返回
   is
    v_json_data   json;
    v_json_yw_log json;
    v_ywjl_czlx   varchar2(3);
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
  
    --公共变量
    v_sysdate date;
    v_czyjgjb varchar2(3);
    v_czyjgdm varchar2(50);
    v_czyyhid varchar2(50);
    v_count   number;
  
    v_vc_xm          zjmb_sw_bgk.vc_xm%TYPE; --姓名
    v_vc_xb          zjmb_sw_bgk.vc_xb%TYPE; --性别
    v_vc_mz          zjmb_sw_bgk.vc_mz%TYPE; --民族
    v_vc_gjhdq       zjmb_sw_bgk.vc_gjhdq%TYPE; --国家或地区
    v_vc_zjlx        zjmb_sw_bgk.vc_zjlx%TYPE; --证件类型
    v_vc_sfzhm       zjmb_sw_bgk.vc_sfzhm%TYPE; --身份证号码
    v_vc_hyzk        zjmb_sw_bgk.vc_hyzk%TYPE; --婚姻状况
    v_vc_whcd        zjmb_sw_bgk.vc_whcd%TYPE; --文化程度
    v_vc_hkqcs       zjmb_sw_bgk.vc_hkqcs%TYPE; --户口省代码
    v_vc_hksdm       zjmb_sw_bgk.vc_hksdm%TYPE; --户口市代码
    v_vc_hkqxdm      zjmb_sw_bgk.vc_hkqxdm%TYPE; --户口区县代码
    v_vc_hkjddm      zjmb_sw_bgk.vc_hkjddm%TYPE; --户口街道代码
    v_vc_hkjw        zjmb_sw_bgk.vc_hkjw%TYPE; --户口居委
    v_vc_wshkshendm  zjmb_sw_bgk.vc_wshkshendm%TYPE; --外省户口省代码
    v_vc_wshksdm     zjmb_sw_bgk.vc_wshksdm%TYPE; --外省户口市代码
    v_vc_wshkqxdm    zjmb_sw_bgk.vc_wshkqxdm%TYPE; --外省户口区县代码
    v_vc_wshkjddm    zjmb_sw_bgk.vc_wshkjddm%TYPE; --外省户口街道代码
    v_vc_wshkjw      zjmb_sw_bgk.vc_wshkjw%TYPE; --外省户口居委
    v_vc_jzqcs       zjmb_sw_bgk.vc_jzqcs%TYPE; --居住省代码
    v_vc_jzsdm       zjmb_sw_bgk.vc_jzsdm%TYPE; --居住市代码
    v_vc_jzqxdm      zjmb_sw_bgk.vc_jzqxdm%TYPE; --居住区县代码
    v_vc_jzjddm      zjmb_sw_bgk.vc_jzjddm%TYPE; --居住街道代码
    v_vc_jzjw        zjmb_sw_bgk.vc_jzjw%TYPE; --居住居委
    v_vc_wsjzshendm  zjmb_sw_bgk.vc_wsjzshendm%TYPE; --外省居住省代码
    v_vc_wsjzsdm     zjmb_sw_bgk.vc_wsjzsdm%TYPE; --外省居住市代码
    v_vc_wsjzqxdm    zjmb_sw_bgk.vc_wsjzqxdm%TYPE; --外省居住区县代码
    v_vc_wsjzjddm    zjmb_sw_bgk.vc_wsjzjddm%TYPE; --外省居住街道代码
    v_vc_wsjzjw      zjmb_sw_bgk.vc_wsjzjw%TYPE; --外省居住居委
    v_vc_zy          zjmb_sw_bgk.vc_zy%TYPE; --职业
    v_vc_lxdzhgzdw   zjmb_sw_bgk.vc_lxdzhgzdw%TYPE; --联系地址或工作单位
    v_dt_csrq        zjmb_sw_bgk.dt_csrq%TYPE; --出生日期
    v_dt_swrq        zjmb_sw_bgk.dt_swrq%TYPE; --死亡日期
    v_vc_jsxm        zjmb_sw_bgk.vc_jsxm%TYPE; --家属姓名
    v_vc_jslxdh      zjmb_sw_bgk.vc_jslxdh%TYPE; --家属联系电话
    v_vc_jsdz        zjmb_sw_bgk.vc_jsdz%TYPE; --家属地址或工作单位
    v_vc_sznl        zjmb_sw_bgk.vc_sznl%TYPE; --实足年龄
    v_vc_swdd        zjmb_sw_bgk.vc_swdd%TYPE; --死亡地点
    v_vc_rsqk        zjmb_sw_bgk.vc_rsqk%TYPE; --妊娠情况
    v_vc_azjswjb1    zjmb_sw_bgk.vc_azjswjb1%TYPE; --
    v_vc_bzjswjb1    zjmb_sw_bgk.vc_bzjswjb1%TYPE; --
    v_vc_czjswjb1    zjmb_sw_bgk.vc_czjswjb1%TYPE; --
    v_vc_dzjswjb1    zjmb_sw_bgk.vc_dzjswjb1%TYPE; --
    v_vc_ezjswjb1    zjmb_sw_bgk.vc_ezjswjb1%TYPE; --
    v_vc_fzjswjb1    zjmb_sw_bgk.vc_fzjswjb1%TYPE; --
    v_vc_gzjswjb1    zjmb_sw_bgk.vc_gzjswjb1%TYPE; --
    v_vc_azjswjb     zjmb_sw_bgk.vc_azjswjb%TYPE; --a直接导致死亡的疾病
    v_nb_azjswjbicd  zjmb_sw_bgk.nb_azjswjbicd%TYPE; --a直接导致死亡的疾病ICD10编码
    v_vc_afbdswsjjg  zjmb_sw_bgk.vc_afbdswsjjg%TYPE; --a发病到死亡的时间间隔
    v_vc_afbdswsjdw  zjmb_sw_bgk.vc_afbdswsjdw%TYPE; --a发病到死亡的时间间隔单位
    v_vc_bzjswjb     zjmb_sw_bgk.vc_bzjswjb%TYPE; --b直接导致死亡的疾病
    v_nb_bzjswjbidc  zjmb_sw_bgk.nb_bzjswjbidc%TYPE; --b直接导致死亡的疾病ICD10编码
    v_vc_bfbdswsjjg  zjmb_sw_bgk.vc_bfbdswsjjg%TYPE; --b发病到死亡的时间间隔
    v_vc_bfbdswsjdw  zjmb_sw_bgk.vc_bfbdswsjdw%TYPE; --b发病到死亡的时间间隔单位
    v_vc_czjswjb     zjmb_sw_bgk.vc_czjswjb%TYPE; --c直接导致死亡的疾病
    v_nb_czjswjbicd  zjmb_sw_bgk.nb_czjswjbicd%TYPE; --c直接导致死亡的疾病ICD10编码
    v_vc_cfbdswsjjg  zjmb_sw_bgk.vc_cfbdswsjjg%TYPE; --c发病到死亡的时间间隔
    v_vc_cfbdswsjdw  zjmb_sw_bgk.vc_cfbdswsjdw%TYPE; --c发病到死亡的时间间隔单位
    v_vc_dzjswjb     zjmb_sw_bgk.vc_dzjswjb%TYPE; --d直接导致死亡的疾病
    v_nb_dajswjbicd  zjmb_sw_bgk.nb_dajswjbicd%TYPE; --d直接导致死亡的疾病ICD10编码
    v_vc_dfbdswsjjg  zjmb_sw_bgk.vc_dfbdswsjjg%TYPE; --d发病到死亡的时间间隔
    v_vc_dfbdswsjdw  zjmb_sw_bgk.vc_dfbdswsjdw%TYPE; --d发病到死亡的时间间隔单位
    v_vc_ezjswjb     zjmb_sw_bgk.vc_ezjswjb%TYPE; --e直接导致死亡的疾病
    v_nb_eajswjbicd  zjmb_sw_bgk.nb_eajswjbicd%TYPE; --e直接导致死亡的疾病ICD10编码
    v_vc_efbdswsjjg  zjmb_sw_bgk.vc_efbdswsjjg%TYPE; --e发病到死亡的时间间隔
    v_vc_efbdswsjdw  zjmb_sw_bgk.vc_efbdswsjdw%TYPE; --e发病到死亡的时间间隔单位
    v_vc_fzjswjb     zjmb_sw_bgk.vc_fzjswjb%TYPE; --f直接导致死亡的疾病
    v_nb_fajswjbicd  zjmb_sw_bgk.nb_fajswjbicd%TYPE; --f直接导致死亡的疾病ICD10编码
    v_vc_ffbdswsjjg  zjmb_sw_bgk.vc_ffbdswsjjg%TYPE; --f发病到死亡的时间间隔
    v_vc_ffbdswsjdw  zjmb_sw_bgk.vc_ffbdswsjdw%TYPE; --f发病到死亡的时间间隔单位
    v_vc_gzjswjb     zjmb_sw_bgk.vc_gzjswjb%TYPE; --g直接导致死亡的疾病
    v_nb_gajswjbicd  zjmb_sw_bgk.nb_gajswjbicd%TYPE; --g直接导致死亡的疾病ICD10编码
    v_vc_gfbdswsjjg  zjmb_sw_bgk.vc_gfbdswsjjg%TYPE; --g发病到死亡的时间间隔
    v_vc_gfbdswsjdw  zjmb_sw_bgk.vc_gfbdswsjdw%TYPE; --g发病到死亡的时间间隔单位
    v_vc_sqzgzddw    zjmb_sw_bgk.vc_sqzgzddw%TYPE; --生前最高诊断单位
    v_vc_zdyj        zjmb_sw_bgk.vc_zdyj%TYPE; --诊断依据
    v_vc_zyh         zjmb_sw_bgk.vc_zyh%TYPE; --住院号
    v_vc_ysqm        zjmb_sw_bgk.vc_ysqm%TYPE; --医生签名
    v_vc_gbsy        zjmb_sw_bgk.vc_gbsy%TYPE; --根本死因
    v_fenleitj       zjmb_sw_bgk.fenleitj%TYPE; --分类统计号
    v_fenleitjmc     zjmb_sw_bgk.fenleitjmc%TYPE; --分类统计号
    v_dt_dcrq        zjmb_sw_bgk.dt_dcrq%TYPE; --调查日期
    v_vc_jkdw        zjmb_sw_bgk.vc_jkdw%TYPE; --建卡医院
    v_vc_szsqbljzztz zjmb_sw_bgk.vc_szsqbljzztz%TYPE; --死者生前病史及症状体征
    v_vc_hkhs        zjmb_sw_bgk.vc_hkhs%TYPE; --户口核实
    v_vc_hkhs_bgq    zjmb_sw_bgk.vc_hkhs%TYPE; --户口核实变更前
    v_vc_whsyy       zjmb_sw_bgk.vc_whsyy%TYPE; --未核实原因
    v_vc_bgkid       zjmb_sw_bgk.vc_bgkid%TYPE; --报告卡id
    v_vc_gldwdm      zjmb_sw_bgk.vc_gldwdm%TYPE; --管理单位
    v_vc_sdqr        zjmb_sw_bgk.vc_sdqr%TYPE; --属地确认标志
    v_vc_shbz        zjmb_sw_bgk.vc_shbz%TYPE; --审核标志
    v_vc_hkqxdm_bgq  zjmb_sw_bgk.vc_hkqxdm%TYPE; --变更前区县代码
    v_vc_hkjddm_bgq  zjmb_sw_bgk.vc_hkjddm%TYPE; --变更前街道代码
  BEGIN
    json_data(data_in, 'zjmb_sw_bgk初访', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm'); --操作员机构代码
    v_czyyhid := Json_Str(v_Json_Data, 'v_czyyhid');
    --获取机构级别
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
  
    v_vc_bgkid       := Json_Str(v_Json_Data, 'vc_bgkid');
    v_vc_wshkqxdm    := Json_Str(v_Json_Data, 'vc_wshkqxdm');
    v_vc_wshkjddm    := Json_Str(v_Json_Data, 'vc_wshkjddm');
    v_vc_wshkjw      := Json_Str(v_Json_Data, 'vc_wshkjw');
    v_vc_gjhdq       := Json_Str(v_Json_Data, 'vc_gjhdq');
    v_vc_wshkshendm  := Json_Str(v_Json_Data, 'vc_wshkshendm');
    v_vc_jzqcs       := Json_Str(v_Json_Data, 'vc_jzqcs');
    v_vc_jzsdm       := Json_Str(v_Json_Data, 'vc_jzsdm');
    v_vc_jzqxdm      := Json_Str(v_Json_Data, 'vc_jzqxdm');
    v_vc_jzjddm      := Json_Str(v_Json_Data, 'vc_jzjddm');
    v_vc_jzjw        := Json_Str(v_Json_Data, 'vc_jzjw');
    v_vc_wsjzshendm  := Json_Str(v_Json_Data, 'vc_wsjzshendm');
    v_vc_wsjzsdm     := Json_Str(v_Json_Data, 'vc_wsjzsdm');
    v_vc_wsjzqxdm    := Json_Str(v_Json_Data, 'vc_wsjzqxdm');
    v_vc_wsjzjddm    := Json_Str(v_Json_Data, 'vc_wsjzjddm');
    v_vc_wsjzjw      := Json_Str(v_Json_Data, 'vc_wsjzjw');
    v_dt_swrq        := std(Json_Str(v_Json_Data, 'dt_swrq'), 0);
    v_vc_sznl        := Json_Str(v_Json_Data, 'vc_sznl');
    v_vc_sfzhm       := Json_Str(v_Json_Data, 'vc_sfzhm');
    v_vc_swdd        := Json_Str(v_Json_Data, 'vc_swdd');
    v_vc_sqzgzddw    := Json_Str(v_Json_Data, 'vc_sqzgzddw');
    v_vc_zdyj        := Json_Str(v_Json_Data, 'vc_zdyj');
    v_vc_gbsy        := Json_Str(v_Json_Data, 'vc_gbsy');
    v_vc_jsxm        := Json_Str(v_Json_Data, 'vc_jsxm');
    v_vc_jslxdh      := Json_Str(v_Json_Data, 'vc_jslxdh');
    v_vc_jsdz        := Json_Str(v_Json_Data, 'vc_jsdz');
    v_vc_zyh         := Json_Str(v_Json_Data, 'vc_zyh');
    v_vc_azjswjb     := Json_Str(v_Json_Data, 'vc_azjswjb');
    v_nb_azjswjbicd  := Json_Str(v_Json_Data, 'nb_azjswjbicd');
    v_vc_afbdswsjjg  := Json_Str(v_Json_Data, 'vc_afbdswsjjg');
    v_vc_afbdswsjdw  := Json_Str(v_Json_Data, 'vc_afbdswsjdw');
    v_vc_bzjswjb     := Json_Str(v_Json_Data, 'vc_bzjswjb');
    v_nb_bzjswjbidc  := Json_Str(v_Json_Data, 'nb_bzjswjbidc');
    v_vc_bfbdswsjjg  := Json_Str(v_Json_Data, 'vc_bfbdswsjjg');
    v_vc_bfbdswsjdw  := Json_Str(v_Json_Data, 'vc_bfbdswsjdw');
    v_vc_czjswjb     := Json_Str(v_Json_Data, 'vc_czjswjb');
    v_nb_czjswjbicd  := Json_Str(v_Json_Data, 'nb_czjswjbicd');
    v_vc_cfbdswsjjg  := Json_Str(v_Json_Data, 'vc_cfbdswsjjg');
    v_vc_cfbdswsjdw  := Json_Str(v_Json_Data, 'vc_cfbdswsjdw');
    v_vc_dzjswjb     := Json_Str(v_Json_Data, 'vc_dzjswjb');
    v_nb_dajswjbicd  := Json_Str(v_Json_Data, 'nb_dajswjbicd');
    v_vc_dfbdswsjjg  := Json_Str(v_Json_Data, 'vc_dfbdswsjjg');
    v_vc_dfbdswsjdw  := Json_Str(v_Json_Data, 'vc_dfbdswsjdw');
    v_vc_szsqbljzztz := Json_Str(v_Json_Data, 'vc_szsqbljzztz');
    v_vc_lxdzhgzdw   := Json_Str(v_Json_Data, 'vc_lxdzhgzdw');
    v_dt_dcrq        := std(Json_Str(v_Json_Data, 'dt_dcrq'), 0);
    v_vc_hksdm       := Json_Str(v_Json_Data, 'vc_hksdm');
    v_vc_hkqxdm      := Json_Str(v_Json_Data, 'vc_hkqxdm');
    v_vc_hkjddm      := Json_Str(v_Json_Data, 'vc_hkjddm');
    v_dt_csrq        := std(Json_Str(v_Json_Data, 'dt_csrq'), 0);
    v_vc_ysqm        := Json_Str(v_Json_Data, 'vc_ysqm');
    v_vc_hkhs        := Json_Str(v_Json_Data, 'vc_hkhs');
    v_vc_whsyy       := Json_Str(v_Json_Data, 'vc_whsyy');
    v_vc_hkjw        := Json_Str(v_Json_Data, 'vc_hkjw');
    v_fenleitj       := Json_Str(v_Json_Data, 'fenleitj');
    v_vc_ezjswjb     := Json_Str(v_Json_Data, 'vc_ezjswjb');
    v_nb_eajswjbicd  := Json_Str(v_Json_Data, 'nb_eajswjbicd');
    v_vc_efbdswsjjg  := Json_Str(v_Json_Data, 'vc_efbdswsjjg');
    v_vc_efbdswsjdw  := Json_Str(v_Json_Data, 'vc_efbdswsjdw');
    v_vc_fzjswjb     := Json_Str(v_Json_Data, 'vc_fzjswjb');
    v_nb_fajswjbicd  := Json_Str(v_Json_Data, 'nb_fajswjbicd');
    v_vc_ffbdswsjjg  := Json_Str(v_Json_Data, 'vc_ffbdswsjjg');
    v_vc_ffbdswsjdw  := Json_Str(v_Json_Data, 'vc_ffbdswsjdw');
    v_vc_gzjswjb     := Json_Str(v_Json_Data, 'vc_gzjswjb');
    v_nb_gajswjbicd  := Json_Str(v_Json_Data, 'nb_gajswjbicd');
    v_vc_gfbdswsjjg  := Json_Str(v_Json_Data, 'vc_gfbdswsjjg');
    v_vc_gfbdswsjdw  := Json_Str(v_Json_Data, 'vc_gfbdswsjdw');
    v_vc_hkqcs       := Json_Str(v_Json_Data, 'vc_hkqcs');
    v_fenleitjmc     := Json_Str(v_Json_Data, 'fenleitjmc');
    v_vc_azjswjb1    := Json_Str(v_Json_Data, 'vc_azjswjb1');
    v_vc_bzjswjb1    := Json_Str(v_Json_Data, 'vc_bzjswjb1');
    v_vc_czjswjb1    := Json_Str(v_Json_Data, 'vc_czjswjb1');
    v_vc_dzjswjb1    := Json_Str(v_Json_Data, 'vc_dzjswjb1');
    v_vc_ezjswjb1    := Json_Str(v_Json_Data, 'vc_ezjswjb1');
    v_vc_fzjswjb1    := Json_Str(v_Json_Data, 'vc_fzjswjb1');
    v_vc_gzjswjb1    := Json_Str(v_Json_Data, 'vc_gzjswjb1');
    v_vc_zjlx        := Json_Str(v_Json_Data, 'vc_zjlx');
    v_vc_rsqk        := Json_Str(v_Json_Data, 'vc_rsqk');
    v_vc_wshksdm     := Json_Str(v_Json_Data, 'vc_wshksdm');
    v_vc_xm          := Json_Str(v_Json_Data, 'vc_xm');
    v_vc_jkdw        := Json_Str(v_Json_Data, 'vc_jkdw');
    v_vc_xb          := Json_Str(v_Json_Data, 'vc_xb');
    v_vc_mz          := Json_Str(v_Json_Data, 'vc_mz');
    v_vc_zy          := Json_Str(v_Json_Data, 'vc_zy');
    v_vc_hyzk        := Json_Str(v_Json_Data, 'vc_hyzk');
    v_vc_whcd        := Json_Str(v_Json_Data, 'vc_whcd');
    --检验字段必填
    --校验数据是否合法
    if v_vc_xm is null then
      v_err := '姓名不能为空!';
      raise err_custom;
    end if;
    if v_vc_xb is null then
      v_err := '性别不能为空!';
      raise err_custom;
    end if;
    if v_vc_mz is null then
      v_err := '民族不能为空!';
      raise err_custom;
    end if;
    if v_vc_zjlx is null then
      v_err := '证件类型不能为空!';
      raise err_custom;
    end if;
    if v_vc_sfzhm is null then
      v_err := '证件号码不能为空!';
      raise err_custom;
    end if;
    if v_vc_hyzk is null then
      v_err := '婚姻状况不能为空!';
      raise err_custom;
    end if;
    if v_vc_hkqcs is null then
      v_err := '户籍地址省不能为空!';
      raise err_custom;
    end if;
    --户籍地址浙江
    if v_vc_hkqcs = '0' then
      if v_vc_hksdm is null then
        v_err := '户籍地址市不能为空!';
        raise err_custom;
      end if;
      if v_vc_hkqxdm is null then
        v_err := '户籍地址区县不能为空!';
        raise err_custom;
      end if;
      if v_vc_hkjddm is null then
        v_err := '户籍地址街道不能为空!';
        raise err_custom;
      end if;
      if substr(v_vc_hksdm, 1, 4) <> substr(v_vc_hkqxdm, 1, 4) or
         substr(v_vc_hksdm, 1, 4) <> substr(v_vc_hkjddm, 1, 4) then
        v_err := '户籍地址区划不匹配!';
        raise err_custom;
      end if;
    end if;
    --户籍地址外省
    if v_vc_hkqcs = '1' then
      if v_vc_wshkshendm is null then
        v_err := '外省户籍地址省不能为空!';
        raise err_custom;
      end if;
      if v_vc_wshksdm is null then
        v_err := '外省户籍地址市不能为空!';
        raise err_custom;
      end if;
      if v_vc_wshkqxdm is null then
        v_err := '外省户籍地址区县不能为空!';
        raise err_custom;
      end if;
      if v_vc_wshkjddm is null then
        v_err := '外省户籍地址街道不能为空!';
        raise err_custom;
      end if;
    end if;
    --居住地址
    if v_vc_jzqcs is null then
      v_err := '居住地址省不能为空!';
      raise err_custom;
    end if;
    --居住地址浙江
    if v_vc_jzqcs = '0' then
      if v_vc_jzsdm is null then
        v_err := '居住地址市不能为空!';
        raise err_custom;
      end if;
      if v_vc_jzqxdm is null then
        v_err := '居住地址区县不能为空!';
        raise err_custom;
      end if;
      if v_vc_jzjddm is null then
        v_err := '居住地址街道不能为空!';
        raise err_custom;
      end if;
      if substr(v_vc_jzsdm, 1, 4) <> substr(v_vc_jzqxdm, 1, 4) or
         substr(v_vc_jzsdm, 1, 4) <> substr(v_vc_jzjddm, 1, 4) then
        v_err := '居住地址区划不匹配!';
        raise err_custom;
      end if;
    end if;
    --居住地址外省
    if v_vc_jzqcs = '1' then
      if v_vc_wsjzshendm is null then
        v_err := '外省居住地址省不能为空!';
        raise err_custom;
      end if;
      if v_vc_wsjzsdm is null then
        v_err := '外省居住地址市不能为空!';
        raise err_custom;
      end if;
      if v_vc_wsjzqxdm is null then
        v_err := '外省居住地址区县不能为空!';
        raise err_custom;
      end if;
      if v_vc_wsjzjddm is null then
        v_err := '外省居住地址街道不能为空!';
        raise err_custom;
      end if;
    end if;
    if v_vc_whcd is null then
      v_err := '文化程度不能为空!';
      raise err_custom;
    end if;
    if v_vc_zy is null then
      v_err := '个人身份不能为空!';
      raise err_custom;
    end if;
    if v_dt_swrq is null then
      v_err := '死亡日期不能为空!';
      raise err_custom;
    end if;
    if v_vc_swdd is null then
      v_err := '死亡地点不能为空!';
      raise err_custom;
    end if;
  
    if v_vc_azjswjb1 is null then
      v_err := 'a直接导致死亡的疾病名不能为空!';
      raise err_custom;
    end if;
    if v_nb_azjswjbicd is null then
      v_err := 'a直接导致死亡的疾病ICD10编码不能为空!';
      raise err_custom;
    end if;
    if v_vc_azjswjb is null then
      v_err := 'a直接导致死亡的疾病的疾病诊断不能为空!';
      raise err_custom;
    end if;
    if v_vc_afbdswsjjg is null then
      v_err := 'a发病到死亡的时间间隔不能为空!';
      raise err_custom;
    end if;
    if v_vc_sqzgzddw is null then
      v_err := '最高诊断单位不能为空!';
      raise err_custom;
    end if;
    if v_vc_zdyj is null then
      v_err := '最高诊断依据不能为空!';
      raise err_custom;
    end if;
    if v_vc_ysqm is null then
      v_err := '医师签名不能为空!';
      raise err_custom;
    end if;
    if v_dt_dcrq is null then
      v_err := '填报日期不能为空!';
      raise err_custom;
    end if;
    if v_vc_jkdw is null then
      v_err := '报卡单位医院不能为空!';
      raise err_custom;
    end if;
    if v_vc_hkhs = '2' and v_vc_whsyy is null then
      v_err := '未核实原因不能为空!';
      raise err_custom;
    end if;
    --查询报卡相关信息
    begin
      select vc_shbz, vc_sdqr, vc_hkhs, vc_hkqxdm, vc_hkjddm, vc_gldwdm
        into v_vc_shbz,
             v_vc_sdqr,
             v_vc_hkhs_bgq,
             v_vc_hkqxdm_bgq,
             v_vc_hkjddm_bgq,
             v_vc_gldwdm
        from zjmb_sw_bgk
       where vc_bgkid = v_vc_bgkid
         and vc_scbz = '2';
    exception
      when no_data_found then
        v_err := 'id[' || v_vc_bgkid || ']未获取到有效报告卡信息!';
        raise err_custom;
    end;
    --户口核实
    if v_vc_hkhs_bgq is not null then
      v_err := '已做户口核实操作,无需初访!';
      raise err_custom;
    end if;
    --审核不通过
    if v_vc_shbz <> '3' then
      v_err := '当前报告状态不为区县审核通过，不能做初访!';
      raise err_custom;
    end if;
    if v_czyjgjb = '4' then
      --修改了户籍地址
      if v_vc_hkqxdm_bgq <> v_vc_hkqxdm or v_vc_hkjddm_bgq <> v_vc_hkjddm then
        --审核状态改为医院通过
        v_vc_shbz := '1';
        --属地确认标志
        select count(1), wm_concat(a.code)
          into v_count, v_vc_gldwdm
          from organ_node a
         where a.removed = 0
           and a.description like '%' || v_vc_hkjddm || '%';
        if v_count = 1 then
          --确定属地
          v_vc_sdqr := '1';
        else
          v_vc_gldwdm := '';
          v_vc_sdqr   := '0';
        end if;
        if v_vc_hkqcs = '1' then
          --2.外省户籍数据（vc_hkqcs=1)，管理单位取报告卡单位前6位（vc_gldwdm=substr(vc_jkdw,1,6)||'00')
          v_vc_sdqr   := '1';
          v_vc_gldwdm := substr(v_czyjgdm, 1, 6) || '00';
        end if;
        --更新报告卡属地确认
        update zjmb_sw_bgk a
           set a.vc_sdqr = v_vc_sdqr, a.vc_gldwdm = v_vc_gldwdm
        where a.vc_bgkid = v_vc_bgkid;
      end if;
    else
      v_err := '当前机构无修改权限!';
      raise err_custom;
    end if;
    --更新报告卡信息
    update zjmb_sw_bgk
       set vc_wshkqxdm    = v_vc_wshkqxdm,
           vc_wshkjddm    = v_vc_wshkjddm,
           vc_wshkjw      = v_vc_wshkjw,
           vc_gjhdq       = v_vc_gjhdq,
           vc_wshkshendm  = v_vc_wshkshendm,
           vc_jzqcs       = v_vc_jzqcs,
           vc_jzsdm       = v_vc_jzsdm,
           vc_jzqxdm      = v_vc_jzqxdm,
           vc_jzjddm      = v_vc_jzjddm,
           vc_jzjw        = v_vc_jzjw,
           vc_wsjzshendm  = v_vc_wsjzshendm,
           vc_wsjzsdm     = v_vc_wsjzsdm,
           vc_wsjzqxdm    = v_vc_wsjzqxdm,
           vc_wsjzjddm    = v_vc_wsjzjddm,
           vc_wsjzjw      = v_vc_wsjzjw,
           dt_swrq        = v_dt_swrq,
           vc_sznl        = v_vc_sznl,
           vc_sfzhm       = v_vc_sfzhm,
           vc_swdd        = v_vc_swdd,
           vc_sqzgzddw    = v_vc_sqzgzddw,
           vc_zdyj        = v_vc_zdyj,
           vc_gbsy        = v_vc_gbsy,
           vc_jsxm        = v_vc_jsxm,
           vc_jslxdh      = v_vc_jslxdh,
           vc_jsdz        = v_vc_jsdz,
           vc_zyh         = v_vc_zyh,
           vc_azjswjb     = v_vc_azjswjb,
           nb_azjswjbicd  = v_nb_azjswjbicd,
           vc_afbdswsjjg  = v_vc_afbdswsjjg,
           vc_afbdswsjdw  = v_vc_afbdswsjdw,
           vc_bzjswjb     = v_vc_bzjswjb,
           nb_bzjswjbidc  = v_nb_bzjswjbidc,
           vc_bfbdswsjjg  = v_vc_bfbdswsjjg,
           vc_bfbdswsjdw  = v_vc_bfbdswsjdw,
           vc_czjswjb     = v_vc_czjswjb,
           nb_czjswjbicd  = v_nb_czjswjbicd,
           vc_cfbdswsjjg  = v_vc_cfbdswsjjg,
           vc_cfbdswsjdw  = v_vc_cfbdswsjdw,
           vc_dzjswjb     = v_vc_dzjswjb,
           nb_dajswjbicd  = v_nb_dajswjbicd,
           vc_dfbdswsjjg  = v_vc_dfbdswsjjg,
           vc_dfbdswsjdw  = v_vc_dfbdswsjdw,
           vc_szsqbljzztz = v_vc_szsqbljzztz,
           vc_lxdzhgzdw   = v_vc_lxdzhgzdw,
           dt_dcrq        = v_dt_dcrq,
           vc_hksdm       = v_vc_hksdm,
           vc_hkqxdm      = v_vc_hkqxdm,
           vc_hkjddm      = v_vc_hkjddm,
           dt_csrq        = v_dt_csrq,
           vc_ysqm        = v_vc_ysqm,
           vc_hkhs        = v_vc_hkhs,
           vc_whsyy       = v_vc_whsyy,
           vc_hkjw        = v_vc_hkjw,
           fenleitj       = v_fenleitj,
           vc_ezjswjb     = v_vc_ezjswjb,
           nb_eajswjbicd  = v_nb_eajswjbicd,
           vc_efbdswsjjg  = v_vc_efbdswsjjg,
           vc_efbdswsjdw  = v_vc_efbdswsjdw,
           vc_fzjswjb     = v_vc_fzjswjb,
           nb_fajswjbicd  = v_nb_fajswjbicd,
           vc_ffbdswsjjg  = v_vc_ffbdswsjjg,
           vc_ffbdswsjdw  = v_vc_ffbdswsjdw,
           vc_gzjswjb     = v_vc_gzjswjb,
           nb_gajswjbicd  = v_nb_gajswjbicd,
           vc_gfbdswsjjg  = v_vc_gfbdswsjjg,
           vc_gfbdswsjdw  = v_vc_gfbdswsjdw,
           vc_hkqcs       = v_vc_hkqcs,
           fenleitjmc     = v_fenleitjmc,
           vc_azjswjb1    = v_vc_azjswjb1,
           vc_bzjswjb1    = v_vc_bzjswjb1,
           vc_czjswjb1    = v_vc_czjswjb1,
           vc_dzjswjb1    = v_vc_dzjswjb1,
           vc_ezjswjb1    = v_vc_ezjswjb1,
           vc_fzjswjb1    = v_vc_fzjswjb1,
           vc_gzjswjb1    = v_vc_gzjswjb1,
           vc_zjlx        = v_vc_zjlx,
           vc_rsqk        = v_vc_rsqk,
           vc_wshksdm     = v_vc_wshksdm,
           vc_xm          = v_vc_xm,
           vc_xb          = v_vc_xb,
           vc_mz          = v_vc_mz,
           vc_zy          = v_vc_zy,
           vc_hyzk        = v_vc_hyzk,
           vc_whcd        = v_vc_whcd,
           vc_shbz        = v_vc_shbz,
           vc_xgyh        = v_czyyhid,
           dt_shsj = case
                       when vc_shbz = '3' and dt_shsj is null then
                        v_sysdate
                       when vc_shbz = '3' and dt_shsj is not null then
                        dt_shsj
                       else
                        null
                     end,
           dt_xgsj        = v_sysdate,
           dt_qxzssj = case
                         when vc_shbz = '3' and dt_shsj is null then
                          null
                         when vc_shbz = '3' and dt_shsj is not null then
                          v_sysdate
                         else
                          null
                       end
     where vc_bgkid = v_vc_bgkid;
    --添加操作日志
    v_json_yw_log := Json_ext.get_json(v_json_data, 'ywjllog');
    if v_json_yw_log is not null then
      v_json_yw_log.put('bgkid', v_vc_bgkid);
      v_json_yw_log.put('bgklx', '05');
      v_json_yw_log.put('ywjlid', v_vc_bgkid);
      v_json_yw_log.put('gnmk', '04');
      v_json_yw_log.put('gnmc', '初访管理');
      v_json_yw_log.put('czlx', '01');
      pkg_zjmb_xtfz.prc_zjjk_yw_log_update(v_json_yw_log, v_err);
      if v_err is not null then
        raise err_custom;
      end if;
    end if;
    --返回
    v_Json_Return.put('id', v_vc_bgkid);
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_sw_bgk_cf;
  /*--------------------------------------------------------------------------
  || 功能描述 ：死因审核
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_sw_bgk_sh(Data_In    In Clob, --入参
                          result_out OUT VARCHAR2) --返回
   is
    v_json_data   json;
    v_json_return json := json();
    v_json_yw_log json;
    v_ywjl_czlx   varchar2(3);
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
    --公共变量
    v_sysdate    date;
    v_czyjgdm    varchar2(50);
    v_czyjgjb    varchar2(3);
    v_shbz       zjmb_sw_bgk.vc_shbz%TYPE; --审核状态
    v_shbz_table zjmb_sw_bgk.vc_shbz%TYPE; --审核状态
    v_bkid       zjmb_sw_bgk.vc_bgkid%type;
    v_shwtgyy    zjmb_sw_bgk.vc_shwtgyy%TYPE; --区县审核未通过原因其他
    v_shwtgyy1   zjmb_sw_bgk.vc_shwtgyy1%TYPE; --区县审核未通过原因编号
    v_vc_hkqcs   zjmb_sw_bgk.vc_hkqcs%type;
    v_cjjgdm     varchar2(100);
    v_gljgdm     varchar2(100);
  BEGIN
    json_data(data_in, 'zjmb_sw_bgk审核', v_json_data);
    v_sysdate  := sysdate;
    v_czyjgdm  := Json_Str(v_Json_Data, 'czyjgdm');
    v_bkid     := Json_Str(v_Json_Data, 'vc_bgkid');
    v_shbz     := Json_Str(v_Json_Data, 'vc_shbz');
    v_shwtgyy  := Json_Str(v_Json_Data, 'vc_shwtgyy');
    v_shwtgyy1 := Json_Str(v_Json_Data, 'vc_shwtgyy1');
    --获取机构级别
    --select fun_getczyjgjb(v_czyjgdm) into v_czyjgjb from dual;
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    --获取报卡状态
    begin
      select vc_shbz, vc_hkqcs, a.vc_gldwdm, a.vc_cjdwdm
        into v_shbz_table, v_vc_hkqcs, v_gljgdm, v_cjjgdm
        from zjmb_sw_bgk a
       where vc_bgkid = v_bkid
         and vc_scbz = '2'
         and vc_shbz = '1';
    exception
      when no_data_found then
        v_err := 'id[' || v_bkid || ']未获取到有效的待审核报告卡信息!';
        raise err_custom;
    end;
    if v_czyjgjb <> '3' then
      --非区县
      v_err := '当前机构无审核权限!';
      raise err_custom;
    end if;
    --校验管理单位审核权限
    if v_czyjgjb = '3' then
      if substr(v_gljgdm, 1, 6) <> substr(v_czyjgdm, 1, 6) then
        v_err := '非管理单位无此操作权限!';
        raise err_custom;
      end if;
    end if;
    --v_shbz_table := '1';
    if v_shbz_table <> '1' then
      v_err := '报卡当前状态不为区县待审核!';
      raise err_custom;
    end if;
    --校验审核权限
    if v_vc_hkqcs = '0' then
      --浙江省
      if substr(v_gljgdm, 1, 6) <> substr(v_czyjgdm, 1, 6) then
        v_err := '省内卡只能审核当前管理机构内的卡片!';
        raise err_custom;
      end if;
    else
      --外省
      --浙江省
      if substr(v_cjjgdm, 1, 6) <> substr(v_czyjgdm, 1, 6) then
        v_err := '省外卡只能审核当前创建机构内的卡片!';
        raise err_custom;
      end if;
    end if;
    --判断审核状态
    if v_shbz = '3' then
      v_shwtgyy := '';
    elsif v_shbz = '4' then
      if v_shwtgyy1 is NULL then
        v_err := '审核不通过原因不能为空';
        raise err_custom;
      end if;
    else
      v_err := '传入审核状态[' || v_shbz || ']不正确!';
      raise err_custom;
    end if;
    --更新审核标志
    update zjmb_sw_bgk
       set vc_shbz     = v_shbz,
           vc_shwtgyy  = v_shwtgyy,
           vc_shwtgyy1 = v_shwtgyy1,
           dt_shsj     = v_sysdate,
           dt_xgsj     = sysdate,
           vc_hkhs = case
                           when v_shbz = '4' then
                            null
                           else
                            vc_hkhs
                         end
     where vc_bgkid = v_bkid;
    --添加操作日志
    v_json_yw_log := Json_ext.get_json(v_json_data, 'ywjllog');
    if v_json_yw_log is not null then
      v_json_yw_log.put('bgkid', v_bkid);
      v_json_yw_log.put('bgklx', '05');
      v_json_yw_log.put('ywjlid', v_bkid);
      v_json_yw_log.put('gnmk', '01');
      v_json_yw_log.put('gnmc', '报卡管理');
      v_json_yw_log.put('czlx', '03');
      pkg_zjmb_xtfz.prc_zjjk_yw_log_update(v_json_yw_log, v_err);
      if v_err is not null then
        raise err_custom;
      end if;
    end if;
    v_Json_Return.put('id', v_bkid);
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_sw_bgk_sh;
  /*--------------------------------------------------------------------------
  || 功能描述 ：死因删除
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_sw_bgk_sc(Data_In    In Clob, --入参
                          result_out OUT VARCHAR2) --返回
   is
    v_json_data   json;
    v_json_return json := json();
    v_json_yw_log json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
    --公共变量
    v_sysdate    date;
    v_czyjgdm    varchar2(50);
    v_czyjgjb    varchar2(3);
    v_shbz       zjmb_sw_bgk.vc_shbz%TYPE; --审核状态
    v_shbz_table zjmb_sw_bgk.vc_shbz%TYPE; --审核状态
    v_bkid       zjmb_sw_bgk.vc_bgkid%type;
    v_vc_hkhs    zjmb_sw_bgk.vc_hkhs%type;
    v_vc_scbz    zjmb_sw_bgk.vc_scbz%type;
    v_gljgdm     zjmb_sw_bgk.vc_gldwdm%type;
  BEGIN
    json_data(data_in, 'zjmb_sw_bgk状态更新', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    --获取机构级别
    --select fun_getczyjgjb(v_czyjgdm) into v_czyjgjb from dual;
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    v_bkid    := Json_Str(v_Json_Data, 'vc_bgkid');
    --获取报卡状态
    begin
      select vc_hkhs, vc_scbz, vc_gldwdm
        into v_vc_hkhs, v_vc_scbz, v_gljgdm
        from zjmb_sw_bgk
       where vc_bgkid = v_bkid
         and vc_scbz = '2';
    exception
      when no_data_found then
        v_err := 'id[' || v_bkid || ']未获取到有效报告卡信息!';
        raise err_custom;
    end;
    --校验管理单位审核权限
    if v_czyjgjb = '3' then
      if substr(v_gljgdm, 1, 6) <> substr(v_czyjgdm, 1, 6) then
        v_err := '非管理单位无此操作权限!';
        raise err_custom;
      end if;
    end if;
    if v_czyjgjb = '4' then
      --医院社区
      if v_vc_hkhs is not null then
        v_err := '该报卡已做户口核实，当前机构无权删除!';
        raise err_custom;
      end if;
    elsif v_czyjgjb <> '3' then
      --非区县
      v_err := '当前机构无删除权限!';
      raise err_custom;
    end if;
    --更新删除标志
    update zjmb_sw_bgk
       set vc_scbz = '1', vc_bgklb = '5', dt_xgsj = sysdate
     where vc_bgkid = v_bkid;
    --添加操作日志
    v_json_yw_log := Json_ext.get_json(v_json_data, 'ywjllog');
    if v_json_yw_log is not null then
      v_json_yw_log.put('bgkid', v_bkid);
      v_json_yw_log.put('bgklx', '05');
      v_json_yw_log.put('ywjlid', v_bkid);
      v_json_yw_log.put('gnmk', '01');
      v_json_yw_log.put('gnmc', '报卡管理');
      v_json_yw_log.put('czlx', '04');
      pkg_zjmb_xtfz.prc_zjjk_yw_log_update(v_json_yw_log, v_err);
      if v_err is not null then
        raise err_custom;
      end if;
    end if;
    v_Json_Return.put('id', v_bkid);
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_sw_bgk_sc;
  /*--------------------------------------------------------------------------
  || 功能描述 ：死因属地确认
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_sw_bgk_sdqr(Data_In    In Clob, --入参
                            result_out OUT VARCHAR2) --返回
   is
    v_json_data   json;
    v_json_return json := json();
    v_json_yw_log json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
    --公共变量
    v_sysdate date;
    v_czyjgdm varchar2(50);
    v_czyjgjb varchar2(3);
    v_bkid    zjmb_sw_bgk.vc_bgkid%type;
    v_gldwdm  zjmb_sw_bgk.vc_gldwdm%type;
    v_count   number;
  BEGIN
    json_data(data_in, 'zjmb_sw_bgk属地确认', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_bkid    := Json_Str(v_Json_Data, 'vc_bgkid');
    v_gldwdm  := Json_Str(v_Json_Data, 'vc_gldwdm');
    --获取机构级别
    --select fun_getczyjgjb(v_czyjgdm) into v_czyjgjb from dual;
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    if v_czyjgjb not in ('3', '4') then
      v_err := '当前机构无属地确认权限!';
      raise err_custom;
    end if;
    if v_gldwdm is null then
      v_err := '管理单位不能为空!';
      raise err_custom;
    end if;
    --判断管理单位与户籍街道是否匹配
    select count(1)
      into v_count
      from zjmb_sw_bgk a, organ_node c
     where c.description like '%' || a.vc_hkjddm || '%'
       and c.code = v_gldwdm
       and c.removed = 0
       and a.vc_bgkid = v_bkid;
    if v_count <> 1 then
      v_err := '管理单位与户籍街道不匹配!';
      raise err_custom;
    end if;
    --修改管理单位
    update zjmb_sw_bgk a
       set a.vc_gldwdm = v_gldwdm, a.vc_sdqr = '1', dt_xgsj = sysdate
     where a.vc_scbz = '2'
       and a.vc_shbz = '3'
       and a.vc_bgkid = v_bkid
       and a.vc_sdqr = '0';
    if sql%rowcount <> 1 then
      v_err := 'id[' || v_bkid || ']未获取到有效报的待属地确认的告卡信息!';
      raise err_custom;
    end if;
    --添加操作日志
    v_json_yw_log := Json_ext.get_json(v_json_data, 'ywjllog');
    if v_json_yw_log is not null then
      v_json_yw_log.put('bgkid', v_bkid);
      v_json_yw_log.put('bgklx', '05');
      v_json_yw_log.put('ywjlid', v_bkid);
      v_json_yw_log.put('gnmk', '02');
      v_json_yw_log.put('gnmc', '属地确认');
      v_json_yw_log.put('czlx', '01');
      pkg_zjmb_xtfz.prc_zjjk_yw_log_update(v_json_yw_log, v_err);
      if v_err is not null then
        raise err_custom;
      end if;
    end if;
    v_Json_Return.put('id', v_bkid);
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_sw_bgk_sdqr;
  /*--------------------------------------------------------------------------
  || 功能描述 ：死因查重管理
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_sw_bgk_ccgl(Data_In    In Clob, --入参
                            result_out OUT VARCHAR2) --返回
   is
    v_json_data   json;
    v_json_return json := json();
    v_json_yw_log json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
  
    --公共变量
    v_sysdate       date;
    v_czyjgdm       varchar2(50);
    v_czyjgjb       varchar2(3);
    v_json_list_yx  json_List; --有效卡
    v_json_list_cf  json_List; --重复卡
    v_json_temp_bgk Json;
    v_vc_bgkid      zjmb_sw_bgk.vc_bgkid%type;
  
  BEGIN
    json_data(data_in, 'zjmb_sw_bgk查重', v_json_data);
    v_sysdate      := sysdate;
    v_czyjgdm      := Json_Str(v_Json_Data, 'czyjgdm'); --操作员机构代码
    v_czyjgjb      := Json_Str(v_Json_Data, 'czyjgjb'); --获取机构级别
    v_Json_List_yx := Json_Ext.Get_Json_List(v_Json_Data, 'yx_arr'); --有效卡
    v_Json_List_cf := Json_Ext.Get_Json_List(v_Json_Data, 'cf_arr'); --重复卡
    if v_czyjgdm is null then
      v_err := '未获取到操作员信息!';
      raise err_custom;
    end if;
  
    --处理有效卡
    if v_json_list_yx.count > 0 then
      for i in 1 .. v_json_list_yx.count loop
        v_json_temp_bgk := Json(v_json_list_yx.Get(i));
        v_vc_bgkid      := Json_Str(v_json_temp_bgk, 'vc_bgkid');
        update zjmb_sw_bgk a
           set a.vc_ccid = v_czyjgdm, dt_xgsj = sysdate
         where a.vc_bgkid = v_vc_bgkid;
      end loop;
    else
      v_err := '未获取到有效卡!';
      raise err_custom;
    end if;
    --处理重复卡
    if v_json_list_cf.count > 0 then
      for i in 1 .. v_json_list_cf.count loop
        v_json_temp_bgk := Json(v_json_list_cf.Get(i));
        v_vc_bgkid      := Json_Str(v_json_temp_bgk, 'vc_bgkid');
        update zjmb_sw_bgk a
           set a.vc_ccid  = v_czyjgdm,
               a.vc_bgklb = '4',
               a.vc_ckbz  = '1',
               dt_xgsj    = sysdate
         where a.vc_bgkid = v_vc_bgkid;
      end loop;
    else
      --v_err := '未获取到重复卡!';
      --raise err_custom;
      --允许全部为有效卡
      null;
    end if;
    --添加操作日志
    v_json_yw_log := Json_ext.get_json(v_json_data, 'ywjllog');
    if v_json_yw_log is not null then
      v_json_yw_log.put('bgkid', v_vc_bgkid);
      v_json_yw_log.put('bgklx', '05');
      v_json_yw_log.put('ywjlid', v_vc_bgkid);
      v_json_yw_log.put('gnmk', '01');
      v_json_yw_log.put('gnmc', '报卡管理');
      v_json_yw_log.put('czlx', '01');
      pkg_zjmb_xtfz.prc_zjjk_yw_log_update(v_json_yw_log, v_err);
      if v_err is not null then
        raise err_custom;
      end if;
    end if;
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_sw_bgk_ccgl;
  /*--------------------------------------------------------------------------
  || 功能描述 ：死亡新增及修改(无名)
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_sw_bgk_wm_update(Data_In    In Clob, --入参
                                 result_out OUT VARCHAR2) --返回
   is
    v_json_data   json;
    v_json_return json := json();
    v_json_yw_log json;
    v_ywjl_czlx   varchar2(3);
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
  
    --公共变量
    v_sysdate date;
    v_czyjgjb varchar2(3);
    v_czyjgdm varchar2(50);
    v_czyyhid varchar2(50);
    v_count   number;
  
    v_vc_xm          zjmb_sw_bgk_wm.vc_xm%TYPE; --姓名
    v_vc_xb          zjmb_sw_bgk_wm.vc_xb%TYPE; --性别
    v_vc_mz          zjmb_sw_bgk_wm.vc_mz%TYPE; --民族
    v_vc_gjhdq       zjmb_sw_bgk_wm.vc_gjhdq%TYPE; --国家或地区
    v_vc_zjlx        zjmb_sw_bgk_wm.vc_zjlx%TYPE; --证件类型
    v_vc_sfzhm       zjmb_sw_bgk_wm.vc_sfzhm%TYPE; --身份证号码
    v_vc_hyzk        zjmb_sw_bgk_wm.vc_hyzk%TYPE; --婚姻状况
    v_vc_whcd        zjmb_sw_bgk_wm.vc_whcd%TYPE; --文化程度
    v_vc_hkqcs       zjmb_sw_bgk_wm.vc_hkqcs%TYPE; --户口省代码
    v_vc_hksdm       zjmb_sw_bgk_wm.vc_hksdm%TYPE; --户口市代码
    v_vc_hkqxdm      zjmb_sw_bgk_wm.vc_hkqxdm%TYPE; --户口区县代码
    v_vc_hkjddm      zjmb_sw_bgk_wm.vc_hkjddm%TYPE; --户口街道代码
    v_vc_hkjw        zjmb_sw_bgk_wm.vc_hkjw%TYPE; --户口居委
    v_vc_wshkshendm  zjmb_sw_bgk_wm.vc_wshkshendm%TYPE; --外省户口省代码
    v_vc_wshksdm     zjmb_sw_bgk_wm.vc_wshksdm%TYPE; --外省户口市代码
    v_vc_wshkqxdm    zjmb_sw_bgk_wm.vc_wshkqxdm%TYPE; --外省户口区县代码
    v_vc_wshkjddm    zjmb_sw_bgk_wm.vc_wshkjddm%TYPE; --外省户口街道代码
    v_vc_wshkjw      zjmb_sw_bgk_wm.vc_wshkjw%TYPE; --外省户口居委
    v_vc_jzqcs       zjmb_sw_bgk_wm.vc_jzqcs%TYPE; --居住省代码
    v_vc_jzsdm       zjmb_sw_bgk_wm.vc_jzsdm%TYPE; --居住市代码
    v_vc_jzqxdm      zjmb_sw_bgk_wm.vc_jzqxdm%TYPE; --居住区县代码
    v_vc_jzjddm      zjmb_sw_bgk_wm.vc_jzjddm%TYPE; --居住街道代码
    v_vc_jzjw        zjmb_sw_bgk_wm.vc_jzjw%TYPE; --居住居委
    v_vc_wsjzshendm  zjmb_sw_bgk_wm.vc_wsjzshendm%TYPE; --外省居住省代码
    v_vc_wsjzsdm     zjmb_sw_bgk_wm.vc_wsjzsdm%TYPE; --外省居住市代码
    v_vc_wsjzqxdm    zjmb_sw_bgk_wm.vc_wsjzqxdm%TYPE; --外省居住区县代码
    v_vc_wsjzjddm    zjmb_sw_bgk_wm.vc_wsjzjddm%TYPE; --外省居住街道代码
    v_vc_wsjzjw      zjmb_sw_bgk_wm.vc_wsjzjw%TYPE; --外省居住居委
    v_vc_zy          zjmb_sw_bgk_wm.vc_zy%TYPE; --职业
    v_vc_lxdzhgzdw   zjmb_sw_bgk_wm.vc_lxdzhgzdw%TYPE; --联系地址或工作单位
    v_dt_csrq        zjmb_sw_bgk_wm.dt_csrq%TYPE; --出生日期
    v_dt_swrq        zjmb_sw_bgk_wm.dt_swrq%TYPE; --死亡日期
    v_vc_jsxm        zjmb_sw_bgk_wm.vc_jsxm%TYPE; --家属姓名
    v_vc_jslxdh      zjmb_sw_bgk_wm.vc_jslxdh%TYPE; --家属联系电话
    v_vc_jsdz        zjmb_sw_bgk_wm.vc_jsdz%TYPE; --家属地址或工作单位
    v_vc_sznl        zjmb_sw_bgk_wm.vc_sznl%TYPE; --实足年龄
    v_vc_swdd        zjmb_sw_bgk_wm.vc_swdd%TYPE; --死亡地点
    v_vc_rsqk        zjmb_sw_bgk_wm.vc_rsqk%TYPE; --妊娠情况
    v_vc_azjswjb1    zjmb_sw_bgk_wm.vc_azjswjb1%TYPE; --
    v_vc_bzjswjb1    zjmb_sw_bgk_wm.vc_bzjswjb1%TYPE; --
    v_vc_czjswjb1    zjmb_sw_bgk_wm.vc_czjswjb1%TYPE; --
    v_vc_dzjswjb1    zjmb_sw_bgk_wm.vc_dzjswjb1%TYPE; --
    v_vc_ezjswjb1    zjmb_sw_bgk_wm.vc_ezjswjb1%TYPE; --
    v_vc_fzjswjb1    zjmb_sw_bgk_wm.vc_fzjswjb1%TYPE; --
    v_vc_gzjswjb1    zjmb_sw_bgk_wm.vc_gzjswjb1%TYPE; --
    v_vc_azjswjb     zjmb_sw_bgk_wm.vc_azjswjb%TYPE; --a直接导致死亡的疾病
    v_nb_azjswjbicd  zjmb_sw_bgk_wm.nb_azjswjbicd%TYPE; --a直接导致死亡的疾病ICD10编码
    v_vc_afbdswsjjg  zjmb_sw_bgk_wm.vc_afbdswsjjg%TYPE; --a发病到死亡的时间间隔
    v_vc_afbdswsjdw  zjmb_sw_bgk_wm.vc_afbdswsjdw%TYPE; --a发病到死亡的时间间隔单位
    v_vc_bzjswjb     zjmb_sw_bgk_wm.vc_bzjswjb%TYPE; --b直接导致死亡的疾病
    v_nb_bzjswjbidc  zjmb_sw_bgk_wm.nb_bzjswjbidc%TYPE; --b直接导致死亡的疾病ICD10编码
    v_vc_bfbdswsjjg  zjmb_sw_bgk_wm.vc_bfbdswsjjg%TYPE; --b发病到死亡的时间间隔
    v_vc_bfbdswsjdw  zjmb_sw_bgk_wm.vc_bfbdswsjdw%TYPE; --b发病到死亡的时间间隔单位
    v_vc_czjswjb     zjmb_sw_bgk_wm.vc_czjswjb%TYPE; --c直接导致死亡的疾病
    v_nb_czjswjbicd  zjmb_sw_bgk_wm.nb_czjswjbicd%TYPE; --c直接导致死亡的疾病ICD10编码
    v_vc_cfbdswsjjg  zjmb_sw_bgk_wm.vc_cfbdswsjjg%TYPE; --c发病到死亡的时间间隔
    v_vc_cfbdswsjdw  zjmb_sw_bgk_wm.vc_cfbdswsjdw%TYPE; --c发病到死亡的时间间隔单位
    v_vc_dzjswjb     zjmb_sw_bgk_wm.vc_dzjswjb%TYPE; --d直接导致死亡的疾病
    v_nb_dajswjbicd  zjmb_sw_bgk_wm.nb_dajswjbicd%TYPE; --d直接导致死亡的疾病ICD10编码
    v_vc_dfbdswsjjg  zjmb_sw_bgk_wm.vc_dfbdswsjjg%TYPE; --d发病到死亡的时间间隔
    v_vc_dfbdswsjdw  zjmb_sw_bgk_wm.vc_dfbdswsjdw%TYPE; --d发病到死亡的时间间隔单位
    v_vc_ezjswjb     zjmb_sw_bgk_wm.vc_ezjswjb%TYPE; --e直接导致死亡的疾病
    v_nb_eajswjbicd  zjmb_sw_bgk_wm.nb_eajswjbicd%TYPE; --e直接导致死亡的疾病ICD10编码
    v_vc_efbdswsjjg  zjmb_sw_bgk_wm.vc_efbdswsjjg%TYPE; --e发病到死亡的时间间隔
    v_vc_efbdswsjdw  zjmb_sw_bgk_wm.vc_efbdswsjdw%TYPE; --e发病到死亡的时间间隔单位
    v_vc_fzjswjb     zjmb_sw_bgk_wm.vc_fzjswjb%TYPE; --f直接导致死亡的疾病
    v_nb_fajswjbicd  zjmb_sw_bgk_wm.nb_fajswjbicd%TYPE; --f直接导致死亡的疾病ICD10编码
    v_vc_ffbdswsjjg  zjmb_sw_bgk_wm.vc_ffbdswsjjg%TYPE; --f发病到死亡的时间间隔
    v_vc_ffbdswsjdw  zjmb_sw_bgk_wm.vc_ffbdswsjdw%TYPE; --f发病到死亡的时间间隔单位
    v_vc_gzjswjb     zjmb_sw_bgk_wm.vc_gzjswjb%TYPE; --g直接导致死亡的疾病
    v_nb_gajswjbicd  zjmb_sw_bgk_wm.nb_gajswjbicd%TYPE; --g直接导致死亡的疾病ICD10编码
    v_vc_gfbdswsjjg  zjmb_sw_bgk_wm.vc_gfbdswsjjg%TYPE; --g发病到死亡的时间间隔
    v_vc_gfbdswsjdw  zjmb_sw_bgk_wm.vc_gfbdswsjdw%TYPE; --g发病到死亡的时间间隔单位
    v_vc_sqzgzddw    zjmb_sw_bgk_wm.vc_sqzgzddw%TYPE; --生前最高诊断单位
    v_vc_zdyj        zjmb_sw_bgk_wm.vc_zdyj%TYPE; --诊断依据
    v_vc_zyh         zjmb_sw_bgk_wm.vc_zyh%TYPE; --住院号
    v_vc_ysqm        zjmb_sw_bgk_wm.vc_ysqm%TYPE; --医生签名
    v_vc_gbsy        zjmb_sw_bgk_wm.vc_gbsy%TYPE; --根本死因
    v_nb_gbsybm      zjmb_sw_bgk.nb_gbsybm%TYPE; -- 根本死因名称
    v_fenleitj       zjmb_sw_bgk_wm.fenleitj%TYPE; --分类统计号
    v_fenleitjmc     zjmb_sw_bgk_wm.fenleitjmc%TYPE; --分类统计号
    v_dt_dcrq        zjmb_sw_bgk_wm.dt_dcrq%TYPE; --调查日期
    v_vc_jkdw        zjmb_sw_bgk_wm.vc_jkdw%TYPE; --建卡医院
    v_vc_szsqbljzztz zjmb_sw_bgk_wm.vc_szsqbljzztz%TYPE; --死者生前病史及症状体征
    v_vc_hkhs        zjmb_sw_bgk_wm.vc_hkhs%TYPE; --户口核实
    v_vc_hkhs_bgq    zjmb_sw_bgk.vc_hkhs%TYPE; --户口核实变更前
    v_vc_whsyy       zjmb_sw_bgk_wm.vc_whsyy%TYPE; --未核实原因
    v_vc_bgkid       zjmb_sw_bgk_wm.vc_bgkid%TYPE; --报告卡id
    v_vc_gldwdm      zjmb_sw_bgk_wm.vc_gldwdm%TYPE; --管理单位
    v_vc_sdqr        zjmb_sw_bgk_wm.vc_sdqr%TYPE; --属地确认标志
    v_vc_shbz        zjmb_sw_bgk_wm.vc_shbz%TYPE; --审核标志
    v_vc_hkqxdm_bgq  zjmb_sw_bgk_wm.vc_hkqxdm%TYPE; --变更前区县代码
    v_vc_hkjddm_bgq  zjmb_sw_bgk_wm.vc_hkjddm%TYPE; --变更前街道代码
  
    v_ywrzid      zjjk_yw_log.id%TYPE; --业务日志id
    v_tab_bgk_old zjmb_sw_bgk_wm%rowtype; --死亡报告卡变更前
    v_tab_bgk_new zjmb_sw_bgk_wm%rowtype; --死亡报告卡变更后
  BEGIN
    json_data(data_in, 'zjmb_sw_bgk_wm新增或修改', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm'); --操作员机构代码
    v_czyyhid := Json_Str(v_Json_Data, 'v_czyyhid');
    --获取机构级别
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
  
    v_vc_bgkid       := Json_Str(v_Json_Data, 'vc_bgkid');
    v_vc_wshkqxdm    := Json_Str(v_Json_Data, 'vc_wshkqxdm');
    v_vc_wshkjddm    := Json_Str(v_Json_Data, 'vc_wshkjddm');
    v_vc_wshkjw      := Json_Str(v_Json_Data, 'vc_wshkjw');
    v_vc_gjhdq       := Json_Str(v_Json_Data, 'vc_gjhdq');
    v_vc_wshkshendm  := Json_Str(v_Json_Data, 'vc_wshkshendm');
    v_vc_jzqcs       := Json_Str(v_Json_Data, 'vc_jzqcs');
    v_vc_jzsdm       := Json_Str(v_Json_Data, 'vc_jzsdm');
    v_vc_jzqxdm      := Json_Str(v_Json_Data, 'vc_jzqxdm');
    v_vc_jzjddm      := Json_Str(v_Json_Data, 'vc_jzjddm');
    v_vc_jzjw        := Json_Str(v_Json_Data, 'vc_jzjw');
    v_vc_wsjzshendm  := Json_Str(v_Json_Data, 'vc_wsjzshendm');
    v_vc_wsjzsdm     := Json_Str(v_Json_Data, 'vc_wsjzsdm');
    v_vc_wsjzqxdm    := Json_Str(v_Json_Data, 'vc_wsjzqxdm');
    v_vc_wsjzjddm    := Json_Str(v_Json_Data, 'vc_wsjzjddm');
    v_vc_wsjzjw      := Json_Str(v_Json_Data, 'vc_wsjzjw');
    v_dt_swrq        := std(Json_Str(v_Json_Data, 'dt_swrq'), 0);
    v_vc_sznl        := Json_Str(v_Json_Data, 'vc_sznl');
    v_vc_sfzhm       := Json_Str(v_Json_Data, 'vc_sfzhm');
    v_vc_swdd        := Json_Str(v_Json_Data, 'vc_swdd');
    v_vc_sqzgzddw    := Json_Str(v_Json_Data, 'vc_sqzgzddw');
    v_vc_zdyj        := Json_Str(v_Json_Data, 'vc_zdyj');
    v_vc_gbsy        := Json_Str(v_Json_Data, 'vc_gbsy');
    v_vc_jsxm        := Json_Str(v_Json_Data, 'vc_jsxm');
    v_vc_jslxdh      := Json_Str(v_Json_Data, 'vc_jslxdh');
    v_vc_jsdz        := Json_Str(v_Json_Data, 'vc_jsdz');
    v_vc_zyh         := Json_Str(v_Json_Data, 'vc_zyh');
    v_vc_azjswjb     := Json_Str(v_Json_Data, 'vc_azjswjb');
    v_nb_azjswjbicd  := Json_Str(v_Json_Data, 'nb_azjswjbicd');
    v_vc_afbdswsjjg  := Json_Str(v_Json_Data, 'vc_afbdswsjjg');
    v_vc_afbdswsjdw  := Json_Str(v_Json_Data, 'vc_afbdswsjdw');
    v_vc_bzjswjb     := Json_Str(v_Json_Data, 'vc_bzjswjb');
    v_nb_bzjswjbidc  := Json_Str(v_Json_Data, 'nb_bzjswjbidc');
    v_vc_bfbdswsjjg  := Json_Str(v_Json_Data, 'vc_bfbdswsjjg');
    v_vc_bfbdswsjdw  := Json_Str(v_Json_Data, 'vc_bfbdswsjdw');
    v_vc_czjswjb     := Json_Str(v_Json_Data, 'vc_czjswjb');
    v_nb_czjswjbicd  := Json_Str(v_Json_Data, 'nb_czjswjbicd');
    v_vc_cfbdswsjjg  := Json_Str(v_Json_Data, 'vc_cfbdswsjjg');
    v_vc_cfbdswsjdw  := Json_Str(v_Json_Data, 'vc_cfbdswsjdw');
    v_vc_dzjswjb     := Json_Str(v_Json_Data, 'vc_dzjswjb');
    v_nb_dajswjbicd  := Json_Str(v_Json_Data, 'nb_dajswjbicd');
    v_vc_dfbdswsjjg  := Json_Str(v_Json_Data, 'vc_dfbdswsjjg');
    v_vc_dfbdswsjdw  := Json_Str(v_Json_Data, 'vc_dfbdswsjdw');
    v_vc_szsqbljzztz := Json_Str(v_Json_Data, 'vc_szsqbljzztz');
    v_vc_lxdzhgzdw   := Json_Str(v_Json_Data, 'vc_lxdzhgzdw');
    v_dt_dcrq        := std(Json_Str(v_Json_Data, 'dt_dcrq'), 0);
    v_vc_hksdm       := Json_Str(v_Json_Data, 'vc_hksdm');
    v_vc_hkqxdm      := Json_Str(v_Json_Data, 'vc_hkqxdm');
    v_vc_hkjddm      := Json_Str(v_Json_Data, 'vc_hkjddm');
    v_dt_csrq        := std(Json_Str(v_Json_Data, 'dt_csrq'), 0);
    v_vc_ysqm        := Json_Str(v_Json_Data, 'vc_ysqm');
    v_vc_hkhs        := Json_Str(v_Json_Data, 'vc_hkhs');
    v_vc_whsyy       := Json_Str(v_Json_Data, 'vc_whsyy');
    v_vc_hkjw        := Json_Str(v_Json_Data, 'vc_hkjw');
    v_fenleitj       := Json_Str(v_Json_Data, 'fenleitj');
    v_vc_ezjswjb     := Json_Str(v_Json_Data, 'vc_ezjswjb');
    v_nb_eajswjbicd  := Json_Str(v_Json_Data, 'nb_eajswjbicd');
    v_vc_efbdswsjjg  := Json_Str(v_Json_Data, 'vc_efbdswsjjg');
    v_vc_efbdswsjdw  := Json_Str(v_Json_Data, 'vc_efbdswsjdw');
    v_vc_fzjswjb     := Json_Str(v_Json_Data, 'vc_fzjswjb');
    v_nb_fajswjbicd  := Json_Str(v_Json_Data, 'nb_fajswjbicd');
    v_vc_ffbdswsjjg  := Json_Str(v_Json_Data, 'vc_ffbdswsjjg');
    v_vc_ffbdswsjdw  := Json_Str(v_Json_Data, 'vc_ffbdswsjdw');
    v_vc_gzjswjb     := Json_Str(v_Json_Data, 'vc_gzjswjb');
    v_nb_gajswjbicd  := Json_Str(v_Json_Data, 'nb_gajswjbicd');
    v_vc_gfbdswsjjg  := Json_Str(v_Json_Data, 'vc_gfbdswsjjg');
    v_vc_gfbdswsjdw  := Json_Str(v_Json_Data, 'vc_gfbdswsjdw');
    v_vc_hkqcs       := Json_Str(v_Json_Data, 'vc_hkqcs');
    v_fenleitjmc     := Json_Str(v_Json_Data, 'fenleitjmc');
    v_vc_azjswjb1    := Json_Str(v_Json_Data, 'vc_azjswjb1');
    v_vc_bzjswjb1    := Json_Str(v_Json_Data, 'vc_bzjswjb1');
    v_vc_czjswjb1    := Json_Str(v_Json_Data, 'vc_czjswjb1');
    v_vc_dzjswjb1    := Json_Str(v_Json_Data, 'vc_dzjswjb1');
    v_vc_ezjswjb1    := Json_Str(v_Json_Data, 'vc_ezjswjb1');
    v_vc_fzjswjb1    := Json_Str(v_Json_Data, 'vc_fzjswjb1');
    v_vc_gzjswjb1    := Json_Str(v_Json_Data, 'vc_gzjswjb1');
    v_vc_zjlx        := Json_Str(v_Json_Data, 'vc_zjlx');
    v_vc_rsqk        := Json_Str(v_Json_Data, 'vc_rsqk');
    v_vc_wshksdm     := Json_Str(v_Json_Data, 'vc_wshksdm');
    v_vc_xm          := Json_Str(v_Json_Data, 'vc_xm');
    v_vc_jkdw        := Json_Str(v_Json_Data, 'vc_jkdw');
    v_vc_xb          := Json_Str(v_Json_Data, 'vc_xb');
    v_vc_mz          := Json_Str(v_Json_Data, 'vc_mz');
    v_vc_zy          := Json_Str(v_Json_Data, 'vc_zy');
    v_vc_hyzk        := Json_Str(v_Json_Data, 'vc_hyzk');
    v_vc_whcd        := Json_Str(v_Json_Data, 'vc_whcd');
    v_nb_gbsybm      := json_str(v_json_data, 'nb_gbsybm');
    --校验数据是否合法
    if v_vc_xm is null then
      v_err := '姓名不能为空!';
      raise err_custom;
    end if;
    --校验身份证号码合法性
    if v_vc_sfzhm is not null then
      if substr(v_vc_sfzhm, 7, 8) <> to_char(v_dt_csrq, 'yyyymmdd') then
        v_err := '身份证号码与出生日期不匹配!';
        raise err_custom;
      end if;
      if (mod(substr(v_vc_sfzhm, 17, 1), 2) = 0 and v_vc_xb <> '2') or
         (mod(substr(v_vc_sfzhm, 17, 1), 2) = 1 and v_vc_xb <> '1') then
        v_err := '身份证号码与性别不匹配!';
        raise err_custom;
      end if;
    end if;
    --新增
    if v_vc_bgkid is null then
      if v_czyjgjb <> '4' then
        v_err := '当前机构无新增权限!';
        raise err_custom;
      end if;
      v_ywjl_czlx := '01';
      --获取报告卡id
      select fun_getbgkid_sw_wm(v_czyjgdm) into v_vc_bgkid from dual;
      --属地确认标志
      if v_vc_hkjddm is not null then
        select count(1), wm_concat(a.code)
          into v_count, v_vc_gldwdm
          from organ_node a
         where a.removed = 0
           and a.description like '%' || v_vc_hkjddm || '%';
        if v_count = 1 then
          --确定属地
          v_vc_sdqr := '1';
        else
          v_vc_gldwdm := v_vc_hkqxdm;
          v_vc_sdqr   := '0';
        end if;
      else
        v_vc_sdqr := '1';
      end if;
      if v_vc_hkqcs = '1' then
        --2.外省户籍数据（vc_hkqcs=1)，管理单位取报告卡单位前6位（vc_gldwdm=substr(vc_jkdw,1,6)||'00')
        v_vc_sdqr   := '1';
        v_vc_gldwdm := substr(v_czyjgdm, 1, 6) || '00';
      end if;
      --本地户籍卡片由管理单位自己报卡时,户口核实为1
      if v_vc_gldwdm = v_czyjgdm then
        v_vc_hkhs := '1';
      end if;
      --写入死亡报告卡
      insert into zjmb_sw_bgk_wm
        (vc_bgkid,
         vc_wshkqxdm,
         vc_wshkjddm,
         vc_wshkjw,
         vc_gjhdq,
         vc_wshkshendm,
         vc_jzqcs,
         vc_jzsdm,
         vc_jzqxdm,
         vc_jzjddm,
         vc_jzjw,
         vc_wsjzshendm,
         vc_wsjzsdm,
         vc_wsjzqxdm,
         vc_wsjzjddm,
         vc_wsjzjw,
         dt_swrq,
         vc_sznl,
         vc_sfzhm,
         vc_swdd,
         vc_sqzgzddw,
         vc_zdyj,
         vc_gbsy,
         vc_jsxm,
         vc_jslxdh,
         vc_jsdz,
         vc_zyh,
         vc_azjswjb,
         nb_azjswjbicd,
         vc_afbdswsjjg,
         vc_afbdswsjdw,
         vc_bzjswjb,
         nb_bzjswjbidc,
         vc_bfbdswsjjg,
         vc_bfbdswsjdw,
         vc_czjswjb,
         nb_czjswjbicd,
         vc_cfbdswsjjg,
         vc_cfbdswsjdw,
         vc_dzjswjb,
         nb_dajswjbicd,
         vc_dfbdswsjjg,
         vc_dfbdswsjdw,
         vc_szsqbljzztz,
         vc_lxdzhgzdw,
         dt_dcrq,
         vc_hksdm,
         vc_hkqxdm,
         vc_hkjddm,
         dt_csrq,
         vc_ysqm,
         vc_hkhs,
         vc_whsyy,
         vc_hkjw,
         fenleitj,
         vc_ezjswjb,
         nb_eajswjbicd,
         vc_efbdswsjjg,
         vc_efbdswsjdw,
         vc_fzjswjb,
         nb_fajswjbicd,
         vc_ffbdswsjjg,
         vc_ffbdswsjdw,
         vc_gzjswjb,
         nb_gajswjbicd,
         vc_gfbdswsjjg,
         vc_gfbdswsjdw,
         vc_hkqcs,
         fenleitjmc,
         vc_azjswjb1,
         vc_bzjswjb1,
         vc_czjswjb1,
         vc_dzjswjb1,
         vc_ezjswjb1,
         vc_fzjswjb1,
         vc_gzjswjb1,
         vc_zjlx,
         vc_rsqk,
         vc_wshksdm,
         vc_xm,
         vc_jkdw,
         vc_xb,
         vc_mz,
         vc_zy,
         vc_hyzk,
         vc_whcd,
         dt_jksj,
         vc_qyid,
         vc_scbz,
         vc_shbz,
         dt_lrsj,
         dt_xgsj,
         vc_sdqr,
         vc_gldwdm,
         vc_bgklb,
         vc_cjyh,
         vc_xgyh,
         dt_cjsj,
         vc_cjdwdm,
         nb_gbsybm)
      values
        (v_vc_bgkid,
         v_vc_wshkqxdm,
         v_vc_wshkjddm,
         v_vc_wshkjw,
         v_vc_gjhdq,
         v_vc_wshkshendm,
         v_vc_jzqcs,
         v_vc_jzsdm,
         v_vc_jzqxdm,
         v_vc_jzjddm,
         v_vc_jzjw,
         v_vc_wsjzshendm,
         v_vc_wsjzsdm,
         v_vc_wsjzqxdm,
         v_vc_wsjzjddm,
         v_vc_wsjzjw,
         v_dt_swrq,
         v_vc_sznl,
         v_vc_sfzhm,
         v_vc_swdd,
         v_vc_sqzgzddw,
         v_vc_zdyj,
         v_vc_gbsy,
         v_vc_jsxm,
         v_vc_jslxdh,
         v_vc_jsdz,
         v_vc_zyh,
         v_vc_azjswjb,
         v_nb_azjswjbicd,
         v_vc_afbdswsjjg,
         v_vc_afbdswsjdw,
         v_vc_bzjswjb,
         v_nb_bzjswjbidc,
         v_vc_bfbdswsjjg,
         v_vc_bfbdswsjdw,
         v_vc_czjswjb,
         v_nb_czjswjbicd,
         v_vc_cfbdswsjjg,
         v_vc_cfbdswsjdw,
         v_vc_dzjswjb,
         v_nb_dajswjbicd,
         v_vc_dfbdswsjjg,
         v_vc_dfbdswsjdw,
         v_vc_szsqbljzztz,
         v_vc_lxdzhgzdw,
         v_dt_dcrq,
         v_vc_hksdm,
         v_vc_hkqxdm,
         v_vc_hkjddm,
         v_dt_csrq,
         v_vc_ysqm,
         v_vc_hkhs,
         v_vc_whsyy,
         v_vc_hkjw,
         v_fenleitj,
         v_vc_ezjswjb,
         v_nb_eajswjbicd,
         v_vc_efbdswsjjg,
         v_vc_efbdswsjdw,
         v_vc_fzjswjb,
         v_nb_fajswjbicd,
         v_vc_ffbdswsjjg,
         v_vc_ffbdswsjdw,
         v_vc_gzjswjb,
         v_nb_gajswjbicd,
         v_vc_gfbdswsjjg,
         v_vc_gfbdswsjdw,
         v_vc_hkqcs,
         v_fenleitjmc,
         v_vc_azjswjb1,
         v_vc_bzjswjb1,
         v_vc_czjswjb1,
         v_vc_dzjswjb1,
         v_vc_ezjswjb1,
         v_vc_fzjswjb1,
         v_vc_gzjswjb1,
         v_vc_zjlx,
         v_vc_rsqk,
         v_vc_wshksdm,
         v_vc_xm,
         v_vc_jkdw,
         v_vc_xb,
         v_vc_mz,
         v_vc_zy,
         v_vc_hyzk,
         v_vc_whcd,
         v_sysdate,
         '0',
         '2', --未删除
         '1', --医院审核通过
         v_sysdate, --录入时间
         v_sysdate, --修改时间
         v_vc_sdqr,
         v_vc_gldwdm,
         '0', --报告卡类别
         v_czyyhid,
         v_czyyhid,
         v_sysdate,
         v_czyjgdm,
         v_nb_gbsybm);
    else
      v_ywjl_czlx := '02';
      --修改
      begin
        select vc_shbz, vc_sdqr, vc_hkhs, vc_hkqxdm, vc_hkjddm, vc_gldwdm
          into v_vc_shbz,
               v_vc_sdqr,
               v_vc_hkhs_bgq,
               v_vc_hkqxdm_bgq,
               v_vc_hkjddm_bgq,
               v_vc_gldwdm
          from zjmb_sw_bgk_wm
         where vc_bgkid = v_vc_bgkid
           and vc_scbz = '2';
      exception
        when no_data_found then
          v_err := 'id[' || v_vc_bgkid || ']未获取到有效报告卡信息!';
          raise err_custom;
      end;
      --校验管理单位审核权限
      if v_czyjgjb = '3' then
        if substr(v_vc_gldwdm, 1, 6) <> substr(v_czyjgdm, 1, 6) then
          v_err := '非管理单位无此操作权限!';
          raise err_custom;
        end if;
      end if;
      if v_czyjgjb = '4' then
        --社区
        if v_vc_hkhs_bgq is not null then
          v_err := '已做户口核实操作,当前机构无操作权限!';
          raise err_custom;
        end if;
        --审核不通过
        if v_vc_shbz in ('0', '2', '4') then
          --修改为审核通过
          v_vc_shbz := '1';
        end if;
        --修改了户籍地址
        if v_vc_hkqxdm_bgq <> v_vc_hkqxdm or v_vc_hkjddm_bgq <> v_vc_hkjddm then
          --审核状态改为医院通过
          v_vc_shbz := '1';
          --属地确认标志
          select count(1), wm_concat(a.code)
            into v_count, v_vc_gldwdm
            from organ_node a
           where a.removed = 0
             and a.description like '%' || v_vc_hkjddm || '%';
          if v_count = 1 then
            --确定属地
            v_vc_sdqr := '1';
          else
            v_vc_gldwdm := v_vc_hkqxdm;
            v_vc_sdqr   := '0';
          end if;
          if v_vc_hkqcs = '1' then
            --2.外省户籍数据（vc_hkqcs=1)，管理单位取报告卡单位前6位（vc_gldwdm=substr(vc_jkdw,1,6)||'00')
            v_vc_sdqr   := '1';
            v_vc_gldwdm := substr(v_czyjgdm, 1, 6) || '00';
          end if;
        end if;
      elsif v_czyjgjb = '3' then
        --区县
        v_vc_shbz := '3';
        --修改了户籍地址
        if v_vc_hkqxdm_bgq <> v_vc_hkqxdm or v_vc_hkjddm_bgq <> v_vc_hkjddm then
          --审核状态改为医院通过
          v_vc_shbz := '1';
          --属地确认标志
          select count(1), wm_concat(a.code)
            into v_count, v_vc_gldwdm
            from organ_node a
           where a.removed = 0
             and a.description like '%' || v_vc_hkjddm || '%';
          if v_count = 1 then
            --确定属地
            v_vc_sdqr := '1';
          else
            v_vc_gldwdm := '';
            v_vc_sdqr   := '0';
          end if;
          if v_vc_hkqcs = '1' then
            --2.外省户籍数据（vc_hkqcs=1)，管理单位取报告卡单位前6位（vc_gldwdm=substr(vc_jkdw,1,6)||'00')
            v_vc_sdqr   := '1';
            v_vc_gldwdm := substr(v_czyjgdm, 1, 6) || '00';
          end if;
        end if;
      else
        v_err := '当前机构无修改权限!';
        raise err_custom;
      end if;
      --获取变更前信息
      select *
        into v_tab_bgk_old
        from zjmb_sw_bgk_wm
       where vc_bgkid = v_vc_bgkid;
      --更新报告卡信息
      update zjmb_sw_bgk_wm
         set vc_wshkqxdm    = v_vc_wshkqxdm,
             vc_wshkjddm    = v_vc_wshkjddm,
             vc_wshkjw      = v_vc_wshkjw,
             vc_gjhdq       = v_vc_gjhdq,
             vc_wshkshendm  = v_vc_wshkshendm,
             vc_jzqcs       = v_vc_jzqcs,
             vc_jzsdm       = v_vc_jzsdm,
             vc_jzqxdm      = v_vc_jzqxdm,
             vc_jzjddm      = v_vc_jzjddm,
             vc_jzjw        = v_vc_jzjw,
             vc_wsjzshendm  = v_vc_wsjzshendm,
             vc_wsjzsdm     = v_vc_wsjzsdm,
             vc_wsjzqxdm    = v_vc_wsjzqxdm,
             vc_wsjzjddm    = v_vc_wsjzjddm,
             vc_wsjzjw      = v_vc_wsjzjw,
             dt_swrq        = v_dt_swrq,
             vc_sznl        = v_vc_sznl,
             vc_sfzhm       = v_vc_sfzhm,
             vc_swdd        = v_vc_swdd,
             vc_sqzgzddw    = v_vc_sqzgzddw,
             vc_zdyj        = v_vc_zdyj,
             vc_gbsy        = v_vc_gbsy,
             vc_jsxm        = v_vc_jsxm,
             vc_jslxdh      = v_vc_jslxdh,
             vc_jsdz        = v_vc_jsdz,
             vc_zyh         = v_vc_zyh,
             vc_azjswjb     = v_vc_azjswjb,
             nb_azjswjbicd  = v_nb_azjswjbicd,
             vc_afbdswsjjg  = v_vc_afbdswsjjg,
             vc_afbdswsjdw  = v_vc_afbdswsjdw,
             vc_bzjswjb     = v_vc_bzjswjb,
             nb_bzjswjbidc  = v_nb_bzjswjbidc,
             vc_bfbdswsjjg  = v_vc_bfbdswsjjg,
             vc_bfbdswsjdw  = v_vc_bfbdswsjdw,
             vc_czjswjb     = v_vc_czjswjb,
             nb_czjswjbicd  = v_nb_czjswjbicd,
             vc_cfbdswsjjg  = v_vc_cfbdswsjjg,
             vc_cfbdswsjdw  = v_vc_cfbdswsjdw,
             vc_dzjswjb     = v_vc_dzjswjb,
             nb_dajswjbicd  = v_nb_dajswjbicd,
             vc_dfbdswsjjg  = v_vc_dfbdswsjjg,
             vc_dfbdswsjdw  = v_vc_dfbdswsjdw,
             vc_szsqbljzztz = v_vc_szsqbljzztz,
             vc_lxdzhgzdw   = v_vc_lxdzhgzdw,
             dt_dcrq        = v_dt_dcrq,
             vc_hksdm       = v_vc_hksdm,
             vc_hkqxdm      = v_vc_hkqxdm,
             vc_hkjddm      = v_vc_hkjddm,
             dt_csrq        = v_dt_csrq,
             vc_ysqm        = v_vc_ysqm,
             vc_hkhs        = v_vc_hkhs,
             vc_whsyy       = v_vc_whsyy,
             vc_hkjw        = v_vc_hkjw,
             fenleitj       = v_fenleitj,
             vc_ezjswjb     = v_vc_ezjswjb,
             nb_eajswjbicd  = v_nb_eajswjbicd,
             vc_efbdswsjjg  = v_vc_efbdswsjjg,
             vc_efbdswsjdw  = v_vc_efbdswsjdw,
             vc_fzjswjb     = v_vc_fzjswjb,
             nb_fajswjbicd  = v_nb_fajswjbicd,
             vc_ffbdswsjjg  = v_vc_ffbdswsjjg,
             vc_ffbdswsjdw  = v_vc_ffbdswsjdw,
             vc_gzjswjb     = v_vc_gzjswjb,
             nb_gajswjbicd  = v_nb_gajswjbicd,
             vc_gfbdswsjjg  = v_vc_gfbdswsjjg,
             vc_gfbdswsjdw  = v_vc_gfbdswsjdw,
             vc_hkqcs       = v_vc_hkqcs,
             fenleitjmc     = v_fenleitjmc,
             vc_azjswjb1    = v_vc_azjswjb1,
             vc_bzjswjb1    = v_vc_bzjswjb1,
             vc_czjswjb1    = v_vc_czjswjb1,
             vc_dzjswjb1    = v_vc_dzjswjb1,
             vc_ezjswjb1    = v_vc_ezjswjb1,
             vc_fzjswjb1    = v_vc_fzjswjb1,
             vc_gzjswjb1    = v_vc_gzjswjb1,
             vc_zjlx        = v_vc_zjlx,
             vc_rsqk        = v_vc_rsqk,
             vc_wshksdm     = v_vc_wshksdm,
             vc_xm          = v_vc_xm,
             vc_xb          = v_vc_xb,
             vc_mz          = v_vc_mz,
             vc_zy          = v_vc_zy,
             vc_hyzk        = v_vc_hyzk,
             vc_whcd        = v_vc_whcd,
             vc_shbz        = v_vc_shbz,
             vc_sdqr        = v_vc_sdqr,
             vc_gldwdm      = v_vc_gldwdm,
             nb_gbsybm      = v_nb_gbsybm,
             vc_xgyh        = v_czyyhid,
             dt_shsj = case
                         when vc_shbz = '3' and dt_shsj is null then
                          v_sysdate
                         when vc_shbz = '3' and dt_shsj is not null then
                          dt_shsj
                         else
                          null
                       end,
             dt_xgsj        = v_sysdate,
             dt_qxzssj = case
                           when vc_shbz = '3' and dt_shsj is null then
                            null
                           when vc_shbz = '3' and dt_shsj is not null then
                            v_sysdate
                           else
                            null
                         end
       where vc_bgkid = v_vc_bgkid;
      --记录报卡变更日志
      v_ywrzid := sys_guid();
      --获取变更后信息
      select *
        into v_tab_bgk_new
        from zjmb_sw_bgk_wm
       where vc_bgkid = v_vc_bgkid;
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_wshkqxdm',
                                         '外省户口区县代码',
                                         v_tab_bgk_old.vc_wshkqxdm,
                                         v_tab_bgk_new.vc_wshkqxdm,
                                         'P_XZDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_wshkjddm',
                                         '外省户口街道代码',
                                         v_tab_bgk_old.vc_wshkjddm,
                                         v_tab_bgk_new.vc_wshkjddm,
                                         'P_XZDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_wshkjw',
                                         '外省户口居委',
                                         v_tab_bgk_old.vc_wshkjw,
                                         v_tab_bgk_new.vc_wshkjw,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_gjhdq',
                                         '国家或地区',
                                         v_tab_bgk_old.vc_gjhdq,
                                         v_tab_bgk_new.vc_gjhdq,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_wshkshendm',
                                         '外省户口省代码',
                                         v_tab_bgk_old.vc_wshkshendm,
                                         v_tab_bgk_new.vc_wshkshendm,
                                         'P_XZDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_jzqcs',
                                         '居住地址省',
                                         v_tab_bgk_old.vc_jzqcs,
                                         v_tab_bgk_new.vc_jzqcs,
                                         'C_COMM_SHEDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_jzsdm',
                                         '居住地址市',
                                         v_tab_bgk_old.vc_jzsdm,
                                         v_tab_bgk_new.vc_jzsdm,
                                         'P_XZDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_jzqxdm',
                                         '居住地址区县',
                                         v_tab_bgk_old.vc_jzqxdm,
                                         v_tab_bgk_new.vc_jzqxdm,
                                         'P_XZDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_jzjddm',
                                         '居住地址街道',
                                         v_tab_bgk_old.vc_jzjddm,
                                         v_tab_bgk_new.vc_jzjddm,
                                         'P_XZDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_jzjw',
                                         '居住地址居委',
                                         v_tab_bgk_old.vc_jzjw,
                                         v_tab_bgk_new.vc_jzjw,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_wsjzshendm',
                                         '外省居住地址省',
                                         v_tab_bgk_old.vc_wsjzshendm,
                                         v_tab_bgk_new.vc_wsjzshendm,
                                         'P_XZDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_wsjzsdm',
                                         '外省居住地址市',
                                         v_tab_bgk_old.vc_wsjzsdm,
                                         v_tab_bgk_new.vc_wsjzsdm,
                                         'P_XZDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_wsjzqxdm',
                                         '外省居住地址区县',
                                         v_tab_bgk_old.vc_wsjzqxdm,
                                         v_tab_bgk_new.vc_wsjzqxdm,
                                         'P_XZDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_wsjzjddm',
                                         '外省居住地址街道',
                                         v_tab_bgk_old.vc_wsjzjddm,
                                         v_tab_bgk_new.vc_wsjzjddm,
                                         'P_XZDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_wsjzjw',
                                         '外省居住地址居委',
                                         v_tab_bgk_old.vc_wsjzjw,
                                         v_tab_bgk_new.vc_wsjzjw,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'dt_swrq',
                                         '死亡日期',
                                         dts(v_tab_bgk_old.dt_swrq, 0),
                                         dts(v_tab_bgk_new.dt_swrq, 0),
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_sznl',
                                         '实足年龄',
                                         v_tab_bgk_old.vc_sznl,
                                         v_tab_bgk_new.vc_sznl,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_sfzhm',
                                         '证件号码',
                                         v_tab_bgk_old.vc_sfzhm,
                                         v_tab_bgk_new.vc_sfzhm,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_swdd',
                                         '死亡地点',
                                         v_tab_bgk_old.vc_swdd,
                                         v_tab_bgk_new.vc_swdd,
                                         'C_SMTJSW_SWDD',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_sqzgzddw',
                                         '主要疾病最高诊断单位',
                                         v_tab_bgk_old.vc_sqzgzddw,
                                         v_tab_bgk_new.vc_sqzgzddw,
                                         'C_SMTJSW_ZGZZDW',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_zdyj',
                                         '主要疾病最高诊断依据',
                                         v_tab_bgk_old.vc_zdyj,
                                         v_tab_bgk_new.vc_zdyj,
                                         'C_SMTJSW_ZGZDYJ',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_gbsy',
                                         '根本死亡原因',
                                         v_tab_bgk_old.vc_gbsy,
                                         v_tab_bgk_new.vc_gbsy,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_jsxm',
                                         '可联系家属姓名',
                                         v_tab_bgk_old.vc_jsxm,
                                         v_tab_bgk_new.vc_jsxm,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_jslxdh',
                                         '家属联系电话',
                                         v_tab_bgk_old.vc_jslxdh,
                                         v_tab_bgk_new.vc_jslxdh,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_jsdz',
                                         '家属住址或工作单位',
                                         v_tab_bgk_old.vc_jsdz,
                                         v_tab_bgk_new.vc_jsdz,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_zyh',
                                         '医院号',
                                         v_tab_bgk_old.vc_zyh,
                                         v_tab_bgk_new.vc_zyh,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_azjswjb',
                                         'a直接导致死亡的疾病',
                                         v_tab_bgk_old.vc_azjswjb,
                                         v_tab_bgk_new.vc_azjswjb,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'nb_azjswjbicd',
                                         'a直接导致死亡的疾病ICD10编码',
                                         v_tab_bgk_old.nb_azjswjbicd,
                                         v_tab_bgk_new.nb_azjswjbicd,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_afbdswsjjg',
                                         'a发病到死亡的时间间隔',
                                         v_tab_bgk_old.vc_afbdswsjjg,
                                         v_tab_bgk_new.vc_afbdswsjjg,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_afbdswsjdw',
                                         'a发病到死亡的时间间隔单位',
                                         v_tab_bgk_old.vc_afbdswsjdw,
                                         v_tab_bgk_new.vc_afbdswsjdw,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_bzjswjb',
                                         'b直接导致死亡的疾病',
                                         v_tab_bgk_old.vc_bzjswjb,
                                         v_tab_bgk_new.vc_bzjswjb,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'nb_bzjswjbidc',
                                         'b直接导致死亡的疾病ICD10编码',
                                         v_tab_bgk_old.nb_bzjswjbidc,
                                         v_tab_bgk_new.nb_bzjswjbidc,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_bfbdswsjjg',
                                         'b发病到死亡的时间间隔',
                                         v_tab_bgk_old.vc_bfbdswsjjg,
                                         v_tab_bgk_new.vc_bfbdswsjjg,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_bfbdswsjdw',
                                         'b发病到死亡的时间间隔单位',
                                         v_tab_bgk_old.vc_bfbdswsjdw,
                                         v_tab_bgk_new.vc_bfbdswsjdw,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_czjswjb',
                                         'c直接导致死亡的疾病',
                                         v_tab_bgk_old.vc_czjswjb,
                                         v_tab_bgk_new.vc_czjswjb,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'nb_czjswjbicd',
                                         'c直接导致死亡的疾病ICD10编码',
                                         v_tab_bgk_old.nb_czjswjbicd,
                                         v_tab_bgk_new.nb_czjswjbicd,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_bszy',
                                         'c发病到死亡的时间间隔',
                                         v_tab_bgk_old.vc_cfbdswsjjg,
                                         v_tab_bgk_new.vc_cfbdswsjjg,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_cfbdswsjdw',
                                         'c发病到死亡的时间间隔单位',
                                         v_tab_bgk_old.vc_cfbdswsjdw,
                                         v_tab_bgk_new.vc_cfbdswsjdw,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_dzjswjb',
                                         'd直接导致死亡的疾病',
                                         v_tab_bgk_old.vc_dzjswjb,
                                         v_tab_bgk_new.vc_dzjswjb,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'nb_dajswjbicd',
                                         'd直接导致死亡的疾病ICD10编码',
                                         v_tab_bgk_old.nb_dajswjbicd,
                                         v_tab_bgk_new.nb_dajswjbicd,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_dfbdswsjjg',
                                         'd发病到死亡的时间间隔',
                                         v_tab_bgk_old.vc_dfbdswsjjg,
                                         v_tab_bgk_new.vc_dfbdswsjjg,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_dfbdswsjdw',
                                         'd发病到死亡的时间间隔单位',
                                         v_tab_bgk_old.vc_dfbdswsjdw,
                                         v_tab_bgk_new.vc_dfbdswsjdw,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_szsqbljzztz',
                                         '死者生前病史及症状体征',
                                         v_tab_bgk_old.vc_szsqbljzztz,
                                         v_tab_bgk_new.vc_szsqbljzztz,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_lxdzhgzdw',
                                         '联系地址或工作单位',
                                         v_tab_bgk_old.vc_lxdzhgzdw,
                                         v_tab_bgk_new.vc_lxdzhgzdw,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'dt_dcrq',
                                         '调查日期',
                                         dts(v_tab_bgk_old.dt_dcrq, 0),
                                         dts(v_tab_bgk_new.dt_dcrq, 0),
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_hksdm',
                                         '户口省代码',
                                         v_tab_bgk_old.vc_hksdm,
                                         v_tab_bgk_new.vc_hksdm,
                                         'C_COMM_SHEDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_hksdm',
                                         '户口市代码',
                                         v_tab_bgk_old.vc_hksdm,
                                         v_tab_bgk_new.vc_hksdm,
                                         'P_XZDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_hkqxdm',
                                         '户口区县代码',
                                         v_tab_bgk_old.vc_hkqxdm,
                                         v_tab_bgk_new.vc_hkqxdm,
                                         'P_XZDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_hkjddm',
                                         '户口街道代码',
                                         v_tab_bgk_old.vc_hkjddm,
                                         v_tab_bgk_new.vc_hkjddm,
                                         'P_XZDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'dt_csrq',
                                         '出生日期',
                                         dts(v_tab_bgk_old.dt_csrq, 0),
                                         dts(v_tab_bgk_new.dt_csrq, 0),
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_ysqm',
                                         '医师签名',
                                         v_tab_bgk_old.vc_ysqm,
                                         v_tab_bgk_new.vc_ysqm,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_hkhs',
                                         '户口核实',
                                         v_tab_bgk_old.vc_hkhs,
                                         v_tab_bgk_new.vc_hkhs,
                                         'C_COMM_SF',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_whsyy',
                                         '未核实原因',
                                         v_tab_bgk_old.vc_whsyy,
                                         v_tab_bgk_new.vc_whsyy,
                                         'C_SMTJSW_WHSYY',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_hkjw',
                                         '户口居委',
                                         v_tab_bgk_old.vc_hkjw,
                                         v_tab_bgk_new.vc_hkjw,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'fenleitj',
                                         '分类统计号',
                                         v_tab_bgk_old.fenleitj,
                                         v_tab_bgk_new.fenleitj,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_ezjswjb',
                                         'e直接导致死亡的疾病',
                                         v_tab_bgk_old.vc_ezjswjb,
                                         v_tab_bgk_new.vc_ezjswjb,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'nb_eajswjbicd',
                                         'e直接导致死亡的疾病ICD10编码',
                                         v_tab_bgk_old.nb_eajswjbicd,
                                         v_tab_bgk_new.nb_eajswjbicd,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_efbdswsjjg',
                                         'e发病到死亡的时间间隔',
                                         v_tab_bgk_old.vc_efbdswsjjg,
                                         v_tab_bgk_new.vc_efbdswsjjg,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_efbdswsjdw',
                                         'e发病到死亡的时间间隔单位',
                                         v_tab_bgk_old.vc_efbdswsjdw,
                                         v_tab_bgk_new.vc_efbdswsjdw,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_fzjswjb',
                                         'f直接导致死亡的疾病',
                                         v_tab_bgk_old.vc_fzjswjb,
                                         v_tab_bgk_new.vc_fzjswjb,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'nb_fajswjbicd',
                                         'f直接导致死亡的疾病ICD10编码',
                                         v_tab_bgk_old.nb_fajswjbicd,
                                         v_tab_bgk_new.nb_fajswjbicd,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_ffbdswsjjg',
                                         'f发病到死亡的时间间隔',
                                         v_tab_bgk_old.vc_ffbdswsjjg,
                                         v_tab_bgk_new.vc_ffbdswsjjg,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_ffbdswsjdw',
                                         'f发病到死亡的时间间隔单位',
                                         v_tab_bgk_old.vc_ffbdswsjdw,
                                         v_tab_bgk_new.vc_ffbdswsjdw,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_gzjswjb',
                                         'g直接导致死亡的疾病',
                                         v_tab_bgk_old.vc_gzjswjb,
                                         v_tab_bgk_new.vc_gzjswjb,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'nb_gajswjbicd',
                                         'g直接导致死亡的疾病ICD10编码',
                                         v_tab_bgk_old.nb_gajswjbicd,
                                         v_tab_bgk_new.nb_gajswjbicd,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_gfbdswsjjg',
                                         'g发病到死亡的时间间隔',
                                         v_tab_bgk_old.vc_gfbdswsjjg,
                                         v_tab_bgk_new.vc_gfbdswsjjg,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_gfbdswsjdw',
                                         'g发病到死亡的时间间隔单位',
                                         v_tab_bgk_old.vc_gfbdswsjdw,
                                         v_tab_bgk_new.vc_gfbdswsjdw,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_hkqcs',
                                         '户口省代码',
                                         v_tab_bgk_old.vc_hkqcs,
                                         v_tab_bgk_new.vc_hkqcs,
                                         'C_COMM_SHEDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'fenleitjmc',
                                         '分类统计名称',
                                         v_tab_bgk_old.fenleitjmc,
                                         v_tab_bgk_new.fenleitjmc,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_azjswjb1',
                                         '具体的疾病名a',
                                         v_tab_bgk_old.vc_azjswjb1,
                                         v_tab_bgk_new.vc_azjswjb1,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_bzjswjb1',
                                         '具体的疾病名b',
                                         v_tab_bgk_old.vc_bzjswjb1,
                                         v_tab_bgk_new.vc_bzjswjb1,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_czjswjb1',
                                         '具体的疾病名c',
                                         v_tab_bgk_old.vc_czjswjb1,
                                         v_tab_bgk_new.vc_czjswjb1,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_dzjswjb1',
                                         '具体的疾病名d',
                                         v_tab_bgk_old.vc_dzjswjb1,
                                         v_tab_bgk_new.vc_dzjswjb1,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_ezjswjb1',
                                         '具体的疾病名e',
                                         v_tab_bgk_old.vc_ezjswjb1,
                                         v_tab_bgk_new.vc_ezjswjb1,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_fzjswjb1',
                                         '具体的疾病名f',
                                         v_tab_bgk_old.vc_fzjswjb1,
                                         v_tab_bgk_new.vc_fzjswjb1,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_gzjswjb1',
                                         '具体的疾病名g',
                                         v_tab_bgk_old.vc_gzjswjb1,
                                         v_tab_bgk_new.vc_gzjswjb1,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_zjlx',
                                         '有效证件类别',
                                         v_tab_bgk_old.vc_zjlx,
                                         v_tab_bgk_new.vc_zjlx,
                                         'C_SMTJSW_ZJLX',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_rsqk',
                                         '死亡时是否处于妊娠期或妊娠终止后42天内',
                                         v_tab_bgk_old.vc_rsqk,
                                         v_tab_bgk_new.vc_rsqk,
                                         'C_COMM_SF',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_wshksdm',
                                         '外省户口市',
                                         v_tab_bgk_old.vc_wshksdm,
                                         v_tab_bgk_new.vc_wshksdm,
                                         'P_XZDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_xm',
                                         '姓名',
                                         v_tab_bgk_old.vc_xm,
                                         v_tab_bgk_new.vc_xm,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_xb',
                                         '性别',
                                         v_tab_bgk_old.vc_xb,
                                         v_tab_bgk_new.vc_xb,
                                         'C_SMTJSW_XB',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_mz',
                                         '民族',
                                         v_tab_bgk_old.vc_mz,
                                         v_tab_bgk_new.vc_mz,
                                         'C_COMM_MZ',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_zy',
                                         '个人身份',
                                         v_tab_bgk_old.vc_zy,
                                         v_tab_bgk_new.vc_zy,
                                         'C_SMTJSW_GRSF',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_hyzk',
                                         '婚姻状况',
                                         v_tab_bgk_old.vc_hyzk,
                                         v_tab_bgk_new.vc_hyzk,
                                         'C_COMM_HYZK',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_whcd',
                                         '文化程度',
                                         v_tab_bgk_old.vc_whcd,
                                         v_tab_bgk_new.vc_whcd,
                                         'C_SMTJSW_WHCD',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_shbz',
                                         '审核标志',
                                         v_tab_bgk_old.vc_shbz,
                                         v_tab_bgk_new.vc_shbz,
                                         'C_COMM_SHZT',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_sdqr',
                                         '属地确认',
                                         v_tab_bgk_old.vc_sdqr,
                                         v_tab_bgk_new.vc_sdqr,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'vc_gldwdm',
                                         '管理单位',
                                         v_tab_bgk_old.vc_gldwdm,
                                         v_tab_bgk_new.vc_gldwdm,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'nb_gbsybm',
                                         '根本死因ICD编码',
                                         v_tab_bgk_old.nb_gbsybm,
                                         v_tab_bgk_new.nb_gbsybm,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'dt_shsj',
                                         '审核时间',
                                         dts(v_tab_bgk_old.dt_shsj, 0),
                                         dts(v_tab_bgk_new.dt_shsj, 0),
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '06',
                                         'dt_qxzssj',
                                         '区县终审时间',
                                         dts(v_tab_bgk_old.dt_qxzssj, 0),
                                         dts(v_tab_bgk_new.dt_qxzssj, 0),
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
    
    end if;
    --添加操作日志
    v_json_yw_log := Json_ext.get_json(v_json_data, 'ywjllog');
    if v_json_yw_log is not null then
      v_json_yw_log.put('ywrzid', v_ywrzid);
      v_json_yw_log.put('bgkid', v_vc_bgkid);
      v_json_yw_log.put('bgklx', '06');
      v_json_yw_log.put('ywjlid', v_vc_bgkid);
      v_json_yw_log.put('gnmk', '01');
      v_json_yw_log.put('gnmc', '报卡管理');
      v_json_yw_log.put('czlx', v_ywjl_czlx);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_update(v_json_yw_log, v_err);
      if v_err is not null then
        raise err_custom;
      end if;
    end if;
    --返回
    v_Json_Return.put('id', v_vc_bgkid);
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_sw_bgk_wm_update;
  /*--------------------------------------------------------------------------
  || 功能描述 ：获取报告卡编码(无名)
  ||------------------------------------------------------------------------*/
  FUNCTION fun_getbgkid_sw_wm(prm_jgdm VARCHAR2) --市区及医院码
   RETURN VARCHAR2 is
    v_id zjmb_sw_bgk_wm.vc_bgkid%type;
    v_dm VARCHAR2(30);
  begin
    if prm_jgdm is null then
      return '';
    end if;
    v_dm := prm_jgdm || to_char(sysdate, 'yyyy');
    select nvl(max(VC_BGKID) + 1, v_dm || '00000001')
      into v_id
      from zjmb_sw_bgk_wm
     where vc_bgkid like v_dm || '%';
    return v_id;
  END fun_getbgkid_sw_wm;
  /*--------------------------------------------------------------------------
  || 功能描述 ：死因审核(无名)
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_sw_bgk_wm_sh(Data_In    In Clob, --入参
                             result_out OUT VARCHAR2) --返回
   is
    v_json_data   json;
    v_json_return json := json();
    v_json_yw_log json;
    v_ywjl_czlx   varchar2(3);
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
    --公共变量
    v_sysdate    date;
    v_czyjgdm    varchar2(50);
    v_czyjgjb    varchar2(3);
    v_shbz       zjmb_sw_bgk_wm.vc_shbz%TYPE; --审核状态
    v_shbz_table zjmb_sw_bgk_wm.vc_shbz%TYPE; --审核状态
    v_bkid       zjmb_sw_bgk_wm.vc_bgkid%type;
    v_shwtgyy    zjmb_sw_bgk_wm.vc_shwtgyy1%TYPE; --区县审核未通过原因
    v_vc_hkqcs   zjmb_sw_bgk.vc_hkqcs%type;
    v_cjjgdm     varchar2(100);
    v_gljgdm     varchar2(100);
    v_vc_gldwdm  zjmb_sw_bgk.vc_gldwdm%type;
  BEGIN
    json_data(data_in, 'zjmb_sw_bgk_wm审核', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_bkid    := Json_Str(v_Json_Data, 'vc_bgkid');
    v_shbz    := Json_Str(v_Json_Data, 'vc_shbz');
    v_shwtgyy := Json_Str(v_Json_Data, 'vc_shwtgyy');
    --获取机构级别
    --select fun_getczyjgjb(v_czyjgdm) into v_czyjgjb from dual;
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    --获取报卡状态
    begin
      select vc_shbz, vc_gldwdm
        into v_shbz_table, v_vc_gldwdm
        from zjmb_sw_bgk_wm
       where vc_bgkid = v_bkid
         and vc_scbz = '2'
         and vc_shbz = '1';
    exception
      when no_data_found then
        v_err := 'id[' || v_bkid || ']未获取到有效的待审核报告卡信息!';
        raise err_custom;
    end;
    --校验管理单位审核权限
    if v_czyjgjb = '3' then
      if substr(v_vc_gldwdm, 1, 6) <> substr(v_czyjgdm, 1, 6) then
        v_err := '非管理单位无此操作权限!';
        raise err_custom;
      end if;
    end if;
    if v_czyjgjb <> '3' then
      --非区县
      v_err := '当前机构无审核权限!';
      raise err_custom;
    end if;
    --v_shbz_table := '1';
    if v_shbz_table <> '1' then
      v_err := '报卡当前状态不为区县待审核!';
      raise err_custom;
    end if;
    --校验审核权限
    if v_vc_hkqcs = '0' then
      --浙江省
      if substr(v_gljgdm, 1, 6) <> substr(v_czyjgdm, 1, 6) then
        v_err := '省内卡只能审核当前管理机构内的卡片!';
        raise err_custom;
      end if;
    else
      --外省
      --浙江省
      if substr(v_cjjgdm, 1, 6) <> substr(v_czyjgdm, 1, 6) then
        v_err := '省外卡只能审核当前创建机构内的卡片!';
        raise err_custom;
      end if;
    end if;
    --判断审核状态
    if v_shbz = '3' then
      v_shwtgyy := '';
    elsif v_shbz = '4' then
      if v_shwtgyy is null then
        v_err := '审核不通过原因不能为空';
        raise err_custom;
      end if;
    else
      v_err := '传入审核状态[' || v_shbz || ']不正确!';
      raise err_custom;
    end if;
    --更新审核标志
    update zjmb_sw_bgk_wm
       set vc_shbz    = v_shbz,
           vc_shwtgyy = v_shwtgyy,
           dt_shsj    = v_sysdate,
           dt_xgsj    = sysdate
     where vc_bgkid = v_bkid;
    --添加操作日志
    v_json_yw_log := Json_ext.get_json(v_json_data, 'ywjllog');
    if v_json_yw_log is not null then
      v_json_yw_log.put('bgkid', v_bkid);
      v_json_yw_log.put('bgklx', '06');
      v_json_yw_log.put('ywjlid', v_bkid);
      v_json_yw_log.put('gnmk', '01');
      v_json_yw_log.put('gnmc', '报卡管理');
      v_json_yw_log.put('czlx', '03');
      pkg_zjmb_xtfz.prc_zjjk_yw_log_update(v_json_yw_log, v_err);
      if v_err is not null then
        raise err_custom;
      end if;
    end if;
    v_Json_Return.put('id', v_bkid);
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_sw_bgk_wm_sh;
  /*--------------------------------------------------------------------------
  || 功能描述 ：死因删除(无名)
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_sw_bgk_wm_sc(Data_In    In Clob, --入参
                             result_out OUT VARCHAR2) --返回
   is
    v_json_data   json;
    v_json_return json := json();
    v_json_yw_log json;
    v_ywjl_czlx   varchar2(3);
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
    --公共变量
    v_sysdate    date;
    v_czyjgdm    varchar2(50);
    v_czyjgjb    varchar2(3);
    v_shbz       zjmb_sw_bgk_wm.vc_shbz%TYPE; --审核状态
    v_shbz_table zjmb_sw_bgk_wm.vc_shbz%TYPE; --审核状态
    v_bkid       zjmb_sw_bgk_wm.vc_bgkid%type;
    v_vc_hkhs    zjmb_sw_bgk_wm.vc_hkhs%type;
    v_vc_scbz    zjmb_sw_bgk_wm.vc_scbz%type;
    v_vc_gldwdm  zjmb_sw_bgk_wm.vc_gldwdm%type;
  BEGIN
    json_data(data_in, 'zjmb_sw_bgk_wm删除', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    --获取机构级别
    --select fun_getczyjgjb(v_czyjgdm) into v_czyjgjb from dual;
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    v_bkid    := Json_Str(v_Json_Data, 'vc_bgkid');
    --获取报卡状态
    begin
      select vc_hkhs, vc_scbz, vc_gldwdm
        into v_vc_hkhs, v_vc_scbz, v_vc_gldwdm
        from zjmb_sw_bgk_wm
       where vc_bgkid = v_bkid
         and vc_scbz = '2';
    exception
      when no_data_found then
        v_err := 'id[' || v_bkid || ']未获取到有效报告卡信息!';
        raise err_custom;
    end;
    --校验管理单位审核权限
    if v_czyjgjb = '3' then
      if substr(v_vc_gldwdm, 1, 6) <> substr(v_czyjgdm, 1, 6) then
        v_err := '非管理单位无此操作权限!';
        raise err_custom;
      end if;
    end if;
    if v_czyjgjb = '4' then
      --医院社区
      if v_vc_hkhs is not null then
        v_err := '该报卡已做户口核实，当前机构无权删除!';
        raise err_custom;
      end if;
    elsif v_czyjgjb <> '3' then
      --非区县
      v_err := '当前机构无删除权限!';
      raise err_custom;
    end if;
    --更新删除标志
    update zjmb_sw_bgk_wm
       set vc_scbz = '1', vc_bgklb = '5', dt_xgsj = sysdate
     where vc_bgkid = v_bkid;
    --添加操作日志
    v_json_yw_log := Json_ext.get_json(v_json_data, 'ywjllog');
    if v_json_yw_log is not null then
      v_json_yw_log.put('bgkid', v_bkid);
      v_json_yw_log.put('bgklx', '06');
      v_json_yw_log.put('ywjlid', v_bkid);
      v_json_yw_log.put('gnmk', '01');
      v_json_yw_log.put('gnmc', '报卡管理');
      v_json_yw_log.put('czlx', '04');
      pkg_zjmb_xtfz.prc_zjjk_yw_log_update(v_json_yw_log, v_err);
      if v_err is not null then
        raise err_custom;
      end if;
    end if;
    v_Json_Return.put('id', v_bkid);
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_sw_bgk_wm_sc;
  /*--------------------------------------------------------------------------
  || 功能描述 ：无名卡转正
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_sw_bgk_wm_zz(Data_In    In Clob, --入参
                             result_out OUT VARCHAR2) --返回
   is
    v_json_data   json;
    v_json_return json := json();
    v_json_yw_log json;
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
    --公共变量
    v_sysdate        date;
    v_czyjgdm        varchar2(50);
    v_czyjgjb        varchar2(3);
    v_vc_wshkqxdm    zjmb_sw_bgk.vc_wshkqxdm%type;
    v_vc_wshkjddm    zjmb_sw_bgk.vc_wshkjddm%type;
    v_vc_wshkjw      zjmb_sw_bgk.vc_wshkjw%type;
    v_vc_gjhdq       zjmb_sw_bgk.vc_gjhdq%type;
    v_vc_wshkshendm  zjmb_sw_bgk.vc_wshkshendm%type;
    v_vc_jzqcs       zjmb_sw_bgk.vc_jzqcs%type;
    v_vc_jzsdm       zjmb_sw_bgk.vc_jzsdm%type;
    v_vc_jzqxdm      zjmb_sw_bgk.vc_jzqxdm%type;
    v_vc_jzjddm      zjmb_sw_bgk.vc_jzjddm%type;
    v_vc_jzjw        zjmb_sw_bgk.vc_jzjw%type;
    v_vc_wsjzshendm  zjmb_sw_bgk.vc_wsjzshendm%type;
    v_vc_wsjzsdm     zjmb_sw_bgk.vc_wsjzsdm%type;
    v_vc_wsjzqxdm    zjmb_sw_bgk.vc_wsjzqxdm%type;
    v_vc_wsjzjddm    zjmb_sw_bgk.vc_wsjzjddm%type;
    v_vc_wsjzjw      zjmb_sw_bgk.vc_wsjzjw%type;
    v_dt_swrq        zjmb_sw_bgk.dt_swrq%type;
    v_vc_sznl        zjmb_sw_bgk.vc_sznl%type;
    v_vc_sfzhm       zjmb_sw_bgk.vc_sfzhm%type;
    v_vc_swdd        zjmb_sw_bgk.vc_swdd%type;
    v_vc_sqzgzddw    zjmb_sw_bgk.vc_sqzgzddw%type;
    v_vc_zdyj        zjmb_sw_bgk.vc_zdyj%type;
    v_vc_gbsy        zjmb_sw_bgk.vc_gbsy%type;
    v_vc_jsxm        zjmb_sw_bgk.vc_jsxm%type;
    v_vc_jslxdh      zjmb_sw_bgk.vc_jslxdh%type;
    v_vc_jsdz        zjmb_sw_bgk.vc_jsdz%type;
    v_vc_zyh         zjmb_sw_bgk.vc_zyh%type;
    v_vc_azjswjb     zjmb_sw_bgk.vc_azjswjb%type;
    v_nb_azjswjbicd  zjmb_sw_bgk.nb_azjswjbicd%type;
    v_vc_afbdswsjjg  zjmb_sw_bgk.vc_afbdswsjjg%type;
    v_vc_afbdswsjdw  zjmb_sw_bgk.vc_afbdswsjdw%type;
    v_vc_bzjswjb     zjmb_sw_bgk.vc_bzjswjb%type;
    v_nb_bzjswjbidc  zjmb_sw_bgk.nb_bzjswjbidc%type;
    v_vc_bfbdswsjjg  zjmb_sw_bgk.vc_bfbdswsjjg%type;
    v_vc_bfbdswsjdw  zjmb_sw_bgk.vc_bfbdswsjdw%type;
    v_vc_czjswjb     zjmb_sw_bgk.vc_czjswjb%type;
    v_nb_czjswjbicd  zjmb_sw_bgk.nb_czjswjbicd%type;
    v_vc_cfbdswsjjg  zjmb_sw_bgk.vc_cfbdswsjjg%type;
    v_vc_cfbdswsjdw  zjmb_sw_bgk.vc_cfbdswsjdw%type;
    v_vc_dzjswjb     zjmb_sw_bgk.vc_dzjswjb%type;
    v_nb_dajswjbicd  zjmb_sw_bgk.nb_dajswjbicd%type;
    v_vc_dfbdswsjjg  zjmb_sw_bgk.vc_dfbdswsjjg%type;
    v_vc_dfbdswsjdw  zjmb_sw_bgk.vc_dfbdswsjdw%type;
    v_vc_szsqbljzztz zjmb_sw_bgk.vc_szsqbljzztz%type;
    v_vc_lxdzhgzdw   zjmb_sw_bgk.vc_lxdzhgzdw%type;
    v_dt_dcrq        zjmb_sw_bgk.dt_dcrq%type;
    v_vc_hksdm       zjmb_sw_bgk.vc_hksdm%type;
    v_vc_hkqxdm      zjmb_sw_bgk.vc_hkqxdm%type;
    v_vc_hkjddm      zjmb_sw_bgk.vc_hkjddm%type;
    v_dt_csrq        zjmb_sw_bgk.dt_csrq%type;
    v_vc_ysqm        zjmb_sw_bgk.vc_ysqm%type;
    v_vc_hkhs        zjmb_sw_bgk.vc_hkhs%type;
    v_vc_whsyy       zjmb_sw_bgk.vc_whsyy%type;
    v_vc_hkjw        zjmb_sw_bgk.vc_hkjw%type;
    v_fenleitj       zjmb_sw_bgk.fenleitj%type;
    v_vc_ezjswjb     zjmb_sw_bgk.vc_ezjswjb%type;
    v_nb_eajswjbicd  zjmb_sw_bgk.nb_eajswjbicd%type;
    v_vc_efbdswsjjg  zjmb_sw_bgk.vc_efbdswsjjg%type;
    v_vc_efbdswsjdw  zjmb_sw_bgk.vc_efbdswsjdw%type;
    v_vc_fzjswjb     zjmb_sw_bgk.vc_fzjswjb%type;
    v_nb_fajswjbicd  zjmb_sw_bgk.nb_fajswjbicd%type;
    v_vc_ffbdswsjjg  zjmb_sw_bgk.vc_ffbdswsjjg%type;
    v_vc_ffbdswsjdw  zjmb_sw_bgk.vc_ffbdswsjdw%type;
    v_vc_gzjswjb     zjmb_sw_bgk.vc_gzjswjb%type;
    v_nb_gajswjbicd  zjmb_sw_bgk.nb_gajswjbicd%type;
    v_vc_gfbdswsjjg  zjmb_sw_bgk.vc_gfbdswsjjg%type;
    v_vc_gfbdswsjdw  zjmb_sw_bgk.vc_gfbdswsjdw%type;
    v_vc_hkqcs       zjmb_sw_bgk.vc_hkqcs%type;
    v_fenleitjmc     zjmb_sw_bgk.fenleitjmc%type;
    v_vc_azjswjb1    zjmb_sw_bgk.vc_azjswjb1%type;
    v_vc_bzjswjb1    zjmb_sw_bgk.vc_bzjswjb1%type;
    v_vc_czjswjb1    zjmb_sw_bgk.vc_czjswjb1%type;
    v_vc_dzjswjb1    zjmb_sw_bgk.vc_dzjswjb1%type;
    v_vc_ezjswjb1    zjmb_sw_bgk.vc_ezjswjb1%type;
    v_vc_fzjswjb1    zjmb_sw_bgk.vc_fzjswjb1%type;
    v_vc_gzjswjb1    zjmb_sw_bgk.vc_gzjswjb1%type;
    v_vc_zjlx        zjmb_sw_bgk.vc_zjlx%type;
    v_vc_rsqk        zjmb_sw_bgk.vc_rsqk%type;
    v_vc_wshksdm     zjmb_sw_bgk.vc_wshksdm%type;
    v_vc_xm          zjmb_sw_bgk.vc_xm%type;
    v_vc_jkdw        zjmb_sw_bgk.vc_jkdw%type;
    v_vc_xb          zjmb_sw_bgk.vc_xb%type;
    v_vc_mz          zjmb_sw_bgk.vc_mz%type;
    v_vc_zy          zjmb_sw_bgk.vc_zy%type;
    v_vc_hyzk        zjmb_sw_bgk.vc_hyzk%type;
    v_vc_whcd        zjmb_sw_bgk.vc_whcd%type;
    v_dt_jksj        zjmb_sw_bgk.dt_jksj%type;
    v_vc_qyid        zjmb_sw_bgk.vc_qyid%type;
    v_vc_scbz        zjmb_sw_bgk.vc_scbz%type;
    v_vc_shbz        zjmb_sw_bgk.vc_shbz%type;
    v_dt_lrsj        zjmb_sw_bgk.dt_lrsj%type;
    v_dt_xgsj        zjmb_sw_bgk.dt_xgsj%type;
    v_vc_sdqr        zjmb_sw_bgk.vc_sdqr%type;
    v_vc_gldwdm      zjmb_sw_bgk.vc_gldwdm%type;
    v_vc_bgklb       zjmb_sw_bgk.vc_bgklb%type;
    v_vc_cjyh        zjmb_sw_bgk.vc_cjyh%type;
    v_vc_xgyh        zjmb_sw_bgk.vc_xgyh%type;
    v_dt_cjsj        zjmb_sw_bgk.dt_cjsj%type;
    v_vc_cjdwdm      zjmb_sw_bgk.vc_cjdwdm%type;
  
    v_bkid_wm zjmb_sw_bgk_wm.vc_bgkid%type;
    v_bkid_sw zjmb_sw_bgk.vc_bgkid%type;
    v_czyyhid varchar2(50);
    v_count   number;
  
  BEGIN
    json_data(data_in, 'zjmb_sw_bgk_wm转正', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    v_bkid_wm := Json_Str(v_Json_Data, 'vc_bgkid');
    v_czyyhid := Json_Str(v_Json_Data, 'v_czyyhid');
    --校验是否已存在转正记录
    select count(1)
      into v_count
      from zjmb_sw_bgk_wm_zzjl
     where vc_bgkid_wm = v_bkid_wm;
    if v_count > 0 then
      v_err := '该保卡已存在转正记录!';
      raise err_custom;
    end if;
    --判断权限
    if v_czyjgjb not in ('3', '4') then
      v_err := '当前机构无转正权限!';
      raise err_custom;
    end if;
    --获取无名尸信息
    select vc_wshkqxdm,
           vc_wshkjddm,
           vc_wshkjw,
           vc_gjhdq,
           vc_wshkshendm,
           vc_jzqcs,
           vc_jzsdm,
           vc_jzqxdm,
           vc_jzjddm,
           vc_jzjw,
           vc_wsjzshendm,
           vc_wsjzsdm,
           vc_wsjzqxdm,
           vc_wsjzjddm,
           vc_wsjzjw,
           dt_swrq,
           vc_sznl,
           vc_sfzhm,
           vc_swdd,
           vc_sqzgzddw,
           vc_zdyj,
           vc_gbsy,
           vc_jsxm,
           vc_jslxdh,
           vc_jsdz,
           vc_zyh,
           vc_azjswjb,
           nb_azjswjbicd,
           vc_afbdswsjjg,
           vc_afbdswsjdw,
           vc_bzjswjb,
           nb_bzjswjbidc,
           vc_bfbdswsjjg,
           vc_bfbdswsjdw,
           vc_czjswjb,
           nb_czjswjbicd,
           vc_cfbdswsjjg,
           vc_cfbdswsjdw,
           vc_dzjswjb,
           nb_dajswjbicd,
           vc_dfbdswsjjg,
           vc_dfbdswsjdw,
           vc_szsqbljzztz,
           vc_lxdzhgzdw,
           dt_dcrq,
           vc_hksdm,
           vc_hkqxdm,
           vc_hkjddm,
           dt_csrq,
           vc_ysqm,
           vc_hkhs,
           vc_whsyy,
           vc_hkjw,
           fenleitj,
           vc_ezjswjb,
           nb_eajswjbicd,
           vc_efbdswsjjg,
           vc_efbdswsjdw,
           vc_fzjswjb,
           nb_fajswjbicd,
           vc_ffbdswsjjg,
           vc_ffbdswsjdw,
           vc_gzjswjb,
           nb_gajswjbicd,
           vc_gfbdswsjjg,
           vc_gfbdswsjdw,
           vc_hkqcs,
           fenleitjmc,
           vc_azjswjb1,
           vc_bzjswjb1,
           vc_czjswjb1,
           vc_dzjswjb1,
           vc_ezjswjb1,
           vc_fzjswjb1,
           vc_gzjswjb1,
           vc_zjlx,
           vc_rsqk,
           vc_wshksdm,
           vc_xm,
           vc_jkdw,
           vc_xb,
           vc_mz,
           vc_zy,
           vc_hyzk,
           vc_whcd,
           dt_jksj,
           vc_qyid,
           vc_scbz,
           vc_shbz,
           dt_lrsj,
           dt_xgsj,
           vc_sdqr,
           vc_gldwdm,
           vc_bgklb,
           vc_cjyh,
           vc_xgyh,
           dt_cjsj,
           vc_cjdwdm
      into v_vc_wshkqxdm,
           v_vc_wshkjddm,
           v_vc_wshkjw,
           v_vc_gjhdq,
           v_vc_wshkshendm,
           v_vc_jzqcs,
           v_vc_jzsdm,
           v_vc_jzqxdm,
           v_vc_jzjddm,
           v_vc_jzjw,
           v_vc_wsjzshendm,
           v_vc_wsjzsdm,
           v_vc_wsjzqxdm,
           v_vc_wsjzjddm,
           v_vc_wsjzjw,
           v_dt_swrq,
           v_vc_sznl,
           v_vc_sfzhm,
           v_vc_swdd,
           v_vc_sqzgzddw,
           v_vc_zdyj,
           v_vc_gbsy,
           v_vc_jsxm,
           v_vc_jslxdh,
           v_vc_jsdz,
           v_vc_zyh,
           v_vc_azjswjb,
           v_nb_azjswjbicd,
           v_vc_afbdswsjjg,
           v_vc_afbdswsjdw,
           v_vc_bzjswjb,
           v_nb_bzjswjbidc,
           v_vc_bfbdswsjjg,
           v_vc_bfbdswsjdw,
           v_vc_czjswjb,
           v_nb_czjswjbicd,
           v_vc_cfbdswsjjg,
           v_vc_cfbdswsjdw,
           v_vc_dzjswjb,
           v_nb_dajswjbicd,
           v_vc_dfbdswsjjg,
           v_vc_dfbdswsjdw,
           v_vc_szsqbljzztz,
           v_vc_lxdzhgzdw,
           v_dt_dcrq,
           v_vc_hksdm,
           v_vc_hkqxdm,
           v_vc_hkjddm,
           v_dt_csrq,
           v_vc_ysqm,
           v_vc_hkhs,
           v_vc_whsyy,
           v_vc_hkjw,
           v_fenleitj,
           v_vc_ezjswjb,
           v_nb_eajswjbicd,
           v_vc_efbdswsjjg,
           v_vc_efbdswsjdw,
           v_vc_fzjswjb,
           v_nb_fajswjbicd,
           v_vc_ffbdswsjjg,
           v_vc_ffbdswsjdw,
           v_vc_gzjswjb,
           v_nb_gajswjbicd,
           v_vc_gfbdswsjjg,
           v_vc_gfbdswsjdw,
           v_vc_hkqcs,
           v_fenleitjmc,
           v_vc_azjswjb1,
           v_vc_bzjswjb1,
           v_vc_czjswjb1,
           v_vc_dzjswjb1,
           v_vc_ezjswjb1,
           v_vc_fzjswjb1,
           v_vc_gzjswjb1,
           v_vc_zjlx,
           v_vc_rsqk,
           v_vc_wshksdm,
           v_vc_xm,
           v_vc_jkdw,
           v_vc_xb,
           v_vc_mz,
           v_vc_zy,
           v_vc_hyzk,
           v_vc_whcd,
           v_dt_jksj,
           v_vc_qyid,
           v_vc_scbz,
           v_vc_shbz,
           v_dt_lrsj,
           v_dt_xgsj,
           v_vc_sdqr,
           v_vc_gldwdm,
           v_vc_bgklb,
           v_vc_cjyh,
           v_vc_xgyh,
           v_dt_cjsj,
           v_vc_cjdwdm
      from zjmb_sw_bgk_wm
     where vc_bgkid = v_bkid_wm;
    if sql%rowcount = 0 then
      v_err := '未获取到需要转正的无名卡信息!';
      raise err_custom;
    end if;
    --校验数据是否合法
    if v_vc_xm is null then
      v_err := '姓名不能为空!';
      raise err_custom;
    end if;
    if v_vc_xb is null then
      v_err := '性别不能为空!';
      raise err_custom;
    end if;
    if v_vc_mz is null then
      v_err := '民族不能为空!';
      raise err_custom;
    end if;
    if v_vc_zjlx is null then
      v_err := '证件类型不能为空!';
      raise err_custom;
    end if;
    if v_vc_sfzhm is null then
      v_err := '证件号码不能为空!';
      raise err_custom;
    end if;
    if v_vc_hyzk is null then
      v_err := '婚姻状况不能为空!';
      raise err_custom;
    end if;
    if v_vc_hkqcs is null then
      v_err := '户籍地址省不能为空!';
      raise err_custom;
    end if;
    --户籍地址浙江
    if v_vc_hkqcs = '0' then
      if v_vc_hksdm is null then
        v_err := '户籍地址市不能为空!';
        raise err_custom;
      end if;
      if v_vc_hkqxdm is null then
        v_err := '户籍地址区县不能为空!';
        raise err_custom;
      end if;
      if v_vc_hkjddm is null then
        v_err := '户籍地址街道不能为空!';
        raise err_custom;
      end if;
      if substr(v_vc_hksdm, 1, 4) <> substr(v_vc_hkqxdm, 1, 4) or
         substr(v_vc_hksdm, 1, 4) <> substr(v_vc_hkjddm, 1, 4) then
        v_err := '户籍地址区划不匹配!';
        raise err_custom;
      end if;
    end if;
    --户籍地址外省
    if v_vc_hkqcs = '1' then
      if v_vc_wshkshendm is null then
        v_err := '外省户籍地址省不能为空!';
        raise err_custom;
      end if;
      if v_vc_wshksdm is null then
        v_err := '外省户籍地址市不能为空!';
        raise err_custom;
      end if;
      if v_vc_wshkqxdm is null then
        v_err := '外省户籍地址区县不能为空!';
        raise err_custom;
      end if;
      if v_vc_wshkjddm is null then
        v_err := '外省户籍地址街道不能为空!';
        raise err_custom;
      end if;
    end if;
    --居住地址
    if v_vc_jzqcs is null then
      v_err := '居住地址省不能为空!';
      raise err_custom;
    end if;
    --居住地址浙江
    if v_vc_jzqcs = '0' then
      if v_vc_jzsdm is null then
        v_err := '居住地址市不能为空!';
        raise err_custom;
      end if;
      if v_vc_jzqxdm is null then
        v_err := '居住地址区县不能为空!';
        raise err_custom;
      end if;
      if v_vc_jzjddm is null then
        v_err := '居住地址街道不能为空!';
        raise err_custom;
      end if;
      if substr(v_vc_jzsdm, 1, 4) <> substr(v_vc_jzqxdm, 1, 4) or
         substr(v_vc_jzsdm, 1, 4) <> substr(v_vc_jzjddm, 1, 4) then
        v_err := '居住地址区划不匹配!';
        raise err_custom;
      end if;
    end if;
    --居住地址外省
    if v_vc_jzqcs = '1' then
      if v_vc_wsjzshendm is null then
        v_err := '外省居住地址省不能为空!';
        raise err_custom;
      end if;
      if v_vc_wsjzsdm is null then
        v_err := '外省居住地址市不能为空!';
        raise err_custom;
      end if;
      if v_vc_wsjzqxdm is null then
        v_err := '外省居住地址区县不能为空!';
        raise err_custom;
      end if;
      if v_vc_wsjzjddm is null then
        v_err := '外省居住地址街道不能为空!';
        raise err_custom;
      end if;
    end if;
    if v_vc_whcd is null then
      v_err := '文化程度不能为空!';
      raise err_custom;
    end if;
    if v_vc_zy is null then
      v_err := '个人身份不能为空!';
      raise err_custom;
    end if;
    if v_dt_swrq is null then
      v_err := '死亡日期不能为空!';
      raise err_custom;
    end if;
    if v_vc_swdd is null then
      v_err := '死亡地点不能为空!';
      raise err_custom;
    end if;
  
    if v_vc_azjswjb1 is null then
      v_err := 'a直接导致死亡的疾病名不能为空!';
      raise err_custom;
    end if;
    if v_nb_azjswjbicd is null then
      v_err := 'a直接导致死亡的疾病ICD10编码不能为空!';
      raise err_custom;
    end if;
    if v_vc_azjswjb is null then
      v_err := 'a直接导致死亡的疾病的疾病诊断不能为空!';
      raise err_custom;
    end if;
    if v_vc_afbdswsjjg is null then
      v_err := 'a发病到死亡的时间间隔不能为空!';
      raise err_custom;
    end if;
    if v_vc_sqzgzddw is null then
      v_err := '最高诊断单位不能为空!';
      raise err_custom;
    end if;
    if v_vc_zdyj is null then
      v_err := '最高诊断依据不能为空!';
      raise err_custom;
    end if;
    if v_vc_ysqm is null then
      v_err := '医师签名不能为空!';
      raise err_custom;
    end if;
    if v_dt_dcrq is null then
      v_err := '填报日期不能为空!';
      raise err_custom;
    end if;
    if v_vc_jkdw is null then
      v_err := '报卡单位医院不能为空!';
      raise err_custom;
    end if;
    if v_vc_cjdwdm is null then
      v_err := '报卡单位医院不能为空!';
      raise err_custom;
    end if;
    --写入死亡报卡
    --获取报告卡id
    select fun_getbgkid_sw(v_vc_cjdwdm) into v_bkid_sw from dual;
    insert into zjmb_sw_bgk
      (vc_bgkid,
       vc_wshkqxdm,
       vc_wshkjddm,
       vc_wshkjw,
       vc_gjhdq,
       vc_wshkshendm,
       vc_jzqcs,
       vc_jzsdm,
       vc_jzqxdm,
       vc_jzjddm,
       vc_jzjw,
       vc_wsjzshendm,
       vc_wsjzsdm,
       vc_wsjzqxdm,
       vc_wsjzjddm,
       vc_wsjzjw,
       dt_swrq,
       vc_sznl,
       vc_sfzhm,
       vc_swdd,
       vc_sqzgzddw,
       vc_zdyj,
       vc_gbsy,
       vc_jsxm,
       vc_jslxdh,
       vc_jsdz,
       vc_zyh,
       vc_azjswjb,
       nb_azjswjbicd,
       vc_afbdswsjjg,
       vc_afbdswsjdw,
       vc_bzjswjb,
       nb_bzjswjbidc,
       vc_bfbdswsjjg,
       vc_bfbdswsjdw,
       vc_czjswjb,
       nb_czjswjbicd,
       vc_cfbdswsjjg,
       vc_cfbdswsjdw,
       vc_dzjswjb,
       nb_dajswjbicd,
       vc_dfbdswsjjg,
       vc_dfbdswsjdw,
       vc_szsqbljzztz,
       vc_lxdzhgzdw,
       dt_dcrq,
       vc_hksdm,
       vc_hkqxdm,
       vc_hkjddm,
       dt_csrq,
       vc_ysqm,
       vc_hkhs,
       vc_whsyy,
       vc_hkjw,
       fenleitj,
       vc_ezjswjb,
       nb_eajswjbicd,
       vc_efbdswsjjg,
       vc_efbdswsjdw,
       vc_fzjswjb,
       nb_fajswjbicd,
       vc_ffbdswsjjg,
       vc_ffbdswsjdw,
       vc_gzjswjb,
       nb_gajswjbicd,
       vc_gfbdswsjjg,
       vc_gfbdswsjdw,
       vc_hkqcs,
       fenleitjmc,
       vc_azjswjb1,
       vc_bzjswjb1,
       vc_czjswjb1,
       vc_dzjswjb1,
       vc_ezjswjb1,
       vc_fzjswjb1,
       vc_gzjswjb1,
       vc_zjlx,
       vc_rsqk,
       vc_wshksdm,
       vc_xm,
       vc_jkdw,
       vc_xb,
       vc_mz,
       vc_zy,
       vc_hyzk,
       vc_whcd,
       dt_jksj,
       vc_qyid,
       vc_scbz,
       vc_shbz,
       dt_lrsj,
       dt_xgsj,
       vc_sdqr,
       vc_gldwdm,
       vc_bgklb,
       vc_cjyh,
       vc_xgyh,
       dt_cjsj,
       vc_cjdwdm)
      select v_bkid_sw,
             vc_wshkqxdm,
             vc_wshkjddm,
             vc_wshkjw,
             vc_gjhdq,
             vc_wshkshendm,
             vc_jzqcs,
             vc_jzsdm,
             vc_jzqxdm,
             vc_jzjddm,
             vc_jzjw,
             vc_wsjzshendm,
             vc_wsjzsdm,
             vc_wsjzqxdm,
             vc_wsjzjddm,
             vc_wsjzjw,
             dt_swrq,
             vc_sznl,
             vc_sfzhm,
             vc_swdd,
             vc_sqzgzddw,
             vc_zdyj,
             vc_gbsy,
             vc_jsxm,
             vc_jslxdh,
             vc_jsdz,
             vc_zyh,
             vc_azjswjb,
             nb_azjswjbicd,
             vc_afbdswsjjg,
             vc_afbdswsjdw,
             vc_bzjswjb,
             nb_bzjswjbidc,
             vc_bfbdswsjjg,
             vc_bfbdswsjdw,
             vc_czjswjb,
             nb_czjswjbicd,
             vc_cfbdswsjjg,
             vc_cfbdswsjdw,
             vc_dzjswjb,
             nb_dajswjbicd,
             vc_dfbdswsjjg,
             vc_dfbdswsjdw,
             vc_szsqbljzztz,
             vc_lxdzhgzdw,
             dt_dcrq,
             vc_hksdm,
             vc_hkqxdm,
             vc_hkjddm,
             dt_csrq,
             vc_ysqm,
             vc_hkhs,
             vc_whsyy,
             vc_hkjw,
             fenleitj,
             vc_ezjswjb,
             nb_eajswjbicd,
             vc_efbdswsjjg,
             vc_efbdswsjdw,
             vc_fzjswjb,
             nb_fajswjbicd,
             vc_ffbdswsjjg,
             vc_ffbdswsjdw,
             vc_gzjswjb,
             nb_gajswjbicd,
             vc_gfbdswsjjg,
             vc_gfbdswsjdw,
             vc_hkqcs,
             fenleitjmc,
             vc_azjswjb1,
             vc_bzjswjb1,
             vc_czjswjb1,
             vc_dzjswjb1,
             vc_ezjswjb1,
             vc_fzjswjb1,
             vc_gzjswjb1,
             vc_zjlx,
             vc_rsqk,
             vc_wshksdm,
             vc_xm,
             vc_jkdw,
             vc_xb,
             vc_mz,
             vc_zy,
             vc_hyzk,
             vc_whcd,
             dt_jksj,
             vc_qyid,
             vc_scbz,
             vc_shbz,
             dt_lrsj,
             dt_xgsj,
             vc_sdqr,
             vc_gldwdm,
             vc_bgklb,
             vc_cjyh,
             vc_xgyh,
             dt_cjsj,
             vc_cjdwdm
        from zjmb_sw_bgk_wm
       where vc_bgkid = v_bkid_wm;
    if sql%rowcount = 0 then
      v_err := '未获取到需要转正的无名卡信息!';
      raise err_custom;
    end if;
    --写入转正记录
    insert into zjmb_sw_bgk_wm_zzjl
      (vc_bgkid_sw, vc_bgkid_wm, vc_cjr, vc_cjdw, dt_cjsj)
    values
      (v_bkid_sw, v_bkid_wm, v_czyyhid, v_czyjgdm, v_sysdate);
    --返回
    --添加操作日志
    v_json_yw_log := Json_ext.get_json(v_json_data, 'ywjllog');
    if v_json_yw_log is not null then
      v_json_yw_log.put('bgkid', v_bkid_sw);
      v_json_yw_log.put('bgklx', '06');
      v_json_yw_log.put('ywjlid', v_bkid_sw);
      v_json_yw_log.put('gnmk', '01');
      v_json_yw_log.put('gnmc', '报卡管理-转正');
      v_json_yw_log.put('czlx', '01');
      pkg_zjmb_xtfz.prc_zjjk_yw_log_update(v_json_yw_log, v_err);
      if v_err is not null then
        raise err_custom;
      end if;
    end if;
    v_Json_Return.put('id', v_bkid_sw);
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_sw_bgk_wm_zz;
  /*--------------------------------------------------------------------------
  || 功能描述 ：出生报告卡管理
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_cs_bgk_update(Data_In    In Clob, --入参
                              result_out OUT VARCHAR2) --返回
   is
    v_json_data   json;
    v_json_return json := json();
    v_json_yw_log json;
    v_ywjl_czlx   varchar2(3);
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
    --公共变量
    v_sysdate date;
    v_czyjgdm varchar2(50);
    v_czyjgjb varchar2(3);
    v_czyyhid varchar2(50);
    v_count   number;
  
    v_vc_swyy     zjmb_cs_bgk.vc_swyy%TYPE; --死亡原因
    v_vc_bgklb    zjmb_cs_bgk.vc_bgklb%TYPE; --报告卡类别
    v_vc_bz       zjmb_cs_bgk.vc_bz%TYPE; --备注
    v_vc_sdm      zjmb_cs_bgk.vc_sdm%TYPE; --户口市代码
    v_vc_qdm      zjmb_cs_bgk.vc_qdm%TYPE; --户口区代码
    v_vc_jddm     zjmb_cs_bgk.vc_jddm%TYPE; --户口街道代码
    v_vc_cssdm    zjmb_cs_bgk.vc_cssdm%TYPE; --出生市代码
    v_vc_csqxdm   zjmb_cs_bgk.vc_csqxdm%TYPE; --出生区县代码
    v_vc_csjddm   zjmb_cs_bgk.vc_csjddm%TYPE; --出生街道代码
    v_vc_cszh     zjmb_cs_bgk.vc_cszh%TYPE; --出生证号
    v_vc_hkxxdz   zjmb_cs_bgk.vc_hkxxdz%TYPE; --户口详细地址
    v_vc_csjw     zjmb_cs_bgk.vc_csjw%TYPE; --出生居委
    v_vc_hkjw     zjmb_cs_bgk.vc_hkjw%TYPE; --户口居委
    v_vc_fqgjqt   zjmb_cs_bgk.vc_fqgjqt%TYPE; --父亲国籍其他
    v_vc_mqgjqt   zjmb_cs_bgk.vc_mqgjqt%TYPE; --母亲国籍其他
    v_vc_csddflqt zjmb_cs_bgk.vc_csddflqt%TYPE; --出生地点分类其他
    v_vc_csdd     zjmb_cs_bgk.vc_csdd%TYPE; --出生地点
    v_vc_jsdw     zjmb_cs_bgk.vc_jsdw%TYPE; --接生单位
    v_dt_qfrq     zjmb_cs_bgk.dt_qfrq%TYPE; --签发日期
    v_vc_jsdwszs  zjmb_cs_bgk.vc_jsdwszs%TYPE; --接生单位所在市
    v_vc_jsdwszq  zjmb_cs_bgk.vc_jsdwszq%TYPE; --接生单位所在区
    v_vc_bgkzt    zjmb_cs_bgk.vc_bgkzt%TYPE; --报告卡状态
    v_vc_xxly     zjmb_cs_bgk.vc_xxly%TYPE; --信息来源
    v_vc_sdqr     zjmb_cs_bgk.vc_sdqr%TYPE; --属地确认
    v_vc_hkshfdm  zjmb_cs_bgk.vc_hkshfdm%TYPE; --户口省份代码
    v_vc_sfsw     zjmb_cs_bgk.vc_sfsw%TYPE; --是否死亡
    v_vc_jkdws    zjmb_cs_bgk.vc_jkdws%TYPE; --建卡单位市
    v_vc_jkdwqx   zjmb_cs_bgk.vc_jkdwqx%TYPE; --建卡单位区县
    v_vc_bgkid    zjmb_cs_bgk.vc_bgkid%TYPE; --VC_BGKID
    v_vc_xsrid    zjmb_cs_bgk.vc_xsrid%TYPE; --新生儿姓名
    v_vc_jkdw     zjmb_cs_bgk.vc_jkdw%TYPE; --建卡医院
    v_vc_jkys     zjmb_cs_bgk.vc_jkys%TYPE; --建卡医生
    v_dt_jksj     zjmb_cs_bgk.dt_jksj%TYPE; --建卡时间
    v_vc_xsrxb    zjmb_cs_bgk.vc_xsrxb%TYPE; --新生儿性别
    v_dt_csrq     zjmb_cs_bgk.dt_csrq%TYPE; --出生日期
    v_vc_csyz     zjmb_cs_bgk.vc_csyz%TYPE; --出生孕周
    v_nb_cstz     zjmb_cs_bgk.nb_cstz%TYPE; --出生体重
    v_nb_cssc     zjmb_cs_bgk.nb_cssc%TYPE; --出生身长
    v_vc_csxxdz   zjmb_cs_bgk.vc_csxxdz%TYPE; --出生详细地址
    v_vc_hkd      zjmb_cs_bgk.vc_hkd%TYPE; --接生单位省
    v_vc_jkzt     zjmb_cs_bgk.vc_jkzt%TYPE; --健康状态
    v_vc_mqxm     zjmb_cs_bgk.vc_mqxm%TYPE; --母亲姓名
    v_vc_mqnl     zjmb_cs_bgk.vc_mqnl%TYPE; --母亲年龄
    v_vc_mqgj     zjmb_cs_bgk.vc_mqgj%TYPE; --母亲国籍
    v_vc_mqmz     zjmb_cs_bgk.vc_mqmz%TYPE; --母亲民族
    v_vc_mqsfzbh  zjmb_cs_bgk.vc_mqsfzbh%TYPE; --母亲身份证编号
    v_vc_mqhkszd  zjmb_cs_bgk.vc_mqhkszd%TYPE; --母亲户口所在地
    v_vc_fqxm     zjmb_cs_bgk.vc_fqxm%TYPE; --父亲姓名
    v_vc_fqnl     zjmb_cs_bgk.vc_fqnl%TYPE; --父亲年龄
    v_vc_fqgj     zjmb_cs_bgk.vc_fqgj%TYPE; --父亲国籍
    v_vc_fqmz     zjmb_cs_bgk.vc_fqmz%TYPE; --父亲民族
    v_vc_fqsfzbh  zjmb_cs_bgk.vc_fqsfzbh%TYPE; --父亲身份证编号
    v_vc_fqhkszd  zjmb_cs_bgk.vc_fqhkszd%TYPE; --父亲户口所在地
    v_vc_jtjzdz   zjmb_cs_bgk.vc_jtjzdz%TYPE; --具体居住地址
    v_vc_csddfl   zjmb_cs_bgk.vc_csddfl%TYPE; --出生地点分类
    v_vc_xsrjhrjz zjmb_cs_bgk.vc_xsrjhrjz%TYPE; --新生儿监护人签章
    v_vc_jsrqz    zjmb_cs_bgk.vc_jsrqz%TYPE; --接生人员签字
    v_vc_jsjgmc   zjmb_cs_bgk.vc_jsjgmc%TYPE; --接生机构名称
    v_vc_lxdh     zjmb_cs_bgk.vc_lxdh%TYPE; --联系电话
    v_vc_yzbm     zjmb_cs_bgk.vc_yzbm%TYPE; --邮政编码
    v_vc_csyyjlbh zjmb_cs_bgk.vc_csyyjlbh%TYPE; --出生医院记录编号
    v_vc_mqblh    zjmb_cs_bgk.vc_mqblh%TYPE; --母亲病历号
    v_vc_gldwdm   zjmb_cs_bgk.vc_gldwdm%TYPE; --管理单位代码
    v_vc_czdwdm   zjmb_cs_bgk.vc_czdwdm%TYPE; --创建单位代码
    v_vc_xsrsfch  zjmb_cs_bgk.vc_xsrsfch%TYPE; --新生儿是否存活
    v_dt_swrq     zjmb_cs_bgk.dt_swrq%TYPE; --死亡日期
  
    v_vc_qdm_bgq  zjmb_cs_bgk.vc_qdm%TYPE; --户口区县代码变更前
    v_vc_jddm_bgq zjmb_cs_bgk.vc_jddm%TYPE; --户口街道代码变更前
    v_vc_shbz     zjmb_cs_bgk.vc_shbz%TYPE; --审核标志
  
    v_ywrzid      zjjk_yw_log.id%TYPE; --业务日志id
    v_tab_bgk_old zjmb_cs_bgk%rowtype; --出生报告卡变更前
    v_tab_bgk_new zjmb_cs_bgk%rowtype; --出生报告卡变更后
  
  BEGIN
    json_data(data_in, 'ZJMB_CS_BGK报告卡管理', v_json_data);
    v_sysdate     := sysdate;
    v_czyjgdm     := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyjgjb     := Json_Str(v_Json_Data, 'czyjgjb');
    v_czyyhid     := Json_Str(v_Json_Data, 'czyyhid');
    v_vc_swyy     := Json_Str(v_Json_Data, 'vc_swyy');
    v_vc_bgklb    := Json_Str(v_Json_Data, 'vc_bgklb');
    v_vc_bz       := Json_Str(v_Json_Data, 'vc_bz');
    v_vc_sdm      := Json_Str(v_Json_Data, 'vc_sdm');
    v_vc_qdm      := Json_Str(v_Json_Data, 'vc_qdm');
    v_vc_jddm     := Json_Str(v_Json_Data, 'vc_jddm');
    v_vc_cssdm    := Json_Str(v_Json_Data, 'vc_cssdm');
    v_vc_csqxdm   := Json_Str(v_Json_Data, 'vc_csqxdm');
    v_vc_csjddm   := Json_Str(v_Json_Data, 'vc_csjddm');
    v_vc_cszh     := Json_Str(v_Json_Data, 'vc_cszh');
    v_vc_hkxxdz   := Json_Str(v_Json_Data, 'vc_hkxxdz');
    v_vc_csjw     := Json_Str(v_Json_Data, 'vc_csjw');
    v_vc_hkjw     := Json_Str(v_Json_Data, 'vc_hkjw');
    v_vc_fqgjqt   := Json_Str(v_Json_Data, 'vc_fqgjqt');
    v_vc_mqgjqt   := Json_Str(v_Json_Data, 'vc_mqgjqt');
    v_vc_csddflqt := Json_Str(v_Json_Data, 'vc_csddflqt');
    v_vc_jsdw     := Json_Str(v_Json_Data, 'vc_jsdw');
    v_dt_qfrq     := std(Json_Str(v_Json_Data, 'dt_qfrq'));
    v_vc_jsdwszs  := Json_Str(v_Json_Data, 'vc_jsdwszs');
    v_vc_jsdwszq  := Json_Str(v_Json_Data, 'vc_jsdwszq');
    v_vc_bgkzt    := Json_Str(v_Json_Data, 'vc_bgkzt');
    v_vc_xxly     := Json_Str(v_Json_Data, 'vc_xxly');
    v_vc_sdqr     := Json_Str(v_Json_Data, 'vc_sdqr');
    v_vc_hkshfdm  := Json_Str(v_Json_Data, 'vc_hkshfdm');
    v_vc_sfsw     := Json_Str(v_Json_Data, 'vc_sfsw');
    v_vc_jkdws    := Json_Str(v_Json_Data, 'vc_jkdws');
    v_vc_jkdwqx   := Json_Str(v_Json_Data, 'vc_jkdwqx');
    v_vc_bgkid    := Json_Str(v_Json_Data, 'vc_bgkid');
    v_vc_xsrid    := Json_Str(v_Json_Data, 'vc_xsrid');
    v_vc_jkdw     := Json_Str(v_Json_Data, 'vc_jkdw');
    v_vc_jkys     := Json_Str(v_Json_Data, 'vc_jkys');
    v_dt_jksj     := std(Json_Str(v_Json_Data, 'dt_jksj'));
    v_vc_xsrxb    := Json_Str(v_Json_Data, 'vc_xsrxb');
    v_dt_csrq     := std(Json_Str(v_Json_Data, 'dt_csrq'));
    v_vc_csyz     := Json_Str(v_Json_Data, 'vc_csyz');
    v_nb_cstz     := Json_Str(v_Json_Data, 'nb_cstz');
    v_nb_cssc     := Json_Str(v_Json_Data, 'nb_cssc');
    v_vc_csxxdz   := Json_Str(v_Json_Data, 'vc_csxxdz');
    v_vc_hkd      := Json_Str(v_Json_Data, 'vc_hkd');
    v_vc_jkzt     := Json_Str(v_Json_Data, 'vc_jkzt');
    v_vc_mqxm     := Json_Str(v_Json_Data, 'vc_mqxm');
    v_vc_mqnl     := Json_Str(v_Json_Data, 'vc_mqnl');
    v_vc_mqgj     := Json_Str(v_Json_Data, 'vc_mqgj');
    v_vc_mqmz     := Json_Str(v_Json_Data, 'vc_mqmz');
    v_vc_mqsfzbh  := Json_Str(v_Json_Data, 'vc_mqsfzbh');
    v_vc_mqhkszd  := Json_Str(v_Json_Data, 'vc_mqhkszd');
    v_vc_fqxm     := Json_Str(v_Json_Data, 'vc_fqxm');
    v_vc_fqnl     := Json_Str(v_Json_Data, 'vc_fqnl');
    v_vc_fqgj     := Json_Str(v_Json_Data, 'vc_fqgj');
    v_vc_fqmz     := Json_Str(v_Json_Data, 'vc_fqmz');
    v_vc_fqsfzbh  := Json_Str(v_Json_Data, 'vc_fqsfzbh');
    v_vc_fqhkszd  := Json_Str(v_Json_Data, 'vc_fqhkszd');
    v_vc_jtjzdz   := Json_Str(v_Json_Data, 'vc_jtjzdz');
    v_vc_csddfl   := Json_Str(v_Json_Data, 'vc_csddfl');
    v_vc_xsrjhrjz := Json_Str(v_Json_Data, 'vc_xsrjhrjz');
    v_vc_jsrqz    := Json_Str(v_Json_Data, 'vc_jsrqz');
    v_vc_jsjgmc   := Json_Str(v_Json_Data, 'vc_jsjgmc');
    v_vc_lxdh     := Json_Str(v_Json_Data, 'vc_lxdh');
    v_vc_yzbm     := Json_Str(v_Json_Data, 'vc_yzbm');
    v_vc_csyyjlbh := Json_Str(v_Json_Data, 'vc_csyyjlbh');
    v_vc_mqblh    := Json_Str(v_Json_Data, 'vc_mqblh');
    v_vc_gldwdm   := Json_Str(v_Json_Data, 'vc_gldwdm');
    v_vc_czdwdm   := Json_Str(v_Json_Data, 'vc_czdwdm');
    v_vc_xsrsfch  := Json_Str(v_Json_Data, 'vc_xsrsfch');
    v_dt_swrq     := std(Json_Str(v_Json_Data, 'dt_swrq'));
    v_vc_csdd     := Json_Str(v_Json_Data, 'vc_csdd');
  
    --校验数据合法性
    if v_vc_xsrid is null then
      v_err := '新生儿姓名不能为空!';
      raise err_custom;
    end if;
    if v_vc_xsrxb is null then
      v_err := '新生儿性别不能为空!';
      raise err_custom;
    end if;
    if v_dt_csrq is null then
      v_err := '新生儿出生日期不能为空!';
      raise err_custom;
    end if;
    if v_vc_csyz is null then
      v_err := '新生儿出生孕周不能为空!';
      raise err_custom;
    end if;
    if v_vc_csdd is null then
      v_err := '新生儿出生地省不能为空!';
      raise err_custom;
    end if;
    --出生地浙江省
    if v_vc_csdd = '0' then
      if v_vc_cssdm is null then
        v_err := '新生儿出生地市不能为空!';
        raise err_custom;
      end if;
      if v_vc_csqxdm is null then
        v_err := '新生儿出生地区县不能为空!';
        raise err_custom;
      end if;
      --出生地址填写到区县即可保存
      /*if v_vc_csjddm is null then
        v_err := '新生儿出生地街道不能为空!';
        raise err_custom;
      end if;*/
      --if v_vc_csjw is null then
      --  v_err := '新生儿出生地居委不能为空!';
      --  raise err_custom;
      --end if;
      if substr(v_vc_cssdm, 1, 4) <> substr(v_vc_csqxdm, 1, 4) or
         substr(v_vc_cssdm, 1, 4) <> substr(v_vc_csjddm, 1, 4) then
        v_err := '新生儿出生地区划不匹配!';
        raise err_custom;
      end if;
    end if;
  
    if v_vc_jkzt is null then
      v_err := '新生儿健康状态不能为空!';
      raise err_custom;
    end if;
    if v_vc_hkshfdm is null then
      v_err := '新生儿户口省不能为空!';
      raise err_custom;
    end if;
    --户口浙江省
    if v_vc_hkshfdm = '0' then
      if v_vc_sdm is null then
        v_err := '新生儿户口市不能为空!';
        raise err_custom;
      end if;
      if v_vc_qdm is null then
        v_err := '新生儿户口区县不能为空!';
        raise err_custom;
      end if;
      if v_vc_jddm is null then
        v_err := '新生儿户口街道不能为空!';
        raise err_custom;
      end if;
      --if v_vc_hkjw is null then
      --  v_err := '新生儿户口居委不能为空!';
      --  raise err_custom;
      --end if;
      if substr(v_vc_sdm, 1, 4) <> substr(v_vc_qdm, 1, 4) or
         substr(v_vc_sdm, 1, 4) <> substr(v_vc_jddm, 1, 4) then
        v_err := '新生儿户口区划不匹配!';
        raise err_custom;
      end if;
    end if;
  
    if v_nb_cstz is null then
      v_err := '新生儿体重不能为空!';
      raise err_custom;
    end if;
    if v_nb_cssc is null then
      v_err := '新生儿身长不能为空!';
      raise err_custom;
    end if;
    if v_vc_mqxm is null then
      v_err := '新生儿母亲姓名不能为空!';
      raise err_custom;
    end if;
    if v_vc_mqnl is null then
      v_err := '新生儿母亲年龄不能为空!';
      raise err_custom;
    end if;
/*    if v_vc_fqxm is null then
      v_err := '新生儿父亲姓名不能为空!';
      raise err_custom;
    end if;
    if v_vc_fqnl is null then
      v_err := '新生儿父亲年龄不能为空!';
      raise err_custom;
    end if;*/
    if v_vc_csddfl is null then
      v_err := '新生儿出生地点分类不能为空!';
      raise err_custom;
    end if;
    if v_vc_hkd is null then
      v_err := '新生儿接生单位-省不能为空!';
      raise err_custom;
    end if;
    --接生浙江省
    if v_vc_hkd = '0' then
      if v_vc_jsdwszs is null then
        v_err := '新生儿接生单位市不能为空!';
        raise err_custom;
      end if;
      if v_vc_jsdwszq is null then
        v_err := '新生儿接生单位区县不能为空!';
        raise err_custom;
      end if;
      if v_vc_jsdw is null then
        v_err := '新生儿接生单位单位不能为空!';
        raise err_custom;
      end if;
    end if;
    if v_vc_jkdws is null then
      v_err := '报卡单位市不能为空!';
      raise err_custom;
    end if;
    if v_vc_jkdwqx is null then
      v_err := '报卡单位区县不能为空!';
      raise err_custom;
    end if;
    if v_vc_jkdw is null then
      v_err := '报卡单位不能为空!';
      raise err_custom;
    end if;
    if v_dt_qfrq is null then
      v_err := '签发日期不能为空!';
      raise err_custom;
    end if;
  
    --新增
    if v_vc_bgkid is null then
      --校验新增权限
      if v_czyjgjb <> '4' then
        v_err := '当前机构无新增权限!';
        raise err_custom;
      end if;
      v_ywjl_czlx := '01';
      --获取报告卡id
      if v_vc_hkd = '0' then
        --浙江省
        select fun_getbgkid_cs(v_sysdate, substr(v_czyjgdm, 3))
          into v_vc_bgkid
          from dual;
      else
        --外省
        select fun_getbgkid_cs(v_sysdate, '0000000')
          into v_vc_bgkid
          from dual;
      end if;
      --死亡状态
      if v_vc_jkzt = '4' then
        v_vc_bgkzt := '7';
        v_vc_sfsw  := '1';
      else
        v_vc_bgkzt := '0';
        v_vc_sfsw  := '0';
      end if;
      --属地确认
      if v_vc_jddm is not null then
        select count(1), wm_concat(a.code)
          into v_count, v_vc_gldwdm
          from organ_node a
         where a.removed = 0
           and a.description like '%' || v_vc_jddm || '%';
        if v_count = 1 then
          --确定属地
          v_vc_sdqr := '1';
        else
          v_vc_gldwdm := v_vc_qdm;
          v_vc_sdqr   := '0';
        end if;
      else
        v_vc_sdqr := '1';
      end if;
      --外省
      if v_vc_hkshfdm = '1' then
        v_vc_gldwdm := '99999999';
        v_vc_sdm    := '';
        v_vc_qdm    := '';
        v_vc_jddm   := '';
        v_vc_hkjw   := '';
      end if;
      insert into zjmb_cs_bgk
        (vc_bgkid,
         vc_xsrid,
         vc_jkdw,
         vc_jkys,
         dt_jksj,
         vc_xsrxb,
         dt_csrq,
         vc_csyz,
         nb_cstz,
         nb_cssc,
         vc_csxxdz,
         vc_hkd,
         vc_jkzt,
         vc_mqxm,
         vc_mqnl,
         vc_mqgj,
         vc_mqmz,
         vc_mqsfzbh,
         vc_mqhkszd,
         vc_fqxm,
         vc_fqnl,
         vc_fqgj,
         vc_fqmz,
         vc_fqsfzbh,
         vc_fqhkszd,
         vc_jtjzdz,
         vc_csddfl,
         vc_xsrjhrjz,
         vc_jsrqz,
         vc_jsjgmc,
         vc_lxdh,
         vc_yzbm,
         vc_csyyjlbh,
         vc_mqblh,
         vc_scbz,
         vc_gldwdm,
         vc_czdwdm,
         vc_xsrsfch,
         dt_swrq,
         vc_swyy,
         dt_czsj,
         vc_czyh,
         dt_xgsj,
         vc_xgyh,
         vc_bgklb,
         vc_bz,
         vc_sdm,
         vc_qdm,
         vc_jddm,
         vc_shbz,
         vc_cssdm,
         vc_csqxdm,
         vc_csjddm,
         vc_cszh,
         vc_hkxxdz,
         vc_csjw,
         vc_hkjw,
         vc_fqgjqt,
         vc_mqgjqt,
         vc_csddflqt,
         vc_jsdw,
         dt_qfrq,
         vc_jsdwszs,
         vc_jsdwszq,
         vc_bgkzt,
         vc_xxly,
         vc_sdqr,
         vc_hkshfdm,
         vc_sfsw,
         vc_jkdws,
         vc_jkdwqx,
         dt_yyshsj,
         vc_csdd)
      values
        (v_vc_bgkid,
         v_vc_xsrid,
         v_vc_jkdw,
         v_vc_jkys,
         v_dt_jksj,
         v_vc_xsrxb,
         v_dt_csrq,
         v_vc_csyz,
         v_nb_cstz,
         v_nb_cssc,
         v_vc_csxxdz,
         v_vc_hkd,
         v_vc_jkzt,
         v_vc_mqxm,
         v_vc_mqnl,
         v_vc_mqgj,
         v_vc_mqmz,
         v_vc_mqsfzbh,
         v_vc_mqhkszd,
         v_vc_fqxm,
         v_vc_fqnl,
         v_vc_fqgj,
         v_vc_fqmz,
         v_vc_fqsfzbh,
         v_vc_fqhkszd,
         v_vc_jtjzdz,
         v_vc_csddfl,
         v_vc_xsrjhrjz,
         v_vc_jsrqz,
         v_vc_jsjgmc,
         v_vc_lxdh,
         v_vc_yzbm,
         v_vc_csyyjlbh,
         v_vc_mqblh,
         '2',
         v_vc_gldwdm,
         v_vc_czdwdm,
         v_vc_xsrsfch,
         v_dt_swrq,
         v_vc_swyy,
         v_sysdate,
         v_czyyhid,
         v_sysdate,
         v_czyyhid,
         v_vc_bgklb,
         v_vc_bz,
         v_vc_sdm,
         v_vc_qdm,
         v_vc_jddm,
         '1',
         v_vc_cssdm,
         v_vc_csqxdm,
         v_vc_csjddm,
         v_vc_cszh,
         v_vc_hkxxdz,
         v_vc_csjw,
         v_vc_hkjw,
         v_vc_fqgjqt,
         v_vc_mqgjqt,
         v_vc_csddflqt,
         v_vc_jsdw,
         v_dt_qfrq,
         v_vc_jsdwszs,
         v_vc_jsdwszq,
         v_vc_bgkzt,
         v_vc_xxly,
         v_vc_sdqr,
         v_vc_hkshfdm,
         v_vc_sfsw,
         v_vc_jkdws,
         v_vc_jkdwqx,
         v_sysdate,
         v_vc_csdd);
    
    else
      v_ywjl_czlx := '02';
      --修改
      begin
        select a.vc_shbz,
               a.vc_jddm,
               a.vc_qdm,
               a.vc_gldwdm,
               a.vc_sdqr,
               vc_bgkzt
          into v_vc_shbz,
               v_vc_jddm_bgq,
               v_vc_qdm_bgq,
               v_vc_gldwdm,
               v_vc_sdqr,
               v_vc_bgkzt
          from zjmb_cs_bgk a
         where a.vc_bgkid = v_vc_bgkid
           and a.vc_scbz = '2';
      exception
        when no_data_found then
          v_err := 'id[' || v_vc_bgkid || ']未获取到有效报告卡信息!';
          raise err_custom;
      end;
      --校验管理单位审核权限
      if v_czyjgjb = '3' then
        if substr(v_vc_gldwdm, 1, 6) <> substr(v_czyjgdm, 1, 6) and v_vc_gldwdm <> '99999999' then
          v_err := '非管理单位无此操作权限!';
          raise err_custom;
        end if;
      end if;
      if v_czyjgjb = '4' then
        --医院社区
        if v_vc_shbz = '3' then
          v_err := '该报卡已区县审核通过，当前机构无权修改!';
          raise err_custom;
        end if;
        --审核不通过
        if v_vc_shbz in ('0', '2', '4') then
          --修改为审核通过
          v_vc_shbz := '1';
        end if;
        --修改了户籍地址
        if v_vc_qdm_bgq <> v_vc_qdm or v_vc_jddm_bgq <> v_vc_jddm then
          --审核状态改为医院通过
          v_vc_shbz := '1';
          select count(1), wm_concat(a.code)
            into v_count, v_vc_gldwdm
            from organ_node a
           where a.removed = 0
             and a.description like '%' || v_vc_jddm || '%';
          if v_count = 1 then
            --确定属地
            v_vc_sdqr := '1';
          else
            v_vc_gldwdm := v_vc_qdm;
            v_vc_sdqr   := '0';
          end if;
          --外省
          if v_vc_hkshfdm = '1' then
            v_vc_gldwdm := '99999999';
            v_vc_sdm    := '';
            v_vc_qdm    := '';
            v_vc_jddm   := '';
            v_vc_hkjw   := '';
          end if;
        end if;
      elsif v_czyjgjb = '3' then
        --区县修改
        v_vc_shbz := '3';
        --修改了户籍地址
        if v_vc_qdm_bgq <> v_vc_qdm or v_vc_jddm_bgq <> v_vc_jddm then
          select count(1), wm_concat(a.code)
            into v_count, v_vc_gldwdm
            from organ_node a
           where a.removed = 0
             and a.description like '%' || v_vc_jddm || '%';
          if v_count = 1 then
            --确定属地
            v_vc_sdqr := '1';
          else
            v_vc_gldwdm := v_vc_qdm;
            v_vc_sdqr   := '0';
          end if;
          --外省
          if v_vc_hkshfdm = '1' then
            v_vc_gldwdm := '99999999';
            v_vc_sdm    := '';
            v_vc_qdm    := '';
            v_vc_jddm   := '';
            v_vc_hkjw   := '';
          end if;
        end if;
      else
        --非区县
        v_err := '当前机构无修改权限!';
        raise err_custom;
      end if;
      --死亡状态
      if v_vc_jkzt = '4' then
        v_vc_bgkzt := '7';
        v_vc_sfsw  := '1';
      else
        v_vc_bgkzt := '0';
        v_vc_sfsw  := '0';
      end if;
      --获取变更前信息
      select *
        into v_tab_bgk_old
        from ZJMB_CS_BGK
       where vc_bgkid = v_vc_bgkid;
      --修改报卡信息
      update ZJMB_CS_BGK a
         set vc_xsrid    = v_vc_xsrid,
             vc_jkys     = v_vc_jkys,
             dt_jksj     = v_dt_jksj,
             vc_xsrxb    = v_vc_xsrxb,
             dt_csrq     = v_dt_csrq,
             vc_csyz     = v_vc_csyz,
             vc_csdd     = v_vc_csdd,
             nb_cstz     = v_nb_cstz,
             nb_cssc     = v_nb_cssc,
             vc_csxxdz   = v_vc_csxxdz,
             vc_hkd      = v_vc_hkd,
             vc_jkzt     = v_vc_jkzt,
             vc_mqxm     = v_vc_mqxm,
             vc_mqnl     = v_vc_mqnl,
             vc_mqgj     = v_vc_mqgj,
             vc_mqmz     = v_vc_mqmz,
             vc_mqsfzbh  = v_vc_mqsfzbh,
             vc_mqhkszd  = v_vc_mqhkszd,
             vc_fqxm     = v_vc_fqxm,
             vc_fqnl     = v_vc_fqnl,
             vc_fqgj     = v_vc_fqgj,
             vc_fqmz     = v_vc_fqmz,
             vc_fqsfzbh  = v_vc_fqsfzbh,
             vc_fqhkszd  = v_vc_fqhkszd,
             vc_jtjzdz   = v_vc_jtjzdz,
             vc_csddfl   = v_vc_csddfl,
             vc_xsrjhrjz = v_vc_xsrjhrjz,
             vc_jsrqz    = v_vc_jsrqz,
             vc_jsjgmc   = v_vc_jsjgmc,
             vc_lxdh     = v_vc_lxdh,
             vc_yzbm     = v_vc_yzbm,
             vc_csyyjlbh = v_vc_csyyjlbh,
             vc_mqblh    = v_vc_mqblh,
             vc_gldwdm   = v_vc_gldwdm,
             vc_czdwdm   = v_vc_czdwdm,
             vc_xsrsfch  = v_vc_xsrsfch,
             dt_swrq     = v_dt_swrq,
             vc_swyy     = v_vc_swyy,
             dt_xgsj     = v_sysdate,
             vc_xgyh     = v_czyyhid,
             vc_bgklb    = v_vc_bgklb,
             vc_bz       = v_vc_bz,
             vc_sdm      = v_vc_sdm,
             vc_qdm      = v_vc_qdm,
             vc_jddm     = v_vc_jddm,
             vc_shbz     = v_vc_shbz,
             vc_cssdm    = v_vc_cssdm,
             vc_csqxdm   = v_vc_csqxdm,
             vc_csjddm   = v_vc_csjddm,
             vc_cszh     = v_vc_cszh,
             vc_hkxxdz   = v_vc_hkxxdz,
             vc_csjw     = v_vc_csjw,
             vc_hkjw     = v_vc_hkjw,
             vc_fqgjqt   = v_vc_fqgjqt,
             vc_mqgjqt   = v_vc_mqgjqt,
             vc_csddflqt = v_vc_csddflqt,
             vc_jsdw     = v_vc_jsdw,
             dt_qfrq     = v_dt_qfrq,
             vc_jsdwszs  = v_vc_jsdwszs,
             vc_jsdwszq  = v_vc_jsdwszq,
             vc_bgkzt    = v_vc_bgkzt,
             vc_xxly     = v_vc_xxly,
             vc_sdqr     = v_vc_sdqr,
             vc_hkshfdm  = v_vc_hkshfdm,
             vc_sfsw     = v_vc_sfsw,
             dt_qxshsj = case
                           when v_vc_shbz = '3' and dt_qxshsj is null then
                            v_sysdate
                           else
                            dt_qxshsj
                         end
       where vc_bgkid = v_vc_bgkid;
      --记录报卡变更日志
      v_ywrzid := sys_guid();
      --获取变更后信息
      select *
        into v_tab_bgk_new
        from ZJMB_CS_BGK
       where vc_bgkid = v_vc_bgkid;
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'vc_xsrid',
                                         '新生儿姓名',
                                         v_tab_bgk_old.vc_xsrid,
                                         v_tab_bgk_new.vc_xsrid,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'vc_jkys',
                                         '建卡医生',
                                         v_tab_bgk_old.vc_jkys,
                                         v_tab_bgk_new.vc_jkys,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'dt_jksj',
                                         '建卡时间',
                                         dts(v_tab_bgk_old.dt_jksj, 0),
                                         dts(v_tab_bgk_new.dt_jksj, 0),
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'vc_xsrxb',
                                         '性别',
                                         v_tab_bgk_old.vc_xsrxb,
                                         v_tab_bgk_new.vc_xsrxb,
                                         'C_COMM_XB',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'dt_csrq',
                                         '出生日期',
                                         dts(v_tab_bgk_old.dt_csrq, 0),
                                         dts(v_tab_bgk_new.dt_csrq, 0),
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'vc_csyz',
                                         '出生孕周',
                                         v_tab_bgk_old.vc_csyz,
                                         v_tab_bgk_new.vc_csyz,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'vc_csdd',
                                         '出生地',
                                         v_tab_bgk_old.vc_csdd,
                                         v_tab_bgk_new.vc_csdd,
                                         'C_ZJMB_CSDFL',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'nb_cstz',
                                         '出生体重',
                                         v_tab_bgk_old.nb_cstz,
                                         v_tab_bgk_new.nb_cstz,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'nb_cssc',
                                         '出生身长',
                                         v_tab_bgk_old.nb_cssc,
                                         v_tab_bgk_new.nb_cssc,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'vc_csxxdz',
                                         '出生详细地址',
                                         v_tab_bgk_old.vc_csxxdz,
                                         v_tab_bgk_new.vc_csxxdz,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'vc_hkd',
                                         '接生单位省',
                                         v_tab_bgk_old.vc_hkd,
                                         v_tab_bgk_new.vc_hkd,
                                         'C_COMM_SHEDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'vc_jkzt',
                                         '健康状态',
                                         v_tab_bgk_old.vc_jkzt,
                                         v_tab_bgk_new.vc_jkzt,
                                         'C_ZJMB_JKZK',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'vc_mqxm',
                                         '母亲姓名',
                                         v_tab_bgk_old.vc_mqxm,
                                         v_tab_bgk_new.vc_mqxm,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'vc_mqnl',
                                         '母亲年龄',
                                         v_tab_bgk_old.vc_mqnl,
                                         v_tab_bgk_new.vc_mqnl,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'vc_mqgj',
                                         '母亲国籍',
                                         v_tab_bgk_old.vc_mqgj,
                                         v_tab_bgk_new.vc_mqgj,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'vc_mqmz',
                                         '母亲民族',
                                         v_tab_bgk_old.vc_mqmz,
                                         v_tab_bgk_new.vc_mqmz,
                                         'C_COMM_MZ',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'vc_mqsfzbh',
                                         '母亲身份证编号',
                                         v_tab_bgk_old.vc_mqsfzbh,
                                         v_tab_bgk_new.vc_mqsfzbh,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'vc_mqhkszd',
                                         '母亲户口地址',
                                         v_tab_bgk_old.vc_mqhkszd,
                                         v_tab_bgk_new.vc_mqhkszd,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'vc_fqxm',
                                         '父亲姓名',
                                         v_tab_bgk_old.vc_fqxm,
                                         v_tab_bgk_new.vc_fqxm,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'vc_fqnl',
                                         '父亲年龄',
                                         v_tab_bgk_old.vc_fqnl,
                                         v_tab_bgk_new.vc_fqnl,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'vc_fqgj',
                                         '父亲国籍',
                                         v_tab_bgk_old.vc_fqgj,
                                         v_tab_bgk_new.vc_fqgj,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'vc_fqmz',
                                         '父亲民族',
                                         v_tab_bgk_old.vc_fqmz,
                                         v_tab_bgk_new.vc_fqmz,
                                         'C_COMM_MZ',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'vc_fqsfzbh',
                                         '父亲证件号码',
                                         v_tab_bgk_old.vc_fqsfzbh,
                                         v_tab_bgk_new.vc_fqsfzbh,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'vc_fqhkszd',
                                         '父亲户口地址',
                                         v_tab_bgk_old.vc_fqhkszd,
                                         v_tab_bgk_new.vc_fqhkszd,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'vc_jtjzdz',
                                         '具体居住地址',
                                         v_tab_bgk_old.vc_jtjzdz,
                                         v_tab_bgk_new.vc_jtjzdz,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'vc_csddfl',
                                         '出生地分类',
                                         v_tab_bgk_old.vc_csddfl,
                                         v_tab_bgk_new.vc_csddfl,
                                         'C_ZJMB_CSDFL',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'vc_xsrjhrjz',
                                         '新生儿监护人',
                                         v_tab_bgk_old.vc_xsrjhrjz,
                                         v_tab_bgk_new.vc_xsrjhrjz,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'vc_jsrqz',
                                         '接生人员',
                                         v_tab_bgk_old.vc_jsrqz,
                                         v_tab_bgk_new.vc_jsrqz,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'vc_jsjgmc',
                                         '接生机构名称',
                                         v_tab_bgk_old.vc_jsjgmc,
                                         v_tab_bgk_new.vc_jsjgmc,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'vc_lxdh',
                                         '联系电话',
                                         v_tab_bgk_old.vc_lxdh,
                                         v_tab_bgk_new.vc_lxdh,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'vc_yzbm',
                                         '邮政编码',
                                         v_tab_bgk_old.vc_yzbm,
                                         v_tab_bgk_new.vc_yzbm,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'vc_csyyjlbh',
                                         '出生医院记录编号',
                                         v_tab_bgk_old.vc_csyyjlbh,
                                         v_tab_bgk_new.vc_csyyjlbh,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'vc_mqblh',
                                         '母亲病历号',
                                         v_tab_bgk_old.vc_mqblh,
                                         v_tab_bgk_new.vc_mqblh,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'vc_gldwdm',
                                         '管理单位',
                                         v_tab_bgk_old.vc_gldwdm,
                                         v_tab_bgk_new.vc_gldwdm,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'vc_czdwdm',
                                         '创建单位代码',
                                         v_tab_bgk_old.vc_czdwdm,
                                         v_tab_bgk_new.vc_czdwdm,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'vc_xsrsfch',
                                         '新生儿是否存活',
                                         v_tab_bgk_old.vc_xsrsfch,
                                         v_tab_bgk_new.vc_xsrsfch,
                                         'C_COMM_SF',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'dt_swrq',
                                         '死亡日期',
                                         dts(v_tab_bgk_old.dt_swrq, 0),
                                         dts(v_tab_bgk_new.dt_swrq, 0),
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'vc_swyy',
                                         '死亡原因',
                                         v_tab_bgk_old.vc_swyy,
                                         v_tab_bgk_new.vc_swyy,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'vc_bgklb',
                                         '报告卡类别',
                                         v_tab_bgk_old.vc_bgklb,
                                         v_tab_bgk_new.vc_bgklb,
                                         'C_COMM_BGKLX',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'vc_bz',
                                         '备注',
                                         v_tab_bgk_old.vc_bz,
                                         v_tab_bgk_new.vc_bz,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'vc_sdm',
                                         '户口市',
                                         v_tab_bgk_old.vc_sdm,
                                         v_tab_bgk_new.vc_sdm,
                                         'P_XZDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'vc_qdm',
                                         '户口区县',
                                         v_tab_bgk_old.vc_qdm,
                                         v_tab_bgk_new.vc_qdm,
                                         'P_XZDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'vc_jddm',
                                         '户口街道',
                                         v_tab_bgk_old.vc_jddm,
                                         v_tab_bgk_new.vc_jddm,
                                         'P_XZDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'vc_shbz',
                                         '审核标志',
                                         v_tab_bgk_old.vc_shbz,
                                         v_tab_bgk_new.vc_shbz,
                                         'C_COMM_SHZT',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'vc_cssdm',
                                         '出生市代码',
                                         v_tab_bgk_old.vc_cssdm,
                                         v_tab_bgk_new.vc_cssdm,
                                         'P_XZDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'vc_csqxdm',
                                         '出生区县代码',
                                         v_tab_bgk_old.vc_csqxdm,
                                         v_tab_bgk_new.vc_csqxdm,
                                         'P_XZDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'vc_csjddm',
                                         '出生街道代码',
                                         v_tab_bgk_old.vc_csjddm,
                                         v_tab_bgk_new.vc_csjddm,
                                         'P_XZDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'vc_cszh',
                                         '出生证号',
                                         v_tab_bgk_old.vc_cszh,
                                         v_tab_bgk_new.vc_cszh,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'vc_hkxxdz',
                                         '户口详细地址',
                                         v_tab_bgk_old.vc_hkxxdz,
                                         v_tab_bgk_new.vc_hkxxdz,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'vc_csjw',
                                         '出生居委',
                                         v_tab_bgk_old.vc_csjw,
                                         v_tab_bgk_new.vc_csjw,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'vc_hkjw',
                                         '户口居委',
                                         v_tab_bgk_old.vc_hkjw,
                                         v_tab_bgk_new.vc_hkjw,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'vc_fqgjqt',
                                         '父亲其他国籍',
                                         v_tab_bgk_old.vc_fqgjqt,
                                         v_tab_bgk_new.vc_fqgjqt,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'vc_jddm',
                                         '母亲其他国籍',
                                         v_tab_bgk_old.vc_mqgjqt,
                                         v_tab_bgk_new.vc_mqgjqt,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'vc_csddflqt',
                                         '出生地其他分类',
                                         v_tab_bgk_old.vc_csddflqt,
                                         v_tab_bgk_new.vc_csddflqt,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'vc_jsdw',
                                         '接生单位',
                                         v_tab_bgk_old.vc_jsdw,
                                         v_tab_bgk_new.vc_jsdw,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'dt_qfrq',
                                         '签发日期',
                                         dts(v_tab_bgk_old.dt_qfrq, 0),
                                         dts(v_tab_bgk_new.dt_qfrq, 0),
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'vc_jsdwszs',
                                         '接生单位市',
                                         v_tab_bgk_old.vc_jsdwszs,
                                         v_tab_bgk_new.vc_jsdwszs,
                                         'P_XZDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'vc_jsdwszq',
                                         '接生单位区县',
                                         v_tab_bgk_old.vc_jsdwszq,
                                         v_tab_bgk_new.vc_jsdwszq,
                                         'P_XZDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'vc_bgkzt',
                                         '报告卡状态',
                                         v_tab_bgk_old.vc_bgkzt,
                                         v_tab_bgk_new.vc_bgkzt,
                                         'C_COMM_BGKZT',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'vc_xxly',
                                         '信息来源',
                                         v_tab_bgk_old.vc_xxly,
                                         v_tab_bgk_new.vc_xxly,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'vc_sdqr',
                                         '属地确认',
                                         v_tab_bgk_old.vc_sdqr,
                                         v_tab_bgk_new.vc_sdqr,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'vc_hkshfdm',
                                         '户口省代码',
                                         v_tab_bgk_old.vc_hkshfdm,
                                         v_tab_bgk_new.vc_hkshfdm,
                                         'C_COMM_SHEDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'vc_sfsw',
                                         '是否死亡',
                                         v_tab_bgk_old.vc_sfsw,
                                         v_tab_bgk_new.vc_sfsw,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '04',
                                         'dt_qxshsj',
                                         '区县审核时间',
                                         v_tab_bgk_old.dt_qxshsj,
                                         v_tab_bgk_new.dt_qxshsj,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
    end if;
    --添加操作日志
    v_json_yw_log := Json_ext.get_json(v_json_data, 'ywjllog');
    if v_json_yw_log is not null then
      v_json_yw_log.put('ywrzid', v_ywrzid);
      v_json_yw_log.put('bgkid', v_vc_bgkid);
      v_json_yw_log.put('bgklx', '04');
      v_json_yw_log.put('ywjlid', v_vc_bgkid);
      v_json_yw_log.put('gnmk', '01');
      v_json_yw_log.put('gnmc', '报卡管理');
      v_json_yw_log.put('czlx', v_ywjl_czlx);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_update(v_json_yw_log, v_err);
      if v_err is not null then
        raise err_custom;
      end if;
    end if;
    --返回
    v_Json_Return.put('id', v_vc_bgkid);
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_cs_bgk_update;
  /*--------------------------------------------------------------------------
  || 功能描述 ：出生报告卡删除
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_cs_bgk_sc(Data_In    In Clob, --入参
                          result_out OUT VARCHAR2) --返回
   is
    v_json_data   json;
    v_json_yw_log json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
    --公共变量
    v_sysdate   date;
    v_czyjgdm   varchar2(50);
    v_czyjgjb   varchar2(3);
    v_bkid      zjmb_cs_bgk.vc_bgkid%type;
    v_scbz      zjmb_cs_bgk.vc_scbz%TYPE; --删除标志
    v_vc_gldwdm zjmb_cs_bgk.vc_gldwdm%TYPE; --删除标志
  BEGIN
    json_data(data_in, 'zjmb_cs_bgk删除', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    --获取机构级别
    --select fun_getczyjgjb(v_czyjgdm) into v_czyjgjb from dual;
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    v_bkid    := Json_Str(v_Json_Data, 'vc_bgkid');
    --获取报卡状态
    begin
      select vc_scbz, vc_gldwdm
        into v_scbz, v_vc_gldwdm
        from zjmb_cs_bgk
       where vc_bgkid = v_bkid
         and vc_scbz = '2';
    exception
      when no_data_found then
        v_err := 'id[' || v_bkid || ']未获取到有效报告卡信息!';
        raise err_custom;
    end;
    --校验管理单位审核权限
    if v_czyjgjb = '3' then
      if substr(v_vc_gldwdm, 1, 6) <> substr(v_czyjgdm, 1, 6) then
        v_err := '非管理单位无此操作权限!';
        raise err_custom;
      end if;
    end if;
    if v_czyjgjb <> '4' and v_czyjgjb <> '3' then
      --非区县
      v_err := '当前机构无删除权限!';
      raise err_custom;
    end if;
    --更新删除标志
    update zjmb_cs_bgk
       set vc_scbz = '1', vc_bgkzt = '5'
     where vc_bgkid = v_bkid;
    --添加操作日志
    v_json_yw_log := Json_ext.get_json(v_json_data, 'ywjllog');
    if v_json_yw_log is not null then
      v_json_yw_log.put('bgkid', v_bkid);
      v_json_yw_log.put('bgklx', '04');
      v_json_yw_log.put('ywjlid', v_bkid);
      v_json_yw_log.put('gnmk', '01');
      v_json_yw_log.put('gnmc', '报卡管理');
      v_json_yw_log.put('czlx', '04');
      pkg_zjmb_xtfz.prc_zjjk_yw_log_update(v_json_yw_log, v_err);
      if v_err is not null then
        raise err_custom;
      end if;
    end if;
    v_Json_Return.put('id', v_bkid);
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_cs_bgk_sc;
  /*--------------------------------------------------------------------------
  || 功能描述 ：出生报告卡审核
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_cs_bgk_sh(Data_In    In Clob, --入参
                          result_out OUT VARCHAR2) --返回
   is
    v_json_data   json;
    v_json_yw_log json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
    --公共变量
    v_sysdate    date;
    v_czyjgdm    varchar2(50);
    v_czyjgjb    varchar2(3);
    v_shbz       zjmb_cs_bgk.vc_shbz%TYPE; --审核状态
    v_shbz_table zjmb_cs_bgk.vc_shbz%TYPE; --审核状态
    v_bkid       zjmb_cs_bgk.vc_bgkid%type;
    v_shwtgyy    zjmb_cs_bgk.vc_shwtgyy%TYPE; --区县审核未通过原因
    v_shwtgyy1   zjmb_cs_bgk.vc_shwtgyy1%TYPE; --区县审核未通过原因选项
    v_vc_gldwdm  zjmb_cs_bgk.vc_gldwdm%TYPE;
  BEGIN
    json_data(data_in, 'zjmb_cs_bgk审核', v_json_data);
    v_sysdate  := sysdate;
    v_czyjgdm  := Json_Str(v_Json_Data, 'czyjgdm');
    v_bkid     := Json_Str(v_Json_Data, 'vc_bgkid');
    v_shbz     := Json_Str(v_Json_Data, 'vc_shbz');
    v_shwtgyy  := Json_Str(v_Json_Data, 'vc_shwtgyy');
    v_shwtgyy1 := Json_Str(v_Json_Data, 'vc_shwtgyy1');
    --获取机构级别
    --select fun_getczyjgjb(v_czyjgdm) into v_czyjgjb from dual;
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    --获取报卡状态
    begin
      select vc_shbz, vc_gldwdm
        into v_shbz_table, v_vc_gldwdm
        from zjmb_cs_bgk
       where vc_bgkid = v_bkid
         and vc_scbz = '2'
         and vc_shbz = '1';
    exception
      when no_data_found then
        v_err := 'id[' || v_bkid || ']未获取到有效报告卡信息!';
        raise err_custom;
    end;
    --校验管理单位审核权限
    if v_czyjgjb = '3' then
      if substr(v_vc_gldwdm, 1, 6) <> substr(v_czyjgdm, 1, 6) then
        v_err := '非管理单位无此操作权限!';
        raise err_custom;
      end if;
    end if;
    if v_czyjgjb <> '3' then
      --非区县
      v_err := '当前机构无审核权限!';
      raise err_custom;
    end if;
    --v_shbz_table := '1';
    if v_shbz_table <> '1' then
      v_err := '报卡当前状态不为区县待审核!';
      raise err_custom;
    end if;
    --判断审核状态
    if v_shbz = '3' then
      v_shwtgyy  := '';
      v_shwtgyy1 := '';
    elsif v_shbz = '4' then
      if v_shwtgyy1 is NULL then
        v_err := '审核不通过原因不能为空';
        raise err_custom;
      end if;
    else
      v_err := '传入审核状态[' || v_shbz || ']不正确!';
      raise err_custom;
    end if;
    --更新审核标志
    update zjmb_cs_bgk
       set vc_shbz     = v_shbz,
           vc_shwtgyy  = v_shwtgyy,
           vc_shwtgyy1 = v_shwtgyy1,
           dt_qxshsj   = v_sysdate
     where vc_bgkid = v_bkid;
    --添加操作日志
    v_json_yw_log := Json_ext.get_json(v_json_data, 'ywjllog');
    if v_json_yw_log is not null then
      v_json_yw_log.put('bgkid', v_bkid);
      v_json_yw_log.put('bgklx', '04');
      v_json_yw_log.put('ywjlid', v_bkid);
      v_json_yw_log.put('gnmk', '01');
      v_json_yw_log.put('gnmc', '报卡管理');
      v_json_yw_log.put('czlx', '03');
      pkg_zjmb_xtfz.prc_zjjk_yw_log_update(v_json_yw_log, v_err);
      if v_err is not null then
        raise err_custom;
      end if;
    end if;
    v_Json_Return.put('id', v_bkid);
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_cs_bgk_sh;
  /*--------------------------------------------------------------------------
  || 功能描述 ：获取出生报告卡id
  ||------------------------------------------------------------------------*/
  FUNCTION fun_getbgkid_cs(prm_date date, prm_dwm VARCHAR2) --创建单位后7位
   RETURN VARCHAR2 is
    v_dm VARCHAR2(30);
    v_id VARCHAR2(30);
    v_yy varchar2(2);
  begin
    if prm_date is null or prm_dwm is null then
      return '';
    end if;
    v_yy := to_char(prm_date, 'yy');
    v_dm := v_yy || prm_dwm;
    select nvl(max(VC_BGKID) + 1, v_dm || '00001')
      into v_id
      from ZJMB_CS_BGK
     where vc_bgkid like v_dm || '%';
    return v_id;
  END fun_getbgkid_cs;
  /*--------------------------------------------------------------------------
  || 功能描述 ：出生报告卡属地确认
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_cs_bgk_sdqr(Data_In    In Clob, --入参
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
    v_czyjgjb varchar2(3);
    v_bkid    zjmb_sw_bgk.vc_bgkid%type;
    v_gldwdm  zjmb_sw_bgk.vc_gldwdm%type;
    v_count   number;
  BEGIN
    json_data(data_in, 'zjmb_cs_bgk属地确认', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_bkid    := Json_Str(v_Json_Data, 'vc_bgkid');
    v_gldwdm  := Json_Str(v_Json_Data, 'vc_gldwdm');
    --获取机构级别
    --select fun_getczyjgjb(v_czyjgdm) into v_czyjgjb from dual;
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    if v_czyjgjb not in ('3', '4') then
      v_err := '当前机构无属地确认权限!';
      raise err_custom;
    end if;
    if v_gldwdm is null then
      v_err := '管理单位不能为空!';
      raise err_custom;
    end if;
    --判断管理单位与户籍街道是否匹配
    select count(1)
      into v_count
      from zjmb_cs_bgk a, organ_node c
     where c.description like '%' || a.vc_jddm || '%'
       and c.code = v_gldwdm
       and c.removed = 0
       and a.vc_bgkid = v_bkid;
    if v_count <> 1 then
      v_err := '管理单位与户籍街道不匹配!';
      raise err_custom;
    end if;
    --修改管理单位
    update zjmb_cs_bgk a
       set a.vc_gldwdm = v_gldwdm, a.vc_sdqr = '1'
     where a.vc_scbz = '2'
       and a.vc_shbz = '3'
       and a.vc_bgkid = v_bkid
       and a.vc_sdqr = '0';
    if sql%rowcount <> 1 then
      v_err := 'id[' || v_bkid || ']未获取到有效报的待属地确认的告卡信息!';
      raise err_custom;
    end if;
    --添加操作日志
    v_json_yw_log := Json_ext.get_json(v_json_data, 'ywjllog');
    if v_json_yw_log is not null then
      v_json_yw_log.put('bgkid', v_bkid);
      v_json_yw_log.put('bgklx', '04');
      v_json_yw_log.put('ywjlid', v_bkid);
      v_json_yw_log.put('gnmk', '01');
      v_json_yw_log.put('gnmc', '报卡管理');
      v_json_yw_log.put('czlx', '03');
      pkg_zjmb_xtfz.prc_zjjk_yw_log_update(v_json_yw_log, v_err);
      if v_err is not null then
        raise err_custom;
      end if;
    end if;
    v_Json_Return.put('id', v_bkid);
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_cs_bgk_sdqr;
  /*--------------------------------------------------------------------------
  || 功能描述 ：伤害监测新增或修改
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_shjc_bgk_update(Data_In    In Clob, --入参
                                result_out OUT VARCHAR2) --返回
   is
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err         VARCHAR2(2000);
    v_json_yw_log json;
    v_ywjl_czlx   varchar2(3);
    --公共变量
    v_sysdate date;
    v_czyjgjb varchar2(3);
    v_czyjgdm varchar2(50);
    v_czyjgmc varchar2(200);
    v_czyyhid varchar2(50);
    v_count   number;
  
    v_vc_jksdm        zjmb_shjc_bgk.vc_jksdm%TYPE; --建卡市代码
    v_vc_jkqxdm       zjmb_shjc_bgk.vc_jkqxdm%TYPE; --建卡区县代码
    v_vc_sfgy         zjmb_shjc_bgk.vc_sfgy%TYPE; --是否故意
    v_vc_jj           zjmb_shjc_bgk.vc_jj%TYPE; --结局
    v_vc_sszjtgj      zjmb_shjc_bgk.vc_sszjtgj%TYPE; --受伤者交通工具
    v_vc_sszjtgjqt    zjmb_shjc_bgk.vc_sszjtgjqt%TYPE; --受伤者交通工具其它
    v_vc_sszqk        zjmb_shjc_bgk.vc_sszqk%TYPE; --受伤者情况
    v_vc_sszqkqt      zjmb_shjc_bgk.vc_sszqkqt%TYPE; --受伤者情况其它
    v_vc_sszhsmfspz   zjmb_shjc_bgk.vc_sszhsmfspz%TYPE; --受伤者和什么发生碰撞
    v_vc_sszhsmfspzqt zjmb_shjc_bgk.vc_sszhsmfspzqt%TYPE; --受伤者和什么发生碰撞其它
    v_vc_czjdcsszdwz  zjmb_shjc_bgk.vc_czjdcsszdwz%TYPE; --乘坐机动车受伤者的位置
    v_vc_zwywanqd     zjmb_shjc_bgk.vc_zwywanqd%TYPE; --座位有无安全带
    v_vc_anqdsy       zjmb_shjc_bgk.vc_anqdsy%TYPE; --安全带使用
    v_vc_ywbhzz       zjmb_shjc_bgk.vc_ywbhzz%TYPE; --有无保护装置
    v_vc_bhzzsy       zjmb_shjc_bgk.vc_bhzzsy%TYPE; --保护装置使用
    v_vc_zyxgys       zjmb_shjc_bgk.vc_zyxgys%TYPE; --主要相关因素
    v_vc_zyxgysqt     zjmb_shjc_bgk.vc_zyxgysqt%TYPE; --主要相关因素其它
    v_vc_yqzsfsdcs    zjmb_shjc_bgk.vc_yqzsfsdcs%TYPE; --以前自伤发生的次数
    v_vc_shqy         zjmb_shjc_bgk.vc_shqy%TYPE; --伤害起因
    v_vc_shqyqt       zjmb_shjc_bgk.vc_shqyqt%TYPE; --伤害起因其它
    v_vc_sszysrgx     zjmb_shjc_bgk.vc_sszysrgx%TYPE; --受伤者与伤人者之间的关系
    v_vc_sszysrgxqt   zjmb_shjc_bgk.vc_sszysrgxqt%TYPE; --受伤者与伤人者之间的关系其它
    v_vc_sygj         zjmb_shjc_bgk.vc_sygj%TYPE; --使用工具
    v_vc_sygjqt       zjmb_shjc_bgk.vc_sygjqt%TYPE; --使用工具其它
    v_vc_shxz1        zjmb_shjc_bgk.vc_shxz1%TYPE; --伤害性质最严重
    v_vc_ssbw1        zjmb_shjc_bgk.vc_ssbw1%TYPE; --受伤部位最严重
    v_vc_qsx          zjmb_shjc_bgk.vc_qsx%TYPE; --全身性
    v_vc_tb           zjmb_shjc_bgk.vc_tb%TYPE; --头部
    v_vc_xz           zjmb_shjc_bgk.vc_xz%TYPE; --下肢
    v_vc_rzzs         zjmb_shjc_bgk.vc_rzzs%TYPE; --软组织伤
    v_vc_ggj          zjmb_shjc_bgk.vc_ggj%TYPE; --骨/关节
    v_vc_sz           zjmb_shjc_bgk.vc_sz%TYPE; --上肢
    v_vc_qg           zjmb_shjc_bgk.vc_qg%TYPE; --躯干
    v_vc_hxd          zjmb_shjc_bgk.vc_hxd%TYPE; --呼吸道
    v_vc_xhd          zjmb_shjc_bgk.vc_xhd%TYPE; --消化道
    v_vc_sjxt         zjmb_shjc_bgk.vc_sjxt%TYPE; --神经系统
    v_vc_sjzy         zjmb_shjc_bgk.vc_sjzy%TYPE; --事件摘要
    v_vc_shwbyy       zjmb_shjc_bgk.vc_shwbyy%TYPE; --伤害外部原因编码
    v_vc_hzjzkb       zjmb_shjc_bgk.vc_hzjzkb%TYPE; --患者就诊科别
    v_vc_txyshs       zjmb_shjc_bgk.vc_txyshs%TYPE; --填写医生/护士
    v_vc_shbz         zjmb_shjc_bgk.vc_shbz%TYPE; --审核标志
    v_dt_shsj         zjmb_shjc_bgk.dt_shsj%TYPE; --审核时间
    v_vc_hzjzkbqt     zjmb_shjc_bgk.vc_hzjzkbqt%TYPE; --患者就诊科别其他
    v_vc_shxz2        zjmb_shjc_bgk.vc_shxz2%TYPE; --伤害性质第二
    v_vc_shxz3        zjmb_shjc_bgk.vc_shxz3%TYPE; --伤害性质第三
    v_vc_ssbw2        zjmb_shjc_bgk.vc_ssbw2%TYPE; --受伤部位第二
    v_vc_ssbw3        zjmb_shjc_bgk.vc_ssbw3%TYPE; --受伤部位第三
    v_vc_bgkzt        zjmb_shjc_bgk.vc_bgkzt%TYPE; --报告卡状态
    v_vc_jkdwmc       zjmb_shjc_bgk.vc_jkdwmc%TYPE; --管理单位名称
    v_vc_hkjwdm       zjmb_shjc_bgk.vc_hkjwdm%TYPE; --户口地址居委
    v_vc_hkjddm       zjmb_shjc_bgk.vc_hkjddm%TYPE; --户口地址街道
    v_vc_hkqxdm       zjmb_shjc_bgk.vc_hkqxdm%TYPE; --户口地址区县
    v_vc_hksdm        zjmb_shjc_bgk.vc_hksdm%TYPE; --户口地址市
    v_vc_hjqt         zjmb_shjc_bgk.vc_hjqt%TYPE; --户籍其他
    v_vc_zyqt         zjmb_shjc_bgk.vc_zyqt%TYPE; --职业其他
    v_vc_sfjdc        zjmb_shjc_bgk.vc_sfjdc%TYPE; --伤害是否由机动车造成
    v_vc_sfzs         zjmb_shjc_bgk.vc_sfzs%TYPE; --伤害是否由自伤造成
    v_vc_sfytrgyzc    zjmb_shjc_bgk.vc_sfytrgyzc%TYPE; --伤害是否由他人故意造成
    v_vc_zz           zjmb_shjc_bgk.vc_zz%TYPE; --住址
    v_vc_id           zjmb_shjc_bgk.vc_id%TYPE; --报告卡编号
    v_vc_shzt         zjmb_shjc_bgk.vc_shzt%TYPE; --审核状态
    v_vc_shwtgyy      zjmb_shjc_bgk.vc_shwtgyy%TYPE; --区县审核未通过原因
    v_vc_shwtgyy1     zjmb_shjc_bgk.vc_shwtgyy1%TYPE; --区县审核未通过原因选项
    v_vc_shxzmc1      zjmb_shjc_bgk.vc_shxzmc1%TYPE; --伤害性质最严重
    v_vc_ssbwmc1      zjmb_shjc_bgk.vc_ssbwmc1%TYPE; --受伤部位最严重
    v_vc_shxzmc2      zjmb_shjc_bgk.vc_shxzmc2%TYPE; --伤害性质第二
    v_vc_shxzmc3      zjmb_shjc_bgk.vc_shxzmc3%TYPE; --伤害性质第三
    v_vc_ssbwmc2      zjmb_shjc_bgk.vc_ssbwmc2%TYPE; --受伤部位第二
    v_vc_ssbwmc3      zjmb_shjc_bgk.vc_ssbwmc3%TYPE; --受伤部位第三
    v_dt_bgrq         zjmb_shjc_bgk.dt_bgrq%TYPE; --报告日期
    v_dt_yyshsj       zjmb_shjc_bgk.dt_yyshsj%TYPE; --医院审核时间
    v_vc_gxbz         zjmb_shjc_bgk.vc_gxbz%TYPE; --更新标志
    v_vc_bgkid        zjmb_shjc_bgk.vc_bgkid%TYPE; --报告卡ID
    v_vc_jkdw         zjmb_shjc_bgk.vc_jkdw%TYPE; --建卡单位
    v_dt_jksj         zjmb_shjc_bgk.dt_jksj%TYPE; --建卡时间
    v_vc_xm           zjmb_shjc_bgk.vc_xm%TYPE; --姓名
    v_vc_xb           zjmb_shjc_bgk.vc_xb%TYPE; --性别
    v_vc_nl           zjmb_shjc_bgk.vc_nl%TYPE; --年龄
    v_vc_dh           zjmb_shjc_bgk.vc_dh%TYPE; --联系电话
    v_vc_mz           zjmb_shjc_bgk.vc_mz%TYPE; --民族
    v_dt_shrq         zjmb_shjc_bgk.dt_shrq%TYPE; --受伤日期
    v_dt_jzrq         zjmb_shjc_bgk.dt_jzrq%TYPE; --就诊日期
    v_vc_hkxxzz       zjmb_shjc_bgk.vc_hkxxzz%TYPE; --户口详细住址
    v_vc_hj           zjmb_shjc_bgk.vc_hj%TYPE; --户籍
    v_vc_zy           zjmb_shjc_bgk.vc_zy%TYPE; --职业
    v_vc_fsdd         zjmb_shjc_bgk.vc_fsdd%TYPE; --发生地点
    v_vc_fsddqt       zjmb_shjc_bgk.vc_fsddqt%TYPE; --发生地点其它
    v_vc_shyy         zjmb_shjc_bgk.vc_shyy%TYPE; --受伤原因
    v_vc_shyyqt       zjmb_shjc_bgk.vc_shyyqt%TYPE; --受伤原因其它
    v_vc_scbz         zjmb_shjc_bgk.vc_scbz%TYPE; --删除标志
    v_vc_glbz         zjmb_shjc_bgk.vc_glbz%TYPE; --管理单位代码
    v_vc_cjdwdm       zjmb_shjc_bgk.vc_cjdwdm%TYPE; --创建单位代码
    v_dt_xgsj         zjmb_shjc_bgk.dt_xgsj%TYPE; --修改时间
    v_vc_shszsm       zjmb_shjc_bgk.vc_shszsm%TYPE; --受伤时在做什么
    v_vc_shszsmqt     zjmb_shjc_bgk.vc_shszsmqt%TYPE; --受伤时在做什么其他
    v_vc_yzcd         zjmb_shjc_bgk.vc_yzcd%TYPE; --严重程度
    v_vc_fsqsfyj      zjmb_shjc_bgk.vc_fsqsfyj%TYPE; --发生前是否饮酒
    v_vc_brddqk       zjmb_shjc_bgk.vc_brddqk%TYPE; --病人抵达情况
    v_vc_brddqkqt     zjmb_shjc_bgk.vc_brddqkqt%TYPE; --病人抵达情况其它  
    v_vc_jkys         zjmb_shjc_bgk.vc_jkys%TYPE; --建卡医生
  
    v_ywrzid      zjjk_yw_log.id%TYPE; --业务日志id
    v_tab_bgk_old ZJMB_SHJC_BGK%rowtype; --伤害报告卡变更前
    v_tab_bgk_new ZJMB_SHJC_BGK%rowtype; --伤害报告卡变更后
  begin
    json_data(data_in, 'zjmb_shjc_bgk新增或修改', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm'); --操作员机构代码
    v_czyjgmc := Json_Str(v_Json_Data, 'czyjgmc'); --操作员机构代码
    v_czyyhid := Json_Str(v_Json_Data, 'v_czyyhid');
    --获取机构级别
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
  
    v_vc_jksdm        := Json_Str(v_Json_Data, 'vc_jksdm');
    v_vc_jkqxdm       := Json_Str(v_Json_Data, 'vc_jkqxdm');
    v_vc_sfgy         := Json_Str(v_Json_Data, 'vc_sfgy');
    v_vc_jj           := Json_Str(v_Json_Data, 'vc_jj');
    v_vc_sszjtgj      := Json_Str(v_Json_Data, 'vc_sszjtgj');
    v_vc_sszjtgjqt    := Json_Str(v_Json_Data, 'vc_sszjtgjqt');
    v_vc_sszqk        := Json_Str(v_Json_Data, 'vc_sszqk');
    v_vc_sszqkqt      := Json_Str(v_Json_Data, 'vc_sszqkqt');
    v_vc_sszhsmfspz   := Json_Str(v_Json_Data, 'vc_sszhsmfspz');
    v_vc_sszhsmfspzqt := Json_Str(v_Json_Data, 'vc_sszhsmfspzqt');
    v_vc_czjdcsszdwz  := Json_Str(v_Json_Data, 'vc_czjdcsszdwz');
    v_vc_zwywanqd     := Json_Str(v_Json_Data, 'vc_zwywanqd');
    v_vc_anqdsy       := Json_Str(v_Json_Data, 'vc_anqdsy');
    v_vc_ywbhzz       := Json_Str(v_Json_Data, 'vc_ywbhzz');
    v_vc_bhzzsy       := Json_Str(v_Json_Data, 'vc_bhzzsy');
    v_vc_zyxgys       := Json_Str(v_Json_Data, 'vc_zyxgys');
    v_vc_zyxgysqt     := Json_Str(v_Json_Data, 'vc_zyxgysqt');
    v_vc_yqzsfsdcs    := Json_Str(v_Json_Data, 'vc_yqzsfsdcs');
    v_vc_shqy         := Json_Str(v_Json_Data, 'vc_shqy');
    v_vc_shqyqt       := Json_Str(v_Json_Data, 'vc_shqyqt');
    v_vc_sszysrgx     := Json_Str(v_Json_Data, 'vc_sszysrgx');
    v_vc_sszysrgxqt   := Json_Str(v_Json_Data, 'vc_sszysrgxqt');
    v_vc_sygj         := Json_Str(v_Json_Data, 'vc_sygj');
    v_vc_sygjqt       := Json_Str(v_Json_Data, 'vc_sygjqt');
    v_vc_shxz1        := Json_Str(v_Json_Data, 'vc_shxz1');
    v_vc_ssbw1        := Json_Str(v_Json_Data, 'vc_ssbw1');
    v_vc_qsx          := Json_Str(v_Json_Data, 'vc_qsx');
    v_vc_tb           := Json_Str(v_Json_Data, 'vc_tb');
    v_vc_xz           := Json_Str(v_Json_Data, 'vc_xz');
    v_vc_rzzs         := Json_Str(v_Json_Data, 'vc_rzzs');
    v_vc_ggj          := Json_Str(v_Json_Data, 'vc_ggj');
    v_vc_sz           := Json_Str(v_Json_Data, 'vc_sz');
    v_vc_qg           := Json_Str(v_Json_Data, 'vc_qg');
    v_vc_hxd          := Json_Str(v_Json_Data, 'vc_hxd');
    v_vc_xhd          := Json_Str(v_Json_Data, 'vc_xhd');
    v_vc_sjxt         := Json_Str(v_Json_Data, 'vc_sjxt');
    v_vc_sjzy         := Json_Str(v_Json_Data, 'vc_sjzy');
    v_vc_shwbyy       := Json_Str(v_Json_Data, 'vc_shwbyy');
    v_vc_hzjzkb       := Json_Str(v_Json_Data, 'vc_hzjzkb');
    v_vc_txyshs       := Json_Str(v_Json_Data, 'vc_txyshs');
    v_vc_shbz         := Json_Str(v_Json_Data, 'vc_shbz');
    v_vc_hzjzkbqt     := Json_Str(v_Json_Data, 'vc_hzjzkbqt');
    v_vc_shxz2        := Json_Str(v_Json_Data, 'vc_shxz2');
    v_vc_shxz3        := Json_Str(v_Json_Data, 'vc_shxz3');
    v_vc_ssbw2        := Json_Str(v_Json_Data, 'vc_ssbw2');
    v_vc_ssbw3        := Json_Str(v_Json_Data, 'vc_ssbw3');
    v_vc_bgkzt        := Json_Str(v_Json_Data, 'vc_bgkzt');
    v_vc_jkdwmc       := Json_Str(v_Json_Data, 'vc_jkdwmc');
    v_dt_shrq         := std(Json_Str(v_Json_Data, 'dt_shrq'), 0);
    v_vc_hkjwdm       := Json_Str(v_Json_Data, 'vc_hkjwdm');
    v_vc_hkjddm       := Json_Str(v_Json_Data, 'vc_hkjddm');
    v_vc_hkqxdm       := Json_Str(v_Json_Data, 'vc_hkqxdm');
    v_vc_hksdm        := Json_Str(v_Json_Data, 'vc_hksdm');
    v_vc_hjqt         := Json_Str(v_Json_Data, 'vc_hjqt');
    v_vc_zyqt         := Json_Str(v_Json_Data, 'vc_zyqt');
    v_vc_sfjdc        := Json_Str(v_Json_Data, 'vc_sfjdc');
    v_vc_sfzs         := Json_Str(v_Json_Data, 'vc_sfzs');
    v_vc_sfytrgyzc    := Json_Str(v_Json_Data, 'vc_sfytrgyzc');
    v_vc_zz           := Json_Str(v_Json_Data, 'vc_zz');
    v_vc_id           := Json_Str(v_Json_Data, 'vc_id');
    v_vc_shzt         := Json_Str(v_Json_Data, 'vc_shzt');
    v_vc_shwtgyy      := Json_Str(v_Json_Data, 'vc_shwtgyy');
    v_vc_shwtgyy1     := Json_Str(v_Json_Data, 'vc_shwtgyy1');
    v_vc_shxzmc1      := Json_Str(v_Json_Data, 'vc_shxzmc1');
    v_vc_ssbwmc1      := Json_Str(v_Json_Data, 'vc_ssbwmc1');
    v_vc_shxzmc2      := Json_Str(v_Json_Data, 'vc_shxzmc2');
    v_vc_shxzmc3      := Json_Str(v_Json_Data, 'vc_shxzmc3');
    v_vc_ssbwmc2      := Json_Str(v_Json_Data, 'vc_ssbwmc2');
    v_vc_ssbwmc3      := Json_Str(v_Json_Data, 'vc_ssbwmc3');
    v_dt_bgrq         := std(Json_Str(v_Json_Data, 'dt_bgrq'), 0);
    v_vc_gxbz         := Json_Str(v_Json_Data, 'vc_gxbz');
    v_vc_bgkid        := Json_Str(v_Json_Data, 'vc_bgkid');
    v_vc_jkdw         := Json_Str(v_Json_Data, 'vc_jkdw');
    v_vc_jkys         := Json_Str(v_Json_Data, 'vc_jkys');
    v_dt_jksj         := std(Json_Str(v_Json_Data, 'dt_jksj'), 0);
    v_vc_xm           := Json_Str(v_Json_Data, 'vc_xm');
    v_vc_xb           := Json_Str(v_Json_Data, 'vc_xb');
    v_vc_nl           := Json_Str(v_Json_Data, 'vc_nl');
    v_vc_dh           := Json_Str(v_Json_Data, 'vc_dh');
    v_vc_mz           := Json_Str(v_Json_Data, 'vc_mz');
    v_dt_shrq         := std(Json_Str(v_Json_Data, 'dt_shrq'), 1);
    v_dt_jzrq         := std(Json_Str(v_Json_Data, 'dt_jzrq'), 1);
    v_vc_hkxxzz       := Json_Str(v_Json_Data, 'vc_hkxxzz');
    v_vc_hj           := Json_Str(v_Json_Data, 'vc_hj');
    v_vc_zy           := Json_Str(v_Json_Data, 'vc_zy');
    v_vc_fsdd         := Json_Str(v_Json_Data, 'vc_fsdd');
    v_vc_fsddqt       := Json_Str(v_Json_Data, 'vc_fsddqt');
    v_vc_shyy         := Json_Str(v_Json_Data, 'vc_shyy');
    v_vc_shyyqt       := Json_Str(v_Json_Data, 'vc_shyyqt');
    v_vc_scbz         := Json_Str(v_Json_Data, 'vc_scbz');
    v_vc_glbz         := Json_Str(v_Json_Data, 'vc_glbz');
    v_vc_cjdwdm       := Json_Str(v_Json_Data, 'vc_cjdwdm');
    v_vc_shszsm       := Json_Str(v_Json_Data, 'vc_shszsm');
    v_vc_shszsmqt     := Json_Str(v_Json_Data, 'vc_shszsmqt');
    v_vc_yzcd         := Json_Str(v_Json_Data, 'vc_yzcd');
    v_vc_fsqsfyj      := Json_Str(v_Json_Data, 'vc_fsqsfyj');
    v_vc_brddqk       := Json_Str(v_Json_Data, 'vc_brddqk');
    v_vc_brddqkqt     := Json_Str(v_Json_Data, 'vc_brddqkqt');
    --校验数据是否合法
    if v_vc_xm is null then
      v_err := '姓名不能为空!';
      raise err_custom;
    end if;
    if v_vc_xb is null then
      v_err := '性别不能为空!';
      raise err_custom;
    end if;
    if v_vc_nl is null then
      v_err := '年龄不能为空!';
      raise err_custom;
    end if;
    if v_dt_shrq is null then
      v_err := '受伤日期不能为空!';
      raise err_custom;
    end if;
    if v_dt_jzrq is null then
      v_err := '就诊日期不能为空!';
      raise err_custom;
    end if;
    if v_vc_jkdw is null then
      v_err := '监测医院不能为空!';
      raise err_custom;
    end if;
    if v_vc_jksdm is null then
      v_vc_jksdm := substr(v_vc_jkdw, 1, 4)||'0000';
    end if;
    if v_vc_jkqxdm is null then
      v_vc_jkqxdm := substr(v_vc_jkdw, 1, 6)||'00';
    end if;
    if v_vc_hj is null then
      v_err := '户籍状态不能为空!';
      raise err_custom;
    end if;
    if v_vc_nl > 7 and v_vc_zy is null then
      v_err := '年龄大于7岁职业不能为空!';
      raise err_custom;
    end if;
    if v_vc_zy = '11' and v_vc_zyqt is null then
      v_err := '职业其他不能为空!';
      raise err_custom;
    end if;
    if v_vc_fsdd is null then
      v_err := '发生地点不能为空!';
      raise err_custom;
    end if;
    --if v_vc_fsdd = '0' and v_vc_fsddqt is null then
    --  v_err := '发生地点其他不能为空!';
    --  raise err_custom;
    --end if;
    if v_vc_shyy is null then
      v_err := '受伤原因不能为空!';
      raise err_custom;
    end if;
    --if v_vc_shyy = 'J' and v_vc_shyyqt is null then
    --  v_err := '受伤原因其它不能为空!';
    --  raise err_custom;
    --end if;
    if v_vc_shszsm is null then
      v_err := '受伤时在做什么不能为空!';
      raise err_custom;
    end if;
    --if v_vc_shszsm = '6' and v_vc_shszsmqt is null then
    --  v_err := '受伤时在做什么其他不能为空!';
    --  raise err_custom;
    --end if;
    if v_vc_yzcd is null then
      v_err := '严重程度不能为空!';
      raise err_custom;
    end if;
    if v_vc_fsqsfyj is null then
      v_err := '发生前是否饮酒不能为空!';
      raise err_custom;
    end if;
    if v_vc_brddqk is null then
      v_err := '病人抵达情况不能为空!';
      raise err_custom;
    end if;
    if v_vc_sfgy is null then
      v_err := '是否故意不能为空!';
      raise err_custom;
    end if;
    if v_vc_jj is null then
      v_err := '结局不能为空!';
      raise err_custom;
    end if;
    if v_vc_sfjdc is null then
      v_err := '伤害是否由机动车造成不能为空!';
      raise err_custom;
    end if;
    if v_vc_sfjdc = '1' then
      if v_vc_sszjtgj is null then
        v_err := '受伤者交通工具不能为空!';
        raise err_custom;
      end if;
      --if v_vc_sszjtgj = 'J' and v_vc_sszjtgjqt is null then
      --  v_err := '受伤者交通工具其它不能为空!';
      --  raise err_custom;
      --end if;
      if v_vc_sszqk is null then
        v_err := '受伤者情况不能为空!';
        raise err_custom;
      end if;
      --if v_vc_sszqk = '5' and v_vc_sszqkqt is null then
      --  v_err := '受伤者情况其它不能为空!';
      --  raise err_custom;
      --end if;
      if v_vc_sszhsmfspz is null then
        v_err := '受伤者和什么发生碰撞不能为空!';
        raise err_custom;
      end if;
      --if v_vc_sszhsmfspz = '6' and v_vc_sszhsmfspzqt is not null then
      --  v_err := '受伤者和什么发生碰撞其他不能为空!';
      --  raise err_custom;
      --end if;
    end if;
    if v_vc_sszjtgj in ('E', 'F', 'G', 'H') and v_vc_czjdcsszdwz is null then
      v_err := '受伤者的位置不能为空!';
      raise err_custom;
    end if;
    if v_vc_sszjtgj in ('E', 'F', 'G', 'H') and v_vc_zwywanqd is null then
      v_err := '座位有无安全带不能为空!';
      raise err_custom;
    end if;
    if v_vc_sszjtgj in ('E', 'F', 'G', 'H') and v_vc_anqdsy is null then
      v_err := '安全带使用不能为空!';
      raise err_custom;
    end if;
    if v_vc_sszjtgj = 'C' and v_vc_ywbhzz is null then
      v_err := '有无保护装置不能为空!';
      raise err_custom;
    end if;
    if v_vc_sszjtgj = 'C' and v_vc_bhzzsy is null then
      v_err := '保护装置使用不能为空!';
      raise err_custom;
    end if;
    if v_vc_sfgy = '1' and v_vc_zyxgys is null then
      v_err := '自伤主要相关因素不能为空!';
      raise err_custom;
    end if;
    if v_vc_sfgy = '1' and v_vc_zyxgys = 'H' and v_vc_zyxgysqt is null then
      v_err := '自伤主要相关因素其它不能为空!';
      raise err_custom;
    end if;
    if v_vc_sfgy = '1' and v_vc_yqzsfsdcs is null then
      v_err := '以前自伤发生的次数不能为空!';
      raise err_custom;
    end if;
    if v_vc_sfgy = '2' and v_vc_shqy is null then
      v_err := '他伤-伤害起因不能为空!';
      raise err_custom;
    end if;
    if v_vc_sfgy = '2' and v_vc_shqy = '6' and v_vc_shqyqt is null then
      v_err := '他伤-伤害起因其它不能为空!';
      raise err_custom;
    end if;
    if v_vc_sfgy = '2' and v_vc_sszysrgx is null then
      v_err := '他伤-受伤者与伤人者之间的关系不能为空!';
      raise err_custom;
    end if;
    if v_vc_sfgy = '2' and v_vc_sygj is null then
      v_err := '他伤-使用工具不能为空!';
      raise err_custom;
    end if;
    --if v_vc_sfgy = '2' and v_vc_sygj = 'F' and v_vc_sygjqt is null then
    --  v_err := '他伤-使用工具其他不能为空!';
    --  raise err_custom;
    --end if;
    if v_vc_shxz1 is null then
      v_err := '伤害性质最严重不能为空!';
      raise err_custom;
    end if;
    if v_vc_ssbw1 is null then
      v_err := '受伤部位最严重不能为空!';
      raise err_custom;
    end if;
    if v_vc_hzjzkb is null then
      v_err := '患者就诊科别不能为空!';
      raise err_custom;
    end if;
    --if v_vc_hzjzkb = '5' and v_vc_hzjzkbqt is null then
    --  v_err := '患者就诊科别其他不能为空!';
    --  raise err_custom;
    --end if;
    if v_vc_txyshs is null then
      v_err := '填写医生/护士不能为空!';
      raise err_custom;
    end if;
    if v_vc_sfjdc = '1' and v_vc_shyy != 'A' then
      v_err := '填写机动车部分，则受伤原因应填写交通伤!';
      raise err_custom;
    end if;
    if v_vc_sfjdc = '1' and v_vc_shyy != 'A' then
      v_err := '填写机动车部分，则受伤原因应填写交通伤!';
      raise err_custom;
    end if;
    if v_vc_sszjtgj = 'A' and v_vc_sszqk != '0' then
      v_err := '如果受伤者的交通工具选择步行，则受伤者的情况只能选择行人!';
      raise err_custom;
    end if;
    if v_vc_sszjtgj = 'B' and v_vc_sszqk != '1' and v_vc_sszqk != '3' then
      v_err := '如果受伤者的交通工具选择非机动车，则受伤者的情况只能选择非机动车驾驶员或非机动车乘客!';
      raise err_custom;
    end if;
    if v_vc_sfjdc in ('C', 'D', 'E', 'F', 'G', 'H', 'I') and
       v_vc_sszqk not in ('2', '4') then
      v_err := '如果受伤者的交通工具选择 3 4 5 6 7 8 9 ，则受伤者的情况只能选择 3机动车驾驶员或5 机动车乘客!';
      raise err_custom;
    end if;
  
    --新增
    if v_vc_id is null then
      v_ywjl_czlx := '01';
      v_vc_scbz   := '0'; --删除标志未删除
      v_vc_bgkzt  := '0'; --报卡状态可用卡
      v_vc_shbz   := '1'; --审核标志医院通过
      if v_czyjgjb <> '4' then
        v_err := '当前机构无新增权限!';
        raise err_custom;
      end if;
      --获取报告卡id
      select fun_getbgkid_shjc(v_czyjgdm) into v_vc_bgkid from dual;
      v_vc_id := sys_guid();
      insert into zjmb_shjc_bgk
        (vc_bgkid,
         vc_jkdw,
         vc_jkys,
         dt_jksj,
         vc_xm,
         vc_xb,
         vc_nl,
         vc_dh,
         vc_mz,
         dt_shrq,
         dt_jzrq,
         vc_hkxxzz,
         vc_hj,
         vc_zy,
         vc_fsdd,
         vc_fsddqt,
         vc_shyy,
         vc_shyyqt,
         vc_scbz,
         vc_glbz,
         vc_cjdwdm,
         dt_cjsj,
         vc_cjyh,
         vc_shszsm,
         vc_shszsmqt,
         vc_yzcd,
         vc_fsqsfyj,
         vc_brddqk,
         vc_brddqkqt,
         vc_sfgy,
         vc_jj,
         vc_sszjtgj,
         vc_sszjtgjqt,
         vc_sszqk,
         vc_sszqkqt,
         vc_sszhsmfspz,
         vc_sszhsmfspzqt,
         vc_czjdcsszdwz,
         vc_zwywanqd,
         vc_anqdsy,
         vc_ywbhzz,
         vc_bhzzsy,
         vc_zyxgys,
         vc_zyxgysqt,
         vc_yqzsfsdcs,
         vc_shqy,
         vc_shqyqt,
         vc_sszysrgx,
         vc_sszysrgxqt,
         vc_sygj,
         vc_sygjqt,
         vc_shxz1,
         vc_ssbw1,
         vc_qsx,
         vc_tb,
         vc_xz,
         vc_rzzs,
         vc_ggj,
         vc_sz,
         vc_qg,
         vc_hxd,
         vc_xhd,
         vc_sjxt,
         vc_sjzy,
         vc_shwbyy,
         vc_hzjzkb,
         vc_txyshs,
         vc_shbz,
         dt_shsj,
         vc_hzjzkbqt,
         vc_shxz2,
         vc_shxz3,
         vc_ssbw2,
         vc_ssbw3,
         vc_bgkzt,
         vc_jkdwmc,
         vc_hkjwdm,
         vc_hkjddm,
         vc_hkqxdm,
         vc_hksdm,
         vc_hjqt,
         vc_zyqt,
         vc_sfjdc,
         vc_sfzs,
         vc_sfytrgyzc,
         vc_zz,
         vc_id,
         vc_shzt,
         vc_shwtgyy,
         vc_shwtgyy1,
         vc_shxzmc1,
         vc_ssbwmc1,
         vc_shxzmc2,
         vc_shxzmc3,
         vc_ssbwmc2,
         vc_ssbwmc3,
         dt_bgrq,
         dt_yyshsj,
         vc_gxbz,
         vc_jksdm,
         vc_jkqxdm)
      values
        (v_vc_bgkid,
         v_czyjgdm,
         v_vc_jkys,
         v_dt_jksj,
         v_vc_xm,
         v_vc_xb,
         v_vc_nl,
         v_vc_dh,
         v_vc_mz,
         v_dt_shrq,
         v_dt_jzrq,
         v_vc_hkxxzz,
         v_vc_hj,
         v_vc_zy,
         v_vc_fsdd,
         v_vc_fsddqt,
         v_vc_shyy,
         v_vc_shyyqt,
         v_vc_scbz,
         v_vc_glbz,
         v_czyjgdm,
         v_sysdate,
         v_czyyhid,
         v_vc_shszsm,
         v_vc_shszsmqt,
         v_vc_yzcd,
         v_vc_fsqsfyj,
         v_vc_brddqk,
         v_vc_brddqkqt,
         v_vc_sfgy,
         v_vc_jj,
         v_vc_sszjtgj,
         v_vc_sszjtgjqt,
         v_vc_sszqk,
         v_vc_sszqkqt,
         v_vc_sszhsmfspz,
         v_vc_sszhsmfspzqt,
         v_vc_czjdcsszdwz,
         v_vc_zwywanqd,
         v_vc_anqdsy,
         v_vc_ywbhzz,
         v_vc_bhzzsy,
         v_vc_zyxgys,
         v_vc_zyxgysqt,
         v_vc_yqzsfsdcs,
         v_vc_shqy,
         v_vc_shqyqt,
         v_vc_sszysrgx,
         v_vc_sszysrgxqt,
         v_vc_sygj,
         v_vc_sygjqt,
         v_vc_shxz1,
         v_vc_ssbw1,
         v_vc_qsx,
         v_vc_tb,
         v_vc_xz,
         v_vc_rzzs,
         v_vc_ggj,
         v_vc_sz,
         v_vc_qg,
         v_vc_hxd,
         v_vc_xhd,
         v_vc_sjxt,
         v_vc_sjzy,
         v_vc_shwbyy,
         v_vc_hzjzkb,
         v_vc_txyshs,
         v_vc_shbz,
         v_dt_shsj,
         v_vc_hzjzkbqt,
         v_vc_shxz2,
         v_vc_shxz3,
         v_vc_ssbw2,
         v_vc_ssbw3,
         v_vc_bgkzt,
         v_czyjgmc,
         v_vc_hkjwdm,
         v_vc_hkjddm,
         v_vc_hkqxdm,
         v_vc_hksdm,
         v_vc_hjqt,
         v_vc_zyqt,
         v_vc_sfjdc,
         v_vc_sfzs,
         v_vc_sfytrgyzc,
         v_vc_zz,
         v_vc_id,
         v_vc_shzt,
         v_vc_shwtgyy,
         v_vc_shwtgyy1,
         v_vc_shxzmc1,
         v_vc_ssbwmc1,
         v_vc_shxzmc2,
         v_vc_shxzmc3,
         v_vc_ssbwmc2,
         v_vc_ssbwmc3,
         v_dt_bgrq,
         v_sysdate,
         v_vc_gxbz,
         v_vc_jksdm,
         v_vc_jkqxdm);
    
    else
      v_ywjl_czlx := '02';
      begin
        select a.vc_shbz
          into v_vc_shbz
          from zjmb_shjc_bgk a
         where a.vc_bgkid = v_vc_bgkid;
      exception
        when no_data_found then
          v_err := 'id[' || v_vc_bgkid || ']未获取到有效报告卡信息!';
          raise err_custom;
      end;
      if v_czyjgjb = '4' then
        --审核不通过
        if v_vc_shbz in ('2', '4') then
          --修改为审核通过
          v_vc_shbz := '1';
        end if;
      elsif v_czyjgjb = '3' then
        --区县
        v_vc_shbz := '3';
      else
        v_err := '当前机构无修改权限!';
        raise err_custom;
      end if;
      --获取变更前信息
      select * into v_tab_bgk_old from ZJMB_SHJC_BGK where vc_id = v_vc_id;
      --修改
      update ZJMB_SHJC_BGK
         set vc_jkys         = v_vc_jkys,
             dt_jksj         = v_dt_jksj,
             vc_xm           = v_vc_xm,
             vc_xb           = v_vc_xb,
             vc_nl           = v_vc_nl,
             vc_dh           = v_vc_dh,
             vc_mz           = v_vc_mz,
             dt_shrq         = v_dt_shrq,
             dt_jzrq         = v_dt_jzrq,
             vc_hkxxzz       = v_vc_hkxxzz,
             vc_hj           = v_vc_hj,
             vc_zy           = v_vc_zy,
             vc_fsdd         = v_vc_fsdd,
             vc_fsddqt       = v_vc_fsddqt,
             vc_shyy         = v_vc_shyy,
             vc_shyyqt       = v_vc_shyyqt,
             vc_glbz         = v_vc_glbz,
             dt_xgsj         = v_sysdate,
             vc_xgyh         = v_czyyhid,
             vc_shszsm       = v_vc_shszsm,
             vc_shszsmqt     = v_vc_shszsmqt,
             vc_yzcd         = v_vc_yzcd,
             vc_fsqsfyj      = v_vc_fsqsfyj,
             vc_brddqk       = v_vc_brddqk,
             vc_brddqkqt     = v_vc_brddqkqt,
             vc_sfgy         = v_vc_sfgy,
             vc_jj           = v_vc_jj,
             vc_sszjtgj      = v_vc_sszjtgj,
             vc_sszjtgjqt    = v_vc_sszjtgjqt,
             vc_sszqk        = v_vc_sszqk,
             vc_sszqkqt      = v_vc_sszqkqt,
             vc_sszhsmfspz   = v_vc_sszhsmfspz,
             vc_sszhsmfspzqt = v_vc_sszhsmfspzqt,
             vc_czjdcsszdwz  = v_vc_czjdcsszdwz,
             vc_zwywanqd     = v_vc_zwywanqd,
             vc_anqdsy       = v_vc_anqdsy,
             vc_ywbhzz       = v_vc_ywbhzz,
             vc_bhzzsy       = v_vc_bhzzsy,
             vc_zyxgys       = v_vc_zyxgys,
             vc_zyxgysqt     = v_vc_zyxgysqt,
             vc_yqzsfsdcs    = v_vc_yqzsfsdcs,
             vc_shqy         = v_vc_shqy,
             vc_shqyqt       = v_vc_shqyqt,
             vc_sszysrgx     = v_vc_sszysrgx,
             vc_sszysrgxqt   = v_vc_sszysrgxqt,
             vc_sygj         = v_vc_sygj,
             vc_sygjqt       = v_vc_sygjqt,
             vc_shxz1        = v_vc_shxz1,
             vc_ssbw1        = v_vc_ssbw1,
             vc_qsx          = v_vc_qsx,
             vc_tb           = v_vc_tb,
             vc_xz           = v_vc_xz,
             vc_rzzs         = v_vc_rzzs,
             vc_ggj          = v_vc_ggj,
             vc_sz           = v_vc_sz,
             vc_qg           = v_vc_qg,
             vc_hxd          = v_vc_hxd,
             vc_xhd          = v_vc_xhd,
             vc_sjxt         = v_vc_sjxt,
             vc_sjzy         = v_vc_sjzy,
             vc_shwbyy       = v_vc_shwbyy,
             vc_hzjzkb       = v_vc_hzjzkb,
             vc_txyshs       = v_vc_txyshs,
             vc_shbz         = v_vc_shbz,
             vc_hzjzkbqt     = v_vc_hzjzkbqt,
             vc_shxz2        = v_vc_shxz2,
             vc_shxz3        = v_vc_shxz3,
             vc_ssbw2        = v_vc_ssbw2,
             vc_ssbw3        = v_vc_ssbw3,
             vc_hkjwdm       = v_vc_hkjwdm,
             vc_hkjddm       = v_vc_hkjddm,
             vc_hkqxdm       = v_vc_hkqxdm,
             vc_hksdm        = v_vc_hksdm,
             vc_hjqt         = v_vc_hjqt,
             vc_zyqt         = v_vc_zyqt,
             vc_sfjdc        = v_vc_sfjdc,
             vc_sfzs         = v_vc_sfzs,
             vc_sfytrgyzc    = v_vc_sfytrgyzc,
             vc_zz           = v_vc_zz,
             vc_id           = v_vc_id,
             vc_shzt         = v_vc_shzt,
             vc_shwtgyy      = v_vc_shwtgyy,
             vc_shwtgyy1     = v_vc_shwtgyy1,
             vc_shxzmc1      = v_vc_shxzmc1,
             vc_ssbwmc1      = v_vc_ssbwmc1,
             vc_shxzmc2      = v_vc_shxzmc2,
             vc_shxzmc3      = v_vc_shxzmc3,
             vc_ssbwmc2      = v_vc_ssbwmc2,
             vc_ssbwmc3      = v_vc_ssbwmc3,
             dt_bgrq         = v_dt_bgrq,
             dt_yyshsj       = v_dt_yyshsj,
             vc_gxbz         = v_vc_gxbz,
             vc_jksdm        = v_vc_jksdm,
             vc_jkqxdm       = v_vc_jkqxdm,
             dt_shsj = case
                         when v_vc_shbz = '3' and dt_shsj is null then
                          v_sysdate
                         else
                          dt_shsj
                       end
       where vc_id = v_vc_id;
      --记录报卡变更日志
      v_ywrzid := sys_guid();
      --获取变更后信息
      select * into v_tab_bgk_new from ZJMB_SHJC_BGK where vc_id = v_vc_id;
      --写入变更记录
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_jkys',
                                         '建卡医生',
                                         v_tab_bgk_old.vc_jkys,
                                         v_tab_bgk_new.vc_jkys,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'dt_jksj',
                                         '建卡时间',
                                         dts(v_tab_bgk_old.dt_jksj, 0),
                                         dts(v_tab_bgk_new.dt_jksj, 0),
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_xm',
                                         '姓名',
                                         v_tab_bgk_old.vc_xm,
                                         v_tab_bgk_new.vc_xm,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_xb',
                                         '性别',
                                         v_tab_bgk_old.vc_xb,
                                         v_tab_bgk_new.vc_xb,
                                         'C_COMM_XB',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_nl',
                                         '年龄',
                                         v_tab_bgk_old.vc_nl,
                                         v_tab_bgk_new.vc_nl,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_dh',
                                         '联系电话',
                                         v_tab_bgk_old.vc_dh,
                                         v_tab_bgk_new.vc_dh,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_mz',
                                         '民族',
                                         v_tab_bgk_old.vc_mz,
                                         v_tab_bgk_new.vc_mz,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'dt_shrq',
                                         '受伤日期',
                                         dts(v_tab_bgk_old.dt_shrq, 0),
                                         dts(v_tab_bgk_new.dt_shrq, 0),
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'dt_jzrq',
                                         '就诊日期',
                                         dts(v_tab_bgk_old.dt_jzrq, 0),
                                         dts(v_tab_bgk_new.dt_jzrq, 0),
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_hkxxzz',
                                         '户口详细住址',
                                         v_tab_bgk_old.vc_hkxxzz,
                                         v_tab_bgk_new.vc_hkxxzz,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_hj',
                                         '户籍',
                                         v_tab_bgk_old.vc_hj,
                                         v_tab_bgk_new.vc_hj,
                                         'DICT_SHJC_HJ',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_zy',
                                         '职业',
                                         v_tab_bgk_old.vc_zy,
                                         v_tab_bgk_new.vc_zy,
                                         'DICT_SHJC_ZY',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_fsdd',
                                         '发生地点',
                                         v_tab_bgk_old.vc_fsdd,
                                         v_tab_bgk_new.vc_fsdd,
                                         'C_SHJC_FSDD',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_fsddqt',
                                         '其他发生地点',
                                         v_tab_bgk_old.vc_fsddqt,
                                         v_tab_bgk_new.vc_fsddqt,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_shyy',
                                         '受伤原因',
                                         v_tab_bgk_old.vc_shyy,
                                         v_tab_bgk_new.vc_shyy,
                                         'DICT_SHJC_SSYY',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_shyyqt',
                                         '其他受伤原因',
                                         v_tab_bgk_old.vc_shyyqt,
                                         v_tab_bgk_new.vc_shyyqt,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_glbz',
                                         '管理单位代码',
                                         v_tab_bgk_old.vc_glbz,
                                         v_tab_bgk_new.vc_glbz,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_shszsm',
                                         '受伤时在做什么',
                                         v_tab_bgk_old.vc_shszsm,
                                         v_tab_bgk_new.vc_shszsm,
                                         'DICT_SHJC_SSSZZSM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_shszsmqt',
                                         '受伤时在做什么其他',
                                         v_tab_bgk_old.vc_shszsmqt,
                                         v_tab_bgk_new.vc_shszsmqt,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_yzcd',
                                         '严重程度',
                                         v_tab_bgk_old.vc_yzcd,
                                         v_tab_bgk_new.vc_yzcd,
                                         'DICT_SHJC_YZCD',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_fsqsfyj',
                                         '发生前是否饮酒',
                                         v_tab_bgk_old.vc_fsqsfyj,
                                         v_tab_bgk_new.vc_fsqsfyj,
                                         'DICT_SHJC_FSQSFYJ',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_brddqk',
                                         '病人抵达情况',
                                         v_tab_bgk_old.vc_brddqk,
                                         v_tab_bgk_new.vc_brddqk,
                                         'DICT_SHJC_BRDDQK',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_brddqkqt',
                                         '病人抵达情况其他',
                                         v_tab_bgk_old.vc_brddqkqt,
                                         v_tab_bgk_new.vc_brddqkqt,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_sfgy',
                                         '是否故意',
                                         v_tab_bgk_old.vc_sfgy,
                                         v_tab_bgk_new.vc_sfgy,
                                         'DICT_SHJC_SFGY',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_jj',
                                         '结局',
                                         v_tab_bgk_old.vc_jj,
                                         v_tab_bgk_new.vc_jj,
                                         'DICT_SHJC_JJ',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_sszjtgj',
                                         '受伤者的交通工具',
                                         v_tab_bgk_old.vc_sszjtgj,
                                         v_tab_bgk_new.vc_sszjtgj,
                                         'DICT_SHJC_SSZDJTGJ',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_sszjtgjqt',
                                         '受伤者的交通工具其他',
                                         v_tab_bgk_old.vc_sszjtgjqt,
                                         v_tab_bgk_new.vc_sszjtgjqt,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_sszqk',
                                         '受伤者的情况',
                                         v_tab_bgk_old.vc_sszqk,
                                         v_tab_bgk_new.vc_sszqk,
                                         'DICT_SHJC_SSZDQK',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_sszqkqt',
                                         '受伤者的情况其他',
                                         v_tab_bgk_old.vc_sszqkqt,
                                         v_tab_bgk_new.vc_sszqkqt,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_sszhsmfspz',
                                         '受伤者和什么发生碰撞',
                                         v_tab_bgk_old.vc_sszhsmfspz,
                                         v_tab_bgk_new.vc_sszhsmfspz,
                                         'DICT_SHJC_SSZFSPZ',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_sszhsmfspzqt',
                                         '受伤者和什么发生碰撞其他',
                                         v_tab_bgk_old.vc_sszhsmfspzqt,
                                         v_tab_bgk_new.vc_sszhsmfspzqt,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_czjdcsszdwz',
                                         '受伤者位置',
                                         v_tab_bgk_old.vc_czjdcsszdwz,
                                         v_tab_bgk_new.vc_czjdcsszdwz,
                                         'DICT_SHJC_SSZWZ',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_zwywanqd',
                                         '座位有无安全带',
                                         v_tab_bgk_old.vc_zwywanqd,
                                         v_tab_bgk_new.vc_zwywanqd,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_anqdsy',
                                         '安全带使用',
                                         v_tab_bgk_old.vc_anqdsy,
                                         v_tab_bgk_new.vc_anqdsy,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_ywbhzz',
                                         '有无保护装置（如头盔）',
                                         v_tab_bgk_old.vc_ywbhzz,
                                         v_tab_bgk_new.vc_ywbhzz,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_bhzzsy',
                                         '保护装置使用',
                                         v_tab_bgk_old.vc_bhzzsy,
                                         v_tab_bgk_new.vc_bhzzsy,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_zyxgys',
                                         '主要相关因素',
                                         v_tab_bgk_old.vc_zyxgys,
                                         v_tab_bgk_new.vc_zyxgys,
                                         'DICT_SHJC_ZYXGYS',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_zyxgysqt',
                                         '主要相关因素其他',
                                         v_tab_bgk_old.vc_zyxgysqt,
                                         v_tab_bgk_new.vc_zyxgysqt,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_yqzsfsdcs',
                                         '以前自伤发生的次数',
                                         v_tab_bgk_old.vc_yqzsfsdcs,
                                         v_tab_bgk_new.vc_yqzsfsdcs,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_shqy',
                                         '伤害起因',
                                         v_tab_bgk_old.vc_shqy,
                                         v_tab_bgk_new.vc_shqy,
                                         'DICT_SHJC_SHQY',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_shqyqt',
                                         '伤害起因其他',
                                         v_tab_bgk_old.vc_shqyqt,
                                         v_tab_bgk_new.vc_shqyqt,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_sszysrgx',
                                         '受者和伤人者之间关系',
                                         v_tab_bgk_old.vc_sszysrgx,
                                         v_tab_bgk_new.vc_sszysrgx,
                                         'DICT_SHJC_SZHSZGX',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_sszysrgxqt',
                                         '受者和伤人者之间关系其他',
                                         v_tab_bgk_old.vc_sszysrgxqt,
                                         v_tab_bgk_new.vc_sszysrgxqt,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_sygj',
                                         '使用的工具',
                                         v_tab_bgk_old.vc_sygj,
                                         v_tab_bgk_new.vc_sygj,
                                         'DICT_SHJC_SYDGJ',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_sygjqt',
                                         '使用的工具其他',
                                         v_tab_bgk_old.vc_sygjqt,
                                         v_tab_bgk_new.vc_sygjqt,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_shxz1',
                                         '伤害性质最严重',
                                         v_tab_bgk_old.vc_shxz1,
                                         v_tab_bgk_new.vc_shxz1,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_ssbw1',
                                         '受伤部位最严重',
                                         v_tab_bgk_old.vc_ssbw1,
                                         v_tab_bgk_new.vc_ssbw1,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_qsx',
                                         '全身性',
                                         v_tab_bgk_old.vc_qsx,
                                         v_tab_bgk_new.vc_qsx,
                                         'DICT_SHJC_QSX',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_tb',
                                         '头部',
                                         v_tab_bgk_old.vc_tb,
                                         v_tab_bgk_new.vc_tb,
                                         'DICT_SHJC_TB',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_xz',
                                         '下肢',
                                         v_tab_bgk_old.vc_xz,
                                         v_tab_bgk_new.vc_xz,
                                         'DICT_SHJC_XZ',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_rzzs',
                                         '软组织伤',
                                         v_tab_bgk_old.vc_rzzs,
                                         v_tab_bgk_new.vc_rzzs,
                                         'DICT_SHJC_RZZS',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_ggj',
                                         '骨关节',
                                         v_tab_bgk_old.vc_ggj,
                                         v_tab_bgk_new.vc_ggj,
                                         'DICT_SHJC_GGJ',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_sz',
                                         '上肢',
                                         v_tab_bgk_old.vc_sz,
                                         v_tab_bgk_new.vc_sz,
                                         'DICT_SHJC_SZ',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_qg',
                                         '躯干',
                                         v_tab_bgk_old.vc_qg,
                                         v_tab_bgk_new.vc_qg,
                                         'DICT_SHJC_QG',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_hxd',
                                         '呼吸道',
                                         v_tab_bgk_old.vc_hxd,
                                         v_tab_bgk_new.vc_hxd,
                                         'DICT_SHJC_HXD',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_xhd',
                                         '消化道',
                                         v_tab_bgk_old.vc_xhd,
                                         v_tab_bgk_new.vc_xhd,
                                         'DICT_SHJC_XHD',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_sjxt',
                                         '神经系统',
                                         v_tab_bgk_old.vc_sjxt,
                                         v_tab_bgk_new.vc_sjxt,
                                         'DICT_SHJC_SJXT',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_sjzy',
                                         '事件摘要',
                                         v_tab_bgk_old.vc_sjzy,
                                         v_tab_bgk_new.vc_sjzy,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_shwbyy',
                                         '伤害外部原因编码(ICD-10)',
                                         v_tab_bgk_old.vc_shwbyy,
                                         v_tab_bgk_new.vc_shwbyy,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_hzjzkb',
                                         '患者就诊科别',
                                         v_tab_bgk_old.vc_hzjzkb,
                                         v_tab_bgk_new.vc_hzjzkb,
                                         'DICT_SHJC_HZJZKB',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_txyshs',
                                         '填写医生/护士',
                                         v_tab_bgk_old.vc_txyshs,
                                         v_tab_bgk_new.vc_txyshs,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_shbz',
                                         '审核标志',
                                         v_tab_bgk_old.vc_shbz,
                                         v_tab_bgk_new.vc_shbz,
                                         'C_COMM_SHZT',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_hzjzkbqt',
                                         '患者就诊科别其他',
                                         v_tab_bgk_old.vc_hzjzkbqt,
                                         v_tab_bgk_new.vc_hzjzkbqt,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_shxz2',
                                         '伤害性质第二',
                                         v_tab_bgk_old.vc_shxz2,
                                         v_tab_bgk_new.vc_shxz2,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_shxz3',
                                         '伤害性质第三',
                                         v_tab_bgk_old.vc_shxz3,
                                         v_tab_bgk_new.vc_shxz3,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_ssbw2',
                                         '受伤部位第二',
                                         v_tab_bgk_old.vc_ssbw2,
                                         v_tab_bgk_new.vc_ssbw2,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_ssbw3',
                                         '受伤部位第三',
                                         v_tab_bgk_old.vc_ssbw3,
                                         v_tab_bgk_new.vc_ssbw3,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_hkjwdm',
                                         '户口地址居委',
                                         v_tab_bgk_old.vc_hkjwdm,
                                         v_tab_bgk_new.vc_hkjwdm,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_hkjddm',
                                         '户口街道',
                                         v_tab_bgk_old.vc_hkjddm,
                                         v_tab_bgk_new.vc_hkjddm,
                                         'P_XZDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_hkqxdm',
                                         '户口区县',
                                         v_tab_bgk_old.vc_hkqxdm,
                                         v_tab_bgk_new.vc_hkqxdm,
                                         'P_XZDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_hksdm',
                                         '户口市',
                                         v_tab_bgk_old.vc_hksdm,
                                         v_tab_bgk_new.vc_hksdm,
                                         'P_XZDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_hjqt',
                                         '户籍其他',
                                         v_tab_bgk_old.vc_hjqt,
                                         v_tab_bgk_new.vc_hjqt,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_zyqt',
                                         '职业其他',
                                         v_tab_bgk_old.vc_zyqt,
                                         v_tab_bgk_new.vc_zyqt,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_sfjdc',
                                         '伤害是否由机动车造成',
                                         v_tab_bgk_old.vc_sfjdc,
                                         v_tab_bgk_new.vc_sfjdc,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_sfzs',
                                         '事件是否与自伤有关',
                                         v_tab_bgk_old.vc_sfzs,
                                         v_tab_bgk_new.vc_sfzs,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_sfytrgyzc',
                                         '事件是否与他人故意伤害有关',
                                         v_tab_bgk_old.vc_sfytrgyzc,
                                         v_tab_bgk_new.vc_sfytrgyzc,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_zz',
                                         '住址',
                                         v_tab_bgk_old.vc_zz,
                                         v_tab_bgk_new.vc_zz,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_shzt',
                                         '审核状态',
                                         v_tab_bgk_old.vc_shzt,
                                         v_tab_bgk_new.vc_shzt,
                                         'C_COMM_SHZT',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_shwtgyy',
                                         '审核不通过原因',
                                         v_tab_bgk_old.vc_shwtgyy,
                                         v_tab_bgk_new.vc_shwtgyy,
                                         'VC_SHWTGYY',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_shwtgyy1',
                                         '审核不通过原因其他',
                                         v_tab_bgk_old.vc_shwtgyy1,
                                         v_tab_bgk_new.vc_shwtgyy1,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_shxzmc1',
                                         '伤害性质最严重',
                                         v_tab_bgk_old.vc_shxzmc1,
                                         v_tab_bgk_new.vc_shxzmc1,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_ssbwmc1',
                                         '伤害部位最严重',
                                         v_tab_bgk_old.vc_ssbwmc1,
                                         v_tab_bgk_new.vc_ssbwmc1,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_shxzmc2',
                                         '伤害性质严重第二',
                                         v_tab_bgk_old.vc_shxzmc2,
                                         v_tab_bgk_new.vc_shxzmc2,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_shxzmc3',
                                         '伤害性质严重第三',
                                         v_tab_bgk_old.vc_shxzmc3,
                                         v_tab_bgk_new.vc_shxzmc3,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_ssbwmc2',
                                         '伤害部位严重第二',
                                         v_tab_bgk_old.vc_ssbwmc2,
                                         v_tab_bgk_new.vc_ssbwmc2,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_ssbwmc3',
                                         '伤害部位严重第三',
                                         v_tab_bgk_old.vc_ssbwmc3,
                                         v_tab_bgk_new.vc_ssbwmc3,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'dt_bgrq',
                                         '报告日期',
                                         dts(v_tab_bgk_old.dt_bgrq, 0),
                                         dts(v_tab_bgk_new.dt_bgrq, 0),
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'dt_yyshsj',
                                         '医院审核时间',
                                         dts(v_tab_bgk_old.dt_yyshsj, 0),
                                         dts(v_tab_bgk_new.dt_yyshsj, 0),
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_gxbz',
                                         '更新标志',
                                         v_tab_bgk_old.vc_gxbz,
                                         v_tab_bgk_new.vc_gxbz,
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_jksdm',
                                         '建卡市代码',
                                         v_tab_bgk_old.vc_jksdm,
                                         v_tab_bgk_new.vc_jksdm,
                                         'P_XZDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'vc_jkqxdm',
                                         '建卡区县代码',
                                         v_tab_bgk_old.vc_jkqxdm,
                                         v_tab_bgk_new.vc_jkqxdm,
                                         'P_XZDM',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_bgjl(v_ywrzid,
                                         v_vc_bgkid,
                                         '07',
                                         'dt_shsj',
                                         '审核时间',
                                         dts(v_tab_bgk_old.dt_shsj, 0),
                                         dts(v_tab_bgk_new.dt_shsj, 0),
                                         '',
                                         v_czyyhid,
                                         v_czyjgdm,
                                         v_err);
    end if;
    --添加操作日志
    v_json_yw_log := Json_ext.get_json(v_json_data, 'ywjllog');
    if v_json_yw_log is not null then
      v_json_yw_log.put('ywrzid', v_ywrzid);
      v_json_yw_log.put('bgkid', v_vc_bgkid);
      v_json_yw_log.put('bgklx', '07');
      v_json_yw_log.put('ywjlid', v_vc_bgkid);
      v_json_yw_log.put('gnmk', '01');
      v_json_yw_log.put('gnmc', '报卡管理');
      v_json_yw_log.put('czlx', v_ywjl_czlx);
      pkg_zjmb_xtfz.prc_zjjk_yw_log_update(v_json_yw_log, v_err);
      if v_err is not null then
        raise err_custom;
      end if;
    end if;
    --返回
    v_Json_Return.put('id', v_vc_id);
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_shjc_bgk_update;
  /*--------------------------------------------------------------------------
  || 功能描述 ：伤害监测报告卡删除
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_shjc_bgk_sc(Data_In    In Clob, --入参
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
    v_czyjgjb varchar2(3);
    v_bkid    zjmb_shjc_bgk.vc_bgkid%type;
    v_scbz    zjmb_shjc_bgk.vc_scbz%TYPE; --删除标志
  BEGIN
    json_data(data_in, 'zjmb_shjc_bgk删除', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    --获取机构级别
    --select fun_getczyjgjb(v_czyjgdm) into v_czyjgjb from dual;
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    v_bkid    := Json_Str(v_Json_Data, 'vc_bgkid');
    --获取报卡状态
    begin
      select vc_scbz
        into v_scbz
        from zjmb_shjc_bgk
       where vc_bgkid = v_bkid
         and vc_scbz = '0';
    exception
      when no_data_found then
        v_err := 'id[' || v_bkid || ']未获取到有效报告卡信息!';
        raise err_custom;
    end;
    if v_czyjgjb <> '4' and v_czyjgjb <> '3' then
      --非区县
      v_err := '当前机构无删除权限!';
      raise err_custom;
    end if;
    --更新删除标志
    update zjmb_shjc_bgk
       set vc_scbz = '1', vc_bgkzt = '5', dt_xgsj = sysdate
     where vc_bgkid = v_bkid;
    v_Json_Return.put('id', v_bkid);
    --添加操作日志
    v_json_yw_log := Json_ext.get_json(v_json_data, 'ywjllog');
    if v_json_yw_log is not null then
      v_json_yw_log.put('bgkid', v_bkid);
      v_json_yw_log.put('bgklx', '07');
      v_json_yw_log.put('ywjlid', v_bkid);
      v_json_yw_log.put('gnmk', '01');
      v_json_yw_log.put('gnmc', '报卡管理');
      v_json_yw_log.put('czlx', '04');
      pkg_zjmb_xtfz.prc_zjjk_yw_log_update(v_json_yw_log, v_err);
      if v_err is not null then
        raise err_custom;
      end if;
    end if;
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_shjc_bgk_sc;
  /*--------------------------------------------------------------------------
  || 功能描述 ：出生报告卡审核
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_shjc_bgk_sh(Data_In    In Clob, --入参
                            result_out OUT VARCHAR2) --返回
   is
    v_json_data   json;
    v_json_yw_log json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
    --公共变量
    v_sysdate    date;
    v_czyjgdm    varchar2(50);
    v_czyjgjb    varchar2(3);
    v_shbz       zjmb_shjc_bgk.vc_shbz%TYPE; --审核状态
    v_shbz_table zjmb_shjc_bgk.vc_shbz%TYPE; --审核状态
    v_bkid       zjmb_shjc_bgk.vc_bgkid%type;
    v_shwtgyy    zjmb_shjc_bgk.vc_shwtgyy%TYPE; --区县审核未通过原因
    v_shwtgyy1   zjmb_shjc_bgk.vc_shwtgyy1%TYPE; --区县审核未通过原因选项
  BEGIN
    json_data(data_in, 'zjmb_shjc_bgk审核', v_json_data);
    v_sysdate  := sysdate;
    v_czyjgdm  := Json_Str(v_Json_Data, 'czyjgdm');
    v_bkid     := Json_Str(v_Json_Data, 'vc_bgkid');
    v_shbz     := Json_Str(v_Json_Data, 'vc_shbz');
    v_shwtgyy  := Json_Str(v_Json_Data, 'vc_shwtgyy');
    v_shwtgyy1 := Json_Str(v_Json_Data, 'vc_shwtgyy1');
    --获取机构级别
    --select fun_getczyjgjb(v_czyjgdm) into v_czyjgjb from dual;
    v_czyjgjb := Json_Str(v_Json_Data, 'czyjgjb');
    --获取报卡状态
    begin
      select vc_shbz
        into v_shbz_table
        from zjmb_shjc_bgk
       where vc_bgkid = v_bkid
         and vc_scbz = '0'
         and vc_shbz = '1';
    exception
      when no_data_found then
        v_err := 'id[' || v_bkid || ']未获取到有效报告卡信息!';
        raise err_custom;
    end;
    if v_czyjgjb <> '3' then
      --非区县
      v_err := '当前机构无审核权限!';
      raise err_custom;
    end if;
    --v_shbz_table := '1';
    if v_shbz_table <> '1' then
      v_err := '报卡当前状态不为区县待审核!';
      raise err_custom;
    end if;
    --判断审核状态
    if v_shbz = '3' then
      v_shwtgyy  := '';
      v_shwtgyy1 := '';
    elsif v_shbz = '4' then
      IF v_shwtgyy1 is null then
        v_err := '审核不通过原因不能为空';
        raise err_custom;
      end if;
    else
      v_err := '传入审核状态[' || v_shbz || ']不正确!';
      raise err_custom;
    end if;
    --更新审核标志
    update zjmb_shjc_bgk
       set vc_shbz     = v_shbz,
           vc_shwtgyy  = v_shwtgyy,
           vc_shwtgyy1 = v_shwtgyy1,
           DT_SHSJ     = v_sysdate,
           dt_xgsj     = sysdate
     where vc_bgkid = v_bkid;
    --添加操作日志
    v_json_yw_log := Json_ext.get_json(v_json_data, 'ywjllog');
    if v_json_yw_log is not null then
      v_json_yw_log.put('bgkid', v_bkid);
      v_json_yw_log.put('bgklx', '07');
      v_json_yw_log.put('ywjlid', v_bkid);
      v_json_yw_log.put('gnmk', '01');
      v_json_yw_log.put('gnmc', '报卡管理');
      v_json_yw_log.put('czlx', '03');
      pkg_zjmb_xtfz.prc_zjjk_yw_log_update(v_json_yw_log, v_err);
      if v_err is not null then
        raise err_custom;
      end if;
    end if;
    v_Json_Return.put('id', v_bkid);
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_shjc_bgk_sh;
  /*--------------------------------------------------------------------------
  || 功能描述 ：获取伤害监测报告卡id
  ||------------------------------------------------------------------------*/
  FUNCTION fun_getbgkid_shjc(prm_jgdm VARCHAR2) --市区及医院码
   RETURN VARCHAR2 is
    v_id zjmb_shjc_bgk.vc_bgkid%type;
    v_dm VARCHAR2(30);
  begin
    if prm_jgdm is null then
      return '';
    end if;
    v_dm := to_char(sysdate, 'yyyy') || substr(prm_jgdm, 3);
    select nvl(max(VC_BGKID) + 1, v_dm || '00001')
      into v_id
      from zjmb_shjc_bgk
     where vc_bgkid like v_dm || '%';
    return v_id;
  END fun_getbgkid_shjc;
  /*--------------------------------------------------------------------------
  || 功能描述 ：伤害监测查重管理
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_shjc_bgk_ccgl(Data_In    In Clob, --入参
                              result_out OUT VARCHAR2) --返回
   is
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err         VARCHAR2(2000);
    v_json_yw_log json;
    v_ywjl_czlx   varchar2(3);
    --公共变量
    v_sysdate       date;
    v_czyjgdm       varchar2(50);
    v_czyjgjb       varchar2(3);
    v_json_list_yx  json_List; --有效卡
    v_json_list_cf  json_List; --重复卡
    v_json_temp_bgk Json;
    v_vc_bgkid      zjmb_shjc_bgk.vc_bgkid%type;
  
  BEGIN
    json_data(data_in, 'zjmb_sw_bgk查重', v_json_data);
    v_sysdate      := sysdate;
    v_czyjgdm      := Json_Str(v_Json_Data, 'czyjgdm'); --操作员机构代码
    v_czyjgjb      := Json_Str(v_Json_Data, 'czyjgjb'); --获取机构级别
    v_Json_List_yx := Json_Ext.Get_Json_List(v_Json_Data, 'yx_arr'); --有效卡
    v_Json_List_cf := Json_Ext.Get_Json_List(v_Json_Data, 'cf_arr'); --重复卡
    if v_czyjgdm is null then
      v_err := '未获取到操作员信息!';
      raise err_custom;
    end if;
  
    --处理有效卡
    if v_json_list_yx.count > 0 then
      for i in 1 .. v_json_list_yx.count loop
        v_json_temp_bgk := Json(v_json_list_yx.Get(i));
        v_vc_bgkid      := Json_Str(v_json_temp_bgk, 'vc_bgkid');
        update zjmb_shjc_bgk a
           set a.vc_ccid = v_czyjgdm, dt_xgsj = sysdate
         where a.vc_bgkid = v_vc_bgkid;
      end loop;
    else
      v_err := '未获取到有效卡!';
      raise err_custom;
    end if;
    --处理重复卡
    if v_json_list_cf.count > 0 then
      for i in 1 .. v_json_list_cf.count loop
        v_json_temp_bgk := Json(v_json_list_cf.Get(i));
        v_vc_bgkid      := Json_Str(v_json_temp_bgk, 'vc_bgkid');
        update zjmb_shjc_bgk a
           set a.vc_ccid  = v_czyjgdm,
               a.vc_bgkzt = '4',
               a.vc_ckbz  = '1',
               dt_xgsj    = sysdate
         where a.vc_bgkid = v_vc_bgkid;
      end loop;
    else
      v_err := '未获取到重复卡!';
      raise err_custom;
    end if;
    --添加操作日志
    v_json_yw_log := Json_ext.get_json(v_json_data, 'ywjllog');
    if v_json_yw_log is not null then
      v_json_yw_log.put('bgkid', '');
      v_json_yw_log.put('bgklx', '07');
      v_json_yw_log.put('ywjlid', '');
      v_json_yw_log.put('gnmk', '08');
      v_json_yw_log.put('gnmc', '查重管理');
      v_json_yw_log.put('czlx', '01');
      pkg_zjmb_xtfz.prc_zjjk_yw_log_update(v_json_yw_log, v_err);
      if v_err is not null then
        raise err_custom;
      end if;
    end if;
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_shjc_bgk_ccgl;
  /*--------------------------------------------------------------------------
  || 功能描述 ：出生报告卡导入
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_cs_bgk_temp_imp(Data_In    In Clob, --入参
                                result_out OUT VARCHAR2) --返回
   is
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err         VARCHAR2(2000);
    v_json_yw_log json;
    v_ywjl_czlx   varchar2(3);
    --公共变量
    v_sysdate       date;
    v_czyjgdm       varchar2(50);
    v_czyjgjb       varchar2(3);
    v_czyyhid       varchar2(50);
    v_json_list_cs  json_List; --出生报告卡
    v_json_temp_bgk Json;
    v_vc_bgkid      zjjk_csbgk_temp.vc_bgkid%type;
    v_vc_drbz       zjjk_csbgk_temp.vc_drbz%type;
    v_vc_dryhmc     zjjk_csbgk_temp.vc_dryhmc%type;
  BEGIN
    json_data(data_in, 'zjjk_csbgk_temp导入', v_json_data);
    v_sysdate      := sysdate;
    v_czyjgdm      := Json_Str(v_Json_Data, 'czyjgdm'); --操作员机构代码
    v_czyyhid      := Json_Str(v_Json_Data, 'czyyhid');
    v_czyjgjb      := Json_Str(v_Json_Data, 'czyjgjb'); --获取机构级别
    v_Json_List_cs := Json_Ext.Get_Json_List(v_Json_Data, 'cs_arr'); --出生信息
  
    if v_czyjgdm is null then
      v_err := '未获取到操作员信息!';
      raise err_custom;
    end if;
    /*if v_czyjgjb not in ('1', '2', '3') then
      v_err := '当前机构无导入权限!';
      raise err_custom;
    end if;*/
    --写入数据
    if v_json_list_cs.count > 0 then
      for i in 1 .. v_json_list_cs.count loop
        v_json_temp_bgk := Json(v_json_list_cs.Get(i));
        v_vc_bgkid      := Json_Str(v_json_temp_bgk, 'vc_bgkid');
        if v_vc_bgkid is null then
          v_err := '出生证号不能为空!';
          raise err_custom;
        end if;
        --检查是否已经导入
        begin
          select vc_drbz, vc_dryhmc
            into v_vc_drbz, v_vc_dryhmc
            from zjjk_csbgk_temp a
           where a.vc_bgkid = v_vc_bgkid;
        exception
          when no_data_found then
            v_vc_drbz := '';
        end;
        --新增
        if v_vc_drbz is null then
          insert into zjjk_csbgk_temp
            (vc_bgkid,
             vc_xm,
             vc_xb,
             vc_csrq,
             vc_fqxm,
             vc_mqxm,
             vc_qfrq,
             vc_mqnl,
             vc_fqnl,
             vc_csd,
             vc_yz,
             vc_jkzk,
             vc_sc,
             vc_tz,
             vc_fqgj,
             vc_fqmz,
             vc_mqgj,
             vc_mqmz,
             vc_fqsfz,
             vc_mqsfz,
             vc_jsjgmc,
             vc_jsr,
             vc_hjszd,
             vc_lxdh,
             vc_jtzz,
             vc_csddfl,
             vc_dryhmc,
             vc_dryhqxdm,
             vc_drsj,
             vc_drbz,
             vc_hjjd)
          values
            (v_vc_bgkid,
             Json_Str(v_json_temp_bgk, 'vc_xm'),
             Json_Str(v_json_temp_bgk, 'vc_xb'),
             Json_Str(v_json_temp_bgk, 'vc_csrq'),
             Json_Str(v_json_temp_bgk, 'vc_fqxm'),
             Json_Str(v_json_temp_bgk, 'vc_mqxm'),
             Json_Str(v_json_temp_bgk, 'vc_qfrq'),
             Json_Str(v_json_temp_bgk, 'vc_mqnl'),
             Json_Str(v_json_temp_bgk, 'vc_fqnl'),
             Json_Str(v_json_temp_bgk, 'vc_csd'),
             Json_Str(v_json_temp_bgk, 'vc_yz'),
             Json_Str(v_json_temp_bgk, 'vc_jkzk'),
             Json_Str(v_json_temp_bgk, 'vc_sc'),
             Json_Str(v_json_temp_bgk, 'vc_tz'),
             Json_Str(v_json_temp_bgk, 'vc_fqgj'),
             Json_Str(v_json_temp_bgk, 'vc_fqmz'),
             Json_Str(v_json_temp_bgk, 'vc_mqgj'),
             Json_Str(v_json_temp_bgk, 'vc_mqmz'),
             Json_Str(v_json_temp_bgk, 'vc_fqsfz'),
             Json_Str(v_json_temp_bgk, 'vc_mqsfz'),
             Json_Str(v_json_temp_bgk, 'vc_jsjgmc'),
             Json_Str(v_json_temp_bgk, 'vc_jsr'),
             Json_Str(v_json_temp_bgk, 'vc_hjszd'),
             Json_Str(v_json_temp_bgk, 'vc_lxdh'),
             Json_Str(v_json_temp_bgk, 'vc_jtzz'),
             Json_Str(v_json_temp_bgk, 'vc_csddfl'),
             v_czyjgdm,
             v_czyjgdm,
             dts(v_sysdate, 1),
             '0',
             Json_Str(v_json_temp_bgk, 'vc_hjjd'));
        else
          if v_vc_dryhmc <> v_czyyhid then
            v_err := '出生证号[' || v_vc_bgkid || ']其他用户已导入';
            raise err_custom;
          end if;
          --修改导入信息
          if v_vc_drbz = '0' or v_vc_drbz = '2' then
            update zjjk_csbgk_temp
               set vc_xm       = Json_Str(v_json_temp_bgk, 'vc_xm'),
                   vc_xb       = Json_Str(v_json_temp_bgk, 'vc_xb'),
                   vc_csrq     = Json_Str(v_json_temp_bgk, 'vc_csrq'),
                   vc_fqxm     = Json_Str(v_json_temp_bgk, 'vc_fqxm'),
                   vc_mqxm     = Json_Str(v_json_temp_bgk, 'vc_mqxm'),
                   vc_qfrq     = Json_Str(v_json_temp_bgk, 'vc_qfrq'),
                   vc_mqnl     = Json_Str(v_json_temp_bgk, 'vc_mqnl'),
                   vc_fqnl     = Json_Str(v_json_temp_bgk, 'vc_fqnl'),
                   vc_csd      = Json_Str(v_json_temp_bgk, 'vc_csd'),
                   vc_yz       = Json_Str(v_json_temp_bgk, 'vc_yz'),
                   vc_jkzk     = Json_Str(v_json_temp_bgk, 'vc_jkzk'),
                   vc_sc       = Json_Str(v_json_temp_bgk, 'vc_sc'),
                   vc_tz       = Json_Str(v_json_temp_bgk, 'vc_tz'),
                   vc_fqgj     = Json_Str(v_json_temp_bgk, 'vc_fqgj'),
                   vc_fqmz     = Json_Str(v_json_temp_bgk, 'vc_fqmz'),
                   vc_mqgj     = Json_Str(v_json_temp_bgk, 'vc_mqgj'),
                   vc_mqmz     = Json_Str(v_json_temp_bgk, 'vc_mqmz'),
                   vc_fqsfz    = Json_Str(v_json_temp_bgk, 'vc_fqsfz'),
                   vc_mqsfz    = Json_Str(v_json_temp_bgk, 'vc_mqsfz'),
                   vc_jsjgmc   = Json_Str(v_json_temp_bgk, 'vc_jsjgmc'),
                   vc_jsr      = Json_Str(v_json_temp_bgk, 'vc_jsr'),
                   vc_hjszd    = Json_Str(v_json_temp_bgk, 'vc_hjszd'),
                   vc_lxdh     = Json_Str(v_json_temp_bgk, 'vc_lxdh'),
                   vc_jtzz     = Json_Str(v_json_temp_bgk, 'vc_jtzz'),
                   vc_csddfl   = Json_Str(v_json_temp_bgk, 'vc_csddfl'),
                   vc_dryhmc   = v_czyyhid,
                   vc_dryhqxdm = v_czyjgdm,
                   vc_drsj     = dts(v_sysdate, 1),
                   vc_hjjd     = Json_Str(v_json_temp_bgk, 'vc_hjjd'),
                   vc_drsbyy   = ''
             where vc_bgkid = v_vc_bgkid
               and vc_dryhmc = v_czyyhid
               and vc_drbz = '0';
          end if;
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
      v_json_yw_log.put('gnmk', '01');
      v_json_yw_log.put('gnmc', '导入');
      v_json_yw_log.put('czlx', '05');
      pkg_zjmb_xtfz.prc_zjjk_yw_log_update(v_json_yw_log, v_err);
      if v_err is not null then
        raise err_custom;
      end if;
    end if;
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_cs_bgk_temp_imp;
  /*--------------------------------------------------------------------------
  || 功能描述 ：出生报告卡导入接收
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_cs_bgk_temp_imp_js(Data_In    In Clob, --入参
                                   result_out OUT VARCHAR2) --返回
   is
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err         VARCHAR2(2000);
    v_json_yw_log json;
    v_ywjl_czlx   varchar2(3);
    --公共变量
    v_sysdate      date;
    v_czyjgdm      varchar2(50);
    v_czyjgjb      varchar2(3);
    v_czyyhid      varchar2(50);
    v_json_list_cs json_List; --出生报告卡
    v_vc_temp_id   zjjk_csbgk_temp.vc_bgkid%type;
  
    v_vc_swyy     zjmb_cs_bgk.vc_swyy%TYPE; --死亡原因
    v_dt_czsj     zjmb_cs_bgk.dt_czsj%TYPE; --创建时间
    v_vc_czyh     zjmb_cs_bgk.vc_czyh%TYPE; --创建用户
    v_dt_xgsj     zjmb_cs_bgk.dt_xgsj%TYPE; --修改时间
    v_vc_xgyh     zjmb_cs_bgk.vc_xgyh%TYPE; --修改用户
    v_vc_bgklb    zjmb_cs_bgk.vc_bgklb%TYPE; --报告卡类别
    v_vc_bz       zjmb_cs_bgk.vc_bz%TYPE; --备注
    v_vc_sdm      zjmb_cs_bgk.vc_sdm%TYPE; --户口市代码
    v_vc_qdm      zjmb_cs_bgk.vc_qdm%TYPE; --户口区代码
    v_vc_jddm     zjmb_cs_bgk.vc_jddm%TYPE; --户口街道代码
    v_vc_shbz     zjmb_cs_bgk.vc_shbz%TYPE; --审核标志
    v_vc_khid     zjmb_cs_bgk.vc_khid%TYPE; --考核ID
    v_vc_khzt     zjmb_cs_bgk.vc_khzt%TYPE; --考核状态
    v_vc_shid     zjmb_cs_bgk.vc_shid%TYPE; --审核ID
    v_vc_cssdm    zjmb_cs_bgk.vc_cssdm%TYPE; --出生市代码
    v_vc_csqxdm   zjmb_cs_bgk.vc_csqxdm%TYPE; --出生区县代码
    v_vc_csjddm   zjmb_cs_bgk.vc_csjddm%TYPE; --出生街道代码
    v_vc_hkqc     zjmb_cs_bgk.vc_hkqc%TYPE; --户口迁出
    v_vc_qcsdm    zjmb_cs_bgk.vc_qcsdm%TYPE; --户口迁出市
    v_vc_qcqxdm   zjmb_cs_bgk.vc_qcqxdm%TYPE; --户口迁出区县
    v_vc_qcjddm   zjmb_cs_bgk.vc_qcjddm%TYPE; --户口迁出街道
    v_dt_qcsj     zjmb_cs_bgk.dt_qcsj%TYPE; --迁出时间
    v_vc_qcxxdz   zjmb_cs_bgk.vc_qcxxdz%TYPE; --户口迁出详细地址
    v_vc_cszh     zjmb_cs_bgk.vc_cszh%TYPE; --出生证号
    v_vc_hkxxdz   zjmb_cs_bgk.vc_hkxxdz%TYPE; --户口详细地址
    v_vc_csjw     zjmb_cs_bgk.vc_csjw%TYPE; --出生居委
    v_vc_hkjw     zjmb_cs_bgk.vc_hkjw%TYPE; --户口居委
    v_vc_fqgjqt   zjmb_cs_bgk.vc_fqgjqt%TYPE; --父亲国籍其他
    v_vc_mqgjqt   zjmb_cs_bgk.vc_mqgjqt%TYPE; --母亲国籍其他
    v_vc_csddflqt zjmb_cs_bgk.vc_csddflqt%TYPE; --出生地点分类其他
    v_vc_jsdw     zjmb_cs_bgk.vc_jsdw%TYPE; --接生单位
    v_dt_qfrq     zjmb_cs_bgk.dt_qfrq%TYPE; --签发日期
    v_vc_qcjw     zjmb_cs_bgk.vc_qcjw%TYPE; --迁出居委
    v_vc_csdd     zjmb_cs_bgk.vc_csdd%TYPE; --出生省份
    v_vc_hkqcd    zjmb_cs_bgk.vc_hkqcd%TYPE; --户口迁出地省份
    v_vc_jsdwszs  zjmb_cs_bgk.vc_jsdwszs%TYPE; --接生单位所在市
    v_vc_jsdwszq  zjmb_cs_bgk.vc_jsdwszq%TYPE; --接生单位所在区
    v_vc_bgkzt    zjmb_cs_bgk.vc_bgkzt%TYPE; --报告卡状态
    v_vc_xxly     zjmb_cs_bgk.vc_xxly%TYPE; --信息来源
    v_vc_shzt     zjmb_cs_bgk.vc_shzt%TYPE; --审核状态
    v_vc_khbz     zjmb_cs_bgk.vc_khbz%TYPE; --考核标志
    v_vc_sdqr     zjmb_cs_bgk.vc_sdqr%TYPE; --属地确认
    v_vc_khjg     zjmb_cs_bgk.vc_khjg%TYPE; --考核结果
    v_vc_hkshfdm  zjmb_cs_bgk.vc_hkshfdm%TYPE; --户口省份代码
    v_vc_sfsw     zjmb_cs_bgk.vc_sfsw%TYPE; --是否死亡
    v_vc_shwtgyy  zjmb_cs_bgk.vc_shwtgyy%TYPE; --区县审核未通过原因
    v_vc_shwtgyy1 zjmb_cs_bgk.vc_shwtgyy1%TYPE; --区县审核未通过原因选项
    v_vc_jkdws    zjmb_cs_bgk.vc_jkdws%TYPE; --建卡单位市
    v_vc_jkdwqx   zjmb_cs_bgk.vc_jkdwqx%TYPE; --建卡单位区县
    v_dt_qxshsj   zjmb_cs_bgk.dt_qxshsj%TYPE; --区县审核时间
    v_dt_yyshsj   zjmb_cs_bgk.dt_yyshsj%TYPE; --医院审核时间
    v_vc_bgkid    zjmb_cs_bgk.vc_bgkid%TYPE; --VC_BGKID
    v_vc_ccid     zjmb_cs_bgk.vc_ccid%TYPE; --查重ID
    v_vc_ckbz     zjmb_cs_bgk.vc_ckbz%TYPE; --重卡标志
    v_vc_xsrid    zjmb_cs_bgk.vc_xsrid%TYPE; --新生儿姓名
    v_vc_jkdw     zjmb_cs_bgk.vc_jkdw%TYPE; --建卡医院
    v_vc_jkys     zjmb_cs_bgk.vc_jkys%TYPE; --建卡医生
    v_dt_jksj     zjmb_cs_bgk.dt_jksj%TYPE; --建卡时间
    v_vc_qyid     zjmb_cs_bgk.vc_qyid%TYPE; --迁移ID
    v_vc_xsrxb    zjmb_cs_bgk.vc_xsrxb%TYPE; --新生儿性别
    v_dt_csrq     zjmb_cs_bgk.dt_csrq%TYPE; --出生日期
    v_vc_csyz     zjmb_cs_bgk.vc_csyz%TYPE; --出生孕周
    v_nb_cstz     zjmb_cs_bgk.nb_cstz%TYPE; --出生体重
    v_nb_cssc     zjmb_cs_bgk.nb_cssc%TYPE; --出生身长
    v_vc_csxxdz   zjmb_cs_bgk.vc_csxxdz%TYPE; --出生详细地址
    v_vc_hkd      zjmb_cs_bgk.vc_hkd%TYPE; --接生单位省
    v_vc_hjhs     zjmb_cs_bgk.vc_hjhs%TYPE; --户籍核实
    v_vc_whsyy    zjmb_cs_bgk.vc_whsyy%TYPE; --未核实原因
    v_vc_jkzt     varchar2(100); --健康状态
    v_vc_mqxm     zjmb_cs_bgk.vc_mqxm%TYPE; --母亲姓名
    v_vc_mqnl     zjmb_cs_bgk.vc_mqnl%TYPE; --母亲年龄
    v_vc_mqgj     varchar2(100); --母亲国籍
    v_vc_mqmz     zjmb_cs_bgk.vc_mqmz%TYPE; --母亲民族
    v_vc_mqsfzbh  zjmb_cs_bgk.vc_mqsfzbh%TYPE; --母亲身份证编号
    v_vc_mqhkszd  zjmb_cs_bgk.vc_mqhkszd%TYPE; --母亲户口所在地
    v_vc_fqxm     zjmb_cs_bgk.vc_fqxm%TYPE; --父亲姓名
    v_vc_fqnl     zjmb_cs_bgk.vc_fqnl%TYPE; --父亲年龄
    v_vc_fqgj     varchar2(100); --父亲国籍
    v_vc_fqmz     zjmb_cs_bgk.vc_fqmz%TYPE; --父亲民族
    v_vc_fqsfzbh  zjmb_cs_bgk.vc_fqsfzbh%TYPE; --父亲身份证编号
    v_vc_fqhkszd  zjmb_cs_bgk.vc_fqhkszd%TYPE; --父亲户口所在地
    v_vc_jtjzdz   zjmb_cs_bgk.vc_jtjzdz%TYPE; --具体居住地址
    v_vc_csddfl   zjmb_cs_bgk.vc_csddfl%TYPE; --出生地点分类
    v_vc_xsrjhrjz zjmb_cs_bgk.vc_xsrjhrjz%TYPE; --新生儿监护人签章
    v_vc_jsrqz    zjmb_cs_bgk.vc_jsrqz%TYPE; --接生人员签字
    v_vc_jsjgmc   zjmb_cs_bgk.vc_jsjgmc%TYPE; --接生机构名称
    v_vc_lxdh     zjmb_cs_bgk.vc_lxdh%TYPE; --联系电话
    v_vc_yzbm     zjmb_cs_bgk.vc_yzbm%TYPE; --邮政编码
    v_vc_csyyjlbh zjmb_cs_bgk.vc_csyyjlbh%TYPE; --出生医院记录编号
    v_vc_mqblh    zjmb_cs_bgk.vc_mqblh%TYPE; --母亲病历号
    v_vc_scbz     zjmb_cs_bgk.vc_scbz%TYPE; --删除标志
    v_vc_gldwdm   zjmb_cs_bgk.vc_gldwdm%TYPE; --管理单位代码
    v_vc_czdwdm   zjmb_cs_bgk.vc_czdwdm%TYPE; --创建单位代码
    v_vc_xsrsfch  zjmb_cs_bgk.vc_xsrsfch%TYPE; --新生儿是否存活
    v_dt_swrq     zjmb_cs_bgk.dt_swrq%TYPE; --死亡日期
  
    v_vc_csd    zjjk_csbgk_temp.vc_csd%type;
    v_vc_hjszd  zjjk_csbgk_temp.vc_hjszd%type;
    v_vc_drbz   zjjk_csbgk_temp.vc_drbz%type;
    v_xzdm_like varchar2(20);
    v_jsdwdm    varchar2(50);
    v_count     number;
  BEGIN
    json_data(data_in, 'ZJMB_CS_BGK导入接收', v_json_data);
    v_sysdate      := sysdate;
    v_czyjgdm      := Json_Str(v_Json_Data, 'czyjgdm'); --操作员机构代码
    v_czyyhid      := Json_Str(v_Json_Data, 'v_czyyhid');
    v_czyjgjb      := Json_Str(v_Json_Data, 'czyjgjb'); --获取机构级别
    v_Json_List_cs := Json_Ext.Get_Json_List(v_Json_Data, 'cs_arr'); --出生信息
    if v_czyjgdm is null then
      v_err := '未获取到操作员信息!';
      raise err_custom;
    end if;
  
    --导入接收
    if v_json_list_cs.count > 0 then
      for i in 1 .. v_json_list_cs.count loop
        v_vc_temp_id := v_json_list_cs.Get(i).get_string;
        begin
          select vc_xm,
                 vc_xb,
                 std(vc_csrq, 0),
                 vc_fqxm,
                 vc_mqxm,
                 vc_mqnl,
                 vc_fqnl,
                 vc_csd,
                 vc_yz,
                 vc_jkzk,
                 vc_sc,
                 vc_tz,
                 vc_fqgj,
                 vc_fqmz,
                 vc_mqgj,
                 vc_mqmz,
                 vc_fqsfz,
                 vc_mqsfz,
                 vc_jsjgmc,
                 vc_jsr,
                 vc_hjszd,
                 vc_lxdh,
                 vc_jtzz,
                 vc_csddfl,
                 vc_drbz,
                 vc_hjjd,
                 std(vc_qfrq, 0)
            into v_vc_xsrid,
                 v_vc_xsrxb,
                 v_dt_csrq,
                 v_vc_fqxm,
                 v_vc_mqxm,
                 v_vc_mqnl,
                 v_vc_fqnl,
                 v_vc_csd,
                 v_vc_csyz,
                 v_vc_jkzt,
                 v_nb_cssc,
                 v_nb_cstz,
                 v_vc_fqgj,
                 v_vc_fqmz,
                 v_vc_mqgj,
                 v_vc_mqmz,
                 v_vc_fqsfzbh,
                 v_vc_mqsfzbh,
                 v_vc_jsjgmc,
                 v_vc_jsrqz,
                 v_vc_hjszd,
                 v_vc_lxdh,
                 v_vc_hkxxdz,
                 v_vc_csddfl,
                 v_vc_drbz,
                 v_vc_jddm,
                 v_dt_qfrq
            from zjjk_csbgk_temp
           where vc_bgkid = v_vc_temp_id;
        exception
          when no_data_found then
            v_err := '出生证号[' || v_vc_temp_id || ']未获取到已导入的出生报告';
            raise err_custom;
        end;
        --导入数据未引用过,则引用
        if nvl(v_vc_drbz, '0') <> '1' then
          update zjjk_csbgk_temp
             set vc_drbz = '1'
           where vc_bgkid = v_vc_temp_id;
        end if;
        v_vc_qyid   := '1';
        v_vc_bgkzt  := '0';
        v_vc_shbz   := '3';
        v_vc_scbz   := '2';
        v_dt_jksj   := v_sysdate;
        v_dt_yyshsj := v_sysdate;
        v_dt_qxshsj := v_sysdate;
        v_dt_czsj   := v_sysdate;
        v_dt_xgsj   := v_sysdate;
        if upper(substr(v_vc_temp_id, 1, 2)) = 'CS' then
          v_vc_cszh := '';
        else
          v_vc_cszh := v_vc_temp_id;
        end if;
        select pkg_zjmb_tnb.fun_getcommdiccode('C_COMM_XB',
                                               substr(v_vc_xsrxb, 1, 1)),
               pkg_zjmb_tnb.fun_getcommdiccode('C_COMM_MZ', v_vc_fqmz),
               pkg_zjmb_tnb.fun_getcommdiccode('C_COMM_MZ', v_vc_mqmz),
               pkg_zjmb_tnb.fun_getcommdiccode('C_ZJMB_JKZK', v_vc_jkzt)
        
          into v_vc_xsrxb, v_vc_fqmz, v_vc_mqmz, v_vc_jkzt
          from dual;
        --获取出生地址
        if v_vc_csd is not null then
          select pkg_zjmb_tnb.fun_getxxqhdm(1, substr(v_vc_csd, 1, 2), '')
            into v_vc_csdd
            from dual;
          if v_vc_csdd is not null then
            v_xzdm_like := substr(v_vc_csdd, 1, 2);
            select pkg_zjmb_tnb.fun_getxxqhdm(2,
                                              substr(v_vc_csd, 3, 2),
                                              v_xzdm_like),
                   pkg_zjmb_tnb.fun_getxxqhdm(3,
                                              substr(v_vc_csd, 5, 2),
                                              v_xzdm_like)
              into v_vc_cssdm, v_vc_csqxdm
              from dual;
          end if;
        end if;
        if v_vc_fqgj = '中国' then
          v_vc_fqgj := '1';
        else
          if v_vc_fqgj <> '2' then
            v_vc_fqgj := '';
          end if;
        end if;
        if v_vc_mqgj = '中国' then
          v_vc_mqgj := '1';
        else
          if v_vc_mqgj <> '2' then
            v_vc_mqgj := '';
          end if;
        end if;
        --获取户籍地址
        if substr(v_vc_hjszd, 1, 2) = '浙江' then
          v_vc_hkshfdm := '0';
          --户口市、县
          select pkg_zjmb_tnb.fun_getxxqhdm(2,
                                            substr(v_vc_hjszd, 3, 2),
                                            '33'),
                 pkg_zjmb_tnb.fun_getxxqhdm(3,
                                            substr(v_vc_hjszd, 5, 2),
                                            '33')
            into v_vc_sdm, v_vc_qdm
            from dual;
          if v_vc_qdm is not null then
            --户口街道
            select pkg_zjmb_tnb.fun_getxxqhdm(4,
                                              v_vc_jddm,
                                              substr(v_vc_qdm, 1, 6))
              into v_vc_jddm
              from dual;
          end if;
        else
          v_vc_hkshfdm := '1';
        end if;
        --获取接生单位
        if v_vc_jsjgmc is not null then
          select max(dm)
            into v_jsdwdm
            from p_yljg a
           where a.mc like '%' || v_vc_jsjgmc || '%';
        end if;
        v_vc_gldwdm := v_vc_qdm;
        v_vc_hkd    := '0';
        if length(v_jsdwdm) = 9 then
          v_vc_jsdwszs := substr(v_jsdwdm, 1, 4) || '0000';
          v_vc_jsdwszq := substr(v_jsdwdm, 1, 6) || '00';
          v_vc_jsdw    := v_jsdwdm;
          v_vc_jkdw    := v_jsdwdm;
          v_vc_jkdws   := substr(v_jsdwdm, 1, 4) || '0000';
          v_vc_jkdwqx  := substr(v_jsdwdm, 1, 6) || '00';
          v_vc_czdwdm  := v_jsdwdm;
        end if;
        --死亡状态
        if v_vc_jkzt = '4' then
          v_vc_bgkzt := '7';
          v_vc_sfsw  := '1';
        else
          v_vc_bgkzt := '0';
          v_vc_sfsw  := '0';
        end if;
        --属地确认
        select count(1), wm_concat(a.code)
          into v_count, v_vc_gldwdm
          from organ_node a
         where a.removed = 0
           and a.description like '%' || v_vc_jddm || '%';
        if v_count = 1 then
          --确定属地
          v_vc_sdqr := '1';
        else
          v_vc_gldwdm := v_vc_qdm;
          v_vc_sdqr   := '0';
        end if;
        --外省
        if v_vc_hkshfdm = '1' then
          v_vc_gldwdm := '99999999';
          v_vc_sdm    := '';
          v_vc_qdm    := '';
          v_vc_jddm   := '';
          v_vc_hkjw   := '';
        end if;
        if v_vc_jsdw is not null then
          --获取报告卡id
          if v_vc_hkd = '0' then
            --浙江省
            select fun_getbgkid_cs(v_sysdate, substr(v_czyjgdm, 3))
              into v_vc_bgkid
              from dual;
          else
            --外省
            select fun_getbgkid_cs(v_sysdate, '0000000')
              into v_vc_bgkid
              from dual;
          end if;
          --写入出生报告卡
          insert into zjmb_cs_bgk
            (vc_bgkid,
             vc_ccid,
             vc_ckbz,
             vc_xsrid,
             vc_jkdw,
             vc_jkys,
             dt_jksj,
             vc_qyid,
             vc_xsrxb,
             dt_csrq,
             vc_csyz,
             nb_cstz,
             nb_cssc,
             vc_csxxdz,
             vc_hkd,
             vc_hjhs,
             vc_whsyy,
             vc_jkzt,
             vc_mqxm,
             vc_mqnl,
             vc_mqgj,
             vc_mqmz,
             vc_mqsfzbh,
             vc_mqhkszd,
             vc_fqxm,
             vc_fqnl,
             vc_fqgj,
             vc_fqmz,
             vc_fqsfzbh,
             vc_fqhkszd,
             vc_jtjzdz,
             vc_csddfl,
             vc_xsrjhrjz,
             vc_jsrqz,
             vc_jsjgmc,
             vc_lxdh,
             vc_yzbm,
             vc_csyyjlbh,
             vc_mqblh,
             vc_scbz,
             vc_gldwdm,
             vc_czdwdm,
             vc_xsrsfch,
             dt_swrq,
             vc_swyy,
             dt_czsj,
             vc_czyh,
             dt_xgsj,
             vc_xgyh,
             vc_bgklb,
             vc_bz,
             vc_sdm,
             vc_qdm,
             vc_jddm,
             vc_shbz,
             vc_khid,
             vc_khzt,
             vc_shid,
             vc_cssdm,
             vc_csqxdm,
             vc_csjddm,
             vc_hkqc,
             vc_qcsdm,
             vc_qcqxdm,
             vc_qcjddm,
             dt_qcsj,
             vc_qcxxdz,
             vc_cszh,
             vc_hkxxdz,
             vc_csjw,
             vc_hkjw,
             vc_fqgjqt,
             vc_mqgjqt,
             vc_csddflqt,
             vc_jsdw,
             dt_qfrq,
             vc_qcjw,
             vc_csdd,
             vc_hkqcd,
             vc_jsdwszs,
             vc_jsdwszq,
             vc_bgkzt,
             vc_xxly,
             vc_shzt,
             vc_khbz,
             vc_sdqr,
             vc_khjg,
             vc_hkshfdm,
             vc_sfsw,
             vc_shwtgyy,
             vc_shwtgyy1,
             vc_jkdws,
             vc_jkdwqx,
             dt_qxshsj,
             dt_yyshsj)
          values
            (v_vc_bgkid,
             v_vc_ccid,
             v_vc_ckbz,
             v_vc_xsrid,
             v_czyjgdm,
             v_vc_jkys,
             v_dt_jksj,
             v_vc_qyid,
             v_vc_xsrxb,
             v_dt_csrq,
             v_vc_csyz,
             v_nb_cstz,
             v_nb_cssc,
             v_vc_csxxdz,
             v_vc_hkd,
             v_vc_hjhs,
             v_vc_whsyy,
             v_vc_jkzt,
             v_vc_mqxm,
             v_vc_mqnl,
             v_vc_mqgj,
             v_vc_mqmz,
             v_vc_mqsfzbh,
             v_vc_mqhkszd,
             v_vc_fqxm,
             v_vc_fqnl,
             v_vc_fqgj,
             v_vc_fqmz,
             v_vc_fqsfzbh,
             v_vc_fqhkszd,
             v_vc_jtjzdz,
             v_vc_csddfl,
             v_vc_xsrjhrjz,
             v_vc_jsrqz,
             v_vc_jsjgmc,
             v_vc_lxdh,
             v_vc_yzbm,
             v_vc_csyyjlbh,
             v_vc_mqblh,
             v_vc_scbz,
             v_vc_gldwdm,
             v_vc_czdwdm,
             v_vc_xsrsfch,
             v_dt_swrq,
             v_vc_swyy,
             v_dt_czsj,
             v_vc_czyh,
             v_dt_xgsj,
             v_vc_xgyh,
             v_vc_bgklb,
             v_vc_bz,
             v_vc_sdm,
             v_vc_qdm,
             v_vc_jddm,
             v_vc_shbz,
             v_vc_khid,
             v_vc_khzt,
             v_vc_shid,
             v_vc_cssdm,
             v_vc_csqxdm,
             v_vc_csjddm,
             v_vc_hkqc,
             v_vc_qcsdm,
             v_vc_qcqxdm,
             v_vc_qcjddm,
             v_dt_qcsj,
             v_vc_qcxxdz,
             v_vc_cszh,
             v_vc_hkxxdz,
             v_vc_csjw,
             v_vc_hkjw,
             v_vc_fqgjqt,
             v_vc_mqgjqt,
             v_vc_csddflqt,
             v_vc_jsdw,
             v_dt_qfrq,
             v_vc_qcjw,
             decode(v_vc_csdd, '33000000', '0', '1'),
             v_vc_hkqcd,
             v_vc_jsdwszs,
             v_vc_jsdwszq,
             v_vc_bgkzt,
             v_vc_xxly,
             v_vc_shzt,
             v_vc_khbz,
             v_vc_sdqr,
             v_vc_khjg,
             v_vc_hkshfdm,
             v_vc_sfsw,
             v_vc_shwtgyy,
             v_vc_shwtgyy1,
             v_vc_jkdws,
             v_vc_jkdwqx,
             v_dt_qxshsj,
             v_dt_yyshsj);
        else
          update zjjk_csbgk_temp
             set vc_drbz = '2', vc_drsbyy = '接生单位在系统中未匹配到数据'
           where vc_bgkid = v_vc_temp_id;
        end if;
      end loop;
    else
      v_err := '未获取到需要接收的数据!';
      raise err_custom;
    end if;
    --添加操作日志
    v_json_yw_log := Json_ext.get_json(v_json_data, 'ywjllog');
  
    if v_json_yw_log is not null then
      v_json_yw_log.put('bgkid', '');
      v_json_yw_log.put('bgklx', '04');
      v_json_yw_log.put('ywjlid', '');
      v_json_yw_log.put('gnmk', '01');
      v_json_yw_log.put('gnmc', '导入接收');
      v_json_yw_log.put('czlx', '05');
      pkg_zjmb_xtfz.prc_zjjk_yw_log_update(v_json_yw_log, v_err);
      if v_err is not null then
        raise err_custom;
      end if;
    end if;
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_cs_bgk_temp_imp_js;
  /*--------------------------------------------------------------------------
  || 功能描述 ：出生报告卡导入删除
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_cs_bgk_temp_imp_delete(Data_In    In Clob, --入参
                                       result_out OUT VARCHAR2) --返回
   is
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err         VARCHAR2(2000);
    v_json_yw_log json;
    v_ywjl_czlx   varchar2(3);
    --公共变量
    v_sysdate      date;
    v_czyjgdm      varchar2(50);
    v_czyjgjb      varchar2(3);
    v_czyyhid      varchar2(50);
    v_json_list_cs json_List; --出生报告卡
    v_vc_temp_id   zjjk_csbgk_temp.vc_bgkid%type;
    v_jsdwdm       varchar2(50);
    v_count        number;
  BEGIN
    json_data(data_in, 'ZJMB_CS_BGK导入删除', v_json_data);
    v_sysdate      := sysdate;
    v_czyjgdm      := Json_Str(v_Json_Data, 'czyjgdm'); --操作员机构代码
    v_czyyhid      := Json_Str(v_Json_Data, 'v_czyyhid');
    v_czyjgjb      := Json_Str(v_Json_Data, 'czyjgjb'); --获取机构级别
    v_Json_List_cs := Json_Ext.Get_Json_List(v_Json_Data, 'cs_arr'); --出生信息
  
    if v_czyjgdm is null then
      v_err := '未获取到操作员信息!';
      raise err_custom;
    end if;
  
    --导入接收
    if v_json_list_cs.count > 0 then
      for i in 1 .. v_json_list_cs.count loop
        v_vc_temp_id := v_json_list_cs.Get(i).get_string;
        delete from zjjk_csbgk_temp where vc_bgkid = v_vc_temp_id;
        if sql%rowcount = 0 then
          v_err := '出生证号[' || v_vc_temp_id || ']未获取到已导入的出生报告';
          raise err_custom;
        end if;
      end loop;
    else
      v_err := '未获取到需要接收的数据!';
      raise err_custom;
    end if;
    --添加操作日志
    v_json_yw_log := Json_ext.get_json(v_json_data, 'ywjllog');
    if v_json_yw_log is not null then
      v_json_yw_log.put('bgkid', '');
      v_json_yw_log.put('bgklx', '04');
      v_json_yw_log.put('ywjlid', '');
      v_json_yw_log.put('gnmk', '01');
      v_json_yw_log.put('gnmc', '导入删除');
      v_json_yw_log.put('czlx', '04');
      pkg_zjmb_xtfz.prc_zjjk_yw_log_update(v_json_yw_log, v_err);
      if v_err is not null then
        raise err_custom;
      end if;
    end if;
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_cs_bgk_temp_imp_delete;
end pkg_zjmb_smtj;
