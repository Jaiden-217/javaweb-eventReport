package servlet.user;

import mysql.MySqlUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "UpdateReport")
public class UpdateReport extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        response.addHeader("Content-type","text/html;charset=UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        PrintWriter pw=response.getWriter();
        String result = MySqlUtil.updateReport(request);
        pw.print(result);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

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
