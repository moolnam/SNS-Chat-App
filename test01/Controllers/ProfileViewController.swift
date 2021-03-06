//
//  ProfileViewController.swift
//  test01
//
//  Created by KimJongHee on 2022/05/23.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FBSDKLoginKit
import GoogleSignIn

class ProfileViewController: UIViewController {
    
    
    
    @IBOutlet var tableView: UITableView!
    
    let data = ["log out"]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
    }

}

extension ProfileViewController: UITableViewDelegate {
    
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .red
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let actionSheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "๋ก๊ทธ์์", style: .destructive, handler: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            
            // FaceBook Log Out
            FBSDKLoginKit.LoginManager().logOut()
            // Google Log out
            GIDSignIn.sharedInstance().signOut()
            
            do {
                try FirebaseAuth.Auth.auth().signOut()
                let vc = LoginViewController()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                strongSelf.present(nav, animated: true)
                print("๋ก๊ทธ์์ = \(nav)")
            } catch {
                print("๋ก๊ทธ์์ ์คํจ")
            }
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "์ทจ์", style: .cancel))
        
        present(actionSheet, animated: true)
        
        
    }
    
    
}
