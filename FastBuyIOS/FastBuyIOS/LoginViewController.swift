//
//  LoginViewController.swift
//  FastBuyIOS
//
//  Created by Luis on 3/3/20.
//  Copyright © 2020 CORPORACION FASTBUY S.A.C. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var txtUserInfo: UITextField!
    @IBOutlet weak var txtUserPassword: UITextField!
    @IBOutlet weak var btnIngresar: UIButton!
    @IBOutlet weak var btnRegistrar: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let keyIcon = UIImage(named: "key")
        setLeftIcon(txtField: txtUserPassword, img: keyIcon!)
        
        let userIcon = UIImage(named: "user")
        setLeftIcon(txtField: txtUserInfo, img: userIcon!)
        
        txtUserInfo.layer.cornerRadius = 22
        txtUserPassword.layer.cornerRadius = 22
        
        Common.setButtomStyleZero(btnIngresar!)
        Common.setButtomStyleZero(btnRegistrar!)
    }
    
    func setLeftIcon(txtField: UITextField, img: UIImage) {
        let padding = 6
        let _wHeight = txtField.frame.size.height
        let viewPadding = UIView(frame: CGRect(x: 0, y: 0, width: Int(_wHeight), height: Int(_wHeight)))
        let leftImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: _wHeight-CGFloat(padding*2), height: _wHeight-CGFloat(padding*2)))
        leftImageView.center = viewPadding.center
        leftImageView.image = img
        viewPadding.addSubview(leftImageView)
        txtField.leftView = viewPadding
        txtField.leftViewMode = .always
    }
    
    @IBAction func click_btnOlvideContrasenha()
    {
        print("olvide contraseña")
    }
    
    @IBAction func click_btnIngresar()
    {
        let user: String = txtUserInfo.text!
        let password: String = txtUserPassword.text!
        print("login con user: \(user)")
        print("      password: \(password)")
    }
    
    @IBAction func click_btnRegistrar()
    {
        let user: String = txtUserInfo.text!
        let password: String = txtUserPassword.text!
        print("register user: \(user)")
        print("     password: \(password)")
    }
    
    @IBAction func click_btnRead()
    {
        print("btn: Read")
        
        let mail = UserDefaults.standard.string(forKey: "e-mail") ?? "< empty >"
        
        print("read > e-mail : \(mail)")
        
        txtUserInfo.text = mail
    }
    
    @IBAction func click_btnSave()
    {
        print("btn: Save")
        
        let mail = txtUserInfo.text ?? "null"
        
        print("write > e-mail: \(mail)")
        
        UserDefaults.standard.set(mail, forKey: "e-mail")
    }
}
