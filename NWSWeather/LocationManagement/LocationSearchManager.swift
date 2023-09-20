//
//  LocationSearchManager.swift
//  NWSWeather
//
//  Created by Jason Koehn on 9/15/23.
//

import Foundation
import MapKit
import Combine

struct SearchedLocation: Identifiable {
    var id: UUID
    var city: String
    var state: String
    var latitude: Double
    var longitude: Double
    init(city: String, state: String, latitude: Double, longitude: Double) {
        self.id = UUID()
        self.city = city
        self.state = state
        self.latitude = latitude
        self.longitude = longitude
    }
}

class LocationSearchManager: NSObject, ObservableObject {
    @Published var searchText: String = ""
    @Published var fetchedPlace: SearchedLocation?
    var cancellable: AnyCancellable?
    
    override init() {
        super .init()
        cancellable = $searchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink(receiveValue: { value in
                if value != "" {
                    self.getCities(value: value)
                } else {
                    self.fetchedPlace = nil
                }
            })
    }
    
    func getCities(value: String) {
        self.getCoordinate(addressString: value) { coordinate, place, error in
            // Can get other items like country, address, and zipcode if needed
            if place?.locality != "" && place?.country == "United States" {
                self.fetchedPlace = SearchedLocation(city: place?.locality ?? "", state: place?.administrativeArea ?? "", latitude: coordinate.latitude, longitude: coordinate.longitude)
            }
        }
    }
    
    func getCoordinate( addressString : String, completionHandler: @escaping(CLLocationCoordinate2D, CLPlacemark?, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    completionHandler(location.coordinate, placemark, nil)
                    return
                }
            }
            completionHandler(kCLLocationCoordinate2DInvalid, nil, error as NSError?)
        }
    }
}
