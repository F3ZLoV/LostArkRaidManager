<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="todo.TodoDAO" %>

<%
    TodoDAO todoDAO = new TodoDAO();
    boolean isDeleted = todoDAO.deleteAllData();
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>데이터 삭제</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-gray-900 text-gray-100">
    <nav class="bg-gray-800 p-4">
        <div class="container mx-auto">
            <h1 class="text-2xl font-bold text-white">로스트아크 레이드 매니저</h1>
        </div>
    </nav>

    <main class="container mx-auto p-4">
        <div class="bg-gray-800 border border-gray-700 p-6 rounded-lg text-center">
            <% if (isDeleted) { %>
                <h2 class="text-xl font-semibold text-green-500">데이터 삭제 완료</h2>
                <p class="text-gray-300 mt-2">모든 캐릭터와 관련 데이터가 성공적으로 삭제되었습니다.</p>
            <% } else { %>
                <h2 class="text-xl font-semibold text-red-500">데이터 삭제 실패</h2>
                <p class="text-gray-300 mt-2">데이터 삭제에 실패했습니다. 관리자에게 문의하세요.</p>
            <% } %>
            <div class="mt-6">
                <form action="searchCharacter.jsp">
                    <button 
                        type="submit" 
                        class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition">
                        캐릭터 검색으로 돌아가기
                    </button>
                </form>
            </div>
        </div>
    </main>
</body>
</html>
