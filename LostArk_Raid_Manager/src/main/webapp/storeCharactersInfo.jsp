<%@page import="java.util.List"%>
<%@page import="user_character.User_character"%>
<%@page import="java.util.ArrayList"%>
<%@page import="user_character.User_characterDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="java.net.HttpURLConnection" %>
<%@ page import="java.net.URL" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="org.json.JSONObject" %>

<%
    String apiUrl = "https://developer-lostark.game.onstove.com/characters/{characterName}/siblings";
    String apiKey = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IktYMk40TkRDSTJ5NTA5NWpjTWk5TllqY2lyZyIsImtpZCI6IktYMk40TkRDSTJ5NTA5NWpjTWk5TllqY2lyZyJ9.eyJpc3MiOiJodHRwczovL2x1ZHkuZ2FtZS5vbnN0b3ZlLmNvbSIsImF1ZCI6Imh0dHBzOi8vbHVkeS5nYW1lLm9uc3RvdmUuY29tL3Jlc291cmNlcyIsImNsaWVudF9pZCI6IjEwMDAwMDAwMDAzNDMzOTMifQ.bjHVrz0ftmu2jhjPUvF32DRNPOA_xzYSkaqpw3AVVgsNHDWWa4QITyG-u9AcrPUMV8z4FwOFUE2meXJweUANMd5Bts9o1W8D-Jon0kMKViHlsy4rLZXbv7WBCGB6Qx-nPbdGSBtBfkBtObrh5PZe3z65Mq2rpt63fVZEBhKntW7XIF0bPRX4AK_c3UtW8d2gjlrvJt3WoL38kOOM8OtCGToD5CY9_uvaNbp7SH2iO3p6hg2_sCTXOlhCislLY1nD2feKbx31dDbIlreShu1J8shuUK1g3H85Hi1NIciOSRGbArPJWqsY3UiYu8r2hV8mY_F5hixsHsFAwCxZU5s71A"; // 실제 API 키를 여기에 입력
    String characterName = request.getParameter("characterName"); // 입력받은 대표 캐릭터 이름

    if (characterName == null || characterName.trim().isEmpty()) {
        out.println("<p>캐릭터 이름이 전달되지 않았습니다.</p>");
        return;
    }

    try {
        String encodedName = java.net.URLEncoder.encode(characterName, "UTF-8");

        URL url = new URL(apiUrl.replace("{characterName}", encodedName));
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("accept", "application/json");
        conn.setRequestProperty("Authorization", "Bearer " + apiKey);

        int responseCode = conn.getResponseCode();
        if (responseCode == 200) { // API 응답 성공 -> 200
            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
            String inputLine;
            StringBuffer response1 = new StringBuffer();

            while ((inputLine = in.readLine()) != null) {
                response1.append(inputLine);
            }
            in.close();

            JSONArray siblingsArray = new JSONArray(response1.toString());
            
            ArrayList<User_character> characters = new ArrayList<>();

            for (int i = 0; i < siblingsArray.length(); i++) {
                JSONObject sibling = siblingsArray.getJSONObject(i);
                User_character character = new User_character();
                character.setCharacter_ID(i + 1);
                character.setIs_Main_Character(sibling.getString("CharacterName").equals(characterName));
                character.setItem_Level(sibling.getString("ItemAvgLevel"));
                character.setCharacter_Name(sibling.getString("CharacterName"));
                character.setCharacter_Class_Name(sibling.getString("CharacterClassName"));
                character.setServer_Name(sibling.getString("ServerName"));

                characters.add(character);
            }
			User_characterDAO userdao = new User_characterDAO();
			boolean result = userdao.saveCharacters(characters);
			session.setAttribute("result", result);
        } else {
            out.println("<p>API 요청 실패. 응답 코드: " + responseCode + "</p>");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<p>에러 발생: " + e.getMessage() + "</p>");
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>캐릭터 정보 저장</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-900 text-gray-100 min-h-screen flex items-center justify-center">
    <div class="bg-gray-800 border border-gray-700 p-6 rounded-lg text-center w-96">
        <h2 class="text-2xl font-bold mb-4">캐릭터 정보 저장</h2>
        
        <%
        	boolean result = (boolean) session.getAttribute("result");
            if (result) {
        %>
            <p class="text-gray-400 mb-6">
                캐릭터 정보가 성공적으로 저장되었습니다. 다음 작업을 선택하세요.
            </p>
            <div class="flex flex-col gap-4">
                <form method="post" action="todoListUpdate.jsp" class="w-full">
                    <button type="submit" 
                            class="w-full px-4 py-2 bg-blue-600 text-white rounded-lg text-lg font-semibold hover:bg-blue-700">
                        숙제 리스트 생성하기
                    </button>
                </form>

                <form method="post" action="deleteCharactersInfo.jsp" class="w-full">
                    <button type="submit" 
                            class="w-full px-4 py-2 bg-red-600 text-white rounded-lg text-lg font-semibold hover:bg-red-700">
                        저장 취소
                    </button>
                </form>
            </div>
        <%
            } else {
        %>
            <p class="text-red-400 mb-6">
                캐릭터 정보를 저장하는 데 실패했습니다. 다시 시도하거나 관리자에게 문의하세요.
            </p>
            <div class="flex flex-col gap-4">
                <button onclick="history.back()" 
                        class="w-full px-4 py-2 bg-yellow-600 text-white rounded-lg text-lg font-semibold hover:bg-yellow-700">
                    다시 시도
                </button>
            </div>
        <%
            }
        %>
    </div>
</body>
</html>
