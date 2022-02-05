//
//  WheaterCell.swift
//  MetaWheater
//
//  Created by Hasan Dag on 5.02.2022.
//

import UIKit

class WheaterCell: UICollectionViewCell {
    
    var model: ConsolidatedWeather? {
        didSet{
            configureCell()
        }
    }
    
    static let cellId:String = "wheaterCell"
    
    private lazy var headerLabel : UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.textAlignment = .center
        lbl.font = .boldSystemFont(ofSize: 20)
        lbl.textColor = .blue

        return lbl
    }()
    
    private lazy var imageView : UIImageView = {
        let imgView = UIImageView(frame: .zero)
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFill

        return imgView
    }()
    
    private lazy var imageDescriptionLbl : UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.textAlignment = .center
        lbl.font = .systemFont(ofSize: 16)
        lbl.textColor = .black

        return lbl
    }()
    
    private lazy var maxDegreeLbl : UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.textAlignment = .center
        lbl.font = .systemFont(ofSize: 16)
        lbl.textColor = .black

        return lbl
    }()
    
    private lazy var minDegreeLbl : UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.textAlignment = .center
        lbl.font = .systemFont(ofSize: 16)
        lbl.textColor = .black

        return lbl
    }()
    
    private lazy var windLbl : UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.textAlignment = .center
        lbl.font = .systemFont(ofSize: 16)
        lbl.textColor = .black
        return lbl
    }()
    
    private lazy var stackView : UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.alignment = .center
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 8
//        stack.translatesAutoresizingMaskIntoConstraints = true
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray
        configureView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        addSubview(headerLabel)
        addSubview(imageView)
        addSubview(imageDescriptionLbl)
        addSubview(stackView)
        stackView.addArrangedSubview(imageDescriptionLbl)
        stackView.addArrangedSubview(maxDegreeLbl)
        stackView.addArrangedSubview(minDegreeLbl)
        stackView.addArrangedSubview(windLbl)

        headerLabel.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
            maker.top.equalToSuperview().inset(16)
        }

        imageView.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(headerLabel.snp.bottom).inset(20)
            maker.width.equalTo(UIView.width * 25)
            maker.height.equalTo(UIView.width * 25)
        }
//
//        imageDescriptionLbl.snp.makeConstraints { (maker) in
//            maker.leading.trailing.equalToSuperview()
//            maker.top.equalTo(imageView.snp.bottom).offset(16)
//        }
//
//        stackView.snp.makeConstraints { (maker) in
//            maker.leading.trailing.equalToSuperview()
//            maker.top.equalTo(imageDescriptionLbl.snp.bottom).offset(8)
//            maker.bottom.equalToSuperview().offset(-8)
//        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = imageView.frame.height / 2
    }
    fileprivate func configureCell(){
        guard let model = model else {return}

        headerLabel.text = "Bugün"
        imageDescriptionLbl.text = model.weatherStateName
        minDegreeLbl.text = "Min: \(model.minTemp ?? 0)ºC"
        maxDegreeLbl.text = "Max: \(model.maxTemp ?? 0)ºC"
        
    }
}
