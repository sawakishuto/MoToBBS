//
//  UserEventAttendanceRepositoryProtocol.swift
//  MoToBBS
//
//  Created by 澤木柊斗 on 2024/05/22.
//

import Foundation
import Combine

protocol UserEventAttendanceRepositoryProtocol: AnyObject {
    func getUserEvent(uid: String) -> AnyPublisher<[Events], Error>

    func addAttendEvents(uid: String, eventId: String)

    func deleteAttendEvents(uid: String, eventId: String)
}
