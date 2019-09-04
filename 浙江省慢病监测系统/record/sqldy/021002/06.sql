SELECT id,
       bkdw,
       zyh,
       jbxxybgksfyz,
       kpzt,
       DECODE(kpzt,'0','可用卡','2','死卡','3','误诊卡','4','重复卡','5','删除卡','6','失访卡','7','死亡卡') kpzt_text,
       blh,
       bgkbm,
       xm,
       xmxg,
       xb,
       xbxg,
       dts(csrq,0) csrq,
       csrqxg,
       sfzh,
       sfzhxg,
       dts(zdrq,0) zdrq,
       zdrqxg,
       icd10,
       icd10xg,
       bgyysfwzdyy,
       zdyymc,
       czbajldjttj,
       qtczbajldtj,
       sfczbdcxgbazl,
       bajlsfdzh,
       dzbasjnr,
       wczbdcxgbazlyy,
       qtknyy,
       sfcjbasy,
       sfcjcyxj,
       sfcjryjl,
       sfcjqwwjxnmhjblbg,
       sfcjwxxbcjcbg,
       sfcjwtlxbxjcbg,
       zyzd,
       cyhqtzd,
       chzt,
       wlcdqtjcbg,
       blcjzqz,
       bacjzdw,
			 dts(fhbgrq,0) fhbgrq,
       zdyj,
       zdyjxg,
       fhjgpd,
       zlwzx,
       fhzt,
       cjrid,
       cjrxm,
       cjsj,
       xgrid,
       xgrxm,
       xgsj,
       blxlx,
       blxlxxg,
       xmsh,
       xbsh,
       csrqsh,
       sfzhsh,
       icd10sh,
       zdrqsh,
       basyzp,
       cyxjzp,
       ryjlzp,
       qwwjxnmhjblbgzp,
       wxxbcjcbgzp,
       icdo3bm,
       icdo3bmxg,       
       wtlxbxjcbgzp
  FROM zjjk_mb_zlfh_wa
 WHERE id = #{id}                                                                                                    