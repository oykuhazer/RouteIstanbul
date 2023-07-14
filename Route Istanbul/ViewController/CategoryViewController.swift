//
//  CategoryViewController.swift
//  Route Istanbul
//
//  Created by Öykü Hazer Ekinci on 22.06.2023.
//

import UIKit
import Firebase

class CategoryViewController: UIViewController {
    
    @IBOutlet weak var viewforTab: UIView!
    @IBOutlet weak var categoriesTableView: UITableView!
    
    var categoriesList = [Categories]()
    var ref:DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let oceanColor = UIColor(named: "ocean") {
               navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: oceanColor]
           }
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // Set the delegate and data source for the categoriesTableView
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
        
        // Customize the appearance of the categoriesTableView
        categoriesTableView.separatorStyle = .none
        categoriesTableView.showsVerticalScrollIndicator = false
        
        // Get a reference to the Firebase database
        ref = Database.database().reference()
        
        // Retrieve all categories from the database
        getAllOfCategories()
        
        // Customize the appearance of the tab bar
        designableTabBar()
        
        // Create and configure a label for describing the categories
        let labelDescribe = UILabel()
        labelDescribe.text = "Witness the enchanting history of Istanbul! Experience unforgettable moments with the diverse venues in different categories."
        
        // Set the text color to "ocean" color if available
        if let oceanColor = UIColor(named: "ocean") {
            labelDescribe.textColor = oceanColor
        }
        
        // Create and configure the label
        labelDescribe.font = UIFont.boldSystemFont(ofSize: 20)
        labelDescribe.textAlignment = .justified
        labelDescribe.numberOfLines = 0
        view.addSubview(labelDescribe)
        
        labelDescribe.translatesAutoresizingMaskIntoConstraints = false
        labelDescribe.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        labelDescribe.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        labelDescribe.topAnchor.constraint(equalTo: view.topAnchor, constant: 130).isActive = true
    }
    
    func getAllOfCategories() {
        // Retrieve all categories from the database
        ref.child("kategoriler").observe(.value, with: { snapshot in
            if let incomingDataSet = snapshot.value as? [String:AnyObject] {
                self.categoriesList.removeAll()
                // Loop through the retrieved data and create Categories objects
                for incomingRowData in incomingDataSet {
                    if let dict = incomingRowData.value as? NSDictionary {
                        let key = incomingRowData.key
                        let categories_name = dict["kategori_ad"] as? String ?? ""
                        let categories = Categories(kategori_id: key, kategori_ad: categories_name)
                        self.categoriesList.append(categories)
                    }
                }
            }
            
            // Reload the table view with the updated data
            DispatchQueue.main.async {
                self.categoriesTableView.reloadData()
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let index = sender as? Int
        
        // Pass the selected category to the HistoriesByCategories view controller
        let destinationVC = segue.destination as! HistoriesByCategories
        destinationVC.categories = categoriesList[index!]
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // Customize the appearance of the tab bar
    func designableTabBar() {
        viewforTab.layer.cornerRadius = viewforTab.frame.size.height/2
        viewforTab.clipsToBounds = true
    }
    
    // Handle tab bar button clicks
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

extension CategoryViewController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of categories
        return categoriesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let categories = categoriesList[indexPath.row]
        
        // Configure the categories table view cell
        let categoriesCell = tableView.dequeueReusableCell(withIdentifier: "categoriesCell", for: indexPath) as! CategoriesTableViewCell
        categoriesCell.labelCategoriesName.text = categories.kategori_ad
    
          var imageCategoriesName = ""
          
        // Set the image name based on the category name
          switch categories.kategori_ad {
          case "Religion":
              imageCategoriesName = "believe"
          case "Museums":
              imageCategoriesName = "museum"
          case "Monuments and Statues":
              imageCategoriesName = "monument"
          case "Parks and Gardens":
              imageCategoriesName = "garden"
          case "City Texture":
              imageCategoriesName = "city"
          default:
              break
          }
          
        // Set the image for the category
        categoriesCell.categoriesImage.image = UIImage(named: imageCategoriesName)
          return categoriesCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle the selection of a category cell
        self.performSegue(withIdentifier: "toHistoriesByCategories", sender: indexPath.row)
    }
   
 func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     // Return the height of the category cell
           return 85
       }
  }
    
