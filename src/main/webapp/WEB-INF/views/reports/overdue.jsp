<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/layout/header.jsp" %>

<div class="container-fluid py-4 px-4">
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
        <div>
            <h1 class="h3 mb-1 fw-semibold text-dark">Overdue Repairs</h1>
            <p class="text-muted small mb-0">
                Repairs overdue by more than <span class="fw-semibold"><%= request.getAttribute("thresholdDays") %> days</span>
            </p>
        </div>
        <div>
            <a href="${pageContext.request.contextPath}/repairs" class="btn btn-outline-dark btn-sm fw-semibold">
                <i class="bi bi-arrow-left"></i> All Repairs
            </a>
        </div>
    </div>

    <div class="app-panel p-4 mb-4">
        <form method="get" action="${pageContext.request.contextPath}/reports/overdue" class="d-flex flex-wrap align-items-center gap-3">
            <div class="d-flex align-items-center gap-2">
                <label for="threshold" class="form-label mb-0 text-nowrap fw-semibold small text-secondary">Threshold (days):</label>
                <input type="number" name="threshold" id="threshold" class="form-control form-control-sm" style="width: 80px;" value="<%= request.getAttribute("thresholdDays") %>" min="1" required>
            </div>
            <button type="submit" class="btn btn-cyan btn-sm">Apply Filter</button>
        </form>
    </div>

    <%
        java.util.List<m2si.poo.TheRepairShop.model.Repair> overdue = (java.util.List<m2si.poo.TheRepairShop.model.Repair>) request.getAttribute("overdueRepairs");
        if (overdue == null) overdue = new java.util.ArrayList<>();
    %>

    <% if (!overdue.isEmpty()) { %>
        <div class="app-panel overflow-hidden">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0 table-app">
                    <thead>
                        <tr>
                            <th class="py-3">ID</th>
                            <th class="py-3">Device</th>
                            <th class="py-3">Client</th>
                            <th class="py-3">Assigned Technician</th>
                            <th class="py-3">Days Open</th>
                            <th class="py-3">Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (m2si.poo.TheRepairShop.model.Repair r : overdue) {
                            String deviceText = r.getDevice() != null ? (r.getDevice().getBrand() + " " + r.getDevice().getModel()) : "-";
                            String clientText = r.getDevice() != null && r.getDevice().getClient() != null ? (r.getDevice().getClient().getFirstName() + " " + r.getDevice().getClient().getLastName()) : "-";
                            String tech = r.getAssignedTechnician() != null ? r.getAssignedTechnician().getUsername() : "Unassigned";
                            long daysOpen = java.time.Duration.between(r.getCreatedAt(), java.time.LocalDateTime.now()).toDays();
                        %>
                        <tr>
                            <td class="py-3 small fw-semibold">#<%= r.getId() %></td>
                            <td class="py-3 small"><%= deviceText %></td>
                            <td class="py-3 small text-muted"><%= clientText %></td>
                            <td class="py-3 small"><%= tech %></td>
                            <td class="py-3 small">
                                <span class="badge bg-danger bg-opacity-10 text-danger border border-danger border-opacity-25 rounded-pill px-2.5 py-1" style="font-size: 0.75rem;">
                                    <%= daysOpen %> days
                                </span>
                            </td>
                            <td class="py-3">
                                <span class="badge text-bg-warning rounded-pill text-uppercase px-2.5 py-1" style="font-size: 0.65rem;">
                                    <%= r.getStatus().toString().replace('_', ' ') %>
                                </span>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    <% } else { %>
        <div class="alert alert-info border border-info border-opacity-25 mb-0" style="background-color: #eff6ff; color: #1e3a8a;">
            <i class="bi bi-info-circle me-2"></i> No overdue repairs found for the specified threshold.
        </div>
    <% } %>

</div>

</body>
</html>
