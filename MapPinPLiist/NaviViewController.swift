//
//  NaviViewController.swift
//  MapPinPLiist
//
//  Created by 김종현 on 2017. 12. 7..
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

class NaviViewController: UIViewController {
    
    var nLat: Double?
    var nLong: Double?
    var nLoc: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //Defining destination
        
        let latitude:CLLocationDegrees = nLat!
        let longitude:CLLocationDegrees = nLong!
        
        let regionDistance:CLLocationDistance = 1000;
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        
        let placemark = MKPlacemark(coordinate: coordinates)
        let mapItem = MKMapItem(placemark: placemark)
        
        mapItem.name = nLoc
        mapItem.openInMaps(launchOptions: options)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
