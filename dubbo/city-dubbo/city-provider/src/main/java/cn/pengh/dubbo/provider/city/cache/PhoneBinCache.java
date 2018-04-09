package cn.pengh.dubbo.provider.city.cache;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;

import cn.pengh.dubbo.provider.city.entity.PhoneCityModel;
import cn.pengh.dubbo.provider.city.repository.PhoneCityRepository;
import cn.pengh.dubbo.provider.city.service.PhoneBinRealtimeQuery;
import cn.pengh.helper.ClazzHelper;
import cn.pengh.library.Log;
import cn.pengh.mvc.core.cache.ICache;

public class PhoneBinCache implements ICache{
	private static Map<String, PhoneCityModel> cacheMap = new HashMap<String, PhoneCityModel>();
	private static List<String> cacheRealtimePhoneBinList = new ArrayList<String>();
	@Autowired
	private PhoneCityRepository phoneCityRepository;
	@Autowired
	private PhoneBinRealtimeQuery phoneBinRealtimeQuery;
	
	private static PhoneBinCache self;
	
	public void initSelf(){
		self = this;
	}
	
	@Override
	public void refreshCache() {
		Map<String, PhoneCityModel> map = new HashMap<String, PhoneCityModel>();
		List<PhoneCityModel> list = phoneCityRepository.findAll();
		for (PhoneCityModel c : list) {
			map.put(c.getPhoneBin(), c);
		}
		cacheMap = map;		
	}
	
	public static PhoneCityModel get(String bin){
		PhoneCityModel pcm = cacheMap.get(bin);
		//
		if (pcm == null) {
			PhoneCityModel realModel = self.phoneBinRealtimeQuery.query(bin);
			if (realModel == null) {
				Log.debug("----未查询到实时数据");
				return null;
			}
				
			Log.debug("----保存并刷新phone bin缓存");
			ClazzHelper.print(realModel);
			if (realModel.isProv())
				cacheRealtimePhoneBinList.add(bin);
			self.phoneCityRepository.save(realModel);
			cacheMap.put(realModel.getPhoneBin(), realModel);
			return realModel;
		} else if (!cacheRealtimePhoneBinList.contains(bin) && pcm.likeMobilephone() && pcm.isProv() ) {//只是省代码			
			PhoneCityModel realModel = self.phoneBinRealtimeQuery.query(bin);
			cacheRealtimePhoneBinList.add(bin);
			if (realModel == null || realModel.isProv()) {
				return pcm;
			}
			ClazzHelper.print(realModel);
			self.phoneCityRepository.delete(pcm);
			self.phoneCityRepository.save(realModel);
			cacheMap.put(realModel.getPhoneBin(), realModel);
			return realModel;
		}
		return pcm;
	}
}
