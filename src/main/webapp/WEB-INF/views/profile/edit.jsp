<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="m2si.poo.TheRepairShop.model.*" %>
<%@ include file="/WEB-INF/views/layout/header.jsp" %>

<%
    User user = (User) request.getAttribute("user");
    
    boolean isProfileIncomplete = false;
    if (user != null) {
        if (user.getFirstName() == null || user.getFirstName().isBlank() ||
            user.getLastName() == null || user.getLastName().isBlank() ||
            user.getPhone() == null || user.getPhone().isBlank()) {
            isProfileIncomplete = true;
        } else if (user instanceof Owner) {
            Owner owner = (Owner) user;
            if (owner.getCompanyName() == null || owner.getCompanyName().isBlank() ||
                owner.getTaxId() == null || owner.getTaxId().isBlank()) {
                isProfileIncomplete = true;
            }
        } else if (user instanceof Repairer) {
            Repairer repairer = (Repairer) user;
            if (repairer.getSpecialization() == null || repairer.getSpecialization().isBlank() ||
                repairer.getHourlyRate() == null || repairer.getHourlyRate().isBlank() ||
                repairer.getExperienceYears() == null) {
                isProfileIncomplete = true;
            }
        }
    }
    
    // Format member since date
    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("MMMM dd, yyyy");
    String memberSince = user.getCreatedAt() != null ? user.getCreatedAt().format(dtf) : "N/A";

    // Set dynamic style values based on user subclass role
    String avatarBg = "linear-gradient(135deg, #ff9500 0%, #ff7e00 100%)";
    String shadowColor = "rgba(255, 149, 0, 0.25)";
    String roleBadgeClass = "bg-warning border-warning text-warning";
    String roleName = "Shop Owner";
    String roleIcon = "bi-shop";
    
    if (user instanceof Admin) {
        avatarBg = "linear-gradient(135deg, #f43f5e 0%, #be123c 100%)";
        shadowColor = "rgba(244, 63, 94, 0.25)";
        roleBadgeClass = "bg-danger border-danger text-danger";
        roleName = "Administrator";
        roleIcon = "bi-shield-lock";
    } else if (user instanceof Repairer) {
        avatarBg = "linear-gradient(135deg, #06b6d4 0%, #0891b2 100%)";
        shadowColor = "rgba(6, 182, 212, 0.25)";
        roleBadgeClass = "bg-info border-info text-info";
        roleName = "Repair Technician";
        roleIcon = "bi-wrench";
    }
    
    String fullName = "";
    if (user.getFirstName() != null && !user.getFirstName().isBlank()) {
        fullName += user.getFirstName();
    }
    if (user.getLastName() != null && !user.getLastName().isBlank()) {
        fullName += (fullName.isEmpty() ? "" : " ") + user.getLastName();
    }
    if (fullName.isEmpty()) {
        fullName = user.getUsername();
    }
%>

<div class="container-fluid py-4 px-4">
    <div class="row justify-content-center">
        <div class="col-lg-8 col-xl-7">
            <!-- Profile Premium Header Banner -->
            <div class="d-flex flex-column flex-sm-row align-items-center gap-4 p-4 mb-4 bg-white border rounded-3 shadow-sm transition-all">
                <div class="rounded-circle d-flex align-items-center justify-content-center text-white flex-shrink-0" 
                    style="width: 5rem; height: 5rem; background: <%= avatarBg %>; font-weight: bold; font-size: 2rem; box-shadow: 0 4px 15px <%= shadowColor %>;">
                    <i class="bi <%= user instanceof Repairer ? "bi-wrench-adjustable" : (user instanceof Admin ? "bi-shield-check" : "bi-person-workspace") %>"></i>
                </div>
                <div class="text-center text-sm-start flex-grow-1">
                    <div class="d-flex flex-column flex-sm-row align-items-center gap-2 mb-1">
                        <h2 class="h4 fw-bold text-dark mb-0"><%= fullName %></h2>
                        <span class="badge bg-opacity-10 <%= roleBadgeClass %> border border-opacity-25 py-1 px-2.5 rounded-pill small" style="font-size: 0.75rem; font-weight: 600;">
                            <i class="bi <%= roleIcon %> me-1"></i><%= roleName %>
                        </span>
                    </div>
                    <p class="text-muted mb-2 small"><i class="bi bi-envelope me-1"></i><%= user.getEmail() %> &middot; <span class="fw-semibold">@<%= user.getUsername() %></span></p>
                    <p class="text-muted small mb-0"><i class="bi bi-calendar-event me-1"></i>Member since <%= memberSince %></p>
                </div>
            </div>

            <!-- Profile Info Form Panel -->
            <div class="app-panel p-4 shadow-sm">
                <div class="d-flex align-items-center gap-2 mb-3">
                    <div class="section-icon bg-cyan bg-opacity-10 text-cyan rounded-3 p-1.5 d-flex align-items-center justify-content-center">
                        <i class="bi bi-person-lines-fill fs-5"></i>
                    </div>
                    <div>
                        <h4 class="h5 fw-semibold text-dark mb-0">Account Information</h4>
                        <p class="text-muted small mb-0">Update your primary contact information</p>
                    </div>
                </div>

                <% if (isProfileIncomplete) { %>
                <div class="alert alert-warning border-warning border-opacity-25 bg-warning bg-opacity-10 text-dark mb-4 py-3 shadow-sm" role="alert">
                    <div class="d-flex align-items-start gap-3">
                        <div class="rounded-circle bg-warning bg-opacity-20 d-flex align-items-center justify-content-center text-warning" style="width: 2.25rem; height: 2.25rem; flex-shrink: 0;">
                            <i class="bi bi-person-fill-exclamation fs-5"></i>
                        </div>
                        <div class="flex-grow-1">
                            <h6 class="fw-bold mb-1" style="color: #664d03; font-size: 0.95rem;">Complete Your Profile Information</h6>
                            <p class="small mb-0 text-muted">Welcome to <strong>The Repair Shop</strong>! Please take a moment to update your profile details below (including your contact and role-specific professional information) to complete your account registration.</p>
                        </div>
                    </div>
                </div>
                <% } %>

                <% if (request.getAttribute("message") != null) { %>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i><%= request.getAttribute("message") %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <% } %>

                <% String error = (String) request.getAttribute("error"); %>
                <% if (error != null) { %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i><%= error %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <% } %>

                <form method="post" action="${pageContext.request.contextPath}/profile" class="needs-validation">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">

                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold text-secondary">Username</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light text-muted small">@</span>
                                <input type="text" class="form-control bg-light text-muted" value="<%= user.getUsername() %>" readonly disabled>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <label for="email" class="form-label small fw-semibold text-secondary">Email Address <span class="text-danger">*</span></label>
                            <input type="email" class="form-control" id="email" name="email" required
                                   value="<%= user.getEmail() != null ? user.getEmail() : "" %>">
                        </div>

                        <div class="col-md-6">
                            <label for="firstName" class="form-label small fw-semibold text-secondary">First Name</label>
                            <input type="text" class="form-control" id="firstName" name="firstName"
                                   value="<%= user.getFirstName() != null ? user.getFirstName() : "" %>">
                        </div>

                        <div class="col-md-6">
                            <label for="lastName" class="form-label small fw-semibold text-secondary">Last Name</label>
                            <input type="text" class="form-control" id="lastName" name="lastName"
                                   value="<%= user.getLastName() != null ? user.getLastName() : "" %>">
                        </div>

                        <div class="col-12">
                            <label for="phone" class="form-label small fw-semibold text-secondary">Phone Number</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-telephone text-muted"></i></span>
                                <input type="text" class="form-control" id="phone" name="phone"
                                       value="<%= user.getPhone() != null ? user.getPhone() : "" %>"
                                       placeholder="+1 (555) 000-0000">
                            </div>
                        </div>
                    </div>

                    <!-- Dynamic Subclass Fields -->
                    <% if (user instanceof Owner) { 
                        Owner owner = (Owner) user;
                    %>
                    <hr class="my-4 text-muted opacity-25">
                    
                    <div class="d-flex align-items-center gap-2 mb-3">
                        <div class="section-icon bg-warning bg-opacity-10 text-warning rounded-3 p-1.5 d-flex align-items-center justify-content-center">
                            <i class="bi bi-briefcase fs-5"></i>
                        </div>
                        <div>
                            <h4 class="h5 fw-semibold text-dark mb-0">Business Registry</h4>
                            <p class="text-muted small mb-0">Your corporate and tax identifiers</p>
                        </div>
                    </div>

                    <div class="row g-3 mb-4">
                        <div class="col-md-6">
                            <label for="companyName" class="form-label small fw-semibold text-secondary">Company Name</label>
                            <input type="text" class="form-control" id="companyName" name="companyName"
                                   value="<%= owner.getCompanyName() != null ? owner.getCompanyName() : "" %>"
                                   placeholder="e.g. Acme Repairs Inc.">
                        </div>
                        <div class="col-md-6">
                            <label for="taxId" class="form-label small fw-semibold text-secondary">Tax ID / Business Number</label>
                            <input type="text" class="form-control" id="taxId" name="taxId"
                                   value="<%= owner.getTaxId() != null ? owner.getTaxId() : "" %>"
                                   placeholder="e.g. TX-98765432-A">
                        </div>
                    </div>

                    <hr class="my-4 text-muted opacity-25">

                    <div class="d-flex align-items-center gap-2 mb-3">
                        <div class="section-icon bg-success bg-opacity-10 text-success rounded-3 p-1.5 d-flex align-items-center justify-content-center">
                            <i class="bi bi-shop-window fs-5"></i>
                        </div>
                        <div>
                            <h4 class="h5 fw-semibold text-dark mb-0">Owned Shops & Business Locations</h4>
                            <p class="text-muted small mb-0">All workshops registered under your ownership</p>
                        </div>
                    </div>

                    <div class="row g-3 mb-4">
                        <% 
                        java.util.Set<Shop> shops = owner.getShops();
                        if (shops != null && !shops.isEmpty()) {
                            for (Shop shop : shops) {
                        %>
                            <div class="col-md-6">
                                <div class="p-3 border rounded-3 bg-light hover-shadow transition-all d-flex align-items-start gap-3">
                                    <div class="rounded bg-white border p-2 d-flex align-items-center justify-content-center text-warning shadow-sm" style="width: 2.5rem; height: 2.5rem; flex-shrink: 0;">
                                        <i class="bi bi-shop fs-4"></i>
                                    </div>
                                    <div class="min-w-0">
                                        <h6 class="fw-bold text-dark mb-1 text-truncate"><%= shop.getName() %></h6>
                                        <p class="text-muted small mb-1 text-truncate"><i class="bi bi-geo-alt me-1"></i><%= shop.getAddress() != null && !shop.getAddress().isBlank() ? shop.getAddress() : "No address registered" %></p>
                                        <p class="text-muted small mb-0"><i class="bi bi-telephone me-1"></i><%= shop.getPhone() != null && !shop.getPhone().isBlank() ? shop.getPhone() : "No phone registered" %></p>
                                    </div>
                                </div>
                            </div>
                        <% 
                            }
                        } else {
                        %>
                            <div class="col-12">
                                <div class="p-4 border border-dashed rounded-3 bg-light text-center">
                                    <i class="bi bi-shop text-muted fs-3 mb-2 d-block"></i>
                                    <span class="text-muted small fw-semibold">No registered shops yet. Go to <a href="${pageContext.request.contextPath}/shops" class="text-cyan text-decoration-none">Shops Management</a> to create one.</span>
                                </div>
                            </div>
                        <% } %>
                    </div>

                    <% } else if (user instanceof Repairer) { 
                        Repairer repairer = (Repairer) user;
                    %>
                    <hr class="my-4 text-muted opacity-25">
                    
                    <div class="d-flex align-items-center gap-2 mb-3">
                        <div class="section-icon bg-info bg-opacity-10 text-info rounded-3 p-1.5 d-flex align-items-center justify-content-center">
                            <i class="bi bi-mortarboard fs-5"></i>
                        </div>
                        <div>
                            <h4 class="h5 fw-semibold text-dark mb-0">Professional Qualifications</h4>
                            <p class="text-muted small mb-0">Credentials, experience level, and rate settings</p>
                        </div>
                    </div>

                    <div class="row g-3 mb-4">
                        <div class="col-md-12">
                            <label for="specialization" class="form-label small fw-semibold text-secondary">Specialization / Skills Area</label>
                            <input type="text" class="form-control" id="specialization" name="specialization"
                                   value="<%= repairer.getSpecialization() != null ? repairer.getSpecialization() : "" %>"
                                   placeholder="e.g. Smartboards, iPhones, Microsoldering">
                        </div>
                        <div class="col-md-6">
                            <label for="experienceYears" class="form-label small fw-semibold text-secondary">Years of Experience</label>
                            <div class="input-group">
                                <input type="number" class="form-control" id="experienceYears" name="experienceYears"
                                       value="<%= repairer.getExperienceYears() != null ? repairer.getExperienceYears() : "" %>"
                                       min="0" placeholder="e.g. 5">
                                <span class="input-group-text small text-muted">years</span>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label for="hourlyRate" class="form-label small fw-semibold text-secondary">Hourly Billing Rate</label>
                            <div class="input-group">
                                    <span class="input-group-text">MAD</span>
                                <input type="text" class="form-control" id="hourlyRate" name="hourlyRate"
                                       value="<%= repairer.getHourlyRate() != null ? repairer.getHourlyRate() : "" %>"
                                       placeholder="e.g. 45.00">
                                <span class="input-group-text small text-muted">/hr</span>
                            </div>
                        </div>
                    </div>

                    <hr class="my-4 text-muted opacity-25">

                    <div class="d-flex align-items-center gap-2 mb-3">
                        <div class="section-icon bg-cyan bg-opacity-10 text-cyan rounded-3 p-1.5 d-flex align-items-center justify-content-center">
                            <i class="bi bi-shop fs-5"></i>
                        </div>
                        <div>
                            <h4 class="h5 fw-semibold text-dark mb-0">Assigned Workshop</h4>
                            <p class="text-muted small mb-0">The shop location you are currently assigned to</p>
                        </div>
                    </div>

                    <div class="mb-4">
                        <% if (repairer.getShop() != null) { %>
                            <div class="p-3 border rounded-3 bg-light d-flex align-items-start gap-3">
                                <div class="rounded bg-white border p-2 d-flex align-items-center justify-content-center text-cyan shadow-sm" style="width: 2.5rem; height: 2.5rem; flex-shrink: 0;">
                                    <i class="bi bi-geo-alt-fill fs-4"></i>
                                </div>
                                <div class="min-w-0">
                                    <h6 class="fw-bold text-dark mb-1"><%= repairer.getShop().getName() %></h6>
                                    <p class="text-muted small mb-1"><i class="bi bi-geo-alt me-1"></i><%= repairer.getShop().getAddress() != null && !repairer.getShop().getAddress().isBlank() ? repairer.getShop().getAddress() : "No address listed" %></p>
                                    <p class="text-muted small mb-0"><i class="bi bi-telephone me-1"></i><%= repairer.getShop().getPhone() != null && !repairer.getShop().getPhone().isBlank() ? repairer.getShop().getPhone() : "No phone listed" %></p>
                                </div>
                            </div>
                        <% } else { %>
                            <div class="p-3 border border-dashed rounded-3 bg-light text-center">
                                <i class="bi bi-exclamation-circle text-muted fs-3 mb-2 d-block"></i>
                                <span class="text-muted small">No shop has been assigned to you by the owner yet.</span>
                            </div>
                        <% } %>
                    </div>

                    <% } else if (user instanceof Admin) { 
                        Admin admin = (Admin) user;
                    %>
                    <hr class="my-4 text-muted opacity-25">
                    
                    <div class="d-flex align-items-center gap-2 mb-3">
                        <div class="section-icon bg-danger bg-opacity-10 text-danger rounded-3 p-1.5 d-flex align-items-center justify-content-center">
                            <i class="bi bi-shield-check fs-5"></i>
                        </div>
                        <div>
                            <h4 class="h5 fw-semibold text-dark mb-0">Administrative Properties</h4>
                            <p class="text-muted small mb-0">System roles and internal corporate positioning</p>
                        </div>
                    </div>

                    <div class="row g-3 mb-4">
                        <div class="col-md-6">
                            <label for="department" class="form-label small fw-semibold text-secondary">Department</label>
                            <input type="text" class="form-control bg-light text-muted" id="department" name="department"
                                   value="<%= admin.getDepartment() != null ? admin.getDepartment() : "General Operations" %>" readonly disabled>
                            <div class="form-text text-muted small">Set during system onboarding.</div>
                        </div>
                        <div class="col-md-6">
                            <label for="adminLevel" class="form-label small fw-semibold text-secondary">Admin Level</label>
                            <input type="text" class="form-control bg-light text-muted" id="adminLevel" name="adminLevel"
                                   value="<%= admin.getAdminLevel() != null ? admin.getAdminLevel() : "Level 1 (Full Access)" %>" readonly disabled>
                            <div class="form-text text-muted small">Controls global access hierarchy.</div>
                        </div>
                    </div>
                    <% } %>

                    <div class="d-grid gap-2 mt-4">
                        <button type="submit" class="btn btn-cyan text-white fw-semibold py-2">
                            <i class="bi bi-save me-2"></i>Save Changes
                        </button>
                        <a href="${pageContext.request.contextPath}/profile/change-password"
                           class="btn btn-outline-secondary py-2">
                            <i class="bi bi-key me-2"></i>Change Security Password
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

</body>
</html>

