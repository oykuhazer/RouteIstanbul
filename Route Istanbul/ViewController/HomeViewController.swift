//
//  HomeViewController.swift
//  Route Istanbul
//
//  Created by Öykü Hazer Ekinci on 21.06.2023.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // Creating a UILabel and setting its properties
        let labelWelcome = UILabel()
        labelWelcome.text = "To be a part of Route Istanbul's journey, log in to your account and uncover the finest travel tips and extraordinary experiences!"
        labelWelcome.textColor = UIColor.white
        labelWelcome.font = UIFont.boldSystemFont(ofSize: 25)
        labelWelcome.textAlignment = .left
        labelWelcome.numberOfLines = 0
        
        // Adding the label to the view
        view.addSubview(labelWelcome)
        
        // Setting up autolayout constraints for the label
        labelWelcome.translatesAutoresizingMaskIntoConstraints = false
        labelWelcome.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        labelWelcome.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        labelWelcome.topAnchor.constraint(equalTo: view.topAnchor, constant: 280).isActive = true
        
        // Creating a UIButton and setting its properties
            let emailButton = UIButton(type: .system)
            emailButton.setTitle("Sign up with email", for: .normal)
    
            emailButton.backgroundColor = UIColor.black
            emailButton.setTitleColor(UIColor.white, for: .normal)
            emailButton.layer.cornerRadius = 26
            emailButton.layer.borderWidth = 2
            emailButton.layer.borderColor = UIColor.white.cgColor
            emailButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            
        // Setting up the email image for the button
    let emailImage = UIImage(named:  "email_image")?.withRenderingMode(.alwaysTemplate).resizableImage(withCapInsets: .zero)
    emailButton.setImage(emailImage, for: .normal)
    emailButton.imageView?.contentMode = .scaleAspectFit
    emailButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -115, bottom: 0, right: 0)
    emailButton.tintColor = UIColor.white
        
        // Adding a target for the button's touchUpInside event
    emailButton.addTarget(self, action: #selector(emailButtonTapped), for: .touchUpInside)
            
        // Adding the button to the view
        view.addSubview(emailButton)
        
        // Setting up autolayout constraints for the button
        emailButton.translatesAutoresizingMaskIntoConstraints = false
        emailButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        emailButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        emailButton.topAnchor.constraint(equalTo: labelWelcome.bottomAnchor, constant: 50).isActive = true
        emailButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
    }
    
    // Function called when the email button is tapped
@objc private func emailButtonTapped() {
        let emailLogInVC = EmailSignUpViewController()
    // Pushing the view controller onto the navigation stack
        navigationController?.pushViewController(emailLogInVC, animated: true)
    }

}

