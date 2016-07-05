package cn.pengh.dubbo.api.city;

import java.io.Serializable;

public class CityRequest implements Serializable{
	private static final long serialVersionUID = -3426599128949053068L;
	private int id;
	public CityRequest(int id) {
		this.id = id;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
}
