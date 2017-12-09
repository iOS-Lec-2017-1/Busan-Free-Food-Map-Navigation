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
    
    var item:[String:String] = [:]
    var items:[[String:String]] = []
    @IBOutlet weak var myMapView: MKMapView!
    var locationManager: CLLocationManager!
    var fLat: Double?
    var fLong: Double?
    var viewTitle: String?
    
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
        
        // 지도에 현재 위치 마크를 보여줌
        myMapView.showsUserLocation = true
        myMapView.userLocation.title = "현재 위치"
        
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
        //myMapView.selectAnnotation(annos[10], animated: true)
    }
    
    func zoomToRegion() {
        // 35.199990, 129.083200
        let curLat = locationManager.location?.coordinate.latitude
        let curLong = locationManager.location?.coordinate.longitude
        let center = CLLocationCoordinate2DMake(curLat!, curLong!)
        
        let span = MKCoordinateSpanMake(0.2, 0.2)
        let region = MKCoordinateRegionMake(center, span)
        myMapView.setRegion(region, animated: true)
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let coor = manager.location?.coordinate
        curLat = coor?.latitude
        curLong = coor?.longitude
        //print("latitute  \(String(describing: curLat))    longitude   \(String(describing: curLong))")
    }
    
    
    // 콘솔(print)로 현재 위치 변화 출력
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let coor = manager.location?.coordinate
//        print("latitute" + String(describing: coor?.latitude) + "/ longitude" + String(describing: coor?.longitude))
//    }

}

