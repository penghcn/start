package cn.pengh.dubbo.provider.city.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import cn.pengh.dubbo.provider.city.entity.PhoneCityModel;

@Repository
public interface PhoneCityRepository extends JpaRepository<PhoneCityModel, Integer> {

}
