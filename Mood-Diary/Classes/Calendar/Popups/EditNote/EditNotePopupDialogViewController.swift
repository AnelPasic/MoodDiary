//
//  ActivityPopupDialogViewController.swift
//  Mood-Diary
//
//  Created by Mobdev125 on 3/21/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Domain

class EditNotePopupDialogViewController: UIViewController {

    private let disposeBag = DisposeBag()
    
    var viewModel: EditNotePopupViewModel! {
        didSet {
            bindViewModel()
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var completeButtons: [CompleteButton]!
    @IBOutlet var smileImageViews: [UIImageView]!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var actionContainerView: UIStackView!
    @IBOutlet weak var saveButton: CircleButton!
    @IBOutlet weak var deleteButton: CircleButton!
    @IBOutlet weak var newSaveButton: CircleButton!
    @IBOutlet weak var completeView: UIView!
    
    @IBOutlet weak var completeViewBottomConstraint: NSLayoutConstraint!
    var selectedCompleteButton: CompleteButton?
    var complete: Int = 5
    var rx_complete = PublishSubject<Int>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for i in 0..<smileImageViews.count {
            if let image = smileImageViews[i].image {
                smileImageViews[i].image = image.withRenderingMode(.alwaysTemplate)
                smileImageViews[i].tintColor = Constants.completedColors[i]
            }
        }
    }
    
    func bindViewModel() {
        assert(viewModel != nil)
        
        let input = EditNotePopupViewModel.Input(desc: textView.rx.text.orEmpty.asDriver(),
                                                 complete: rx_complete.asDriverOnErrorJustComplete(),
                                                 saveTrigger: Driver.merge(saveButton.rx.tap.asDriver(), newSaveButton.rx.tap.asDriver()),
                                                 deleteTrigger: deleteButton.rx.tap.asDriver(),
                                                 closeTrigger: closeButton.rx.tap.asDriver())
        
        let output = viewModel.transform(input: input)
        
        [output.past.drive(pastBinding),
         output.canSave.drive(saveButton.rx.isEnabled),
         output.dismiss.drive(),
         output.note.asObservable().take(1).asDriverOnErrorJustComplete().drive(noteBinding),
         output.save.drive(),
         output.error.drive(errorBinding),
         output.isExist.drive(isExistBinding)]
            .forEach({ $0.disposed(by: disposeBag) })
        
        viewModel.checkPast()
        viewModel.checkNewNote()
        rx_complete.onNext(complete)
    }
    
    var isExistBinding: Binder<Bool> {
        return Binder(self, binding: { (vc, isExist) in
            if isExist {
                vc.actionContainerView.isHidden = false
                vc.newSaveButton.isHidden = true
            }
            else {
                vc.actionContainerView.isHidden = true
                vc.newSaveButton.isHidden = false
            }
        })
    }
    var pastBinding: Binder<Bool> {
        return Binder(self, binding: { (vc, isPast) in
            vc.completeView.isHidden = !isPast
            if vc.completeViewBottomConstraint != nil {
                vc.completeViewBottomConstraint.isActive = false
            }
            if isPast {
                vc.completeViewBottomConstraint = vc.completeView.bottomAnchor.constraint(equalTo: vc.saveButton.topAnchor, constant: -8)
                vc.completeViewBottomConstraint.isActive = true
                if vc.selectedCompleteButton == nil {
                    vc.selectedComplete(vc.completeButtons.last!)
                }
            }
        })
    }
    var noteBinding: Binder<Note> {
        return Binder(self, binding: { (vc, note) in
            vc.textView.text = note.desc
            if vc.selectedCompleteButton == nil {
                let completeButton = vc.completeButtons.filter{ $0.number == note.complete }
                if completeButton.count == 1 {
                    completeButton[0].isSelectedComplete = true
                    vc.selectedCompleteButton = completeButton[0]
                }
            }
        })
    }
    
    var errorBinding: Binder<Error> {
        return Binder(self, binding: { (vc, _) in
            let alert = UIAlertController(title: "Save Error",
                                          message: "Something went wrong",
                                          preferredStyle: .alert)
            let action = UIAlertAction(title: "Dismiss",
                                       style: UIAlertActionStyle.cancel,
                                       handler: nil)
            alert.addAction(action)
            vc.present(alert, animated: true, completion: nil)
        })
    }
}

extension EditNotePopupDialogViewController: CompleteButtonDelegate {
    func selectedComplete(_ button: CompleteButton) {
        if selectedCompleteButton == button {
            button.isSelectedComplete = !button.isSelectedComplete
            selectedCompleteButton = nil
            complete = 0
            rx_complete.onNext(complete)
            return
        }
        button.isSelectedComplete = true
        selectedCompleteButton?.isSelectedComplete = false
        selectedCompleteButton = button
        complete = button.number
        rx_complete.onNext(complete)
    }
}
