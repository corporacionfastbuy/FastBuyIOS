//
//  CarritoViewController.swift
//  FastBuyIOS
//
//  Created by Luis on 3/3/20.
//  Copyright © 2020 CORPORACION FASTBUY S.A.C. All rights reserved.
//

import UIKit

protocol ListaPedidoItemDelegate: class
{
    func actionDeleteItem(_ row: Int)
    func actionCambiarCantidadItem(_ row: Int)
}

class ListaPedidoItem: UITableViewCell
{
    @IBOutlet weak var txtProducto: UILabel!
    @IBOutlet weak var txtNegocio: UILabel!
    @IBOutlet weak var txtCantidad: UITextField!
    @IBOutlet weak var btnStepper: UIStepper!
    @IBOutlet weak var txtCosto: UILabel!
    
    var row: Int = -1
    
    var delegate: ListaPedidoItemDelegate?
    
    @IBAction func click_btnEliminar()
    {
        delegate?.actionDeleteItem(row)
    }
    
    @IBAction func click_btnStepper(_ sender: Any)
    {
        var item = app.carrito[row]
        
        item.cantidad = Int(btnStepper.value)
        txtCantidad.text = "\(Int(btnStepper.value))"
        
        item.precio = item.producto.precio * btnStepper.value
        txtCosto.text = item.precio.toString()
        
        app.carrito[row] = item
        
        delegate?.actionCambiarCantidadItem(row)
    }
}

class ListaPedidoDelegate: NSObject, UITableViewDelegate, UITableViewDataSource
{
    var completionDelegate: ListaPedidoItemDelegate?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return app.carrito.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UiPedidoItem", for: indexPath) as! ListaPedidoItem
        
        let data = app.carrito[indexPath.row]
        
        cell.row = indexPath.row
        cell.txtProducto.text = data.producto.nombre
        cell.txtNegocio.text = data.negocio.nombre
        cell.btnStepper.value = Double(data.cantidad)
        cell.txtCantidad.text = "\(data.cantidad)"
        cell.txtCosto.text = data.precio.toString()
        cell.delegate = completionDelegate
        
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            app.carrito.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
}

class CarritoViewController: UIViewController, ListaPedidoItemDelegate, UITextFieldDelegate
{
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var txtDatosContacto: UITextField!
    @IBOutlet weak var txtCostoEnvio: UILabel!
    @IBOutlet weak var txtCostoTotal: UILabel!
    
    var dataDelegate: ListaPedidoDelegate = ListaPedidoDelegate()
    var toDatosContatoView: Bool = false
    
    var posItemPedido: Int = -1
    var idPedido: Int = -1
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        navigationItem.title = "Pedido"
        navigationController?.toolbar.isTranslucent = false
        navigationController?.toolbar.barTintColor = Common.MAIN_COLOR
        
        table.delegate = dataDelegate
        table.dataSource = dataDelegate
        table.contentInset = UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0)
        table.tableFooterView = UIView(frame: .zero)
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 300
        
        dataDelegate.completionDelegate = self
        
        txtDatosContacto.delegate = self
        
        txtDatosContacto.backgroundColor = UIColor.clear
        txtDatosContacto.layer.cornerRadius = 5
        txtDatosContacto.layer.borderWidth = 1
        txtDatosContacto.layer.borderColor = UIColor.lightGray.cgColor
        
        mostrarListaPedido()
    }
    
    func textFieldShouldBeginEditing(_ txt: UITextField) -> Bool {
        print("txt edit mode")
        if txt == txtDatosContacto
        {
            toDatosContatoView = true
            performSegue(withIdentifier: "show_datos_contacto_form", sender: self)
        }
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setToolbarHidden(false, animated: animated)
        if app.currentPedido.userDataValid
        {
            txtDatosContacto.text = app.currentPedido.userTelefono
            txtDatosContacto.layer.borderColor = UIColor.lightGray.cgColor
        }
        else
        {
            txtDatosContacto.text = ""
        }
        toDatosContatoView = false
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if toDatosContatoView == false
        {
            self.navigationController?.setToolbarHidden(true, animated: animated)
        }
        super.viewWillDisappear(animated)
    }

    func mostrarListaPedido()
    {
        table.reloadData()
        actualizarCostos()
    }
    
    func actualizarCostos()
    {
        var costo: Double = 0.0
        
        for item in app.carrito
        {
            costo += item.precio
        }
        
        if costo > 0.00
        {
            costo += app.minimoCostoEnvio
            app.carritoCostoTotal = costo
            txtCostoEnvio.text = app.minimoCostoEnvio.toString()
            txtCostoTotal.text = "S/ " + costo.toString()
        }
        else
        {
            txtCostoEnvio.text = "0.00"
            txtCostoTotal.text = "S/ 0.00"
        }
    }
    
    func actionDeleteItem(_ row: Int)
    {
        print("eliminar row \(row)")
        
        app.carrito.remove(at: row)
        
        mostrarListaPedido()
    }
    
    func actionCambiarCantidadItem(_ row: Int)
    {
        print("actualizar row \(row)")
        actualizarCostos()
    }
    
    @IBAction func click_btnLimpiar()
    {
        print("limpiar carrito")
        app.carrito.removeAll()
        mostrarListaPedido()
    }
    
    @IBAction func click_btnDone()
    {
        print("continuar pedido")
        
        let pedido = app.currentPedido
        
        if !pedido.userDataValid
        {
            txtDatosContacto.layer.borderColor = UIColor.red.cgColor
            return
        }
        
        dataController.pedido.registrar(pedido.userNombre,
                                        pedido.userDireccion,
                                        pedido.userTelefono,
                                        handler_registraPedido)
    }
    
    @objc func handler_registraPedido(_ error: Bool)
    {
        if error
        {
            print("Carrito: error, no se puede registrar el pedido")
            return
        }
        
        idPedido = dataController.pedido.lastId
        print("Carrito: pedido registrado con el codigo < \(idPedido) >")
        
        posItemPedido = -1
        
        print("Carrito: registrando items")
        registrarPedidoItem()
    }
    
    func registrarPedidoItem()
    {
        posItemPedido += 1
        
        if posItemPedido < app.carrito.count
        {
            let prod = app.carrito[posItemPedido]
            
            dataController.pedido.anhadir(self.idPedido,
                                          posItemPedido, prod.producto.codigo, prod.cantidad, prod.producto.precio, prod.precio,
                                          handler_registrarItem)
        }
        else
        {
            print("Carrito: contenido registrado con exito")
        }
    }
    
    @objc func handler_registrarItem(_ err: Bool)
    {
        if err
        {
            print("Carrito: ocurrio un error al registrar el item < \(posItemPedido) >")
            return
        }
        
        registrarPedidoItem()
    }
}
