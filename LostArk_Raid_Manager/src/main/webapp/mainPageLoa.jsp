<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="todo.TodoDAO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>로스트아크 레이드 매니저</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-gray-900 text-gray-100">
<script>
	function toggleRaidStatus(characterID, raidID, isChecked) {
	    const xhr = new XMLHttpRequest();
	    xhr.open("POST", "UpdateTodoStatusServlet", true);
	    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	    xhr.onload = function () {
	        if (xhr.status === 200) {
	            try {
	                const response = JSON.parse(xhr.responseText);
	                console.log("Raw response:", xhr.responseText);
	                if (response.success) {
	                    console.log("Update successful");
	                    console.log("Response:", response);
	
	                    // 페이지 새로고침
	                    location.reload();
	                } else {
	                    alert("상태 업데이트 실패");
	                }
	            } catch (e) {
	                console.error("Failed to parse JSON response:", e);
	                alert("서버 오류 발생: 응답 파싱 실패");
	            }
	        } else {
	            alert("서버 오류 발생");
	        }
	    };
	
	    xhr.send("characterID=" + characterID + "&raidID=" + raidID + "&isCleared=" + isChecked);
	}
	
	
	function confirmDeletion() {
	    if (confirm("정말 캐릭터 정보를 삭제하시겠습니까?")) {
	        // 사용자가 확인을 누르면 deleteCharactersInfo.jsp로 이동
	        window.location.href = "deleteCharactersInfo.jsp";
	    }
	}
</script>
<%
    TodoDAO todoDAO = new TodoDAO();
    List<Map<String, Object>> todoList = todoDAO.getTodoList();

    Map<String, List<Map<String, Object>>> groupedTodos = new java.util.HashMap<>();
    for (Map<String, Object> todo : todoList) {
        String characterName = (String) todo.get("characterName");
        groupedTodos.computeIfAbsent(characterName, k -> new java.util.ArrayList<>()).add(todo);
    }

    Map<Integer, Integer> weeklyGoldMap = todoDAO.calculateWeeklyGold();
    int totalWeeklyGold = todoDAO.calculateTotalGold();

    request.setAttribute("weeklyGoldMap", weeklyGoldMap);
    request.setAttribute("totalWeeklyGold", totalWeeklyGold);
    request.setAttribute("groupedTodos", groupedTodos);
%>
	
	<nav class="bg-gray-800 p-4 flex items-center justify-between">
	    <div>
	        <h1 class="text-2xl font-bold text-white">로스트아크 레이드 매니저</h1>
	    </div>
	    <div>
	        <button 
	            onclick="confirmDeletion()"
	            class="bg-red-600 text-white px-4 py-2 rounded-lg hover:bg-red-700 transition"
	        >
	            캐릭터 삭제
	        </button>
	    </div>
	</nav>
	
	<main class="container mx-auto p-4">
	    <form method="post" action="UpdateTodoStatusServlet">
	        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
	            <!-- 캐릭터 섹션 -->
	            <c:forEach var="entry" items="${groupedTodos}">
	                <c:set var="characterName" value="${entry.key}" />
	                <c:set var="raids" value="${entry.value}" />
	                <div class="bg-gray-800 border-gray-700 p-4 rounded-lg">
	                    <div class="flex justify-between items-center">
					        <h2 class="text-lg font-semibold">${characterName}</h2>
					        <span class="text-sm bg-gray-600 text-white px-2 py-1 rounded-full">Lv. ${raids[0].itemLevel}</span>
					    </div>
					    <p class="text-sm text-gray-400">${raids[0].characterClassName}</p>
	                    <c:forEach var="raid" items="${raids}">
	                        <div class="mt-2 flex justify-between items-center bg-gray-700 p-2 rounded-lg">
	                            <div>
	                                <p>${raid.raidName}</p>
	                                <div class="flex items-center gap-2">
								        <img src="images/gold_icon.jpg" alt="골드" class="w-5 h-5" />
								        <p>${raid.raidGold} 골드</p>
								    </div>
	                            </div>
	                            <div>
	                                <input 
									    type="checkbox" 
									    id="checkbox-${raid.characterID}-${raid.raidID}" 
									    onchange="toggleRaidStatus(${raid.characterID}, ${raid.raidID}, this.checked)" 
									    class="w-6 h-6"
									    <c:if test="${raid.isCleared}">checked</c:if>
									/>
									<input type="hidden" name="isCleared-${raid.characterID}-${raid.raidID}" value="false" />
	                                <input type="hidden" name="characterID" value="${raid.characterID}" />
	                                <input type="hidden" name="raidID" value="${raid.raidID}" />
	                            </div>
	                        </div>
	                    </c:forEach>
	                    <!-- 캐릭터별 주간 골드 -->
						<div class="mt-4 bg-gray-600 p-2 rounded-lg flex justify-between items-center">
						    <span class="font-semibold">주간 골드 수입</span>
						    <span id="weekly-gold-${raids[0].characterID}" class="font-bold text-yellow-500">
							    ${weeklyGoldMap[raids[0].characterID] != null ? weeklyGoldMap[raids[0].characterID] : 0} 골드
							</span>
						</div>
	                </div>
	            </c:forEach>
	        </div>
	    </form>
		<!-- 전체 총 주간 골드 수입 -->
		<div class="mt-8 bg-gray-800 border-gray-700 p-4 rounded-lg text-center">
		    <h2 class="text-lg font-bold">전체 총 주간 골드 수입</h2>
		    <div class="flex justify-center items-center gap-2">
		        <img src="images/gold_icon.jpg" alt="골드" class="w-6 h-6" />
		        <p class="text-2xl font-bold text-yellow-500">${totalWeeklyGold} 골드</p>
		    </div>
		</div>
	</main>

</body>
</html>
