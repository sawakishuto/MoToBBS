//
//  LoginViewModel.swift
//  MoToBBC
//
//  Created by 澤木柊斗 on 2023/04/28.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class LoginViewModel :ObservableObject{
    func adduser(usersname:String,bikename:String,usercomment:String,userid:String){
        let user = Auth.auth().currentUser
        let db = Firestore.firestore()
        db.collection("User").document(user!.uid).setData([
            "userid":db.collection("User").document(user!.uid),
            "usersname":usersname,
            "usercomment":usercomment,
            "bikename":bikename
        ])
    }

}

