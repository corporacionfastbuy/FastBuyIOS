//
//  IngresaNumeroViewController.swift
//  FastBuyIOS
//
//  Created by Luis on 3/5/20.
//  Copyright © 2020 CORPORACION FASTBUY S.A.C. All rights reserved.
//

import UIKit

class IngresaNumeroViewController: UIViewController {
    
    @IBOutlet weak var txtSaludoUsuario: UILabel!
    @IBOutlet weak var btnCodigoNumero: UIButton!
    @IBOutlet weak var edtNumeroMovil: UITextView!
    @IBOutlet weak var btnRecibeCodigo: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnCodigoNumero.layer.cornerRadius = 10
        edtNumeroMovil.layer.cornerRadius = 10
        btnRecibeCodigo.layer.cornerRadius = 20
        // Do any additional setup after loading the view.
    }
    
    
    
    

}
