//
//  CommentListViewController.swift
//  Route Istanbul
//
//  Created by Öykü Hazer Ekinci on 25.06.2023.
//

import UIKit
import Firebase
import FirebaseFirestore

class CommentListViewController: UIViewController {

    @IBOutlet weak var CommentTableView: UITableView!
    
    private var segmentedControl: UISegmentedControl!
    private var ideas = [Ideas]()
    private var  ideasCollectionRef : CollectionReference!
    private var ideasListener : ListenerRegistration!
    
    var selectedCategory = "Religion"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let oceanColor = UIColor(named: "ocean") {
               navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: oceanColor]
           }
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // Set up the add button and segmented control
        setupAddButton()
        setupSegmentedControl()
        
        CommentTableView.delegate = self
        CommentTableView.dataSource = self
        
        // Set up the Firestore collection reference
        ideasCollectionRef = Firestore.firestore().collection(ideas_ref)
    }
   
    
    override func viewWillAppear(_ animated: Bool) {
        // Set up the Firestore snapshot listener
    setListener()
    }
    
    // Set up the Firestore snapshot listener
    func setListener() {
        ideasListener = ideasCollectionRef.whereField(categories,isEqualTo: selectedCategory).order(by: addedate, descending: true).addSnapshotListener { (snapshot, error) in
               if let error = error {
                   debugPrint("An error occurred while fetching the records: \(error.localizedDescription)")
               } else {
                   self.ideas.removeAll()
                   guard let snap = snapshot else { return }
                   for document in snap.documents {
                    
                       let data = document.data()
                       let userName = data[username] as? String ?? "Misafir"
                       let ts = data[addedate] as? Timestamp ?? Timestamp()
                       let addedHistories = ts.dateValue()
                       let ideasText = data[ideas_text] as? String ?? ""
                       let  commentNumber = data[comments_number] as? Int ?? 0
                       let placeName = data[comments_place] as? String ?? ""
                       let documentId = document.documentID
                       
                       let newIdeas = Ideas(userName: userName, addedDate: addedHistories, ideasText: ideasText, commentNumbers: commentNumber,  commentPlace: placeName, documentId: documentId)
                       self.ideas.append(newIdeas)
                   }
                   self.CommentTableView.reloadData()
               }
           }
     }
  
    
    override func viewWillDisappear(_ animated: Bool) {
        // Remove the Firestore snapshot listener
        ideasListener.remove()
    }
    
    // Set up the segmented control
    private func setupSegmentedControl() {
            let segmentedControl = UISegmentedControl(items: ["Religion", "Park", "Museum", "Monument", "Texture"])
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
            segmentedControl.frame = CGRect(x: 20, y: 120, width: view.frame.width - 40, height: 30)
            
            view.addSubview(segmentedControl)
        }
    
    // Set up the "Add" button in the navigation bar
    private func setupAddButton() {
           let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
           navigationItem.rightBarButtonItem = addButton
       }
  
    // Handle the tap event on the "Add" button
    @objc private func addButtonTapped() {
        // Instantiate the "AddIdeaViewController" from the Main storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "AddIdeaViewController") as! AddIdeaViewController
        // Push the new view controller to the navigation stack for presentation
        navigationController?.pushViewController(viewController, animated: true)
      }
    
    // Handle the value change event of the segmented control
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        // Set the selected category based on the segmented control's selected segment index
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
        
        // Remove the previous listener and set a new listener for the ideas
        ideasListener.remove()
        setListener()
    }
}

// Implement the UITableViewDelegate and UITableViewDataSource methods for the table view
extension CommentListViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ideas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue a reusable cell with the identifier "commentListCell" and cast it as IdeasTableViewCell
        if let commentListCell = tableView.dequeueReusableCell(withIdentifier: "commentListCell", for: indexPath) as? IdeasTableViewCell {
            // Set the view of the IdeasTableViewCell using the corresponding idea from the ideas array
            commentListCell.setView(ideas: ideas[indexPath.row])
            return commentListCell
        } else {
            // Return a default UITableViewCell if the dequeueing or casting fails
            return UITableViewCell()
        }
    }
    
    // Return the height for each row in the table view
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
