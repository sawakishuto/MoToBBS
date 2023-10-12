//
//  LoginViewModel.swift
//  MoToBBC
//
//  Created by 澤木柊斗 on 2023/04/28.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
// swiftlint:disable identifier_name
class LoginViewModel: ObservableObject {
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    func adduser(usersname: String, bikename: String, usercomment: String, userid: String, users: String?) {
        db.collection("User").document(users!).setData([
            "userid": db.collection("User").document(user!.uid).documentID,
            "usersname": usersname,
            "usercomment": usercomment,
            "bikename": bikename
        ])
    }
    func addattendfirst() {
        db.collection("Attend").document(user!.uid).setData(["event": ""])
     }
}
