//
//  ViewController.swift
//  MobileDataUsage
//
//  Created by Anson on 12/9/19.
//  Copyright © 2019 Anson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let viewModel = MainViewModel()
    
    @IBOutlet weak var dataCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        viewModel.getData()
        
        viewModel.updateUI = {[weak self] in
            DispatchQueue.main.async {
                self?.dataCollectionView.reloadData()
            }
        }
    }
    
    func setupView() {
        dataCollectionView.delegate = self
        dataCollectionView.dataSource = self
        dataCollectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getNumberOfItemsByYear()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? DataUsageCell)!
        cell.delegate = self
        cell.lblYear.text = viewModel.getAllEntriesByYear()[row].year ?? ""
        cell.lblTotalConsumption.text = viewModel.getAllEntriesByYear()[row].totalConsumption ?? ""
        cell.showDecreasedConsumption(viewModel.getAllEntriesByYear()[row].hasConsumptionDropped ?? false)
        cell.message = viewModel.getAllEntriesByYear()[row].message
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let contentWidth = collectionView.frame.width - 16 - 48
        let width = contentWidth / 3
        let height: CGFloat = width
        
        return CGSize(width: width, height: height + 30)
    }
}

extension ViewController: DataUsageCellProtocol {
    func lowerConsumptionImageTapped(message: String?) {
        let alert = UIAlertController(title: "Decrease in consumption", message: message ?? "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        self.present(alert, animated: true, completion: nil)
    }
}

