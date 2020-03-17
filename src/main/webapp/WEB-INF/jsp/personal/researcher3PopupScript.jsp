<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<script type="text/javascript">
function popArticleListBySc(fromYear, toYear, sc, userId, page) {
    var mappingPopup = window.open('about:blank', 'articleList', 'height=614px,width=1050px,location=no,scrollbars=yes');
    var popFrm = $('#popFrm');
    popFrm.empty();
    popFrm.append($('<input type="hidden" name="fromYear" value="'+fromYear+'"/>'));
    popFrm.append($('<input type="hidden" name="toYear" value="'+toYear+'"/>'));
    popFrm.append($('<input type="hidden" name="sc" value="'+sc+'"/>'));
    popFrm.append($('<input type="hidden" name="title" value="'+sc+'"/>'));
    popFrm.append($('<input type="hidden" name="type" value="sc"/>'));
    if(userId)popFrm.append($('<input type="hidden" name="userId" value="'+userId+'"/>'));
    if(page)popFrm.append($('<input type="hidden" name="page" value="'+page+'"/>'));

    popFrm.attr('action', '<c:url value="/analysis/r/researcher/findArticleListByCondPopup.do"/>');
    popFrm.attr('target', 'articleList');
    popFrm.attr('method', 'POST');
    popFrm.submit();
    mappingPopup.focus();
}
function popArticleListByKeyword(fromYear, toYear, keyword, userId, page) {
    var mappingPopup = window.open('about:blank', 'articleList', 'height=614px,width=1050px,location=no,scrollbars=yes');
    var popFrm = $('#popFrm');
    popFrm.empty();
    popFrm.append($('<input type="hidden" name="fromYear" value="'+fromYear+'"/>'));
    popFrm.append($('<input type="hidden" name="toYear" value="'+toYear+'"/>'));
    popFrm.append($('<input type="hidden" name="keyword" value="'+keyword+'"/>'));
    popFrm.append($('<input type="hidden" name="title" value="'+keyword+'"/>'));
    popFrm.append($('<input type="hidden" name="type" value="keyword"/>'));
    if(userId)popFrm.append($('<input type="hidden" name="userId" value="'+userId+'"/>'));
    if(page)popFrm.append($('<input type="hidden" name="page" value="'+page+'"/>'));

    popFrm.attr('action', '<c:url value="/analysis/r/researcher/findArticleListByCondPopup.do"/>');
    popFrm.attr('target', 'articleList');
    popFrm.attr('method', 'POST');
    popFrm.submit();
    mappingPopup.focus();
}
function popArticleDetail(articleId, userId) {
    var mappingPopup = window.open('about:blank', 'articleDetail', 'height=614px,width=1100px,location=no,scrollbars=yes');
    var popFrm = $('#popFrm');
    popFrm.empty();
    popFrm.append($('<input type="hidden" name="articleId" value="'+articleId+'"/>'));
    if(userId)popFrm.append($('<input type="hidden" name="userId" value="'+userId+'"/>'));
    popFrm.attr('action', 'articleDetailPopup.do');
    popFrm.attr('target', 'articleDetail');
    popFrm.attr('method', 'POST');
    popFrm.submit();
    mappingPopup.focus();
}

function popConferenceDetail(conferenceId, userId) {
    var mappingPopup = window.open('about:blank', 'conferenceDetail', 'height=614px,width=1100px,location=no,scrollbars=yes');
    var popFrm = $('#popFrm');
    popFrm.empty();
    popFrm.append($('<input type="hidden" name="conferenceId" value="'+conferenceId+'"/>'));
    if(userId)popFrm.append($('<input type="hidden" name="userId" value="'+userId+'"/>'));
    popFrm.attr('action', 'conferenceDetailPopup.do');
    popFrm.attr('target', 'conferenceDetail');
    popFrm.attr('method', 'POST');
    popFrm.submit();
    mappingPopup.focus();
}
function popBookDetail(bookId, userId) {
    var mappingPopup = window.open('about:blank', 'bookDetail', 'height=614px,width=1100px,location=no,scrollbars=yes');
    var popFrm = $('#popFrm');
    popFrm.empty();
    popFrm.append($('<input type="hidden" name="bookId" value="'+bookId+'"/>'));
    if(userId)popFrm.append($('<input type="hidden" name="userId" value="'+userId+'"/>'));
    popFrm.attr('action', 'bookDetailPopup.do');
    popFrm.attr('target', 'bookDetail');
    popFrm.attr('method', 'POST');
    popFrm.submit();
    mappingPopup.focus();
}

function popRcArticleListBySc(fromYear, toYear, sc, userId, page) {
    var mappingPopup = window.open('about:blank', 'rcArticleList', 'height=614px,width=1050px,location=no,scrollbars=yes');
    var popFrm = $('#popFrm');
    popFrm.empty();
    popFrm.append($('<input type="hidden" name="fromYear" value="'+fromYear+'"/>'));
    popFrm.append($('<input type="hidden" name="toYear" value="'+toYear+'"/>'));
    popFrm.append($('<input type="hidden" name="subjctCtgry" value="'+sc+'"/>'));
    popFrm.append($('<input type="hidden" name="title" value="'+sc+'"/>'));
    popFrm.append($('<input type="hidden" name="type" value="sc"/>'));
    if(userId)popFrm.append($('<input type="hidden" name="userId" value="'+userId+'"/>'));
    if(page)popFrm.append($('<input type="hidden" name="page" value="'+page+'"/>'));

    popFrm.attr('action', 'findRcArticleListByCondPopup.do');
    popFrm.attr('target', 'rcArticleList');
    popFrm.attr('method', 'POST');
    popFrm.submit();
    mappingPopup.focus();
}
function popRcArticleListByKeyword(fromYear, toYear, keyword, userId, page) {
    var mappingPopup = window.open('about:blank', 'rcArticleList', 'height=614px,width=1050px,location=no,scrollbars=yes');
    var popFrm = $('#popFrm');
    popFrm.empty();
    popFrm.append($('<input type="hidden" name="fromYear" value="'+fromYear+'"/>'));
    popFrm.append($('<input type="hidden" name="toYear" value="'+toYear+'"/>'));
    popFrm.append($('<input type="hidden" name="authrKwrd" value="'+keyword+'"/>'));
    popFrm.append($('<input type="hidden" name="keyword" value="'+keyword+'"/>'));
    popFrm.append($('<input type="hidden" name="title" value="'+keyword+'"/>'));
    popFrm.append($('<input type="hidden" name="type" value="keyword"/>'));
    if(userId)popFrm.append($('<input type="hidden" name="userId" value="'+userId+'"/>'));
    if(page)popFrm.append($('<input type="hidden" name="page" value="'+page+'"/>'));

    popFrm.attr('action', 'findRcArticleListByCondPopup.do');
    popFrm.attr('target', 'rcArticleList');
    popFrm.attr('method', 'POST');
    popFrm.submit();
    mappingPopup.focus();
}
function popRcArticleDetail(eId, userId) {
    var mappingPopup = window.open('about:blank', 'rcArticleDetail', 'height=614px,width=1100px,location=no,scrollbars=yes');
    var popFrm = $('#popFrm');
    popFrm.empty();
    popFrm.append($('<input type="hidden" name="eId" value="'+eId+'"/>'));
    if(userId)popFrm.append($('<input type="hidden" name="userId" value="'+userId+'"/>'));
    popFrm.attr('action', 'rcArticleDetailPopup.do');
    popFrm.attr('target', 'rcArticleDetail');
    popFrm.attr('method', 'POST');
    popFrm.submit();
    mappingPopup.focus();
}
function popArticleListByCoAuthor(fromYear, toYear, userId, gubun, targtUserId, trgetSe, pure_nm, title, page) {
    var mappingPopup = window.open('about:blank', 'articleList', 'height=614px,width=1050px,location=no,scrollbars=yes');
    var popFrm = $('#popFrm');
    popFrm.empty();
    popFrm.append($('<input type="hidden" name="fromYear" value="'+fromYear+'"/>'));
    popFrm.append($('<input type="hidden" name="toYear" value="'+toYear+'"/>'));
    popFrm.append($('<input type="hidden" name="topNm" value="researcher"/>'));
    popFrm.append($('<input type="hidden" name="userId" value="'+userId+'"/>'));
    popFrm.append($('<input type="hidden" name="gubun" value="'+gubun+'"/>'));
    popFrm.append($('<input type="hidden" name="coauthorUser" value="'+targtUserId+'"/>'));
    popFrm.append($('<input type="hidden" name="trgetSe" value="'+trgetSe+'"/>'));
    popFrm.append($('<input type="hidden" name="trgetPsitn" value="'+targtUserId+'"/>'));
    popFrm.append($('<input type="hidden" name="trgetNm" value="'+pure_nm+'"/>'));
    popFrm.append($('<input type="hidden" name="title" value="'+title+'"/>'));
    popFrm.append($('<input type="hidden" name="type" value="coAuthor"/>'));
    if(page)popFrm.append($('<input type="hidden" name="page" value="'+page+'"/>'));

    popFrm.attr('action', 'findArticleListByCoAuthorPopup.do');
    popFrm.attr('target', 'articleList');
    popFrm.attr('method', 'POST');
    popFrm.submit();
    mappingPopup.focus();
}
</script>