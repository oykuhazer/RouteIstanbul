//
//  WishListViewController.swift
//  Route Istanbul
//
//  Created by Öykü Hazer Ekinci on 24.06.2023.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class WishListViewController: UIViewController {

    @IBOutlet weak var viewforTab: UIView!
    @IBOutlet weak var WishListTableView: UITableView!
    
    let db = Firestore.firestore()
    var historiesList = [Histories]()
    var ref:DatabaseReference!
    var history: Histories?
    var favoriteCricker = [Int:Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let oceanColor = UIColor(named: "ocean") {
               navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: oceanColor]
           }
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        WishListTableView.delegate = self
        WishListTableView.dataSource = self
        WishListTableView.separatorStyle = .none
        WishListTableView.showsVerticalScrollIndicator = false

        // Add a label to describe the purpose of the wishlist
        let labelDescribe = UILabel()
        labelDescribe.text = "It represents a special area where you can add your favorite places. Create a list of your favorite historical sites and share them here."
        labelDescribe.font = UIFont.boldSystemFont(ofSize: 17)
        
        if let oceanColor = UIColor(named: "ocean") {
            labelDescribe.textColor = oceanColor
        }
        
        labelDescribe.font = UIFont.boldSystemFont(ofSize: 17)
        labelDescribe.textAlignment = .justified
        labelDescribe.numberOfLines = 0
        view.addSubview(labelDescribe)
        
        labelDescribe.translatesAutoresizingMaskIntoConstraints = false
        labelDescribe.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        labelDescribe.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        labelDescribe.topAnchor.constraint(equalTo: view.topAnchor, constant: 110).isActive = true
        
        // Set up database reference and designable tab bar
        ref = Database.database().reference()
        designableTabBar()
        
        // Fetch all histories and check favorite list
        getAllHistories()
        checkFavoriteList()
    }
    
    func checkFavoriteList() {
        // Check the favorite list for the current user
        guard let email = Auth.auth().currentUser?.email else {
            print("User email not found")
            return
        }

        let documentRef = db.collection("users").whereField("email", isEqualTo: email).limit(to: 1)

        documentRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching user document: \(error.localizedDescription)")
                return
            }

            // Extract the favoriteCricker data from the user document
            guard let document = querySnapshot?.documents.first else {
                print("User document not found")
                return
            }

            // Convert the favoriteCricker data to the expected format [Int: Bool]
            guard let favoriteCrickerData = document.data()["favoriteCricker"] as? [String: Bool] else {
                print("FavoriteCricker data not found")
                return
            }

            var updatedFavoriteCricker = [Int: Bool]()
            for (key, value) in favoriteCrickerData {
                if let index = Int(key) {
                    updatedFavoriteCricker[index] = value
                }
            }
            
            self.favoriteCricker = updatedFavoriteCricker

            DispatchQueue.main.async {
                self.WishListTableView.reloadData()
            }
        }
    }

    @IBAction func sortFavoriteButton(_ sender: Any) {
        // Update the favoriteCricker data in the user document
        guard let email = Auth.auth().currentUser?.email else {
               print("User email not found")
               return
           }

           let documentRef = db.collection("users").whereField("email", isEqualTo: email).limit(to: 1)

           documentRef.getDocuments { (querySnapshot, error) in
               if let error = error {
                   print("Error fetching user document: \(error.localizedDescription)")
                   return
               }

               guard let document = querySnapshot?.documents.first else {
                   print("User document not found")
                   return
               }

               // Convert the favoriteCricker data to the expected format [String: Bool]
               var updatedFavoriteCricker: [String: Bool] = [:]

               for (key, value) in self.favoriteCricker {
                   updatedFavoriteCricker[key.description] = value
               }

               // Update the favoriteCricker data in the user document
               document.reference.updateData(["favoriteCricker": updatedFavoriteCricker]) { error in
                   if let error = error {
                       print("Error updating favoriteCricker: \(error.localizedDescription)")
                   } else {
                       print("FavoriteCricker updated successfully")

                       // Navigate to the FavoriteViewController and pass the necessary data
                       let favoriteHome = self.storyboard?.instantiateViewController(withIdentifier: "favoritehome") as! FavoriteViewController
                       favoriteHome.favoriteList = self.favoriteCricker
                       favoriteHome.historiesList = self.historiesList
                       self.navigationController?.pushViewController(favoriteHome, animated: true)
                   }
               }
           }
    }
    
    private func blankfavoriteCricker() {
        // Initialize the favoriteCricker dictionary with false values for all indices
        for i in 0...historiesList.count {
            favoriteCricker[i] = false
        }
    }
   
    func getAllHistories() {
        // Fetch all histories from the "tarihler" node in the database
        let query = ref.child("tarihler")
        query.observe(.value, with: { snapshot in
            if let incomingDataSet = snapshot.value as? [String:AnyObject] {
                self.historiesList.removeAll()
                // Iterate through each history in the dataset
                for incomingRowData in incomingDataSet {
                    if let dict = incomingRowData.value as? NSDictionary {
                        let key = incomingRowData.key
                        let histories_name = dict["tarih_ad"] as? String ?? ""
                        let histories_image = dict["tarih_resim"] as? String ?? ""
                        let categories_name = dict["kategori_ad"] as? String ?? ""
                        let histories_shortInf = dict["tarih_kisa"] as? String ?? ""
                        let histories_longInf = dict["tarih_uzun"] as? String ?? ""
            let histories_latitude = dict["tarih_enlem"] as? Double ?? 0.0
            let histories_longitude = dict["tarih_boylam"] as? Double ?? 0.0
                        
                        // Create a Histories object with the fetched data
                        let histories = Histories(tarih_id: key, tarih_ad: histories_name, tarih_resim: histories_image, kategori_ad: categories_name, tarih_kisa: histories_shortInf, tarih_uzun: histories_longInf, tarih_enlem: histories_latitude, tarih_boylam: histories_longitude)
                        
                        // Add the history to the historiesList array
                        self.historiesList.append(histories)
                    }
                }
            }
            DispatchQueue.main.async {
                self.WishListTableView.reloadData()
            }
        })
    }
    
  override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func designableTabBar() {
        // Customize the design of the tab bar
        viewforTab.layer.cornerRadius = viewforTab.frame.size.height/2
        viewforTab.clipsToBounds = true
    }
    
    // Handle tab bar button clicks
    @IBAction func onClickTabBar4(_ sender: UIButton) {
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
          
extension WishListViewController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows based on the number of histories in the list
            return historiesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        history = historiesList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "wishCell", for: indexPath) as! WishListTableViewCell
        
        // Configure the cell with the history data
        if favoriteCricker[indexPath.row] == true {
            // If the history is marked as a favorite, display a filled heart icon
            cell.wishImage.image = UIImage(named: "filledheart")
            cell.wishLabel.text  = history?.tarih_ad
        } else {
            // If the history is not marked as a favorite, display an empty heart icon
            cell.wishImage.image = UIImage(named: "heart")
            cell.wishLabel.text  = history?.tarih_ad
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle the selection of a row in the table view
        let cell = WishListTableView.cellForRow(at: indexPath) as! WishListTableViewCell
        cell.wishImage.image = UIImage(named: "filledheart")
        favoriteCricker[indexPath.row] = true
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // Handle the deselection of a row in the table view
        let cell = WishListTableView.cellForRow(at: indexPath) as! WishListTableViewCell
        cell.wishImage.image = UIImage(named: "heart")
        favoriteCricker[indexPath.row] = false
    }
  
    // Set the height for each row in the table view
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
              return 85
          }
       }
