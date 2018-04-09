package cn.pengh.dubbo.provider.city.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import cn.pengh.dubbo.provider.city.entity.CityModel;

@Repository
public interface CityRepository extends JpaRepository<CityModel, Integer> {

}
