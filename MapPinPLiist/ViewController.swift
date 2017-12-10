//
//  ViewController.swift
//  MapPinPLiist
//
//  Created by 김종현 on 2017. 9. 17..
//  Copyright © 2017년 김종현. All rights reserved.
//
////////////////////////////////////////////////
// DetailsInfo item name
// idx : 일련번호
// name : 시설명        : title
// loc :  급식장소
// target : 급식대상     : 2 cell
// mealDay : 급식일     : 1 cell
// time : 급식시간
// startDay : 운영시작일
// endDay : 운영종료일
// manageNm : 운영기관명  : 3 cell
// phone : 연락처        : 4 cell
// addr : 지번주소
// lng : 경도
// lat : 위도
// gugun : 구군
////////////////////////////////////////////////////

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate
{
    
    @IBOutlet weak var myMapView: MKMapView!
    @IBOutlet weak var segControl: UISegmentedControl!
    
    var item:[String:String] = [:]
    var items:[[String:String]] = []
    var locationManager: CLLocationManager!
    var fLat: Double?
    var fLong: Double?
    var viewTitle: String?
    var curLat: Double?
    var curLong: Double?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "부산 무료 급식소 찾기"
        myMapView.delegate = self
        
        ////
        // 현재 위치 트랙킹
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        //locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        
        /////////////////////////////
        curLat = locationManager.location?.coordinate.latitude
        curLong = locationManager.location?.coordinate.longitude
        
        // 지도에 현재 위치 마크를 보여줌
        myMapView.showsUserLocation = true
        myMapView.userLocation.title = "현재 위치"
        myMapView.showsCompass = true
        
        zoomToRegion()
        
        let path = Bundle.main.path(forResource: "data", ofType: "plist")
        items = NSArray(contentsOfFile: path!) as! [[String : String]]
        var annos = [MKPointAnnotation]()
        
        for item in items
        {
            let anno = MKPointAnnotation()
            
            let lat = item["lat"]
            let long = item["lng"]
            fLat = (lat! as NSString).doubleValue
            fLong = (long! as NSString).doubleValue
            
            anno.coordinate.latitude = fLat!
            anno.coordinate.longitude = fLong!
            anno.title = item["loc"]
            anno.subtitle = item["addr"]
            annos.append(anno)
        }
        
        myMapView.addAnnotations(annos)
        //myMapView.showAnnotations(annos, animated: true)
        myMapView.selectAnnotation(annos[25], animated: true)
    }
    
    func zoomToRegion() {
        
        segControl.selectedSegmentIndex = 3
        // 35.199990, 129.083200
//        curLat = locationManager.location?.coordinate.latitude
//        curLong = locationManager.location?.coordinate.longitude
        print("curLat = \(String(describing: curLat))")
        print("curLong = \(String(describing: curLong))")
        
        let center = CLLocationCoordinate2DMake(35.230990, 129.083200)
        //let center = CLLocationCoordinate2DMake(curLat!, curLong!)

        let span = MKCoordinateSpanMake(0.41, 0.41)
        let region = MKCoordinateRegionMake(center, span)
        myMapView.setRegion(region, animated: true)
    }
    
    // segmentIndex = 1,2,3,4
    @IBAction func segmentControlPressed(_ sender: Any) {
        switch segControl.selectedSegmentIndex {
        case 0:
            let center = CLLocationCoordinate2DMake(curLat!, curLong!)
            let region = MKCoordinateRegionMakeWithDistance(center, 2000, 2000)
            myMapView.setRegion(region, animated: true)
            
        case 1:
            let center = CLLocationCoordinate2DMake(curLat!, curLong!)
            let region = MKCoordinateRegionMakeWithDistance(center, 4000, 4000)
            myMapView.setRegion(region, animated: true)
            
        case 2:
            let center = CLLocationCoordinate2DMake(curLat!, curLong!)
            let region = MKCoordinateRegionMakeWithDistance(center, 8000, 8000)
            myMapView.setRegion(region, animated: true)
            
        case 3:
            let center = CLLocationCoordinate2DMake(35.230990, 129.083200)
            //let center = CLLocationCoordinate2DMake(curLat!, curLong!)
            let span = MKCoordinateSpanMake(0.41, 0.41)
            let region = MKCoordinateRegionMake(center, span)
            myMapView.setRegion(region, animated: true)
            
        default:
            print("out of index")
      }
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        //if annotation is MKUserLocation {return nil}
        if annotation .isKind(of: MKUserLocation.self) {
            return nil
        }
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
            let calloutButton = UIButton(type: .detailDisclosure)
            pinView!.rightCalloutAccessoryView = calloutButton
            pinView!.sizeToFit()
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        print("callout Accessory Tapped!")
        
        let viewAnno = view.annotation
        viewTitle = ((viewAnno?.title)!)!
//        let viewSubTitle: String = ((viewAnno?.subtitle)!)!
//        print("\(viewSubTitle) \(viewSubTitle)")
        
        if control == view.rightCalloutAccessoryView {
            self.performSegue(withIdentifier: "goDetail", sender: self)
        }
        
//        let ac = UIAlertController(title: viewTitle, message: viewSubTitle, preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        self.present(ac, animated: true, completion: nil)

    }
    
    
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "goDetail" {
            let detailVC = segue.destination as! DetailTableViewController
            detailVC.dItems = items
            
            detailVC.dLoc = viewTitle
            
//            naviVC.nLat = fLat
//            naviVC.nLong = fLong
//            naviVC.nLoc = viewTitle
            
        }
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let coor = manager.location?.coordinate
//        let curLat = coor?.latitude
//        let curLong = coor?.longitude
//        print("latitute  \(String(describing: curLat))    longitude   \(String(describing: curLong))")
//    }
    
    
    // 콘솔(print)로 현재 위치 변화 출력
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let coor = manager.location?.coordinate
//        print("latitute" + String(describing: coor?.latitude) + "/ longitude" + String(describing: coor?.longitude))
//    }

}

