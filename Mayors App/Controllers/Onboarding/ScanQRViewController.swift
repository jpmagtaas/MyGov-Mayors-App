//
//  ScanQRViewController.swift
//  Mayors App
//
//  Created by Juan Paolo Magtaas on 1/22/21.
//

import Foundation
import UIKit
import MercariQRScanner

class ScanQRViewController: UIViewController {
    
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var mediaButton: UIButton!
    
    let qrScannerView = QRScannerView()
    
    var validateCodeService = ValidationService()
    var util = Utils()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        qrScannerView.frame = view.bounds
        view.addSubview(qrScannerView)
        qrScannerView.configure(delegate: self)
        qrScannerView.startRunning()
        
        setupButtonLayout()
        
    }
    
    fileprivate func setupButtonLayout() {
        flashButton.layer.cornerRadius = 30
        cancelButton.layer.cornerRadius = 45
        mediaButton.layer.cornerRadius = 30
        
        view.bringSubviewToFront(flashButton)
        view.bringSubviewToFront(cancelButton)
        view.bringSubviewToFront(mediaButton)
    }
    
    @IBAction func tapFlashButton(_ sender: UIButton) {
        qrScannerView.setTorchActive(isOn: !sender.isSelected)
    }
    
    @IBAction func tapCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapMediaButton(_ sender: Any) {
        //FOR SAMPLE PURPOSE ONLY
        
    }
    
}

extension ScanQRViewController: QRScannerViewDelegate {
    func qrScannerView(_ qrScannerView: QRScannerView, didFailure error: QRScannerError) {
        print(error)
        util.showToast(view: self, message: error.localizedDescription, type: .error)
    }

    func qrScannerView(_ qrScannerView: QRScannerView, didSuccess code: String) {
        print(code)
        
        //Validate the code first
        //let sampleCode = "17245"
        
        util.showLoader(view: self, message: "Validating QRCode")
        
        validateCodeService.validateMayorCode(code: code) { (official, err) in
            if official != nil {
                //Successful Validation proceed to Step 1
                DispatchQueue.main.async {
                    self.util.dismissLoader()
                    
                    // Open Account Setup
                    let vc = self.storyboard!.instantiateViewController(withIdentifier: "ACCOUNTSETUP_VC") as! AccountSetupViewController
                    vc.modalPresentationStyle = .overFullScreen
                    vc.official = official
                    
                    //Save Official Data
                    GlobalHelper.shared.official = official
                    
                    self.present(vc, animated: true, completion: nil)
                    
                }
            } else {//Failed Validation
                DispatchQueue.main.async {
                    self.util.dismissLoader()
                    
                    //Show An Alert with the returned message
                    let alert = UIAlertController(title: "Validation Failed", message: err, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: {_ in }))
                    
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
        }
        
    }
    
    func qrScannerView(_ qrScannerView: QRScannerView, didChangeTorchActive isOn: Bool) {
        flashButton.isSelected = isOn
    }
}
