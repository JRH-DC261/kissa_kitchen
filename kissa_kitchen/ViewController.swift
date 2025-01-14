//
//  ViewController.swift
//  kissa_list
//
//  Created by Kei Kawamura on 2018/09/19.
//  Modified by Tomohiro Hori from 2019/03/18~.
//  Copyright © 2018 Kei Kawamura / 2019 Tomohiro Hori . All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBAction func ToWOrderList(_ sender: Any) {
        performSegue(withIdentifier: "toWOrderList", sender: nil)
    }
    @IBAction func ToPOrderList(_ sender: Any) {
        performSegue(withIdentifier: "toPOrderList", sender: nil)
    }
    @IBAction func ToSOrderList(_ sender: Any) {
        performSegue(withIdentifier: "toSOrderList", sender: nil)
    }
    @IBAction func ToDOrderList(_ sender: Any) {
        performSegue(withIdentifier: "toDOrderList", sender: nil)
    }
    @IBAction func ToD2OrderList(_ sender: Any) {
        performSegue(withIdentifier: "toD2OrderList", sender: nil)
    }

    override func  prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination
        if (segue.identifier == "toWOrderList"){
            nextVC.navigationItem.title = "サンドウィッチ"
        }else if (segue.identifier == "toPOrderList"){
            nextVC.navigationItem.title = "パンケーキ"
        }else if (segue.identifier == "toSOrderList"){
            nextVC.navigationItem.title = "スープ"
        }else if (segue.identifier == "toDOrderList"){
            nextVC.navigationItem.title = "ドリンク"
        }else if (segue.identifier == "toD2OrderList"){
            nextVC.navigationItem.title = "カクテル"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

}
