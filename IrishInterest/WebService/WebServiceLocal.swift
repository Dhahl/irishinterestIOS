// Copyright © 2021 Balazs Perlaki-Horvath, PerlakiDigital. All rights reserved.

import Foundation
import RxSwift

struct WebServiceLocal: WebService {
    
    let decoder = JSONDecoder()
    
    func categories() -> Observable<[Category]> {
        let s: String = """
        {
            "response": [
                {
                    "id": 1,
                    "Name": "Art",
                    "Description": "Art"
                },
                {
                    "id": 2,
                    "Name": "History",
                    "Description": "History"
                },
                {
                    "id": 5,
                    "Name": "Autobiography",
                    "Description": "autobiography"
                },
                {
                    "id": 6,
                    "Name": "Biography",
                    "Description": "biography"
                },
                {
                    "id": 7,
                    "Name": "Business",
                    "Description": "business"
                },
                {
                    "id": 8,
                    "Name": "Culture",
                    "Description": "culture"
                },
                {
                    "id": 9,
                    "Name": "Cuisine",
                    "Description": "cuisine"
                },
                {
                    "id": 10,
                    "Name": "Education",
                    "Description": "education"
                },
                {
                    "id": 11,
                    "Name": "Fiction",
                    "Description": "fiction"
                },
                {
                    "id": 12,
                    "Name": "Childrens",
                    "Description": "childrens"
                },
                {
                    "id": 13,
                    "Name": "Film",
                    "Description": "film"
                },
                {
                    "id": 14,
                    "Name": "Geology",
                    "Description": "geology"
                },
                {
                    "id": 15,
                    "Name": "History culture",
                    "Description": "history culture"
                },
                {
                    "id": 17,
                    "Name": "Hobby",
                    "Description": "hobby"
                },
                {
                    "id": 18,
                    "Name": "Music",
                    "Description": "music"
                },
                {
                    "id": 19,
                    "Name": "Non-fiction",
                    "Description": "non-fiction"
                },
                {
                    "id": 20,
                    "Name": "Photography",
                    "Description": "photography"
                },
                {
                    "id": 21,
                    "Name": "Play",
                    "Description": "play"
                },
                {
                    "id": 23,
                    "Name": "Poetry",
                    "Description": "poetry"
                },
                {
                    "id": 24,
                    "Name": "Politics",
                    "Description": "politics"
                },
                {
                    "id": 25,
                    "Name": "Society",
                    "Description": "society"
                },
                {
                    "id": 27,
                    "Name": "Sports",
                    "Description": "sports"
                },
                {
                    "id": 28,
                    "Name": "Tourism",
                    "Description": "tourism"
                },
                {
                    "id": 29,
                    "Name": "Places to stay",
                    "Description": "places to stay"
                },
                {
                    "id": 30,
                    "Name": "Holidays",
                    "Description": "holidays"
                },
                {
                    "id": 31,
                    "Name": "Travel",
                    "Description": "travel"
                },
                {
                    "id": 33,
                    "Name": "Guide book/Reference book",
                    "Description": "Guide book/Reference book"
                },
                {
                    "id": 34,
                    "Name": "Gardens",
                    "Description": "Gardens/Gardening"
                },
                {
                    "id": 35,
                    "Name": "Archaeology",
                    "Description": "Archaeology"
                },
                {
                    "id": 36,
                    "Name": "Young Adult/Teen",
                    "Description": "Young Adult/Teen"
                },
                {
                    "id": 37,
                    "Name": "Religion",
                    "Description": "Religion"
                },
                {
                    "id": 38,
                    "Name": "Lifestyle",
                    "Description": "Lifestyle"
                },
                {
                    "id": 39,
                    "Name": "Irish Language",
                    "Description": "Irish Language"
                },
                {
                    "id": 40,
                    "Name": "Memoir",
                    "Description": "Memoir"
                },
                {
                    "id": 41,
                    "Name": "Animals",
                    "Description": "Animals"
                },
                {
                    "id": 42,
                    "Name": "Humor",
                    "Description": "Humor"
                },
                {
                    "id": 43,
                    "Name": "Historical Fiction ",
                    "Description": "Historical Fiction "
                },
                {
                    "id": 44,
                    "Name": "Journal",
                    "Description": "Journal"
                },
                {
                    "id": 45,
                    "Name": "Humanities",
                    "Description": "Humanities"
                },
                {
                    "id": 46,
                    "Name": "Language",
                    "Description": "Language "
                },
                {
                    "id": 47,
                    "Name": "Literature ",
                    "Description": "Literature "
                },
                {
                    "id": 48,
                    "Name": "Law ",
                    "Description": "Law "
                },
                {
                    "id": 49,
                    "Name": "Medicine ",
                    "Description": "Medicine "
                },
                {
                    "id": 50,
                    "Name": "Science ",
                    "Description": "Science "
                },
                {
                    "id": 51,
                    "Name": "Earth Sciences ",
                    "Description": "Earth Sciences "
                },
                {
                    "id": 52,
                    "Name": "Technology",
                    "Description": "Technology "
                },
                {
                    "id": 53,
                    "Name": "Children ",
                    "Description": "Children "
                },
                {
                    "id": 54,
                    "Name": "Unknown E",
                    "Description": "Unknown E"
                },
                {
                    "id": 55,
                    "Name": "Unknown T",
                    "Description": "Unknown  T"
                }
            ],
            "token": null
        }
        """
        let response: ResponseCategories = try! decode(data: s.data(using: .utf8)!)
        return .just(response.response.sorted(by: { (a: Category, b: Category) in
            a.displayName <= b.displayName
        }))
    }
    
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
}
