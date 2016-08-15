package cn.pengh.dubbo.provider.city.service;

import java.lang.reflect.Type;
import java.util.HashMap;
import java.util.Map;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonDeserializationContext;
import com.google.gson.JsonDeserializer;
import com.google.gson.JsonElement;
import com.google.gson.JsonParseException;
import com.google.gson.JsonPrimitive;
import com.google.gson.JsonSerializationContext;
import com.google.gson.JsonSerializer;
import com.google.gson.reflect.TypeToken;

import cn.pengh.dubbo.provider.city.cache.CityCache;
import cn.pengh.dubbo.provider.city.entity.PhoneCityModel;
import cn.pengh.helper.ClazzHelper;
import cn.pengh.http.HttpRequest;
import cn.pengh.http.HttpRequest.HttpRequestConfig;
import cn.pengh.util.CurrencyUtil;

/**
 * http://apistore.baidu.com/apiworks/servicedetail/709.html
 * https://www.showapi.com/api/lookPoint/6
 * @author pengh
 * @Date 2016年8月5日 下午3:02:49
 */
public class PhoneBinRealtimeQuery {
	private static Map<Integer, Byte> BRAND_2_MY = new HashMap<Integer, Byte>(){
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
				.setTimeout(1000)
				.build());
		if (back == null)
			return null;
		
	
		Map<String,Object> json = getGson().fromJson(back,new TypeToken<Map<String,Object>>(){}.getType());
		//Log.debug(json);
		if (json == null || 0 != CurrencyUtil.convert(json.get("showapi_res_code")).intValue()) {
			return null;
		}
		
		Map<String,String> info = getGson().fromJson(json.get("showapi_res_body").toString(),new TypeToken<Map<String,String>>(){}.getType());
		//Log.getLogger().debug("{}{}, {}", info.getString("prov"), info.get("city") == null ? "" : info.getString("city"), info.getString("name"));
		//Log.debug(info);
		//
		byte brandId = BRAND_2_MY.get(CurrencyUtil.convert(info.get("type")).intValue());		
		//1为移动 2为电信 3为联通
		if ("京东通信".equals(info.get("name")))
			brandId = 3;
		
		int cityId = CurrencyUtil.convert(info.get("provCode")).intValue();
		if (info.get("city") != null) {
			cityId = CityCache.getCityId(cityId, info.get("city"));
		}
		return new PhoneCityModel(CurrencyUtil.convert(info.get("num"),0).toString(),cityId,brandId);
	}
	
	private Gson getGson(){
		return new GsonBuilder().registerTypeAdapter(Double.class, new JsonSerializer<Double>() {
			@Override
			public JsonElement serialize(Double src, Type typeOfSrc, JsonSerializationContext context) {
				if (src == src.longValue())  
                    return new JsonPrimitive(src.longValue());  
                return new JsonPrimitive(src);
			}			
		}).registerTypeAdapter(Integer.class, new JsonDeserializer<Integer>() {
			@Override
			public Integer deserialize(JsonElement src, Type paramType, JsonDeserializationContext context) throws JsonParseException {
                return src.getAsInt();
			}						
		}).registerTypeAdapter(HashMap.class, new JsonDeserializer<HashMap<String, JsonElement>>() {
			@Override
			public HashMap<String, JsonElement> deserialize(JsonElement json, Type paramType, JsonDeserializationContext context) throws JsonParseException {
				HashMap<String, JsonElement> resultMap = new HashMap<String, JsonElement>();
				for (Map.Entry<String, JsonElement> entry : json.getAsJsonObject().entrySet()) {
					resultMap.put(entry.getKey().toString(),entry.getValue());
				}
				return resultMap;
			}						
		}).create();
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


