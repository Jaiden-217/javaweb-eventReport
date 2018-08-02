<%@ page import="java.io.InputStream" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="mysql.MySqlUtil" %><%--
  Created by IntelliJ IDEA.
  User: lighter
  Date: 18-7-25
  Time: 上午10:07
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta name="viewport" content="width=device-width,initial-scale=1,user-scalable=no" charset="UTF-8">
    <title>修改</title>
    <link rel="stylesheet" href="../css/report.css">
    <script src="../../vendor/jquery-3.3.1.js"></script>
    <script src="../../vendor/jquery-form.js"></script>

    <style>
        input[type=date]::-webkit-inner-spin-button { visibility: hidden; }
        input[type=time] {
            width: 100px;}
    </style>
</head>
<body>

<%
    int p_id = Integer.parseInt(request.getParameter("pid"));
    String jsonMsg = MySqlUtil.queryItemDetail(p_id, false).replaceAll("\\\\n", "  ");
%>

<form id="update_form" name="update_form" method="post" action="/EventReport/UpdateReport" onsubmit="return updateClicked()">
    <div class="box" id="confirmBox" >
        <table id="confirmTable" class="confirmTable">
            <tr>
                <td colspan="2">将提交到：</td>
            </tr>
            <tr>
                <td colspan="2" id="depDisplay" style="color: red;"><%=session.getAttribute("department")%>:<%=session.getAttribute("leader_name")%></td>
            </tr>
            <tr>
                <td colspan="2">确认提交？</td>
            </tr>
            <tr>
                <td><input name="confirmInput" type="button" value="否" onclick="hideConfirmBox()"></td>
                <td><input name="confirmInput" type="submit" value="是"></td>
            </tr>
        </table>
    </div>
    <div class="box" id="boxFarther1">
        <div class="boxChild">
            执行中...请稍候...
        </div>
    </div>
    <input type="hidden" name="pid" value="<%=p_id%>">
    <div id="con">
        <div class="happen">
            <i class="note">*</i>
            <span>事件类型</span>
            <select id="category" name="category">
                <optgroup id="group_first" label="护理安全事件">
                    <option value="护理安全事件-发错药物">发错药物</option>
                    <option value="护理安全事件-配错药物">配错药物</option>
                    <option value="护理安全事件-换错药物">换错药物</option>
                    <option value="护理安全事件-意外拔（脱）管">意外拔（脱）管</option>
                    <option value="护理安全事件-跌倒坠床">跌倒坠床</option>
                    <option value="护理安全事件-堵管事件">堵管事件</option>
                    <option value="护理安全事件-走失事件">走失事件</option>
                    <option value="护理安全事件-漏执行医嘱">漏执行医嘱</option>
                    <option value="护理安全事件-执行医嘱错误">执行医嘱错误</option>
                    <option value="护理安全事件-输液（血）外渗（漏）">输液（血）外渗（漏）</option>
                    <option value="护理安全事件-院内发生压疮或漏报（未报难免压床）">院内发生压疮或漏报（未报难免压床）</option>
                    <option value="护理安全事件-物品丢失">物品丢失</option>
                    <option value="护理安全事件-用物混用">用物混用</option>
                    <option value="护理安全事件-条码贴错">条码贴错</option>
                    <option value="护理安全事件-采血管（对象）错误">采血管（对象）错误</option>
                    <option value="护理安全事件-被投诉事件">被投诉事件</option>
                    <option value="护理安全事件-错送病室">错送病室</option>
                    <option value="护理安全事件-精一类安剖（贴）丢弃">精一类安剖（贴）丢弃</option>
                    <option value="护理安全事件-烫伤事件">烫伤事件</option>
                    <option value="护理安全事件-用物准备不全">用物准备不全</option>
                    <option value="护理安全事件-其他">其他</option>
                </optgroup>
                <optgroup label="设备管理事件">
                    <option value="设备管理事件">设备管理事件</option>
                </optgroup>
                <optgroup label="医疗安全事件">
                    <option value="医疗安全事件">医疗安全事件</option>
                </optgroup>
                <optgroup label="药品安全事件">
                    <option value="药品安全事件">药品安全事件</option>
                </optgroup>
                <optgroup label="用血安全事件">
                    <option value="用血安全事件">用血安全事件</option>
                </optgroup>
                <optgroup label="输血反应事件">
                    <option value="输血反应事件">输血反应事件</option>
                </optgroup>
                <optgroup label="医疗事故及纠纷事件">
                    <option value="医疗事故及纠纷事件">医疗事故及纠纷事件</option>
                </optgroup>
                <optgroup label="消毒、隔离事件">
                    <option value="消毒、隔离事件">消毒、隔离事件</option>
                </optgroup>
                <optgroup label="手术安全事件">
                    <option value="手术安全事件">手术安全事件</option>
                </optgroup>
                <optgroup label="医疗废物事件">
                    <option value="医疗废物事件">医疗废物事件</option>
                </optgroup>
                <optgroup label="传染病管理事件">
                    <option value="传染病管理事件">传染病管理事件</option>
                </optgroup>
                <optgroup label="其他事件">
                    <option value="其他事件">其他事件</option>
                </optgroup>
            </select>
        </div>
        <div class="happen">
            <i class="note">*</i>
            <span>发生日期</span>
            <input type="date" id="date" name="date" >
        </div>
        <div class="happen">
            <i class="note">*</i>
            <span>发生时间</span>
            <input type="time" id="time" name="time">
        </div>
        <div class="happen">
            <i class="note">*</i>
            <span>发生科室</span>
            <select id="department" name="department" value="<%=session.getAttribute("department")%>">
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
        </div>
        <div class="mode">
            <i class="note">*</i>
            <span>事件经过</span>
            <textarea cols="30" rows="10" id="course" name="course"></textarea>
        </div>
        <div class="mode">
            <i class="note">*</i>
            <span>事件结果与补救措施</span>
            <textarea cols="30" rows="10" id="result" name="result"></textarea>
        </div>
        <div class="mode">
            <i class="note">*</i>
            <span>原因分析</span><br><br>
            <h4>护士因素:</h4>
            <br>
            <div class="divAboveSelect">
                <select id="nurse_reason" name="nurse_reason" multiple="multiple" size="4">
                    <option value="护士年轻，经验不足" >1.护士年轻，经验不足</option>
                    <option value="业务知识缺乏" >2.业务知识缺乏</option>
                    <option value="技术水平低" >3.技术水平低</option>
                    <option value="操作技术不规范" >4.操作技术不规范</option>
                    <option value="核心制度落实不到位" >5.核心制度落实不到位</option>
                    <option value="不严于职守，责任心不强" >6.不严于职守，责任心不强</option>
                    <option value="思想不重视" >7.思想不重视</option>
                    <option value="主动学习意识不强" >8.主动学习意识不强</option>
                    <option value="安全意识淡薄" >9.安全意识淡薄</option>
                    <option value="宣教、沟通不到位" >10.宣教、沟通不到位</option>
                    <option value="风险防范及预见性不足" >11.风险防范及预见性不足</option>
                    <option value="不遵守规章制度" >12.不遵守规章制度</option>
                    <option value="违反操作规程" >13.违反操作规程</option>
                    <option value="评估不到位" >14.评估不到位</option>
                    <option value="带教不规范" >15.带教不规范</option>
                    <option value="医患及医护沟通不到位" >16.医患及医护沟通不到位</option>
                </select>
            </div>
            <br>
            <div class="divUnderSelect">其他:<input type="text" id="nurse_reason_ex" name="nurse_reason"></div>
            <br><hr class="hrDiv"><br>

            <h4>病人因素:</h4>
            <br>
            <div class="divAboveSelect">
                <select id="patient_reason" name="patient_reason" multiple="multiple">
                    <option value="病人依从性差" >1.病人依从性差</option>
                    <option value="知识缺乏" >2.知识缺乏</option>
                    <option value="不遵守医院规章制度" >3.不遵守医院规章制度</option>
                    <option value="经济条件不好欠费未及时交费" >4.经济条件不好欠费未及时交费</option>
                    <option value="意识障碍" >5.意识障碍</option>
                    <option value="自理能力差" >6.自理能力差</option>
                    <option value="家属不关心，无陪护照顾" >7.家属不关心，无陪护照顾</option>
                    <option value="不配合床上大小便" >8.不配合床上大小便</option>
                    <option value="患者年龄大、病情重、管道多" >9.患者年龄大、病情重、管道多</option>
                    <option value="擅自调节滴速" >10.擅自调节滴速</option>
                    <option value="血管条件差" >11.管条件差</option>
                    <option value="自我评估过高" >12.自我评估过高</option>
                    <option value="不配合翻身" >13.不配合翻身</option>
                    <option value="不听劝告" >14.不听劝告</option>
                    <option value="不良心境、情绪不稳定" >15.不良心境、情绪不稳定</option>
                    <option value="自身素质差" >16.自身素质差</option>
                    <option value="期望值过高" >17.期望值过高</option>
                </select>
            </div>
            <br>
            <div class="divUnderSelect">其他:<input type="text" id="patient_reason_ex" name="patient_reason"></div>
            <br><hr class="hrDiv"><br>

            <h4>环境因素:</h4>
            <br>
            <div class="divAboveSelect">
                <select id="environ_reason" name="environ_reason" multiple="multiple">
                    <option value="病房空间小、家属陪人多" >1.病房空间小、家属陪人多</option>
                    <option value="地面湿滑" >2.地面湿滑</option>
                    <option value="标识不清楚或无相应标识" >3.标识不清楚或无相应标识</option>
                    <option value="坐便器少" >4.坐便器少</option>
                    <option value="光线较暗" >5.光线较暗</option>
                    <option value="病房温湿度不适宜、空调效果欠佳 " >6.病房温湿度不适宜、空调效果欠佳 </option>
                    <option value="床单不整洁" >7.床单不整洁</option>
                    <option value="病人周转快、科室忙 、工作量大" >8.病人周转快、科室忙 、工作量大</option>
                    <option value="更换床位或转科病人多" >9.更换床位或转科病人多</option>
                    <option value="上墙标准流程图及宣教资料少" >10.上墙标准流程图及宣教资料少</option>
                    <option value="药品种类多、药品标识不明显或两种药品标识相似度高" >11.药品种类多、药品标识不明显或两种药品标识相似度高</option>
                    <option value="存放药品空间小或放置位置不合理" >12.存放药品空间小或放置位置不合理</option>
                    <option value="仪器设备故障" >13.仪器设备故障</option>
                </select>
            </div>
            <br>
            <div class="divUnderSelect">其他:<input type="text" id="environ_reason_ex" name="environ_reason"></div>
            <br><hr class="hrDiv"><br>

            <h4>管理因素:</h4>
            <br>
            <div class="divAboveSelect">
                <select id="manage_reason" name="manage_reason" multiple="multiple">
                    <option value="不重视安全教育">1.不重视安全教育</option>
                    <option value="病室识别系统不完善">2.病室识别系统不完善</option>
                    <option value="人力配置不足，超负荷工作">3.人力配置不足，超负荷工作</option>
                    <option value="交接班流程不完善">4.交接班流程不完善</option>
                    <option value="护士长不在时无人主事">5.护士长不在时无人主事</option>
                    <option value="激励机制不健全">6.激励机制不健全</option>
                    <option value="后勤社会化服务不到位">7.后勤社会化服务不到位</option>
                    <option value="护士长监督力度不大，对重点环节、人群疏于管理">8.护士长监督力度不大，对重点环节、人群疏于管理</option>
                    <option value="管理者对存在风险缺乏预见性">9.管理者对存在风险缺乏预见性</option>
                    <option value="急于安排新护士单独上岗">10.急于安排新护士单独上岗</option>
                    <option value="职业道德教育薄弱">11.职业道德教育薄弱</option>
                    <option value="目标管理机制不健全">12.目标管理机制不健全</option>
                    <option value="人员培训机制不健全">13.人员培训机制不健全</option>
                    <option value="排班不合理">14.排班不合理</option>
                </select>
            </div>
            <br>
            <div class="divUnderSelect">其他:<input type="text" id="manage_reason_ex" name="manage_reason"></div>
            <br><hr class="hrDiv"><br>
        </div>
        <div class="mode">
            <i class="note">*</i>
            <span>改进措施</span><br><br>
            <h4>护士因素:</h4>
            <br>
            <div class="divAboveSelect">
                <select id="pro_nurse" name="pro_nurse" multiple="multiple">
                    <option value="提升护士业务技术水平" >1.提升护士业务技术水平</option>
                    <option value="规范操作规程" >2.规范操作规程</option>
                    <option value="加强慎独精神和责任心" >3.加强慎独精神和责任心</option>
                    <option value="严格落实护理核心制度" >4.严格落实护理核心制度</option>
                    <option value="提高认知和思想觉悟" >5.提高认知和思想觉悟</option>
                    <option value="加强风险意识、安全防范意识培训" >6.加强风险意识、安全防范意识培训</option>
                    <option value="加强对患者的宣教" >7.加强对患者的宣教</option>
                    <option value="遵守规章制度" >8.遵守规章制度</option>
                    <option value="强化评估意识" >9.强化评估意识</option>
                    <option value="规范带教行为" >10.规范带教行为</option>
                    <option value="加强医患及医护沟通" >11.加强医患及医护沟通</option>
                </select>
            </div>
            <br>
            <div class="divUnderSelect">其他:<input type="text" id="pro_nurse_ex" name="pro_nurse"></div>
            <br><hr class="hrDiv"><br>

            <h4>病人因素:</h4>
            <br>
            <div class="divAboveSelect">
                <select id="pro_patient" name="pro_patient" multiple="multiple">
                    <option value="强化安全意识" >1.强化安全意识</option>
                    <option value="加强营养" >2.加强营养</option>
                    <option value="配合医护人员" >3.配合医护人员</option>
                    <option value="稳定情绪" >4.稳定情绪</option>
                    <option value="聘请陪护，加强陪护管理" >5.聘请陪护，加强陪护管理</option>
                    <option value="适度床上活动" >6.适度床上活动</option>
                    <option value="保持皮肤清洁、干燥，床单位整洁" >7.保持皮肤清洁、干燥，床单位整洁</option>
                </select>
            </div>
            <br>
            <div class="divUnderSelect">其他:<input type="text" id="pro_patient_ex" name="pro_patient"></div>
            <br><hr class="hrDiv"><br>

            <h4>环境因素:</h4>
            <br>
            <div class="divAboveSelect">
                <select id="pro_environ" name="pro_environ" multiple="multiple">
                    <option value="严格探陪制度，每个患者仅留一个陪人" >1.严格探陪制度，每个患者仅留一个陪人</option>
                    <option value="患者活动前完成卫生处置，使用防滑垫" >2.患者活动前完成卫生处置，使用防滑垫</option>
                    <option value="制作并张贴相应标识牌；及时更换模糊不清的标识牌" >3.制作并张贴相应标识牌；及时更换模糊不清的标识牌</option>
                    <option value="申请增加坐便器数量" >4.申请增加坐便器数量</option>
                    <option value="保证病房照明设施处于正常工作状态" >5.保证病房照明设施处于正常工作状态</option>
                    <option value="未开放空调时，病房定时开窗，保证空气流通；及时联系工程部保证空调正常运行" >6.未开放空调时，病房定时开窗，保证空气流通；及时联系工程部保证空调正常运行</option>
                    <option value="及时更换不整洁床单" >7.及时更换不整洁床单</option>
                    <option value="护士长合理排班，增加助班缓解治疗高峰期人力不足情况" >8.护士长合理排班，增加助班缓解治疗高峰期人力不足情况</option>
                    <option value="规范转床与转科流程" >9.规范转床与转科流程</option>
                    <option value="科室常见疾病知识宣教及抢救流程图制作上墙" >10.科室常见疾病知识宣教及抢救流程图制作上墙</option>
                    <option value="科室备用药品分柜放置，定期清理，标识模糊的药品及时作废，标识相似的药品做特殊标识" >11.科室备用药品分柜放置，定期清理，标识模糊的药品及时作废，标识相似的药品做特殊标识</option>
                    <option value="合理放置药品位置，禁止囤积药品，多余药品及时回收至药房" >12.合理放置药品位置，禁止囤积药品，多余药品及时回收至药房</option>
                    <option value="及时联系设备科维修" >13.及时联系设备科维修</option>
                </select>
            </div>
            <br>
            <div class="divUnderSelect">其他:<input type="text" id="pro_environ_ex" name="pro_environ"></div>
            <br><hr class="hrDiv"><br>

            <h4>管理因素:</h4>
            <br>
            <div class="divAboveSelect">
                <select id="pro_manage" name="pro_manage" multiple="multiple">
                    <option value="进行安全教育培训，考试">1.进行安全教育培训，考试</option>
                    <option value="改进增加病室识别系统">2.改进增加病室识别系统</option>
                    <option value="增加护理人员，优化职称结构，年龄结构">3.增加护理人员，优化职称结构，年龄结构</option>
                    <option value="改进交接班流程，督查落实">4.改进交接班流程，督查落实</option>
                    <option value="护士长不在时指定临时负责护士，并担责">5.护士长不在时指定临时负责护士，并担责</option>
                    <option value="建立健全激励机制，提高工作积极性">6.建立健全激励机制，提高工作积极性</option>
                    <option value="与后勤管理部门积极沟通督促后勤社会化服务到位">7.与后勤管理部门积极沟通督促后勤社会化服务到位</option>
                    <option value="护士长加强检查内容、范围，落实对重点环节、人群的管理">8.护士长加强检查内容、范围，落实对重点环节、人群的管理</option>
                    <option value="管理者加强自身业务学习对存在风险进行干预">9.管理者加强自身业务学习对存在风险进行干预</option>
                    <option value="对于新护士进行综合考核，合格后方可单独上岗">10.对于新护士进行综合考核，合格后方可单独上岗</option>
                    <option value="加强职业道德方面的知识进行教育、培训、考核">11.加强职业道德方面的知识进行教育、培训、考核</option>
                    <option value="完善目标管理机制">12.完善目标管理机制</option>
                    <option value="完善人员培训机制">13.完善人员培训机制</option>
                    <option value="排班根据病人的病情，护士的能力进行合理的排班">14.排班根据病人的病情，护士的能力进行合理的排班</option>
                </select>
            </div>
            <br>
            <div class="divUnderSelect">其他:<input type="text" id="pro_manage_ex" name="pro_manage"></div>
            <br><hr class="hrDiv"><br>
        </div>
        <div class="subBtn">
            <input type="submit" value="提交">
        </div>
    </div>
</form>

</body>
</html>


<script>
    window.onload=function () {
        jsonMsg=JSON.parse('<%=jsonMsg%>');
        loadMsg();
    }
    
    var jsonMsg="{}";

    function loadMsg() {
        $("#category").val(jsonMsg.category);
        $("#date").val(jsonMsg.date);
        $("#time").val(jsonMsg.time);
        $("#department").val(jsonMsg.department);
        $("#course").val(jsonMsg.course);
        $("#result").val(jsonMsg.result);

        loadSelects("nurse_reason");
        loadSelects("patient_reason");
        loadSelects("environ_reason");
        loadSelects("manage_reason");
        loadSelects("pro_nurse");
        loadSelects("pro_patient");
        loadSelects("pro_environ");
        loadSelects("pro_manage");
    }

    function loadSelects(name) {
        var options = document.getElementById(name).options;
        var items = jsonMsg[name].split("|");
        for (var i = 0; i < items.length; i++) {

            for (var j = 0; j < options.length; j++) {

                if (items[i] == options[j].value){
                    options[j].selected = true;
                    continue;
                }

                if (i == items.length - 1 && j == options.length - 1) {
                    var exId = name+"_ex";
                    document.getElementById(exId).value=items[items.length-1];
                }
            }
        }


    }
    
    function updateClicked() {
        $("#boxFarther1").show();
        $("#update_form").ajaxSubmit(function (jsonMsg) {
            $("#boxFarther1").hide();
            alert(jsonMsg);
        });
        return false;
    }
</script>