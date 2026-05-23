<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/layout/header.jsp" %>

<div class="container-fluid py-4 px-4">
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
        <div>
            <h1 class="h3 mb-1 fw-semibold text-dark">Shops</h1>
            <p class="text-muted small mb-0">Manage your repair shop locations</p>
        </div>
        <a href="${pageContext.request.contextPath}/shops/new" class="btn btn-cyan btn-sm">
            <i class="bi bi-plus-circle"></i> New Shop
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

    <div class="app-panel overflow-hidden">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0 table-app">
                <%
                    Boolean adminView = (Boolean) request.getAttribute("adminView");
                    boolean showOwnerColumn = Boolean.TRUE.equals(adminView);
                %>
                <thead>
                <tr>
                    <th>Name</th>
                    <% if (showOwnerColumn) { %><th>Owner</th><% } %>
                    <th>Address</th>
                    <th class="text-center">Active</th>
                    <th class="text-center">Repairers</th>
                    <th class="text-center">Actions</th>
                </tr>
                </thead>
                <tbody>
                <%
                    java.util.List<m2si.poo.TheRepairShop.model.Shop> shops =
                            (java.util.List<m2si.poo.TheRepairShop.model.Shop>) request.getAttribute("shops");
                    if (shops != null && !shops.isEmpty()) {
                        for (m2si.poo.TheRepairShop.model.Shop shop : shops) {
                            int repairerCount = shop.getUsers() != null ? shop.getUsers().size() : 0;
                %>
                <tr>
                    <td class="small fw-semibold"><%= shop.getName() %></td>
                    <% if (showOwnerColumn) {
                        String ownerLabel = "-";
                        if (shop.getOwner() != null) {
                            ownerLabel = shop.getOwner().getUsername();
                        }
                    %>
                    <td class="small text-muted"><%= ownerLabel %></td>
                    <% } %>
                    <td class="small text-muted"><%= shop.getAddress() != null ? shop.getAddress() : "-" %></td>
                    <td class="text-center">
                        <% if (shop.isActive()) { %>
                            <span class="badge rounded-pill text-bg-success">Active</span>
                        <% } else { %>
                            <span class="badge rounded-pill text-bg-secondary">Inactive</span>
                        <% } %>
                    </td>
                    <td class="text-center">
                        <span class="badge rounded-pill text-bg-light border"><%= repairerCount %></span>
                    </td>
                    <td class="text-center">
                        <div class="dropdown">
                            <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                Actions
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end shadow-sm">
                                <li>
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/shops/<%= shop.getId() %>/edit">
                                        <i class="bi bi-pencil-square me-2 text-primary"></i>Edit
                                    </a>
                                </li>
                                <li><hr class="dropdown-divider"></li>
                                <li>
                                    <form method="post"
                                          action="${pageContext.request.contextPath}/shops/<%= shop.getId() %>/delete"
                                          class="d-inline" onsubmit="return confirm('Are you sure?');">
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
                    <td colspan="<%= showOwnerColumn ? 6 : 5 %>" class="text-center text-muted py-5">No shops found</td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

</body>
</html>
