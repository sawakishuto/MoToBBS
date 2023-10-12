//
//  dataviewmodel.swift
//  MoToBBC
//
//  Created by 澤木柊斗 on 2023/04/19.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import SwiftUI
import UIKit
// swiftlint:disable type_body_length
// swiftlint:disable line_length
// swiftlint:disable identifier_name
// swiftlint:disable function_parameter_count
class ViewModel: ObservableObject {
    @Published var image: Image?
    var arrayData: [String] = []
    @Published var images: Image?
    @Published var eventidinfo = [Eventidmodel]()
    @Published var datamodeluser = [Usersinfo]()
    @Published var userInfo = [User]()
    @Published var userInfo2 = [User]()
    let dataDesctiption: String
    let user = Auth.auth().currentUser
    @Published var datamodel = [Events]()
    private var db = Firestore.firestore()
    @Published var documentId: String?
    init() { self.dataDesctiption = "今日は" }
    //    ツーリング終了ボタン（投稿者側）が押された時に参加者リストを削除
    func AttendListclear(eventid: String) {
        let docRef = db.collection("AttendList").document(eventid)
        docRef.delete { error in
            if let error = error {
                print("ドキュメントの削除エラー：\(error.localizedDescription)")
            } else {
                print("ドキュメントが正常に削除されました。")
            }
        }
    }
    //    AttendlistからUser情報を取得
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
    //    Eventコレクションからデータを取得
    func fetchData() {
        db.collection("Event").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents
            else {
                print("No documents")
                return
            }
            self.datamodel = documents.map {(queryDocumentSnapshot) -> Events in
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
                return Events(
                    eventid: eventid,
                    userid: userid,
                    title: title,
                    whereis: whereis,
                    dateEvent: dateEvent,
                    participants: participants,
                    detail: detail,
                    how: how
                )
            }
        }
    }
    //    ログインしているユーザがどのようなイベントを募集しているかを取得
    func getUser() {
        self.datamodeluser.removeAll()        // データベースクエリを実行する前に、既にデータがロードされている場合は処理を中断する
        guard self.datamodeluser.isEmpty else {
            return
        }
        db.collection("Event").document(user!.uid).getDocument { (_snapshot, error) in
            if let error = error {
                fatalError("\(error)")
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
            let user = Usersinfo(
                eventid: eventid,
                userid: userid,
                title: title,
                whereis: whereis,
                dateEvent: dateEvent,
                participants: participants,
                detail: detail,
                how: how
            )
            self.datamodeluser.append(user)
        }
    }
    //    ログインしているユーザの情報を取得
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
    // 参加するボタンを押した時、押したユーザのUser情報を取得してAttendlistコレクションに情報を格納
    func GetUserInfoAndSet(userid: String, username: String, usercomment: String, bikename: String, documentinfo: String) {
        let documentID = db.collection("User").document(user!.uid).documentID
        // db.collection("User").document(user!.uid)からユーザーデータを取得
        db.collection("User").document(user!.uid).getDocument { (userSnapshot, userError) in
            if let userError = userError {
                fatalError("\(userError)")
            }
            guard let userData = userSnapshot?.data() else {
                return
            }
            let userid = documentID
            let username = userData["usersname"] as? String ?? ""
            let usercomment = userData["usercomment"] as? String ?? ""
            let bikename = userData["bikename"] as? String ?? ""
            let user = User(userid: userid, username: username, usercomment: usercomment, bikename: bikename)
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
                            "userid": user.userid,
                            "username": "\( user.username)",
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
                            "userid": user.userid,
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
                        "userid": user.userid,
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
    // 上に同じ関数だが、投稿者は（主催者）という文字を名前に追加して格納する
    func GetUserInfoAndSet2(userid: String, username: String, usercomment: String, bikename: String) { // db.collection("User").document(user!.uid)からユーザーデータを取得
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
                            "username": "\(user.username)(主催者)",
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
                        "username": "\(user.username)(主催者)",
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
    //    自分が参加するボタンを押したイベントを格納
    func addattend(eventid: String) {
        let event: [String: Any] = [
            "eventid": FieldValue.arrayUnion([eventid])
        ]
        db.collection("Attend").document(user!.uid).updateData(event) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated!")
            }
        }
    }
    // 自分が参加する予定のイベントの情報を取得
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
                                //  ドキュメントのデータを処理する
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
                                    let event = Events(
                                        eventid: eventid,
                                        userid: userid,
                                        title: title,
                                        whereis: whereis,
                                        dateEvent: dateEvent,
                                        participants: participants,
                                        detail: detail,
                                        how: how
                                    )
                                    events.append(event)
                                }
                            }
                            group.leave()
                        }
                    }
                    group.notify(queue: .main) {
                        completion(events)
                    }
                }
            }
        }
    }
    // 自分が投稿したイベント内容を格納
    func addDocument(title: String, detail: String, whereis: String, how: String, selectionDate: Date, eventid: String, userid: String, username: String, participants: String) {
        let documentID = db.collection("User").document(user!.uid).documentID
        db.collection("Event").document(user!.uid).setData([
            "username": documentID,
            "detail": detail,
            "title": title,
            "how": how,
            "whereis": whereis,
            "selectionDate": selectionDate,
            // ドキュメントIDを保存する
            "eventid": documentID,
            "userid": documentID,
            "participants": participants
        ])
          {
            err in
            if let err = err {
                print(err)
            } else {
                print("success")
            }
        }
    }
    //    バイクの車種変更時の情報更新
    func profileset(bikename: String) {
        db.collection("User").document(user!.uid).updateData([
            "bikename": bikename
        ])
    }
    //     自分が投稿したイベントを削除
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
    // 自分が参加する予定だったイベントのキャンセルまたは終了時、参加予定のイベントリストから削除
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
    //    参加をキャンセルしたときまたは終了時Attendlistから自分のUser情報を削除
    func findAndDeleteAttendee( documentInfo: String) {
        let userID = db.collection("User").document(user!.uid).documentID
        let docRef = db.collection("AttendList").document(documentInfo)
        docRef.getDocument { (document, error) in
            if let error = error {
                print("Error getting document: \(error)")
            } else {
                if let document = document, document.exists {
                    if var data = document.data(),
                       var attendList = data["attendList"] as? [[String: Any]] {
                        // 一致するuserIDを持つ要素を検索し、削除する
                        for (index, attendee) in attendList.enumerated() {
                            if let attendeeID = attendee["userid"] as? String, attendeeID == userID {
                                attendList.remove(at: index)
                                break
                            }
                        }
                        data["attendList"] = attendList
                        docRef.setData(data) { error in
                            if let error = error {
                                print("Error updating document: \(error)")
                            } else {
                                print("Attendee deleted successfully.")
                            }
                        }
                    } else {
                        print("attendList not found in the document.")
                    }
                } else {
                    print("Document not found.")
                }
            }
        }
    }
    func UploadImage(inputImage: UIImage?) {
        let documentRef = db.collection("User").document(user!.uid)
        // Retrieve the document data
        documentRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let userid = document.data()?["userid"] as? String {
                    print("Your String Field: \(userid)")
                    let storageref = Storage.storage().reference(forURL: "gs://motobbc-19c0a.appspot.com").child(userid)
                    let imageUI = inputImage
                    let data = imageUI!.jpegData(compressionQuality: 0.25)! as NSData
                    storageref.putData(data as Data, metadata: nil) { (data, error) in
                        if error != nil {
                            return
                        }
                    }
                }
            }
        }
    }
    func deleteImage() {
        print("今から削除")
        let documentRef = db.collection("User").document(user!.uid)
        // Retrieve the document data
        documentRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let userid = document.data()?["userid"] as? String {
                    print("Your String Field: \(userid)")
                    let storageref = Storage.storage().reference(forURL: "gs://motobbc-19c0a.appspot.com/" + userid
                    )
                    print(storageref)
                    storageref.delete { error in
                        if let error = error {
                            // An error occurred while deleting the photo
                            print("Failed to delete photo: \(error.localizedDescription)")
                        } else {
                            // Photo deleted successfully
                            print("Photo deleted successfully")
                        }
                    }
                } else {
                    print("失敗1")
                }
            } else {
                print("失敗2")
            }
        }
    }
    func getImage(eventid: String, completion: @escaping (UIImage?) -> Void) {
        let storageref = Storage.storage().reference(forURL: "gs://motobbc-19c0a.appspot.com/\(eventid)")
        storageref.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("画像のダウンロードに失敗しました: \(error.localizedDescription)")
                completion(nil)
            } else if let data = data, let uiImage = UIImage(data: data) {
                completion(uiImage)
            } else {
                print("画像データが見つかりません")
                completion(nil)
            }
        }
    }
    func openGoogleMaps(location: String) {
        if let encodingLocation = location.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: "http://maps.apple.com/?q=\(encodingLocation)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                print("don't install")
            }
        }

    }


}
