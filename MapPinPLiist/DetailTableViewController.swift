//
//  DetailTableViewController.swift
//  MapPinPLiist
//
//  Created by 김종현 on 2017. 12. 8..
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

class DetailTableViewController: UITableViewController, CLLocationManagerDelegate {
    var dItem:[String:String] = [:]
    var dItems:[[String:String]] = []
    var dLat: Double?
    var dLong: Double?
    var locationManager: CLLocationManager!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var dManageNm: UITableViewCell!
    @IBOutlet weak var dTarget: UITableViewCell!
    @IBOutlet weak var dMealDay: UITableViewCell!
    @IBOutlet weak var dMealTime: UITableViewCell!
    @IBOutlet weak var dPhone: UITableViewCell!
    
    var dLoc: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 현재 위치 트랙킹
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        //locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()

        self.title = dLoc
        
        // 전체 items 배열에서 loc 값과 같은 item 뽑기
        for item in dItems {
            if item["loc"] == dLoc {
                dItem = item
                print("dItem = \(dItem)")
            }
        }
        
        dTarget.textLabel?.text = "급식대상"
        dTarget.detailTextLabel?.text = dItem["target"]
        dMealDay.textLabel?.text = "급식일"
        dMealDay.detailTextLabel?.text = dItem["mealDay"]
        dMealTime.textLabel?.text = "급식시간"
        dMealTime.detailTextLabel?.text = dItem["time"]
        dManageNm.textLabel?.text = "관리기관"
        dManageNm.detailTextLabel?.text = dItem["manageNm"]
        dPhone.textLabel?.text = "전화번호"
        dPhone.detailTextLabel?.text = dItem["phone"]
        
        /////
        dLat = (dItem["lat"]! as NSString).doubleValue
        dLong = (dItem["lng"]! as NSString).doubleValue
        
        // 35.162685, 129.064238
        let center = CLLocationCoordinate2DMake(dLat!, dLong!)
        let span = MKCoordinateSpanMake(0.3, 0.3)
        let region = MKCoordinateRegionMake(center, span)
        mapView.setRegion(region, animated: true)
        
        let anno = MKPointAnnotation()
        anno.coordinate.latitude = dLat!
        anno.coordinate.longitude = dLong!
        anno.title = dLoc
        anno.subtitle = dItem["addr"]
        
        mapView.addAnnotation(anno)
        mapView.selectAnnotation(anno, animated: true)
        
        // 지도에 현재 위치 마크를 보여줌
        mapView.userLocation.title = "현재 위치"
        mapView.showsUserLocation = true
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goNavi" {
            let naviVC = segue.destination as! NaviViewController
            
            naviVC.nLat = dLat
            naviVC.nLong = dLong
            naviVC.nLoc = dLoc
        }
    }
}
