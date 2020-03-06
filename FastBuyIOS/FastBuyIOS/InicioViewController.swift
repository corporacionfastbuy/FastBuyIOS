//
//  InicioViewController.swift
//  FastBuyIOS
//
//  Created by Luis on 3/3/20.
//  Copyright © 2020 CORPORACION FASTBUY S.A.C. All rights reserved.
//


import UIKit

class InicioViewController: UIViewController {

    @IBOutlet weak var btnPedidoFast: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnLoginFacebook: UIButton!
    @IBOutlet weak var btnLoginGooglePlus: UIButton!
    @IBOutlet weak var vSpacer: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.backgroundColor = Common.MAIN_COLOR
        
        /*
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        var value: CGFloat = 0
        
        if self.navigationController != nil {
            value = self.navigationController!.navigationBar.frame.size.height
        }
        
        vSpacer.constant = value + 65.0
        */
        
        Common.setButtomStyleZero(btnPedidoFast!,18)
        Common.setButtomStyleZero(btnLogin!,btnLogin.frame.height/2)
        
        btnLoginFacebook.layer.cornerRadius = 32
        btnLoginGooglePlus.layer.cornerRadius = 32
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }

    @IBAction func click_btnPedidoFast()
    {
        print("pedido fast")
        performSegue(withIdentifier: "show_main", sender: self)
    }
    
    @IBAction func click_btnLogin()
    {
        print("login")
        
        guard let view = storyboard?.instantiateViewController(withIdentifier: "LoginForm") else
        {
            print("no se puede obtener la instancia de LoginViewController")
            return
        }
        
        navigationController?.pushViewControllerFade(view)
        
        //performSegue(withIdentifier: "show_login", sender: self)
    }
    
    @IBAction func click_btnLoginFacebook()
    {
        print("login con facebook")
    }
    
    @IBAction func click_btnLoginGooglePlus()
    {
        print("login with google plus")
    }
}

