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
    
    lazy var cv : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .clear
        return cv
    }()
    override func viewDidLoad() {
        self.viewModel = MainVM()
        self.viewPage = MainView()
        super.viewDidLoad()
        bindUI()
        configureNavController()
        configureLocation()
    }
    
    override func updateUI() {
        super.updateUI()
        viewPage.updateUI()
        // Annotions hala çalışmıyor
//        let annotions = viewModel.getMarkers()
//        viewPage.mapView.addAnnotations(annotions)
        cv.reloadData()
        viewPage.viewModel = viewModel

    }
    
    fileprivate func bindUI(){

    }
    
    fileprivate func configureNavController(){
        navigationController?.navigationBar.addSubview(searchBar)
        view.addSubview(cv)
        cv.snp.makeConstraints { (maker) in
            maker.bottom.leading.trailing.equalToSuperview()
            maker.height.equalToSuperview().multipliedBy(0.5)
        }
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "myCell")

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

extension MainVC : UICollectionViewDelegate,UICollectionViewDataSource, UISearchBarDelegate, CLLocationManagerDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
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
    

    //MARK:-Searchbar Delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

    }
    //MARK:-Location Delegate

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        viewModel.fetchRequest(lat: locValue.latitude, long: locValue.longitude)
    }


}

