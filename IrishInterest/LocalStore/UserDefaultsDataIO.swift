// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation

struct UserDefaultsDataIO: DataIO {

    let key: String
    let store: UserDefaults

    init(key: String, store: UserDefaults = UserDefaults.standard) {
        self.key = key
        self.store = store
    }
    
    func read() -> Data? {
        store.data(forKey: key)
    }

    func write(data: Data) throws {
        store.set(data, forKey: key)
    }
}