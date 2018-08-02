<%@ page import="wx.util.ComUtil" %>
<%@ page import="wx.GetAuthentication" %>
<%@ page import="net.sf.json.JSONObject" %>
 <%-- Created by IntelliJ IDEA.
  User: lighter
  Date: 18-7-3
  Time: 下午2:11
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta name="viewport" content="width=device-width,initial-scale=1,user-scalable=no" charset="UTF-8">
    <script src="../../vendor/jquery-3.3.1.js"></script>
    <title>不良事件管理平台</title>
</head>

<style>
    *{
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
        top: 20%;
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

    input[name=depUserId] {
        width: 80%;
        height: 20%;
        margin-top: 9%;
        position: relative;
    }
</style>

<body>

<%
    String token=ComUtil.getAccessToken(2);
    String depUserId = request.getParameter("depUserId");
    String depUserName = "";
    try {
        String code=request.getParameter("code");
        depUserId=GetAuthentication.getInstance().getUserId(code,token);
    } catch (Exception e) { }

    try {
        JSONObject userInfo = GetAuthentication.getInstance().getUserInfo(depUserId, token);
        depUserName = userInfo.getString("name");
    } catch (Exception e) { }

    session.setAttribute("depUserId", depUserId);
    session.setAttribute("depUserName", depUserName);
%>


<div id="parent">

    <div id="child_btn">
        <button onclick="onClick(1)">未查看</button>
        <button onclick="onClick(2)">已查看（未处理）</button>
        <button onclick="onClick(3)">已处理</button>
    </div>

    <form id="signInForm" action="" method="post">
        <input name="depUserId" placeholder="自动获取失败，请在此输入您的工号"><br><br><hr><br>
        <input type="submit" value="提交">
    </form>

</div>

</body>

<script>

    window.onload=function () {
        var userId =<%=depUserId%>;
        console.log("userId: "+userId);
        if (userId == null) {
            $("#signInForm").show();
            var btns = document.getElementsByTagName("button");
            for (var i = 0; i<btns.length; i++)
                btns[i].disabled="disabled";
        }
    }

    function onClick(index) {
        var url="./list.jsp?index="+index;
        window.open(url,"_self");
    }
</script>

</html>
