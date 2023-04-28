//
//  dataviewmodel.swift
//  MoToBBC
//
//  Created by 澤木柊斗 on 2023/04/19.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
class ViewModel: ObservableObject{
    let dataDesctiption:String
    let user = Auth.auth().currentUser
    @Published var datamodel = [Events]()
    
    private var db = Firestore.firestore()
    @Published var documentId : String?
    init(){self.dataDesctiption = "今日は"}
    
    func fetchData() {
        db.collection("Event").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents
                    
            else {
                print("No documents")
                return
            }
            
            
            self.datamodel = documents.map{(queryDocumentSnapshot)->Events in
                let data = queryDocumentSnapshot.data()
                //                print(data)
                //                let id = data["id"] as? String ?? ""
                let userid = data["userid"] as? String ?? ""
                let eventid = data["eventid"] as? String ?? ""
                let title = data["title"] as? String ?? ""
                let whereis = data["whereis"] as? String ?? ""
                let detail = data["detail"] as? String ?? ""
                let how = data["how"] as? String ?? ""
                let participants = data["participants"] as? String ?? ""
                
                let dateEvent = (data["selectionDate"] as? Timestamp)?.dateValue() ?? Date()
                return Events(eventid: eventid, userid: userid, title: title, whereis: whereis, dateEvent: dateEvent, participants: participants, detail: detail, how: how)
            }
        }
        
        
        
    }
    func getUser(){
        db.collection("Event").document(user!.uid).getDocument { (_snapshot, error) in
            if let error = error {
                fatalError("\(error)")
                print("だめでした")
            }
            guard let datas = _snapshot?.data()
                    
            else { return }
            self.datamodel = datas.map{(queryDocumentSnapshot)->Events in
                
                //                let id = data["id"] as? String ?? ""
                let userid = datas["userid"] as? String ?? ""
                let eventid = datas["eventid"] as? String ?? ""
                let title = datas["title"] as? String ?? ""
                let whereis = datas["whereis"] as? String ?? ""
                let detail = datas["detail"] as? String ?? ""
                let how = datas["how"] as? String ?? ""
                let participants = datas["participants"] as? String ?? ""
                let dateEvent = (datas["selectionDate"] as? Timestamp)?.dateValue() ?? Date()
                
                return Events(eventid:eventid, userid:userid, title: title, whereis: whereis, dateEvent: dateEvent, participants: participants, detail: detail, how: how)
            }
        }
    }
    func adduser(username:String,bikename:String,usercomment:String){
        db.collection("User").document(user!.uid).setData([
            "username":username,
            "usercomment":usercomment,
            "bikename":bikename
        ])
    }
    
    func addDocument(title:String,detail:String,whereis:String,how:String,selectionDate:Date,eventid:String,participants:String,userid:String){
        db.collection("Event").document(user!.uid).setData( [
            "username":db.collection("User").document(user!.uid),
            "detail":detail,
            "title":title,
            "how":how,
            "whereis":whereis,
            "selectionDate":selectionDate,
            "eventid":db.collection("User").document(user!.uid),
            "userid":db.collection("User").document(user!.uid),
            "participants":participants
        ]){
            err in
            if let err = err {
                print("err")
            }else{
                print("success")
            }
        }
    }
    func addDocumentprofile(usersname:String,bikename:String,usercomment:String,textname:String,title:String,detail:String,whereis:String,how:String,selectionDate:Date){
        db.collection("users").document(user!.uid).setData( [
            "usersname":usersname,
            "bikename":bikename,
            "usercomment":usercomment,
            "textname":textname,
            "detail":detail,
            "title":title,
            "how":how,
            "whereis":whereis,
            "selectionDate":selectionDate
        ]){
            err in
            if let err = err {
                print("err")
            }else{
                print("success")
            }
        }
    }
}

