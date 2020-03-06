//
//  ListaProductosViewController.swift
//  FastBuyIOS
//
//  Created by Luis on 3/3/20.
//  Copyright © 2020 CORPORACION FASTBUY S.A.C. All rights reserved.
//

import Foundation
import UIKit

protocol ListaProductosItemDelegate: class
{
    func actionAddCarrito(_ row: Int, _ cantidad: Int)
}

class ListaProductosItem: UITableViewCell
{
    @IBOutlet weak var txtNombre: UILabel!
    @IBOutlet weak var txtPrecio: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var txtCantidad: UITextField!
    @IBOutlet weak var btnStepper: UIStepper!
    
    var row: Int = -1
    
    var cellDelegate: ListaProductosItemDelegate?
    
    @IBAction func click_btnAnahdir()
    {
        print("click en producto: [ \(row) ] \(txtNombre.text!)")
        
        cellDelegate?.actionAddCarrito(row,Int(btnStepper.value))
    }
    
    @IBAction func click_btnStepper(_ sender: Any)
    {
        txtCantidad.text = "\(Int(btnStepper.value))"
    }
}

class ListaProductosViewController: UITableViewController, ListaProductosItemDelegate
{
    let dstr = "ListaProductos: "
    let progressWidget: UIActivityIndicatorView = UIActivityIndicatorView(style: .gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = app.currentCategoria.desc
        
        let btnBarCarrito = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.compose,
                                            target: self,
                                            action: #selector(click_btnCarrito))
        
        navigationItem.rightBarButtonItem = btnBarCarrito

        tableView.backgroundView = progressWidget
        
        tableView.contentInset = UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0)
        tableView.allowsMultipleSelection = false
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        
        if app.oldCurrentCategoria.cod != app.currentCategoria.cod
        {
            getListaNegociosFromWeb()
        }
        else
        {
            mostrarLista()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return app.listaProductos.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 1.0 : 32
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return ""
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("table: loading item")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListaProductosItem", for: indexPath) as! ListaProductosItem
        
        let producto = app.listaProductos[indexPath.row]
        
        cell.row = indexPath.row
        cell.cellDelegate = self
        
        cell.txtNombre.text = producto.nombre
        cell.txtPrecio.text = "S/ "+producto.precio.toString()
        
        if fileGestor.existsFile(fileName: producto.imagen)
        {
            cell.imgView.image = UIImage(contentsOfFile: fileGestor.filePath(fileName: producto.imagen))
        }
        else
        {
            cell.imgView.image = UIImage(contentsOfFile: "shop.png")
        }
        
        cell.imgView.layer.masksToBounds = true
        cell.imgView.layer.cornerRadius = 5
        
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(dstr,"click sobre el item \(indexPath.row)")

    }
    
    @objc func mostrarLista(_ err: Bool = false)
    {
        if err
        {
            print(dstr,"ocurrio un error mientras se obtenia la lista de negocios")
        }
        
        DispatchQueue.main.async( execute: {
            self.progressWidget.stopAnimating()
            self.tableView.separatorStyle = .singleLine
            self.tableView.reloadData()
        })
        
        /* OperationQueue.main.addOperation {
            self.progressWidget.stopAnimating()
            self.tableView.separatorStyle = .singleLine
            self.tableView.reloadData()
        } */
    }
    
    func getListaNegociosFromWeb()
    {
        print(dstr,"obtener lista de negocios")
        
        tableView.separatorStyle = .none
        
        progressWidget.startAnimating()
        
        dataController.listaProductos.get(app.currentNegocio.codigo,
                                          app.currentCategoria.cod,
                                          mostrarLista)
    }
    
    func actionAddCarrito(_ row: Int, _ cantidad: Int)
    {
        app.carrito.append(CarritoItem(negocio: app.currentNegocio,
                                       categoria: app.currentCategoria,
                                       producto: app.listaProductos[row],
                                       cantidad: cantidad,
                                       precio: app.listaProductos[row].precio * Double(cantidad) ))
        print(dstr,"añadir al carrito")
    }
    
    @IBAction func click_btnCarrito()
    {
        print(dstr,"mostrar carrito")
        performSegue(withIdentifier: "mostrar_carrito_desde_listaProductos", sender: self)
    }
}
