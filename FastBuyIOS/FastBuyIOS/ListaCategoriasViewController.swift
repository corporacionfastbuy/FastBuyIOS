//
//  ListaCategoriasViewController.swift
//  FastBuyIOS
//
//  Created by Luis on 3/3/20.
//  Copyright © 2020 CORPORACION FASTBUY S.A.C. All rights reserved.
//

import Foundation
import UIKit

class ListaCategoriasDelegate: NSObject, UITableViewDelegate, UITableViewDataSource
{
    var didSelectRow: ((_ row: Int) -> Void)?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return app.listaCategorias.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = app.listaCategorias[indexPath.row].desc
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let didSelectRow = didSelectRow
        {
            didSelectRow(indexPath.row)
        }
    }
}

class ListaCategoriasViewController: UIViewController
{
    let dstr = "ListaCategorias: "
    
    @IBOutlet weak var listView: UITableView!
    var dataDelegate: ListaCategoriasDelegate = ListaCategoriasDelegate()
    @IBOutlet weak var txtNegocioNombre: UILabel!
    @IBOutlet weak var txtNegocioDescripcion: UILabel!
    @IBOutlet weak var imgNegocioLogo: UIImageView!
    let progressWidget: UIActivityIndicatorView = UIActivityIndicatorView(style: .gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let btnBarCarrito = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.compose,
                                            target: self,
                                            action: #selector(click_btnCarrito))
        
        navigationItem.rightBarButtonItem = btnBarCarrito
        
        txtNegocioNombre.text = app.currentNegocio.nombre
        txtNegocioDescripcion.text = app.currentNegocio.razon
        
        if fileGestor.isOk(), fileGestor.existsFile(fileName: app.currentNegocio.logo)
        {
            imgNegocioLogo.image = UIImage(contentsOfFile: fileGestor.filePath(fileName: app.currentNegocio.logo))
        }
        else
        {
            imgNegocioLogo.image = UIImage(contentsOfFile: "shop.png")
        }
        
        listView.backgroundView = progressWidget
        listView.delegate = dataDelegate
        listView.dataSource = dataDelegate
        dataDelegate.didSelectRow = didSelectRow
        
        if app.oldCurrentNegocio.codigo != app.currentNegocio.codigo
        {
            getListaCategorias()
        }
        else
        {
            mostrarLista(false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        print(dstr,"mostrar categorias de < \(app.currentNegocio.nombre) >")
        super.viewWillAppear(animated)
    }
    
    func didSelectRow(_ row: Int)
    {
        if app.currentCategoria != nil
        {
            app.oldCurrentCategoria = app.currentCategoria
        }
        app.currentCategoria = app.listaCategorias[row]
        print(dstr,"abrir catalogo de < \(app.currentCategoria.desc) >")
        performSegue(withIdentifier: "mostrar_producto_2", sender: self)
    }
    
    @objc func mostrarLista(_ err: Bool)
    {
        OperationQueue.main.addOperation {
            self.progressWidget.stopAnimating()
            self.listView.separatorStyle = .singleLine
            self.listView.reloadData()
        }
    }
    
    func getListaCategorias()
    {
        print(dstr,"obtener lista de categorias")

        listView.separatorStyle = .none
        progressWidget.startAnimating()
        
        dataController.listaCategorias.get(idNegocio: app.currentNegocio.codigo, mostrarLista)
    }
    
    @IBAction func click_btnCarrito()
    {
        print(dstr,"mostrar carrito")
        performSegue(withIdentifier: "mostrar_carrito_desde_listaCategorias", sender: self)
    }
}
