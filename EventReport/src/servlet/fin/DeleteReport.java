package servlet.fin;

import mysql.MySqlUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

public class DeleteReport extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        resp.addHeader("Content-type","text/html;charset=UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        int pid = Integer.parseInt(req.getParameter("pid"));
        int userId = Integer.parseInt(req.getSession().getAttribute("finalUserId").toString());

        System.out.println("pid:"+pid+"   ===   user:"+userId);

        PrintWriter pw=resp.getWriter();
        String result = MySqlUtil.deleteReport(pid, userId);
        pw.print(result);
    }
}
