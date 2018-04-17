//
//  EditNoteNavigator.swift
//  Mood-Diary
//
//  Created by Mobdev125 on 3/22/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import UIKit
import PopupDialog

protocol EditNoteNavigator {
    func toCalendar()
}

final class DefaultEditNoteNavigator: EditNoteNavigator {
    private let popup: PopupDialog

    init(popup: PopupDialog) {
        self.popup = popup
    }
    
    func toCalendar() {
        popup.dismiss()
    }
}
