<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="ptags" uri="http://web.ru/taglibs" %>

<jsp:useBean id="user" class="com.github.admissionCommittee.model.User" scope="request"/>
<jsp:useBean id="certificate" class="com.github.admissionCommittee.model.SchoolCertificate" scope="request"/>
<jsp:useBean id="sheet" class="com.github.admissionCommittee.model.Sheet" scope="request"/>
<jsp:useBean id="listFaculty" type="java.util.List" scope="request"/>

<fmt:setLocale value="${not empty sessionScope['lang'] ? sessionScope['lang'] : 'Ru'}"/>
<fmt:setBundle basename="localization"/>

<jsp:include page="template/header.jsp"/>

<div id="infopanel">
    <div id="left-infopanel">
        <div id="avatarcontainter">
            <div id="bavatar" style="background-image:url('${pageContext.request.contextPath}/img/obuchenie.jpg')"></div>
        </div>
    </div>

    <div class="div-space"><!-- blank --></div>

    <div id="right-infopanel">
        <div>
            <dl>
                <dt> &nbsp</dt><dd><h2>${user.lastName}</h2></dd>
                <br>
                <dt><fmt:message key="profile.firstname"/>:</dt> <dd>${user.firstName}</dd>
                <br>
                <dt><fmt:message key="profile.middlename"/>:</dt> <dd>${user.patronymic}</dd>
                <br>
                <dt><fmt:message key="profile.birthDate"/>:</dt> <dd><ptags:FormatLocalDate date="${user.birthDate}"/></dd>
                <br>
                <dt> &nbsp</dt><dd>${user.mail}</dd>
            </dl>
        </div>

        <div class="div-none-small"><!-- blank --></div>

        <div><a href="profile"><fmt:message key="profile.edit"/></a> </div>
    </div>
</div>

<div id="certificate-info">

    <fmt:message key="profile.certificateinfo"/><br>
    <p>
    <table width="100%">
        <tr>
            <!--<td></td>-->
            <td><fmt:message key="certificate.year"/></td>
            <td><fmt:message key="certificate.averagescore"/></td>
        </tr>

        <tr>
            <!--<td></td>-->
            <td>${certificate.year}</td>
            <td>${certificate.averageScore}</td>
            <!--<td></td>-->
        </tr>
    </table>

    <form action="${pageContext.request.contextPath}/certificate" method="post">
        <button class="submit" type="submit" ><fmt:message key="key_certificate"/></button>
    </form>

</div>

<c:if test="${not empty certificate.subjects}">
<div id="faculty-info">
    <form class="login_form" action="${pageContext.request.contextPath}/examinations" method="post">
        <label for="faculty">Для подачи документов выберите факультет:</label>
        <select id="faculty" name="faculty">
                <ptags:SelectFromList list="${listFaculty}"/>
        </select>
        </p>
        <p>
            <button class="submit" type="submit"><fmt:message key="button_apply"/></button>
        </p>
    </form>
</div>
</c:if>

<jsp:include page="template/footer.jsp"/>