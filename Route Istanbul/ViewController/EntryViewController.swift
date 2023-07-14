//
//  EntryViewController.swift
//  Route Istanbul
//
//  Created by Öykü Hazer Ekinci on 21.06.2023.
//

import UIKit
import Firebase
import FirebaseStorage

class EntryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var viewforTab: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var upCollectionView: UICollectionView!
    @IBOutlet weak var bottomCollectionView: UICollectionView!
    
    var ref:DatabaseReference!
    var username: String?
    var historyList = [Histories]()
    var upPhotos = [UIImage(named: "1")!, UIImage(named: "2")!,  UIImage(named: "3")!, UIImage(named: "4")!, UIImage(named: "5")!, UIImage(named: "6")!]
    var timer : Timer?
    var currentCellIndex = 0
    var additionalView: UIView!
    
    override func viewDidLoad() {
    super.viewDidLoad()
        
        if let oceanColor = UIColor(named: "ocean") {
               navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: oceanColor]
           }
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // Database reference initialization
        ref = Database.database().reference()
        
        // Set the delegates for the collection views
            upCollectionView.delegate = self
            upCollectionView.dataSource = self
        
        // Set the number of pages in the page control
        pageControl.numberOfPages = upPhotos.count
        
        // Start the timer for auto-scrolling the collection view
        startTimer()
        
        // Configure the tab bar view
        designableTabBar()
           
        // Create and configure the welcome label
            let labelWelcome = UILabel()
            labelWelcome.text = "Welcome \(username ?? "")!"
            labelWelcome.textColor = UIColor(named: "ocean")
            labelWelcome.font = UIFont.boldSystemFont(ofSize: 24)
       
        // Apply initial translation to the welcome label
            labelWelcome.transform = CGAffineTransform(translationX: -view.bounds.width, y: 0)

        // Animate the welcome label using a spring animation
            UIView.animate(withDuration: 1, delay: 0.3, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0, options: [], animations: {
                labelWelcome.transform = CGAffineTransform.identity
            }, completion: nil)
        
        // Add the welcome label to the view and position it using Auto Layout
            labelWelcome.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(labelWelcome)
            
        // Function to animate the welcome label by continuously translating it back and forth
            func animateLabel() {
                UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
                    labelWelcome.transform = CGAffineTransform(translationX: 20, y: 0)
                }) { _ in
                    UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
                        labelWelcome.transform = CGAffineTransform(translationX: -20, y: 0)
                    }) { _ in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            animateLabel()
                        }
                    }
                }
            }

        // Start the label animation after a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                animateLabel()
            }

        // Create and configure the "Categories" button
            let buttonCategories = UIButton(type: .system)
            buttonCategories.setTitle("Categories", for: .normal)
            buttonCategories.setTitleColor(.white, for: .normal)
            buttonCategories.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            buttonCategories.layer.shadowColor = UIColor.black.cgColor
            buttonCategories.layer.shadowOpacity = 0.5
            buttonCategories.layer.shadowOffset = CGSize(width: 0, height: 2)
            buttonCategories.layer.shadowRadius = 4
            
        // Set the background color of the button
            if let oceanColor = UIColor(named: "ocean") {
                buttonCategories.backgroundColor = oceanColor
            }
            
        // Configure the appearance of the button
            buttonCategories.layer.cornerRadius = 25
            buttonCategories.clipsToBounds = false
            buttonCategories.addTarget(self, action: #selector(buttonCategoriesTapped), for: .touchUpInside)
            buttonCategories.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(buttonCategories)

        // Create and configure the "Favorite List" button
            let buttonFavoriteList = UIButton(type: .system)
            buttonFavoriteList.setTitle("Favorite List", for: .normal)
            buttonFavoriteList.setTitleColor(.white, for: .normal)
            buttonFavoriteList.layer.shadowColor = UIColor.black.cgColor
            buttonFavoriteList.layer.shadowOpacity = 0.5
            buttonFavoriteList.layer.shadowOffset = CGSize(width: 0, height: 2)
            buttonFavoriteList.layer.shadowRadius = 4
            buttonFavoriteList.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            
        // Set the background color of the button
            if let oceanColor = UIColor(named: "ocean") {
                buttonFavoriteList.backgroundColor = oceanColor
            }
            
        // Configure the appearance of the button
            buttonFavoriteList.layer.cornerRadius = 25
            buttonFavoriteList.clipsToBounds = false
            buttonFavoriteList.addTarget(self, action: #selector(buttonFavoriteListTapped), for: .touchUpInside)
            buttonFavoriteList.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(buttonFavoriteList)

        // Create and configure the "All Places" button
            let buttonAllPlaces = UIButton(type: .system)
            buttonAllPlaces.setTitle("All Places", for: .normal)
            buttonAllPlaces.setTitleColor(.white, for: .normal)
            buttonAllPlaces.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            buttonAllPlaces.layer.shadowColor = UIColor.black.cgColor
            buttonAllPlaces.layer.shadowOpacity = 0.5
            buttonAllPlaces.layer.shadowOffset = CGSize(width: 0, height: 2)
            buttonAllPlaces.layer.shadowRadius = 4
        
        // Set the background color of the button
            if let oceanColor = UIColor(named: "ocean") {
                buttonAllPlaces.backgroundColor = oceanColor
            }
         
        // Configure the appearance of the button
            buttonAllPlaces.layer.cornerRadius = 25
            buttonAllPlaces.clipsToBounds = false
            buttonAllPlaces.addTarget(self, action: #selector(buttonAllPlacesTapped), for: .touchUpInside)
            buttonAllPlaces.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(buttonAllPlaces)

        // Create and configure the title label
            let titleLabel = UILabel()
                   titleLabel.text = "Best destinations for your vacation"
                   titleLabel.textColor = UIColor(named: "ocean")
                   titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
            view.addSubview(titleLabel)
                   titleLabel.translatesAutoresizingMaskIntoConstraints = false
                   NSLayoutConstraint.activate([
                    titleLabel.topAnchor.constraint(equalTo: bottomCollectionView.topAnchor, constant: -25),
                                titleLabel.leadingAnchor.constraint(equalTo: bottomCollectionView.leadingAnchor, constant: 16),
                                titleLabel.trailingAnchor.constraint(equalTo: bottomCollectionView.trailingAnchor, constant: -16)
                   ])
            
            NSLayoutConstraint.activate([
                labelWelcome.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                labelWelcome.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80),
                
                buttonCategories.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                buttonCategories.topAnchor.constraint(equalTo: upCollectionView.bottomAnchor, constant: 80),
                buttonCategories.widthAnchor.constraint(equalToConstant: 160),
                buttonCategories.heightAnchor.constraint(equalToConstant: 50),
                
                buttonFavoriteList.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
                buttonFavoriteList.topAnchor.constraint(equalTo: upCollectionView.bottomAnchor, constant: 80),
                buttonFavoriteList.widthAnchor.constraint(equalToConstant: 180),
                buttonFavoriteList.heightAnchor.constraint(equalToConstant: 50),
                
                buttonAllPlaces.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                buttonAllPlaces.topAnchor.constraint(equalTo: buttonFavoriteList.bottomAnchor, constant: 18),
                buttonAllPlaces.widthAnchor.constraint(equalToConstant: 350),
                buttonAllPlaces.heightAnchor.constraint(equalToConstant: 50)
            ])
            historiesByHistoryName()
           }

        func historiesByHistoryName() {
            // List of history names to query for
            let historiesNameList = ["Hagia Sophia Mosque", "Sultanahmet Mosque", "Gulhane Park", "Great Camlica Choir", "Topkapi Palace Museum", "Galata Tower", "Cemberlitas", "Taksim Republic Monument", "Maiden's Tower", "Yedikule Fortress and Dungeons"]
            
            // Query the "tarihler" node in the database for each history name
            for historiesName in historiesNameList {
                let query = ref.child("tarihler").queryOrdered(byChild: "tarih_ad").queryEqual(toValue: historiesName)
                
                query.observe(.value, with: { snapshot in
                    if let incomingDataSet = snapshot.value as? [String: AnyObject] {
                        // Loop through the incoming data set and create history objects
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
                                // Create a Histories object and add it to the historyList
                                let histories = Histories(tarih_id: key, tarih_ad: histories_name, tarih_resim: histories_image, kategori_ad: categories_name, tarih_kisa: histories_shortInf, tarih_uzun: histories_longInf, tarih_enlem: histories_latitude, tarih_boylam: histories_longitude)
                                self.historyList.append(histories)
                            }
                        }
                    }
                    
                    // Reload the bottomCollectionView to reflect the updated data
                    DispatchQueue.main.async {
                        self.bottomCollectionView.reloadData()
                    }
                })
            }
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Prepare for segue and pass the selected history to the destination view controller
            let index = sender as? Int
            let destinationVC = segue.destination as! HistoriesDetailViewController
            destinationVC.histories = historyList[index!]
        }
        
      override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
        
        func designableTabBar() {
            // Configure the appearance of the viewforTab (tab bar)
            viewforTab.layer.cornerRadius = viewforTab.frame.size.height/2
            viewforTab.clipsToBounds = true
        }
        
    // Handle the tab bar button taps based on the tag value
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

    // Handle the buttonCategories tap by navigating to the CategoryViewController
    @objc func buttonCategoriesTapped() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let viewController = storyboard.instantiateViewController(withIdentifier: "CategoryViewController") as! CategoryViewController
    navigationController?.pushViewController(viewController, animated: true)
        }
    
    // Handle the buttonFavoriteList tap by navigating to the WishListViewController
    @objc func buttonFavoriteListTapped() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let viewController = storyboard.instantiateViewController(withIdentifier: "WishListViewController") as! WishListViewController
    navigationController?.pushViewController(viewController, animated: true)
        }
    
    // Handle the buttonAllPlaces tap by navigating to the AllHistoriesViewController
    @objc func buttonAllPlacesTapped() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let viewController = storyboard.instantiateViewController(withIdentifier: "AllHistoriesViewController") as! AllHistoriesViewController
    navigationController?.pushViewController(viewController, animated: true)
        }
    
    // Start a timer to automatically scroll the upCollectionView
    func startTimer() {
    timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(moveToNextIndex), userInfo: nil, repeats: true)
               }
          
    // Move to the next index in the upCollectionView
     @objc func moveToNextIndex() {
     if currentCellIndex < upPhotos.count - 1 {
     currentCellIndex += 1
       } else {
     currentCellIndex = 0
           }
         
         // Scroll to the next index in the upCollectionView
         upCollectionView.scrollToItem(at: IndexPath(item: currentCellIndex, section: 0), at: .centeredHorizontally, animated: true)
         // Update the current page in the pageControl
     pageControl.currentPage = currentCellIndex
               }
       
    // Return the number of items in the collection view
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     if collectionView == self.upCollectionView {
     return upPhotos.count
               } else if collectionView == self.bottomCollectionView {
                   return historyList.count
               }
               
               fatalError("Unexpected collection view")
           }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Configure the cells for the collection views
        if collectionView == self.upCollectionView {
            let entryUpCell = collectionView.dequeueReusableCell(withReuseIdentifier: "entryUpCell", for: indexPath) as! EntryUpCollectionViewCell
            entryUpCell.imageViewUp.image = upPhotos[indexPath.row]
            return entryUpCell
        } else if collectionView == self.bottomCollectionView {
            let histories = historyList[indexPath.row]
            
            let entryBottomCell = collectionView.dequeueReusableCell(withReuseIdentifier: "entryBottomCell", for: indexPath) as! EntryBottomCollectionViewCell
         
            // Download and set the image for the cell using Firebase Storage
            let storage = Storage.storage()
            let storageRef = storage.reference()
            let imagesRef = storageRef.child("resimler")
            
            if let imageName = histories.tarih_resim {
                let imageRef = imagesRef.child(imageName + ".png")
                
                imageRef.getData(maxSize: 2 * 1024 * 1024) { data, error in
                    if let error = error {
                        print("Image download error: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let data = data else {
                        print("Failed to retrieve image data")
                        return
                    }
                    
                    DispatchQueue.main.async {
                        let image = UIImage(data: data)
                        entryBottomCell.squareImageView.image = image
                    }
                }
            }
            
            // Set the label and return the cell
            entryBottomCell.indexPath = indexPath
            entryBottomCell.squareLabel.text = histories.tarih_ad
            return entryBottomCell
        }
        
        fatalError("Unexpected collection view")
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Handle the selection of a cell in the bottomCollectionView
        let entryBottomCell = collectionView.cellForItem(at: indexPath) as! EntryBottomCollectionViewCell
            self.performSegue(withIdentifier: "toDetay5", sender: indexPath.row)
    }
               func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                   
                   // Return the size of the items in the collection view
                 return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
               }
           }
