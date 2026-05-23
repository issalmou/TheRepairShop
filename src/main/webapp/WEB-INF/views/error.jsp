<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - TheRepairShop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>
    <div class="container d-flex align-items-center justify-content-center" style="min-height: 100vh;">
        <div class="text-center">
            <div class="mb-4">
                <i class="bi bi-exclamation-triangle text-danger" style="font-size: 4rem;"></i>
            </div>
            <h1 class="display-4 mb-3">
                <c:choose>
                    <c:when test="${empty requestScope['javax.servlet.error.status_code']}">
                        Error
                    </c:when>
                    <c:otherwise>
                        ${requestScope['javax.servlet.error.status_code']}
                    </c:otherwise>
                </c:choose>
            </h1>
            <h2 class="h4 mb-4">
                <c:choose>
                    <c:when test="${requestScope['javax.servlet.error.status_code'] == 404}">
                        Page Not Found
                    </c:when>
                    <c:when test="${requestScope['javax.servlet.error.status_code'] == 403}">
                        Access Denied
                    </c:when>
                    <c:when test="${requestScope['javax.servlet.error.status_code'] == 500}">
                        Internal Server Error
                    </c:when>
                    <c:otherwise>
                        An Error Occurred
                    </c:otherwise>
                </c:choose>
            </h2>
            <p class="text-muted mb-4">
                <c:choose>
                    <c:when test="${requestScope['javax.servlet.error.status_code'] == 404}">
                        The page you're looking for could not be found.
                    </c:when>
                    <c:when test="${requestScope['javax.servlet.error.status_code'] == 403}">
                        You don't have permission to access this resource.
                    </c:when>
                    <c:when test="${requestScope['javax.servlet.error.status_code'] == 500}">
                        Something went wrong on our end. Please try again later.
                    </c:when>
                    <c:otherwise>
                        An unexpected error occurred. Please try again or contact support.
                    </c:otherwise>
                </c:choose>
            </p>
            <p class="text-muted small mb-4">
                <c:if test="${not empty requestScope['javax.servlet.error.message']}">
                    Message: ${requestScope['javax.servlet.error.message']}
                </c:if>
            </p>
            <div>
                <a href="${pageContext.request.contextPath}/" class="btn btn-primary me-2">
                    <i class="bi bi-house"></i> Go to Home
                </a>
                <a href="javascript:history.back()" class="btn btn-secondary">
                    <i class="bi bi-arrow-left"></i> Go Back
                </a>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
