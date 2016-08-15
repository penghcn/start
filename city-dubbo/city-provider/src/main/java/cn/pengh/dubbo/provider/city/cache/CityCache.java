package cn.pengh.dubbo.provider.city.cache;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;

import cn.pengh.dubbo.provider.city.entity.CityModel;
import cn.pengh.dubbo.provider.city.repository.CityRepository;
import cn.pengh.mvc.core.cache.ICache;

public class CityCache implements ICache{
	private static Map<Integer, CityModel> cacheMap = new HashMap<Integer, CityModel>();
	@Autowired
	private CityRepository cityRepository;
	@Override
	public void refreshCache() {
		Map<Integer, CityModel> map = new HashMap<Integer, CityModel>();
		List<CityModel> list = cityRepository.findAll();
		for (CityModel c : list) {
			map.put(c.getCityId(), c);
		}
		cacheMap = map;
		
		//先处理好
		Map<Integer, CityModel> parsedMap = new HashMap<Integer, CityModel>();
		for (CityModel c : list) {
			c.setCityNm(dealNm(c.getCityId()));
			parsedMap.put(c.getCityId(), c);
		}
		cacheMap = parsedMap;
	}
	
	private static String dealNm(int cityId){
		if (cityId % 10000 == 0)
			return getNm(cityId);
		else if (cityId % 100 == 0)
			return getNm(cityId / 10000 * 10000) + getNm(cityId);
		else 
			return /*getNm(cityId / 10000 * 10000) + */getNm(cityId / 100 * 100) + getNm(cityId);
	}
	
	public static String getNm(int cityId){
		CityModel c = cacheMap.get(getValidCityId(cityId));
		return c == null ? "" : c.getCityNm();
	}
	
	public static int getValidCityId(int cityId){
		if (cityId > 999999)
			return 0;
		if (cityId < 100000) {
			/*if (cityId < 10)
				return cityId * 100000;
			else*/ 
			if (cityId < 100)
				return cityId * 10000;
			else if (cityId < 1000)
				return cityId * 1000;
			else if (cityId < 10000)
				return cityId * 100;
			else 
				return cityId * 10;
		}
		return cityId;
	}
	
	//440308 -> 440300
	private static int getRealCityId(int cityId){
		//几个特殊直辖市
		if (cityId == 310000 || cityId == 110000 || cityId == 120000 || cityId == 500000)
			return cityId + 100;
		return cityId /100 * 100;
	}
	
	//深圳 -> 440300
	public static Integer getCityId(String cityNm){
		for(Map.Entry<Integer, CityModel>  e : cacheMap.entrySet()) {
			if (e.getValue().getCityNm().indexOf(cityNm) > -1)
				return getRealCityId(e.getKey());
		}
		return null;
	}
	
	//440000,深圳 -> 440300
	public static Integer getCityId(int provId,String cityNm){
		provId = getValidCityId(provId);
		for(Map.Entry<Integer, CityModel>  e : cacheMap.entrySet()) {
			if (e.getKey()/10000 == provId /10000 && e.getValue().getCityNm().indexOf(cityNm.trim()) > -1)
				return getRealCityId(e.getKey());
		}
		return null;
	}

}
