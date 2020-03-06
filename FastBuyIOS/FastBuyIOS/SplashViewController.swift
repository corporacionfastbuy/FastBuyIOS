//
//  SplashViewController.swift
//  FastBuyIOS
//
//  Created by Luis on 3/4/20.
//  Copyright © 2020 CORPORACION FASTBUY S.A.C. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
        
    var timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(statusManager),
                         name: .flagsChanged,
                         object: nil)
        updateUserInterface()
    }
    
    @objc func timerAction(){
        self.performSegue(withIdentifier: "goOpcionLogin", sender: self)
    }
    
    func updateUserInterface() {
        switch Network.reachability.status {
        case .unreachable:
            view.backgroundColor = .red
        case .wwan:
            nextController()
        case .wifi:
            nextController()
            
        }
        print("Reachability Summary")
        print("Status:", Network.reachability.status)
        print("HostName:", Network.reachability.hostname ?? "nil")
        print("Reachable:", Network.reachability.isReachable)
        print("Wifi:", Network.reachability.isReachableViaWiFi)
    }
    @objc func statusManager(_ notification: Notification) {
        updateUserInterface()
    }
    
    func nextController(){
        view.backgroundColor = UIColor(red: 0/255.0, green: 195/255.0, blue: 164/255.0, alpha: 1.0)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: false)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "goOpcionLogin") {
            segue.destination as! OpcionLoginViewController
        }
    }*/

}
