//
//  LyricsPasteCreateViewController.swift
//  Omos
//
//  Created by sangheon on 2022/03/14.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import YPImagePicker
import Mantis
import Combine
import KakaoSDKUser
import Kingfisher
import IRSticker_swift

class LyricsPasteCreateViewController:BaseViewController {
    
    var defaultModel:recordSaveDefaultModel = .init(musicId: "", imageURL: "", musicTitle: "", subTitle: "")
    let scrollView = UIScrollView()
    var cancellables = Set<AnyCancellable>()
    let selfView = LyricsPasteCreateView()
    let viewModel:LyricsViewModel
    let type:CreateType
    var totalString = 0
    var textTagCount = 1
    var textCellsArray:[Int]
    lazy var awsHelper = AWSS3Helper()
    let stickerChoiceView = StickerView()
    var animator: UIDynamicAnimator?
    var selectedSticker: IRStickerView?
    
    init(viewModel:LyricsViewModel,type:CreateType) {
        self.viewModel = viewModel
        self.type = type
        self.textCellsArray = [Int](repeating: 0, count: viewModel.lyricsStringArray.count + 1)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selfView.tableView.delegate = self
        selfView.tableView.dataSource = self
        selfView.titleTextView.delegate = self 
        bind()
        animator = UIDynamicAnimator.init(referenceView: selfView.tableView)
        
                if type == .create { setCreateViewinfo() }
                else { setModifyView() }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        selfView.tableView.layoutIfNeeded()
        selfView.tableView.reloadData()
        // selfView.tableHeightConstraint!.update(offset: selfView.tableView.contentSize.height)
        selfView.tableHeightConstraint!.update(offset: selfView.tableView.intrinsicContentSize2.height )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.rightBarButtonItems?.removeAll()
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(didTapDone))
        doneButton.tintColor = .white
        self.navigationItem.rightBarButtonItem = doneButton
        enableScrollWhenKeyboardAppeared(scrollView: self.scrollView)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeListeners()
    }
    
    @objc func didTapDone() {
        guard let titleText = selfView.titleTextView.text else {
            return
        }
        var content = ""
        var state = true
        selfView.tableView.visibleCells.forEach { cell in
            if let cell = cell as? LyriscTableCell {
                guard let txt = cell.label.text else {
                    return
                }
               content += txt + "\n"
            } else if let cell = cell as? TextTableCell {
                guard let desc = cell.textView.text else {
                    return
                }
                if desc == "" || desc == "가사해석을 적어주세요." {
                    state = false
                }
                content += (desc + "\n")
            
            }
        }
        print(content)
        if selfView.titleTextView.text == "" || selfView.titleTextView.text == "레코드 제목을 입력해주세요" || !state {
            setAlert()
            return
        }
        
        
        if type == .create {
            viewModel.saveRecord(cate: "LYRICS", content: content, isPublic: !(selfView.lockButton.isSelected), musicId: viewModel.defaultModel.musicId, title:titleText , userid: Account.currentUser,recordImageUrl: "https://omos-image.s3.ap-northeast-2.amazonaws.com/record/\(viewModel.curTime).png")
        } else {
            if ImageCache.default.isCached(forKey: viewModel.modifyDefaultModel?.recordImageURL ?? "") {
                          print("Image is cached")
                          ImageCache.default.removeImage(forKey: viewModel.modifyDefaultModel?.recordImageURL ?? "")
                 }
            viewModel.updateRecord(postId: viewModel.modifyDefaultModel?.recordID ?? 0, request: .init(contents: content, title: selfView.titleTextView.text,isPublic: !(selfView.lockButton.isSelected),recordImageUrl: viewModel.modifyDefaultModel?.recordImageURL ?? "" ))
        }
    }
    
    private func setAlert() {
        let action = UIAlertAction(title: "확인", style: .default) { alert in
            
        }
        action.setValue(UIColor.mainOrange, forKey: "titleTextColor")
        self.presentAlert(title: "", message: "내용이나 제목을 채워주세요", isCancelActionIncluded: false, preferredStyle: .alert, with: action)
    }
    
    func setScrollView() {
        self.view.addSubview(scrollView)
        scrollView.addSubview(selfView)
        scrollView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        }
        
        selfView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        scrollView.showsVerticalScrollIndicator = false
    }
    
    private func setStickerView() {
        stickerChoiceView.isHidden = false
        
        selfView.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        
        stickerChoiceView.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.top.equalTo(selfView.lastView.snp.top)
            make.bottom.equalToSuperview()
        }
        stickerChoiceView.layoutIfNeeded()
    }
    
    override func configureUI() {
        super.configureUI()
        setScrollView()
        scrollView.addSubview(stickerChoiceView)
        setStickerView()
        hideStickerView()
    }
    
    private func setCreateViewinfo() {
        selfView.cateLabel.text = "  | 나만의 가사해석"
        selfView.circleImageView.setImage(with: viewModel.defaultModel.imageURL)
        selfView.musicTitleLabel.text = viewModel.defaultModel.musicTitle
        selfView.subMusicInfoLabel.text = viewModel.defaultModel.subTitle

        // get the current date and time
        let currentDateTime = Date()
        
        // get the user's calendar
        let userCalendar = Calendar.current
        
        // choose which date and time components are needed
        let requestedComponents: Set<Calendar.Component> = [
            .year,
            .month,
            .day
        ]
        
        // get the components
        let dateTimeComponents = userCalendar.dateComponents(requestedComponents, from: currentDateTime)
        
        selfView.createdField.text = "\(dateTimeComponents.year!) \(dateTimeComponents.month!) \(dateTimeComponents.day!)"
    }
    
    func setModifyView() {
        print(viewModel.modifyDefaultModel!)
        selfView.cateLabel.text = "  | 가사 해석"
        selfView.circleImageView.setImage(with: viewModel.modifyDefaultModel?.music.albumImageURL ?? "")
        selfView.musicTitleLabel.text = viewModel.modifyDefaultModel?.music.musicTitle
        selfView.subMusicInfoLabel.text = viewModel.modifyDefaultModel?.music.artists.map { $0.artistName }.reduce("") { $0 + " \($1)" }
        selfView.titleTextView.text = viewModel.modifyDefaultModel?.recordTitle
        selfView.titleTextView.textColor = .white
        selfView.imageView.setImage(with: viewModel.modifyDefaultModel?.recordImageURL ?? "")
        selfView.remainTitleCount.text =  "\(viewModel.modifyDefaultModel?.recordTitle.count ?? 0)/36"
        selfView.remainTextCount.text = "\(viewModel.modifyDefaultModel?.recordContents.count ?? 0)/380"
        
    }
    
    private func bind() {
        selfView.imageAddButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.configureImagePicker()
            }).disposed(by: disposeBag)
        
        viewModel.state
            .subscribe(onNext: { [weak self] info in
                
                for controller in (self?.navigationController?.viewControllers ?? [UIViewController()] )  as Array {
                    if controller.isKind(of: MyRecordViewController.self) {
                        self?.navigationController?.popToViewController(controller, animated: true)
                        UserDefaults.standard.set(1, forKey: "reload")
                        break
                    }
                    
                    if controller.isKind(of: HomeViewController.self) {
                        self?.navigationController?.popToViewController(controller, animated: true)
                        break
                    }
                    
                    if controller.isKind(of: AllRecordCateDetailViewController.self) {
                        self?.navigationController?.popToViewController(controller, animated: true)
                        
                        break
                    }
                    if controller.isKind(of: AllRecordSearchDetailViewController.self) {
                        self?.navigationController?.popToViewController(controller, animated: true)
                        break
                    }
                }
                for controller in (self?.navigationController?.viewControllers ?? [UIViewController()] )  as Array {
                    if controller.isKind(of: AllRecordViewController.self) {
                        self?.navigationController?.popToViewController(controller, animated: true)
                        break
                    }
                }
                
            }).disposed(by: disposeBag)
        
        selfView.stickerImageView.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.setStickerView()
                self?.scrollView.layoutIfNeeded()
                self?.scrollView.setContentOffset(CGPoint(x: 0, y: (self?.scrollView.contentSize.height)! - (self?.scrollView.bounds.size.height)!), animated: true)
            }).disposed(by: disposeBag)
        
        viewModel.loading
            .subscribe(onNext: { [weak self] loading in
                
            }).disposed(by: disposeBag)
        
        selfView.lockButton.rx.tap
            .scan(false) { (lastState, newValue) in
                !lastState
            }
            .bind(to: selfView.lockButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        stickerBind()
    }
    
    func stickerBind() {
        stickerChoiceView.stickerImageView1.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                let sticker1 = IRStickerView(frame: CGRect.init(x: 100, y: 100, width: 150, height: 150), contentImage: UIImage.init(named: "sticker1")!)
                sticker1.enabledControl = false
                sticker1.enabledBorder = false
                sticker1.tag = 1
                sticker1.delegate = self
                self?.selfView.tableView.addSubview(sticker1)
                sticker1.performTapOperation()
            }).disposed(by: disposeBag)
        
        stickerChoiceView.stickerImageView2.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                let sticker1 = IRStickerView(frame: CGRect.init(x: 100, y: 100, width: 150, height: 150), contentImage: UIImage.init(named: "sticker2")!)
                sticker1.enabledControl = false
                sticker1.enabledBorder = false
                sticker1.tag = 2
                sticker1.delegate = self
                self?.selfView.tableView.addSubview(sticker1)
                sticker1.performTapOperation()
            }).disposed(by: disposeBag)
        
        stickerChoiceView.stickerImageView3.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                let sticker1 = IRStickerView(frame: CGRect.init(x: 100, y: 100, width: 150, height: 150), contentImage: UIImage.init(named: "ost")!)
                sticker1.enabledControl = false
                sticker1.enabledBorder = false
                sticker1.tag = 3
                sticker1.delegate = self
                self?.selfView.tableView.addSubview(sticker1)
                sticker1.performTapOperation()
            }).disposed(by: disposeBag)
        
        stickerChoiceView.stickerImageView4.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                let sticker1 = IRStickerView(frame: CGRect.init(x: 100, y: 100, width: 150, height: 150), contentImage: UIImage.init(named: "sticker3")!)
                sticker1.enabledControl = false
                sticker1.enabledBorder = false
                sticker1.tag = 4
                sticker1.delegate = self
                self?.selfView.tableView.addSubview(sticker1)
                sticker1.performTapOperation()
            }).disposed(by: disposeBag)
        
        stickerChoiceView.stickerImageView5.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                let sticker1 = IRStickerView(frame: CGRect.init(x: 100, y: 100, width: 150, height: 150), contentImage: UIImage.init(named: "sticker4")!)
                sticker1.enabledControl = false
                sticker1.enabledBorder = false
                sticker1.tag = 5
                sticker1.delegate = self
                self?.selfView.tableView.addSubview(sticker1)
                sticker1.performTapOperation()
            }).disposed(by: disposeBag)
        
        stickerChoiceView.stickerImageView6.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                let sticker1 = IRStickerView(frame: CGRect.init(x: 100, y: 100, width: 150, height: 150), contentImage: UIImage.init(named: "oneline")!)
                sticker1.enabledControl = false
                sticker1.enabledBorder = false
                sticker1.tag = 6
                sticker1.delegate = self
                self?.selfView.tableView.addSubview(sticker1)
                sticker1.performTapOperation()
            }).disposed(by: disposeBag)
        
        selfView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                if (self?.selectedSticker != nil) {
                    self?.selectedSticker!.enabledControl = false
                    self?.selectedSticker!.enabledBorder = false;
                    self?.selectedSticker = nil
                    self?.scrollView.isScrollEnabled = true
                }
                if !((self?.stickerChoiceView.isHidden)!) {
                    self?.hideStickerView()
                }
            }).disposed(by: disposeBag)
    }
    
    private func hideStickerView() {
        selfView.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        
        stickerChoiceView.snp.remakeConstraints({ make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(0)
        })
        stickerChoiceView.isHidden = true
    }
    
    func configureImagePicker() {
        var config = YPImagePickerConfiguration()
        config.wordings.libraryTitle = "보관함"
        config.wordings.cameraTitle = "카메라"
        config.wordings.next = "다음"
        config.colors.tintColor = .white
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, cancelled in
            if let photo = items.singlePhoto {
                print(photo.image) // Final image selected by the user
                let cropViewController = Mantis.cropViewController(image: photo.image)
                cropViewController.delegate = self
                cropViewController.modalPresentationStyle = .fullScreen
                picker.dismiss(animated: true, completion: nil)
                self.present(cropViewController, animated: true)
            }
            if cancelled {
                print("Picker was canceled")
                picker.dismiss(animated: true, completion: nil)
                self.tabBarController?.tabBar.isHidden = true
            }
            
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    
}



extension LyricsPasteCreateViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == selfView.titleTextView {
            if textView.text == "레코드 제목을 입력해주세요" {
                textView.text = nil
                textView.textColor = .white
            }
        } else {
            if textView.tag < 1 {
                textView.tag = textTagCount
                textTagCount+=1
            }
            
            if textView.text == "가사해석을 적어주세요" {
                textView.text = nil
                textView.textColor = .white
            }
        }
     
       
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView == selfView.titleTextView {
            if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                textView.text = "레코드 제목을 입력해주세요"
                textView.textColor = .mainGrey7
                selfView.remainTitleCount.text = "\(0)/36"
            }
        } else {
            if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                textView.text = "가사해석을 적어주세요"
                textView.textColor = .mainGrey7
                //selfView.remainTextCount.text = "\(0)/250"
            }
        }
        
      
      
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let inputString = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let oldString = textView.text, let newRange = Range(range, in: oldString) else { return true }
        let newString = oldString.replacingCharacters(in: newRange, with: inputString).trimmingCharacters(in: .whitespacesAndNewlines)
        let characterCount = newString.count
        if textView == selfView.titleTextView {
            guard characterCount <= 36 else { return false }
            selfView.remainTitleCount.text =  "\(characterCount)/36"
        } else {
            textCellsArray[textView.tag] = characterCount
            totalString = textCellsArray.reduce(0,+)
            guard totalString <= 380 else { return false }
            selfView.remainTextCount.text =  "\(totalString)/380"
        }
        

        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = textView.bounds.size
        let newSize = selfView.tableView.sizeThatFits(CGSize(width: size.width,
                                                             height: CGFloat.greatestFiniteMagnitude))

        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            selfView.tableView.beginUpdates()
            selfView.tableHeightConstraint!.update(offset: selfView.tableView.contentSize.height )
            selfView.tableView.endUpdates()
            UIView.setAnimationsEnabled(true)
        }
    }
    
}


extension LyricsPasteCreateViewController:CropViewControllerDelegate {
    func cropViewControllerDidCrop(_ cropViewController: CropViewController, cropped: UIImage, transformation: Transformation, cropInfo: CropInfo) {
        selfView.imageView.image = cropped
        if type == .create {
            awsHelper.uploadImage(cropped, sender: self, imageName: "record/\(viewModel.curTime)" , type: .record) { _ in
               
            }
        } else {//711648447384992.png
            guard let str = viewModel.modifyDefaultModel?.recordImageURL else { return }
            let startIndex = str.index(str.endIndex, offsetBy: -19)
            let endIndex = str.index(str.endIndex, offsetBy: -4)
            let defualtUrl = String(str[startIndex..<endIndex])
            
            awsHelper.uploadImage(cropped, sender: self, imageName: "record/\(defualtUrl)" , type: .record) { _ in

            }
           
        }
        self.dismiss(animated: true,completion: nil)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func cropViewControllerDidFailToCrop(_ cropViewController: CropViewController, original: UIImage) {
        
    }
    
    func cropViewControllerDidCancel(_ cropViewController: CropViewController, original: UIImage) {
        self.dismiss(animated: true, completion: nil)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func cropViewControllerDidBeginResize(_ cropViewController: CropViewController) {
        
    }
    
    func cropViewControllerDidEndResize(_ cropViewController: CropViewController, original: UIImage, cropInfo: CropInfo) {
        
    }
    
    
}

extension LyricsPasteCreateViewController:IRStickerViewDelegate {
    func ir_StickerViewDidTapContentView(stickerView: IRStickerView) {
        NSLog("Tap[%zd] ContentView", stickerView.tag)
        if let selectedSticker = selectedSticker {
            selectedSticker.enabledBorder = false
            selectedSticker.enabledControl = false
        }

        selectedSticker = stickerView
        selectedSticker!.enabledBorder = true
        selectedSticker!.enabledControl = true
        scrollView.isScrollEnabled = false
    }
    
    func ir_StickerViewDidTapLeftTopControl(stickerView: IRStickerView) {
        NSLog("Tap[%zd] DeleteControl", stickerView.tag);
        stickerView.removeFromSuperview()
        for subView in self.selfView.tableView.subviews {
            if subView.isKind(of: IRStickerView.self)  {
                let sticker = subView as! IRStickerView
                sticker.performTapOperation()
                break
            }
        }
    }
}




// selfView.tableView.heightAnchor.constraint(equalToConstant: selfView.tableView.contentSize.height).isActive = true
//        selfView.tableView.heightAnchor.constraint(equalToConstant:400).isActive = true
//        selfView.tableView.publisher(for: \.contentSize)
//            .receive(on: RunLoop.main)
//            .sink { [weak self] size in
////                      self.myViewsHeightConstraint.constant = size.height
////                      self.tableView.isScrollEnabled = size.height > self.tableView.frame.height
//                if size.height > 1 {
//                    print( self?.selfView.tableView.contentSize.height)
//                    self?.selfView.tableHeightConstraint!.updateOffset(amount: size.height)
//                    self?.selfView.tableView.reloadData()
//                }
//
//                  }
//                  .store(in: &cancellables)
//selfView.tableHeightConstraint!.updateOffset(amount: 200)
