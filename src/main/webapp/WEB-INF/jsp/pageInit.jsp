<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld" %>
<%@ taglib prefix="fn" uri="/WEB-INF/tld/fn.tld" %>
<%@ taglib prefix="spring" uri="/WEB-INF/tld/spring.tld" %>
<%@ taglib prefix="str" uri="/WEB-INF/tld/string.tld" %>
<%@ taglib prefix="ui" uri="/WEB-INF/tld/ui.tld" %>
<%@ taglib prefix="rims" uri="/WEB-INF/tld/rims.tld" %>
<%@ taglib prefix="fc" uri="/WEB-INF/tld/fusioncharts.tld"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<c:set var="asrimsContextPath" value="${pageContext.request.contextPath}/analysis"/>
<c:set var="asrimsImagePath" value="${pageContext.request.contextPath}/images/analysis_${fn:toLowerCase(sysConf['inst.abrv'])}"/>
<c:set var="dhtmlXImagePath" value="${contextPath}/images/dthmlx/skins/${sysConf['dhtmlx.skin']}/imgs/"/>
<c:set var="dhtmlXSkin" value="dhx_${sysConf['dhtmlx.skin']}"/>
<c:set var="dhtmlXPagingSkin" value="${sysConf['dhtmlx.grid.pagingSkin']}"/>
<c:set var="instAbrv" value="${sysConf['inst.abrv']}"/>
<c:set var="instName" value="${sysConf['inst.blng.agc.name']}"/>
<c:set var="language" value="${empty sessionScope.sess_user.languageFlag ? 'ko' : sessionScope.sess_user.languageFlag}"/>
<c:set var="sessMode" value="${not empty acessMode and acessMode eq 'rchfs' ? true : false }"/>
<c:set var="preUrl" value="${not empty acessMode and acessMode eq 'rchfs' ?  acessMode : 'auth' }"/>
<c:set var="notStdn" value="${(sessionScope.auth.adminDvsCd ne 'R' or sessionScope.sess_user.gubun ne 'S') and (not sessMode or sessionScope.sess_user.gubun ne 'S') }"/>
<script type="text/javascript">
 var contextpath = '${contextPath}';
 var preUrl = '${preUrl}';
 var dhtmlximagepath = '${dhtmlXImagePath}';
 var dhtmlxskin = '${dhtmlXSkin}';
 var dhtmlxpagingskin = '${dhtmlXPagingSkin}';
 var language = '${language}';
 var instname = "${instName}";
 var instcode = "${sysConf['inst.blng.agc.code']}";
 var loginAuthor = '${sessionScope.auth.adminDvsCd}';
 var sessUserId = '${sessionScope.sess_user.userId}';
 var isChange = false;
 var screenWidth = screen.width;
 var screenHeight = screen.height;
 var preUrl = '${preUrl}';
 var sessMode = '${sessMode}';
 var rimsUrl = "${sysConf['system.url']}";
 var kriAction = "${sysConf['kri.frm.action']}";
</script>