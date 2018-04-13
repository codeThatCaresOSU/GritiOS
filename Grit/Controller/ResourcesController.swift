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

class ResourcesViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, ModalControllerDelegate, TutorialControllerDelegate, TutorialModalDelegate {
    
    // sets up locationManager
    var locationManager: CLLocationManager!
    
    // declares the views
    let mapView = MKMapView()
    let filterModalView = ModalController()
    let tutorialPageControllerView = TutorialController()
    let tutorialModalView = TutorialModal()
    let annotationView = MKAnnotationView()
    
    // declares necessary buttons
    let filterButton = UIButton()
    let directionsButton = UIButton()
    let websiteButton = UIButton()
    let callButton = UIButton()
    
    // delcares annotation for mapView
    var selectedAnnotation: CustomAnnotation?
    
    let locale = CLLocationCoordinate2DMake(39.9612, -82.9988)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo"))
        
        let width = self.view.bounds.width
        let height = self.view.bounds.height - (self.tabBarController?.tabBar.frame.size.height)!
        let spacer = width/32
        
        let buttonSize = width/4
        
        // requests location
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        // sets map delegate to self
        self.mapView.delegate = self
        
        // sets modalController delegate to self
        self.filterModalView.modalDelegate = self
        
        // sets tutorialController delegate to self
        self.tutorialPageControllerView.tutorialDelegate = self
        
        // sets tutorialModal delegate to self
        self.tutorialModalView.tutorialModalDelegate = self
        
        // sets map shows users location (if possible)
        mapView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        mapView.showsUserLocation = true
        
        // sets up filterButton and target function
        filterButton.frame = CGRect(x: spacer, y: height - buttonSize - spacer, width: buttonSize, height: buttonSize)
        filterButton.setTitle("Filter", for: .normal)
        filterButton.setTitleColor(UIColor.white, for: .normal)
        filterButton.layer.cornerRadius = filterButton.frame.width/2
        filterButton.layer.masksToBounds = true
        filterButton.backgroundColor = UIColor.gray
        filterButton.addTarget(self, action: #selector(displayFilterModal), for: .touchUpInside)
        
        // sets up directionsButton and target function
        directionsButton.frame = CGRect(x: width/2 - buttonSize/2, y: height - buttonSize - spacer, width: buttonSize, height: buttonSize)
        directionsButton.setTitle("Directions", for: .normal)
        directionsButton.setTitleColor(UIColor.white, for: .normal)
        directionsButton.layer.cornerRadius = directionsButton.frame.width/2
        directionsButton.layer.masksToBounds = true
        directionsButton.backgroundColor = UIColor.red
        directionsButton.addTarget(self, action: #selector(openInMaps), for: .touchUpInside)
        directionsButton.isHidden = true
        
        // sets up websiteButton and target function
        websiteButton.frame = CGRect(x: width - buttonSize - spacer, y: height - buttonSize - spacer, width: buttonSize, height: buttonSize)
        websiteButton.setTitle("Website", for: .normal)
        websiteButton.setTitleColor(UIColor.white, for: .normal)
        websiteButton.layer.cornerRadius = websiteButton.frame.width/2
        websiteButton.layer.masksToBounds = true
        websiteButton.backgroundColor = UIColor.blue
        websiteButton.addTarget(self, action: #selector(openInWeb), for: .touchUpInside)
        websiteButton.isHidden = true
        
        // adds subviews into view
        self.view.addSubview(mapView)
        self.view.addSubview(filterButton)
        self.view.addSubview(directionsButton)
        self.view.addSubview(websiteButton)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
            mapView.userTrackingMode = .follow
            break
            
        case .denied, .restricted:
            break
            
        default:
            manager.requestWhenInUseAuthorization()
            displayTutorialModal()
            break
        }
        
    }
   
    @objc func displayFilterModal() {
        filterModalView.modalPresentationStyle = .overFullScreen
        self.present(self.filterModalView, animated: true, completion: nil)
    }
    
    func displayTutorialModal() {
        tutorialModalView.modalPresentationStyle = .overFullScreen
        self.present(self.tutorialModalView, animated: true, completion: nil)
    }
    
    func displayTutorialPageController() {
        tutorialPageControllerView.modalPresentationStyle = .overFullScreen
        self.present(self.tutorialPageControllerView, animated: true, completion: nil)
    }
    
    func dismissFilter(modalText: Array<String>) {
        self.filterModalView.dismiss(animated: true, completion: nil)
        populate(modalText: modalText)
    }
    
    func dismissTutorialModal(decision: Bool) {
        self.tutorialModalView.dismiss(animated: true, completion: nil)
        
        if decision {
            displayTutorialPageController()
        }
    }
    
    func dismissTutorial() {
        self.tutorialPageControllerView.dismiss(animated: true, completion: nil)
    }

    func populate(modalText: Array<String>) {
        
        FirebaseManager.sharedInstance.getBusinesses(flags: modalText) {
            businesses in
            
            for business in businesses {

                if (modalText.contains(business.category)) {
                    
                    let geoCoder = CLGeocoder()
                    
                    let street = business.street + ", "
                    let city = business.city + ", "
                    let state = business.state + ", "
                    let zip = business.zip
                    let url = business.url
                    let phone = business.phone
                    
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
                                return
                        }
                        
                        let pin = CustomAnnotation()
                        pin.coordinate = locat.coordinate
                        pin.title = business.name
                        pin.subtitle = business.category
                        pin.url = url
                        pin.phone = phone
                        
                        self.annotationView.annotation = pin
                        
                        self.mapView.addAnnotation(self.annotationView.annotation!)
                        
                    }
                    
                }
            }
        }
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.selectedAnnotation = view.annotation as? CustomAnnotation
        directionsButton.isHidden = false
        
        if self.selectedAnnotation?.url! != nil {
            websiteButton.isHidden = false
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        directionsButton.isHidden = true
        websiteButton.isHidden = true
    }
    
    @objc func openInMaps() {
        let coordinate = CLLocationCoordinate2DMake((self.selectedAnnotation?.coordinate.latitude)!, (self.selectedAnnotation?.coordinate.longitude)!)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = self.selectedAnnotation?.title!
        mapItem.openInMaps(launchOptions: nil)
    }
    
    @objc func openInWeb() {
        let url = URL(string: (self.selectedAnnotation?.url!)!)
        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        }
    }
}

