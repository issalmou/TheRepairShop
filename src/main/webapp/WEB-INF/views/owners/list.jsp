<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/layout/header.jsp" %>

<div class="container-fluid py-4 px-4">
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
        <div>
            <h1 class="h3 mb-1 fw-semibold text-dark">Owners Management</h1>
            <p class="text-muted small mb-0">Create and manage shop owner accounts</p>
        </div>
        <a href="${pageContext.request.contextPath}/users/owners/new" class="btn btn-cyan btn-sm">
            <i class="bi bi-plus-circle"></i> New Owner
        </a>
    </div>

    <% if (request.getAttribute("message") != null) { %>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <%= request.getAttribute("message") %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } %>

    <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <%= request.getAttribute("error") %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } %>

    <% if (request.getAttribute("generatedPassword") != null) { %>
        <div class="alert alert-info alert-dismissible fade show" role="alert">
            <strong>Account Credentials:</strong>
            Username: <%= request.getAttribute("generatedUsername") %>
            &nbsp;|&nbsp; Password: <%= request.getAttribute("generatedPassword") %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } %>

    <div class="app-panel overflow-hidden">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0 table-app">
                <thead>
                <tr>
                    <th>Username</th>
                    <th>Email</th>
                    <th>Name</th>
                    <th class="text-center">Active</th>
                    <th class="text-center">Must Change Password</th>
                    <th class="text-center">Actions</th>
                </tr>
                </thead>
                <tbody>
                <%
                    java.util.List<m2si.poo.TheRepairShop.model.User> owners =
                            (java.util.List<m2si.poo.TheRepairShop.model.User>) request.getAttribute("owners");
                    if (owners != null && !owners.isEmpty()) {
                        for (m2si.poo.TheRepairShop.model.User owner : owners) {
                            boolean active = Boolean.TRUE.equals(owner.getActive());
                            String fullName = "";
                            if (owner.getFirstName() != null) {
                                fullName += owner.getFirstName();
                            }
                            if (owner.getLastName() != null) {
                                fullName += (fullName.isEmpty() ? "" : " ") + owner.getLastName();
                            }
                            if (fullName.isEmpty()) {
                                fullName = "-";
                            }
                %>
                <tr>
                    <td class="small fw-semibold"><%= owner.getUsername() %></td>
                    <td class="small text-muted"><%= owner.getEmail() %></td>
                    <td class="small"><%= fullName %></td>
                    <td class="text-center">
                        <% if (active) { %>
                            <span class="badge rounded-pill text-bg-success">Active</span>
                        <% } else { %>
                            <span class="badge rounded-pill text-bg-secondary">Inactive</span>
                        <% } %>
                    </td>
                    <td class="text-center">
                        <% if (owner.isMustChangePassword()) { %>
                            <span class="badge rounded-pill text-bg-warning">Must change</span>
                        <% } else { %>
                            <span class="text-muted small">No</span>
                        <% } %>
                    </td>
                    <td class="text-center">
                        <div class="dropdown">
                            <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                Actions
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end shadow-sm">
                                <li>
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/users/owners/<%= owner.getId() %>/edit">
                                        <i class="bi bi-pencil-square me-2 text-primary"></i>Edit
                                    </a>
                                </li>
                                <li>
                                    <form method="post"
                                          action="${pageContext.request.contextPath}/users/owners/<%= owner.getId() %>/reset-password"
                                          class="d-inline"
                                          onsubmit="return confirm('Generate a new password for <%= owner.getUsername() %>?');">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                                        <button type="submit" class="dropdown-item">
                                            <i class="bi bi-key-fill me-2 text-warning"></i>Reset Password
                                        </button>
                                    </form>
                                </li>
                                <li><hr class="dropdown-divider"></li>
                                <li>
                                    <form method="post"
                                          action="${pageContext.request.contextPath}/users/owners/<%= owner.getId() %>/delete"
                                          class="d-inline"
                                          onsubmit="return confirm('Delete this owner permanently? They must have no shops.');">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                                        <button type="submit" class="dropdown-item text-danger">
                                            <i class="bi bi-trash3 me-2"></i>Delete
                                        </button>
                                    </form>
                                </li>
                            </ul>
                        </div>
                    </td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="6" class="text-center text-muted py-5">No owners found</td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

</body>
</html>
