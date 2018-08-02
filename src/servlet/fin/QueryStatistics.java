package servlet.fin;

import mysql.MySqlUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "QueryStatistics")
public class QueryStatistics extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String date=request.getParameter("date");
        String dep=request.getParameter("dep");

        response.addHeader("Content-type","text/html;charset=UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        PrintWriter pw=response.getWriter();
        String result = MySqlUtil.doQuery(makeSql(date, dep));
        pw.print(result);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.addHeader("Content-type","text/html;charset=UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        PrintWriter pw=response.getWriter();
        String result = MySqlUtil.queryFromDatabase(Integer.MAX_VALUE,0,null);
        pw.print(result);
    }

    private String makeSql(String date, String dep) {
        String sql=null;
        if (date.length()>2 && dep.equals("所有科室"))
            sql="select * from event_detail where date='"+date+"'";
        else if (date.length()<2 && !dep.equals("所有科室"))
            sql="select * from event_detail where department='"+dep+"'";
        else
            sql="select * from event_detail where date='"+date+"' and department='"+dep+"'";
        return sql;
    }


}
