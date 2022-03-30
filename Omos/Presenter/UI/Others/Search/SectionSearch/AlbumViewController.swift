//
//  AlbumViewController.swift
//  Omos
//
//  Created by sangheon on 2022/02/27.
//
import UIKit
import RxSwift

class AlbumViewController:BaseViewController {
    
    let selfView = AlbumView()
    let viewModel:SearchViewModel
    let disposebag = DisposeBag()
    
    init(viewModel:SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        selfView.tableView.delegate = self
        selfView.tableView.dataSource = self
        selfView.emptyView.isHidden = !(viewModel.currentAlbum.isEmpty)
    }
    
    
    override func configureUI() {
        super.configureUI()
        self.view.addSubview(selfView)
        
        selfView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        }
    }
    
    func bind() {
        viewModel.album
            .subscribe({ [weak self] data in
                self?.selfView.emptyView.isHidden = !(self?.viewModel.currentAlbum.isEmpty)!
                self?.selfView.tableView.reloadData()
            }).disposed(by: disposebag)
        
        
        viewModel.isAlbumEmpty
            .withUnretained(self)
            .subscribe(onNext: { owner,empty in
                owner.selfView.emptyView.isHidden = !empty
            }).disposed(by: disposeBag)
        
    }
    
    
}

extension AlbumViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.currentAlbum.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AlbumTableCell.identifier, for: indexPath) as! AlbumTableCell
        let cellData = viewModel.currentAlbum[indexPath.row]
        cell.configureModel(album: cellData)
        cell.selectionStyle = . none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cellData = viewModel.currentAlbum[indexPath.row]
        let rp = SearchRepositoryImpl(searchAPI: SearchAPI())
        let uc = SearchUseCase(searchRepository: rp)
        let vm = SearchAlbumDetailViewModel(usecase: uc)
        let vc = SearchAlbumDetailViewController(viewModel:vm ,albumInfo:cellData,searchType: viewModel.searchType)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constant.mainHeight * 0.108
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
}
