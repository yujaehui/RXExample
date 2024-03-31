//
//  SimpleValidationViewController.swift
//  RXExample
//
//  Created by Jaehui Yu on 3/31/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SimpleValidationViewController: UIViewController {
    
    let usernameLabel = UILabel()
    let usernameTextField = UITextField()
    let usernameStateLabel = UILabel()
    
    let passwordLabel = UILabel()
    let passwordTextfield = UITextField()
    let passwordStateLabel = UILabel()
    
    let submitButton = UIButton()
    
    let usernameState = Observable.just("5글자 이상 입력해주세요.")
    let passwordState = Observable.just("5글자 이상 입력해주세요.")
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        view.backgroundColor = .white
        super.viewDidLoad()
        configureHierarchy()
        configureView()
        configureConstraints()
        bind()
    }
    
    func bind() {
        usernameState.bind(to: usernameStateLabel.rx.text).disposed(by: disposeBag)
        passwordState.bind(to: passwordStateLabel.rx.text).disposed(by: disposeBag)
        
        let usernameValidation = usernameTextField.rx.text.orEmpty.map { $0.count > 5 }
        usernameValidation.bind(to: usernameStateLabel.rx.isHidden).disposed(by: disposeBag)
        
        let passwordVaildation = passwordTextfield.rx.text.orEmpty.map { $0.count > 5 }
        passwordVaildation.bind(to: passwordStateLabel.rx.isHidden).disposed(by: disposeBag)
        
        let validation = Observable.combineLatest(usernameValidation, passwordVaildation) { $0 && $1 }
        validation
            .bind(with: self) { owner, value in
                owner.submitButton.isEnabled = value
                owner.submitButton.backgroundColor = value ? .systemGreen : .systemGray
            }.disposed(by: disposeBag)
        
        submitButton.rx.tap
            .bind(with: self) { owner, _ in
                let alert = UIAlertController(title: "RXExample",
                                              message: "submit successfully",
                                              preferredStyle: .alert)
                let button = UIAlertAction(title: "OK", style: .default)
                alert.addAction(button)
                owner.present(alert, animated: true)
            }.disposed(by: disposeBag)
    }
    
    func configureHierarchy() {
        view.addSubview(usernameLabel)
        view.addSubview(usernameTextField)
        view.addSubview(usernameStateLabel)
        
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextfield)
        view.addSubview(passwordStateLabel)
        
        view.addSubview(submitButton)
    }
    
    func configureView() {
        usernameLabel.text = "Username"
        usernameTextField.borderStyle = .bezel
        
        passwordLabel.text = "Password"
        passwordTextfield.borderStyle = .bezel
        
        submitButton.setTitle("Submit", for: .normal)
        submitButton.backgroundColor = .systemGreen
    }
    
    func configureConstraints() {
        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(20)
        }
        
        usernameTextField.snp.makeConstraints { make in
            make.top.equalTo(usernameLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        
        usernameStateLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameTextField.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(20)
        }
        
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameStateLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(20)
        }
        
        passwordTextfield.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        
        passwordStateLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextfield.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(20)
        }
        
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(passwordStateLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
    }
}
