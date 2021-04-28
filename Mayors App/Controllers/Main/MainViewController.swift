//
//  MainViewController.swift
//  Mayors App
//
//  Created by Juan Paolo Magtaas on 1/27/21.
//

import Foundation
import UIKit
import ScalingCarousel
import Charts

struct Card {
    let name: String
    let imageName: String
    let total: Double
    let type: String
}

class MainViewController: BaseViewController, ChartViewDelegate, IValueFormatter {
    
    @IBOutlet weak var carousel: ScalingCarouselView!
    @IBOutlet weak var chartView: UIView!
    
    @IBOutlet weak var greetingsLabel: UILabel!
    
    @IBOutlet weak var cardsCV: UICollectionView!
    
    @IBOutlet weak var menuButton: UIBarItem!
    
    let userService = UserService()
    let cardService = CardsService()
    var util = Utils()
    
    var cards: [CardItem]? = GlobalHelper.shared.cards
    
    lazy var lineChartView: LineChartView = {
        let lineChartView = LineChartView()
        lineChartView.backgroundColor = .clear
        lineChartView.fitScreen()
        
        lineChartView.gridBackgroundColor = .clear
        lineChartView.drawGridBackgroundEnabled = true
        
        lineChartView.drawBordersEnabled = false
        
        lineChartView.chartDescription?.enabled = false
        
        lineChartView.pinchZoomEnabled = false
        lineChartView.dragEnabled = true
        lineChartView.setScaleEnabled(true)
        
        lineChartView.legend.enabled = false
        
        lineChartView.xAxis.enabled = false
        
        let leftAxis = lineChartView.leftAxis
        leftAxis.axisMaximum = 3500
        leftAxis.axisMinimum = 0
        leftAxis.drawAxisLineEnabled = false
        lineChartView.setExtraOffsets(left: 20, top: 20, right: 20, bottom: 20)
        
        lineChartView.rightAxis.enabled = false
        lineChartView.leftAxis.enabled = false
        lineChartView.animate(yAxisDuration: 1.0)
        
        lineChartView.delegate = self
        
        return lineChartView
    }()
    
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        
        let dataEntry = dataEntries.first(where: {$0 == entry})
        
        return "\(String(Int(value))) \n" + "\(months[Int(dataEntry?.x ?? 0.0)])"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUser()
        getCardDetails()
        setupLineChartView()
        
    }
    
    func getCardDetails() {
        util.showLoader(view: self)
        self.cardService.getCards { (cardList, err) in
            self.util.dismissLoader()
            if err != nil {
                self.util.showToast(view: self, message: err ?? "", type: .error)
                self.util.checkIfTokenExpired(view: self, errorMessage: err ?? "")
            } else {
                DispatchQueue.main.async {
                    //populate card values
                    GlobalHelper.shared.cards = cardList
                    self.cards = cardList
                    self.carousel.reloadData()
                }
            }
        }
    }
    
    func getUser() {
        //GET USER
        if let username = UserDefaults.standard.string(forKey: "userName") {
            util.showLoader(view: self)
            self.userService.getUser(email: username) { (userDetails, err) in
                if err != nil {
                    DispatchQueue.main.async {
                        self.util.dismissLoader()
                        self.util.showToast(view: self, message: err ?? "", type: .error)
                        self.util.checkIfTokenExpired(view: self, errorMessage: err ?? "")
                    }
                } else {
                    DispatchQueue.main.async {
                        self.util.dismissLoader()
                        self.updateUserInfo()
                    }
                }
            }
        }
    }
    
    func updateUserInfo() {
        let user = GlobalHelper.shared.currentUser
        
        self.greetingsLabel.text = "Hello, \(user?.Designation ?? "") \(user?.FirstName ?? "")"
        
    }
    
    func setupLineChartView() {
        chartView.addSubview(lineChartView)
        
        lineChartView.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: chartView.bounds.size.height)
        
        //setData()
        
        setData(dataPoints: months, values: values)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        carousel.deviceRotated()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        util.clearNavigationBarColor(self, true)
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //util.clearNavigationBarColor(self, false)
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
    
    let months = ["Jan", "Feb", "Mar", "Apr"]
    let values = [1985.0, 970.0, 2815.0, 1267]
    var dataEntries: [ChartDataEntry] = []
    
    func setData(dataPoints: [String], values: [Double]) {
        //let set1 = LineChartDataSet(entries: yValues, label: "Constituents")
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let set1 = LineChartDataSet(entries: dataEntries, label: "Constituents")
        
        let gradientColors = [ChartColorTemplates.colorFromString("#fcf4e7").cgColor, ChartColorTemplates.colorFromString("#f9c683").cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        
        set1.fillAlpha = 0.8
        set1.fill = Fill(linearGradient: gradient, angle: 90)
        set1.drawFilledEnabled = true
        set1.mode = .cubicBezier
        set1.lineWidth = 3
        set1.setColor(ChartColorTemplates.colorFromString("#c57101"))
        set1.setCircleColor(.white)
        set1.valueFont = .boldSystemFont(ofSize: 10)
        set1.circleRadius = 10
        
        let data = LineChartData(dataSets: [set1])
        
        data.dataSets[0].valueFormatter = self
        
        lineChartView.data = data
    }
    
    @IBAction func openMenu(_ sender: Any) {
        sideMenuController?.showLeftView(animated: true, completionHandler: nil)
    }
}

typealias CarouselDataSource = MainViewController
extension CarouselDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        let card = cards?[indexPath.row]
        
        if let scalingCell = cell as? MainCollectionViewCell {
            scalingCell.mainView.backgroundColor = .white
            scalingCell.alphaMinimum = 1
            
            scalingCell.nameLabel.text = card?.Title ?? ""
            
            if let url = URL(string:card?.Icon ?? "") {
                scalingCell.cardImage.load(url: url)
            }
            scalingCell.cardTotalLabel.text = "\(card?.Number ?? "0")"
            scalingCell.cardType.text = card?.Description
        }

        DispatchQueue.main.async {
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
        }
        
        return cell
    }
}

typealias CarouselDelegate = MainViewController
extension MainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //Push Info View
        let card = cards?[indexPath.row]
        
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "INFO_VC") as! InfoViewController
        vc.title = card?.Title
        vc.contents = card?.Content
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        carousel.didScroll()
        
        guard let currentCenterIndex = carousel.currentCenterCellIndex?.row else { return }
        
        //print(String(describing: currentCenterIndex))
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let currentCenterIndex = carousel.currentCenterCellIndex?.row else { return }
        
        print(String(describing: currentCenterIndex))
    }
}

private typealias ScalingCarouselFlowDelegate = MainViewController
extension ScalingCarouselFlowDelegate: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
}
