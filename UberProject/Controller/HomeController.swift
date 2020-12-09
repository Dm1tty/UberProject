//
//  HomeController.swift
//  UberProject
//
//  Created by Dzmitry Matsiulka on 12/9/20.
//

import UIKit
import FirebaseAuth
import MapKit

class HomeController: UIViewController{

    
    // MARK: Properties
    private let mapView = MKMapView()
    private let locationManager = CLLocationManager()
  
    private let inputActivationView = locationInputActivationView()
    

    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        checkIfUserIsLoggedIn()
        // Do any additional setup after loading the view.
        enableLocationServices()
    }
    
    func checkIfUserIsLoggedIn(){
        if Auth.auth().currentUser?.uid == nil{
            print("User is not logged in")
            DispatchQueue.main.async{
               let nav = UINavigationController(rootViewController: LoginController())
                self.present(nav, animated: false, completion: nil)
            }
        }
        else{
            configureUI()
        }
    }

    func singOut() {
        // call from any screen
        
        do {
            try Auth.auth().signOut()
            
            }
            catch{
                print("already logged out")
                }
        
        
    }
   
    // MARK: Helper Functions
    func configureMapView(){
        view.addSubview(mapView)
        mapView.frame = view.frame
        
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
    }
    
    func configureUI() {
      configureMapView()
        
        view.addSubview(inputActivationView)
        inputActivationView.centerX(inView: view)
        inputActivationView.setDimenstions(height: 50, width: view.frame.width-64)
        inputActivationView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
    }
}


extension HomeController: CLLocationManagerDelegate{
    func enableLocationServices(){
        locationManager.delegate = self
        
                switch locationManager.authorizationStatus {
                    case .authorizedAlways:
                        print("All good!")
                        locationManager.startUpdatingLocation()
                        locationManager.desiredAccuracy = kCLLocationAccuracyBest
                        break
                    case .authorizedWhenInUse:
                        locationManager.requestAlwaysAuthorization()
                    case .notDetermined , .denied , .restricted:
                        locationManager.requestWhenInUseAuthorization()
                        break
                    default:
                        break
                
            }
        }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse{
            locationManager.requestAlwaysAuthorization()
        }
    }
    }
