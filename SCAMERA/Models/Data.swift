

import Foundation

struct modulesData: Codable{
    let modules: [modulesInnerData]
}

struct modulesInnerData: Codable{
    let unique_id: String
    let whitelists:[String]
}

struct whitelistData:Codable{
    let whitelists: [String]
}

struct platesData: Codable{
    let plates:[String]
    let whitelist_name:String
}

struct attemptData:Codable{
    var date:String
    var got_access:Bool
    var id:Int
    var plate: String
    var processed_plate_string:String
}
struct attemptsData:Codable{
    var access_attempts: [attemptData]
}
