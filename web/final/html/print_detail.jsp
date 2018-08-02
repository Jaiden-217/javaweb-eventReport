<%@ page import="mysql.MySqlUtil" %><%--
  Created by IntelliJ IDEA.
  User: lighter
  Date: 18-7-27
  Time: 下午3:40
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>打印预览</title>
    <meta name="viewport" content="width=device-width,initial-scale=1,user-scalable=no" charset="utf-8">
    <script src="../../vendor/jquery-3.3.1.js"></script>
</head>
<style>
    * {
        margin: 0;
        padding: 0;
    }

    table[name=title] {
        width: 100%;
        height: 5%;
        border: none;
    }

    .title_tr{
        border:none;
    }

    .title_td {
        height: 5%;
        vertical-align: center;
        text-align: center;
        font-size: 15px;
        font-weight: bold;
        border: none;
    }

    table[name=main] {
        width: 99.6%;
        height: 95%;
        margin-left: 0.2%;
        margin-right: 0.2%;
    }

    table ,tr, th, td {
        border: 1px solid black;
        border-collapse: collapse;
        text-align: center;
        vertical-align: center;
        word-break:break-all;
    }

    .top_td_label_narrow {
        width: 12%;
    }

    .top_td_label_wide {
        width: 15%;
    }

    .top_td_content_narrow {
        width: 10%;
    }

    .top_td_content_middle {
        width: 15%;
    }

    .top_td_content_wide {
        width: 33%;
    }

    .mid_td_narrow {
        width: 2%;
    }

    .textContent {
        text-align: left;
        padding-left: 10px;
        font-size: 13px;
    }

button {
    position: fixed;
    width: 80px;
    height: 35px;
    line-height: 35px;
    text-align: center;
    top: 46%;
    right: 1%;
}

</style>
<body>

<%
    int pid = Integer.parseInt(request.getParameter("pid"));
    String dataJson = MySqlUtil.queryItemDetail(pid, false).replaceAll("\\\\n"," ");
%>

<table name="title">
    <tr class="title_tr">
        <td colspan="7" class="title_td">不良事件上报表</td>
    </tr>
</table>

<table name="main">
    <tr>
        <th class="top_td_label_narrow" colspan="2">事件类型</th>
        <td id="category" class="top_td_content_wide">category</td>
        <th class="top_td_label_narrow">发生日期</th>
        <td id="date" class="top_td_content_middle">date</td>
        <th class="top_td_label_wide">提交人姓名</th>
        <td id="user_name" class="top_td_content_narrow">user_name</td>

    </tr>

    <tr>
        <th colspan="2">发生科室</th>
        <td id="department">department</td>
        <th>发生时间</th>
        <td id="time">time</td>
        <th>提交人工号</th>
        <td id="user_id">user_id</td>
    </tr>

    <tr>
        <th colspan="2">事件经过</th>
        <td colspan="5" id="course" class="textContent">course</td>
    </tr>

    <tr>
        <th colspan="2">事件结果及补救措施</th>
        <td colspan="5" id="result" class="textContent">result</td>
    </tr>

    <tr>
        <th rowspan="4" class="mid_td_narrow">原因分析</th>
        <th>护士因素</th>
        <td id="nurse_reason" colspan="5" class="textContent">nurse_reason</td>
    </tr>

    <tr>
        <th>病人因素</th>
        <td id="patient_reason" colspan="5" class="textContent">patient_reason</td>
    </tr>

    <tr>
        <th>环境因素</th>
        <td id="environ_reason" colspan="5" class="textContent">environ_reason</td>
    </tr>

    <tr>
        <th>管理因素</th>
        <td id="manage_reason" colspan="5" class="textContent">manage_reason</td>
    </tr>

    <tr>
        <th rowspan="4">改进措施</th>
        <th>护士因素</th>
        <td id="pro_nurse" colspan="5" class="textContent">pro_nurse</td>
    </tr>

    <tr>
        <th>病人因素</th>
        <td id="pro_patient" colspan="5" class="textContent">pro_patient</td>
    </tr>
    <tr>
        <th>环境因素</th>
        <td id="pro_environ" colspan="5" class="textContent">pro_environ</td>
    </tr>

    <tr>
        <th>管理因素</th>
        <td id="pro_manage" colspan="5" class="textContent">pro_manage</td>
    </tr>

    <tr>
        <th rowspan="2" colspan="2" style="padding-left: 10px;padding-right: 10px">科室处理意见</th>
        <td id="dep_dealing" rowspan="2" colspan="3" class="textContent">dep_dealing</td>
        <td id="dep_leader_name" colspan="2">处理人：dep_leader_name</td>
    </tr>

    <tr>
        <td id="dep_deal_time" colspan="2">处理时间：dep_deal_time</td>
    </tr>

    <tr>
        <th rowspan="2" colspan="2">护理部处理意见</th>
        <td id="final_dealing" rowspan="2" colspan="3" class="textContent">final_dealing</td>
        <td id="final_dealer_name" colspan="2">处理人：final_dealer_name</td>
    </tr>

    <tr>
        <td id="final_deal_time" colspan="2">处理时间：final_deal_time</td>
    </tr>
</table>
<button id="printBtn" onclick="printThis()">打印此页</button>

</body>
</html>

<script>

    var jsonMsg = "{}";

    window.onload=function () {
        jsonMsg = JSON.parse('<%=dataJson%>');
        loadMsg();
    }

    function loadMsg() {
        document.getElementById("category").innerText=jsonMsg.category;
        document.getElementById("date").innerText=jsonMsg.date;
        document.getElementById("time").innerText=jsonMsg.time;
        document.getElementById("department").innerText=jsonMsg.department;
        document.getElementById("course").innerText=jsonMsg.course;
        document.getElementById("result").innerText=jsonMsg.result;
        document.getElementById("user_name").innerText=jsonMsg.user_name;
        document.getElementById("user_id").innerText=jsonMsg.user_id;
        document.getElementById("dep_dealing").innerText=jsonMsg.dep_dealing;
        document.getElementById("final_dealing").innerText=jsonMsg.final_dealing;
        document.getElementById("dep_leader_name").innerText="处理人："+jsonMsg.dep_leader_name;
        document.getElementById("dep_deal_time").innerText="处理时间："+jsonMsg.dep_deal_time;
        document.getElementById("final_dealer_name").innerText="处理人："+jsonMsg.final_dealer_name;
        document.getElementById("final_deal_time").innerText="处理时间："+jsonMsg.final_deal_time;

        loadMsg_2("nurse_reason");
        loadMsg_2("patient_reason");
        loadMsg_2("environ_reason");
        loadMsg_2("manage_reason");
        loadMsg_2("pro_nurse");
        loadMsg_2("pro_patient");
        loadMsg_2("pro_environ");
        loadMsg_2("pro_manage");
    }

    function loadMsg_2(id) {
        if (jsonMsg[id] == undefined)
            return;
        var msg = jsonMsg[id].split("|");
        var temp = "";
        for (var i = 0; i < msg.length-1; i++) {
            temp = temp+(i+1)+"."+msg[i]+"； ";
        }

        var last = msg[msg.length-1];
        if (last!=undefined && last.length>0)
            temp = temp+(i+1)+"."+last;
        document.getElementById(id).innerText=temp;
    }

    function printThis() {
        $("#printBtn").hide();
        window.print();
        $("#printBtn").show();
    }
</script>