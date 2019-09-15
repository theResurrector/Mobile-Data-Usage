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
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getNumberOfItemsByYear()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? DataUsageCell)!
        cell.lblYear.text = viewModel.getAllEntriesByYear()[row].year ?? ""
        cell.lblTotalConsumption.text = viewModel.getAllEntriesByYear()[row].totalConsumption ?? ""
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let contentWidth = collectionView.frame.width - 16 - 48
        let width = contentWidth / 3
        let height: CGFloat = width
        
        return CGSize(width: width, height: height)
    }
    
}

