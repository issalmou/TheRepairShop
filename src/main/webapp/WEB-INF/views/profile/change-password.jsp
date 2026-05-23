<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/layout/header.jsp" %>

<div class="container-fluid py-4 px-4">
    <div class="row justify-content-center">
        <div class="col-lg-7">
            <div class="app-panel p-4">
                <%
                    Boolean mustChange = (Boolean) request.getAttribute("mustChangePassword");
                    boolean forced = Boolean.TRUE.equals(mustChange);
                %>
                <h1 class="h4 fw-semibold text-dark mb-1">Change Password</h1>
                <p class="text-muted small mb-4">
                    <%= forced ? "You must set a new password before continuing" : "Update your account password" %>
                </p>

                <% if (request.getAttribute("message") != null) { %>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <%= request.getAttribute("message") %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <% } %>

                <% String error = (String) request.getAttribute("error"); %>
                <% if (error != null) { %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <%= error %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <% } %>

                <form method="post" action="${pageContext.request.contextPath}/profile/change-password" class="needs-validation">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">

                    <div class="mb-3">
                        <label for="oldPassword" class="form-label small fw-semibold">Current password <span class="text-danger">*</span></label>
                        <input type="password" class="form-control" id="oldPassword" name="oldPassword" required>
                    </div>

                    <div class="mb-3">
                        <label for="newPassword" class="form-label small fw-semibold">New password <span class="text-danger">*</span></label>
                        <input type="password" class="form-control" id="newPassword" name="newPassword" required minlength="8">
                        <div class="form-text">At least 8 characters</div>
                    </div>

                    <div class="mb-4">
                        <label for="confirmPassword" class="form-label small fw-semibold">Confirm new password <span class="text-danger">*</span></label>
                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required minlength="8">
                    </div>

                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-cyan">Change password</button>
                        <% if (!forced) { %>
                        <a href="${pageContext.request.contextPath}/profile" class="btn btn-outline-secondary">Back to profile</a>
                        <% } %>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

</body>
</html>
