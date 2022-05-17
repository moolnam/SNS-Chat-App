//
//  RegisterViewController.swift
//  test01
//
//  Created by KimJongHee on 2022/05/17.
//

import UIKit

class RegisterViewController: UIViewController {
    
    
    //MARK: - UIView
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person")
        imageView.tintColor = UIColor.green
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
    
    private let firstNameField: UITextField = {
        let emailField = UITextField()
        emailField.autocapitalizationType = .none
        emailField.autocorrectionType = .no
        emailField.returnKeyType = .continue
        emailField.layer.cornerRadius = 12
        emailField.layer.borderWidth = 1
        emailField.layer.borderColor = UIColor.black.cgColor
        emailField.placeholder = "이름을 입력하세요"
        emailField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        emailField.leftViewMode = .always
        emailField.backgroundColor = .white
        return emailField
    }()
    
    private let secondNameField: UITextField = {
        let emailField = UITextField()
        emailField.autocapitalizationType = .none
        emailField.autocorrectionType = .no
        emailField.returnKeyType = .continue
        emailField.layer.cornerRadius = 12
        emailField.layer.borderWidth = 1
        emailField.layer.borderColor = UIColor.black.cgColor
        emailField.placeholder = "성을 입력하세요"
        emailField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        emailField.leftViewMode = .always
        emailField.backgroundColor = .white
        return emailField
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원가입", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "회원가입"
        view.backgroundColor = UIColor(named: "RegisterColor")
        
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        
        emailField.delegate = self
        passwordField.delegate = self
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(firstNameField)
        scrollView.addSubview(secondNameField)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(registerButton)
        
        imageView.isUserInteractionEnabled = true
        scrollView.isUserInteractionEnabled = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfilePic))
        
        imageView.addGestureRecognizer(gesture)
    }
    
    //MARK: - viewDidLayoutSubviews
    
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
        
        firstNameField.frame = CGRect(x: paddingSize, y: imageView.bottom+paddingSize, width: widthSize, height: heightSize)
        
        secondNameField.frame = CGRect(x: paddingSize, y: firstNameField.bottom+paddingSize, width: widthSize, height: heightSize)
        
        emailField.frame = CGRect(x: paddingSize, y: secondNameField.bottom+paddingSize, width: widthSize, height: heightSize)
        print(imageView.frame)
        
        passwordField.frame = CGRect(x: paddingSize, y: emailField.bottom+paddingSize, width: widthSize, height: heightSize)
        
        registerButton.frame = CGRect(x: paddingSize, y: passwordField.bottom+100, width: widthSize, height: heightSize)
    }
    
    //MARK: - func
    
    @objc func didTapChangeProfilePic() {
        print("Did tap change profile pic")
        presentPhotoActionSheet()
    }
    
    @objc private func registerButtonTapped() {
        
        firstNameField.resignFirstResponder()
        // 텍스트필드 내려간다.
        secondNameField.resignFirstResponder()
        // 텍스트필드 내려간다.
        emailField.resignFirstResponder()
        // 텍스트필드 내려간다.
        passwordField.resignFirstResponder()
        // 텍스트필드 내려간다.
        
        guard let email = emailField.text,
              let password = passwordField.text,
              let firstName = firstNameField.text,
              let secondName = secondNameField.text,
              !email.isEmpty,
              !password.isEmpty,
              !firstName.isEmpty,
              !secondName.isEmpty,
              password.count > 6 else {
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
    
    
}

//MARK: - UITextFieldDelegate

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            registerButtonTapped()
            
        }
        
        return true
    }
}

//MARK: - UIImagePickerControllerDelegate

extension RegisterViewController: UIImagePickerControllerDelegate {
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "프로필 사진", message: "사진을 골라주세요", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        actionSheet.addAction(UIAlertAction(title: "사진 찍기", style: .default, handler: { [weak self] _ in
            self?.presentCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "사진 선택", style: .default, handler: { [weak self] _ in
            self?.presentPhotoPicker()
        }))
        
        present(actionSheet, animated: true)
        
    }
    
    func presentCamera() {
        
    }
    
    func presentPhotoPicker() {
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
    }
}
