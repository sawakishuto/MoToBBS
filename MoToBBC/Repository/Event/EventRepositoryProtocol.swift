//
//  EventRepositoryProtocol.swift
//  MoToBBS
//
//  Created by 澤木柊斗 on 2024/05/22.
//

import Foundation
import Combine

protocol EventRepository: AnyObject {
    func getEvents() -> AnyPublisher<[Events], Error>

    func addEvent(eventId: String, uid: String, event: Events)

    func deleteEvent(eventid: String, uid: String)

}
