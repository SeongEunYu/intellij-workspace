<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld" %>
<%@ taglib prefix="fn" uri="/WEB-INF/tld/fn.tld" %>
<%@ taglib prefix="spring" uri="/WEB-INF/tld/spring.tld" %>
<%@ taglib prefix="str" uri="/WEB-INF/tld/string.tld" %>
<%@ taglib prefix="ui" uri="/WEB-INF/tld/ui.tld" %>
<%@ taglib prefix="rims" uri="/WEB-INF/tld/rims.tld" %>
<%@ taglib prefix="fc" uri="/WEB-INF/tld/fusioncharts.tld"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<c:set var="dhtmlXImagePath" value="${contextPath}/images/dthmlx/skins/${sysConf['dhtmlx.skin']}/imgs/"/>
<c:set var="dhtmlXSkin" value="dhx_${sysConf['dhtmlx.skin']}"/>
<c:set var="dhtmlXPagingSkin" value="${sysConf['dhtmlx.grid.pagingSkin']}"/>
<c:set var="instAbrv" value="${sysConf['inst.abrv']}"/>
<c:set var="instName" value="${sysConf['inst.blng.agc.name']}"/>
<c:set var="language" value="${empty sessionScope.sess_user.languageFlag ? 'KOR' : sessionScope.sess_user.languageFlag}"/>
<c:set var="gSessMode" value="${not empty acessMode and acessMode eq 'rchfs' ? true : false }"/>