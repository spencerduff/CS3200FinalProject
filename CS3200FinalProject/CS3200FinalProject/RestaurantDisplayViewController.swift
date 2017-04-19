//
//  RestaurantDisplayViewController.swift
//  CS3200FinalProject
//
//  Created by Student on 3/28/17.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

class RestaurantDisplayViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var imageHolder: UIImageView!
    
    var priceRange = ""
    var restaurantType = ""
    
    var cheap = [Restaurant]()
    var near = [Restaurant]()
    var med = [Restaurant]()
    var medprice = [Restaurant]()
    var expensive = [Restaurant]()
    var far = [Restaurant]()
    
    var results:Set<Restaurant> = []
    
    var toParse = [[String]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        parseStrings(toParse: toParse)
        
        var priceSelection:Set<Restaurant>
        var typeSelection:Set<Restaurant>
        
        if priceRange == "Any" {
            priceSelection = Set(cheap + medprice + expensive)
        }
        else if priceRange == "$"{
            priceSelection = Set(cheap)
        }
        else if priceRange == "$$"{
            priceSelection = Set(medprice)
        }
        else{
            priceSelection = Set(expensive)
        }
        
        if restaurantType == "Any" {
            typeSelection = Set(near + med + far)
        }
        else if restaurantType == "<1000"{
            typeSelection = Set(near)
        }
        else if restaurantType == "<2000"{
            typeSelection = Set(med + near)
        }
        else { // fastcasual
            typeSelection = Set(far + med + near)
        }
        
        results = typeSelection.intersection(priceSelection)
        
        nameLabel.text = results.first?.name
        priceLabel.text = results.first?.priceRange
        typeLabel.text = results.first?.distance
        addressLabel.text = results.first?.address
        if let checkedUrl = URL(string: (results.first?.imageURL)!){
            imageHolder.contentMode = .scaleAspectFit
            downloadImage(url: checkedUrl)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func searchAgain(_ sender: Any) {
        if results.count > 1 {
            results.removeFirst()
            nameLabel.text = results.first?.name
            priceLabel.text = results.first?.priceRange
            typeLabel.text = results.first?.distance
            addressLabel.text = results.first?.address
            if let checkedUrl = URL(string: (results.first?.imageURL)!){
                imageHolder.contentMode = .scaleAspectFit
                downloadImage(url: checkedUrl)
            }
        }
    }
    
    func parseStrings(toParse: [[String]]){
        for i in toParse{
            let name = i[0]
            let price = i[1]
            let location = i[2]
            let distance = i[3]
            let imageURL = i[4]
            let restaurant = Restaurant(pr: price, d: distance, n: name, a: location, i: imageURL)
            let dis = Double(distance)
            if (dis! >= 2000.0){
                far.append(restaurant)
            }
            else if (dis! >= 1000.0){
                med.append(restaurant)
            }
            else{
                near.append(restaurant)
            }
            if (price == "$"){
                cheap.append(restaurant)
            }
            else if (price == "$$"){
                medprice.append(restaurant)
            }
            else{
                expensive.append(restaurant)
            }
            
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    func downloadImage(url: URL) {
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            DispatchQueue.main.async() { () -> Void in
                self.imageHolder.image = UIImage(data: data)
            }
        }
    }
}

func ==(lhs: Restaurant, rhs: Restaurant) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

class Restaurant : Hashable {
    var priceRange = "No Results"
    var distance = "No Results"
    var name = "No Results"
    var address = "No Results"
    var imageURL = "https://upload.wikimedia.org/wikipedia/commons/thumb/3/33/Image-missing.svg/500px-Image-missing.svg.png"
    
    init (pr: String, d: String, n: String, a: String, i: String){
        priceRange = pr
        distance = d
        name = n
        address = a
        imageURL = i
    }
    
    var hashValue : Int {
        get {
            return "\(self.priceRange),\(self.distance),\(self.name),\(self.address)".hashValue
        }
    }
    
}
