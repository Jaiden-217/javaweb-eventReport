<%--
  Created by IntelliJ IDEA.
  User: lighter
  Date: 18-8-1
  Time: 下午3:47
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta name="viewport" content="width=device-width,initial-scale=1,user-scalable=no" charset="UTF-8">
    <link rel="stylesheet" href="../css/report_excel.css">
    <script type="text/javascript" src="../../vendor/jquery-3.3.1.js"></script>
    <title>报表</title>
</head>
<body>

<div>
    <input type="date" id="date" oninput="onInputEvent()">
    <select id="department" oninput="onInputEvent()">
        <option value="所有科室">所有科室</option>
        <option value="一病室">一病室</option>
        <option value="二病室">二病室</option>
        <option value="三病室">三病室</option>
        <option value="四病室">四病室</option>
        <option value="五病室">五病室</option>
        <option value="六病室">六病室</option>
        <option value="六一病室">六一病室</option>
        <option value="七病室">七病室</option>
        <option value="八病室">八病室</option>
        <option value="九病室">九病室</option>
        <option value="十病室">十病室</option>
        <option value="十一病室">十一病室</option>
        <option value="十二病室">十二病室</option>
        <option value="十八病室">十八病室</option>
        <option value="十九病室">十九病室</option>
        <option value="二十病室">二十病室</option>
        <option value="ICU护理">ICU</option>
        <option value="血液净化中心">血液净化中心</option>
        <option value="手术室">手术室</option>
        <option value="消毒供应室">供应室</option>
        <option value="放射科">放射科</option>
        <option value="急诊护理">急诊科</option>
        <option value="高压氧科">高压氧科</option>
        <option value="信息中心">信息中心</option>
    </select>
    <a id="dlink" style="display: none;"></a>
    <button id="export" onclick="exeExportDataToExcel()">导出Excel</button>
</div>

<table id="mTable" name="mTable">
    <tr>
        <th>编号</th>
        <th>发生时间</th>
        <th>提交时间</th>
        <th>姓名</th>
        <th>科室</th>
        <th>事件类型</th>
        <th>已受理</th>
        <th>已处理</th>
        <th>处理人</th>
        <th>操作</th>
    </tr>
</table>
</body>
</html>

<script>
    window.onload=function () {
        queryStatistics();
    }

    function queryStatistics() {
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
                analyzeStatistics(msg);
            }
        }
        xmlhttp.open("GET","/EventReport/QueryStatistics",true);
        xmlhttp.setRequestHeader("Content-Type","application/json;charset=UTF-8");
        xmlhttp.send();
    }

    var dataArray;
    function analyzeStatistics(msg) {
        dataArray=JSON.parse(msg);

        $("#mTable tr").eq(0).nextAll().remove(); //先清除表格数据，只保留表头
        for (var i=0; i<dataArray.length; i++) {
            makeTable(i);
        }
    }

    function makeTable(index) {
        var json=dataArray[index];
        var pid=json.p_id;
        var date=json.date;
        var time=json.time;
        var submit_time = json.submit_time;
        var name=json.user_name;
        var department=json.department;
        var category=json.category;
        var accepted=getBoolean(json.accepted);
        var handled=getBoolean(json.handled);

        var charger_name=handled=="是"?json.dep_leader_name:"-";

        var html="<tr><td id="+pid+"><a href='new_report.jsp?pid="+pid+"'>"+pid+"</a></td>" +
            "<td>"+date+"&nbsp;"+time+"</td>" +
            "<td>"+submit_time+"</td>" +
            "<td>"+name+"</td>" +
            "<td>"+department+"</td>" +
            "<td>"+category+"</td>" +
            "<td>"+accepted+"</td>" +
            "<td>"+handled+"</td>" +
            "<td>"+charger_name+"</td>" +
            "<td><a href='new_report.jsp?pid="+pid+"'>查看</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href='#1' onclick='delReport("+pid+")'>删除</a></td></tr>";
        $("#mTable tbody").append(html);
    }

    function getBoolean(param) {
        if (param==0)
            return "否";
        else
            return "是";
    }

    function onInputEvent() {
        var date=document.getElementById("date").value;
        var department=document.getElementById("department").value;
        queryOnTip(date,department);
    }

    function queryOnTip(date,dep) {
        var xmlhttp;
        if (window.XMLHttpRequest) {
            xmlhttp=new XMLHttpRequest();
        } else {
            xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
        }
        xmlhttp.onreadystatechange=function() {
            if (xmlhttp.readyState==4 && xmlhttp.status==200) {
                var msg=xmlhttp.responseText;
                analyzeStatistics(msg);
            }
        }
        xmlhttp.open("POST","/EventReport/QueryStatistics?date="+date+"&dep="+dep,true);
        xmlhttp.setRequestHeader("Content-Type","application/json;charset=UTF-8");
        xmlhttp.send();
    }

    function delReport(pid) {
        var warn = confirm("删除后将无法恢复，确定执行删除？");
        if (warn == true) {
            var xmlhttp;
            if (window.XMLHttpRequest)
                xmlhttp = new XMLHttpRequest();
            else
                xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
            xmlhttp.onreadystatechange=function () {
                if (xmlhttp.readyState==4 && xmlhttp.status==200) {
                    var msg = xmlhttp.responseText;
                    alert(msg);
                    location.reload();
                }
            }
            xmlhttp.open("GET","/EventReport/DeleteReport?pid="+pid,true);
            xmlhttp.send();
        }
    }

    /**
     * table数据导出到excel
     * 形参 table  : tableId ;
     *      sheetName : 工作薄名
     *      fileName  : 文件名
     *      linkId    ：隐藏的链接控件id
     */

    var tableToExcel = (function () {
        var uri = 'data:application/vnd.ms-excel;base64,',
            template =
                '<html xmlns:o="urn:schemas-microsoft-com:office:office" ' +
                'xmlns:x="urn:schemas-microsoft-com:office:excel" ' +
                'xmlns="http://www.w3.org/TR/REC-html40"><head>' +
                '<!--[if gte mso 9]><xml><x:ExcelWorkbook>' +
                '<x:ExcelWorksheets><x:ExcelWorksheet><x:Name>{worksheet}' +
                '</x:Name><x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions>' +
                '</x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml>' +
                '<![endif]--></head><body><table>{table}</table></body></html>',
            base64 = function (s) {
                return window.btoa(unescape(encodeURIComponent(s)));
            },
            format = function (s, c) {
                return s.replace(/{(\w+)}/g, function (m, p) { return c[p]; });
            }
        return function (table, sheetName, fileName,linkId) {
            if (!table.nodeType)
                table = document.getElementById(table);
            var ctx = { worksheet: sheetName || 'Worksheet', table: table.innerHTML }
            var dlinkInfo = document.getElementById(linkId);
            dlinkInfo.href = uri + base64(format(template, ctx));
            dlinkInfo.download = fileName;
            dlinkInfo.click();
        }
    })();

    var exeExportDataToExcel = function () {
        var sheetName = "sheet";
        var fileName = "test.xls";
        tableToExcel("mTable", sheetName, fileName, "dlink");
    }
</script>
