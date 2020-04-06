//
//  HomeViewController.swift
//  Search Routes
//
//  Created by Luis Gustavo Oliveira Silva on 04/04/20.
//  Copyright © 2020 Luis Gustavo Oliveira Silva. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class HomeViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
     let locationManager = CLLocationManager()
     let regionInMeters: Double = 600
    var directionsArray: [MKDirections] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        hidekeyboard()
        checkLocationServices()
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        map.delegate = self
    }
       
    func getAddress() {
        map.removeOverlays(map.overlays)
        let geoCoder = CLGeocoder()
        guard let textField = textFieldSearch.text else {return}
        geoCoder.geocodeAddressString(textField) { (placemarks, error) in
            guard let placemarks = placemarks, let location = placemarks.first?.location
                else {
                    let alert = UIAlertController(title: "Attention", message: "Invalid address", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
            }
            print(location)
            self.mapThis(destinationCord: location.coordinate)
            
        }
    }
    
    func mapThis(destinationCord : CLLocationCoordinate2D) {
        
        let souceCordinate = (locationManager.location?.coordinate)!
        
        let soucePlaceMark = MKPlacemark(coordinate: souceCordinate)
        let destPlaceMark = MKPlacemark(coordinate: destinationCord)
        
        let sourceItem = MKMapItem(placemark: soucePlaceMark)
        let destItem = MKMapItem(placemark: destPlaceMark)
        
        let destinationRequest = MKDirections.Request()
        destinationRequest.source = sourceItem
        destinationRequest.destination = destItem
        destinationRequest.transportType = .automobile
        destinationRequest.requestsAlternateRoutes = true
        
        
        let directions = MKDirections(request: destinationRequest)
        directions.calculate { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("Something is wrong :(")
                }
                return
            }
          let route = response.routes[0]
          self.map.addOverlay(route.polyline)
          self.map.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            
        }
    }
    
    func resetMapView(withNew directions: MKDirections) {
        map.removeOverlays(map.overlays)
        directionsArray.append(directions)
        let _ = directionsArray.map { $0.cancel() }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        render.strokeColor = #colorLiteral(red: 0.8039215686, green: 0.8039215686, blue: 0.8039215686, alpha: 1)
          return render
      }
    
       func checkLocationServices() {
           if CLLocationManager.locationServicesEnabled() {
               setupLocationManager()
               checkLocationAuthorization()
           } else {
               
           }
       }
       
       func centerViewOnUserLocation() {
           if let location = locationManager.location?.coordinate {
               let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
               map.setRegion(region, animated: true)
           }
       }
       
       func checkLocationAuthorization() {
           switch CLLocationManager.authorizationStatus() {
           case .authorizedWhenInUse:
               map.showsUserLocation = true
               centerViewOnUserLocation()
               break
           case .denied:
               // Show alert instructing them how to turn on permissions
               break
           case .notDetermined:
               locationManager.requestWhenInUseAuthorization()
               break
           case .restricted:
               // Show an alert letting them know what's up
               break
           case .authorizedAlways:
               break
           }
       }
    
    @objc func actionButtonSearch() {
       getAddress()
    }

    private lazy var map: MKMapView = {
        let map = MKMapView()
        return map
    }()
    
    private lazy var textFieldSearch: UITextField = {
        let textFieldSearch = UITextField(frame: .zero)
        textFieldSearch.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        textFieldSearch.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        textFieldSearch.placeholder = "Enter destination address"
        textFieldSearch.clipsToBounds = true
        textFieldSearch.layer.cornerRadius = 10
        return textFieldSearch
    }()
    
    private lazy var buttonSearch: UIButton = {
        let buttonSearch = UIButton(frame: .zero)
        buttonSearch.setTitle("Search", for: .normal)
        buttonSearch.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        buttonSearch.clipsToBounds = true
        buttonSearch.layer.cornerRadius = 10
        buttonSearch.addTarget(self, action: #selector(actionButtonSearch), for: .touchUpInside)
        return buttonSearch
    }()
    
    func contraintsMap() {
        map.translatesAutoresizingMaskIntoConstraints = false
        let topMap = map.topAnchor.constraint(equalTo: view.topAnchor)
        let leadingMap = map.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let trailingMap = map.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let bottomMap = map.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        NSLayoutConstraint.activate([topMap, leadingMap, trailingMap, bottomMap])
    }
    
    func contraintsTextFieldSearch() {
        textFieldSearch.translatesAutoresizingMaskIntoConstraints = false
        let topTextFieldSearch = textFieldSearch.topAnchor.constraint(equalTo: buttonSearch.topAnchor)
        let bottomTextFieldSearch = textFieldSearch.bottomAnchor.constraint(equalTo: buttonSearch.bottomAnchor)
        let leadingTextFieldSearch = textFieldSearch.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15)
        let trailingTextFieldSearch = textFieldSearch.trailingAnchor.constraint(equalTo: buttonSearch.leadingAnchor, constant:-10)
        NSLayoutConstraint.activate([topTextFieldSearch, leadingTextFieldSearch, trailingTextFieldSearch, bottomTextFieldSearch])
    }
    
    func contraintsButton() {
        buttonSearch.translatesAutoresizingMaskIntoConstraints = false
        let topButtonSearch = buttonSearch.topAnchor.constraint(equalTo: view.topAnchor , constant: 40)
        let trailingButtonSearch = buttonSearch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15)
        let widthButtonSearch = buttonSearch.widthAnchor.constraint(equalToConstant: 70)
        let leadinguttonSearch = buttonSearch.leadingAnchor.constraint(equalTo: textFieldSearch.trailingAnchor, constant: 10)
        NSLayoutConstraint.activate([topButtonSearch, trailingButtonSearch, widthButtonSearch, leadinguttonSearch])
    }
    
}
extension HomeViewController: ViewLayoutHelper {
    func buildViewHierarchy() {
        view.addSubview(map)
        view.addSubview(textFieldSearch)
        view.addSubview(buttonSearch)
    }
    
    func setupContraints() {
        contraintsMap()
        contraintsTextFieldSearch()
        contraintsButton()
    }
    
    func setupAdditionalConfiguration() {
        self.view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
}
