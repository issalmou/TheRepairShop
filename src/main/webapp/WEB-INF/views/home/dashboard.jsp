<%-- CORRECT dans un .jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags" %>

<layout:tag title="Dashboard" activePage="dashboard">
    <style>
        .stat-card-orange { background: linear-gradient(135deg, #ff9500 0%, #ff7e00 100%); }
        .stat-card-dark { background: #2a2a2a; }
        .review-bar { height: 8px; border-radius: 4px; display: inline-block; }
        .chart-bar { height: 6px; border-radius: 3px; margin-top: 8px; }
    </style>

    <!-- Stat Cards Row 1 -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        <!-- Users Active Card (Orange) -->
        <div class="stat-card-orange rounded-lg p-6 shadow-lg text-white">
            <div class="flex items-start justify-between">
                <div>
                    <div class="flex items-center gap-2 mb-2">
                        <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 24 24">
                            <path d="M12 12a4 4 0 100-8 4 4 0 000 8zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/>
                        </svg>
                    </div>
                    <p class="text-sm font-light opacity-90">Users Active</p>
                    <p class="text-3xl font-bold">1600</p>
                </div>
                <span class="text-sm font-semibold">+55%</span>
            </div>
        </div>

        <!-- Click Events Card (Dark) -->
        <div class="stat-card-dark rounded-lg p-6 shadow-lg text-white">
            <div class="flex items-start justify-between">
                <div>
                    <div class="flex items-center gap-2 mb-2">
                        <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 24 24">
                            <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.42 0-8-3.58-8-8s3.58-8 8-8 8 3.58 8 8-3.58 8-8 8zm0-14c-3.31 0-6 2.69-6 6s2.69 6 6 6 6-2.69 6-6-2.69-6-6-6z"/>
                        </svg>
                    </div>
                    <p class="text-sm font-light opacity-90">Click Events</p>
                    <p class="text-3xl font-bold">357</p>
                </div>
                <span class="text-sm font-semibold">+124%</span>
            </div>
        </div>

        <!-- Purchases Card (Dark) -->
        <div class="stat-card-dark rounded-lg p-6 shadow-lg text-white">
            <div class="flex items-start justify-between">
                <div>
                    <div class="flex items-center gap-2 mb-2">
                        <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 24 24">
                            <path d="M7 18c-1.1 0-1.99.9-1.99 2S5.9 22 7 22s2-.9 2-2-.9-2-2-2zM1 2v2h2l3.6 7.59-1.35 2.45c-.16.28-.25.61-.25.96 0 1.1.9 2 2 2h12v-2H7.42c-.14 0-.25-.11-.25-.25l.03-.12.9-1.63h7.45c.75 0 1.41-.41 1.75-1.03l3.58-6.49c.08-.14.12-.31.12-.48 0-.55-.45-1-1-1H5.21l-.94-2H1zm16 16c-1.1 0-1.99.9-1.99 2s.89 2 1.99 2 2-.9 2-2-.9-2-2-2z"/>
                        </svg>
                    </div>
                    <p class="text-sm font-light opacity-90">Purchases</p>
                    <p class="text-3xl font-bold">2300</p>
                </div>
                <span class="text-sm font-semibold">+15%</span>
            </div>
        </div>

        <!-- Likes Card (Dark) -->
        <div class="stat-card-dark rounded-lg p-6 shadow-lg text-white">
            <div class="flex items-start justify-between">
                <div>
                    <div class="flex items-center gap-2 mb-2">
                        <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 24 24">
                            <path d="M1 21h4V9H1v12zm22-11c0-1.1-.9-2-2-2h-6.31l.95-4.57.03-.32c0-.41-.17-.79-.44-1.06L14.17 1 7.59 7.59C7.22 7.95 7 8.45 7 9v10c0 1.1.9 2 2 2h9c.83 0 1.54-.5 1.84-1.22l5.15-9.1c.1-.16.16-.34.16-.54z"/>
                        </svg>
                    </div>
                    <p class="text-sm font-light opacity-90">Likes</p>
                    <p class="text-3xl font-bold">940</p>
                </div>
                <span class="text-sm font-semibold">+80%</span>
            </div>
        </div>
    </div>

    <!-- Reviews and Orders Row -->
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 mb-8">
        <!-- Reviews Section -->
        <div class="bg-white border border-gray-200 rounded-lg p-6 shadow-sm lg:col-span-1">
            <h3 class="text-lg font-semibold text-gray-800 mb-6">Reviews</h3>
            
            <!-- Positive Reviews -->
            <div class="mb-6">
                <div class="flex justify-between items-center mb-2">
                    <p class="text-sm font-semibold text-gray-700">Positive Reviews</p>
                    <span class="text-sm font-bold text-gray-800">80%</span>
                </div>
                <div class="w-full bg-gray-200 rounded-full h-2">
                    <div class="bg-orange-500 h-2 rounded-full" style="width: 80%"></div>
                </div>
            </div>

            <!-- Neutral Reviews -->
            <div class="mb-6">
                <div class="flex justify-between items-center mb-2">
                    <p class="text-sm font-semibold text-gray-700">Neutral Reviews</p>
                    <span class="text-sm font-bold text-gray-800">17%</span>
                </div>
                <div class="w-full bg-gray-200 rounded-full h-2">
                    <div class="bg-gray-400 h-2 rounded-full" style="width: 17%"></div>
                </div>
            </div>

            <!-- Negative Reviews -->
            <div class="mb-6">
                <div class="flex justify-between items-center mb-2">
                    <p class="text-sm font-semibold text-gray-700">Negative Reviews</p>
                    <span class="text-sm font-bold text-gray-800">3%</span>
                </div>
                <div class="w-full bg-gray-200 rounded-full h-2">
                    <div class="bg-red-500 h-2 rounded-full" style="width: 3%"></div>
                </div>
            </div>

            <p class="text-xs text-gray-600 mt-6">
                More than <span class="font-semibold">1,500,000</span> developers used Creative Tim's products and over <span class="font-semibold">700,000</span> projects were created.
            </p>

            <button class="mt-4 bg-gray-900 text-white text-sm px-4 py-2 rounded font-semibold hover:bg-gray-800 w-full">
                View all reviews
            </button>
        </div>

        <!-- Orders Overview Section -->
        <div class="bg-white border border-gray-200 rounded-lg p-6 shadow-sm lg:col-span-2">
            <h3 class="text-lg font-semibold text-gray-800 mb-6">Orders overview</h3>
            <p class="text-xs text-gray-600 mb-6"><span class="font-semibold">24%</span> this month</p>

            <div class="space-y-4">
                <!-- Order 1 -->
                <div class="flex items-center justify-between pb-4 border-b">
                    <div class="flex items-center gap-4">
                        <div class="w-10 h-10 bg-green-100 rounded flex items-center justify-center">
                            <svg class="w-6 h-6 text-green-600" fill="currentColor" viewBox="0 0 24 24">
                                <path d="M9 16.2L4.8 12l-1.4 1.4L9 19 21 7l-1.4-1.4L9 16.2z"/>
                            </svg>
                        </div>
                        <div>
                            <p class="font-semibold text-sm text-gray-800">$2400, Design changes</p>
                            <p class="text-xs text-gray-500">22 DEC 7:20 PM</p>
                        </div>
                    </div>
                </div>

                <!-- Order 2 -->
                <div class="flex items-center justify-between pb-4 border-b">
                    <div class="flex items-center gap-4">
                        <div class="w-10 h-10 bg-red-100 rounded flex items-center justify-center">
                            <svg class="w-6 h-6 text-red-600" fill="currentColor" viewBox="0 0 24 24">
                                <path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12 19 6.41z"/>
                            </svg>
                        </div>
                        <div>
                            <p class="font-semibold text-sm text-gray-800">New order #1832412</p>
                            <p class="text-xs text-gray-500">21 DEC 11 PM</p>
                        </div>
                    </div>
                </div>

                <!-- Order 3 -->
                <div class="flex items-center justify-between pb-4 border-b">
                    <div class="flex items-center gap-4">
                        <div class="w-10 h-10 bg-blue-100 rounded flex items-center justify-center">
                            <svg class="w-6 h-6 text-blue-600" fill="currentColor" viewBox="0 0 24 24">
                                <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/>
                            </svg>
                        </div>
                        <div>
                            <p class="font-semibold text-sm text-gray-800">Server payments for April</p>
                            <p class="text-xs text-gray-500">21 DEC 9:34 PM</p>
                        </div>
                    </div>
                </div>

                <!-- Order 4 -->
                <div class="flex items-center justify-between pb-4 border-b">
                    <div class="flex items-center gap-4">
                        <div class="w-10 h-10 bg-orange-100 rounded flex items-center justify-center">
                            <svg class="w-6 h-6 text-orange-600" fill="currentColor" viewBox="0 0 24 24">
                                <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8zm3.5-9c.83 0 1.5-.67 1.5-1.5S16.33 8 15.5 8 14 8.67 14 9.5s.67 1.5 1.5 1.5zm-7 0c.83 0 1.5-.67 1.5-1.5S9.33 8 8.5 8 7 8.67 7 9.5 7.67 11 8.5 11zm3.5 6.5c2.33 0 4.31-1.46 5.11-3.5H6.89c.8 2.04 2.78 3.5 5.11 3.5z"/>
                            </svg>
                        </div>
                        <div>
                            <p class="font-semibold text-sm text-gray-800">New card added for order #4395133</p>
                            <p class="text-xs text-gray-500">20 DEC 2:20 AM</p>
                        </div>
                    </div>
                </div>

                <!-- Order 5 -->
                <div class="flex items-center justify-between">
                    <div class="flex items-center gap-4">
                        <div class="w-10 h-10 bg-purple-100 rounded flex items-center justify-center">
                            <svg class="w-6 h-6 text-purple-600" fill="currentColor" viewBox="0 0 24 24">
                                <path d="M9 16.2L4.8 12l-1.4 1.4L9 19 21 7l-1.4-1.4L9 16.2z"/>
                            </svg>
                        </div>
                        <div>
                            <p class="font-semibold text-sm text-gray-800">Unlock packages for development</p>
                            <p class="text-xs text-gray-500">18 DEC 4:54 AM</p>
                        </div>
                    </div>
                </div>

                <!-- Order 6 -->
                <div class="flex items-center justify-between pt-4 border-t">
                    <div class="flex items-center gap-4">
                        <div class="w-10 h-10 bg-gray-100 rounded flex items-center justify-center">
                            <svg class="w-6 h-6 text-gray-600" fill="currentColor" viewBox="0 0 24 24">
                                <path d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z"/>
                            </svg>
                        </div>
                        <div>
                            <p class="font-semibold text-sm text-gray-800">New order #9583120</p>
                            <p class="text-xs text-gray-500">17 DEC</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Projects Section -->
    <div class="bg-white border border-gray-200 rounded-lg p-6 shadow-sm">
        <div class="flex justify-between items-center mb-6">
            <div>
                <h3 class="text-lg font-semibold text-gray-800">Projects</h3>
                <p class="text-sm text-gray-600">30 done this month</p>
            </div>
        </div>

        <div class="overflow-x-auto">
            <table class="w-full">
                <thead>
                    <tr class="border-b border-gray-200">
                        <th class="text-left py-3 px-4 text-xs font-bold text-gray-500 uppercase">COMPANIES</th>
                        <th class="text-left py-3 px-4 text-xs font-bold text-gray-500 uppercase">MEMBERS</th>
                        <th class="text-left py-3 px-4 text-xs font-bold text-gray-500 uppercase">BUDGET</th>
                        <th class="text-left py-3 px-4 text-xs font-bold text-gray-500 uppercase">COMPLETION</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- Project 1 -->
                    <tr class="border-b border-gray-100 hover:bg-gray-50">
                        <td class="py-3 px-4">
                            <div class="flex items-center gap-2">
                                <div class="w-6 h-6 bg-purple-600 rounded text-white text-xs flex items-center justify-center font-bold">V</div>
                                <span class="text-sm font-semibold text-gray-800">Soft UI XD Version</span>
                            </div>
                        </td>
                        <td class="py-3 px-4">
                            <div class="flex -space-x-2">
                                <img class="w-6 h-6 rounded-full border border-white" src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24'%3E%3Crect fill='%238B5CF6' width='24' height='24'/%3E%3C/svg%3E" alt="user">
                            </div>
                        </td>
                        <td class="py-3 px-4"><span class="text-sm font-semibold text-gray-800">$14,000</span></td>
                        <td class="py-3 px-4">
                            <div class="w-full bg-gray-200 rounded-full h-2 max-w-xs">
                                <div class="bg-orange-500 h-2 rounded-full" style="width: 60%"></div>
                            </div>
                            <p class="text-xs text-gray-600 mt-1">60%</p>
                        </td>
                    </tr>

                    <!-- Project 2 -->
                    <tr class="border-b border-gray-100 hover:bg-gray-50">
                        <td class="py-3 px-4">
                            <div class="flex items-center gap-2">
                                <div class="w-6 h-6 bg-blue-500 rounded text-white text-xs flex items-center justify-center font-bold">A</div>
                                <span class="text-sm font-semibold text-gray-800">Add Progress Track</span>
                            </div>
                        </td>
                        <td class="py-3 px-4">
                            <div class="flex -space-x-2">
                                <img class="w-6 h-6 rounded-full border border-white" src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24'%3E%3Crect fill='%233B82F6' width='24' height='24'/%3E%3C/svg%3E" alt="user">
                            </div>
                        </td>
                        <td class="py-3 px-4"><span class="text-sm font-semibold text-gray-800">$3,000</span></td>
                        <td class="py-3 px-4">
                            <div class="w-full bg-gray-200 rounded-full h-2 max-w-xs">
                                <div class="bg-blue-500 h-2 rounded-full" style="width: 10%"></div>
                            </div>
                            <p class="text-xs text-gray-600 mt-1">10%</p>
                        </td>
                    </tr>

                    <!-- Project 3 -->
                    <tr class="border-b border-gray-100 hover:bg-gray-50">
                        <td class="py-3 px-4">
                            <div class="flex items-center gap-2">
                                <div class="w-6 h-6 bg-pink-500 rounded text-white text-xs flex items-center justify-center font-bold">F</div>
                                <span class="text-sm font-semibold text-gray-800">Fix Platform Errors</span>
                            </div>
                        </td>
                        <td class="py-3 px-4">
                            <div class="flex -space-x-2">
                                <img class="w-6 h-6 rounded-full border border-white" src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24'%3E%3Crect fill='%23EC4899' width='24' height='24'/%3E%3C/svg%3E" alt="user">
                            </div>
                        </td>
                        <td class="py-3 px-4"><span class="text-sm font-semibold text-gray-800">Not set</span></td>
                        <td class="py-3 px-4">
                            <div class="w-full bg-gray-200 rounded-full h-2 max-w-xs">
                                <div class="bg-green-500 h-2 rounded-full" style="width: 100%"></div>
                            </div>
                            <p class="text-xs text-gray-600 mt-1">100%</p>
                        </td>
                    </tr>

                    <!-- Project 4 -->
                    <tr class="border-b border-gray-100 hover:bg-gray-50">
                        <td class="py-3 px-4">
                            <div class="flex items-center gap-2">
                                <div class="w-6 h-6 bg-green-500 rounded text-white text-xs flex items-center justify-center font-bold">L</div>
                                <span class="text-sm font-semibold text-gray-800">Launch our Mobile App</span>
                            </div>
                        </td>
                        <td class="py-3 px-4">
                            <div class="flex -space-x-2">
                                <img class="w-6 h-6 rounded-full border border-white" src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24'%3E%3Crect fill='%2310B981' width='24' height='24'/%3E%3C/svg%3E" alt="user">
                            </div>
                        </td>
                        <td class="py-3 px-4"><span class="text-sm font-semibold text-gray-800">$20,500</span></td>
                        <td class="py-3 px-4">
                            <div class="w-full bg-gray-200 rounded-full h-2 max-w-xs">
                                <div class="bg-green-500 h-2 rounded-full" style="width: 100%"></div>
                            </div>
                            <p class="text-xs text-gray-600 mt-1">100%</p>
                        </td>
                    </tr>

                    <!-- Project 5 -->
                    <tr class="border-b border-gray-100 hover:bg-gray-50">
                        <td class="py-3 px-4">
                            <div class="flex items-center gap-2">
                                <div class="w-6 h-6 bg-blue-400 rounded text-white text-xs flex items-center justify-center font-bold">A</div>
                                <span class="text-sm font-semibold text-gray-800">Add the New Pricing Page</span>
                            </div>
                        </td>
                        <td class="py-3 px-4">
                            <div class="flex -space-x-2">
                                <img class="w-6 h-6 rounded-full border border-white" src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24'%3E%3Crect fill='%2360A5FA' width='24' height='24'/%3E%3C/svg%3E" alt="user">
                            </div>
                        </td>
                        <td class="py-3 px-4"><span class="text-sm font-semibold text-gray-800">$500</span></td>
                        <td class="py-3 px-4">
                            <div class="w-full bg-gray-200 rounded-full h-2 max-w-xs">
                                <div class="bg-orange-500 h-2 rounded-full" style="width: 25%"></div>
                            </div>
                            <p class="text-xs text-gray-600 mt-1">25%</p>
                        </td>
                    </tr>

                    <!-- Project 6 -->
                    <tr class="hover:bg-gray-50">
                        <td class="py-3 px-4">
                            <div class="flex items-center gap-2">
                                <div class="w-6 h-6 bg-red-500 rounded text-white text-xs flex items-center justify-center font-bold">R</div>
                                <span class="text-sm font-semibold text-gray-800">Redesign New Online Shop</span>
                            </div>
                        </td>
                        <td class="py-3 px-4">
                            <div class="flex -space-x-2">
                                <img class="w-6 h-6 rounded-full border border-white" src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24'%3E%3Crect fill='%23EF4444' width='24' height='24'/%3E%3C/svg%3E" alt="user">
                            </div>
                        </td>
                        <td class="py-3 px-4"><span class="text-sm font-semibold text-gray-800">$2,000</span></td>
                        <td class="py-3 px-4">
                            <div class="w-full bg-gray-200 rounded-full h-2 max-w-xs">
                                <div class="bg-orange-500 h-2 rounded-full" style="width: 40%"></div>
                            </div>
                            <p class="text-xs text-gray-600 mt-1">40%</p>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>  
    </div>
</layout:tag>