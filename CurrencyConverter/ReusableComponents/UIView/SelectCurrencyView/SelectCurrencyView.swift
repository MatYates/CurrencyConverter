//
//  SelectCurrencyView.swift
//  CurrencyConverter
//
//  Created by Mat Yates on 15/1/21.
//

import UIKit

class SelectCurrencyView: UIView {

    @IBOutlet private weak var collectionView: UICollectionView!{
        didSet {
            self.collectionView?.dataSource = self
            self.collectionView?.delegate = self
        }
    }
    
    var currencyChanged: ((Currency) -> Void)?
    var currencies: [Currency] = [] {
        didSet{
            self.refreshCurrencies()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func refreshCurrencies() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.collectionView.performBatchUpdates(nil, completion: { (result) in
                // ready
                if self.currencies.count > 0 {
                    //highlight first cell
                    self.selectCell(indexPath: IndexPath(row: 0, section: 0))
                }
            })
        }
    }

}

extension SelectCurrencyView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currencies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScalingCarouselCell", for: indexPath) as! SelectCurrencyCollectionViewCell
        let currency = self.currencies[indexPath.row]
        cell.currencyLabel.text = currency.currencyCode
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let totalCellWidth = Int(collectionView.layer.frame.size.width) / 3

        let leftInset = (collectionView.layer.frame.size.width - CGFloat(totalCellWidth)) / 2
        let rightInset = leftInset
            
        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalCellWidth: CGFloat = collectionView.layer.frame.size.width / 3
        
        return CGSize(width: totalCellWidth, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currency = self.currencies[indexPath.row]
        let cell = collectionView.cellForItem(at: indexPath) as! SelectCurrencyCollectionViewCell
        cell.currencyLabel.textColor = UIColor.white
        currencyChanged?(currency)
    }
}

extension SelectCurrencyView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollToNearestVisibleCollectionViewCell()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.scrollToNearestVisibleCollectionViewCell()
        }
    }
    
    //this function centers the selected cell and then calls the cell selected delegate
    func scrollToNearestVisibleCollectionViewCell() {
        self.collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        let visibleCenterPositionOfScrollView = Float(self.collectionView.contentOffset.x + (self.collectionView.bounds.size.width / 2))
        var closestCellIndex = -1
        var closestDistance: Float = .greatestFiniteMagnitude
        for i in 0..<self.collectionView.visibleCells.count {
            let cell = self.collectionView.visibleCells[i] as! SelectCurrencyCollectionViewCell
            cell.currencyLabel.textColor = UIColor(named: "CurrencyGreen")
            let cellWidth = cell.bounds.size.width
            let cellCenter = Float(cell.frame.origin.x + cellWidth / 2)

            // Now calculate closest cell
            let distance: Float = fabsf(visibleCenterPositionOfScrollView - cellCenter)
            if distance < closestDistance {
                closestDistance = distance
                closestCellIndex = self.collectionView.indexPath(for: cell)!.row
            }
        }
        if closestCellIndex != -1 {
            self.selectCell(indexPath: IndexPath(row: closestCellIndex, section: 0))
        }
    }
    
    private func selectCell(indexPath: IndexPath) {
        self.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        self.collectionView(self.collectionView, didSelectItemAt: indexPath)
    }
}
