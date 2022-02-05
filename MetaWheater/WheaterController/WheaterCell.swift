//
//  WheaterCell.swift
//  MetaWheater
//
//  Created by Hasan Dag on 5.02.2022.
//

import UIKit
import SDWebImage

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
        lbl.textColor = .systemYellow

        return lbl
    }()
    
    private lazy var imageView : UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
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
        lbl.textColor = .systemRed

        return lbl
    }()
    
    private lazy var minDegreeLbl : UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.textAlignment = .center
        lbl.font = .systemFont(ofSize: 16)
        lbl.textColor = .systemIndigo

        return lbl
    }()
    private lazy var windDescription : UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.textAlignment = .center
        lbl.font = .systemFont(ofSize: 14)
        lbl.textColor = .darkGray
        return lbl
    }()
    
    private lazy var windLbl : UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.textAlignment = .center
        lbl.font = .systemFont(ofSize: 16)
        lbl.textColor = .darkGray
        return lbl
    }()
    
    private lazy var humidityLbl : UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.textAlignment = .center
        lbl.font = .systemFont(ofSize: 16)
        lbl.textColor = .systemGreen
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
        backgroundColor = .clear
        clipsToBounds = true
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
        stackView.addArrangedSubview(maxDegreeLbl)
        stackView.addArrangedSubview(minDegreeLbl)
        stackView.addArrangedSubview(windDescription)
        stackView.addArrangedSubview(windLbl)
        stackView.addArrangedSubview(humidityLbl)

        headerLabel.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
            maker.top.equalToSuperview().inset(16)
        }

        imageView.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(headerLabel.snp.bottom).inset(-20)
            maker.width.equalTo(200)
            maker.height.equalTo(200)
        }

        imageDescriptionLbl.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
            maker.top.equalTo(imageView.snp.bottom).inset(-8)
        }

        stackView.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
            maker.top.equalTo(imageDescriptionLbl.snp.bottom).offset(UIView.height * 0.05)
            maker.bottom.equalToSuperview().inset(UIView.height * 0.1)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 25
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(white: 0.5, alpha: 0.5).cgColor
        imageView.layer.cornerRadius = imageView.frame.height / 2
    }
    
    fileprivate func configureCell(){
        guard let model = model else {return}

        headerLabel.text =  model.applicableDate
        
        let url = Bundle.main.object(forInfoDictionaryKey: "BaseUrl") as! String + "static/img/weather/png/\(model.weatherStateAbbr ?? "").png"

        imageView.sd_setImage(with: URL(string: url), completed: nil)
        imageDescriptionLbl.text = model.weatherStateName
        minDegreeLbl.text = "Min: \(Int(model.minTemp ?? 0.0))ºC"
        maxDegreeLbl.text = "Max: \(Int(model.maxTemp ?? 0.0))ºC"
        windDescription.text = "\(Int(model.windDirection ?? 0.0)) \(model.windDirectionCompass ?? "") Direction"
        windLbl.text = "\(model.windSpeed ?? 0.0) MP/h"
        humidityLbl.text = "\(Int(model.humidity ?? 0.0)) Humidity"
        
    }
}
