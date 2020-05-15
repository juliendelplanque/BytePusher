Class {
	#name : #BPAddressReference,
	#superclass : #BPReferenceToEntityWithAddress,
	#category : #'BytePusher-Assembler-Model'
}

{ #category : #'instance creation' }
BPAddressReference class >> address: address byteIndex: byteIndex [
	^ self new
		address: address;
		offset: byteIndex;
		yourself
]

{ #category : #visiting }
BPAddressReference >> acceptVisitor: aBPAssemblerVisitor [
	<generated>
	^ aBPAssemblerVisitor visitBPAddressDataAccess: self
]

{ #category : #accessing }
BPAddressReference >> address [
	self
		deprecated: 'Please use #objectWithAddress instead'
		transformWith: '`@receiver address' -> '`@receiver objectWithAddress'.
	^ self objectWithAddress
]

{ #category : #accessing }
BPAddressReference >> address: anObject [
	self
		deprecated: 'Use #objectWithAddress: instead'
		transformWith: '`@receiver address: `@statements' -> '`@receiver objectWithAddress: `@statements'.
	self objectWithAddress: anObject
]
