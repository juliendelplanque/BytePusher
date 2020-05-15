Class {
	#name : #BPInstructionReference,
	#superclass : #BPEntityToResolve,
	#instVars : [
		'instruction',
		'offset'
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
		offset: byteIndex;
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

{ #category : #'assembler-dispatch' }
BPInstructionReference >> forAssembler: aBPAssembler [ 
	^ self
]

{ #category : #'instance creation' }
BPInstructionReference >> fromAddressHighByte [
	self offset: 0
]

{ #category : #'instance creation' }
BPInstructionReference >> fromAddressLowByte [
	self offset: 2
]

{ #category : #'instance creation' }
BPInstructionReference >> fromAddressMiddleByte [
	self offset: 1
]

{ #category : #initialization }
BPInstructionReference >> initialize [
	super initialize.
	self offset: 0
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
	self offset: 6
]

{ #category : #'instance creation' }
BPInstructionReference >> jumpAddressLowByte [
	self offset: 8
]

{ #category : #'instance creation' }
BPInstructionReference >> jumpAddressMiddleByte [
	self offset: 7
]

{ #category : #accessing }
BPInstructionReference >> offset [
	^ offset
]

{ #category : #accessing }
BPInstructionReference >> offset: anObject [
	offset := anObject
]

{ #category : #'instance creation' }
BPInstructionReference >> toAddressHighByte [
	self offset: 3
]

{ #category : #'instance creation' }
BPInstructionReference >> toAddressLowByte [
	self offset: 5
]

{ #category : #'instance creation' }
BPInstructionReference >> toAddressMiddleByte [
	self offset: 4
]
