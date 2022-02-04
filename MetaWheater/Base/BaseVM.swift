//
//  BaseVM.swift
//  MetaWheater
//
//  Created by Hasan Dag on 4.02.2022.
//

import Foundation

enum CallState : Equatable {
    case success
    case failure
}

typealias viewModelState = ((_ state : CallState)->())

class BaseVM: NSObject {
    
    var state : viewModelState?
        
    override init() {
        super.init()
    }
    
}

