//
//  FBRepositoryProtocol.swift
//  MoToBBS
//
//  Created by 澤木柊斗 on 2024/05/17.
//

import Foundation

protocol FBRepositoryProtocol: AnyObject {
    func getUserProfile(userId: String, completion: @escaping (Result<User, Error>) ->Void)
    func getUserEvents(userId: String, completion: @escaping(Result<Usersinfo, Error>) -> Void)
    func getEvents(completion: @escaping (Result<[Events], Error>) -> Void)
    func getAttendReservationEvents(uid: String, completion: @escaping (Result<[Events], Error>) -> Void)
        // getUserProfile -> AttendListに保存
    func saveUserProfileToAttendList()
    func getUserInfoFromAttendList(eventId: String, completion: @escaping (Result<[User], Error>) -> Void)
    func saveEventIdToUserEventAttendee(uid: String, eventId: String)
    func getOwnEvents(uid: String, completion: @escaping (Result<[Events], Error>) -> Void)
    func saveOwnEvent(uid: String)
    func postEvent(eventId: String)
    func updateEvents(title: String, detail: String, whereis: String, how: String)
    func updateBikeName(bikeName: String)
    //  attendListとEventどっちも消す
    func deleteEvent(eventId: String)
    func deleteAttendReservationEvent(uid: String)
    func deleteUidFromAttendList(uid: String)
    func uploadProfileImage(data: Data, uid: String)
    func uploadEventImage(data: Data, eventId: String)
    func deleteEventImage(eventId: String)
    func getImage(eventId: String) -> Data
    func deleteAccount(uid: String)
    //TODO　チャットの通信を付け加える
    func getChatContents(eventId: String, completion: @escaping (Result<[Chat], Error>) -> Void)
    func postChatContents(uid: String, eventId: String)
}
