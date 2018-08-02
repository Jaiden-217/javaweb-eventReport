package servlet.dep;

import mysql.MySqlUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "QueryList")
public class QueryList extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int pid=Integer.parseInt(request.getParameter("pid"));

        response.addHeader("Content-type","text/html;charset=UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        PrintWriter pw=response.getWriter();
        String result = MySqlUtil.queryItemDetail(pid, true);
        pw.print(result);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int action=Integer.parseInt(request.getParameter("action"));
        String depUserId=request.getParameter("depUserId");
        response.addHeader("Content-type","text/html;charset=UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        PrintWriter pw=response.getWriter();
        String result = MySqlUtil.queryFromDatabase(Integer.MIN_VALUE,action,depUserId);
        pw.print(result);
    }
}
