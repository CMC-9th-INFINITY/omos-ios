//
//  MyDjViewModel.swift
//  Omos
//
//  Created by sangheon on 2022/03/13.
//


import RxSwift

class MyDjProfileViewModel:BaseViewModel {
    
    let isEmpty = BehaviorSubject<Bool>(value:false)
    let loading = BehaviorSubject<Bool>(value:false)
    let mydjProfile = PublishSubject<MyDjProfileResponse>()
    var currentMydjProfile:MyDjProfileResponse? = nil
    let usecase:RecordsUseCase
    let errorMessage = BehaviorSubject<String?>(value: nil)
    
    func fetchMyDjProfile(fromId:Int,toId:Int) {
        loading.onNext(true)
        usecase.myDjProfile(fromId: fromId, toId: toId)
            .subscribe({ [weak self] event in
                self?.loading.onNext(false)
                switch event {
                case .success(let data):
                    self?.currentMydjProfile = data
                    self?.mydjProfile.onNext(data)
                case .failure(let error):
                    self?.errorMessage.onNext(error.localizedDescription)
                }
            }).disposed(by: disposeBag)
    }
    
    func fetchUserRecords(fromId:Int,toId:Int) {
      
        usecase.userRecords(fromId: fromId, toId: toId)
            .subscribe({ [weak self] event in
               
                switch event {
                case .success(let data):
                    
                case .failure(let error):
                    self?.errorMessage.onNext(error.localizedDescription)
                }
            }).disposed(by: disposeBag)
    }
    
    //follow
    func saveFollow(fromId:Int,toId:Int) {
        usecase.saveFollow(fromId: fromId, toId: toId)
            .subscribe({ state in
                print(state)
            }).disposed(by: disposeBag)
    }
    
    func deleteFollow(fromId:Int,toId:Int) {
        usecase.deleteFollow(fromId: fromId, toId: toId)
            .subscribe({ state in
                print(state)
            }).disposed(by: disposeBag)
    }
    
   
    init(usecase:RecordsUseCase) {
        self.usecase = usecase
        super.init()
    }
    
    func reduce() {
        mydjProfile
            .withUnretained(self)
            .subscribe(onNext: { owner,record in
                if owner.currentMydjProfile == nil {
                    owner.isEmpty.onNext(true)
                } else {
                    owner.isEmpty.onNext(false)
                }
            }).disposed(by: disposeBag)

    }
}
