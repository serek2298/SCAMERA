

import Foundation
import Swagger
import SwagGenKit

enum networking {
    case Success
    case Failure
    case SuccessDeleted
    case FailureDeleted
}
protocol LoginDelegate {
    func didFinished(what: networking)
    
}
protocol registerDelegate {
    func didFinished(what: networking)
    
}
protocol getDataDelegate {
    func didFinished(what: networking)
    
}
protocol addPlateDelegate {
    func didFinished(what: networking)
    
}
protocol addModuleDelegate {
    func didFinished(what: networking)
    
}
protocol addWhitelistToModuleDelegate {
    func didFinished(what: networking)
    
}
protocol createWhitelistDelegate{
    func didFinishes(what: networking)
}

class API{
    let baseUrl = "192.168.1.24:5000/api"
    var loginDelegate:LoginDelegate?
    var registerDelegate:registerDelegate?
    var getDataDelegate:getDataDelegate?
    var addPlateDelegate:addPlateDelegate?
    var addModuleDelegate:addModuleDelegate?
    var createWhitelsitDelegate:createWhitelistDelegate?
    var addWhitelistToModuleDelegate:addWhitelistToModuleDelegate?
    var user : User?
    
    func getWhitelists(username:String,password:String){
        let modulesUrl = "http://\(baseUrl)/get_whitelists"
        perfmormWhitelists(urlString: modulesUrl,username: username,password: password)
        
    }
    func login(username: String,password:String){
        let urlString = "http:\(baseUrl)/get_modules"
        perfmormLogin(urlString: urlString,username: username,password: password)
        
    }
    
    func getPlates(username: String,password:String,whitelist_name:String){
        let urlString = "http:\(baseUrl)/get_plates_in_whitelist?whitelist_name=\(whitelist_name)"
        perfmormPlates(urlString: urlString,username: username,password: password)
        
    }
    func perfmormLogin(urlString: String,username: String,password:String){
        if let url = URL(string: urlString){
            let loginString = String(format: "%@:%@", username, password)
            let loginData = loginString.data(using: String.Encoding.utf8)!
            let base64LoginString = loginData.base64EncodedString()
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
            let session = URLSession(configuration: .default)
            
            
            let task = session.dataTask(with: request){(data,response,error) in
                if error != nil{
                    print(error!)
                    return
                }
                if let safeData = data{
                    
                    print(safeData)
                    if let modules = self.parseLogin(Data: safeData){
                        let user = User(username: username, password: password, modules:modules)
                        sharedUser = user
                        DispatchQueue.main.async {
                            self.loginDelegate?.didFinished(what: .Success)
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.loginDelegate?.didFinished(what: .Failure)
                        }
                    }
                }
            }
            task.resume()
            
        }
    }
    func perfmormWhitelists(urlString: String,username: String,password:String){
        if let url = URL(string: urlString){
            let loginString = String(format: "%@:%@", username, password)
            let loginData = loginString.data(using: String.Encoding.utf8)!
            let base64LoginString = loginData.base64EncodedString()
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
            let session = URLSession(configuration: .default)
            
            
            let task = session.dataTask(with: request){(data,response,error) in
                if error != nil{
                    print(error!)
                    return
                }
                if let safeData = data{
                    

                    if let whitelists = self.parseWhitelists(Data: safeData){
                        if (self.user?.username) != nil{
                            self.user?.whitelists = whitelists
                        }
                        for name in whitelists{
                            self.getPlates(username: username, password: password, whitelist_name: name.name)
                        }
                        sharedUser.whitelists = whitelists
                        
                    }
                }
            }
            task.resume()
            
        }
    }
    func perfmormPlates(urlString: String,username: String,password:String){
        if let url = URL(string: urlString){
            let loginString = String(format: "%@:%@", username, password)
            let loginData = loginString.data(using: String.Encoding.utf8)!
            let base64LoginString = loginData.base64EncodedString()
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
            let session = URLSession(configuration: .default)
            
            
            let task = session.dataTask(with: request){(data,response,error) in
                if error != nil{
                    print(error!)
                    return
                }
                if let safeData = data{
                    if let plates = self.parsePlates(Data: safeData),let wl = sharedUser.whitelists?.count{
                        for n in 0..<wl{
                            if(sharedUser.whitelists![n].name == plates.whitelist_name){
                                sharedUser.whitelists![n].plates = plates.plates
                                DispatchQueue.main.async {
                                    self.getDataDelegate?.didFinished(what: .Success)
                                }
                            }
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.getDataDelegate?.didFinished(what: .Failure)
                        }
                    }
                }
            }
            task.resume()
            
        }
    }
    func parsePlates(Data: Data)->platesData?{
        let decoder = JSONDecoder()
        
        do{
            let decodedData = try decoder.decode(platesData.self, from: Data)
            return decodedData
        }catch{
            print("CHUJAAA\n")
            return nil
        }
    }
    func parseWhitelists(Data: Data)->[Whitelist]?{
        let decoder = JSONDecoder()
        
        do{
            let decodedData = try decoder.decode(whitelistData.self, from: Data)
            var whitelists = [Whitelist]()
            for whitelist in decodedData.whitelists {
                whitelists.append(Whitelist(name: whitelist, plates: nil))
            }
            return whitelists
        }catch{
            print("CHUJAAA\n")
            return nil
        }
    }
    func parseLogin(Data: Data)->[Module]?{
        let decoder = JSONDecoder()
        
        do{
            let decodedData = try decoder.decode(modulesData.self, from: Data)
            var modules = [Module]()
            for name in decodedData.modules {
                var whitelists = [String]()
                for wl in name.whitelists{
                    whitelists.append(wl)
                }
                modules.append(Module(unique_id: name.unique_id, whitelists: whitelists, isActive: false))
            }
            return modules
        }catch{
            print("CHUJAAA\n")
            return nil
        }
    }
    func addModule(module_id: String){
        let urlString = "http:\(baseUrl)/bind_module?unique_id=\(module_id)"
        if let url = URL(string: urlString){
            let loginString = String(format: "%@:%@", sharedUser.username, sharedUser.password)
            let loginData = loginString.data(using: String.Encoding.utf8)!
            let base64LoginString = loginData.base64EncodedString()
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: request){(data,response,error) in
                if error != nil{
                    print(error!)
                    return
                }
                if let httpresponse  = response as? HTTPURLResponse{
                    if httpresponse.statusCode == 201{
                        
                        sharedUser.modules?.append(Module(unique_id: module_id, isActive: false))
                        DispatchQueue.main.async {
                            self.addModuleDelegate?.didFinished(what: .Success)
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.addModuleDelegate?.didFinished(what: .Failure)
                        }}
                    
                }
            }
            task.resume()
            
        }
    }
    func deleteModule(module_id: String){
        let urlString = "http:\(baseUrl)/unbind_module?unique_id=\(module_id)"
        if let url = URL(string: urlString){
            let loginString = String(format: "%@:%@", sharedUser.username, sharedUser.password)
            let loginData = loginString.data(using: String.Encoding.utf8)!
            let base64LoginString = loginData.base64EncodedString()
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: request){(data,response,error) in
                if error != nil{
                    print(error!)
                    return
                }
                if let httpresponse  = response as? HTTPURLResponse{
                    if httpresponse.statusCode == 201{
                        for n in 1...sharedUser.modules!.count{
                            if sharedUser.modules?[n-1].unique_id == module_id{
                                sharedUser.modules?.remove(at: n-1)
                                break
                            }
                        }
                        DispatchQueue.main.async {
                            self.addModuleDelegate?.didFinished(what: .SuccessDeleted)
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.addModuleDelegate?.didFinished(what: .FailureDeleted)
                        }}
                    
                }
            }
            task.resume()
            
        }
    }
    func createWhitelist(whitelist_name:String){
        let urlString = "http:\(baseUrl)/create_whitelist?whitelist_name=\(whitelist_name)"
        if let url = URL(string: urlString){
            let loginString = String(format: "%@:%@", sharedUser.username, sharedUser.password)
            let loginData = loginString.data(using: String.Encoding.utf8)!
            let base64LoginString = loginData.base64EncodedString()
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
            let session = URLSession(configuration: .default)
    
            let task = session.dataTask(with: request){(data,response,error) in
                if error != nil{
                    print(error!)
                    return
                }
                if let httpresponse  = response as? HTTPURLResponse{
                    if httpresponse.statusCode == 201{
                        if data != nil{
                            sharedUser.whitelists?.append(Whitelist(name: whitelist_name, plates: nil))
                            DispatchQueue.main.async {
                                self.createWhitelsitDelegate?.didFinishes(what: .Success)
                            }
                        }}else{
                            DispatchQueue.main.async {
                                self.createWhitelsitDelegate?.didFinishes(what: .Failure)
                            }
                        }
                }
            }
            task.resume()
        }
    }
    func addWhitelistToModule(whitelist_name:String,unique_id:String){
        let urlString = "http:\(baseUrl)/bind_whitelist_to_module?whitelist_name=\(whitelist_name)&unique_id=\(unique_id)"
        if let url = URL(string: urlString){
            let loginString = String(format: "%@:%@", sharedUser.username, sharedUser.password)
            let loginData = loginString.data(using: String.Encoding.utf8)!
            let base64LoginString = loginData.base64EncodedString()
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: request){(data,response,error) in
                if error != nil{
                    print(error!)
                    return
                }
                if let httpresponse  = response as? HTTPURLResponse{
                    if httpresponse.statusCode == 201{
                        if data != nil{
                            for n in 1...sharedUser.modules!.count{
                                if sharedUser.modules?[n-1].unique_id == unique_id{
                                    if(sharedUser.modules?[n-1].whitelists == nil){sharedUser.modules?[n-1].whitelists = [String]()}
                                    sharedUser.modules?[n-1].whitelists?.append(whitelist_name)
                                }
                            }
                            DispatchQueue.main.async {
                                self.addWhitelistToModuleDelegate?.didFinished(what: .Success)
                                
                            }
                        }}else{
                            DispatchQueue.main.async {
                                self.addWhitelistToModuleDelegate?.didFinished(what: .Failure)
                            }
                        }
                    
                }
            }
            task.resume()
            
        }
    }
    func addPlate(whitelist_name:String,plate:String){
        let urlString = "http:\(baseUrl)/add_plate_to_whitelist?whitelist_name=\(whitelist_name)&plate_text=\(plate)"
        if let url = URL(string: urlString){
            let loginString = String(format: "%@:%@", sharedUser.username, sharedUser.password)
            let loginData = loginString.data(using: String.Encoding.utf8)!
            let base64LoginString = loginData.base64EncodedString()
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: request){(data,response,error) in
                if error != nil{
                    print(error!)
                    return
                }
                if let httpresponse  = response as? HTTPURLResponse{
                    if httpresponse.statusCode == 201{
                        if data != nil{
                            for n in 1...sharedUser.whitelists!.count{
                                if sharedUser.whitelists?[n-1].name == whitelist_name{
                                    sharedUser.whitelists?[n-1].plates?.append(plate)
                                    if(sharedUser.whitelists?[n-1].plates?.last == nil){
                                        let temp:[String] = [plate]
                                        sharedUser.whitelists?[n-1].plates = temp
                                    }
                                    break
                                }
                            }
                            DispatchQueue.main.async {
                                self.addPlateDelegate?.didFinished(what: .Success)
                                
                            }
                        }}else{
                            DispatchQueue.main.async {
                                self.addPlateDelegate?.didFinished(what: .Failure)
                            }
                        }
                    
                }
            }
            task.resume()
            
        }
    }
    func deleteWhitelistFromModule(whitelist_name:String,unique_id:String,index:Int){
        let urlString = "http:\(baseUrl)/unbind_whitelist_from_module?whitelist_name=\(whitelist_name)&unique_id=\(unique_id)"
        if let url = URL(string: urlString){
            let loginString = String(format: "%@:%@", sharedUser.username, sharedUser.password)
            let loginData = loginString.data(using: String.Encoding.utf8)!
            let base64LoginString = loginData.base64EncodedString()
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: request){(data,response,error) in
                if error != nil{
                    print(error!)
                    return
                }
                if let httpresponse  = response as? HTTPURLResponse{
                    if httpresponse.statusCode == 201{
                        if data != nil{
                            print("deleteWhitelist success")
                            for n in 0..<sharedUser.modules!.count{
                                if sharedUser.modules?[n].unique_id == unique_id{
                                    for i in 0..<(sharedUser.modules?[n].whitelists!.count)!{
                                        if sharedUser.modules?[n].whitelists?[i] == whitelist_name{
                                            sharedUser.modules?[n].whitelists?.remove(at: i)
                                            break
                                        }
                                    }
                                }
                            }
                            DispatchQueue.main.async {
                                self.addWhitelistToModuleDelegate?.didFinished(what: .SuccessDeleted)
                                
                            }
                        }}else{
                            print("deleteWhitelist failure")
                            DispatchQueue.main.async {
                                self.addWhitelistToModuleDelegate?.didFinished(what: .FailureDeleted)
                            }
                        }
                    
                }
            }
            task.resume()
            
        }
    }
    func getAttempts(module_index:Int){

        guard let unique_id = sharedUser.modules?[module_index].unique_id else {print("JAPIERDOLE");return}
        let urlString = "http:\(baseUrl)/get_access_attempts_for_module?unique_id=\(unique_id)"
        if let url = URL(string: urlString){
            let loginString = String(format: "%@:%@", sharedUser.username, sharedUser.password)
            let loginData = loginString.data(using: String.Encoding.utf8)!
            let base64LoginString = loginData.base64EncodedString()
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: request){(data,response,error) in
                if error != nil{
                    print(error!)
                    return
                }

                if let safeData = data{
                    let decoder = JSONDecoder()
                    do{
                        let decodedData = try decoder.decode(attemptsData.self, from: safeData)
                        DispatchQueue.main.async {
                            sharedUser.modules?[module_index].attempts = decodedData.access_attempts
                        }
                    }catch{
                        print("dokodowanie zakonczone porażką\n")
                        print(error)
                    }
                    
                }
            }
            task.resume()
            
        }
    }
    func register(user:User){
        // /register
    }
    
    
}

