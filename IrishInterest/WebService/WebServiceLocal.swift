// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import RxSwift

struct WebServiceLocal: WebService {
    func authors() -> Observable<[Author]> {
        let s: String = """
    {
        "response": [
            {
                "id": 24337,
                "firstname": "",
                "lastname": "   ",
                "dob": "0000-00-00",
                "profile": "",
                "contact": "",
                "address": "",
                "url": "",
                "image": null,
                "createdby": "/nielsen_xml/122370_71106_00_20200430_00",
                "altlink": ""
            },
            {
                "id": 25087,
                "firstname": "Donal",
                "lastname": " Drisceoil",
                "dob": null,
                "profile": "",
                "contact": null,
                "address": null,
                "url": null,
                "image": null,
                "createdby": "/nielsen_xml/122370_77946_00_20201216_00.upd",
                "altlink": null
            },
            {
                "id": 25088,
                "firstname": "Diarmuid",
                "lastname": " Drisceoil",
                "dob": null,
                "profile": "",
                "contact": null,
                "address": null,
                "url": null,
                "image": null,
                "createdby": "/nielsen_xml/122370_77946_00_20201216_00.upd",
                "altlink": null
            },
            {
                "id": 1560,
                "firstname": "various",
                "lastname": "-",
                "dob": "0000-00-00",
                "profile": "",
                "contact": "",
                "address": "",
                "url": "",
                "image": "",
                "createdby": "1",
                "altlink": ""
            },
            {
                "id": 23081,
                "firstname": "Moane",
                "lastname": ",Moane, G.",
                "dob": "0000-00-00",
                "profile": "",
                "contact": "",
                "address": "",
                "url": "",
                "image": null,
                "createdby": "/nielsen_xml/122370_57280_00_20180622_00",
                "altlink": ""
            },
            {
                "id": 24919,
                "firstname": "Reidun",
                "lastname": "(Reidun's Harp Centre)",
                "dob": "0000-00-00",
                "profile": "",
                "contact": "",
                "address": "",
                "url": "",
                "image": null,
                "createdby": "/nielsen_xml/122370_75746_01_20201012_00",
                "altlink": ""
            },
            {
                "id": 23574,
                "firstname": "",
                "lastname": "***",
                "dob": "0000-00-00",
                "profile": "",
                "contact": "",
                "address": "",
                "url": "",
                "image": null,
                "createdby": "/nielsen_xml/122370_64270_01_20190328_00",
                "altlink": ""
            },
            {
                "id": 16702,
                "firstname": "MAHON",
                "lastname": "A",
                "dob": "0000-00-00",
                "profile": "",
                "contact": "",
                "address": "",
                "url": "",
                "image": null,
                "createdby": "122370_49204_01_20161018_01.add",
                "altlink": ""
            },
            {
                "id": 23679,
                "firstname": "Coleman",
                "lastname": "A. Dennehy",
                "dob": "0000-00-00",
                "profile": "",
                "contact": "",
                "address": "",
                "url": "",
                "image": null,
                "createdby": "/nielsen_xml/122370_65214_00_20190614_00",
                "altlink": ""
            },
            {
                "id": 17695,
                "firstname": "",
                "lastname": "A& L Goodbody Solicitors",
                "dob": "0000-00-00",
                "profile": "",
                "contact": "",
                "address": "",
                "url": "",
                "image": null,
                "createdby": "122370_49204_01_20161018_01.add",
                "altlink": ""
            },
            {
                "id": 22449,
                "firstname": "",
                "lastname": "A&L Goodbody",
                "dob": "0000-00-00",
                "profile": "",
                "contact": "",
                "address": "",
                "url": "",
                "image": null,
                "createdby": "/nielsen_xml/122370_51424_01_20170911_00",
                "altlink": ""
            },
            {
                "id": 5112,
                "firstname": "F.H.A.",
                "lastname": "Aalen",
                "dob": "0000-00-00",
                "profile": "",
                "contact": "",
                "address": "",
                "url": "",
                "image": null,
                "createdby": "122370_49204_00_20161018_00.add",
                "altlink": ""
            },
            {
                "id": 24960,
                "firstname": "",
                "lastname": "Aaron Edwards",
                "dob": "0000-00-00",
                "profile": "",
                "contact": "",
                "address": "",
                "url": "",
                "image": null,
                "createdby": "/nielsen_xml/122370_75906_00_20201016_00",
                "altlink": ""
            },
            {
                "id": 24206,
                "firstname": "Marja",
                "lastname": "Aartsen",
                "dob": "0000-00-00",
                "profile": "",
                "contact": "",
                "address": "",
                "url": "",
                "image": null,
                "createdby": "/nielsen_xml/122370_69786_00_20200312_00",
                "altlink": ""
            },
            {
                "id": 22100,
                "firstname": "Erdal",
                "lastname": "Abaci",
                "dob": "0000-00-00",
                "profile": "",
                "contact": "",
                "address": "",
                "url": "",
                "image": null,
                "createdby": "/nielsen_xml/122370_50176_01_20170303_00",
                "altlink": ""
            },
            {
                "id": 3725,
                "firstname": "Vivienne",
                "lastname": "Abbott",
                "dob": "0000-00-00",
                "profile": "",
                "contact": "",
                "address": "",
                "url": "",
                "image": null,
                "createdby": "122370_49204_00_20161018_00.add",
                "altlink": ""
            },
            {
                "id": 19241,
                "firstname": "Richard",
                "lastname": "Abbott",
                "dob": "0000-00-00",
                "profile": "",
                "contact": "",
                "address": "",
                "url": "",
                "image": null,
                "createdby": "122370_49204_01_20161018_02.add",
                "altlink": ""
            },
            {
                "id": 2255,
                "firstname": "Annabel",
                "lastname": "Abbs",
                "dob": "0000-00-00",
                "profile": "Annabel Abbs grew up in Wales and Sussex, with stints in Dorset, Bristol and Hereford. She has a degree in English Literature from the University of East Anglia and a Masters in Marketing and Statistics from the University of Kingston. After fifteen years running a consultancy, she took a career break to bring up her four children, before returning to her first love, literature.",
                "contact": "",
                "address": "",
                "url": "http://www.annabelabbs.com/",
                "image": "author2255.png",
                "createdby": "1",
                "altlink": "https://twitter.com/annabelabbs"
            },
            {
                "id": 22966,
                "firstname": "Yoshi",
                "lastname": "Abe",
                "dob": "0000-00-00",
                "profile": "",
                "contact": "",
                "address": "",
                "url": "",
                "image": null,
                "createdby": "/nielsen_xml/122370_56360_00_20180521_00",
                "altlink": ""
            },
            {
                "id": 17026,
                "firstname": "Michael",
                "lastname": "Abecassis",
                "dob": "0000-00-00",
                "profile": "",
                "contact": "",
                "address": "",
                "url": "",
                "image": null,
                "createdby": "122370_49204_01_20161018_01.add",
                "altlink": ""
            },
            {
                "id": 2867,
                "firstname": "Nick",
                "lastname": "Abel",
                "dob": "0000-00-00",
                "profile": "",
                "contact": "",
                "address": "",
                "url": "",
                "image": null,
                "createdby": "122370_49204_00_20161018_00.add",
                "altlink": ""
            },
            {
                "id": 20443,
                "firstname": "Anthony M.",
                "lastname": "Abela",
                "dob": "0000-00-00",
                "profile": "",
                "contact": "",
                "address": "",
                "url": "",
                "image": null,
                "createdby": "122370_49204_01_20161018_03.add",
                "altlink": ""
            },
            {
                "id": 23461,
                "firstname": "Alan",
                "lastname": "Abernathy",
                "dob": "0000-00-00",
                "profile": "",
                "contact": "",
                "address": "",
                "url": "",
                "image": null,
                "createdby": "/nielsen_xml/122370_63370_00_20190115_00",
                "altlink": ""
            },
            {
                "id": 13358,
                "firstname": "Alan",
                "lastname": "Abernethy",
                "dob": "0000-00-00",
                "profile": "",
                "contact": "",
                "address": "",
                "url": "",
                "image": null,
                "createdby": "122370_49204_00_20161018_03.add",
                "altlink": ""
            },
            {
                "id": 23897,
                "firstname": "Daniel Aboye",
                "lastname": "Aberra",
                "dob": "0000-00-00",
                "profile": "",
                "contact": "",
                "address": "",
                "url": "",
                "image": null,
                "createdby": "/nielsen_xml/122370_66802_00_20191014_00",
                "altlink": ""
            },
            {
                "id": 3956,
                "firstname": "Kevin",
                "lastname": "Abosch",
                "dob": "0000-00-00",
                "profile": "",
                "contact": "",
                "address": "",
                "url": "",
                "image": null,
                "createdby": "122370_49204_00_20161018_00.add",
                "altlink": ""
            },
            {
                "id": 24588,
                "firstname": "Daniel",
                "lastname": "Aboye Aberra",
                "dob": "0000-00-00",
                "profile": "",
                "contact": "",
                "address": "",
                "url": "",
                "image": null,
                "createdby": "/nielsen_xml/122370_73546_00_20200727_00",
                "altlink": ""
            },
            {
                "id": 13114,
                "firstname": "William",
                "lastname": "Abrahamson",
                "dob": "0000-00-00",
                "profile": "",
                "contact": "",
                "address": "",
                "url": "",
                "image": null,
                "createdby": "122370_49204_00_20161018_03.add",
                "altlink": ""
            },
            {
                "id": 15114,
                "firstname": "Harold J.",
                "lastname": "Abramson",
                "dob": "0000-00-00",
                "profile": "",
                "contact": "",
                "address": "",
                "url": "",
                "image": null,
                "createdby": "122370_49204_01_20161018_00.add",
                "altlink": ""
            },
            {
                "id": 6312,
                "firstname": "Mike",
                "lastname": "Absalom",
                "dob": "0000-00-00",
                "profile": "",
                "contact": "",
                "address": "",
                "url": "",
                "image": null,
                "createdby": "122370_49204_00_20161018_01.add",
                "altlink": ""
            }
        ],
        "token": null
    }
"""
        let response: ResponseAuthors = try! JSONDecoder().decode(ResponseAuthors.self, from: s.data(using: .utf8)!)
        
        let authors: Observable<[Author]> = .just(response.response.sorted(by: { (a: Author, b: Author) in
            a.fullName <= b.fullName
        }))
        return authors
    }
    
    func authors(searching: Observable<String?>) -> Observable<[Author]> {
        return searching.flatMap { (value: String?) -> Observable<[Author]> in
            let authors: Observable<[Author]> = authors()
            guard let searchValue = value else { return authors }
            return authors.map { (list: [Author]) -> [Author] in
                list.filter { (author: Author) -> Bool in
                    author.fullName.lowercased().contains(searchValue.lowercased())
                }
            }
        }
    }
}
