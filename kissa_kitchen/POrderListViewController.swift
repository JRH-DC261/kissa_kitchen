//
//  POrderListViewController.swift
//  kissa_list
//
//  Originally created by Kei Kawamura on 2018/09/19.
//  Created by Tomohiro Hori on 2019/03/18.
//  Copyright © 2018 Kei Kawamura / 2019 Tomohiro Hori . All rights reserved.
//

import Foundation
import UIKit
import Firebase

class POrderListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    // インスタンス変数
    var DBRef:DatabaseReference!
    var hogeArray : [String] = []
    var array1 : [String] = []
    var P1Amount = Array(repeating: "0", count: 20)
    var P2Amount = Array(repeating: "0", count: 20)
    var time = Array(repeating: "0", count: 20)
    var dateUnix: TimeInterval = 0
    var hogeTime : String?
    var selectedRow : String?
    var status : String?
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.hogeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let timeLabel = cell.contentView.viewWithTag(1) as! UILabel
        let tableLabel = cell.contentView.viewWithTag(2) as! UILabel
        let P1Label = cell.contentView.viewWithTag(3) as! UILabel
        let P2Label = cell.contentView.viewWithTag(4) as! UILabel
        
        var status1 : String?
        var intStatus1 : Int?
        let defaultPlaceX = DBRef.child("table/PStatus").child(hogeArray[indexPath.row])
        defaultPlaceX.observe(.value, with: { snapshot in
            status1 = (snapshot.value! as AnyObject).description
            intStatus1 = Int(status1!)
            if intStatus1! == 1{
                cell.contentView.backgroundColor = UIColor(red:0.87, green:0.91, blue:0.70, alpha:1.0)
            }else if intStatus1! == 2{
                cell.isHidden = true
            }else{
                cell.contentView.backgroundColor = UIColor.clear
            }
        })
        
        let defaultPlace0 = self.DBRef.child("table/order").child(self.hogeArray[indexPath.row]).child("time")
        defaultPlace0.observe(.value, with: { snapshot in
            self.hogeTime = (snapshot.value! as AnyObject).description
            self.dateUnix = TimeInterval(self.hogeTime!)!
            let hogeDate = NSDate(timeIntervalSince1970: self.dateUnix/1000)
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:ss"
            self.time[indexPath.row] = formatter.string(from: hogeDate as Date)
        })
        let defaultPlace1 = self.DBRef.child("table/order").child(self.hogeArray[indexPath.row]).child("P1Amount")
        defaultPlace1.observe(.value, with: { snapshot in
            self.P1Amount[indexPath.row] = (snapshot.value! as AnyObject).description
        })
        let defaultPlace2 = self.DBRef.child("table/order").child(self.hogeArray[indexPath.row]).child("P2Amount")
        defaultPlace2.observe(.value, with: { snapshot in
            self.P2Amount[indexPath.row] = (snapshot.value! as AnyObject).description
        })
        timeLabel.text = "\(String(describing: self.time[indexPath.row]))"
        tableLabel.text = "Table \(String(describing: self.hogeArray[indexPath.row]))"
        P1Label.text =  "\(String(describing: self.P1Amount[indexPath.row]))"
        P2Label.text =  "\(String(describing: self.P2Amount[indexPath.row]))"
        
        if P1Label.text == "0" && P2Label.text == "0"{
            cell.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRow = hogeArray[indexPath.row]
        let defaultPlace = self.DBRef.child("table")
        defaultPlace.child("PStatus").child(self.selectedRow!).observeSingleEvent(of: .value, with: { (snapshot) in
            self.status = (snapshot.value! as AnyObject).description
            if self.status == "0"{
                let alertController = UIAlertController(title: "調理完了",message: "調理完了としてマークします", preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default){ (action: UIAlertAction) in
                    defaultPlace.child("status").child(self.selectedRow!).observeSingleEvent(of: .value, with: { (snapshot) in
                        self.status = (snapshot.value! as AnyObject).description
                        if self.status == "0" || self.status == "1"{
                            self.DBRef.child("table/status").child(self.selectedRow!).setValue(2)
                        }
                    })
                    defaultPlace.child("PStatus").child(self.selectedRow!).setValue(1)
                }
                let cancelButton = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: nil)
                alertController.addAction(okAction)
                alertController.addAction(cancelButton)
                self.present(alertController,animated: true,completion: nil)
            } else {
                let alertController = UIAlertController(title: "調理未完了",message: "調理完了を取消します", preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default){ (action: UIAlertAction) in
                    defaultPlace.child("PStatus").child(self.selectedRow!).setValue(0)
                }
                let cancelButton = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: nil)
                alertController.addAction(okAction)
                alertController.addAction(cancelButton)
                self.present(alertController,animated: true,completion: nil)
            }
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //インスタンスを作成
        DBRef = Database.database().reference()
        //オーダーリストの取得
        let defaultPlace = DBRef.child("table/orderOrder")
        defaultPlace.observe(.value, with: { snapshot in
            var array: [String] = []
            for item in (snapshot.children) {
                let snapshot = item as! DataSnapshot
                let dict = snapshot.value as! String
                if Int(dict)!<100{
                    array.append(dict)
                }
            }
            DispatchQueue.main.async {
                self.hogeArray = array
            }
        })
        Timer.scheduledTimer(
            timeInterval: 0.5,
            target: self,
            selector: #selector(self.newArray(_:)),
            userInfo: nil,
            repeats: true
        )
    }
    
    @objc func newArray(_ sender: Timer) {
        self.tableView.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
