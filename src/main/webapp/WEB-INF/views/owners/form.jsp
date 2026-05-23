<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ include file="/WEB-INF/views/layout/header.jsp" %>

<div class="container-fluid py-4 px-4">
    <div class="mb-4">
        <a href="${pageContext.request.contextPath}/users/owners" class="btn btn-sm btn-outline-secondary">
            <i class="bi bi-arrow-left"></i> Back to owners management
        </a>
    </div>

    <div class="row justify-content-center">
        <div class="col-lg-7">
            <div class="app-panel p-4">
                <%
                    Boolean editMode = (Boolean) request.getAttribute("editMode");
                    boolean isEdit = Boolean.TRUE.equals(editMode);
                    m2si.poo.TheRepairShop.model.User owner =
                            (m2si.poo.TheRepairShop.model.User) request.getAttribute("owner");
                %>
                <h1 class="h4 fw-semibold text-dark mb-1"><%= isEdit ? "Edit Owner" : "Create Owner" %></h1>
                <p class="text-muted small mb-4">
                    <%= isEdit
                            ? "Update profile, status, or set a new password (leave blank to keep current)"
                            : "Leave password empty to auto-generate one" %>
                </p>

                <spring:hasBindErrors name="ownerForm">
                    <c:if test="${errors.globalErrorCount > 0}">
                        <div class="alert alert-danger">
                            <c:forEach var="error" items="${errors.globalErrors}">
                                <div><c:out value="${error.defaultMessage}"/></div>
                            </c:forEach>
                        </div>
                    </c:if>
                </spring:hasBindErrors>

                <form method="post"
                      action="${pageContext.request.contextPath}/users/owners<%= isEdit ? "/" + owner.getId() + "/edit" : "" %>"
                      class="needs-validation">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">

                    <% if (!isEdit) { %>
                    <div class="mb-3">
                        <label for="username" class="form-label small fw-semibold">Username <span class="text-danger">*</span></label>
                        <spring:bind path="ownerForm.username">
                            <input type="text" class="form-control ${status.error ? 'is-invalid' : ''}"
                                   id="username" name="${status.expression}" value="${status.value}" required>
                            <c:if test="${status.error}">
                                <div class="invalid-feedback"><c:out value="${status.errorMessage}"/></div>
                            </c:if>
                        </spring:bind>
                    </div>
                    <% } else { %>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Username</label>
                        <input type="text" class="form-control" value="<%= owner.getUsername() %>" readonly disabled>
                    </div>
                    <% } %>

                    <div class="mb-3">
                        <label for="email" class="form-label small fw-semibold">Email <span class="text-danger">*</span></label>
                        <spring:bind path="ownerForm.email">
                            <input type="email" class="form-control ${status.error ? 'is-invalid' : ''}"
                                   id="email" name="${status.expression}" value="${status.value}" required>
                            <c:if test="${status.error}">
                                <div class="invalid-feedback"><c:out value="${status.errorMessage}"/></div>
                            </c:if>
                        </spring:bind>
                    </div>

                    <div class="mb-3">
                        <label for="firstName" class="form-label small fw-semibold">First name</label>
                        <spring:bind path="ownerForm.firstName">
                            <input type="text" class="form-control ${status.error ? 'is-invalid' : ''}"
                                   id="firstName" name="${status.expression}" value="${status.value}">
                            <c:if test="${status.error}">
                                <div class="invalid-feedback"><c:out value="${status.errorMessage}"/></div>
                            </c:if>
                        </spring:bind>
                    </div>

                    <div class="mb-3">
                        <label for="lastName" class="form-label small fw-semibold">Last name</label>
                        <spring:bind path="ownerForm.lastName">
                            <input type="text" class="form-control ${status.error ? 'is-invalid' : ''}"
                                   id="lastName" name="${status.expression}" value="${status.value}">
                            <c:if test="${status.error}">
                                <div class="invalid-feedback"><c:out value="${status.errorMessage}"/></div>
                            </c:if>
                        </spring:bind>
                    </div>

                    <div class="mb-3">
                        <label for="phone" class="form-label small fw-semibold">Phone</label>
                        <spring:bind path="ownerForm.phone">
                            <input type="text" class="form-control ${status.error ? 'is-invalid' : ''}"
                                   id="phone" name="${status.expression}" value="${status.value}">
                            <c:if test="${status.error}">
                                <div class="invalid-feedback"><c:out value="${status.errorMessage}"/></div>
                            </c:if>
                        </spring:bind>
                    </div>

                    <% if (!isEdit) { %>
                    <div class="mb-3">
                        <label for="password" class="form-label small fw-semibold">Password</label>
                        <spring:bind path="ownerForm.password">
                            <input type="password" class="form-control ${status.error ? 'is-invalid' : ''}"
                                   id="password" name="${status.expression}"
                                   minlength="8" autocomplete="new-password"
                                   placeholder="Leave blank to auto-generate">
                            <c:if test="${status.error}">
                                <div class="invalid-feedback"><c:out value="${status.errorMessage}"/></div>
                            </c:if>
                        </spring:bind>
                        <div class="form-text">Minimum 8 characters if you set it manually.</div>
                    </div>
                    <% } %>

                    <% if (isEdit) { %>
                    <div class="mb-3">
                        <label for="newPassword" class="form-label small fw-semibold">New password</label>
                        <spring:bind path="ownerForm.newPassword">
                            <input type="password" class="form-control ${status.error ? 'is-invalid' : ''}"
                                   id="newPassword" name="${status.expression}"
                                   minlength="8" autocomplete="new-password"
                                   placeholder="Leave blank to keep current password">
                            <c:if test="${status.error}">
                                <div class="invalid-feedback"><c:out value="${status.errorMessage}"/></div>
                            </c:if>
                        </spring:bind>
                        <div class="form-text">Minimum 8 characters.</div>
                    </div>
                    <% } %>

                    <% if (isEdit) { %>
                    <div class="mb-4 form-check">
                        <spring:bind path="ownerForm.active">
                            <input type="checkbox" class="form-check-input" id="active" name="${status.expression}" value="true"
                                   ${status.value eq true || status.value eq 'true' ? 'checked' : ''}>
                            <label class="form-check-label small" for="active">Active account</label>
                        </spring:bind>
                    </div>
                    <% } %>

                    <div class="d-grid">
                        <button type="submit" class="btn btn-cyan">
                            <%= isEdit ? "Save changes" : "Create owner" %>
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

</body>
</html>
