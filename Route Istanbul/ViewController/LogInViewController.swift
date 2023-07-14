//
//  LogInViewController.swift
//  Route Istanbul
//
//  Created by Öykü Hazer Ekinci on 21.06.2023.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class LogInViewController: UIViewController {
    
    // Create the required UI elements
    let passwordTextField = UITextField()
    let showPasswordButton = UIButton(type: .custom)
    let forgotPasswordButton = UIButton(type: .system)
    let emailTextField = UITextField()
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
    super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // Set the delegates and background color
        emailTextField.delegate = self
        passwordTextField.delegate = self
        view.backgroundColor = UIColor.black
        
        // Create and configure the "Welcome" labels
        let labelAgainWelcome = UILabel()
        labelAgainWelcome.text = "It's great to see you again,"
        labelAgainWelcome.textColor = UIColor.white
        labelAgainWelcome.font = UIFont.boldSystemFont(ofSize: 25)
        labelAgainWelcome.textAlignment = .left
        
        view.addSubview(labelAgainWelcome)
        
        labelAgainWelcome.translatesAutoresizingMaskIntoConstraints = false
        labelAgainWelcome.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        labelAgainWelcome.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        
        let  labelAgainWelcome2 = UILabel()
        labelAgainWelcome2.text = "welcome!"
        labelAgainWelcome2.textColor = UIColor.white
        labelAgainWelcome2.font = UIFont.boldSystemFont(ofSize: 25)
        labelAgainWelcome2.textAlignment = .left
        
        view.addSubview(labelAgainWelcome2)
        
        labelAgainWelcome2.translatesAutoresizingMaskIntoConstraints = false
        labelAgainWelcome2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        labelAgainWelcome2.topAnchor.constraint(equalTo: labelAgainWelcome.bottomAnchor, constant: 8).isActive = true
        
        // Create and configure the email text field
        emailTextField.placeholder = "E-mail address"
        emailTextField.backgroundColor = UIColor.darkGray
        emailTextField.textColor = UIColor.white
        emailTextField.borderStyle = .roundedRect
        emailTextField.layer.borderColor = UIColor.lightGray.cgColor
        emailTextField.layer.borderWidth = 1.0
        emailTextField.attributedPlaceholder = NSAttributedString(string: "E-mail address", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        emailTextField.layer.cornerRadius = 4.0
        emailTextField.clipsToBounds = true
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emailTextField)
        
        emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        emailTextField.topAnchor.constraint(equalTo: labelAgainWelcome.bottomAnchor, constant: 120).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let emailLabel = UILabel()
        emailLabel.text = "E-mail address"
        emailLabel.textColor = UIColor.white
        emailLabel.font = UIFont.boldSystemFont(ofSize: 17)
        emailLabel.textAlignment = .left
        view.addSubview(emailLabel)
        
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        emailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        emailLabel.bottomAnchor.constraint(equalTo: emailTextField.topAnchor, constant: -8).isActive = true
        
        // Create and configure the password text field
        passwordTextField.placeholder = "Password"
        passwordTextField.backgroundColor = UIColor.darkGray
        passwordTextField.textColor = UIColor.white
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.layer.borderColor = UIColor.lightGray.cgColor
        passwordTextField.layer.borderWidth = 1.0
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        passwordTextField.layer.cornerRadius = 4.0
        passwordTextField.clipsToBounds = true
        passwordTextField.isSecureTextEntry = true
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(passwordTextField)
        
        passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 55).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
        // Create and configure the show password button
        showPasswordButton.setImage(UIImage(systemName: "key.horizontal"), for: .normal)
        showPasswordButton.tintColor = .white
        showPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(showPasswordButton)
        
        showPasswordButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor, constant: -8).isActive = true
        showPasswordButton.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor).isActive = true
        showPasswordButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        showPasswordButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        showPasswordButton.addTarget(self, action: #selector(showPasswordButtonTapped), for: .touchUpInside)
        
        let passwordLabel = UILabel()
        passwordLabel.text = "Password"
        passwordLabel.textColor = UIColor.white
        passwordLabel.font = UIFont.boldSystemFont(ofSize: 17)
        passwordLabel.textAlignment = .left
        
        view.addSubview(passwordLabel)
        
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        passwordLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        passwordLabel.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -8).isActive = true
        
        // Create and configure the sign-up button
        let signUpButton = UIButton(type: .custom)
        signUpButton.backgroundColor = UIColor.white
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.setTitleColor(UIColor.black, for: .normal)
        signUpButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        signUpButton.layer.cornerRadius = 25
        signUpButton.clipsToBounds = true
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(signUpButton)
        
        signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        signUpButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 70).isActive = true
        signUpButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        // Create and configure the login button
        let loginButton = UIButton(type: .custom)
        loginButton.backgroundColor = UIColor.black
        loginButton.setTitle("Log In", for: .normal)
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        loginButton.layer.cornerRadius = 25
        loginButton.layer.borderColor = UIColor.white.cgColor
        loginButton.layer.borderWidth = 2.0
        loginButton.clipsToBounds = true
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginButton)
        
        loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        loginButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 20).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 55).isActive = true

        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        let emailLeftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        emailTextField.leftView = emailLeftView
        emailTextField.leftViewMode = .always
        
        let passwordLeftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        passwordTextField.leftView = passwordLeftView
        passwordTextField.leftViewMode = .always
    }
    
    // Function triggered when the show password button is tapped
    @objc func showPasswordButtonTapped() {
        // Toggle the secure text entry property of the password text field
           passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
        // Determine the image name based on the secure text entry state
           let imageName = passwordTextField.isSecureTextEntry ? "key.horizontal" : "key.horizontal.fill"
        // Set the image of the show password button
           showPasswordButton.setImage(UIImage(systemName: imageName), for: .normal)
       }

    // Function to fetch the username for a given email
    func fetchUsername(for email: String, completion: @escaping (String?) -> Void) {
           let db = Firestore.firestore()
           
        // Query the "users" collection for the provided email
           db.collection("users").whereField("email", isEqualTo: email).getDocuments { (snapshot, error) in
               if let error = error {
                   print("Kullanıcı adını alma hatası: \(error.localizedDescription)")
                   completion(nil)
                   return
               }
               
               // Check if any documents were found
               guard let documents = snapshot?.documents, !documents.isEmpty else {
                   print("User not found")
                   completion(nil)
                   return
               }
               
               // Retrieve the username from the first document
               let document = documents[0]
               let username = document["username"] as? String
               completion(username)
           }
       }
       
    // Function triggered when the login button is tapped
    @objc private func loginButtonTapped() {
        // Retrieve the email and password from the text fields
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespaces), let password = passwordTextField.text?.trimmingCharacters(in: .whitespaces) else {
            return
        }

        // Authenticate the user with the provided email and password
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                // Show an error alert if login was unsuccessful
                let alertController = UIAlertController(title: "Error", message: "The login was unsuccessful. Error: \(error.localizedDescription)", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            } else {
                // Fetch the username for the logged-in user
                self.fetchUsername(for: email) { username in
                    guard let username = username else {
                                    print("The username is not available.")
                                    return
                                }
                    // Create an instance of the EntryViewController and set the username
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController = storyboard.instantiateViewController(withIdentifier: "EntryViewController") as! EntryViewController
                    viewController.username = username
                    // Push the entry view controller onto the navigation stack
                self.navigationController?.pushViewController(viewController, animated: true)
              }
            }
         }
       }
    }

// UITextFieldDelegate methods
extension LogInViewController: UITextFieldDelegate {
    // Set the border color of the text field to white when editing begins
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.white.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Set the border color of the text field to light gray when editing ends
        textField.layer.borderColor = UIColor.lightGray.cgColor
    }
}
