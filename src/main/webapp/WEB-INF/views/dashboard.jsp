<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/layout/header.jsp" %>

<%
    java.util.Map<String, Object> stats = (java.util.Map<String, Object>) request.getAttribute("stats");
    if (stats == null) stats = new java.util.HashMap<>();
    long total = ((Number) stats.getOrDefault("totalRepairs", 0)).longValue();
    long pending = ((Number) stats.getOrDefault("pendingCount", 0)).longValue();
    long inProgress = ((Number) stats.getOrDefault("inProgressCount", 0)).longValue();
    long completed = ((Number) stats.getOrDefault("completedCount", 0)).longValue();
    long returned = ((Number) stats.getOrDefault("returnedCount", 0)).longValue();
    java.math.BigDecimal revenue = (java.math.BigDecimal) stats.getOrDefault("totalRevenue", java.math.BigDecimal.ZERO);

    int pendingPct = total > 0 ? (int) Math.round((pending * 100.0) / total) : 0;
    int inProgressPct = total > 0 ? (int) Math.round((inProgress * 100.0) / total) : 0;
    int completedPct = total > 0 ? (int) Math.round((completed * 100.0) / total) : 0;
    int returnedPct = total > 0 ? (int) Math.round((returned * 100.0) / total) : 0;

    java.time.format.DateTimeFormatter dateFmt =
            java.time.format.DateTimeFormatter.ofPattern("dd MMM yyyy, HH:mm");
%>

<style>
    .stat-card {
        background: #fff;
        border: 1px solid #e5e7eb;
        border-radius: 0.5rem;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
        transition: transform 0.2s ease, box-shadow 0.2s ease;
    }
    .stat-card:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
    }
    .stat-card-orange {
        border-top: 4px solid #ea580c !important;
    }
    .stat-card-warning {
        border-top: 4px solid #d97706 !important;
    }
    .stat-card-info {
        border-top: 4px solid #2563eb !important;
    }
    .stat-card-success {
        border-top: 4px solid #16a34a !important;
    }
    .activity-icon {
        width: 2.5rem;
        height: 2.5rem;
        border-radius: 0.375rem;
        display: flex;
        align-items: center;
        justify-content: center;
        flex-shrink: 0;
    }
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
    .progress-bar-info {
        background-color: #2563eb !important;
    }
    .progress-bar-success {
        background-color: #16a34a !important;
    }
    .progress-bar-secondary {
        background-color: #4b5563 !important;
    }
</style>

<div class="container-fluid py-4 px-4">
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
        <div>
            <h1 class="h3 mb-1 fw-semibold text-dark">Dashboard</h1>
            <c:if test="${not empty shopName}">
                <p class="text-muted small mb-0">${shopName}</p>
            </c:if>
        </div>

    </div>

    <!-- Stat cards -->
    <div class="row g-4 mb-4">
        <div class="col-sm-6 col-xl-3">
            <div class="card stat-card stat-card-orange h-100">
                <div class="card-body">
                    <div class="d-flex align-items-center justify-content-between mb-2">
                        <span class="text-uppercase text-muted fw-semibold" style="font-size: 0.75rem; letter-spacing: 0.05em;">Total Repairs</span>
                        <div class="activity-icon text-warning" style="background-color: #ffedd5 !important; color: #ea580c !important;">
                            <i class="bi bi-wrench-adjustable fs-5"></i>
                        </div>
                    </div>
                    <h2 class="display-6 fw-bold mb-0 text-dark"><%= total %></h2>
                </div>
            </div>
        </div>
        <div class="col-sm-6 col-xl-3">
            <div class="card stat-card stat-card-warning h-100">
                <div class="card-body">
                    <div class="d-flex align-items-center justify-content-between mb-2">
                        <span class="text-uppercase text-muted fw-semibold" style="font-size: 0.75rem; letter-spacing: 0.05em;">Pending</span>
                        <div class="activity-icon text-warning" style="background-color: #fef3c7 !important; color: #d97706 !important;">
                            <i class="bi bi-clock-history fs-5"></i>
                        </div>
                    </div>
                    <div class="d-flex align-items-baseline justify-content-between">
                        <h2 class="display-6 fw-bold mb-0 text-dark"><%= pending %></h2>
                        <span class="badge text-bg-warning rounded-pill px-2.5 py-1" style="font-size: 0.75rem;"><%= pendingPct %>%</span>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-sm-6 col-xl-3">
            <div class="card stat-card stat-card-info h-100">
                <div class="card-body">
                    <div class="d-flex align-items-center justify-content-between mb-2">
                        <span class="text-uppercase text-muted fw-semibold" style="font-size: 0.75rem; letter-spacing: 0.05em;">In Progress</span>
                        <div class="activity-icon text-info" style="background-color: #dbeafe !important; color: #2563eb !important;">
                            <i class="bi bi-hammer fs-5"></i>
                        </div>
                    </div>
                    <div class="d-flex align-items-baseline justify-content-between">
                        <h2 class="display-6 fw-bold mb-0 text-dark"><%= inProgress %></h2>
                        <span class="badge text-bg-info rounded-pill px-2.5 py-1" style="font-size: 0.75rem;"><%= inProgressPct %>%</span>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-sm-6 col-xl-3">
            <div class="card stat-card stat-card-success h-100">
                <div class="card-body">
                    <div class="d-flex align-items-center justify-content-between mb-2">
                        <span class="text-uppercase text-muted fw-semibold" style="font-size: 0.75rem; letter-spacing: 0.05em;">Revenue</span>
                        <div class="activity-icon text-success" style="background-color: #dcfce7 !important; color: #16a34a !important;">
                            <i class="bi bi-currency-exchange fs-5"></i>
                        </div>
                    </div>
                    <div class="d-flex align-items-baseline justify-content-between">
                        <h2 class="display-6 fw-bold mb-0 text-dark" style="font-size: 1.5rem;">
                            MAD <%= revenue.setScale(0, java.math.RoundingMode.HALF_UP) %>
                        </h2>
                        <span class="badge text-bg-success rounded-pill px-2.5 py-1" style="font-size: 0.75rem;"><%= completed + returned %> done</span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Status breakdown + recent activity -->
    <div class="row g-4 mb-4">
        <div class="col-lg-4">
            <div class="bg-white dashboard-panel p-4 h-100">
                <h3 class="h5 fw-semibold text-dark mb-4">Repair Status</h3>

                <div class="mb-4">
                    <div class="d-flex justify-content-between mb-2">
                        <span class="small fw-semibold text-secondary">Pending</span>
                        <span class="small fw-bold text-dark"><%= pendingPct %>%</span>
                    </div>
                    <div class="progress" style="height: 6px;">
                        <div class="progress-bar progress-bar-warning" style="width: <%= pendingPct %>%"></div>
                    </div>
                </div>

                <div class="mb-4">
                    <div class="d-flex justify-content-between mb-2">
                        <span class="small fw-semibold text-secondary">In Progress</span>
                        <span class="small fw-bold text-dark"><%= inProgressPct %>%</span>
                    </div>
                    <div class="progress" style="height: 6px;">
                        <div class="progress-bar progress-bar-info" style="width: <%= inProgressPct %>%"></div>
                    </div>
                </div>

                <div class="mb-4">
                    <div class="d-flex justify-content-between mb-2">
                        <span class="small fw-semibold text-secondary">Completed</span>
                        <span class="small fw-bold text-dark"><%= completedPct %>%</span>
                    </div>
                    <div class="progress" style="height: 6px;">
                        <div class="progress-bar progress-bar-success" style="width: <%= completedPct %>%"></div>
                    </div>
                </div>

                <div class="mb-4">
                    <div class="d-flex justify-content-between mb-2">
                        <span class="small fw-semibold text-secondary">Returned</span>
                        <span class="small fw-bold text-dark"><%= returnedPct %>%</span>
                    </div>
                    <div class="progress" style="height: 6px;">
                        <div class="progress-bar progress-bar-secondary" style="width: <%= returnedPct %>%"></div>
                    </div>
                </div>

                <p class="text-muted small mb-0">
                    <span class="fw-semibold text-dark"><%= completed %></span> completed and
                    <span class="fw-semibold text-dark"><%= returned %></span> returned out of
                    <span class="fw-semibold text-dark"><%= total %></span> repairs.
                </p>

                <a href="${pageContext.request.contextPath}/repairs"
                   class="btn btn-dark btn-sm w-100 mt-4 fw-semibold">
                    View all repairs
                </a>
            </div>
        </div>

        <div class="col-lg-8">
            <div class="bg-white dashboard-panel p-4 h-100">
                <h3 class="h5 fw-semibold text-dark mb-1">Recent activity</h3>
                <p class="text-muted small mb-4">Latest repairs across your shops</p>

                <c:choose>
                    <c:when test="${empty recentRepairs}">
                        <p class="text-muted small mb-0">No repairs yet.</p>
                    </c:when>
                    <c:otherwise>
                        <div class="d-flex flex-column">
                            <c:forEach var="repair" items="${recentRepairs}" varStatus="st">
                                <%
                                    m2si.poo.TheRepairShop.model.Repair r =
                                            (m2si.poo.TheRepairShop.model.Repair) pageContext.getAttribute("repair");
                                    String status = r.getStatus().name();
                                    String iconBg = "bg-warning-subtle";
                                    String iconColor = "text-warning";
                                    String icon = "bi-clock-history";
                                    if ("IN_PROGRESS".equals(status)) {
                                        iconBg = "bg-info-subtle";
                                        iconColor = "text-info";
                                        icon = "bi-hammer";
                                    } else if ("COMPLETED".equals(status)) {
                                        iconBg = "bg-success-subtle";
                                        iconColor = "text-success";
                                        icon = "bi-check-lg";
                                    } else if ("RETURNED".equals(status)) {
                                        iconBg = "bg-secondary-subtle";
                                        iconColor = "text-secondary";
                                        icon = "bi-box-arrow-left";
                                    }
                                    String deviceLabel = r.getDevice() != null
                                            ? r.getDevice().getBrand() + " " + r.getDevice().getModel()
                                            : "Device";
                                    String clientName = "";
                                    if (r.getDevice() != null && r.getDevice().getClient() != null) {
                                        clientName = r.getDevice().getClient().getFirstName() + " "
                                                + r.getDevice().getClient().getLastName();
                                    }
                                    String dateStr = r.getUpdatedAt() != null
                                            ? r.getUpdatedAt().format(dateFmt) : "";
                                %>
                                <a href="${pageContext.request.contextPath}/repairs/<%= r.getId() %>"
                                   class="d-flex align-items-center gap-3 py-3 text-decoration-none text-dark${st.last ? '' : ' border-bottom'}">
                                    <div class="activity-icon <%= iconBg %>">
                                        <i class="bi <%= icon %> <%= iconColor %> fs-5"></i>
                                    </div>
                                    <div class="flex-grow-1 min-w-0">
                                        <p class="fw-semibold small mb-0 text-truncate">
                                            #<%= r.getId() %> — <%= deviceLabel %>
                                            <% if (!clientName.isEmpty()) { %> · <%= clientName %><% } %>
                                        </p>
                                        <p class="text-muted mb-0" style="font-size: 0.75rem;"><%= dateStr %></p>
                                    </div>
                                    <span class="badge rounded-pill text-bg-light border text-uppercase" style="font-size: 0.65rem;">
                                        <%= status.replace('_', ' ') %>
                                    </span>
                                </a>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- Technician workload -->
    <div class="bg-white dashboard-panel p-4">
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-2">
            <div>
                <h3 class="h5 fw-semibold text-dark mb-1">Technician workload</h3>
                <p class="text-muted small mb-0"><%= completed + returned %> repairs finished in total</p>
            </div>
            <a href="${pageContext.request.contextPath}/reports/workload" class="btn btn-sm btn-outline-dark">
                Full report
            </a>
        </div>

        <c:choose>
            <c:when test="${empty workloadByTechnician}">
                <p class="text-muted small mb-0">No assigned technicians yet.</p>
            </c:when>
            <c:otherwise>
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead>
                            <tr class="border-bottom">
                                <th class="text-uppercase text-muted small py-3">Technician</th>
                                <th class="text-uppercase text-muted small py-3">Assigned</th>
                                <th class="text-uppercase text-muted small py-3">Completed</th>
                                <th class="text-uppercase text-muted small py-3" style="min-width: 200px;">Completion</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="row" items="${workloadByTechnician}">
                                <%
                                    java.util.Map<String, Object> workloadRow =
                                            (java.util.Map<String, Object>) pageContext.getAttribute("row");
                                    m2si.poo.TheRepairShop.model.User tech =
                                            (m2si.poo.TheRepairShop.model.User) workloadRow.get("technician");
                                    long assigned = ((Number) workloadRow.get("assignedCount")).longValue();
                                    long done = ((Number) workloadRow.get("completedCount")).longValue();
                                    int rate = assigned > 0 ? (int) Math.round((done * 100.0) / assigned) : 0;
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
                                    <td class="py-3 small fw-semibold"><%= assigned %></td>
                                    <td class="py-3 small fw-semibold"><%= done %></td>
                                    <td class="py-3">
                                        <div class="progress" style="height: 6px; max-width: 280px;">
                                            <div class="progress-bar progress-bar-warning" style="width: <%= rate %>%"></div>
                                        </div>
                                        <p class="text-muted mb-0 mt-1" style="font-size: 0.75rem;"><%= rate %>%</p>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

</body>
</html>
