CREATE OR REPLACE FUNCTION fn_zjjk_zlfh_csf_getfhjg(v_csflx VARCHAR2,
                                                    v_bllx  VARCHAR2,
                                                    v_id    VARCHAR2)
  RETURN VARCHAR2 IS
  /*-------------------------------
  函数名： fn_zjjk_zlfh_csf_getfhjg
  作者：    yrq
  功能:    获取初随访复核结果情况
  创建日期： 2018-11-28
  修改日期:
  版本号:
  --------------------------------*/
  v_sffh VARCHAR2(10);
BEGIN
  v_sffh := '';

  IF v_id IS NOT NULL THEN
    IF v_csflx IS NOT NULL AND v_csflx = '1' THEN
      IF v_bllx IS NOT NULL AND v_bllx = '5' THEN
        SELECT sffh INTO v_sffh FROM zjjk_cf_zlfh_swga WHERE id = v_id;
      ELSE
        SELECT sffh INTO v_sffh FROM zjjk_cf_zlfh_mxbjc WHERE id = v_id;
      END IF;
    ELSIF v_csflx IS NOT NULL AND v_csflx = '2' THEN
      SELECT sffh INTO v_sffh FROM zjjk_sf_zlfh_mxbjc WHERE id = v_id;
    END IF;
  END IF;

  IF v_sffh IS NOT NULL AND v_sffh = '0' THEN
    v_sffh := '符合';
  ELSIF v_sffh IS NOT NULL AND v_sffh = '1' THEN
    v_sffh := '不符合';
  END IF;
  RETURN v_sffh;
END fn_zjjk_zlfh_csf_getfhjg;
