//
//  SignUpController.swift
//  UberProject
//
//  Created by Dzmitry Matsiulka on 12/7/20.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController{

    // MARK: Properties
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Uber"
        label.textColor = UIColor(white: 1, alpha: 0.8)
        label.font = UIFont(name: "Avenir-Light", size: 36)
        return label
    }()
    
    private lazy var emailContrainerView: UIView = {
        let view = UIView().inputViewContainer(image: #imageLiteral(resourceName: "ic_mail_outline_white_2x"), textField: emailTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    private lazy var passwordContainerView: UIView = {
        let view = UIView().inputViewContainer(image: #imageLiteral(resourceName: "ic_lock_outline_white_2x"), textField: passwordTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    private lazy var fullNameContainerView: UIView = {
        let view = UIView().inputViewContainer(image: #imageLiteral(resourceName: "ic_person_outline_white_2x"), textField: fullNameTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    private lazy var accountTypeContainerView: UIView = {
        let view = UIView().inputViewContainer(image: #imageLiteral(resourceName: "ic_account_box_white_2x"), segmentedControl: accountTypeSegmentedControl)
        view.heightAnchor.constraint(equalToConstant: 80).isActive = true
        return view
    }()
    
    
    private let emailTextField : UITextField = {
        return UITextField().textField(withPlaceholder: "Email",
                                       isSecureTextEntry: false)
    }()
    
    private let passwordTextField : UITextField = {
        return UITextField().textField(withPlaceholder: "Password",
                                       isSecureTextEntry: true)
    }()
    private let fullNameTextField : UITextField = {
        return UITextField().textField(withPlaceholder: "Full Name",
                                       isSecureTextEntry: false)
    }()
    private let accountTypeSegmentedControl: UISegmentedControl = {
        let segmentedController = UISegmentedControl(items: ["Rider", "Driver"])
        segmentedController.backgroundColor = .backgroundColor
        segmentedController.tintColor = UIColor(white: 1, alpha: 0.87)
        
        segmentedController.selectedSegmentIndex = 0
        return segmentedController
    }()
    
    private let signUpButton : UIButton = {
        let signUpButton = AuthButton(type: .system)
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        signUpButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        
        return signUpButton
    }()
    
    let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?   ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Log In", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.mainBlueTint]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        button.addTarget(self, action: #selector(handleLogIn), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
       
    }
    func configureUI(){
        
        view.backgroundColor = .backgroundColor
         
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor)
        titleLabel.centerX(inView: view)
        
        let stack = UIStackView(arrangedSubviews: [emailContrainerView,
                                                   fullNameContainerView,
                                                   passwordContainerView,
                                                   accountTypeContainerView,
                                                   signUpButton])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 24
        
        view.addSubview(stack)
        stack.anchor(top: titleLabel.bottomAnchor,
                     left: view.leftAnchor,
                     right: view.rightAnchor,
                     paddingTop: 40,
                     paddingLeft: 16,
                     paddingRight: 16)
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.centerX(inView: view)
        alreadyHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, height: 32)
        
    }
    
   
    
    // MARK: Selectors:
    @objc func handleLogIn(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSignUp(){
        guard let email = emailTextField.text else { return}
        guard let password = passwordTextField.text else { return}
        guard let fullName = fullNameTextField.text else { return}
        let accountTypeIndex = String(accountTypeSegmentedControl.selectedSegmentIndex)
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error{
                print("Error was thrown: " + error.localizedDescription)
                return
            }
            guard let uid = result?.user.uid else {return}
            
            let values = ["email": email,
                          "fullName":fullName,
                          "accountType":accountTypeIndex]
            
            Database.database().reference().child("users").child(uid).updateChildValues(values) { (error, ref) in
                if error != nil{
                    print("Data wasn't saved:" + error!.localizedDescription)
                }
                else{
                    print("Data was saved!")
                    guard let controller = UIApplication.shared.keyWindow?.rootViewController as? HomeController else { return}
                    controller.configureUI()
                    self.dismiss(animated: false, completion: nil )
                }
            }
        }
    }
}
