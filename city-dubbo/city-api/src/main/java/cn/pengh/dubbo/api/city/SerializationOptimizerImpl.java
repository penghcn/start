package cn.pengh.dubbo.api.city;

import java.util.Collection;
import java.util.LinkedList;
import java.util.List;

//import com.alibaba.dubbo.common.serialize.support.SerializationOptimizer;

public class SerializationOptimizerImpl /*implements SerializationOptimizer*/ {

	@SuppressWarnings("rawtypes")
	//@Override
	public Collection<Class> getSerializableClasses() {
		List<Class> classes = new LinkedList<Class>();
        classes.add(CityRequest.class);
        classes.add(CityResponse.class);
        return classes;
	}

}
