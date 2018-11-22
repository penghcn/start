package cn.pengh.demo.hello.mvc.req;

/**
 * @author Created by pengh
 * @datetime 2018/11/22 19:35
 */
public class UserLoginReq {
    private String loginId;
    private String loginPwd;

    public String getLoginId() {
        return loginId;
    }

    public void setLoginId(String loginId) {
        this.loginId = loginId;
    }

    public String getLoginPwd() {
        return loginPwd;
    }

    public void setLoginPwd(String loginPwd) {
        this.loginPwd = loginPwd;
    }
}
