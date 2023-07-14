//
//  HistoriesDetailViewController.swift
//  Route Istanbul
//
//  Created by Öykü Hazer Ekinci on 23.06.2023.
//


import UIKit
import Firebase
import FirebaseStorage
import MapKit


class HistoriesDetailViewController: UIViewController, UIViewControllerTransitioningDelegate, UITextViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var viewforTab: UIView!
    
    @IBOutlet weak var historiesDetailImage: UIImageView!
    @IBOutlet weak var historiesDetailBackground: UIView!
    @IBOutlet weak var historiesDetailText: UITextView!
    @IBOutlet weak var historiesDetailName: UILabel!
    
    var histories: Histories?
    private var bottomSheetVC: UIViewController?
    private var datePicker: UIDatePicker!
    private var previousView: UIView?
    private var mapViewController: UIViewController!
    private var moreButton: UIButton?
    private var subMapButton: UIButton?
    private var subCommentButton: UIButton?
    private var isSubButtonsVisible = false
    private var mapView: MKMapView!
    private var locationPin: MKPointAnnotation?
    let mapImage = UIImage(named: "map")
    let commentImage = UIImage(named: "comment")
    let More = UIImage(named: "more")
   
    
    override func viewDidLoad() {
            super.viewDidLoad()
        
        if let oceanColor = UIColor(named: "ocean") {
               navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: oceanColor]
           }
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        previousView = view.subviews.first
        historiesDetailBackground.layer.cornerRadius = 12
        historiesDetailText.layer.cornerRadius = 12
        historiesDetailName.layer.cornerRadius = 12
        historiesDetailName.layer.masksToBounds = true
        addMoreButton()
        
        // Load the image from Firebase Storage
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imagesRef = storageRef.child("resimler")

        if let imageName = histories?.tarih_resim {
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
                    self.historiesDetailImage.image = UIImage(data: data)
                }
            }
        }

        // Set the text and name from the Histories object
        if let h = histories {
            historiesDetailName.text = h.tarih_ad
            historiesDetailText.text = h.tarih_kisa
        }
      
        designableTabBar()
    }
    
    // Add a button for showing/hiding sub-buttons
    private func addMoreButton() {
        moreButton = UIButton(type: .system)
        moreButton?.setImage(More, for: .normal)
        moreButton?.tintColor = .white
        moreButton?.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        moreButton?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(moreButton!)
        
        NSLayoutConstraint.activate([
            moreButton!.trailingAnchor.constraint(equalTo: historiesDetailImage.trailingAnchor, constant: -30),
            moreButton!.topAnchor.constraint(equalTo: historiesDetailImage.topAnchor, constant: 20),
            moreButton!.widthAnchor.constraint(equalToConstant: 40),
            moreButton!.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    // Show or hide the sub-buttons
    @objc private func moreButtonTapped() {
        if isSubButtonsVisible {
            hideSubButtons()
        } else {
            showSubButtons()
        }
    }

    private func showSubButtons() {
        let buttonHeight: CGFloat = 40
            let buttonWidth: CGFloat = 40
        let buttonMargin: CGFloat = 16
        
        // Add the sub-buttons for map and comments
        subMapButton = UIButton(type: .custom)
        subMapButton?.setImage(mapImage, for: .normal)
        subMapButton?.frame = CGRect(x: view.bounds.width - buttonWidth - buttonMargin, y: 160, width: buttonWidth, height: buttonHeight)
        subMapButton?.addTarget(self, action: #selector(subMapButtonTapped), for: .touchUpInside)
        view.addSubview(subMapButton!)

        subCommentButton = UIButton(type: .custom)
        subCommentButton?.setImage(commentImage, for: .normal)
        subCommentButton?.frame = CGRect(x: view.bounds.width - buttonWidth - buttonMargin, y: 210, width: buttonWidth, height: buttonHeight)
        subCommentButton?.addTarget(self, action: #selector(subCommentButtonTapped), for: .touchUpInside)
        view.addSubview(subCommentButton!)

        isSubButtonsVisible = true
    }

    private func hideSubButtons() {
        
        // Remove the sub-buttons from the view
        subMapButton?.removeFromSuperview()
        subMapButton = nil
        subCommentButton?.removeFromSuperview()
        subCommentButton = nil
        isSubButtonsVisible = false
    }
    
    

    @objc private func subMapButtonTapped() {
        
        // Handle the sub-map button tapped event
        guard let historiesName = historiesDetailName.text else {
            return
        }

        // Fetching the history data from the Firebase Realtime Database based on the given history name
        let historiesRef = Database.database().reference().child("tarihler").queryOrdered(byChild: "tarih_ad").queryEqual(toValue: historiesName)
        historiesRef.observeSingleEvent(of: .value) { [weak self] snapshot in
            
            // Check if the necessary data is available
            guard let self = self, let historiesData = snapshot.children.allObjects.first as? DataSnapshot else {
                return
            }
            
            // Extract latitude and longitude values from the retrieved history data
            if let historiesLatitude = historiesData.childSnapshot(forPath: "tarih_enlem").value as? Double,
               let historiesLongitude = historiesData.childSnapshot(forPath: "tarih_boylam").value as? Double {
                // Show the location on the map using the extracted coordinates
                self.showLocationOnMap(latitude: historiesLatitude, longitude: historiesLongitude)
            }
        }
    }

    // Handle the sub comment button tap event
    @objc private func subCommentButtonTapped() {
        // Instantiate the "AddIdeaViewController" from the Main storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "AddIdeaViewController") as! AddIdeaViewController
        // Set the text field value of the new view controller to the historiesDetailName text
        viewController.textFieldValue = historiesDetailName.text
        // Push the new view controller to the navigation stack for presentation
        navigationController?.pushViewController(viewController, animated: true)
    }
   
    // Show the location on the map using the provided latitude and longitude coordinates
    private func showLocationOnMap(latitude: Double, longitude: Double) {
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

        // Create and configure the map view
        mapView = MKMapView(frame: view.bounds)
        mapView.delegate = self
        mapView.mapType = .standard

        // Create a map pin annotation for the location
        locationPin = MKPointAnnotation()
        locationPin?.coordinate = coordinates

        // Set the location name as the title for the pin annotation
        if let locationName = historiesDetailName.text {
            locationPin?.title = locationName.uppercased()
        }

        // Add the pin annotation to the map view and set the region to display
        mapView.addAnnotation(locationPin!)
        mapView.setRegion(MKCoordinateRegion(center: coordinates, latitudinalMeters: 1000, longitudinalMeters: 1000), animated: true)

        // Add the map view to the current view and bring it to the front
        view.addSubview(mapView)
        view.bringSubviewToFront(mapView)
    }
  
    // Zoom in the map view
    func zoomIn() {
        guard let mapView = mapViewController.view.subviews.first as? MKMapView else {
            return
        }

        var region = mapView.region
        region.span.latitudeDelta /= 2
        region.span.longitudeDelta /= 2

        mapView.setRegion(region, animated: true)
    }

    // Zoom out the map view
    func zoomOut() {
        guard let mapView = mapViewController.view.subviews.first as? MKMapView else {
            return
        }

        var region = mapView.region
        region.span.latitudeDelta *= 2
        region.span.longitudeDelta *= 2

        mapView.setRegion(region, animated: true)
    }
    
    // Handle the detail information button tap event
    @IBAction func detailInfButton(_ sender: Any) {
        // Configure the bottom sheet view controller
        configureSheet()
    }
    
    // Configure the bottom sheet view controller to display detailed information
    private func configureSheet() {
        let vc = DetailInfViewController()
            vc.tarih_ad = historiesDetailName.text
            if let historiesName = historiesDetailName.text {
                let historiesRef = Database.database().reference().child("tarihler").queryOrdered(byChild: "tarih_ad").queryEqual(toValue: historiesName)
                historiesRef.observeSingleEvent(of: .value) { snapshot in
                    // Extract the long information from the retrieved history data
                    if let historiesData = snapshot.children.allObjects.first as? DataSnapshot,
                       let historiesLongInf = historiesData.childSnapshot(forPath: "tarih_uzun").value as? String {
                        vc.tarih_uzun = historiesLongInf
                    }
                    
                    // Set the configured bottom sheet view controller
                    self.bottomSheetVC = vc

                    // Create and configure a navigation controller to present the bottom sheet
                    let navVC = UINavigationController(rootViewController: vc)
                    navVC.isModalInPresentation = true

                    // Configure the presentation style and appearance of the bottom sheet
                    if let sheet = navVC.sheetPresentationController {
                        sheet.preferredCornerRadius = 30
                        sheet.detents = [.custom(resolver: { context in
                            0.4 * context.maximumDetentValue
                        }), .large()]
                        sheet.largestUndimmedDetentIdentifier = .large
                    }

                    // Present the bottom sheet view controller
                    self.navigationController?.present(navVC, animated: true)
                }
            }
    }
    
    // Set the preferred status bar style to light content
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // Configure the design of the tab bar view
    func designableTabBar() {
        viewforTab.layer.cornerRadius = viewforTab.frame.size.height/2
        viewforTab.clipsToBounds = true
    }
    
    // Handle the click event of the tab bar buttons
    @IBAction func onClickTabBar5(_ sender: UIButton) {
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
   
// Implement the MKMapViewDelegate methods for the map view
extension HistoriesDetailViewController: MKMapViewDelegate {

    // Customize the view for the map annotations
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Check if the annotation is of type MKPointAnnotation
        guard annotation is MKPointAnnotation else { return nil }

        let identifier = "PinAnnotationView"
        // Try to reuse an existing annotation view if available
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView

        if annotationView == nil {
            // Create a new annotation view if none is available for reuse
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            // Reuse the existing annotation view and update its annotation
            annotationView?.annotation = annotation
        }

        return annotationView
    }

    // Handle the tap event on the callout accessory control button
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            // Check if the tapped annotation is an MKPointAnnotation
            if let locationPin = view.annotation as? MKPointAnnotation {
                // Create a placemark for the annotation's coordinate
                let placemark = MKPlacemark(coordinate: locationPin.coordinate)
                // Create an MKMapItem with the placemark and set the name as the title
                let mapItem = MKMapItem(placemark: placemark)
                mapItem.name = locationPin.title

                // Open the Maps app with the driving directions to the location
                mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
            }
        }
    }

    }
