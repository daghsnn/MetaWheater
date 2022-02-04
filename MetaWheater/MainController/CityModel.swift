//
//  CityModel.swift
//  MetaWheater
//
//  Created by Hasan Dag on 4.02.2022.
//

import Foundation

struct CityModel:Codable {
    let distance : Int?
    let title:String?
    let location_type:String?
    let woeid:Int?
    let latt_long: String?
}
