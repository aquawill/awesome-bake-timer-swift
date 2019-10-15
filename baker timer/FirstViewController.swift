//
//  FirstViewController.swift
//  baker-timer
//
//  Created by Wu, Guan-Ling on 15/03/2017.
//  Copyright © 2017 Wu, Guan-Ling. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var timer = Timer()
    var valueToPass:Int!

    @IBOutlet weak var playButton: UIBarButtonItem!
    @IBOutlet weak var cleanButton: UIBarButtonItem!
    
    var myActivityIndicator:UIActivityIndicatorView!
    
    @IBAction func resetTimer(_ sender: Any) {
        let itemsObject = UserDefaults.standard.object(forKey: "bakeTimers")
        if let tempItems = itemsObject as? [[Int]] {
            bakeTimers = tempItems
        }
        
        func clean() {
            bakeTimers.removeAll()
            table.reloadData()
            UserDefaults.standard.set(bakeTimers, forKey: "bakeTimers")
            print(bakeTimers)
            checkTimer()
        }
        
        let alertController = UIAlertController(
            title: "Erase All Timers?",
            message: "Caution! This action cannot be undone!",
            preferredStyle: .alert)
        
        // cancel button
         let cancelAction = UIAlertAction(
         title: "No",
         style: .cancel,
         handler: nil)
         alertController.addAction(cancelAction)
        
        // confirm button
        let okAction = UIAlertAction(
            title: "Yes",
            style: .default,
            handler: {
                (action: UIAlertAction!) -> Void in
                clean()
        })
        alertController.addAction(okAction)
        
        // show alert
        self.present(
            alertController,
            animated: true,
            completion: nil)
    }
    
    //http://stackoverflow.com/questions/28315133/swift-pass-uitableviewcell-label-to-new-viewcontroller
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
        let indexPath = tableView.indexPathForSelectedRow;
        _ = tableView.cellForRow(at: indexPath!) as UITableViewCell?;
        valueToPass = indexPath?.row
        print("valueToPass \(valueToPass)")
        performSegue(withIdentifier: "modifyCell", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ModifyViewController {
            let selectedRow = table.indexPathForSelectedRow!.row
            destination.itemIndex = selectedRow
        }
    }
    
    @IBOutlet weak var table: UITableView!
    var bakeTimers = [[Int]]()
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return bakeTimers.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let list = bakeTimers[indexPath.row]
        let cell = 
            tableView.dequeueReusableCell(withIdentifier: "Cell", for:
                indexPath) as! ItemTableViewCell
        cell.index.text = String(describing: indexPath[1] + 1)
        let ut = list[0]
        let bt = list[1]
        _ = DateFormatter()
        let timeMin = Int(list[2])/60
        let timeSec = Int(list[2])%60
        if ut > 0{
            cell.upperTempValue.text = "\(ut)°C"
        } else {
            cell.upperTempValue.text = "Off"
        }
        if bt > 0{
            cell.bottomTempValue.text = "\(bt)°C"
        } else {
            cell.bottomTempValue.text = "Off"
        }
        if timeSec < 10{
            cell.time.text = "\(timeMin):0\(timeSec)"
        } else {
            cell.time.text = "\(timeMin):\(timeSec)"
        }
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.tintColor = UIColor.orange
        self.tabBarController?.tabBar.barTintColor = UIColor.black
        let backgroundImage = UIImage(named: "table_bg")
        let imageView = UIImageView(image: backgroundImage)
        self.table.backgroundView = imageView
        table.tableFooterView = UIView(frame: CGRect.zero) //http://stackoverflow.com/questions/29997935/cgrectzero-vs-cgrect-zerorect
        imageView.contentMode = .scaleAspectFill
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    func checkTimer(){
        if bakeTimers.count == 0 {
            playButton.isEnabled = false
            cleanButton.isEnabled = false
            let alertController = UIAlertController(
                title: "Wanna play?",
                message: "Please add a timer first",
                preferredStyle: .alert
                )
            /*// cancel button
             let cancelAction = UIAlertAction(
             title: "cancel",
             style: .cancel,
             handler: nil)
             alertController.addAction(cancelAction)
             */
            // confirm button
            let okAction = UIAlertAction(
                title: "Sure!",
                style: .default,
                handler: nil)
            alertController.addAction(okAction)
            
            // show alert
            self.present(
                alertController,
                animated: true,
                completion: nil)
        } else {
            playButton.isEnabled = true
            cleanButton.isEnabled = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let itemsObject = UserDefaults.standard.object(forKey: "bakeTimers")
        if let tempItems = itemsObject as? [[Int]] {
            bakeTimers = tempItems
        }
        print(bakeTimers)
        checkTimer()
        table.reloadData()
    }
    
    internal func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            bakeTimers.remove(at: indexPath.row)
            //table.reloadData()
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            UserDefaults.standard.set(bakeTimers, forKey: "bakeTimers")
            print(bakeTimers)
            checkTimer()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

