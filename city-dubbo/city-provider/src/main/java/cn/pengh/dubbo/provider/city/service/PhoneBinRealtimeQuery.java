package cn.pengh.dubbo.provider.city.service;

import java.util.HashMap;
import java.util.Map;

import cn.pengh.dubbo.provider.city.cache.CityCache;
import cn.pengh.dubbo.provider.city.entity.PhoneCityModel;
import cn.pengh.helper.ClazzHelper;
import cn.pengh.http.HttpRequest;
import cn.pengh.http.HttpRequest.HttpRequestConfig;
import cn.pengh.library.Log;
import net.sf.json.JSONObject;

/**
 * http://apistore.baidu.com/apiworks/servicedetail/709.html
 * https://www.showapi.com/api/lookPoint/6
 * @author pengh
 * @Date 2016年8月5日 下午3:02:49
 */
public class PhoneBinRealtimeQuery {
	public static Map<Integer, Byte> BRAND_2_MY = new HashMap<Integer, Byte>(){
		private static final long serialVersionUID = -4110769094190514333L;{
			put(1,(byte)1);
			put(2,(byte)3);
			put(3,(byte)2);
		}		
	};
	private static final String BAIDU_API_KEY = "73a4ab04cce7d80adb1dd9327dfea1c8";
	private static final String BAIDU_API_URL = "http://apis.baidu.com/showapi_open_bus/mobile/find";//http://route.showapi.com/6-1
	
	//手机号码归属地查询
	public PhoneCityModel query(String tel){
		String back = HttpRequest.get(BAIDU_API_URL+"?num="+tel,HttpRequestConfig.createDefault()
				.setHeaders("apikey", BAIDU_API_KEY)
				.setTimeout(500)
				.build());
		if (back == null)
			return null;
		JSONObject json = JSONObject.fromObject(back);
		
		if (json == null || 0 != json.getInt("showapi_res_code")) {
			return null;
		}
		
		JSONObject info = json.getJSONObject("showapi_res_body");
		Log.getLogger().debug("{}{}, {}", info.getString("prov"), info.get("city") == null ? "" : info.getString("city"), info.getString("name"));
		
		//
		byte brandId = BRAND_2_MY.get(info.getInt("type"));		
		//1为移动 2为电信 3为联通
		if ("京东通信".equals(info.getString("name")))
			brandId = 3;
		
		int cityId = info.getInt("provCode");
		if (info.get("city") != null) {
			cityId = CityCache.getCityId(cityId, info.getString("city"));
		}
		return new PhoneCityModel(info.getString("num"),cityId,brandId);
	}
	
	public static void main(String[] args) {
		String tel = "1709183";
		//tel = "18682010000";
		//tel = "17301690000";
		//tel = "13148460000";
		tel = "1314846";
		PhoneBinRealtimeQuery t = new PhoneBinRealtimeQuery();
		ClazzHelper.print(t.query(tel));
	}
}


