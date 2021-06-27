// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation

struct FileDataIO: DataIO {
    let url: URL

    init(fileURL: URL) {
        assert(fileURL.isFileURL, "Error! url should be a file URL")
        url = fileURL
    }

    func read() -> Data? {
        try? Data(contentsOf: url)
    }

    func write(data: Data) throws {
        try data.write(to: url)
    }

}