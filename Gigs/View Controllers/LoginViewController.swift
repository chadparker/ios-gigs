//
//  LoginViewController.swift
//  Gigs
//
//  Created by Chad Parker on 3/17/20.
//  Copyright © 2020 Chad Parker. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case logIn
}

class LoginViewController: UIViewController {
    
    var gigController: GigController?
    var loginType: LoginType = .signUp

    @IBOutlet weak var loginTypeSegmentControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        signUpInButton.backgroundColor = UIColor(hue: 190/360, saturation: 70/100, brightness: 80/100, alpha: 1.0)
        signUpInButton.tintColor = .white
        signUpInButton.layer.cornerRadius = 8.0
    }
    
    @IBAction func loginTypeSegmentNewValue(_ sender: Any) {
        if loginTypeSegmentControl.selectedSegmentIndex == 0 {
            loginType = .signUp
            signUpInButton.titleLabel?.text = "Sign Up"
        } else {
            loginType = .logIn
            signUpInButton.titleLabel?.text = "Log In"
        }
    }
    
    @IBAction func signUpInButtonPressed(_ sender: Any) {
        guard
            let gigController = gigController,
            let username = usernameTextField.text,
            let password = passwordTextField.text,
            !username.isEmpty,
            !password.isEmpty else { return }
        
        let user = User(username: username, password: password)
        
        switch loginType {
        case .signUp:
            gigController.signUp(with: user, completion: { error in
                guard error == nil else {
                    print("Error signing up: \(error!)")
                    return
                }
                
                self.showAlert(title: "Sign Up Successful", message: "Now please log in.") {
                    self.loginType = .logIn
                    self.loginTypeSegmentControl.selectedSegmentIndex = 1
                    self.signUpInButton.setTitle("Log In", for: .normal)
                }
            })
        case .logIn:
            gigController.logIn(with: user, completion: { error in
                guard error == nil else {
                    print("Error loggin in: \(error!)")
                    self.showAlert(title: "Error logging in", message: "Check username and password") {}
                    return
                }
                
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
    }
    
    private func showAlert(title: String, message: String, completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(
                UIAlertAction(title: "OK", style: .default, handler: nil)
            )
            self.present(alertController, animated: true) {
                completion()
            }
        }
    }
}
