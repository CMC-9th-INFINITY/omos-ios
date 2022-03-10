//
//  MyRecordDetailViewController.swift
//  Omos
//
//  Created by sangheon on 2022/02/19.
//

import UIKit
import RxSwift
import RxCocoa
import MaterialComponents.MaterialBottomSheet

class MyRecordDetailViewController:BaseViewController {
    
    private let selfView = MyRecordDetailView()
    let myRecord:MyRecordRespone
    let bottomVC:BottomSheetViewController
    let bottomSheet:MDCBottomSheetController
    let viewModel:MyRecordDetailViewModel
    
    
    init(myRecord:MyRecordRespone,viewModel:MyRecordDetailViewModel) {
        self.myRecord = myRecord
        self.viewModel = viewModel
        self.bottomVC = BottomSheetViewController(type: .MyRecord, myRecordVM: viewModel, AllRecordVM: nil)
        self.bottomSheet = MDCBottomSheetController(contentViewController: bottomVC)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationItems()
        bind()
        setData()
    }
    
    private func setNavigationItems() {
        self.navigationItem.rightBarButtonItems?.removeAll()
        let InstaButton = UIBarButtonItem(image: UIImage(named: "instagram"), style: .plain, target: self, action: #selector(didTapInstagram))
        InstaButton.tintColor = .white
        let moreButton = UIBarButtonItem(image: UIImage(named: "more"), style: .plain, target: self, action: #selector(didTapMoreButton))
        moreButton.tintColor = .white
        self.navigationItem.rightBarButtonItems = [moreButton,InstaButton]
    }
    
    @objc func didTapInstagram() {
        
    }
    
    @objc func didTapMoreButton() {
        bottomSheet.mdc_bottomSheetPresentationController?.preferredSheetHeight = Constant.mainHeight * 0.194
        self.present(bottomSheet,animated: true)
    }
    
    override func configureUI() {
        self.view.addSubview(selfView)
        selfView.reportButton.isHidden = true
        
        selfView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.height.equalToSuperview().multipliedBy(0.7)
        }
       
    }
    
    func bind() {
//        selfView.reportButton.rx.tap
//            .asDriver()
//            .drive(onNext:{ [weak self] _ in
//                let action = UIAlertAction(title: "신고", style: .default) { alert in
//                    print(alert)
//                }
//                action.setValue(UIColor.mainOrange, forKey: "titleTextColor")
//                self?.presentAlert(title: "신고하기", message: "이 레코드를 신고하시겠어요?", isCancelActionIncluded: true, preferredStyle: .alert, with: action)
//            }).disposed(by: disposeBag)
        
        //like button and scrap button
        selfView.lockButton.rx.tap
            .scan(false) { (lastState, newValue) in
                !lastState
            }
            .bind(to: selfView.lockButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.modify
            .subscribe(onNext: { [weak self] _ in
                let rp = RecordsRepositoryImpl(recordAPI: RecordAPI())
                let uc = RecordsUseCase(recordsRepository: rp)
                let vm = CreateViewModel(usecase: uc)
                vm.modifyDefaultModel = self?.myRecord
                let vc = CreateViewController(viewModel: vm, category: (self?.getReverseCate(cate: self?.myRecord.category ?? ""))!, type: .modify)
                self?.navigationController?.pushViewController( vc, animated: true)
                
            }).disposed(by: disposeBag)
        
        viewModel.delete
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.deleteRecord(postId: self?.myRecord.recordID ?? 0)
            }).disposed(by: disposeBag)
        
        viewModel.done
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
        
    }
    
    func setData() {
        selfView.musicTitleLabel.text = myRecord.music.musicTitle
        selfView.subMusicInfoLabel.text = myRecord.music.artists.map { $0.artistName }.reduce("") { $0 + " \($1)" }
        selfView.circleImageView.setImage(with: myRecord.music.albumImageURL)
//        selfView.backImageView.setImage(with: <#T##String#>)
        selfView.titleLabel.text = myRecord.recordTitle
        selfView.createdLabel.text = myRecord.createdDate
        selfView.mainLabelView.text = myRecord.recordContents
        selfView.loveCountLabel.text = String(myRecord.likeCnt)
        selfView.starCountLabel.text = String(myRecord.scrapCnt)
        
        if myRecord.isPublic {
            selfView.lockButton.setImage(UIImage(named: "unlock"), for: .normal)
            selfView.lockButton.setImage(UIImage(named: "lock"), for: .selected)
        } else {
            selfView.lockButton.setImage(UIImage(named: "lock"), for: .normal)
            selfView.lockButton.setImage(UIImage(named: "unlock"), for: .selected)
        }
        if myRecord.isLiked {
            selfView.loveImageView.image = UIImage(named: "fillLove")
            selfView.loveCountLabel.textColor = .mainOrange
        }
        
        if myRecord.isScraped {
            selfView.starImageView.image = UIImage(named: "fillStar")
            selfView.starCountLabel.textColor = .mainOrange
        }
        
    }
    
    private func getReverseCate(cate:String) -> String {
        switch cate {
        case "A_LINE":
            return "한 줄 감상"
        case "STORY":
            return "노래 속 나의 이야기"
        case "OST":
            return "내 인생의 OST"
        case "LYRICS":
            return "나만의 가사해석"
        case "FREE":
            return "자유 공간"
        default:
            return "자유 공간"
        }
    }
    
}
