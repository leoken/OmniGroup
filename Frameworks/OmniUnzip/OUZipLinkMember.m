// Copyright 2008, 2010-2011 Omni Development, Inc.  All rights reserved.
//
// This software may only be used and reproduced according to the
// terms in the file OmniSourceLicense.html, which should be
// distributed with this project and can also be found at
// <http://www.omnigroup.com/developer/sourcecode/sourcelicense/>.

#import <OmniUnzip/OUZipLinkMember.h>

#import <OmniUnzip/OUZipArchive.h>

RCS_ID("$Id$");

@implementation OUZipLinkMember

- initWithName:(NSString *)name date:(NSDate *)date destination:(NSString *)destination;
{
    OBPRECONDITION(![NSString isEmptyString:destination]); // TODO: Convert to an error or exception?
                     
    if (!(self = [super initWithName:name date:date]))
        return nil;
    
    _destination = [destination copy];
    
    return self;
}

- (void)dealloc;
{
    [_destination release];
    [super dealloc];
}

- (NSString *)destination;
{
    return _destination;
}

#pragma mark -
#pragma mark OUZipMember subclass

- (OFFileWrapper *)fileWrapperRepresentation;
{
    OFFileWrapper *wrapper = [[[OFFileWrapper alloc] initSymbolicLinkWithDestination:_destination] autorelease];
    [wrapper setFilename:[self name]];
    [wrapper setPreferredFilename:[self name]];
    return wrapper;
}

#pragma mark -
#pragma mark OUZipMember subclass

- (BOOL)appendToZipArchive:(OUZipArchive *)zip fileNamePrefix:(NSString *)fileNamePrefix error:(NSError **)outError;
{
    NSString *name = [self name];
    if (![NSString isEmptyString:fileNamePrefix])
        name = [fileNamePrefix stringByAppendingFormat:@"/%@", name];
    
    return [zip appendEntryNamed:name fileType:NSFileTypeSymbolicLink contents:[_destination dataUsingEncoding:NSUTF8StringEncoding] date:[self date] error:outError];
}

@end
