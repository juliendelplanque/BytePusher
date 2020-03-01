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
