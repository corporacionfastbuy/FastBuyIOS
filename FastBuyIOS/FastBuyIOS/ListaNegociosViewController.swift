//
//  ListaNegociosViewController.swift
//  FastBuyIOS
//
//  Created by Luis on 3/3/20.
//  Copyright © 2020 CORPORACION FASTBUY S.A.C. All rights reserved.
//

import UIKit

class ListaNegociosItem: UITableViewCell
{
    @IBOutlet weak var negocioNombre: UILabel!
    @IBOutlet weak var negocioRazon: UILabel!
    @IBOutlet weak var negocioLogo: UIImageView!
    @IBOutlet weak var txtStatus: UILabel!
    var cod: Int!
}

class ListaNegociosViewController: UITableViewController
{
    let dstr = "ListaNegocios: "
    var progressWidget: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = Common.MAIN_COLOR
        navigationController?.navigationBar.backgroundColor = Common.MAIN_COLOR
        navigationController?.navigationBar.tintColor = UIColor.white

        let btnBarUpdate = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.refresh,
                                           target: self,
                                           action: #selector(getListaNegociosFromWeb))
        let btnBarCarrito = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.compose,
                                            target: self,
                                            action: #selector(click_btnCarrito))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "",
                                                           style: .plain,
                                                           target: self, action: nil)
        navigationItem.rightBarButtonItems = [btnBarCarrito,btnBarUpdate]
        
        progressWidget = UIActivityIndicatorView(style: .gray)
        tableView.backgroundView = progressWidget
        
        tableView.contentInset = UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0)
        tableView.allowsMultipleSelection = false
        tableView.tableFooterView = UIView(frame: .zero)
        
        self.title = "FAST BUY"
        
        getListaNegociosFromWeb()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return app.listaNegocios.count
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListaNegociosItem", for: indexPath) as! ListaNegociosItem
        let item_info = app.listaNegocios[indexPath.row]
        print("\tNegocio: \(item_info.nombre)\n\tArea: \(item_info.razon)")

        cell.negocioNombre.text = item_info.nombre
        cell.negocioRazon.text = item_info.razon
        
        if fileGestor.existsFile(fileName: item_info.logo)
        {
            cell.negocioLogo.image = UIImage(contentsOfFile: fileGestor.filePath(fileName: item_info.logo))
        }
        else
        {
            cell.negocioLogo.image = UIImage(contentsOfFile: "shop.png")
        }
        
        cell.negocioLogo.layer.masksToBounds = true
        cell.negocioLogo.layer.cornerRadius = 5
        
        cell.cod = item_info.codigo
        
        if item_info.estado == 0
        {
            cell.txtStatus.text = "Cerrado"
            cell.txtStatus.textColor = UIColor.red
        }
        else
        {
            cell.txtStatus.text = "Atendiendo ahora"
            cell.txtStatus.textColor = UIColor(red: 34/255, green: 206/255, blue: 5/255, alpha: 1)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(dstr,"click sobre el item \(indexPath.row)")
        let negocio = app.listaNegocios[indexPath.row]
        if app.currentNegocio != nil
        {
            app.oldCurrentNegocio = app.currentNegocio
        }
        app.currentNegocio = negocio
        print(dstr,"abrir catalogo de < \(negocio.nombre) >")
        performSegue(withIdentifier: "mostrar_categorias_2", sender: self)
    }
    
    @objc func mostrarLista(_ err: Bool)
    {
        /*
        DispatchQueue.main.async( execute: {
            self.progressWidget.stopAnimating()
            self.tableView.separatorStyle = .singleLine
            self.tableView.reloadData()
        })
        */
        
        if err
        {
            print(dstr,"ocurrio un error mientras se obtenia la lista de negocios")
        }
        
        OperationQueue.main.addOperation {
            self.progressWidget.stopAnimating()
            self.tableView.separatorStyle = .singleLine
            self.tableView.reloadData()
        }
    }
    
    @objc @IBAction func getListaNegociosFromWeb()
    {
        print(dstr,"obtener lista de negocios")
        
        tableView.separatorStyle = .none
        progressWidget.startAnimating()
        
        dataController.listaNegocios.get(mostrarLista)
    }
    
    @IBAction func click_btnCarrito()
    {
        print(dstr,"mostrar carrito")
        performSegue(withIdentifier: "mostrar_carrito_desde_listaNegocios", sender: self)
    }
}
