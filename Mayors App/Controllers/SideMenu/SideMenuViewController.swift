//
//  SideMenuViewController.swift
//  Mayors App
//
//  Created by Juan Paolo Magtaas on 1/29/21.
//

import Foundation
import UIKit

class SideMenuViewController: UIViewController {
    
    @IBOutlet weak var menuTableView: UITableView!
    
    struct MenuItem {
        let name: String
        let imageName: String
    }
    
    //List of Menu Items to display
    let menus = [
        [
            MenuItem(name: "Home", imageName: "house.fill"),
            MenuItem(name: "Calendar", imageName: "calendar"),
            MenuItem(name: "For Signature", imageName: "signature"),
            MenuItem(name: "Chat", imageName: "message"),
            MenuItem(name: "Email", imageName: "envelope.fill")
        ],
        [
            MenuItem(name: "Settings", imageName: "gearshape.fill"),
            MenuItem(name: "Log Out", imageName: "arrow.forward.square")
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuTableView.delegate = self
        menuTableView.dataSource = self
    }
    
    @IBAction func tapLockButton(_ sender: UIButton) {
        sideMenuController?.hideLeftViewAnimated()
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name("UserEnteredForeground"), object: nil)
    }
}

extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus[section].count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 0.5))
            view.backgroundColor = .systemGray2
            
            return view
        }
        
        return UIView(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 0.5
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sideMenuCell", for: indexPath) as! SideMenuTableViewCell
        
        let menu = menus[indexPath.section][indexPath.row] as MenuItem
        
        cell.menuImageView.image = UIImage(systemName: menu.imageName)
        cell.menuLabel.text = menu.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //DO LOGOUT
        if indexPath.section == 1 && indexPath.row == 1 {
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "LOGIN_VC") as! LoginViewController
            
            //self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
            let alert = UIAlertController(title: "Are you sure you want to log out?", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
                UIApplication.shared.windows.first?.rootViewController = vc
                UIApplication.shared.windows.first?.makeKeyAndVisible()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
