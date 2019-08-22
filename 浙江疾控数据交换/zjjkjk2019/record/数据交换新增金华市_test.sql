insert into zjsjk_ws_config (JLBH, SRCSYSTEM, INTEGRATION, WSUSERNAME, WSPASSWORD, AREANAME, AREACODE, WSDL_URL, NAME_SPACE, IMETHOD, SCBZ, WSTYPE)
values ((select max(jlbh) + 1 from zjsjk_ws_config), 'C2001', 'DTP3062', 'zjsmb', 'qwer1234', '½ð»ª', '3307', 'https://10.10.3.25:8443/ede-service/api/ws/dataExchange?wsdl', 'http://api.exchangeservice.ede.edata.com.cn/', 'dataEncryExchange', '1', '1');

