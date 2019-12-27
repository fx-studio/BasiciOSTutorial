//
//  ViewController.swift
//  DemoMap
//
//  Created by Le Phuong Tien on 12/26/19.
//  Copyright © 2019 Fx Studio. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        // This is coordinate of Eiffel Tower of Pari city.
        //let eiffelTowerLocation = CLLocation(latitude: 48.858042, longitude:  2.294793)
        // Da Nang city
        let dannangLocation = CLLocation(latitude: 16.072163, longitude:  108.227071)
        
        // display map
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: dannangLocation.coordinate, span: span)
        mapView.region = region
        
        //add 1 pin
        //addAnnotation()
        
        //add pins
        //addAnnotations()
        
        //add overlay
        //addOverlayData()
        
        //LocationManager.shared().getCurrentLocation { (location) in
        //    let myPin = MyPin(title: "Me", locationName: "I am here.", coordinate: location.coordinate)
        //    self.mapView.addAnnotation(myPin)
        //}
        
        //routing
        let source = CLLocationCoordinate2D(latitude: 16.071668, longitude: 108.230178)
        addPin(coordinate: source, title: "Vincom", subTitle: "Da Nang, Viet Nam")
        
        let destination = CLLocationCoordinate2D(latitude: 16.080838, longitude: 108.238573)
        addPin(coordinate: destination, title: "Asian Tech", subTitle: "Da Nang, Viet Nam")
        
        routing(source: source, destination: destination)
        
    }
    
    //MARK: -  Annotation
    func addAnnotation() {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 16.071763, longitude: 108.223963)
        annotation.title = "Point 0001"
        annotation.subtitle = "subtitle 0001"
        
        mapView.addAnnotation(annotation)
    }
    
    func addPin(coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
    
    func addPin(coordinate: CLLocationCoordinate2D, title: String, subTitle: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        annotation.subtitle = subTitle
        mapView.addAnnotation(annotation)
    }
    
    func addAnnotations() {
        
        let pins: [MyPin] = [MyPin(title: "Point 0001", locationName: "Point 0001", coordinate: CLLocationCoordinate2D(latitude: 16.071763, longitude: 108.223963)),
                             MyPin(title: "Point 0002", locationName: "Point 0002", coordinate: CLLocationCoordinate2D(latitude: 16.074443, longitude: 108.224443)),
                             MyPin(title: "Point 0003", locationName: "Point 0003", coordinate: CLLocationCoordinate2D(latitude: 16.073969, longitude: 108.228798)),
                             MyPin(title: "Point 0004", locationName: "Point 0004", coordinate: CLLocationCoordinate2D(latitude: 16.069783, longitude: 108.225086)),
                             MyPin(title: "Point 0005", locationName: "Point 0005", coordinate: CLLocationCoordinate2D(latitude: 16.070629, longitude: 108.228563))]
        
        mapView.addAnnotations(pins)
    }
    
    //MARK: - Display Map
    func center(location: CLLocation) {
        //center
        mapView.setCenter(location.coordinate, animated: true)
        
        //zoom
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        //show current location
        mapView.showsUserLocation = true
        
        //add 1 pin
        addAnnotation()
    }
    
    func zoom(location: CLLocation, span: Float) {
        let span = MKCoordinateSpan(latitudeDelta: CLLocationDegrees(span), longitudeDelta: CLLocationDegrees(span))
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }

    //MARK: -  Overlay Map
    func addOverlayData() {
        let coordinates = [
            CLLocationCoordinate2D(latitude: 16.071763, longitude: 108.223963),
            CLLocationCoordinate2D(latitude: 16.074443, longitude: 108.224443),
            CLLocationCoordinate2D(latitude: 16.073969, longitude: 108.228798),
            CLLocationCoordinate2D(latitude: 16.069783, longitude: 108.225086),
            CLLocationCoordinate2D(latitude: 16.070629, longitude: 108.228563)
        ]
        
        for center in coordinates {
            let radius = 100.0 //Distance unit: meters
            let overlay = MKCircle(center: center, radius: radius)
            
            //add circle
            mapView.addOverlay(overlay)
            
            //add pin
            addPin(coordinate: center)
        }
    }
    
    //MARK: - Routing
    func routing(source: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: source, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination, addressDictionary: nil))
        request.requestsAlternateRoutes = true
        request.transportType = .automobile

        let directions = MKDirections(request: request)

        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }

            for route in unwrappedResponse.routes {
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }
    
    //MARK: - Actions
    @IBAction func movetoCurrentLocaltion(_ sender: Any) {
        LocationManager.shared().getCurrentLocation { (location) in
            self.center(location: location)
        }
    }
    
}

//MARK: - MapView Delegate
extension ViewController: MKMapViewDelegate {
    //MARK: - Annotation View
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let pin = annotation as? MKPointAnnotation {
            let identifier = "pin"
            var view: MKPinAnnotationView
            
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
                
            } else {
                view = MKPinAnnotationView(annotation: pin, reuseIdentifier: identifier)
                view.animatesDrop = true
                view.pinTintColor = .green
                view.canShowCallout = true
            }
            
            return view
            
        } else if let annotation = annotation as? MyPin {
            let identifier = "mypin"
            var view: MyPinView
            
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MyPinView {
                dequeuedView.annotation = annotation
                view = dequeuedView
                
            } else {
                view = MyPinView(annotation: annotation, reuseIdentifier: identifier)
                let button = UIButton(type: .detailDisclosure)
                button.addTarget(self, action: #selector(selectPinView(_:)), for: .touchDown)
                view.rightCalloutAccessoryView = button
                view.leftCalloutAccessoryView = UIImageView(image: UIImage(named: "pin"))
                view.canShowCallout = true
            }
            
            return view
        } else {
            return nil
        }
    }
    
    //MARK: - Action
    @objc func selectPinView(_ sender: UIButton?) {
        print("select button detail")
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("selected callout")
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("selected pin")
    }
    
    //MARK: - Renderer
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 3
            return renderer
            
        } else if let circle = overlay as? MKCircle {
            let circleRenderer = MKCircleRenderer(circle: circle)
            circleRenderer.fillColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.5)
            circleRenderer.strokeColor = .blue
            circleRenderer.lineWidth = 1
            circleRenderer.lineDashPhase = 10
            return circleRenderer
            
        } else {
            return MKOverlayRenderer()
        }
        
    }
}



