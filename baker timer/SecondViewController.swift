//
//  SecondViewController.swift
//  baker-timer
//
//  Created by Wu, Guan-Ling on 15/03/2017.
//  Copyright © 2017 Wu, Guan-Ling. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITextFieldDelegate  {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var timePickerOutlet: UIDatePicker!
    @IBOutlet weak var modeSelection: UISegmentedControl!
    @IBOutlet weak var upperSliderOutlet: UISlider!
    @IBOutlet weak var bottomSliderOutlet: UISlider!
    
    var itemIndex:Int! = -1
    
    @objc func getUpdateNoti(noti:Notification) {
        let name = noti.userInfo!["ut"] as! String
        self.upperTempText.text = name
    }
    
    
    @IBAction func upperTempSlider(_ sender: UISlider) {
        let upperTempValue = Int(Int(sender.value) * 10)
        if upperTempValue > 0 {
            upperTempText.text = "\(upperTempValue)°C"
        } else {
            upperTempText.text = "Off"
        }
        
        //print("upperTempValue = \(upperTempValue)")
        if modeSelection.selectedSegmentIndex == 1 {
            bottomSliderOutlet.value = Float(Int(sender.value))
            if upperSliderOutlet.value != 0 {
                bottomTempText.text = "\(Int(sender.value) * 10)°C"
            } else {
                bottomTempText.text = "Off"
            }
        }
    }
    
    @IBAction func bottomTempSlider(_ sender: UISlider) {
        let bottomTempValue = Int(Int(sender.value) * 10)
        if bottomTempValue > 0 {
            bottomTempText.text = "\(bottomTempValue)°C"
        } else {
            bottomTempText.text = "Off"
        }
        //print("bottomTempValue = \(bottomTempValue)")
        if modeSelection.selectedSegmentIndex == 1 {
            upperSliderOutlet.value = Float(Int(sender.value))
            if bottomSliderOutlet.value != 0 {
                upperTempText.text = "\(Int(sender.value) * 10)°C"
            } else {
                upperTempText.text = "Off"
            }
        }
        
    }
    
    @IBOutlet weak var upperTempText: UILabel!
    @IBOutlet weak var bottomTempText: UILabel!
    
    
    @IBAction func add(_ sender: Any) {
        
        let hrFormatter = DateFormatter()
        hrFormatter.dateFormat = "HH"
        
        let minFormatter = DateFormatter()
        minFormatter.dateFormat = "mm"
        
        var hr = Int(hrFormatter.string(from: timePickerOutlet.date))!
        let min = Int(minFormatter.string(from: timePickerOutlet.date))!
        
        if hr == 12{
            hr -= 12
        }
        
        let timeCountDown = hr * 3600 + min * 60
        //print(timeCountDown)
        let upperTempValue = Int(Int(upperSliderOutlet.value) * 10)
        //print(upperTempValue)
        let bottomTempValue = Int(Int(bottomSliderOutlet.value) * 10)
        //print(bottomTempValue)
        
        print([upperTempValue,bottomTempValue,timeCountDown])
        
        let itemsObject = UserDefaults.standard.object(forKey: "bakeTimers")
        
        var items:[[Int]]
        
        if let tempItems = itemsObject as? [[Int]] {
            items = tempItems
            items.append([upperTempValue,bottomTempValue,timeCountDown])
            print(items)
        } else {
            items = []
        }
        
        //writing storage
        UserDefaults.standard.set(items, forKey: "bakeTimers")
        //UserDefaults.standard.synchronize()
        
        // the alert view
        let alert = UIAlertController(title: "Timer Added", message: "Let's bake!", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        
        // change to desired number of seconds (in this case 5 seconds)
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when){
            // your code with delay
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //insert empty item
        let itemsObject = UserDefaults.standard.object(forKey: "bakeTimers")
        var items:[[Int]]
        if let tempItems = itemsObject as? [[Int]] {
            items = tempItems
            //items.append([])
        } else {
            items = []
        }
        UserDefaults.standard.set(items, forKey: "bakeTimers")
        
        //bar item styling
        self.tabBarController?.tabBar.tintColor = UIColor.orange
        self.tabBarController?.tabBar.backgroundColor = UIColor.black
        timePickerOutlet.setValue(UIColor.white, forKeyPath: "textColor") //https://grokswift.com/transparent-table-view/
        
        // Do any additional setup after loading the view, typically from a nib.
        let notificationName = Notification.Name("GetUpdateNoti")
        NotificationCenter.default.addObserver(self, selector: #selector(SecondViewController.getUpdateNoti(noti:)), name: notificationName, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(itemIndex)
    }
    
}

