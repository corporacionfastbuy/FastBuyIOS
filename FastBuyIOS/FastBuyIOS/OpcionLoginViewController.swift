//
//  OpcionLoginViewController.swift
//  FastBuyIOS
//
//  Created by Luis on 3/4/20.
//  Copyright © 2020 CORPORACION FASTBUY S.A.C. All rights reserved.
//

import UIKit

class OpcionLoginViewController: UIViewController {

    @IBOutlet weak var btnLoginFacebook: UIButton!
    @IBOutlet weak var btnLoginGoogle: UIButton!
    @IBOutlet weak var btnLoginFastbuy: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnLoginFacebook.layer.cornerRadius = 25
        btnLoginGoogle.layer.cornerRadius = 25
        btnLoginFastbuy.layer.cornerRadius = 25
        btnLoginFastbuy.layer.borderColor = UIColor(red: 0/255.0, green: 195/255.0, blue: 164/255.0, alpha: 1.0).cgColor//.green.cgColor
        btnLoginFastbuy.layer.borderWidth = 2
        
        //valida conexion a internet
        NotificationCenter.default
            .addObserver(self,
                     selector: #selector(statusManager),
                     name: .flagsChanged,
                     object: nil)
        updateUserInterface()
        
        
    }
    @IBAction func btnLoginFacebook(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goIngresarNumero", sender: self)
    }
    
    @IBAction func btnLoginGoogle(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goIngresarNumero", sender: self)
    }
    
    @IBAction func btnFastbuy(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goNewUsuarioFast", sender: self)
    }
    
    @objc func statusManager(_ notification: Notification) {
        updateUserInterface()
    }
    
    func updateUserInterface() {
        switch Network.reachability.status {
        case .unreachable:
            controlView(color:.red, enabled: false)
        case .wwan:
            controlView(color:.white, enabled: true)
        case .wifi:
            controlView(color:.white, enabled: true)
        }
    }
    
    func controlView(color:UIColor, enabled: Bool){
        view.backgroundColor = color
        enabledButton(bool: enabled)
        /*timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: false)*/
    }
    
    func enabledButton(bool:Bool){
        btnLoginFacebook.isEnabled = bool
        btnLoginGoogle.isEnabled = bool
        btnLoginFastbuy.isEnabled = bool
        if bool{
            btnLoginFacebook.setTitleColor(.white, for: UIControl.State.normal)
            btnLoginGoogle.setTitleColor(.white, for: UIControl.State.normal)
            btnLoginFastbuy.setTitleColor(UIColor(red: 0/255.0, green: 195/255.0, blue: 164/255.0, alpha: 1.0), for: UIControl.State.normal)
        }else{
            btnLoginFacebook.setTitleColor(.gray, for: UIControl.State.normal)
            btnLoginGoogle.setTitleColor(.gray, for: UIControl.State.normal)
            btnLoginFastbuy.setTitleColor(.gray, for: UIControl.State.normal)
        }
        
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        /*if(segue.identifier == "goIngresarNumero") {
            segue.destination as! IngresaNumeroViewController
        }
        else if(segue.identifier == "goNewUsuarioFast") {
            segue.destination as! NewUsuarioFastViewController
        }    */
    //}

}
