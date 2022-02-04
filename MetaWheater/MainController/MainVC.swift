//
//  MainVC.swift
//  MetaWheater
//
//  Created by Hasan Dag on 4.02.2022.
//


import UIKit
import CoreLocation
import MapKit

final class MainVC: BaseVC<MainVM,MainView> {
    
    let locationManager = CLLocationManager()
    
    private lazy var searchBar : UISearchBar = {
        let sB = UISearchBar(frame: .zero)
        sB.placeholder = "Searching location"
        sB.delegate = self
        return sB
    }()
    
    lazy var mapView : MKMapView = {
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
        cv.backgroundColor = .clear
        return cv
    }()
    override func viewDidLoad() {
        viewModel = MainVM()
        viewPage = MainView()
        super.viewDidLoad()
        bindUI()
        configureNavController()
        configureLocation()
    }
    
    override func updateUI() {
        super.updateUI()
//        viewPage.viewModel = viewModel
        cv.reloadData()
        let markers = viewModel.getMarkers()
        mapView.addAnnotations(markers)


    }
    
    fileprivate func bindUI(){

    }
    
    fileprivate func configureNavController(){
        navigationController?.navigationBar.addSubview(searchBar)
        cv.register(CityCell.self, forCellWithReuseIdentifier: CityCell.cellId)
        view.addSubview(cv)
        cv.snp.makeConstraints { (maker) in
            maker.bottom.leading.trailing.equalToSuperview()
            maker.height.equalToSuperview().multipliedBy(0.5)
        }
        
        view.addSubview(mapView)
        mapView.snp.makeConstraints { (maker) in
            maker.leading.trailing.top.equalToSuperview()
            maker.height.equalToSuperview().multipliedBy(0.5)
        }

    }
    
    func configureLocation() {
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            self.locationManager.startUpdatingLocation()
        }

    }
}

extension MainVC : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CityCell.cellId, for: indexPath ) as! CityCell

        print(cell.model?.title)
    }
    
    //MARK:UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 60)
    }
    
}

extension MainVC : UISearchBarDelegate, CLLocationManagerDelegate,MKMapViewDelegate {

    //MARK:-Location Delegate

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        viewModel.fetchRequest(lat: locValue.latitude, long: locValue.longitude)
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print(view.annotation?.coordinate.latitude, " -----" ,view.annotation?.coordinate.longitude)

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

