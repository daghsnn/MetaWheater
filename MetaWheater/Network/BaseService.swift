//
//  BaseService.swift
//  MetaWheater
//
//  Created by Hasan Dag on 4.02.2022.
//

import Alamofire

enum ErrorType: Error {
    case unReachable
    case domain
    case decoding
    case empty
}
protocol BaseRequestProtocol: Encodable {
    
}

struct BaseRequestModel : BaseRequestProtocol {
    
}

struct BaseResponseModel: Codable {
    
}

protocol APIConfiguration {
    associatedtype RequestModel
    var requestModel : RequestModel { get }

    var baseUrl : String { get }
    var method : Alamofire.HTTPMethod{ get}
    var path : String { get }
    var encoding : Alamofire.ParameterEncoding?{ get }
    var headers : HTTPHeaders { get }
}

class BaseService <BaseRequestModel:BaseRequestProtocol, BaseResponseModel: Decodable > : APIConfiguration {
    
    typealias ResultBlock = (Swift.Result<BaseResponseModel, ErrorType>) -> ()
    typealias responseModel = BaseResponseModel
    
    private var resultBlock: ResultBlock!
    
    var requestModel: BaseRequestModel?

    var baseUrl: String = "https://www.metaweather.com/"
    var headers: HTTPHeaders = HTTPHeaders.default
    var encoding: ParameterEncoding? = URLEncoding.httpBody
    var method: HTTPMethod = .get
    var path: String = String()

    func addParameterToUrlPath(_ parameterString : String) -> Self {
        self.path = self.path + "\(parameterString)"
        return self
    }
 
    
    func response(resultBlock: @escaping ResultBlock) {
        self.resultBlock = resultBlock
        configureRequest()
    }
  
    private func configureRequest() {
        if NetworkReachableManager.shared.reachabilityManager.isReachable {
            sendRequest()
        } else {
            self.resultBlock(.failure(.unReachable))
        }
    }
    
    private func sendRequest() {
        if path.count > 0 {
            baseUrl += path
        }
        AF.request(baseUrl,method: self.method,encoding: self.encoding!, headers: self.headers).responseJSON { (response) in
            NetworkReachableManager.shared.log(self, response)
            guard let data = response.data else { return}
            do {
                let baseResponse = try JSONDecoder().decode(BaseResponseModel.self, from: data)
                self.resultBlock(.success(baseResponse))
            } catch  {
                self.resultBlock(.failure(.decoding))
            }
        }
    }
    
}
