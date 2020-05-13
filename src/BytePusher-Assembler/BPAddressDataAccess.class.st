Class {
	#name : #BPAddressDataAccess,
	#superclass : #BPReferenceToResolve,
	#instVars : [
		'byteIndex',
		'objectWithAddress'
	],
	#category : #'BytePusher-Assembler-Model'
}

{ #category : #'instance creation' }
BPAddressDataAccess class >> address: address byteIndex: byteIndex [
	^ self new
		address: address;
		byteIndex: byteIndex;
		yourself
]

{ #category : #visiting }
BPAddressDataAccess >> acceptVisitor: aBPAssemblerVisitor [
	<generated>
	^ aBPAssemblerVisitor visitBPAddressDataAccess: self
]

{ #category : #accessing }
BPAddressDataAccess >> address [
	self
		deprecated: 'Please use #objectWithAddress instead'
		transformWith: '`@receiver address' -> '`@receiver objectWithAddress'.
	^ self objectWithAddress
]

{ #category : #accessing }
BPAddressDataAccess >> address: anObject [
	self
		deprecated: 'Use #objectWithAddress: instead'
		transformWith: '`@receiver address: `@statements' -> '`@receiver objectWithAddress: `@statements'.
	self objectWithAddress: anObject
]

{ #category : #accessing }
BPAddressDataAccess >> byteIndex [
	^ byteIndex
]

{ #category : #accessing }
BPAddressDataAccess >> byteIndex: anObject [
	byteIndex := anObject
]

{ #category : #initialization }
BPAddressDataAccess >> initialize [
	super initialize.
	self byteIndex: 0
]

{ #category : #accessing }
BPAddressDataAccess >> objectWithAddress [
	^ objectWithAddress
]

{ #category : #accessing }
BPAddressDataAccess >> objectWithAddress: anObject [
	objectWithAddress := anObject
]
