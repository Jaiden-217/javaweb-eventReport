<%--
  Created by IntelliJ IDEA.
  User: lighter
  Date: 18-7-18
  Time: 下午2:46
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<head>
    <meta name="viewport" content="width=device-width,initial-scale=1,user-scalable=no" charset="UTF-8">
    <link rel="stylesheet" href="../css/list.css">
    <script type="text/javascript" src="../../vendor/jquery-3.3.1.js"></script>
    <title id="title"></title>
</head>
<body>
<%!
    private String action;
%>
<%
  action = request.getParameter("index");
%>

<ul id="m_list"></ul>
</body>
</html>

<script>
    window.onload=function () {
        var xmlhttp;
        if (window.XMLHttpRequest)
            xmlhttp=new XMLHttpRequest();
        else
            xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");

        xmlhttp.onreadystatechange=function() {
            if (xmlhttp.readyState==4 && xmlhttp.status==200) {
                var msg=xmlhttp.responseText;
                analyzeList(msg);
            }
        }
        xmlhttp.open("GET","/EventReport/QueryList?action=<%=action%>&depUserId=<%=session.getAttribute("depUserId")%>",true);
        xmlhttp.send();
    }

    var listJson;
    function analyzeList(json) {
        listJson=JSON.parse(json);

        if (listJson.length<1) {
            document.write("暂无此类记录");
            return;
        }

        for (var i=0; i<listJson.length; i++) {
            var child_json=listJson[i];
            var list_child="<li id='"+child_json.p_id+"' name='list_child' onclick='onListClicked(this)'>"
                +child_json.date+" - "+child_json.category+ "</li>";
            $("#m_list").append(list_child);
        }

    }

    function onListClicked(e) {
        var url="new_report.jsp?pid="+e.id;
        window.open(url,"_self");
    }
</script>