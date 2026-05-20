<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags" %>

<layout:tag title="Mon Profil" activePage="profile">

    <div class="bg-gray-100 min-h-screen p-6">

        <!-- TOP PROFILE HEADER -->
        <div class="bg-white rounded-2xl shadow-sm border border-gray-200 p-8 mb-6">

            <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-6">

                <div class="flex items-center gap-6">

                    <!-- Avatar -->
                    <div class="w-28 h-28 rounded-full bg-yellow-400 flex items-center justify-center text-5xl font-bold text-black shadow-sm">
                        ${user.firstName.substring(0,1)}${user.lastName.substring(0,1)}
                    </div>

                    <!-- User Info -->
                    <div>
                        <h1 class="text-4xl font-bold text-gray-900 mb-2">
                            ${user.firstName} ${user.lastName}
                        </h1>

                        <div class="flex flex-col gap-1 text-gray-500 text-sm">

                            <div class="flex items-center gap-2">
                                <span>👤</span>
                                <span><sec:authentication property="name" /></span>
                            </div>

                            <div class="flex items-center gap-2">
                                <span>✉️</span>
                                <span>${user.email}</span>
                            </div>

                            <div class="flex items-center gap-2">
                                <span>📞</span>
                                <span>
                                    ${not empty user.phoneNumber ? user.phoneNumber : 'Non renseigné'}
                                </span>
                            </div>

                        </div>
                    </div>

                </div>

                <!-- Role Badge -->
                <div>
                    <span class="px-4 py-2 rounded-full text-sm font-semibold
                        ${user.role == 'ADMIN' ? 'bg-red-100 text-red-700' :
                          user.role == 'OWNER' ? 'bg-purple-100 text-purple-700' :
                          user.role == 'REPARATOR' ? 'bg-yellow-100 text-yellow-700' :
                          'bg-green-100 text-green-700'}">

                        <c:choose>
                            <c:when test="${user.role == 'ADMIN'}">Administrateur</c:when>
                            <c:when test="${user.role == 'OWNER'}">Propriétaire</c:when>
                            <c:when test="${user.role == 'REPARATOR'}">Réparateur</c:when>
                            <c:otherwise>Client</c:otherwise>
                        </c:choose>

                    </span>
                </div>

            </div>

        </div>

        <!-- ALERTS -->
        <c:if test="${not empty success}">
            <div class="bg-green-100 border border-green-300 text-green-700 px-5 py-4 rounded-xl mb-6">
                    ${success}
            </div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="bg-red-100 border border-red-300 text-red-700 px-5 py-4 rounded-xl mb-6">
                    ${error}
            </div>
        </c:if>

        <!-- MAIN GRID -->
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">

            <!-- LEFT CONTENT -->
            <div class="lg:col-span-2 space-y-6">

                <!-- PERSONAL INFORMATIONS -->
                <div class="bg-white rounded-2xl shadow-sm border border-gray-200">

                    <div class="px-6 py-5 border-b border-gray-100">
                        <h2 class="text-2xl font-bold text-gray-800">
                            Informations personnelles
                        </h2>
                    </div>

                    <div class="p-6">

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-5">

                            <div class="bg-gray-50 rounded-xl p-4">
                                <p class="text-sm text-gray-500 mb-1">Prénom</p>
                                <p class="font-semibold text-gray-900">${user.firstName}</p>
                            </div>

                            <div class="bg-gray-50 rounded-xl p-4">
                                <p class="text-sm text-gray-500 mb-1">Nom</p>
                                <p class="font-semibold text-gray-900">${user.lastName}</p>
                            </div>

                            <div class="bg-gray-50 rounded-xl p-4">
                                <p class="text-sm text-gray-500 mb-1">Email</p>
                                <p class="font-semibold text-gray-900">${user.email}</p>
                            </div>

                            <div class="bg-gray-50 rounded-xl p-4">
                                <p class="text-sm text-gray-500 mb-1">Téléphone</p>
                                <p class="font-semibold text-gray-900">
                                    ${not empty user.phoneNumber ? user.phoneNumber : 'Non renseigné'}
                                </p>
                            </div>

                            <div class="bg-gray-50 rounded-xl p-4 md:col-span-2">
                                <p class="text-sm text-gray-500 mb-1">Adresse</p>
                                <p class="font-semibold text-gray-900">
                                    ${not empty user.address ? user.address : 'Non renseignée'}
                                </p>
                            </div>

                        </div>

                    </div>

                </div>

                <!-- UPDATE PROFILE -->
                <div class="bg-white rounded-2xl shadow-sm border border-gray-200">

                    <div class="px-6 py-5 border-b border-gray-100">
                        <h2 class="text-2xl font-bold text-gray-800">
                            Informations personnelles
                        </h2>
                    </div>

                    <div class="p-6">

                        <form:form
                                action="${pageContext.request.contextPath}/profile/update"
                                method="post"
                                modelAttribute="updateProfileRequest">

                            <div class="grid grid-cols-1 md:grid-cols-2 gap-5">

                                <div>
                                    <label class="block text-sm font-semibold text-gray-700 mb-2">
                                        Prénom
                                    </label>

                                    <form:input
                                            path="firstName"
                                            value="${user.firstName}"
                                            class="w-full rounded-xl border border-gray-300 px-4 py-3 focus:ring-2 focus:ring-blue-500 focus:outline-none"/>
                                </div>

                                <div>
                                    <label class="block text-sm font-semibold text-gray-700 mb-2">
                                        Nom
                                    </label>

                                    <form:input
                                            path="lastName"
                                            value="${user.lastName}"
                                            class="w-full rounded-xl border border-gray-300 px-4 py-3 focus:ring-2 focus:ring-blue-500 focus:outline-none"/>
                                </div>

                                <div>
                                    <label class="block text-sm font-semibold text-gray-700 mb-2">
                                        Téléphone
                                    </label>

                                    <form:input
                                            path="phoneNumber"
                                            value="${user.phoneNumber}"
                                            class="w-full rounded-xl border border-gray-300 px-4 py-3 focus:ring-2 focus:ring-blue-500 focus:outline-none"/>
                                </div>

                                <div class="md:col-span-2">
                                    <label class="block text-sm font-semibold text-gray-700 mb-2">
                                        Adresse
                                    </label>

                                    <textarea
                                            name="address"
                                            rows="3"
                                            class="w-full rounded-xl border border-gray-300 px-4 py-3 focus:ring-2 focus:ring-blue-500 focus:outline-none">${user.address}</textarea>
                                </div>

                            </div>

                            <!-- OWNER -->
                            <c:if test="${user.role == 'OWNER'}">

                                <div class="border-t border-gray-200 mt-8 pt-8">

                                    <h3 class="text-xl font-bold text-gray-800 mb-5">
                                        Informations professionnelles
                                    </h3>

                                    <div class="grid grid-cols-1 md:grid-cols-2 gap-5">

                                        <div>
                                            <label class="block text-sm font-semibold text-gray-700 mb-2">
                                                Nom entreprise
                                            </label>

                                            <form:input
                                                    path="companyName"
                                                    value="${owner.companyName}"
                                                    class="w-full rounded-xl border border-gray-300 px-4 py-3"/>
                                        </div>

                                        <div>
                                            <label class="block text-sm font-semibold text-gray-700 mb-2">
                                                N° taxe
                                            </label>

                                            <form:input
                                                    path="taxNumber"
                                                    value="${owner.taxNumber}"
                                                    class="w-full rounded-xl border border-gray-300 px-4 py-3"/>
                                        </div>

                                        <div>
                                            <label class="block text-sm font-semibold text-gray-700 mb-2">
                                                Licence
                                            </label>

                                            <form:input
                                                    path="businessLicense"
                                                    value="${owner.businessLicense}"
                                                    class="w-full rounded-xl border border-gray-300 px-4 py-3"/>
                                        </div>

                                        <div>
                                            <label class="block text-sm font-semibold text-gray-700 mb-2">
                                                Site web
                                            </label>

                                            <form:input
                                                    path="website"
                                                    value="${owner.website}"
                                                    class="w-full rounded-xl border border-gray-300 px-4 py-3"/>
                                        </div>

                                        <div class="md:col-span-2">
                                            <label class="block text-sm font-semibold text-gray-700 mb-2">
                                                Description
                                            </label>

                                            <textarea
                                                    name="companyDescription"
                                                    rows="3"
                                                    class="w-full rounded-xl border border-gray-300 px-4 py-3">${owner.companyDescription}</textarea>
                                        </div>

                                    </div>

                                </div>

                            </c:if>

                            <!-- REPARATOR -->
                            <c:if test="${user.role == 'REPARATOR'}">

                                <div class="border-t border-gray-200 mt-8 pt-8">

                                    <h3 class="text-xl font-bold text-gray-800 mb-5">
                                        Informations professionnelles
                                    </h3>

                                    <div class="grid grid-cols-1 md:grid-cols-2 gap-5">

                                        <div>
                                            <label class="block text-sm font-semibold text-gray-700 mb-2">
                                                Spécialisation
                                            </label>

                                            <form:input
                                                    path="specialization"
                                                    value="${repairer.specialization}"
                                                    class="w-full rounded-xl border border-gray-300 px-4 py-3"/>
                                        </div>

                                        <div>
                                            <label class="block text-sm font-semibold text-gray-700 mb-2">
                                                Disponible
                                            </label>

                                            <form:select
                                                    path="available"
                                                    class="w-full rounded-xl border border-gray-300 px-4 py-3">

                                                <form:option value="true">Oui</form:option>
                                                <form:option value="false">Non</form:option>

                                            </form:select>
                                        </div>

                                        <div>
                                            <label class="block text-sm font-semibold text-gray-700 mb-2">
                                                Certification
                                            </label>

                                            <form:input
                                                    path="certification"
                                                    value="${repairer.certification}"
                                                    class="w-full rounded-xl border border-gray-300 px-4 py-3"/>
                                        </div>

                                        <div class="md:col-span-2">
                                            <label class="block text-sm font-semibold text-gray-700 mb-2">
                                                Compétences
                                            </label>

                                            <textarea
                                                    name="skills"
                                                    rows="3"
                                                    class="w-full rounded-xl border border-gray-300 px-4 py-3">${repairer.skills}</textarea>
                                        </div>

                                    </div>

                                </div>

                            </c:if>

                            <div class="flex justify-end mt-8">

                                <button
                                        type="submit"
                                        class="bg-blue-600 hover:bg-blue-700 transition text-white font-semibold px-6 py-3 rounded-xl shadow-sm">

                                    Mettre à jour

                                </button>

                            </div>

                        </form:form>

                    </div>

                </div>

            </div>

            <!-- RIGHT SIDEBAR -->
            <div class="space-y-6">

                <!-- ABOUT -->
                <div class="bg-white rounded-2xl shadow-sm border border-gray-200 p-6">

                    <h3 class="text-xl font-bold text-gray-800 mb-4">
                        À propos
                    </h3>

                    <p class="text-gray-600 leading-relaxed">
                        ${not empty user.address ? user.address : 'Aucune description disponible.'}
                    </p>

                </div>

                <!-- SECURITY -->
                <div class="bg-white rounded-2xl shadow-sm border border-gray-200">

                    <div class="px-6 py-5 border-b border-gray-100">
                        <h3 class="text-xl font-bold text-gray-800">
                            Sécurité
                        </h3>
                    </div>

                    <div class="p-6">

                        <c:if test="${not empty passwordError}">
                            <div class="bg-red-100 border border-red-300 text-red-700 px-4 py-3 rounded-xl mb-4">
                                    ${passwordError}
                            </div>
                        </c:if>

                        <form:form
                                action="${pageContext.request.contextPath}/profile/change-password"
                                method="post"
                                modelAttribute="changePasswordRequest">

                            <div class="mb-4">

                                <label class="block text-sm font-semibold text-gray-700 mb-2">
                                    Mot de passe actuel
                                </label>

                                <form:password
                                        path="currentPassword"
                                        required="required"
                                        class="w-full rounded-xl border border-gray-300 px-4 py-3"/>
                            </div>

                            <div class="mb-4">

                                <label class="block text-sm font-semibold text-gray-700 mb-2">
                                    Nouveau mot de passe
                                </label>

                                <form:password
                                        path="newPassword"
                                        required="required"
                                        class="w-full rounded-xl border border-gray-300 px-4 py-3"/>

                                <p class="text-xs text-gray-500 mt-1">
                                    Minimum 6 caractères
                                </p>

                            </div>

                            <div class="mb-5">

                                <label class="block text-sm font-semibold text-gray-700 mb-2">
                                    Confirmer le mot de passe
                                </label>

                                <form:password
                                        path="confirmPassword"
                                        required="required"
                                        class="w-full rounded-xl border border-gray-300 px-4 py-3"/>
                            </div>

                            <button
                                    type="submit"
                                    class="w-full bg-green-600 hover:bg-green-700 transition text-white font-semibold py-3 rounded-xl">

                                Changer le mot de passe

                            </button>

                        </form:form>

                    </div>

                </div>

            </div>

        </div>

    </div>

</layout:tag>