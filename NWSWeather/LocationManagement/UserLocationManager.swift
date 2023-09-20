//
//  UserLocationManager.swift
//  NWSWeather
//
//  Created by Jason Koehn on 9/15/23.
//

import Foundation
import CoreLocation

class UserLocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    @Published var authorisationStatus: CLAuthorizationStatus?
    
    var latitude: Double {
        locationManager.location?.coordinate.latitude ?? 37.322998
    }
    var longitude: Double {
        locationManager.location?.coordinate.longitude ?? -122.032181
    }
    
    override init() {
        super .init()
        locationManager.delegate = self
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            authorisationStatus = .authorizedWhenInUse
            locationManager.requestLocation()
            break
        case .restricted:
            authorisationStatus = .restricted
            break
        case .denied:
            authorisationStatus = .denied
            break
        case .notDetermined:
            authorisationStatus = .notDetermined
            manager.requestWhenInUseAuthorization()
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // for determining if location is updating
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("\(error.localizedDescription)")
    }
    
    // Reverse Geocode user location
    func getUserAddress(latitude: Double, longitude: Double, completionHandler: @escaping(CLPlacemark?, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    completionHandler(placemark, nil)
                    return
                }
            }
            completionHandler(nil, error as NSError?)
        }
    }
}
