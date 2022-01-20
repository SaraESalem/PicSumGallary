
import UIKit

extension String {

    var timeAgo: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"//"yyyy-MM-dd'T'HH:mm:ssZ"//"yyyy-MM-dd'T'HH:mm:ssZZZZZ"//"yyyy-MM-dd HH:mm:ss" //2020-09-22T11:49:50.000000Z
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        if let date = dateFormatter.date(from: self) {
            let calendar = Calendar.current
            let now = Date()
       
           // print(Date().localDateString())
            
            let earliest = (now as NSDate).earlierDate(date)
            let latest = (earliest == now) ? date : now
            let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
            
        }
        
        return ""
    }
    
    func index(at position: Int, from start: Index? = nil) -> Index? {
        let startingIndex = start ?? startIndex
        return index(startingIndex, offsetBy: position, limitedBy: endIndex)
    }
    
    func character(at position: Int) -> Character? {
        guard position >= 0, let indexPosition = index(at: position) else {
            return nil
        }
        return self[indexPosition]
    }
    
    func convertToEnglishNumbers()-> NSNumber {
        let formatter = NumberFormatter()
        
        formatter.locale = NSLocale(localeIdentifier: "EN") as Locale
        if let final = formatter.number(from: self) {
            return final
        }
        
        return 0
    }
    
    var localizedString: String {
        return NSLocalizedString(self, comment: "")
    }
    
    var firstUppercased: String {
        guard let first = first else { return "" }
        return String(first).uppercased() + dropFirst()
    }
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var removedSpaces: String? {
        return self.replacingOccurrences(of: "{0}", with: "")
    }
    
    var underlined: NSAttributedString? {
        return underlined(withColor: .white)
    }
    
    func underlined(withColor color : UIColor) -> NSAttributedString? {
        let color = color
        
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single, NSAttributedString.Key.foregroundColor: color] as [NSAttributedString.Key : Any]
        let attributedString = NSAttributedString(string: self, attributes: underlineAttribute)
        return attributedString
    }
    
    func formatLocalizedString(withValue newValue: String) -> String{
        return self.replacingOccurrences(of: "{0}", with: newValue)
    }
    
    func formatLocalizedString(firstValue firstStr: String, secondValue secondStr: String) -> String {
        var formattedString = self.replacingOccurrences(of: "{0}", with: firstStr)
        formattedString = formattedString.replacingOccurrences(of: "{1}", with: secondStr)
        return formattedString
    }
    
    ///
    
    /// Calculates string width based on max height and font
    ///
    /// - Parameters:
    ///   - height: max height
    ///   - font: font used
    /// - Returns: text width
    func widthWithConstrainedHeight(height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.width
    }
    
    
    /// Calculates string height based on max width and font
    ///
    /// - Parameters:
    ///   - width: max width
    ///   - font: font uesd
    /// - Returns: text hight
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
    
    func getFullDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSxxx"
        let dateObject = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.dateStyle = .medium
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        if dateObject != nil {
            let date = dateFormatter.string(from: dateObject!)
            return date
        } else {
            return " "
        }
    }
    
    func formattedDate(with format:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSxxx"
        let dateObject = dateFormatter.date(from: self)
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        if dateObject != nil {
            let date = dateFormatter.string(from: dateObject!)
            return date
        } else {
            return " "
        }
    }
    
    func multipleFontString(withUniqueText unique: String, uiniqueFont uniqueFont: UIFont, andNormalFont normalFont: UIFont) -> NSAttributedString {
        let string = NSString(string: self)
        let differentRange = string.range(of: unique)
        if differentRange.location != NSNotFound {
            let allAttr = [NSAttributedString.Key.font: normalFont]
            let vodafoneAttr = [NSAttributedString.Key.font: uniqueFont]
            
            let attributedText = NSMutableAttributedString(string: self, attributes: allAttr)
            attributedText.addAttributes(vodafoneAttr, range: differentRange)
            
            return attributedText
        }
        return NSAttributedString()
    }
    
    //: ### Base64 encoding a string
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    //: ### Base64 decoding a string
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
    func validatePhoneNumber() -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: self)
        return result
    }
    
    func isURL () -> Bool {
        
        if let url  = NSURL(string: self) {
            return UIApplication.shared.canOpenURL(url as URL)
        }
        return false
    }
    
    func deCodeImage () -> UIImage? {
        if let decodedData = Data(base64Encoded: self, options: .ignoreUnknownCharacters) {
            let image = UIImage(data: decodedData)
            return image
        }
        
        return nil
    }
    
    func withStrik() -> NSMutableAttributedString {
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
    
    func localized(_ lang: String) -> String {
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
    
    func stringByAddingPercentEncodingForFormUrlencoded() -> String? {
        let characterSet = NSMutableCharacterSet.alphanumeric()
        characterSet.addCharacters(in: "-._* ")
        
        return addingPercentEncoding(withAllowedCharacters: characterSet as CharacterSet)?.replacingOccurrences(of: " ", with: "+")
    }
    
    public var replacedArabicDigitsWithEnglish: String {
        var str = self
        let map = ["٠": "0",
                   "١": "1",
                   "٢": "2",
                   "٣": "3",
                   "٤": "4",
                   "٥": "5",
                   "٦": "6",
                   "٧": "7",
                   "٨": "8",
                   "٩": "9"]
        map.forEach { str = str.replacingOccurrences(of: $0, with: $1) }
        return str
    }
    
    
    func vaildStringUrl() -> String {
        guard let url = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("Invailed String URL")
            return "Invailed String URL"
        }
        return url.replacingOccurrences(of: " ", with: "%20")
    }
    
    func keepDecimalDigits() -> Int {
        if let number = Int(self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) {
            return number
        }
        print("keep Decimal Digits has fialed")
        return -1
    }
    
    func keepDoubleNumbers()-> Double {
        return NumberFormatter().number(from: self)?.doubleValue ?? 0.0
    }
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
}



extension Date {
    func localString(dateStyle: DateFormatter.Style = .medium, timeStyle: DateFormatter.Style = .medium) -> String {
        return DateFormatter.localizedString(from: self, dateStyle: dateStyle, timeStyle: timeStyle)
    }
}
extension Date {
  @nonobjc static var localFormatter: DateFormatter = {
    let dateStringFormatter = DateFormatter()
    dateStringFormatter.dateStyle = .medium
    dateStringFormatter.timeStyle = .medium
    return dateStringFormatter
  }()
  
  func localDateString() -> String
  {
    return Date.localFormatter.string(from: self)
  }
}


extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
