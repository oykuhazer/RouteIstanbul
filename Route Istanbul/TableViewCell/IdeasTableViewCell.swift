//
//  IdeasTableViewCell.swift
//  Route Istanbul
//
//  Created by Öykü Hazer Ekinci on 21.06.2023.
//

import UIKit
import Firebase
import FirebaseFirestore

class IdeasTableViewCell: UITableViewCell {

    @IBOutlet weak var labelUsername: UILabel!
    @IBOutlet weak var textViewIdea: UITextView!
    @IBOutlet weak var labelAddedDate: UILabel!
    
    @IBOutlet weak var labelPlaceName: UILabel!
    var selectedIdeas : Ideas!
    
    override func awakeFromNib() {
           super.awakeFromNib()

       }

    private func applyCornerRadius(to view: UIView) {
        view.layer.cornerRadius = 6.0
        view.layer.masksToBounds = true
    }
    
    func setView (ideas: Ideas) {
    
        selectedIdeas = ideas
        labelUsername.text = ideas.userName
        textViewIdea.text = ideas.ideasText
        labelPlaceName.text = ideas.commentPlace
        
        applyCornerRadius(to: labelUsername)
        applyCornerRadius(to: textViewIdea)
        applyCornerRadius(to: labelPlaceName)
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd MM YYYY, hh:mm"
        let addedDate = dateFormat.string(from: ideas.addedDate)
        labelAddedDate.text = addedDate
    }
}

