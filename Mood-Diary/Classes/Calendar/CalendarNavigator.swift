//
//  CalendarNavigator.swift
//  Mood-Diary
//
//  Created by Mobdev125 on 3/22/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import UIKit

import UIKit
import Domain
import PopupDialog

protocol CalendarNavigator {
    func editNote(noteCell: CalendarCellButtonView, isNew: Bool)
    func toWeek(year: Int, week: Int, weekView: CalendarWeekView)
}

class DefaultCalendarNavigator: CalendarNavigator {
    
    public static var shared: DefaultCalendarNavigator!
    
    private let viewController: UIViewController
    private let useCase: CalendarUseCase
    
    init(useCase: CalendarUseCase,
         viewController: UIViewController) {
        self.useCase = useCase
        self.viewController = viewController
    }
    
    func editNote(noteCell: CalendarCellButtonView, isNew: Bool = false) {
        let noteEditPopupVC = EditNotePopupDialogViewController()
        noteEditPopupVC.complete = noteCell.note.complete
        let popup = PopupDialog.init(viewController: noteEditPopupVC)
        let editNoteViewModel = EditNotePopupViewModel(cellView: noteCell,
                                                       useCase: useCase,
                                                       navigator: DefaultEditNoteNavigator.init(popup: popup),
                                                       isNew: isNew)
        noteEditPopupVC.viewModel = editNoteViewModel
        viewController.present(popup, animated: true, completion: nil)
    }
    
    func toWeek(year: Int, week: Int, weekView: CalendarWeekView) {
        
    }
}


