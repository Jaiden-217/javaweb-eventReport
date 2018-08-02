package servlet.user;

import mysql.MySqlUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "GetHistoryList")
public class GetHistoryList extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int pid=Integer.parseInt(request.getParameter("pid"));

        response.addHeader("Content-type","text/html;charset=UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        PrintWriter pw=response.getWriter();

        String result = MySqlUtil.queryItemDetail(pid, false);
        pw.print(result);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int user_id=Integer.parseInt(request.getParameter("user_id"));

        response.addHeader("Content-type","text/html;charset=UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        PrintWriter pw=response.getWriter();
        String result = MySqlUtil.queryFromDatabase(user_id,0,null);
        pw.print(result);
    }
}
