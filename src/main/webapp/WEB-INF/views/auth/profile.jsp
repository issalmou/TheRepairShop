<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags" %>

<layout:tag title="Mon Profil" activePage="profile">
    <div class="max-w-4xl mx-auto">
        <!-- Messages -->
        <c:if test="${not empty success}">
            <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-4">
                    ${success}
            </div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
                    ${error}
            </div>
        </c:if>

        <!-- Informations personnelles -->
        <div class="bg-white rounded-lg shadow mb-6">
            <div class="border-b px-6 py-4">
                <h2 class="text-xl font-semibold text-gray-800">Informations personnelles</h2>
            </div>
            <div class="p-6">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                        <label class="block text-gray-600 text-sm font-medium mb-1">Nom d'utilisateur</label>
                        <p class="text-gray-900 font-medium"><sec:authentication property="name" /></p>
                    </div>
                    <div>
                        <label class="block text-gray-600 text-sm font-medium mb-1">Email</label>
                        <p class="text-gray-900">${user.email}</p>
                    </div>
                    <div>
                        <label class="block text-gray-600 text-sm font-medium mb-1">Prénom</label>
                        <p class="text-gray-900">${user.firstName}</p>
                    </div>
                    <div>
                        <label class="block text-gray-600 text-sm font-medium mb-1">Nom</label>
                        <p class="text-gray-900">${user.lastName}</p>
                    </div>
                    <div>
                        <label class="block text-gray-600 text-sm font-medium mb-1">Téléphone</label>
                        <p class="text-gray-900">${not empty user.phoneNumber ? user.phoneNumber : 'Non renseigné'}</p>
                    </div>
                    <div>
                        <label class="block text-gray-600 text-sm font-medium mb-1">Rôle</label>
                        <p class="text-gray-900">
                            <span class="px-2 py-1 text-xs font-semibold rounded-full
                                ${user.role == 'ADMIN' ? 'bg-red-100 text-red-800' :
                                  user.role == 'OWNER' ? 'bg-purple-100 text-purple-800' :
                                  user.role == 'REPARATOR' ? 'bg-yellow-100 text-yellow-800' :
                                  'bg-green-100 text-green-800'}">
                                <c:choose>
                                    <c:when test="${user.role == 'ADMIN'}">Administrateur</c:when>
                                    <c:when test="${user.role == 'OWNER'}">Propriétaire</c:when>
                                    <c:when test="${user.role == 'REPARATOR'}">Réparateur</c:when>
                                    <c:otherwise>Client</c:otherwise>
                                </c:choose>
                            </span>
                        </p>
                    </div>
                    <div class="col-span-2">
                        <label class="block text-gray-600 text-sm font-medium mb-1">Adresse</label>
                        <p class="text-gray-900">${not empty user.address ? user.address : 'Non renseignée'}</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Formulaire de mise à jour UNIFIÉ -->
        <div class="bg-white rounded-lg shadow mb-6">
            <div class="border-b px-6 py-4">
                <h2 class="text-xl font-semibold text-gray-800">Modifier mon profil</h2>
            </div>
            <div class="p-6">
                <%--@elvariable id="updateProfileRequest" type="ma.aabs.repair_management_system.dto.UpdateProfileRequest"--%>
                <form:form action="${pageContext.request.contextPath}/profile/update" method="post" modelAttribute="updateProfileRequest">
                    <!-- Champs communs -->
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                        <div>
                            <label class="block text-gray-700 text-sm font-bold mb-2" for="firstName">Prénom</label>
                            <form:input path="firstName" id="firstName" value="${user.firstName}"
                                        class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"/>
                        </div>
                        <div>
                            <label class="block text-gray-700 text-sm font-bold mb-2" for="lastName">Nom</label>
                            <form:input path="lastName" id="lastName" value="${user.lastName}"
                                        class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"/>
                        </div>
                        <div>
                            <label class="block text-gray-700 text-sm font-bold mb-2" for="phoneNumber">Téléphone</label>
                            <form:input path="phoneNumber" id="phoneNumber" value="${user.phoneNumber}"
                                        class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"/>
                        </div>
                        <div class="col-span-2">
                            <label class="block text-gray-700 text-sm font-bold mb-2" for="address">Adresse</label>
                            <textarea id="address" name="address" rows="3"
                                      class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline">${user.address}</textarea>
                        </div>
                    </div>

                    <!-- Champs spécifiques OWNER -->
                    <c:if test="${user.role == 'OWNER'}">
                        <div class="border-t pt-4 mt-4">
                            <h3 class="text-lg font-semibold text-gray-800 mb-4">Informations professionnelles</h3>
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                <div>
                                    <label class="block text-gray-700 text-sm font-bold mb-2" for="companyName">Nom de l'entreprise</label>
                                    <form:input path="companyName" id="companyName" value="${owner.companyName}"
                                                class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"/>
                                </div>
                                <div>
                                    <label class="block text-gray-700 text-sm font-bold mb-2" for="taxNumber">N° de taxe</label>
                                    <form:input path="taxNumber" id="taxNumber" value="${owner.taxNumber}"
                                                class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"/>
                                </div>
                                <div>
                                    <label class="block text-gray-700 text-sm font-bold mb-2" for="businessLicense">Licence</label>
                                    <form:input path="businessLicense" id="businessLicense" value="${owner.businessLicense}"
                                                class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"/>
                                </div>
                                <div>
                                    <label class="block text-gray-700 text-sm font-bold mb-2" for="website">Site web</label>
                                    <form:input path="website" id="website" value="${owner.website}"
                                                class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"/>
                                </div>
                                <div class="col-span-2">
                                    <label class="block text-gray-700 text-sm font-bold mb-2" for="companyDescription">Description</label>
                                    <textarea id="companyDescription" name="companyDescription" rows="3"
                                              class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline">${owner.companyDescription}</textarea>
                                </div>
                            </div>
                        </div>
                    </c:if>

                    <!-- Champs spécifiques REPARATOR -->
                    <c:if test="${user.role == 'REPARATOR'}">
                        <div class="border-t pt-4 mt-4">
                            <h3 class="text-lg font-semibold text-gray-800 mb-4">Informations professionnelles</h3>
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                <div>
                                    <label class="block text-gray-700 text-sm font-bold mb-2" for="specialization">Spécialisation</label>
                                    <form:input path="specialization" id="specialization" value="${repairer.specialization}"
                                                class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"/>
                                </div>
                                <div>
                                    <label class="block text-gray-700 text-sm font-bold mb-2" for="available">Disponible</label>
                                    <form:select path="available" id="available"
                                                 class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline">
                                        <form:option value="true">Oui</form:option>
                                        <form:option value="false">Non</form:option>
                                    </form:select>
                                </div>
                                <div>
                                    <label class="block text-gray-700 text-sm font-bold mb-2" for="certification">Certification</label>
                                    <form:input path="certification" id="certification" value="${repairer.certification}"
                                                class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"/>
                                </div>
                                <div class="col-span-2">
                                    <label class="block text-gray-700 text-sm font-bold mb-2" for="skills">Compétences</label>
                                    <textarea id="skills" name="skills" rows="3"
                                              class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline">${repairer.skills}</textarea>
                                </div>
                            </div>
                        </div>
                    </c:if>

                    <div class="flex justify-end mt-6">
                        <button type="submit" class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded transition">
                            Mettre à jour
                        </button>
                    </div>
                </form:form>
            </div>
        </div>

        <!-- Changement de mot de passe -->
        <div class="bg-white rounded-lg shadow">
            <div class="border-b px-6 py-4">
                <h2 class="text-xl font-semibold text-gray-800">Changer mon mot de passe</h2>
            </div>
            <div class="p-6">
                <c:if test="${not empty passwordError}">
                    <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
                            ${passwordError}
                    </div>
                </c:if>
                <form:form action="${pageContext.request.contextPath}/profile/change-password" method="post" modelAttribute="changePasswordRequest">
                    <div class="mb-4">
                        <label class="block text-gray-700 text-sm font-bold mb-2" for="currentPassword">Mot de passe actuel</label>
                        <form:password path="currentPassword" id="currentPassword"
                                       class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
                                       required="required"/>
                    </div>
                    <div class="mb-4">
                        <label class="block text-gray-700 text-sm font-bold mb-2" for="newPassword">Nouveau mot de passe</label>
                        <form:password path="newPassword" id="newPassword"
                                       class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
                                       required="required"/>
                        <p class="text-xs text-gray-500 mt-1">Minimum 6 caractères</p>
                    </div>
                    <div class="mb-4">
                        <label class="block text-gray-700 text-sm font-bold mb-2" for="confirmPassword">Confirmer le nouveau mot de passe</label>
                        <form:password path="confirmPassword" id="confirmPassword"
                                       class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
                                       required="required"/>
                    </div>
                    <div class="flex justify-end">
                        <button type="submit" class="bg-green-500 hover:bg-green-700 text-white font-bold py-2 px-4 rounded transition">
                            Changer le mot de passe
                        </button>
                    </div>
                </form:form>
            </div>
        </div>
    </div>
</layout:tag>