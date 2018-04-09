package cn.pengh.dubbo.api.phone;

import java.io.Serializable;

public class PhoneBinRequest implements Serializable{
	private static final long serialVersionUID = -8394565580007588722L;
	private String bin;
	public PhoneBinRequest(String bin) {
		this.bin = bin;
	}
	public String getBin() {
		return bin;
	}
	public void setBin(String bin) {
		this.bin = bin;
	}
}
