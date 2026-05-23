<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/layout/header.jsp" %>

<style>
    .tech-avatar {
        width: 1.5rem;
        height: 1.5rem;
        border-radius: 0.25rem;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        color: #fff;
        font-size: 0.7rem;
        font-weight: 700;
    }
    .progress {
        background-color: #f3f4f6;
        border-radius: 1rem;
        overflow: hidden;
    }
    .progress-bar-warning {
        background-color: #d97706 !important;
    }
</style>

<div class="container-fluid py-4 px-4">
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
        <div>
            <h1 class="h3 mb-1 fw-semibold text-dark">Technician Workload</h1>
            <p class="text-muted small mb-0">Overview of active assignments and completion rates per repairer</p>
        </div>
        <div>
            <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-outline-dark btn-sm fw-semibold">
                <i class="bi bi-arrow-left"></i> Dashboard
            </a>
        </div>
    </div>

    <%
        java.util.List<java.util.Map<String, Object>> workload = (java.util.List<java.util.Map<String, Object>>) request.getAttribute("workloadByTechnician");
        if (workload == null) workload = new java.util.ArrayList<>();
    %>

    <% if (!workload.isEmpty()) { %>
        <div class="app-panel overflow-hidden">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0 table-app">
                    <thead>
                        <tr>
                            <th class="py-3">Technician</th>
                            <th class="py-3 text-center">Assigned Repairs</th>
                            <th class="py-3 text-center">Completed Repairs</th>
                            <th class="py-3" style="min-width: 250px;">Completion Rate</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (java.util.Map<String, Object> row : workload) {
                            m2si.poo.TheRepairShop.model.User tech = (m2si.poo.TheRepairShop.model.User) row.get("technician");
                            long assigned = ((Number) row.get("assignedCount")).longValue();
                            long completed = ((Number) row.get("completedCount")).longValue();
                            int rate = assigned > 0 ? (int) Math.round((completed * 100.0) / assigned) : 0;
                            String username = tech != null ? tech.getUsername() : "?";
                            String initial = username.isEmpty() ? "?" : username.substring(0, 1).toUpperCase();
                            String[] avatarColors = {"#8B5CF6", "#3B82F6", "#EC4899", "#10B981", "#60A5FA", "#EF4444"};
                            String avatarColor = avatarColors[(int) (username.hashCode() & 0x7FFFFFFF) % avatarColors.length];
                        %>
                        <tr>
                            <td class="py-3">
                                <div class="d-flex align-items-center gap-2">
                                    <span class="tech-avatar" style="background: <%= avatarColor %>;"><%= initial %></span>
                                    <span class="small fw-semibold"><%= username %></span>
                                </div>
                            </td>
                            <td class="py-3 text-center small fw-semibold">
                                <% if (assigned > 5) { %>
                                    <span class="badge text-bg-warning rounded-pill px-2.5 py-1" style="font-size: 0.75rem;"><%= assigned %> (High load)</span>
                                <% } else { %>
                                    <%= assigned %>
                                <% } %>
                            </td>
                            <td class="py-3 text-center small fw-semibold"><%= completed %></td>
                            <td class="py-3">
                                <div class="progress" style="height: 6px; max-width: 280px;">
                                    <div class="progress-bar progress-bar-warning" style="width: <%= rate %>%"></div>
                                </div>
                                <p class="text-muted mb-0 mt-1" style="font-size: 0.75rem;"><%= rate %>%</p>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    <% } else { %>
        <div class="alert alert-info border border-info border-opacity-25 mb-0" style="background-color: #eff6ff; color: #1e3a8a;">
            <i class="bi bi-info-circle me-2"></i> No workload data available.
        </div>
    <% } %>

</div>

</body>
</html>
