//
//  WheaterVM.swift
//  MetaWheater
//
//  Created by Hasan Dag on 4.02.2022.
//

import Foundation

final class WheaterVM :BaseVM {
    var responseModel : WheaterModel?
    
    override init() {
        super.init()
    }
    
    func fetchWheater(woeid:Int){
        WheaterService().addParameterToUrlPath("\(woeid)").response {   [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.responseModel = response
                self.state?(.success)
            case .failure:
                print("decoding error")
                self.state?(.failure)
            }
        }
    }
    //MARK:- VM servis decoding
    //        for day in 0...6 {
    //
    //            var dayComponent    = DateComponents()
    //            dayComponent.day    = day
    //            let theCalendar     = Calendar.current
    //            let nextDate        = theCalendar.date(byAdding: dayComponent, to: Date())
    //            let comps = Calendar.current.dateComponents([.year, .month, .day], from: nextDate ?? Date())
    //            let year = String(comps.year ?? 2022)
    //            let month = String(comps.month ?? 01)
    //            let day = String(comps.day ?? 2022)
    //
    //            WheaterService().addParameterToUrlPath("\(woeid)/\(year)/\(month)/\(day)").response {   [weak self] (result) in
    //
    //                guard let self = self else { return }
    //                switch result {
    //                case .success(let response):
    //                    guard let first = response.first else {return}
    //                    self.responseModel = response
    //                    print(response.first?.applicableDate,"/n/n dateeeee")
    //                case .failure:
    //                    print("decoding error")
    //                    self.state?(.failure)
    //                }
    //            }
    //        }
    //
    //        self.state?(.success)
    
    
}
