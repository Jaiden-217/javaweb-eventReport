package wx.util;

import net.sf.json.JSONObject;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.methods.GetMethod;
import org.apache.commons.httpclient.methods.PostMethod;
import wx.send.SendWxInfo;

import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSocketFactory;
import javax.net.ssl.TrustManager;
import java.io.*;
import java.net.ConnectException;
import java.net.URL;

public class ComUtil {
    /**
     * 发送https请求
     * @param requestUrl 请求地址
     * @param requestMethod 请求方式（GET、POST）
     * @param outputStr 提交的数据
     * @return JSONObject(通过JSONObject.get(key)的方式获取json对象的属性值)
     */
    public static JSONObject httpsRequest(String requestUrl, String requestMethod, String outputStr) {
        JSONObject jsonObject = null;
        try {
            TrustManager[] tm = { new MyX509TrustManager() };
            SSLContext sslContext = SSLContext.getInstance("SSL", "SunJSSE");
            sslContext.init(null, tm, new java.security.SecureRandom());
            SSLSocketFactory ssf = sslContext.getSocketFactory();
            URL url = new URL(requestUrl);
            HttpsURLConnection conn = (HttpsURLConnection) url.openConnection();
            conn.setSSLSocketFactory(ssf);
            conn.setDoOutput(true);
            conn.setDoInput(true);
            conn.setUseCaches(false);
            conn.setRequestMethod(requestMethod);
            if (null != outputStr) {
                OutputStream outputStream = conn.getOutputStream();
                outputStream.write(outputStr.getBytes("UTF-8"));
                outputStream.close();
            }
            InputStream inputStream = conn.getInputStream();
            InputStreamReader inputStreamReader = new InputStreamReader(inputStream, "utf-8");
            BufferedReader bufferedReader = new BufferedReader(inputStreamReader);
            String str = null;
            StringBuffer buffer = new StringBuffer();
            while ((str = bufferedReader.readLine()) != null) {
                buffer.append(str);
            }
            bufferedReader.close();
            inputStreamReader.close();
            inputStream.close();
            inputStream = null;
            conn.disconnect();
            jsonObject = JSONObject.fromObject(buffer.toString());
        } catch (ConnectException ce) {
        } catch (Exception e) {
        }
        return jsonObject;
    }

    /**
     * 获取接口访问凭证
     */
    public static String getAccessToken(int flag) {
        HttpClient client=new HttpClient();
        GetMethod get=null;
        switch (flag) {
            case 1:
                get=new GetMethod(WxConstants.ACCESS_TOKEN_URL1);
                break;
            case 2:
                get=new GetMethod(WxConstants.ACCESS_TOKEN_URL2);
                break;
            case 3:
                get=new GetMethod(WxConstants.ACCESS_TOKEN_URL3);
                break;
        }
        get.releaseConnection();
        get.setRequestHeader("Content-Type", "application/x-www-form-urlencoded;charset=UTF-8");
        String result="";
        try {
            client.executeMethod(get);
            result=new String(get.getResponseBodyAsString().getBytes("UTF-8"));
        } catch (IOException e) {
            e.printStackTrace();
        }
        JSONObject obj=JSONObject.fromObject(result);
        result=obj.getString("access_token");
        get.releaseConnection();
        return result;
    }

}
