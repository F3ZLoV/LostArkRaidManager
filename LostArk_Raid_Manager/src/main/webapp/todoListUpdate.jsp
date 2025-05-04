<%@ page import="user_character.User_character"%>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List"%>
<%@ page import="todo.TodoDAO"%>
<%@ page import="raid.RaidDAO"%>
<%@ page import="user_character.User_characterDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>숙제 생성 중...</title>
</head>
<body class="min-h-screen bg-gray-900 text-gray-100">
<%
    User_characterDAO characterDAO = new User_characterDAO();
    RaidDAO raidDAO = new RaidDAO();
    TodoDAO todoDAO = new TodoDAO();

    List<User_character> characters = characterDAO.getCharacters();

    for (User_character character : characters) {
        int characterID = character.getCharacter_ID();
        String cleanedItemLevel = character.getItem_Level().replace(",", "");
        Double itemLevelDouble = Double.parseDouble(cleanedItemLevel);

        int itemLevel = itemLevelDouble.intValue();
        List<Integer> matchingRaids = raidDAO.getMatchingRaids(itemLevel);

        // TodoList 업데이트
        boolean success = todoDAO.createTodoEntries(characterID, matchingRaids);
        if (!success) {
            out.println("Failed to create todos for character ID: " + characterID);
        }
    }

	response.sendRedirect("mainPageLoa.jsp");
%>

</body>
</html>
