//
//  MainView.swift
//  MetaWheater
//
//  Created by Hasan Dag on 4.02.2022.
//

import UIKit
import MapKit

final class MainView:BaseView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    //MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath )
        cell.setNeedsDisplay()

        if indexPath.row % 2 == 0 {
            cell.backgroundColor = .red
        }else{
            cell.backgroundColor = .black
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    //MARK:UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 60)
    }
    
    var viewModel : MainVM? {
        didSet{
            DispatchQueue.main.async {
                self.cv.reloadData()
            }
        }
    }
//    var annotions : [CustomPin] = [CustomPin]() {
//        didSet{
//            print(annotions.count)
//        }
//    }
    
    var annotions : [MKPointAnnotation] = [MKPointAnnotation]()
    lazy var mapView : MKMapView = {
        let map = MKMapView()
        map.mapType = .standard
        map.showsUserLocation = true
        return map
    }()
    
    lazy var cv : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        return cv
    }()

    override func configureUI() {
        super.configureUI()

        backgroundColor = .white
        prepareSubview()
        
        //:- Statik olarak annotion tanımlanınca çalışıyor dinamik olarak çalışmıyor?
//        let london = MKPointAnnotation()
//        london.title = "London"
//        london.coordinate = CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275)
//        mapView.addAnnotation(london)
//        let baska = MKPointAnnotation()
//        baska.title = "istanbul"
//        baska.coordinate = CLLocationCoordinate2D(latitude: 40, longitude: 30)
//        mapView.addAnnotation(baska)
    }
  
    
//    fileprivate func createMarkers(location:CLLocationCoordinate2D, title:String) {
//        let marker = MKPointAnnotation()
//        marker.title = title
//        marker.coordinate = location
//        mapView.addAnnotation(marker)
//    }
    
//    fileprivate func createNearCities(){
//        guard let nearCities = viewModel?.responseModel else {return}
//        for cities in nearCities {
//            let latlong = cities.latt_long?.components(separatedBy: ",")
//            guard let lat = latlong?[0], let long = latlong?[1] else {return}
//            let convertedLat = Double(lat) ?? 0.0
//            let convertedLong = Double(long) ?? 0.0
//            let coordinate = CLLocationCoordinate2D(latitude: convertedLat, longitude: convertedLong)
//            let title = cities.title ?? ""
//            createMarkers(location: coordinate, title: title)
//
//        }
//    }
    
    fileprivate func prepareSubview(){
        addSubview(mapView)
        addSubview(cv)
        mapView.snp.makeConstraints { (maker) in
            maker.leading.trailing.top.equalToSuperview()
            maker.height.equalToSuperview().multipliedBy(0.5)
        }
        
        cv.snp.makeConstraints { (maker) in
            maker.top.equalTo(mapView.snp.bottom).inset(-8)
            maker.leading.trailing.equalToSuperview().inset(8)
            maker.bottom.equalToSuperview().offset(-8)
        }
        
        guard let markers = viewModel?.getMarkers() else {return}
        mapView.addAnnotations(markers)

    }
    
    override func updateUI() {
        super.updateUI()
        print("update ui a düştü")
        cv.delegate = self
        cv.dataSource = self
        cv.clipsToBounds = true
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "myCell")
//        guard let markers = viewModel?.getMarkers() else {return}
//        mapView.addAnnotations(markers)
        cv.reloadData()
    }
 
}

extension MainView: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print(view.annotation?.coordinate.latitude, " -----" ,view.annotation?.coordinate.longitude)
        
    }
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        guard annotation is MKPointAnnotation else { return nil }
//
//        let identifier = "Annotation"
//        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
//
//        if annotationView == nil {
//            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//            annotationView!.canShowCallout = true
//        } else {
//            annotationView!.annotation = annotation
//        }
//
//        return annotationView
//    }
    
}
