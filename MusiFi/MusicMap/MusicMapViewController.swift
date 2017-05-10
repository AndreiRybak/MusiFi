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
    
    let locationManager = CLLocationManager()
    
    
    //TODO: FAKE DATA
    fileprivate let longitude = 21.2312312
    fileprivate let latitude = 53.703173975086926


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Colors.dark
        
        self.mapView.delegate = self
        self.mapView.mapType = .hybrid
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        setAnnotationOnMap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let myLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegionMake(myLocation, span)
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
    }
    
    //TODO: SET ALL ANNOTATIONS FROM REQUSTED DATA
    fileprivate func setAnnotationOnMap() {
        let annotation =  MKPointAnnotation()
        
        annotation.coordinate.latitude = self.latitude
        annotation.coordinate.longitude = self.longitude
        annotation.title = "Annotation title"
        annotation.subtitle = "Annotation subtitle"
        self.mapView.addAnnotation(annotation)
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
        
        //TODO: CHANGE PIN ICON
        let pinImage = UIImage(named: "pin_annotation")
        annotationView!.image = pinImage
        
        return annotationView
    }
    
    
}
