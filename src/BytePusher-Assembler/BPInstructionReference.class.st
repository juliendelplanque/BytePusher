Class {
	#name : #BPInstructionReference,
	#superclass : #BPReferenceToResolve,
	#instVars : [
		'instruction',
		'byteIndex'
	],
	#category : #'BytePusher-Assembler-Model'
}

{ #category : #'instance creation' }
BPInstructionReference class >> instruction: instruction [
	^ self new
		instruction: instruction;
		yourself
]

{ #category : #'instance creation' }
BPInstructionReference class >> instruction: instruction byteIndex: byteIndex [
	^ self new
		instruction: instruction;
		byteIndex: byteIndex;
		yourself
]

{ #category : #visiting }
BPInstructionReference >> acceptVisitor: aBPAssemblerVisitor [
	<generated>
	^ aBPAssemblerVisitor visitBPReferenceToInstruction: self
]

{ #category : #accessing }
BPInstructionReference >> address [
	^ self instruction address
]

{ #category : #accessing }
BPInstructionReference >> byteIndex [
	^ byteIndex
]

{ #category : #accessing }
BPInstructionReference >> byteIndex: anObject [
	byteIndex := anObject
]

{ #category : #'assembler-dispatch' }
BPInstructionReference >> forAssembler: aBPAssembler [ 
	^ self
]

{ #category : #'instance creation' }
BPInstructionReference >> fromAddressHighByte [
	self byteIndex: 0
]

{ #category : #'instance creation' }
BPInstructionReference >> fromAddressLowByte [
	self byteIndex: 2
]

{ #category : #'instance creation' }
BPInstructionReference >> fromAddressMiddleByte [
	self byteIndex: 1
]

{ #category : #initialization }
BPInstructionReference >> initialize [
	super initialize.
	self byteIndex: 0
]

{ #category : #accessing }
BPInstructionReference >> instruction [
	^ instruction
]

{ #category : #accessing }
BPInstructionReference >> instruction: anObject [
	instruction := anObject
]

{ #category : #'instance creation' }
BPInstructionReference >> jumpAddressHighByte [
	self byteIndex: 6
]

{ #category : #'instance creation' }
BPInstructionReference >> jumpAddressLowByte [
	self byteIndex: 8
]

{ #category : #'instance creation' }
BPInstructionReference >> jumpAddressMiddleByte [
	self byteIndex: 7
]

{ #category : #'instance creation' }
BPInstructionReference >> toAddressHighByte [
	self byteIndex: 3
]

{ #category : #'instance creation' }
BPInstructionReference >> toAddressLowByte [
	self byteIndex: 5
]

{ #category : #'instance creation' }
BPInstructionReference >> toAddressMiddleByte [
	self byteIndex: 4
]
