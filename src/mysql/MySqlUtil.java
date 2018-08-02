package mysql;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import wx.send.SendWxInfo;
import wx.util.WxConstants;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

public class MySqlUtil {
    private static String URL="jdbc:mysql://www.dj0217.top:3306/event_report?useSSL=false&allowPublicKeyRetrieval=true&charSet=utf-8";
    private static String USER="root";
    private static String PASSWORD="123456";

    public static Connection getConn() throws ClassNotFoundException, SQLException {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn=DriverManager.getConnection(URL,USER,PASSWORD);
        return conn;
    }

    /**
     * 员工提交报告时写入数据库
     * */
    public static String loadIntoDatabase(HttpServletRequest req) {
        String category = req.getParameter("category");
        String date = req.getParameter("date");
        String time = req.getParameter("time");
        String department = req.getParameter("department");
        String course = req.getParameter("course");
        String result = req.getParameter("result");
        String[] nurse_reason = req.getParameterValues("nurse_reason");
        String[] patient_reason = req.getParameterValues("patient_reason");
        String[] environ_reason = req.getParameterValues("environ_reason");
        String[] manage_reason = req.getParameterValues("manage_reason");
        String[] pro_nurse = req.getParameterValues("pro_nurse");
        String[] pro_patient = req.getParameterValues("pro_patient");
        String[] pro_environ = req.getParameterValues("pro_environ");
        String[] pro_manage = req.getParameterValues("pro_manage");
        String user_name = req.getParameter("user_name");
        String user_id = req.getParameter("user_id");

        HttpSession session = req.getSession();
        int leader_id = Integer.parseInt(session.getAttribute("leader_id").toString());
        String leader_name = session.getAttribute("leader_name").toString();

        String t_id = String.valueOf(System.currentTimeMillis());
        String sql="insert into event_detail(t_id,category,date,time,submit_time,department,course,result,nurse_reason,patient_reason," +
                "environ_reason,manage_reason,pro_nurse,pro_patient,pro_environ,pro_manage,user_name," +
                "user_id,dep_leader_id,dep_leader_name,dep_dealing,final_dealing,accepted,handled,deleted) values ('"
                +t_id+"','"+category+"','"+date+"','"+time+"','"+getLocalTime()+"','"+department+"','"+course+"','"+result+"','"+
                compileList(nurse_reason)+"','"+compileList(patient_reason)+"','"+compileList(environ_reason)+"','"+compileList(manage_reason)+"','"+
                compileList(pro_nurse)+"','"+compileList(pro_patient)+"','"+compileList(pro_environ)+"','"+compileList(pro_manage)+"','"+user_name+"',"+
                user_id+","+leader_id+ ",'"+leader_name+"','未处理','未处理',"+0+","+0+","+0+")";

        Statement stmt= null;
        try {
            stmt = getConn().createStatement();
            stmt.execute(sql);
            sendToWx(t_id);
            return "提交成功";
        } catch (Exception e) {
            e.printStackTrace();
            return "提交失败";
        }
    }

    private static String compileList(String[] target) {
        StringBuilder builder = new StringBuilder();

        for (int i=0; i<target.length-1; i++)
            builder.append(target[i]+"|");
        builder.append(target[target.length-1]);

        return builder.toString();
    }

    /**
     * 根据科室名称查找科室领导
     * */
    public static boolean queryLeaderInfo(HttpServletRequest req,String dep_name) {
        String sql = "select id,leader_id,leader_name from department where name='"+dep_name+"'";

        try {
            Statement stmt = getConn().createStatement();
            ResultSet rs = stmt.executeQuery(sql);
            while (rs.next()) {
                int dep_id = rs.getInt("id");
                int leader_id = rs.getInt("leader_id");
                String leader_name = rs.getString("leader_name");
                HttpSession session = req.getSession();
                session.setAttribute("department", dep_name);
                session.setAttribute("leader_id", leader_id);
                session.setAttribute("leader_name", leader_name);
                session.setAttribute("new_department_id", dep_id);
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }

        return false;
    }

    /**
     * 员工提交报告后推送给科室主任，基本与写入报告到数据库同时发生
     * @param t_id （long转String）时间戳，报告刚提交时没有p_id（写入数据库后自动生成），只能根据t_id来查找报告
     * @return 容量为2的数组，0位是报告的p_id，1位是报告填写的科室主任的工号
     * */
    public static int[] getPidAndTouser(String t_id) {
        int[] result=new int[2];
        String sql="select p_id, dep_leader_id from event_detail where t_id='"+t_id+"'";
        try {
            Statement stmt=getConn().createStatement();
            ResultSet rs=stmt.executeQuery(sql);
            while (rs.next()) {
                result[0]=rs.getInt("p_id");
                result[1]=rs.getInt("dep_leader_id");
                return result;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    /**
     * 将刚提交的报告推送给科室主任和护理部
     * @param t_id 报告的时间戳
     * */
    private static void sendToWx(String t_id) {
        int[] info=getPidAndTouser(t_id);
        String touser=String.valueOf(info[1]);
        String toparty="";
        String totag="";
        String msgtype="text";
        int agentid=WxConstants.AGENTID;

        String mUrl="https://open.weixin.qq.com/connect/oauth2/authorize?appid=wwf0b23c8b36012b34&redirect_uri=" +
                "www.dj0217.top/EventReport/dep/html/new_report.jsp?pid="+info[0]+"&response_type=code&scope=snsapi_userinfo&agentid=1000030&state=STATE#wechat_redirect";

        String content="收到一条事件报告，请尽快处理。\n<a href='"+mUrl+"'>点击此处查看详情</a>";


        SendWxInfo.Send_msg(touser,toparty,totag,msgtype,agentid,content);
    }

    /**
     * 修改未处理的报告
     * */
    public static String updateReport(HttpServletRequest req) {
        String pid=req.getParameter("pid");
        String category = req.getParameter("category");
        String date = req.getParameter("date");
        String time = req.getParameter("time");
        String course = req.getParameter("course");
        String result = req.getParameter("result");
        String[] nurse_reason = req.getParameterValues("nurse_reason");
        String[] patient_reason = req.getParameterValues("patient_reason");
        String[] environ_reason = req.getParameterValues("environ_reason");
        String[] manage_reason = req.getParameterValues("manage_reason");
        String[] pro_nurse = req.getParameterValues("pro_nurse");
        String[] pro_patient = req.getParameterValues("pro_patient");
        String[] pro_environ = req.getParameterValues("pro_environ");
        String[] pro_manage = req.getParameterValues("pro_manage");

        String sql="update event_detail set category='"+category+"',date='"+date+"',time='"+time+"',course='"+course
                +"',result='"+result+"',nurse_reason='"+compileList(nurse_reason)
                +"',patient_reason='"+compileList(patient_reason)+"',environ_reason='"+compileList(environ_reason)
                +"',manage_reason='"+compileList(manage_reason)+"',pro_nurse='"+compileList(pro_nurse)
                +"',pro_patient='"+compileList(pro_patient)+"',pro_environ='"+compileList(pro_environ)
                +"',pro_manage='"+compileList(pro_manage)+"' where p_id='"+pid+"'";

        System.out.println(sql);

        try {
            Statement stmt = getConn().createStatement();
            stmt.execute(sql);
            return "修改成功";
        } catch (Exception e) {
            e.printStackTrace();
            return "修改失败";
        }
    }

    /**
     * 根据不同的参数从数据库查询相应的报告
     * @param user_id (整型): 工号，MIN_VALUE-科室主任查看不同状态的报告
     *                   MAX_VALUE-护理部查看统计报表
     *                   NORMAL_VALUE-员工查看自己的历史上报记录
     *
     * @param flag (整型)： 仅在workNumber=MIN_VALUE时生效，1-未查看过的报告，2-已查看但未处理的报告，3-已处理的报告
     *                     4-查看指定日期的报告，5-查看指定科室的报告
     *
     * @param tips (字符串)： 在workNumber=MIN_VALUE时生效，代表科室主任的工号
     *             在flag=4 OR flag=5时生效，4-tips为日期，5-tips为科室
     * */
    public static String queryFromDatabase(int user_id, int flag, String tips) {
        String sql;
        if (user_id==Integer.MIN_VALUE) {// 科室主任查看不同状态的报告
            sql = makeSql(flag, tips);
        } else if (user_id==Integer.MAX_VALUE) {// 护理部查看统计报表
            sql = "select * from event_detail where deleted=0";
        } else {
            sql = "select * from event_detail where deleted=0 and user_id="+user_id; // 用户查看自己的上报记录
        }
        return doQuery(sql);
    }

    public static String  doQuery(String sql) {
        try {
            Connection conn;
            ResultSet rs;
            conn=MySqlUtil.getConn();
            Statement stmt=conn.createStatement();
            rs=stmt.executeQuery(sql);
            ResultSetMetaData rsmd=rs.getMetaData();
            int col=rsmd.getColumnCount();
            while (rs.next()) {
                Map<String, String> map=new HashMap<>();
                for (int i=1; i<=col; i++) {
                    map.put(rsmd.getColumnName(i), rs.getString(i));
                }
                makeJson(map);
                map.clear();
            }
            rs.close();
            conn.close();
            return jsonArray.toString();
        } catch (Exception e) {
            e.printStackTrace();
            return "查询失败";
        } finally {
            jsonArray.clear();
        }
    }

    /**
     * 根据不同的参数生成相应的sql语句
     * @param flag @see queryFromDatabase
     * @param tips @see queryFromDatabase
     * */
    private static String makeSql(int flag, String tips) {
        String sql=null;
        switch (flag) {
            case 1:
                if (tips.equals("1137") || tips.equals("1488") || tips.equals("1290"))
                    sql="select * from event_detail where deleted=0 and accepted=0";
                else
                    sql="select * from event_detail where deleted=0 and accepted=0 and dep_leader_id='"+tips+"'";
                break;
            case 2:
                if (tips.equals("1137") || tips.equals("1488") || tips.equals("1290"))
                    sql="select * from event_detail where deleted=0 and accepted=1 and handled=0";
                else
                    sql="select * from event_detail where deleted=0 and accepted=1 and handled=0 and dep_leader_id='"+tips+"'";
                break;
            case 3:
                if (tips.equals("1137") || tips.equals("1488") || tips.equals("1290"))
                    sql="select * from event_detail where deleted=0 and handled=1";
                else
                    sql="select * from event_detail where deleted=0 and handled=1 and dep_leader_id='"+tips+"'";
                break;
            case 4:
                sql="select * from event_detail where deleted=0 and date='"+tips+"'";
                break;
            case 5:
                sql="select * from event_detail where deleted=0 and department='"+tips+"'";
                break;
        }
        return sql;
    }

    private static JSONArray jsonArray=new JSONArray();

    /**
     * 用查询到的数据生成json
     * @param map 目标数据
     * */
    private static void makeJson(Map<String,String> map) {
        JSONObject obj=new JSONObject();
        obj.putAll(map);
        jsonArray.add(obj);
    }


    /**
     * 根据不同条件查询相应的报告
     * @param pid 要查看的报告的pid
     * @param needUpdate 是否需要更新该报告的状态（如果是科室主任查看该报告，则需要更新accepted字段为1）
     * */
    public static String queryItemDetail(int pid, boolean needUpdate) {

        String sql="select * from event_detail where deleted=0 and p_id="+pid;
        Connection conn;
        ResultSet rs;
        JSONObject obj=new JSONObject();
        try {
            conn=getConn();
            Statement stmt=conn.createStatement();
            rs=stmt.executeQuery(sql);
            ResultSetMetaData rsmd=rs.getMetaData();
            int col=rsmd.getColumnCount();
            while (rs.next()) {
                Map<String, String> map=new HashMap<>();
                for (int i=1; i<=col; i++) {
                    map.put(rsmd.getColumnName(i), rs.getString(i));
                }
                obj.putAll(map);
            }
            if (needUpdate) {
                String sql2="update event_detail set accepted=1 where p_id="+pid;
                stmt.execute(sql2);
            }
            rs.close();
            conn.close();
            String result = obj.toString();
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            return "查询失败";
        }
    }

    /**
     * 更新报告的处理结果
     * @param flag 0-提交科室处理结果，1-提交护理部处理结果
     * @param deal 处理内容
     * @param pid 被处理的报告的pid
     * */
    public static String updateDealingInfo(int flag, String deal, int pid,int dealerId, String dealerName) {
        try {
            String sql;

            if (flag==0)
                sql="update event_detail set dep_dealing='"+deal+"',handled=1,dep_leader_id="+dealerId+",dep_leader_name='"+dealerName+
                        "',dep_deal_time='"+getLocalTime()+ "' where p_id="+pid;
            else
                sql="update event_detail set final_dealing='"+deal+"',handled=1,final_dealer_id="+dealerId+",final_dealer_name='"+dealerName+
                        "',final_deal_time='"+getLocalTime()+"' where p_id="+pid;

            Statement stmt=getConn().createStatement();
            stmt.execute(sql);
            System.out.println("mysql数据已更新");

            if (flag==0)
                sendWxMsgToFinal(pid);

            return makeResult("OK", "提交成功");

        } catch (Exception e) {
            e.printStackTrace();
            return makeResult("ERROR", "提交失败");
        }

    }

    /**
     * 删除报告
     * */
    public static String deleteReport(int pid, int user_id) {
        String result;
        try {
            Statement stmt = getConn().createStatement();
            String sql = "update event_detail set deleted=1,delete_operate_id="+user_id+",delete_time='"+getLocalTime()+"' where p_id="+pid;
            stmt.execute(sql);
            result = "删除成功";
            stmt.close();
        } catch (Exception e) {
            result = "删除失败";
        }

        return result;
    }

    private static void sendWxMsgToFinal(int pid) {
        String touser= "|1137|1488|1290";
        String toparty="";
        String totag="";
        String msgtype="text";
        int agentid=WxConstants.AGENTID_3;

        String mUrl="https://open.weixin.qq.com/connect/oauth2/authorize?appid=wwf0b23c8b36012b34&redirect_uri=" +
                "www.dj0217.top/EventReport/final/html/new_report.jsp?pid="+pid+"&response_type=code&scope=snsapi_userinfo&agentid=1000030&state=STATE#wechat_redirect";

        String content="新报告送达。\n<a href='"+mUrl+"'>点击此处查看详情</a>";


        SendWxInfo.Send_msg(touser,toparty,totag,msgtype,agentid,content);
    }

    /**
     * 生成返回给客户端的信息
     * @param result （OK OR ERROR）操作成功或者失败
     * @param msg 用于显示在客户端的内容
     * */
    private static String makeResult(String result, String msg) {
        JSONObject obj=new JSONObject();
        obj.put("result",result);
        obj.put("msg",msg);
        return obj.toString();
    }

    private static String getLocalTime() {
        String result = "";
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        result = sdf.format(new Date());
        return result;
    }

}
