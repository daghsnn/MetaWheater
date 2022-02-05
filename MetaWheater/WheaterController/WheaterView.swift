//
//  WheaterView.swift
//  MetaWheater
//
//  Created by Hasan Dag on 4.02.2022.
//

import UIKit

final class WheaterView:BaseView {
    
    var viewModel : WheaterVM? {
        didSet{
            updateUI()
        }
    }
    
    private lazy var cv : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.showsHorizontalScrollIndicator = true
        cv.isPagingEnabled = true
        cv.backgroundColor = .clear
        return cv
    }()
    
    override func configureUI() {
        super.configureUI()
        backgroundColor = .white
        prepareSubview()
    }
    
    fileprivate func prepareSubview(){
        cv.register(WheaterCell.self, forCellWithReuseIdentifier: WheaterCell.cellId)
        addSubview(cv)
        cv.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.leading.trailing.equalToSuperview().inset(16)
            maker.height.equalTo(UIView.height * 0.75)
            maker.bottom.equalToSuperview().inset(UIView.height * 0.1)
        }
    }
    
    override func updateUI() {
        super.updateUI()
        DispatchQueue.main.async {
            self.cv.reloadData()
        }
    }
}

extension WheaterView: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.responseModel?.consolidatedWeather?.count ?? 0
    }
    //MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WheaterCell.cellId, for: indexPath ) as! WheaterCell
        cell.model = viewModel?.responseModel?.consolidatedWeather?[indexPath.row]
        return cell
    }
    //MARK:UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}
