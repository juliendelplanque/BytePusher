Class {
	#name : #BPReferenceToInstruction,
	#superclass : #BPReferenceToResolve,
	#instVars : [
		'instruction',
		'byteIndex'
	],
	#category : #'BytePusher-Assembler-Model'
}

{ #category : #'instance creation' }
BPReferenceToInstruction class >> instruction: instruction [
	^ self new
		instruction: instruction;
		yourself
]

{ #category : #'instance creation' }
BPReferenceToInstruction class >> instruction: instruction byteIndex: byteIndex [
	^ self new
		instruction: instruction;
		byteIndex: byteIndex;
		yourself
]

{ #category : #visiting }
BPReferenceToInstruction >> acceptVisitor: aBPAssemblerVisitor [
	<generated>
	^ aBPAssemblerVisitor visitBPReferenceToInstruction: self
]

{ #category : #accessing }
BPReferenceToInstruction >> address [
	^ self instruction address
]

{ #category : #accessing }
BPReferenceToInstruction >> byteIndex [
	^ byteIndex
]

{ #category : #accessing }
BPReferenceToInstruction >> byteIndex: anObject [
	byteIndex := anObject
]

{ #category : #'assembler-dispatch' }
BPReferenceToInstruction >> forAssembler: aBPAssembler [ 
	^ self
]

{ #category : #'instance creation' }
BPReferenceToInstruction >> fromAddressHighByte [
	self byteIndex: 0
]

{ #category : #'instance creation' }
BPReferenceToInstruction >> fromAddressLowByte [
	self byteIndex: 2
]

{ #category : #'instance creation' }
BPReferenceToInstruction >> fromAddressMiddleByte [
	self byteIndex: 1
]

{ #category : #initialization }
BPReferenceToInstruction >> initialize [
	super initialize.
	self byteIndex: 0
]

{ #category : #accessing }
BPReferenceToInstruction >> instruction [
	^ instruction
]

{ #category : #accessing }
BPReferenceToInstruction >> instruction: anObject [
	instruction := anObject
]

{ #category : #'instance creation' }
BPReferenceToInstruction >> jumpAddressHighByte [
	self byteIndex: 6
]

{ #category : #'instance creation' }
BPReferenceToInstruction >> jumpAddressLowByte [
	self byteIndex: 8
]

{ #category : #'instance creation' }
BPReferenceToInstruction >> jumpAddressMiddleByte [
	self byteIndex: 7
]

{ #category : #'instance creation' }
BPReferenceToInstruction >> toAddressHighByte [
	self byteIndex: 3
]

{ #category : #'instance creation' }
BPReferenceToInstruction >> toAddressLowByte [
	self byteIndex: 5
]

{ #category : #'instance creation' }
BPReferenceToInstruction >> toAddressMiddleByte [
	self byteIndex: 4
]
