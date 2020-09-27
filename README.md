# CoreNetwork

**CoreNetwork** is network layer build on URLSesssion without using third part libraries simple and easy to use.

## Installation

To add a package dependency to your Xcode project, select File > Swift Packages > Add Package Dependency and enter its repository URL. You can also navigate to your target’s General pane, and in the “Frameworks, Libraries, and Embedded Content” section, click the + button. In the “Choose frameworks and libraries to add” dialog, select Add Other, and choose Add Package Dependency.

~~~swift

dependencies: [
    .package(url: "https://github.com/DiegoCaroli/CoreNetwork.git", from: "1.0.0")
]

~~~

## Logger
You can enable the logger with an Environment Variable: **verbose_network_logger** to enable the log with four different levels of verbose from 1 to 4. 

## Usage

Using **NetworkLayer**  is really simple, you need to declare an **EndPointAPI** and a **NetworkManager** like the example below:

### EndPointAPI

~~~swift

import Foundation
import CoreNetwork

enum GitHubAPI {
    case users
    case users(String)
}

extension GitHubAPI: EndPointType {
    var baseURL: URL {
        guard let url = URL(string: "https://api.github.com") else{
            fatalError("Please provide valid URL")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .users: return "/users"
        case .user(let username): return "/users/\(username)"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }

    var task: HTTPTask {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }

    var sampleData: Data {
        return Data()
    }

}

~~~

### Task
You can use different types of task: 
* .requestPlain
* .requestData(Data)
* .requestJSONEncodable(Encodable)
* .requestCustomJSONEncodable(Encodable, encoder: JSONEncoder)
* .requestParameters(urlParameters: Parametes)
* .requestCompositeData(bodyData: Data, urlParameters: Parametes)
* .requestCompositeParameters(bodyParameters: Parametes, urlParameters: Parametes)

### NetworkManager

~~~swift

import CoreNetwork

class NetworkManager {

    let provider = Router<GitHubAPI>()

    func fetchUsers(completion @escaping (Result<User>, Error>) -> Void) {
        router.request(.users) { result in
        do {
            let response = try result.get()
            let user = try response.map(User.self)
        } catch {
            print(error.localizedDescription)
        }
      }
    }

}
~~~
