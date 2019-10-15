//
//  ModifyViewController.swift
//  baker-timer
//
//  Created by Wu, Guan-Ling on 15/03/2017.
//  Copyright © 2017 Wu, Guan-Ling. All rights reserved.
//
import UIKit

class ModifyViewController: UIViewController, UITextFieldDelegate  {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var bakeTimers = [[Int]]()
    var ut:Int = 0
    var bt:Int = 0
    var time:Int = 0
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timePickerOutlet: UIDatePicker!
    @IBOutlet weak var modeSelection: UISegmentedControl!
    @IBOutlet weak var upperSliderOutlet: UISlider!
    @IBOutlet weak var bottomSliderOutlet: UISlider!

    var itemIndex:Int!
    
    func getUpdateNoti(noti:Notification) {
        let name = noti.userInfo!["ut"] as! String
        self.upperTempText.text = name
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
    
    @IBOutlet weak var itemTextField: UITextField!
    
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
        
        //print([upperTempValue,bottomTempValue,timeCountDown])
        
        let itemsObject = UserDefaults.standard.object(forKey: "bakeTimers")
        
        var items:[[Int]]
        
        if let tempItems = itemsObject as? [[Int]] {
            items = tempItems
            items[itemIndex] = [upperTempValue, bottomTempValue, timeCountDown]
            print(items)
        } else {
            items = []
        }
        //writing storage
        UserDefaults.standard.set(items, forKey: "bakeTimers")
        
        
        //closing current vc
        self.dismiss(animated: true)
    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timePickerOutlet.setValue(UIColor.white, forKeyPath: "textColor")
        // Do any additional setup after loading the view, typically from a nib.
        let itemsObject = UserDefaults.standard.object(forKey: "bakeTimers")
        if let tempItems = itemsObject as? [[Int]] {
            bakeTimers = tempItems
        }
        ut = bakeTimers[itemIndex][0]
        bt = bakeTimers[itemIndex][1]
        time = bakeTimers[itemIndex][2]
        print("time \(time)")
        upperTempText.text = "\(ut)°C"
        bottomTempText.text = "\(bt)°C"
        upperSliderOutlet.value = Float(ut / 10)
        bottomSliderOutlet.value = Float(bt / 10)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "HH:mm:ss"
        let date = dateFormatter.date(from: timeString(time: TimeInterval(time)))
        timePickerOutlet.date = date!
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let notificationName = Notification.Name("GetUpdateNoti")
        NotificationCenter.default.addObserver(self, selector: #selector(SecondViewController.getUpdateNoti(noti:)), name: notificationName, object: nil)
        }
    
    /*
     let itemObject = UserDefaults.standard.object(forKey: "items")
     
     var items:[String]
     if let tempItems = itemObject as? [String] {
     items = tempItems
     items.append(itemTextField.text!)
     } else {
     items = [itemTextField.text!]
     }
     
     UserDefaults.standard.set(items, forKey: "items")
     
     itemTextField.text = ""
     
     }
     
     
     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
     self.view.endEditing(true)
     
     }
     
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
     
     textField.resignFirstResponder()
     return true
     
     }
     
     
     override func didReceiveMemoryWarning() {
     super.didReceiveMemoryWarning()
     // Dispose of any resources that can be recreated.
     }
     */
    
}

