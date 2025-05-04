<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>로스트아크 레이드 매니저</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-slate-900 flex items-center justify-center p-4">
    <div class="w-full max-w-md bg-slate-800 border border-slate-700 rounded-lg shadow-lg">
        <div class="p-6">
            <h1 class="text-2xl font-bold text-white text-center mb-4">로스트아크 레이드 매니저</h1>
            <form action="checkCharacter.jsp" method="GET" class="space-y-4">
                <div>
                    <label for="characterName" class="block text-sm font-medium text-slate-200 mb-1">
                        대표 캐릭터 이름
                    </label>
                    <input
                        id="characterName"
                        name="characterName"
                        type="text"
                        placeholder="캐릭터 이름을 입력하세요"
                        class="w-full px-4 py-2 bg-slate-700 border border-slate-600 text-white placeholder-slate-400 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                        required
                    />
                </div>
                <button
                    type="submit"
                    class="w-full bg-blue-600 hover:bg-blue-700 text-white font-semibold py-2 px-4 rounded-md"
                >
                    검색
                </button>
            </form>
            <% if (request.getParameter("error") != null) { %>
                <div class="mt-4 p-4 bg-red-900 text-red-200 border border-red-800 rounded-md">
                    <p class="text-sm">오류: <%= request.getParameter("error") %></p>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>