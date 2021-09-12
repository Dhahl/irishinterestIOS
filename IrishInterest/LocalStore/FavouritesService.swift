// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import RxSwift

struct FavouritesService {
    
    let localStore = LocalStore<[Book]>(userDefaultsKey: "favourites")
    
    func localFavourites() -> Observable<[Book]> {
        return .just(localStore.read() ?? [])
    }
}
