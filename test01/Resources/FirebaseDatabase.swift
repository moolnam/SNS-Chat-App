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
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        database.child(safeEmail).observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.value as? String != nil else {
                completion(false)
                return
            }
            completion(true)
        })
    }
    
    public func insertUser(with user: ChatAppUser) {
        // 유저가 추가 되면
        database.child(user.safeEmail).setValue([
            "first_name" : user.firstName,
            "last_name" : user.lastName
        ])
        
    }
}

struct ChatAppUser {
    let firstName: String
    let lastName: String
    let emailAdress: String
    
    var safeEmail: String {
        var safeEmail = emailAdress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
//    let profilePictureUrl: String
}
