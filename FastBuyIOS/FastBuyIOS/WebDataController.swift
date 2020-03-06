//
//  WebDataController.swift
//  Fast_Buy_iOS
//
//  Created by null on 3/14/19.
//  Copyright © 2019 chinchilla. All rights reserved.
//

import Foundation

public class WebDataController
{
    let listaNegocios = ListaNegociosDataController()
    let listaCategorias = ListaCategoriasDataController()
    let listaProductos = ListaProductosDataController()
    let pedido = PedidoDataController()
}

fileprivate struct Response
{
    let statusCode: Int
    let headers: [String:String]
    let body: Data
}

fileprivate func uriAssembler(path: String, queryItems: [String:String]? = nil) -> URLComponents
{
    var _uri: URLComponents = URLComponents()
    
    _uri.scheme = Common.SCHEME
    _uri.host   = Common.HOST
    _uri.path   = path
    
    if let queryItems = queryItems
    {
        var qItems: [URLQueryItem] = [URLQueryItem]()
        
        for key in Array(queryItems.keys)
        {
            qItems.append(URLQueryItem(name: key, value: queryItems[key]))
        }
        
        _uri.queryItems = qItems
    }
    
    return _uri
}

class WebDataControllerBase
{
    fileprivate private(set) var objectName = "Web Data Controller Base"
    fileprivate private(set) var requestMethod = "GET"
    fileprivate private(set) var response: Response?
    
    fileprivate var fnCompletionHandler: Any?
    
    // asignar nombre al objeto, para identificar el origen del mensaje durante el debug
    //                         , por seguridad la variable < objectName > solo puede ser modificada usando esta funcion
    fileprivate func setObjectName(_ name: String)
    {
        self.objectName = name
    }
    
    // imprimir mensaje, version abrebiada para facilidad de escritura ( por pereza )
    fileprivate func log(_ text: String)
    {
        print(objectName + ": " + text)
    }
    
    // imprimir mensaje de error y llamar a la funcion de completado ( oferta: 2 acciones x 1 )
    fileprivate func error(_ text: String)
    {
        print("[ERROR!] "+self.objectName+": "+text)
        finish(error: true)
    }
    
    // informar sobre la finalizacion de la consulta al servidor
    fileprivate func finish(error: Bool = false)
    {
        guard let fn = fnCompletionHandler as? (_ error: Bool) -> () else
        {
            print(objectName,"error, no se puede llamar a la funcion de completado")
            return
        }
        
        fn(error)
    }
    
    // iniciar consulta al servidor
    fileprivate func processRequest(method: String = "GET", uri: URLComponents, headers: [String:String]? = nil)
    {
        self.requestMethod = method
        
        guard let uriTarget = uri.url else
        {
            //print(dstr,"error, no se puede convertir: String a URL")
            error("no se puede ensamblar la url objetivo")
            return
        }
        
        print(objectName,"target < \(uriTarget.absoluteString) >")
        
        var req = URLRequest(url: uriTarget)
        req.httpMethod = self.requestMethod
        // req.addValue("fastbuy_ios_app", forHTTPHeaderField: "User-Agent") // solo por curiosidad
        
        if let headers = headers
        {
            for key in Array(headers.keys)
            {
                req.addValue(headers[key]!, forHTTPHeaderField: key)
            }
        }
        
        let task = URLSession.shared.dataTask(with: req)
        {
            (data, response, error) in
            
            guard error == nil else
            {
                self.error("ocurrio un error inesperado, \(error.debugDescription)")
                return
            }
            
            self.log("respuesta obtenida")
            
            self.processResponse(dat: data, res: response)
        }
        task.resume()
        
        log("consulta envida al servidor")
    }
    
    fileprivate func processResponse(dat: Data?, res: URLResponse?) -> Void
    {
        guard let responseInfo = res as? HTTPURLResponse else
        {
            print(objectName,"error, no se puede leer la respuesta del servidor")
            finish(error: true)
            return
        }
        
        guard let header = responseInfo.allHeaderFields as? [String:String] else
        {
            print(objectName,"error, no se puede leer la cabecera de la respuesta")
            finish(error: true)
            return
        }
        
        guard let data = dat else
        {
            print(objectName,"error, no se recivieron datos")
            finish(error: true)
            return
        }
        
        response = Response(statusCode: responseInfo.statusCode,headers: header, body: data)
        
        processData()
    }
    
    // funcion reemplazable para procesar la respuesta del servidor
    func processData()
    {
        guard let res = response else
        {
            print(objectName,"no se puede acceder a la copia de la respuesta del servidor")
            finish(error: true)
            return
        }
        
        if res.statusCode >= 400
        {
            print(objectName,"el servidor se encuentra NOCAUT")
            finish(error: true)
            return
        }
        
        do
        {
            // print(String(decoding: res.body, as: UTF8.self))
            
            let json = try JSONSerialization.jsonObject(with: res.body, options: [])
            
            if let array = json as? [[String: Any]]
            {
                print(objectName,"procesar como json.Array")
                processDataAsJson(array: array)
            }
            else if let object = json as? [String: Any]
            {
                print(objectName,"procesar como json.Object")
                processDataAsJson(object: object)
            }
            else
            {
                print(objectName,"no se puede convertir el json a un estructura procesable")
                finish(error: true)
            }
        }
        catch
        {
            print(objectName,"error al reconstruir el archivo json")
            finish(error: true)
        }
    }
    
    fileprivate func processDataAsJson(array: [[String: Any]])
    {
        // codigo para procesar el array json
        finish(error: true)
    }
    
    fileprivate func processDataAsJson(object: [String: Any])
    {
        // codigo para procesar el objeto json
        finish(error: true)
    }
    
    
    
    
    
}

class ImageDownloader: WebDataControllerBase
{
    var uriPath = "abc://test.com"
    var fileName = ""
    
    override init()
    {
        super.init()
        setObjectName("Image Downloader")
    }
    
    // If-Modified-Since: $DATE
    // return <- 304, no mod
    //             n, mod
    
    func get(fileName: String, _ cuandoTermineLlamar: @escaping (_ error: Bool) -> ())
    {
        fnCompletionHandler = cuandoTermineLlamar
        self.fileName = fileName
        let aUri = uriAssembler(path: uriPath + fileName)
        //print("url_encode: \(fileName.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!)")
        print(objectName,"get file < \(fileName) >")
        processRequest(method: "HEAD", uri: aUri)
    }
    
    override func processData()
    {
        if requestMethod == "HEAD"
        {
            comprobarImagen()
        }
        else
        {
            saveImageData()
        }
    }
    
    private func comprobarImagen()
    {
        print(objectName,"comprobar modificacion de la imagen")
        
        guard let res = response else
        {
            print(objectName,"no se puede acceder a la copia de la respuesta del servidor")
            finish(error: true)
            return
        }
        
        if res.statusCode >= 500
        {
            print(objectName,"error, el servidor se esta NOCAUT")
            finish(error: true)
            return
        }
        
        if res.statusCode >= 400
        {
            print(objectName,"error, lo solicitado no existe en el servidor")
            finish(error: true)
            return
        }
        
        guard let dateModified = res.headers["Last-Modified"] else
        {
            print(objectName,"no se encontro la etiqueta < Last-Modified >, procediendo con la descarga de la imagen")
            downloadImage()
            return
        }
        
        if !fileGestor.isOk()
        {
            print(objectName,"no se puede acceder al gestor de archivos")
            finish(error: true)
            return
        }
        
        if !fileGestor.existsFile(fileName: fileName)
        {
            print(objectName,"la imagen < \(fileName) >  no existe, procediendo con la descarga")
            downloadImage()
            return
        }
        
        print(objectName,"image < \(fileName) >")
        print(objectName,"mod-date < \(dateModified) >")
        
        let dateFile = fileGestor.fileLastModified(fileName: fileName)
        
        if dateModified == dateFile
        {
            print(objectName,"la fecha de la imagen local es igual a la que esta en el servidor")
            print(objectName,"saltando la descarga de la imagen")
            finish()
        }
        else
        {
            print(objectName,"las fechas no coinciden, procediendo a descargar la imagen nueva")
            downloadImage()
        }
    }
    
    private func saveImageData()
    {
        guard let res = response else
        {
            print(objectName,"no se puede acceder a la copia de la respuesta del servidor")
            finish(error: true)
            return
        }
        
        if res.body.count == 0
        {
            print(objectName,"no se recivieron datos")
            finish(error: true)
            return
        }
        
        fileGestor.saveFile(fileName: fileName, buffer: res.body)
        
        guard let dateModified = res.headers["Last-Modified"] else
        {
            print(objectName,"no se encontro la etiqueta < Last-Modified >")
            finish(error: true)
            return
        }
        
        fileGestor.setfileLastModified(fileName: fileName, strDate: dateModified)
        
        print(objectName,"image < \(fileName) >")
        print(objectName,"mod-date < \(dateModified) >")
        
        finish()
    }
    
    private func downloadImage()
    {
        print(objectName,"descargar imagen")
        let aUri = uriAssembler(path: uriPath + fileName)
        processRequest(uri: aUri)
    }
}

class ListaNegociosDataController: WebDataControllerBase
{
    let uriPath = "/app/controllers/CargarEmpresas.php"
    let imgDownloader = ImageDownloader()
    var idxImage = -1
    
    override init()
    {
        super.init()
        setObjectName("Data Lista Negocios")
        imgDownloader.uriPath = "/empresas/logos/"
    }
    
    func get(_ cuandoTermineLlamar: @escaping (_ error: Bool) -> ())
    {
        print(objectName,"obtener lista actualizada")
        fnCompletionHandler = cuandoTermineLlamar
        processRequest(uri: uriAssembler(path: uriPath))
    }
    
    override func processDataAsJson(array: [[String: Any]])
    {
        print(objectName,"procesando JSON")
        
        app.listaNegocios.removeAll()
        
        for item in array
        {
            var status: Int = 0
            
            if item["estadoAbierto"] as! String == "Abierto"
            {
                status = 1
            }
            
            let negocio = NegocioData (
                codigo: item["codigo"] as! Int,
                nombre: item["nombreComercial"] as! String,
                razon: item["razonSocial"] as! String,
                logo: item["foto"] as! String,
                estado: status
            )
            
            app.listaNegocios.append(negocio)
        }
        
        app.listaNegocios = app.listaNegocios.sorted { $0.nombre.lowercased() < $1.nombre.lowercased() }
        
        getLogos()
    }
    
    private func getLogos()
    {
        idxImage += 1
        
        if idxImage < app.listaNegocios.count
        {
            let negocio = app.listaNegocios[idxImage]
            print(objectName,"[ \(idxImage) de \(app.listaNegocios.count) ] obtener logo de < \(negocio.nombre) >")
            imgDownloader.get(fileName: negocio.logo, nextLogo)
        }
        else
        {
            idxImage = -1
            print(objectName,"operaciones finalizadas, llamando a la funcion de completado")
            finish()
        }
    }
    
    @objc private func nextLogo(anteriorConError: Bool)
    {
        if anteriorConError
        {
            print(objectName,"error al obtener el logo de < \(app.listaNegocios[idxImage].nombre) >")
        }
        
        getLogos()
    }
}

class ListaCategoriasDataController: WebDataControllerBase
{
    let uriPath = "/app/controllers/CargarCategoriaPorEmpresa.php"
    
    override init()
    {
        super.init()
        setObjectName("Data Lista Categorias")
    }
    
    func get(idNegocio: Int, _ cuandoTermineLlamar: @escaping (_ error: Bool) -> ())
    {
        print(objectName,"obtener lista")
        fnCompletionHandler = cuandoTermineLlamar
        processRequest(uri: uriAssembler(path: uriPath, queryItems: ["empresa": idNegocio.toString()] ))
    }
    
    override func processDataAsJson(array: [[String: Any]])
    {
        print(objectName,"procesando JSON")
        
        app.listaCategorias.removeAll()
        
        for item in array
        {
            let categoria = CategoriaData (
                cod: item["codigo"] as! Int,
                desc: item["descripcion"] as! String
            )
            
            app.listaCategorias.append(categoria)
        }
        
        app.listaCategorias = app.listaCategorias.sorted { $0.desc < $1.desc }
        
        finish()
    }
}

class ListaProductosDataController: WebDataControllerBase
{
    let uriPath = "/app/controllers/CargarProductosPorEmpresa.php"
    let imgDownloader = ImageDownloader()
    var idxImage = -1
    
    override init()
    {
        super.init()
        setObjectName("Data Lista Negocios")
        imgDownloader.uriPath = "/productos/fotos/"
    }
    
    func get(_ idEmpresa: Int,_ idCategoria: Int,_ cuandoTermineLlamar: @escaping (_ error: Bool) -> ())
    {
        print(objectName,"obtener lista actualizada")
        fnCompletionHandler = cuandoTermineLlamar
        processRequest(uri: uriAssembler(path: uriPath, queryItems: ["empresa": idEmpresa.toString(), "categoria": idCategoria.toString()] ))
    }
    
    override func processDataAsJson(array: [[String: Any]])
    {
        print(objectName,"procesando JSON")
        
        app.listaProductos.removeAll()
        
        for item in array
        {
            let producto = ProductoData (
                codigo: item["codigo"] as! Int,
                nombre: item["descripcion"] as! String,
                precio: (item["precio"] as! NSString).doubleValue,
                imagen: item["imagen"] as! String
            )
            
            app.listaProductos.append(producto)
        }
        
        app.listaProductos = app.listaProductos.sorted { $0.nombre < $1.nombre }
        
        getLogos()
    }
    
    private func getLogos()
    {
        idxImage += 1
        
        if idxImage < app.listaProductos.count
        {
            let producto = app.listaProductos[idxImage]
            print(objectName,"[ \(idxImage+1) de \(app.listaProductos.count) ] obtener logo de < \(producto.nombre) >")
            imgDownloader.get(fileName: producto.imagen, nextLogo)
        }
        else
        {
            idxImage = -1
            print(objectName,"operaciones finalizadas, llamando a la funcion de completado")
            finish()
        }
    }

    @objc private func nextLogo(anteriorConError: Bool)
    {
        if anteriorConError
        {
            print(objectName,"error al obtener el logo de < \(app.listaProductos[idxImage].nombre) >")
        }
        
        getLogos()
    }
}

class PedidoDataController: WebDataControllerBase
{
    let uriPathReg = "/app/controllers/RegistrarNuevoPedido.php"
    let uriPathAdd = "/app/controllers/RegistrarPedidoDetalle.php"
    var modoRetornoIdPedido: Bool = true
    
    private(set) var lastId: Int = -1
    
    override init()
    {
        super.init()
        setObjectName("Pedido")
    }
    
    func registrar(_ nombre: String, _ direccion: String, _ telefono: String, _ handler:  @escaping (_ fail: Bool) -> ())
    {
        lastId = -1
        fnCompletionHandler = handler
        modoRetornoIdPedido = true
        processRequest(uri: uriAssembler(path: uriPathReg, queryItems: ["nombre": nombre, "direccion": direccion, "telefono": telefono] ))
    }
    
    func anhadir(_ idPedido: Int,
                 _ posItem: Int, _ codProducto: Int, _ cantidad: Int, _ precio: Double, _ totalPrecio: Double,
                 _ handler: @escaping (_ fail: Bool) -> ())
    {
        fnCompletionHandler = handler
        modoRetornoIdPedido = false
        processRequest(uri: uriAssembler(path: uriPathAdd, queryItems: ["pedido": idPedido.toString(),
                                                                        "item": posItem.toString(),
                                                                        "producto": codProducto.toString(),
                                                                        "cantidad": cantidad.toString(),
                                                                        "precio": precio.toString(),
                                                                        "total": totalPrecio.toString()] ))
    }
    
    override func processDataAsJson(object: [String : Any])
    {
        if modoRetornoIdPedido
        {
            print(objectName,"procesando retorno de fn: registrar")
            
            guard let id: Int = object["codigo"] as? Int else
            {
                print(objectName,"error, el campo <codigo> no existe en el json o no puede se convertido a entero")
                finish(error: true)
                return
            }
            
            self.lastId = id
            finish()
        }
        else
        {
            print(objectName,"procesando retorno de fn: anhadir")
            
            print("keys: \(object.keys)")
            
            finish()
        }
    }
}




