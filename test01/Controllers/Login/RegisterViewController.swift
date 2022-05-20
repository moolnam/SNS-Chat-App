//
//  RegisterViewController.swift
//  test01
//
//  Created by KimJongHee on 2022/05/17.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RegisterViewController: UIViewController {
    
    
    //MARK: - UIView
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.crop.circle.badge.plus")
        imageView.tintColor = UIColor.green
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.green.cgColor
        return imageView
    }()
    
    private let firstNameField: UITextField = {
        let firstNameField = UITextField()
        firstNameField.autocapitalizationType = .none
        firstNameField.autocorrectionType = .no
        firstNameField.returnKeyType = .continue
        firstNameField.layer.cornerRadius = 12
        firstNameField.layer.borderWidth = 1
        firstNameField.layer.borderColor = UIColor.black.cgColor
        firstNameField.placeholder = "이름을 입력하세요"
        firstNameField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        firstNameField.leftViewMode = .always
        firstNameField.backgroundColor = .white
        return firstNameField
    }()
    
    private let lastNameField: UITextField = {
        let lastNameField = UITextField()
        lastNameField.autocapitalizationType = .none
        lastNameField.autocorrectionType = .no
        lastNameField.returnKeyType = .continue
        lastNameField.layer.cornerRadius = 12
        lastNameField.layer.borderWidth = 1
        lastNameField.layer.borderColor = UIColor.black.cgColor
        lastNameField.placeholder = "성을 입력하세요"
        lastNameField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        lastNameField.leftViewMode = .always
        lastNameField.backgroundColor = .white
        return lastNameField
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
        view.backgroundColor = UIColor(named: "LoginColor")
        
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        
        emailField.delegate = self
        passwordField.delegate = self
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(firstNameField)
        scrollView.addSubview(lastNameField)
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
        imageView.layer.cornerRadius = imageView.wigth/2
        
        firstNameField.frame = CGRect(x: paddingSize, y: imageView.bottom+paddingSize, width: widthSize, height: heightSize)
        
        lastNameField.frame = CGRect(x: paddingSize, y: firstNameField.bottom+paddingSize, width: widthSize, height: heightSize)
        
        emailField.frame = CGRect(x: paddingSize, y: lastNameField.bottom+paddingSize, width: widthSize, height: heightSize)
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
        lastNameField.resignFirstResponder()
        // 텍스트필드 내려간다.
        emailField.resignFirstResponder()
        // 텍스트필드 내려간다.
        passwordField.resignFirstResponder()
        // 텍스트필드 내려간다.
        
        guard let email = emailField.text,
              let password = passwordField.text,
              let firstName = firstNameField.text,
              let lastName = lastNameField.text,
              !email.isEmpty,
              !password.isEmpty,
              !firstName.isEmpty,
              !lastName.isEmpty,
              password.count > 6 else {
            alertUserLoginError()
            return
        }
        
        // Firebase Login
        
        DatabaseManager.shared.userExists(with: email) { [weak self] exist in
            print("만약 이미 이메일 계정이 있다면")
            
            guard let strongSelf = self else {
                // strongSelf 는 RegisterViewController 를 가지고 있다.
                return
            }
            
            guard !exist else {
                strongSelf.alertUserLoginError(message: "이미 계정 있음")
                print("이미 계정 있음")
                // 이미 사용자 존재
                return
            }
            
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { authResult, error in
                print("파이어 베이스 계정 생성")
                
                guard authResult != nil, error == nil else {
                    print("파이어 베이스 계정 생성 안됨")
                    return
                }
                
                DatabaseManager.shared.insertUser(with: ChatAppUser(
                    firstName: firstName,
                    lastName: lastName,
                    emailAdress: email))
                
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            })
        }
        
        
    }
    
    func alertUserLoginError(message: String = "다시 확인해 주세요") {
        print("Error \(emailField), \(passwordField)")
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
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

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "프로필 사진", message: "사진을 골라주세요", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        actionSheet.addAction(UIAlertAction(title: "사진 찍기", style: .default, handler: { [weak self] _ in
            self?.presentCamera()
            // 사진 찍기 함수
        }))
        
        actionSheet.addAction(UIAlertAction(title: "사진 선택", style: .default, handler: { [weak self] _ in
            self?.presentPhotoPicker()
            // 사진앱 함수
        }))
        
        present(actionSheet, animated: true)
        
    }
    
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            // info 안에 Image가 있으면 자식인 UIImage 로 형변환하고 값이 있으면 selectedImage 안에 넣고 값이 없으면 리턴된다. 그러므로 seletedImage 는 UIImage 타입이다.
            return
        }
        self.imageView.image = selectedImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
