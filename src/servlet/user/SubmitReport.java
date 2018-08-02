package servlet.user;

import mysql.MySqlUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.URLDecoder;
import java.sql.Statement;

import static mysql.MySqlUtil.getConn;

public class SubmitReport extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        response.addHeader("Content-type","text/html;charset=UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        PrintWriter pw=response.getWriter();
        String result = MySqlUtil.loadIntoDatabase(request);
        pw.print(result);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String department = request.getParameter("department");
        MySqlUtil.queryLeaderInfo(request, department);
    }

//    public String acceptJSON(HttpServletRequest request){
//        String acceptJson = "";
//        try {
//            BufferedReader br = new BufferedReader(new InputStreamReader(request.getInputStream(), "utf-8"));
//            StringBuffer sb = new StringBuffer("");
//            String temp;
//            while ((temp = br.readLine()) != null) {
//                sb.append(temp);
//            }
//            br.close();
//            acceptJson = URLDecoder.decode(sb.toString(), "UTF-8");
//            System.out.println(acceptJson);
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return acceptJson;
//    }

}
