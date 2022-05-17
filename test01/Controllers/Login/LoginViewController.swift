//
//  SecondViewController.swift
//  test01
//
//  Created by KimJongHee on 2022/05/17.
//

import UIKit

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

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "로그인"
        view.backgroundColor = UIColor(named: "LoginColor")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "회원가입", style: .plain, target: self, action: #selector(didTapRegister))
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        emailField.delegate = self
        passwordField.delegate = self
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(loginButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        
        let size = view.wigth/3
        let size2 = view.height/2
        let paddingSize = view.wigth/20
        let widthSize = view.wigth - paddingSize * 2
        let heightSize = view.height/15
        print(size)
        print(size2)
        imageView.frame = CGRect(x: (scrollView.wigth-size)/2,
                                 y: 20,
                                 width: size,
                                 height: size)
        emailField.frame = CGRect(x: paddingSize, y: imageView.bottom+paddingSize, width: widthSize, height: heightSize)
        print(imageView.frame)
        
        passwordField.frame = CGRect(x: paddingSize, y: emailField.bottom+paddingSize, width: widthSize, height: heightSize)
        
        loginButton.frame = CGRect(x: paddingSize, y: passwordField.bottom+100, width: widthSize, height: heightSize)
    }
    
    @objc private func loginButtonTapped() {
        guard let email = emailField.text, let password = passwordField.text, !email.isEmpty, !password.isEmpty, password.count > 6 else {
            alertUserLoginError()
            return
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

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            loginButtonTapped()
        }
        return true
    }
}
