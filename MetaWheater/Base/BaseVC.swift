//
//  BaseVC.swift
//  MetaWheater
//
//  Created by Hasan Dag on 4.02.2022.
//

import UIKit
import SnapKit

protocol ViewModelProtocol: NSObjectProtocol {
    associatedtype ViewModelType: BaseVM
    var viewModel: ViewModelType! { get set }
}
protocol ViewProtocol: NSObjectProtocol {
    associatedtype PageType: BaseView
    var viewPage: PageType! { get set }
}

class BaseVC<VM:BaseVM, V:BaseView>:UIViewController, ViewModelProtocol,ViewProtocol {
    
    var viewModel : VM!
    var viewPage:V!

    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
        configureView()
    }
    
    func updateUI() { }

    fileprivate func bindUI() {
        viewModel.state = { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success:
                self.updateUI()
            case .failure:
                debugPrint("failure")
            }
        }
    }
 
    fileprivate func configureView(){
        view.addSubview(viewPage)
        
        viewPage.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
}
