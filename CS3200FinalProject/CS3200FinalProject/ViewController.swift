//
//  ViewController.swift
//  CS3200FinalProject
//
//  Created by Student on 3/28/17.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var restaurantTypePicker: UIPickerView!
    @IBOutlet weak var priceRangePicker: UIPickerView!
    
    let priceRanges = [String](arrayLiteral: "Any", "$", "$$", "$$$")
    let restTypes = [String](arrayLiteral: "Any", "Fast Food", "Sit Down", "Fast Casual")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.'
        
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
