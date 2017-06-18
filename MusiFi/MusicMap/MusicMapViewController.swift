//
//  MusicMapViewController.swift
//  MusiFi
//
//  Created by Andrei Rybak on 3/27/17.
//  Copyright © 2017 Andrei Rybak. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MusicMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    fileprivate var userRegion: MKCoordinateRegion? = nil
    fileprivate var isRegionsSetted: Bool = false
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Colors.dark
        
        self.mapView.delegate = self
        self.mapView.mapType = .hybrid
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if userRegion != nil {
            mapView.setRegion(userRegion!, animated: true)
        }
        
        setAnnotationOnMap()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        isRegionsSetted = false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard isRegionsSetted == false else { return }
        
        let location = locations[0]
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let myLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegionMake(myLocation, span)
        userRegion = region
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
        isRegionsSetted = true
    }

    fileprivate func setAnnotationOnMap() {
        let annotation =  MKPointAnnotation()
        
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        
        SessionController.getTracks { (tracks) in
            for track in tracks {
                annotation.coordinate.latitude = Double(track.latitude)!
                annotation.coordinate.longitude = Double(track.longitude)!
                annotation.title = track.name
                annotation.subtitle = track.artist
                self.mapView.addAnnotation(annotation)
            }
        }
    }
    
    //MARK: MKMapViewDelegate methods
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MKPointAnnotation) {
            return nil
        }
        
        let annotationIdentifier = "AnnotationIdentifier"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView!.canShowCallout = true
        }
        else {
            annotationView!.annotation = annotation
        }
        
        let pinImage = UIImage(named: "pin_annotation")
        annotationView!.image = pinImage
        
        return annotationView
    }
    
    
}
