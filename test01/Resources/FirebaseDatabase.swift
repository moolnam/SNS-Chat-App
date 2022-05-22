//
//  FirebaseDatabase.swift
//  test01
//
//  Created by KimJongHee on 2022/05/20.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    // Firebase 데이터베이스에 액세스하기 위한 진입점입니다. `Database.database()`를 호출하여 인스턴스를 얻을 수 있습니다. 데이터베이스의 위치에 액세스하고 데이터를 읽거나 쓰려면 `FIRDatabase.reference()`를 사용합니다.
    
    
    
}

extension DatabaseManager {
    
    public func userExists(with email: String, completion: @escaping ((Bool) -> Void)) {
        
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        // email 안에 . 이 잇다면 - 로 바꿔줌
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        // safeEmail 안에 @ 이 있다면 - 로 바꿔줌
        
        database.child(safeEmail).observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.value as? String != nil else {
                completion(false)
                // 함수가 종료된 후에 실행됨 @escaping
                return
            }
            completion(true)
            // 함수가 종료된 후에 실행됨 @escaping
        })
    }
    
    public func insertUser(with user: ChatAppUser) {
        // 유저가 추가 되면
        database.child(user.safeEmail).setValue([
            "first_name" : user.firstName,
            // 파이어베이스 안에 first_name 이라는 곳에 firstName 이 저장됨
            "last_name" : user.lastName
            // 파이어베이스 안에 last_name 이라는 곳에 lastName 이 저장됨
        ])
        
    }
}

struct ChatAppUser {
    let firstName: String
    let lastName: String
    let emailAdress: String
    //    let profilePictureUrl: String
    
    var safeEmail: String {
        var safeEmail = emailAdress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
}
