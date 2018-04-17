//
//  UseCaseProvider.swift
//  RealmPlatform
//
//  Created by Mobdev125 on 3/21/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import Foundation
import Domain
import Realm
import RealmSwift

public final class UseCaseProvider: Domain.UseCaseProvider {
    private let configuration: Realm.Configuration
    
    public init(configuration: Realm.Configuration = Realm.Configuration()) {
        self.configuration = configuration
    }
    
    public func makeCalendarUseCase() -> Domain.CalendarUseCase {
        let repository = Repository<Note>(configuration: configuration)
        return CalendarUseCase(repository: repository)
    }
    
    public func makeDevelopmentUseCase() -> Domain.DevelopmentUseCase {
        let repository = Repository<Note>(configuration: configuration)
        return DevelopmentUseCase(repository: repository)
    }
}
