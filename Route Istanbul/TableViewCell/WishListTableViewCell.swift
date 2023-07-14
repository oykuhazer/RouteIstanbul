//
//  WishListTableViewCell.swift
//  Route Istanbul
//
//  Created by Öykü Hazer Ekinci on 21.06.2023.
//

import UIKit

class WishListTableViewCell: UITableViewCell {

    @IBOutlet weak var wishImage: UIImageView!
    @IBOutlet weak var wishLabel: UILabel!
    @IBOutlet weak var wishBackground: UIView!
    
    let cornerRadius: CGFloat = 10.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        wishBackground.layer.shadowColor = UIColor.black.cgColor
        wishBackground.layer.shadowOpacity = 0.5
        wishBackground.layer.shadowOffset = CGSize(width: 2, height: 2)
        wishBackground.layer.shadowRadius = 4
        wishBackground.layer.cornerRadius = cornerRadius
    }

}
