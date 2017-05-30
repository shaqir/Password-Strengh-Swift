//
//  ViewController.swift
//  Password-Strengh-Checker
//
//  Created by Sakir on 30/05/17.
//  Copyright © 2017 Sakir. All rights reserved.
//

import UIKit
import AVFoundation

struct PasswordImage
{
    static let weak     : String = "password-weak"
    static let average  : String = "password-average"
    static let strong   : String = "password-strong"
}

class ViewController: UIViewController {

    @IBOutlet weak var txtPassword      : UITextField!
    @IBOutlet weak var lblStatus        : UILabel!
    @IBOutlet weak var img              : UIImageView!
    
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        setup_UI()
        
    }
    
    func setup_UI(){
    
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapButton(sender:)))
        
        gestureRecognizer.numberOfTapsRequired = 1
        
        self.view.addGestureRecognizer(gestureRecognizer)
        
        lblStatus.text = ""
        txtPassword.delegate = self
        
        txtPassword.layer.cornerRadius = txtPassword.frame.size.height/2.0
        txtPassword.layer.masksToBounds = true
        
        if let placeholderLabel = txtPassword.value(forKey: "_placeholderLabel") as? UILabel
        {
            if placeholderLabel.textColor == placeholderLabel.textColor {
                placeholderLabel.text = "Password"
                placeholderLabel.textColor =  UIColor.white
            }
        }
        
        txtPassword.rightViewMode = UITextFieldViewMode.always
        let imageView1 = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView1.contentMode = .left
        imageView1.contentScaleFactor = 0.5
        let image1 = UIImage(named: "password_img.png")
        imageView1.image = image1
        txtPassword.rightView = imageView1
        
        
    }
    
    func tapButton(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func callMyMethod(Str: String) {
        
         print("str:",Str)
        
        let stengthValue : PasswordStrength = PasswordStrength.of(password: Str)
        
        switch stengthValue {
            
        case .none:
            lblStatus.text   = "None"
            img.image = UIImage(named: "")
        case .low:
            lblStatus.text   = "Weak"
            img.image = UIImage(named: PasswordImage.weak)
        case .medium:
            lblStatus.text   = "Average"
            img.image = UIImage(named: PasswordImage.average)
        default:
            lblStatus.text   = "Strong"
            img.image = UIImage(named: PasswordImage.strong)
        }
    }

}

extension ViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        callMyMethod(Str: txtAfterUpdate)
        
        return true
    }
    
}

enum PasswordStrength {
    
    case none, low, medium, high
    
    static func of(password: String) -> PasswordStrength {
        
        let scere = scereOf(password: password)
        
        switch(scere) {
        
        case 0: return .none
        case 1...2: return .low
        case 3...4: return .medium
        default: return .high
        
        }
    }
    
    static func scereOf(password: String) -> Int {
        
        var score = 0
        
        // At least one lowercase letter
        if test(password, matches: "[a-züöäß]") {
            score += 1
        }
        
        // At least one uppercase
        if test(password, matches: "[A-ZÜÖÄß]") {
            score += 1
        }
        
        // At least one number
        if test(password, matches: "[0-9]") {
            score += 1
        }
        
        // At least one special character
        if test(password, matches: "[^A-Za-z0-9üöäÜÖÄß]") {
            score += 1
        }
        
        // A length of at least 8 characters
        
        if password.characters.count >= 16 {
            score += 2
            
        } else if password.characters.count >= 8 {
            score += 1
        }
        
        return score
    }
    
    static func test(_ password: String, matches: String) -> Bool {
        return password.range(of: matches, options: .regularExpression) != nil
    }
}
