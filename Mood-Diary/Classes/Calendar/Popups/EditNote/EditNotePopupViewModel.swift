//
//  EditNotePopupViewModel.swift
//  Mood-Diary
//
//  Created by Mobdev125 on 3/22/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import Domain
import RxSwift
import RxCocoa

class EditNotePopupViewModel: ViewModelType {
    private let cellView: CalendarCellButtonView
    private let note: Note
    private let isNew: Bool
    private let useCase: CalendarUseCase
    private let navigator: EditNoteNavigator
    private var past = PublishSubject<Bool>()
    private var exist = PublishSubject<Bool>()
    
    init(cellView: CalendarCellButtonView, useCase: CalendarUseCase, navigator: EditNoteNavigator, isNew: Bool = false) {
        self.cellView = cellView
        self.note = cellView.note
        self.useCase = useCase
        self.navigator = navigator
        self.isNew = isNew
    }
    
    func transform(input: Input) -> Output {
        let errorTracker = ErrorTracker()
        
        let canSave = input.desc.map{ !$0.isEmpty }.startWith(true)
        let descAndComplete = Driver.combineLatest(input.desc, input.complete) { (desc, complete) -> (String, Int) in
            return (desc, complete)
            }.filter{ !$0.0.isEmpty }
        let note = Driver.combineLatest(Driver.just(self.note), descAndComplete) { (note, descAndComplete) -> Note in
            var complete = descAndComplete.1
            if complete <= 0 {
                complete = ButtonType.notCompleted.rawValue
            }
            return Note(uid: note.uid, year: note.year, week: note.week, weekDay: note.weekDay, index: note.index, desc: descAndComplete.0, complete: complete)
        }.startWith(self.note)
        
        let saveNote = input.saveTrigger.withLatestFrom(note)
            .flatMapLatest { note in
                return self.useCase.saveNote(note: note)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
                    .do(onNext: {
                        self.cellView.updateNote(note)
                    })
            }
        
        let deleteNote = input.deleteTrigger.withLatestFrom(note)
            .flatMapLatest { note in
                return self.useCase.deleteNote(note: note)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
                    .do(onNext: {
                        self.cellView.deleteNote()
                    })
        }
        
        let dismiss = Driver.of(saveNote, deleteNote, input.closeTrigger).merge().do(onNext: navigator.toCalendar)
        
        return Output(past: past.asDriverOnErrorJustComplete(),
                      canSave: canSave,
                      dismiss: dismiss,
                      note: note,
                      save: saveNote,
                      error: errorTracker.asDriver(),
                      isExist: exist.asDriverOnErrorJustComplete())
    }
    
    func checkPast() {
        past.onNext(Date.isPast(year: self.note.year, weekOfYear: self.note.week, weekDay: self.note.weekDay, index: self.note.index))
    }
    
    func checkNewNote() {
        exist.onNext(!isNew)
    }
}

extension EditNotePopupViewModel {
    struct Input {
        let desc: Driver<String>
        let complete: Driver<Int>
        let saveTrigger: Driver<Void>
        let deleteTrigger: Driver<Void>
        let closeTrigger: Driver<Void>
    }
    
    struct Output {
        let past: Driver<Bool>
        let canSave: Driver<Bool>
        let dismiss: Driver<Void>
        let note: Driver<Note>
        let save: Driver<Void>
        let error: Driver<Error>
        let isExist: Driver<Bool>
    }
}

