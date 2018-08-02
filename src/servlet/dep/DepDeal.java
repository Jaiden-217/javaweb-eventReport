package servlet.dep;

import mysql.MySqlUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "DepDeal")
public class DepDeal extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String deal=request.getParameter("deal");
        int pid=Integer.parseInt(request.getParameter("pid"));
        int depUserId = Integer.parseInt(request.getParameter("depUserId"));
        String depUserName=request.getParameter("depUserName");

        response.addHeader("Content-type","text/html;charset=UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        PrintWriter pw=response.getWriter();
        String result = MySqlUtil.updateDealingInfo(0,deal,pid, depUserId, depUserName);
        pw.print(result);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String deal=request.getParameter("deal");
        int pid=Integer.parseInt(request.getParameter("pid"));
        int finalDealerId = Integer.parseInt(request.getParameter("finalUserId"));
        String finalDealerName = request.getParameter("finalUserName");

        response.addHeader("Content-type","text/html;charset=UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        PrintWriter pw=response.getWriter();
        String result = MySqlUtil.updateDealingInfo(1,deal,pid,finalDealerId,finalDealerName);
        pw.print(result);
    }
}
