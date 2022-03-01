//
//  SearchViewModel.swift
//  Omos
//
//  Created by sangheon on 2022/02/09.
//

import Foundation
import RxSwift

class SearchViewModel :BaseViewModel{
    
    let loading = BehaviorSubject<Bool>(value:false)
    let musics = BehaviorSubject<[Stock]>(value:[])
    let isEmpty = PublishSubject<Bool>()
    let errorMessage = BehaviorSubject<String?>(value: nil)
    var currentMusic:[Stock] = []
    let usecase:MusicUseCase
    
    func searchQeuryChanged(query:String) {
        loading.onNext(true)
        usecase.fetchMusicList(keyword: query)
            .subscribe({ [weak self] event in
                self?.loading.onNext(false)
                switch event {
                case .success(let data):
                    self?.currentMusic = data.items
                    self?.musics.onNext(data.items)
                case .failure(let error):
                    self?.errorMessage.onNext(error.localizedDescription)
                }
            }).disposed(by: disposeBag)
    }
    
    init(usecase:MusicUseCase) {
        self.usecase = usecase
        super.init()
        self.reduce()
    }
    
    func reduce() {
        musics
            .withUnretained(self)
            .subscribe(onNext: { owner,musics in
                if musics.isEmpty {
                    owner.isEmpty.onNext(true)
                } else {
                    owner.isEmpty.onNext(false)
                }
            }).disposed(by: disposeBag)
    }
    
}
