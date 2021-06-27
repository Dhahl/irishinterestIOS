// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation

public class LocalStore<Type: Codable> {
    public typealias Element = Type

    private let dataIO: DataIO

    public init(fileURL url: URL) {
        dataIO = FileDataIO(fileURL: url)
    }

    public init(userDefaultsKey key: String) {
        dataIO = UserDefaultsDataIO(key: key)
    }

    public func read() -> Type? {
        guard let data = dataIO.read() else {
            return nil
        }
        return try? JSONDecoder().decode(Element.self, from: data)
    }

    public func write(_ item: Type) throws {
        let data: Data = try JSONEncoder().encode(item)
        try dataIO.write(data: data)
    }
}