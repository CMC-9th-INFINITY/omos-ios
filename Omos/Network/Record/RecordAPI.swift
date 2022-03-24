//
//  RecordAPI.swift
//  Omos
//
//  Created by sangheon on 2022/03/02.
//

import Foundation
import Alamofire

class RecordAPI {
    
    func select(completion:@escaping(Result<SelectResponse,Error>) -> Void) {
        AF.request(RecordTarget.select,interceptor: TokenInterceptor.shared.getInterceptor()).responseDecodable { (response:AFDataResponse<SelectResponse>) in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    func recordDetail(postId:Int,userId:Int,completion:@escaping(Result<DetailRecordResponse,Error>) -> Void) {
        AF.request(RecordTarget.recordDetail(postId: postId, userId: userId),interceptor: TokenInterceptor.shared.getInterceptor()).responseDecodable { (response:AFDataResponse<DetailRecordResponse>) in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
        
    }
    
    func categoryFetch(cateType:cateType,request:CateRequest,completion:@escaping(Result<[CategoryRespone],Error>) -> Void) {
        
        AF.request(RecordTarget.category(cate: cateType, request: request),interceptor: TokenInterceptor.shared.getInterceptor()).responseDecodable { (response:AFDataResponse<[CategoryRespone]>) in
            switch response.result {
            case .success(let data):
                print(data)
                
                completion(.success(data))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    func myRecordFetch(userid:Int,completion:@escaping(Result<[MyRecordRespone],Error>) -> Void) {
        
        AF.request(RecordTarget.myRecord(userid: userid),interceptor: TokenInterceptor.shared.getInterceptor()).responseDecodable { (response:AFDataResponse<[MyRecordRespone]>) in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
        
    }
    
    func saveFetch(request:SaveRequest,completion:@escaping(Result<SaveRespone,Error>) -> Void) {
        AF.request(RecordTarget.save(request),interceptor: TokenInterceptor.shared.getInterceptor()).responseDecodable { (response:AFDataResponse<SaveRespone>) in
            switch response.result {
            case .success(let data):
                print(data)
                completion(.success(data))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    func recordIspublic(postId:Int,completion:@escaping(Result<StateRespone,Error>) -> Void) {
        AF.request(RecordTarget.recordIspublic(postId: postId),interceptor: TokenInterceptor.shared.getInterceptor()).responseDecodable { (response:AFDataResponse<StateRespone>) in
            switch response.result {
            case .success(let data):
                print(data)
                completion(.success(data))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    func recordDelete(postId:Int,completion:@escaping(Result<StateRespone,Error>) -> Void) {
        AF.request(RecordTarget.recordDelete(postId: postId),interceptor: TokenInterceptor.shared.getInterceptor()).responseDecodable { (response:AFDataResponse<StateRespone>) in
            switch response.result {
            case .success(let data):
                print(data)
                completion(.success(data))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    func recordUpdate(postId:Int,request:UpdateRequest,completion:@escaping(Result<StateRespone,Error>) -> Void) {
        AF.request(RecordTarget.recordUpdate(postId: postId,request),interceptor: TokenInterceptor.shared.getInterceptor()).responseDecodable { (response:AFDataResponse<StateRespone>) in
            switch response.result {
            case .success(let data):
                print(data)
                completion(.success(data))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
        
    }
    
    func oneMusicRecordFetch(musicId:String,request:OneMusicRecordRequest,completion:@escaping(Result<[OneMusicRecordRespone],Error>) -> Void) {
        AF.request(RecordTarget.oneMusicRecord(musicId: musicId, request),interceptor: TokenInterceptor.shared.getInterceptor()).responseDecodable { (response:AFDataResponse<[OneMusicRecordRespone]>) in
            switch response.result {
            case .success(let data):
                print(data)
                completion(.success(data))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    
    //MARK: Interaction API here
    func saveScrap(postId:Int,userId:Int,completion:@escaping(Result<StateRespone,Error>) -> Void) {
        AF.request(InteractionTarget.saveScrap(postId: postId, userId: userId),interceptor: TokenInterceptor.shared.getInterceptor()).responseDecodable { (response:AFDataResponse<StateRespone>) in
            switch response.result {
            case .success(let data):
                print(data)
                completion(.success(data))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    func deleteScrap(postId:Int,userId:Int,completion:@escaping(Result<StateRespone,Error>) -> Void) {
        AF.request(InteractionTarget.deleteScrap(postId: postId, userId: userId),interceptor: TokenInterceptor.shared.getInterceptor()).responseDecodable { (response:AFDataResponse<StateRespone>) in
            switch response.result {
            case .success(let data):
                print(data)
                completion(.success(data))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    func saveLike(postId:Int,userId:Int,completion:@escaping(Result<StateRespone,Error>) -> Void) {
        AF.request(InteractionTarget.saveLike(postId: postId, userId: userId),interceptor: TokenInterceptor.shared.getInterceptor()).responseDecodable { (response:AFDataResponse<StateRespone>) in
            switch response.result {
            case .success(let data):
                print(data)
                completion(.success(data))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    func deleteLike(postId:Int,userId:Int,completion:@escaping(Result<StateRespone,Error>) -> Void) {
        AF.request(InteractionTarget.deleteLike(postId: postId, userId: userId),interceptor: TokenInterceptor.shared.getInterceptor()).responseDecodable { (response:AFDataResponse<StateRespone>) in
            switch response.result {
            case .success(let data):
                print(data)
                completion(.success(data))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    //MARK: MyDj API
    func MyDjAllRecord(userId:Int,MyDjRequest:MyDjRequest,completion:@escaping(Result<[MyDjResponse],Error>) -> Void) {
        AF.request(RecordTarget.MyDjAllRecord(userId: userId, MyDjRequest),interceptor: TokenInterceptor.shared.getInterceptor()).responseDecodable { (response:AFDataResponse<[MyDjResponse]>) in
            switch response.result {
            case .success(let data):
                print(data)
                completion(.success(data))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    func saveFollow(fromId:Int,toId:Int,completion:@escaping(Result<StateRespone,Error>) -> Void) {
        AF.request(FollowTarget.saveFollow(fromId: fromId, toId: toId),interceptor: TokenInterceptor.shared.getInterceptor()).responseDecodable { (response:AFDataResponse<StateRespone>) in
            switch response.result {
            case .success(let data):
                print(data)
                completion(.success(data))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    func deleteFollow(fromId:Int,toId:Int,completion:@escaping(Result<StateRespone,Error>) -> Void) {
        AF.request(FollowTarget.deleteFollow(fromId: fromId, toId: toId),interceptor: TokenInterceptor.shared.getInterceptor()).responseDecodable { (response:AFDataResponse<StateRespone>) in
            switch response.result {
            case .success(let data):
                print(data)
                completion(.success(data))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    func myDjProfile(fromId:Int,toId:Int,completion:@escaping(Result<MyDjProfileResponse,Error>) -> Void) {
        AF.request(FollowTarget.myDjProfile(fromId: fromId, toId: toId),interceptor: TokenInterceptor.shared.getInterceptor()).responseDecodable { (response:AFDataResponse<MyDjProfileResponse>) in
            switch response.result {
            case .success(let data):
                print(data)
                completion(.success(data))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    func myDjList(userId:Int,completion:@escaping(Result<[MyDjListResponse],Error>) -> Void) {
        AF.request(FollowTarget.myDjList(userId: userId),interceptor: TokenInterceptor.shared.getInterceptor()).responseDecodable { (response:AFDataResponse<[MyDjListResponse]>) in
            switch response.result {
            case .success(let data):
                print(data)
                completion(.success(data))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    

    func userRecords(fromId:Int,toId:Int,completion:@escaping(Result<[MyDjResponse],Error>) -> Void) {
        AF.request(RecordTarget.userRecords(fromId: fromId, toId: toId),interceptor: TokenInterceptor.shared.getInterceptor()).responseDecodable { (response:AFDataResponse<[MyDjResponse]>) in
            switch response.result {
            case .success(let data):
                print(data)
                completion(.success(data))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    func reportRecord(postId:Int,completion:@escaping(Result<StateRespone,Error>) -> Void) {
        AF.request(RecordTarget.reportRecord(postId: postId),interceptor: TokenInterceptor.shared.getInterceptor()).responseDecodable { (response:AFDataResponse<StateRespone>) in
            switch response.result {
            case .success(let data):
                print(data)
                completion(.success(data))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    
}
