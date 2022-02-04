//
//  CityCell.swift
//  MetaWheater
//
//  Created by Hasan Dag on 4.02.2022.
//

import UIKit

class CityCell: UICollectionViewCell {
    var model: CityModel? {
        didSet{
            print("cell model ", model?.woeid)
            configureCell()
        }
    }
    
    static let cellId:String = "cityCell"
    
    private lazy var label : UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.font = .systemFont(ofSize: 20)
        lbl.textColor = .white
        return lbl
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        addSubview(label)
        label.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
            maker.leading.trailing.equalToSuperview()
        }
    }
    
    fileprivate func configureCell(){
        guard let model = model else {return}
        label.text = model.title
    }
}
