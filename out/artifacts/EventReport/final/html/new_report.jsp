<%@ page import="wx.util.ComUtil" %>
<%@ page import="wx.GetAuthentication" %>
<%@ page import="net.sf.json.JSONObject" %><%--
  Created by IntelliJ IDEA.
  User: lighter
  Date: 18-7-19
  Time: 上午9:01
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta name="viewport" content="width=device-width,initial-scale=1,user-scalable=no" charset="utf-8">
    <title id="title"></title>
    <link rel="stylesheet" href="../../user/css/report.css">
    <script src="../../vendor/jquery-3.3.1.js"></script>
    <script src="../../vendor/public-tool.js"></script>

    <style>
        input[type=date]::-webkit-inner-spin-button { visibility: hidden; }
        #con>div>input{
            width: 49%;
            height: 30px;
            float: left;
            line-height: 30px;
            background: rgba(153, 153, 153, 0.22);
        }
    </style>
</head>
<body>

<%
    String report_pid = request.getParameter("pid");
    Object idInSession = session.getAttribute("finalUserId");
    Object nameInSession = session.getAttribute("finalUserName");
    String finalUserId = idInSession!=null?idInSession.toString():null;
    String finalUserName = nameInSession!=null?nameInSession.toString():null;
    if (finalUserId == null) {
        String token = ComUtil.getAccessToken(3);
        finalUserId = request.getParameter("finalUserId");
        try {
            String code=request.getParameter("code");
            finalUserId=GetAuthentication.getInstance().getUserId(code,token);
        } catch (Exception e) { }
        try {
            JSONObject userInfo = GetAuthentication.getInstance().getUserInfo(finalUserId, token);
            finalUserName = userInfo.getString("name");
        } catch (Exception e) { }
        session.setAttribute("finalUserId", finalUserId);
        session.setAttribute("finalUserName", finalUserName);
    }
%>


<div class="box" id="boxFarther3">
    <div class="boxChild">
        执行中...请稍候...
    </div>
</div>
<div id="con">
    <div class="happen">
        <i class="note">*</i>
        <span>事件类型</span>
        <input disabled='disabled' type="text" id="category" name="category">
    </div>
    <div class="happen">
        <i class="note">*</i>
        <span>发生日期</span>
        <input disabled='disabled' type="date" id="date" name="date" >
    </div>
    <div class="happen">
        <i class="note">*</i>
        <span>发生时间</span>
        <input disabled='disabled' type="time" id="time" name="time">
    </div>
    <div class="happen">
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
    <div class="mode">
        <i class="note">*</i>
        <span>原因分析</span><br><br>
        <h4>护士因素:</h4>

        <ul id="nurse_reason">

        </ul>

        <br><br><hr class="hrDiv"><br>

        <h4>病人因素:</h4>

        <ul id="patient_reason">

        </ul>

        <br><br><hr class="hrDiv"><br>

        <h4>环境因素:</h4>

        <ul id="environ_reason">

        </ul>

        <br><br><hr class="hrDiv"><br>

        <h4>管理因素:</h4>

        <ul id="manage_reason">

        </ul>

        <br><br><hr class="hrDiv"><br>
    </div>

    <div class="mode">
        <i class="note">*</i>
        <span>改进措施</span><br><br>
        <h4>护士因素:</h4>

        <ul id="pro_nurse">

        </ul>

        <br><br><hr class="hrDiv"><br>

        <h4>病人因素:</h4>

        <ul id="pro_patient">

        </ul>

        <br><br><hr class="hrDiv"><br>

        <h4>环境因素:</h4>

        <ul id="pro_environ">

        </ul>

        <br><br><hr class="hrDiv"><br>

        <h4>管理因素:</h4>

        <ul id="pro_manage">

        </ul>

        <br><br><hr class="hrDiv"><br>
    </div>
    <div class="happen">
        <span>提交人姓名</span>
        <input disabled='disabled' id="user_name" name="user_name"  style="width: 40%; height: 25px; text-align: center">
    </div>
    <div class="happen">
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
        <textarea disabled='disabled' cols="30" rows="10" id="final_dealing" name="final_dealing" oninput="onFinalDealInput(this)" ></textarea>

        <div id="final_dealer_info" class="dealer_info_div">
            处理人：<input id="final_dealer_name" disabled="disabled" value="" class="dealer_name">&nbsp;&nbsp;&nbsp;&nbsp;
            处理时间：<input id="final_deal_time" disabled="disabled" value="" class="deal_time">
        </div>
    </div>
    <div class="subBtn">
        <button id="modifyBtn" onclick="goModify(3,<%=report_pid%>)">前往修改</button>
        <button onclick="submitFinalDeal()">提交</button>
        <button onclick="printThis(0,<%=report_pid%>)">生成打印样式</button>
    </div>

</div>

<form id="signInForm" action="" method="post">
    <input name="pid" type="hidden" value="<%=report_pid%>">;
    <input name="finalUserId" placeholder="自动获取失败，请在此输入您的工号"><br><br><hr><br>
    <input type="submit" id="signInSubmit" value="提交">
</form>

</body>

</html>

<script>
    window.onload=function () {
        if (<%=finalUserId==null%>) {
            $("#signInForm").show();
            document.getElementById("final_dealing").disabled="disabled";
            var btns = document.getElementsByTagName("button");
            for (var i=0; i<btns.length; i++)
                btns[i].disabled='disabled';
        } else {
            readFinalDealCookie();
            var servlet="/EventReport/QueryList?pid=<%=report_pid%>";
            sendFinalQuery(1,servlet,"POST");
        }
        console.log("id: <%=finalUserId%>, name: <%=finalUserName%>");
    }

    function sendFinalQuery(flag, url, method) {
        var xmlhttp;
        if (window.XMLHttpRequest)
            xmlhttp=new XMLHttpRequest();
        else
            xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");

        xmlhttp.onreadystatechange=function() {
            if (xmlhttp.readyState==4 && xmlhttp.status==200) {
                var msg=xmlhttp.responseText;
                if (flag==1) {
                    loadData(msg,3);
                } else {
                    var json=JSON.parse(msg);
                    var result=json.result;
                    var msg1=json.msg;
                    jQuery("#boxFarther3").hide();
                    alert(msg1);
                    if (result=="OK")
                        clearFinalDealCookie();
                }
            }
        }
        xmlhttp.open(method,url,true);
        xmlhttp.send();
    }

    // 提交护理部处理结果
    function submitFinalDeal() {
        if (localStorage.finalDeal!=undefined && localStorage.finalDeal.length>0) {
            jQuery("#boxFarther3").show();
            var url="/EventReport/DepDeal?deal="+localStorage.finalDeal+"&pid=<%=report_pid%>&finalUserId=<%=finalUserId%>&finalUserName=<%=finalUserName%>";
            sendFinalQuery(2,url,"GET");
        } else {
            alert("请填写护理部处理意见");
        }
    }


    // 跟随填写保存cookie
    function onFinalDealInput(e) {
        localStorage.finalDeal=e.value;
    }

    // 加载时读取cookie
    function readFinalDealCookie() {
        if (localStorage.finalDeal!=undefined)
            document.getElementById("final_dealing").value=localStorage.finalDeal;
    }

    // 清除缓存
    function clearFinalDealCookie() {
        localStorage.removeItem("finalDeal");
        window.history.back();
    }

</script>

<style>
    form[id=signInForm] {
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

    input[id=signInSubmit] {
        width: 80%;
        height: 30%;
        position: relative;
    }

    input[name=finalUserId] {
        width: 80%;
        height: 20%;
        margin-top: 9%;
        position: relative;
    }

</style>
