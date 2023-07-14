//
//  EmailSignUpViewController.swift
//  Route Istanbul
//
//  Created by Öykü Hazer Ekinci on 21.06.2023.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class EmailSignUpViewController: UIViewController {
    
    // Define properties
    let passwordTextField = UITextField()
    let showPasswordButton = UIButton(type: .custom)
    let passwordRequirementLabel = UILabel()
    let passwordRequirementLabel2 = UILabel()
    let passwordRequirementimageView = UIImageView()
    let passwordRequirementimageView2 = UIImageView()
    let emailTextField = UITextField()
    let signUpButton = UIButton(type: .custom)
    var username: String?
    let userTextField = UITextField()
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // Set delegates for text fields
        emailTextField.delegate = self
        userTextField.delegate = self
        passwordTextField.delegate = self
        
        // Add target action for sign up button
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)

        view.backgroundColor = UIColor.black
        
        // Create and configure the labelSignup
        let labelSignUp = UILabel()
        labelSignUp.text = "Become a Route Istanbul member."
        labelSignUp.textColor = UIColor.white
        labelSignUp.font = UIFont.boldSystemFont(ofSize: 22)
        labelSignUp.textAlignment = .left
        view.addSubview(labelSignUp)
        
        // Set auto-layout constraints for the labelSignup
        labelSignUp.translatesAutoresizingMaskIntoConstraints = false
        labelSignUp.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        labelSignUp.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        
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
        
        // Set auto-layout constraints for the email text field
        emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        emailTextField.topAnchor.constraint(equalTo: labelSignUp.bottomAnchor, constant: 60).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // Create and configure the email label
        let emailLabel = UILabel()
        emailLabel.text = "E-mail address"
        emailLabel.textColor = UIColor.white
        emailLabel.font = UIFont.boldSystemFont(ofSize: 17)
        emailLabel.textAlignment = .left
        view.addSubview(emailLabel)
        
        // Set auto-layout constraints for the email label
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        emailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        emailLabel.bottomAnchor.constraint(equalTo: emailTextField.topAnchor, constant: -8).isActive = true
     
        // Create and configure the username text field
        userTextField.placeholder = "Username"
        userTextField.backgroundColor = UIColor.darkGray
        userTextField.textColor = UIColor.white
        userTextField.borderStyle = .roundedRect
        userTextField.layer.borderColor = UIColor.lightGray.cgColor
        userTextField.layer.borderWidth = 1.0
        userTextField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        userTextField.layer.cornerRadius = 4.0
        userTextField.clipsToBounds = true
        userTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userTextField)
       
        // Set auto-layout constraints for the username text field
        userTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        userTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        userTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 60).isActive = true
        userTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // Create and configure the username label
        let userLabel = UILabel()
        userLabel.text = "Username"
        userLabel.textColor = UIColor.white
        userLabel.font = UIFont.boldSystemFont(ofSize: 17)
        userLabel.textAlignment = .left
        view.addSubview(userLabel)
        
        // Set auto-layout constraints for the username label
        userLabel.translatesAutoresizingMaskIntoConstraints = false
        userLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        userLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        userLabel.bottomAnchor.constraint(equalTo: userTextField.topAnchor, constant: -8).isActive = true
  
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
        
        // Set auto-layout constraints for the password text field
        passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 170).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
        // Create and configure the show password button
        showPasswordButton.setImage(UIImage(systemName: "key.horizontal"), for: .normal)
        showPasswordButton.tintColor = .white
        showPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(showPasswordButton)
        
        // Set auto-layout constraints for the show password button
        showPasswordButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor, constant: -8).isActive = true
        showPasswordButton.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor).isActive = true
        showPasswordButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        showPasswordButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        // Add target action for show password button
        showPasswordButton.addTarget(self, action: #selector(showPasswordButtonTapped), for: .touchUpInside)
        
        // Create and configure the password label
        let passwordLabel = UILabel()
        passwordLabel.text = "Password"
        passwordLabel.textColor = UIColor.white
        passwordLabel.font = UIFont.boldSystemFont(ofSize: 17)
        passwordLabel.textAlignment = .left
        view.addSubview(passwordLabel)
        
        // Set auto-layout constraints for the password label
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        passwordLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        passwordLabel.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -8).isActive = true
        
        // Set up the sign-up button
        signUpButton.backgroundColor = UIColor.white
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.setTitleColor(UIColor.black, for: .normal)
        signUpButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        signUpButton.layer.cornerRadius = 25
        signUpButton.clipsToBounds = true
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(signUpButton)
        
        // Set up constraints for the sign-up button
        signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        signUpButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 120).isActive = true
        signUpButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
       
        // Set up the login button
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
        
        // Set up constraints for the login button
        loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        loginButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 20).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        // Add target for login button tap
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        // Set up left views for email and password text fields
        let emailLeftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        emailTextField.leftView = emailLeftView
        emailTextField.leftViewMode = .always
        
        let passwordLeftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        passwordTextField.leftView = passwordLeftView
        passwordTextField.leftViewMode = .always
        
        // Set up the first password requirement label
        passwordRequirementLabel.text = "Minimum of 10 characters"
        passwordRequirementLabel.textColor = UIColor.white
        passwordRequirementLabel.font = UIFont.systemFont(ofSize: 15)
        passwordRequirementLabel.textAlignment = .left
        view.addSubview(passwordRequirementLabel)

        // Set up constraints for the first password requirement label
        passwordRequirementLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordRequirementLabel.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor, constant:30 ).isActive = true
        passwordRequirementLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 35).isActive = true
        
        // Set up the second password requirement label
        passwordRequirementLabel2.text = "Must include special characters"
        passwordRequirementLabel2.textColor = UIColor.white
        passwordRequirementLabel2.font = UIFont.systemFont(ofSize: 15)
        passwordRequirementLabel2.textAlignment = .left
        view.addSubview(passwordRequirementLabel2)

        // Set up constraints for the second password requirement label
           passwordRequirementLabel2.translatesAutoresizingMaskIntoConstraints = false
           passwordRequirementLabel2.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor, constant: 30).isActive = true
           passwordRequirementLabel2.topAnchor.constraint(equalTo: passwordRequirementLabel.bottomAnchor, constant: 5).isActive = true
        
        // Set the delegate for the password text field
        passwordTextField.delegate = self

        // Set up the first password requirement image view
        passwordRequirementimageView.contentMode = .scaleAspectFit
        passwordRequirementimageView.image = UIImage(named: "carpi_gri")
        view.addSubview(passwordRequirementimageView)

        // Set up constraints for the first password requirement image view
        passwordRequirementimageView.translatesAutoresizingMaskIntoConstraints = false
        passwordRequirementimageView.trailingAnchor.constraint(equalTo: passwordRequirementLabel.leadingAnchor, constant: -10).isActive = true
        passwordRequirementimageView.centerYAnchor.constraint(equalTo: passwordRequirementLabel.centerYAnchor).isActive = true
        passwordRequirementimageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        passwordRequirementimageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        // Add target for password text change
        passwordTextField.addTarget(self, action: #selector(passwordTextChanged), for: .editingChanged)
        
        // Set up the second password requirement image view
        passwordRequirementimageView2.contentMode = .scaleAspectFit
        passwordRequirementimageView2.image = UIImage(named: "carpi_gri")
        view.addSubview(passwordRequirementimageView2)

        // Set up constraints for the second password requirement image view
        passwordRequirementimageView2.translatesAutoresizingMaskIntoConstraints = false
        passwordRequirementimageView2.trailingAnchor.constraint(equalTo: passwordRequirementLabel2.leadingAnchor, constant: -10).isActive = true
        passwordRequirementimageView2.centerYAnchor.constraint(equalTo: passwordRequirementLabel2.centerYAnchor).isActive = true
        passwordRequirementimageView2.widthAnchor.constraint(equalToConstant: 20).isActive = true
        passwordRequirementimageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
     
        // Add target for password text change
        passwordTextField.addTarget(self, action: #selector(passwordTextChanged2), for: .editingChanged)
        
    }
    
    // Called when the password text changes
    @objc func passwordTextChanged() {
           if let password = passwordTextField.text {
               // Update the first password requirement image based on the length of the password
               passwordRequirementimageView.image = password.count >= 10 ? UIImage(named: "check_beyaz") : UIImage(named: "carpi_gri")
           } else {
               passwordRequirementimageView.image = UIImage(named: "carpi_gri")
           }
       }
    
    // Called when the password text changes
    @objc func passwordTextChanged2() {
        if let password = passwordTextField.text {
            // Check if the password contains special characters
            let hasSpecialCharacter = password.rangeOfCharacter(from: .alphanumerics.inverted) != nil
            // Update the second password requirement image based on whether it contains special characters or not
            passwordRequirementimageView2.image = ( hasSpecialCharacter) ? UIImage(named: "check_beyaz") : UIImage(named: "carpi_gri")
        } else {
            passwordRequirementimageView2.image = UIImage(named: "carpi_gri")
        }
    }
    
    // Called when the show password button is tapped
    @objc func showPasswordButtonTapped() {
           passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
           let imageName = passwordTextField.isSecureTextEntry ? "key.horizontal" : "key.horizontal.fill"
           showPasswordButton.setImage(UIImage(systemName: imageName), for: .normal)
           updatePasswordRequirementLabels()
       }
        
    // Update the password requirement labels based on the current password text
    func updatePasswordRequirementLabels() {
          if let password = passwordTextField.text {
              let hasSpecialCharacter = password.rangeOfCharacter(from: .alphanumerics.inverted) != nil
              passwordRequirementLabel.textColor = password.count >= 10 ? UIColor.white : UIColor.lightGray
              passwordRequirementLabel2.textColor = hasSpecialCharacter ? UIColor.white : UIColor.lightGray
          } else {
              passwordRequirementLabel.textColor = UIColor.lightGray
              passwordRequirementLabel2.textColor = UIColor.lightGray
          }
      }
    
    // UITextFieldDelegate method called when characters are about to change in the password text field
      func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
          if textField == passwordTextField {
              if let text = textField.text, let textRange = Range(range, in: text) {
                  let newText = text.replacingCharacters(in: textRange, with: string)
                  // Check if the new text contains special characters
                  let hasSpecialCharacter = newText.rangeOfCharacter(from: .alphanumerics.inverted) != nil
                  // Update the text color of the password requirement labels based on the new text length and special character presence
                  passwordRequirementLabel.textColor = newText.count >= 10 ? UIColor.white : UIColor.lightGray
                  passwordRequirementLabel2.textColor = hasSpecialCharacter ? UIColor.white : UIColor.lightGray
              }
          }
          
          return true
      }
    
    // Called when the login button is tapped
    @objc private func loginButtonTapped() {
            let LogInVC = LogInViewController()
            navigationController?.pushViewController(LogInVC, animated: true)
        }
    
    // Fetch the username associated with the given email from Firestore
    func fetchUsername(for email: String, completion: @escaping (String?) -> Void) {
           let db = Firestore.firestore()
           db.collection("users").whereField("email", isEqualTo: email).getDocuments { (snapshot, error) in
               if let error = error {
                   print("Kullanıcı adını alma hatası: \(error.localizedDescription)")
                   completion(nil)
                   return
               }
               guard let documents = snapshot?.documents, !documents.isEmpty else {
                   print("User not found")
                   completion(nil)
                   return
               }
               let document = documents[0]
               let username = document["username"] as? String
               completion(username)
           }
       }
    
    // Called when the sign-up button is tapped
    @objc private func signUpButtonTapped() {
        if userTextField.text?.isEmpty ?? true {
            // Display an error label if the username field is empty
            let errorLabel = UILabel()
            errorLabel.tag = 100
            errorLabel.text = "Username field is required."
            errorLabel.textColor = UIColor.red
            errorLabel.font = UIFont.systemFont(ofSize: 15)
            errorLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(errorLabel)
            
            errorLabel.leadingAnchor.constraint(equalTo: userTextField.leadingAnchor).isActive = true
            errorLabel.topAnchor.constraint(equalTo: userTextField.bottomAnchor, constant: 5).isActive = true
            
            userTextField.addTarget(self, action: #selector(userTextFieldDidChange), for: .editingChanged)
            
            return
        }
        
        guard let email = emailTextField.text,
                      let password = passwordTextField.text,
                      let username = userTextField.text else {
                    return
        }
        
        if email.isEmpty {
            // Display an error label if the email field is empty
        let errorLabel = UILabel()
        errorLabel.tag = 100
        errorLabel.text = "Please enter a valid email address."
            errorLabel.textColor = UIColor.red
            errorLabel.font = UIFont.systemFont(ofSize: 15)
            errorLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(errorLabel)
            
            errorLabel.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor).isActive = true
            errorLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 5).isActive = true
            
            emailTextField.addTarget(self, action: #selector(emailTextFieldDidChange), for: .editingChanged)
            
            return
        }
        
        if password.isEmpty {
            // Display an error label if the password field is empty
        let errorLabel = UILabel()
                errorLabel.tag = 200
                errorLabel.text = "Please enter a valid password."
                errorLabel.textColor = UIColor.red
                errorLabel.font = UIFont.systemFont(ofSize: 15)
                errorLabel.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(errorLabel)
            
                errorLabel.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor).isActive = true
                errorLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 5).isActive = true
  
                passwordTextField.addTarget(self, action: #selector(passwordTextFieldDidChange), for: .editingChanged)
                
                return
            }
        
        // Check if the email is valid
        if !isValidEmail(email) {
            // Display an error label if the email format is invalid
            let errorLabel = UILabel()
            errorLabel.tag = 100
            errorLabel.text = "The email format is invalid."
            errorLabel.font = UIFont.systemFont(ofSize: 15)
            errorLabel.textColor = UIColor.red
            errorLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(errorLabel)
           
            errorLabel.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor).isActive = true
            errorLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 5).isActive = true
            
            emailTextField.addTarget(self, action: #selector(emailTextFieldDidChange), for: .editingChanged)
            
            return
        }
        
        // Check if the password length is less than 10 characters
        if password.count < 10 {
            // Display an error label if the password is too short
               let errorLabel = UILabel()
               errorLabel.tag = 200
               errorLabel.text = "Your password must be at least 10 characters long."
               errorLabel.textColor = UIColor.red
               errorLabel.font = UIFont.systemFont(ofSize: 15)
               errorLabel.translatesAutoresizingMaskIntoConstraints = false
               view.addSubview(errorLabel)
            
               errorLabel.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor).isActive = true
               errorLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 5).isActive = true
               
               passwordTextField.addTarget(self, action: #selector(passwordTextFieldDidChange), for: .editingChanged)
               
               return
           }
        
        // Check if the password contains a special character
        if !containsSpecialCharacter(password) {
            // Display an error label if the password does not contain a special character
              let errorLabel = UILabel()
              errorLabel.tag = 300
              errorLabel.text = "Your password must contain a special character."
              errorLabel.textColor = UIColor.red
              errorLabel.font = UIFont.systemFont(ofSize: 15)
              errorLabel.translatesAutoresizingMaskIntoConstraints = false
              
              view.addSubview(errorLabel)
              errorLabel.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor).isActive = true
              errorLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 5).isActive = true
              
              passwordTextField.addTarget(self, action: #selector(passwordTextFieldDidChange), for: .editingChanged)
              
              return
          }
        
        // Check if the email is already registered
        if isEmailAlreadyRegistered(email) {
            // Display an error view if the email is already associated with an account
            let errorView = UIView()
            errorView.tag = 400
            errorView.translatesAutoresizingMaskIntoConstraints = false
            
            let errorLabel = UILabel()
            errorLabel.text = "The email address you entered is already associated with an account."
            errorLabel.textColor = UIColor.white
            errorLabel.font = UIFont.systemFont(ofSize: 15)
            errorLabel.translatesAutoresizingMaskIntoConstraints = false
            
            errorView.addSubview(errorLabel)
            errorLabel.leadingAnchor.constraint(equalTo: errorView.leadingAnchor, constant: 10).isActive = true
            errorLabel.topAnchor.constraint(equalTo: errorView.topAnchor, constant: 5).isActive = true
            errorLabel.trailingAnchor.constraint(equalTo: errorView.trailingAnchor, constant: -10).isActive = true
            errorLabel.bottomAnchor.constraint(equalTo: errorView.bottomAnchor, constant: -5).isActive = true
            view.addSubview(errorView)
            
            NSLayoutConstraint.activate([
                errorView.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
                errorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 5),
                errorView.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor)
            ])
            
            emailTextField.addTarget(self, action: #selector(emailTextFieldDidChange), for: .editingChanged)
            
            return
        }

        // Create a user with the provided email and password
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
               guard let self = self else { return }
               
               if let error = error {
                   print("User creation error: \(error.localizedDescription)")
                   return
               }
               
               if let user = authResult?.user {
                   let userData: [String: Any] = ["username": username, "email": email]
                   let db = Firestore.firestore()
                   
                   // Save the username and email to Firestore
                   db.collection("users").document(user.uid).setData(userData) { error in
                       if let error = error {
                           print("Username saving error: \(error.localizedDescription)")
                           return
                       }
        // Navigate to the EntryViewController after successful sign-up
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let viewController = storyboard.instantiateViewController(withIdentifier: "EntryViewController") as! EntryViewController
      viewController.username = username
      self.navigationController?.pushViewController(viewController, animated: true)
                   }
               }
           }
    }
    
    // Called when the user text field changes
    @objc func userTextFieldDidChange() {
        if let errorLabel = view.viewWithTag(100) as? UILabel {
            errorLabel.isHidden = true
        }
    }
    
    // Called when the email text field changes
    @objc private func emailTextFieldDidChange() {
        if let errorLabel = view.viewWithTag(100) as? UILabel {
            errorLabel.removeFromSuperview()
        }
    }
    
    // Called when the password text field changes
    @objc private func passwordTextFieldDidChange() {
        if let errorLabel = view.viewWithTag(200) as? UILabel {
            errorLabel.removeFromSuperview()
        }
        
        let containsSpecialCharacter = containsSpecialCharacter(passwordTextField.text ?? "")
        
        if containsSpecialCharacter, let specialCharacterErrorLabel = view.viewWithTag(300) as? UILabel {
            specialCharacterErrorLabel.removeFromSuperview()
        }
    }

    // Check if the email is valid using a regular expression
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        let isValid = emailPredicate.evaluate(with: email)
        
        return isValid
    }
    
    // Check if the password contains a special character using a regular expression
    private func containsSpecialCharacter(_ password: String) -> Bool {
        let specialCharacterRegex = ".*[^A-Za-z0-9].*"
        let specialCharacterPredicate = NSPredicate(format: "SELF MATCHES %@", specialCharacterRegex)
        let containsSpecialCharacter = specialCharacterPredicate.evaluate(with: password)
        return containsSpecialCharacter
    }
    
    // Check if the email is already registered (dummy implementation)
    private func isEmailAlreadyRegistered(_ email: String) -> Bool {
        return email == "existing@example.com"
       }
    }

// UITextFieldDelegate methods for text field editing
extension EmailSignUpViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.white.cgColor
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.lightGray.cgColor
    } 
}

