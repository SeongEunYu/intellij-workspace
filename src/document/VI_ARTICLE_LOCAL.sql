
  CREATE OR REPLACE FORCE VIEW "VI_ARTICLE_LOCAL" ("SOURC_IDNTFC_NO", "PBLCATE_TYPE", "ARTICLE_TTL", "PLSCMPN_NM", "LANG", "DOC_TYPE", "ADIT_KWRD", "AUTHR_KWRD", "PBLSHR_NM", "PBLSHR_CITY", "PBLSHR_ADRES", "TC", "TC_DATE", "ISSN", "ARTICLE_ABRV", "ISO_ARTICLE_ABRV", "PBLCATE_DATE", "PBLCATE_YEAR", "VLM", "ISSUE", "BEGIN_PAGE", "END_PAGE", "DOI", "SUBJCT_CTGRY", "ARTICLE_DELY_NO", "RPNT_ADRES", "EMAIL_ADRES", "TR_PC", "RE_IF", "RE_DATE", "RE_USER", "DPLCT_SOURC_IDNTFC_NO", "ARTL_TIMEP", "STATUS", "REGDATE", "MIG_COMPLETED", "MIG_USER", "MIG_DATE", "IS_APPROVAL", "TR_PD", "ARTICLE_ID", "ABSTRCT", "ISBN", "CFRNC_NM", "CFRNC_DATE", "CFRNC_LOC", "CFRNC_CD", "RE_PC", "RE_LA", "SOURC_DVSN_CD", "VA_DATE", "VA_USER", "RE_PERNO", "AUTORDER", "PERNO", "NAME_KOR", "NAME_ENG", "DEPT") AS
  SELECT  TA.SOURC_IDNTFC_NO AS SOURC_IDNTFC_NO,         /*   소스고유번호   */
          TA.PBLCATE_TYPE AS PBLCATE_TYPE,                /*   출판유형          */
          TA.ARTICLE_TTL AS ARTICLE_TTL,                 /*   논문명            */
          TA.PLSCMPN_NM AS PLSCMPN_NM,                    /*   출판사명          */
          TA.LANG AS LANG,                                /*   작성언어          */
          TA.DOC_TYPE AS DOC_TYPE,                        /*   논문유형          */
          TA.ADIT_KWRD AS ADIT_KWRD,                           /*   추가 키워드   */
          TA.AUTHR_KWRD AS AUTHR_KWRD,                     /*   저자키워드        */
          TA.PBLSHR_NM AS PBLSHR_NM,                      /*   발행인명          */
          TA.PBLSHR_CITY AS PBLSHR_CITY,                 /*   발행국            */
          TA.PBLSHR_ADRES AS PBLSHR_ADRES,                 /*   출판사주소        */
          TA.TC AS TC,                                    /*   인용횟수          */
          TA.TC_DATE AS TC_DATE,                             /*   인용횟수수정일자   */
          TA.ISSN AS ISSN,                              /*   ISSN번호          */
          TA.ARTICLE_ABRV AS ARTICLE_ABRV,                 /*   논문약어명        */
          TA.ISO_ARTICLE_ABRV AS ISO_ARTICLE_ABRV,           /*   ISO논문약어명   */
          TA.PBLCATE_DATE AS PBLCATE_DATE,                /*   출판일자          */
          TA.PBLCATE_YEAR AS PBLCATE_YEAR,                /*   출판년도          */
          TA.VLM AS VLM,                               /*   권                */
          TA.ISSUE AS ISSUE,                           /*   호                */
          TA.BEGIN_PAGE AS BEGIN_PAGE,                     /*   시작페이지        */
          TA.END_PAGE AS END_PAGE,                        /*   끝페이지          */
          TA.DOI AS DOI,                              /*   DOI               */
          TA.SUBJCT_CTGRY AS SUBJCT_CTGRY,                     /*   주제카테코리   */
          TA.ARTICLE_DELY_NO AS ARTICLE_DELY_NO,               /*   논문배포번호   */
          TA.RPNT_ADRES AS RPNT_ADRES,                     /*   재발행주소        */
          TA.EMAIL_ADRES AS EMAIL_ADRES,                /*   EMAIL주소         */
          TA.TR_PC AS TR_PC,                          /*   TR_PC             */
          TA.RE_IF AS RE_IF,                            /*   매핑IF            */
          TA.RE_DATE AS RE_DATE,                          /*   매핑일자          */
          TA.RE_USER AS RE_USER,                           /*   매핑자사번        */
          TA.DPLCT_SOURC_IDNTFC_NO AS DPLCT_SOURC_IDNTFC_NO, /*   중복소스고유번호   */
          TA.ARTL_TIMEP AS ARTL_TIMEP,                /*   ARTL_TIMEP        */
          TA.STATUS AS STATUS,                            /*   논문상태          */
          TA.REGDATE AS REGDATE,                          /*   등록일자          */
          TA.MIG_COMPLETED AS MIG_COMPLETED,          /*   MIG_COMPLETED     */
          TA.MIG_USER AS MIG_USER,                    /*   MIG_USER          */
          TA.MIG_DATE AS MIG_DATE,                    /*   MIG_DATE          */
          TA.IS_APPROVAL AS IS_APPROVAL,              /*   IS_APPROVAL       */
          TA.TR_PD AS TR_PD,                          /*   TR_PD             */
          TA.ARTICLE_ID AS ARTICLE_ID,                         /*   논문관리번호   */
          TA.ABSTRCT AS ABSTRCT,                        /*   초록              */
          TA.ISBN AS ISBN,                              /*   ISBN번호          */
          TA.CFRNC_NM AS CFRNC_NM,                         /*   학술활동명        */
          TA.CFRNC_DATE AS CFRNC_DATE,                         /*   학술활동일자   */
          TA.CFRNC_LOC AS CFRNC_LOC,                          /*   학술활동개최지   */
          TA.CFRNC_CD AS CFRNC_CD,                             /*   학술활동코드   */
          TA.RE_PC AS RE_PC,                              /*   매핑국가          */
          TA.RE_LA AS RE_LA,                              /*   매핑언어          */
          TA.SOURC_DVSN_CD AS SOURC_DVSN_CD,                   /*   소스구분코드   */
          TA.VA_DATE AS VA_DATE,                      /*   VA_DATE           */
          TA.VA_USER AS VA_USER,                      /*   VA_USER           */
          TB.RE_PERNO AS RE_PERNO,
          TB.AUTHR_SEQ AS AUTORDER,
          TC.USER_ID AS PERNO,
          TC.KOR_NM AS NAME_KOR,
          TC.LAST_NAME || ', ' || TC.FIRST_NAME AS NAME_ENG,
          TC.dept_KOR AS DEPT
     FROM ER_ARTICLE TA, ER_ARTICLE_AUTHR TB, RI_USER TC
    WHERE TA.SOURC_IDNTFC_NO = TB.SOURC_IDNTFC_NO
          AND TB.RE_PERNO = TC.USER_ID;

