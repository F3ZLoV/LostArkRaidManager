<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="java.net.HttpURLConnection" %>
<%@ page import="java.net.URL" %>
<%@ page import="org.json.JSONObject" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>캐릭터 확인</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-gray-900 text-gray-100">
<%
    String apiUrl = "https://developer-lostark.game.onstove.com/armories/characters/{characterName}/profiles";
    String apiKey = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IktYMk40TkRDSTJ5NTA5NWpjTWk5TllqY2lyZyIsImtpZCI6IktYMk40TkRDSTJ5NTA5NWpjTWk5TllqY2lyZyJ9.eyJpc3MiOiJodHRwczovL2x1ZHkuZ2FtZS5vbnN0b3ZlLmNvbSIsImF1ZCI6Imh0dHBzOi8vbHVkeS5nYW1lLm9uc3RvdmUuY29tL3Jlc291cmNlcyIsImNsaWVudF9pZCI6IjEwMDAwMDAwMDAzNDMzOTMifQ.bjHVrz0ftmu2jhjPUvF32DRNPOA_xzYSkaqpw3AVVgsNHDWWa4QITyG-u9AcrPUMV8z4FwOFUE2meXJweUANMd5Bts9o1W8D-Jon0kMKViHlsy4rLZXbv7WBCGB6Qx-nPbdGSBtBfkBtObrh5PZe3z65Mq2rpt63fVZEBhKntW7XIF0bPRX4AK_c3UtW8d2gjlrvJt3WoL38kOOM8OtCGToD5CY9_uvaNbp7SH2iO3p6hg2_sCTXOlhCislLY1nD2feKbx31dDbIlreShu1J8shuUK1g3H85Hi1NIciOSRGbArPJWqsY3UiYu8r2hV8mY_F5hixsHsFAwCxZU5s71A";    String characterName = request.getParameter("characterName"); // 전달받은 캐릭터 이름

    if (characterName == null || characterName.trim().isEmpty()) {
%>
    <div class="flex justify-center items-center h-screen">
        <div class="bg-gray-800 border border-gray-700 p-6 rounded-lg text-center">
            <p class="text-white text-lg">캐릭터 이름이 전달되지 않았습니다. 이전 페이지로 돌아가 입력해주세요.</p>
            <button onclick="history.back()" class="px-4 py-2 bg-red-600 text-white rounded-lg mt-4">돌아가기</button>
        </div>
    </div>
<%
    } else {
        try {
            String encodedName = java.net.URLEncoder.encode(characterName, "UTF-8");
            URL url = new URL(apiUrl.replace("{characterName}", encodedName));
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("accept", "application/json");
            conn.setRequestProperty("Authorization", "Bearer " + apiKey);

            int responseCode = conn.getResponseCode();
            if (responseCode == 200) {
                BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
                String inputLine;
                StringBuilder response1 = new StringBuilder();
                while ((inputLine = in.readLine()) != null) {
                    response1.append(inputLine);
                }
                in.close();

                JSONObject responseObject = new JSONObject(response1.toString());
%>
	<div class="flex justify-center items-center h-screen">
	    <div class="bg-gray-800 border border-gray-700 p-6 rounded-lg text-center w-96">
	        <h2 class="text-xl font-bold text-white mb-4">캐릭터 확인</h2>
	        <div class="flex justify-center mb-4">
	            <div class="w-32 h-32 rounded-full overflow-hidden border-4 border-blue-500">
	                <img 
	                    src="<%= responseObject.getString("CharacterImage") %>" 
	                    alt="캐릭터 이미지" 
	                    class="w-full h-full object-cover"
	                />
	            </div>
	        </div>
	        <h3 class="text-lg font-semibold text-white"><%= responseObject.getString("CharacterName") %></h3>
	        <p class="text-sm text-gray-400"><%= responseObject.getString("CharacterClassName") %></p>
	        <p class="text-lg mt-2">아이템 레벨: <span class="text-yellow-400"><%= responseObject.getString("ItemAvgLevel") %></span></p>
	        <p class="text-sm text-gray-400 mt-4">이 캐릭터가 맞나요?</p>
	        <div class="flex gap-4 mt-4">
	            <form action="storeCharactersInfo.jsp" method="get" class="flex-1">
	                <input type="hidden" name="characterName" value="<%= responseObject.getString("CharacterName") %>">
	                <button 
	                    type="submit" 
	                    class="w-full px-4 py-3 bg-green-600 text-white rounded-lg text-lg font-semibold hover:bg-green-700">
	                    확인
	                </button>
	            </form>
	            <form onsubmit="history.back(); return false;" class="flex-1">
	                <button 
	                    type="submit" 
	                    class="w-full px-4 py-3 bg-red-600 text-white rounded-lg text-lg font-semibold hover:bg-red-700">
	                    취소
	                </button>
	            </form>
	        </div>
	    </div>
	</div>



<%
            } else {
%>
    <div class="flex justify-center items-center h-screen">
        <div class="bg-gray-800 border border-gray-700 p-6 rounded-lg text-center">
            <p class="text-white text-lg">캐릭터 정보를 불러오는 데 실패했습니다. 응답 코드: <%= responseCode %></p>
            <button onclick="history.back()" class="px-4 py-2 bg-red-600 text-white rounded-lg mt-4">돌아가기</button>
        </div>
    </div>
<%
            }
        } catch (Exception e) {
            e.printStackTrace();
%>
    <div class="flex justify-center items-center h-screen">
        <div class="bg-gray-800 border border-gray-700 p-6 rounded-lg text-center">
            <p class="text-white text-lg">에러 발생: <%= e.getMessage() %></p>
            <button onclick="history.back()" class="px-4 py-2 bg-red-600 text-white rounded-lg mt-4">돌아가기</button>
        </div>
    </div>
<%
        }
    }
%>
</body>
</html>
