import Foundation

class SVGParserRegexHelper {

    fileprivate static let transformPattern = "\\-?\\d+\\.?\\d*e?\\-?\\d*"
    fileprivate static let textElementPattern = "<text.*?>((?s:.*))<\\/text>"

    fileprivate static var transformMatcher: NSRegularExpression?
    fileprivate static var textElementMatcher: NSRegularExpression?

    class func getTransformMatcher() -> NSRegularExpression? {
        if self.transformMatcher == nil {
            do {
                self.transformMatcher = try NSRegularExpression(pattern: transformPattern, options: .caseInsensitive)
            } catch {

            }
        }
        return self.transformMatcher
    }

    class func getTextElementMatcher() -> NSRegularExpression? {
        if self.textElementMatcher == nil {
            do {
                self.textElementMatcher = try NSRegularExpression(pattern: textElementPattern, options: .caseInsensitive)
            } catch {

            }
        }
        return self.textElementMatcher
    }
}
