//
//  CustomCell.swift
//  MetaWheater
//
//  Created by Hasan Dag on 4.02.2022.
//

import UIKit

class CustomCell: UICollectionViewCell {
//    var model: CityModel? {
//        didSet{
//            configureCell()
//        }
//    }
//
    static let cellId:String = "cityCell"
    
    var label : UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.font = .systemFont(ofSize: 20)
        lbl.textColor = .white
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        label.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
