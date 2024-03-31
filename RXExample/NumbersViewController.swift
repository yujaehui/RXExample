//
//  NumbersViewController.swift
//  RXExample
//
//  Created by Jaehui Yu on 3/31/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class NumbersViewController: UIViewController {
    
    let numaber1 = UITextField()
    let number2 = UITextField()
    let number3 = UITextField()
    let plus = UILabel()
    let line = UIView()
    let numberResult = UILabel()
    
    let result = PublishSubject<Int>()
    
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
        result.map { String($0) }.bind(to: numberResult.rx.text).disposed(by: disposeBag)
        
        Observable.combineLatest(numaber1.rx.text.orEmpty, number2.rx.text.orEmpty, number3.rx.text.orEmpty)
        .map { (num1, num2, num3) -> Int in
            let number1 = Int(num1) ?? 0
            let number2 = Int(num2) ?? 0
            let number3 = Int(num3) ?? 0
            return number1 + number2 + number3
        }.bind(with: self, onNext: { owner, value in
            owner.result.onNext(value)
        }).disposed(by: disposeBag)
    }
    
    func configureHierarchy() {
        view.addSubview(numaber1)
        view.addSubview(number2)
        view.addSubview(number3)
        view.addSubview(plus)
        view.addSubview(line)
        view.addSubview(numberResult)
    }
    
    func configureView() {
        numaber1.textAlignment = .right
        numaber1.borderStyle = .bezel
        number2.textAlignment = .right
        number2.borderStyle = .bezel
        number3.textAlignment = .right
        number3.borderStyle = .bezel
        plus.text = "+"
        plus.textAlignment = .center
        line.backgroundColor = .systemGray
        numberResult.textAlignment = .right
        numberResult.backgroundColor = .systemGray6
    }
    
    func configureConstraints() {
        numaber1.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(150)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(100)
            make.height.equalTo(50)
        }
        
        number2.snp.makeConstraints { make in
            make.top.equalTo(numaber1.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(100)
            make.height.equalTo(50)
        }
        
        number3.snp.makeConstraints { make in
            make.top.equalTo(number2.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(100)
            make.height.equalTo(50)
        }
        
        plus.snp.makeConstraints { make in
            make.top.equalTo(number3.snp.top)
            make.size.equalTo(50)
            make.trailing.equalTo(number3.snp.leading).offset(10)
        }
        
        line.snp.makeConstraints { make in
            make.top.equalTo(number3.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(100)
            make.height.equalTo(1)
        }
        
        numberResult.snp.makeConstraints { make in
            make.top.equalTo(line.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(100)
            make.height.equalTo(50)
        }
    }
}
