//
//  HistoriesByCategories.swift
//  Route Istanbul
//
//  Created by Öykü Hazer Ekinci on 22.06.2023.
//

import UIKit
import Firebase
import FirebaseStorage

class HistoriesByCategories: UIViewController {

    @IBOutlet weak var historiesCollectionView: UICollectionView!
    @IBOutlet weak var historiesSearchBar: UISearchBar!
    
    var historiesList = [Histories]()
    var filteredHistoriesList = [Histories]()
    var categories:Categories?
    var ref:DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let oceanColor = UIColor(named: "ocean") {
               navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: oceanColor]
           }
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
    
        ref = Database.database().reference()
        
        historiesCollectionView.delegate = self
        historiesCollectionView.dataSource = self
        historiesSearchBar.delegate = self
        
        // Set the title of the navigation item to the category name
        if let c = categories{
            navigationItem.title = c.kategori_ad
            historiesByCategoriesName(kategori_ad:c.kategori_ad!)
        }
        
        // Customize the appearance of the search bar
        if let oceanColor = UIColor(named: "ocean") {
            historiesSearchBar.barTintColor = oceanColor
            historiesSearchBar.searchTextField.backgroundColor = UIColor.white
            historiesSearchBar.searchTextField.textColor = UIColor.black
               }
           }
    
    // Fetch histories by category name from the database
    func historiesByCategoriesName(kategori_ad:String){
        let query = ref.child("tarihler").queryOrdered(byChild: "kategori_ad").queryEqual(toValue: kategori_ad)
        query.observe(.value, with: {snapshot in
            if let incomingDataSet = snapshot.value as? [String:AnyObject]{
                self.historiesList.removeAll()
                for incomingRowData in incomingDataSet {
                    if let dict = incomingRowData.value as? NSDictionary{
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
            DispatchQueue.main.async {
                self.historiesCollectionView.reloadData()
            }
        })
    }
    
    // Prepare for segue and pass the selected history object to the destination view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let index = sender as? Int
        let destinationVC = segue.destination as! HistoriesDetailViewController
        destinationVC.histories = historiesList[index!]
    }
    
    // Filter the histories list based on the search text entered in the search bar
    func filteredHistoriesList(with keyword: String) {
        filteredHistoriesList = historiesList.filter { ($0.tarih_ad ?? "").lowercased().hasPrefix(keyword.lowercased()) }
        historiesCollectionView.reloadData()
    }
}


extension HistoriesByCategories: UICollectionViewDelegate, UICollectionViewDataSource,UISearchBarDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // Return the number of items based on whether the search bar is empty or not
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           if historiesSearchBar.text?.isEmpty ?? true {
               return historiesList.count
           } else {
               return filteredHistoriesList.count
           }
       }
       
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let history: Histories
        if historiesSearchBar.text?.isEmpty ?? true {
            // Get the history object from the appropriate list based on the search bar text
            history = historiesList[indexPath.row]
        } else {
            history = filteredHistoriesList[indexPath.row]
        }
        
        // Dequeue a reusable cell and cast it to HistoriesByCategoryCollectionViewCell
        let historiesByCategoriesCell = collectionView.dequeueReusableCell(withReuseIdentifier: "historiesByCategoriesCell", for: indexPath) as! HistoriesByCategoryCollectionViewCell

        // Fetch the image from Firebase Storage using the image name
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imagesRef = storageRef.child("resimler")

        if let imageName = history.tarih_resim {
            let imageRef = imagesRef.child(imageName + ".png")

            // Download the image data
            imageRef.getData(maxSize: 2 * 1024 * 1024) { data, error in
                if let error = error {
                    print("Image download error: \(error.localizedDescription)")
                    return
                }

                guard let data = data else {
                    print("Failed to fetch image data")
                    return
                }

                let image = UIImage(data: data)
                
                // Set the fetched image to the image view in the cell
                historiesByCategoriesCell.historiesImageView.image = image
            }
        }

        // Set the index path and history name to the cell
        historiesByCategoriesCell.indexPath = indexPath
        historiesByCategoriesCell.historiesNameLabel.text = history.tarih_ad

        return historiesByCategoriesCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let historiesByCategoriesCell = historiesCollectionView.cellForItem(at: indexPath) as! HistoriesByCategoryCollectionViewCell
        
        let selectedHistory: Histories
        if historiesSearchBar.text?.isEmpty ?? true {
            
            // Get the selected history from the appropriate list based on the search bar text
            selectedHistory = historiesList[indexPath.row]
        } else {
            selectedHistory = filteredHistoriesList[indexPath.row]
        }
        
        // Perform segue to the detail view controller with the selected history index
        if let index = historiesList.firstIndex(where: { $0.tarih_id == selectedHistory.tarih_id }) {
            self.performSegue(withIdentifier: "toDetailHistoriesByCategories", sender: index)
        }
    }

    // Filter the histories list based on the search text entered
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredHistoriesList(with: searchText)
      }
    }
