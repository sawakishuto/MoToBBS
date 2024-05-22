//
//  ChatRepositoryProtocol.swift
//  MoToBBS
//
//  Created by 澤木柊斗 on 2024/05/22.
//

import Foundation
import Combine

protocol ChatRepositoryProtocol: AnyObject {
    func addChatCotent(eventId: String, uid: String, content: String)

    func getChatContent(eventId: String, eventId: String) -> AnyPublisher<[Chat], Error>

    func deleteChatContent(eventId: String)


}
