//
//  DetailInfViewController.swift
//  Route Istanbul
//
//  Created by Öykü Hazer Ekinci on 24.06.2023.
//

import UIKit
import Firebase

class DetailInfViewController: UIViewController {
    
    var ref:DatabaseReference!
    var tarih_ad: String?
    var labelTitle: UILabel!
    var tarih_uzun: String?
    var textViewInformation: UITextView!
   
  
       override func viewDidLoad() {
           super.viewDidLoad()
          
           // Set up the reference to the Firebase Database
           ref = Database.database().reference()
           
           view.backgroundColor = .white
           
           // Create and configure the text view for displaying the information
           textViewInformation = UITextView()
           textViewInformation.translatesAutoresizingMaskIntoConstraints = false
           textViewInformation.text = tarih_uzun
           textViewInformation.font = UIFont(name: "Arial-BoldMT", size: 15.0)
           textViewInformation.textAlignment = .justified
           textViewInformation.textColor = UIColor.black
           view.addSubview(textViewInformation)
           
           // Create and configure the label for displaying the title
           labelTitle = UILabel()
           labelTitle.translatesAutoresizingMaskIntoConstraints = false
           labelTitle.text = tarih_ad
           labelTitle.font = UIFont(name: "Arial-BoldMT", size: 22.0)
           labelTitle.textAlignment = .center
           labelTitle.textColor = UIColor(named: "ocean")
               view.addSubview(labelTitle)

               NSLayoutConstraint.activate([
                labelTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 35),
                labelTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                labelTitle.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
               ])

           NSLayoutConstraint.activate([
            textViewInformation.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 18),
            textViewInformation.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textViewInformation.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            textViewInformation.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
           ])
    
           // Create and configure the dismiss button
           let dismissButton = UIButton(type: .custom)
           dismissButton.translatesAutoresizingMaskIntoConstraints = false
           let config = UIImage.SymbolConfiguration(weight: .bold)
           let image = UIImage(systemName: "xmark", withConfiguration: config)
           dismissButton.setImage(image, for: .normal)
           dismissButton.tintColor = UIColor(named: "ocean")
           dismissButton.layer.cornerRadius = 5
           dismissButton.layer.borderWidth = 1
           dismissButton.layer.borderColor = UIColor.lightGray.cgColor
           dismissButton.addTarget(self, action: #selector(dismissBottomSheet), for: .touchUpInside)
           view.addSubview(dismissButton)

           NSLayoutConstraint.activate([
               dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -14),
               dismissButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
               dismissButton.widthAnchor.constraint(equalToConstant: 35),
               dismissButton.heightAnchor.constraint(equalToConstant: 35)
           ])
           
       }
 
    // Function to dismiss the bottom sheet view controller
   @objc func dismissBottomSheet() {
   dismiss(animated: true, completion: nil)
       
           }
       }
    
