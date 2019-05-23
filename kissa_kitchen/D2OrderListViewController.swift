//
//  D2OrderListViewController.swift
//  kissa_list
//
//  Originally created by Kei Kawamura on 2018/09/19.
//  Created by Tomohiro Hori on 2019/05/19.
//  Copyright © 2018 Kei Kawamura / 2019 Tomohiro Hori . All rights reserved.
//

import Foundation
import UIKit
import Firebase

class D2OrderListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    // インスタンス変数
    var DBRef:DatabaseReference!
    var hogeArray : [String] = []
    var array1 : [String] = []
    var D11Amount = Array(repeating: "0", count: 20)
    var D12Amount = Array(repeating: "0", count: 20)
    var D13Amount = Array(repeating: "0", count: 20)
    var D14Amount = Array(repeating: "0", count: 20)
    var D15Amount = Array(repeating: "0", count: 20)
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
        let D11Label = cell.contentView.viewWithTag(3) as! UILabel
        let D12Label = cell.contentView.viewWithTag(4) as! UILabel
        let D13Label = cell.contentView.viewWithTag(5) as! UILabel
        let D14Label = cell.contentView.viewWithTag(6) as! UILabel
        let D15Label = cell.contentView.viewWithTag(7) as! UILabel

        var status1 : String?
        var intstatus1 : Int?
        let defaultPlaceX = DBRef.child("table/DStatus").child(hogeArray[indexPath.row])
        defaultPlaceX.observe(.value, with: { snapshot in
            status1 = (snapshot.value! as AnyObject).description
            intstatus1 = Int(status1!)
            if intstatus1! == 1||intstatus1! == 2{
                cell.contentView.backgroundColor = UIColor(red:0.87, green:0.91, blue:0.70, alpha:1.0)
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
        let defaultPlace11 = self.DBRef.child("table/order").child(self.hogeArray[indexPath.row]).child("D11Amount")
        defaultPlace11.observe(.value, with: { snapshot in
            self.D11Amount[indexPath.row] = (snapshot.value! as AnyObject).description
        })
        let defaultPlace12 = self.DBRef.child("table/order").child(self.hogeArray[indexPath.row]).child("D12Amount")
        defaultPlace12.observe(.value, with: { snapshot in
            self.D12Amount[indexPath.row] = (snapshot.value! as AnyObject).description
        })
        let defaultPlace13 = self.DBRef.child("table/order").child(self.hogeArray[indexPath.row]).child("D13Amount")
        defaultPlace13.observe(.value, with: { snapshot in
            self.D13Amount[indexPath.row] = (snapshot.value! as AnyObject).description
        })
        let defaultPlace14 = self.DBRef.child("table/order").child(self.hogeArray[indexPath.row]).child("D14Amount")
        defaultPlace14.observe(.value, with: { snapshot in
            self.D14Amount[indexPath.row] = (snapshot.value! as AnyObject).description
        })
        let defaultPlace15 = self.DBRef.child("table/order").child(self.hogeArray[indexPath.row]).child("D15Amount")
        defaultPlace15.observe(.value, with: { snapshot in
            self.D15Amount[indexPath.row] = (snapshot.value! as AnyObject).description
        })
        //timeLabel.text = "\(String(describing: self.time[indexPath.row]))"
        tableLabel.text = "Table \(String(describing: self.hogeArray[indexPath.row]))"
        D11Label.text =  "\(String(describing: self.D11Amount[indexPath.row]))"
        D12Label.text =  "\(String(describing: self.D12Amount[indexPath.row]))"
        D13Label.text =  "\(String(describing: self.D13Amount[indexPath.row]))"
        D14Label.text =  "\(String(describing: self.D14Amount[indexPath.row]))"
        D15Label.text =  "\(String(describing: self.D15Amount[indexPath.row]))"

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
                    defaultPlace.child("Status").child(self.selectedRow!).setValue(0)
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
