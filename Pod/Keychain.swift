import Security
import Foundation

public struct Keychain {
    public static func save(token: String) -> Bool {
        let data: NSData? = token.dataUsingEncoding(NSUTF8StringEncoding)
        if let data = data {
            let keychainQuery = [kSecClass as String: kSecClassGenericPassword as String,
                kSecAttrService as String: "com.nerdishbynature.octokit",
                kSecAttrAccount as String: "accessToken",
                kSecValueData as String: data] as CFDictionaryRef
            SecItemDelete(keychainQuery)
            let status: OSStatus = SecItemAdd(keychainQuery, nil)
            return status == 0
        }
        return false
    }

    public static func load() -> NSString? {
        // Instantiate a new default keychain query
        // Tell the query to return a result
        // Limit our results to one item
        var keychainQuery = NSMutableDictionary(dictionary: [kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "com.nerdishbynature.octokit",
            kSecAttrAccount as String: "accessToken",
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne])

        var dataTypeRef :Unmanaged<AnyObject>?

        // Search for the keychain items
        let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef)

        let opaque = dataTypeRef?.toOpaque()

        var contentsOfKeychain: NSString?

        if let op = opaque? {
            let retrievedData = Unmanaged<NSData>.fromOpaque(op).takeUnretainedValue()

            // Convert the data retrieved from the keychain into a string
            contentsOfKeychain = NSString(data: retrievedData, encoding: NSUTF8StringEncoding)
        } else {
            return nil
        }

        return contentsOfKeychain
    }
}
