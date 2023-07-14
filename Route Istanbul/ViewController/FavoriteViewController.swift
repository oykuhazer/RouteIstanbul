//
//  FavoriteViewController.swift
//  Route Istanbul
//
//  Created by Öykü Hazer Ekinci on 24.06.2023.
//

import UIKit
import Firebase
import FirebaseFirestore

class FavoriteViewController: UIViewController {

  
    @IBOutlet weak var favoriteTableView: UITableView!
    
    var favoriteList = [Int: Bool]()
    var tempList = [Int]()
    var historiesList = [Histories]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let oceanColor = UIColor(named: "ocean") {
               navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: oceanColor]
           }
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        favoriteTableView.delegate = self
        favoriteTableView.dataSource = self
        
        // Loop through the historiesList to find the indices of favorite histories
        for i in 0..<historiesList.count {
                  if favoriteList[i] == true {
                      tempList.append(i)
                  }
              }
        
        // Reload the table view to display the favorite histories
        favoriteTableView.reloadData()
          }
      }

extension FavoriteViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows based on the number of favorite histories
        return tempList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let favCell = favoriteTableView.dequeueReusableCell(withIdentifier: "favCell", for: indexPath)
        
        // Configure the cell with the favorite history's name
        favCell.textLabel?.text = historiesList[tempList[indexPath.row]].tarih_ad
        favCell.textLabel?.textColor = .white
        favCell.textLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        favCell.textLabel?.textAlignment = .center
           
           return favCell
           }
    
    // Set the height for each row in the table view
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
              return 85
          }
      }
