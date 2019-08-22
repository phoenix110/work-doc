-- Create table
create table ZJMB_SW_WJW_BGK
(
  vc_bgkid         VARCHAR2(50) not null,
  vc_ccid          VARCHAR2(60),
  vc_ckbz          VARCHAR2(1),
  vc_xm            VARCHAR2(20),
  vc_jkdw          VARCHAR2(9),
  nb_jkyybm        VARCHAR2(10),
  vc_jkys          VARCHAR2(20),
  dt_jksj          DATE,
  vc_xb            VARCHAR2(4),
  vc_mz            VARCHAR2(2),
  vc_zy            VARCHAR2(2),
  vc_hjdzlx        VARCHAR2(1),
  vc_hjdz          VARCHAR2(70),
  vc_hjdzbm        VARCHAR2(8),
  vc_hyzk          VARCHAR2(1),
  vc_whcd          VARCHAR2(1),
  dt_swrq          DATE,
  vc_sznl          VARCHAR2(3),
  vc_sfzhm         VARCHAR2(20),
  vc_rqfl          VARCHAR2(1),
  vc_swdd          VARCHAR2(1),
  vc_sqczdzlx      VARCHAR2(1),
  vc_sqxxdz        VARCHAR2(20),
  vc_sqzgzddw      VARCHAR2(1),
  vc_icdbm         VARCHAR2(3),
  vc_zdyj          VARCHAR2(1),
  vc_gbsy          VARCHAR2(20),
  nb_gbsybm        VARCHAR2(120),
  vc_qtjbzd        VARCHAR2(20),
  nb_qtjbzdicd     NUMBER,
  vc_jsxm          VARCHAR2(30),
  vc_jslxdh        VARCHAR2(40),
  vc_jsdz          VARCHAR2(200),
  vc_bgklb         VARCHAR2(1),
  vc_zyh           VARCHAR2(20),
  vc_scbz          VARCHAR2(1),
  vc_gldwdm        VARCHAR2(120),
  vc_cjdwdm        VARCHAR2(60),
  dt_cjsj          DATE,
  vc_cjyh          VARCHAR2(30),
  dt_xgsj          DATE,
  vc_xgyh          VARCHAR2(9),
  vc_azjswjb       VARCHAR2(200),
  nb_azjswjbicd    VARCHAR2(60),
  vc_afbdswsjjg    VARCHAR2(60),
  vc_afbdswsjdw    VARCHAR2(60),
  vc_bzjswjb       VARCHAR2(200),
  nb_bzjswjbidc    VARCHAR2(60),
  vc_bfbdswsjjg    VARCHAR2(60),
  vc_bfbdswsjdw    VARCHAR2(60),
  vc_czjswjb       VARCHAR2(200),
  nb_czjswjbicd    VARCHAR2(60),
  vc_cfbdswsjjg    VARCHAR2(60),
  vc_cfbdswsjdw    VARCHAR2(60),
  vc_dzjswjb       VARCHAR2(200),
  nb_dajswjbicd    VARCHAR2(60),
  vc_dfbdswsjjg    VARCHAR2(60),
  vc_dfbdswsjdw    VARCHAR2(60),
  vc_szsqbljzztz   VARCHAR2(1500),
  vc_bdczxm        VARCHAR2(20),
  vc_yszgx         VARCHAR2(20),
  vc_lxdzhgzdw     VARCHAR2(60),
  vc_bdczdh        VARCHAR2(11),
  vc_sytd          VARCHAR2(20),
  vc_bdczqm        VARCHAR2(20),
  dt_dcrq          DATE,
  dt_scsj          DATE,
  dt_lrsj          DATE,
  vc_lrrid         VARCHAR2(20),
  vc_shbz          VARCHAR2(1),
  dt_shsj          DATE,
  vc_kpzt          VARCHAR2(1),
  vc_kply          VARCHAR2(20),
  vc_hksdm         VARCHAR2(10),
  vc_hkqxdm        VARCHAR2(10),
  vc_hkjddm        VARCHAR2(10),
  vc_cssdm         VARCHAR2(10),
  vc_csqxdm        VARCHAR2(10),
  vc_csjddm        VARCHAR2(10),
  dt_csrq          DATE,
  vc_wbswyy        VARCHAR2(60),
  vc_ebm           VARCHAR2(60),
  vc_ysqm          VARCHAR2(30),
  vc_hkhs          VARCHAR2(10),
  vc_whsyy         VARCHAR2(60),
  vc_hkqc          VARCHAR2(10),
  vc_qcsdm         VARCHAR2(10),
  vc_qcqxdm        VARCHAR2(10),
  vc_qcjddm        VARCHAR2(10),
  dt_qcsj          DATE,
  vc_bz            VARCHAR2(60),
  vc_shid          VARCHAR2(60),
  vc_khzt          VARCHAR2(1),
  vc_khid          VARCHAR2(60),
  vc_khjg          VARCHAR2(60),
  vc_hkxxdz        VARCHAR2(200),
  vc_qcxxdz        VARCHAR2(60),
  vc_sqgzdw        VARCHAR2(60),
  vc_hkjw          VARCHAR2(255),
  vc_qcjw          VARCHAR2(100),
  fenleitj         VARCHAR2(3),
  vc_ezjswjb       VARCHAR2(200),
  nb_eajswjbicd    VARCHAR2(60),
  vc_efbdswsjjg    VARCHAR2(60),
  vc_efbdswsjdw    VARCHAR2(60),
  vc_fzjswjb       VARCHAR2(200),
  nb_fajswjbicd    VARCHAR2(60),
  vc_ffbdswsjjg    VARCHAR2(60),
  vc_ffbdswsjdw    VARCHAR2(60),
  vc_gzjswjb       VARCHAR2(200),
  nb_gajswjbicd    VARCHAR2(60),
  vc_gfbdswsjjg    VARCHAR2(60),
  vc_gfbdswsjdw    VARCHAR2(60),
  vc_hkqcs         VARCHAR2(10),
  dt_tbrq          DATE,
  vc_xxly          VARCHAR2(60),
  vc_qcsfdm        VARCHAR2(10),
  vc_qyid          VARCHAR2(10),
  vc_shzt          VARCHAR2(1),
  vc_khbz          VARCHAR2(1),
  vc_xnxgbfzt      VARCHAR2(2),
  vc_tnbbfzt       VARCHAR2(2),
  vc_zlbfzt        VARCHAR2(2),
  vc_sdqr          VARCHAR2(20),
  fenleitjmc       VARCHAR2(60),
  vc_azjswjb1      VARCHAR2(200),
  vc_bzjswjb1      VARCHAR2(200),
  vc_czjswjb1      VARCHAR2(200),
  vc_dzjswjb1      VARCHAR2(200),
  vc_ezjswjb1      VARCHAR2(200),
  vc_fzjswjb1      VARCHAR2(200),
  vc_gzjswjb1      VARCHAR2(200),
  vc_shwtgyy       VARCHAR2(500),
  vc_shwtgyy1      VARCHAR2(60),
  vc_dyqbh         VARCHAR2(10),
  dt_yyshsj        DATE,
  dt_sfsj          DATE,
  dt_qxzssj        DATE,
  vc_zjlx          VARCHAR2(2),
  vc_rsqk          VARCHAR2(2),
  vc_wshksdm       VARCHAR2(20),
  vc_wshkqxdm      VARCHAR2(20),
  vc_wshkjddm      VARCHAR2(20),
  vc_wshkjw        VARCHAR2(255),
  vc_gjhdq         VARCHAR2(20),
  vc_wshkshendm    VARCHAR2(20),
  vc_jzqcs         VARCHAR2(20),
  vc_jzsdm         VARCHAR2(20),
  vc_jzqxdm        VARCHAR2(20),
  vc_jzjddm        VARCHAR2(20),
  vc_jzjw          VARCHAR2(255),
  vc_wsjzshendm    VARCHAR2(20),
  vc_wsjzsdm       VARCHAR2(20),
  vc_wsjzqxdm      VARCHAR2(20),
  vc_wsjzjddm      VARCHAR2(20),
  vc_wsjzjw        VARCHAR2(255),
  vc_gxbz          VARCHAR2(5),
  vc_id            VARCHAR2(50),
  is_pass          VARCHAR2(3),
  validate_detail  VARCHAR2(2000),
  validate_date    DATE,
  vc_hzicd         VARCHAR2(10),
  uploadcountry    VARCHAR2(2) default '1',
  requestid        VARCHAR2(40),
  upload_areaeport VARCHAR2(15),
  vc_wjw_scbz      VARCHAR2(1) default 0 not null,
  dt_wjw_scsj      DATE
)
tablespace ZJJK
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 128K
    next 1M
    minextents 1
    maxextents unlimited
  );
-- Add comments to the columns 
comment on column ZJMB_SW_WJW_BGK.vc_ccid
  is '查重ID';
comment on column ZJMB_SW_WJW_BGK.vc_ckbz
  is '重卡标志';
comment on column ZJMB_SW_WJW_BGK.vc_xm
  is '姓名';
comment on column ZJMB_SW_WJW_BGK.vc_jkdw
  is '建卡医院';
comment on column ZJMB_SW_WJW_BGK.nb_jkyybm
  is '建卡医院编码';
comment on column ZJMB_SW_WJW_BGK.vc_jkys
  is '建卡医生';
comment on column ZJMB_SW_WJW_BGK.dt_jksj
  is '建卡时间';
comment on column ZJMB_SW_WJW_BGK.vc_xb
  is '性别';
comment on column ZJMB_SW_WJW_BGK.vc_mz
  is '民族';
comment on column ZJMB_SW_WJW_BGK.vc_zy
  is '职业';
comment on column ZJMB_SW_WJW_BGK.vc_hjdzlx
  is '户籍地址类型';
comment on column ZJMB_SW_WJW_BGK.vc_hjdz
  is '户籍地址';
comment on column ZJMB_SW_WJW_BGK.vc_hjdzbm
  is '户籍地址编码';
comment on column ZJMB_SW_WJW_BGK.vc_hyzk
  is '婚姻状况';
comment on column ZJMB_SW_WJW_BGK.vc_whcd
  is '文化程度';
comment on column ZJMB_SW_WJW_BGK.dt_swrq
  is '死亡日期';
comment on column ZJMB_SW_WJW_BGK.vc_sznl
  is '实足年龄';
comment on column ZJMB_SW_WJW_BGK.vc_sfzhm
  is '身份证号码';
comment on column ZJMB_SW_WJW_BGK.vc_rqfl
  is '人群分类';
comment on column ZJMB_SW_WJW_BGK.vc_swdd
  is '死亡地点';
comment on column ZJMB_SW_WJW_BGK.vc_sqczdzlx
  is '生前长住地址类型';
comment on column ZJMB_SW_WJW_BGK.vc_sqxxdz
  is '生前详细地址';
comment on column ZJMB_SW_WJW_BGK.vc_sqzgzddw
  is '生前最高诊断单位';
comment on column ZJMB_SW_WJW_BGK.vc_icdbm
  is 'ICD编码';
comment on column ZJMB_SW_WJW_BGK.vc_zdyj
  is '诊断依据';
comment on column ZJMB_SW_WJW_BGK.vc_gbsy
  is '根本死因';
comment on column ZJMB_SW_WJW_BGK.nb_gbsybm
  is '根本死因ICD编码';
comment on column ZJMB_SW_WJW_BGK.vc_qtjbzd
  is '其它疾病诊断';
comment on column ZJMB_SW_WJW_BGK.nb_qtjbzdicd
  is '其它疾病诊断ICD10';
comment on column ZJMB_SW_WJW_BGK.vc_jsxm
  is '家属姓名';
comment on column ZJMB_SW_WJW_BGK.vc_jslxdh
  is '家属联系电话';
comment on column ZJMB_SW_WJW_BGK.vc_jsdz
  is '家属地址或工作单位';
comment on column ZJMB_SW_WJW_BGK.vc_bgklb
  is '报告卡类别';
comment on column ZJMB_SW_WJW_BGK.vc_zyh
  is '住院号';
comment on column ZJMB_SW_WJW_BGK.vc_scbz
  is '删除标志';
comment on column ZJMB_SW_WJW_BGK.vc_gldwdm
  is '管理单位代码';
comment on column ZJMB_SW_WJW_BGK.vc_cjdwdm
  is '创建单位代码';
comment on column ZJMB_SW_WJW_BGK.dt_cjsj
  is '创建时间';
comment on column ZJMB_SW_WJW_BGK.vc_cjyh
  is '创建用户';
comment on column ZJMB_SW_WJW_BGK.dt_xgsj
  is '修改时间';
comment on column ZJMB_SW_WJW_BGK.vc_xgyh
  is '修改用户';
comment on column ZJMB_SW_WJW_BGK.vc_azjswjb
  is 'a直接导致死亡的疾病';
comment on column ZJMB_SW_WJW_BGK.nb_azjswjbicd
  is 'a直接导致死亡的疾病ICD10编码';
comment on column ZJMB_SW_WJW_BGK.vc_afbdswsjjg
  is 'a发病到死亡的时间间隔';
comment on column ZJMB_SW_WJW_BGK.vc_afbdswsjdw
  is 'a发病到死亡的时间间隔单位';
comment on column ZJMB_SW_WJW_BGK.vc_bzjswjb
  is 'b直接导致死亡的疾病';
comment on column ZJMB_SW_WJW_BGK.nb_bzjswjbidc
  is 'b直接导致死亡的疾病ICD10编码';
comment on column ZJMB_SW_WJW_BGK.vc_bfbdswsjjg
  is 'b发病到死亡的时间间隔';
comment on column ZJMB_SW_WJW_BGK.vc_bfbdswsjdw
  is 'b发病到死亡的时间间隔单位';
comment on column ZJMB_SW_WJW_BGK.vc_czjswjb
  is 'c直接导致死亡的疾病';
comment on column ZJMB_SW_WJW_BGK.nb_czjswjbicd
  is 'c直接导致死亡的疾病ICD10编码';
comment on column ZJMB_SW_WJW_BGK.vc_cfbdswsjjg
  is 'c发病到死亡的时间间隔';
comment on column ZJMB_SW_WJW_BGK.vc_cfbdswsjdw
  is 'c发病到死亡的时间间隔单位';
comment on column ZJMB_SW_WJW_BGK.vc_dzjswjb
  is 'd直接导致死亡的疾病';
comment on column ZJMB_SW_WJW_BGK.nb_dajswjbicd
  is 'd直接导致死亡的疾病ICD10编码';
comment on column ZJMB_SW_WJW_BGK.vc_dfbdswsjjg
  is 'd发病到死亡的时间间隔';
comment on column ZJMB_SW_WJW_BGK.vc_dfbdswsjdw
  is 'd发病到死亡的时间间隔单位';
comment on column ZJMB_SW_WJW_BGK.vc_szsqbljzztz
  is '死者生前病史及症状体征';
comment on column ZJMB_SW_WJW_BGK.vc_bdczxm
  is '被调查者姓名';
comment on column ZJMB_SW_WJW_BGK.vc_yszgx
  is '与死者关系';
comment on column ZJMB_SW_WJW_BGK.vc_lxdzhgzdw
  is '联系地址或工作单位';
comment on column ZJMB_SW_WJW_BGK.vc_bdczdh
  is '被调查者电话号码';
comment on column ZJMB_SW_WJW_BGK.vc_sytd
  is '死因推断';
comment on column ZJMB_SW_WJW_BGK.vc_bdczqm
  is '调查者签名';
comment on column ZJMB_SW_WJW_BGK.dt_dcrq
  is '调查日期';
comment on column ZJMB_SW_WJW_BGK.dt_scsj
  is '删除时间';
comment on column ZJMB_SW_WJW_BGK.dt_lrsj
  is '录入时间';
comment on column ZJMB_SW_WJW_BGK.vc_lrrid
  is '录入人ID';
comment on column ZJMB_SW_WJW_BGK.vc_shbz
  is '审核标志';
comment on column ZJMB_SW_WJW_BGK.dt_shsj
  is '审核时间';
comment on column ZJMB_SW_WJW_BGK.vc_kpzt
  is '卡片状态';
comment on column ZJMB_SW_WJW_BGK.vc_kply
  is '卡片来源';
comment on column ZJMB_SW_WJW_BGK.vc_hksdm
  is '户口市代码';
comment on column ZJMB_SW_WJW_BGK.vc_hkqxdm
  is '户口区县代码';
comment on column ZJMB_SW_WJW_BGK.vc_hkjddm
  is '户口街道代码';
comment on column ZJMB_SW_WJW_BGK.vc_cssdm
  is '出生市代码';
comment on column ZJMB_SW_WJW_BGK.vc_csqxdm
  is '出生区县代码';
comment on column ZJMB_SW_WJW_BGK.vc_csjddm
  is '出生街道代码';
comment on column ZJMB_SW_WJW_BGK.dt_csrq
  is '出生日期';
comment on column ZJMB_SW_WJW_BGK.vc_wbswyy
  is '外部死亡原因';
comment on column ZJMB_SW_WJW_BGK.vc_ebm
  is 'E编码';
comment on column ZJMB_SW_WJW_BGK.vc_ysqm
  is '医生签名';
comment on column ZJMB_SW_WJW_BGK.vc_hkhs
  is '户口核实';
comment on column ZJMB_SW_WJW_BGK.vc_whsyy
  is '未核实原因';
comment on column ZJMB_SW_WJW_BGK.vc_hkqc
  is '户口迁出';
comment on column ZJMB_SW_WJW_BGK.vc_qcsdm
  is '户口迁出市代码';
comment on column ZJMB_SW_WJW_BGK.vc_qcqxdm
  is '户口迁出区县代码';
comment on column ZJMB_SW_WJW_BGK.vc_qcjddm
  is '户口迁出街道代码';
comment on column ZJMB_SW_WJW_BGK.dt_qcsj
  is '户口迁出时间';
comment on column ZJMB_SW_WJW_BGK.vc_bz
  is '备注';
comment on column ZJMB_SW_WJW_BGK.vc_shid
  is '审核ID';
comment on column ZJMB_SW_WJW_BGK.vc_khzt
  is '考核状态?';
comment on column ZJMB_SW_WJW_BGK.vc_khid
  is '考核ID';
comment on column ZJMB_SW_WJW_BGK.vc_khjg
  is '考核结果';
comment on column ZJMB_SW_WJW_BGK.vc_hkxxdz
  is '户口详细地址';
comment on column ZJMB_SW_WJW_BGK.vc_qcxxdz
  is '迁出详细地址';
comment on column ZJMB_SW_WJW_BGK.vc_sqgzdw
  is '生前工作单位';
comment on column ZJMB_SW_WJW_BGK.vc_hkjw
  is '户口居委';
comment on column ZJMB_SW_WJW_BGK.vc_qcjw
  is '迁出居委';
comment on column ZJMB_SW_WJW_BGK.vc_ezjswjb
  is 'e直接导致死亡的疾病';
comment on column ZJMB_SW_WJW_BGK.nb_eajswjbicd
  is 'e直接导致死亡的疾病ICD10编码';
comment on column ZJMB_SW_WJW_BGK.vc_efbdswsjjg
  is 'e发病到死亡的时间间隔';
comment on column ZJMB_SW_WJW_BGK.vc_efbdswsjdw
  is 'e发病到死亡的时间间隔单位';
comment on column ZJMB_SW_WJW_BGK.vc_fzjswjb
  is 'f直接导致死亡的疾病';
comment on column ZJMB_SW_WJW_BGK.nb_fajswjbicd
  is 'f直接导致死亡的疾病ICD10编码';
comment on column ZJMB_SW_WJW_BGK.vc_ffbdswsjjg
  is 'f发病到死亡的时间间隔';
comment on column ZJMB_SW_WJW_BGK.vc_ffbdswsjdw
  is 'f发病到死亡的时间间隔单位';
comment on column ZJMB_SW_WJW_BGK.vc_gzjswjb
  is 'g直接导致死亡的疾病';
comment on column ZJMB_SW_WJW_BGK.nb_gajswjbicd
  is 'g直接导致死亡的疾病ICD10编码';
comment on column ZJMB_SW_WJW_BGK.vc_gfbdswsjjg
  is 'g发病到死亡的时间间隔';
comment on column ZJMB_SW_WJW_BGK.vc_gfbdswsjdw
  is 'g发病到死亡的时间间隔单位';
comment on column ZJMB_SW_WJW_BGK.vc_hkqcs
  is '户口省代码';
comment on column ZJMB_SW_WJW_BGK.vc_qcsfdm
  is '户口迁出省代码';
comment on column ZJMB_SW_WJW_BGK.vc_qyid
  is '迁移ID';
comment on column ZJMB_SW_WJW_BGK.vc_shzt
  is '审核状态 ';
comment on column ZJMB_SW_WJW_BGK.vc_shwtgyy
  is '审核未通过原因';
comment on column ZJMB_SW_WJW_BGK.dt_qxzssj
  is '区县终审时间';
comment on column ZJMB_SW_WJW_BGK.vc_zjlx
  is '证件类型';
comment on column ZJMB_SW_WJW_BGK.vc_rsqk
  is '妊娠情况';
comment on column ZJMB_SW_WJW_BGK.vc_wshksdm
  is '外省户口市代码';
comment on column ZJMB_SW_WJW_BGK.vc_wshkqxdm
  is '外省户口区县代码';
comment on column ZJMB_SW_WJW_BGK.vc_wshkjddm
  is '外省户口街道代码';
comment on column ZJMB_SW_WJW_BGK.vc_wshkjw
  is '外省户口居委';
comment on column ZJMB_SW_WJW_BGK.vc_gjhdq
  is '国家或地区';
comment on column ZJMB_SW_WJW_BGK.vc_wshkshendm
  is '外省户口省代码';
comment on column ZJMB_SW_WJW_BGK.vc_jzqcs
  is '居住省代码';
comment on column ZJMB_SW_WJW_BGK.vc_jzsdm
  is '居住市代码';
comment on column ZJMB_SW_WJW_BGK.vc_jzqxdm
  is '居住区县代码';
comment on column ZJMB_SW_WJW_BGK.vc_jzjddm
  is '居住街道代码';
comment on column ZJMB_SW_WJW_BGK.vc_jzjw
  is '居住居委';
comment on column ZJMB_SW_WJW_BGK.vc_wsjzshendm
  is '外省居住省代码';
comment on column ZJMB_SW_WJW_BGK.vc_wsjzsdm
  is '外省居住市代码';
comment on column ZJMB_SW_WJW_BGK.vc_wsjzqxdm
  is '外省居住区县代码';
comment on column ZJMB_SW_WJW_BGK.vc_wsjzjddm
  is '外省居住街道代码';
comment on column ZJMB_SW_WJW_BGK.vc_wsjzjw
  is '外省居住居委';
comment on column ZJMB_SW_WJW_BGK.uploadcountry
  is '上传标识， ''或者1 为未上传  2 为已上传 待验证 3 已上传 且已验证(成功) 4 已上传 验证失败';
comment on column ZJMB_SW_WJW_BGK.requestid
  is '上报id';
comment on column ZJMB_SW_WJW_BGK.vc_wjw_scbz
  is '卫健委上传标志，默认为0未上传，1为已上传';
comment on column ZJMB_SW_WJW_BGK.dt_wjw_scsj
  is '卫健委上传时间';
-- Create/Recreate indexes 
create index INDEX_SW_WJW_GLDW on ZJMB_SW_WJW_BGK (VC_GLDWDM, VC_CJDWDM)
  tablespace ZJJK
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index ZJJK_SW_WJW_INDEX on ZJMB_SW_WJW_BGK (VC_GLDWDM, VC_XM, VC_JKDW, DT_SWRQ, VC_BGKLB, VC_HKSDM, VC_HKQXDM, VC_HKJDDM)
  tablespace ZJJK
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
-- Create/Recreate primary, unique and foreign key constraints 
alter table ZJMB_SW_WJW_BGK
  add constraint PK_ZJMB_SW_WJW_BGK primary key (VC_BGKID)
  using index 
  tablespace ZJJK
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
