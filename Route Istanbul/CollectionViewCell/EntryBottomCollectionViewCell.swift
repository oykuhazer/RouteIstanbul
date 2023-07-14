//
//  EntryBottomCollectionViewCell.swift
//  Route Istanbul
//
//  Created by Öykü Hazer Ekinci on 22.06.2023.
//

import UIKit

class EntryBottomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var squareLabel: UILabel!
    @IBOutlet weak var squareImageView: UIImageView!
    var indexPath:IndexPath?
    
    override func layoutSubviews() {
        super.layoutSubviews()
   
        squareImageView.layer.cornerRadius = 5
        squareImageView.layer.masksToBounds = true
    
        squareLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        squareLabel.font = UIFont(name: "Arial", size: 10)
        squareLabel.font = UIFont.boldSystemFont(ofSize: 10)
        squareLabel.backgroundColor = UIColor(named: "ocean")
    }
    }
