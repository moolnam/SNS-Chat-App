//
//  ViewController.swift
//  test01
//
//  Created by KimJongHee on 2022/05/17.
//

import UIKit
import FirebaseAuth

class ConversationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        DatabaseManager.shared.test()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("View Did Appear")
        super.viewDidAppear(animated)
        
        validateAuth()
        
    }
    
    private func validateAuth() {
        
        if FirebaseAuth.Auth.auth().currentUser == nil {
            // 현재 유저가 로그인 되어 있지 않다면 로그인 뷰 로 넘어가고 유저가 로그인 되어 있다면 현재 지금 있는 뷰로 남아 있는다. 
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true)
            print("Logged In = \(nav)")
        }
        
    }


}

