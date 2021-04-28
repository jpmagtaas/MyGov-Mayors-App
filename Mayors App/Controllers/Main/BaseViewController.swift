//
//  BaseViewController.swift
//  Mayors App
//
//  Created by Juan Paolo Magtaas on 2/7/21.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(userEnteredForeground), name: Notification.Name("UserEnteredForeground"), object: nil)
        
//        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(doStuff), userInfo: nil, repeats: true)
//              let reset = UITapGestureRecognizer(target: self, action: #selector(resetTimer));
//              self.view.isUserInteractionEnabled = true
//              self.view.addGestureRecognizer(reset)
    }
    
    @objc fileprivate func userEnteredForeground() {
        //close all presenting views
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let pinVC = storyboard.instantiateViewController(withIdentifier: "LOCK_VC") as! LockViewController
        pinVC.modalTransitionStyle = .coverVertical
        pinVC.modalPresentationStyle = .fullScreen
        
        present(pinVC, animated: true, completion: nil)
    }
    
    @objc func doStuff() {
        print("User inactive for more than 5 seconds .")
        timer.invalidate()
        userEnteredForeground()
    }
    
    @objc func resetTimer() {
        print("User inactive for more than 5 seconds .")
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(doStuff), userInfo: nil, repeats: true)
    }
}
