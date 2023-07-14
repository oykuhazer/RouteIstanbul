//
//  FavoriteTableViewCell.swift
//  Route Istanbul
//
//  Created by Öykü Hazer Ekinci on 21.06.2023.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {

    
    @IBOutlet weak var favoriteBackground: UIView!
    let cornerRadius: CGFloat = 10.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        favoriteBackground.layer.shadowColor = UIColor.black.cgColor
        favoriteBackground.layer.shadowOpacity = 0.5
        favoriteBackground.layer.shadowOffset = CGSize(width: 2, height: 2)
        favoriteBackground.layer.shadowRadius = 4
        favoriteBackground.layer.cornerRadius = cornerRadius
    }

}
