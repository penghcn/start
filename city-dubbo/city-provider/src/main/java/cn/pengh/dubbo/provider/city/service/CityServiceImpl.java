package cn.pengh.dubbo.provider.city.service;

import cn.pengh.dubbo.api.city.CityRequest;
import cn.pengh.dubbo.api.city.CityResponse;
import cn.pengh.dubbo.api.city.CityService;
import cn.pengh.dubbo.provider.city.cache.CityCache;

public class CityServiceImpl implements CityService{

	@Override
	public CityResponse get(CityRequest req) {
		int cityId = CityCache.getValidCityId(req.getId());
		return new CityResponse(cityId,CityCache.getNm(cityId));
	}

}
