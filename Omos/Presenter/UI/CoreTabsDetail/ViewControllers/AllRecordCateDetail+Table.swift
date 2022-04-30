//
//  AllRecordCateDetail + Table.swift
//  Omos
//
//  Created by sangheon on 2022/03/12.
//

import RxCocoa
import RxSwift
import UIKit

extension AllRecordCateDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.currentCateRecords.count
        } else if section == 1 && isPaging && hasNextPage {
            return 1
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let record = viewModel.currentCateRecords[safe:indexPath.row] else { return UITableViewCell() }
//            if Account.currentReportRecordsId.contains(record.recordID) {
//                return UITableViewCell.init(frame: .zero)
//            }
            switch self.myCateType {
            case .lyrics:
                let cell = tableView.dequeueReusableCell(withIdentifier: AllrecordLyricsTableCell.identifier, for: indexPath) as! AllrecordLyricsTableCell
                cell.selfView.tableHeightConstraint?.deactivate()
                cell.configureModel(record: record)
                cell.selectionStyle = .none
                cell.selfView.tableView.reloadData()

                lyricsCellBind(cell: cell, data: record, indexPath: indexPath)
                return cell
            case .aLine:
                let cell = tableView.dequeueReusableCell(withIdentifier: AllRecordCateShortDetailCell.identifier, for: indexPath) as! AllRecordCateShortDetailCell
                cell.configureModel(record: record)
                shortCellBind(cell: cell, data: record)
                cell.selectionStyle = .none
                cell.myView.lockButton.isHidden = true
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: AllRecordCateLongDetailCell.identifier, for: indexPath) as! AllRecordCateLongDetailCell
                cell.configureModel(record: record)
                cell.layoutIfNeeded()
//                cell.myView.circleImageView.layer.cornerRadius = cell.myView.circleImageView.height / 2
//                cell.myView.circleImageView.layer.masksToBounds = true
                //MARK: todo fix : 여기서 max number부르지말고 텍스트 숫자 기준으로 해서 넘으면 셀에서 줄이거나 여기서 메시지 받고 줄여주기
                
                if expandedIndexSet.contains(indexPath.row) {
                    // cell.layoutIfNeeded()
                    cell.myView.mainLabelView.numberOfLines = 0
                    cell.myView.mainLabelView.sizeToFit()
                    cell.myView.mainLabelView.setNeedsLayout()
                    cell.myView.mainLabelView.layoutIfNeeded()
                    cell.myView.readMoreButton.isHidden = true
                } else {
//                    if cell.myView.mainLabelView.maxNumberOfLines < 4 {
//                        cell.myView.readMoreButton.isHidden = true
//                    } else {
//                        cell.myView.mainLabelView.numberOfLines = 3
//                        cell.myView.mainLabelView.sizeToFit()
//                        cell.myView.readMoreButton.isHidden = false
//                    }
                }
                cell.layer.shouldRasterize = true
                cell.layer.rasterizationScale = UIScreen.main.scale
                longCellBind(cell: cell, data: record, indexPath: indexPath)
                cell.myView.lockButton.isHidden = true
                cell.selectionStyle = . none
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: LoadingCell.identifier, for: indexPath) as! LoadingCell

            cell.start()
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(
            at: indexPath, animated: true)
        guard let record = viewModel.currentCateRecords[safe:indexPath.row] else { return }

        if Account.currentUser == record.userID {
            let rp = RecordsRepositoryImpl(recordAPI: RecordAPI())
            let uc = RecordsUseCase(recordsRepository: rp)
            let vm = MyRecordDetailViewModel(usecase: uc)
            let vc = MyRecordDetailViewController(posetId: record.recordID, viewModel: vm)
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let rp = RecordsRepositoryImpl(recordAPI: RecordAPI())
            let uc = RecordsUseCase(recordsRepository: rp)
            let vm = AllRecordDetailViewModel(usecase: uc)
            let vc = AllRecordDetailViewController(viewModel: vm, postId: record.recordID)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if self.myCateType != .aLine, self.myCateType != .lyrics {
                return shortCellHeights[indexPath] ?? Constant.mainHeight * 0.63
            }
        }

        return  longCellHeights[indexPath] ?? UITableView.automaticDimension
    }

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == 0 {
//            if self.myCateType == .asc || self.myCateType == .lyrics {
//                return Constant.mainHeight * 0.63
//            }
//        }
//        return UITableView.automaticDimension
//    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
     
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.height == 44.0 { return }
        shortCellHeights[indexPath] = cell.height
        longCellHeights[indexPath] = cell.height
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        UIView()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        0
    }
}

extension AllRecordCateDetailViewController {
    func lyricsCellBind(cell: AllrecordLyricsTableCell, data: CategoryRespone, indexPath: IndexPath) {
        cell.selfView.reportButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                let action = UIAlertAction(title: "신고하기", style: .default) { _ in
                    self?.viewModel.reportRecord(postId: data.recordID)
                    Account.currentReportRecordsId.append(data.recordID)
                }
                action.setValue(UIColor.mainOrange, forKey: "titleTextColor")
                self?.presentAlert(title: "", with: action, message: "이 레코드를 신고하시겠어요?", isCancelActionIncluded: true, preferredStyle: .alert)
            }).disposed(by: cell.disposeBag)

        cell.selfView.likeButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let count = Int(cell.selfView.likeCountLabel.text ?? "0")
                else { return }
                let userId = UserDefaults.standard.integer(forKey: "user")
                let recordId = data.recordID

                if cell.selfView.likeCountLabel.textColor == .mainOrange {
                    // 좋아요 취소
                    cell.selfView.likeButton.setImage(UIImage(named: "emptyLove"), for: .normal)
                    cell.selfView.likeCountLabel.textColor = .mainGrey3
                    cell.selfView.likeCountLabel.text = String(count - 1)
                    self?.viewModel.deleteLike(postId: recordId, userId: userId)
                } else {
                    // 좋아요 클릭
                    cell.selfView.likeButton.setImage(UIImage(named: "fillLove"), for: .normal)
                    cell.selfView.likeCountLabel.textColor = .mainOrange
                    cell.selfView.likeCountLabel.text = String(count + 1)
                    self?.viewModel.saveLike(postId: recordId, userId: userId)
                }
            }).disposed(by: cell.disposeBag)

        cell.selfView.scrapButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let scrapCount = Int(cell.selfView.scrapCountLabel.text ?? "0")
                else { return }
                let userId = UserDefaults.standard.integer(forKey: "user")
                let recordId = data.recordID

                if cell.selfView.scrapCountLabel.textColor == .mainOrange {
                    // 좋아요 취소
                    cell.selfView.scrapButton.setImage(UIImage(named: "emptyStar"), for: .normal)
                    cell.selfView.scrapCountLabel.textColor = .mainGrey3
                    cell.selfView.scrapCountLabel.text = String(scrapCount - 1)
                    self?.viewModel.deleteScrap(postId: recordId, userId: userId)
                } else {
                    // 좋아요 클릭
                    cell.selfView.scrapButton.setImage(UIImage(named: "fillStar"), for: .normal)
                    cell.selfView.scrapCountLabel.textColor = .mainOrange
                    cell.selfView.scrapCountLabel.text = String(scrapCount + 1)
                    self?.viewModel.saveScrap(postId: recordId, userId: userId)
                }
            }).disposed(by: cell.disposeBag)

        cell.selfView.nicknameLabel.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                let rp = RecordsRepositoryImpl(recordAPI: RecordAPI())
                let uc = RecordsUseCase(recordsRepository: rp)
                let vm = MyDjProfileViewModel(usecase: uc)
                let vc = MydjProfileViewController(viewModel: vm, toId: data.userID)
                self?.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: cell.disposeBag)
    }

    func shortCellBind(cell: AllRecordCateShortDetailCell, data: CategoryRespone) {
        cell.myView.reportButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                let action = UIAlertAction(title: "신고하기", style: .default) { _ in
                    self?.viewModel.reportRecord(postId: data.recordID)
                    Account.currentReportRecordsId.append(data.recordID)
                }
                action.setValue(UIColor.mainOrange, forKey: "titleTextColor")
                self?.presentAlert(title: "", with: action, message: "이 레코드를 신고하시겠어요?", isCancelActionIncluded: true, preferredStyle: .alert)
            }).disposed(by: cell.disposeBag)

        cell.myView.likeButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let count = Int(cell.myView.likeCountLabel.text ?? "0")
                else { return }
                let userId = UserDefaults.standard.integer(forKey: "user")
                let recordId = data.recordID

                if cell.myView.likeCountLabel.textColor == .mainOrange {
                    // 좋아요 취소
                    cell.myView.likeButton.setImage(UIImage(named: "emptyLove"), for: .normal)
                    cell.myView.likeCountLabel.textColor = .mainGrey3
                    cell.myView.likeCountLabel.text = String(count - 1)
                    self?.viewModel.deleteLike(postId: recordId, userId: userId)
                } else {
                    // 좋아요 클릭
                    cell.myView.likeButton.setImage(UIImage(named: "fillLove"), for: .normal)
                    cell.myView.likeCountLabel.textColor = .mainOrange
                    cell.myView.likeCountLabel.text = String(count + 1)
                    self?.viewModel.saveLike(postId: recordId, userId: userId)
                }
            }).disposed(by: cell.disposeBag)

        cell.myView.scrapButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let scrapCount = Int(cell.myView.scrapCountLabel.text ?? "0")
                else { return }
                let userId = UserDefaults.standard.integer(forKey: "user")
                let recordId = data.recordID

                if cell.myView.scrapCountLabel.textColor == .mainOrange {
                    // 좋아요 취소
                    cell.myView.scrapButton.setImage(UIImage(named: "emptyStar"), for: .normal)
                    cell.myView.scrapCountLabel.textColor = .mainGrey3
                    cell.myView.scrapCountLabel.text = String(scrapCount - 1)
                    self?.viewModel.deleteScrap(postId: recordId, userId: userId)
                } else {
                    // 좋아요 클릭
                    cell.myView.scrapButton.setImage(UIImage(named: "fillStar"), for: .normal)
                    cell.myView.scrapCountLabel.textColor = .mainOrange
                    cell.myView.scrapCountLabel.text = String(scrapCount + 1)
                    self?.viewModel.saveScrap(postId: recordId, userId: userId)
                }
            }).disposed(by: cell.disposeBag)

        cell.myView.nicknameLabel.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                let rp = RecordsRepositoryImpl(recordAPI: RecordAPI())
                let uc = RecordsUseCase(recordsRepository: rp)
                let vm = MyDjProfileViewModel(usecase: uc)
                let vc = MydjProfileViewController(viewModel: vm, toId: data.userID)
                self?.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: cell.disposeBag)
    }

    func longCellBind(cell: AllRecordCateLongDetailCell, data: CategoryRespone, indexPath: IndexPath) {
        cell.myView.reportButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                let action = UIAlertAction(title: "신고하기", style: .default) { _ in
                    self?.viewModel.reportRecord(postId: data.recordID)
                    Account.currentReportRecordsId.append(data.recordID)
                }
                action.setValue(UIColor.mainOrange, forKey: "titleTextColor")
                self?.presentAlert(title: "", with: action, message: "이 레코드를 신고하시겠어요?", isCancelActionIncluded: true, preferredStyle: .alert)
            }).disposed(by: cell.disposeBag)

        cell.myView.likeButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let count = Int(cell.myView.likeCountLabel.text ?? "0")
                else { return }
                let userId = UserDefaults.standard.integer(forKey: "user")
                let recordId = data.recordID

                if cell.myView.likeCountLabel.textColor == .mainOrange {
                    // 좋아요 취소
                    cell.myView.likeButton.setImage(UIImage(named: "emptyLove"), for: .normal)
                    cell.myView.likeCountLabel.textColor = .mainGrey3
                    cell.myView.likeCountLabel.text = String(count - 1)
                    self?.viewModel.deleteLike(postId: recordId, userId: userId)
                } else {
                    // 좋아요 클릭
                    cell.myView.likeButton.setImage(UIImage(named: "fillLove"), for: .normal)
                    cell.myView.likeCountLabel.textColor = .mainOrange
                    cell.myView.likeCountLabel.text = String(count + 1)
                    self?.viewModel.saveLike(postId: recordId, userId: userId)
                }
            }).disposed(by: cell.disposeBag)

        cell.myView.scrapButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let scrapCount = Int(cell.myView.scrapCountLabel.text ?? "0")
                else { return }
                let userId = UserDefaults.standard.integer(forKey: "user")
                let recordId = data.recordID

                if cell.myView.scrapCountLabel.textColor == .mainOrange {
                    // 좋아요 취소
                    cell.myView.scrapButton.setImage(UIImage(named: "emptyStar"), for: .normal)
                    cell.myView.scrapCountLabel.textColor = .mainGrey3
                    cell.myView.scrapCountLabel.text = String(scrapCount - 1)
                    self?.viewModel.deleteScrap(postId: recordId, userId: userId)
                } else {
                    // 좋아요 클릭
                    cell.myView.scrapButton.setImage(UIImage(named: "fillStar"), for: .normal)
                    cell.myView.scrapCountLabel.textColor = .mainOrange
                    cell.myView.scrapCountLabel.text = String(scrapCount + 1)
                    self?.viewModel.saveScrap(postId: recordId, userId: userId)
                }
            }).disposed(by: cell.disposeBag)

        if !(self.expandedIndexSet2.contains(indexPath.row)) {
        cell.myView.readMoreButton.rx
            .tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                    self.expandedIndexSet.insert(indexPath.row)
                self.selfView.tableView.reloadRows(at: [indexPath], with: .none)
            })
            .disposed(by: cell.disposeBag)
        }

        cell.myView.nicknameLabel.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                let rp = RecordsRepositoryImpl(recordAPI: RecordAPI())
                let uc = RecordsUseCase(recordsRepository: rp)
                let vm = MyDjProfileViewModel(usecase: uc)
                let vc = MydjProfileViewController(viewModel: vm, toId: data.userID)
                self?.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: cell.disposeBag)
    }
}
