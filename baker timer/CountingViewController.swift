//
//  CountingViewController.swift
//  baker-timer
//
//  Created by Wu, Guan-Ling on 15/03/2017.
//  Copyright © 2017 Wu, Guan-Ling. All rights reserved.
//

import UIKit
import UserNotifications

class CountingViewController: UIViewController, UIPickerViewDelegate {
    
    var index = 0
    var isCounting = false
    
    func loadStoredData(){
        if index >= 0 && index < bakeTimers.count {
            seconds.seconds = bakeTimers[index][2]
            let ut = bakeTimers[index][0]
            let bt = bakeTimers[index][1]
            timerIndex.text = String("Bake Timer No. \(index + 1)")
            timeCounting.text = String(timeString(time: TimeInterval(seconds.seconds)))
            upperTemp.text = "\(ut)°C"
            bottomTemp.text = "\(bt)°C"
            playButton.isEnabled = true
        }
        if bakeTimers.count == 1 {
            forwardButton.isEnabled = false
            rewindButton.isEnabled = false
            playButton.isEnabled = true
        } else if bakeTimers.count == 0{
            forwardButton.isEnabled = false
            rewindButton.isEnabled = false
            playButton.isEnabled = false
        } else if index == bakeTimers.count - 1 {
            forwardButton.isEnabled = false
            rewindButton.isEnabled = true
            playButton.isEnabled = true
        } else if index > 0 && index < bakeTimers.count - 1 {
            forwardButton.isEnabled = true
            rewindButton.isEnabled = true
            playButton.isEnabled = true
        } else if index == 0 && bakeTimers.count > 1{
            forwardButton.isEnabled = true
            rewindButton.isEnabled = false
            playButton.isEnabled = true
        }
        resetButton.isEnabled = false
        isCounting = false
    }
    
    //buttons
    @IBAction func backButtonPressed(_ sender: Any) {
        timer.invalidate()
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func rewindButtonPressed(_ sender: Any) {
        timer.invalidate()
        resetButton.isEnabled = false
        isCounting = false
        if index >= 0 {
            index -= 1
        } else {
            
        }
        print("rewind, index \(index)")
        playButton.isEnabled = true
        pauseButton.isEnabled = false
        loadStoredData()
    }
    @IBAction func playbuttonPressed(_ sender: Any) {
        resetButton.isEnabled = true
        if(isCounting) {
            return
        }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)),userInfo: nil, repeats: true)
        isCounting = true
        playButton.isEnabled = false
        pauseButton.isEnabled = true
    }
    @IBAction func pauseButtonPressed(_ sender: Any) {
        timer.invalidate()
        isCounting = false
        playButton.isEnabled = true
        pauseButton.isEnabled = false
    }
    @IBAction func forwardButtonPressed(_ sender: Any) {
        resetButton.isEnabled = false
        timer.invalidate()
        isCounting = false
        if index < bakeTimers.count{
            index += 1
        } else {
            
        }
        print("forward, index \(index)")
        playButton.isEnabled = true
        pauseButton.isEnabled = false
        loadStoredData()
        
    }
    @IBAction func resetButtonPrressed(_ sender: Any) {
        timer.invalidate()
        isCounting = false
        loadStoredData()
        playButton.isEnabled = true
        pauseButton.isEnabled = false
        resetButton.isEnabled = false
        
    }
    
    
    //labels
    @IBOutlet weak var timerIndex: UILabel!
    @IBOutlet weak var timeCounting: UILabel!
    @IBOutlet weak var upperTemp: UILabel!
    @IBOutlet weak var bottomTemp: UILabel!
    
    //button outlets
    @IBOutlet weak var playButton: UIBarButtonItem!
    @IBOutlet weak var resetButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var pauseButton: UIBarButtonItem!
    @IBOutlet weak var rewindButton: UIBarButtonItem!
    
    
    
    var timer = Timer()
    var bakeTimers = [[Int]]()
    
    struct arrayIndex {
        static var arrayIndex = 0
    }
    
    struct seconds {
        static var seconds = 0
    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    func createNotification(index:Int) {
        let content = UNMutableNotificationContent()
        content.title = "Time's Up!"
        //content.subtitle = ""
        if index < bakeTimers.count - 1 {
            content.body = "Timer number \(index + 1) is done, please check the next timer."
        } else {
            content.body = "Well done! Let's enjoy it!"
        }
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = "reminder"
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let request = UNNotificationRequest(identifier: "notification1", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func alert(index:Int) {
        if index < bakeTimers.count - 1 {
            let alertController = UIAlertController(
                title: "Time's Up!",
                message: "Proceed the next setting?",
                preferredStyle: .alert)
            
            // 建立[取消]按鈕
            let cancelAction = UIAlertAction(
                title: "No",
                style: .cancel,
                handler: nil)
            alertController.addAction(cancelAction)
            // 建立[確認]按鈕
            let okAction = UIAlertAction(
                title: "Yes",
                style: .default,
                handler: {
                    (action: UIAlertAction!) -> Void in
                    self.loadNext()
            })
            alertController.addAction(okAction)
            
            // 顯示提示框
            self.present(
                alertController,
                animated: true,
                completion: nil)
        } else {
            let alertController = UIAlertController(
                title: "Time's Up!",
                message: "You hungry?",
                preferredStyle: .alert)
            
            // 建立[確認]按鈕
            let okAction = UIAlertAction(
                title: "Sure!",
                style: .default,
                handler: nil)
            alertController.addAction(okAction)
            
            // 顯示提示框
            self.present(
                alertController,
                animated: true,
                completion: nil)
        }
    }
    
    func updateTimer(){
        if seconds.seconds < 1 {
            timer.invalidate()
            //Send alert to indicate time's up.
            print("time's up")
            pauseButton.isEnabled = false
            playButton.isEnabled = false
            //super.dismiss(animated: true, completion: nil)
            //alert(index: index)
            createNotification(index:index)
            if index < bakeTimers.count - 1 {
                index += 1
            }
            loadStoredData()
        } else {
            seconds.seconds -= 1
            timeCounting.text = timeString(time: TimeInterval(seconds.seconds))
            print(seconds.seconds)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pauseButton.isEnabled = false
        playButton.isEnabled = false
        forwardButton.isEnabled = false
        rewindButton.isEnabled = false
        let itemsObject = UserDefaults.standard.object(forKey: "bakeTimers")
        if let tempItems = itemsObject as? [[Int]] {
            bakeTimers = tempItems
        }
        loadStoredData()
        print("bakeTimers.count, \(bakeTimers.count)")
    }
    
    func loadNext() {
        pauseButton.isEnabled = false
        let itemsObject = UserDefaults.standard.object(forKey: "bakeTimers")
        if let tempItems = itemsObject as? [[Int]] {
            bakeTimers = tempItems
        }
        index += 1
        loadStoredData()
        isCounting = false
    }
    // Do any additional setup after loading the view.
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
    
}
