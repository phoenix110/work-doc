-- Create table
create table ZJMB_SW_WJW_BGK
(
  VC_BGKID         VARCHAR2(20) not null,
  VC_CCID          VARCHAR2(60),
  VC_CKBZ          VARCHAR2(1),
  VC_XM            VARCHAR2(32),
  VC_JKDW          VARCHAR2(9),
  NB_JKYYBM        VARCHAR2(10),
  VC_JKYS          VARCHAR2(20),
  DT_JKSJ          DATE,
  VC_XB            VARCHAR2(4),
  VC_MZ            VARCHAR2(2),
  VC_ZY            VARCHAR2(2),
  VC_HJDZLX        VARCHAR2(1),
  VC_HJDZ          VARCHAR2(70),
  VC_HJDZBM        VARCHAR2(8),
  VC_HYZK          VARCHAR2(1),
  VC_WHCD          VARCHAR2(1),
  DT_SWRQ          DATE,
  VC_SZNL          VARCHAR2(3),
  VC_SFZHM         VARCHAR2(20),
  VC_RQFL          VARCHAR2(1),
  VC_SWDD          VARCHAR2(1),
  VC_SQCZDZLX      VARCHAR2(1),
  VC_SQXXDZ        VARCHAR2(20),
  VC_SQZGZDDW      VARCHAR2(1),
  VC_ICDBM         VARCHAR2(3),
  VC_ZDYJ          VARCHAR2(1),
  VC_GBSY          VARCHAR2(20),
  NB_GBSYBM        VARCHAR2(120),
  VC_QTJBZD        VARCHAR2(20),
  NB_QTJBZDICD     NUMBER(10),
  VC_JSXM          VARCHAR2(30),
  VC_JSLXDH        VARCHAR2(40),
  VC_JSDZ          VARCHAR2(200),
  VC_BGKLB         VARCHAR2(1),
  VC_ZYH           VARCHAR2(20),
  VC_SCBZ          VARCHAR2(1),
  VC_GLDWDM        VARCHAR2(120),
  VC_CJDWDM        VARCHAR2(60),
  DT_CJSJ          DATE,
  VC_CJYH          VARCHAR2(30),
  DT_XGSJ          DATE,
  VC_XGYH          VARCHAR2(9),
  VC_AZJSWJB       VARCHAR2(200),
  NB_AZJSWJBICD    VARCHAR2(60),
  VC_AFBDSWSJJG    VARCHAR2(60),
  VC_AFBDSWSJDW    VARCHAR2(200),
  VC_BZJSWJB       VARCHAR2(200),
  NB_BZJSWJBIDC    VARCHAR2(60),
  VC_BFBDSWSJJG    VARCHAR2(60),
  VC_BFBDSWSJDW    VARCHAR2(200),
  VC_CZJSWJB       VARCHAR2(200),
  NB_CZJSWJBICD    VARCHAR2(60),
  VC_CFBDSWSJJG    VARCHAR2(60),
  VC_CFBDSWSJDW    VARCHAR2(200),
  VC_DZJSWJB       VARCHAR2(200),
  NB_DAJSWJBICD    VARCHAR2(60),
  VC_DFBDSWSJJG    VARCHAR2(60),
  VC_DFBDSWSJDW    VARCHAR2(200),
  VC_SZSQBLJZZTZ   VARCHAR2(1024),
  VC_BDCZXM        VARCHAR2(20),
  VC_YSZGX         VARCHAR2(20),
  VC_LXDZHGZDW     VARCHAR2(60),
  VC_BDCZDH        VARCHAR2(11),
  VC_SYTD          VARCHAR2(20),
  VC_BDCZQM        VARCHAR2(20),
  DT_DCRQ          DATE,
  DT_SCSJ          DATE,
  DT_LRSJ          DATE,
  VC_LRRID         VARCHAR2(20),
  VC_SHBZ          VARCHAR2(1),
  DT_SHSJ          DATE,
  VC_KPZT          VARCHAR2(1),
  VC_KPLY          VARCHAR2(20),
  VC_HKSDM         VARCHAR2(10),
  VC_HKQXDM        VARCHAR2(10),
  VC_HKJDDM        VARCHAR2(10),
  VC_CSSDM         VARCHAR2(10),
  VC_CSQXDM        VARCHAR2(10),
  VC_CSJDDM        VARCHAR2(10),
  DT_CSRQ          DATE,
  VC_WBSWYY        VARCHAR2(60),
  VC_EBM           VARCHAR2(60),
  VC_YSQM          VARCHAR2(30),
  VC_HKHS          VARCHAR2(10),
  VC_WHSYY         VARCHAR2(60),
  VC_HKQC          VARCHAR2(10),
  VC_QCSDM         VARCHAR2(10),
  VC_QCQXDM        VARCHAR2(10),
  VC_QCJDDM        VARCHAR2(10),
  DT_QCSJ          DATE,
  VC_BZ            VARCHAR2(60),
  VC_SHID          VARCHAR2(60),
  VC_KHZT          VARCHAR2(1),
  VC_KHID          VARCHAR2(60),
  VC_KHJG          VARCHAR2(60),
  VC_HKXXDZ        VARCHAR2(200),
  VC_QCXXDZ        VARCHAR2(60),
  VC_SQGZDW        VARCHAR2(60),
  VC_HKJW          VARCHAR2(255),
  VC_QCJW          VARCHAR2(100),
  FENLEITJ         VARCHAR2(3),
  VC_EZJSWJB       VARCHAR2(200),
  NB_EAJSWJBICD    VARCHAR2(60),
  VC_EFBDSWSJJG    VARCHAR2(60),
  VC_EFBDSWSJDW    VARCHAR2(60),
  VC_FZJSWJB       VARCHAR2(200),
  NB_FAJSWJBICD    VARCHAR2(60),
  VC_FFBDSWSJJG    VARCHAR2(60),
  VC_FFBDSWSJDW    VARCHAR2(60),
  VC_GZJSWJB       VARCHAR2(200),
  NB_GAJSWJBICD    VARCHAR2(60),
  VC_GFBDSWSJJG    VARCHAR2(60),
  VC_GFBDSWSJDW    VARCHAR2(60),
  VC_HKQCS         VARCHAR2(10),
  DT_TBRQ          DATE,
  VC_XXLY          VARCHAR2(60),
  VC_QCSFDM        VARCHAR2(10),
  VC_QYID          VARCHAR2(10),
  VC_SHZT          VARCHAR2(1),
  VC_KHBZ          VARCHAR2(1),
  VC_XNXGBFZT      VARCHAR2(2),
  VC_TNBBFZT       VARCHAR2(2),
  VC_ZLBFZT        VARCHAR2(2),
  VC_SDQR          VARCHAR2(20),
  FENLEITJMC       VARCHAR2(60),
  VC_AZJSWJB1      VARCHAR2(200),
  VC_BZJSWJB1      VARCHAR2(200),
  VC_CZJSWJB1      VARCHAR2(200),
  VC_DZJSWJB1      VARCHAR2(200),
  VC_EZJSWJB1      VARCHAR2(200),
  VC_FZJSWJB1      VARCHAR2(200),
  VC_GZJSWJB1      VARCHAR2(200),
  VC_SHWTGYY       VARCHAR2(500),
  VC_SHWTGYY1      VARCHAR2(60),
  VC_DYQBH         VARCHAR2(10),
  DT_YYSHSJ        DATE,
  DT_SFSJ          DATE,
  DT_QXZSSJ        DATE,
  VC_ZJLX          VARCHAR2(2),
  VC_RSQK          VARCHAR2(2),
  VC_WSHKSDM       VARCHAR2(20),
  VC_WSHKQXDM      VARCHAR2(20),
  VC_WSHKJDDM      VARCHAR2(20),
  VC_WSHKJW        VARCHAR2(255),
  VC_GJHDQ         VARCHAR2(20),
  VC_WSHKSHENDM    VARCHAR2(20),
  VC_JZQCS         VARCHAR2(20),
  VC_JZSDM         VARCHAR2(20),
  VC_JZQXDM        VARCHAR2(20),
  VC_JZJDDM        VARCHAR2(20),
  VC_JZJW          VARCHAR2(255),
  VC_WSJZSHENDM    VARCHAR2(20),
  VC_WSJZSDM       VARCHAR2(20),
  VC_WSJZQXDM      VARCHAR2(20),
  VC_WSJZJDDM      VARCHAR2(20),
  VC_WSJZJW        VARCHAR2(255),
  VC_GXBZ          VARCHAR2(5),
  VC_ID            VARCHAR2(50),
  VC_HZICD         VARCHAR2(10),
  IS_PASS          VARCHAR2(3),
  VALIDATE_DATE    DATE,
  VALIDATE_DETAIL  VARCHAR2(2000),
  UPLOADCOUNTRY    VARCHAR2(2) default '1',
  UPLOAD_AREAEPORT VARCHAR2(15),
  REQUESTID        VARCHAR2(60),
  VC_WJW_SCBZ      VARCHAR2(1) default 0 not null,
  DT_WJW_SCSJ      DATE
)
tablespace ZJJK
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 16
    next 8
    minextents 1
    maxextents unlimited
  );
-- Add comments to the columns 
comment on column ZJMB_SW_WJW_BGK.VC_CCID
  is '查重ID';
comment on column ZJMB_SW_WJW_BGK.VC_CKBZ
  is '重卡标志';
comment on column ZJMB_SW_WJW_BGK.VC_XM
  is '姓名';
comment on column ZJMB_SW_WJW_BGK.VC_JKDW
  is '建卡医院';
comment on column ZJMB_SW_WJW_BGK.NB_JKYYBM
  is '建卡医院编码';
comment on column ZJMB_SW_WJW_BGK.VC_JKYS
  is '建卡医生';
comment on column ZJMB_SW_WJW_BGK.DT_JKSJ
  is '建卡时间';
comment on column ZJMB_SW_WJW_BGK.VC_XB
  is '性别';
comment on column ZJMB_SW_WJW_BGK.VC_MZ
  is '民族';
comment on column ZJMB_SW_WJW_BGK.VC_ZY
  is '职业';
comment on column ZJMB_SW_WJW_BGK.VC_HJDZLX
  is '户籍地址类型';
comment on column ZJMB_SW_WJW_BGK.VC_HJDZ
  is '户籍地址';
comment on column ZJMB_SW_WJW_BGK.VC_HJDZBM
  is '户籍地址编码';
comment on column ZJMB_SW_WJW_BGK.VC_HYZK
  is '婚姻状况';
comment on column ZJMB_SW_WJW_BGK.VC_WHCD
  is '文化程度';
comment on column ZJMB_SW_WJW_BGK.DT_SWRQ
  is '死亡日期';
comment on column ZJMB_SW_WJW_BGK.VC_SZNL
  is '实足年龄';
comment on column ZJMB_SW_WJW_BGK.VC_SFZHM
  is '身份证号码';
comment on column ZJMB_SW_WJW_BGK.VC_RQFL
  is '人群分类';
comment on column ZJMB_SW_WJW_BGK.VC_SWDD
  is '死亡地点';
comment on column ZJMB_SW_WJW_BGK.VC_SQCZDZLX
  is '生前长住地址类型';
comment on column ZJMB_SW_WJW_BGK.VC_SQXXDZ
  is '生前详细地址';
comment on column ZJMB_SW_WJW_BGK.VC_SQZGZDDW
  is '生前最高诊断单位';
comment on column ZJMB_SW_WJW_BGK.VC_ICDBM
  is 'ICD编码';
comment on column ZJMB_SW_WJW_BGK.VC_ZDYJ
  is '诊断依据';
comment on column ZJMB_SW_WJW_BGK.VC_GBSY
  is '根本死因';
comment on column ZJMB_SW_WJW_BGK.NB_GBSYBM
  is '根本死因ICD编码';
comment on column ZJMB_SW_WJW_BGK.VC_QTJBZD
  is '其它疾病诊断';
comment on column ZJMB_SW_WJW_BGK.NB_QTJBZDICD
  is '其它疾病诊断ICD10';
comment on column ZJMB_SW_WJW_BGK.VC_JSXM
  is '家属姓名';
comment on column ZJMB_SW_WJW_BGK.VC_JSLXDH
  is '家属联系电话';
comment on column ZJMB_SW_WJW_BGK.VC_JSDZ
  is '家属地址或工作单位';
comment on column ZJMB_SW_WJW_BGK.VC_BGKLB
  is '报告卡类别';
comment on column ZJMB_SW_WJW_BGK.VC_ZYH
  is '住院号';
comment on column ZJMB_SW_WJW_BGK.VC_SCBZ
  is '删除标志';
comment on column ZJMB_SW_WJW_BGK.VC_GLDWDM
  is '管理单位代码';
comment on column ZJMB_SW_WJW_BGK.VC_CJDWDM
  is '创建单位代码';
comment on column ZJMB_SW_WJW_BGK.DT_CJSJ
  is '创建时间';
comment on column ZJMB_SW_WJW_BGK.VC_CJYH
  is '创建用户';
comment on column ZJMB_SW_WJW_BGK.DT_XGSJ
  is '修改时间';
comment on column ZJMB_SW_WJW_BGK.VC_XGYH
  is '修改用户';
comment on column ZJMB_SW_WJW_BGK.VC_AZJSWJB
  is 'a直接导致死亡的疾病';
comment on column ZJMB_SW_WJW_BGK.NB_AZJSWJBICD
  is 'a直接导致死亡的疾病ICD10编码';
comment on column ZJMB_SW_WJW_BGK.VC_AFBDSWSJJG
  is 'a发病到死亡的时间间隔';
comment on column ZJMB_SW_WJW_BGK.VC_AFBDSWSJDW
  is 'a发病到死亡的时间间隔单位';
comment on column ZJMB_SW_WJW_BGK.VC_BZJSWJB
  is 'b直接导致死亡的疾病';
comment on column ZJMB_SW_WJW_BGK.NB_BZJSWJBIDC
  is 'b直接导致死亡的疾病ICD10编码';
comment on column ZJMB_SW_WJW_BGK.VC_BFBDSWSJJG
  is 'b发病到死亡的时间间隔';
comment on column ZJMB_SW_WJW_BGK.VC_BFBDSWSJDW
  is 'b发病到死亡的时间间隔单位';
comment on column ZJMB_SW_WJW_BGK.VC_CZJSWJB
  is 'c直接导致死亡的疾病';
comment on column ZJMB_SW_WJW_BGK.NB_CZJSWJBICD
  is 'c直接导致死亡的疾病ICD10编码';
comment on column ZJMB_SW_WJW_BGK.VC_CFBDSWSJJG
  is 'c发病到死亡的时间间隔';
comment on column ZJMB_SW_WJW_BGK.VC_CFBDSWSJDW
  is 'c发病到死亡的时间间隔单位';
comment on column ZJMB_SW_WJW_BGK.VC_DZJSWJB
  is 'd直接导致死亡的疾病';
comment on column ZJMB_SW_WJW_BGK.NB_DAJSWJBICD
  is 'd直接导致死亡的疾病ICD10编码';
comment on column ZJMB_SW_WJW_BGK.VC_DFBDSWSJJG
  is 'd发病到死亡的时间间隔';
comment on column ZJMB_SW_WJW_BGK.VC_DFBDSWSJDW
  is 'd发病到死亡的时间间隔单位';
comment on column ZJMB_SW_WJW_BGK.VC_SZSQBLJZZTZ
  is '死者生前病史及症状体征';
comment on column ZJMB_SW_WJW_BGK.VC_BDCZXM
  is '被调查者姓名';
comment on column ZJMB_SW_WJW_BGK.VC_YSZGX
  is '与死者关系';
comment on column ZJMB_SW_WJW_BGK.VC_LXDZHGZDW
  is '联系地址或工作单位';
comment on column ZJMB_SW_WJW_BGK.VC_BDCZDH
  is '被调查者电话号码';
comment on column ZJMB_SW_WJW_BGK.VC_SYTD
  is '死因推断';
comment on column ZJMB_SW_WJW_BGK.VC_BDCZQM
  is '调查者签名';
comment on column ZJMB_SW_WJW_BGK.DT_DCRQ
  is '调查日期';
comment on column ZJMB_SW_WJW_BGK.DT_SCSJ
  is '删除时间';
comment on column ZJMB_SW_WJW_BGK.DT_LRSJ
  is '录入时间';
comment on column ZJMB_SW_WJW_BGK.VC_LRRID
  is '录入人ID';
comment on column ZJMB_SW_WJW_BGK.VC_SHBZ
  is '审核标志';
comment on column ZJMB_SW_WJW_BGK.DT_SHSJ
  is '审核时间';
comment on column ZJMB_SW_WJW_BGK.VC_KPZT
  is '卡片状态';
comment on column ZJMB_SW_WJW_BGK.VC_KPLY
  is '卡片来源';
comment on column ZJMB_SW_WJW_BGK.VC_HKSDM
  is '户口市代码';
comment on column ZJMB_SW_WJW_BGK.VC_HKQXDM
  is '户口区县代码';
comment on column ZJMB_SW_WJW_BGK.VC_HKJDDM
  is '户口街道代码';
comment on column ZJMB_SW_WJW_BGK.VC_CSSDM
  is '出生市代码';
comment on column ZJMB_SW_WJW_BGK.VC_CSQXDM
  is '出生区县代码';
comment on column ZJMB_SW_WJW_BGK.VC_CSJDDM
  is '出生街道代码';
comment on column ZJMB_SW_WJW_BGK.DT_CSRQ
  is '出生日期';
comment on column ZJMB_SW_WJW_BGK.VC_WBSWYY
  is '外部死亡原因';
comment on column ZJMB_SW_WJW_BGK.VC_EBM
  is 'E编码';
comment on column ZJMB_SW_WJW_BGK.VC_YSQM
  is '医生签名';
comment on column ZJMB_SW_WJW_BGK.VC_HKHS
  is '户口核实';
comment on column ZJMB_SW_WJW_BGK.VC_WHSYY
  is '未核实原因';
comment on column ZJMB_SW_WJW_BGK.VC_HKQC
  is '户口迁出';
comment on column ZJMB_SW_WJW_BGK.VC_QCSDM
  is '户口迁出市代码';
comment on column ZJMB_SW_WJW_BGK.VC_QCQXDM
  is '户口迁出区县代码';
comment on column ZJMB_SW_WJW_BGK.VC_QCJDDM
  is '户口迁出街道代码';
comment on column ZJMB_SW_WJW_BGK.DT_QCSJ
  is '户口迁出时间';
comment on column ZJMB_SW_WJW_BGK.VC_BZ
  is '备注';
comment on column ZJMB_SW_WJW_BGK.VC_SHID
  is '审核ID';
comment on column ZJMB_SW_WJW_BGK.VC_KHZT
  is '考核状态?';
comment on column ZJMB_SW_WJW_BGK.VC_KHID
  is '考核ID';
comment on column ZJMB_SW_WJW_BGK.VC_KHJG
  is '考核结果';
comment on column ZJMB_SW_WJW_BGK.VC_HKXXDZ
  is '户口详细地址';
comment on column ZJMB_SW_WJW_BGK.VC_QCXXDZ
  is '迁出详细地址';
comment on column ZJMB_SW_WJW_BGK.VC_SQGZDW
  is '生前工作单位';
comment on column ZJMB_SW_WJW_BGK.VC_HKJW
  is '户口居委';
comment on column ZJMB_SW_WJW_BGK.VC_QCJW
  is '迁出居委';
comment on column ZJMB_SW_WJW_BGK.VC_EZJSWJB
  is 'e直接导致死亡的疾病';
comment on column ZJMB_SW_WJW_BGK.NB_EAJSWJBICD
  is 'e直接导致死亡的疾病ICD10编码';
comment on column ZJMB_SW_WJW_BGK.VC_EFBDSWSJJG
  is 'e发病到死亡的时间间隔';
comment on column ZJMB_SW_WJW_BGK.VC_EFBDSWSJDW
  is 'e发病到死亡的时间间隔单位';
comment on column ZJMB_SW_WJW_BGK.VC_FZJSWJB
  is 'f直接导致死亡的疾病';
comment on column ZJMB_SW_WJW_BGK.NB_FAJSWJBICD
  is 'f直接导致死亡的疾病ICD10编码';
comment on column ZJMB_SW_WJW_BGK.VC_FFBDSWSJJG
  is 'f发病到死亡的时间间隔';
comment on column ZJMB_SW_WJW_BGK.VC_FFBDSWSJDW
  is 'f发病到死亡的时间间隔单位';
comment on column ZJMB_SW_WJW_BGK.VC_GZJSWJB
  is 'g直接导致死亡的疾病';
comment on column ZJMB_SW_WJW_BGK.NB_GAJSWJBICD
  is 'g直接导致死亡的疾病ICD10编码';
comment on column ZJMB_SW_WJW_BGK.VC_GFBDSWSJJG
  is 'g发病到死亡的时间间隔';
comment on column ZJMB_SW_WJW_BGK.VC_GFBDSWSJDW
  is 'g发病到死亡的时间间隔单位';
comment on column ZJMB_SW_WJW_BGK.VC_HKQCS
  is '户口省代码';
comment on column ZJMB_SW_WJW_BGK.VC_QCSFDM
  is '户口迁出省代码';
comment on column ZJMB_SW_WJW_BGK.VC_QYID
  is '迁移ID';
comment on column ZJMB_SW_WJW_BGK.VC_SHZT
  is '审核状态 ';
comment on column ZJMB_SW_WJW_BGK.VC_SHWTGYY
  is '审核未通过原因';
comment on column ZJMB_SW_WJW_BGK.DT_QXZSSJ
  is '区县终审时间';
comment on column ZJMB_SW_WJW_BGK.VC_ZJLX
  is '证件类型';
comment on column ZJMB_SW_WJW_BGK.VC_RSQK
  is '妊娠情况';
comment on column ZJMB_SW_WJW_BGK.VC_WSHKSDM
  is '外省户口市代码';
comment on column ZJMB_SW_WJW_BGK.VC_WSHKQXDM
  is '外省户口区县代码';
comment on column ZJMB_SW_WJW_BGK.VC_WSHKJDDM
  is '外省户口街道代码';
comment on column ZJMB_SW_WJW_BGK.VC_WSHKJW
  is '外省户口居委';
comment on column ZJMB_SW_WJW_BGK.VC_GJHDQ
  is '国家或地区';
comment on column ZJMB_SW_WJW_BGK.VC_WSHKSHENDM
  is '外省户口省代码';
comment on column ZJMB_SW_WJW_BGK.VC_JZQCS
  is '居住省代码';
comment on column ZJMB_SW_WJW_BGK.VC_JZSDM
  is '居住市代码';
comment on column ZJMB_SW_WJW_BGK.VC_JZQXDM
  is '居住区县代码';
comment on column ZJMB_SW_WJW_BGK.VC_JZJDDM
  is '居住街道代码';
comment on column ZJMB_SW_WJW_BGK.VC_JZJW
  is '居住居委';
comment on column ZJMB_SW_WJW_BGK.VC_WSJZSHENDM
  is '外省居住省代码';
comment on column ZJMB_SW_WJW_BGK.VC_WSJZSDM
  is '外省居住市代码';
comment on column ZJMB_SW_WJW_BGK.VC_WSJZQXDM
  is '外省居住区县代码';
comment on column ZJMB_SW_WJW_BGK.VC_WSJZJDDM
  is '外省居住街道代码';
comment on column ZJMB_SW_WJW_BGK.VC_WSJZJW
  is '外省居住居委';
comment on column ZJMB_SW_WJW_BGK.UPLOADCOUNTRY
  is '上传标识， ''或者1 为未上传  2 为已上传 待验证 3 已上传 且已验证(成功) 4 已上传 验证失败';
comment on column ZJMB_SW_WJW_BGK.REQUESTID
  is '上报id';
comment on column ZJMB_SW_WJW_BGK.VC_WJW_SCBZ
  is '卫健委上传标志，默认为0未上传，1为已上传';
comment on column ZJMB_SW_WJW_BGK.DT_WJW_SCSJ
  is '卫健委上传时间';
-- Create/Recreate primary, unique and foreign key constraints 
alter table ZJMB_SW_WJW_BGK
  add constraint ZJMB_SW_WJW_BGK_PRIMARY_KEY primary key (VC_BGKID)
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
create index INDEX_SW_WJW_VCID on ZJMB_SW_WJW_BGK (VC_ID)
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
create index ZJJK_SW_WJW_INDEX on ZJMB_SW_WJW_BGK (VC_XM, VC_JKDW, DT_SWRQ, VC_BGKLB, VC_HKSDM, VC_HKQXDM, VC_HKJDDM)
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
