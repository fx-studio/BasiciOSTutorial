//
//  ViewController.swift
//  DemoCoreLocation
//
//  Created by Le Phuong Tien on 12/25/19.
//  Copyright © 2019 Fx Studio. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    
    //MARK: - Properties
    let locationManager = CLLocationManager()
    
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //delegate
        locationManager.delegate = self
//
//        //request location permission
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.requestLocation()
        
        LocationManager.shared().startUpdating { (location) in
            print("latitude: \(location.coordinate.latitude), longitude: \(location.coordinate.longitude)")
            self.latitudeLabel.text = "\(location.coordinate.latitude)"
            self.longitudeLabel.text = "\(location.coordinate.longitude)"

            if self.count < 10 {
                self.count += 1
            } else {
                LocationManager.shared().stopUpdating()
            }
        }
    }
    
    //MARK: - Actions
    @IBAction func getCurrentLocationTapped(_ sender: Any) {
        print("Get Current Location")
        retriveCurrentLocation()
    }
    
    func retriveCurrentLocation(){
        let status = CLLocationManager.authorizationStatus()
        
        if(status == .denied || status == .restricted || !CLLocationManager.locationServicesEnabled()){
            return
        }
        
        if(status == .notDetermined){
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        // request location data once
        locationManager.requestLocation()
        // updating location
        locationManager.startUpdatingLocation()
        
    }
    
    //MARK: GeoCoder
    func getAddress(location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, _) in
            if let place = placemarks?.first {
                var addressString : String = ""
                if place.subLocality != nil {
                    addressString = addressString + place.subLocality! + ", "
                }
                if place.thoroughfare != nil {
                    addressString = addressString + place.thoroughfare! + ", "
                }
                if place.locality != nil {
                    addressString = addressString + place.locality! + ", "
                }
                if place.country != nil {
                    addressString = addressString + place.country! + ", "
                }
                if place.postalCode != nil {
                    addressString = addressString + place.postalCode! + " "
                }


                print(addressString)
            }
        }
    }
    
}

//MARK: - Location Manager
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("location manager authorization status changed")
        
        switch status {
        case .authorizedAlways:
            print("user allow app to get location data when app is active or in background")
            manager.requestLocation()
            
        case .authorizedWhenInUse:
            print("user allow app to get location data only when app is active")
            manager.requestLocation()
            
        case .denied:
            print("user tap 'disallow' on the permission dialog, cant get location data")
            
        case .restricted:
            print("parental control setting disallow location data")
            
        case .notDetermined:
            print("the location permission dialog haven't shown before, user haven't tap allow/disallow")
            
        default:
            print("default")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("latitude: \(location.coordinate.latitude), longitude: \(location.coordinate.longitude)")
            self.latitudeLabel.text = "\(location.coordinate.latitude)"
            self.longitudeLabel.text = "\(location.coordinate.longitude)"
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
}

