package cn.pengh.dubbo.provider.city.service;

import java.util.HashMap;
import java.util.Map;

import cn.pengh.dubbo.api.phone.PhoneBinRequest;
import cn.pengh.dubbo.api.phone.PhoneBinResponse;
import cn.pengh.dubbo.api.phone.PhoneBinService;
import cn.pengh.dubbo.provider.city.cache.CityCache;
import cn.pengh.dubbo.provider.city.cache.PhoneBinCache;
import cn.pengh.dubbo.provider.city.entity.PhoneCityModel;

/**
 * 
 * @author pengh
 * @Date 2016年8月5日 下午2:31:03
 */
public class PhoneBinServiceImpl implements PhoneBinService {
	private static Map<Byte, String> BRAND_DESC = new HashMap<Byte, String>(){
		private static final long serialVersionUID = -4110769094190514344L;{
			put((byte)0,"固话");
			put((byte)1,"移动");
			put((byte)2,"联通");
			put((byte)3,"电信");
		}
		
	};
	@Override
	public PhoneBinResponse get(PhoneBinRequest req) {
		String bin = req.getBin();
		if (bin.length() > 7)
			bin = bin.substring(0,7);
		PhoneCityModel pbm = PhoneBinCache.get(bin);
		if (pbm == null)
			return new PhoneBinResponse(bin,null,"","");
		return new PhoneBinResponse(bin,pbm.getCityId(),CityCache.getNm(pbm.getCityId()),BRAND_DESC.get(pbm.getBrandId()));
	}
}


