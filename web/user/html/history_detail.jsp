<%--
  Created by IntelliJ IDEA.
  User: lighter
  Date: 18-7-25
  Time: 上午10:04
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta name="viewport" content="width=device-width,initial-scale=1,user-scalable=no" charset="UTF-8">
    <title>详细信息</title>
    <link rel="stylesheet" href="../css/report.css">
    <script src="../../vendor/jquery-3.3.1.js"></script>
    <script src="../../vendor/jquery-form.js"></script>
    <script src="../../vendor/public-tool.js"></script>
</head>

<style>
    #con>div>input{
        width: 49%;
        height: 30px;
        float: left;
        line-height: 30px;
        background: rgba(153, 153, 153, 0.22);
    }
    /*ul,li{*/
        /*list-style: none;*/
        /*margin-left: 10px;*/
    /*}*/

</style>

<body>

<%
    String pid = request.getParameter("pid");
%>
<div id="con">
    <input type="hidden" name="pid" id="pid" value=<%=pid%>>
    <div class="department happen">
        <i class="note">*</i>
        <span>事件类型</span>
        <input disabled='disabled' type="text" id="category" name="category">
    </div>
    <div class="date happen">
        <i class="note">*</i>
        <span>发生日期</span>
        <input disabled='disabled' type="date" id="date" name="date" >
    </div>
    <div class="time happen">
        <i class="note">*</i>
        <span>发生时间</span>
        <input disabled='disabled' type="time" id="time" name="time">
    </div>
    <div class="department happen">
        <i class="note">*</i>
        <span>发生科室</span>
        <input disabled='disabled' type="text" id="department" name="department">
    </div>
    <div class="mode">
        <i class="note">*</i>
        <span>事件经过</span>
        <textarea disabled='disabled' cols="30" rows="10" id="course" name="course" ></textarea>
    </div>
    <div class="mode">
        <i class="note">*</i>
        <span>事件结果</span>
        <textarea disabled='disabled' cols="30" rows="10" id="result" name="result" ></textarea>
    </div>
    <div class="analysis">
        <i class="note">*</i>
        <span>原因分析</span>
        <br><br>
        <h4>护士因素:</h4>

        <ul id="nurse_reason">

        </ul>

        <br><hr class="hrDiv"><br>

        <h4>病人因素:</h4>

        <ul id="patient_reason">

        </ul>

        <br><hr class="hrDiv"><br>

        <h4>环境因素:</h4>

        <ul id="environ_reason">

        </ul>

        <br><hr class="hrDiv"><br>

        <h4>管理因素:</h4>

        <ul id="manage_reason">

        </ul>

        <br><hr class="hrDiv"><br>
    </div>

    <div class="measures">
        <i class="note">*</i>
        <span>改进措施</span>
        <br><br>
        <h4>护士因素:</h4>

        <ul id="pro_nurse">

        </ul>

        <br><hr class="hrDiv"><br>

        <h4>病人因素:</h4>

        <ul id="pro_patient">

        </ul>

        <br><hr class="hrDiv"><br>

        <h4>环境因素:</h4>

        <ul id="pro_environ">

        </ul>

        <br><hr class="hrDiv"><br>

        <h4>管理因素:</h4>

        <ul id="pro_manage">

        </ul>

        <br><hr class="hrDiv"><br>
    </div>
    <div class="name happen">
        <span>提交人姓名</span>
        <input disabled='disabled' id="user_name" name="user_name"  style="width: 40%; height: 25px; text-align: center">
    </div>
    <div class="number happen">
        <span>提交人工号</span>
        <input disabled='disabled' id="user_id" name="user_id"  style="width: 40%; height: 25px; text-align: center">
    </div>

    <div id="deal_div" class="mode">
        <i class="note">*</i>
        <span>科室处理意见</span>
        <textarea disabled='disabled' cols="30" rows="10" id="department_dealing" name="dep_dealing" ></textarea>

        <div id="dep_dealer_info" class="dealer_info_div">
            处理人：<input id="dep_dealer_name" disabled="disabled" value="" class="dealer_name">&nbsp;&nbsp;&nbsp;&nbsp;
            处理时间：<input id="dep_deal_time" disabled="disabled" value="" class="deal_time">
        </div>
    </div>

    <div class="mode">
        <i class="note">*</i>
        <span>护理部意见</span>
        <textarea disabled='disabled' cols="30" rows="10" id="final_dealing" name="final_dealing" ></textarea>
        <div id="final_dealer_info" class="dealer_info_div">
            处理人：<input id="final_dealer_name" disabled="disabled" value="" class="dealer_name">&nbsp;&nbsp;&nbsp;&nbsp;
            处理时间：<input id="final_deal_time" disabled="disabled" value="" class="deal_time">
        </div>
    </div>

    <div class="subBtn">
        <button id="modifyBtn" onclick="goModify(1,<%=pid%>)">前往修改</button>
        <button onclick="javascript:history.back(-1);">返回</button>
    </div>
</div>

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
                loadData(msg,1);
            }
        }

        xmlhttp.open("POST","/EventReport/GetHistoryList?pid=<%=pid%>",true);
        xmlhttp.send();
    }


</script>