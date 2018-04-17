//
//  ValuesContentView.swift
//  Mood-Diary
//
//  Created by Mobdev125 on 3/26/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ActiveLabel

class ValuesContentView: BaseContentView {
    
    private let disposeBag = DisposeBag()
    
    let contentFont = UIFont(name: "Avenir-Book", size: 14)
    let contentMargin: CGFloat = 8
    let contentPadding: CGFloat = 8
    let contentLabel = ActiveLabel()
    let contentTextView = UITextView()
    let containerView = UIView(frame: .zero)
    
    var borderColor: UIColor = Constants.valueContentBorderColor {
        didSet {
            containerView.layer.borderColor = borderColor.cgColor
        }
    }
    
    var borderWidth: CGFloat = Constants.calendarLineWidth {
        didSet {
            containerView.layer.borderWidth = borderWidth
        }
    }
    
    var textColor: UIColor = Constants.valueContentTextColor {
        didSet {
            contentLabel.textColor = textColor
        }
    }
    
    var value: Value? {
        didSet {
            guard let value = self.value else {
                return
            }
            if isEditable {
                contentTextView.text = value.content
                checkContent()
            }
            else {
                contentLabel.text = "\(Constants.infoString)\n\n\(self.value!.type.rawValue)"
                contentLabel.enabledTypes = [.url]
                contentLabel.handleURLTap({ (url) in
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                })
            }
        }
    }
    
    var isEditable = true
    
    func checkContent() {
        if isEditable {
            if contentTextView.text.isEmpty {
                contentLabel.isHidden = false
                contentLabel.text = self.value!.type.rawValue
            }
            else {
                contentLabel.isHidden = true
                contentLabel.text = contentTextView.text
                value?.content = contentTextView.text
            }
        }
    }
    init(_ isEditable: Bool = true) {
        super.init(frame: .zero)
        self.isEditable = isEditable
        layoutView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layoutView()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layoutView()
    }
    
    func layoutView() {
        self.clipsToBounds = true
        backgroundColor = UIColor.white
        containerView.layer.borderColor = borderColor.cgColor
        containerView.layer.borderWidth = borderWidth
        containerView.clipsToBounds = true
        
        addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: contentMargin),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -contentMargin),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: contentMargin),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -contentMargin)
            ])
        
        if isEditable {
            layoutTextView()
        }
        layoutLabel()
        layoutBottomLine()
        
        self.bringSubview(toFront: contentTextView)
        
//        setupRX()
        setupUI()
        
        if !isEditable {
            borderColor = .clear
            borderWidth = 0
        }
    }
    
    func layoutTextView() {
        
        contentTextView.font = contentFont
        contentTextView.textColor = textColor
        contentTextView.backgroundColor = .clear
        containerView.addSubview(contentTextView)
        
        contentTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentTextView.topAnchor.constraint(equalTo: containerView.topAnchor),
            contentTextView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            contentTextView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            contentTextView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            contentTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 80)
            ])
        
        contentTextView.textContainerInset = UIEdgeInsetsMake(contentPadding, contentPadding, contentPadding, contentPadding)
        contentTextView.isScrollEnabled = false
    }
    
    func layoutLabel() {
        contentLabel.textColor = textColor
        contentLabel.font = contentFont
        contentLabel.numberOfLines = 0
        contentLabel.alpha = isEditable ? 0.5:1.0
        containerView.addSubview(contentLabel)
        
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        if isEditable {
            NSLayoutConstraint.activate([
                contentLabel.topAnchor.constraint(equalTo: contentTextView.topAnchor, constant: contentPadding),
                contentLabel.leadingAnchor.constraint(equalTo: contentTextView.leadingAnchor, constant: contentPadding),
                contentLabel.trailingAnchor.constraint(equalTo: contentTextView.trailingAnchor, constant: -contentPadding)
                ])
        }
        else {
            NSLayoutConstraint.activate([
                contentLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: contentPadding),
                contentLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: contentPadding),
                contentLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -contentPadding),
                contentLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -contentPadding)
                ])
        }
    }
    
    func layoutBottomLine() {
        // bottom line
        let bottomLine = UIView(frame: .zero)
        bottomLine.backgroundColor = UIColor(colorWithHexValue: 0xABA8A8)
        addSubview(bottomLine)
        
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomLine.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bottomLine.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            bottomLine.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            bottomLine.heightAnchor.constraint(equalToConstant: 0.7)
            ])
    }
    
//    func setupRX() {
//        contentTextView.rx.text                                            // Observable of RxCocoa
//            .orEmpty                                            // make it not Optional ( String? -> String )
//            .debounce(0.1, scheduler: MainScheduler.instance)   // wait 0.5 sec
//            .distinctUntilChanged()                             // make sure the new value is the same as the previous value.
//            .subscribe(onNext: { [weak self] (text) in
//                self?.checkContent()
//                self?.layoutIfNeeded()
//            })
//            .disposed(by: disposeBag)
//
//    }
    
    func setupUI() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: NSNotification.Name.UIKeyboardWillHide,
            object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if isEditable {
            contentLabel.isHidden = true
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        checkContent()
    }
    
}

