//
//  MainService.swift
//  MetaWheater
//
//  Created by Hasan Dag on 4.02.2022.
//


import Foundation
final class MainService : BaseService<BaseRequestModel,[CityModel]>{
 
    override init() {
        super.init()
        path = "api/location/search/"
        method = .get
    }
}
