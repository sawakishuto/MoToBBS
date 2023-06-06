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
    
    @Published var Eventidinfo = [Eventidmodel]()
    @Published var datamodeluser = [Usersinfo]()
    @Published var userInfo = [User]()
    @Published var userInfo2 = [User]()
    let dataDesctiption:String
    let user = Auth.auth().currentUser
    @Published var datamodel = [Events]()
    
    private var db = Firestore.firestore()
    @Published var documentId : String?
    init(){self.dataDesctiption = "今日は"}
    func AttendListclear(eventid:String){
        let docRef = db.collection("AttendList").document(eventid)
            
            docRef.delete { error in
                if let error = error {
                    print("ドキュメントの削除エラー：\(error.localizedDescription)")
                } else {
                    print("ドキュメントが正常に削除されました。")
                }
            }
        }
    
    func fetchUserInfoFromAttendList(documentinfo: String, completion: @escaping ([[String]]) -> Void) {
        let attendListRef = db.collection("AttendList").document(documentinfo)
        
        attendListRef.getDocument { (snapshot, error) in
            guard let data = snapshot?.data(),
                  let attendList = data["attendList"] as? [[String: Any]] else {
                completion([])
                return
            }
            
            var userInfoArray: [[String]] = []
            
            for userInfo in attendList {
                if let username = userInfo["username"] as? String,
                   let usercomment = userInfo["usercomment"] as? String,
                   let bikename = userInfo["bikename"] as? String {
                    let userInfoArrayElement = [username, usercomment, bikename]
                    userInfoArray.append(userInfoArrayElement)
                }
            }
            
            completion(userInfoArray)
        }
    }

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
    func getUser() {
        self.datamodeluser.removeAll()        // データベースクエリを実行する前に、既にデータがロードされている場合は処理を中断する
        guard self.datamodeluser.isEmpty else {
            return
        }
        
        db.collection("Event").document(user!.uid).getDocument { (_snapshot, error) in
            if let error = error {
                fatalError("\(error)")
                print("だめでした")
            }
            
            guard let datas = _snapshot?.data() else {
                return
            }
            
            let eventid = datas["eventid"] as? String ?? ""
            let userid = datas["userid"] as? String ?? ""
            let title = datas["title"] as? String ?? ""
            let whereis = datas["whereis"] as? String ?? ""
            let detail = datas["detail"] as? String ?? ""
            let how = datas["how"] as? String ?? ""
            let participants = datas["participants"] as? String ?? ""
            let dateEvent = (datas["selectionDate"] as? Timestamp)?.dateValue() ?? Date()
            
            let user = Usersinfo(eventid: eventid, userid: userid, title: title, whereis: whereis, dateEvent: dateEvent, participants: participants, detail: detail, how: how)
            
            self.datamodeluser.append(user)
            
        }
    }
    func fetchUserinfo( completion: @escaping (String, String, String) -> Void) {
        db.collection("User").document(user!.uid).getDocument { (userSnapshot, userError) in
            if let userError = userError {
                fatalError("\(userError)")
            }
            
            guard let userData = userSnapshot?.data() else {
                return
            }
            
            let fetchusername = userData["usersname"] as? String ?? ""
            let fetchusercomment = userData["usercomment"] as? String ?? ""
            let fetchbikename = userData["bikename"] as? String ?? ""
            
            completion(fetchusername, fetchusercomment, fetchbikename)
        }
    }

    func GetUserInfoAndSet(userid: String, username: String, usercomment: String, bikename: String,documentinfo: String){ // db.collection("User").document(user!.uid)からユーザーデータを取得
        db.collection("User").document(user!.uid).getDocument { (userSnapshot, userError) in
            if let userError = userError {
                fatalError("\(userError)")
            }
            
            guard let userData = userSnapshot?.data() else {
                return
            }
            
            let username = userData["usersname"] as? String ?? ""
            let usercomment = userData["usercomment"] as? String ?? ""
            let bikename = userData["bikename"] as? String ?? ""
            
            let user = User(userid: "user!.uid", username: username, usercomment: usercomment, bikename: bikename)
            
            // AttendListドキュメントにアクセス
            let attendListRef = self.db.collection("AttendList").document(documentinfo)
            
            attendListRef.getDocument { (attendListSnapshot, attendListError) in
                if let attendListError = attendListError {
                    fatalError("\(attendListError)")
                }
                
                if let attendListData = attendListSnapshot?.data() {
                    // documentinfoドキュメントが存在する場合
                    if var existingAttendList = attendListData["attendList"] as? [[String: Any]] {
                        // attendListフィールドが既に存在する場合、userInfoを追加する
                        existingAttendList.append([
                            "userid": "",
                            "username":"\( user.username)",
                            "usercomment": user.usercomment,
                            "bikename": user.bikename
                        ])
                        
                        // 更新されたattendListをdocumentinfoドキュメントに保存する
                        attendListRef.updateData(["attendList": existingAttendList]) { error in
                            if let error = error {
                                print("更新エラー: \(error)")
                            } else {
                                print("attendListが更新されました")
                            }
                        }
                    } else {
                        // attendListフィールドが存在しない場合、新たに作成してuserInfoを格納する
                        let newAttendList = [[
                            "userid": "",
                            "username": user.username,
                            "usercomment": user.usercomment,
                            "bikename": user.bikename
                        ]]
                        
                        attendListRef.updateData(["attendList": newAttendList]) { error in
                            if let error = error {
                                print("作成エラー: \(error)")
                            } else {
                                print("attendListが作成されました")
                            }
                        }
                    }
                } else {
                    // documentinfoドキュメントが存在しない場合、新たに作成してuserInfoを格納する
                    let newAttendList = [[
                        "userid": "",
                        "username": user.username,
                        "usercomment": user.usercomment,
                        "bikename": user.bikename
                    ]]
                    
                    attendListRef.setData(["attendList": newAttendList]) { error in
                        if let error = error {
                            print("作成エラー: \(error)")
                        } else {
                            print("attendListが作成されました")
                        }
                    }
                }
            }
        }
        
    }
    func GetUserInfoAndSet2(userid: String, username: String, usercomment: String, bikename: String){ // db.collection("User").document(user!.uid)からユーザーデータを取得
        db.collection("User").document(user!.uid).getDocument { (userSnapshot, userError) in
            if let userError = userError {
                fatalError("\(userError)")
            }
            
            guard let userData = userSnapshot?.data() else {
                return
            }
            
            let username = userData["usersname"] as? String ?? ""
            let usercomment = userData["usercomment"] as? String ?? ""
            let bikename = userData["bikename"] as? String ?? ""
            
            let user = User(userid: "user!.uid", username: username, usercomment: usercomment, bikename: bikename)
            
            // AttendListドキュメントにアクセス
            let attendListRef = self.db.collection("AttendList").document(self.user!.uid)
            
            attendListRef.getDocument { (attendListSnapshot, attendListError) in
                if let attendListError = attendListError {
                    fatalError("\(attendListError)")
                }
                
                if let attendListData = attendListSnapshot?.data() {
                    // documentinfoドキュメントが存在する場合
                    if var existingAttendList = attendListData["attendList"] as? [[String: Any]] {
                        // attendListフィールドが既に存在する場合、userInfoを追加する
                        existingAttendList.append([
                            "userid": "",
                            "username": "\(user.username)(主催者)",
                            "usercomment": user.usercomment,
                            "bikename": user.bikename
                        ])
                        
                        // 更新されたattendListをdocumentinfoドキュメントに保存する
                        attendListRef.updateData(["attendList": existingAttendList]) { error in
                            if let error = error {
                                print("更新エラー: \(error)")
                            } else {
                                print("attendListが更新されました")
                            }
                        }
                    } else {
                        // attendListフィールドが存在しない場合、新たに作成してuserInfoを格納する
                        let newAttendList = [[
                            "userid": "",
                            "username":"\(user.username)(主催者)",
                            "usercomment": user.usercomment,
                            "bikename": user.bikename
                        ]]
                        
                        attendListRef.updateData(["attendList": newAttendList]) { error in
                            if let error = error {
                                print("作成エラー: \(error)")
                            } else {
                                print("attendListが作成されました")
                            }
                        }
                    }
                } else {
                    // documentinfoドキュメントが存在しない場合、新たに作成してuserInfoを格納する
                    let newAttendList = [[
                        "userid": "",
                        "username":"\(user.username)(主催者)",
                        "usercomment": user.usercomment,
                        "bikename": user.bikename
                    ]]
                    
                    attendListRef.setData(["attendList": newAttendList]) { error in
                        if let error = error {
                            print("作成エラー: \(error)")
                        } else {
                            print("attendListが作成されました")
                        }
                    }
                }
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
        
        func deleteDocument() {
            let db = Firestore.firestore()
            let docRef = db.collection("Event").document(user!.uid)
            
            docRef.delete { (error) in
                if let error = error {
                    print("Error removing document: \(error)")
                } else {
                    print("Document successfully removed!")
                }
            }
        }
        func deleteEvent(eventid: String) {
            
            
            let db = Firestore.firestore()
            let docRef = db.collection("Attend").document(user!.uid)
            
            docRef.updateData([
                "eventid": FieldValue.arrayRemove([eventid])
            ]) { (error) in
                if let error = error {
                    print("Error removing event id from array: \(error.localizedDescription)")
                } else {
                    print("Event id successfully removed from array.")
                }
            }
        }
    
        
    }

