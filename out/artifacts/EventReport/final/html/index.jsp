<%@ page import="wx.util.ComUtil" %>
<%@ page import="wx.GetAuthentication" %>
<%@ page import="net.sf.json.JSONObject" %><%--
  Created by IntelliJ IDEA.
  User: lighter
  Date: 18-7-3
  Time: 下午2:20
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<head>
    <meta name="viewport" content="width=device-width,initial-scale=1,user-scalable=no" charset="UTF-8">
    <link rel="stylesheet" href="../css/jquery.treeview.css">
    <script type="text/javascript" src="../../vendor/jquery-3.3.1.js"></script>
    <script type="text/javascript" src="../js/jquery.treeview.js" id="treeViewJs"></script>
    <title>统计</title>
</head>
<body>

<%
    String finalUserId=request.getParameter("finalUserId");
    String finalUserName="";
    String token=ComUtil.getAccessToken(3);
    try {
        String code = request.getParameter("code");
        finalUserId = GetAuthentication.getInstance().getUserId(code,token);
    } catch (Exception e) { }

    try {
        JSONObject userInfo = GetAuthentication.getInstance().getUserInfo(finalUserId, token);
        finalUserName = userInfo.getString("name");
    } catch (Exception e) { }

    session.setAttribute("finalUserId", finalUserId);
    session.setAttribute("finalUserName", finalUserName);

%>

<div id="main">
    <ul id="treeview" class="filetree">
        <li><span class="folder">报告统计&nbsp;&nbsp;<span name="report_number">(0)</span></span></span>

            <ul id="tree" class="none">

                <li><span class="folder">护理安全事件&nbsp;&nbsp;<span name="report_number">(0)</span></span>
                    <ul name="report_list" class="none">
                    </ul>
                </li>

                <li><span class="folder">设备管理事件&nbsp;&nbsp;<span name="report_number">(0)</span></span>
                    <ul name="report_list" class="none">
                    </ul>
                </li>

                <li><span class="folder">医疗安全事件&nbsp;&nbsp;<span name="report_number">(0)</span></span>
                    <ul name="report_list" class="none">
                    </ul>
                </li>

                <li><span class="folder">药品安全事件&nbsp;&nbsp;<span name="report_number">(0)</span></span>
                    <ul name="report_list" class="none">
                    </ul>
                </li>

                <li><span class="folder">用血安全事件&nbsp;&nbsp;<span name="report_number">(0)</span></span>
                    <ul name="report_list" class="none">
                    </ul>
                </li>

                <li><span class="folder">输血反应事件&nbsp;&nbsp;<span name="report_number">(0)</span></span>
                    <ul name="report_list" class="none">
                    </ul>
                </li>

                <li><span class="folder">手术安全事件&nbsp;&nbsp;<span name="report_number">(0)</span></span>
                    <ul name="report_list" class="none">
                    </ul>
                </li>

                <li><span class="folder">医疗事故及纠纷事件&nbsp;&nbsp;<span name="report_number">(0)</span></span>
                    <ul name="report_list" class="none">
                    </ul>
                </li>

                <li><span class="folder">消毒、隔离事件&nbsp;&nbsp;<span name="report_number">(0)</span></span>
                    <ul name="report_list" class="none">
                    </ul>
                </li>

                <li><span class="folder">医疗废物事件&nbsp;&nbsp;<span name="report_number">(0)</span></span>
                    <ul name="report_list" class="none">
                    </ul>
                </li>

                <li><span class="folder">传染病管理事件&nbsp;&nbsp;<span name="report_number">(0)</span></span>
                    <ul name="report_list" class="none">
                    </ul>
                </li>

                <li><span class="folder">其他事件&nbsp;&nbsp;<span name="report_number">(0)</span></span>
                    <ul name="report_list" class="none">
                    </ul>
                </li>

            </ul>

        </li>
    </ul>
</div>

<div><a id="viewExcel" class="bottomDiv" href="statistics.jsp">查看报表</a></div>

<form id="signInForm" action="" method="post">
    <input name="finalUserId" placeholder="自动获取失败，请在此输入您的工号"><br><br><hr><br>
    <input type="submit" value="提交">
</form>

</body>
</html>

<style>
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

    input[name=finalUserId] {
        width: 80%;
        height: 20%;
        margin-top: 9%;
        position: relative;
    }

</style>

<script>
    window.onload=function() {
        $("#treeview").treeview();
        if (<%=finalUserId==null%>) {
            $("#signInForm").show();
            document.getElementById("viewExcel").href="";
        }
        else
            queryStatistics();
    }

    function queryStatistics() {
        var xmlhttp;
        if (window.XMLHttpRequest)
            xmlhttp=new XMLHttpRequest();
        else
            xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");

        xmlhttp.onreadystatechange=function() {
            if (xmlhttp.readyState==4 && xmlhttp.status==200) {
                var msg=xmlhttp.responseText;
                analyzeStatistics(msg);
            }
        }
        xmlhttp.open("GET","/EventReport/QueryStatistics",true);
        xmlhttp.setRequestHeader("Content-Type","application/json;charset=UTF-8");
        xmlhttp.send();
    }

    var jArray;
    function analyzeStatistics(msg) {
        jArray=JSON.parse(msg);

        for (var i=0; i<jArray.length; i++) {
            makeCategoryList(jArray[i].category, i);
        }

        fillDataOnView();
    }

    var evt_ylaq=[],evt_sbgl=[],evt_hlaq=[],evt_ypaq=[],evt_yxaq=[],evt_sxfy=[],evt_ylsgjjf=[],
        evt_xdgl=[],evt_ssaq=[],evt_ylfw=[],evt_crbgl=[],evt_others=[];

    function makeCategoryList(category,index) {
        var simpCat = category.split("-")[0];
        switch (simpCat) {
            case "护理安全事件":
                evt_hlaq[evt_hlaq.length]=jArray[index];
                break;
            case "设备管理事件":
                evt_sbgl[evt_sbgl.length]=jArray[index];
                break;
            case "医疗安全事件":
                evt_ylaq[evt_ylaq.length]=jArray[index];
                break;
            case "药品安全事件":
                evt_ypaq[evt_ypaq.length]=jArray[index];
                break;
            case "用血安全事件":
                evt_yxaq[evt_yxaq.length]=jArray[index];
                break;
            case "输血反应事件":
                evt_sxfy[evt_sxfy.length]=jArray[index];
                break;
            case "医疗事故及纠纷事件":
                evt_ylsgjjf[evt_ylsgjjf.length]=jArray[index];
                break;
            case "消毒、隔离事件":
                evt_xdgl[evt_xdgl.length]=jArray[index];
                break;
            case "手术安全事件":
                evt_ssaq[evt_ssaq.length]=jArray[index];
                break;
            case "医疗废物事件":
                evt_ylfw[evt_ylfw.length]=jArray[index];
                break;
            case "传染病管理事件":
                evt_crbgl[evt_crbgl.length]=jArray[index];
                break;
            case "其他事件":
                evt_others[evt_others.length]=jArray[index];
                break;
        }
    }

    function fillDataOnView() {
        var categoryList=[evt_hlaq,evt_sbgl,evt_ylaq,evt_ypaq,evt_yxaq,evt_sxfy,
            evt_ssaq,evt_ylsgjjf,evt_xdgl,evt_ylfw, evt_crbgl,evt_others];

        var numChildren=document.getElementsByName("report_number"); // 显示报告数量的控件
        var listChildren=document.getElementsByName("report_list"); // 包含报告文件li标签的ul标签

        var totalNum=0;
        for (var i=0; i<categoryList.length; i++) {
            // numChildren从1开始，第0位是所有报告的总数
            numChildren[i+1].innerText="("+categoryList[i].length+")";
            totalNum+=categoryList[i].length;

            var temp=categoryList[i];
            for (var j=0; j<temp.length; j++) {
                var text=temp[j].date+"-"+temp[j].department;
                var liNode=document.createElement("li");
                liNode.setAttribute("name","file_list");
                liNode.setAttribute("id",temp[j].p_id);
                var aNode=document.createElement("a");
                aNode.className="file";
                aNode.href="new_report.jsp?pid="+liNode.id;
                aNode.target="_blank";
                var textNode=document.createTextNode(text);
                aNode.appendChild(textNode);
                liNode.appendChild(aNode);
                listChildren[i].appendChild(liNode);
            }
        }
        numChildren[0].innerText="("+totalNum+")";
    }
</script>
