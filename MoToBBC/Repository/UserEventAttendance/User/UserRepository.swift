//
//  User.swift
//  MoToBBS
//
//  Created by 澤木柊斗 on 2024/05/22.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import Combine

final class UserRepository: UserRepositoryProtocol {
    var fb = Firestore.firestore()
    var auth = Auth.auth()

    func addUser(user: User) {
        let currentUserId: String = auth.currentUser?.uid ?? "000000"
        let docRef = fb.collection("User").document(currentUserId)
        let userData: [String: Any] = [
            "userId": user.userid,
            "userName": user.username,
            "userComment": user.usercomment,
            "bikeName": user.bikename
        ]
        if currentUserId != "000000" {
            docRef.setData(userData) { error in
                print(error!)
            }
        } else {
            print("uidの取得に失敗しました")
        }
    }

    func getUser(uid: String) -> AnyPublisher<User, Error> {
        Deferred {
            Future { promise in
                let docRef = self.fb.collection("User").document(uid)

                docRef.getDocument { user, error in
                    guard let user = user else {promise(.failure(error!))}
                    if let userData = user.data() {
                        let userId = userData["userId"] as? String ?? "データ取得失敗"
                        let userName = userData["userName"] as? String ?? "データ取得失敗"
                        let userComment = userData["userComment"] as? String ?? "データ取得失敗"
                        let bikeName = userData["bikeName"] as? String ?? "データ取得失敗"
                        let user = User(userid: userId, username: userName, usercomment: userComment, bikename: bikeName)
                        promise(.success(user))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }

//    func getUsers() -> AnyPublisher<[User], Error> {
//        <#code#>
//    }


}
