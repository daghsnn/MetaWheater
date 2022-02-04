//
//  NetworkManager.swift
//  MetaWheater
//
//  Created by Hasan Dag on 4.02.2022.
//

import Alamofire

enum ReachabilityType: String {
    case wifi
    case cellular
    case none
}

final class NetworkReachableManager : NSObject {
    
    static let shared : NetworkReachableManager = NetworkReachableManager()
    private var disconnected: Bool = false
    
    private(set) var reachabilityManager: NetworkReachabilityManager!
    
    var reachabilityType: ReachabilityType {
        guard reachabilityManager.isReachable else { return .none }
        if reachabilityManager.isReachableOnCellular {
            return .cellular
        }
        return .wifi
    }
    
    override init() {
        super.init()
        self.configureReachability()
    }
    
    func configureReachability() {
        reachabilityManager = NetworkReachabilityManager(host: "www.google.com")
        reachabilityManager.startListening { [weak self] (status) in
            guard let self = self else { return }
            
            if case .reachable = status, self.disconnected == true {
                self.disconnected = false
                print("Yeniden bağlandı")
            }
            if status == .notReachable {
                self.disconnected = true
                print("Bağlantı hatası")
            }
        }
    }
}

final class NetworkLogger {
    
    class func printNetworkCall(url: String?,
                                methodType: HTTPMethod?,
                                body: [String: Any]?,
                                response: Any?,
                                headers: HTTPHeaders? = nil,
                                statusCode: Int?) {
        #if DEBUG
        print("""
            --------------------------------------------------
            ☆ Request Url : \(url ?? "")
            ☆ Request Type : \((methodType as AnyObject))
            ☆ Request Headers: \(headers?.description ?? "")
            ☆ Request Parameters : \((body as AnyObject))
            ▽ ▽ ▽ ▽ ▽ ▽ ▽ ▽ ▽ ▽ ▽ ▽ ▽ ▽ ▽ ▽ ▽ ▽ ▽
            ◁ Response
            ◁ Status Code: \(statusCode ?? -1)
            ◁ \n\((response as AnyObject))
            ◁
            --------------------------------------------------
            """)
        #endif
    }
}

extension NetworkReachableManager {
    func log<Request,Response>(_ service : BaseService<Request,Response>,
                               _ response: DataResponse<Any, AFError>?) {
        guard let data = try? JSONEncoder().encode(service.requestModel) else { return }
        let dict = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : Any]
        NetworkLogger.printNetworkCall(url: service.path,
                                       methodType: service.method,
                                       body: dict,response: response?.value,
                                       headers: response?.request?.headers,
                                       statusCode: response?.response?.statusCode)
    }
}
