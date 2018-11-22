package cn.pengh.demo.hello.mvc.dao.hellodb;

import cn.pengh.demo.hello.mvc.dto.UserLoginDto;
import cn.pengh.demo.hello.mvc.req.UserLoginReq;

import java.util.List;

/**
 * @author Created by pengh
 * @datetime 2018/11/22 19:31
 */
public interface UserLoginDao {
    int save(UserLoginDto data);

    UserLoginDto getOne(UserLoginReq req);
    List<UserLoginDto> find(UserLoginReq req);
}
