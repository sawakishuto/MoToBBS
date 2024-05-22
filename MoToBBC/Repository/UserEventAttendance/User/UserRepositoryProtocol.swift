//
//  UserRepositoryProtocol.swift
//  MoToBBS
//
//  Created by 澤木柊斗 on 2024/05/22.
//

import Foundation
import Combine

protocol UserRepositoryProtocol: AnyObject {
    func addUser(uid: String, user: User)

    func getUser(uid: String) -> AnyPublisher<User, Error>

    func getUsers() -> AnyPublisher<[User], Error>
    
}
