<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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

                <form method="post"
                      action="${pageContext.request.contextPath}/users/owners<%= isEdit ? "/" + owner.getId() + "/edit" : "" %>"
                      class="needs-validation">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">

                    <% if (!isEdit) { %>
                    <div class="mb-3">
                        <label for="username" class="form-label small fw-semibold">Username <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="username" name="username" required>
                    </div>
                    <% } else { %>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Username</label>
                        <input type="text" class="form-control" value="<%= owner.getUsername() %>" readonly disabled>
                    </div>
                    <% } %>

                    <div class="mb-3">
                        <label for="email" class="form-label small fw-semibold">Email <span class="text-danger">*</span></label>
                        <input type="email" class="form-control" id="email" name="email" required
                               value="<%= isEdit && owner.getEmail() != null ? owner.getEmail() : "" %>">
                    </div>

                    <% if (isEdit) { %>
                    <div class="mb-3">
                        <label for="firstName" class="form-label small fw-semibold">First name</label>
                        <input type="text" class="form-control" id="firstName" name="firstName"
                               value="<%= isEdit && owner.getFirstName() != null ? owner.getFirstName() : "" %>">
                    </div>

                    <div class="mb-3">
                        <label for="lastName" class="form-label small fw-semibold">Last name</label>
                        <input type="text" class="form-control" id="lastName" name="lastName"
                               value="<%= isEdit && owner.getLastName() != null ? owner.getLastName() : "" %>">
                    </div>

                    <div class="mb-3">
                        <label for="phone" class="form-label small fw-semibold">Phone</label>
                        <input type="text" class="form-control" id="phone" name="phone"
                               value="<%= isEdit && owner.getPhone() != null ? owner.getPhone() : "" %>">
                    </div>

                    <div class="mb-3">
                        <label for="newPassword" class="form-label small fw-semibold">New password</label>
                        <input type="password" class="form-control" id="newPassword" name="newPassword"
                               minlength="8" autocomplete="new-password"
                               placeholder="Leave blank to keep current password">
                        <div class="form-text">Minimum 8 characters.</div>
                    </div>
                    <% } %>

                    <% if (isEdit) { %>
                    <div class="mb-4 form-check">
                        <input type="checkbox" class="form-check-input" id="active" name="active" value="true"
                               <%= Boolean.TRUE.equals(owner.getActive()) ? "checked" : "" %>>
                        <label class="form-check-label small" for="active">Active account</label>
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
