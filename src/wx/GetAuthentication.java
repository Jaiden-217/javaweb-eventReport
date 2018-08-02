package wx;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.methods.GetMethod;

import java.io.IOException;


public class GetAuthentication {
    private static GetAuthentication instance=null;

    private GetAuthentication() {}

    public static GetAuthentication getInstance() {
        if (instance==null) {
            synchronized (GetAuthentication.class) {
                instance=new GetAuthentication();
            }
        }
        return instance;
    }

    /**
     * 根据code获取用户的基本信息
     * 需要使用GetMethod
     * */
    public String getUserId(String code, String token) {
        String getUserId_URL="https://qyapi.weixin.qq.com/cgi-bin/user/getuserinfo?access_token="+token+"&code="+code+"&agentid=1000030";
        HttpClient client=new HttpClient();
        GetMethod get=new GetMethod(getUserId_URL);
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
        result=obj.getString("UserId");
        get.releaseConnection();

        return result;
    }

    /**
     * 根据UserId(或者user_ticket)获取用户详细信息
     * 需要使用PostMethod
     * */
    public JSONObject getUserInfo(String userId, String token) {
        String getUserMsg_URL="https://qyapi.weixin.qq.com/cgi-bin/user/get?access_token="+token+"&userid="+userId;
        HttpClient client=new HttpClient();
        GetMethod get=new GetMethod(getUserMsg_URL);
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
        get.releaseConnection();
        return obj;
    }

    public String getDepartment(String token, int id) {
        String url = "https://qyapi.weixin.qq.com/cgi-bin/department/list?access_token="+token+"&id="+id;
        String result = "";
        HttpClient client = new HttpClient();
        GetMethod get = new GetMethod(url);
        get.releaseConnection();
        get.setRequestHeader("Content-Type", "application/x-www-form-urlencoded;charset=UTF-8");

        try {
            client.executeMethod(get);
            result = new String(get.getResponseBodyAsString().getBytes("UTF-8"));
            System.out.println(result);
        } catch (IOException e) {}

        JSONObject object = JSONObject.fromObject(result);
        JSONArray jsonArray = object.getJSONArray("department");
        object = jsonArray.getJSONObject(0);
        result = object.getString("name");
        return result;
    }

}
