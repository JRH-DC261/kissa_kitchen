//
//  WOrderListViewController.swift
//  kissa_list
//
//  Originally created by Kei Kawamura on 2018/09/19.
//  Created by Tomohiro Hori on 2019/03/18.
//  Copyright © 2018 Kei Kawamura / 2019 Tomohiro Hori . All rights reserved.
//

import Foundation
import UIKit
import Firebase

class WOrderListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    // インスタンス変数
    var DBRef:DatabaseReference!
    var hogeArray : [String] = []
    var array1 : [String] = []
    var W1Amount = Array(repeating: "0", count: 20)
    var W2Amount = Array(repeating: "0", count: 20)
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
        let W1Label = cell.contentView.viewWithTag(3) as! UILabel
        let W2Label = cell.contentView.viewWithTag(4) as! UILabel
        
        var status1 : String?
        var intStatus1 : Int?
        let defaultPlaceX = DBRef.child("table/WStatus").child(hogeArray[indexPath.row])
        defaultPlaceX.observe(.value, with: { snapshot in
            status1 = (snapshot.value! as AnyObject).description
            intStatus1 = Int(status1!)
            if intStatus1! == 1||intStatus1! == 2{
                cell.contentView.backgroundColor = UIColor(red:0.75, green:0.83, blue:0.41, alpha:0.5)
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
        let defaultPlace1 = self.DBRef.child("table/order").child(self.hogeArray[indexPath.row]).child("W1Amount")
        defaultPlace1.observe(.value, with: { snapshot in
            self.W1Amount[indexPath.row] = (snapshot.value! as AnyObject).description
        })
        let defaultPlace2 = self.DBRef.child("table/order").child(self.hogeArray[indexPath.row]).child("W2Amount")
        defaultPlace2.observe(.value, with: { snapshot in
            self.W2Amount[indexPath.row] = (snapshot.value! as AnyObject).description
        })
        timeLabel.text = "\(String(describing: self.time[indexPath.row]))"
        tableLabel.text = "Table \(String(describing: self.hogeArray[indexPath.row]))"
        W1Label.text =  "\(String(describing: self.W1Amount[indexPath.row]))"
        W2Label.text =  "\(String(describing: self.W2Amount[indexPath.row]))"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRow = hogeArray[indexPath.row]
        let alertController = UIAlertController(title: "調理完了",message: "調理完了としてマークします", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default){ (action: UIAlertAction) in
            let defaultPlace = self.DBRef.child("table/status").child(self.selectedRow!)
            defaultPlace.observeSingleEvent(of: .value, with: { (snapshot) in
                self.status = (snapshot.value! as AnyObject).description
                self.DBRef.child("table/WStatus").child(self.selectedRow!).setValue(1)
                if self.status == "0" || self.status == "1"{
                    self.DBRef.child("table/status").child(self.selectedRow!).setValue(2)
                }
            })
        }
    
        let cancelButton = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelButton)
        
        present(alertController,animated: true,completion: nil)
        
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
