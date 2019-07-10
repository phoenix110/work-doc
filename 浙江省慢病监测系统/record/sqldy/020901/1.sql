select
        t.VC_RKGLID, 
        t.VC_RKGLSF,
        t.VC_RKGLS,
        t.VC_RKGLQ,
        t.VC_RKGLJD,
        t.VC_LX,
        t.VC_XTLB,
        t.VC_NF,
        t.VC_NHJ,
        t.VC_VHJ,
        t.VC_ZHJ,
        t.VC_GANHJ,
        t.VC_GAVHJ,
        t.VC_GAZHJ,
        t.VC_0NLD,
        t.VC_1NLD,
        t.VC_5NLD,
        t.VC_10NLD,
        t.VC_15NLD,
        t.VC_20NLD,
        t.VC_25NLD,
        t.VC_30NLD,
        t.VC_35NLD,
        t.VC_40NLD,
        t.VC_45NLD,
        t.VC_50NLD,
        t.VC_55NLD,
        t.VC_60NLD,
        t.VC_65NLD,
        t.VC_70NLD,
        t.VC_75NLD,
        t.VC_80NLD,
        t.VC_85NLD,
        t.VC_ZRKS
    from
        ZJMB_RKGLB t 
    where
        t.VC_RKGLS=#{vc_hks} 
        and t.VC_RKGLQ=#{vc_hkqx} 
        and t.VC_RKGLJD=#{vc_hkjd} 
        and t.VC_NF=#{nf}
    order by
        t.VC_LX ASC