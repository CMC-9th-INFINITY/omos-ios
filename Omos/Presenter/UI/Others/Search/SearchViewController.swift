//
//  searchViewController.swift
//  Omos
//
//  Created by sangheon on 2022/02/06.
//

import UIKit
import RxSwift

enum SearchType {

}

class SearchViewController:BaseViewController {
    
    let viewModel:SearchViewModel
    let selfView = SearchListView()
    
    init(viewModel:SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.enableScrollWhenKeyboardAppeared(scrollView: selfView.tableView)
        self.enableScrollWhenKeyboardAppeared(scrollView: selfView.bestTableView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeListeners()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selfView.searchViewController.searchBar.delegate = self
        navigationItem.rightBarButtonItems?.removeAll()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        selfView.searchViewController.isActive = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        selfView.searchViewController.isActive = false
        selfView.searchViewController.searchBar.resignFirstResponder()
    }
    
    override func configureUI() {
        view.addSubview(selfView)
        selfView.tableView.delegate = self
        selfView.tableView.dataSource = self
        selfView.bestTableView.delegate = self
        selfView.bestTableView.dataSource = self
        
        selfView.searchViewController.delegate = self
        selfView.searchViewController.searchResultsUpdater = self
        selfView.searchViewController.hidesNavigationBarDuringPresentation = false
        navigationItem.titleView = selfView.searchViewController.searchBar
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationItem.hidesBackButton = true 
        
        selfView.frame = view.bounds
    }
    
    
    
    func bind() {
        
        selfView.searchViewController.searchBar.rx.text
            .debounce(.milliseconds(300),scheduler:MainScheduler.instance) //요청 오버헤드 방지
            .withUnretained(self)
            .subscribe(onNext: { owner,text in
                guard let text = text else {
                    return
                }
                
                print(text)
                //owner.viewModel.searchQeuryChanged(query: text)
            }).disposed(by: disposeBag)
        
        viewModel.errorMessage
            .subscribe(onNext: { errorMessage in
                guard let errorMessage = errorMessage , !errorMessage.isEmpty else {
                    return
                }
                print("search Error: \(errorMessage)")
            }).disposed(by: disposeBag)
        
        viewModel.musics
            .withUnretained(self)
            .subscribe(onNext: { owner,musics in
                owner.selfView.tableView.reloadData()
            }).disposed(by: disposeBag)
        
        
        viewModel.loading
            .withUnretained(self)
            .subscribe(onNext: { owner,loading in
                print("loading\(loading)")
                owner.selfView.loadingView.isHidden = !loading
            }).disposed(by: disposeBag)
        
        viewModel.isEmpty
            .withUnretained(self)
            .subscribe(onNext: { owner,empty in
                guard let isTextEmpty = owner.selfView.searchViewController.searchBar.text?.isEmpty else { return }
                if isTextEmpty {
                    print("check")
                    owner.selfView.bestTableView.isHidden = !isTextEmpty
                    owner.selfView.emptyView.isHidden = true 
                } else {
                    owner.selfView.emptyView.isHidden = !empty
                }

            }).disposed(by: disposeBag)
    }
    
}



extension SearchViewController:UISearchControllerDelegate {
    func didPresentSearchController(_ searchController: UISearchController) {
        DispatchQueue.main.async
        { [weak self] in
            self?.selfView.searchViewController.searchBar.becomeFirstResponder()
        }
    }
    
}

extension SearchViewController:UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

extension SearchViewController:UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.navigationController?.popViewController(animated: true)
    }
}
