//
//  BusinessViewController.swift
//  Grit
//
//  Created by Jared Williams on 11/11/18.
//  Copyright © 2018 Jared Williams. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class BusinessViewController : UIViewController {
    var business: Business?
    
    private lazy var mapView: MKMapView = {
       var mapView = MKMapView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height / 3))
       var annotation = CustomAnnotation()
       let coordinate = CLLocationCoordinate2D(latitude: self.business?.lat ?? 0.0, longitude: business?.lng ?? 0.0)
        
        annotation.coordinate = coordinate
        annotation.title = business?.name
        
        mapView.region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5))
        mapView.addAnnotation(annotation)
        
        
        return mapView
    }()
    
    convenience init(business: Business) {
        self.init()
        self.business = business
        
    }
    override func viewDidLoad() {
        self.setupView()
    }
    
    func setupView() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(self.mapView)
    }
}
