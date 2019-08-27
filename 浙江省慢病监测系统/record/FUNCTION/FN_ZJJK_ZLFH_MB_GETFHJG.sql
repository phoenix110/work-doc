CREATE OR REPLACE FUNCTION fn_zjjk_zlfh_mb_getfhjg(v_mblx   VARCHAR2,
                                                   v_bgkid  VARCHAR2,
                                                   v_cctjid VARCHAR2)
  RETURN VARCHAR2 IS
  /*-------------------------------
  函数名： fn_zjjk_zlfh_mb_getfhjg
  作者：    yrq
  功能:    获取慢病复核结果情况
  创建日期： 2018-11-28
  修改日期:
  版本号:
  --------------------------------*/
  v_id     VARCHAR2(100);
  v_ccbz   VARCHAR2(100);
  v_fhjgpd VARCHAR2(100);
BEGIN
  v_fhjgpd := '';

  SELECT id, ccbz
    INTO v_id, v_ccbz
    FROM zjjk_mb_zlfh
   WHERE mblx = v_mblx
     AND bgkid = v_bgkid
     AND cctjid = v_cctjid
     AND zt = '1';

  IF v_id IS NOT NULL THEN
    IF v_ccbz IS NOT NULL AND v_ccbz = '101' THEN
      SELECT fhjgpd INTO v_fhjgpd FROM zjjk_mb_zlfh_ncz WHERE id = v_id;
    ELSIF v_ccbz = '201' THEN
      SELECT fhjgpd INTO v_fhjgpd FROM zjjk_mb_zlfh_gxb WHERE id = v_id;
    ELSIF v_ccbz = '301' THEN
      SELECT fhjgpd INTO v_fhjgpd FROM zjjk_mb_zlfh_tnb WHERE id = v_id;
    ELSIF v_ccbz = '401' THEN
      SELECT fhjgpd INTO v_fhjgpd FROM zjjk_mb_zlfh_fa WHERE id = v_id;
    ELSIF v_ccbz = '402' THEN
      SELECT fhjgpd INTO v_fhjgpd FROM zjjk_mb_zlfh_ga WHERE id = v_id;
    ELSIF v_ccbz = '403' THEN
      SELECT fhjgpd INTO v_fhjgpd FROM zjjk_mb_zlfh_wa WHERE id = v_id;
    ELSIF v_ccbz = '404' THEN
      SELECT fhjgpd INTO v_fhjgpd FROM zjjk_mb_zlfh_sga WHERE id = v_id;
    ELSIF v_ccbz = '405' THEN
      SELECT fhjgpd INTO v_fhjgpd FROM zjjk_mb_zlfh_jzca WHERE id = v_id;
    ELSIF v_ccbz = '406' THEN
      SELECT fhjgpd INTO v_fhjgpd FROM zjjk_mb_zlfh_nxrxa WHERE id = v_id;
    ELSIF v_ccbz = '407' THEN
      SELECT fhjgpd INTO v_fhjgpd FROM zjjk_mb_zlfh_qtexzl WHERE id = v_id;
    END IF;
  END IF;

  IF v_fhjgpd IS NOT NULL AND v_fhjgpd = '0' THEN
    v_fhjgpd := '符合';
  ELSIF v_fhjgpd IS NOT NULL AND v_fhjgpd = '1' THEN
    v_fhjgpd := '不符合';
  END IF;
  RETURN v_fhjgpd;
END fn_zjjk_zlfh_mb_getfhjg;
