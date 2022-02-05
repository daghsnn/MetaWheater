//
//  MainView.swift
//  MetaWheater
//
//  Created by Hasan Dag on 4.02.2022.
//

import UIKit
import MapKit

final class MainView:BaseView {
    
    var viewModel : MainVM = MainVM() {
        didSet{
            updateUI()
        }
    }
    
    var didSelectCity: ((_ woeid: Int, _ cityName:String)->())?
    
    private lazy var mapView : MKMapView = {
        let map = MKMapView()
        map.mapType = .standard
        map.showsUserLocation = true
        map.delegate = self
        return map
    }()
    
    private lazy var cv : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.isScrollEnabled = true
        cv.backgroundColor = .clear
        return cv
    }()
    
    override func configureUI() {
        super.configureUI()
        backgroundColor = .white
        prepareSubview()
    }
    
    fileprivate func prepareSubview(){
        cv.register(CityCell.self, forCellWithReuseIdentifier: CityCell.cellId)
        
        addSubview(mapView)
        addSubview(cv)
        mapView.snp.makeConstraints { (maker) in
            maker.leading.trailing.top.equalToSuperview()
            maker.height.equalToSuperview().multipliedBy(0.7)
        }
        cv.snp.makeConstraints { (maker) in
            maker.top.equalTo(mapView.snp.bottom).inset(-8)
            maker.leading.trailing.equalToSuperview().inset(8)
            maker.bottom.equalToSuperview().offset(-8)
        }
    }
    
    override func updateUI() {
        super.updateUI()
        
        DispatchQueue.main.async {
            self.cv.reloadData()
        }
        let markers = viewModel.getMarkers()
        mapView.addAnnotations(markers)
    }
    
}

extension MainView: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,MKMapViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.responseModel?.count ?? 0
    }
    
    //MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CityCell.cellId, for: indexPath ) as! CityCell
        cell.model = viewModel.getCity(index: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let woeid = viewModel.responseModel?[indexPath.row] else {return}
        self.didSelectCity?(woeid.woeid ?? 0, woeid.title ?? "")
    }
    
    //MARK:UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 60)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let woeid = view.annotation?.subtitle, let name = view.annotation?.title else {return}
        guard let intWoeid = Int(woeid ?? "0") else { return }
        view.isSelected = false
        self.didSelectCity?(intWoeid, name ?? "")
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        return annotationView
    }
}
