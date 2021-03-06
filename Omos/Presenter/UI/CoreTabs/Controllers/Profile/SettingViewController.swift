//
//  SettingViewController.swift
//  Omos
//
//  Created by sangheon on 2022/03/18.
//

import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import UIKit

class SettingViewController: BaseViewController {
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "header")
        table.separatorStyle = .none
        table.backgroundColor = .mainBackGround
        table.showsVerticalScrollIndicator = false
        table.isScrollEnabled = false
        return table
    }()
    let viewModel: ProfileViewModel

    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        bind()
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.view.backgroundColor = .mainBackGround
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }

    override func configureUI() {
        super.configureUI()
        self.view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    func bind() {
        viewModel.logoutState
            .subscribe(onNext: { [weak self] state in
                if state {
                    let uc = LoginUseCase(authRepository: AuthRepositoryImpl(loginAPI: LoginAPI()))
                    let vm = LoginViewModel(usecase: uc)
                    let vc = LoginViewController(viewModel: vm)
                    UIApplication.shared.windows.first?.rootViewController = vc
                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                    self?.navigationController?.popToRootViewController(animated: false)
                }
            }).disposed(by: disposeBag)
    }

    private func logout() {
        // KAKAKO ????????????
        UserApi.shared.logout {error in
            if let error = error {
                print(error)
            } else {
                print("???????????? ??????")
            }
        }
        // APPLE ???????????? ??? ?????? ????????? ?????? ??????????????? ??????
        // reset UserDefault
        resetDefaults()
        viewModel.logOut(userId: Account.currentUser)
        Account.currentUser = -1
        // local
    }

    private func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .mainBackGround
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "????????? ??????"
            case 1:
                cell.textLabel?.text = "???????????? ??????"
            default:
                print("")
            }
        } else {
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "????????????"
            case 1:
                cell.textLabel?.text = "????????????"
            default:
                print("")
            }
        }

        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header")!
        if section == 0 {
            header.textLabel?.text = "????????????"
        } else {
            header.textLabel?.text = "????????????"
        }
        return header
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView {
            view.backgroundView?.backgroundColor = .mainBackGround
            view.textLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
            view.textLabel?.textColor = .mainOrange
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                let vc = ProfileChangeViewController(viewModel: viewModel)
                self.navigationController?.pushViewController(vc, animated: true)
            case 1:
                let vc = PasswordChangeViewController(viewModel: viewModel)
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                print("")
            }
        } else {
            switch indexPath.row {
            case 0:
                // logout
                let action = UIAlertAction(title: "????????????", style: .default) { _ in
                    self.logout()
                }
                action.setValue(UIColor.mainOrange, forKey: "titleTextColor")
                self.presentAlert(title: "", with: action, message: "?????? ???????????? ????????????????", isCancelActionIncluded: true, preferredStyle: .alert)
            case 1:
                let vc = AccountOutViewController(viewModel: viewModel)
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                print("")
            }
        }
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .mainBlack1
        return view
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.5
        } else {
            return 0
        }
    }
}
