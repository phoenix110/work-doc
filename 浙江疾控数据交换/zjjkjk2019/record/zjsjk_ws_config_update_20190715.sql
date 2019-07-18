update zjsjk_ws_config set wsdl_url = 'https://10.44.30.20:8443/ede-service/api/ws/dataExchange'
 where wstype = 1 and wsdl_url = 'https://10.10.3.20:8443/ede-service/api/ws/dataExchange'