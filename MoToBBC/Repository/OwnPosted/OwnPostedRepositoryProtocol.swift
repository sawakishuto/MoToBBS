//
//  OwnPostedRepositoryProtocol.swift
//  MoToBBS
//
//  Created by 澤木柊斗 on 2024/05/22.
//

import Foundation
import Combine

protocol OwnPostedRepositoryProtocol: AnyObject {
    func getOwnPosted(uid: String) -> AnyPublisher<[Events], Error>

    func addOwnPosted(uid: String, eventId: String)

    func deleteOwnPosted(uid: String, eventId: String)

    
}
