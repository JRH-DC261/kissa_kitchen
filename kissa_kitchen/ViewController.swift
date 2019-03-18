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
    @IBAction func ToBOrderList(_ sender: Any) {
        performSegue(withIdentifier: "toWOrderList", sender: nil)
    }
    
    override func  prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination
        if (segue.identifier == "toWOrderList"){
            nextVC.navigationItem.title = "サンドウィッチ"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

}

