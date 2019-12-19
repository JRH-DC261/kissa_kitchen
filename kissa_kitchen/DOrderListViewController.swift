//
//  DOrderListViewController.swift
//  kissa_list
//
//  Originally created by Kei Kawamura on 2018/09/19.
//  Created by Tomohiro Hori on 2019/05/19.
//  Copyright © 2018 Kei Kawamura / 2019 Tomohiro Hori . All rights reserved.
//

import Foundation
import UIKit
import Firebase

class DOrderListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    // インスタンス変数
    var DBRef:DatabaseReference!
    var hogeArray : [String] = []
    var array1 : [String] = []
    var D1Amount = Array(repeating: "0", count: 20)
    var D2Amount = Array(repeating: "0", count: 20)
    var D3Amount = Array(repeating: "0", count: 20)
    var D4Amount = Array(repeating: "0", count: 20)
    var D5Amount = Array(repeating: "0", count: 20)
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
        //let timeLabel = cell.contentView.viewWithTag(1) as! UILabel
        let tableLabel = cell.contentView.viewWithTag(2) as! UILabel
        let D1Label = cell.contentView.viewWithTag(3) as! UILabel
        let D2Label = cell.contentView.viewWithTag(4) as! UILabel
        let D3Label = cell.contentView.viewWithTag(5) as! UILabel
        let D4Label = cell.contentView.viewWithTag(6) as! UILabel
        let D5Label = cell.contentView.viewWithTag(7) as! UILabel

        var status1 : String?
        var intStatus1 : Int?
        let defaultPlaceX = DBRef.child("table/DStatus").child(hogeArray[indexPath.row])
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

        /*let defaultPlace0 = self.DBRef.child("table/order").child(self.hogeArray[indexPath.row]).child("time")
        defaultPlace0.observe(.value, with: { snapshot in
            self.hogeTime = (snapshot.value! as AnyObject).description
            self.dateUnix = TimeInterval(self.hogeTime!)!
            let hogeDate = NSDate(timeIntervalSince1970: self.dateUnix/1000)
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:ss"
            self.time[indexPath.row] = formatter.string(from: hogeDate as Date)
        })*/
        let defaultPlace1 = self.DBRef.child("table/order").child(self.hogeArray[indexPath.row]).child("D1Amount")
        defaultPlace1.observe(.value, with: { snapshot in
            self.D1Amount[indexPath.row] = (snapshot.value! as AnyObject).description
        })
        let defaultPlace2 = self.DBRef.child("table/order").child(self.hogeArray[indexPath.row]).child("D2Amount")
        defaultPlace2.observe(.value, with: { snapshot in
            self.D2Amount[indexPath.row] = (snapshot.value! as AnyObject).description
        })
        let defaultPlace3 = self.DBRef.child("table/order").child(self.hogeArray[indexPath.row]).child("D3Amount")
        defaultPlace3.observe(.value, with: { snapshot in
            self.D3Amount[indexPath.row] = (snapshot.value! as AnyObject).description
        })
        let defaultPlace4 = self.DBRef.child("table/order").child(self.hogeArray[indexPath.row]).child("D4Amount")
        defaultPlace4.observe(.value, with: { snapshot in
            self.D4Amount[indexPath.row] = (snapshot.value! as AnyObject).description
        })
        let defaultPlace5 = self.DBRef.child("table/order").child(self.hogeArray[indexPath.row]).child("D5Amount")
        defaultPlace5.observe(.value, with: { snapshot in
            self.D5Amount[indexPath.row] = (snapshot.value! as AnyObject).description
        })
        //timeLabel.text = "\(String(describing: self.time[indexPath.row]))"
        tableLabel.text = "Table \(String(describing: self.hogeArray[indexPath.row]))"
        D1Label.text =  "\(String(describing: self.D1Amount[indexPath.row]))"
        D2Label.text =  "\(String(describing: self.D2Amount[indexPath.row]))"
        D3Label.text =  "\(String(describing: self.D3Amount[indexPath.row]))"
        D4Label.text =  "\(String(describing: self.D4Amount[indexPath.row]))"
        D5Label.text =  "\(String(describing: self.D5Amount[indexPath.row]))"

        if D1Label.text == "0" && D2Label.text == "0" && D3Label.text == "0" && D4Label.text == "0" && D5Label.text == "0"{
            cell.isHidden = true
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRow = hogeArray[indexPath.row]
        let defaultPlace = self.DBRef.child("table")
        defaultPlace.child("DStatus").child(self.selectedRow!).observeSingleEvent(of: .value, with: { (snapshot) in
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
                    defaultPlace.child("DStatus").child(self.selectedRow!).setValue(1)
                }
                let cancelButton = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: nil)
                alertController.addAction(okAction)
                alertController.addAction(cancelButton)
                self.present(alertController,animated: true,completion: nil)
            } else {
                let alertController = UIAlertController(title: "調理未完了",message: "調理完了を取消します", preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default){ (action: UIAlertAction) in
                    defaultPlace.child("DStatus").child(self.selectedRow!).setValue(0)
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
                if Int(dict)!<200{
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
