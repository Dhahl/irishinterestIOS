// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation

public protocol DataIO {
    func read() -> Data?
    func write(data: Data) throws
}