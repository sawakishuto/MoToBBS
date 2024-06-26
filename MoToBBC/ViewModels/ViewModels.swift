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
import FirebaseDatabase
import Observation
// swiftlint:disable type_body_length
// swiftlint:disable line_length
// swiftlint:disable identifier_name
// swiftlint:disable function_parameter_count
@Observable final class ViewModels: ObservableObject {
     var eventExists: Bool = false
     var tutorialOpen: Bool = false
     var blockedList: [String] = []
     var attendList: [String] = []
     var image: Image?
     var ChatList: [Chat] = []
     var arrayData: [String] = []
     var images: Image?
     var eventidinfo = [Eventidmodel]()
     var datamodeluser = [Usersinfo]()
     var userInfo = [User]()
     var userInfo2 = [User]()
     var qestion: Bool = false
     let user = Auth.auth().currentUser
     var datamodel = [Events]()
     var isLogin = false
    private var db = Firestore.firestore()
     var documentId: String?

    //   この辺の作業は全部Modelの仕事だった。。。
    //　今後大量のリファクタリングをして頑張ってMVVMにしたい

    //    ツーリング終了ボタン（投稿者側）が押された時に参加者リストを削除
    func getLoginUserCollectionDocId() -> String {
        return db.collection("User").document(user!.uid).documentID
    }
    func getLoginUserEventCollectionDocId() -> String {
        return db.collection("Event").document(user!.uid).documentID
    }
    func getLoginUserCollectionDocRef() -> DocumentReference {
        return db.collection("User").document(user!.uid)
    }
    func getLoginUserEventCollectionDocRef() -> DocumentReference {
        return db.collection("Event").document(user!.uid)
    }
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
                if let userid = userInfo["userid"] as? String,
                    let username = userInfo["username"] as? String,
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

    func fetchEvntList() {
        db.collection("Event").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents
            else {
                print("No documents")
                return
            }
            self.datamodel = documents.map {
                (queryDocumentSnapshot) -> Events in
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
                let endTime = (data["endTime"] as? Timestamp)?.dateValue() ?? Date()
                return Events(
                    eventid: eventid,
                    userid: userid,
                    title: title,
                    whereis: whereis,
                    dateEvent: dateEvent,
                    endTime: endTime,
                    participants: participants,
                    detail: detail,
                    how: how
                )
            }
            self.datamodel = self.datamodel.filter({ value in
                return !self.blockedList.contains(value.userid)
            })
        }

    }
    //    ログインしているユーザがどのようなイベントを募集しているかを取得
    func getUser() {
        self.datamodeluser.removeAll()        // データベースクエリを実行する前に、既にデータがロードされている場合は処理を中断する
        guard self.datamodeluser.isEmpty else {
            return
        }
        let loginUserEventCollectionDocRef = getLoginUserEventCollectionDocRef()
        loginUserEventCollectionDocRef.getDocument { (_snapshot, error) in
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
            let endTime = (datas["endTime"] as? Timestamp)?.dateValue() ?? Date()
            let dateEvent = (datas["selectionDate"] as? Timestamp)?.dateValue() ?? Date()
            let user = Usersinfo(
                eventid: eventid,
                userid: userid,
                title: title,
                whereis: whereis,
                dateEvent: dateEvent,
                endTime: endTime,
                participants: participants,
                detail: detail,
                how: how
            )
            self.datamodeluser.append(user)
        }
    }
    //    ログインしているユーザの情報を取得
    func fetchUserinfo( completion: @escaping (String, String, String) -> Void) {
        let loginUserCollectionDocRef = getLoginUserCollectionDocRef()
        loginUserCollectionDocRef.getDocument { (userSnapshot, userError) in
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
    func GetUserInfoAndSet(documentinfo: String) {
        let loginUserCollectionDocId = getLoginUserCollectionDocId()
        let loginUserCollectionDocRef = getLoginUserCollectionDocRef()
        // db.collection("User").document(user!.uid)からユーザーデータを取得
        loginUserCollectionDocRef.getDocument { (userSnapshot, userError) in
            if let userError = userError {
                fatalError("\(userError)")
            }
            guard let userData = userSnapshot?.data() else {
                return
            }
            let userid = userData["userid"] as? String ?? ""
            let username = userData["usersname"] as? String ?? ""
            let usercomment = userData["usercomment"] as? String ?? ""
            let bikename = userData["bikename"] as? String ?? ""
            if self.user!.uid == documentinfo {
                let user = User(userid: userid, username: "\(username)(主催者)", usercomment: usercomment, bikename: bikename)
                self.setUserInfoInAttendList(documentinfo: documentinfo, user: user)
            } else {
                let user = User(userid: userid, username: username, usercomment: usercomment, bikename: bikename)
                self.setUserInfoInAttendList(documentinfo: documentinfo, user: user)
            }

        }
    }
    func setUserInfoInAttendList(documentinfo: String, user: User) {
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
// ユーザーが現在募集中のイベントがないか確認する
    func comformEvent() -> Bool {
        let loginUserEventCollectionDocRef = getLoginUserEventCollectionDocRef()
        loginUserEventCollectionDocRef.getDocument { (document, error) in
            if let error = error {
                print("\(error)")
                self.eventExists = false
                print("naiyo")
            } else if document!.exists {
                print("ある")
                self.eventExists = true
            } else {
                self.eventExists = false
            }
        }

        return eventExists
    }
    //    自分が参加するボタンを押したイベントを格納
    func addAttend(eventid: String) {
        let event: [String: Any] = [
            "eventid": FieldValue.arrayUnion([eventid])
        ]
        let loginUserAttendCollectionDocRef = db.collection("Attend").document(user!.uid)

        loginUserAttendCollectionDocRef.getDocument { (document, error) in
            if let error = error {
                print("Error fetching document: \(error)")
            } else if document!.exists {
                // UIDに対応するドキュメントが存在する場合、既存のドキュメントを更新
                loginUserAttendCollectionDocRef.updateData(event) { error in
                    if let error = error {
                        print("Error updating document: \(error)")
                    } else {
                        print("Document successfully updated!")
                    }
                }
            } else {
                // UIDに対応するドキュメントが存在しない場合、空のドキュメントを作成
                loginUserAttendCollectionDocRef.setData(event) { error in
                    if let error = error {
                        print("Error creating document: \(error)")
                    } else {
                        print("Document successfully created!")
                    }
                }
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
                                    let endTime = (data["endTime"] as? Timestamp)?.dateValue() ?? Date()
                                    let dateEvent = (data["selectionDate"] as? Timestamp)?.dateValue() ?? Date()
                                    let event = Events(
                                        eventid: eventid,
                                        userid: userid,
                                        title: title,
                                        whereis: whereis,
                                        dateEvent: dateEvent,
                                        endTime: endTime,
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
    func UpdateDocument(title: String, detail: String, whereis: String, how: String)  {
        let loginUserEventCollectionDocRef = getLoginUserEventCollectionDocRef()
             loginUserEventCollectionDocRef.updateData([
                "detail": detail,
                "title": title,
                "how": how,
                "whereis": whereis
            ])
    }

    // 自分が投稿したイベント内容を格納
    func addDocument(title: String, detail: String, whereis: String, how: String, selectionDate: Date, endTime: Date, eventid: String, userid: String, username: String, participants: String) {
        let loginUserCollectionDocId = getLoginUserCollectionDocId()
        db.collection("User").document(user!.uid).getDocument { (userSnapshot, userError) in
            if let userError = userError {
                fatalError("\(userError)")
            }
            guard let userData = userSnapshot?.data() else {
                return
            }
            let username = userData["usersname"] as? String ?? ""
        }
        db.collection("Event").document(user!.uid).setData([
            "username": username,
            "detail": detail,
            "title": title,
            "how": how,
            "whereis": whereis,
            "selectionDate": selectionDate,
            "endTime": endTime,
            // ドキュメントIDを保存する
            "eventid": loginUserCollectionDocId,
            "userid": loginUserCollectionDocId,
            "participants": participants,
            "chat": []
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
        let loginUserCollctionDocId = getLoginUserCollectionDocId()
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
                            if let attendeeID = attendee["userid"] as? String, attendeeID == loginUserCollctionDocId {
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
        let loginUserCollectionDocRef = getLoginUserCollectionDocRef()
        // Retrieve the document data
        loginUserCollectionDocRef.getDocument { (document, error) in
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
        let loginUserCollectionDocRef = getLoginUserCollectionDocRef()
        // Retrieve the document data
        loginUserCollectionDocRef.getDocument { (document, error) in
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
    func GetUserInfomationAndChat(eventid: String, content: String) {
        print(eventid)
        print(content)
        let loginUserCollectionDocRef = getLoginUserCollectionDocRef()
        loginUserCollectionDocRef.getDocument { (getuserSnapshot, getError) in
            if let getError = getError {
                fatalError("\(getError)")
            }
            print("aaaa")
            guard let userData = getuserSnapshot?.data() else {
                print("取得できなかった１")
                return
            }

            let userid = userData["userid"] as? String ?? ""
            let username = userData["usersname"] as? String ?? ""
            let usercomment = userData["usercomment"] as? String ?? ""
            let bikename = userData["bikename"] as? String ?? ""
            let users = User(userid: userid, username: username, usercomment: usercomment, bikename: bikename)

            self.db.collection("Event").document(eventid).updateData([
                "chat": FieldValue.arrayUnion([
                    [
                        "userid": users.userid,
                        "username": users.username,
                        "timeStamp": Date(),
                        "content": content
                    ]
                ])
            ]) { error in
                if let error = error {
                    print("更新エラー: \(error)")
                } else {
                    print("chatが更新されました")
                }
            }
        }

        print("nanana")
    }


    func deleteAccount() {
        let ref = Database.database().reference()
        DispatchQueue.global().async {
            self.db.collection("User").document(self.user!.uid).delete()
            self.db.collection("Attend").document(self.user!.uid).delete()
            self.db.collection("AttendList").document(self.user!.uid).delete()
            self.db.collection("Event").document(self.user!.uid).delete()
        }
        DispatchQueue.main.async {
            let user = Auth.auth().currentUser
            user?.delete { error in
                if let error = error {
                    print("削除に失敗")
                }
                print("削除完了")
                do{
                    try? Auth.auth().signOut()
                } catch {
                    print("失敗")
                }
            }
        }
    }

    func getChatContent(eventid: String, completion: @escaping ([Chat]) -> Void) {
        db.collection("Event").document(eventid).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("Error getting chat content: \(error)")
                completion([]) // エラー時に空のChatリストを返す
                return
            }

            guard let data = snapshot?.data(),
                  let chatData = data["chat"] as? [[String: Any]] else {
                print("Unable to fetch chat data")
                completion([]) // データが取得できない場合も空のChatリストを返す
                return
            }

            let chatList: [Chat] = chatData.map { chat in
                let content = chat["content"] as! String
                let userId = chat["userid"] as! String
                let username = chat["username"] as! String
                let timestamp = (chat["timeStamp"] as? Timestamp)?.dateValue() ?? Date()

                // userId == eventid の場合にtrue、それ以外の場合にfalseを設定
                let isQuestion = userId != eventid

                return Chat(
                    id: UUID().uuidString,
                    name: username,
                    content: content,
                    timeStampString: timestamp,
                    qestion: isQuestion
                )
            }

            completion(chatList)
        }
    }

    func shareOnTwitter(title: String, place: String, date: String, detail: String) {

        //シェアするテキストを作成
        let text = "【MoToBBS】\nツーリング募集\n\(title)\n【集合時間】\(date)\n【集合場所】\(place)\nMoToBBSで詳細を確認！！\nhttps://apps.apple.com/jp/app/motobbs/id6469105461"
        let hashTag = "#ツーリング募集"
        let completedText = text + "\n" + hashTag

        //作成したテキストをエンコード
        let encodedText = completedText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

        //エンコードしたテキストをURLに繋げ、URLを開いてツイート画面を表示させる
        if let encodedText = encodedText,
           let url = URL(string: "https://twitter.com/intent/tweet?text=\(encodedText)") {
            UIApplication.shared.open(url)
        }
    }

}
