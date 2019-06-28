-- Create table
create table TEST_CLOB
(
  ID VARCHAR2(64) not null,
  CLOB_VAL  CLOB,
  CJSJ DATE default sysdate not null
)
tablespace DXBMF_CS
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
-- Add comments to the columns 
comment on column TEST_CLOB.ID
  is '主键ID';
comment on column TEST_CLOB.CLOB_VAL
  is 'CLOB内容';
comment on column TEST_CLOB.CJSJ
  is '创建时间';
-- Create/Recreate primary, unique and foreign key constraints 
alter table TEST_CLOB
  add constraint PK_TEST_CLOB primary key (ID)
  using index 
  tablespace DXBMF_CS
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
