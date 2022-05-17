//
//  ViewController.swift
//  test01
//
//  Created by KimJongHee on 2022/05/17.
//

import UIKit

class ConversationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("View Did Appear")
        super.viewDidAppear(animated)
        
        let isLoggdIn = UserDefaults.standard.bool(forKey: "Logged In")
        print("Logged In = \(isLoggdIn)")
        
        if !isLoggdIn {
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true)
            print("Logged In = \(nav)")
        }
    }


}

