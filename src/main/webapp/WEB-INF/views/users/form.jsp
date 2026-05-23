<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ include file="/WEB-INF/views/layout/header.jsp" %>

<div class="container-fluid py-4 px-4">
    <div class="mb-4">
        <a href="${pageContext.request.contextPath}/users/manage" class="btn btn-sm btn-outline-secondary">
            <i class="bi bi-arrow-left"></i> Back to repairers management
        </a>
    </div>

    <div class="row justify-content-center">
        <div class="col-lg-7">
            <div class="app-panel p-4">
                <%
                    Boolean editMode = (Boolean) request.getAttribute("editMode");
                    boolean isEdit = Boolean.TRUE.equals(editMode);
                    m2si.poo.TheRepairShop.model.User user =
                            (m2si.poo.TheRepairShop.model.User) request.getAttribute("user");
                    Long selectedShopId = (Long) request.getAttribute("selectedShopId");
                %>
                <h1 class="h4 fw-semibold text-dark mb-1"><%= isEdit ? "Edit Repairer" : "Create Repairer" %></h1>
                <p class="text-muted small mb-4">
                    <%= isEdit ? "Update profile and shop assignment" : "A temporary password will be generated on creation" %>
                </p>

                <spring:hasBindErrors name="userForm">
                    <c:if test="${errors.globalErrorCount > 0}">
                        <div class="alert alert-danger">
                            <c:forEach var="error" items="${errors.globalErrors}">
                                <div><c:out value="${error.defaultMessage}"/></div>
                            </c:forEach>
                        </div>
                    </c:if>
                </spring:hasBindErrors>

                <form method="post"
                      action="${pageContext.request.contextPath}/users/manage<%= isEdit ? "/" + user.getId() + "/edit" : "" %>"
                      class="needs-validation">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">

                    <% if (!isEdit) { %>
                    <div class="mb-3">
                        <label for="username" class="form-label small fw-semibold">Username <span class="text-danger">*</span></label>
                        <spring:bind path="userForm.username">
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
                        <input type="text" class="form-control" value="<%= user.getUsername() %>" readonly disabled>
                    </div>
                    <% } %>

                    <div class="mb-3">
                        <label for="email" class="form-label small fw-semibold">Email <span class="text-danger">*</span></label>
                        <spring:bind path="userForm.email">
                            <input type="email" class="form-control ${status.error ? 'is-invalid' : ''}"
                                   id="email" name="${status.expression}" value="${status.value}" required>
                            <c:if test="${status.error}">
                                <div class="invalid-feedback"><c:out value="${status.errorMessage}"/></div>
                            </c:if>
                        </spring:bind>
                    </div>

                    <div class="mb-3">
                        <label for="firstName" class="form-label small fw-semibold">First name</label>
                        <spring:bind path="userForm.firstName">
                            <input type="text" class="form-control ${status.error ? 'is-invalid' : ''}"
                                   id="firstName" name="${status.expression}" value="${status.value}">
                            <c:if test="${status.error}">
                                <div class="invalid-feedback"><c:out value="${status.errorMessage}"/></div>
                            </c:if>
                        </spring:bind>
                    </div>

                    <div class="mb-3">
                        <label for="lastName" class="form-label small fw-semibold">Last name</label>
                        <spring:bind path="userForm.lastName">
                            <input type="text" class="form-control ${status.error ? 'is-invalid' : ''}"
                                   id="lastName" name="${status.expression}" value="${status.value}">
                            <c:if test="${status.error}">
                                <div class="invalid-feedback"><c:out value="${status.errorMessage}"/></div>
                            </c:if>
                        </spring:bind>
                    </div>

                    <div class="mb-3">
                        <label for="phone" class="form-label small fw-semibold">Phone</label>
                        <spring:bind path="userForm.phone">
                            <input type="text" class="form-control ${status.error ? 'is-invalid' : ''}"
                                   id="phone" name="${status.expression}" value="${status.value}">
                            <c:if test="${status.error}">
                                <div class="invalid-feedback"><c:out value="${status.errorMessage}"/></div>
                            </c:if>
                        </spring:bind>
                    </div>

                    <c:choose>
                    <c:when test="${not empty shops}">
                    <div class="mb-3">
                        <label for="shopId" class="form-label small fw-semibold">Shop <span class="text-danger">*</span></label>
                        <spring:bind path="userForm.shopId">
                            <select name="${status.expression}" id="shopId"
                                    class="form-select ${status.error ? 'is-invalid' : ''}" required>
                                <option value="">Select shop</option>
                                <c:forEach var="shop" items="${shops}">
                                    <option value="${shop.id}"
                                            ${status.value eq shop.id || (empty status.value && !editMode && shops.size() == 1) ? 'selected' : ''}>
                                        <c:out value="${shop.name}"/>
                                    </option>
                                </c:forEach>
                            </select>
                            <c:if test="${status.error}">
                                <div class="invalid-feedback"><c:out value="${status.errorMessage}"/></div>
                            </c:if>
                        </spring:bind>
                    </div>
                    </c:when>
                    <c:otherwise>
                    <div class="alert alert-warning">No shops available. Please create a shop first.</div>
                    </c:otherwise>
                    </c:choose>

                    <% if (isEdit) { %>
                    <div class="mb-4 form-check">
                        <spring:bind path="userForm.active">
                            <input type="checkbox" class="form-check-input" id="active" name="${status.expression}" value="true"
                                   ${status.value eq true || status.value eq 'true' ? 'checked' : ''}>
                            <label class="form-check-label small" for="active">Active account</label>
                        </spring:bind>
                    </div>
                    <% } %>

                    <div class="d-grid">
                        <button type="submit" class="btn btn-cyan" ${empty shops ? 'disabled' : ''}>
                            <%= isEdit ? "Save changes" : "Create repairer" %>
                        </button>
                    </div>
                </form>

                <% String generatedPassword = (String) request.getAttribute("generatedPassword"); %>
                <% if (generatedPassword != null) { %>
                <div class="alert alert-info mt-4 mb-0">
                    Generated password (shown once): <strong><%= generatedPassword %></strong>
                </div>
                <% } %>
            </div>
        </div>
    </div>
</div>

</body>
</html>
