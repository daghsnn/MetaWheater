//
//  MainView.swift
//  MetaWheater
//
//  Created by Hasan Dag on 4.02.2022.
//

import UIKit
import MapKit
import SkeletonView

final class MainView:BaseView {
    
    var viewModel : MainVM = MainVM() {
        didSet{
            updateUI()
        }
        willSet {
            mapView.showGradientSkeleton(usingGradient: SkeletonGradient.init(baseColor: .belizeHole, secondaryColor: .amethyst), animated: true, delay: 0, transition: .crossDissolve(0.7))

            cv.showGradientSkeleton(usingGradient: SkeletonGradient.init(baseColor: .carrot, secondaryColor: .amethyst), animated: true, delay: 0, transition: .crossDissolve(0.5))
        }
    }
    
    var didSelectCity: ((_ woeid: Int, _ cityName:String)->())?
    
    private lazy var mapView : MKMapView = {
        let map = MKMapView()
        map.mapType = .standard
        map.showsUserLocation = true
        map.delegate = self
        map.isSkeletonable = true
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
        cv.isSkeletonable = true
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
        let markers = viewModel.getMarkers()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(6)) {
            self.mapView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(1))
            self.cv.hideSkeleton()
            self.cv.reloadData()

        }
        mapView.addAnnotations(markers)
    }
    
}

extension MainView: SkeletonCollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,MKMapViewDelegate {
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return CityCell.cellId
    }
    
    
    
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
