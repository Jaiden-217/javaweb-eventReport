<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<head>
    <meta name="viewport" content="width=device-width,initial-scale=1,user-scalable=no" charset="UTF-8">
    <title>历史上报</title>
    <script type="text/javascript" src="../../vendor/jquery-3.3.1.js"></script>
</head>

<style>
    *{
        margin: 0;
        padding: 0;
    }

    li{
        height: 35px;
        width: 98%;
        margin-left: 1%;
        padding-left: 10px;
        line-height: 35px;
        list-style: none;
        border: 1px solid lightskyblue;
        margin-top: 5px;
    }

    /*input{*/
        /*float: right;*/
        /*margin-top: 5px;*/
        /*margin-right: 10px;*/
        /*height: 25px;*/
        /*width: 50px;*/
        /*border: 1px solid gray;*/
        /*border-radius: 3px;*/
        /*text-align: center;*/
        /*color: #ffffff;*/
        /*position: absolute;*/
    /*}*/

    input[name=handled]{
        margin-top: 5px;
        right: 1px;
        height: 25px;
        width: 50px;
        border: 1px solid gray;
        border-radius: 3px;
        text-align: center;
        color: #ffffff;
        position: absolute;
    }

    input[name=accepted]{
        margin-top: 5px;
        right: 60px;
        height: 25px;
        width: 50px;
        border: 1px solid gray;
        border-radius: 3px;
        text-align: center;
        color: #ffffff;
        position: absolute;
    }

</style>

<body>

<%
    String user_id = request.getParameter("user_id");
%>

<div>
    <ul id="h_list" name="h_list">

    </ul>
</div>

</body>

<script>
    window.onload=function () {
        var xmlhttp;
        if (window.XMLHttpRequest) {
            //  IE7+, Firefox, Chrome, Opera, Safari 浏览器执行代码
            xmlhttp=new XMLHttpRequest();
        } else {
            // IE6, IE5 浏览器执行代码
            xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
        }
        xmlhttp.onreadystatechange=function() {
            if (xmlhttp.readyState==4 && xmlhttp.status==200) {
                var msg=xmlhttp.responseText;
                analyzeHistory(msg);
            }
        }
        xmlhttp.open("GET","/EventReport/GetHistoryList?user_id=<%=user_id%>",true);
        xmlhttp.send();
    }

    var history_json;
    function analyzeHistory(history) {
        if (history.length<4) {
            document.write("暂无当前工号的历史记录。")
            return;
        } else if (history.length<8) {
            document.write("查询失败，请稍后再试。");
            return;
        }

        history_json=JSON.parse(history);

        for (var i=0; i<history_json.length; i++) {
            var child_json=history_json[i];

            var list_child="<li id='"+child_json.p_id+"' onclick='onListClicked(this)'>"
                +child_json.date+" - "+child_json.category+

                "<input name='accepted' style='background-color: "+bgForAcceptedOrHandled(child_json.accepted)+"'"+
                " type='text' readonly='readonly' value='" + isAccepted(child_json.accepted) + "'/>" +

                "<input name='handled' style='background-color: "+bgForAcceptedOrHandled(child_json.handled)+"'"+
                " type='text' readonly='readonly' value='" + isHandled(child_json.handled) + "'/>" +

                "</li>";
            $("#h_list").append(list_child);

        }
    }

    function isAccepted(param) {
        if (param==0)
            return "未查看";
        else
            return "已查看";
    }

    function isHandled(param) {
        if (param==0)
            return "未处理";
        else
            return "已处理";
    }

    function bgForAcceptedOrHandled(param) {
        if (param==0)
            return "#CDCDCD";
        else
            return "#57CF4F";
    }

    function onListClicked(e) {
        var url="history_detail.jsp?pid="+e.id;
        window.open(url, "_self");
    }

</script>

</html>
