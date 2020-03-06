//
//  AppDelegate.swift
//  Fast_Buy_iOS
//
//  Created by null on 2/28/19.
//  Copyright © 2019 chinchilla. All rights reserved.
//

import UIKit

public struct NegocioData
{
    let codigo: Int
    let nombre: String
    let razon: String
    let logo: String
    let estado: Int
}

public struct CategoriaData
{
    let cod: Int
    let desc: String
}

public struct ProductoData
{
    let codigo: Int
    let nombre: String  // json.descripcion
    let precio: Double
    let imagen: String
}

public struct CarritoItem
{
    let negocio: NegocioData
    let categoria: CategoriaData
    let producto: ProductoData
    var cantidad: Int
    var precio: Double
}

public struct PedidoData
{
    let userDataValid: Bool
    let userNombre: String
    let userDireccion: String
    let userTelefono: String
    
    init()
    {
        self.userDataValid = false
        self.userNombre = ""
        self.userDireccion = ""
        self.userTelefono = ""
    }
    
    init(nombre: String, direccion: String, telefono: String)
    {
        self.userDataValid = true
        self.userNombre = nombre
        self.userDireccion = direccion
        self.userTelefono = telefono
    }
}

public class AppData
{
    var listaNegocios = [NegocioData]()
    var listaCategorias = [CategoriaData]()
    var listaProductos = [ProductoData]()
    var currentNegocio: NegocioData!
    var oldCurrentNegocio: NegocioData = NegocioData(codigo: -1, nombre: "null", razon: "null", logo: "null", estado: 0)
    var currentCategoria: CategoriaData!
    var oldCurrentCategoria: CategoriaData = CategoriaData(cod: -1, desc: "null")
    var carrito = [CarritoItem]()
    var carritoCostoTotal: Double = 0.00
    var minimoCostoEnvio: Double = 3.00
    var currentPedido: PedidoData = PedidoData()
}

public var app = AppData()
public var cache = MediaCache()
public var fileGestor = GestorDeArchivos()
public var dataController = WebDataController()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        print("inicializar directorio de la aplicacion")
        fileGestor.initAppDir()
        //start validar conexion a internet
        do {
            try Network.reachability = Reachability(hostname: "www.google.com")
        }
        catch {
            switch error as? Network.Error {
            case let .failedToCreateWith(hostname)?:
                print("Network error:\nFailed to create reachability object With host named:", hostname)
            case let .failedToInitializeWith(address)?:
                print("Network error:\nFailed to initialize reachability object With address:", address)
            case .failedToSetCallout?:
                print("Network error:\nFailed to set callout")
            case .failedToSetDispatchQueue?:
                print("Network error:\nFailed to set DispatchQueue")
            case .none:
                print(error)
            }
        }
        //end validar conexion a internet
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

