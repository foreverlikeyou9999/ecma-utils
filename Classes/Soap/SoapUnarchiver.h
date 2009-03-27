#import <Foundation/Foundation.h>

@class CXMLDocument;

@class SoapUnarchiverContext;

@interface SoapUnarchiver : NSCoder{
	CXMLDocument* xml;	
	SoapUnarchiverContext* nodeContext;
}

+(SoapUnarchiver*) soapUnarchiverWithXmlString: (NSString*)xmlString;

-(NSArray*) decodeObjectsOfType: (Class)aClass forXpath:(NSString*)path namespaceMappings: (NSDictionary*)mappings;

@end