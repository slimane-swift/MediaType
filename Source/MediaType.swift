// MediaType.swift
//
// The MIT License (MIT)
//
// Copyright (c) 2015 Zewo
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

enum MediaTypeError: ErrorType {
    case MalformedMediaTypeString
}

public struct MediaType: CustomStringConvertible {
    public let type: String
    public let subtype: String
    public let parameters: [String: String]

    public init(type: String, subtype: String, parameters: [String: String] = [:]) {
        self.type = type
        self.subtype = subtype
        self.parameters = parameters
    }

    public var description: String {
        var string = "\(type)/\(subtype)"

        if parameters.count > 0 {
            string += parameters.reduce(";") { $0 + " \($1.0)=\($1.1)" }
        }

        return string
    }

    public init(string: String) {
        let mediaTypeTokens = string.split(";")

        let mediaType = mediaTypeTokens.first!
        var parameters: [String: String] = [:]

        if mediaTypeTokens.count == 2 {
            let parametersTokens = mediaTypeTokens[1].trim().split(" ")

            for parametersToken in parametersTokens {
                let parameterTokens = parametersToken.split("=")

                if parameterTokens.count == 2 {
                    let key = parameterTokens[0]
                    let value = parameterTokens[1]
                    parameters[key] = value
                }
            }
        }

        let tokens = mediaType.split("/")

        self.type = tokens[0].lowercaseString
        self.subtype = tokens[1].lowercaseString
        self.parameters = parameters
    }

    public func matches(mediaType: MediaType) -> Bool {
        if type == "*" || mediaType.type == "*" {
            return true
        }

        if type == mediaType.type {
            if subtype == "*" || mediaType.subtype == "*" {
                return true
            }

            return subtype == mediaType.subtype
        }

        return false
    }
}

extension MediaType: Hashable {
    public var hashValue: Int {
        return type.hashValue ^ subtype.hashValue
    }
}

public func ==(lhs: MediaType, rhs: MediaType) -> Bool {
    return lhs.type == rhs.type && lhs.subtype == rhs.subtype
}

extension String {
    func split(separator: Character, allowEmptySlices: Bool = false) -> [String] {
        return characters.split(separator, allowEmptySlices: allowEmptySlices).map(String.init)
    }

    func trim() -> String {
        let string = trimLeft()
        return string.trimRight()
    }

    func trimLeft() -> String {
        var start = characters.count

        for (index, character) in characters.enumerate() {
            if ![" ", "\t", "\r", "\n"].contains(character) {
                start = index
                break
            }
        }

        return self[startIndex.advancedBy(start) ..< endIndex]
    }

    func trimRight() -> String {
        var end = characters.count

        for (index, character) in characters.reverse().enumerate() {
            if ![" ", "\t", "\r", "\n"].contains(character) {
                end = index
                break
            }
        }

        return self[startIndex ..< startIndex.advancedBy(characters.count - end)]
    }
}

public let JSONMediaType = MediaType(type: "application", subtype: "json", parameters: ["charset": "utf-8"])
public let XMLMediaType = MediaType(type: "application", subtype: "xml", parameters: ["charset": "utf-8"])
public let URLEncodedFormMediaType = MediaType(type: "application", subtype: "x-www-form-urlencoded")
public let multipartFormMediaType = MediaType(type: "multipart", subtype: "form-data")

let fileExtensionMediaTypeMapping: [String: MediaType] = [
    "ez": MediaType(type: "application", subtype: "andrew-inset"),
    "anx": MediaType(type: "application", subtype: "annodex"),
    "atom": MediaType(type: "application", subtype: "atom+xml"),
    "atomcat": MediaType(type: "application", subtype: "atomcat+xml"),
    "atomsrv": MediaType(type: "application", subtype: "atomserv+xml"),
    "lin": MediaType(type: "application", subtype: "bbolin"),
    "cu": MediaType(type: "application", subtype: "cu-seeme"),
    "davmount": MediaType(type: "application", subtype: "davmount+xml"),
    "dcm": MediaType(type: "application", subtype: "dicom"),
    "tsp": MediaType(type: "application", subtype: "dsptype"),
    "es": MediaType(type: "application", subtype: "ecmascript"),
    "spl": MediaType(type: "application", subtype: "futuresplash"),
    "hta": MediaType(type: "application", subtype: "hta"),
    "jar": MediaType(type: "application", subtype: "java-archive"),
    "ser": MediaType(type: "application", subtype: "java-serialized-object"),
    "class": MediaType(type: "application", subtype: "java-vm"),
    "js": MediaType(type: "application", subtype: "javascript"),
    "json": MediaType(type: "application", subtype: "json"),
    "m3g": MediaType(type: "application", subtype: "m3g"),
    "hqx": MediaType(type: "application", subtype: "mac-binhex40"),
    "cpt": MediaType(type: "application", subtype: "mac-compactpro"),
    "nb": MediaType(type: "application", subtype: "mathematica"),
    "nbp": MediaType(type: "application", subtype: "mathematica"),
    "mbox": MediaType(type: "application", subtype: "mbox"),
    "mdb": MediaType(type: "application", subtype: "msaccess"),
    "doc": MediaType(type: "application", subtype: "msword"),
    "dot": MediaType(type: "application", subtype: "msword"),
    "mxf": MediaType(type: "application", subtype: "mxf"),
    "bin": MediaType(type: "application", subtype: "octet-stream"),
    "oda": MediaType(type: "application", subtype: "oda"),
    "ogx": MediaType(type: "application", subtype: "ogg"),
    "one": MediaType(type: "application", subtype: "onenote"),
    "onetoc2": MediaType(type: "application", subtype: "onenote"),
    "onetmp": MediaType(type: "application", subtype: "onenote"),
    "onepkg": MediaType(type: "application", subtype: "onenote"),
    "pdf": MediaType(type: "application", subtype: "pdf"),
    "pgp": MediaType(type: "application", subtype: "pgp-encrypted"),
    "key": MediaType(type: "application", subtype: "pgp-keys"),
    "sig": MediaType(type: "application", subtype: "pgp-signature"),
    "prf": MediaType(type: "application", subtype: "pics-rules"),
    "ps": MediaType(type: "application", subtype: "postscript"),
    "ai": MediaType(type: "application", subtype: "postscript"),
    "eps": MediaType(type: "application", subtype: "postscript"),
    "epsi": MediaType(type: "application", subtype: "postscript"),
    "epsf": MediaType(type: "application", subtype: "postscript"),
    "eps2": MediaType(type: "application", subtype: "postscript"),
    "eps3": MediaType(type: "application", subtype: "postscript"),
    "rar": MediaType(type: "application", subtype: "rar"),
    "rdf": MediaType(type: "application", subtype: "rdf+xml"),
    "rtf": MediaType(type: "application", subtype: "rtf"),
    "stl": MediaType(type: "application", subtype: "sla"),
    "smi": MediaType(type: "application", subtype: "smil+xml"),
    "smil": MediaType(type: "application", subtype: "smil+xml"),
    "xhtml": MediaType(type: "application", subtype: "xhtml+xml"),
    "xht": MediaType(type: "application", subtype: "xhtml+xml"),
    "xml": MediaType(type: "application", subtype: "xml"),
    "xsd": MediaType(type: "application", subtype: "xml"),
    "xsl": MediaType(type: "application", subtype: "xslt+xml"),
    "xslt": MediaType(type: "application", subtype: "xslt+xml"),
    "xspf": MediaType(type: "application", subtype: "xspf+xml"),
    "zip": MediaType(type: "application", subtype: "zip"),
    "apk": MediaType(type: "application", subtype: "vnd.android.package-archive"),
    "cdy": MediaType(type: "application", subtype: "vnd.cinderella"),
    "kml": MediaType(type: "application", subtype: "vnd.google-earth.kml+xml"),
    "kmz": MediaType(type: "application", subtype: "vnd.google-earth.kmz"),
    "xul": MediaType(type: "application", subtype: "vnd.mozilla.xul+xml"),
    "xls": MediaType(type: "application", subtype: "vnd.ms-excel"),
    "xlb": MediaType(type: "application", subtype: "vnd.ms-excel"),
    "xlt": MediaType(type: "application", subtype: "vnd.ms-excel"),
    "xlam": MediaType(type: "application", subtype: "vnd.ms-excel.addin.macroEnabled.12"),
    "xlsb": MediaType(type: "application", subtype: "vnd.ms-excel.sheet.binary.macroEnabled.12"),
    "xlsm": MediaType(type: "application", subtype: "vnd.ms-excel.sheet.macroEnabled.12"),
    "xltm": MediaType(type: "application", subtype: "vnd.ms-excel.template.macroEnabled.12"),
    "eot": MediaType(type: "application", subtype: "vnd.ms-fontobject"),
    "thmx": MediaType(type: "application", subtype: "vnd.ms-officetheme"),
    "cat": MediaType(type: "application", subtype: "vnd.ms-pki.seccat"),
    "ppt": MediaType(type: "application", subtype: "vnd.ms-powerpoint"),
    "pps": MediaType(type: "application", subtype: "vnd.ms-powerpoint"),
    "ppam": MediaType(type: "application", subtype: "vnd.ms-powerpoint.addin.macroEnabled.12"),
    "pptm": MediaType(type: "application", subtype: "vnd.ms-powerpoint.presentation.macroEnabled.12"),
    "sldm": MediaType(type: "application", subtype: "vnd.ms-powerpoint.slide.macroEnabled.12"),
    "ppsm": MediaType(type: "application", subtype: "vnd.ms-powerpoint.slideshow.macroEnabled.12"),
    "potm": MediaType(type: "application", subtype: "vnd.ms-powerpoint.template.macroEnabled.12"),
    "docm": MediaType(type: "application", subtype: "vnd.ms-word.document.macroEnabled.12"),
    "dotm": MediaType(type: "application", subtype: "vnd.ms-word.template.macroEnabled.12"),
    "odc": MediaType(type: "application", subtype: "vnd.oasis.opendocument.chart"),
    "odb": MediaType(type: "application", subtype: "vnd.oasis.opendocument.database"),
    "odf": MediaType(type: "application", subtype: "vnd.oasis.opendocument.formula"),
    "odg": MediaType(type: "application", subtype: "vnd.oasis.opendocument.graphics"),
    "otg": MediaType(type: "application", subtype: "vnd.oasis.opendocument.graphics-template"),
    "odi": MediaType(type: "application", subtype: "vnd.oasis.opendocument.image"),
    "odp": MediaType(type: "application", subtype: "vnd.oasis.opendocument.presentation"),
    "otp": MediaType(type: "application", subtype: "vnd.oasis.opendocument.presentation-template"),
    "ods": MediaType(type: "application", subtype: "vnd.oasis.opendocument.spreadsheet"),
    "ots": MediaType(type: "application", subtype: "vnd.oasis.opendocument.spreadsheet-template"),
    "odt": MediaType(type: "application", subtype: "vnd.oasis.opendocument.text"),
    "odm": MediaType(type: "application", subtype: "vnd.oasis.opendocument.text-master"),
    "ott": MediaType(type: "application", subtype: "vnd.oasis.opendocument.text-template"),
    "oth": MediaType(type: "application", subtype: "vnd.oasis.opendocument.text-web"),
    "pptx": MediaType(type: "application", subtype: "vnd.openxmlformats-officedocument.presentationml.presentation"),
    "sldx": MediaType(type: "application", subtype: "vnd.openxmlformats-officedocument.presentationml.slide"),
    "ppsx": MediaType(type: "application", subtype: "vnd.openxmlformats-officedocument.presentationml.slideshow"),
    "potx": MediaType(type: "application", subtype: "vnd.openxmlformats-officedocument.presentationml.template"),
    "xlsx": MediaType(type: "application", subtype: "vnd.openxmlformats-officedocument.spreadsheetml.sheet"),
    "xltx": MediaType(type: "application", subtype: "vnd.openxmlformats-officedocument.spreadsheetml.template"),
    "docx": MediaType(type: "application", subtype: "vnd.openxmlformats-officedocument.wordprocessingml.document"),
    "dotx": MediaType(type: "application", subtype: "vnd.openxmlformats-officedocument.wordprocessingml.template"),
    "cod": MediaType(type: "application", subtype: "vnd.rim.cod"),
    "mmf": MediaType(type: "application", subtype: "vnd.smaf"),
    "sdc": MediaType(type: "application", subtype: "vnd.stardivision.calc"),
    "sds": MediaType(type: "application", subtype: "vnd.stardivision.chart"),
    "sda": MediaType(type: "application", subtype: "vnd.stardivision.draw"),
    "sdd": MediaType(type: "application", subtype: "vnd.stardivision.impress"),
    "sdf": MediaType(type: "application", subtype: "vnd.stardivision.math"),
    "sdw": MediaType(type: "application", subtype: "vnd.stardivision.writer"),
    "sgl": MediaType(type: "application", subtype: "vnd.stardivision.writer-global"),
    "sxc": MediaType(type: "application", subtype: "vnd.sun.xml.calc"),
    "stc": MediaType(type: "application", subtype: "vnd.sun.xml.calc.template"),
    "sxd": MediaType(type: "application", subtype: "vnd.sun.xml.draw"),
    "std": MediaType(type: "application", subtype: "vnd.sun.xml.draw.template"),
    "sxi": MediaType(type: "application", subtype: "vnd.sun.xml.impress"),
    "sti": MediaType(type: "application", subtype: "vnd.sun.xml.impress.template"),
    "sxm": MediaType(type: "application", subtype: "vnd.sun.xml.math"),
    "sxw": MediaType(type: "application", subtype: "vnd.sun.xml.writer"),
    "sxg": MediaType(type: "application", subtype: "vnd.sun.xml.writer.global"),
    "stw": MediaType(type: "application", subtype: "vnd.sun.xml.writer.template"),
    "sis": MediaType(type: "application", subtype: "vnd.symbian.install"),
    "cap": MediaType(type: "application", subtype: "vnd.tcpdump.pcap"),
    "pcap": MediaType(type: "application", subtype: "vnd.tcpdump.pcap"),
    "vsd": MediaType(type: "application", subtype: "vnd.visio"),
    "wbxml": MediaType(type: "application", subtype: "vnd.wap.wbxml"),
    "wmlc": MediaType(type: "application", subtype: "vnd.wap.wmlc"),
    "wmlsc": MediaType(type: "application", subtype: "vnd.wap.wmlscriptc"),
    "wpd": MediaType(type: "application", subtype: "vnd.wordperfect"),
    "wp5": MediaType(type: "application", subtype: "vnd.wordperfect5.1"),
    "wk": MediaType(type: "application", subtype: "x-123"),
    "7z": MediaType(type: "application", subtype: "x-7z-compressed"),
    "abw": MediaType(type: "application", subtype: "x-abiword"),
    "dmg": MediaType(type: "application", subtype: "x-apple-diskimage"),
    "bcpio": MediaType(type: "application", subtype: "x-bcpio"),
    "torrent": MediaType(type: "application", subtype: "x-bittorrent"),
    "cab": MediaType(type: "application", subtype: "x-cab"),
    "cbr": MediaType(type: "application", subtype: "x-cbr"),
    "cbz": MediaType(type: "application", subtype: "x-cbz"),
    "cdf": MediaType(type: "application", subtype: "x-cdf"),
    "cda": MediaType(type: "application", subtype: "x-cdf"),
    "vcd": MediaType(type: "application", subtype: "x-cdlink"),
    "pgn": MediaType(type: "application", subtype: "x-chess-pgn"),
    "mph": MediaType(type: "application", subtype: "x-comsol"),
    "cpio": MediaType(type: "application", subtype: "x-cpio"),
    "csh": MediaType(type: "application", subtype: "x-csh"),
    "deb": MediaType(type: "application", subtype: "x-debian-package"),
    "udeb": MediaType(type: "application", subtype: "x-debian-package"),
    "dcr": MediaType(type: "application", subtype: "x-director"),
    "dir": MediaType(type: "application", subtype: "x-director"),
    "dxr": MediaType(type: "application", subtype: "x-director"),
    "dms": MediaType(type: "application", subtype: "x-dms"),
    "wad": MediaType(type: "application", subtype: "x-doom"),
    "dvi": MediaType(type: "application", subtype: "x-dvi"),
    "pfa": MediaType(type: "application", subtype: "x-font"),
    "pfb": MediaType(type: "application", subtype: "x-font"),
    "gsf": MediaType(type: "application", subtype: "x-font"),
    "pcf": MediaType(type: "application", subtype: "x-font"),
    "pcf.Z": MediaType(type: "application", subtype: "x-font"),
    "woff": MediaType(type: "application", subtype: "x-font-woff"),
    "mm": MediaType(type: "application", subtype: "x-freemind"),
//  "spl": MediaType(type: "application", subtype: "x-futuresplash"),
    "gan": MediaType(type: "application", subtype: "x-ganttproject"),
    "gnumeric": MediaType(type: "application", subtype: "x-gnumeric"),
    "sgf": MediaType(type: "application", subtype: "x-go-sgf"),
    "gcf": MediaType(type: "application", subtype: "x-graphing-calculator"),
    "gtar": MediaType(type: "application", subtype: "x-gtar"),
    "tgz": MediaType(type: "application", subtype: "x-gtar-compressed"),
    "taz": MediaType(type: "application", subtype: "x-gtar-compressed"),
    "hdf": MediaType(type: "application", subtype: "x-hdf"),
    "hwp": MediaType(type: "application", subtype: "x-hwp"),
    "ica": MediaType(type: "application", subtype: "x-ica"),
    "info": MediaType(type: "application", subtype: "x-info"),
    "ins": MediaType(type: "application", subtype: "x-internet-signup"),
    "isp": MediaType(type: "application", subtype: "x-internet-signup"),
    "iii": MediaType(type: "application", subtype: "x-iphone"),
    "iso": MediaType(type: "application", subtype: "x-iso9660-image"),
    "jam": MediaType(type: "application", subtype: "x-jam"),
    "jnlp": MediaType(type: "application", subtype: "x-java-jnlp-file"),
    "jmz": MediaType(type: "application", subtype: "x-jmol"),
    "chrt": MediaType(type: "application", subtype: "x-kchart"),
    "kil": MediaType(type: "application", subtype: "x-killustrator"),
    "skp": MediaType(type: "application", subtype: "x-koan"),
    "skd": MediaType(type: "application", subtype: "x-koan"),
    "skt": MediaType(type: "application", subtype: "x-koan"),
    "skm": MediaType(type: "application", subtype: "x-koan"),
    "kpr": MediaType(type: "application", subtype: "x-kpresenter"),
    "kpt": MediaType(type: "application", subtype: "x-kpresenter"),
    "ksp": MediaType(type: "application", subtype: "x-kspread"),
    "kwd": MediaType(type: "application", subtype: "x-kword"),
    "kwt": MediaType(type: "application", subtype: "x-kword"),
    "latex": MediaType(type: "application", subtype: "x-latex"),
    "lha": MediaType(type: "application", subtype: "x-lha"),
    "lyx": MediaType(type: "application", subtype: "x-lyx"),
    "lzh": MediaType(type: "application", subtype: "x-lzh"),
    "lzx": MediaType(type: "application", subtype: "x-lzx"),
    "frm": MediaType(type: "application", subtype: "x-maker"),
    "maker": MediaType(type: "application", subtype: "x-maker"),
    "frame": MediaType(type: "application", subtype: "x-maker"),
    "fm": MediaType(type: "application", subtype: "x-maker"),
    "fb": MediaType(type: "application", subtype: "x-maker"),
    "book": MediaType(type: "application", subtype: "x-maker"),
    "fbdoc": MediaType(type: "application", subtype: "x-maker"),
    "md5": MediaType(type: "application", subtype: "x-md5"),
    "mif": MediaType(type: "application", subtype: "x-mif"),
    "m3u8": MediaType(type: "application", subtype: "x-mpegURL"),
    "wmd": MediaType(type: "application", subtype: "x-ms-wmd"),
    "wmz": MediaType(type: "application", subtype: "x-ms-wmz"),
    "com": MediaType(type: "application", subtype: "x-msdos-program"),
    "exe": MediaType(type: "application", subtype: "x-msdos-program"),
    "bat": MediaType(type: "application", subtype: "x-msdos-program"),
    "dll": MediaType(type: "application", subtype: "x-msdos-program"),
    "msi": MediaType(type: "application", subtype: "x-msi"),
    "nc": MediaType(type: "application", subtype: "x-netcdf"),
    "pac": MediaType(type: "application", subtype: "x-ns-proxy-autoconfig"),
    "dat": MediaType(type: "application", subtype: "x-ns-proxy-autoconfig"),
    "nwc": MediaType(type: "application", subtype: "x-nwc"),
    "o": MediaType(type: "application", subtype: "x-object"),
    "oza": MediaType(type: "application", subtype: "x-oz-application"),
    "p7r": MediaType(type: "application", subtype: "x-pkcs7-certreqresp"),
    "crl": MediaType(type: "application", subtype: "x-pkcs7-crl"),
    "pyc": MediaType(type: "application", subtype: "x-python-code"),
    "pyo": MediaType(type: "application", subtype: "x-python-code"),
    "qgs": MediaType(type: "application", subtype: "x-qgis"),
    "shp": MediaType(type: "application", subtype: "x-qgis"),
    "shx": MediaType(type: "application", subtype: "x-qgis"),
    "qtl": MediaType(type: "application", subtype: "x-quicktimeplayer"),
    "rdp": MediaType(type: "application", subtype: "x-rdp"),
    "rpm": MediaType(type: "application", subtype: "x-redhat-package-manager"),
    "rss": MediaType(type: "application", subtype: "x-rss+xml"),
    "rb": MediaType(type: "application", subtype: "x-ruby"),
    "sci": MediaType(type: "application", subtype: "x-scilab"),
    "sce": MediaType(type: "application", subtype: "x-scilab"),
    "xcos": MediaType(type: "application", subtype: "x-scilab-xcos"),
    "sh": MediaType(type: "application", subtype: "x-sh"),
    "sha1": MediaType(type: "application", subtype: "x-sha1"),
    "shar": MediaType(type: "application", subtype: "x-shar"),
    "swf": MediaType(type: "application", subtype: "x-shockwave-flash"),
    "swfl": MediaType(type: "application", subtype: "x-shockwave-flash"),
    "scr": MediaType(type: "application", subtype: "x-silverlight"),
    "sql": MediaType(type: "application", subtype: "x-sql"),
    "sit": MediaType(type: "application", subtype: "x-stuffit"),
    "sitx": MediaType(type: "application", subtype: "x-stuffit"),
    "sv4cpio": MediaType(type: "application", subtype: "x-sv4cpio"),
    "sv4crc": MediaType(type: "application", subtype: "x-sv4crc"),
    "tar": MediaType(type: "application", subtype: "x-tar"),
    "tcl": MediaType(type: "application", subtype: "x-tcl"),
    "gf": MediaType(type: "application", subtype: "x-tex-gf"),
    "pk": MediaType(type: "application", subtype: "x-tex-pk"),
    "texinfo": MediaType(type: "application", subtype: "x-texinfo"),
    "texi": MediaType(type: "application", subtype: "x-texinfo"),
    "~": MediaType(type: "application", subtype: "x-trash"),
    "%": MediaType(type: "application", subtype: "x-trash"),
    "bak": MediaType(type: "application", subtype: "x-trash"),
    "old": MediaType(type: "application", subtype: "x-trash"),
    "sik": MediaType(type: "application", subtype: "x-trash"),
    "t": MediaType(type: "application", subtype: "x-troff"),
    "tr": MediaType(type: "application", subtype: "x-troff"),
    "roff": MediaType(type: "application", subtype: "x-troff"),
    "man": MediaType(type: "application", subtype: "x-troff-man"),
    "me": MediaType(type: "application", subtype: "x-troff-me"),
    "ms": MediaType(type: "application", subtype: "x-troff-ms"),
    "ustar": MediaType(type: "application", subtype: "x-ustar"),
    "src": MediaType(type: "application", subtype: "x-wais-source"),
    "wz": MediaType(type: "application", subtype: "x-wingz"),
    "crt": MediaType(type: "application", subtype: "x-x509-ca-cert"),
    "xcf": MediaType(type: "application", subtype: "x-xcf"),
    "fig": MediaType(type: "application", subtype: "x-xfig"),
    "xpi": MediaType(type: "application", subtype: "x-xpinstall"),
    "amr": MediaType(type: "audio", subtype: "amr"),
    "awb": MediaType(type: "audio", subtype: "amr-wb"),
    "axa": MediaType(type: "audio", subtype: "annodex"),
    "au": MediaType(type: "audio", subtype: "basic"),
    "snd": MediaType(type: "audio", subtype: "basic"),
    "csd": MediaType(type: "audio", subtype: "csound"),
    "orc": MediaType(type: "audio", subtype: "csound"),
    "sco": MediaType(type: "audio", subtype: "csound"),
    "flac": MediaType(type: "audio", subtype: "flac"),
    "mid": MediaType(type: "audio", subtype: "midi"),
    "midi": MediaType(type: "audio", subtype: "midi"),
    "kar": MediaType(type: "audio", subtype: "midi"),
    "mpga": MediaType(type: "audio", subtype: "mpeg"),
    "mpega": MediaType(type: "audio", subtype: "mpeg"),
    "mp2": MediaType(type: "audio", subtype: "mpeg"),
    "mp3": MediaType(type: "audio", subtype: "mpeg"),
    "m4a": MediaType(type: "audio", subtype: "mpeg"),
    "m3u": MediaType(type: "audio", subtype: "mpegurl"),
    "oga": MediaType(type: "audio", subtype: "ogg"),
    "ogg": MediaType(type: "audio", subtype: "ogg"),
    "opus": MediaType(type: "audio", subtype: "ogg"),
    "spx": MediaType(type: "audio", subtype: "ogg"),
    "sid": MediaType(type: "audio", subtype: "prs.sid"),
    "aif": MediaType(type: "audio", subtype: "x-aiff"),
    "aiff": MediaType(type: "audio", subtype: "x-aiff"),
    "aifc": MediaType(type: "audio", subtype: "x-aiff"),
    "gsm": MediaType(type: "audio", subtype: "x-gsm"),
//  "m3u": MediaType(type: "audio", subtype: "x-mpegurl"),
    "wma": MediaType(type: "audio", subtype: "x-ms-wma"),
    "wax": MediaType(type: "audio", subtype: "x-ms-wax"),
    "ra": MediaType(type: "audio", subtype: "x-pn-realaudio"),
    "rm": MediaType(type: "audio", subtype: "x-pn-realaudio"),
    "ram": MediaType(type: "audio", subtype: "x-pn-realaudio"),
//  "ra": MediaType(type: "audio", subtype: "x-realaudio"),
    "pls": MediaType(type: "audio", subtype: "x-scpls"),
    "sd2": MediaType(type: "audio", subtype: "x-sd2"),
    "wav": MediaType(type: "audio", subtype: "x-wav"),
    "alc": MediaType(type: "chemical", subtype: "x-alchemy"),
    "cac": MediaType(type: "chemical", subtype: "x-cache"),
    "cache": MediaType(type: "chemical", subtype: "x-cache"),
    "csf": MediaType(type: "chemical", subtype: "x-cache-csf"),
    "cbin": MediaType(type: "chemical", subtype: "x-cactvs-binary"),
    "cascii": MediaType(type: "chemical", subtype: "x-cactvs-binary"),
    "ctab": MediaType(type: "chemical", subtype: "x-cactvs-binary"),
    "cdx": MediaType(type: "chemical", subtype: "x-cdx"),
    "cer": MediaType(type: "chemical", subtype: "x-cerius"),
    "c3d": MediaType(type: "chemical", subtype: "x-chem3d"),
    "chm": MediaType(type: "chemical", subtype: "x-chemdraw"),
    "cif": MediaType(type: "chemical", subtype: "x-cif"),
    "cmdf": MediaType(type: "chemical", subtype: "x-cmdf"),
    "cml": MediaType(type: "chemical", subtype: "x-cml"),
    "cpa": MediaType(type: "chemical", subtype: "x-compass"),
    "bsd": MediaType(type: "chemical", subtype: "x-crossfire"),
    "csml": MediaType(type: "chemical", subtype: "x-csml"),
    "csm": MediaType(type: "chemical", subtype: "x-csml"),
    "ctx": MediaType(type: "chemical", subtype: "x-ctx"),
    "cxf": MediaType(type: "chemical", subtype: "x-cxf"),
    "cef": MediaType(type: "chemical", subtype: "x-cxf"),
    "emb": MediaType(type: "chemical", subtype: "x-embl-dl-nucleotide"),
    "embl": MediaType(type: "chemical", subtype: "x-embl-dl-nucleotide"),
    "spc": MediaType(type: "chemical", subtype: "x-galactic-spc"),
    "inp": MediaType(type: "chemical", subtype: "x-gamess-input"),
    "gam": MediaType(type: "chemical", subtype: "x-gamess-input"),
    "gamin": MediaType(type: "chemical", subtype: "x-gamess-input"),
    "fch": MediaType(type: "chemical", subtype: "x-gaussian-checkpoint"),
    "fchk": MediaType(type: "chemical", subtype: "x-gaussian-checkpoint"),
    "cub": MediaType(type: "chemical", subtype: "x-gaussian-cube"),
    "gau": MediaType(type: "chemical", subtype: "x-gaussian-input"),
    "gjc": MediaType(type: "chemical", subtype: "x-gaussian-input"),
    "gjf": MediaType(type: "chemical", subtype: "x-gaussian-input"),
    "gal": MediaType(type: "chemical", subtype: "x-gaussian-log"),
    "gcg": MediaType(type: "chemical", subtype: "x-gcg8-sequence"),
    "gen": MediaType(type: "chemical", subtype: "x-genbank"),
    "hin": MediaType(type: "chemical", subtype: "x-hin"),
    "istr": MediaType(type: "chemical", subtype: "x-isostar"),
    "ist": MediaType(type: "chemical", subtype: "x-isostar"),
    "jdx": MediaType(type: "chemical", subtype: "x-jcamp-dx"),
    "dx": MediaType(type: "chemical", subtype: "x-jcamp-dx"),
    "kin": MediaType(type: "chemical", subtype: "x-kinemage"),
    "mcm": MediaType(type: "chemical", subtype: "x-macmolecule"),
    "mmd": MediaType(type: "chemical", subtype: "x-macromodel-input"),
    "mmod": MediaType(type: "chemical", subtype: "x-macromodel-input"),
    "mol": MediaType(type: "chemical", subtype: "x-mdl-molfile"),
    "rd": MediaType(type: "chemical", subtype: "x-mdl-rdfile"),
    "rxn": MediaType(type: "chemical", subtype: "x-mdl-rxnfile"),
    "sd": MediaType(type: "chemical", subtype: "x-mdl-sdfile"),
//  "sdf": MediaType(type: "chemical", subtype: "x-mdl-sdfile"),
    "tgf": MediaType(type: "chemical", subtype: "x-mdl-tgf"),
    "mcif": MediaType(type: "chemical", subtype: "x-mmcif"),
    "mol2": MediaType(type: "chemical", subtype: "x-mol2"),
    "b": MediaType(type: "chemical", subtype: "x-molconn-Z"),
    "gpt": MediaType(type: "chemical", subtype: "x-mopac-graph"),
    "mop": MediaType(type: "chemical", subtype: "x-mopac-input"),
    "mopcrt": MediaType(type: "chemical", subtype: "x-mopac-input"),
    "mpc": MediaType(type: "chemical", subtype: "x-mopac-input"),
    "zmt": MediaType(type: "chemical", subtype: "x-mopac-input"),
    "moo": MediaType(type: "chemical", subtype: "x-mopac-out"),
    "mvb": MediaType(type: "chemical", subtype: "x-mopac-vib"),
    "asn": MediaType(type: "chemical", subtype: "x-ncbi-asn1"),
    "prt": MediaType(type: "chemical", subtype: "x-ncbi-asn1-ascii"),
    "ent": MediaType(type: "chemical", subtype: "x-ncbi-asn1-ascii"),
    "val": MediaType(type: "chemical", subtype: "x-ncbi-asn1-binary"),
    "aso": MediaType(type: "chemical", subtype: "x-ncbi-asn1-binary"),
//  "asn": MediaType(type: "chemical", subtype: "x-ncbi-asn1-spec"),
    "pdb": MediaType(type: "chemical", subtype: "x-pdb"),
//  "ent": MediaType(type: "chemical", subtype: "x-pdb"),
    "ros": MediaType(type: "chemical", subtype: "x-rosdal"),
    "sw": MediaType(type: "chemical", subtype: "x-swissprot"),
    "vms": MediaType(type: "chemical", subtype: "x-vamas-iso14976"),
    "vmd": MediaType(type: "chemical", subtype: "x-vmd"),
    "xtel": MediaType(type: "chemical", subtype: "x-xtel"),
    "xyz": MediaType(type: "chemical", subtype: "x-xyz"),
    "gif": MediaType(type: "image", subtype: "gif"),
    "ief": MediaType(type: "image", subtype: "ief"),
    "jp2": MediaType(type: "image", subtype: "jp2"),
    "jpg2": MediaType(type: "image", subtype: "jp2"),
    "jpeg": MediaType(type: "image", subtype: "jpeg"),
    "jpg": MediaType(type: "image", subtype: "jpeg"),
    "jpe": MediaType(type: "image", subtype: "jpeg"),
    "jpm": MediaType(type: "image", subtype: "jpm"),
    "jpx": MediaType(type: "image", subtype: "jpx"),
    "jpf": MediaType(type: "image", subtype: "jpx"),
    "pcx": MediaType(type: "image", subtype: "pcx"),
    "png": MediaType(type: "image", subtype: "png"),
    "svg": MediaType(type: "image", subtype: "svg+xml"),
    "svgz": MediaType(type: "image", subtype: "svg+xml"),
    "tiff": MediaType(type: "image", subtype: "tiff"),
    "tif": MediaType(type: "image", subtype: "tiff"),
    "djvu": MediaType(type: "image", subtype: "vnd.djvu"),
    "djv": MediaType(type: "image", subtype: "vnd.djvu"),
    "ico": MediaType(type: "image", subtype: "vnd.microsoft.icon"),
    "wbmp": MediaType(type: "image", subtype: "vnd.wap.wbmp"),
    "cr2": MediaType(type: "image", subtype: "x-canon-cr2"),
    "crw": MediaType(type: "image", subtype: "x-canon-crw"),
    "ras": MediaType(type: "image", subtype: "x-cmu-raster"),
    "cdr": MediaType(type: "image", subtype: "x-coreldraw"),
    "pat": MediaType(type: "image", subtype: "x-coreldrawpattern"),
    "cdt": MediaType(type: "image", subtype: "x-coreldrawtemplate"),
//  "cpt": MediaType(type: "image", subtype: "x-corelphotopaint"),
    "erf": MediaType(type: "image", subtype: "x-epson-erf"),
    "art": MediaType(type: "image", subtype: "x-jg"),
    "jng": MediaType(type: "image", subtype: "x-jng"),
    "bmp": MediaType(type: "image", subtype: "x-ms-bmp"),
    "nef": MediaType(type: "image", subtype: "x-nikon-nef"),
    "orf": MediaType(type: "image", subtype: "x-olympus-orf"),
    "psd": MediaType(type: "image", subtype: "x-photoshop"),
    "pnm": MediaType(type: "image", subtype: "x-portable-anymap"),
    "pbm": MediaType(type: "image", subtype: "x-portable-bitmap"),
    "pgm": MediaType(type: "image", subtype: "x-portable-graymap"),
    "ppm": MediaType(type: "image", subtype: "x-portable-pixmap"),
    "rgb": MediaType(type: "image", subtype: "x-rgb"),
    "xbm": MediaType(type: "image", subtype: "x-xbitmap"),
    "xpm": MediaType(type: "image", subtype: "x-xpixmap"),
    "xwd": MediaType(type: "image", subtype: "x-xwindowdump"),
    "eml": MediaType(type: "message", subtype: "rfc822"),
    "igs": MediaType(type: "model", subtype: "iges"),
    "iges": MediaType(type: "model", subtype: "iges"),
    "msh": MediaType(type: "model", subtype: "mesh"),
    "mesh": MediaType(type: "model", subtype: "mesh"),
    "silo": MediaType(type: "model", subtype: "mesh"),
    "wrl": MediaType(type: "model", subtype: "vrml"),
    "vrml": MediaType(type: "model", subtype: "vrml"),
    "x3dv": MediaType(type: "model", subtype: "x3d+vrml"),
    "x3d": MediaType(type: "model", subtype: "x3d+xml"),
    "x3db": MediaType(type: "model", subtype: "x3d+binary"),
    "appcache": MediaType(type: "text", subtype: "cache-manifest"),
    "ics": MediaType(type: "text", subtype: "calendar"),
    "icz": MediaType(type: "text", subtype: "calendar"),
    "css": MediaType(type: "text", subtype: "css"),
    "csv": MediaType(type: "text", subtype: "csv"),
    "323": MediaType(type: "text", subtype: "h323"),
    "html": MediaType(type: "text", subtype: "html"),
    "htm": MediaType(type: "text", subtype: "html"),
    "shtml": MediaType(type: "text", subtype: "html"),
    "uls": MediaType(type: "text", subtype: "iuls"),
    "mml": MediaType(type: "text", subtype: "mathml"),
    "asc": MediaType(type: "text", subtype: "plain"),
    "txt": MediaType(type: "text", subtype: "plain"),
    "text": MediaType(type: "text", subtype: "plain"),
    "pot": MediaType(type: "text", subtype: "plain"),
    "brf": MediaType(type: "text", subtype: "plain"),
    "srt": MediaType(type: "text", subtype: "plain"),
    "rtx": MediaType(type: "text", subtype: "richtext"),
    "sct": MediaType(type: "text", subtype: "scriptlet"),
    "wsc": MediaType(type: "text", subtype: "scriptlet"),
    "tm": MediaType(type: "text", subtype: "texmacs"),
    "tsv": MediaType(type: "text", subtype: "tab-separated-values"),
    "ttl": MediaType(type: "text", subtype: "turtle"),
    "jad": MediaType(type: "text", subtype: "vnd.sun.j2me.app-descriptor"),
    "wml": MediaType(type: "text", subtype: "vnd.wap.wml"),
    "wmls": MediaType(type: "text", subtype: "vnd.wap.wmlscript"),
    "bib": MediaType(type: "text", subtype: "x-bibtex"),
    "boo": MediaType(type: "text", subtype: "x-boo"),
    "h++": MediaType(type: "text", subtype: "x-c++hdr"),
    "hpp": MediaType(type: "text", subtype: "x-c++hdr"),
    "hxx": MediaType(type: "text", subtype: "x-c++hdr"),
    "hh": MediaType(type: "text", subtype: "x-c++hdr"),
    "c++": MediaType(type: "text", subtype: "x-c++src"),
    "cpp": MediaType(type: "text", subtype: "x-c++src"),
    "cxx": MediaType(type: "text", subtype: "x-c++src"),
    "cc": MediaType(type: "text", subtype: "x-c++src"),
    "h": MediaType(type: "text", subtype: "x-chdr"),
    "htc": MediaType(type: "text", subtype: "x-component"),
//  "csh": MediaType(type: "text", subtype: "x-csh"),
    "c": MediaType(type: "text", subtype: "x-csrc"),
    "d": MediaType(type: "text", subtype: "x-dsrc"),
    "diff": MediaType(type: "text", subtype: "x-diff"),
    "patch": MediaType(type: "text", subtype: "x-diff"),
    "hs": MediaType(type: "text", subtype: "x-haskell"),
    "java": MediaType(type: "text", subtype: "x-java"),
    "ly": MediaType(type: "text", subtype: "x-lilypond"),
    "lhs": MediaType(type: "text", subtype: "x-literate-haskell"),
    "moc": MediaType(type: "text", subtype: "x-moc"),
    "p": MediaType(type: "text", subtype: "x-pascal"),
    "pas": MediaType(type: "text", subtype: "x-pascal"),
    "gcd": MediaType(type: "text", subtype: "x-pcs-gcd"),
    "pl": MediaType(type: "text", subtype: "x-perl"),
    "pm": MediaType(type: "text", subtype: "x-perl"),
    "py": MediaType(type: "text", subtype: "x-python"),
    "scala": MediaType(type: "text", subtype: "x-scala"),
    "etx": MediaType(type: "text", subtype: "x-setext"),
    "sfv": MediaType(type: "text", subtype: "x-sfv"),
//  "sh": MediaType(type: "text", subtype: "x-sh"),
//  "tcl": MediaType(type: "text", subtype: "x-tcl"),
    "tk": MediaType(type: "text", subtype: "x-tcl"),
    "tex": MediaType(type: "text", subtype: "x-tex"),
    "ltx": MediaType(type: "text", subtype: "x-tex"),
    "sty": MediaType(type: "text", subtype: "x-tex"),
    "cls": MediaType(type: "text", subtype: "x-tex"),
    "vcs": MediaType(type: "text", subtype: "x-vcalendar"),
    "vcf": MediaType(type: "text", subtype: "x-vcard"),
    "3gp": MediaType(type: "video", subtype: "3gpp"),
    "axv": MediaType(type: "video", subtype: "annodex"),
    "dl": MediaType(type: "video", subtype: "dl"),
    "dif": MediaType(type: "video", subtype: "dv"),
    "dv": MediaType(type: "video", subtype: "dv"),
    "fli": MediaType(type: "video", subtype: "fli"),
    "gl": MediaType(type: "video", subtype: "gl"),
    "mpeg": MediaType(type: "video", subtype: "mpeg"),
    "mpg": MediaType(type: "video", subtype: "mpeg"),
    "mpe": MediaType(type: "video", subtype: "mpeg"),
    "ts": MediaType(type: "video", subtype: "MP2T"),
    "mp4": MediaType(type: "video", subtype: "mp4"),
    "qt": MediaType(type: "video", subtype: "quicktime"),
    "mov": MediaType(type: "video", subtype: "quicktime"),
    "ogv": MediaType(type: "video", subtype: "ogg"),
    "webm": MediaType(type: "video", subtype: "webm"),
    "mxu": MediaType(type: "video", subtype: "vnd.mpegurl"),
    "flv": MediaType(type: "video", subtype: "x-flv"),
    "lsf": MediaType(type: "video", subtype: "x-la-asf"),
    "lsx": MediaType(type: "video", subtype: "x-la-asf"),
    "mng": MediaType(type: "video", subtype: "x-mng"),
    "asf": MediaType(type: "video", subtype: "x-ms-asf"),
    "asx": MediaType(type: "video", subtype: "x-ms-asf"),
    "wm": MediaType(type: "video", subtype: "x-ms-wm"),
    "wmv": MediaType(type: "video", subtype: "x-ms-wmv"),
    "wmx": MediaType(type: "video", subtype: "x-ms-wmx"),
    "wvx": MediaType(type: "video", subtype: "x-ms-wvx"),
    "avi": MediaType(type: "video", subtype: "x-msvideo"),
    "movie": MediaType(type: "video", subtype: "x-sgi-movie"),
    "mpv": MediaType(type: "video", subtype: "x-matroska"),
    "mkv": MediaType(type: "video", subtype: "x-matroska"),
    "ice": MediaType(type: "x-conference", subtype: "x-cooltalk"),
    "sisx": MediaType(type: "x-epoc", subtype: "x-sisx-app"),
    "vrm": MediaType(type: "x-world", subtype: "x-vrml"),
//  "vrml": MediaType(type: "x-world", subtype: "x-vrml"),
//  "wrl": MediaType(type: "x-world", subtype: "x-vrml"),
]


public func mediaTypeForFileExtension(fileExtension: String) -> MediaType? {
    return fileExtensionMediaTypeMapping[fileExtension]
}