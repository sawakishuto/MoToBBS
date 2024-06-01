//
//  AttendListRepositoryProtocol.swift
//  MoToBBS
//
//  Created by 澤木柊斗 on 2024/05/22.
//

import Foundation
import Combine

protocol AttendListRepositoryProtocol: AnyObject {
    func getAttendReservationEvents(eventId: String) -> AnyPublisher<[User], Error>
    func addUserToAttendList(eventId: String, uid: String, user: User)

    func deleteUserFromAttendList(userId: String, eventId: String)

    func deleteAllUser(eventId: String)

}
