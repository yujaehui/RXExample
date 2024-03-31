//
//  SimplePickerViewController.swift
//  RXExample
//
//  Created by Jaehui Yu on 3/31/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SimplePickerViewController: UIViewController {
    
    let stackView = UIStackView()
    let picker1 = UIPickerView()
    let picker2 = UIPickerView()
    let picker3 = UIPickerView()
    
    let list = Observable.just(Array(1...3))
    let colorList = Observable.just([UIColor.systemRed, UIColor.systemYellow, UIColor.systemGreen])
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureHierarchy()
        configureView()
        configureConstraints()
        bind()
    }
    
    func bind() {
        list
            .bind(to: picker1.rx.itemTitles) { _, item in
                return "\(item)"
            }.disposed(by: disposeBag)
        
        list
            .bind(to: picker2.rx.itemAttributedTitles) { _, item in
                return NSAttributedString(string: "\(item)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.cyan,
                                                                          NSAttributedString.Key.underlineStyle: NSUnderlineStyle.double.rawValue])
            }.disposed(by: disposeBag)
        
        colorList
            .bind(to: picker3.rx.items) { _, item, _ in
                let view = UIView()
                view.backgroundColor = item
                return view
            }.disposed(by: disposeBag)
        
        picker1.rx.modelSelected(Int.self)
            .bind { value in
                print("models selected 1: \(value)")
            }.disposed(by: disposeBag)
        
        picker2.rx.modelSelected(Int.self)
            .bind { value in
                print("models selected 2: \(value)")
            }.disposed(by: disposeBag)
        
        picker3.rx.modelSelected(UIColor.self)
            .bind { value in
                print("models selected 3: \(value)")
            }.disposed(by: disposeBag)
    }
    
    func configureHierarchy() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(picker1)
        stackView.addArrangedSubview(picker2)
        stackView.addArrangedSubview(picker3)
    }
    
    func configureView() {
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 10
    }
    
    func configureConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
