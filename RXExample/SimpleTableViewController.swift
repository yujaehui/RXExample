//
//  SimpleTableViewController.swift
//  RXExample
//
//  Created by Jaehui Yu on 3/31/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SimpleTableViewController: UIViewController {
    
    let tableView = UITableView()
    
    let list = Observable.just(Array(1...20))
    
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
            .bind(to: tableView.rx.items) { (tableView, row, element) in
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
                cell.textLabel?.text = "\(element) @ row \(row)"
                cell.accessoryType = .detailButton
                return cell
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Int.self)
            .bind(with: self) { owner, value in
                let alert = UIAlertController(title: "RXExample",
                                              message: "Tapped \(value)",
                                              preferredStyle: .alert)
                let button = UIAlertAction(title: "OK", style: .default)
                alert.addAction(button)
                owner.present(alert, animated: true)
            }.disposed(by: disposeBag)
        
        tableView.rx.itemAccessoryButtonTapped
            .bind(with: self) { owner, value in
                let alert = UIAlertController(title: "RXExample",
                                              message: "Tapped Detail @ \(value.section),\(value.row)",
                                              preferredStyle: .alert)
                let button = UIAlertAction(title: "OK", style: .default)
                alert.addAction(button)
                owner.present(alert, animated: true)
            }.disposed(by: disposeBag)
    }
    
    func configureHierarchy() {
        view.addSubview(tableView)
    }
    
    func configureView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    func configureConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
