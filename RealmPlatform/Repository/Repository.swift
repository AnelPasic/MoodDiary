//
//  Repository.swift
//  Mood-Diary
//
//  Created by Mobdev125 on 3/21/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import RxSwift
import RxRealm

protocol AbstractRepository {
    associatedtype T
    func queryAll() -> Observable<[T]>
    func query(with filter: NSPredicate,
               sortDescriptors: [SortDescriptor]) -> Observable<[T]>
    func save(entity: T) -> Observable<Void>
    func delete(entity: T) -> Observable<Void>
}

final class Repository<T:RealmRepresentable>: AbstractRepository where T == T.RealmType.DomainType, T.RealmType: Object {
    private let configuration: Realm.Configuration
    private let scheduler: RunLoopThreadScheduler
    
    private var realm: Realm {
        return try! Realm(configuration: self.configuration)
    }
    
    init(configuration: Realm.Configuration) {
        self.configuration = configuration
        let name = "no.medon.Mood.Repository"
        self.scheduler = RunLoopThreadScheduler(threadName: name)
        print("File � url: \(RLMRealmPathForFile("default.realm"))")
    }
    
    func queryAll() -> Observable<[T]> {
        return Observable.deferred {
            let realm = self.realm
            let objects = realm.objects(T.RealmType.self)
            
            return Observable.array(from: objects)
                .mapToDomain()
            }
            .subscribeOn(scheduler)
    }
    
    func query(with predicate: NSPredicate,
               sortDescriptors: [SortDescriptor] = []) -> Observable<[T]> {
        return Observable.deferred {
            let realm = self.realm
            let objects = realm.objects(T.RealmType.self).filter(predicate).sorted(by: sortDescriptors)
            
            return Observable.array(from: objects)
                .mapToDomain()
            }
            .subscribeOn(scheduler)
    }
    
    func save(entity: T) -> Observable<Void> {
        return Observable.deferred {
            return self.realm.rx.save(entity: entity)
            }.subscribeOn(scheduler)
    }
    
    func delete(entity: T) -> Observable<Void> {
        return Observable.deferred {
            return self.realm.rx.delete(entity: entity)
            }.subscribeOn(scheduler)
    }
    
}


