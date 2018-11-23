package cn.pengh.demo.hello.mvc.controller;

import cn.pengh.demo.hello.mvc.util.LogUtil;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * @author Created by pengh
 * @datetime 2018/11/23 09:09
 */
@Controller
@RequestMapping("/user/login")
public class LoginController {

    @RequestMapping(value = "/", method = {RequestMethod.GET, RequestMethod.POST})
    public void index() {
        LogUtil.getLogger().debug("");
    }
}
