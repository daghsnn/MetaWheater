//
//  WheaterService.swift
//  MetaWheater
//
//  Created by Hasan Dag on 4.02.2022.
//

import Foundation
final class WheaterService : BaseService<BaseRequestModel,WheaterModel>{
    
    override init() {
        super.init()
        path = "api/location/"
        method = .get
    }
}
