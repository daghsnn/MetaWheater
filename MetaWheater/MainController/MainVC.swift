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
    
    override func viewDidLoad() {
        viewModel = MainVM()
        viewPage = MainView()
        super.viewDidLoad()
        bindUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureLocation()
    }
    
    override func updateUI() {
        super.updateUI()
        viewPage.viewModel = viewModel
    }
    
    
    fileprivate func bindUI(){
        
        viewPage.didSelectCity = { [weak self] (woeid, name) in
            guard let self = self else { return }
            let vc = WheaterController()
            vc.woeid = woeid
            vc.cityName = name
            self.navigationController?.pushViewController(vc, animated: true)
            
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

extension MainVC : UISearchBarDelegate, CLLocationManagerDelegate {
    
    //MARK:-Location Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        viewModel.fetchRequest(lat: locValue.latitude, long: locValue.longitude)
    }
}

