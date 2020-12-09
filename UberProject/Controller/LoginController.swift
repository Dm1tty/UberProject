//
//  LoginController.swift
//  UberProject
//
//  Created by Dzmitry Matsiulka on 12/6/20.
//

import UIKit
import FirebaseAuth


class LoginController : UIViewController{
    
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
    
    
    private let emailTextField : UITextField = {
        return UITextField().textField(withPlaceholder: "Email",
                                       isSecureTextEntry: false)
    }()
    
    private let passwordTextField : UITextField = {
        return UITextField().textField(withPlaceholder: "Password",
                                       isSecureTextEntry: true)
    }()
    
    private let loginButton : UIButton = {
        let loginButton = AuthButton(type: .system)
        loginButton.setTitle("Log In", for: .normal)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        loginButton.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
        return loginButton
    }()
    
    let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?   ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.mainBlueTint]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: Lifecycle:
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
       
    }
    
    // MARK: Action Handlers:

    @objc func handleShowSignUp(){
        let controller = SignUpViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func handleSignIn(){
        guard let email = emailTextField.text else { return}
        guard let password = passwordTextField.text else { return}
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            guard let controller = UIApplication.shared.keyWindow?.rootViewController as? HomeController else { return}
            controller.configureUI()
            self.dismiss(animated: false, completion: nil )
            
        }
    }

    
    // MARK: Helping Functions
    
    func configureUI(){
        configureNavigatorBar()
        
        view.backgroundColor = .backgroundColor
         
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor)
        titleLabel.centerX(inView: view)
        
        let stack = UIStackView(arrangedSubviews: [emailContrainerView,
                                                   passwordContainerView,
                                                   loginButton])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 24
        
        view.addSubview(stack)
        stack.anchor(top: titleLabel.bottomAnchor,
                     left: view.leftAnchor,
                     right: view.rightAnchor,
                     paddingTop: 40,
                     paddingLeft: 16,
                     paddingRight: 16)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.centerX(inView: view)
        dontHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, height: 32)
    }

    func configureNavigatorBar(){
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
}
