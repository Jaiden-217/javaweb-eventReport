var jsonMsg;

function loadData(msg,flag) {
    jsonMsg=JSON.parse(msg);

    document.getElementById("category").value=jsonMsg.category;
    document.getElementById("date").value=jsonMsg.date;
    document.getElementById("time").value=jsonMsg.time;
    document.getElementById("department").value=jsonMsg.department;
    document.getElementById("course").value=jsonMsg.course;
    document.getElementById("result").value=jsonMsg.result;
    document.getElementById("user_name").value=jsonMsg.user_name;
    document.getElementById("user_id").value=jsonMsg.user_id;
    document.getElementById("department_dealing").value=jsonMsg.dep_dealing;
    document.getElementById("final_dealing").value=jsonMsg.final_dealing;

    displayList("nurse_reason");
    displayList("patient_reason");
    displayList("environ_reason");
    displayList("manage_reason");
    displayList("pro_nurse");
    displayList("pro_patient");
    displayList("pro_environ");
    displayList("pro_manage");

    if (flag == 2)
        readDepDealCookie();

    if (jsonMsg.handled == 1) {
        if (flag==3)
            document.getElementById("final_dealing").disabled='';
        document.getElementById("modifyBtn").disabled='disabled';
        showDealerInfo();
    }
}

function showDealerInfo() {
    $("#dep_dealer_info").show();
    $("#dep_dealer_name").val(jsonMsg.dep_leader_name);
    $("#dep_deal_time").val(jsonMsg.dep_deal_time);

    $("#final_dealer_info").show();
    $("#final_dealer_name").val(jsonMsg.final_dealer_name);
    $("#final_deal_time").val(jsonMsg.final_deal_time);
}

function displayList(id) {
    var ulNode = document.getElementById(id);
    var msg = jsonMsg[id].split("|");
    for (var i = 0; i < msg.length; i++) {
        if (msg[i].length>3) {
            var liNode = document.createElement("li");
            liNode.setAttribute("name",id);
            liNode.textContent = (i+1)+"."+msg[i];
            ulNode.appendChild(liNode);
        }
    }
}


// department-part
var pid_on_dep;
function sendDepQuery(flag, url) {
    var xmlhttp;
    if (window.XMLHttpRequest) {
        xmlhttp=new XMLHttpRequest();
    } else {
        xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
    }
    xmlhttp.onreadystatechange=function() {
        if (xmlhttp.readyState==4 && xmlhttp.status==200) {
            var msg=xmlhttp.responseText;
            if (flag==1) {
                loadData(msg,2);
            } else {
                var json=JSON.parse(msg);
                var result=json.result;
                var msg1=json.msg;
                jQuery("#boxFarther4").hide();
                alert(msg1);
                if (result=="OK"){
                    clearDepDealCookie();
                }
            }
        }
    }
    xmlhttp.open("POST",url,true);
    xmlhttp.send();
}

// 提交科室处理结果
function depSubmitClicked(depUserId,depUserName) {
    if (localStorage.depDealInput!=undefined && localStorage.depDealInput.length>0) {
        jQuery("#boxFarther4").show();
        var url="/EventReport/DepDeal?deal="+localStorage.depDealInput+"&pid="+pid_on_dep+"&depUserId="+depUserId+"&depUserName="+depUserName;
        sendDepQuery(2,url);
    } else {
        alert("请填写科室处理方式");
    }
}


// 跟随填写保存cookie
function onDepDealInput(e) {
    localStorage.depDealInput=e.value;
    console.log(e.value);
}

// 加载时读取cookie
function readDepDealCookie() {
    if (localStorage.depDealInput!=undefined)
        document.getElementById("department_dealing").value=localStorage.depDealInput;

}

// 清除缓存
function clearDepDealCookie() {
    localStorage.removeItem("depDealInput");
    window.history.back();
}

// 前往修改
function goModify(flag,pid) {
    var url = "../../user/html/modify_history.jsp?pid="+pid;
    if (flag==1)
        url = "./modify_history.jsp?pid="+pid;
    window.open(url,"_self");
}

// 打印
function printThis(flag,pid) {
    var url = "print_detail.jsp?pid="+pid;
    if (flag == 1)
        url = "../../final/html/print_detail.jsp?pid="+pid;
    window.open(url,"_self");
}
