import CardParser
import XCTest

class TestCCValidator: XCTestCase {
    
    let americanExpressNumbers = [
        373867484422390, 377959119526293, 342030949859361,
        378809096932924, 340598394858882, 345459348424609,
        372313178485220, 370497105866404, 347914242888828
    ]
    
    let dinersClubNumbers = [
        30362723320576, 38839617015257, 30087439675753,
        30067597907446, 38861398148347, 36083937810426,
        30127375921801, 30317110158260, 30253658981898
    ]
    
    let discoverNumbers = [
        6011243526028329, 6011805052205610, 6011295761811736,
        6011925617967577, 6011602231112746, 6011830444184299,
        6011386781305583, 6011798934501878, 6011713578534887
    ]
    
    let jcbNumbers = [
        3528062122672865, 3528732131260577, 3528130273272254,
        3529436157866312, 3529044702880703, 3529881648108024,
        3530028330154281, 3530007072603416, 3530826104585063,
        3538134440571448, 3538528721470602, 3538528721470602,
        3538134440571448, 3538528721470602, 3538553155017166,
        3589747852651222, 3589455441381166, 3589557082574742
    ]
    
    let masterCardNumbers = [
        5129187892858887, 5316089796332584, 5324168430436389,
        5430534412386192, 5357811976339638, 5492842318918850,
        5327977939468223, 5517428927289239, 5243501311144896
    ]
    
    let visaNumbers = [
        4916743482352895, 4929115173208766, 4929111150993017,
        4532569705997925, 4532532346704936, 4539449005266755,
        4539647967252222, 4485278059645588, 4716218684717841,
        4916312540852, 4875293328226, 4539363085138,
        4485124016097, 4485888470472, 4532619444738,
        4556744269496, 4929217824669, 4485303685779,
        4917610000000000003, 4444333322221111, 4484070000000000
    ]
    
    let visaEletronNumbers = [
        4026822714436531, 4026876704511547, 4026708136587110,
        4175006618410151, 4175006107134254, 4175008866138385,
        4405432182452845, 4405074145776033, 4405252571817477,
        4508460883258076, 4508665737226075, 4508177462002150,
        4844674574513648, 4844076673470433, 4844217036488643,
        4913043770246047, 4913234258744773, 4913728443363605,
        4917872103882516, 4917618264737647, 4917555708382244
    ]
    
    let fakeCreditCardNumbers = [
        0, 12, 134, 1578, 187653, 122392389238923819,
        1234567890, 6666666666666666, 8888888888888, 111111111111111,
        090909090909, 1212121212, 33333, 444, 66, 1234123412341234
    ]
    
    let notNumbersStringInputs = [
        "12345678 ???", "A B C D", "1 2 E 4 S 6 7 B", "4242x24242424x42"
    ]
    
    func testEmptyString() {
         XCTAssertEqual(CardState(fromNumber: ""), CardState.invalid)
    }
    
    func testFakeNumbers() {
        fakeCreditCardNumbers.map(String.init).forEach {
            let state = CardState(fromNumber: $0)
            XCTAssertEqual(state, CardState.invalid, "\($0) resulted in incorrect state")
        }
        
        notNumbersStringInputs.forEach {
            let state = CardState(fromNumber: $0)
            XCTAssertEqual(state, CardState.invalid, "\($0) resulted in incorrect state")
        }
    }
    
    func testVisaNumbers() {
        visaNumbers.map(String.init).forEach {
            let state = CardState(fromNumber: $0)
            XCTAssertEqual(state, CardState.identified(CardType.visa), "\($0) resulted in incorrect state")
        }
        
        visaEletronNumbers.map(String.init).forEach {
            let state = CardState(fromNumber: $0)
            XCTAssertEqual(state, CardState.identified(CardType.visa), "\($0) resulted in incorrect state")
        }
    }
    
    func testMasterCardNumbers() {
        masterCardNumbers.map(String.init).forEach {
            let state = CardState(fromNumber: $0)
            XCTAssertEqual(state, CardState.identified(CardType.masterCard), "\($0) resulted in incorrect state")
        }
    }
    
    func testAmericanExpressNumbers() {
        americanExpressNumbers.map(String.init).forEach {
            let state = CardState(fromNumber: $0)
            XCTAssertEqual(state, CardState.identified(CardType.amex), "\($0) resulted in incorrect state")
        }
    }
    
    func testDiscoverNumbers() {
        discoverNumbers.map(String.init).forEach {
            let state = CardState(fromNumber: $0)
            XCTAssertEqual(state, CardState.identified(CardType.discover), "\($0) resulted in incorrect state")
        }
    }
    
    func testDinersClubNumbers() {
        dinersClubNumbers.map(String.init).forEach {
            let state = CardState(fromNumber: $0)
            XCTAssertEqual(state, CardState.identified(CardType.diners), "\($0) resulted in incorrect state")
        }
    }
    
    func testJCBNumbers() {
        jcbNumbers.map(String.init).forEach {
            let state = CardState(fromNumber: $0)
            XCTAssertEqual(state, CardState.identified(CardType.jcb), "\($0) resulted in incorrect state")
        }
    }
}
