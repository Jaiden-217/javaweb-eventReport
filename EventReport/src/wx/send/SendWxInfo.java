package wx.send;

import net.sf.json.JSONObject;
import wx.util.ComUtil;
import wx.util.WxConstants;

public class SendWxInfo {
    /**
     * @param touser 成员ID列表
     * @param toparty 部门ID列表
     * @param totag 标签ID列表
     * @param msgtype 消息类型，此时固定为：text（支持消息型应用跟主页型应用）
     * @param agentid 企业应用的id，整型。可在应用的设置页面查看
     * @param content 消息内容，最长不超过2048个字节，注意：主页型应用推送的文本消息在微信端最多只显示20个字（包含中英文）
     * @return int 表示是否是保密消息，0表示否，1表示是，默认0
     */
    public static int Send_msg(String touser,String toparty,String totag,String msgtype,int agentid,String content){
        int errCode=0;
        String requestUrl= WxConstants.SEND_MSG_URL.replace("ACCESS_TOKEN", ComUtil.getAccessToken(1));
        String postJson = "{\"agentid\":%s,\"touser\": \"%s\",\"toparty\": \"%s\",\"totag\": \"%s\","+
                "\"msgtype\":\"%s\",\"text\": {\"content\": \"%s\"},\"safe\":0}";
        String outputStr=String.format(postJson,agentid,touser,toparty,totag,msgtype,content);
        System.out.println(outputStr);
        JSONObject jsonObject=ComUtil.httpsRequest(requestUrl, "POST", outputStr);
        if(null!=jsonObject){
            System.out.println(jsonObject.toString()+"=====");
        }
        return errCode;
    }

    public static int Send_file(String touser,String toparty,String totag,String msgtype,int agentid,String media_id){
        int errCode=0;
        String requestUrl=WxConstants.SEND_MSG_URL.replace("ACCESS_TOKEN", ComUtil.getAccessToken(1));
        String postJson = "{\"agentid\":%s,\"touser\": \"%s\",\"toparty\": \"%s\",\"totag\": \"%s\","+
                "\"msgtype\":\"%s\",\"file\": {\"media_id\": \"%s\"},\"safe\":0}";
        String outputStr=String.format(postJson,agentid,touser,toparty,totag,msgtype,media_id);
        System.out.println(outputStr);
        JSONObject jsonObject=ComUtil.httpsRequest(requestUrl, "POST", outputStr);
        if(null!=jsonObject){
            System.out.println(jsonObject.toString()+"=====");
        }
        return errCode;
    }
}
