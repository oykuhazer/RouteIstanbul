//
//  AllHistoriesViewController.swift
//  Route Istanbul
//
//  Created by Öykü Hazer Ekinci on 22.06.2023.
//

import UIKit
import Firebase
import FirebaseStorage

class AllHistoriesViewController: UIViewController{
  
    @IBOutlet weak var viewforTab: UIView!
    @IBOutlet weak var allHistoriesCollectionView: UICollectionView!
    @IBOutlet weak var allHistoriesSearchBar: UISearchBar!
    
    var historiesList = [Histories]()
    var filteredHistoriesList = [Histories]()
    var ref:DatabaseReference!
    var histories: Histories?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let oceanColor = UIColor(named: "ocean") {
               navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: oceanColor]
           }
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // Set the delegate and data source for the allHistoriesCollectionView and allHistoriesSearchBar
        
        allHistoriesCollectionView.delegate = self
        allHistoriesCollectionView.dataSource = self
        allHistoriesSearchBar.delegate = self

        // Customize the appearance of the search bar with the "ocean" color
        if let oceanColor = UIColor(named: "ocean") {
            allHistoriesSearchBar.barTintColor = oceanColor
            allHistoriesSearchBar.searchTextField.backgroundColor = UIColor.white
            allHistoriesSearchBar.searchTextField.textColor = UIColor.black
            
            // Get a reference to the Firebase database
            ref = Database.database().reference()
            
            // Customize the appearance of the tab bar
            designableTabBar2()
        }
        
        // Retrieve all histories from the database
        getAllHistories()
    }
    
    func getAllHistories() {
        
        // Query the "tarihler" node in the database
        let query = ref.child("tarihler")
        
        // Observe the value of the query
        query.observe(.value, with: { snapshot in
            if let incomingDataSet = snapshot.value as? [String:AnyObject] {
                self.historiesList.removeAll()
                
                // Loop through the retrieved data and create Histories objects
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
                        let histories = Histories(tarih_id: key, tarih_ad: histories_name, tarih_resim: histories_image, kategori_ad: categories_name, tarih_kisa: histories_shortInf, tarih_uzun: histories_longInf, tarih_enlem: histories_latitude, tarih_boylam: histories_longitude)
                        self.historiesList.append(histories)
                    }
                }
            }
            
            // Reload the collection view with the updated data
            DispatchQueue.main.async {
                self.allHistoriesCollectionView.reloadData()
            }
        })
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let index = sender as? Int
        // Pass the selected history to the HistoriesDetailViewController
        let destinationVC = segue.destination as! HistoriesDetailViewController
        destinationVC.histories = historiesList[index!]
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // Customize the appearance of the tab bar
    func designableTabBar2() {
        viewforTab.layer.cornerRadius = viewforTab.frame.size.height/2
        viewforTab.clipsToBounds = true
    }
    
    // Handle tab bar button clicks
    @IBAction func onClickTabBar2(_ sender: UIButton) {
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
   
    func filterHistoriesList(with keyword: String) {
        // Filter the historiesList based on the keyword
        filteredHistoriesList = historiesList.filter { ($0.tarih_ad ?? "").lowercased().hasPrefix(keyword.lowercased()) }
        // Reload the collection view with the filtered data
        allHistoriesCollectionView.reloadData()
    }
}

extension AllHistoriesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // Determine the number of items in the collection view based on the search bar text
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if allHistoriesSearchBar.text?.isEmpty ?? true {
            return historiesList.count
        } else {
            return filteredHistoriesList.count
        }
           }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let history: Histories
        if allHistoriesSearchBar.text?.isEmpty ?? true {
            history = historiesList[indexPath.row]
        } else {
            history = filteredHistoriesList[indexPath.row]
        }
        
        // Dequeue a reusable cell and configure it with the history data
        let allHistoriesCell = collectionView.dequeueReusableCell(withReuseIdentifier: "allHistoriesCell", for: indexPath) as! AllHistoriesCollectionViewCell
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imagesRef = storageRef.child("resimler")
        
        if let imageName = history.tarih_resim {
        let imageRef = imagesRef.child(imageName + ".png")
            
            // Download the image from Firebase Storage
            imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    print("Image download error: \(error.localizedDescription)")
                    return
                }

                guard let data = data else {
                    print("Failed to retrieve image data")
                    return
                }

                let image = UIImage(data: data)
                allHistoriesCell.historiesImageView.image = image
            }
        }

        allHistoriesCell.indexPath = indexPath
        allHistoriesCell.historiesNameLabel.text = history.tarih_ad

        return allHistoriesCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Handle the selection of a collection view cell
        let allHistoriesCell = collectionView.cellForItem(at: indexPath) as! AllHistoriesCollectionViewCell
        
        let selectedHistory: Histories
        if allHistoriesSearchBar.text?.isEmpty ?? true {
            selectedHistory = historiesList[indexPath.row]
        } else {
            selectedHistory = filteredHistoriesList[indexPath.row]
        }
        
        // Perform the segue to the HistoriesDetailViewController and pass the selected history
        if let index = historiesList.firstIndex(where: { $0.tarih_id == selectedHistory.tarih_id }) {
            self.performSegue(withIdentifier: "toDetailAllHistories", sender: index)
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Filter the histories list based on the search bar text
        filterHistoriesList(with: searchText)
      }
    }

