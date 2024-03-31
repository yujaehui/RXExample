//
//  NameTableViewController.swift
//  RXExample
//
//  Created by Jaehui Yu on 3/31/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class NameTableViewController: UIViewController {
    
    let nameTextField = UITextField()
    let addButton = UIButton()
    let nameTableView = UITableView()
    
    let names = BehaviorSubject<[String]>(value: [])
    
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
        let validation = nameTextField.rx.text.orEmpty.map { $0.count != 0 }
        validation
            .bind(with: self) { owner, value in
                owner.addButton.isEnabled = value
                owner.addButton.backgroundColor = value ? .systemGreen : .systemGray
            }.disposed(by: disposeBag)
        
        addButton.rx.tap
            .bind(with: self) { owner, _ in
                var currentNames = try! owner.names.value()
                guard let text = owner.nameTextField.text, !currentNames.contains(text) else { return }
                currentNames.append(text)
                owner.names.onNext(currentNames)
            }.disposed(by: disposeBag)
        
        names.bind(to: nameTableView.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = element
            return cell
        }.disposed(by: disposeBag)
        
        nameTableView.rx.modelDeleted(String.self)
            .bind(with: self) { owner, value in
                var currentNames = try! owner.names.value()
                currentNames.removeAll { $0 == value }
                owner.names.onNext(currentNames)
            }.disposed(by: disposeBag)
    }
    
    func configureHierarchy() {
        view.addSubview(nameTextField)
        view.addSubview(addButton)
        view.addSubview(nameTableView)
    }
    
    func configureView() {
        nameTextField.borderStyle = .bezel
        nameTextField.placeholder = "Please enter your name..."
        
        addButton.setTitle("추가", for: .normal)
        addButton.backgroundColor = .systemBlue
        
        nameTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    func configureConstraints() {
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        
        addButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.leading.equalTo(nameTextField.snp.trailing).offset(10)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.size.equalTo(50)
        }
        
        nameTableView.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(20)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

}
