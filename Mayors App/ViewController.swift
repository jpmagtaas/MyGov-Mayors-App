//
//  ViewController.swift
//  Mayors App
//
//  Created by Juan Paolo Magtaas on 1/21/21.
//

import UIKit
import MTSlideToOpen

class ViewController: UIViewController {

    @IBOutlet weak var scannerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let slide = MTSlideToOpenView(frame: CGRect(x: 0, y: 0, width: self.scannerView.frame.width, height: self.scannerView.frame.height))
        slide.sliderViewTopDistance = 0
        slide.sliderCornerRadius = 0
        slide.delegate = self
        slide.thumnailImageView.image = #imageLiteral(resourceName: "icon-swipe-button")
        slide.contentMode = .scaleAspectFit
        slide.thumnailImageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        slide.labelText = ""
        slide.slidingColor = UIColor(red:99.0/255, green:99.0/255, blue:99.0/255, alpha:1)
        
        self.scannerView.addSubview(slide)
        
        //FORCE CLAIM CODE
//        let defaults = UserDefaults.standard
//        defaults.set(true, forKey: "didClaim")
    }


}

extension ViewController: MTSlideToOpenDelegate {
    func mtSlideToOpenDelegateDidFinish(_ sender: MTSlideToOpenView) {
        print("Open Scanner")
        
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "SCANQR_VC") as! ScanQRViewController
        vc.modalPresentationStyle = .overFullScreen
        
        self.present(vc, animated: true, completion: {
            sender.resetStateWithAnimation(true)
        })
        
    }
    
}

