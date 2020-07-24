//
//  ViewController.swift
//  Project28
//
//  Created by DeNNiO   G on 23.10.2019.
//  Copyright © 2019 Donny G. All rights reserved.
//
import LocalAuthentication
import UIKit

class ViewController: UIViewController {

    @IBOutlet var secret: UITextView!
    
    var passwordIsSet = false
    var currentPassword: String?
    
    var passwordFromKeyChain: String?
    var typedPassword: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Challenge2
        let defaults = UserDefaults.standard
        let passCheck = defaults.object(forKey: "SavedPassword") as? Bool
        passwordIsSet = passCheck ?? false
        
        title = "Nothing to see here"
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
        //Challenge 1
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveSecretMessage))
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            secret.contentInset = .zero
        } else {
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        secret.scrollIndicatorInsets = secret.contentInset
        let selectedRange = secret.selectedRange
        secret.scrollRangeToVisible(selectedRange)
    }


    @IBAction func authenticateTapped(_ sender: Any) {
        
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself"
        
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self?.unlockSecretMessage()
                    } else {
                        let ac = UIAlertController(title: "Authentication failed", message: "You could not be verified, try again", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(ac, animated: true)
                    }
                }
            }
        } else {
            //Challenge 2
            if passwordIsSet {
                readPassword()
                let ac = UIAlertController(title: "Failed to unlock", message: "Please enter password", preferredStyle: .alert)
                ac.addTextField { (texField) in
                texField.placeholder = "Password"
                }
                ac.addAction(UIAlertAction(title: "Submit", style: .destructive, handler: { [weak ac, weak self] _ in
                guard let password = ac?.textFields?[0].text else { return }
                
                    if password == self?.passwordFromKeyChain{
                    self?.unlockSecretMessage()
                    }
                    }
                    ))
                    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                    present(ac, animated: true)
            }else{
                let ac = UIAlertController(title: "Failed to unlock", message: "Please set password", preferredStyle: .alert)
                    ac.addTextField { (texField) in
                    texField.placeholder = "Set password"
                    }
                    ac.addAction(UIAlertAction(title: "Save", style: .destructive, handler: { [weak ac, weak self] _ in
                    guard let password = ac?.textFields?[0].text else { return }
                        self?.savePasswordToKeyChain(pass: password)
                        self?.passwordIsSet = true
                        let defaults = UserDefaults.standard
                        defaults.set(self?.passwordIsSet, forKey: "SavedPassword")
                    }
                    ))
                ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                present(ac, animated: true)
            }
    }
    }
    
    func unlockSecretMessage() {
        secret.isHidden = false
        //Challenge 1
        self.navigationItem.leftBarButtonItem?.isEnabled = true
        title = "Secret stuff!"
        
        if let text = KeychainWrapper.standard.string(forKey: "SecretMessage") {
            secret.text = text
        }
    }
    
    @objc func saveSecretMessage() {
        guard secret.isHidden == false else { return }
        KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
        secret.resignFirstResponder()
        secret.isHidden = true
        title = "Nothing to see here"
    }
    func savePasswordToKeyChain(pass: String) {
        guard passwordIsSet == false else {return}
        KeychainWrapper.standard.set(pass, forKey: "CurrentPassword")
        print(pass)
    }
    
    func readPassword() {
        if let currentPassword = KeychainWrapper.standard.string(forKey: "CurrentPassword") {
            passwordFromKeyChain = currentPassword
        }
    }
    
  
}

