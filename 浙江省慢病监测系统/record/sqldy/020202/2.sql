select id,
       code,
       name,
       description, 
       pkg_zjmb_tnb.fun_getxzqhmc(vc_hkjd) dyjd 
       from organ_node  
       where description = #{hkjd}