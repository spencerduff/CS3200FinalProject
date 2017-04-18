//
//  ViewController.swift
//  CS3200FinalProject
//
//  Created by Student on 3/28/17.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var restaurantTypePicker: UIPickerView!
    @IBOutlet weak var priceRangePicker: UIPickerView!
    
    
    let locManager = CLLocationManager()
    
    let priceRanges = [String](arrayLiteral: "Any", "$", "$$", "$$$")
    let restTypes = [String](arrayLiteral: "Any", "Fast Food", "Sit Down", "Fast Casual")
    let accessToken = "8Dqf222-lrNZhZnbgWQTk0kEoRvMjVywr2tL-kS2JjEIfTIH6QZuYGeHLHbKOkGLFcgXjpzIRyiZ2C9KHSMBBNqxE8yCes2wcpJ0NP2f6kjMsNAflM2OpWNLwovtWHYx"
    
    var parsedJSON = [[String]]()
    var unparsedJSON = [String : Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyKilometer
        
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse{
            locManager.requestWhenInUseAuthorization()
            if (CLLocationManager.authorizationStatus() == .authorizedWhenInUse){
                locManager.requestLocation()
            }
        }
        else{
            locManager.requestLocation()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func SearchButton(_ sender: Any) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "displaySegue",
            let detailVC = segue.destination as? RestaurantDisplayViewController {
            detailVC.priceRange = priceRanges[priceRangePicker.selectedRow(inComponent: 0)]
            detailVC.restaurantType = restTypes[restaurantTypePicker.selectedRow(inComponent: 0)]
        }
        
    }
    
    func makeRequest() -> [String : Any]{
        let latitude = locManager.location?.coordinate.latitude
        let longitude = locManager.location?.coordinate.longitude
        let toGet = "https://api.yelp.com/v3/businesses/search?&latitude=\(latitude!)&longitude=\(longitude!)"
        let url = URL(string: toGet)
        var request = URLRequest(url: url!)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        var toReturn = [String : Any]()

        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            guard let data = data, error == nil else {
                print(error ?? "No error")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            if let responseJSON = responseJSON as? [String : Any] {
                print(responseJSON)
                toReturn = responseJSON
            }
            
        }
        task.resume()
        
        
        return toReturn
        
    }
    
    func parseJSON(json: [String : Any]) {
        //print(json)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            manager.requestLocation()
        }
        else{
            // no permission
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        parseJSON(json: makeRequest())
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //
    }
    
}

extension ViewController : UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 4
    }
}

extension ViewController : UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == restaurantTypePicker{
            return restTypes[row]
        }else{
            return priceRanges[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
}
