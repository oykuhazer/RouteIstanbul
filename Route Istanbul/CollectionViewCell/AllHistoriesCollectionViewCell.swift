//
//  AllHistoriesCollectionViewCell.swift
//  Route Istanbul
//
//  Created by Öykü Hazer Ekinci on 22.06.2023.
//

import UIKit

class AllHistoriesCollectionViewCell: UICollectionViewCell {
    
  @IBOutlet weak var allHistoriesBackground: UIView!

    @IBOutlet weak var historiesImageView: UIImageView!
    @IBOutlet weak var historiesNameLabel: UILabel!
    var indexPath:IndexPath?
    
    override func awakeFromNib() {
       allHistoriesBackground.layer.cornerRadius = 12
        historiesImageView.layer.cornerRadius = 12
        historiesNameLabel.layer.cornerRadius = 12
        historiesNameLabel.clipsToBounds = true
        historiesNameLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
    if let oceanColor = UIColor(named: "ocean") {
        historiesNameLabel.backgroundColor = oceanColor.withAlphaComponent(0.7)
        }
    }
}

