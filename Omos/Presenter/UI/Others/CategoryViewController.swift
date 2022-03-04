//
//  CategoryViewController.swift
//  Omos
//
//  Created by sangheon on 2022/02/22.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit
import RxGesture

class CategoryViewController:BaseViewController {
    
    private let selfView = CategoryView()
    
    
    //    init(viewModel:CreateViewModel) {
    //        self.viewModel = viewModel
    //        super.init(nibName: nil, bundle: nil)
    //    }
    
    //    required init?(coder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItems?.removeAll()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "다음", style: .plain, target: self, action: #selector(createPresent))
        self.navigationItem.rightBarButtonItem?.tintColor = .white
        bind()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    override func configureUI() {
        super.configureUI()
        self.view.addSubview(selfView)
        
        selfView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
            make.bottom.equalToSuperview().offset(40).priority(1)
        }
    }
    
    private func bind() {
        selfView.oneLineView.rx.tapGesture()
            .when(.recognized)
            .asDriver{_ in .never()}
            .drive(onNext: { [weak self] _ in
                self?.checkOther((self?.selfView.oneLineView)!)
                self?.selfView.oneLineView.layer.borderWidth = 1
                self?.selfView.oneLineView.layer.borderColor = UIColor.mainOrange.cgColor
            })
            .disposed(by: disposeBag)
        
        selfView.myOstView.rx.tapGesture()
            .when(.recognized)
            .asDriver{_ in .never()}
            .drive(onNext: { [weak self] _ in
                self?.checkOther((self?.selfView.myOstView)!)
                self?.selfView.myOstView.layer.borderWidth = 1
                self?.selfView.myOstView.layer.borderColor = UIColor.mainOrange.cgColor
            })
            .disposed(by: disposeBag)
        
        selfView.myStoryView.rx.tapGesture()
            .when(.recognized)
            .asDriver{_ in .never()}
            .drive(onNext: { [weak self] _ in
                self?.checkOther((self?.selfView.myStoryView)!)
                self?.selfView.myStoryView.layer.borderWidth = 1
                self?.selfView.myStoryView.layer.borderColor = UIColor.mainOrange.cgColor
            })
            .disposed(by: disposeBag)
        
        selfView.lyricsView.rx.tapGesture()
            .when(.recognized)
            .asDriver{_ in .never()}
            .drive(onNext: { [weak self] _ in
                self?.checkOther((self?.selfView.lyricsView)!)
                self?.selfView.lyricsView.layer.borderWidth = 1
                self?.selfView.lyricsView.layer.borderColor = UIColor.mainOrange.cgColor
            })
            .disposed(by: disposeBag)
        
        selfView.freeView.rx.tapGesture()
            .when(.recognized)
            .asDriver{_ in .never()}
            .drive(onNext: { [weak self] _ in
                self?.checkOther((self?.selfView.freeView)!)
                self?.selfView.freeView.layer.borderWidth = 1
                self?.selfView.freeView.layer.borderColor = UIColor.mainOrange.cgColor
            })
            .disposed(by: disposeBag)
        
    }
    
    //MARK: Local Func
    private func checkOther(_ selectedView:reactangleView) {
        var views = [
            selfView.oneLineView,
            selfView.myOstView,
            selfView.myStoryView,
            selfView.lyricsView,
            selfView.freeView
        ]
        
        for idx in 0...4 {
            if views[idx] == selectedView {
                views.remove(at: idx)
                break;
            }
        }
        
        for view in views {
            view.layer.borderWidth = 0
        }
        
    }
    
    @objc func createPresent() {
        let views = [
            selfView.oneLineView,
            selfView.myOstView,
            selfView.myStoryView,
            selfView.lyricsView,
            selfView.freeView
        ]
        
        let rp = RecordsRepositoryImpl(recordAPI: RecordAPI())
        let uc = RecordsUseCase(recordsRepository: rp)
        let vm = CreateViewModel(usecase: uc)
        for view in views {
            if view.layer.borderWidth == 1 {
                if view == selfView.lyricsView {
                    print("this is lyrics view")
                } else {
                    let vc = CreateViewController(viewModel:vm,category: view.titleLabel.text!)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
}

