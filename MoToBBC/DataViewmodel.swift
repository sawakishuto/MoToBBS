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
    var arrayData: [String] = []
    
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
                let eventid = data["eventid"] as? String ?? ""
                let userid = data["userid"] as? String ?? ""
                let title = data["title"] as? String ?? ""
                let whereis = data["whereis"] as? String ?? ""
                let detail = data["detail"] as? String ?? ""
                let how = data["how"] as? String ?? ""
                let participants = data["participants"] as? String ?? ""
                
                let dateEvent = (data["selectionDate"] as? Timestamp)?.dateValue() ?? Date()
                return Events(eventid:eventid,userid: userid, title: title, whereis: whereis, dateEvent: dateEvent, participants: participants, detail: detail, how: how)
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
                let eventid = datas["eventid"] as? String ?? ""
                let userid = datas["userid"] as? String ?? ""
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
    func addattend(eventid:String){
        let event:[String: Any] = [
            "eventid": FieldValue.arrayUnion([
                eventid
            ])
        ]

        db.collection("Attend").document(user!.uid).updateData(event) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated!")
            }
        }
    }
   func addattendfirst(eventid:String){
       let documentID = db.collection("User").document(user!.uid).documentID
        let event:[String: Any] = [
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
    func fetchJoinedData(completion: @escaping ([Events]) -> Void) {
        db.collection("Attend").document(user!.uid).getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                if let array = data?["eventid"] as? [String] {
                    // 配列データを取得する
                    var events: [Events] = []
                    let group = DispatchGroup()
                    
                    for attend in array {
                        group.enter()
                        self.db.collection("Event").whereField("eventid", isEqualTo: attend).getDocuments { (querySnapshot, error) in
                            if let error = error {
                                print("Error getting documents: \(error)")
                            } else {
                                guard let documents = querySnapshot?.documents else { return }

                                // ドキュメントのデータを処理する
                                for document in documents {
                                    let data = document.data()
                                    let eventid = data["eventid"] as? String ?? ""
                                    let userid = data["userid"] as? String ?? ""
                                    let title = data["title"] as? String ?? ""
                                    let whereis = data["whereis"] as? String ?? ""
                                    let detail = data["detail"] as? String ?? ""
                                    let how = data["how"] as? String ?? ""
                                    let participants = data["participants"] as? String ?? ""
                                    let dateEvent = (data["selectionDate"] as? Timestamp)?.dateValue() ?? Date()

                                    let event = Events(eventid:eventid, userid:userid, title: title, whereis: whereis, dateEvent: dateEvent, participants: participants, detail: detail, how: how)
                                    events.append(event)
                                }
                            }
                            group.leave()
                        }
                    }
                    print(events)
                    group.notify(queue: .main) {
                        completion(events)
                    }
                }
            }
        }
    }
    func addDocument(title: String, detail: String, whereis: String, how: String, selectionDate: Date, eventid: String,userid:String,username:String, participants: String) {
        let documentID = db.collection("User").document(user!.uid).documentID
        db.collection("Event").document(user!.uid).setData([
            "username":documentID,
            "detail": detail,
            "title": title,
            "how": how,
            "whereis": whereis,
            "selectionDate": selectionDate,
            "eventid": documentID, // ドキュメントIDを保存する
            "userid": documentID,
            "participants": participants
        ])
    {
            err in
            if let err = err {
                print("err")
            }else{
                print("success")
            }
        }
    }
}

