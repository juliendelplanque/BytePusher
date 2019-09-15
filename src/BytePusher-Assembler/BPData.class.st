Class {
	#name : #BPData,
	#superclass : #Object,
	#instVars : [
		'byte',
		'address'
	],
	#category : #'BytePusher-Assembler'
}

{ #category : #'instance creation' }
BPData class >> byte: byte [
	^ self new
		byte: byte;
		yourself
]

{ #category : #visiting }
BPData >> acceptVisitor: aBPAssemblerVisitor [
	<generated>
	^ aBPAssemblerVisitor visitBPData: self
]

{ #category : #accessing }
BPData >> address [
	^ address
]

{ #category : #accessing }
BPData >> address: anObject [
	address := anObject
]

{ #category : #converting }
BPData >> asReference [
	^ BPDataReference data: self
]

{ #category : #assembling }
BPData >> beAssembledIn: aBPAssembledCode [ 
	aBPAssembledCode addInstruction: self
]

{ #category : #accessing }
BPData >> byte [
	^ byte
]

{ #category : #accessing }
BPData >> byte: anObject [
	byte := anObject
]

{ #category : #testing }
BPData >> isInstruction [
	^ false
]

{ #category : #testing }
BPData >> isInstructionToResolve [
	^ false
]

{ #category : #printing }
BPData >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	aStream nextPutAll: (self byte printPaddedWith: $0 to: 2 base: 16).
	aStream nextPut: $)
]

{ #category : #writing }
BPData >> writeOn: aByteArray [
	self address store: self byte in: aByteArray
]
