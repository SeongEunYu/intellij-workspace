<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@include file="../pageInit.jsp" %>
<head>
    <script type="text/javascript">
        $(function () {
            //대메뉴 형광색 들어오게하기
            $("#bigAbout").addClass("on");

        });
    </script>
</head>
<body>
<div class="sub_container">
    <div ${pageContext.response.locale == 'ko' ? '' : 'class="hidden"'}>
        <h3 class="result_title"><spring:message code="disc.about.rims.title"/></h3>
        <div class="about_top_wrap">
            <%--<div class="language_r_box">
                <a href="${pageContext.request.contextPath}/share/user/overviewRims.do"><spring:message code="disc.language.eng"/></a>
                <a href="#" class="on"><spring:message code="disc.language.kor"/></a>
            </div>--%>


            <div class="row">
                <div class="col-md-6">
                    <div class="about_rims_box">
                        <dl>
                            <dt>RIMS란</dt>
                            <dd style="text-align: justify">연구성과관리시스템(RIMS)은 KAIST 연구성과정보를 종합적으로 수집ㆍ등록ㆍ관리ㆍ활용하기 위하여 구축된 시스템입니다. 전임교원 성과정보는 KOASAS와 한국연구재단의 KRI 시스템에 연계되어 활용되고 있으며, 기관 내부의 성과관리와 각종 대·내외 평가에 활용됩니다.
                            </dd>
                        </dl>
                    </div>

                </div>
                <div class="col-md-6">
                    <div class="about_rims_box ar_icon02">
                        <dl>
                            <dt class="rg_dt">RIMS Discovery란</dt>
                            <dd style="text-align: justify">RIMS Discovery는 RIMS에 구축된 연구성과정보 중 KAIST 구성원에게 공개 가능한 연구자 정보, 저널논문, 학술활동(2010년 이후), 연구과제(종료된 정부과제), 등록 특허(2000년 이후), 기타 관련 연구정보를 제공하는 연구자(전임교원) 및 연구성과 통합 검색 서비스를 제공합니다.
                            </dd>
                        </dl>
                    </div>
                </div>
            </div>


        </div>
        <div class="about_rims_box ar_icon03 mgb_50">

            <h4>RIMS 성과 관리 대상 및 접속권한</h4>

            <div class="about_rbox">
                <ol class="about_ol">
                    <li><em class="list_num">1</em><strong>접속주소</strong> <a href="http://portal.kaist.ac.kr/" class="link_text" target="_blank">http://portal.kaist.ac.kr/</a> 접속 → 로그인 → 바로가기 메뉴에서 RIMS를 선택</li>
                    <li><em class="list_num">2</em><strong>RIMS 성과관리 항목 및 대상자</strong>
                        <ul class="bullet_ul">
                            <li>전임 및 비전임교원, 전임연구원
                                <ul>
                                    <li>논문게재, 학술활동, 저역서, 연구비, 지식재산, 기술이전, 전시작품, 경력사항, 취득학위, 수상사항, 자격사항, 연구분야, 강의실적, 학생배출실적, 연구보고서,
                                        기타연구실적, 기타활용실적 등 17개 성과정보</li>
                                </ul>
                            </li>
                        </ul>
                    </li>
                    <li><em class="list_num">3</em><strong>RIMS 접속 권한</strong> 성과관리 대상자, 대리입력자, 학과담당자, 팀장 등 권한이 부여된 이용자
                    </li>

                </ol>
            </div>
        </div>

        <div class="about_rims_box ar_icon04 mgb_50">
            <h4>연구성과관리시스템(RIMS) 구성도</h4>
            <p class="mgb_20">One Source Multi Use 개념 기반인 연구성과관리시스템(RIMS) 구성도 입니다. </p>
            <div class="about_img_box"><img src="<c:url value="/share/img/common/about_img01.png"/>" alt="연구성과관리시스템(RIMS) 구성도"/></div>
        </div>


        <div class="about_rims_box ar_icon05">
            <h4>RIMS를 통한 전임교원 성과정보 연계 시스템</h4>


            <div class="about_con_wrap mgb_40">
                <h5 class="about_rt">한국연구재단의 KRI</h5>
                <div class="as_list">
                    <ul class="mgb_10">
                        <li class="add_blank"><span class="ft_text">KRI 시스템</span>대학 및 기관 연구자들의 연구업적 정보를 국가차원에서 공유 및 활용하기 위해 구축한 한국연구자정보 DB 입니다.</li>
                        <li class="add_blank"><span class="ft_text">대학정보공시</span>교육관련 기관 정보공개에 관한 특례법의 취지에 따라 학술 및 정책연구진흥과 아울러 학교교육에 대한 참여와 교육행정의 투명성을 제고하고자 2008년 5월에 시행되었습니다.</li>
                    </ul>

                    <p class="l_arrow_p">자세한 사항은 KRI 웹 사이트(<a href="http://www.kri.go.kr" class="link_text" target="_blank">http://www.kri.go.kr</a>) 참조</p>
                </div>
            </div>

            <div class="about_con_wrap mgb_40">
                <h5 class="about_rt">KOASAS</h5>
                <div class="as_list">
                    <ul class="mgb_10">
                        <li>KOASAS는 KAIST 교수님들의 연구 결과물에 대한 Open Access Self-Archiving 기반의 Institutional Repository 시스템으로 교수님들의 연구성과 확산(인용횟수 증가)과 KAIST의 위상 제고를 목적으로 운영하는 시스템입니다.</li>
                    </ul>

                    <p class="l_arrow_p">자세한 사항은 KOASAS 웹 사이트(<a href="http://koasas.kaist.ac.kr" class="link_text" target="_blank">http://koasas.kaist.ac.kr</a>) 참조</p>
                </div>
            </div>
            <div class="about_con_wrap">
                <h5 class="about_rt">Web of Science의 ResearcherID</h5>
                <div class="as_list">
                    <ul class="mgb_10">
                        <li>SCI(Web of Science)의 Thomson Reuters사와 Nature사가 공동으로 운영하는 저자의 고유식별번호입니다.</li>
                        <li>저자 이름의 모호성을 해결하여 완전한 인용 분석과 공동연구 현황을 파악하고 저자의 프로필을 홍보하고 관리하는데 도움을 줍니다.</li>
                    </ul>
                    <p class="l_arrow_p">자세한 사항은 ResearcherID 웹 사이트 (<a href="http://www.researcherid.com" class="link_text" target="_blank">http://www.researcherid.com</a>) 참조</p>
                </div>
            </div>
        </div>
    </div>
    <div ${pageContext.response.locale == 'en' ? '' : 'class="hidden"'}>
        <h3 class="result_title"><spring:message code="disc.about.rims.title"/></h3>
        <div class="about_top_wrap">
            <%--<div class="language_r_box">
                <a href="#" class="on"><spring:message code="disc.language.eng"/></a>
                <a href="${pageContext.request.contextPath}/share/user/overviewRims.do?language=ko"><spring:message code="disc.language.kor"/></a>
            </div>--%>
            <div class="row">
                <div class="col-md-6">
                    <div class="about_rims_box">
                        <dl>
                            <dt>RIMS</dt>
                            <dd style="text-align: justify">KAIST operates Researcher Information Management System (RIMS) to collect, register, maintain, and utilize the results of studies of the KAIST researchers. The data of the RIMS is automatically transferred to KOASAS and Korean Researcher Information (KRI) and used for government research funding application and university evaluation.
                            </dd>
                        </dl>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="about_rims_box ar_icon02">
                        <dl>
                            <dt class="rg_dt">RIMS Discovery</dt>
                            <dd style="text-align: justify">RIMS Discovery provides integrated searching service to the KAIST members for non-confidential information such as researchers’ information, journal articles, conference papers(since 2010), completed research project by government, registered patents(since 2000) among selected research results of the full-time researchers in the RIMS.
                            </dd>
                        </dl>
                    </div>
                </div>
            </div>
        </div>
        <div class="about_rims_box ar_icon03 mgb_50">
            <h4>RIMS Instruction</h4>
            <div class="about_rbox">
                <ol class="about_ol">
                    <li><em class="list_num">1</em><strong>How to access</strong> <a href="http://portal.kaist.ac.kr/" class="link_text" target="_blank">http://portal.kaist.ac.kr/</a>  login → click the “RIMS” on the “Quick Menu”</li>
                    <li><em class="list_num">2</em><strong>Whose achievements are managed by RIMS?</strong>
                        <ul class="bullet_ul">
                            <li>Professors and full-time researchers
                                <ul>
                                    <li>17 types of research achievements : Articles, Conference proceedings, Books, Research projects, Intellectual properties, Transfer of technology, Works in exhibitions, Careers, Degrees, Awards, Qualifications, Fields of study, Lecture records, Advised student, Final research report, Other research activities, Other activities</li>
                                </ul>
                            </li>
                            <li>Ph.D students
                                <ul>
                                    <li>Articles, Conference proceedings</li>
                                </ul>
                            </li>
                        </ul>
                    </li>
                    <li><em class="list_num">3</em><strong>RIMS Access Privileges</strong> Researchers, Department managers, Assistants</li>
                    <li><em class="list_num">4</em><strong>Contact</strong> rims@kaist.ac.kr (Tel. 042-350- 4493,4494)</li>
                </ol>
            </div>
        </div>



        <div class="about_rims_box ar_icon04 mgb_50">
            <h4>RIMS Block Diagram</h4>
            <p class="mgb_20">One Source Multi Use concept-based workforce management system(RIMS) configuration diagram. </p>
            <div class="about_img_box"><img src="<c:url value="/share/img/common/about_img02.png"/>" alt="연구성과관리시스템(RIMS) 구성도"/></div>
        </div>


        <div class="about_rims_box ar_icon05">
            <h4>Linked Systems of the RIMS</h4>
            <div class="about_con_wrap eng_ls_box mgb_40">
                <h5 class="about_rt">Korean Researcher Information by National Research Foundation of Korea</h5>
                <div class="as_list">
                    <ul class="mgb_10">
                        <li style="text-align: justify">The NRF is one of the research funding agencies in Korea for creating future knowledge and
                            fostering next-generation researchers. The KRI system of NRF is operated to disseminate
                            research results and knowledge. It also boosts the expertise and efficiency of research funding
                            systems by integrating scattered research management functions.</li>
                        <li style="text-align: justify"><strong>“Act on Information Disclosure of Educational Institutions”</strong> obligates thorough public
                            disclosure of information and regulates relevant details in order to ensure the right to be
                            informed, to promote academic and policy research, to encourage participation in school
                            education, and to improve the efficiency and transparency in educational administration by
                            disclosing the information managed by the Korean education institutions.</li>
                    </ul>

                    <p class="l_arrow_p">To see more details, please visit the website (<a href="http://www.kri.go.kr" class="link_text" target="_blank">http://www.kri.go.kr</a>)</p>
                </div>
            </div>

            <div class="about_con_wrap eng_ls_box mgb_40">
                <h5 class="about_rt">KOASAS (KAIST Open Access Self-Archiving System)</h5>
                <div class="as_list">
                    <ul class="mgb_10">
                        <li style="text-align: justify">KOASAS (http://koasas.kaist.ac.kr/) is an institutional repository based on an open access
                            self-archiving system used for research results in KAIST. In order to make use of KAIST
                            Institutional Repository, KOASAS is a customization of DSPACE which was developed by
                            MIT libraries and HP labs. It can disseminate research outputs and improve KAIST&#39;s
                            standing in the Webometrics Ranking of World Universities.</li>
                    </ul>

                    <p class="l_arrow_p">To see more details, please visit the website(<a href="http://koasas.kaist.ac.kr" class="link_text" target="_blank">http://koasas.kaist.ac.kr</a>)</p>
                </div>
            </div>
            <div class="about_con_wrap eng_ls_box">
                <h5 class="about_rt">ResearcherID of Web of Science</h5>
                <div class="as_list">
                    <ul class="mgb_10">
                        <li>ResearcherID (http://www.researcherid.com/) is a global, multi-disciplinary scholarly research community.</li>
                        <li style="text-align: justify">It uses a unique identifier assigned to each author which is co-operated by Thomson
                            Reuters and Nature. It is used to widely publicize research profiles of KAIST members and
                            increase joint researches and citations. It also contributes to improving the awareness of the
                            institution and raising the institutional ranking.</li>
                    </ul>
                    <p class="l_arrow_p">To see more details, please visit the website (<a href="http://www.researcherid.com" class="link_text" target="_blank">http://www.researcherid.com</a>)</p>
                </div>
            </div>
        </div>
    </div>

    <a id="toTop" href="#">상단으로 이동</a>

</div><!-- sub_container : e -->
</body>
