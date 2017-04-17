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
    
    var priceRange = ""
    var restaurantType = ""
    
    var cheap = [Restaurant]()
    var fast = [Restaurant]()
    var sitdown = [Restaurant]()
    var medprice = [Restaurant]()
    var expensive = [Restaurant]()
    var fastcas = [Restaurant]()
    
    var results:Set<Restaurant> = []
    
    let McDonalds = Restaurant(pr: "$", rt: "Fast Food", n: "McDonalds", h: "24/7",  a: "810 N Main St")
    let LeNonne = Restaurant(pr: "$$", rt: "Sit Down", n: "Le Nonne", h: "5:30-9:30", a: "129 N 100 E")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        cheap.append(McDonalds)
        sitdown.append(LeNonne)
        medprice.append(LeNonne)
        fast.append(McDonalds)
        
        
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
            typeSelection = Set(sitdown + fast + fastcas)
        }
        else if restaurantType == "Sit Down"{
            typeSelection = Set(sitdown)
        }
        else if restaurantType == "Fast Food"{
            typeSelection = Set(fast)
        }
        else { // fastcasual
            typeSelection = Set(fastcas)
        }
        
        results = typeSelection.intersection(priceSelection)
        
        nameLabel.text = results.first?.name
        hoursLabel.text = results.first?.hours
        priceLabel.text = results.first?.priceRange
        typeLabel.text = results.first?.restType
        addressLabel.text = results.first?.address
        
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
            hoursLabel.text = results.first?.hours
            priceLabel.text = results.first?.priceRange
            typeLabel.text = results.first?.restType
            addressLabel.text = results.first?.address
        }
    }
    
}

func ==(lhs: Restaurant, rhs: Restaurant) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

class Restaurant : Hashable {
    var priceRange = "No Results"
    var restType = "No Results"
    var name = "No Results"
    var hours = "No Results"
    var address = "No Results"
    
    init (pr: String, rt: String, n: String, h: String, a: String){
        priceRange = pr
        restType = rt
        name = n
        hours = h
        address = a
    }
    
    var hashValue : Int {
        get {
            return "\(self.priceRange),\(self.restType),\(self.name),\(self.hours),\(self.address)".hashValue
        }
    }
    
}
