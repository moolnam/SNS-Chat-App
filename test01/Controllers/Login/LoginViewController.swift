//
//  SecondViewController.swift
//  test01
//
//  Created by KimJongHee on 2022/05/17.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FBSDKLoginKit


class LoginViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "face-logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let emailField: UITextField = {
        let emailField = UITextField()
        emailField.autocapitalizationType = .none
        emailField.autocorrectionType = .no
        emailField.returnKeyType = .continue
        emailField.layer.cornerRadius = 12
        emailField.layer.borderWidth = 1
        emailField.layer.borderColor = UIColor.black.cgColor
        emailField.placeholder = "이메일을 입력하세요"
        emailField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        emailField.leftViewMode = .always
        emailField.backgroundColor = .white
        return emailField
    }()
    
    private let passwordField: UITextField = {
        let passwordField = UITextField()
        passwordField.autocapitalizationType = .none
        passwordField.autocorrectionType = .no
        passwordField.returnKeyType = .done
        passwordField.layer.cornerRadius = 12
        passwordField.layer.borderWidth = 1
        passwordField.layer.borderColor = UIColor.black.cgColor
        passwordField.placeholder = "비밀번호를 입력하세요"
        passwordField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        passwordField.leftViewMode = .always
        passwordField.backgroundColor = .white
        passwordField.isSecureTextEntry = true
        return passwordField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    private let faceBookLoginButton: FBLoginButton = {
        let button = FBLoginButton()
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.permissions = ["public_profile", "email"]
        return button
    }()
    
    
    //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "로그인"
        view.backgroundColor = UIColor(named: "LoginColor")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "회원가입", style: .plain, target: self, action: #selector(didTapRegister))
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        emailField.delegate = self
        passwordField.delegate = self
        faceBookLoginButton.delegate = self
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(loginButton)
        scrollView.addSubview(faceBookLoginButton) // 페이스북 로그인 버튼
        
        
    }
    
    //MARK: - func
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        
        let size = view.wigth/3
        let paddingSize = view.wigth/20
        let widthSize = view.wigth - paddingSize * 2
        let heightSize = view.height/15
        
        imageView.frame = CGRect(x: (scrollView.wigth-size)/2,
                                 y: 20,
                                 width: size,
                                 height: size)
        emailField.frame = CGRect(x: paddingSize, y: imageView.bottom+paddingSize, width: widthSize, height: heightSize)
        print(imageView.frame)
        
        passwordField.frame = CGRect(x: paddingSize, y: emailField.bottom+paddingSize, width: widthSize, height: heightSize)
        
        loginButton.frame = CGRect(x: paddingSize, y: passwordField.bottom+20, width: widthSize, height: heightSize)
        
        faceBookLoginButton.frame = CGRect(x: paddingSize, y: loginButton.bottom+100, width: widthSize, height: heightSize)
    }
    
    @objc private func loginButtonTapped() {
        
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let email = emailField.text, let password = passwordField.text, !email.isEmpty, !password.isEmpty, password.count > 6 else {
            alertUserLoginError()
            return
        }
        
        //MARK: - Firebase Log In
        // Firebase Lon in
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            
            guard let strongSelf = self else {
                // strongSelf 는 LoginViewController 를 가지고 있다
                return
            }
            
            guard let result = authResult, error == nil else {
                print("Failed to log in user with email : \(email)")
                return
            }
            let user = result.user
            print("Logged In User : \(user)")
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func alertUserLoginError() {
        print("Error \(emailField), \(passwordField)")
        let alert = UIAlertController(title: "오류", message: "다시 확인해 주세요", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "닫기", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
    
    
    
    @objc private func didTapRegister() {
        print("Did Tap Register Clicked")
        let vc = RegisterViewController()
        vc.title = "계정 만들기"
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
            // emailField 에 있다면 키보드를 유지시키고
        }
        else if textField == passwordField {
            loginButtonTapped()
            // passwordfield 에 있다면 loginButtonTapped() 메소드를 실행 시킨다.
            // loginButtonTapped 안에 있는 resignFirstResponder() 각각 텍스트필드에 있는 키보드를 전체 내리게 한다.
        }
        return true
    }
}


extension LoginViewController: LoginButtonDelegate {
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        // no operation
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard let token = result?.token?.tokenString else {
            print("User failed to log in with FaceBook")
            return
        }
        
        let facebookRequest = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields" : "email, name"], tokenString: token, version: nil ,httpMethod: .get)
        
        facebookRequest.start { _, result, error in
            guard let result = result as? [String : Any], error == nil else {
                print("Failed to make facebook graph request")
                return
            }
            print("\(result)")
            
            guard let userName = result["name"] as? String,
                  let email = result["email"] as? String else {
                // result 에 있는 ["email"] 값을 String 으로 변환
                // result 에 있는 ["name"] 값을 String 으로 변환
                print("field to get name and email from fb result")
                return
            }
            
            let nameComponents = userName.components(separatedBy: "")
            guard nameComponents.count == 2 else {
                return
            }
            
            let firstName = nameComponents[0]
            let lastName = nameComponents[1]
            
            DatabaseManager.shared.userExists(with: email, completion: { exists in
                if !exists {
                    DatabaseManager.shared.insertUser(with: ChatAppUser(firstName: firstName,
                                                                        lastName: lastName,
                                                                        emailAdress: email))
                }
            })
            
            let credential = FacebookAuthProvider.credential(withAccessToken: token)
            
            FirebaseAuth.Auth.auth().signIn(with: credential, completion: { [weak self] authResult, error in
                
                guard let strongSelf = self else {
                    return
                }
                
                guard authResult != nil, error == nil else {
                    if let error = error {
                        print("FaceBook credential log in Falied : \(error)")
                    }
                    return
                }
                print("Successfully logged uesr in")
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            })
        }
        
    }
    
    
}
