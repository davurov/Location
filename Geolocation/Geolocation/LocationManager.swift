//
//  LocationManager.swift
//  Geolocation
//
//  Created by Abduraxmon on 26/03/23.
//

import Foundation
import CoreLocation

class LoacationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LoacationManager()
    
    let manager = CLLocationManager()
    var complition: ((CLLocation) -> Void)?
    
    public func getUserLocation(complition: @escaping((CLLocation) -> Void)) {
        self.complition = complition
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        manager.startUpdatingLocation()
    }
    
    public func resolveLocationName(with location: CLLocation, complition: @escaping ((String?) -> Void)) {
        let geaocoder = CLGeocoder()
        geaocoder.reverseGeocodeLocation(location, preferredLocale: .current) { placemarks, error in
            guard let place = placemarks?.first, error == nil else {
                complition(nil)
                return
            }
            print(place)
            
            var name = ""
            
            if let locality = place.locality {
                name += locality
            }
            
            if let adminRegion = place.administrativeArea {
                name += ", \(adminRegion)"
            }
            
            complition(name)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        complition?(location)
        manager.stopUpdatingLocation()
    }
    
}
