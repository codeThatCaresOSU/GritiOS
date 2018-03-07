//
//  ResourcesViewController.swift
//  GRIT
//
//  Created by Jake Alvord on 4/30/17.
//  Copyright © 2017 CodeThatCares. All rights reserved.
//
import UIKit
import MapKit
import CoreLocation

class CustomAnnotation : MKPointAnnotation {
    var address : String? = nil
    var url : String? = nil
    var phone : String? = nil
}

class ResourcesViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, ModalViewControllerDelegate {
    
    // sets up locationManager
    var locationManager: CLLocationManager!
    
    // declares the views
    let mapView = MKMapView()
    let modalView = ModalViewController()
    let annotationView = MKAnnotationView()
    
    // declares necessary buttons
    let filterButton = UIButton()
    let directionsButton = UIButton()
    let websiteButton = UIButton()
    let callButton = UIButton()
    
    // delcares annotation for mapView
    var selectedAnnotation: CustomAnnotation?
    
    //let subview = UIView()
    //let map_view = UIView()
    //let map = MKMapView()
    //let modal_view = ModalViewController()
    //var locationManager : CLLocationManager!
    //let temp_ann = MKAnnotationView()
    //let filter = UIButton()
    //let button = UIButton()
    //var selected_annotation: MKPointAnnotation?
    
    let locale = CLLocationCoordinate2DMake(39.9612, -82.9988)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.navigationController?.navigationBar.topItem?.title = "Resources"
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let navigationBarHeight = (self.tabBarController?.navigationController?.navigationBar.frame.height)!
        let tabBarHeight = (self.tabBarController?.tabBar.frame.height)!
        let totalTopHeight = statusBarHeight + navigationBarHeight
        let totalWidth = self.view.bounds.width
        let totalHeight = self.view.bounds.height - totalTopHeight - tabBarHeight
        let spacer = totalWidth/20
 
     
        // locationManager declaration
        // helps to request and grab user's location
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        //self.view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        // sets mapView delegate to self
        self.mapView.delegate = self
        
        // sets modal_view delegate to self
        self.modalView.delegate = self
        
        // sets map shows users location (if possible)
        mapView.frame = CGRect(x: 0, y: totalTopHeight, width: totalWidth, height: totalHeight)
        mapView.showsUserLocation = true
        
        // sets up filterButton parameters and target function
        let buttonSize = totalWidth/4
        filterButton.frame = CGRect(x: spacer, y: totalHeight + totalTopHeight - buttonSize - spacer, width: buttonSize, height: buttonSize)
        filterButton.setTitle("Filter", for: .normal)
        filterButton.setTitleColor(UIColor.white, for: .normal)
        filterButton.layer.cornerRadius = filterButton.frame.width/2
        filterButton.layer.masksToBounds = true
        filterButton.backgroundColor = UIColor.lightGray
        filterButton.addTarget(self, action: #selector(displayFilter), for: .touchUpInside)
        
        // sets up directionsButton and target function
        directionsButton.frame = CGRect(x: totalWidth/2 - buttonSize/2, y: totalHeight + totalTopHeight - buttonSize - spacer, width: buttonSize, height: buttonSize)
        directionsButton.setTitle("Directions", for: .normal)
        directionsButton.setTitleColor(UIColor.white, for: .normal)
        directionsButton.layer.cornerRadius = directionsButton.frame.width/2
        directionsButton.layer.masksToBounds = true
        directionsButton.backgroundColor = UIColor.red
        directionsButton.addTarget(self, action: #selector(openInMaps), for: .touchUpInside)
        directionsButton.isHidden = true
        
        // sets up websiteButton and target function
        websiteButton.frame = CGRect(x: totalWidth - spacer - buttonSize, y: totalHeight + totalTopHeight - buttonSize - spacer, width: buttonSize, height: buttonSize)
        websiteButton.setTitle("Website", for: .normal)
        websiteButton.setTitleColor(UIColor.white, for: .normal)
        websiteButton.layer.cornerRadius = websiteButton.frame.width/2
        websiteButton.layer.masksToBounds = true
        websiteButton.backgroundColor = UIColor.blue
        websiteButton.addTarget(self, action: #selector(openWebsite), for: .touchUpInside)
        websiteButton.isHidden = true
        
        // TODO: implement call button
        /*
        callButton.frame = CGRect(x: spacer, y: totalHeight + totalTopHeight - 2 * buttonSize - 2 * spacer, width: buttonSize, height: buttonSize)
        callButton.setTitle("Call", for: .normal)
        callButton.setTitleColor(UIColor.white, for: .normal)
        callButton.layer.cornerRadius = callButton.frame.width/2
        callButton.layer.masksToBounds = true
        callButton.backgroundColor = UIColor.green
        callButton.addTarget(self, action: #selector(callBusiness), for: .touchUpInside)
        callButton.isHidden = true
        */
        
        // adds subviews into view
        self.view.addSubview(mapView)
        self.view.addSubview(filterButton)
        self.view.addSubview(directionsButton)
        self.view.addSubview(websiteButton)
        //self.view.addSubview(callButton)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            
            //            manager.startUpdatingLocation()
            //            map.userTrackingMode = .follow
            //            let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
            //            let region = MKCoordinateRegion(center: (manager.location?.coordinate)!, span: span)
            //            map.setRegion(region, animated: true)
            break
            
        case .denied, .restricted:
            let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
            let region = MKCoordinateRegion(center: locale, span: span)
            mapView.setRegion(region, animated: true)
            break
            
        default:
            manager.requestWhenInUseAuthorization()
            break
        }
        
    }
    
    @objc func displayFilter() {
        if filterButton.isHidden == false {
            
            // hide the filterButton
            filterButton.isHidden = true
            
            // remove annotations from mapView
            if self.mapView.annotations.count > 1 {
                self.mapView.removeAnnotations(self.mapView.annotations)
            }
            
            // display the modal filter view
            modalView.modalPresentationStyle = .overFullScreen
            self.present(self.modalView, animated: true, completion: nil)
        }
    }
    
    
    func dismissFilter(modalText: Array<String>) {
        // dismiss the filter modal view
        self.modalView.dismiss(animated: true, completion: nil)

        // replace the filterButton
        if filterButton.isHidden == true {
            filterButton.isHidden = false
        }
        
        // populate mapView with annotations
        populate(modalText: modalText)
        print(modalText)
    }
    
    func populate(modalText: Array<String>) {
        
        //TO-DO move all of the processing somewhere else, we shouldnt be doing it in the viewcontroller
        
        FirebaseManager.sharedInstance.getBusinesses() {
            businesses in
            
            for business in businesses {
                
                if (modalText.contains(business.category)) {
                    
                    let geoCoder = CLGeocoder()
                    
                    let street = business.street + ", "
                    let city = business.city + ", "
                    let state = business.state + ", "
                    let zip = business.zip
                    var newZip = ""
                    if zip != nil {
                        newZip = String(zip!)
                    }
                    
                    let address : String! = street + city + state + newZip
                    
                    geoCoder.geocodeAddressString(address) { (placemarks, error) in
                        guard
                            let placemarks = placemarks,
                            let locat = placemarks.first?.location
                            else {
                                // handle no location found
                                return
                        }
                        
                        let pin = CustomAnnotation()
                        pin.coordinate = locat.coordinate
                        pin.title = business.name
                        pin.subtitle = business.category
                        pin.address = address
                        pin.phone = business.phone
                        
                        if !business.url.isEmpty {
                            pin.url = business.url
                        }
                        
                        //self.annotationView.annotation = pin
                        
                        self.mapView.addAnnotation(pin)//self.annotationView.annotation!)
                        
                    }
                    
                }
            }
        }
        
    }
    
    
    /*
    
     func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
     guard !(annotation is MKUserLocation) else { return nil }
     
     let identifier = "pin"
     
     var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
     
     if annotationView == nil {
     annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
     //annotationView?.pinTintColor = UIColor.green
     annotationView?.canShowCallout = true
     } else {
     annotationView?.annotation = annotation
     }
     
     return annotationView
     }
     */
    

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.selectedAnnotation = view.annotation as? CustomAnnotation
        directionsButton.isHidden = false
        callButton.isHidden = false
        
        if !(self.selectedAnnotation!.url!.isEmpty) {
            websiteButton.isHidden = false
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        directionsButton.isHidden = true
        websiteButton.isHidden = true
        callButton.isHidden = true
    }

    @objc func openInMaps() {
        let placemark = MKPlacemark(coordinate: (self.selectedAnnotation!.coordinate))
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.selectedAnnotation?.title
        mapItem.openInMaps()
    }
    
    @objc func openWebsite() {
        let url = URL(string: self.selectedAnnotation!.url!)
        UIApplication.shared.open(url!)
    }
    
    @objc func callBusiness() {
        var phone = self.selectedAnnotation!.phone!
        phone = phone.replacingOccurrences(of: "\\D", with: "", options: .regularExpression, range: phone.startIndex..<phone.endIndex)
        print(phone)
        let phoneNumber = URL(string: "tel://" + phone)
        UIApplication.shared.open(phoneNumber!)
    }
}
