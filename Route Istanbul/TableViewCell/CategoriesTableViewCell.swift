//
//  CategoriesTableViewCell.swift
//  Route Istanbul
//
//  Created by Öykü Hazer Ekinci on 21.06.2023.
//

import UIKit

class CategoriesTableViewCell: UITableViewCell {

    @IBOutlet weak var categoriesView: UIView!
    @IBOutlet weak var categoriesImage: UIImageView!
    @IBOutlet weak var labelCategoriesName: UILabel!
    
    let cornerRadius: CGFloat = 10.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
            super.layoutSubviews()

        categoriesImage.layer.shadowColor = UIColor.black.cgColor
        categoriesImage.layer.shadowOpacity = 0.5
        categoriesImage.layer.shadowOffset = CGSize(width: 2, height: 2)
        categoriesImage.layer.shadowRadius = 4
        categoriesImage.layer.masksToBounds = false
        categoriesView.layer.cornerRadius = cornerRadius
        categoriesImage.layer.cornerRadius = cornerRadius
        }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
