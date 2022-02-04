//
//  BaseView.swift
//  MetaWheater
//
//  Created by Hasan Dag on 4.02.2022.
//

import UIKit

class BaseView: UIView {

    //MARK: - UI Properties
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = true
        return scrollView
    }()
    
//    let heightLayout = UIApplication.shared.windows.first{ $0.isKeyWindow }?.safeAreaInsets.top ?? 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        configureUI()
    }
    
    init() {
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Override Functions
    func configureUI() { }
    func updateUI() { }
    
    //MARK: - Private Functions
    func configureScrollView() {
        if subviews.contains(scrollView) {
            scrollView.removeFromSuperview()
        }
        addSubview(scrollView)
        
        scrollView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
}
