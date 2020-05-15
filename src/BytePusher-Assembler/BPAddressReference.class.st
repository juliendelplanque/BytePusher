Class {
	#name : #BPAddressReference,
	#superclass : #BPEntityToResolve,
	#instVars : [
		'objectWithAddress'
	],
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

{ #category : #initialization }
BPAddressReference >> initialize [
	super initialize.
	self offset: 0
]

{ #category : #accessing }
BPAddressReference >> objectWithAddress [
	^ objectWithAddress
]

{ #category : #accessing }
BPAddressReference >> objectWithAddress: anObject [
	objectWithAddress := anObject
]
