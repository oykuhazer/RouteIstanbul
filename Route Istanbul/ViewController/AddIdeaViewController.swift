//
//  AddIdeaViewController.swift
//  Route Istanbul
//
//  Created by Öykü Hazer Ekinci on 25.06.2023.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class AddIdeaViewController: UIViewController{
    
    @IBOutlet weak var viewforTab: UIView!
    
    var textFieldValue: String?
    private var segmentedControl: UISegmentedControl!
    
    // Text field for place name
    private let textFieldPlaceName: UITextField = {
           let textFieldPlaceName = UITextField()
        
        // Set background color and text color
        textFieldPlaceName.backgroundColor = UIColor(named: "ocean2")
        textFieldPlaceName.textColor = .black
        
        // Set border color based on the named color "ocean" or light gray
           if let oceanColor = UIColor(named: "ocean") {
               textFieldPlaceName.layer.borderColor = oceanColor.cgColor
           } else {
               textFieldPlaceName.layer.borderColor = UIColor.lightGray.cgColor
           }
        
        textFieldPlaceName.layer.cornerRadius = 8.0
        textFieldPlaceName.font = UIFont.systemFont(ofSize: 16)
        textFieldPlaceName.textAlignment = .center
        
           return textFieldPlaceName
       }()
       
    // Text field for username
       private let textFieldUsername: UITextField = {
           let textFieldUsername = UITextField()
           // Set background color and text color
           textFieldUsername.backgroundColor = UIColor(named: "ocean2")
           textFieldUsername.textColor = .black
           
           // Set border color based on the named color "ocean" or light gray
           if let oceanColor = UIColor(named: "ocean") {
               textFieldUsername.layer.borderColor = oceanColor.cgColor
           } else {
               textFieldUsername.layer.borderColor = UIColor.lightGray.cgColor
           }
           textFieldUsername.layer.cornerRadius = 8.0
           textFieldUsername.font = UIFont.systemFont(ofSize: 16)
           textFieldUsername.textAlignment = .center
           return textFieldUsername
       }()
       
    // Text view for comment
    private let textViewComment: UITextView = {
        let textViewComment = UITextView()
        
        // Set background color and text color
        textViewComment.backgroundColor = UIColor(named: "ocean2")
        textViewComment.textColor = .black
        textViewComment.layer.borderWidth = 3.0
        
        // Set border color based on the named color "ocean" or light gray
        if let oceanColor = UIColor(named: "ocean") {
            textViewComment.layer.borderColor = oceanColor.cgColor
        } else {
            textViewComment.layer.borderColor = UIColor.lightGray.cgColor
        }
        
        textViewComment.layer.cornerRadius = 8.0
        textViewComment.font = UIFont.systemFont(ofSize: 16)
        return textViewComment
    }()
    
    // Share button
    private let shareButton: UIButton = {
         let shareButton = UIButton()
        // Set background color, text color, title, font, and corner radius
        let oceanColor = UIColor(named: "ocean") ?? UIColor.darkGray
        shareButton.backgroundColor = oceanColor
        shareButton.setTitleColor(.white, for: .normal)
        shareButton.setTitle("Share", for: .normal)
        shareButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        shareButton.layer.cornerRadius = 8.0
        return shareButton
     }()
    
    let placeholderText = "Share your opinion.."
    var selectedCategory = "Religion"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let oceanColor = UIColor(named: "ocean") {
               navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: oceanColor]
           }
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // Add subviews to the view
        view.addSubview(textViewComment)
        view.addSubview(shareButton)
        view.addSubview(textFieldPlaceName)
        view.addSubview(textFieldUsername)
        textFieldPlaceName.text = textFieldValue
        textViewComment.frame = CGRect(x: 20, y: 430, width: view.frame.width - 40, height: 200)
        shareButton.frame = CGRect(x: 20, y: textViewComment.frame.origin.y + textViewComment.frame.height + 20, width:textViewComment.frame.width, height: 50)
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        textViewComment.text = placeholderText
        textViewComment.textColor = .lightGray
        textViewComment.delegate = self
        textFieldUsername.delegate = self
        setupSegmentedControl()
        textFieldPlaceName.frame = CGRect(x: 20, y: 240, width: view.frame.width - 40, height: 50)
        textFieldUsername.frame = CGRect(x: 20, y: textViewComment.frame.origin.y - 100, width: view.frame.width - 40, height: 50)
        fetchUsernameFromFirestore()
        designableTabBar()
    }
    
    // Fetch the username from Firestore
    private func fetchUsernameFromFirestore() {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }

        Firestore.firestore().collection("users").document(currentUserID).getDocument { (snapshot, error) in
            if let error = error {
                print("Firestore error: \(error.localizedDescription)")
                return
            }

            if let document = snapshot, document.exists {
                let username = document.data()?["username"] as? String
                DispatchQueue.main.async {
                    self.textFieldUsername.text = username
                }
            }
        }
    }
    
    // Setup the segmented control
    private func setupSegmentedControl() {
            let segmentedControl = UISegmentedControl(items: ["Religion", "Park", " Museum", "Monument", "Texture"])
            segmentedControl.selectedSegmentIndex = 0
        
            segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
           
        // Set border color, border width, and selected segment tint color based on the named color "ocean" or light gray
        if let oceanColor = UIColor(named: "ocean") {
                 segmentedControl.layer.borderColor = oceanColor.cgColor
                 segmentedControl.layer.borderWidth = 2.5
                 segmentedControl.selectedSegmentTintColor = oceanColor
             } else {
                 segmentedControl.layer.borderColor = UIColor.lightGray.cgColor
                 segmentedControl.layer.borderWidth = 2.5
                 segmentedControl.selectedSegmentTintColor = UIColor.lightGray
             }
        
            segmentedControl.selectedSegmentTintColor = UIColor(named: "ocean")
            segmentedControl.backgroundColor = UIColor(named: "ocean2")
            segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
            segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
            segmentedControl.frame = CGRect(x: 20, y: 150, width: view.frame.width - 40, height: 30)
            view.addSubview(segmentedControl)
        }
        
    // Handle segmented control value change
  @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
  
      switch sender.selectedSegmentIndex {
             case 0:
                 selectedCategory = Comments.Religion.rawValue
             case 1:
          selectedCategory = Comments.Park.rawValue
             case 2:
          selectedCategory = Comments.Museum.rawValue
             case 3:
          selectedCategory = Comments.Monument.rawValue
             case 4:
          selectedCategory = Comments.Texture.rawValue
             default:
          selectedCategory = Comments.Religion.rawValue
         }
     }
    
    
    @objc private func shareButtonTapped() {
        
        // Get the values from text fields and text view
        guard let textFieldPlaceName = textFieldPlaceName.text else { return }
        guard let textFieldUsername = textFieldUsername.text else { return }

        // Add a new document to the Firestore collection
                Firestore.firestore().collection(ideas_ref).addDocument(data: [
                    categories: selectedCategory,
                    comments_number: 0,
                    ideas_text: textViewComment.text!,
                    addedate: FieldValue.serverTimestamp(),
                    username: textFieldUsername,
                    comments_place: textFieldPlaceName
        ]) {(hata) in
            if let hata = hata {
                print("Document Hatası: \(hata.localizedDescription)")
            } else {
                
                // If the document is added successfully, navigate to the CommentListViewController
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: "CommentListViewController") as! CommentListViewController
                self.navigationController?.pushViewController(viewController, animated: true)
              }
           }
       }
    
    // Override the preferred status bar style
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
      }
    
    // Configure the designable tab bar
      func designableTabBar() {
          viewforTab.layer.cornerRadius = viewforTab.frame.size.height/2
          viewforTab.clipsToBounds = true
      }
      
    // Handle the click event of the tab bar buttons
    @IBAction func onClickTabBar(_ sender: UIButton) {
        let tag = sender.tag
        print(tag)
        if tag == 1 {
            guard let house = self.storyboard?.instantiateViewController(withIdentifier: "EntryViewController") as? EntryViewController else { return }
            navigationController?.pushViewController(house, animated: true)
        } else if tag == 2 {
            guard let category = self.storyboard?.instantiateViewController(withIdentifier: "CategoryViewController") as? CategoryViewController else { return }
            navigationController?.pushViewController(category, animated: true)
        } else if tag == 3 {
            guard let all = self.storyboard?.instantiateViewController(withIdentifier: "AllHistoriesViewController") as? AllHistoriesViewController else { return }
            navigationController?.pushViewController(all, animated: true)
        } else {
            guard let wish = self.storyboard?.instantiateViewController(withIdentifier: "WishListViewController") as? WishListViewController else { return }
            navigationController?.pushViewController(wish, animated: true)
        }
    }
}

extension AddIdeaViewController: UITextViewDelegate, UITextFieldDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        // Clear the placeholder text and change the text color when editing begins
        if textView.text == placeholderText {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        // Restore the placeholder text and text color when editing ends and the text view is empty
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = .black
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Disable text field editing for textFieldUsername
            if textField == textFieldUsername {
                return false
            }
            return true
        }
    }
  


