//
//  VerificationViewController.swift
//  Mayors App
//
//  Created by Juan Paolo Magtaas on 1/23/21.
//

import Foundation
import UIKit

protocol VerificationViewControllerDelegate {
    func didComplete(stepNumber: Int)
    
    func confirmVerification()
}

class VerificationViewController: UIViewController {
    
    var pageViewController: UIPageViewController!
    
    lazy var viewControllers: [UIViewController] = {
        return setupViewControllers()
    }()
    
    //Required Values
    var official: Official? = nil
    
    fileprivate func setupViewControllers() -> [UIViewController] {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        //setup phone validation view
        let phoneVC = storyboard.instantiateViewController(withIdentifier: "PHONE_VC") as! PhoneViewController
        phoneVC.delegate = self
        
        //setup  details validation view
        let detailsVC = storyboard.instantiateViewController(withIdentifier: "DETAILS_VC") as! DetailsViewController
        detailsVC.delegate = self
        
        //setup  pin validation view
        let pinVC = storyboard.instantiateViewController(withIdentifier: "PIN_VC") as! PinViewController
        pinVC.delegate = self
        
        //setup  email validation view
        let emailVC = storyboard.instantiateViewController(withIdentifier: "EMAIL_VC") as! EmailVerificationViewController
        emailVC.delegate = self
        
        return [phoneVC, detailsVC, pinVC, emailVC]
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.delegate = self
        
        pageViewController.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        pageViewController.view.backgroundColor = .clear
        
        self.addChild(pageViewController)
        self.view.addSubview(pageViewController.view)
        self.view.sendSubviewToBack(pageViewController.view)
        
        self.pageViewController.didMove(toParent: self)
        
        setViewController(page: 0, reverse: false)
    }
    
    fileprivate func setViewController(page: Int, reverse: Bool) {
            
        let currentView = self.viewControllers[page]
        
        var direction: UIPageViewController.NavigationDirection
        
        if reverse { direction = .reverse } else { direction = .forward }
        
        pageViewController.setViewControllers([currentView], direction: direction, animated: true, completion: nil)
    }
    
}

extension VerificationViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            
        guard let index = self.viewControllers.firstIndex(of: viewController) else { return nil }
        
        let prevIndex = index - 1
        
        guard prevIndex >= 0 else { return nil }
        
        guard viewControllers.count > 0 else { return nil }
        
        return self.viewControllers[prevIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = self.viewControllers.firstIndex(of: viewController) else { return nil }
        
        let nextIndex = index + 1
        
        guard viewControllers.count != nextIndex else { return nil }
        
        guard viewControllers.count > nextIndex else { return nil }
        
        return self.viewControllers[nextIndex]
    }
}

extension VerificationViewController: VerificationViewControllerDelegate {
    func confirmVerification() {
        //do something
        let loginVC = self.storyboard!.instantiateViewController(withIdentifier: "LOGIN_VC") as! LoginViewController
        loginVC.modalPresentationStyle = .overFullScreen
        self.present(loginVC, animated: true, completion: nil)
    }
    
    func didComplete(stepNumber: Int) {
        setViewController(page: stepNumber, reverse: false)
    }
}
