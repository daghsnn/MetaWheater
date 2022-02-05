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
}
