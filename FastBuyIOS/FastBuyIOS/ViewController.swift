//
//  ViewController.swift
//  FastBuyIOS
//
//  Created by OMAR on 19/02/20.
//  Copyright © 2020 CORPORACION FASTBUY S.A.C. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var timer  = Timer()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var collectionArr : [String] = ["1","2","3","4"]
    let titles = [("item 1"),("item 2"),("item 3"),("item 4")]
    let images = [UIImage(named: "restaurants"),
                  UIImage(named: "restaurants"),
                  UIImage(named: "restaurants"),
                  UIImage(named: "restaurants")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
    }
    @IBAction func btnNext(_ sender: Any) {
        self.performSegue(withIdentifier: "beforeMaps", sender: self)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemSubcategoria", for: indexPath) as! CollectionViewCell
        
        let cellIndex = indexPath.item
        //de existir botones puedes ocultarlos o mostrarlos usando
        //cell.boton.isHidden = true
        
        cell.imgSubCategoria.image = images[cellIndex]
        cell.lblSubCategoria.text = titles[cellIndex]
        return cell
    }
}

