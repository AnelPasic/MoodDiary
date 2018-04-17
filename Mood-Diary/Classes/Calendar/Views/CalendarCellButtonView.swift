//
//  CalendarCellButtonView.swift
//  Mood-Diary
//
//  Created by Mobdev125 on 3/20/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import UIKit
import Domain

enum ButtonType: Int {
    case completed1 = 1
    case completed2 = 2
    case completed3 = 3
    case completed4 = 4
    case completed5 = 5
    case adding = -2
    case deleted = -3
    case notCompleted = -1
    case none = 0
}

protocol CalendarCellButtonViewDelegate {
    func refresh()
    func updatedNote()
}

class CalendarCellButtonView: CalendarCellView {
    var delegate: CalendarCellButtonViewDelegate?

    fileprivate(set) var button = UIButton(type: .custom)
    
    var note: Note! {
        didSet {
            guard let note = self.note, let buttonType = ButtonType.init(rawValue: note.complete) else {
                return
            }
            self.type = buttonType
        }
    }
    
    var index: Int = 0
    var type: ButtonType = .none {
        didSet {
            self.updateButton()
        }
    }
    
    private func updateButton() {
        button.transform = CGAffineTransform.identity
        if type == .notCompleted {
            let image = #imageLiteral(resourceName: "icon_note").withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            button.setImage(image, for: .normal)
            if isPast() {
                button.tintColor = Constants.pastColor
            }
            else {
                button.tintColor = Constants.futureColor
            }
        }
        else if type == .adding {
            button.setImage(#imageLiteral(resourceName: "icon_add"), for: .normal)
        }
        else if type == .deleted {
            button.setImage(#imageLiteral(resourceName: "icon_add"), for: .normal)
            button.transform = CGAffineTransform.init(rotationAngle: .pi / 4)
        }
        else if type == .none {
            button.setImage(nil, for: .normal)
        }
        else {
            let image = UIImage(named: "icon_smile\(type.rawValue)")?.withRenderingMode(.alwaysTemplate)
            button.setImage(image, for: .normal)
            button.tintColor = Constants.completedColors[type.rawValue - 1]
        }
    }
    
    func isPast() -> Bool {
        return Date.isPast(year: note.year, weekOfYear: note.week, weekDay: note.weekDay, index: note.index)
    }
    
    init(_ date: Date, _ index: Int, _ delegate: CalendarCellButtonViewDelegate) {
        super.init(frame: .zero)
        self.index = index
        self.delegate = delegate
        updateButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutView() {
        super.layoutView()
        
        button = UIButton(type: .custom)
        button.backgroundColor = UIColor.clear
        addSubview(button)
        
        button.addTarget(self, action: #selector(handleButton(_:)), for: .touchUpInside)
        layoutButton()
    }
    
    func layoutButton() {
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: self.topAnchor),
            button.widthAnchor.constraint(equalTo: self.widthAnchor),
            button.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            button.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
    }
    
    @objc func handleButton(_ sender: UIButton) {
        if index == 0 {
            return
        }
        
        if delegate != nil {
            delegate?.refresh()
        }
        
        if note.complete == ButtonType.none.rawValue || note.complete == ButtonType.deleted.rawValue || note.complete == ButtonType.adding.rawValue {
            note = Note(uid: note.uid, year: note.year, week: note.week, weekDay: note.weekDay, index: note.index, desc: "", complete: ButtonType.adding.rawValue)
            DefaultCalendarNavigator.shared.editNote(noteCell: self, isNew: true)
        }
        else {
            DefaultCalendarNavigator.shared.editNote(noteCell: self, isNew: false)
        }
    }
    
    func updateNote(_ note: Note) {
        self.note = note
        if delegate != nil {
            delegate?.updatedNote()
        }
    }
    func deleteNote() {
        self.note = nil
        if delegate != nil {
            delegate?.updatedNote()
        }
    }
    func closedEditNote() {
        if type == .adding {
            
        }
    }
    deinit {
        button.removeFromSuperview()
    }
}
