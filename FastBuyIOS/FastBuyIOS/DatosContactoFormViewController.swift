//
//  DatosContactoFormViewController.swift
//  FastBuyIOS
//
//  Created by Luis on 3/3/20.
//  Copyright © 2020 CORPORACION FASTBUY S.A.C. All rights reserved.
//

import UIKit

class DatosContactoFormViewController: UIViewController
{
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtDireccion: UITextField!
    @IBOutlet weak var txtTelefono: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        navigationItem.title = "Datos de contacto"
        
        let btnCancel = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(click_btnCancel))
        let btnDone = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(click_btnDone))
        btnDone.style = .plain
        navigationItem.leftBarButtonItem = btnCancel
        navigationItem.rightBarButtonItem = btnDone
    
        txtNombre.text = app.currentPedido.userNombre
        txtDireccion.text = app.currentPedido.userDireccion
        txtTelefono.text = app.currentPedido.userTelefono
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.navigationController?.setToolbarHidden(false, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //self.navigationController?.setToolbarHidden(true, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    @IBAction func click_btnCancel()
    {
        navigationController?.popViewController(animated: true)
    }
    
    private func inputWidgetRed(_ widget: UITextField)
    {
        widget.backgroundColor = UIColor.clear
        widget.layer.cornerRadius = 5
        widget.layer.borderWidth = 1
        widget.layer.borderColor = UIColor.red.cgColor
    }
    
    @IBAction func click_btnDone()
    {
        let textNombre = txtNombre.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let textDireccion = txtDireccion.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let textTelefono = txtTelefono.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        var contador: Int = 0
        
        if textNombre.count > 0
        {
            contador += 1
            txtNombre.layer.borderColor = UIColor.lightGray.cgColor
        }
        else
        {
            print("empty nombre")
            inputWidgetRed(txtNombre)
        }
        
        if textDireccion.count > 0
        {
            contador += 1
            txtDireccion.layer.borderColor = UIColor.lightGray.cgColor
        }
        else
        {
            print("empty direccion")
            inputWidgetRed(txtDireccion)
        }
        
        if textTelefono.count > 0
        {
            contador += 1
            txtTelefono.layer.borderColor = UIColor.lightGray.cgColor
        }
        else
        {
            print("empty telefono")
            inputWidgetRed(txtTelefono)
        }
        
        if contador == 3
        {
            app.currentPedido = PedidoData(nombre: textNombre, direccion: textDireccion, telefono: textTelefono)
            navigationController?.popViewController(animated: true)
        }
    }
}
