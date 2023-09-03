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
    func adduser(usersname: String, bikename: String, usercomment: String, userid: String) {
        db.collection("User").document(user!.uid).setData([
            "userid": db.collection("User").document(user!.uid).documentID,
            "usersname": usersname,
            "usercomment": usercomment,
            "bikename": bikename
        ])
    }
    func addattendfirst(eventid: String) {
        let documentID = db.collection("User").document(user!.uid).documentID
         let event: [String: Any] = [
             "eventid": FieldValue.arrayUnion([
                 documentID
             ])
         ]

         db.collection("Attend").document(user!.uid).setData(event) { error in
             if let error = error {
                 print("Error updating document: \(error)")
             } else {
                 print("Document successfully updated!")
             }
         }
     }
}
