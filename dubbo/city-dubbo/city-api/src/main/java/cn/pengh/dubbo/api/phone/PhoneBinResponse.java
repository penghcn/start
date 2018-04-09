package cn.pengh.dubbo.api.phone;

import java.io.Serializable;

import cn.pengh.dubbo.api.Response;

public class PhoneBinResponse extends Response implements Serializable{
	private static final long serialVersionUID = -6227516243903193638L;
	private String bin;
	private Integer cityId;
	private String cityNm;
	private String brand;
	public PhoneBinResponse(String bin,Integer cityId,String cityNm,String brand) {
		this.bin = bin;
		this.cityId = cityId;
		this.cityNm = cityNm;
		this.brand = brand;
	}
	public String getBin() {
		return bin;
	}
	public void setBin(String bin) {
		this.bin = bin;
	}
	public Integer getCityId() {
		return cityId;
	}
	public void setCityId(Integer cityId) {
		this.cityId = cityId;
	}
	public String getCityNm() {
		return cityNm;
	}
	public void setCityNm(String cityNm) {
		this.cityNm = cityNm;
	}
	public String getBrand() {
		return brand;
	}
	public void setBrand(String brand) {
		this.brand = brand;
	}

}
