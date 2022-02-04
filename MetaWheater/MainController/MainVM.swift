//
//  MainVM.swift
//  MetaWheater
//
//  Created by Hasan Dag on 4.02.2022.
//

import Foundation
import MapKit

final class MainVM :BaseVM {
    var responseModel : [CityModel]?
    var markers: [MKPointAnnotation] = [MKPointAnnotation]()
    
    override init() {
        super.init()
        
    }
    
    func fetchRequest(lat:Double,long:Double){
        MainService().addParameterToUrlPath("lattlong=\(lat),\(long)").response {   [weak self] (result) in
            
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.responseModel = response
                self.state?(.success)
            case .failure:
                self.state?(.failure)
            }
        }
    }
    
    func getCity(index: Int) -> CityModel {
        return responseModel?[index] ?? CityModel(distance: 0, title: "DummyData", location_type: "nil", woeid: 0, latt_long: "nil")
    }

    func getMarkers() -> [MKPointAnnotation]{
        guard let nearCities = responseModel else {
            print("marker guarda düştü")
            return self.markers}
        for cities in nearCities {
            let latlong = cities.latt_long?.components(separatedBy: ",")
            guard let lat = latlong?[0], let long = latlong?[1] else {return self.markers}
            let convertedLat = Double(lat) ?? 0.0
            let convertedLong = Double(long) ?? 0.0
            let marker = MKPointAnnotation()
            let coordinate = CLLocationCoordinate2D(latitude: convertedLat, longitude: convertedLong)
            marker.title = cities.title ?? ""
            marker.coordinate = coordinate
            self.markers.append(marker)
        }
        
        return self.markers
    }
}
