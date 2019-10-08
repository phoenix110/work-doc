CREATE OR REPLACE PACKAGE BODY pkg_auth AS
  --初始化包序号--
  /******************************************************************************/
  /*  程序包名 ：pkg_auth                                                     */
  /*  业务环节 ：权限注册管理                                                 */
  /*                                                                          */
  /*  作    者 ：          作成日期 ：2018-03-14   版本编号 ：Ver 1.0.0       */
  /*----------------------------------------------------------------------------*/
  /*  修改记录 ：                                                               */
  /******************************************************************************/
  /*--------------------------------------------------------------------------
  || 功能描述 ：获取菜单编号
  ||------------------------------------------------------------------------*/
  FUNCTION f_get_maxmkbh(v_xtbh In Varchar2, --系统编号
                         v_sjid In Varchar2) --上级id
   RETURN VARCHAR2 is
    v_mkbh  Varchar2(100);
    v_count number;
  Begin
    --取上级ID最大ID加1
    select lpad(to_number(max(mkbh)) + 1, length(max(mkbh)), 0)
      into v_mkbh
      from xtcd
     where xtbh = v_xtbh
       and mkbh like v_xtbh || '%'
       and sjid = v_sjid;
    if v_mkbh is null then
      --获取上级编号加1
      select lpad(to_number(max(mkbh)) + 1, length(max(mkbh)), 0)
        into v_mkbh
        from xtcd
       where xtbh = v_xtbh
         and mkbh like v_xtbh || '%'
         and id = v_sjid;
    end if;
    select count(1) into v_count from xtcd where mkbh = v_mkbh;
    --如果编号存在
    if v_count > 0 then
      --获取系统编号最大的加1
      select lpad(to_number(max(mkbh)) + 1, length(max(mkbh)), 0)
        into v_mkbh
        from xtcd
       where xtbh = v_xtbh
         and mkbh like v_xtbh || '%';
    end if;
    Return v_mkbh;
  Exception
    When Others Then
      Return '';
  End f_get_maxmkbh;
  /*--------------------------------------------------------------------------
  || 功能描述 ：系统菜单新增或修改
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_xtcd_update(Data_In    In Clob, --入参
                            result_out OUT VARCHAR2) --返回
   is
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
    --公共变量
    v_sysdate date;
    v_czyjgdm varchar2(50);
    v_czyjgjb varchar2(3);
  
    v_cdlx     xtcd.cdlx%TYPE; --菜单类型1:菜单2权限3虚拟模块
    v_id       xtcd.id%TYPE; --id
    v_sjid     xtcd.sjid%TYPE; --上级id
    v_xh       xtcd.xh%TYPE; --序号
    v_bt       xtcd.bt%TYPE; --标题
    v_sm       xtcd.sm%TYPE; --说明
    v_xtbh     xtcd.xtbh%TYPE; --系统编号
    v_mkbh     xtcd.mkbh%TYPE; --模块编号
    v_zt       xtcd.zt%TYPE; --状态
    v_url      gnmk.url%type; --url
    v_mkbh_bgq xtcd.mkbh%TYPE; --模块编号
  BEGIN
    json_data(data_in, 'xtcd新增修改', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
  
    v_cdlx := Json_Str(v_Json_Data, 'cdlx');
    v_id   := Json_Str(v_Json_Data, 'id');
    v_sjid := Json_Str(v_Json_Data, 'sjid');
    v_xh   := Json_Str(v_Json_Data, 'xh');
    v_bt   := Json_Str(v_Json_Data, 'bt');
    v_xtbh := Json_Str(v_Json_Data, 'xtbh');
    v_mkbh := Json_Str(v_Json_Data, 'mkbh');
    v_zt   := Json_Str(v_Json_Data, 'zt');
    v_url  := Json_Str(v_Json_Data, 'url');
    v_sm   := v_bt;
    if v_id is null then
      --新增
      v_id := sys_guid();
      insert into xtcd
        (cdlx, id, sjid, xh, bt, sm, xtbh, mkbh, xgsj, cjsj, zt)
      values
        (v_cdlx,
         v_id,
         v_sjid,
         v_xh,
         v_bt,
         v_sm,
         v_xtbh,
         v_mkbh,
         v_sysdate,
         v_sysdate,
         v_zt);
    else
      --修改
      --获取变更前的mkbh
      begin
        select mkbh into v_mkbh_bgq from xtcd a where a.id = v_id;
      exception
        when no_data_found then
          v_err := 'id未获取到对应的菜单信息!';
          raise err_custom;
      end;
      --修改菜单
      update xtcd
         set cdlx = v_cdlx,
             xh   = v_xh,
             bt   = v_bt,
             sm   = v_sm,
             xtbh = v_xtbh,
             mkbh = v_mkbh,
             xgsj = v_sysdate,
             zt   = v_zt
       where id = v_id;
      --删除原来的功能模块
      delete from gnmk a where a.dm = v_mkbh_bgq;
    end if;
    --存在url的时候写入功能模块
    if v_url is not null then
      insert into gnmk
        (xtbh, dm, mc, sm, bs, qsbb, zt, xgsj, cjsj, url, id)
      values
        (v_xtbh,
         v_mkbh,
         v_bt,
         v_bt,
         v_cdlx,
         '1',
         v_zt,
         v_sysdate,
         v_sysdate,
         v_url,
         v_id);
    end if;
    --返回
    v_Json_Return.put('id', v_id);
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_xtcd_update;
  /*--------------------------------------------------------------------------
  || 功能描述 ：角色组新增或修改
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_jsgroup_update(Data_In    In Clob, --入参
                               result_out OUT VARCHAR2) --返回
   is
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
    --公共变量
    v_sysdate date;
    v_czyjgdm varchar2(50);
    v_czyjgid varchar2(50);
    v_czyjgjb varchar2(3);
  
    v_id jsgroup.id%TYPE; --id
    v_mc jsgroup.mc%TYPE; --标题
    v_sm jsgroup.sm%TYPE; --说明
    v_lx jsgroup.lx%TYPE; --类型
  BEGIN
    json_data(data_in, 'jsgroup新增修改', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyjgid := Json_Str(v_Json_Data, 'czyjgid');
  
    v_lx := Json_Str(v_Json_Data, 'js_lx');
    v_id := Json_Str(v_Json_Data, 'jsgroup_id');
    v_mc := Json_Str(v_Json_Data, 'js_mc');
    v_sm := Json_Str(v_Json_Data, 'js_sm');
    if v_id is null then
      --新增
      v_id := sys_guid();
      insert into jsgroup
        (id, lx, mc, sm, jgid, xgsj, cjsj)
      values
        (v_id, v_lx, v_mc, v_sm, v_czyjgid, v_sysdate, v_sysdate);
    else
      update jsgroup
         set lx = v_lx, mc = v_mc, sm = v_sm, xgsj = v_sysdate
       where id = v_id;
    end if;
    --返回
    v_Json_Return.put('id', v_id);
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_jsgroup_update;
  /*--------------------------------------------------------------------------
  || 功能描述 ：角色新增或修改
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_xtjs_update(Data_In    In Clob, --入参
                            result_out OUT VARCHAR2) --返回
   is
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
    --公共变量
    v_sysdate date;
    v_czyjgdm varchar2(50);
    v_czyjgid varchar2(50);
    v_czyjgjb varchar2(3);
  
    v_id      xtjs.id%TYPE; --id
    v_mc      xtjs.mc%TYPE; --标题
    v_sm      xtjs.sm%TYPE; --说明
    v_lx      xtjs.lx%TYPE; --类型
    v_jsgroup xtjs.jsgroup%type; --角色组\
  
    v_json_list_cd json_List; --菜单
    v_cdid         xtcd.id%type;
    v_cdid_s       varchar2(4000);
  BEGIN
    json_data(data_in, 'xtjs新增修改', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyjgid := Json_Str(v_Json_Data, 'czyjgid');
  
    v_lx           := Json_Str(v_Json_Data, 'lx');
    v_id           := Json_Str(v_Json_Data, 'jsid');
    v_mc           := Json_Str(v_Json_Data, 'mc');
    v_sm           := Json_Str(v_Json_Data, 'sm');
    v_jsgroup      := Json_Str(v_Json_Data, 'groupid');
    v_json_list_cd := Json_Ext.Get_Json_List(v_Json_Data, 'cd_arr'); --角色菜单
    if v_id is null then
      --新增
      v_id := sys_guid();
      insert into xtjs
        (id, lx, mc, sm, jgid, xgsj, cjsj, jsgroup)
      values
        (v_id,
         v_lx,
         v_mc,
         v_sm,
         v_czyjgid,
         v_sysdate,
         v_sysdate,
         v_jsgroup);
    else
      update xtjs
         set lx      = v_lx,
             mc      = v_mc,
             sm      = v_sm,
             xgsj    = v_sysdate,
             jsgroup = v_jsgroup
       where id = v_id;
    end if;
    --删除角色菜单
    delete from jsqx where jsid = v_id;
    --增加角色菜单
    if v_json_list_cd.count > 0 then
      v_cdid_s := '';
      for i in 1 .. v_json_list_cd.count loop
        v_cdid   := v_json_list_cd.Get(i).get_string;
        v_cdid_s := v_cdid_s || ',' || v_cdid;
        if mod(i, 100) = 0 or i = v_json_list_cd.count then
          v_cdid_s := substr(v_cdid_s, 2);
          --菜单id转换成表，一次插入100条
          insert into jsqx
            (jsid, lx, id)
            select v_id, a.cdlx, a.id
              from xtcd a,
                   (select distinct column_value column_value
                      from table(split(v_cdid_s, ','))) b
             where a.id = b.column_value;
          v_cdid_s := '';
        end if;
      end loop;
    end if;
    --返回
    v_Json_Return.put('id', v_id);
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_xtjs_update;
  /*--------------------------------------------------------------------------
  || 功能描述 ：角色启用
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_xtjs_start(Data_In    In Clob, --入参
                           result_out OUT VARCHAR2) --返回
   is
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
    --公共变量
    v_sysdate      date;
    v_czyjgdm      varchar2(50);
    v_czyjgid      varchar2(50);
    v_czyjgjb      varchar2(3);
    v_jsid_s       varchar2(4000);
    v_jsid         xtjs.id%TYPE; --id
    v_json_list_js json_List; --菜单
  BEGIN
    json_data(data_in, 'xtjs启用', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyjgid := Json_Str(v_Json_Data, 'czyjgid');
  
    v_json_list_js := Json_Ext.Get_Json_List(v_Json_Data, 'jsid_arr'); --角色id
    if v_json_list_js.count > 0 then
      v_jsid_s := '';
      for i in 1 .. v_json_list_js.count loop
        v_jsid   := v_json_list_js.Get(i).get_string;
        v_jsid_s := v_jsid_s || ',' || v_jsid;
        if mod(i, 100) = 0 or i = v_json_list_js.count then
          v_jsid_s := substr(v_jsid_s, 2);
          --菜单id转换成表，一次插入100条
          update xtjs
             set zt = 1, xgsj = sysdate
           where id in (select distinct column_value column_value
                          from table(split(v_jsid_s, ',')));
          v_jsid_s := '';
        end if;
      end loop;
    end if;
    --返回
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_xtjs_start;
  /*--------------------------------------------------------------------------
  || 功能描述 ：角色停用
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_xtjs_stop(Data_In    In Clob, --入参
                          result_out OUT VARCHAR2) --返回
   is
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
    --公共变量
    v_sysdate      date;
    v_czyjgdm      varchar2(50);
    v_czyjgid      varchar2(50);
    v_czyjgjb      varchar2(3);
    v_jsid_s       varchar2(4000);
    v_jsid         xtjs.id%TYPE; --id
    v_json_list_js json_List; --菜单
  BEGIN
    json_data(data_in, 'xtjs启用', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyjgid := Json_Str(v_Json_Data, 'czyjgid');
  
    v_json_list_js := Json_Ext.Get_Json_List(v_Json_Data, 'jsid_arr'); --角色id
    if v_json_list_js.count > 0 then
      v_jsid_s := '';
      for i in 1 .. v_json_list_js.count loop
        v_jsid   := v_json_list_js.Get(i).get_string;
        v_jsid_s := v_jsid_s || ',' || v_jsid;
        if mod(i, 100) = 0 or i = v_json_list_js.count then
          v_jsid_s := substr(v_jsid_s, 2);
          --菜单id转换成表，一次插入100条
          update xtjs
             set zt = -1, xgsj = sysdate
           where id in (select distinct column_value column_value
                          from table(split(v_jsid_s, ',')));
          v_jsid_s := '';
        end if;
      end loop;
    end if;
    --返回
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_xtjs_stop;
  /*--------------------------------------------------------------------------
  || 功能描述 ：机构新增或修改
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_p_yljg_update(Data_In    In Clob, --入参
                              result_out OUT VARCHAR2) --返回
   is
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
    --公共变量
    v_sysdate date;
    v_czyjgdm varchar2(50);
    v_czyjgid varchar2(50);
    v_czyjgjb varchar2(3);
    v_count   number;
    v_czyyhid varchar2(50);
  
    v_id      p_yljg.id%TYPE; --
    v_dm      p_yljg.dm%TYPE; --代码
    v_mc      p_yljg.mc%TYPE; --名称
    v_jc      p_yljg.jc%TYPE; --简称
    v_lb      p_yljg.lb%TYPE; --类别
    v_gljgid  p_yljg.gljgid%TYPE; --管理机构id
    v_xzqh    p_yljg.xzqh%TYPE; --机构管辖所属行政级别区划代码
    v_jjlx    p_yljg.jjlx%TYPE; --经济类型
    v_lxr     p_yljg.lxr%TYPE; --联系人
    v_lxdh    p_yljg.lxdh%TYPE; --联系电话
    v_szddz   p_yljg.szddz%TYPE; --所在地址
    v_szdxzqh p_yljg.szdxzqh%TYPE; --所在地行政区划
    v_wtdm    p_yljg.wtdm%TYPE; --卫统代码
    v_zzjgdm  p_yljg.zzjgdm%TYPE; --组织机构代码
    v_kzyw    varchar2(200); --开展业务
  
  BEGIN
    json_data(data_in, 'p_yljg新增修改', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyjgid := Json_Str(v_Json_Data, 'czyjgid');
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid');
  
    v_id      := Json_Str(v_Json_Data, 'jgid');
    v_dm      := Json_Str(v_Json_Data, 'dm');
    v_mc      := Json_Str(v_Json_Data, 'mc');
    v_jc      := Json_Str(v_Json_Data, 'jc');
    v_lb      := Json_Str(v_Json_Data, 'lb');
    v_gljgid  := Json_Str(v_Json_Data, 'gljgid');
    v_xzqh    := Json_Str(v_Json_Data, 'xzqh');
    v_jjlx    := Json_Str(v_Json_Data, 'jjlx');
    v_lxr     := Json_Str(v_Json_Data, 'lxr');
    v_lxdh    := Json_Str(v_Json_Data, 'lxdh');
    v_szddz   := Json_Str(v_Json_Data, 'szddz');
    v_szdxzqh := Json_Str(v_Json_Data, 'szdxzqh');
    v_wtdm    := Json_Str(v_Json_Data, 'wtdm');
    v_zzjgdm  := Json_Str(v_Json_Data, 'zzjgdm');
    v_kzyw    := Json_Str(v_Json_Data, 'kzyw');
  
    if v_id is null then
      --检查管理机构
      select count(1) into v_count from p_yljg where id = v_gljgid;
      if v_count = 0 then
        v_err := '管理单位未获取到!';
        raise err_custom;
      end if;
      --新增
      v_id := sys_guid();
      insert into p_yljg
        (id,
         dm,
         mc,
         jc,
         pym,
         wbm,
         lb,
         gljgid,
         xzqh,
         jjlx,
         lxr,
         lxdh,
         szddz,
         szdxzqh,
         xgsj,
         xgr,
         cjsj,
         cjr,
         bz,
         wtdm,
         zzjgdm)
      values
        (v_id,
         v_dm,
         v_mc,
         v_jc,
         pyjm(v_jc),
         wbjm(v_jc),
         v_lb,
         v_gljgid,
         v_xzqh,
         v_jjlx,
         v_lxr,
         v_lxdh,
         v_szddz,
         v_szdxzqh,
         v_sysdate,
         v_czyyhid,
         v_sysdate,
         v_czyyhid,
         1,
         v_wtdm,
         v_zzjgdm);
    
    else
      update p_yljg
         set dm      = v_dm,
             mc      = v_mc,
             jc      = v_jc,
             pym     = pyjm(v_jc),
             wbm     = wbjm(v_jc),
             lb      = v_lb,
             xzqh    = v_xzqh,
             jjlx    = v_jjlx,
             lxr     = v_lxr,
             lxdh    = v_lxdh,
             szddz   = v_szddz,
             szdxzqh = v_szdxzqh,
             xgsj    = v_sysdate,
             xgr     = v_czyyhid,
             wtdm    = v_wtdm,
             zzjgdm  = v_zzjgdm
       where id = v_id;
    
    end if;
    --处理机构业务开展
    --删除业务开展
    delete from zjjk_zlfh_ccjg a where a.jgdm = v_dm;
    --写入业务开展
    if v_kzyw is not null then
      insert into zjjk_zlfh_ccjg
        (ywlx, jgdm)
        select distinct column_value, v_dm from table(split(v_kzyw, ','));
    end if;
    --返回
    v_Json_Return.put('id', v_id);
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_p_yljg_update;
  /*--------------------------------------------------------------------------
  || 功能描述 ：机构启用
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_p_yljg_start(Data_In    In Clob, --入参
                             result_out OUT VARCHAR2) --返回
   is
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
    --公共变量
    v_sysdate      date;
    v_czyjgdm      varchar2(50);
    v_czyjgid      varchar2(50);
    v_czyjgjb      varchar2(3);
    v_jgid_s       varchar2(4000);
    v_jgid         p_yljg.id%TYPE; --id
    v_json_list_jg json_List; --机构
  BEGIN
    json_data(data_in, 'xtjs启用', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyjgid := Json_Str(v_Json_Data, 'czyjgid');
  
    v_json_list_jg := Json_Ext.Get_Json_List(v_Json_Data, 'jgid_arr'); --
    if v_json_list_jg.count > 0 then
      v_jgid_s := '';
      for i in 1 .. v_json_list_jg.count loop
        v_jgid   := v_json_list_jg.Get(i).get_string;
        v_jgid_s := v_jgid_s || ',' || v_jgid;
        if mod(i, 100) = 0 or i = v_json_list_jg.count then
          v_jgid_s := substr(v_jgid_s, 2);
          --菜单id转换成表，一次插入100条
          update p_yljg
             set bz = 1, xgsj = sysdate
           where id in (select distinct column_value column_value
                          from table(split(v_jgid_s, ',')));
          v_jgid_s := '';
        end if;
      end loop;
    end if;
    --返回
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_p_yljg_start;
  /*--------------------------------------------------------------------------
  || 功能描述 ：机构停用
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_p_yljg_stop(Data_In    In Clob, --入参
                            result_out OUT VARCHAR2) --返回
   is
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
    --公共变量
    v_sysdate      date;
    v_czyjgdm      varchar2(50);
    v_czyjgid      varchar2(50);
    v_czyjgjb      varchar2(3);
    v_jgid_s       varchar2(4000);
    v_jgid         p_yljg.id%TYPE; --id
    v_json_list_jg json_List; --机构
  BEGIN
    json_data(data_in, 'xtjs启用', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyjgid := Json_Str(v_Json_Data, 'czyjgid');
  
    v_json_list_jg := Json_Ext.Get_Json_List(v_Json_Data, 'jgid_arr');
    if v_json_list_jg.count > 0 then
      v_jgid_s := '';
      for i in 1 .. v_json_list_jg.count loop
        v_jgid   := v_json_list_jg.Get(i).get_string;
        v_jgid_s := v_jgid_s || ',' || v_jgid;
        if mod(i, 100) = 0 or i = v_json_list_jg.count then
          v_jgid_s := substr(v_jgid_s, 2);
          --菜单id转换成表，一次插入100条
          update p_yljg
             set bz = -1, xgsj = sysdate
           where id in (select distinct column_value column_value
                          from table(split(v_jgid_s, ',')));
          v_jgid_s := '';
        end if;
      end loop;
    end if;
    --返回
    result_out := Return_Succ_Json(v_json_return);
    --返回
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_p_yljg_stop;
  /*--------------------------------------------------------------------------
  || 功能描述 ：机构资源授权
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_jgqx_update(Data_In    In Clob, --入参
                            result_out OUT VARCHAR2) --返回
   is
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
    --公共变量
    v_sysdate      date;
    v_czyjgdm      varchar2(50);
    v_czyjgid      varchar2(50);
    v_czyjgjb      varchar2(3);
    v_cdid_s       varchar2(4000);
    v_jgid         p_yljg.id%TYPE; --id
    v_cdid         xtcd.id%type;
    v_json_list_jg json_List; --机构
    v_json_list_cd json_List; --机构
  BEGIN
    json_data(data_in, 'jqqx授权', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyjgid := Json_Str(v_Json_Data, 'czyjgid');
  
    v_json_list_jg := Json_Ext.Get_Json_List(v_Json_Data, 'jg_arr');
    v_json_list_cd := Json_Ext.Get_Json_List(v_Json_Data, 'cd_arr');
    if v_json_list_jg.count > 0 and v_json_list_cd.count > 0 then
      for i in 1 .. v_json_list_jg.count loop
        v_jgid := v_json_list_jg.Get(i).get_string;
        --删除机构权限
        delete from jgqx where jgid = v_jgid;
        --写入机构权限
        for j in 1 .. v_json_list_cd.count loop
          v_cdid   := v_json_list_cd.Get(j).get_string;
          v_cdid_s := v_cdid_s || ',' || v_cdid;
          if mod(j, 100) = 0 or j = v_json_list_cd.count then
            v_cdid_s := substr(v_cdid_s, 2);
            --菜单id转换成表，一次插入100条
            insert into jgqx
              (jgid, lx, id)
              select v_jgid, a.cdlx, a.id
                from xtcd a,
                     (select distinct column_value column_value
                        from table(split(v_cdid_s, ','))) b
               where a.id = b.column_value;
            v_cdid_s := '';
          end if;
        end loop;
      end loop;
    else
      v_err := '机构或权限不能为空!';
      raise err_custom;
    end if;
    --返回
    result_out := Return_Succ_Json(v_json_return);
    --返回
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_jgqx_update;
  /*--------------------------------------------------------------------------
  || 功能描述 ：系统用户新增或修改
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_xtyh_update(Data_In    In Clob, --入参
                            result_out OUT VARCHAR2) --返回
   is
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
    --公共变量
    v_sysdate      date;
    v_czyjgdm      varchar2(50);
    v_czyjgid      varchar2(50);
    v_czyjgjb      varchar2(3);
    v_czyyhid      varchar2(50);
    v_jsid_s       varchar2(4000);
    v_jsid         xtcd.id%type;
    v_json_list_js json_List; --角色
  
    v_ryid   p_ryxx.id%TYPE; --id
    v_yhjgid p_ryxx.jgid%TYPE; --机构id
    v_dm     p_ryxx.dm%TYPE; --代码
    v_xm     p_ryxx.xm%TYPE; --姓名 机构唯一
    v_xb     p_ryxx.xb%TYPE; --性别
    v_qm     p_ryxx.qm%TYPE; --签名
    v_lxdh   p_ryxx.lxdh%TYPE; --联系电话
    v_sfzh   p_ryxx.sfzh%TYPE; --身份证号
    v_csrq   p_ryxx.csrq%TYPE; --出生日期
    v_yhm    xtyh.yhm%type; --用户名
    v_mm     xtyh.mm%type; --用户名
    v_oyhm   xtyh.yhm%type; --用户名
    --计算数量
    v_count number(2);
  
  BEGIN
    json_data(data_in, 'xtyh新增或修改', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyjgid := Json_Str(v_Json_Data, 'czyjgid');
  
    v_ryid    := Json_Str(v_Json_Data, 'ryid');
    v_yhjgid  := Json_Str(v_Json_Data, 'yhjgid');
    v_dm      := Json_Str(v_Json_Data, 'dm');
    v_xm      := Json_Str(v_Json_Data, 'xm');
    v_xb      := Json_Str(v_Json_Data, 'xb');
    v_qm      := Json_Str(v_Json_Data, 'qm');
    v_lxdh    := Json_Str(v_Json_Data, 'lxdh');
    v_sfzh    := Json_Str(v_Json_Data, 'sfzh');
    v_csrq    := std(Json_Str(v_Json_Data, 'csrq'));
    v_yhm     := Json_Str(v_Json_Data, 'yhm');
    v_mm      := Json_Str(v_Json_Data, 'mm');
    v_oyhm    := Json_Str(v_Json_Data, 'oyhm');
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid');
    if v_ryid is null or v_mm is null then
      select max(count(1))
        into v_count
        from p_ryxx a, xtyh b
       where a.id = b.ryid(+)
         and a.jgid = v_yhjgid
         and a.sfzh = v_sfzh
       group by a.jgid;
      if (v_count > 0) then
        v_err := '该身份证号已存在！';
        raise err_custom;
      else
        v_count := 0;
        select max(count(1))
          into v_count
          from p_ryxx a, xtyh b
         where a.id = b.ryid(+)
           and a.jgid = v_yhjgid
           and b.yhm = v_yhm
         group by a.jgid;
        if (v_count > 0) then
          v_err := '该用户名已存在！';
          raise err_custom;
        end if;
      end if;
      if v_yhm is null then
        v_err := '用户名或密码不能为空!';
        raise err_custom;
      end if;
      --新增
      v_ryid := sys_guid();
      --写入人员信息
      insert into p_ryxx
        (id,
         jgid,
         dm,
         xm,
         xb,
         pym,
         wbm,
         qm,
         lxdh,
         sfzh,
         xgsj,
         xgr,
         cjsj,
         cjr,
         bz,
         csrq)
      values
        (v_ryid,
         v_yhjgid,
         v_dm,
         v_xm,
         v_xb,
         pyjm(v_xm),
         wbjm(v_xm),
         v_qm,
         v_lxdh,
         v_sfzh,
         v_sysdate,
         v_czyyhid,
         v_sysdate,
         v_czyyhid,
         1,
         v_csrq);
      --写入用户信息
      insert into xtyh
        (jgid, yhm, ryid, mm, zt, xgsj, cjsj, xgr, cjr)
      values
        (v_yhjgid,
         v_yhm,
         v_ryid,
         v_mm,
         1,
         v_sysdate,
         v_sysdate,
         v_czyyhid,
         v_czyyhid);
    
    else
      --校验身份证号 用户名
      select max(count(1))
        into v_count
        from p_ryxx a, xtyh b
       where a.id = b.ryid(+)
         and a.jgid = v_yhjgid
         and a.sfzh = v_sfzh
         and a.id <> v_ryid
       group by a.jgid;
      if (v_count > 0) then
        v_err := '该身份证号已存在！';
        raise err_custom;
      else
        v_count := 0;
        select max(count(1))
          into v_count
          from p_ryxx a, xtyh b
         where a.id = b.ryid(+)
           and a.jgid = v_yhjgid
           and b.yhm = v_yhm
           and a.id <> v_ryid
         group by a.jgid;
        if (v_count > 0) then
          v_err := '该用户名已存在！';
          raise err_custom;
        end if;
      end if;
      --修改人员信息
      update p_ryxx
         set dm   = v_dm,
             xm   = v_xm,
             xb   = v_xb,
             pym  = pyjm(v_xm),
             wbm  = wbjm(v_xm),
             qm   = v_qm,
             lxdh = v_lxdh,
             sfzh = v_sfzh,
             xgsj = v_sysdate,
             xgr  = v_yhjgid,
             csrq = v_csrq
       where id = v_ryid;
    end if;
    --删除用户权限
    delete from yhjs
     where jgid = v_yhjgid
       and yhm = v_yhm;
    v_json_list_js := Json_Ext.Get_Json_List(v_Json_Data, 'js_arr');
    if v_json_list_js.count > 0 then
      --写入用户权限
      for j in 1 .. v_json_list_js.count loop
        v_jsid   := v_json_list_js.Get(j).get_string;
        v_jsid_s := v_jsid_s || ',' || v_jsid;
        if mod(j, 100) = 0 or j = v_json_list_js.count then
          v_jsid_s := substr(v_jsid_s, 2);
          --角色id转换成表，一次插入100条
          insert into yhjs
            (jgid, yhm, jsid, xgr, xgsj)
            select v_yhjgid, v_yhm, a.id, v_yhjgid, v_sysdate
              from xtjs a,
                   (select distinct column_value column_value
                      from table(split(v_jsid_s, ','))) b
             where a.id = b.column_value;
          v_jsid_s := '';
        end if;
      end loop;
    end if;
    --返回
    result_out := Return_Succ_Json(v_json_return);
    --返回
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_xtyh_update;
  /*--------------------------------------------------------------------------
  || 功能描述 ：获取系统用户编号
  ||------------------------------------------------------------------------*/
  FUNCTION f_get_maxxtyhbh(v_yhjgid In Varchar2) --用户机构id
   RETURN VARCHAR2 is
    v_yhbh  Varchar2(100);
    v_count number;
  Begin
    --取上级ID最大ID加1
    select lpad(to_number(max(dm)) + 1, 3, 0)
      into v_yhbh
      from p_ryxx
     where jgid = v_yhjgid;
    if v_yhbh is null then
      v_yhbh := '001';
    end if;
    Return v_yhbh;
  Exception
    When Others Then
      Return '';
  End f_get_maxxtyhbh;
  /*--------------------------------------------------------------------------
  || 功能描述 ：系统用户启用
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_xtyh_start(Data_In    In Clob, --入参
                           result_out OUT VARCHAR2) --返回
   is
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
    --公共变量
    v_sysdate      date;
    v_czyjgdm      varchar2(50);
    v_czyjgid      varchar2(50);
    v_czyjgjb      varchar2(3);
    v_czyyhid      varchar2(50);
    v_yhid_s       varchar2(4000);
    v_yhid         p_yljg.id%TYPE; --id
    v_json_list_yh json_List; --用户
  BEGIN
    json_data(data_in, 'xtyh启用', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyjgid := Json_Str(v_Json_Data, 'czyjgid');
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid');
  
    v_json_list_yh := Json_Ext.Get_Json_List(v_Json_Data, 'yhid_arr'); --
    if v_json_list_yh.count > 0 then
      v_yhid_s := '';
      for i in 1 .. v_json_list_yh.count loop
        v_yhid   := v_json_list_yh.Get(i).get_string;
        v_yhid_s := v_yhid_s || ',' || v_yhid;
        if mod(i, 100) = 0 or i = v_json_list_yh.count then
          v_yhid_s := substr(v_yhid_s, 2);
          --菜单id转换成表，一次插入100条
          update xtyh
             set zt = 1, xgsj = sysdate, xgr = v_czyyhid
           where (yhm, jgid) in
                 (select arr(column_value, 1, '||'),
                         arr(column_value, 2, '||')
                    from table(split(v_yhid_s, ',')));
          v_yhid_s := '';
        end if;
      end loop;
    end if;
    --返回
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_xtyh_start;
  /*--------------------------------------------------------------------------
  || 功能描述 ：系统用户停用
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_xtyh_stop(Data_In    In Clob, --入参
                          result_out OUT VARCHAR2) --返回
   is
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
    --公共变量
    v_sysdate      date;
    v_czyjgdm      varchar2(50);
    v_czyjgid      varchar2(50);
    v_czyjgjb      varchar2(3);
    v_czyyhid      varchar2(50);
    v_yhid_s       varchar2(4000);
    v_yhid         p_yljg.id%TYPE; --id
    v_json_list_yh json_List; --用户
  BEGIN
    json_data(data_in, 'xtyh启用', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyjgid := Json_Str(v_Json_Data, 'czyjgid');
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid');
  
    v_json_list_yh := Json_Ext.Get_Json_List(v_Json_Data, 'yhid_arr'); --
    if v_json_list_yh.count > 0 then
      v_yhid_s := '';
      for i in 1 .. v_json_list_yh.count loop
        v_yhid   := v_json_list_yh.Get(i).get_string;
        v_yhid_s := v_yhid_s || ',' || v_yhid;
        if mod(i, 100) = 0 or i = v_json_list_yh.count then
          v_yhid_s := substr(v_yhid_s, 2);
          --菜单id转换成表，一次插入100条
          update xtyh
             set zt = -1, xgsj = sysdate, xgr = v_czyyhid
           where (yhm, jgid) in
                 (select arr(column_value, 1, '||'),
                         arr(column_value, 2, '||')
                    from table(split(v_yhid_s, ',')));
          v_yhid_s := '';
        end if;
      end loop;
    end if;
    --返回
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_xtyh_stop;
  /*--------------------------------------------------------------------------
  || 功能描述 ：系统用户重置密码
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_xtyh_czmm(Data_In    In Clob, --入参
                          result_out OUT VARCHAR2) --返回
   is
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
    --公共变量
    v_sysdate date;
    v_czyjgdm varchar2(50);
    v_czyjgid varchar2(50);
    v_czyjgjb varchar2(3);
    v_czyyhid varchar2(50);
  
    v_yhjgid p_ryxx.jgid%TYPE; --机构id
    v_yhm    xtyh.yhm%type; --用户名
    v_mm     xtyh.mm%type; --用户名
  BEGIN
    json_data(data_in, 'xtyh重置密码', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyjgid := Json_Str(v_Json_Data, 'czyjgid');
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid');
    v_yhm     := Json_Str(v_Json_Data, 'yhm');
    --v_mm      := Json_Str(v_Json_Data, 'mm');
    v_yhjgid := Json_Str(v_Json_Data, 'yhjgid');
    /* if v_mm is null then
      v_err := '密码不能为空!';
      raise err_custom;
    end if;*/
    --默认密码cdc12302
    v_mm := '24c72134b6f5828f29fc6f316081f72b7ec31b9c';
    update xtyh a
       set a.mm = v_mm
     where a.yhm = v_yhm
       and a.jgid = v_yhjgid;
  
    --返回
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_xtyh_czmm;
  /*--------------------------------------------------------------------------
  || 功能描述 ：系统用户修改密码
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_xtyh_xgmm(Data_In    In Clob, --入参
                          result_out OUT VARCHAR2) --返回
   is
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
    --公共变量
    v_sysdate date;
    v_czyjgdm varchar2(50);
    v_czyjgid varchar2(50);
    v_czyjgjb varchar2(3);
    v_czyyhid varchar2(50);
  
    v_yhjgid p_ryxx.jgid%TYPE; --机构id
    v_yhm    xtyh.yhm%type; --用户名
    v_jmm    xtyh.mm%type; --旧密码
    v_mm     xtyh.mm%type; --用户名
    v_qrmm   xtyh.mm%type; --确认密码
    v_yhjgid p_ryxx.jgid%TYPE; --机构id
    v_count  number;
  BEGIN
    json_data(data_in, 'xtyh修改密码', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyjgid := Json_Str(v_Json_Data, 'czyjgid');
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid');
    v_yhm     := Json_Str(v_Json_Data, 'yhm');
    v_mm      := Json_Str(v_Json_Data, 'mm');
    v_jmm     := Json_Str(v_Json_Data, 'jmm');
    v_qrmm    := Json_Str(v_Json_Data, 'qrmm');
    if v_mm is null then
      v_err := '密码不能为空!';
      raise err_custom;
    end if;
    if v_mm <> v_qrmm then
      v_err := '两次密码输入不一致!';
      raise err_custom;
    end if;
    select count(1)
      into v_count
      from p_ryxx a, xtyh b
     where a.id = b.ryid
       and b.yhm = v_yhm
       and b.mm = v_jmm;
    if v_count = 0 then
      v_err := '原始密码不正确！';
      raise Err_Custom;
    end if;
    update xtyh a set a.mm = v_mm where a.yhm = v_yhm;
    if sql%rowcount > 1 then
      v_err := '用户名重复！';
      raise Err_Custom;
    end if;
    --返回
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_xtyh_xgmm;
  /*--------------------------------------------------------------------------
  || 功能描述 ：用户角色授权-多用户多角色（先删除再插入）
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_yhjs_update(Data_In    In Clob, --入参
                            result_out OUT VARCHAR2) --返回
   is
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
    --公共变量
    v_sysdate date;
    v_czyjgdm varchar2(50);
    v_czyjgid varchar2(50);
    v_czyjgjb varchar2(3);
    v_czyyhid varchar2(50);
  
    v_jsid_s       varchar2(4000);
    v_yhm_yhjgid   varchar2(100);
    v_yhm          varchar2(100);
    v_yhjgid       varchar2(100);
    v_jsid         xtjs.id%type;
    v_json_list_yh json_List; --用户
    v_json_list_js json_List; --角色
  BEGIN
    json_data(data_in, 'yhjs授权', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyjgid := Json_Str(v_Json_Data, 'czyjgid');
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid');
  
    v_json_list_yh := Json_Ext.Get_Json_List(v_Json_Data, 'yh_arr');
    v_json_list_js := Json_Ext.Get_Json_List(v_Json_Data, 'js_arr');
    if v_json_list_yh.count > 0 and v_json_list_js.count > 0 then
      for i in 1 .. v_json_list_yh.count loop
        v_yhm_yhjgid := v_json_list_yh.Get(i).get_string;
        v_yhm        := arr(v_yhm_yhjgid, 1, '||');
        v_yhjgid     := arr(v_yhm_yhjgid, 2, '||');
        --删除用户权限
        delete from yhjs
         where yhm = v_yhm
           and jgid = v_yhjgid;
        --写入用户权限
        for j in 1 .. v_json_list_js.count loop
          v_jsid   := v_json_list_js.Get(j).get_string;
          v_jsid_s := v_jsid_s || ',' || v_jsid;
          if mod(j, 100) = 0 or j = v_json_list_js.count then
            v_jsid_s := substr(v_jsid_s, 2);
            --菜单id转换成表，一次插入100条
            insert into yhjs
              (jgid, yhm, jsid, xgsj, xgr)
              select v_yhjgid, v_yhm, a.id, v_sysdate, v_czyyhid
                from xtjs a,
                     (select distinct column_value column_value
                        from table(split(v_jsid_s, ','))) b
               where a.id = b.column_value;
            v_jsid_s := '';
          end if;
        end loop;
      end loop;
    else
      v_err := '用户或角色不能为空!';
      raise err_custom;
    end if;
    --返回
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_yhjs_update;
  /*--------------------------------------------------------------------------
  || 功能描述 ：角色用户授权-单角色，多用户
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_jsyh_update(Data_In    In Clob, --入参
                            result_out OUT VARCHAR2) --返回
   is
    v_json_data   json;
    v_json_return json := json();
    err_custom EXCEPTION;
    v_err VARCHAR2(2000);
    --公共变量
    v_sysdate date;
    v_czyjgdm varchar2(50);
    v_czyjgid varchar2(50);
    v_czyjgjb varchar2(3);
    v_czyyhid varchar2(50);
  
    v_jsid_s       varchar2(4000);
    v_yhm_yhjgid   varchar2(100);
    v_yhm          varchar2(100);
    v_yhjgid       varchar2(100);
    v_jsid         xtjs.id%type;
    v_json_list_yh json_List; --用户
  BEGIN
    json_data(data_in, 'yhjs授权', v_json_data);
    v_sysdate := sysdate;
    v_czyjgdm := Json_Str(v_Json_Data, 'czyjgdm');
    v_czyjgid := Json_Str(v_Json_Data, 'czyjgid');
    v_czyyhid := Json_Str(v_Json_Data, 'czyyhid');
    v_jsid    := Json_Str(v_Json_Data, 'jsid');
    if v_jsid is null then
      v_err := '角色不能为空!';
      raise err_custom;
    end if;
  
    v_json_list_yh := Json_Ext.Get_Json_List(v_Json_Data, 'yh_arr');
    if v_json_list_yh.count > 0 then
      for i in 1 .. v_json_list_yh.count loop
        v_yhm_yhjgid := v_json_list_yh.Get(i).get_string;
        v_yhm        := arr(v_yhm_yhjgid, 1, '||');
        v_yhjgid     := arr(v_yhm_yhjgid, 2, '||');
        --删除用户权限
        delete from yhjs
         where yhm = v_yhm
           and jgid = v_yhjgid
           and jsid = v_jsid;
        --写入用户权限
        insert into yhjs
          (jgid, yhm, jsid, xgsj, xgr)
        values
          (v_yhjgid, v_yhm, v_jsid, v_sysdate, v_czyyhid);
      end loop;
    else
      v_err := '用户不能为空!';
      raise err_custom;
    end if;
    --返回
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_jsyh_update;
  /*--------------------------------------------------------------------------
  || 功能描述 ：用户登录
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_xtyh_login(Data_In    In Clob, --入参
                           result_out OUT Clob) --返回
   is
    v_json_data   json;
    v_json_return json := json();
    v_json_out    Json := Json();
    v_json_temp   Json := Json();
    err_custom EXCEPTION;
    v_err       VARCHAR2(2000);
    v_json_yhxx json := json(); --用户信息json
    v_json_cdqx Json_List;
    --公共变量
    v_sysdate         date;
    v_yhm             xtyh.yhm%type;
    v_mm              xtyh.mm%type;
    v_jgid            xtyh.jgid%type;
    cur_temp          SYS_REFCURSOR;
    v_cdid            xtcd.id%type;
    v_cdid_superadmin xtcd.id%type; --超级管理员只授予权限管理部分菜单
    v_cdid_resource   xtcd.id%type; --普通用户不授予菜单管理权限
    v_ryid            p_ryxx.id%type;
    v_xm              p_ryxx.xm%type;
    v_dm              p_ryxx.dm%type;
    v_lxdh            p_ryxx.lxdh%type;
    v_zt              xtyh.zt%type;
    v_jgdm            p_yljg.dm%type;
    v_jgmc            p_yljg.mc%type;
    v_xzqh            p_yljg.xzqh%type;
    v_xzqh_organ      organ_node.description%type; -- organ_node 表中的行政区划
    v_xzmc            p_xzdm.mc%type;
    v_xzjb            p_xzdm.jb%type;
    v_jglb            p_yljg.lb%type;
    v_jgjb            varchar2(3);
    v_superadmin      varchar2(1);
    v_sql             Varchar2(4000);
    v_user_level      varchar2(3);  --用户级别，取开关权限用，1省，2市，3区县，A1医院，B1社区
    v_json_per        json := json(); --开关权限
    type rc is ref cursor ;    
    cur_per rc;
    v_per_item  USER_PERMISSION%RowType;
  begin
    json_data(data_in, 'xtyh登录', v_json_data);
    v_yhm             := Json_Str(v_json_data, 'yhm');
    v_mm              := Json_Str(v_json_data, 'mm');
    v_cdid            := Json_Str(v_json_data, 'cdid');
    v_cdid_superadmin := Json_Str(v_json_data, 'cdid_superadmin'); --超级管理员只授予权限管理部分菜单
    v_cdid_resource   := Json_Str(v_json_data, 'cdid_resource'); --超级管理员才授予菜单管理权限
    --校验用户名与密码
    begin
      select a.id, a.xm, a.dm, a.lxdh, b.zt, b.issuperadmin
        into v_ryid, v_xm, v_dm, v_lxdh, v_zt, v_superadmin
        from p_ryxx a, xtyh b
       where a.id = b.ryid
         and b.yhm = v_yhm
         and b.mm = v_mm;
    exception
      when no_data_found then
        v_err := '用户名或密码错误！';
        raise Err_Custom;
    end;
    if v_zt <> 1 then
      v_err := '用户已停用！';
      raise Err_Custom;
    end if;
    v_json_yhxx.put('ryid', v_ryid); --人员id
    v_json_yhxx.put('username', v_xm); --姓名
    v_json_yhxx.put('usercode', v_dm); --人员代码
    v_json_yhxx.put('yhm', v_yhm); --用户名
    v_json_yhxx.put('superadmin', v_superadmin); --超级管理员标志
    --获取登录机构信息
    begin
      select a.bz, a.dm, a.jc, a.xzqh, b.mc, b.jb, a.lb, a.id
        into v_zt, v_jgdm, v_jgmc, v_xzqh, v_xzmc, v_xzjb, v_jglb, v_jgid
        from p_yljg a, p_xzdm b
       where a.xzqh = b.dm(+)
         and a.id = (select yh.jgid from xtyh yh where yh.yhm = v_yhm);
    exception
      when no_data_found then
        v_err := '用户所在机构不存在';
        raise Err_Custom;
    end;
    if v_zt <> 1 then
      v_err := '机构已停用';
      raise Err_Custom;
    end if;
    if v_xzmc is null then
      v_err := '机构未设置对应的行政区划';
      raise Err_Custom;
    end if;
    v_json_yhxx.put('jgid', v_jgid); --机构id
    v_json_yhxx.put('jgdm', v_jgdm); --机构代码
    v_json_yhxx.put('jgmc', v_jgmc); --机构名称
    v_json_yhxx.put('xzqh', v_xzqh); --行政区划
    v_json_yhxx.put('xzmc', v_xzmc); --机构区划名称
    v_json_yhxx.put('xzjb', v_xzjb); --行政区划级别
    --疾控中心
    if v_jglb = 'J1' then
      --机构类型
      v_json_yhxx.put('jglx', 'J1');
      v_user_level := v_xzjb;
      --省疾控
      if v_xzjb = 1 then
        v_jgjb := '1';
        --市疾控
      elsif v_xzjb = 2 then
        v_jgjb := '2';
        --区疾控
      elsif v_xzjb = 3 then
        v_jgjb := '3';
      else
        v_err := '疾控中心与所在区划不匹配';
        raise Err_Custom;
      end if;
      --医院
    elsif v_jglb = 'A1' then
      v_jgjb := '4';
      v_json_yhxx.put('jglx', 'A1');
      v_user_level := 'A1';
      --社区
    elsif v_jglb = 'B1' then
      v_jgjb := '4';
      v_json_yhxx.put('jglx', 'B1');
      v_user_level := 'B1';
      if v_xzjb < 4 then
        v_err := '社区医院与所在区划不匹配';
        raise Err_Custom;
      end if;
      -- 社区需要从organ_node表中查找对应的街道，可能有多个
      select max(a.description) into v_xzqh_organ from organ_node a
      where a.removed = 0 and a.description is not null
      and a.code = (
           select p.dm from p_yljg p where p.id = 
              (select yh.jgid from xtyh yh where yh.yhm = v_yhm)
        );
      v_json_yhxx.put('xzqh_organ', v_xzqh_organ); --organ_node 表中的行政区划
    else
      v_err := '机构类别有误';
      raise Err_Custom;
    end if;
    --机构级别
    v_json_yhxx.put('jgjb', v_jgjb);
  
    --获取权限
    if nvl(v_superadmin, '0') <> '1' then
      --非超级管理员
      v_sql       := 'select a.id,
               a.cdlx,
               a.sjid,
               a.bt,
               a.bt   as name,
               a.tbid,
               a.tbid as icon,
               level  cdcj,
               a.url
          from (select a.id,
                       a.cdlx,
                       a.sjid,
                       a.bt,
                       a.bt   as name,
                       a.tbid,
                       a.tbid as icon,
                       b.url,
                       a.xh
                  from xtcd a, gnmk b
                 where a.mkbh = b.dm(+)
                   and a.zt = 1
                   and a.id <> nvl(''' ||
                     v_cdid_resource ||
                     ''', ''-9999'')
                   and exists (select 1
                          from jsqx jsqx, yhjs yhjs, xtjs xtjs
                         where jsqx.jsid = yhjs.jsid
                           and yhjs.jsid = xtjs.id
                           and xtjs.zt = 1
                           and yhjs.yhm = ''' || v_yhm || '''
                           and yhjs.jgid = ''' ||
                     v_jgid || '''
                           and a.id = jsqx.id)) a
         start with a.id = ''' || v_cdid || '''
        connect by a.sjid = prior a.id
         order by level, a.xh';
      v_json_cdqx := Json_Dyn.Executelist(v_sql);
    else
      --超级管理员
      v_sql       := 'select a.id,
               a.cdlx,
               a.sjid,
               a.bt,
               a.bt as name,
               a.tbid,
               a.tbid as icon,
               decode('''||v_cdid_superadmin||''', null, level + 1, level) cdcj,
               a.url,
               a.xh
          from (select a.id,
                       a.cdlx,
                       a.sjid,
                       a.bt,
                       a.bt   as name,
                       a.tbid,
                       a.tbid as icon,
                       b.url,
                       a.xh
                  from xtcd a, gnmk b
                 where a.mkbh = b.dm(+)
                   and a.zt = 1) a
         start with a.id = nvl('''||v_cdid_superadmin||''', '''||v_cdid||''')
        connect by a.sjid = prior a.id
        union
        select a.id,
               a.cdlx,
               a.sjid,
               a.bt,
               a.bt   as name,
               a.tbid,
               a.tbid as icon,
               1      cdcj,
               b.url,
               a.xh
          from xtcd a, gnmk b
         where a.mkbh = b.dm(+)
           and a.zt = 1
           and a.id = decode('''||v_cdid_superadmin||''', null, ''-9999'', '''||v_cdid||''')
         order by cdcj, xh';
      v_json_cdqx := Json_Dyn.Executelist(v_sql);
    end if;
  
    -- 取开关权限
    open cur_per for select * from USER_PERMISSION where user_level = v_user_level;    
    loop
      fetch cur_per into v_per_item;
      EXIT WHEN cur_per%NOTFOUND;
      v_json_per.put(v_per_item.code, v_per_item.state);
    end loop;
    close cur_per;  
    v_json_yhxx.put('permission', v_json_per);
     
    --用户信息
    v_json_out.put('ryxx', v_json_yhxx);
    --权限信息
    v_json_out.put('cdqx', v_Json_cdqx);
  
    v_json_temp.Put('data', v_Json_Out);
    
    result_out := return_succ_clob(v_json_temp);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_xtyh_login;
  /*--------------------------------------------------------------------------
  || 功能描述 ：用户登录_门户
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_xtyh_login_portal(Data_In    In Clob, --入参
                                  result_out OUT Clob) --返回
   is
    v_json_data   json;
    v_json_return json := json();
    v_json_out    Json := Json();
    v_json_temp   Json := Json();
    err_custom EXCEPTION;
    v_err       VARCHAR2(2000);
    v_json_yhxx json := json(); --用户信息json
    v_json_cdqx Json_List;
    --公共变量
    v_sysdate         date;
    v_openID          xtyh.ptyhid%type;
    v_yhm             xtyh.yhm%type;
    v_jgid            xtyh.jgid%type;
    cur_temp          SYS_REFCURSOR;
    v_cdid            xtcd.id%type;
    v_cdid_superadmin xtcd.id%type; --超级管理员只授予权限管理部分菜单
    v_cdid_resource   xtcd.id%type; --普通用户不授予菜单管理权限
    v_ryid            p_ryxx.id%type;
    v_xm              p_ryxx.xm%type;
    v_dm              p_ryxx.dm%type;
    v_lxdh            p_ryxx.lxdh%type;
    v_zt              xtyh.zt%type;
    v_jgdm            p_yljg.dm%type;
    v_jgmc            p_yljg.mc%type;
    v_xzqh            p_yljg.xzqh%type;
    v_xzqh_organ      organ_node.description%type; -- organ_node 表中的行政区划
    v_xzmc            p_xzdm.mc%type;
    v_xzjb            p_xzdm.jb%type;
    v_jglb            p_yljg.lb%type;
    v_jgjb            varchar2(3);
    v_superadmin      varchar2(1);
    v_sql             Varchar2(4000);
    v_user_level      varchar2(3);  --用户级别，取开关权限用，1省，2市，3区县，A1医院，B1社区
    v_json_per        json := json(); --开关权限
    type rc is ref cursor ;    
    cur_per rc;
    v_per_item  USER_PERMISSION%RowType;
  begin
    json_data(data_in, '门户登录', v_json_data);
    v_openid          := Json_Str(v_json_data, 'openid');
    v_cdid            := Json_Str(v_json_data, 'cdid');
    v_cdid_superadmin := Json_Str(v_json_data, 'cdid_superadmin'); --超级管理员只授予权限管理部分菜单
    v_cdid_resource   := Json_Str(v_json_data, 'cdid_resource'); --超级管理员才授予菜单管理权限
    --校验用户名与密码
    begin
      select a.id, a.xm, a.dm, a.lxdh, b.zt, b.issuperadmin, b.yhm
        into v_ryid, v_xm, v_dm, v_lxdh, v_zt, v_superadmin, v_yhm
        from p_ryxx a, xtyh b
       where a.id = b.ryid
         and instr(',' || b.ptyhid || ',', ',' || v_openid || ',') > 0;
    exception
      when no_data_found then
        v_err := 'openid未获取到用户！';
        raise Err_Custom;
    end;
    if v_zt <> 1 then
      v_err := '用户已停用！';
      raise Err_Custom;
    end if;
    v_json_yhxx.put('ryid', v_ryid); --人员id
    v_json_yhxx.put('username', v_xm); --姓名
    v_json_yhxx.put('usercode', v_dm); --人员代码
    v_json_yhxx.put('yhm', v_yhm); --用户名
    v_json_yhxx.put('superadmin', v_superadmin); --超级管理员标志
    --获取登录机构信息
    begin
      select a.bz, a.dm, a.jc, a.xzqh, b.mc, b.jb, a.lb, a.id
        into v_zt, v_jgdm, v_jgmc, v_xzqh, v_xzmc, v_xzjb, v_jglb, v_jgid
        from p_yljg a, p_xzdm b
       where a.xzqh = b.dm(+)
         and a.id = (select yh.jgid from xtyh yh where yh.yhm = v_yhm);
    exception
      when no_data_found then
        v_err := '用户所在机构不存在';
        raise Err_Custom;
    end;
    if v_zt <> 1 then
      v_err := '机构已停用';
      raise Err_Custom;
    end if;
    if v_xzmc is null then
      v_err := '机构未设置对应的行政区划';
      raise Err_Custom;
    end if;
    v_json_yhxx.put('jgid', v_jgid); --机构id
    v_json_yhxx.put('jgdm', v_jgdm); --机构代码
    v_json_yhxx.put('jgmc', v_jgmc); --机构名称
    v_json_yhxx.put('xzqh', v_xzqh); --行政区划
    v_json_yhxx.put('xzmc', v_xzmc); --机构区划名称
    v_json_yhxx.put('xzjb', v_xzjb); --行政区划级别
    --疾控中心
    if v_jglb = 'J1' then
      --机构类型
      v_json_yhxx.put('jglx', 'J1');
      v_user_level := v_xzjb;
      --省疾控
      if v_xzjb = 1 then
        v_jgjb := '1';
        --市疾控
      elsif v_xzjb = 2 then
        v_jgjb := '2';
        --区疾控
      elsif v_xzjb = 3 then
        v_jgjb := '3';
      else
        v_err := '疾控中心与所在区划不匹配';
        raise Err_Custom;
      end if;
      --医院
    elsif v_jglb = 'A1' then
      v_jgjb := '4';
      v_json_yhxx.put('jglx', 'A1');
      v_user_level := 'A1';
      --社区
    elsif v_jglb = 'B1' then
      v_jgjb := '4';
      v_json_yhxx.put('jglx', 'B1');
      v_user_level := 'B1';
      if v_xzjb < 4 then
        v_err := '社区医院与所在区划不匹配';
        raise Err_Custom;
      end if;
      -- 社区需要从organ_node表中查找对应的街道，可能有多个
      select max(a.description) into v_xzqh_organ from organ_node a
      where a.removed = 0 and a.description is not null
      and a.code = (
           select p.dm from p_yljg p where p.id = 
              (select yh.jgid from xtyh yh where yh.yhm = v_yhm)
        );
      v_json_yhxx.put('xzqh_organ', v_xzqh_organ); --organ_node 表中的行政区划
    else
      v_err := '机构类别有误';
      raise Err_Custom;
    end if;
    --机构级别
    v_json_yhxx.put('jgjb', v_jgjb);
  
    --获取权限
    if nvl(v_superadmin, '0') <> '1' then
      --非超级管理员
        v_sql       := 'select a.id,
               a.cdlx,
               a.sjid,
               a.bt,
               a.bt   as name,
               a.tbid,
               a.tbid as icon,
               level  cdcj,
               a.url
          from (select a.id,
                       a.cdlx,
                       a.sjid,
                       a.bt,
                       a.bt   as name,
                       a.tbid,
                       a.tbid as icon,
                       b.url,
                       a.xh
                  from xtcd a, gnmk b
                 where a.mkbh = b.dm(+)
                   and a.zt = 1
                   and a.id <> nvl('''||v_cdid_resource||''', ''-9999'')
                   and exists (select 1
                          from jsqx jsqx, yhjs yhjs, xtjs xtjs
                         where jsqx.jsid = yhjs.jsid
                           and yhjs.jsid = xtjs.id
                           and xtjs.zt = 1
                           and yhjs.yhm = '''||v_yhm||'''
                           and yhjs.jgid = '''||v_jgid||'''
                           and a.id = jsqx.id)) a
         start with a.id = '''||v_cdid||'''
        connect by a.sjid = prior a.id
         order by level, a.xh';
      v_json_cdqx := Json_Dyn.Executelist(v_sql);
    else
      --超级管理员
        v_sql       := 'select a.id,
               a.cdlx,
               a.sjid,
               a.bt,
               a.bt as name,
               a.tbid,
               a.tbid as icon,
               decode('''||v_cdid_superadmin||''', null, level + 1, level) cdcj,
               a.url,
               a.xh
          from (select a.id,
                       a.cdlx,
                       a.sjid,
                       a.bt,
                       a.bt   as name,
                       a.tbid,
                       a.tbid as icon,
                       b.url,
                       a.xh
                  from xtcd a, gnmk b
                 where a.mkbh = b.dm(+)
                   and a.zt = 1) a
         start with a.id = nvl('''||v_cdid_superadmin||''', '''||v_cdid||''')
        connect by a.sjid = prior a.id
        union
        select a.id,
               a.cdlx,
               a.sjid,
               a.bt,
               a.bt   as name,
               a.tbid,
               a.tbid as icon,
               1      cdcj,
               b.url,
               a.xh
          from xtcd a, gnmk b
         where a.mkbh = b.dm(+)
           and a.zt = 1
           and a.id = decode('''||v_cdid_superadmin||''', null, ''-9999'', '''||v_cdid||''')
         order by cdcj, xh';
      v_json_cdqx := Json_Dyn.Executelist(v_sql);
    end if;
  
    -- 取开关权限
    open cur_per for select * from USER_PERMISSION where user_level = v_user_level;    
    loop
      fetch cur_per into v_per_item;
      EXIT WHEN cur_per%NOTFOUND;
      v_json_per.put(v_per_item.code, v_per_item.state);
    end loop;
    close cur_per;  
    v_json_yhxx.put('permission', v_json_per);
    
    --用户信息
    v_json_out.put('ryxx', v_json_yhxx);
    --权限信息
    v_json_out.put('cdqx', v_Json_cdqx);
  
    v_json_temp.Put('data', v_Json_Out);
    result_out := return_succ_clob(v_json_temp);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_xtyh_login_portal;
  /*--------------------------------------------------------------------------
  || 功能描述 ：用户绑定_门户
  ||------------------------------------------------------------------------*/
  PROCEDURE prc_xtyh_portal_bd(Data_In    In Clob, --入参
                               result_out OUT Clob) --返回
   is
    v_json_data   json;
    v_json_return json := json();
    v_json_out    Json := Json();
    v_json_temp   Json := Json();
    err_custom EXCEPTION;
    v_err       VARCHAR2(2000);
    v_json_yhxx json := json(); --用户信息json
    v_json_cdqx Json_List;
    --公共变量
    v_sysdate    date;
    v_yhm        xtyh.yhm%type;
    v_openID     xtyh.ptyhid%type;
    v_mm         xtyh.mm%type;
    v_jgid       xtyh.jgid%type;
    v_count      number;
    v_ptyhid_ycc xtyh.ptyhid%type;
  begin
    json_data(data_in, '门户用户绑定', v_json_data);
    v_yhm    := Json_Str(v_json_data, 'yhm');
    v_openid := Json_Str(v_json_data, 'openid');
    v_mm     := Json_Str(v_json_data, 'mm');
    if v_openid is null then
      v_err := '门户openid不能为空！';
      raise Err_Custom;
    end if;
    --校验用户名与密码
    select count(1), max(ptyhid)
      into v_count, v_ptyhid_ycc
      from p_ryxx a, xtyh b
     where a.id = b.ryid
       and b.yhm = v_yhm
       and b.mm = v_mm;
    if v_count = 0 then
      v_err := '用户名或密码错误！';
      raise Err_Custom;
    end if;
    --校验绑定个数
    if v_ptyhid_ycc is not null then
      select (length(v_ptyhid_ycc) - length(replace(v_ptyhid_ycc, ',', ''))) + 1
        into v_count
        from dual;
    end if;
    if v_count >= 10 then
      v_err := '该用户绑定人数过多！';
      raise Err_Custom;
    end if;
    --校验openid是否已绑定
    select count(1)
      into v_count
      from p_ryxx a, xtyh b
     where a.id = b.ryid
       and instr(',' || b.ptyhid || ',', ',' || v_openid || ',') > 0;
    if v_count > 0 then
      v_err := '用户已绑定，不能重复绑定！';
      raise Err_Custom;
    end if;
    update xtyh a
       set a.ptyhid = case
                        when a.ptyhid is null then
                         v_openid
                        else
                         a.ptyhid || ',' || v_openid
                      end
     where a.yhm = v_yhm;
    v_Json_Return.put('openid', v_openid);
    result_out := Return_Succ_Json(v_json_return);
  EXCEPTION
    WHEN err_custom THEN
      result_out := return_fail(v_err, 2);
    WHEN OTHERS THEN
      v_err      := SQLERRM;
      result_out := return_fail(v_err, 0);
  END prc_xtyh_portal_bd;
END pkg_auth;
