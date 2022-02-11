//
//  WheaterController.swift
//  MetaWheater
//
//  Created by Hasan Dag on 4.02.2022.
//

import UIKit

final class WheaterController: BaseVC<WheaterVM,WheaterView> {
    var woeid : Int = Int()
    var cityName : String = String()
    override func viewDidLoad() {
        viewModel = WheaterVM()
        viewPage = WheaterView()
        super.viewDidLoad()
        bindUI()
        configureNavController()
    }
    
    override func updateUI() {
        super.updateUI()
        viewPage.viewModel = viewModel
    }
    
    
    fileprivate func bindUI(){
        viewModel.fetchWheater(woeid: woeid)
    }
    
    fileprivate func configureNavController(){
        navigationItem.title = cityName
    }
}
