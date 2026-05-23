<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/layout/header.jsp" %>

<div class="container-fluid py-4 px-4">
    <div class="mb-4">
        <a href="${pageContext.request.contextPath}/shops" class="btn btn-sm btn-outline-secondary">
            <i class="bi bi-arrow-left"></i> Back to shops
        </a>
    </div>

    <div class="row justify-content-center">
        <div class="col-lg-7">
            <div class="app-panel p-4">
                <%
                    m2si.poo.TheRepairShop.model.Shop shop =
                            (m2si.poo.TheRepairShop.model.Shop) request.getAttribute("shop");
                    boolean isEdit = shop != null && shop.getId() != null;
                %>

                <%
                    Boolean adminCreate = (Boolean) request.getAttribute("adminCreate");
                    boolean showOwnerSelect = Boolean.TRUE.equals(adminCreate) && !isEdit;
                    java.util.List<m2si.poo.TheRepairShop.model.User> owners =
                            (java.util.List<m2si.poo.TheRepairShop.model.User>) request.getAttribute("owners");
                %>
                <h1 class="h4 fw-semibold text-dark mb-4"><%= isEdit ? "Edit Shop" : "New Shop" %></h1>

                <form method="post" action="${pageContext.request.contextPath}<%= isEdit ? "/shops/" + shop.getId() : "/shops" %>" class="needs-validation">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                    <% if (showOwnerSelect && owners != null && !owners.isEmpty()) { %>
                    <div class="mb-3">
                        <label for="ownerId" class="form-label small fw-semibold">Owner <span class="text-danger">*</span></label>
                        <select name="ownerId" id="ownerId" class="form-select" required>
                            <option value="">Select owner</option>
                            <% for (m2si.poo.TheRepairShop.model.User owner : owners) { %>
                            <option value="<%= owner.getId() %>">
                                <%= owner.getUsername() %> — <%= owner.getEmail() %>
                            </option>
                            <% } %>
                        </select>
                    </div>
                    <% } else if (showOwnerSelect) { %>
                    <div class="alert alert-warning">No owners available. Create an owner account first.</div>
                    <% } %>
                    <div class="mb-3">
                        <label for="name" class="form-label small fw-semibold">Name <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="name" name="name"
                               value="<%= shop != null && shop.getName() != null ? shop.getName() : "" %>" required>
                    </div>

                    <div class="mb-3">
                        <label for="address" class="form-label small fw-semibold">Address</label>
                        <textarea class="form-control" id="address" name="address" rows="3"><%= shop != null && shop.getAddress() != null ? shop.getAddress() : "" %></textarea>
                    </div>

                    <div class="mb-4">
                        <label for="phone" class="form-label small fw-semibold">Phone</label>
                        <input type="tel" class="form-control" id="phone" name="phone"
                               value="<%= shop != null && shop.getPhone() != null ? shop.getPhone() : "" %>">
                    </div>

                    <div class="d-flex flex-wrap gap-2 justify-content-end">
                        <a href="${pageContext.request.contextPath}/shops" class="btn btn-outline-secondary">Cancel</a>
                        <button type="submit" class="btn btn-cyan">
                            <%= isEdit ? "Save Shop" : "Create Shop" %>
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

</body>
</html>
