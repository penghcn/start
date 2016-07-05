package cn.pengh.dubbo.api.city;

import java.io.Serializable;

import cn.pengh.dubbo.api.Response;

public class CityResponse extends Response implements Serializable{
	private static final long serialVersionUID = -6462724996856731888L;
	private int id;
	private String nm;
	public CityResponse(int id,String nm) {
		this.id = id;
		this.nm = nm;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getNm() {
		return nm;
	}
	public void setNm(String nm) {
		this.nm = nm;
	}

}
