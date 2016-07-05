package cn.pengh.dubbo.api;

import java.io.Serializable;

public class Response implements Serializable{
	private static final long serialVersionUID = 6028835192473752657L;
	private int code = 200;
	private String desc = "成功";
	public int getCode() {
		return code;
	}
	public void setCode(int code) {
		this.code = code;
	}
	public String getDesc() {
		return desc;
	}
	public void setDesc(String desc) {
		this.desc = desc;
	}
	public boolean isSuccess() {
		return code == 200;
	}
}
