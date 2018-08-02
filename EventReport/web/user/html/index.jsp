<%@ page import="wx.util.ComUtil" %>
<%@ page import="wx.GetAuthentication" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="mysql.MySqlUtil" %>
<%--
  Created by IntelliJ IDEA.
  User: lighter
  Date: 18-7-2
  Time: 下午3:31
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta name="viewport" content="width=device-width,initial-scale=1,user-scalable=no" charset="UTF-8">
    <title>不良事件管理平台</title>
    <script src="../../vendor/jquery-3.3.1.js"></script>
</head>

<style>
    * {
        padding: 0;
        margin: 0;
    }

    body {
        width: 100%;
        height: 100%;
    }

    div[id=parent] {
        width: 100%;
        height: 100%;
        text-align: center;
        position: fixed;
    }

    div[id=child_btn] {
        width: 50%;
        height: 30%;
        line-height: 30%;
        top: 35%;
        left: 25%;
        position: fixed;
    }

    button {
        width: 100%;
        height: 50px;
        line-height: 50px;
        background: rgba(153, 153, 153, 0.22);
        outline: none;
        margin-top: 30px;
    }

    form {
        position: fixed;
        width: 80%;
        height: 30%;
        left: 10%;
        top: 35%;
        background-color: #cdcdcd;
        border: 2px solid sandybrown;
        text-align: center;
        display: none;
    }

    input[type=submit] {
        width: 80%;
        height: 30%;
        position: relative;
    }

    input[name=userId] {
        width: 80%;
        height: 20%;
        margin-top: 9%;
        position: relative;
    }

</style>

<body>

<%
    String token = ComUtil.getAccessToken(1);
    String userId = request.getParameter("userId");
    String userName = "";
    int depId = -1;
    String department = "";
    try {
        String code = request.getParameter("code");
        userId = GetAuthentication.getInstance().getUserId(code, token);
    } catch (Exception e) { }

    try {

        JSONObject userInfo = GetAuthentication.getInstance().getUserInfo(userId, token);
        userName = userInfo.getString("name");

        JSONArray dep = userInfo.getJSONArray("department");
        depId = Integer.parseInt(dep.get(0).toString());
        department = GetAuthentication.getInstance().getDepartment(token, depId);
        MySqlUtil.queryLeaderInfo(request, department);
    } catch (Exception e) {}

    session.setAttribute("userId", userId);
    session.setAttribute("userName", userName);
    session.setAttribute("departmentId", depId);
    session.setAttribute("department", department);

%>

<div id="parent">

    <div id="child_btn">
        <button id="event" onclick="report()">事件上报</button>
        <button id="history" onclick="history()">历史记录</button>
    </div>

    <form id="signInForm" action="" method="post">
        <input name="userId" placeholder="自动获取失败，请在此输入您的工号"><br><br><hr><br>
        <input type="submit" value="提交">
    </form>

</div>

</body>
</html>

<script>
    window.onload = function () {
        var userId =<%=userId%>;
        console.log("userId: "+userId);
        if (userId == null) {
            $("#signInForm").show();
            document.getElementById("event").disabled="disabled";
            document.getElementById("history").disabled="disabled";
        }
    }

    function report() {
        var url = "report.jsp";
        window.open(url);
    }

    function history() {
        var historyUrl = "history_list.jsp?user_id=" +<%=session.getAttribute("userId") %>;
        window.open(historyUrl);
    }

</script>
