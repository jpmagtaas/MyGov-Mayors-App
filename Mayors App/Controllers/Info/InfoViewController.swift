//
//  InfoViewController.swift
//  Mayors App
//
//  Created by Juan Paolo Magtaas on 1/29/21.
//

import Foundation
import UIKit

class InfoViewController: UIViewController {
    
    var contents: [CardItemContent]? = []
    var topTwoContents: [CardItemContent]? = []
    var otherContents: [CardItemContent]? = []
    @IBOutlet weak var contentCVHeight: NSLayoutConstraint!
    private let spacing:CGFloat = 16.0
    
    @IBOutlet weak var topViewLeftLabel: UILabel!
    @IBOutlet weak var topViewLeftCountLabel: UILabel!
    @IBOutlet weak var topViewLeftSubLabel: UILabel!
    @IBOutlet weak var topViewRightLabel: UILabel!
    @IBOutlet weak var topViewRightCountLabel: UILabel!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var topCardView: UIView!
    @IBOutlet weak var contentCV: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.systemBackground]
        self.navigationController?.navigationBar.tintColor = UIColor.systemBackground
        contentCV.delegate = self
        contentCV.dataSource = self
        
        if let contents = contents {
            for (idx,content) in contents.enumerated() {
                if idx <= 1 {
                    topTwoContents?.append(content)
                } else {
                    otherContents?.append(content)
                }
            }
        }

        //setup top two contents
        if topTwoContents?.count ?? 0 > 0 {
            topViewLeftLabel.text = topTwoContents?[0].Label
            topViewLeftSubLabel.text = topTwoContents?[0].SubLabel
            topViewLeftCountLabel.text = topTwoContents?[0].TotalValue
            
            topViewRightLabel.text = topTwoContents?[1].Label
            topViewRightCountLabel.text = topTwoContents?[1].TotalValue
        }
        
        //set top card layout
        topCardView.layer.cornerRadius = 16
        topCardView.layer.shadowColor = UIColor.gray.cgColor
        topCardView.layer.shadowOffset = CGSize(width: 0, height: 3.0)
        topCardView.layer.shadowRadius = 3.0
        topCardView.layer.shadowOpacity = 0.1
        // Never mask the shadow as it falls outside the view
        topCardView.layer.masksToBounds = false
        topCardView.clipsToBounds = true
        
        let height = contentCV.collectionViewLayout.collectionViewContentSize.height
        contentCVHeight.constant = height
        self.view.layoutIfNeeded()
    }

}

extension InfoViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Other Conntent Count \(otherContents?.count ?? 0)")
        
        return otherContents?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "contentCell", for: indexPath) as! InfoCollectionViewCell
        let content = otherContents?[indexPath.row]
        
        cell.titleLabel.text = content?.Label
        cell.valueLabel.text = content?.TotalValue
        cell.newValueLabel.text = content?.NewValue
        cell.subtitleLabel.text = content?.SubLabel
        setupCell(cell)
        
        return cell
    }
    
    fileprivate func setupCell(_ cell: InfoCollectionViewCell) {
        let radius: CGFloat = 16
        
        cell.contentView.layer.cornerRadius = radius
        // Always mask the inside view
        cell.contentView.layer.masksToBounds = true
        
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 3.0)
        cell.layer.shadowRadius = 3.0
        cell.layer.shadowOpacity = 0.1
        // Never mask the shadow as it falls outside the view
        cell.layer.masksToBounds = false
        
        // Matching the contentView radius here will keep the shadow
        // in sync with the contentView's rounded shape
        cell.layer.cornerRadius = radius
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.contentCV.frame.width / 2) - 8, height: 190)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
