Class {
	#name : #BPAddressReference,
	#superclass : #BPReferenceToResolve,
	#instVars : [
		'byteIndex',
		'objectWithAddress'
	],
	#category : #'BytePusher-Assembler-Model'
}

{ #category : #'instance creation' }
BPAddressReference class >> address: address byteIndex: byteIndex [
	^ self new
		address: address;
		byteIndex: byteIndex;
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

{ #category : #accessing }
BPAddressReference >> byteIndex [
	^ byteIndex
]

{ #category : #accessing }
BPAddressReference >> byteIndex: anObject [
	byteIndex := anObject
]

{ #category : #initialization }
BPAddressReference >> initialize [
	super initialize.
	self byteIndex: 0
]

{ #category : #accessing }
BPAddressReference >> objectWithAddress [
	^ objectWithAddress
]

{ #category : #accessing }
BPAddressReference >> objectWithAddress: anObject [
	objectWithAddress := anObject
]
